using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
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
        if (Session["User"] != null)
        {
            Response.Redirect("Home.aspx");
        }
    }

    protected void lnkLogin_Click1(object sender, EventArgs e)
    {
        mycon();
        cmd = new SqlCommand("Select * from UserTbl Where Email=@em and Password=@pwd", con);
        cmd.Parameters.AddWithValue("@em", txtEmail.Text);
        cmd.Parameters.AddWithValue("@pwd", txtPassword.Text);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count > 0)
        {
            // Check if user is verified
            string isVerifiedStr = ds.Tables[0].Rows[0]["IsVerified"].ToString();
            bool isVerified = (isVerifiedStr == "True" || isVerifiedStr == "1");

            if (!isVerified)
            {
                lblMessage.Text = "Account unverified. Waiting for Admin confirmation.";
                lblMessage.CssClass = "d-block mb-3 fw-bold text-warning";
                
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", 
                    "alert('Your account is awaiting confirmation from the admin. Please check back later.');", true);
            }
            else
            {
                Session["User"] = ds.Tables[0].Rows[0]["UserID"].ToString();
                string userType = ds.Tables[0].Rows[0]["UserType"].ToString();
                
                lblMessage.Text = "Login successful! Redirecting...";
                lblMessage.CssClass = "d-block mb-3 fw-bold text-success";
                
                // Determine redirect URL based on UserType
                string redirectUrl = (userType == "2") ? "../Library/LibraryHome.aspx" : "Home.aspx";

                // Show JS alert then redirect
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", 
                    "alert('Login successfully completed.'); window.location='" + redirectUrl + "';", true);
            }
        }
        else
        {
            lblMessage.Text = "Invalid email address or password.";
            lblMessage.CssClass = "d-block mb-3 fw-bold text-danger";
        }

        //    cmd = new SqlCommand("Insert into Logintbl Values(@em,@ps,@Isv,@Isa,@dt)", con);

        //    cmd.Parameters.AddWithValue("@em", txtEmail.Text);

        //    cmd.Parameters.AddWithValue("@ps", txtPassword.Text);
        //    cmd.Parameters.AddWithValue("@isv", 0);
        //    cmd.Parameters.AddWithValue("@Isa", 1);
        //    cmd.Parameters.AddWithValue("@dt", System.DateTime.Now);

        //    cmd.ExecuteNonQuery();
        //    Response.Write("<script>alert(' Login are successfully')</script>");

        //    txtEmail.Text = "";

        //    txtPassword.Text = "";
        //}
        con.Close();
        con.Dispose();
        cmd.Dispose();
        da.Dispose();



    }
}