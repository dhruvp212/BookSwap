<%@ WebHandler Language="C#" Class="SendChatHandler" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;

/// <summary>
/// Saves a chat message and returns the saved message as JSON.
/// GET: ?swapId=8&msg=Hello
/// </summary>
public class SendChatHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext ctx)
    {
        ctx.Response.ContentType  = "application/json";
        ctx.Response.CacheControl = "no-cache";

        if (ctx.Session == null || ctx.Session["User"] == null)
        {
            ctx.Response.Write("{\"ok\":false,\"error\":\"Not logged in\"}");
            return;
        }

        int swapId;
        string msg = (ctx.Request.QueryString["msg"] ?? "").Trim();
        if (!int.TryParse(ctx.Request.QueryString["swapId"], out swapId) || swapId <= 0 || string.IsNullOrEmpty(msg))
        {
            ctx.Response.Write("{\"ok\":false,\"error\":\"Invalid parameters\"}");
            return;
        }

        int myId = Convert.ToInt32(ctx.Session["User"].ToString());
        string conn = ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString;

        try
        {
            using (var con = new SqlConnection(conn))
            {
                con.Open();

                // Insert message
                DateTime sentAt = DateTime.Now;
                using (var cmd = new SqlCommand(
                    "INSERT INTO SwapChatTbl (SwapRequestId, SenderId, Message, SentAt) " +
                    "VALUES (@sid, @uid, @msg, @ts)", con))
                {
                    cmd.Parameters.AddWithValue("@sid", swapId);
                    cmd.Parameters.AddWithValue("@uid", myId);
                    cmd.Parameters.AddWithValue("@msg", msg);
                    cmd.Parameters.AddWithValue("@ts",  sentAt);
                    cmd.ExecuteNonQuery();
                }

                // Get sender name
                string senderName = "Me";
                using (var cmd2 = new SqlCommand("SELECT ISNULL(Name,'Me') FROM UserTbl WHERE UserID=@uid", con))
                {
                    cmd2.Parameters.AddWithValue("@uid", myId);
                    var obj = cmd2.ExecuteScalar();
                    if (obj != null) senderName = obj.ToString();
                }

                string sentAtStr = sentAt.ToString("yyyy-MM-ddTHH:mm:ss.fff",
                    System.Globalization.CultureInfo.InvariantCulture);
                long sentAtMs = (long)(sentAt.ToUniversalTime() - new DateTime(1970,1,1,0,0,0,DateTimeKind.Utc)).TotalMilliseconds;

                ctx.Response.Write(
                    "{\"ok\":true,\"savedMsg\":{" +
                    "\"senderId\":"   + myId + "," +
                    "\"senderName\":" + J(senderName) + "," +
                    "\"message\":"    + J(msg) + "," +
                    "\"sentAt\":"     + J(sentAtStr) + "," +
                    "\"sentAtMs\":"   + sentAtMs + "," +
                    "\"isMine\":true}}");
            }
        }
        catch (Exception ex)
        {
            ctx.Response.Write("{\"ok\":false,\"error\":" + J(ex.Message) + "}");
        }
    }

    static string J(string s)
    {
        if (s == null) return "null";
        return "\"" + s.Replace("\\","\\\\").Replace("\"","\\\"")
                       .Replace("\r","\\r").Replace("\n","\\n")
                       .Replace("\t","\\t") + "\"";
    }

    public bool IsReusable { get { return false; } }
}
