using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Area : System.Web.UI.Page
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


    void FillCityDropDown()
    {
        mycon();
        cmd = new SqlCommand("Select * from CityTbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        dropArea.DataSource = ds;
        dropArea.DataValueField = "City";
        dropArea.DataTextField = "CityId";

        dropArea.DataBind();
        da.Dispose();
        ds.Dispose();
        con.Close();
        con.Dispose();
        dropArea.Items.Insert(0, "--- Select CityId ---");
        dropArea.Items[0].Value = "";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillCityDropDown();
        }
        if (!IsPostBack)
        {
            if (Request.QueryString["Edit"] != null)
            {
                string id = Request.QueryString["Edit"].ToString();
                mycon();

                cmd = new SqlCommand("Select * from AreaTbl Where AreaId=@aid", con);
                cmd.Parameters.AddWithValue("@aid", id);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();

                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    // dropCategory.Text = ds.Tables[0].Rows[0]["Category"].ToString();
                    txtArea.Text = ds.Tables[0].Rows[0]["Area"].ToString();
                    //  fileIcon.ImageUrl = ds.Tables[0].Rows[0]["Icon"].ToString();
                    dropstatus.Text = ds.Tables[0].Rows[0]["Status"].ToString() == "True" ? "1" : "0";

                }
            }
        }
    }

    protected void LinkSave_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["Edit"] != null)
        {

            mycon();
            cmd = new SqlCommand("Select * from AreaTbl Where Area=@ar and  AreaId!=@aid", con);
            cmd.Parameters.AddWithValue("@ar", txtArea.Text);
            cmd.Parameters.AddWithValue("@aid", Request.QueryString["Edit"].ToString());
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script> alert('Given Area is Allready Exist.')</script>");

            }

            else
            {
                int statusValue = (dropstatus.SelectedItem.Text == "Active") ? 1 : 0;
                

                cmd = new SqlCommand("Update AreaTbl set Area=@ar,Status=@sts Where AreaId=@aid", con);
                cmd.Parameters.AddWithValue("@ar", txtArea.Text);




                cmd.Parameters.AddWithValue("@sts", statusValue);
                cmd.Parameters.AddWithValue("@aid", Request.QueryString["Edit"].ToString());
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Area is successfully Updated.')</script>");

            }
        }
        else
        {
            mycon();
            cmd = new SqlCommand("Select * from AreaTbl Where Area=@ar", con);
            cmd.Parameters.AddWithValue("@ar", txtArea.Text);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script> alert('Given Area is Allready Exist.')</script>");
            }
            else
            {
                int statusValue = (dropstatus.SelectedItem.Text == "Active") ? 1 : 0;

                cmd = new SqlCommand("Insert into AreaTbl(Area,Status) Values(@ar,@sts) ", con);
                cmd.Parameters.AddWithValue("@ar", txtArea.Text);

                cmd.Parameters.AddWithValue("@sts", statusValue);
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Area is successfully Inserted.')</script>");
                txtArea.Text = "";
                cmd.Dispose();

                con.Close();
                con.Dispose();
            }
        }




    }

}




