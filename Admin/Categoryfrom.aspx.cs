using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


public partial class Admin_Categoryfrom : System.Web.UI.Page
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

                cmd = new SqlCommand("Select * from CategoryTbl Where CategoryId=@cid", con);
                cmd.Parameters.AddWithValue("@cid", id);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    TxtCategory.Text = ds.Tables[0].Rows[0]["Category"].ToString();
                    imgIcon.ImageUrl = ds.Tables[0].Rows[0]["icon"].ToString();
                    DropStatus.Text = ds.Tables[0].Rows[0]["Status"].ToString() == "True" ? "1" : "0";
                }
            }
        }

    }

    protected void btnsave_Click1(object sender, EventArgs e)
    {
        string path = "";
        mycon();

        cmd = new SqlCommand("Select * from CategoryTbl Where Category=@ct and CategoryId != @cid", con);
        cmd.Parameters.AddWithValue("@ct", TxtCategory.Text);
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
            Response.Write("<script> alert('Given Category is Allready Exist.')</script>");

        }
        else
        {
            if (Request.QueryString["Edit"] != null)
            {

                cmd = new SqlCommand("Update CategoryTbl set Category=@ct,icon=@ic,Status=@st Where CategoryId=@cid", con);
                cmd.Parameters.AddWithValue("@ct", TxtCategory.Text);
                if (FileUpload1.HasFile)
                {
                    FileUpload1.SaveAs(Server.MapPath("~/Icon/" + FileUpload1.FileName));
                    path = "~/icon/" + FileUpload1.FileName;
                }
                else
                {
                    path = imgIcon.ImageUrl;
                }
                cmd.Parameters.AddWithValue("@ic", path);
                cmd.Parameters.AddWithValue("@st", DropStatus.Text);
                cmd.Parameters.AddWithValue("@cid", Request.QueryString["Edit"].ToString());
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Category is Successfully Updated.')</script>");
            }
            else
            {
                cmd = new SqlCommand("Insert into CategoryTbl Values(@cat,@Icon,@sts) ", con);
                cmd.Parameters.AddWithValue("@cat", TxtCategory.Text);
                if (FileUpload1.HasFile)
                {
                    FileUpload1.SaveAs(Server.MapPath("~/Icon/" + FileUpload1.FileName));
                    path = "~/icon/" + FileUpload1.FileName;

                }
                cmd.Parameters.AddWithValue("@Icon", path);
                cmd.Parameters.AddWithValue("@sts", DropStatus.Text);
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Category is Successfully Inserted.')</script>");
                TxtCategory.Text = "";
                FileUpload1.TabIndex = 0;
            }


        }

        cmd.Dispose();

        con.Close();
        con.Dispose();


    }
}