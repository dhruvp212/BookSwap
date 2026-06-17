using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_Student_AddbookList : System.Web.UI.Page
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

        if (Session["User"]!=null)
        {
            mycon();
        cmd = new SqlCommand("Select * from BookTbl where UserId=@uid", con);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
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
        else
        {
            Response.Redirect("/Client/Home.aspx");
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        FillGrid();
    }
    protected void gridList_RowCommand1(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Del")
        {
            string id = e.CommandArgument.ToString();
            mycon();
            cmd = new SqlCommand("Delete From BookTbl Where BookId=@cid", con);
            cmd.Parameters.AddWithValue("@cid", id);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();
            con.Dispose();
            Response.Write("<script>alert('Book is successfully Delete.')</script>");
            FillGrid();

        }
    }
}