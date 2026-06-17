using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cilent : System.Web.UI.MasterPage
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
    //void FillCategory()
    //{
    //    mycon();
    //    cmd = new SqlCommand("Select * from CategoryTbl", con);
    //    da = new SqlDataAdapter(cmd);
    //    ds = new DataSet();
    //    da.Fill(ds);
    //    rptCategory.DataSource = ds;
    //    rptCategory.DataBind();
    //    con.Close();
    //    con.Dispose();
    //    ds.Dispose();
    //    da.Dispose();
    //    cmd.Dispose();
    //}
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //FillCategory();
        }
        if (Session["User"] != null || Session["Student"] != null)
        {
            
            BeforeLoginPanel.Visible = false;
            AfterLoginPanel.Visible = true;
            mycon();
            cmd = new SqlCommand("Select * from UserTbl Where UserID=@uid ", con);
            cmd.Parameters.AddWithValue("@uid", Session["Student"] != null ? Session["Student"].ToString() : Session["User"].ToString());
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                lblUser.InnerHtml = ds.Tables[0].Rows[0]["Name"].ToString();
            }
        }
    }
    protected void btnLogout_Click1(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();

        Response.Redirect("login.aspx");
    }
}
