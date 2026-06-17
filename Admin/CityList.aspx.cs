using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_CityList : System.Web.UI.Page
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

    void FillGrid()
    {
        mycon();
        cmd = new SqlCommand("Select * From CityTbl", con);
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
    protected void Page_Load(object sender, EventArgs e)
    {
        FillGrid();
    }
    protected void gridList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Del")
        {
            string id = e.CommandArgument.ToString();
            mycon();
            cmd = new SqlCommand("Delete From CityTbl Where CityId=@cid", con);
            cmd.Parameters.AddWithValue("@cid", id);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();
            con.Dispose();
            Response.Write("<script>alert(' Your Data is Successfully Deleted.')</script>");
            FillGrid();
        }
    }
}