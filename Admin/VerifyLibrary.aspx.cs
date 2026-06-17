using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_VerifyLibrary : System.Web.UI.Page
{
    SqlConnection con;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        if (con.State == ConnectionState.Closed)
            con.Open();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Require Admin Login (Assuming standard protection or session check here if applicable)
        
        if (!IsPostBack)
        {
            BindPendingLibraries();
        }
    }

    void BindPendingLibraries()
    {
        mycon();
        SqlCommand cmd = new SqlCommand("SELECT * FROM LibraryTbl ORDER BY EntryDate DESC", con);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        gridLibraries.DataSource = dt;
        gridLibraries.DataBind();
        con.Close();
    }

    protected void gridLibraries_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Accept" || e.CommandName == "Reject")
        {
            int userId = Convert.ToInt32(e.CommandArgument);
            mycon();

            if (e.CommandName == "Accept")
            {
                // Approve Library across both tables
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        SqlCommand cmdUser = new SqlCommand("UPDATE UserTbl SET IsVerified=1, IsActive=1 WHERE UserId=@UserId", con, tran);
                        cmdUser.Parameters.AddWithValue("@UserId", userId);
                        cmdUser.ExecuteNonQuery();

                        SqlCommand cmdLib = new SqlCommand("UPDATE LibraryTbl SET IsVerified=1 WHERE UserId=@UserId", con, tran);
                        cmdLib.Parameters.AddWithValue("@UserId", userId);
                        cmdLib.ExecuteNonQuery();

                        tran.Commit();
                        lblMessage.Text = "Library registration approved successfully.";
                        lblMessage.CssClass = "d-block mb-3 fw-bold text-success";
                    }
                    catch (Exception)
                    {
                        tran.Rollback();
                        lblMessage.Text = "Error saving approval.";
                        lblMessage.CssClass = "d-block mb-3 fw-bold text-danger";
                    }
                }
            }
            else if (e.CommandName == "Reject")
            {
                // Reject Library across both tables (Delete them to allow re-registration)
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        SqlCommand cmdLib = new SqlCommand("DELETE FROM LibraryTbl WHERE UserId=@UserId", con, tran);
                        cmdLib.Parameters.AddWithValue("@UserId", userId);
                        cmdLib.ExecuteNonQuery();

                        SqlCommand cmdUser = new SqlCommand("DELETE FROM UserTbl WHERE UserId=@UserId", con, tran);
                        cmdUser.Parameters.AddWithValue("@UserId", userId);
                        cmdUser.ExecuteNonQuery();

                        tran.Commit();
                        lblMessage.Text = "Library registration rejected and removed.";
                        lblMessage.CssClass = "d-block mb-3 fw-bold text-warning";
                    }
                    catch (Exception)
                    {
                        tran.Rollback();
                        lblMessage.Text = "Error processing rejection.";
                        lblMessage.CssClass = "d-block mb-3 fw-bold text-danger";
                    }
                }
            }

            con.Close();
            BindPendingLibraries(); // Refresh Grid
        }
    }
}
