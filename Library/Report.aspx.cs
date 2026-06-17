using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Library_Report : System.Web.UI.Page
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
            LoadStats();
            LoadActivity();
        }
    }

    void LoadStats()
    {
        mycon();
        SqlCommand cmdLib = new SqlCommand("SELECT LibraryId FROM LibraryTbl WHERE UserId=@UserId", con);
        cmdLib.Parameters.AddWithValue("@UserId", Session["User"]);
        int libId = Convert.ToInt32(cmdLib.ExecuteScalar());

        // Total Books
        SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM BookTbl WHERE UserId=@UserId", con);
        cmd1.Parameters.AddWithValue("@UserId", Session["User"]);
        litTotalBooks.Text = cmd1.ExecuteScalar().ToString();

        // Active Loans
        SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM BookBorrowTbl WHERE LibraryId=@LibId AND Status=1 AND IsReturn=0", con);
        cmd2.Parameters.AddWithValue("@LibId", libId);
        litActiveLoans.Text = cmd2.ExecuteScalar().ToString();

        // Total Returns
        SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM BookBorrowTbl WHERE LibraryId=@LibId AND IsReturn=1", con);
        cmd3.Parameters.AddWithValue("@LibId", libId);
        litTotalReturns.Text = cmd3.ExecuteScalar().ToString();

        // Total Fines
        SqlCommand cmd4 = new SqlCommand("SELECT ISNULL(SUM(TotalFine), 0) FROM BookBorrowTbl WHERE LibraryId=@LibId", con);
        cmd4.Parameters.AddWithValue("@LibId", libId);
        litTotalFines.Text = Convert.ToDecimal(cmd4.ExecuteScalar()).ToString("C");

        con.Close();
    }

    void LoadActivity()
    {
        mycon();
        SqlCommand cmdLib = new SqlCommand("SELECT LibraryId FROM LibraryTbl WHERE UserId=@UserId", con);
        cmdLib.Parameters.AddWithValue("@UserId", Session["User"]);
        int libId = Convert.ToInt32(cmdLib.ExecuteScalar());

        SqlCommand cmd = new SqlCommand(@"
            SELECT TOP 10 bb.*, b.BookTitle, u.Name as StudentName
            FROM BookBorrowTbl bb
            INNER JOIN BookTbl b ON bb.BookId = b.BookId
            INNER JOIN UserTBL u ON bb.StudentId = u.UserId
            WHERE bb.LibraryId = @LibId
            ORDER BY bb.EntryDate DESC", con);
        
        cmd.Parameters.AddWithValue("@LibId", libId);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        gridActivity.DataSource = dt;
        gridActivity.DataBind();
        con.Close();
    }

    protected string GetStatusClass(object status, object isReturn)
    {
        int s = Convert.ToInt32(status);
        bool r = Convert.ToBoolean(isReturn);

        if (r) return "badge bg-success";
        if (s == 1) return "badge bg-info";
        return "badge bg-warning text-dark";
    }

    protected string GetStatusText(object status, object isReturn)
    {
        int s = Convert.ToInt32(status);
        bool r = Convert.ToBoolean(isReturn);

        if (r) return "Returned";
        if (s == 1) return "Borrowed";
        return "Pending Approval";
    }
}
