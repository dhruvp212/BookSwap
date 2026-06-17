using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Library_ReturnBook : System.Web.UI.Page
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
            BindBorrowedBooks();
        }
    }

    void BindBorrowedBooks()
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
                SELECT bb.*, b.BookTitle, b.Photo1, u.Name as StudentName
                FROM BookBorrowTbl bb
                INNER JOIN BookTbl b ON bb.BookId = b.BookId
                INNER JOIN UserTBL u ON bb.StudentId = u.UserId
                WHERE bb.LibraryId = @LibId AND bb.Status = 1 
                AND (bb.IsReturn = 0 OR (bb.IsReturn = 1 AND bb.IsFinePaid = 0))
                ORDER BY bb.IsReturnRequested DESC, bb.ReturnDate ASC", con);
            
            cmd.Parameters.AddWithValue("@LibId", libId);
            
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            
            gridReturns.DataSource = dt;
            gridReturns.DataBind();
        }
        con.Close();
    }

    protected void gridReturns_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ProcessReturn")
        {
            int borrowId = Convert.ToInt32(e.CommandArgument);
            mycon();

            SqlCommand cmdGet = new SqlCommand("SELECT ReturnDate FROM BookBorrowTbl WHERE BookBorrowId = @ID", con);
            cmdGet.Parameters.AddWithValue("@ID", borrowId);
            DateTime expectedReturn = Convert.ToDateTime(cmdGet.ExecuteScalar());

            decimal fine = 0;
            int isFineApplicable = 0;

            if (DateTime.Now.Date > expectedReturn.Date)
            {
                int overdueDays = (DateTime.Now.Date - expectedReturn.Date).Days;
                fine = overdueDays * 10;
                isFineApplicable = 1;
            }

            SqlCommand cmdUpdate = new SqlCommand(@"
                UPDATE BookBorrowTbl 
                SET IsReturn = 1, 
                    TotalFine = @Fine, 
                    IsFineAplicable = @IsFine,
                    IsFinePaid = @IsPaid,
                    IsReturnRequested = 1
                WHERE BookBorrowId = @ID", con);
            
            cmdUpdate.Parameters.AddWithValue("@Fine", fine);
            cmdUpdate.Parameters.AddWithValue("@IsFine", isFineApplicable);
            cmdUpdate.Parameters.AddWithValue("@IsPaid", fine > 0 ? 0 : 1);
            cmdUpdate.Parameters.AddWithValue("@ID", borrowId);
            
            cmdUpdate.ExecuteNonQuery();
            con.Close();

            lblMessage.Text = (fine > 0) ? "Return processed. Overdue fine: " + fine.ToString("C") : "Return processed successfully.";
            lblMessage.CssClass = "d-block mb-3 fw-bold " + (fine > 0 ? "text-warning" : "text-success");
            
            BindBorrowedBooks();
        }
    }

    protected bool ToBool(object value)
    {
        if (value == null || value == DBNull.Value) return false;
        return Convert.ToBoolean(value);
    }

    protected decimal ToDecimal(object value)
    {
        if (value == null || value == DBNull.Value) return 0;
        return Convert.ToDecimal(value);
    }
}
