using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class contactpage : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;
    DataSet ds;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void lnkSend_Click(object sender, EventArgs e)
    {
        mycon();
        cmd = new SqlCommand("Insert Into ContactTbl values(@sb,@Fn,@em,@mb,@msg,GETDATE())", con);
        cmd.Parameters.AddWithValue("@sb", dropSubject.Text);
        cmd.Parameters.AddWithValue("@Fn", txtFullName.Text);
        cmd.Parameters.AddWithValue("@em", txtEmail.Text);
        cmd.Parameters.AddWithValue("@mb", txtMobile.Text);
        cmd.Parameters.AddWithValue("@msg", txtMessage.Text);
        cmd.ExecuteNonQuery();
        con.Close();
        con.Dispose();
        cmd.Dispose();
        txtFullName.Text = "";
        txtEmail.Text = "";
        txtMobile.Text = "";
        txtMessage.Text = "";
        dropSubject.SelectedIndex = 0;
        Response.Write("<script>alert('Your Contact Inquiry Send Successfully to Our Admin. Our Admin Can Contact As Soon As Possible.')</script>");

    }
}