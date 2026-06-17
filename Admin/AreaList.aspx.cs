using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_AreaList : System.Web.UI.Page
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
        cmd = new SqlCommand("select * from AreaTbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        gridList.DataSource = ds;
        gridList.DataBind();
        con.Close();

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        fillgrid();
    }
    protected void gridList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Del")
        {
            string id = e.CommandArgument.ToString();
            mycon();
            cmd = new SqlCommand("Delete From AreaTbl Where AreaId=@aid", con);
            cmd.Parameters.AddWithValue("@aid", id);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();
            con.Dispose();
            Response.Write("<script>alert('Area is successfully Deleted')</script>");
            fillgrid();

        }
    }
}