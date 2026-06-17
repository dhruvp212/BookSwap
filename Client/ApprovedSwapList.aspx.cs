using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_ApprovedSwapList : System.Web.UI.Page
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

    void FillRepeater()
    {
        mycon();

        // Fetch only SwapStatus = 1 (Approved), excluding the logged-in user's own books
        string uid = Session["User"] != null ? Session["User"].ToString() : "0";
        cmd = new SqlCommand(@"
            SELECT SwapRequestId, Userid, EducationId, EducationLevelId, Semester,
                   PhotoFront, PhotoEnd, OriganalTotalAmount, SecondTotalAmount,
                   Discription, PaymentType, Ispaid, SwapStatus, EntryDate, UpdatedDate
            FROM   SwapRequestTbl
            WHERE  SwapStatus = 1
              AND  Userid <> @uid
            ORDER  BY EntryDate DESC", con);
        cmd.Parameters.AddWithValue("@uid", uid);


        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);

        int count = ds.Tables[0].Rows.Count;

        if (count > 0)
        {
            rptBooks.DataSource = ds;
            rptBooks.DataBind();
            pnlEmpty.Visible = false;
            lblCount.Text = count + " approved swap book" + (count == 1 ? "" : "s") + " available";
        }
        else
        {
            rptBooks.DataSource = null;
            rptBooks.DataBind();
            pnlEmpty.Visible = true;
            lblCount.Text = "0 approved swap books";
        }

        da.Dispose();
        ds.Dispose();
        cmd.Dispose();
        con.Close();
        con.Dispose();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillRepeater();
        }
    }

    // ── ItemDataBound: handle photo visibility and back-photo link ────────────────
    protected void rptBooks_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataRowView row = (DataRowView)e.Item.DataItem;

            // -- Front photo --
            System.Web.UI.WebControls.Image imgFront = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgFront");
            System.Web.UI.HtmlControls.HtmlGenericControl noImgDiv =
                (System.Web.UI.HtmlControls.HtmlGenericControl)e.Item.FindControl("divNoImg");

            string photoFront = row["PhotoFront"] == DBNull.Value ? "" : row["PhotoFront"].ToString().Trim();
            if (!string.IsNullOrEmpty(photoFront))
            {
                imgFront.ImageUrl = photoFront;
                imgFront.Visible  = true;
                noImgDiv.Visible  = false;
            }
            else
            {
                imgFront.Visible  = false;
                noImgDiv.Visible  = true;
            }

            // -- Back photo link --
            HyperLink lnkBack = (HyperLink)e.Item.FindControl("lnkBackPhoto");
            string photoEnd = row["PhotoEnd"] == DBNull.Value ? "" : row["PhotoEnd"].ToString().Trim();
            if (!string.IsNullOrEmpty(photoEnd))
            {
                lnkBack.NavigateUrl = "javascript:showPhoto('" + ResolveUrl(photoEnd) + "','Back Photo')";
                lnkBack.Visible = true;
            }
            else
            {
                lnkBack.Visible = false;
            }

            // -- Description panel --
            Panel pnlDesc = (Panel)e.Item.FindControl("pnlDesc");
            string desc = row["Discription"] == DBNull.Value ? "" : row["Discription"].ToString();
            if (!string.IsNullOrEmpty(desc))
            {
                string shortDesc = desc.Length > 80 ? desc.Substring(0, 80) + "…" : desc;
                pnlDesc.Controls.Add(new System.Web.UI.LiteralControl(
                    "<span title='" + HttpUtility.HtmlAttributeEncode(desc) + "'>" +
                    HttpUtility.HtmlEncode(shortDesc) + "</span>"));
                pnlDesc.Visible = true;
            }
            else
            {
                pnlDesc.Visible = false;
            }
        }
    }
}
