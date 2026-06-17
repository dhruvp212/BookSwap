<%@ Page Title="Book Exchange" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="BookExchange.aspx.cs" Inherits="Client_BookExchange" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <style>
        /* ── Layout ── */
        .exchange-grid { display: grid; grid-template-columns: 1fr 380px; gap: 28px; align-items: start; }
        @media (max-width:992px) { .exchange-grid { grid-template-columns: 1fr; } }

        /* ── Book Detail Card ── */
        .book-detail-card {
            border: none; border-radius: 18px;
            box-shadow: 0 6px 28px rgba(0,0,0,.10);
            overflow: hidden;
        }
        .book-detail-card .hero-img {
            width: 100%; height: 320px;
            object-fit: cover; display: block;
            cursor: zoom-in;
        }
        .book-detail-card .hero-placeholder {
            width: 100%; height: 320px;
            background: linear-gradient(135deg,#1a1a2e,#0f3460);
            display: flex; align-items: center; justify-content: center;
            font-size: 80px; color: rgba(255,255,255,.3);
        }
        .book-detail-card .info-body { padding: 28px; }
        .book-detail-card .book-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 6px; }
        .status-badge { display:inline-block; background:#d4edda; color:#155724; padding:4px 14px; border-radius:20px; font-size:13px; font-weight:600; }
        .price-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin:20px 0; }
        .price-box { background:#f8f9fa; border-radius:12px; padding:16px; text-align:center; }
        .price-box .lbl { font-size:11px; color:#6c757d; text-transform:uppercase; letter-spacing:1px; display:block; }
        .price-box .amt { font-size:1.6rem; font-weight:800; color:#0f3460; }
        .price-box .amt.striked { font-size:1.1rem; color:#adb5bd; text-decoration:line-through; font-weight:500; }
        .meta-table td { padding:6px 0; font-size:14px; vertical-align:top; }
        .meta-table td:first-child { color:#6c757d; width:130px; font-weight:500; }
        .desc-box { background:#f8f9fa; border-radius:10px; padding:16px; font-size:14px; color:#495057; line-height:1.7; }

        /* ── Photo thumbnails ── */
        .thumb-row { display:flex; gap:10px; margin-top:16px; }
        .thumb { width:70px; height:70px; object-fit:cover; border-radius:10px; cursor:pointer;
                 border:2px solid #e9ecef; transition:border-color .2s; }
        .thumb:hover { border-color:#0f3460; }

        /* ── Chat box ── */
        .chat-card {
            border:none; border-radius:18px;
            box-shadow:0 6px 28px rgba(0,0,0,.10);
            display:flex; flex-direction:column;
            position:sticky; top:80px;
        }
        .chat-header {
            background:linear-gradient(135deg,#1a1a2e,#0f3460);
            color:#fff; padding:18px 20px; border-radius:18px 18px 0 0;
        }
        .chat-header .owner-name { font-weight:700; font-size:1rem; }
        .chat-header .subtitle { font-size:12px; opacity:.75; }
        .chat-messages {
            height:360px; overflow-y:auto;
            padding:16px; background:#f8f9fa;
            display:flex; flex-direction:column; gap:10px;
        }
        .chat-messages::-webkit-scrollbar { width:4px; }
        .chat-messages::-webkit-scrollbar-thumb { background:#ccc; border-radius:4px; }

        /* bubbles */
        .bubble { max-width:75%; padding:10px 14px; border-radius:16px; font-size:13px; line-height:1.5; word-break:break-word; }
        .bubble.sent { background:#0f3460; color:#fff; border-bottom-right-radius:4px; align-self:flex-end; }
        .bubble.received { background:#fff; color:#212529; border-bottom-left-radius:4px; align-self:flex-start; box-shadow:0 1px 4px rgba(0,0,0,.08); }
        .bubble .bubble-meta { font-size:10px; opacity:.65; margin-top:4px; }
        .bubble.sent .bubble-meta { text-align:right; }

        .chat-empty { text-align:center; margin:auto; color:#adb5bd; font-size:14px; }

        .chat-input-area { padding:14px; border-top:1px solid #e9ecef; background:#fff; border-radius:0 0 18px 18px; }
        .chat-input-area .input-group input {
            border-radius:24px 0 0 24px !important;
            border-right:none; font-size:13px;
            padding: 10px 16px;
        }
        .chat-input-area .input-group .btn {
            border-radius:0 24px 24px 0 !important;
            padding: 10px 18px; font-size:13px;
        }
        .login-notice { padding:20px; text-align:center; color:#6c757d; font-size:14px; }

        /* ── Photo modal ── */
        #imgModal .modal-body img { max-width:100%; border-radius:10px; }

        /* ── Exchange CTA ── */
        .cta-box { margin-top:20px; background:linear-gradient(135deg,#0f3460,#16213e); border-radius:14px; padding:20px; color:#fff; text-align:center; }
        .cta-box h5 { margin-bottom:8px; font-weight:700; }
        .cta-box p { font-size:13px; opacity:.8; margin-bottom:14px; }

        /* ── In-app toast notifications ── */
        #toastContainer {
            position: fixed; top: 80px; right: 20px;
            z-index: 9999; display: flex; flex-direction: column; gap: 10px;
            pointer-events: none;
        }
        .chat-toast {
            background: #1a1a2e; color: #fff;
            border-radius: 14px; padding: 14px 18px;
            min-width: 280px; max-width: 340px;
            box-shadow: 0 8px 30px rgba(0,0,0,.35);
            display: flex; align-items: flex-start; gap: 12px;
            pointer-events: all;
            animation: toastIn .35s ease forwards;
            border-left: 4px solid #28a745;
        }
        .chat-toast.fade-out { animation: toastOut .4s ease forwards; }
        .chat-toast .t-icon { font-size: 22px; flex-shrink: 0; }
        .chat-toast .t-body .t-sender { font-weight: 700; font-size: 13px; }
        .chat-toast .t-body .t-msg    { font-size: 12px; opacity: .8; margin-top: 2px; }
        .chat-toast .t-close {
            margin-left: auto; background: none; border: none;
            color: rgba(255,255,255,.5); font-size: 16px; cursor: pointer;
            padding: 0; line-height: 1; flex-shrink: 0;
        }
        .chat-toast .t-close:hover { color: #fff; }
        @keyframes toastIn  { from { opacity:0; transform:translateX(60px); } to   { opacity:1; transform:translateX(0); } }
        @keyframes toastOut { from { opacity:1; transform:translateX(0);    } to   { opacity:0; transform:translateX(60px); } }

        /* ── Bell icon button ── */
        .bell-btn {
            background: rgba(255,255,255,.15); border: none; border-radius: 50%;
            width: 32px; height: 32px; display: flex; align-items: center;
            justify-content: center; cursor: pointer; font-size: 15px;
            transition: background .2s; color: #fff;
        }
        .bell-btn:hover { background: rgba(255,255,255,.28); }
        .bell-btn.granted { background: rgba(40,167,69,.35); }
        .bell-btn.denied  { background: rgba(220,53,69,.25); }

        /* ── Offer card (deal locking) ── */
        .offer-card .oc-header { font-size:11px; color:#0f3460; font-weight:700; letter-spacing:1px; margin-bottom:6px; }
        .oc-accept { margin-top:8px; font-size:12px; width:100%; }
        .deal-locked-tag { margin-top:8px; background:#d4edda; color:#155724; border-radius:8px; padding:6px 10px; font-size:12px; font-weight:700; text-align:center; }
        .deal-waiting    { margin-top:8px; color:#856404; font-size:12px; text-align:center; }
        /* System message (deal locked banner) */
        .bubble.system-msg { align-self:center; background:transparent; padding:0; max-width:90%; box-shadow:none; }
        .deal-locked-banner { background:linear-gradient(135deg,#28a745,#20c997); color:#fff; border-radius:12px; padding:12px 18px; text-align:center; font-size:14px; box-shadow:0 4px 16px rgba(40,167,69,.35); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">

    <%-- Toast notification container — MUST be in DOM for showToast() to work --%>
    <div id="toastContainer"></div>

    <!-- Back button -->
    <a href="ApprovedSwapList.aspx" class="btn btn-outline-secondary btn-sm mb-4">
        &larr; Back to Approved Books
    </a>


    <!-- Error panel if book not found -->
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="alert alert-warning text-center py-5">
            <h4>Book not found or no longer available.</h4>
            <a href="ApprovedSwapList.aspx" class="btn btn-primary mt-2">Browse Available Books</a>
        </div>
    </asp:Panel>

    <!-- Main Exchange Grid -->
    <asp:Panel ID="pnlMain" runat="server" Visible="false">
        <div class="exchange-grid">

            <!-- ═══ LEFT: Book Details ═══ -->
            <div>
                <div class="book-detail-card card">

                    <!-- Hero image (front photo) -->
                    <asp:Image ID="imgHero" runat="server" CssClass="hero-img" AlternateText="Book Front" />
                    <asp:Panel ID="pnlHeroPlaceholder" runat="server" CssClass="hero-placeholder">
                        &#128218;
                    </asp:Panel>

                    <div class="info-body">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                            <div>
                                <div class="book-title">
                                    <asp:Label ID="lblTitle" runat="server"></asp:Label>
                                </div>
                                <span class="status-badge">&#10003; Approved &amp; Available</span>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">Request #<asp:Label ID="lblReqId" runat="server"></asp:Label></small>
                            </div>
                        </div>

                        <!-- Prices -->
                        <div class="price-grid">
                            <div class="price-box">
                                <span class="lbl">Original Price</span>
                                <span class="amt striked">&#8377;<asp:Label ID="lblOrigAmt" runat="server"></asp:Label></span>
                            </div>
                            <div class="price-box">
                                <span class="lbl">Swap Price</span>
                                <span class="amt">&#8377;<asp:Label ID="lblSwapAmt" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <!-- Meta info -->
                        <table class="meta-table w-100 mb-3">
                            <tr><td>Education</td><td><asp:Label ID="lblEducation" runat="server">-</asp:Label></td></tr>
                            <tr><td>Level</td><td><asp:Label ID="lblLevel" runat="server">-</asp:Label></td></tr>
                            <tr><td>Semester</td><td><asp:Label ID="lblSemester" runat="server">-</asp:Label></td></tr>
                            <tr><td>Payment</td><td><asp:Label ID="lblPayment" runat="server">-</asp:Label></td></tr>
                            <tr><td>Posted On</td><td><asp:Label ID="lblDate" runat="server">-</asp:Label></td></tr>
                        </table>

                        <!-- Description -->
                        <asp:Panel ID="pnlDesc" runat="server">
                            <p class="fw-semibold mb-1" style="font-size:14px;">Description</p>
                            <div class="desc-box"><asp:Label ID="lblDesc" runat="server"></asp:Label></div>
                        </asp:Panel>

                        <!-- Photo thumbnails -->
                        <div class="thumb-row">
                            <asp:Image ID="imgThumb1" runat="server" CssClass="thumb" AlternateText="Front" Visible="false" />
                            <asp:Image ID="imgThumb2" runat="server" CssClass="thumb" AlternateText="Back" Visible="false" />
                        </div>

                        <!-- Exchange CTA -->
                        <div class="cta-box">
                            <h5>Interested in This Book?</h5>
                            <p>Send a message to the owner using the chat panel and arrange your swap!</p>
                            <asp:Panel ID="pnlCTALogin" runat="server">
                                <a href='login.aspx?ret=BookExchange.aspx?id=<asp:Literal ID="litRetId" runat="server"></asp:Literal>'
                                   class="btn btn-warning fw-bold">Login to Start Chat</a>
                            </asp:Panel>
                            <asp:Panel ID="pnlCTALoggedIn" runat="server" Visible="false">
                                <button type="button" class="btn btn-warning fw-bold"
                                        onclick="document.getElementById('txtMsg').focus()">
                                    Start Chatting &darr;
                                </button>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ═══ RIGHT: Chat Box ═══ -->
            <div>
                <div class="chat-card">
                    <div class="chat-header" style="display:flex;justify-content:space-between;align-items:flex-start;">
                        <div>
                            <div class="owner-name">Chat with Owner</div>
                            <div class="subtitle">
                                <asp:Label ID="lblOwnerName" runat="server" Text="Book Owner"></asp:Label>
                            </div>
                        </div>
                        <button id="bellBtn" class="bell-btn" title="Toggle notifications"
                                onclick="toggleNotifications()" type="button">
                            &#128276;
                        </button>
                    </div>

                    <!-- Messages -->
                    <div class="chat-messages" id="chatMessages">
                        <asp:Repeater ID="rptChat" runat="server" OnItemDataBound="rptChat_ItemDataBound">
                            <ItemTemplate>
                                <asp:Panel ID="pnlBubble" runat="server">
                                    <asp:Label ID="lblMsg" runat="server"></asp:Label>
                                    <div class="bubble-meta">
                                        <asp:Label ID="lblSender" runat="server"></asp:Label>
                                        &bull;
                                        <%# Eval("SentAt") != DBNull.Value
                                            ? Convert.ToDateTime(Eval("SentAt")).ToString("dd MMM, h:mm tt")
                                            : "" %>
                                    </div>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlChatEmpty" runat="server" CssClass="chat-empty">
                            <p>No messages yet.<br />Be the first to say hello!</p>
                        </asp:Panel>
                    </div>

                    <!-- Input or login notice -->
                    <asp:Panel ID="pnlChatInput" runat="server" CssClass="chat-input-area" Visible="false">
                        <!-- Notification permission bar -->
                        <div id="notifBar" class="notif-bar" style="display:none;">
                            <span>&#128276; Get notified when you receive a reply?</span>
                            <button type="button" class="btn btn-sm btn-warning ms-2" onclick="requestNotifPermission()">Enable</button>
                            <button type="button" class="btn btn-sm btn-link text-muted" onclick="dismissNotifBar()">Later</button>
                        </div>
                        <div class="input-row">
                            <asp:TextBox ID="txtMsg" runat="server" CssClass="chat-txt"
                                         placeholder="Type a message..."
                                         ClientIDMode="Static"
                                         MaxLength="500" autocomplete="off"></asp:TextBox>
                            <button type="button" class="btn btn-outline-secondary offer-btn"
                                    title="Send a book offer" onclick="openOfferModal()">
                                &#128218; Offer
                            </button>
                            <asp:LinkButton ID="btnSend" runat="server" CssClass="btn btn-primary send-btn"
                                            OnClick="btnSend_Click">Send &#10148;</asp:LinkButton>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlChatLoginNotice" runat="server" CssClass="login-notice">
                        <a href="login.aspx" class="btn btn-outline-primary btn-sm">Login to Chat</a>
                    </asp:Panel>
                </div>
            </div>

        </div>
    </asp:Panel>

    <!-- Photo zoom modal -->
    <div class="modal fade" id="imgModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0">
                <div class="modal-header border-0 pb-0">
                    <h6 class="modal-title" id="imgModalLabel">Book Photo</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center pb-4">
                    <img id="modalImg" src="" alt="" class="img-fluid" />
                </div>
            </div>
        </div>
    </div>

    <!-- Offer Book modal -->
    <div class="modal fade" id="offerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-md">
            <div class="modal-content">
                <div class="modal-header" style="background:linear-gradient(135deg,#1a1a2e,#0f3460);color:#fff;">
                    <h5 class="modal-title">&#128218; Send a Book Offer</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-3">
                    <p class="text-muted mb-3" style="font-size:13px;">Select one of your approved swap books to offer in this chat:</p>
                    <div id="offerBookList" class="offer-book-list">
                        <div class="text-center text-muted py-3">Loading your books...</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden fields -->
    <asp:HiddenField ID="hfSwapId"  runat="server" />
    <asp:HiddenField ID="hfUserId"  runat="server" />
    <asp:HiddenField ID="hfLastTs"  runat="server" />

    <!-- Toast notification container (fixed top-right) -->
    <div id="toastContainer"></div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
<style>
    .chat-input-area { padding:12px; border-top:1px solid #e9ecef; background:#fff; border-radius:0 0 18px 18px; }
    .input-row       { display:flex; gap:8px; align-items:center; }
    .chat-txt        { flex:1; border:1px solid #dee2e6; border-radius:20px; padding:9px 16px; font-size:13px; outline:none; }
    .chat-txt:focus  { border-color:#0f3460; box-shadow:0 0 0 3px rgba(15,52,96,.1); }
    .send-btn        { border-radius:20px; padding:9px 18px; font-size:13px; }
    .offer-btn       { border-radius:20px; padding:9px 14px; font-size:13px; white-space:nowrap; }
    .notif-bar       { background:#fff8e1; border:1px solid #ffe082; border-radius:8px; padding:8px 12px; margin-bottom:10px; font-size:13px; display:flex; align-items:center; flex-wrap:wrap; gap:6px; }
    .offer-card      { background:#f0f4ff; border:1px solid #c7d5f5; border-radius:12px; padding:12px 14px; font-size:13px; max-width:260px; }
    .offer-card .oc-title  { font-weight:700; color:#0f3460; margin-bottom:4px; }
    .offer-card .oc-price  { color:#28a745; font-weight:600; margin-bottom:6px; }
    .offer-card .oc-img    { width:100%; height:90px; object-fit:cover; border-radius:8px; margin-bottom:8px; display:block; }
    .offer-card .oc-img-ph { width:100%; height:90px; background:#dce4f0; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:32px; margin-bottom:8px; }
    .offer-card .view-btn  { font-size:12px; }
    .offer-book-list { max-height:360px; overflow-y:auto; }
    .obl-item { border:1px solid #e9ecef; border-radius:10px; padding:12px; margin-bottom:8px; cursor:pointer; display:flex; align-items:center; gap:12px; transition:border-color .18s; }
    .obl-item:hover { border-color:#0f3460; background:#f0f4ff; }
    .obl-item img { width:56px; height:56px; object-fit:cover; border-radius:8px; flex-shrink:0; }
    .obl-item .ph { width:56px; height:56px; background:#dce4f0; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:22px; flex-shrink:0; }
    .obl-item .obl-info .name  { font-weight:600; font-size:14px; }
    .obl-item .obl-info .price { font-size:13px; color:#28a745; font-weight:600; }
    .live-dot   { display:inline-block; width:8px; height:8px; border-radius:50%; background:#28a745; margin-right:5px; animation:livePulse 1.4s infinite; }
    .live-badge { font-size:12px; color:#28a745; font-weight:600; }
    @keyframes livePulse { 0%,100%{opacity:1;} 50%{opacity:.3;} }
    #toastContainer { position:fixed; top:76px; right:16px; z-index:9999; width:300px; pointer-events:none; }
    .chat-toast { background:#1a1a2e; color:#fff; border-radius:12px; padding:12px 14px; margin-bottom:10px;
                  display:flex; align-items:flex-start; gap:10px; pointer-events:all;
                  animation:toastIn .3s ease; box-shadow:0 4px 20px rgba(0,0,0,.35); }
    .chat-toast .t-icon  { font-size:20px; flex-shrink:0; }
    .chat-toast .t-body  { flex:1; min-width:0; }
    .chat-toast .t-sender{ font-weight:700; font-size:13px; color:#e94560; margin-bottom:2px; }
    .chat-toast .t-msg   { font-size:12px; color:#ccc; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .chat-toast .t-close { background:none; border:none; color:#aaa; font-size:18px; cursor:pointer; padding:0 0 0 8px; line-height:1; flex-shrink:0; }
    .chat-toast .t-close:hover { color:#fff; }
    .chat-toast.fade-out { animation:toastOut .4s ease forwards; }
    @keyframes toastIn  { from{opacity:0;transform:translateX(40px);} to{opacity:1;transform:translateX(0);} }
    @keyframes toastOut { from{opacity:1;} to{opacity:0;transform:translateX(40px);} }
    .bell-btn { background:none; border:2px solid rgba(255,255,255,.3); border-radius:50%;
                width:36px; height:36px; font-size:17px; cursor:pointer; color:#fff;
                display:flex; align-items:center; justify-content:center; transition:all .2s; }
    .bell-btn:hover             { background:rgba(255,255,255,.15); border-color:#fff; }
    .bell-btn.granted           { border-color:#28a745; color:#28a745; }
    .bell-btn.denied            { border-color:#dc3545; color:#dc3545; }
</style>
<script>
(function () {
    var SWAP_ID    = document.getElementById('<%= hfSwapId.ClientID %>').value;
    var MY_ID      = document.getElementById('<%= hfUserId.ClientID %>').value;
    var isLoggedIn = MY_ID !== '';
    var chatBox    = document.getElementById('chatMessages');

    var serverTs = document.getElementById('<%= hfLastTs.ClientID %>').value;
    var lastTs   = serverTs || '';

    // parseMsgDate: handles both 'HH:mm:ss' and 'HH.mm.ss' culture variants
    function parseMsgDate(s) {
        if (!s) return null;
        // Normalize dot-separated time to colon-separated (culture-safe)
        var norm = s.replace(/T(\d{2})[.:](\d{2})[.:](\d{2})/, 'T$1:$2:$3');
        var m = norm.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.?(\d{0,3})/);
        if (m) return new Date(+m[1], +m[2]-1, +m[3], +m[4], +m[5], +m[6], +(m[7]||0));
        var d = new Date(s);
        return isNaN(d.getTime()) ? null : d;
    }

    // NOTIF_THRESHOLD_MS: Unix epoch ms of the last server-rendered message.
    // Any polled message with sentAtMs > this is genuinely new → notify.
    // -1 = chat was empty on page load → use firstPollDone flag.
    var serverTsDate       = serverTs ? parseMsgDate(serverTs) : null;
    var NOTIF_THRESHOLD_MS = serverTsDate ? serverTsDate.getTime() : -1;
    var firstPollDone      = false;

    /* ── Helpers ── */
    function scrollBottom() { if (chatBox) chatBox.scrollTop = chatBox.scrollHeight; }
    function esc(s) {
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }
    function fmtTime(iso) {
        var d = parseMsgDate(iso);
        if (!d) return '';
        return d.toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'}) + ', ' +
               d.toLocaleDateString([], {day:'2-digit',month:'short'});
    }

    /* ── In-app toast (also exposed as window.showToast for console testing) ── */
    window.showToast = function showToast(senderName, message, isOffer) {
        var toastBox = document.getElementById('toastContainer');
        if (!toastBox) { console.warn('toastContainer not found'); return; }
        var toast = document.createElement('div');
        toast.className = 'chat-toast';
        var icon = isOffer ? '&#128218;' : '&#128172;';
        var body = isOffer ? senderName + ' sent you a book offer!' : message.substring(0, 80);
        toast.innerHTML =
            '<div class="t-icon">' + icon + '</div>' +
            '<div class="t-body"><div class="t-sender">' + esc(senderName) + '</div>' +
            '<div class="t-msg">' + esc(body) + '</div></div>' +
            '<button class="t-close" onclick="this.parentNode.remove()">&times;</button>';
        toastBox.appendChild(toast);
        setTimeout(function () {
            toast.classList.add('fade-out');
            setTimeout(function () { if (toast.parentNode) toast.remove(); }, 420);
        }, 5000);
    }

    /* ── Browser notification (HTTPS / localhost only) ── */
    function tryBrowserNotif(senderName, message, isOffer) {
        if (!('Notification' in window) || Notification.permission !== 'granted') return;
        var body = isOffer ? senderName + ' sent you a book offer!' : senderName + ': ' + message.substring(0, 80);
        new Notification('BookSwap Chat', { body: body, icon: '/favicon.ico' });
    }

    /* ── Bell button ── */
    window.toggleNotifications = function () {
        var bell = document.getElementById('bellBtn');
        if (!('Notification' in window)) { showToast('System', 'Your browser does not support notifications.', false); return; }
        if (Notification.permission === 'granted') { showToast('Notifications', 'To disable, open browser site settings.', false); return; }
        if (Notification.permission === 'denied')  { showToast('Blocked', 'Click the padlock in the address bar and Allow notifications.', false); bell.classList.add('denied'); return; }
        Notification.requestPermission().then(function (p) {
            if (p === 'granted') {
                bell.classList.remove('denied'); bell.classList.add('granted');
                localStorage.setItem('chatNotifMode','browser');
                new Notification('BookSwap Chat', { body: 'Notifications enabled!' });
                showToast('Enabled', 'You will get notified for new messages.', false);
            } else { bell.classList.add('denied'); showToast('Denied', 'Enable in browser site settings.', false); }
        });
    };
    function syncBellState() {
        var bell = document.getElementById('bellBtn');
        if (!bell || !('Notification' in window)) return;
        if (Notification.permission === 'granted') bell.classList.add('granted');
        if (Notification.permission === 'denied')  bell.classList.add('denied');
    }

    /* ── Bubble rendering ── */
    function renderBubble(msg) {
        var wrap = document.createElement('div');
        wrap.className = 'bubble ' + (msg.isMine ? 'sent' : 'received');
        var isOffer = typeof msg.message === 'string' && msg.message.indexOf('[BOOK_OFFER:') === 0;
        var content = isOffer ? renderOfferCard(msg.message, msg.isMine, msg.dealStatus)
                              : '<span>' + esc(msg.message) + '</span>';
        content += '<div class="bubble-meta">' + esc(msg.senderName) + ' &bull; ' + fmtTime(msg.sentAt) + '</div>';
        wrap.innerHTML = content;
        return wrap;
    }
    function renderOfferCard(raw, isMine, dealStatus) {
        var parts = raw.slice(12, -1).split('|||');
        var id = parts[0]||'', title = parts[1]||'Book', price = parts[2]||'0.00', photo = parts[3]||'';
        var img = photo
            ? (function(p){ p = p.replace(/^~\//, '/'); return '<img src="'+esc(p)+'" class="oc-img" alt="Book" />'; })(photo)
            : '<div class="oc-img-ph">&#128218;</div>';
        var swapCtx = typeof SWAP_ID !== 'undefined' ? SWAP_ID : '';
        var status  = dealStatus || 'pending';
        var actionHtml;
        if (status === 'locked') {
            actionHtml = '<div class="deal-locked-tag">&#128274; Deal Locked!</div>';
        } else if (!isMine) {
            // Owner sees Accept button
            actionHtml = '<button class="btn btn-success btn-sm oc-accept" onclick="acceptOffer(\'' + esc(id) + '\',\'' + esc(swapCtx) + '\',this)">&#10003; Accept Offer</button>';
        } else {
            // Requester sees waiting state
            actionHtml = '<div class="deal-waiting">&#9203; Awaiting owner acceptance...</div>';
        }
        return '<div class="offer-card" data-offered-swap="'+esc(id)+'" data-swap="'+esc(swapCtx)+'" data-status="'+status+'">' +
               '<div class="oc-header">BOOK OFFER</div>' +
               img + '<div class="oc-title">'+esc(title)+'</div>' +
               '<div class="oc-price">Swap Price: &#8377;'+esc(price)+'</div>' +
               actionHtml + '</div>';
    }

    /* ── Accept offer (called from Accept button) ── */
    window.acceptOffer = function (offeredSwapId, swapId, btn) {
        if (btn) { btn.disabled = true; btn.textContent = 'Processing...'; }
        fetch('AcceptOfferHandler.ashx?swapId=' + encodeURIComponent(swapId) +
              '&offeredSwapId=' + encodeURIComponent(offeredSwapId) + '&action=accept')
            .then(function (r) { return r.json(); })
            .then(function (data) {
                var card = btn ? btn.closest('.offer-card') : null;
                if (!card) return;
                var actionArea = card.querySelector('.oc-accept, .deal-waiting, .deal-locked-tag, .view-btn');
                if (data.isLocked || data.dealStatus === 'locked') {
                    card.setAttribute('data-status', 'locked');
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

    /* ── Polling ── */
    function poll() {
        if (!SWAP_ID) return;
        fetch('ChatHandler.ashx?swapId=' + SWAP_ID + '&since=' + encodeURIComponent(lastTs))
            .then(function (r) { return r.json(); })
            .then(function (msgs) {
                if (!msgs || !msgs.length) { firstPollDone = true; return; }
                var empty = chatBox ? chatBox.querySelector('.chat-empty') : null;
                if (empty) empty.style.display = 'none';
                var scrollNeeded = false;
                msgs.forEach(function (msg) {
                    lastTs = msg.sentAt;

                    // Use sentAtMs (epoch ms from server) — no string parsing, culture-safe
                    var msgMs    = msg.sentAtMs || (parseMsgDate(msg.sentAt) || new Date(0)).getTime();

                    // isNewMsg: true only for messages newer than the last Repeater-rendered message
                    var isNewMsg = (NOTIF_THRESHOLD_MS >= 0) ? (msgMs > NOTIF_THRESHOLD_MS) : firstPollDone;

                    if (isNewMsg) {
                        // Handle [DEAL_LOCKED:...] system messages
                        if (msg.message.indexOf('[DEAL_LOCKED:') === 0) {
                            var banner = document.createElement('div');
                            banner.className = 'bubble system-msg';
                            banner.innerHTML = '<div class="deal-locked-banner">&#128274; <strong>Deal Locked!</strong> Both parties have agreed. The books are now reserved.</div>';
                            chatBox.appendChild(banner);
                            // Update any offer card that is now locked
                            document.querySelectorAll('.offer-card').forEach(function(c) {
                                var act = c.querySelector('.oc-accept,.deal-waiting,.view-btn');
                                if (act) act.outerHTML = '<div class="deal-locked-tag">&#128274; Deal Locked!</div>';
                                c.setAttribute('data-status','locked');
                            });
                            scrollNeeded = true;
                            window.showToast('Deal Locked!', 'Both parties agreed. Books are now reserved.', true);
                        } else {
                            chatBox.appendChild(renderBubble(msg));
                            scrollNeeded = true;
                            if (!msg.isMine) {
                                var isOff = msg.message.indexOf('[BOOK_OFFER:') === 0;
                                window.showToast(msg.senderName, msg.message, isOff);
                                if (document.hidden) tryBrowserNotif(msg.senderName, msg.message, isOff);
                            }
                        }
                    }
                });
                firstPollDone = true;
                if (scrollNeeded) scrollBottom();
                document.getElementById('<%= hfLastTs.ClientID %>').value = lastTs;
            })
            .catch(function () {});
    }

    /* ── Offer book modal ── */
    window.openOfferModal = function () {
        var list = document.getElementById('offerBookList');
        list.innerHTML = '<div class="text-center text-muted py-3">Loading...</div>';
        new bootstrap.Modal(document.getElementById('offerModal')).show();
        fetch('GetUserBooksHandler.ashx')
            .then(function (r) { return r.json(); })
            .then(function (books) {
                if (!books || !books.length) {
                    list.innerHTML = '<div class="text-center text-muted py-4">No approved swap books.<br><a href="SwapRequest.aspx">Submit a request</a></div>';
                    return;
                }
                list.innerHTML = '';
                books.forEach(function (b) {
                    var item = document.createElement('div');
                    item.className = 'obl-item';
                    var img = b.photoFront ? '<img src="'+esc(b.photoFront)+'" alt="Book" />' : '<div class="ph">&#128218;</div>';
                    item.innerHTML = img + '<div class="obl-info"><div class="name">'+esc(b.title)+'</div><div class="price">&#8377;'+parseFloat(b.swapPrice).toFixed(2)+' swap price</div></div>';
                    item.addEventListener('click', function () {
                        var token = '[BOOK_OFFER:'+b.id+'|||'+b.title+'|||'+parseFloat(b.swapPrice).toFixed(2)+'|||'+(b.photoFront||'')+']';
                        document.getElementById('txtMsg').value = token;
                        bootstrap.Modal.getInstance(document.getElementById('offerModal')).hide();
                        document.querySelector('[id$="btnSend"]').click();
                    });
                    list.appendChild(item);
                });
            })
            .catch(function () { list.innerHTML = '<div class="text-danger p-3">Failed to load books.</div>'; });
    };

    window.zoomPhoto = function (src, title) {
        document.getElementById('modalImg').src = src;
        document.getElementById('imgModalLabel').innerText = title || 'Book Photo';
        new bootstrap.Modal(document.getElementById('imgModal')).show();
    };

    /* ── Init ── */
    document.addEventListener('DOMContentLoaded', function () {
        var hero = document.querySelector('.hero-img');
        if (hero) hero.addEventListener('click', function () { zoomPhoto(this.src, 'Front Photo'); });
        document.querySelectorAll('.thumb').forEach(function (t) {
            t.addEventListener('click', function () { zoomPhoto(this.src, this.alt + ' Photo'); });
        });
        scrollBottom();
        syncBellState();
        if (isLoggedIn) {
            var sub = document.querySelector('.chat-header .subtitle');
            if (sub) {
                var dot = document.createElement('span');
                dot.className = 'live-badge d-block mt-1';
                dot.innerHTML = '<span class="live-dot"></span>Live';
                sub.appendChild(dot);
            }
        }
        if (SWAP_ID) {
            poll();
            setInterval(poll, 2500);
        }
    });
})();
</script>
</asp:Content>
