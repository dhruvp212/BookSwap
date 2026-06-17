using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Client_Payment : System.Web.UI.Page
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

        if (Request.QueryString["id"] == null || Request.QueryString["amt"] == null)
        {
            Response.Redirect("MyLibraryBorrows.aspx");
            return;
        }

        if (!IsPostBack)
        {
            lblAmount.Text = string.Format("{0:C}", Convert.ToDecimal(Request.QueryString["amt"]));
        }
    }

    protected void btnPay_Click(object sender, EventArgs e)
    {
        string borrowId = Request.QueryString["id"];

        mycon();
        SqlCommand cmd = new SqlCommand("UPDATE BookBorrowTbl SET IsFinePaid = 1 WHERE BookBorrowId = @BId", con);
        cmd.Parameters.AddWithValue("@BId", borrowId);
        
        int row = cmd.ExecuteNonQuery();
        con.Close();

        if (row > 0)
        {
            Response.Write("<script>alert('Payment Successful! Fine marked as Paid.');window.location='MyLibraryBorrows.aspx';</script>");
        }
    }
}
