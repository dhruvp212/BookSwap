using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_Profile : System.Web.UI.Page
{
    SqlConnection con;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        if (con.State == ConnectionState.Closed)
            con.Open();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
        {
            Response.Redirect("login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            BindCity();
            LoadProfile();
        }
    }

    void BindCity()
    {
        mycon();
        SqlCommand cmd = new SqlCommand("SELECT * FROM CityTbl", con);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        ddlCity.DataSource = dt;
        ddlCity.DataTextField = "City";
        ddlCity.DataValueField = "CityId";
        ddlCity.DataBind();
        ddlCity.Items.Insert(0, new ListItem("-- Select City --", "0"));
        con.Close();
    }

    void BindArea(string cityId)
    {
        mycon();
        SqlCommand cmd = new SqlCommand("SELECT * FROM AreaTbl WHERE CityId=@CId", con);
        cmd.Parameters.AddWithValue("@CId", cityId);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        ddlArea.DataSource = dt;
        ddlArea.DataTextField = "Area";
        ddlArea.DataValueField = "AreaId";
        ddlArea.DataBind();
        ddlArea.Items.Insert(0, new ListItem("-- Select Area --", "0"));
        con.Close();
    }

    void LoadProfile()
    {
        mycon();
        // Fetch from UserTBL and StudentTbl
        SqlCommand cmd = new SqlCommand(@"
            SELECT u.Name, u.Email, u.Mobile, u.Password, s.Address, s.Pincode, s.CityId, s.AreaId 
            FROM UserTBL u 
            LEFT JOIN StudentTbl s ON u.UserId = s.UserId 
            WHERE u.UserId = @UId", con);
        
        cmd.Parameters.AddWithValue("@UId", Session["User"].ToString());
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.Rows[0];
            txtFullName.Text = dr["Name"].ToString();
            txtEmail.Text = dr["Email"].ToString();
            txtMobile.Text = dr["Mobile"].ToString();
            txtPassword.Attributes["value"] = dr["Password"].ToString(); // Show as dots but accessible
            
            txtAddress.Text = dr["Address"].ToString();
            txtPincode.Text = dr["Pincode"].ToString();

            if (dr["CityId"] != DBNull.Value)
            {
                ddlCity.SelectedValue = dr["CityId"].ToString();
                BindArea(dr["CityId"].ToString());
                if (dr["AreaId"] != DBNull.Value)
                {
                    ddlArea.SelectedValue = dr["AreaId"].ToString();
                }
            }
        }
        con.Close();
    }

    protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCity.SelectedIndex > 0)
        {
            BindArea(ddlCity.SelectedValue);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        mycon();
        SqlTransaction trans = con.BeginTransaction();

        try
        {
            // 1. Update UserTBL
            SqlCommand cmdUser = new SqlCommand(@"
                UPDATE UserTBL 
                SET Name = @Nm, Mobile = @Mob, Password = @Pass 
                WHERE UserId = @UId", con, trans);
            
            cmdUser.Parameters.AddWithValue("@Nm", txtFullName.Text);
            cmdUser.Parameters.AddWithValue("@Mob", txtMobile.Text);
            cmdUser.Parameters.AddWithValue("@Pass", txtPassword.Text);
            cmdUser.Parameters.AddWithValue("@UId", Session["User"].ToString());
            cmdUser.ExecuteNonQuery();

            // 2. Update StudentTbl
            SqlCommand cmdStudent = new SqlCommand(@"
                UPDATE StudentTbl 
                SET Name = @Nm, CityId = @Cid, AreaId = @Aid, Address = @Add, Pincode = @Pin 
                WHERE UserId = @UId", con, trans);
            
            cmdStudent.Parameters.AddWithValue("@Nm", txtFullName.Text);
            cmdStudent.Parameters.AddWithValue("@Cid", ddlCity.SelectedValue);
            cmdStudent.Parameters.AddWithValue("@Aid", ddlArea.SelectedValue);
            cmdStudent.Parameters.AddWithValue("@Add", txtAddress.Text);
            cmdStudent.Parameters.AddWithValue("@Pin", txtPincode.Text);
            cmdStudent.Parameters.AddWithValue("@UId", Session["User"].ToString());
            cmdStudent.ExecuteNonQuery();

            trans.Commit();
            lblMessage.Text = "Profile updated successfully!";
            lblMessage.CssClass = "d-block mb-4 alert alert-success";
        }
        catch (Exception ex)
        {
            trans.Rollback();
            lblMessage.Text = "Error: " + ex.Message;
            lblMessage.CssClass = "d-block mb-4 alert alert-danger";
        }
        finally
        {
            con.Close();
        }
    }
}
