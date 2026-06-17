using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_City : System.Web.UI.Page
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

        if (!IsPostBack)
        {
            if (Request.QueryString["Edit"] != null)
            {
                string id = Request.QueryString["Edit"].ToString();
                mycon();
                cmd = new SqlCommand("Select * From CityTbl Where CityId=@cid", con);
                cmd.Parameters.AddWithValue("@cid", id);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtCity.Text = ds.Tables[0].Rows[0]["City"].ToString();
                    dropstatus.Text = ds.Tables[0].Rows[0]["Status"].ToString() == "True" ? "Active" : "InActive";
                }
            }


        }
    }
    protected void LinkSave_Click(object sender, EventArgs e)
    {
  
        mycon();
        cmd = new SqlCommand("Select * From CityTbl Where City=@ct and CityId !=@cid ", con);
        cmd.Parameters.AddWithValue("@ct", txtCity.Text);
        if (Request.QueryString["Edit"] != null)
        {
            cmd.Parameters.AddWithValue("@cid", Request.QueryString["Edit"].ToString());
        }
        else
        {
            cmd.Parameters.AddWithValue("@cid", 0);
        }
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count > 0)
        {
            Response.Write("<script> alert('Given  is Allready Exist.')</script>");

        }
        else
        {
            if (Request.QueryString["Edit"] != null)
            {
                cmd = new SqlCommand("Update CityTbl set City=@ct,Status=@sts Where CityId=@cid", con);
                cmd.Parameters.AddWithValue("@ct", txtCity.Text);
            }
            else
            {
                cmd = new SqlCommand("Insert into CityTbl values(@ct, @sts) ", con);
                cmd.Parameters.AddWithValue("@ct", txtCity.Text);
                da = new SqlDataAdapter(cmd);
                cmd.Parameters.AddWithValue("@sts", dropstatus.SelectedItem.Text == "Active" ? "1" : "0");
                cmd.ExecuteNonQuery();
                cmd.Dispose();
                Response.Write("<script> alert('City is Successfully Inserted.')</script>");
            }

            txtCity.Text = "";
            dropstatus.SelectedIndex = 0;

            con.Close();
        }
    }
}
