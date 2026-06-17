using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class bookCategoryClient : System.Web.UI.Page
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
    void FillCategoryRpt()
    {
        mycon();
        cmd = new SqlCommand("Select * from CategoryTbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        rptbookcategory.DataSource = ds;
        rptbookcategory.DataBind();
        da.Dispose();
        ds.Dispose();
        con.Close();
        con.Dispose();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        FillCategoryRpt();
    }
}
