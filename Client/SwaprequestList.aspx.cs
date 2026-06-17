using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

public partial class Client_SwaprequestList : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;

    // tracks which chat sender panel should stay open after postback
    string activeSenderId = "";

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
    }

    // ═══════════════════════════════════════════
    //  PAGE LOAD
    // ═══════════════════════════════════════════
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
        {
            Response.Redirect("login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            // If ?view=X open detail straight away (e.g. after redirect)
            int viewId;
            if (Request.QueryString["view"] != null &&
                int.TryParse(Request.QueryString["view"], out viewId))
            {
                ShowDetail(viewId);
            }
            else
            {
                ShowList();
            }
        }
    }

    // ═══════════════════════════════════════════
    //  SHOW LIST VIEW
    // ═══════════════════════════════════════════
    void ShowList()
    {
        pnlList.Visible   = true;
        pnlDetail.Visible = false;
        btnBackList.Visible = false;

        mycon();
        cmd = new SqlCommand(@"
            SELECT s.SwapRequestId, s.Userid, s.EducationId, s.EducationLevelId,
                   s.Semester, s.PhotoFront, s.OriganalTotalAmount, s.SecondTotalAmount,
                   s.SwapStatus, s.EntryDate,
                   ISNULL(e.Education, '-')      AS EducationName,
                   ISNULL(el.EducationLevel, '-') AS LevelName
            FROM   SwapRequestTbl s
            LEFT JOIN EducationTbl     e  ON e.EducationId      = s.EducationId
            LEFT JOIN EducationLvelTbl el ON el.EducationLevelId = s.EducationLevelId
            WHERE  s.Userid = @uid
            ORDER  BY s.EntryDate DESC", con);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());

        da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        con.Close();

        if (dt.Rows.Count > 0)
        {
            pnlEmpty.Visible      = false;
            rptBooks.DataSource   = dt;
            rptBooks.DataBind();
        }
        else
        {
            pnlEmpty.Visible    = true;
            rptBooks.DataSource = null;
            rptBooks.DataBind();
        }
    }

    // ═══════════════════════════════════════════
    //  REPEATER (BOOKS) — ItemDataBound
    // ═══════════════════════════════════════════
    protected void rptBooks_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;

        // Photo
        Image imgCard   = (Image)e.Item.FindControl("imgCard");
        HtmlGenericControl ph = (HtmlGenericControl)e.Item.FindControl("divCardPh");
        string front = row["PhotoFront"] == DBNull.Value ? "" : row["PhotoFront"].ToString().Trim();
        if (!string.IsNullOrEmpty(front)) { imgCard.ImageUrl = front; imgCard.Visible = true; ph.Visible = false; }
        else                              { imgCard.Visible = false; ph.Visible = true; }

        // Status badge
        Label lblStatus = (Label)e.Item.FindControl("lblStatus");
        byte status = row["SwapStatus"] == DBNull.Value ? (byte)0 : Convert.ToByte(row["SwapStatus"]);
        switch (status)
        {
            case 1:  lblStatus.Text = "<span class='s-approved'>Approved</span>"; break;
            case 2:  lblStatus.Text = "<span class='s-denied'>Denied</span>"; break;
            default: lblStatus.Text = "<span class='s-pending'>Pending</span>"; break;
        }
    }

    // ═══════════════════════════════════════════
    //  BOOK REPEATER ItemCommand → View Inquiries
    // ═══════════════════════════════════════════
    protected void rptBooks_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            int swapId = Convert.ToInt32(e.CommandArgument);
            ShowDetail(swapId);
        }
    }

    // ═══════════════════════════════════════════
    //  SHOW DETAIL VIEW
    // ═══════════════════════════════════════════
    void ShowDetail(int swapRequestId)
    {
        pnlList.Visible     = false;
        pnlDetail.Visible   = true;
        btnBackList.Visible = true;

        hfViewId.Value = swapRequestId.ToString();

        // ── Book detail ──────────────────────────────
        mycon();
        cmd = new SqlCommand(@"
            SELECT s.*, ISNULL(e.Education,'-') AS EducationName, ISNULL(el.EducationLevel,'-') AS LevelName
            FROM   SwapRequestTbl s
            LEFT JOIN EducationTbl     e  ON e.EducationId      = s.EducationId
            LEFT JOIN EducationLvelTbl el ON el.EducationLevelId = s.EducationLevelId
            WHERE  s.SwapRequestId = @sid AND s.Userid = @uid", con);
        cmd.Parameters.AddWithValue("@sid", swapRequestId);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());

        da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        con.Close();

        if (dt.Rows.Count == 0) { ShowList(); return; }   // not owner, go back

        DataRow r = dt.Rows[0];

        // Title
        string edu   = r["EducationName"].ToString();
        string level = r["LevelName"].ToString();
        string sem   = r["Semester"] == DBNull.Value ? "" : "Semester " + r["Semester"].ToString();
        lblDetailTitle.Text = edu + (level != "-" ? " - " + level : "") + (sem != "" ? " (" + sem + ")" : "");
        lblDetailSem.Text   = sem != "" ? sem : "-";

        // Amounts
        lblDetailOrig.Text = r["OriganalTotalAmount"] == DBNull.Value ? "0.00" : Convert.ToDecimal(r["OriganalTotalAmount"]).ToString("N2");
        lblDetailSwap.Text = r["SecondTotalAmount"]   == DBNull.Value ? "0.00" : Convert.ToDecimal(r["SecondTotalAmount"]).ToString("N2");

        // Payment
        bool online = r["PaymentType"] != DBNull.Value && Convert.ToBoolean(r["PaymentType"]);
        lblDetailPay.Text = online ? "Online" : "Cash";

        // Date
        lblDetailDate.Text = r["EntryDate"] != DBNull.Value
            ? Convert.ToDateTime(r["EntryDate"]).ToString("dd MMM yyyy")
            : "-";

        // Status badge
        byte status = r["SwapStatus"] == DBNull.Value ? (byte)0 : Convert.ToByte(r["SwapStatus"]);
        spanStatus.InnerText = status == 1 ? "Approved" : status == 2 ? "Denied" : "Pending";
        spanStatus.Attributes["class"] = status == 1 ? "s-approved" : status == 2 ? "s-denied" : "s-pending";

        // Photo
        string front = r["PhotoFront"] == DBNull.Value ? "" : r["PhotoFront"].ToString().Trim();
        if (!string.IsNullOrEmpty(front)) { imgDetail.ImageUrl = front; imgDetail.Visible = true; pnlDetailPh.Visible = false; }
        else                              { imgDetail.Visible = false; pnlDetailPh.Visible = true; }

        // ── Set JS hidden fields ──────────────────────────────────────
        // Notification threshold: last message time for this swap request
        hfDetailLastTs.Value = GetLatestMessageTs(swapRequestId);
        // Re-open active chat panel after postback
        hfActiveSender.Value = activeSenderId;

        // ── Interested users who have chatted ──
        LoadInterestedUsers(swapRequestId);
    }

    // ═══════════════════════════════════════════
    //  LOAD INTERESTED USERS
    // ═══════════════════════════════════════════
    void LoadInterestedUsers(int swapRequestId)
    {
        mycon();
        cmd = new SqlCommand(@"
            SELECT   c.SenderId,
                     ISNULL(u.Name,'Unknown') AS SenderName,
                     COUNT(*)                  AS MsgCount,
                     MAX(c.SentAt)             AS LastMsg
            FROM     SwapChatTbl c
            LEFT JOIN UserTbl u ON u.UserID = c.SenderId
            WHERE    c.SwapRequestId = @sid
              AND    c.SenderId      <> @uid
            GROUP BY c.SenderId, u.Name
            ORDER BY MAX(c.SentAt) DESC", con);
        cmd.Parameters.AddWithValue("@sid", swapRequestId);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());

        da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        con.Close();

        if (dt.Rows.Count > 0)
        {
            pnlNoUsers.Visible    = false;
            rptUsers.DataSource   = dt;
            rptUsers.DataBind();
        }
        else
        {
            pnlNoUsers.Visible  = true;
            rptUsers.DataSource = null;
            rptUsers.DataBind();
        }
    }

    // ═══════════════════════════════════════════
    //  USER REPEATER — ItemDataBound (load chat messages)
    // ═══════════════════════════════════════════
    protected void rptUsers_UserDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        int senderId    = Convert.ToInt32(row["SenderId"]);
        int swapId      = Convert.ToInt32(hfViewId.Value);
        int myId        = Convert.ToInt32(Session["User"].ToString());

        // If this is the active sender, keep chat panel open
        HtmlGenericControl panel = null; // we handle open state via CSS class in JS
        // (the panel toggling is done client-side via JS toggleChat())

        // Load message thread for this user
        mycon();
        cmd = new SqlCommand(@"
            SELECT m.MessageId, m.SenderId, m.Message, m.SentAt,
                   ISNULL(u.Name,'Unknown') AS SenderName
            FROM   SwapChatTbl m
            LEFT JOIN UserTbl u ON u.UserID = m.SenderId
            WHERE  m.SwapRequestId = @sid
              AND (m.SenderId = @uid OR m.SenderId = @myId)
            ORDER BY m.SentAt ASC", con);
        cmd.Parameters.AddWithValue("@sid", swapId);
        cmd.Parameters.AddWithValue("@uid", senderId);
        cmd.Parameters.AddWithValue("@myId", myId);

        da = new SqlDataAdapter(cmd);
        DataTable msgs = new DataTable();
        da.Fill(msgs);
        con.Close();

        Repeater rptMsgs    = (Repeater)e.Item.FindControl("rptMsgs");
        Panel   pnlMsgEmpty = (Panel)e.Item.FindControl("pnlMsgEmpty");

        if (msgs.Rows.Count > 0)
        {
            pnlMsgEmpty.Visible   = false;
            rptMsgs.DataSource    = msgs;
            rptMsgs.DataBind();
        }
        else
        {
            pnlMsgEmpty.Visible = true;
            rptMsgs.DataSource  = null;
            rptMsgs.DataBind();
        }

        // Mark active (open) chat after reply postback
        if (!string.IsNullOrEmpty(activeSenderId) && activeSenderId == senderId.ToString())
        {
            // inject 'open' class via the LinkButton callback below
            LinkButton btnChat = (LinkButton)e.Item.FindControl("btnChat");
            if (btnChat != null)
                btnChat.OnClientClick = "toggleChat('" + senderId + "'); return false;";
        }
        else
        {
            LinkButton btnChat = (LinkButton)e.Item.FindControl("btnChat");
            if (btnChat != null)
                btnChat.OnClientClick = "toggleChat('" + senderId + "'); return false;";
        }
    }

    // ═══════════════════════════════════════════
    //  USER REPEATER — ItemCommand (Reply / OpenChat)
    // ═══════════════════════════════════════════
    protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Reply")
        {
            TextBox txtMsg = (TextBox)e.Item.FindControl("txtChatMsg");
            string msg = txtMsg != null ? txtMsg.Text.Trim() : "";
            if (string.IsNullOrEmpty(msg)) goto Refresh;

            int toUserId = Convert.ToInt32(e.CommandArgument);
            int swapId   = Convert.ToInt32(hfViewId.Value);

            mycon();
            cmd = new SqlCommand(@"
                INSERT INTO SwapChatTbl (SwapRequestId, SenderId, Message, SentAt)
                VALUES (@sid, @uid, @msg, GETDATE())", con);
            cmd.Parameters.AddWithValue("@sid", swapId);
            cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
            cmd.Parameters.AddWithValue("@msg", msg);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();

            activeSenderId = toUserId.ToString();   // keep chat panel open
        }

        Refresh:
        // Re-render detail view
        int sid = Convert.ToInt32(hfViewId.Value);
        ShowDetail(sid);
    }

    // ═══════════════════════════════════════════
    //  MESSAGE BUBBLE — ItemDataBound
    // ═══════════════════════════════════════════
    protected void rptMsgs_BubbleBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        int myId     = Convert.ToInt32(Session["User"].ToString());
        int senderId = row["SenderId"] == DBNull.Value ? 0 : Convert.ToInt32(row["SenderId"]);
        string msg   = row["Message"]  == DBNull.Value ? "" : row["Message"].ToString();
        string name  = row["SenderName"].ToString();

        bool isMine = senderId == myId;

        Panel pnlBubble    = (Panel)e.Item.FindControl("pnlBubble");
        Label lblBubbleMsg = (Label)e.Item.FindControl("lblBubbleMsg");
        Label lblSender    = (Label)e.Item.FindControl("lblBubbleSender");

        pnlBubble.CssClass = "bubble " + (isMine ? "mine" : "theirs");
        lblSender.Text     = HttpUtility.HtmlEncode(name);

        // Render BOOK_OFFER tokens as styled cards with Accept Offer button
        if (msg.StartsWith("[BOOK_OFFER:") && msg.EndsWith("]"))
        {
            string inner = msg.Substring(12, msg.Length - 13);
            string[] parts = inner.Split(new string[] { "|||" }, StringSplitOptions.None);
            string bookId = parts.Length > 0 ? parts[0] : "";
            string title  = parts.Length > 1 ? HttpUtility.HtmlEncode(parts[1]) : "Book";
            string price  = parts.Length > 2 ? HttpUtility.HtmlEncode(parts[2]) : "0.00";
            string photo  = parts.Length > 3 ? parts[3] : "";

            // Resolve "~/icon/..." → "/icon/..." so browser <img src> works
            if (photo.StartsWith("~/")) photo = "/" + photo.Substring(2);
            string imgHtml = !string.IsNullOrEmpty(photo)
                ? "<img src='" + HttpUtility.HtmlEncode(photo) + "' class='oc-img' alt='Book' />"
                : "<div class='oc-img-ph'>&#128218;</div>";

            // In SwaprequestList the viewer IS ALWAYS the book owner → show Accept button
            // Get deal status so we don't show Accept if already locked / already accepted
            int swapReqId = 0;
            int.TryParse(hfViewId.Value, out swapReqId);
            string dealStatus = GetDealStatusOwner(swapReqId, bookId);

            string actionHtml;
            if (dealStatus == "locked")
            {
                actionHtml = "<div class='deal-locked-tag'>&#128274; Deal Locked!</div>";
            }
            else if (dealStatus == "owner_accepted")
            {
                actionHtml = "<div class='deal-waiting'>&#10003; You accepted &mdash; waiting for requester to confirm.</div>";
            }
            else
            {
                // Show Accept Offer button (owner hasn't accepted yet)
                actionHtml =
                    "<button class='btn btn-success btn-sm oc-accept' " +
                    "onclick=\"acceptOffer('" + HttpUtility.HtmlEncode(bookId) + "','" + swapReqId + "',this)\">" +
                    "&#10003; Accept Offer</button>";
            }

            lblBubbleMsg.Text =
                "<div class='offer-card' data-offered-swap='" + HttpUtility.HtmlEncode(bookId) +
                "' data-swap='" + swapReqId + "' data-status='" + dealStatus + "'>" +
                "<div class='oc-header'>BOOK OFFER</div>" +
                imgHtml +
                "<div class='oc-title'>" + title + "</div>" +
                "<div class='oc-price'>Swap Price: &#8377;" + price + "</div>" +
                actionHtml +
                "</div>";
        }
        else if (msg.StartsWith("[DEAL_LOCKED:") && msg.EndsWith("]"))
        {
            pnlBubble.CssClass = "bubble system-msg";
            lblSender.Text     = "";
            lblBubbleMsg.Text  =
                "<div class='deal-locked-banner'>&#128274; <strong>Deal Locked!</strong> " +
                "Both parties have agreed. The books are now reserved.</div>";
        }
        else
        {
            lblBubbleMsg.Text = HttpUtility.HtmlEncode(msg);
        }
    }

    // ═══════════════════════════════════════════
    //  GET DEAL STATUS (owner's perspective)
    // ═══════════════════════════════════════════
    string GetDealStatusOwner(int swapId, string offeredSwapIdStr)
    {
        int offeredSwapId;
        if (!int.TryParse(offeredSwapIdStr, out offeredSwapId)) return "pending";
        try
        {
            using (var c = new SqlConnection(
                ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString))
            {
                c.Open();
                using (var cmd2 = new SqlCommand(
                    "SELECT IsLocked, OwnerAccepted FROM SwapDealTbl " +
                    "WHERE SwapRequestId=@sid AND OfferedSwapId=@osid", c))
                {
                    cmd2.Parameters.AddWithValue("@sid",  swapId);
                    cmd2.Parameters.AddWithValue("@osid", offeredSwapId);
                    using (var r = cmd2.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            if (Convert.ToBoolean(r["IsLocked"]))     return "locked";
                            if (Convert.ToBoolean(r["OwnerAccepted"])) return "owner_accepted";
                            return "requester_accepted";
                        }
                    }
                }
            }
        }
        catch { /* SwapDealTbl may not exist yet */ }
        return "pending";
    }

    // ═══════════════════════════════════════════
    //  GET LATEST MESSAGE TIMESTAMP (for JS threshold)
    // ═══════════════════════════════════════════
    string GetLatestMessageTs(int swapId)
    {
        string result = "";
        try
        {
            using (var c = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString()))
            {
                c.Open();
                using (var cmd2 = new SqlCommand(
                    "SELECT TOP 1 CONVERT(varchar(23), SentAt, 126) AS Ts " +
                    "FROM SwapChatTbl WHERE SwapRequestId = @sid ORDER BY SentAt DESC", c))
                {
                    cmd2.Parameters.AddWithValue("@sid", swapId);
                    var obj = cmd2.ExecuteScalar();
                    if (obj != null && obj != DBNull.Value) result = obj.ToString();
                }
            }
        }
        catch { }
        return result;
    }

    // ═══════════════════════════════════════════
    //  BACK TO LIST button
    // ═══════════════════════════════════════════
    protected void btnBackList_Click(object sender, EventArgs e)
    {
        ShowList();
    }
}