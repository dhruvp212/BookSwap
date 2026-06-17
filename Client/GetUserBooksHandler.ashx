<%@ WebHandler Language="C#" Class="GetUserBooksHandler" %>

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.SessionState;

public class GetUserBooksHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType  = "application/json";
        context.Response.CacheControl = "no-cache";

        try
        {
            if (context.Session == null || context.Session["User"] == null)
            {
                context.Response.Write("[]");
                return;
            }

            string userId = context.Session["User"].ToString();
            string connStr = ConfigurationManager
                .ConnectionStrings["BookswapConnectionString1"].ConnectionString;

            var sb = new StringBuilder("[");
            bool first = true;

            using (var con = new SqlConnection(connStr))
            {
                con.Open();
                using (var cmd = new SqlCommand(
                    "SELECT s.SwapRequestId, " +
                    "ISNULL(e.Education,'Book') AS EducationName, " +
                    "ISNULL(el.EducationLevel,'') AS LevelName, " +
                    "s.Semester, " +
                    "ISNULL(s.SecondTotalAmount,0) AS SwapPrice, " +
                    "ISNULL(s.PhotoFront,'') AS PhotoFront, " +
                    "ISNULL(s.Discription,'') AS Description " +
                    "FROM SwapRequestTbl s " +
                    "LEFT JOIN EducationTbl e ON e.EducationId = s.EducationId " +
                    "LEFT JOIN EducationLvelTbl el ON el.EducationLevelId = s.EducationLevelId " +
                    "WHERE s.Userid = @uid AND s.SwapStatus = 1 " +
                    "ORDER BY s.EntryDate DESC", con))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);

                    using (var rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            string title = rdr["EducationName"].ToString();
                            string level = rdr["LevelName"].ToString();
                            if (!string.IsNullOrEmpty(level)) title += " - " + level;
                            if (rdr["Semester"] != DBNull.Value)
                                title += " (Sem " + rdr["Semester"].ToString() + ")";

                            decimal swapPrice = Convert.ToDecimal(rdr["SwapPrice"]);

                            if (!first) sb.Append(",");
                            first = false;

                            sb.Append("{");
                            sb.AppendFormat("\"id\":{0},",          rdr["SwapRequestId"]);
                            sb.AppendFormat("\"title\":{0},",       JsonStr(title));
                            sb.AppendFormat("\"swapPrice\":{0},",   swapPrice.ToString("F2",
                                System.Globalization.CultureInfo.InvariantCulture));

                            // Resolve "~/icon/..." → "/icon/..." so browser img src works
                            string photo = rdr["PhotoFront"].ToString();
                            if (photo.StartsWith("~/")) photo = "/" + photo.Substring(2);

                            sb.AppendFormat("\"photoFront\":{0},",  JsonStr(photo));
                            sb.AppendFormat("\"description\":{0}",  JsonStr(rdr["Description"].ToString()));
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
