using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_BookExchange : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;
    DataSet ds;

    int swapRequestId = 0;

    void mycon()
    {
        con = new SqlConnection(ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ToString());
        con.Open();
    }

    // ── Page Load ────────────────────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        // On first load: read from query string and store in hidden field
        // On postback:   read from hidden field (query string is not re-sent)
        if (!IsPostBack)
        {
            if (Request.QueryString["id"] == null ||
                !int.TryParse(Request.QueryString["id"], out swapRequestId))
            {
                pnlNotFound.Visible = true;
                pnlMain.Visible     = false;
                return;
            }
            hfSwapId.Value = swapRequestId.ToString();
            // Pass user id to JS for isMine detection
            hfUserId.Value = Session["User"] != null ? Session["User"].ToString() : "";
            LoadBookDetail();
        }
        else
        {
            // Restore from hidden field on every postback
            if (!int.TryParse(hfSwapId.Value, out swapRequestId) || swapRequestId == 0)
            {
                pnlNotFound.Visible = true;
                pnlMain.Visible     = false;
                return;
            }
        }

        LoadChat();
        SetupChatPanel();
        // Set last-timestamp for JS polling cursor (ISO 8601)
        SetLastTimestamp();
    }

    // ── Load book details from SwapRequestTbl ─────────────────────────────────────
    void LoadBookDetail()
    {
        mycon();
        cmd = new SqlCommand(@"
            SELECT s.SwapRequestId, s.Userid, s.EducationId, s.EducationLevelId, s.Semester,
                   s.PhotoFront, s.PhotoEnd, s.OriganalTotalAmount, s.SecondTotalAmount,
                   s.Discription, s.PaymentType, s.EntryDate,
                   e.Education,
                   el.EducationLevel,
                   ISNULL(u.Name, 'Book Owner') AS OwnerName
            FROM   SwapRequestTbl s
            LEFT JOIN EducationTbl        e  ON e.EducationId      = s.EducationId
            LEFT JOIN EducationLvelTbl    el ON el.EducationLevelId = s.EducationLevelId
            LEFT JOIN UserTbl             u  ON u.UserID            = s.Userid
            WHERE  s.SwapRequestId = @sid AND s.SwapStatus = 1", con);
        cmd.Parameters.AddWithValue("@sid", swapRequestId);

        da = new SqlDataAdapter(cmd);
        ds = new DataSet();
        da.Fill(ds);
        con.Close();

        if (ds.Tables[0].Rows.Count == 0)
        {
            pnlNotFound.Visible = true;
            pnlMain.Visible = false;
            return;
        }

        pnlMain.Visible = true;
        pnlNotFound.Visible = false;

        DataRow r = ds.Tables[0].Rows[0];

        // Request ID & title
        lblReqId.Text    = r["SwapRequestId"].ToString();
        litRetId.Text    = swapRequestId.ToString();

        // Build a title from Education + Level + Semester
        string edu   = r["Education"]     == DBNull.Value ? "" : r["Education"].ToString();
        string level = r["EducationLevel"] == DBNull.Value ? "" : r["EducationLevel"].ToString();
        string sem   = r["Semester"]       == DBNull.Value ? "" : "Sem " + r["Semester"].ToString();
        lblTitle.Text = (edu + (level != "" ? " - " + level : "") + (sem != "" ? " (" + sem + ")" : "")).Trim('-', ' ');

        // Education / Level / Semester labels
        lblEducation.Text = edu  != "" ? edu  : "-";
        lblLevel.Text     = level != "" ? level : "-";
        lblSemester.Text  = r["Semester"] == DBNull.Value ? "-" : "Semester " + r["Semester"].ToString();

        // Payment
        bool isOnline = r["PaymentType"] != DBNull.Value && Convert.ToBoolean(r["PaymentType"]);
        lblPayment.Text = isOnline ? "Online" : "Cash";

        // Date
        lblDate.Text = r["EntryDate"] != DBNull.Value
            ? Convert.ToDateTime(r["EntryDate"]).ToString("dd MMM yyyy")
            : "-";

        // Amounts
        decimal origAmt = r["OriganalTotalAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["OriganalTotalAmount"]);
        decimal swapAmt = r["SecondTotalAmount"]   == DBNull.Value ? 0 : Convert.ToDecimal(r["SecondTotalAmount"]);
        lblOrigAmt.Text = origAmt.ToString("N2");
        lblSwapAmt.Text = swapAmt.ToString("N2");

        // Description
        string desc = r["Discription"] == DBNull.Value ? "" : r["Discription"].ToString();
        if (!string.IsNullOrEmpty(desc))
        {
            lblDesc.Text    = HttpUtility.HtmlEncode(desc);
            pnlDesc.Visible = true;
        }
        else
        {
            pnlDesc.Visible = false;
        }

        // Owner name
        lblOwnerName.Text = "Owner: " + r["OwnerName"].ToString();

        // Hero / front photo
        string front = r["PhotoFront"] == DBNull.Value ? "" : r["PhotoFront"].ToString().Trim();
        string back  = r["PhotoEnd"]   == DBNull.Value ? "" : r["PhotoEnd"].ToString().Trim();

        if (!string.IsNullOrEmpty(front))
        {
            imgHero.ImageUrl          = front;
            imgHero.Visible           = true;
            pnlHeroPlaceholder.Visible = false;

            imgThumb1.ImageUrl = front;
            imgThumb1.Visible  = true;
        }
        else
        {
            imgHero.Visible           = false;
            pnlHeroPlaceholder.Visible = true;
        }

        if (!string.IsNullOrEmpty(back))
        {
            imgThumb2.ImageUrl = back;
            imgThumb2.Visible  = true;
        }
    }

    // ── Show/hide chat input based on login ───────────────────────────────────────
    void SetupChatPanel()
    {
        bool loggedIn = Session["User"] != null;
        pnlChatInput.Visible      = loggedIn;
        pnlChatLoginNotice.Visible = !loggedIn;
        pnlCTALogin.Visible       = !loggedIn;
        pnlCTALoggedIn.Visible    = loggedIn;
    }

    // ── Load chat messages (E2E: only between me and the book owner) ─────────────
    void LoadChat()
    {
        int myId    = Session["User"] != null ? Convert.ToInt32(Session["User"].ToString()) : 0;
        int ownerId = GetSwapOwner(swapRequestId);   // book owner

        mycon();
        cmd = new SqlCommand(@"
            SELECT m.MessageId, m.SenderId, m.Message, m.SentAt,
                   ISNULL(u.Name, 'User') AS SenderName
            FROM   SwapChatTbl m
            LEFT JOIN UserTbl u ON u.UserID = m.SenderId
            WHERE  m.SwapRequestId = @sid
              AND  (m.SenderId = @myId OR m.SenderId = @ownerId)
            ORDER  BY m.SentAt ASC", con);
        cmd.Parameters.AddWithValue("@sid",     swapRequestId);
        cmd.Parameters.AddWithValue("@myId",    myId    > 0 ? (object)myId    : DBNull.Value);
        cmd.Parameters.AddWithValue("@ownerId", ownerId > 0 ? (object)ownerId : DBNull.Value);

        da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        con.Close();

        if (dt.Rows.Count > 0)
        {
            rptChat.DataSource = dt;
            rptChat.DataBind();
            pnlChatEmpty.Visible = false;
        }
        else
        {
            rptChat.DataSource = null;
            rptChat.DataBind();
            pnlChatEmpty.Visible = true;
        }
    }

    // ── Set hfLastTs so JS poll cursor starts AFTER server-rendered messages ──────
    void SetLastTimestamp()
    {
        if (swapRequestId == 0) return;
        mycon();
        cmd = new SqlCommand(
            "SELECT TOP 1 CONVERT(varchar(30), SentAt, 127) AS Ts FROM SwapChatTbl " +
            "WHERE SwapRequestId = @sid ORDER BY SentAt DESC", con);
        cmd.Parameters.AddWithValue("@sid", swapRequestId);
        object result = cmd.ExecuteScalar();
        cmd.Dispose();
        con.Close();
        if (result != null && result != DBNull.Value)
            hfLastTs.Value = result.ToString();
    }

    // ── Repeater ItemDataBound: style bubbles; render offer / locked cards ──────
    protected void rptChat_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        DataRowView row = (DataRowView)e.Item.DataItem;

        Panel pnlBubble = (Panel)e.Item.FindControl("pnlBubble");
        Label lblMsg    = (Label)e.Item.FindControl("lblMsg");
        Label lblSender = (Label)e.Item.FindControl("lblSender");

        int    senderId   = row["SenderId"]  == DBNull.Value ? 0 : Convert.ToInt32(row["SenderId"]);
        string msg        = row["Message"]   == DBNull.Value ? "" : row["Message"].ToString();
        string senderName = row["SenderName"].ToString();

        bool isMine = Session["User"] != null &&
                      senderId.ToString() == Session["User"].ToString();

        pnlBubble.CssClass = "bubble " + (isMine ? "sent" : "received");
        lblSender.Text = HttpUtility.HtmlEncode(senderName);

        // ── DEAL_LOCKED system message ──────────────────────────────────────
        if (msg.StartsWith("[DEAL_LOCKED:") && msg.EndsWith("]"))
        {
            pnlBubble.CssClass = "bubble system-msg";
            lblSender.Text     = "";
            lblMsg.Text = "<div class='deal-locked-banner'>" +
                          "&#128274; <strong>Deal Locked!</strong> Both parties have agreed. The books are now reserved." +
                          "</div>";
            return;
        }

        // ── BOOK_OFFER card rendering ───────────────────────────────────────
        if (msg.StartsWith("[BOOK_OFFER:") && msg.EndsWith("]"))
        {
            string inner = msg.Substring(12, msg.Length - 13);
            string[] parts = inner.Split(new string[] { "|||" }, StringSplitOptions.None);
            string bookId = parts.Length > 0 ? parts[0] : "";
            string title  = parts.Length > 1 ? HttpUtility.HtmlEncode(parts[1]) : "Book";
            string price  = parts.Length > 2 ? HttpUtility.HtmlEncode(parts[2]) : "0.00";
            string photo  = parts.Length > 3 ? parts[3] : "";

            // Get deal status from DB
            string dealStatus = GetDealStatus(swapRequestId, bookId);
            int myId = Session["User"] != null ? Convert.ToInt32(Session["User"].ToString()) : 0;
            int ownerId = GetSwapOwner(swapRequestId);
            bool isOwner = myId == ownerId;

            // Resolve "~/icon/..." → "/icon/..." so browser <img src> works
            if (photo.StartsWith("~/")) photo = "/" + photo.Substring(2);
            string imgHtml = !string.IsNullOrEmpty(photo)
                ? "<img src='" + HttpUtility.HtmlEncode(photo) + "' class='oc-img' alt='Book'/>"
                : "<div class='oc-img-ph'>&#128218;</div>";

            string actionHtml;
            if (dealStatus == "locked")
                actionHtml = "<div class='deal-locked-tag'>&#128274; Deal Locked!</div>";
            else if (isOwner && dealStatus != "owner_accepted")
                actionHtml = "<button class='btn btn-success btn-sm oc-accept' " +
                             "onclick=\"acceptOffer('" + HttpUtility.HtmlEncode(bookId) + "','" + swapRequestId + "',this)\">" +
                             "&#10003; Accept Offer</button>";
            else if (!isOwner && isMine)
                actionHtml = "<div class='deal-waiting'>&#9203; Awaiting owner acceptance...</div>";
            else
                actionHtml = "<a href='BookExchange.aspx?id=" + HttpUtility.HtmlEncode(bookId) + "' class='btn btn-sm btn-outline-primary view-btn'>View Details</a>";

            lblMsg.Text =
                "<div class='offer-card' data-offered-swap='" + HttpUtility.HtmlEncode(bookId) + "' data-swap='" + swapRequestId + "' data-status='" + dealStatus + "'>" +
                "<div class='oc-header'>BOOK OFFER</div>" +
                imgHtml +
                "<div class='oc-title'>" + title + "</div>" +
                "<div class='oc-price'>Swap Price: &#8377;" + price + "</div>" +
                actionHtml +
                "</div>";
            return;
        }

        // ── Plain message ───────────────────────────────────────────────────
        lblMsg.Text = HttpUtility.HtmlEncode(msg);
    }

    // ── Get deal status from SwapDealTbl ─────────────────────────────────────────
    string GetDealStatus(int targetSwapId, string offeredSwapIdStr)
    {
        int offeredSwapId;
        if (!int.TryParse(offeredSwapIdStr, out offeredSwapId)) return "pending";
        try
        {
            mycon();
            cmd = new SqlCommand(
                "SELECT IsLocked, OwnerAccepted, RequesterAccepted FROM SwapDealTbl " +
                "WHERE SwapRequestId=@sid AND OfferedSwapId=@osid", con);
            cmd.Parameters.AddWithValue("@sid",  targetSwapId);
            cmd.Parameters.AddWithValue("@osid", offeredSwapId);
            using (var rdr = cmd.ExecuteReader())
            {
                if (rdr.Read())
                {
                    if (Convert.ToBoolean(rdr["IsLocked"]))       return "locked";
                    if (Convert.ToBoolean(rdr["OwnerAccepted"]))  return "owner_accepted";
                    return "requester_accepted";
                }
            }
            con.Close();
        }
        catch { try { con.Close(); } catch { } }
        return "pending";
    }

    // ── Get the owner userId of a swap request ───────────────────────────────────
    int GetSwapOwner(int swapId)
    {
        try
        {
            mycon();
            cmd = new SqlCommand("SELECT Userid FROM SwapRequestTbl WHERE SwapRequestId=@sid", con);
            cmd.Parameters.AddWithValue("@sid", swapId);
            object obj = cmd.ExecuteScalar();
            con.Close();
            return obj != null && obj != DBNull.Value ? Convert.ToInt32(obj) : 0;
        }
        catch { try { con.Close(); } catch { } return 0; }
    }


    // ── Send message ─────────────────────────────────────────────────────────────────
    protected void btnSend_Click(object sender, EventArgs e)
    {
        if (Session["User"] == null) return;

        string msg = txtMsg.Text.Trim();
        if (string.IsNullOrEmpty(msg)) return;

        int sid = 0;
        if (!int.TryParse(hfSwapId.Value, out sid)) return;

        mycon();
        cmd = new SqlCommand(@"
            INSERT INTO SwapChatTbl (SwapRequestId, SenderId, Message, SentAt)
            VALUES (@sid, @uid, @msg, GETDATE())", con);
        cmd.Parameters.AddWithValue("@sid", sid);
        cmd.Parameters.AddWithValue("@uid", Session["User"].ToString());
        cmd.Parameters.AddWithValue("@msg", msg);
        cmd.ExecuteNonQuery();
        cmd.Dispose();

        // ── When a BOOK_OFFER is sent, auto-create a SwapDealTbl record ────
        if (msg.StartsWith("[BOOK_OFFER:") && msg.EndsWith("]"))
        {
            string inner = msg.Substring(12, msg.Length - 13);
            string[] parts = inner.Split(new string[] { "|||" }, StringSplitOptions.None);
            int offeredSwapId;
            if (parts.Length > 0 && int.TryParse(parts[0], out offeredSwapId))
            {
                int myId = Convert.ToInt32(Session["User"].ToString());
                // Get the owner of the target book
                cmd = new SqlCommand("SELECT Userid FROM SwapRequestTbl WHERE SwapRequestId=@sid", con);
                cmd.Parameters.AddWithValue("@sid", sid);
                object ownerObj = cmd.ExecuteScalar();
                if (ownerObj != null && ownerObj != DBNull.Value)
                {
                    int ownerId = Convert.ToInt32(ownerObj);
                    cmd = new SqlCommand(@"
                        IF NOT EXISTS (
                            SELECT 1 FROM SwapDealTbl
                            WHERE SwapRequestId=@sid AND OfferedSwapId=@osid AND RequesterId=@rid)
                        INSERT INTO SwapDealTbl
                            (SwapRequestId, OfferedSwapId, RequesterId, OwnerId)
                        VALUES (@sid, @osid, @rid, @oid)", con);
                    cmd.Parameters.AddWithValue("@sid",  sid);
                    cmd.Parameters.AddWithValue("@osid", offeredSwapId);
                    cmd.Parameters.AddWithValue("@rid",  myId);
                    cmd.Parameters.AddWithValue("@oid",  ownerId);
                    cmd.ExecuteNonQuery();
                }
                cmd.Dispose();
            }
        }

        con.Close();
        txtMsg.Text = "";
        LoadChat();
    }
}
