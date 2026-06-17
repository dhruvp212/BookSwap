using System;
using System.Configuration;
using System.Collections.Generic;
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
   void fillgrid()
    {
        mycon();
        cmd = new SqlCommand("select * from  Logintbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        GridView1.DataSource = ds;
        GridView1.DataBind();
        con.Close();
        con.Dispose();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        fillgrid();
       
    }
}
