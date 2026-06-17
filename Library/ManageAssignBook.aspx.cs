using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Library_ManageAssignBook : System.Web.UI.Page
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
        if (Session["User"] == null)
        {
            Response.Redirect("../Client/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            BindRequests();
        }
    }

    void BindRequests()
    {
        mycon();
        // Fetch library ID based on UserId
        SqlCommand cmdLib = new SqlCommand("SELECT LibraryId FROM LibraryTbl WHERE UserId=@UserId", con);
        cmdLib.Parameters.AddWithValue("@UserId", Session["User"]);
        object libIdResult = cmdLib.ExecuteScalar();

        if (libIdResult != null)
        {
            int libId = Convert.ToInt32(libIdResult);

            SqlCommand cmd = new SqlCommand(@"
                SELECT bb.*, b.BookTitle, b.Auther, b.Photo1, u.Name as StudentName
                FROM BookBorrowTbl bb
                INNER JOIN BookTbl b ON bb.BookId = b.BookId
                INNER JOIN UserTBL u ON bb.StudentId = u.UserId
                WHERE bb.LibraryId = @LibId AND bb.Status = 0
                ORDER BY bb.EntryDate DESC", con);
            
            cmd.Parameters.AddWithValue("@LibId", libId);
            
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            
            gridAssign.DataSource = dt;
            gridAssign.DataBind();
        }
        con.Close();
    }

    protected void gridAssign_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ApproveRequest" || e.CommandName == "RejectRequest")
        {
            int borrowId = Convert.ToInt32(e.CommandArgument);
            mycon();

            if (e.CommandName == "ApproveRequest")
            {
                // Status = 1 means Approved/Assigned
                SqlCommand cmd = new SqlCommand("UPDATE BookBorrowTbl SET Status = 1 WHERE BookBorrowId = @ID", con);
                cmd.Parameters.AddWithValue("@ID", borrowId);
                cmd.ExecuteNonQuery();
                lblMessage.Text = "Request approved and book assigned successfully!";
                lblMessage.CssClass = "d-block mb-3 fw-bold text-success";
            }
            else if (e.CommandName == "RejectRequest")
            {
                // You could delete or set a status to 2 for Rejected.
                // For now, let's just delete to keep the pending list clean.
                SqlCommand cmd = new SqlCommand("DELETE FROM BookBorrowTbl WHERE BookBorrowId = @ID", con);
                cmd.Parameters.AddWithValue("@ID", borrowId);
                cmd.ExecuteNonQuery();
                lblMessage.Text = "Borrow request has been rejected.";
                lblMessage.CssClass = "d-block mb-3 fw-bold text-danger";
            }

            con.Close();
            BindRequests();
        }
    }
}
