using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Client_Student_Addbook : System.Web.UI.Page
{
    SqlConnection con;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
    }

    // ================= CATEGORY =================
    void FilldropCategory()
    {
        mycon();
        SqlDataAdapter da = new SqlDataAdapter("Select * from CategoryTbl", con);
        DataTable dt = new DataTable();
        da.Fill(dt);

        DropCategory.DataSource = dt;
        DropCategory.DataTextField = "Category";
        DropCategory.DataValueField = "CategoryId";
        DropCategory.DataBind();

        DropCategory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--- Select Category ---", ""));
        con.Close();
    }

    // ================= EDUCATION =================
    void FillEducationDrop()
    {
        mycon();
        SqlDataAdapter da = new SqlDataAdapter("Select * from EducationTbl", con);
        DataTable dt = new DataTable();
        da.Fill(dt);

        DropEducation.DataSource = dt;
        DropEducation.DataTextField = "Education";
        DropEducation.DataValueField = "EducationId";
        DropEducation.DataBind();

        DropEducation.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--- Select Education ---", ""));
        con.Close();
    }

    // ================= EDUCATION LEVEL =================
    void fillDropEducationlavel()
    {
        mycon();
        SqlCommand cmd = new SqlCommand("Select * from EducationLvelTbl Where EducationId=@eid", con);
        cmd.Parameters.AddWithValue("@eid", DropEducation.SelectedValue);

        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);

        DropEducationlavel.DataSource = dt;
        DropEducationlavel.DataTextField = "EducationLevel";
        DropEducationlavel.DataValueField = "EducationLevelId";
        DropEducationlavel.DataBind();

        DropEducationlavel.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--- Select Level ---", ""));
        con.Close();
    }

    // ================= PAGE LOAD =================
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
        {
            Response.Redirect("login.aspx");
        }

        if (!IsPostBack)
        {
            FilldropCategory();
            FillEducationDrop();
        }
    }

    // ================= SAVE BUTTON =================
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (Session["User"] != null)
        {
            string File1 = "", File2 = "", File3 = "", File4 = "", File5 = "";

            // ?? Upload Images
            if (Uploadphoto1.HasFile)
            {
                File1 = "~/Icon/" + Guid.NewGuid() + Uploadphoto1.FileName;
                Uploadphoto1.SaveAs(Server.MapPath(File1));
            }

            if (Upload2.HasFile)
            {
                File2 = "~/Icon/" + Guid.NewGuid() + Upload2.FileName;
                Upload2.SaveAs(Server.MapPath(File2));
            }

            if (Upload3.HasFile)
            {
                File3 = "~/Icon/" + Guid.NewGuid() + Upload3.FileName;
                Upload3.SaveAs(Server.MapPath(File3));
            }

            if (Upload4.HasFile)
            {
                File4 = "~/Icon/" + Guid.NewGuid() + Upload4.FileName;
                Upload4.SaveAs(Server.MapPath(File4));
            }

            if (Upload5.HasFile)
            {
                File5 = "~/Icon/" + Guid.NewGuid() + Upload5.FileName;
                Upload5.SaveAs(Server.MapPath(File5));
            }

            // ?? INSERT QUERY (FIXED)
            mycon();

            SqlCommand cmd = new SqlCommand(@"
            INSERT INTO BookTbl 
            (UserId, CategoryId, EducationId, EducationLevelId, EducationLevel, BookTitle, Auther, INSBNO, RentPriceperDay, Description, Photo1, Photo2, Photo3, Photo4, Photo5, IsVerified, IsActive, EntryDate)
            VALUES
            (@UserId, @CategoryId, @EducationId, @EducationLevelId, @EducationLevel, @BookTitle, @Auther, @INSBNO, @RentPriceperDay, @Description, @Photo1, @Photo2, @Photo3, @Photo4, @Photo5, @IsVerified, @IsActive, GETDATE())
            ", con);

            cmd.Parameters.AddWithValue("@UserId", Session["User"].ToString());
            cmd.Parameters.AddWithValue("@CategoryId", DropCategory.SelectedValue);
            cmd.Parameters.AddWithValue("@EducationId", DropEducation.SelectedValue); // ?? FIX
            cmd.Parameters.AddWithValue("@EducationLevelId", DropEducationlavel.SelectedValue);
            cmd.Parameters.AddWithValue("@EducationLevel", DropEducationlavel.SelectedItem.Text);

            cmd.Parameters.AddWithValue("@BookTitle", TxtBookTitle.Text);
            cmd.Parameters.AddWithValue("@Auther", TxtAuther.Text);
            cmd.Parameters.AddWithValue("@INSBNO", TxtINSBNO.Text);
            cmd.Parameters.AddWithValue("@RentPriceperDay", txtPrice.Text);
            cmd.Parameters.AddWithValue("@Description", TxtDescription.Text);

            cmd.Parameters.AddWithValue("@Photo1", File1);
            cmd.Parameters.AddWithValue("@Photo2", File2);
            cmd.Parameters.AddWithValue("@Photo3", File3);
            cmd.Parameters.AddWithValue("@Photo4", File4);
            cmd.Parameters.AddWithValue("@Photo5", File5);

            cmd.Parameters.AddWithValue("@IsVerified", 1);
            cmd.Parameters.AddWithValue("@IsActive", 1);

            cmd.ExecuteNonQuery();
            con.Close();

            Response.Write("<script>alert('Book Added Successfully!');</script>");
        }
    }

    // ================= DROPDOWN CHANGE =================
    protected void DropEducation_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DropEducation.SelectedIndex > 0)
        {
            fillDropEducationlavel();
        }
    }
}