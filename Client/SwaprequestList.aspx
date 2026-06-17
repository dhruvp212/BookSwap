<%@ Page Title="My Swap Requests" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="SwaprequestList.aspx.cs" Inherits="Client_SwaprequestList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
<div id="toastContainer"></div>
<style>
    /* ── Book cards ── */
    .swap-card {
        border: none; border-radius: 14px;
        box-shadow: 0 4px 18px rgba(0,0,0,.09);
        overflow: hidden; transition: transform .2s, box-shadow .2s;
        height: 100%;
    }
    .swap-card:hover { transform: translateY(-4px); box-shadow: 0 10px 28px rgba(0,0,0,.14); }
    .swap-card .card-img {
        width: 100%; height: 160px; object-fit: cover; display: block;
    }
    .swap-card .card-img-ph {
        width: 100%; height: 160px;
        background: linear-gradient(135deg,#1a1a2e,#0f3460);
        display: flex; align-items: center; justify-content: center;
        color: rgba(255,255,255,.3); font-size: 52px;
    }
    .swap-card .card-body { padding: 16px; }
    .swap-card .req-no { font-size: 11px; color: #6c757d; font-weight: 600; letter-spacing: 1px; }
    .swap-card .title  { font-size: 1rem; font-weight: 700; margin: 4px 0 8px; }
    .swap-card .price-row { display: flex; gap: 8px; }
    .swap-card .price-chip {
        flex: 1; text-align: center; background: #f8f9fa;
        border-radius: 8px; padding: 6px 8px;
    }
    .swap-card .price-chip .lbl { font-size: 10px; color: #6c757d; display: block; }
    .swap-card .price-chip .val { font-size: 14px; font-weight: 700; color: #0f3460; }
    .swap-card .card-footer-row {
        border-top: 1px solid #f0f0f0; padding: 10px 16px;
        display: flex; justify-content: space-between; align-items: center;
        background: #fff; font-size: 12px; color: #6c757d;
    }

    /* status badges */
    .s-pending  { background:#fff3cd; color:#856404; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:600; }
    .s-approved { background:#d4edda; color:#155724; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:600; }
    .s-denied   { background:#f8d7da; color:#721c24; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:600; }

    /* ── Detail view ── */
    .detail-layout { display: grid; grid-template-columns: 280px 1fr; gap: 24px; align-items: start; }
    @media(max-width:768px) { .detail-layout { grid-template-columns: 1fr; } }
    .detail-img { width: 100%; border-radius: 12px; object-fit: cover; height: 260px; }
    .detail-img-ph {
        width: 100%; height: 260px; border-radius: 12px;
        background: linear-gradient(135deg,#1a1a2e,#0f3460);
        display: flex; align-items: center; justify-content: center;
        color: rgba(255,255,255,.3); font-size: 70px;
    }
    .meta-row td { padding: 5px 0; font-size: 14px; }
    .meta-row td:first-child { color: #6c757d; width: 120px; font-weight: 500; }

    /* ── Interested users list ── */
    .section-title { font-size: 1rem; font-weight: 700; border-left: 4px solid #0f3460; padding-left: 10px; margin: 24px 0 14px; }
    .user-card {
        background: #fff; border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,.07);
        padding: 14px 16px; margin-bottom: 10px;
        display: flex; justify-content: space-between; align-items: center;
        transition: box-shadow .18s;
    }
    .user-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.13); }
    .user-card .avatar {
        width: 40px; height: 40px; border-radius: 50%;
        background: linear-gradient(135deg,#0f3460,#1a1a2e);
        color: #fff; display: flex; align-items: center;
        justify-content: center; font-weight: 700; font-size: 16px;
        flex-shrink: 0;
    }
    .user-card .user-info { flex: 1; margin-left: 12px; }
    .user-card .user-info .name  { font-weight: 600; font-size: 14px; }
    .user-card .user-info .meta  { font-size: 12px; color: #6c757d; }
    .user-card .last-msg { font-size: 12px; color: #6c757d; max-width: 200px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }

    /* ── Inline chat ── */
    .chat-panel {
        display: none; margin-top: 10px;
        border: 1px solid #e0e0e0; border-radius: 12px; overflow: hidden;
    }
    .chat-panel.open { display: block; }
    .chat-panel .chat-head {
        background: linear-gradient(135deg,#1a1a2e,#0f3460);
        color: #fff; padding: 12px 16px; font-weight: 600; font-size: 14px;
    }
    .chat-panel .chat-msgs {
        height: 240px; overflow-y: auto; padding: 12px;
        background: #f8f9fa; display: flex; flex-direction: column; gap: 8px;
    }
    .chat-panel .chat-msgs::-webkit-scrollbar { width: 3px; }
    .chat-panel .chat-msgs::-webkit-scrollbar-thumb { background: #ccc; border-radius: 3px; }
    .bubble { max-width: 70%; padding: 8px 12px; border-radius: 14px; font-size: 13px; word-break: break-word; }
    .bubble.mine     { align-self: flex-end;   background: #0f3460; color: #fff; border-bottom-right-radius:3px; }
    .bubble.theirs   { align-self: flex-start; background: #fff; color: #212529; border-bottom-left-radius:3px; box-shadow: 0 1px 4px rgba(0,0,0,.08); }
    .bubble .ts      { font-size: 10px; opacity: .6; margin-top: 3px; }
    .bubble.mine .ts { text-align: right; }
    .chat-empty-msg  { text-align: center; color: #adb5bd; font-size: 13px; margin: auto; }
    .chat-panel .chat-input {
        display: flex; border-top: 1px solid #e9ecef; background: #fff; padding: 10px;
    }
    .chat-panel .chat-input input {
        flex: 1; border: 1px solid #dee2e6; border-radius: 20px 0 0 20px;
        padding: 8px 14px; font-size: 13px; outline: none;
    }
    .chat-panel .chat-input button {
        border-radius: 0 20px 20px 0; padding: 8px 18px;
        background: #0f3460; color: #fff; border: none; font-size: 13px; cursor: pointer;
    }
    .chat-panel .chat-input button:hover { background: #16213e; }

    /* ── Offer card (used by server-side Repeater AND JS-created bubbles) ── */
    .offer-card { background:#f0f4ff; border:1px solid #c7d5f5; border-radius:12px; padding:12px 14px; font-size:13px; max-width:220px; }
    .offer-card .oc-title  { font-weight:700; color:#0f3460; margin-bottom:4px; font-size:13px; }
    .offer-card .oc-price  { color:#28a745; font-weight:600; margin-bottom:6px; font-size:12px; }
    .offer-card .oc-img    { width:100%; height:80px; object-fit:cover; border-radius:8px; margin-bottom:8px; display:block; }
    .offer-card .oc-img-ph { width:100%; height:80px; background:#dce4f0; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:28px; margin-bottom:8px; }
    .offer-card .view-btn  { font-size:11px; }
    /* Deal locking styles */
    .offer-card .oc-header  { font-size:11px; color:#0f3460; font-weight:700; letter-spacing:1px; margin-bottom:6px; }
    .oc-accept { margin-top:8px; font-size:12px; width:100%; }
    .deal-locked-tag { margin-top:8px; background:#d4edda; color:#155724; border-radius:8px; padding:6px 10px; font-size:12px; font-weight:700; text-align:center; }
    .deal-waiting    { margin-top:8px; color:#856404; font-size:12px; text-align:center; }
    .bubble.system-msg { align-self:center; background:transparent; padding:0; max-width:90%; box-shadow:none; }
    .deal-locked-banner { background:linear-gradient(135deg,#28a745,#20c997); color:#fff; border-radius:12px; padding:12px 18px; text-align:center; font-size:14px; box-shadow:0 4px 16px rgba(40,167,69,.35); }
    /* ── Toast ── */
    #toastContainer { position:fixed; top:74px; right:16px; z-index:9999; width:290px; pointer-events:none; }
    .chat-toast { background:#1a1a2e; color:#fff; border-radius:12px; padding:12px 14px; margin-bottom:10px;
                  display:flex; align-items:flex-start; gap:10px; pointer-events:all;
                  animation:toastIn .3s ease; box-shadow:0 4px 20px rgba(0,0,0,.35); border-left:4px solid #28a745; }
    .chat-toast .t-icon  { font-size:20px; flex-shrink:0; }
    .chat-toast .t-body  { flex:1; min-width:0; }
    .chat-toast .t-sender{ font-weight:700; font-size:13px; color:#e94560; margin-bottom:2px; }
    .chat-toast .t-msg   { font-size:12px; color:#ccc; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .chat-toast .t-close { background:none; border:none; color:#aaa; font-size:18px; cursor:pointer; padding:0 0 0 8px; line-height:1; flex-shrink:0; }
    .chat-toast .t-close:hover { color:#fff; }
    .chat-toast.fade-out { animation:toastOut .4s ease forwards; }
    @keyframes toastIn  { from{opacity:0;transform:translateX(40px);} to{opacity:1;transform:translateX(0);} }
    @keyframes toastOut { from{opacity:1;} to{opacity:0;transform:translateX(40px);} }
    /* empty state */
    .empty-state { text-align: center; padding: 48px 20px; color: #adb5bd; }
    .empty-state .icon { font-size: 56px; margin-bottom: 12px; }
</style>

<!-- ═══════════════ PAGE HEADER ═══════════════ -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0">My Swap Requests</h4>
    <div class="d-flex gap-2">
        <asp:LinkButton ID="btnBackList" runat="server" CssClass="btn btn-outline-secondary btn-sm"
                        OnClick="btnBackList_Click" Visible="false">&larr; Back to List</asp:LinkButton>
        <a href="SwapRequest.aspx" class="btn btn-primary btn-sm">+ New Request</a>
    </div>
</div>

<!-- ═══════════════ LIST VIEW ═══════════════ -->
<asp:Panel ID="pnlList" runat="server">
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-state">
            <div class="icon">&#128218;</div>
            <h5>No Swap Requests Yet</h5>
            <p>You haven't submitted any swap requests.<br />Click <strong>New Request</strong> to get started.</p>
        </div>
    </asp:Panel>

    <div class="row g-3" id="bookGrid">
        <asp:Repeater ID="rptBooks" runat="server" OnItemDataBound="rptBooks_ItemDataBound" OnItemCommand="rptBooks_ItemCommand">
            <ItemTemplate>
                <div class="col-12 col-sm-6 col-md-4">
                    <div class="swap-card card">
                        <!-- Photo -->
                        <asp:Image ID="imgCard" runat="server" CssClass="card-img" AlternateText="Book" Visible="false" />
                        <div class="card-img-ph" id="divCardPh" runat="server">&#128218;</div>

                        <div class="card-body">
                            <div class="req-no">REQUEST #<%# Eval("SwapRequestId") %></div>
                            <div class="title"><%# Eval("EducationName") %> &ndash; <%# Eval("LevelName") %></div>
                            <div class="price-row">
                                <div class="price-chip">
                                    <span class="lbl">Original</span>
                                    <span class="val">&#8377;<%# string.Format("{0:N2}", Eval("OriganalTotalAmount") == DBNull.Value ? 0 : Eval("OriganalTotalAmount")) %></span>
                                </div>
                                <div class="price-chip">
                                    <span class="lbl">Swap</span>
                                    <span class="val">&#8377;<%# string.Format("{0:N2}", Eval("SecondTotalAmount") == DBNull.Value ? 0 : Eval("SecondTotalAmount")) %></span>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer-row">
                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                            <asp:LinkButton ID="btnView" runat="server"
                                CssClass="btn btn-sm btn-outline-primary"
                                CommandName="View"
                                CommandArgument='<%# Eval("SwapRequestId") %>'>
                                View Inquiries
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Panel>

<!-- ═══════════════ DETAIL VIEW ═══════════════ -->
<asp:Panel ID="pnlDetail" runat="server" Visible="false">

    <!-- Book info -->
    <div class="detail-layout mb-4">
        <div>
            <asp:Image ID="imgDetail" runat="server" CssClass="detail-img" AlternateText="Front" Visible="false" />
            <asp:Panel ID="pnlDetailPh" runat="server" CssClass="detail-img-ph">&#128218;</asp:Panel>
        </div>
        <div>
            <h5 class="fw-bold mb-1"><asp:Label ID="lblDetailTitle" runat="server"></asp:Label></h5>
            <span id="spanStatus" runat="server" class="s-pending"></span>
            <table class="meta-row mt-3">
                <tr><td>Semester</td><td><asp:Label ID="lblDetailSem" runat="server">-</asp:Label></td></tr>
                <tr><td>Original</td><td>&#8377;<asp:Label ID="lblDetailOrig" runat="server">0.00</asp:Label></td></tr>
                <tr><td>Swap Price</td><td><strong>&#8377;<asp:Label ID="lblDetailSwap" runat="server">0.00</asp:Label></strong></td></tr>
                <tr><td>Payment</td><td><asp:Label ID="lblDetailPay" runat="server">-</asp:Label></td></tr>
                <tr><td>Submitted</td><td><asp:Label ID="lblDetailDate" runat="server">-</asp:Label></td></tr>
            </table>
        </div>
    </div>

    <!-- Interested users who have chatted -->
    <div class="section-title">Interested Users</div>

    <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
        <div class="alert alert-light text-muted">No one has messaged about this book yet.</div>
    </asp:Panel>

    <!-- Hidden field to carry SwapRequestId for chat post-backs -->
    <asp:HiddenField ID="hfViewId"        runat="server" />
    <asp:HiddenField ID="hfDetailLastTs"  runat="server" />
    <asp:HiddenField ID="hfActiveSender"  runat="server" />

    <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand" OnItemDataBound="rptUsers_UserDataBound">
        <ItemTemplate>
            <div class="user-card">
                <div class="avatar"><%# Eval("SenderName").ToString().Length > 0 ? Eval("SenderName").ToString().Substring(0,1).ToUpper() : "?" %></div>
                <div class="user-info">
                    <div class="name"><%# Eval("SenderName") %></div>
                    <div class="meta"><%# Eval("MsgCount") %> message(s) &bull; Last: <%# Eval("LastMsg") != DBNull.Value ? Convert.ToDateTime(Eval("LastMsg")).ToString("dd MMM, h:mm tt") : "-" %></div>
                </div>
                <asp:LinkButton ID="btnChat" runat="server"
                    CssClass="btn btn-sm btn-outline-primary"
                    CommandName="OpenChat"
                    CommandArgument='<%# Eval("SenderId") %>'>
                    Chat
                </asp:LinkButton>
            </div>

            <!-- Inline chat panel -->
            <div class="chat-panel" id='chatPanel_<%# Eval("SenderId") %>' data-sender-id='<%# Eval("SenderId") %>'>
                <div class="chat-head">Chat with <%# Eval("SenderName") %></div>

                <div class="chat-msgs" id='msgs_<%# Eval("SenderId") %>'>
                    <asp:Repeater ID="rptMsgs" runat="server" OnItemDataBound="rptMsgs_BubbleBound">
                        <ItemTemplate>
                            <asp:Panel ID="pnlBubble" runat="server">
                                <asp:Label ID="lblBubbleMsg" runat="server"></asp:Label>
                                <div class="ts">
                                    <asp:Label ID="lblBubbleSender" runat="server"></asp:Label>
                                    &bull; <%# Eval("SentAt") != DBNull.Value ? Convert.ToDateTime(Eval("SentAt")).ToString("h:mm tt, dd MMM") : "" %>
                                </div>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlMsgEmpty" runat="server" CssClass="chat-empty-msg"><p>No messages yet.</p></asp:Panel>
                </div>

                <div class="chat-input">
                    <asp:TextBox ID="txtChatMsg" runat="server" placeholder="Type a reply..." MaxLength="500"></asp:TextBox>
                    <asp:LinkButton ID="btnReply" runat="server"
                        CommandName="Reply"
                        CommandArgument='<%# Eval("SenderId") %>'>Send</asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

</asp:Panel>

    <script>
    (function () {
        var swapId = '', lastTs = '', NOTIF_THRESHOLD_MS = -1, firstPollDone = false;
        var activeSenderId = null, pollTimer = null;

        /* ── Date parsing (handles '.' or ':' as time separator) ── */
        function parseMsgDate(s) {
            if (!s) return null;
            var norm = s.replace(/T(\d{2})[.:](\d{2})[.:](\d{2})/, 'T$1:$2:$3');
            var m = norm.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.?(\d{0,3})/);
            if (m) return new Date(+m[1],+m[2]-1,+m[3],+m[4],+m[5],+m[6],+(m[7]||0));
            var d = new Date(s); return isNaN(d.getTime()) ? null : d;
        }
        function fmtTime(iso) {
            var d = parseMsgDate(iso);
            if (!d) return '';
            return d.toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'}) + ', ' +
                   d.toLocaleDateString([], {day:'2-digit',month:'short'});
        }
        function esc(s) {
            return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        /* ── Toast ── */
        window.showToast = function (senderName, message, isOffer) {
            var box = document.getElementById('toastContainer');
            if (!box) return;
            var t = document.createElement('div');
            t.className = 'chat-toast';
            var icon = isOffer ? '&#128218;' : '&#128172;';
            var body = isOffer ? senderName + ' sent a book offer!' : message.substring(0, 80);
            t.innerHTML =
                '<div class="t-icon">' + icon + '</div>' +
                '<div class="t-body"><div class="t-sender">' + esc(senderName) + '</div>' +
                '<div class="t-msg">' + esc(body) + '</div></div>' +
                '<button class="t-close" onclick="this.parentNode.remove()">&times;</button>';
            box.appendChild(t);
            setTimeout(function () {
                t.classList.add('fade-out');
                setTimeout(function () { if (t.parentNode) t.remove(); }, 420);
            }, 5000);
        };

        /* ── Offer card renderer ── */
        function renderOfferCard(raw) {
            var parts = raw.slice(12, -1).split('|||');
            var id = parts[0]||'', title = parts[1]||'Book', price = parts[2]||'0.00', photo = parts[3]||'';
            var img = photo ? '<img src="'+esc(photo)+'" class="oc-img" alt="Book"/>' : '<div class="oc-img-ph">&#128218;</div>';
            return '<div class="offer-card">' +
                   '<div style="font-size:11px;color:#0f3460;font-weight:700;letter-spacing:1px;margin-bottom:6px;">BOOK OFFER</div>' +
                   img + '<div class="oc-title">'+esc(title)+'</div>' +
                   '<div class="oc-price">Swap Price: &#8377;'+esc(price)+'</div>' +
                   '<a href="BookExchange.aspx?id='+esc(id)+'" class="btn btn-sm btn-outline-primary view-btn">View Details</a></div>';
        }

        /* ── Offer card: owner sees Accept button, requester sees waiting state ── */
        function renderOfferCard(raw, isMine, dealStatus) {
            var parts = raw.slice(12, -1).split('|||');
            var id = parts[0]||'', title = parts[1]||'Book', price = parts[2]||'0.00', photo = parts[3]||'';
            var img = photo
                ? (function(p){ p = p.replace(/^~\//, '/'); return '<img src="'+esc(p)+'" class="oc-img" alt="Book"/>'; })(photo)
                : '<div class="oc-img-ph">&#128218;</div>';

            var status = dealStatus || 'pending';
            var actionHtml;
            if (status === 'locked') {
                actionHtml = '<div class="deal-locked-tag">&#128274; Deal Locked!</div>';
            } else if (!isMine) {
                // Owner sees Accept button
                actionHtml = '<button class="btn btn-success btn-sm oc-accept" onclick="acceptOffer(\'' + esc(id) + '\',\'' + esc(swapId) + '\',this)">&#10003; Accept Offer</button>';
            } else {
                actionHtml = '<div class="deal-waiting">&#9203; Awaiting owner acceptance...</div>';
            }
            return '<div class="offer-card" data-offered-swap="'+esc(id)+'" data-swap="'+esc(swapId)+'" data-status="'+status+'">' +
                   '<div class="oc-header">BOOK OFFER</div>' +
                   img + '<div class="oc-title">'+esc(title)+'</div>' +
                   '<div class="oc-price">Swap Price: &#8377;'+esc(price)+'</div>' +
                   actionHtml + '</div>';
        }

        /* ── Accept offer button handler ── */
        window.acceptOffer = function (offeredSwapId, targetSwapId, btn) {
            if (btn) { btn.disabled = true; btn.textContent = 'Processing...'; }
            fetch('AcceptOfferHandler.ashx?swapId=' + encodeURIComponent(targetSwapId) +
                  '&offeredSwapId=' + encodeURIComponent(offeredSwapId) + '&action=accept')
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    var card = btn ? btn.closest('.offer-card') : null;
                    if (!card) return;
                    var actionArea = card.querySelector('.oc-accept,.deal-waiting,.deal-locked-tag,.view-btn');
                    if (data.isLocked || data.dealStatus === 'locked') {
                        card.setAttribute('data-status','locked');
                        if (actionArea) actionArea.outerHTML = '<div class="deal-locked-tag">&#128274; Deal Locked!</div>';
                        window.showToast('Deal Locked!', 'Both parties agreed. Books are now reserved.', true);
                    } else if (data.dealStatus === 'owner_accepted') {
                        if (actionArea) actionArea.outerHTML = '<div class="deal-waiting">&#10003; You accepted. Waiting for requester.</div>';
                    } else {
                        if (btn) { btn.disabled = false; btn.textContent = '\u2713 Accept Offer'; }
                    }
                })
                .catch(function () { if (btn) { btn.disabled = false; btn.textContent = '\u2713 Accept Offer'; } });
        };

        /* ── Build bubble element ── */
        function createBubble(msg) {
            var div = document.createElement('div');
            div.className = 'bubble ' + (msg.isMine ? 'mine' : 'theirs');
            var isOffer = msg.message.indexOf('[BOOK_OFFER:') === 0;
            var body = isOffer ? renderOfferCard(msg.message, msg.isMine, msg.dealStatus)
                               : '<div>' + esc(msg.message) + '</div>';
            body += '<div class="ts">' + esc(msg.senderName) + ' &bull; ' + fmtTime(msg.sentAt) + '</div>';
            div.innerHTML = body;
            return div;
        }

        /* ── Poll ChatHandler ── */
        function poll() {
            if (!swapId) return;
            // Pass activeSenderId as otherId for E2E filtering
            var otherParam = activeSenderId ? '&otherId=' + encodeURIComponent(activeSenderId) : '';
            fetch('ChatHandler.ashx?swapId=' + swapId + '&since=' + encodeURIComponent(lastTs) + otherParam)
                .then(function (r) { return r.json(); })
                .then(function (msgs) {
                    if (!msgs || !msgs.length) { firstPollDone = true; return; }
                    msgs.forEach(function (msg) {
                        lastTs = msg.sentAt;
                        var msgMs = msg.sentAtMs || (parseMsgDate(msg.sentAt) || new Date(0)).getTime();
                        var isNew = (NOTIF_THRESHOLD_MS >= 0) ? (msgMs > NOTIF_THRESHOLD_MS) : firstPollDone;
                        if (!isNew) return;

                        /* Handle DEAL_LOCKED system message */
                        if (msg.message.indexOf('[DEAL_LOCKED:') === 0) {
                            var targetId2 = msg.isMine ? activeSenderId : String(msg.senderId);
                            var msgBox2   = targetId2 ? document.getElementById('msgs_' + targetId2) : null;
                            if (msgBox2) {
                                var banner = document.createElement('div');
                                banner.className = 'bubble system-msg';
                                banner.innerHTML = '<div class="deal-locked-banner">&#128274; <strong>Deal Locked!</strong> Both parties agreed. Books are now reserved.</div>';
                                msgBox2.appendChild(banner);
                                msgBox2.scrollTop = msgBox2.scrollHeight;
                                /* Update all offer cards in this panel */
                                msgBox2.querySelectorAll('.offer-card').forEach(function(c) {
                                    var act = c.querySelector('.oc-accept,.deal-waiting,.view-btn');
                                    if (act) act.outerHTML = '<div class="deal-locked-tag">&#128274; Deal Locked!</div>';
                                    c.setAttribute('data-status','locked');
                                });
                            }
                            window.showToast('Deal Locked!', 'Both parties agreed. Books are now reserved.', true);
                            return;
                        }

                        /* Route: received → sender's panel; sent (owner) → active panel */
                        var targetId = msg.isMine ? activeSenderId : String(msg.senderId);
                        var msgBox   = targetId ? document.getElementById('msgs_' + targetId) : null;
                        if (msgBox) {
                            var empty = msgBox.querySelector('.chat-empty-msg');
                            if (empty) empty.style.display = 'none';
                            msgBox.appendChild(createBubble(msg));
                            msgBox.scrollTop = msgBox.scrollHeight;
                        }
                        /* Toast only for incoming messages */
                        if (!msg.isMine) {
                            var isOff = msg.message.indexOf('[BOOK_OFFER:') === 0;
                            window.showToast(msg.senderName, msg.message, isOff);
                        }
                    });
                    firstPollDone = true;
                })
                .catch(function () {});
        }

        /* ── Toggle chat panel (only one open at a time) ── */
        window.toggleChat = function (senderId) {
            var panel = document.getElementById('chatPanel_' + senderId);
            if (!panel) return;
            /* close any other open panel */
            document.querySelectorAll('.chat-panel.open').forEach(function (p) {
                if (p !== panel) p.classList.remove('open');
            });
            panel.classList.toggle('open');
            var isOpen = panel.classList.contains('open');
            activeSenderId = isOpen ? String(senderId) : null;
            if (isOpen) {
                var mb = document.getElementById('msgs_' + senderId);
                if (mb) mb.scrollTop = mb.scrollHeight;
                if (!pollTimer && swapId) { poll(); pollTimer = setInterval(poll, 2500); }
            }
        };

        /* ── Init ── */
        document.addEventListener('DOMContentLoaded', function () {
            var hfSwap = document.getElementById('<%= hfViewId.ClientID %>');
            if (hfSwap) swapId = hfSwap.value;

            var hfLast = document.getElementById('<%= hfDetailLastTs.ClientID %>');
            if (hfLast && hfLast.value) {
                var d = parseMsgDate(hfLast.value);
                NOTIF_THRESHOLD_MS = d ? d.getTime() : -1;
                lastTs = hfLast.value;
            }

            /* Re-open active chat after postback */
            var hfActive = document.getElementById('<%= hfActiveSender.ClientID %>');
            var openId = hfActive ? hfActive.value : '';
            if (openId) {
                var p = document.getElementById('chatPanel_' + openId);
                if (p) {
                    p.classList.add('open');
                    activeSenderId = openId;
                    var mb = document.getElementById('msgs_' + openId);
                    if (mb) mb.scrollTop = mb.scrollHeight;
                    if (swapId) { poll(); pollTimer = setInterval(poll, 2500); }
                }
            }

            /* Auto-scroll any already-open panels */
            document.querySelectorAll('.chat-panel.open').forEach(function (p) {
                var id = p.getAttribute('data-sender-id') || p.id.replace('chatPanel_','');
                if (id && !activeSenderId) activeSenderId = id;
                var mb = p.querySelector('.chat-msgs');
                if (mb) mb.scrollTop = mb.scrollHeight;
            });
        });
    })();
    </script>

</asp:Content>
