using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Client_ProductDetail : System.Web.UI.Page
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
        if (!IsPostBack)
        {
            txtBorrowDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            if (Request.QueryString["id"] != null)
            {
                LoadBookDetails(Request.QueryString["id"].ToString());
            }
            else
            {
                bookDetailsContainer.Visible = false;
                lblMessage.Text = "Invalid Book Requested. Please return to the Library Collection.";
                lblMessage.CssClass = "d-block text-center mt-3 fw-bold text-danger fs-4";
            }
        }
    }

    void LoadBookDetails(string bookId)
    {
        mycon();
        SqlCommand cmd = new SqlCommand(@"
            SELECT bt.*, ct.Category, lt.LibraryName, lt.LibraryId 
            FROM BookTbl as bt 
            INNER JOIN CategoryTbl as ct ON bt.CategoryId = ct.CategoryId
            INNER JOIN LibraryTbl as lt ON bt.UserId = lt.UserId
            WHERE bt.BookId = @BookId AND bt.IsVerified = 1 AND bt.IsActive = 1", con);
            
        cmd.Parameters.AddWithValue("@BookId", bookId);
        
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            
            litTitle.Text = row["BookTitle"].ToString();
            litAuthor.Text = row["Auther"].ToString();
            litPrice.Text = Convert.ToDecimal(row["RentPriceperDay"]) == 0 ? "Free" : string.Format("{0:C}", row["RentPriceperDay"]);
            litCategory.Text = row["Category"].ToString();
            litISBN.Text = row["INSBNO"].ToString();
            litEducation.Text = row["EducationLevel"].ToString();
            litLibrary.Text = row["LibraryName"].ToString();
            litDescription.Text = row["Description"].ToString().Replace("\n", "<br/>");
            hfLibraryId.Value = row["LibraryId"].ToString();
            hfBookId.Value = row["BookId"].ToString();

            // Check availability
            SqlCommand cmdAvail = new SqlCommand("SELECT COUNT(*) FROM BookBorrowTbl WHERE BookId=@BId AND IsReturn=0 AND Status=1", con);
            cmdAvail.Parameters.AddWithValue("@BId", bookId);
            int borrowCount = Convert.ToInt32(cmdAvail.ExecuteScalar());

            if (borrowCount > 0)
            {
                litAvailability.Text = "<span class='badge bg-danger px-3 py-2 fs-6'>Currently Borrowed</span>";
                borrowForm.Visible = false;
            }
            else
            {
                litAvailability.Text = "<span class='badge bg-success px-3 py-2 fs-6'>Available Now</span>";
                borrowForm.Visible = true;
            }
            
            // Set Photos
            mainPhoto.Src = ResolveUrl(row["Photo1"].ToString());
            thumb1.Src = ResolveUrl(row["Photo1"].ToString());
            
            if (!string.IsNullOrEmpty(row["Photo2"].ToString())) thumb2.Src = ResolveUrl(row["Photo2"].ToString()); else thumb2.Visible = false;
            if (!string.IsNullOrEmpty(row["Photo3"].ToString())) thumb3.Src = ResolveUrl(row["Photo3"].ToString()); else thumb3.Visible = false;
            if (!string.IsNullOrEmpty(row["Photo4"].ToString())) thumb4.Src = ResolveUrl(row["Photo4"].ToString()); else thumb4.Visible = false;
        }
        else
        {
            bookDetailsContainer.Visible = false;
            lblMessage.Text = "Book not found or currently unavailable.";
            lblMessage.CssClass = "d-block text-center mt-3 fw-bold text-danger fs-4";
        }
        
        con.Close();
    }

    protected void btnConfirmBorrow_Click(object sender, EventArgs e)
    {
        if (Session["User"] == null)
        {
            // Remember they wanted to borrow, ideally route them back here
            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "alert('You must be logged in as a Student to borrow a book.'); window.location='login.aspx';", true);
            return;
        }

        DateTime borrowDate = DateTime.Now;
        DateTime returnDate;
        if (!DateTime.TryParse(txtReturnDate.Text, out returnDate))
        {
            lblMessage.Text = "Please provide a valid Return Date.";
            lblMessage.CssClass = "d-block text-center mt-3 fw-bold text-danger fs-5";
            return;
        }

        if (returnDate <= borrowDate)
        {
            lblMessage.Text = "Your expected Return Date must be strictly after today.";
            lblMessage.CssClass = "d-block text-center mt-3 fw-bold text-danger fs-5";
            return;
        }

        TimeSpan diff = returnDate - borrowDate;
        int totalDays = (int)diff.TotalDays;

        mycon();
        SqlCommand cmd = new SqlCommand(@"
            INSERT INTO BookBorrowTbl 
            (LibraryId, StudentId, Bookid, BorrowDate, ReturnDate, TotalDay, TotalFine, IsReturn, IsFineAplicable, EntryDate, Status) 
            VALUES 
            (@LibraryId, @StudentId, @Bookid, @BorrowDate, @ReturnDate, @TotalDay, 0, 0, 0, GETDATE(), 0)", con);
            
        cmd.Parameters.AddWithValue("@LibraryId", hfLibraryId.Value);
        cmd.Parameters.AddWithValue("@StudentId", Session["User"].ToString());
        cmd.Parameters.AddWithValue("@Bookid", hfBookId.Value);
        cmd.Parameters.AddWithValue("@BorrowDate", borrowDate.ToString("yyyy-MM-dd"));
        cmd.Parameters.AddWithValue("@ReturnDate", returnDate.ToString("yyyy-MM-dd"));
        cmd.Parameters.AddWithValue("@TotalDay", totalDays);

        try
        {
            cmd.ExecuteNonQuery();
            
            // Success Logic
            bookDetailsContainer.Visible = false;
            lblMessage.Text = "Library Borrow request submitted successfully! Awaiting library approval.";
            lblMessage.CssClass = "d-block text-center mt-5 fw-bold text-success fs-3";
        }
        catch (Exception ex)
        {
            lblMessage.Text = "An error occurred while placing the request. " + ex.Message;
            lblMessage.CssClass = "d-block text-center mt-3 fw-bold text-danger fs-5";
        }
        finally
        {
            con.Close();
        }
    }
}