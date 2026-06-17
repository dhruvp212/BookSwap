using System;
using System.Web.UI;

public partial class Library_LibraryMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Enforce Library Login Access (UserType == 2 typically)
        if (Session["User"] == null)
        {
            Response.Redirect("~/Client/login.aspx");
        }
    }
}
