using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class registerpage : System.Web.UI.Page
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
            FillCity();
        }
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

        dropCity.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--- Select City ---", ""));
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

        dropArea.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--- Select Area ---", ""));
        con.Close();
    }

    protected void dropCity_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillArea();
    }

    protected void BtnRegister_Click(object sender, EventArgs e)
    {
        mycon();

        // 1. Check if email or mobile exists in UserTbl
        cmd = new SqlCommand("Select * from UserTbl Where Email=@em or Mobile=@mb", con);
        cmd.Parameters.AddWithValue("@em", txtEmail.Text.Trim() ?? "");
        cmd.Parameters.AddWithValue("@mb", txtOwnerContact.Text.Trim() ?? "");
        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0]["Email"].ToString() == txtEmail.Text && ds.Tables[0].Rows[0]["Mobile"].ToString() == txtOwnerContact.Text)
            {
                Response.Write("<script>alert('Given Email and Mobile No already exists.')</script>");
            }
            else if (ds.Tables[0].Rows[0]["Email"].ToString() == txtEmail.Text)
            {
                Response.Write("<script>alert('Given Email already exists.')</script>");
            }
            else
            {
                Response.Write("<script>alert('Given Mobile No already exists.')</script>");
            }
            con.Close();
            return;
        }

        // 2. Upload Files
        string fileAddressProof = "", fileAadhar = "", fileShopPhoto = "", fileOwnerPhoto = "", fileLibraryLogo = "", fileBannerPhoto = "";

        if (fuAddressProof.HasFile)
        {
            fileAddressProof = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuAddressProof.FileName);
            fuAddressProof.SaveAs(Server.MapPath(fileAddressProof));
        }
        if (fuAadhar.HasFile)
        {
            fileAadhar = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuAadhar.FileName);
            fuAadhar.SaveAs(Server.MapPath(fileAadhar));
        }
        if (fuShopPhoto.HasFile)
        {
            fileShopPhoto = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuShopPhoto.FileName);
            fuShopPhoto.SaveAs(Server.MapPath(fileShopPhoto));
        }
        if (fuOwnerPhoto.HasFile)
        {
            fileOwnerPhoto = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuOwnerPhoto.FileName);
            fuOwnerPhoto.SaveAs(Server.MapPath(fileOwnerPhoto));
        }
        if (fuLibraryLogo.HasFile)
        {
            fileLibraryLogo = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuLibraryLogo.FileName);
            fuLibraryLogo.SaveAs(Server.MapPath(fileLibraryLogo));
        }
        if (fuBannerPhoto.HasFile)
        {
            fileBannerPhoto = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0, 8) + System.IO.Path.GetExtension(fuBannerPhoto.FileName);
            fuBannerPhoto.SaveAs(Server.MapPath(fileBannerPhoto));
        }

        // 3. Begin Transaction for Safe Combined Insert
        using (SqlTransaction tran = con.BeginTransaction())
        {
            try
            {
                // IsVerified and IsActive are set to 0 (False) by default, requiring Admin approval
                SqlCommand cmdInsertUser = new SqlCommand("INSERT INTO UserTBL(Name,UserType,Email,Mobile,Password,IsVerified,IsActive,EntryDate) VALUES(@Name,@UserType,@Email,@Mobile,@Password,0,0,GETDATE()); SELECT SCOPE_IDENTITY();", con, tran);
                cmdInsertUser.Parameters.AddWithValue("@Name", Txtfullname.Text);
                cmdInsertUser.Parameters.AddWithValue("@UserType", 2); // 2 = Library
                cmdInsertUser.Parameters.AddWithValue("@Email", txtEmail.Text.ToLower());
                cmdInsertUser.Parameters.AddWithValue("@Mobile", txtOwnerContact.Text);
                cmdInsertUser.Parameters.AddWithValue("@Password", TxtPassword.Text);
                
                int newUserId = Convert.ToInt32(cmdInsertUser.ExecuteScalar());

                // 4. Insert into LibraryTbl (IsVerified = 0 here as well)
                SqlCommand cmdInsertLib = new SqlCommand(@"INSERT INTO LibraryTbl
                    (UserId, LibraryName, OwnerName, LibraryContactNo, OwnerContactNo, Address, CityId, AreaId, 
                     AddressProof, AdharCard, ShopPhoto, OwnerPhoto, LibraryLogo, LibraryBanarPhoto, IsVerified, EntryDate) 
                     VALUES 
                    (@UserId, @LibraryName, @OwnerName, @LibraryContactNo, @OwnerContactNo, @Address, @CityId, @AreaId, 
                     @AddressProof, @AdharCard, @ShopPhoto, @OwnerPhoto, @LibraryLogo, @LibraryBanarPhoto, 0, GETDATE())", con, tran);

                cmdInsertLib.Parameters.AddWithValue("@UserId", newUserId);
                cmdInsertLib.Parameters.AddWithValue("@LibraryName", txtLibraryName.Text);
                cmdInsertLib.Parameters.AddWithValue("@OwnerName", Txtfullname.Text);
                cmdInsertLib.Parameters.AddWithValue("@LibraryContactNo", txtLibraryContact.Text);
                cmdInsertLib.Parameters.AddWithValue("@OwnerContactNo", txtOwnerContact.Text);
                cmdInsertLib.Parameters.AddWithValue("@Address", txtAddress.Text);
                cmdInsertLib.Parameters.AddWithValue("@CityId", dropCity.SelectedValue);
                cmdInsertLib.Parameters.AddWithValue("@AreaId", dropArea.SelectedValue);
                cmdInsertLib.Parameters.AddWithValue("@AddressProof", fileAddressProof);
                cmdInsertLib.Parameters.AddWithValue("@AdharCard", fileAadhar);
                cmdInsertLib.Parameters.AddWithValue("@ShopPhoto", fileShopPhoto);
                cmdInsertLib.Parameters.AddWithValue("@OwnerPhoto", fileOwnerPhoto);
                cmdInsertLib.Parameters.AddWithValue("@LibraryLogo", fileLibraryLogo);
                cmdInsertLib.Parameters.AddWithValue("@LibraryBanarPhoto", fileBannerPhoto);
                
                cmdInsertLib.ExecuteNonQuery();

                // Commit if both succeed
                tran.Commit();
                Response.Write("<script>alert('Library Registered Successfully! Awaiting Admin Approval.');window.location='login.aspx';</script>");
            }
            catch (Exception ex)
            {
                // Rollback if any error occurs
                tran.Rollback();
                Response.Write("<script>alert('Registration failed due to a system error. Please try again later.');</script>");
            }
        }
        con.Close();
    }
}
