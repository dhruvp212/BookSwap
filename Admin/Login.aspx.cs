using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Login : System.Web.UI.Page
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
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        
    }
    protected void lnklogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text;
        string password = txtpassword.Text;

        if (username == "admin" && password == "12345")
        {
            Response.Redirect("Dashboard.aspx");
        }
        else
        {
            lblMsg.Text = "Invalid Username or Password";
            lblMsg.Style.Add("color", "red");
        }
        }
    }


    

        

       
   


  

