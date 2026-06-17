using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_User : System.Web.UI.Page
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
        mycon();
        cmd = new SqlCommand("Select * from UserTBL", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);


        gridList.DataSource = ds;
        gridList.DataBind();
        da.Dispose();
        ds.Dispose();
        cmd.Dispose();
        con.Close();
        con.Dispose();

    }

}