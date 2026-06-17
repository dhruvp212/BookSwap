using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_EducationLevelFrom : System.Web.UI.Page
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


    void FillEducationDropDown()
    {
        mycon();
        cmd = new SqlCommand("Select * from EducationTbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        DropEducationlevel.DataSource = ds;
        DropEducationlevel.DataValueField = "Education";
        DropEducationlevel.DataTextField = "EducationId";

        DropEducationlevel.DataBind();
        da.Dispose();
        ds.Dispose();
        con.Close();
        con.Dispose();
        DropEducationlevel.Items.Insert(0, "--- Select EducationId ---");
        DropEducationlevel.Items[0].Value = "";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
           FillEducationDropDown();
          
        }
        if (!IsPostBack)
        {
            if (Request.QueryString["Edit"] != null)
            {
                string id = Request.QueryString["Edit"].ToString();
                mycon();

                cmd = new SqlCommand("Select * from EducationLvelTbl Where EducationLevelId=@eId", con);
                cmd.Parameters.AddWithValue("@eId", id);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();

                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    // dropCategory.Text = ds.Tables[0].Rows[0]["Category"].ToString();
                    DropEducationlevel.Text = ds.Tables[0].Rows[0]["Educationlevel"].ToString();
                    //  fileIcon.ImageUrl = ds.Tables[0].Rows[0]["Icon"].ToString();
                    DropStatus.Text = ds.Tables[0].Rows[0]["Status"].ToString() == "True" ? "1" : "0";

                }
            }
        }
    } 
       
   protected void btnsave_Click1(object sender, EventArgs e)
   {
        if (Request.QueryString["Edit"] != null)
        {

            mycon();
            cmd = new SqlCommand("Select * from EducationLvelTbl Where Educationlevel=@Educationlevel and  EducationLevelId!=@eid", con);
            cmd.Parameters.AddWithValue("@Educationlevel", DropEducationlevel.Text);
            cmd.Parameters.AddWithValue("@eid", Request.QueryString["Edit"].ToString());
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script> alert('Given Educationlevel is Allready Exist.')</script>");

            }

            else
            {
                int statusValue = (DropStatus.SelectedItem.Text == "Active") ? 1 : 0;


                cmd = new SqlCommand("Update EducationLvelTbl set Educationlevel=@Educationlevel,Status=@sts Where EducationLevelId=@eId", con);
                cmd.Parameters.AddWithValue("@Educationlevel", DropEducationlevel.Text);




                cmd.Parameters.AddWithValue("@sts", statusValue);
                cmd.Parameters.AddWithValue("@eId", Request.QueryString["Edit"].ToString());
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Educationlevel is successfully Updated.')</script>");

            }
        }
        else
        {
            mycon();
            cmd = new SqlCommand("Select * from EducationLvelTbl Where Educationlevel=@Educationlevel", con);
            cmd.Parameters.AddWithValue("@Educationlevel", DropEducationlevel.Text);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script> alert('Given Area is Allready Exist.')</script>");
            }
            else
            {
                int statusValue = (DropStatus.SelectedItem.Text == "Active") ? 1 : 0;

                cmd = new SqlCommand("Insert into EducationLveltbl(Educationlevel,Status) Values(@Educationlevel,@sts) ", con);
                cmd.Parameters.AddWithValue("@Educationlevel", DropEducationlevel.Text);

                cmd.Parameters.AddWithValue("@sts", statusValue);
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Educationlevel is successfully Inserted.')</script>");
                DropEducationlevel.Text = "";
                cmd.Dispose();

                con.Close();
                con.Dispose();
            }
        }


    }
  
}
