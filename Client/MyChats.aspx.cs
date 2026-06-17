using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_MyChats : System.Web.UI.Page
{
    // ── Exposed to JS as NOTIF_TS threshold ─────────────────────────────────
    protected long notifThresholdMs = -1;

    // ── Page Load ────────────────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
        {
            pnlLogin.Visible = true;
            pnlList.Visible  = false;
            pnlEmpty.Visible = false;
            return;
        }

        if (!IsPostBack)
        {
            LoadConversations();
        }
        else
        {
            // Restore active panel state on postback
            LoadConversations();
        }

        // Set notification threshold from the latest message across all my chats
        SetNotifThreshold();
    }

    // ── Load all books the logged-in user has chatted about (as interested user) ──
    void LoadConversations()
    {
        int myId = Convert.ToInt32(Session["User"].ToString());
        string conn = ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString;

        using (var con = new SqlConnection(conn))
        {
            con.Open();
            // Get all swap requests where I have sent messages, that I don't own
            using (var cmd = new SqlCommand(@"
                SELECT  s.SwapRequestId,
                        s.Userid AS OwnerId,
                        ISNULL(u.Name,'Book Owner')      AS OwnerName,
                        ISNULL(e.Education,'')            AS Education,
                        ISNULL(el.EducationLevel,'')      AS EducationLevel,
                        ISNULL(s.Semester,'')             AS Semester,
                        ISNULL(s.PhotoFront,'')           AS PhotoFront,
                        COUNT(m.MessageId)                AS MsgCount,
                        MAX(m.SentAt)                     AS LastMessageAt,
                        (SELECT TOP 1 Message FROM SwapChatTbl
                         WHERE SwapRequestId = s.SwapRequestId
                         ORDER BY SentAt DESC)            AS LastMsg
                FROM   SwapChatTbl m
                JOIN   SwapRequestTbl s  ON s.SwapRequestId = m.SwapRequestId
                LEFT JOIN UserTbl     u  ON u.UserID         = s.Userid
                LEFT JOIN EducationTbl   e  ON e.EducationId = s.EducationId
                LEFT JOIN EducationLvelTbl el ON el.EducationLevelId = s.EducationLevelId
                WHERE  m.SenderId = @uid
                  AND  s.Userid  <> @uid
                GROUP BY s.SwapRequestId, s.Userid, u.Name,
                         e.Education, el.EducationLevel, s.Semester, s.PhotoFront
                ORDER BY MAX(m.SentAt) DESC", con))
            {
                cmd.Parameters.AddWithValue("@uid", myId);
                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptConv.DataSource = dt;
                    rptConv.DataBind();
                    pnlEmpty.Visible = false;
                    pnlList.Visible  = true;
                }
                else
                {
                    pnlEmpty.Visible = true;
                    pnlList.Visible  = false;
                }
            }
        }
    }

    // ── Set JS notification threshold ────────────────────────────────────────
    void SetNotifThreshold()
    {
        int myId = Convert.ToInt32(Session["User"].ToString());
        try
        {
            string conn = ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString;
            using (var con = new SqlConnection(conn))
            {
                con.Open();
                using (var cmd = new SqlCommand(
                    "SELECT TOP 1 SentAt FROM SwapChatTbl m " +
                    "JOIN SwapRequestTbl s ON s.SwapRequestId = m.SwapRequestId " +
                    "WHERE m.SenderId <> @uid AND s.Userid <> @uid " +
                    "ORDER BY SentAt DESC", con))
                {
                    cmd.Parameters.AddWithValue("@uid", myId);
                    var obj = cmd.ExecuteScalar();
                    if (obj != null && obj != DBNull.Value)
                    {
                        var ts = Convert.ToDateTime(obj);
                        notifThresholdMs = (long)(ts - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;
                    }
                }
            }
        }
        catch { }
    }

    // ── Repeater ItemDataBound: wire up each conversation ────────────────────
    protected void rptConv_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;

        int    myId       = Convert.ToInt32(Session["User"].ToString());
        int    swapId     = Convert.ToInt32(row["SwapRequestId"]);
        string ownerName  = row["OwnerName"].ToString();
        string edu        = row["Education"].ToString();
        string level      = row["EducationLevel"].ToString();
        string sem        = row["Semester"].ToString();
        int    msgCount   = Convert.ToInt32(row["MsgCount"]);
        string lastMsg    = row["LastMsg"] == DBNull.Value ? "" : row["LastMsg"].ToString();

        // Build book title
        string title = edu;
        if (!string.IsNullOrEmpty(level)) title += " - " + level;
        if (!string.IsNullOrEmpty(sem))   title += " (Sem " + sem + ")";
        if (string.IsNullOrEmpty(title))  title = "Book #" + swapId;

        // Last message time
        string lastTime = "";
        if (row["LastMessageAt"] != DBNull.Value)
        {
            var dt = Convert.ToDateTime(row["LastMessageAt"]);
            lastTime = dt.ToString("dd MMM, h:mm tt");
        }

        // Avatar letter
        Label lblAvatar    = (Label)e.Item.FindControl("lblAvatar");
        Label lblBookTitle = (Label)e.Item.FindControl("lblBookTitle");
        Label lblOwnerName = (Label)e.Item.FindControl("lblOwnerName");
        Label lblMeta      = (Label)e.Item.FindControl("lblMeta");
        Label lblPanelOwner= (Label)e.Item.FindControl("lblPanelOwner");

        lblAvatar.Text     = ownerName.Length > 0 ? ownerName.Substring(0,1).ToUpper() : "?";
        lblBookTitle.Text  = HttpUtility.HtmlEncode(title);
        lblOwnerName.Text  = HttpUtility.HtmlEncode(ownerName);
        lblMeta.Text       = msgCount + " message(s) &bull; Last: " + lastTime;
        lblPanelOwner.Text = HttpUtility.HtmlEncode(ownerName);

        // Load messages into inner repeater
        Repeater rptMsgs = (Repeater)e.Item.FindControl("rptMsgs");
        LoadMessages(swapId, rptMsgs);
    }

    // ── Load messages for a specific swap request ─────────────────────────────
    void LoadMessages(int swapId, Repeater rptMsgs)
    {
        int myId = Convert.ToInt32(Session["User"].ToString());
        try
        {
            string conn = ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString;
            using (var con = new SqlConnection(conn))
            {
                con.Open();

                // Get book owner ID first (for E2E filter)
                int ownerId = 0;
                using (var ownerCmd = new SqlCommand("SELECT Userid FROM SwapRequestTbl WHERE SwapRequestId=@sid", con))
                {
                    ownerCmd.Parameters.AddWithValue("@sid", swapId);
                    var obj = ownerCmd.ExecuteScalar();
                    if (obj != null && obj != DBNull.Value) ownerId = Convert.ToInt32(obj);
                }

                using (var cmd = new SqlCommand(@"
                    SELECT m.MessageId, m.SenderId, m.Message, m.SentAt,
                           ISNULL(u.Name,'User') AS SenderName
                    FROM   SwapChatTbl m
                    LEFT JOIN UserTbl u ON u.UserID = m.SenderId
                    WHERE  m.SwapRequestId = @sid
                      AND  (m.SenderId = @myId OR m.SenderId = @ownerId)
                    ORDER  BY m.SentAt ASC", con))
                {
                    cmd.Parameters.AddWithValue("@sid",     swapId);
                    cmd.Parameters.AddWithValue("@myId",    myId    > 0 ? (object)myId    : DBNull.Value);
                    cmd.Parameters.AddWithValue("@ownerId", ownerId > 0 ? (object)ownerId : DBNull.Value);
                    var dt = new DataTable();
                    new SqlDataAdapter(cmd).Fill(dt);
                    rptMsgs.DataSource = dt;
                    rptMsgs.DataBind();
                }
            }
        }
        catch { }
    }

    // ── Message bubble ItemDataBound ──────────────────────────────────────────
    protected void rptMsgs_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row    = (DataRowView)e.Item.DataItem;
        int  myId          = Convert.ToInt32(Session["User"].ToString());
        int  senderId      = row["SenderId"] == DBNull.Value ? 0 : Convert.ToInt32(row["SenderId"]);
        string msg         = row["Message"]  == DBNull.Value ? "" : row["Message"].ToString();
        string senderName  = row["SenderName"].ToString();
        DateTime sentAt    = row["SentAt"]   == DBNull.Value ? DateTime.Now : Convert.ToDateTime(row["SentAt"]);
        bool isMine        = senderId == myId;

        Panel pnlBubble = (Panel)e.Item.FindControl("pnlBubble");
        Label lblMsg    = (Label)e.Item.FindControl("lblMsg");
        Label lblSender = (Label)e.Item.FindControl("lblSender");

        // System message
        if (msg.StartsWith("[DEAL_LOCKED:") && msg.EndsWith("]"))
        {
            pnlBubble.CssClass = "bubble system-msg";
            lblMsg.Text   = "<div class='deal-locked-banner'>&#128274; <strong>Deal Locked!</strong> Both parties agreed. Books are now reserved.</div>";
            lblSender.Text = "";
            return;
        }

        pnlBubble.CssClass = "bubble " + (isMine ? "mine" : "theirs");
        lblSender.Text = HttpUtility.HtmlEncode(senderName) + " &bull; " +
                         sentAt.ToString("h:mm tt, dd MMM");

        // Book offer card
        if (msg.StartsWith("[BOOK_OFFER:") && msg.EndsWith("]"))
        {
            string inner = msg.Substring(12, msg.Length - 13);
            string[] parts = inner.Split(new string[]{"|||"}, StringSplitOptions.None);
            string bookId = parts.Length > 0 ? parts[0] : "";
            string title  = parts.Length > 1 ? HttpUtility.HtmlEncode(parts[1]) : "Book";
            string price  = parts.Length > 2 ? HttpUtility.HtmlEncode(parts[2]) : "0.00";
            string photo  = parts.Length > 3 ? parts[3] : "";
            if (photo.StartsWith("~/")) photo = "/" + photo.Substring(2);

            string imgHtml = !string.IsNullOrEmpty(photo)
                ? "<img src='" + HttpUtility.HtmlEncode(photo) + "' class='oc-img' alt='Book'/>"
                : "<div class='oc-img-ph'>&#128218;</div>";

            // This page is the INTERESTED USER side, so isMine = I sent the offer
            string actionHtml = isMine
                ? "<div class='deal-waiting'>&#9203; Awaiting owner acceptance...</div>"
                : "<a href='BookExchange.aspx?id=" + HttpUtility.HtmlEncode(bookId) + "' class='btn btn-sm btn-outline-primary' style='font-size:11px;margin-top:8px;'>View Book</a>";

            lblMsg.Text =
                "<div class='offer-card'>" +
                "<div class='oc-header'>BOOK OFFER</div>" +
                imgHtml +
                "<div class='oc-title'>" + title + "</div>" +
                "<div class='oc-price'>Swap Price: &#8377;" + price + "</div>" +
                actionHtml + "</div>";
        }
        else
        {
            lblMsg.Text = HttpUtility.HtmlEncode(msg);
        }
    }
}
