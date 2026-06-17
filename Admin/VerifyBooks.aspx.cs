using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_VerifyBooks : System.Web.UI.Page
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
        if (!IsPostBack)
        {
            BindBooks();
        }
    }

    void BindBooks()
    {
        mycon();
        SqlCommand cmd;
        if (Request.QueryString["uid"] != null)
        {
            cmd = new SqlCommand("SELECT * FROM BookTbl WHERE UserId=@uid ORDER BY EntryDate DESC", con);
            cmd.Parameters.AddWithValue("@uid", Request.QueryString["uid"]);
            lblTitle.Text = "Manage User Books";
        }
        else
        {
            cmd = new SqlCommand("SELECT * FROM BookTbl WHERE IsVerified = 0 ORDER BY EntryDate DESC", con);
        }
        
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        gridBooks.DataSource = dt;
        gridBooks.DataBind();
        con.Close();
    }

    protected void gridBooks_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AcceptBook" || e.CommandName == "RejectBook")
        {
            int bookId = Convert.ToInt32(e.CommandArgument);
            mycon();

            try
            {
                if (e.CommandName == "AcceptBook")
                {
                    SqlCommand cmd = new SqlCommand("UPDATE BookTbl SET IsVerified=1, IsActive=1 WHERE BookId=@BookId", con);
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    cmd.ExecuteNonQuery();

                    lblMessage.Text = "Book verified and active in the marketplace.";
                    lblMessage.CssClass = "d-block mb-3 fw-bold text-success";
                }
                else if (e.CommandName == "RejectBook")
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM BookTbl WHERE BookId=@BookId", con);
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    cmd.ExecuteNonQuery();

                    lblMessage.Text = "Book rejected and deleted.";
                    lblMessage.CssClass = "d-block mb-3 fw-bold text-warning";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
                lblMessage.CssClass = "d-block mb-3 fw-bold text-danger";
            }
            finally
            {
                con.Close();
                BindBooks(); // Refresh list
            }
        }
    }
}
