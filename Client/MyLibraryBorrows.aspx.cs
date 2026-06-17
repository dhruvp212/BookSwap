using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_MyLibraryBorrows : System.Web.UI.Page
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
            Response.Redirect("login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            BindMyBorrows();
        }
    }

    protected void gridMyBorrows_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "RequestReturn")
        {
            int borrowId = Convert.ToInt32(e.CommandArgument);
            mycon();
            SqlCommand cmd = new SqlCommand("UPDATE BookBorrowTbl SET IsReturnRequested = 1 WHERE BookBorrowId = @ID", con);
            cmd.Parameters.AddWithValue("@ID", borrowId);
            cmd.ExecuteNonQuery();
            con.Close();
            BindMyBorrows();
        }
    }

    void BindMyBorrows()
    {
        mycon();
        SqlCommand cmd = new SqlCommand(@"
            SELECT bb.*, b.BookTitle, b.Auther, b.Photo1, lt.LibraryName
            FROM BookBorrowTbl bb
            INNER JOIN BookTbl b ON bb.BookId = b.BookId
            INNER JOIN LibraryTbl lt ON bb.LibraryId = lt.LibraryId
            WHERE bb.StudentId = @StudentId
            ORDER BY bb.EntryDate DESC", con);
        
        cmd.Parameters.AddWithValue("@StudentId", Session["User"]);
        
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        gridMyBorrows.DataSource = dt;
        gridMyBorrows.DataBind();
        con.Close();
    }

    protected string GetStatusClass(object status, object isReturn)
    {
        int s = Convert.ToInt32(status);
        bool r = Convert.ToBoolean(isReturn);

        if (r) return "badge bg-success";
        if (s == 1) return "badge bg-info shadow-sm";
        return "badge bg-warning text-dark border shadow-sm";
    }

    protected string GetStatusText(object status, object isReturn)
    {
        int s = Convert.ToInt32(status);
        bool r = Convert.ToBoolean(isReturn);

        if (r) return "Already Returned";
        if (s == 1) return "Active Borrow/With Me";
        return "Waiting for Library Approval";
    }

    protected string GetDaysLeftText(object status, object isReturn, object returnDate)
    {
        int s = Convert.ToInt32(status != DBNull.Value ? status : 0);
        bool r = Convert.ToBoolean(isReturn != DBNull.Value ? isReturn : false);

        if (r || s == 0) return "---";

        DateTime retDate = Convert.ToDateTime(returnDate);
        if (DateTime.Now > retDate)
        {
            return "<span class='text-danger fw-bold'>Overdue by " + (DateTime.Now - retDate).Days + " Days</span>";
        }
        else
        {
            int left = (retDate - DateTime.Now).Days;
            return "<span>" + left + " Days left</span>";
        }
    }

    protected bool IsFineUnpaid(object isFineApplicable, object isFinePaid)
    {
        bool applicable = (isFineApplicable != DBNull.Value) ? Convert.ToBoolean(isFineApplicable) : false;
        bool paid = (isFinePaid != DBNull.Value) ? Convert.ToBoolean(isFinePaid) : false;
        return applicable && !paid;
    }

    protected bool IsFinePaidConfirmed(object isFinePaid)
    {
        return (isFinePaid != DBNull.Value) ? Convert.ToBoolean(isFinePaid) : false;
    }

    protected bool ToBool(object value)
    {
        if (value == null || value == DBNull.Value) return false;
        return Convert.ToBoolean(value);
    }
}
