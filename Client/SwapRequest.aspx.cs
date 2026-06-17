using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

public partial class Client_SwapRequest : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
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

    // ================= LEVEL =================
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
            FillEducationDrop();
        }
    }

    // ================= INSERT / UPDATE =================
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        string frontPath = "";
        string endPath = "";

        // ===== Photo Upload =====
        if (PhotoFront.HasFile)
        {
            string folderPath = Server.MapPath("~/icon/");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            string filename = Guid.NewGuid().ToString() + Path.GetExtension(PhotoFront.FileName);
            string fullPath = Path.Combine(folderPath, filename);

            PhotoFront.SaveAs(fullPath);

            frontPath = "~/icon/" + filename;   // ? save path
        }

        mycon();

        // ===== INSERT =====
        cmd = new SqlCommand("INSERT INTO SwapRequestTbl " +
            "(UserId,EducationId, EducationLevelId, Semester, PhotoFront, PhotoEnd, OriganalTotalAmount, SecondTotalAmount, Discription,EntryDate) " +
            "VALUES (@uid,@edu, @Educationlevel, @sem, @front, @end, @Ota,@sta, @desc,GETDATE())", con);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
        cmd.Parameters.AddWithValue("@edu", DropEducation.SelectedValue);
        cmd.Parameters.AddWithValue("@Educationlevel", DropEducationlavel.SelectedValue);
        cmd.Parameters.AddWithValue("@sem", DroupSemester.SelectedValue);
        cmd.Parameters.AddWithValue("@front", frontPath);
        cmd.Parameters.AddWithValue("@end", endPath);
        cmd.Parameters.AddWithValue("@Ota", txtAmt1.Text);
        cmd.Parameters.AddWithValue("@sta", txtAmt2.Text);
        cmd.Parameters.AddWithValue("@desc", txtDesc.Text);

        cmd.ExecuteNonQuery();

        con.Close();

        Response.Write("<script>alert('Swap Request Submitted Successfully!');</script>");

        Clear();
    }

    // ================= CLEAR =================
    void Clear()
    {
        DropEducation.SelectedIndex = 0;
        DropEducationlavel.Items.Clear();
        DroupSemester.SelectedIndex = 0;
        txtAmt1.Text = "";
        txtAmt2.Text = "";
        txtDesc.Text = "";
    }

    // ================= DROPDOWN EVENT =================
    protected void DropEducation_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DropEducation.SelectedIndex > 0)
        {
            fillDropEducationlavel();
        }
    }
}