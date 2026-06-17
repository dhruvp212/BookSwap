using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_Educationfrom : System.Web.UI.Page
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

                cmd = new SqlCommand("Select * from EducationTbl Where EducationId=@EId", con);
                cmd.Parameters.AddWithValue("@EId", id);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtEducation.Text = ds.Tables[0].Rows[0]["Education"].ToString();

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

            cmd = new SqlCommand("Select * from EducationTbl Where Education=@Ec and EducationId != @EId", con);
            cmd.Parameters.AddWithValue("@Ec", txtEducation.Text);

            cmd.Parameters.AddWithValue("@EId", Request.QueryString["Edit"].ToString());

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script> alert('Given Category is Allready Exist.')</script>");

            }

            else
            {
                cmd = new SqlCommand("Update EducationTbl set Education=@Ec,Status=@st Where EducationId=@EId", con);
                cmd.Parameters.AddWithValue("@Ec", txtEducation.Text);


                cmd.Parameters.AddWithValue("@st", DropStatus.Text);
                cmd.Parameters.AddWithValue("@EId", Request.QueryString["Edit"].ToString());
                cmd.ExecuteNonQuery();
                Response.Write("<script> alert('Education is Successfully Updated.')</script>");
            }
        }
        else
        {
            mycon();

            cmd = new SqlCommand("Insert into EducationTbl Values (@EId,@sts) ", con);
            cmd.Parameters.AddWithValue("@EId", txtEducation.Text);


            cmd.Parameters.AddWithValue("@sts", DropStatus.Text);
            cmd.ExecuteNonQuery();
            Response.Write("<script> alert('Category is Successfully Inserted.')</script>");
            txtEducation.Text = "";

        }
        cmd.Dispose();
        con.Close();
        con.Dispose();


    }
}
