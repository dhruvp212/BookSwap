using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_StudentLogin : System.Web.UI.Page
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

    void FillCity()
    {
        mycon();
        cmd = new SqlCommand("Select * from CityTbl", con);
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);

        dropCity.DataSource = ds;
        dropCity.DataTextField = "City";
        dropCity.DataValueField = "CityId";
        dropCity.DataBind();

        dropCity.Items.Insert(0, "--- Select City ---");
        dropCity.Items[0].Value = "";

        con.Close();
    }

    void FillArea()
    {
        mycon();
        cmd = new SqlCommand("Select * from AreaTbl Where CityId=@ct", con);
        cmd.Parameters.AddWithValue("@ct", dropCity.SelectedValue);

        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);

        dropArea.DataSource = ds;
        dropArea.DataTextField = "Area";
        dropArea.DataValueField = "AreaId";
        dropArea.DataBind();

        dropArea.Items.Insert(0, "--- Select Area ---");
        dropArea.Items[0].Value = "";

        con.Close();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillCity();

            if (Session["User"] != null)
            {


                mycon();
                cmd = new SqlCommand("Select * from StudentTbl Where UserId=@UId", con);
                cmd.Parameters.AddWithValue("@UId", Session["User"].ToString());

                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    Txtfullname.Text = ds.Tables[0].Rows[0]["Name"].ToString();
                    txtAddress.Text = ds.Tables[0].Rows[0]["Address"].ToString();
                    txtPincode.Text = ds.Tables[0].Rows[0]["Pincode"].ToString();

                    dropCity.SelectedValue = ds.Tables[0].Rows[0]["CityId"].ToString();
                    FillArea();
                    dropArea.SelectedValue = ds.Tables[0].Rows[0]["AreaId"].ToString();
                }

                btnsave.Text = "Update";

                con.Close();
            }
        }
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (Session["User"] != null)
        {
            mycon();
            cmd = new SqlCommand("Select count(*) from StudentTbl Where Email=@em and  UserID!=@uid", con);
            cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
            cmd.Parameters.AddWithValue("@em", Email.Text);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script>alert('Email Are Alrady Exsist')</script>");

            }
            else
            {
                mycon();

                cmd = new SqlCommand("UPDATE StudentTbl SET Name=@Nm, CityId=@Cid, AreaId=@Aid, Address=@Add, Pincode=@Pin WHERE UserId=@Uid", con);

                cmd.Parameters.AddWithValue("@Nm", Txtfullname.Text);
                cmd.Parameters.AddWithValue("@Cid", dropCity.SelectedValue);
                cmd.Parameters.AddWithValue("@Aid", dropArea.SelectedValue);
                cmd.Parameters.AddWithValue("@Add", txtAddress.Text);
                cmd.Parameters.AddWithValue("@Pin", txtPincode.Text);
                cmd.Parameters.AddWithValue("@Uid", Session["User"].ToString());

                cmd.ExecuteNonQuery();

                Response.Write("<script>alert('Profile Updated Successfully')</script>");

                con.Close();
            }
        }
        else
        {
            mycon();
            SqlCommand cmd = new SqlCommand("INSERT INTO UserTBL(Name,UserType,Email,Mobile,Password,IsVerified,IsActive,EntryDate) VALUES(@Name,@UserType,@Email,@Mobile,@Password,1,1,GETDATE()); SELECT SCOPE_IDENTITY();", con);

            cmd.Parameters.AddWithValue("@Name", Txtfullname.Text);
            cmd.Parameters.AddWithValue("@UserType", 1);
            cmd.Parameters.AddWithValue("@Email", Email.Text.ToLower());
            cmd.Parameters.AddWithValue("@Mobile", Mobile.Text);
            cmd.Parameters.AddWithValue("@Password", Password.Text);

            int UserID = Convert.ToInt32(cmd.ExecuteScalar());

            SqlCommand cmd2 = new SqlCommand("INSERT INTO StudentTbl(UserId,Name,CityId,AreaId,Address,Pincode,Status,EntryDate) VALUES(@UserId,@Name,@CityId,@AreaId,@Address,@Pincode,1,GETDATE())", con);

            cmd2.Parameters.AddWithValue("@UserId", UserID);
            cmd2.Parameters.AddWithValue("@Name", Txtfullname.Text);
            cmd2.Parameters.AddWithValue("@CityId", dropCity.SelectedValue);
            cmd2.Parameters.AddWithValue("@AreaId", dropArea.SelectedValue);
            cmd2.Parameters.AddWithValue("@Address", txtAddress.Text);
            cmd2.Parameters.AddWithValue("@Pincode", txtPincode.Text);
            cmd2.ExecuteNonQuery();
            Response.Write("<script>alert('Profile Create Successfully ! To use student Login Frist');window.location='login.aspx';</script>");
            con.Close();
        }
    }

    protected void dropCity_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillArea();
    }
}