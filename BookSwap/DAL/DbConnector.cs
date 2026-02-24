using Microsoft.Data.SqlClient;
using System.Data;
namespace BookSwap.DAL;

    public class DbConnector
    {
        private readonly IConfiguration configuration;
        private readonly string connectionString;

       public DbConnector(IConfiguration configuration)
        {
            this.configuration = configuration;
            connectionString = configuration.GetConnectionString("dbcon");
        }

    private SqlConnection GetConnection()
    {
        return new SqlConnection(connectionString);
    }

    public Dictionary<string, object> GetData(string SQLQuery, SqlParameter[]? parameters = null)
    {
        try
        {
            using (SqlConnection con = GetConnection())
            using (SqlCommand cmd = new SqlCommand(SQLQuery, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                if (parameters != null)
                {
                    cmd.Parameters.AddRange(parameters);
                }
                using (DataTable dt = new DataTable())
                {
                    da.Fill(dt);
                    return new Dictionary<string, object>()
                        {
                            {"Data",dt }
                        };
                }
            }
        }
        catch (Exception Ex)
        {
            return new Dictionary<string, object>() {
                    {"Error", Ex.ToString()}
                };
        }

    }

    public Dictionary<string, object> InsertUpdateDelete(string SQLQuery, SqlParameter[]? parameters = null)
    {
        try
        {
            using (SqlConnection con = GetConnection())
            using (SqlCommand cmd = new SqlCommand(SQLQuery, con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                if (parameters != null)
                {
                    cmd.Parameters.AddRange(parameters);
                }
                con.Open();
                int Rows = cmd.ExecuteNonQuery();
                con.Close();
                if (Rows > 0)
                {
                    return new Dictionary<string, object>()
                        {
                            {"Status" , "Success"}
                        };
                }
                else
                {
                    return new Dictionary<string, object>()
                        {
                            {"Status" , "NoData" }
                        };
                }
            }
        }
        catch (Exception Ex)
        {
            return new Dictionary<string, object>() {
                    {"Error", Ex.ToString()}
                };
        }

    }


}
