using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Library_ManageBookCenter : System.Web.UI.Page
{
    SqlConnection con;
    
    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        if(con.State == ConnectionState.Closed)
            con.Open();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
            Response.Redirect("~/Client/login.aspx");

        if (!IsPostBack)
        {
            FilldropCategory();
            FillEducationDrop();
            BindGrid();
        }
    }

    // ================= DDL BINDING =================
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
        DropCategory.Items.Insert(0, new ListItem("--- Select Category ---", ""));
        con.Close();
    }

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
        DropEducation.Items.Insert(0, new ListItem("--- Select Education ---", ""));
        con.Close();
    }

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
        DropEducationlavel.Items.Insert(0, new ListItem("--- Select Level ---", ""));
        con.Close();
    }

    protected void DropEducation_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DropEducation.SelectedIndex > 0)
            fillDropEducationlavel();
    }

    // ================= CRUD: READ =================
    void BindGrid()
    {
        mycon();
        SqlCommand cmd = new SqlCommand("SELECT * FROM BookTbl WHERE UserId=@uid ORDER BY BookId DESC", con);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        gridBooks.DataSource = dt;
        gridBooks.DataBind();
        con.Close();
    }

    // ================= CRUD: CREATE / UPDATE =================
    protected void btnsave_Click(object sender, EventArgs e)
    {
        string File1 = "", File2 = "", File3 = "", File4 = "", File5 = "";

        // Safe hashed short names
        if (Uploadphoto1.HasFile) { File1 = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0,8) + System.IO.Path.GetExtension(Uploadphoto1.FileName); Uploadphoto1.SaveAs(Server.MapPath(File1)); }
        if (Upload2.HasFile) { File2 = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0,8) + System.IO.Path.GetExtension(Upload2.FileName); Upload2.SaveAs(Server.MapPath(File2)); }
        if (Upload3.HasFile) { File3 = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0,8) + System.IO.Path.GetExtension(Upload3.FileName); Upload3.SaveAs(Server.MapPath(File3)); }
        if (Upload4.HasFile) { File4 = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0,8) + System.IO.Path.GetExtension(Upload4.FileName); Upload4.SaveAs(Server.MapPath(File4)); }
        if (Upload5.HasFile) { File5 = "~/Icon/" + Guid.NewGuid().ToString("N").Substring(0,8) + System.IO.Path.GetExtension(Upload5.FileName); Upload5.SaveAs(Server.MapPath(File5)); }

        mycon();
        SqlCommand cmd;

        if (string.IsNullOrEmpty(hfBookId.Value))
        {
            // INSERT (IsVerified set to 0 to require Admin Approval)
            cmd = new SqlCommand(@"INSERT INTO BookTbl 
            (UserId, CategoryId, EducationId, EducationLevelId, EducationLevel, BookTitle, Auther, INSBNO, RentPriceperDay, Description, Photo1, Photo2, Photo3, Photo4, Photo5, IsVerified, IsActive, EntryDate)
            VALUES
            (@UserId, @CategoryId, @EducationId, @EducationLevelId, @EducationLevel, @BookTitle, @Auther, @INSBNO, @RentPriceperDay, @Description, @Photo1, @Photo2, @Photo3, @Photo4, @Photo5, 0, 1, GETDATE())", con);
            
            cmd.Parameters.AddWithValue("@Photo1", File1);
            cmd.Parameters.AddWithValue("@Photo2", File2);
            cmd.Parameters.AddWithValue("@Photo3", File3);
            cmd.Parameters.AddWithValue("@Photo4", File4);
            cmd.Parameters.AddWithValue("@Photo5", File5);
        }
        else
        {
            // UPDATE
            cmd = new SqlCommand(@"UPDATE BookTbl SET 
                CategoryId=@CategoryId, EducationId=@EducationId, EducationLevelId=@EducationLevelId, EducationLevel=@EducationLevel, 
                BookTitle=@BookTitle, Auther=@Auther, INSBNO=@INSBNO, RentPriceperDay=@RentPriceperDay, Description=@Description 
                WHERE BookId=@BookId AND UserId=@UserId", con);
            cmd.Parameters.AddWithValue("@BookId", hfBookId.Value);

            // Dynamic string building safely for optional file replacement
            if (File1 != "") { cmd.CommandText = cmd.CommandText.Replace("Description=@Description", "Description=@Description, Photo1=@Photo1"); cmd.Parameters.AddWithValue("@Photo1", File1); }
            if (File2 != "") { cmd.CommandText = cmd.CommandText.Replace("Description=@Description", "Description=@Description, Photo2=@Photo2"); cmd.Parameters.AddWithValue("@Photo2", File2); }
            if (File3 != "") { cmd.CommandText = cmd.CommandText.Replace("Description=@Description", "Description=@Description, Photo3=@Photo3"); cmd.Parameters.AddWithValue("@Photo3", File3); }
            if (File4 != "") { cmd.CommandText = cmd.CommandText.Replace("Description=@Description", "Description=@Description, Photo4=@Photo4"); cmd.Parameters.AddWithValue("@Photo4", File4); }
            if (File5 != "") { cmd.CommandText = cmd.CommandText.Replace("Description=@Description", "Description=@Description, Photo5=@Photo5"); cmd.Parameters.AddWithValue("@Photo5", File5); }
        }

        cmd.Parameters.AddWithValue("@UserId", Session["User"].ToString());
        cmd.Parameters.AddWithValue("@CategoryId", DropCategory.SelectedValue == "" ? "0" : DropCategory.SelectedValue);
        cmd.Parameters.AddWithValue("@EducationId", DropEducation.SelectedValue == "" ? "0" : DropEducation.SelectedValue);
        cmd.Parameters.AddWithValue("@EducationLevelId", DropEducationlavel.SelectedValue == "" ? "0" : DropEducationlavel.SelectedValue);
        cmd.Parameters.AddWithValue("@EducationLevel", DropEducationlavel.SelectedItem != null ? DropEducationlavel.SelectedItem.Text : "");
        cmd.Parameters.AddWithValue("@BookTitle", TxtBookTitle.Text);
        cmd.Parameters.AddWithValue("@Auther", TxtAuther.Text);
        cmd.Parameters.AddWithValue("@INSBNO", TxtINSBNO.Text);
        cmd.Parameters.AddWithValue("@RentPriceperDay", txtPrice.Text);
        cmd.Parameters.AddWithValue("@Description", TxtDescription.Text);

        cmd.ExecuteNonQuery();
        con.Close();

        Response.Write("<script>alert('Book Details Saved Successfully!');</script>");
        ClearForm();
        BindGrid();
    }

    // ================= CRUD: EDIT ROW =================
    protected void gridBooks_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SelectBook")
        {
            int bookId = Convert.ToInt32(e.CommandArgument);
            hfBookId.Value = bookId.ToString();

            mycon();
            SqlCommand cmd = new SqlCommand("SELECT * FROM BookTbl WHERE BookId=@id AND UserId=@uid", con);
            cmd.Parameters.AddWithValue("@id", bookId);
            cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                if (DropCategory.Items.FindByValue(dr["CategoryId"].ToString()) != null)
                    DropCategory.SelectedValue = dr["CategoryId"].ToString();
                
                if (DropEducation.Items.FindByValue(dr["EducationId"].ToString()) != null)
                    DropEducation.SelectedValue = dr["EducationId"].ToString();

                fillDropEducationlavel(); // Repopulate level dropdown based on new EducationId
                
                if (DropEducationlavel.Items.FindByValue(dr["EducationLevelId"].ToString()) != null)
                    DropEducationlavel.SelectedValue = dr["EducationLevelId"].ToString();

                TxtBookTitle.Text = dr["BookTitle"].ToString();
                TxtAuther.Text = dr["Auther"].ToString();
                TxtINSBNO.Text = dr["INSBNO"].ToString();
                txtPrice.Text = dr["RentPriceperDay"].ToString();
                TxtDescription.Text = dr["Description"].ToString();
                
                btnsave.Text = "Update Book";
            }
            con.Close();
        }
    }

    // ================= CRUD: DELETE ROW =================
    protected void gridBooks_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int bookId = Convert.ToInt32(gridBooks.DataKeys[e.RowIndex].Value);
        
        mycon();
        SqlCommand cmd = new SqlCommand("DELETE FROM BookTbl WHERE BookId=@id AND UserId=@uid", con);
        cmd.Parameters.AddWithValue("@id", bookId);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
        cmd.ExecuteNonQuery();
        con.Close();

        Response.Write("<script>alert('Book deleted successfully!');</script>");
        BindGrid();
    }

    protected void btnclear_Click(object sender, EventArgs e)
    {
        ClearForm();
    }

    void ClearForm()
    {
        hfBookId.Value = "";
        TxtBookTitle.Text = "";
        TxtAuther.Text = "";
        TxtINSBNO.Text = "";
        txtPrice.Text = "";
        TxtDescription.Text = "";
        DropCategory.SelectedIndex = 0;
        DropEducation.SelectedIndex = 0;
        DropEducationlavel.Items.Clear();
        btnsave.Text = "Save Book";
    }
}
