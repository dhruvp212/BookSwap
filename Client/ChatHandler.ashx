<%@ WebHandler Language="C#" Class="ChatHandler" %>

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.SessionState;

public class ChatHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType  = "application/json";
        context.Response.CacheControl = "no-cache";

        try
        {
            int swapId;
            if (!int.TryParse(context.Request.QueryString["swapId"], out swapId))
            {
                context.Response.Write("[]");
                return;
            }

            // SQL Server datetime minimum is 1753-01-01
            DateTime since = new DateTime(1753, 1, 1);
            string sinceStr = context.Request.QueryString["since"];
            if (!string.IsNullOrEmpty(sinceStr))
            {
                DateTime parsed;
                if (DateTime.TryParseExact(sinceStr,
                        new string[] {
                            "yyyy-MM-ddTHH:mm:ss.fff",
                            "yyyy-MM-ddTHH:mm:ss",
                            "yyyy-MM-ddTHH:mm:ss.fffffff"
                        },
                        System.Globalization.CultureInfo.InvariantCulture,
                        System.Globalization.DateTimeStyles.None,
                        out parsed)
                    || DateTime.TryParse(sinceStr, out parsed))
                {
                    if (parsed > since) since = parsed;
                }
            }

            int myUserId = 0;
            if (context.Session != null && context.Session["User"] != null)
                int.TryParse(context.Session["User"].ToString(), out myUserId);

            string connStr = ConfigurationManager
                .ConnectionStrings["BookswapConnectionString1"].ConnectionString;

            var sb = new StringBuilder("[");
            bool first = true;

            using (var con = new SqlConnection(connStr))
            {
                con.Open();
                // ── E2E: determine the OTHER user in this conversation ──────────
            // SwaprequestList passes ?otherId=<interestedUserId>
            // BookExchange.aspx doesn't pass it → look up the book owner
            int otherUserId = 0;
            int.TryParse(context.Request.QueryString["otherId"], out otherUserId);

            if (otherUserId == 0)
            {
                // Auto-detect: the book owner is the other party
                using (var ownerCmd = new SqlCommand(
                    "SELECT Userid FROM SwapRequestTbl WHERE SwapRequestId=@sid", con))
                {
                    ownerCmd.Parameters.AddWithValue("@sid", swapId);
                    var obj = ownerCmd.ExecuteScalar();
                    if (obj != null && obj != DBNull.Value)
                        otherUserId = Convert.ToInt32(obj);
                }
            }

            using (var cmd = new SqlCommand(
                "SELECT m.MessageId, m.SenderId, m.Message, m.SentAt, " +
                "ISNULL(u.Name,'User') AS SenderName " +
                "FROM SwapChatTbl m " +
                "LEFT JOIN UserTbl u ON u.UserID = m.SenderId " +
                "WHERE m.SwapRequestId = @sid AND m.SentAt > @since " +
                (otherUserId > 0
                    ? "AND (m.SenderId = @uid OR m.SenderId = @otherId) "
                    : "") +
                "ORDER BY m.SentAt ASC", con))
            {
                cmd.Parameters.AddWithValue("@sid",   swapId);
                cmd.Parameters.AddWithValue("@since", since);
                cmd.Parameters.AddWithValue("@uid",   myUserId);
                if (otherUserId > 0)
                    cmd.Parameters.AddWithValue("@otherId", otherUserId);

                    using (var rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            bool   isMine  = (rdr["SenderId"] != DBNull.Value &&
                                               Convert.ToInt32(rdr["SenderId"]) == myUserId);
                            string msgText = rdr["Message"].ToString();

                            // ALWAYS use InvariantCulture so separator is ':' not '.' (culture-safe)
                            string sentAt = ((DateTime)rdr["SentAt"]).ToString(
                                "yyyy-MM-ddTHH:mm:ss.fff",
                                System.Globalization.CultureInfo.InvariantCulture);

                            // Also send epoch ms — JS uses this for comparison (no parsing needed)
                            long sentAtMs = (long)(((DateTime)rdr["SentAt"]) - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;

                            if (!first) sb.Append(",");
                            first = false;

                            sb.Append("{");
                            sb.AppendFormat("\"messageId\":{0},",  rdr["MessageId"]);
                            sb.AppendFormat("\"senderId\":{0},",
                                rdr["SenderId"] == DBNull.Value ? "null" : rdr["SenderId"].ToString());
                            sb.AppendFormat("\"senderName\":{0},", JsonStr(rdr["SenderName"].ToString()));
                            sb.AppendFormat("\"message\":{0},",    JsonStr(msgText));
                            sb.AppendFormat("\"sentAt\":{0},",     JsonStr(sentAt));
                            sb.AppendFormat("\"sentAtMs\":{0},",   sentAtMs);
                            sb.AppendFormat("\"isMine\":{0}",      isMine ? "true" : "false");

                            // ── For BOOK_OFFER messages: include deal status ──────────────
                            if (msgText.StartsWith("[BOOK_OFFER:") && msgText.EndsWith("]"))
                            {
                                string dealStatus = "pending";
                                try
                                {
                                    string inner = msgText.Substring(12, msgText.Length - 13);
                                    string[] parts = inner.Split(new string[] { "|||" }, StringSplitOptions.None);
                                    int offeredSwapId;
                                    if (parts.Length > 0 && int.TryParse(parts[0], out offeredSwapId))
                                    {
                                        // NOTE: con is still open here (reader not closed yet — use a new connection)
                                        using (var con2 = new SqlConnection(connStr))
                                        {
                                            con2.Open();
                                            using (var dCmd = new SqlCommand(
                                                "SELECT IsLocked, OwnerAccepted FROM SwapDealTbl " +
                                                "WHERE SwapRequestId=@sid AND OfferedSwapId=@osid", con2))
                                            {
                                                dCmd.Parameters.AddWithValue("@sid",  swapId);
                                                dCmd.Parameters.AddWithValue("@osid", offeredSwapId);
                                                using (var dr = dCmd.ExecuteReader())
                                                {
                                                    if (dr.Read())
                                                    {
                                                        if (Convert.ToBoolean(dr["IsLocked"]))      dealStatus = "locked";
                                                        else if (Convert.ToBoolean(dr["OwnerAccepted"])) dealStatus = "owner_accepted";
                                                        else dealStatus = "requester_accepted";
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                catch { /* SwapDealTbl may not exist yet — default to "pending" */ }
                                sb.AppendFormat(",\"dealStatus\":{0}", JsonStr(dealStatus));
                            }

                            sb.Append("}");
                        }
                    }
                }
            }

            sb.Append("]");
            context.Response.Write(sb.ToString());
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 500;
            context.Response.Write("{\"error\":" + JsonStr(ex.Message) +
                                   ",\"type\":"  + JsonStr(ex.GetType().Name) + "}");
        }
    }

    private static string JsonStr(string s)
    {
        if (s == null) return "null";
        return "\"" + s.Replace("\\", "\\\\")
                       .Replace("\"", "\\\"")
                       .Replace("\r", "\\r")
                       .Replace("\n", "\\n")
                       .Replace("\t", "\\t") + "\"";
    }

    public bool IsReusable { get { return false; } }
}
