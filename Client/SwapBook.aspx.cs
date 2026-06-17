using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_SwapBook : System.Web.UI.Page
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
            BindLibraryBooks();
        }
    }

    void BindLibraryBooks()
    {
        mycon();
        // Fetch only books uploaded by Libraries (UserType = 2) that are verified (IsVerified = 1)
        SqlCommand cmd = new SqlCommand(@"
            SELECT bt.*, ct.Category, lt.LibraryName, lt.LibraryId,
            (CASE WHEN EXISTS (SELECT 1 FROM BookBorrowTbl bb WHERE bb.BookId = bt.BookId AND bb.IsReturn = 0 AND bb.Status = 1) THEN 0 ELSE 1 END) as IsAvailable
            FROM BookTbl as bt 
            INNER JOIN CategoryTbl as ct ON bt.CategoryId = ct.CategoryId
            INNER JOIN LibraryTbl as lt ON bt.UserId = lt.UserId
            INNER JOIN UserTBL as ut ON ut.UserId = lt.UserId
            WHERE bt.IsVerified = 1 AND ut.UserType = 2 AND bt.IsActive = 1
            ORDER BY bt.EntryDate DESC", con);
            
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        rptBooklist.DataSource = dt;
        rptBooklist.DataBind();
        
        con.Close();
    }
}
