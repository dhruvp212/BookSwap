using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_SwapRequestList : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;
    DataSet ds;

    // Current filter: "All", "0" = Pending, "1" = Approved, "2" = Denied
    private string CurrentFilter
    {
        get { return ViewState["SwapFilter"] != null ? ViewState["SwapFilter"].ToString() : "All"; }
        set { ViewState["SwapFilter"] = value; }
    }

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
    }

    // ── Helper: returns a colour-coded badge based on SwapStatus value ──────────
    protected string GetSwapStatusBadge(object swapStatus)
    {
        if (swapStatus == null || swapStatus == DBNull.Value)
            return "<span class='badge-pending'>Pending</span>";

        byte status = Convert.ToByte(swapStatus);
        switch (status)
        {
            case 1:  return "<span class='badge-approved'>Approved</span>";
            case 2:  return "<span class='badge-denied'>Denied</span>";
            default: return "<span class='badge-pending'>Pending</span>";
        }
    }

    // ── Fill the GridView (optionally filtered by SwapStatus) ────────────────────
    void FillGrid(string filter)
    {
        mycon();

        string sql;
        if (filter == "All")
        {
            sql = @"SELECT SwapRequestId, Userid, EducationId, EducationLevelId, Semester,
                           PhotoFront, PhotoEnd, OriganalTotalAmount, SecondTotalAmount,
                           Discription, PaymentType, Ispaid, SwapStatus, EntryDate, Status, UpdatedDate
                    FROM SwapRequestTbl
                    ORDER BY EntryDate DESC";
            cmd = new SqlCommand(sql, con);
        }
        else
        {
            sql = @"SELECT SwapRequestId, Userid, EducationId, EducationLevelId, Semester,
                           PhotoFront, PhotoEnd, OriganalTotalAmount, SecondTotalAmount,
                           Discription, PaymentType, Ispaid, SwapStatus, EntryDate, Status, UpdatedDate
                    FROM SwapRequestTbl
                    WHERE SwapStatus = @st
                    ORDER BY EntryDate DESC";
            cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@st", Convert.ToByte(filter));
        }

        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);

        gridSwapList.DataSource = ds;
        gridSwapList.DataBind();

        // Update total count badge
        totalBadge.InnerText = ds.Tables[0].Rows.Count + " record(s)";

        con.Close();
        con.Dispose();
    }

    // ── Page Load ────────────────────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillGrid(CurrentFilter);
        }
    }

    // ── Filter buttons ────────────────────────────────────────────────────────────
    protected void FilterStatus_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        CurrentFilter = btn.CommandArgument;
        FillGrid(CurrentFilter);
    }

    // ── GridView row commands: Approve / Deny ─────────────────────────────────────
    protected void gridSwapList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Approve" || e.CommandName == "Deny")
        {
            int requestId = Convert.ToInt32(e.CommandArgument);
            byte newStatus = (e.CommandName == "Approve") ? (byte)1 : (byte)2;

            mycon();
            cmd = new SqlCommand(
                "UPDATE SwapRequestTbl SET SwapStatus = @st, UpdatedDate = @ud WHERE SwapRequestId = @rid",
                con);
            cmd.Parameters.AddWithValue("@st",  newStatus);
            cmd.Parameters.AddWithValue("@ud",  DateTime.Now);
            cmd.Parameters.AddWithValue("@rid", requestId);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();
            con.Dispose();

            string msg = (e.CommandName == "Approve")
                ? "Swap request #" + requestId + " has been Approved."
                : "Swap request #" + requestId + " has been Denied.";

            Response.Write("<script>alert('" + msg + "')</script>");
            FillGrid(CurrentFilter);
        }
    }
}
