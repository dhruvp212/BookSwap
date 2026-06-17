<%@ Page Title="My Chats" Language="C#" MasterPageFile="~/Client/Student.master"
    AutoEventWireup="true" CodeFile="MyChats.aspx.cs" Inherits="Client_MyChats" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">

<div id="toastContainer"></div>

<asp:HiddenField ID="hfSendSwapId"   runat="server" Value="" />
<asp:HiddenField ID="hfActiveSwapId" runat="server" Value="" />

<style>
    /* ── Page header ── */
    .page-hdr { display:flex; align-items:center; justify-content:space-between; margin-bottom:24px; }
    .page-hdr h4 { font-weight:700; margin:0; }

    /* ── Conversation card ── */
    .conv-card {
        background:#fff; border-radius:14px;
        box-shadow:0 2px 12px rgba(0,0,0,.08);
        padding:14px 18px; margin-bottom:12px;
        transition:box-shadow .18s;
    }
    .conv-card:hover { box-shadow:0 6px 24px rgba(0,0,0,.13); }
    .conv-row { display:flex; align-items:center; gap:14px; }
    .conv-avatar {
        width:44px; height:44px; border-radius:50%;
        background:linear-gradient(135deg,#0f3460,#e94560);
        color:#fff; display:flex; align-items:center;
        justify-content:center; font-weight:700; font-size:17px;
        flex-shrink:0; text-transform:uppercase;
    }
    .conv-info { flex:1; min-width:0; }
    .conv-info .book-title { font-weight:700; font-size:14px; color:#0f3460; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .conv-info .owner-name { font-size:13px; color:#495057; }
    .conv-info .meta       { font-size:11px; color:#6c757d; margin-top:2px; }
    .conv-info .last-msg   { font-size:12px; color:#6c757d; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:300px; }
    .chat-btn {
        background:#fff; border:1.5px solid #0f3460; color:#0f3460;
        border-radius:8px; padding:6px 18px; font-size:13px; font-weight:600;
        cursor:pointer; transition:all .18s; white-space:nowrap;
    }
    .chat-btn:hover, .chat-btn.active { background:#0f3460; color:#fff; }

    /* ── Inline chat panel ── */
    .chat-panel {
        display:none; margin-top:12px;
        border:1px solid #dee2e6; border-radius:12px; overflow:hidden;
        animation:slideDown .22s ease;
    }
    .chat-panel.open { display:block; }
    @keyframes slideDown { from{opacity:0;transform:translateY(-8px);} to{opacity:1;transform:translateY(0);} }
    .chat-head {
        background:linear-gradient(135deg,#1a1a2e,#0f3460);
        color:#fff; padding:12px 16px; font-size:14px; font-weight:600;
        display:flex; align-items:center; gap:10px;
    }
    .chat-msgs {
        height:260px; overflow-y:auto; padding:14px;
        background:#f8f9fa; display:flex; flex-direction:column; gap:8px;
    }
    .chat-msgs::-webkit-scrollbar { width:3px; }
    .chat-msgs::-webkit-scrollbar-thumb { background:#ccc; border-radius:3px; }
    .bubble { max-width:70%; padding:8px 12px; border-radius:14px; font-size:13px; word-break:break-word; }
    .bubble.mine    { align-self:flex-end;   background:#0f3460; color:#fff; border-bottom-right-radius:3px; }
    .bubble.theirs  { align-self:flex-start; background:#fff; color:#212529; border-bottom-left-radius:3px; box-shadow:0 1px 4px rgba(0,0,0,.08); }
    .bubble .ts     { font-size:10px; opacity:.6; margin-top:3px; }
    .bubble.mine .ts{ text-align:right; }
    .chat-empty     { text-align:center; color:#adb5bd; font-size:13px; margin:auto; }
    .chat-input     { display:flex; border-top:1px solid #e9ecef; background:#fff; padding:10px; gap:8px; }
    .chat-input input  { flex:1; border:1px solid #dee2e6; border-radius:20px; padding:8px 14px; font-size:13px; outline:none; }
    .chat-input button { border-radius:20px; padding:8px 20px; background:#0f3460; color:#fff; border:none; font-size:13px; cursor:pointer; }
    .chat-input button:hover { background:#16213e; }

    /* ── Offer card ── */
    .offer-card { background:#f0f4ff; border:1px solid #c7d5f5; border-radius:12px; padding:12px 14px; font-size:13px; max-width:220px; }
    .offer-card .oc-header { font-size:11px; color:#0f3460; font-weight:700; letter-spacing:1px; margin-bottom:6px; }
    .offer-card .oc-title  { font-weight:700; color:#0f3460; margin-bottom:4px; font-size:13px; }
    .offer-card .oc-price  { color:#28a745; font-weight:600; margin-bottom:6px; font-size:12px; }
    .offer-card .oc-img    { width:100%; height:80px; object-fit:cover; border-radius:8px; margin-bottom:8px; display:block; }
    .offer-card .oc-img-ph { width:100%; height:80px; background:#dce4f0; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:28px; margin-bottom:8px; }
    .deal-locked-tag  { margin-top:8px; background:#d4edda; color:#155724; border-radius:8px; padding:6px 10px; font-size:12px; font-weight:700; text-align:center; }
    .deal-waiting     { margin-top:8px; color:#856404; font-size:12px; text-align:center; }
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

    /* ── Empty state ── */
    .empty-state { text-align:center; padding:60px 20px; color:#adb5bd; }
    .empty-state .icon { font-size:60px; margin-bottom:14px; }
</style>

<!-- ═══════ PAGE HEADER ═══════ -->
<div class="page-hdr">
    <h4>&#128172; My Chats</h4>
    <a href="ApprovedSwapList.aspx" class="btn btn-sm btn-outline-primary">Browse Books</a>
</div>

<!-- ═══════ NOT LOGGED IN ═══════ -->
<asp:Panel ID="pnlLogin" runat="server" Visible="false">
    <div class="alert alert-warning text-center">
        Please <a href="login.aspx">log in</a> to view your chats.
    </div>
</asp:Panel>

<!-- ═══════ EMPTY STATE ═══════ -->
<asp:Panel ID="pnlEmpty" runat="server" Visible="false">
    <div class="empty-state">
        <div class="icon">&#128172;</div>
        <h5>No conversations yet</h5>
        <p>Browse approved swap books and start a chat with a book owner.</p>
        <a href="ApprovedSwapList.aspx" class="btn btn-primary mt-2">Browse Books</a>
    </div>
</asp:Panel>

<!-- ═══════ CONVERSATION LIST ═══════ -->
<asp:Panel ID="pnlList" runat="server">
    <asp:Repeater ID="rptConv" runat="server" OnItemDataBound="rptConv_ItemDataBound">
        <ItemTemplate>
            <div class="conv-card">
                <div class="conv-row">
                    <!-- Avatar: first letter of owner's name -->
                    <div class="conv-avatar">
                        <asp:Label ID="lblAvatar" runat="server"></asp:Label>
                    </div>
                    <!-- Info -->
                    <div class="conv-info">
                        <div class="book-title">
                            <asp:Label ID="lblBookTitle" runat="server"></asp:Label>
                        </div>
                        <div class="owner-name">&#128100;
                            <asp:Label ID="lblOwnerName" runat="server"></asp:Label>
                        </div>
                        <div class="meta">
                            <asp:Label ID="lblMeta" runat="server"></asp:Label>
                        </div>
                    </div>
                    <!-- Chat button -->
                    <button type="button" class="chat-btn" id='<%# "chatBtn_" + Eval("SwapRequestId") %>'
                            onclick='<%# "toggleMyChat(" + Eval("SwapRequestId") + ",this)" %>'>
                        &#128172; Chat
                    </button>
                </div>

                <!-- ── Inline chat panel ── -->
                <div class="chat-panel" id='<%# "panel_" + Eval("SwapRequestId") %>'>
                    <div class="chat-head">
                        &#128172; Chat with <asp:Label ID="lblPanelOwner" runat="server"></asp:Label>
                    </div>
                    <div class="chat-msgs" id='<%# "msgs_" + Eval("SwapRequestId") %>'>
                        <asp:Repeater ID="rptMsgs" runat="server" OnItemDataBound="rptMsgs_Bound">
                            <ItemTemplate>
                                <asp:Panel ID="pnlBubble" runat="server">
                                    <asp:Label ID="lblMsg" runat="server"></asp:Label>
                                    <div class="ts">
                                        <asp:Label ID="lblSender" runat="server"></asp:Label>
                                    </div>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="chat-input">
                        <asp:HiddenField ID="hfSwapId" runat="server"
                            Value='<%# Eval("SwapRequestId") %>' />
                        <input type="text"
                               id='<%# "inp_" + Eval("SwapRequestId") %>'
                               placeholder="Type a message..."
                               onkeydown='<%# "if(event.key==\"Enter\")sendMsg(" + Eval("SwapRequestId") + ")" %>' />
                        <button type="button"
                                onclick='<%# "sendMsg(" + Eval("SwapRequestId") + ")" %>'>
                            Send &#10148;
                        </button>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>

<script>
/* ─────────────────────────────────────────────────────
   MyChats.aspx client script
   ───────────────────────────────────────────────────── */
var MY_USER_ID    = '<%=Session["User"] ?? ""  %>';
var activeSwapIds = [];   // list of open chat panel swapIds for polling
var lastTsMap     = {};   // { swapId: lastTimestamp }
var NOTIF_TS      = <%=notifThresholdMs %>;

function esc(s){ return s==null?'':String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

/* ── Toggle chat panel ── */
window.toggleMyChat = function(swapId, btn) {
    var panel = document.getElementById('panel_' + swapId);
    if (!panel) return;
    var isOpen = panel.classList.contains('open');
    // Close all first
    document.querySelectorAll('.chat-panel.open').forEach(function(p){ p.classList.remove('open'); });
    document.querySelectorAll('.chat-btn.active').forEach(function(b){ b.classList.remove('active'); });
    activeSwapIds = [];

    if (!isOpen) {
        panel.classList.add('open');
        btn.classList.add('active');
        activeSwapIds = [String(swapId)];
        var mb = document.getElementById('msgs_' + swapId);
        if (mb) mb.scrollTop = mb.scrollHeight;
    }
};

/* ── Send message via AJAX ── */
window.sendMsg = function(swapId) {
    var input = document.getElementById('inp_' + swapId);
    if (!input) return;
    var txt = input.value.trim();
    if (!txt) return;
    input.value = '';
    input.disabled = true;

    fetch('SendChatHandler.ashx?swapId=' + encodeURIComponent(swapId) +
          '&msg=' + encodeURIComponent(txt))
        .then(function(r){ return r.json(); })
        .then(function(d){
            input.disabled = false;
            if (d.ok) {
                var mb = document.getElementById('msgs_' + swapId);
                if (mb) {
                    mb.appendChild(makeBubble(d.savedMsg, true));
                    mb.scrollTop = mb.scrollHeight;
                    // Update lastTs for this panel
                    if (d.savedMsg && d.savedMsg.sentAt)
                        lastTsMap[String(swapId)] = d.savedMsg.sentAt;
                }
            }
        })
        .catch(function(){ input.disabled = false; });
};

/* ── Render bubble ── */
function makeBubble(msg, isMine) {
    var wrap = document.createElement('div');
    if (msg.message && msg.message.indexOf('[DEAL_LOCKED:') === 0) {
        wrap.className = 'bubble system-msg';
        wrap.innerHTML = '<div class="deal-locked-banner">&#128274; <strong>Deal Locked!</strong> Both parties agreed. Books are now reserved.</div>';
        return wrap;
    }
    wrap.className = 'bubble ' + (isMine ? 'mine' : 'theirs');
    var body = '';
    if (msg.message && msg.message.indexOf('[BOOK_OFFER:') === 0) {
        body = renderOfferCard(msg.message, isMine, msg.dealStatus);
    } else {
        body = '<span>' + esc(msg.message) + '</span>';
    }
    body += '<div class="ts">' + esc(msg.senderName) + ' &bull; ' + fmtTime(msg.sentAt) + '</div>';
    wrap.innerHTML = body;
    return wrap;
}

/* ── Offer card ── */
function renderOfferCard(raw, isMine, dealStatus) {
    var parts = raw.slice(12,-1).split('|||');
    var id=parts[0]||'', title=parts[1]||'Book', price=parts[2]||'0.00', photo=parts[3]||'';
    if (photo) photo = photo.replace(/^~\//, '/');
    var img = photo ? '<img src="'+esc(photo)+'" class="oc-img" alt="Book"/>' : '<div class="oc-img-ph">&#128218;</div>';
    var status = dealStatus || 'pending';
    var action = status==='locked'
        ? '<div class="deal-locked-tag">&#128274; Deal Locked!</div>'
        : isMine
            ? '<div class="deal-waiting">&#9203; Awaiting owner acceptance...</div>'
            : '<a href="BookExchange.aspx?id='+esc(id)+'" class="btn btn-sm btn-outline-primary" style="font-size:11px;margin-top:8px;">View Book</a>';
    return '<div class="offer-card"><div class="oc-header">BOOK OFFER</div>'+img+
           '<div class="oc-title">'+esc(title)+'</div>'+
           '<div class="oc-price">Swap Price: &#8377;'+esc(price)+'</div>'+action+'</div>';
}

/* ── Format time ── */
function fmtTime(s) {
    if (!s) return '';
    var d = new Date(s.replace('T',' ').replace(/-/g,'/'));
    if (isNaN(d)) return s;
    return d.toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'});
}

/* ── Toast ── */
window.showToast = function(sender, msg, isOffer) {
    var tc = document.getElementById('toastContainer');
    if (!tc) return;
    var t = document.createElement('div');
    t.className = 'chat-toast';
    t.innerHTML = '<span class="t-icon">'+(isOffer?'&#128218;':'&#128172;')+'</span>'+
                  '<div class="t-body"><div class="t-sender">'+esc(sender)+'</div>'+
                  '<div class="t-msg">'+(isOffer?'Sent a book offer':esc(msg))+'</div></div>'+
                  '<button class="t-close" onclick="this.closest(\'.chat-toast\').remove()">&#215;</button>';
    tc.appendChild(t);
    setTimeout(function(){ t.classList.add('fade-out'); setTimeout(function(){ if(t.parentNode)t.remove(); }, 420); }, 5000);
};

/* ── Polling ── */
function poll() {
    if (!activeSwapIds.length) return;
    var swapId = activeSwapIds[0];
    var lastTs = lastTsMap[swapId] || '';
    fetch('ChatHandler.ashx?swapId=' + encodeURIComponent(swapId) +
          '&since=' + encodeURIComponent(lastTs))
        .then(function(r){ return r.json(); })
        .then(function(msgs){
            if (!msgs || !msgs.length) return;
            msgs.forEach(function(msg) {
                if (!msg || !msg.sentAt) return;
                lastTsMap[swapId] = msg.sentAt;
                var msgMs = msg.sentAtMs || 0;
                var isNew = NOTIF_TS >= 0 ? msgMs > NOTIF_TS : true;
                if (!isNew) return;

                var mb = document.getElementById('msgs_' + swapId);
                if (!mb) return;
                var isMine = String(msg.senderId) === MY_USER_ID;
                mb.appendChild(makeBubble(msg, isMine));
                mb.scrollTop = mb.scrollHeight;

                if (!isMine) {
                    var isOff = msg.message && msg.message.indexOf('[BOOK_OFFER:') === 0;
                    window.showToast(msg.senderName, msg.message, isOff);
                }
            });
        })
        .catch(function(){});
}
setInterval(poll, 2500);

/* ── Re-open active panel after postback ── */
window.addEventListener('load', function() {
    var activeId = document.getElementById('<%= hfActiveSwapId.ClientID %>').value;
    if (activeId) {
        var panel = document.getElementById('panel_' + activeId);
        var btn   = document.getElementById('chatBtn_' + activeId);
        if (panel) { panel.classList.add('open'); activeSwapIds = [activeId]; }
        if (btn)   btn.classList.add('active');
        var mb = document.getElementById('msgs_' + activeId);
        if (mb) mb.scrollTop = mb.scrollHeight;
    }
});
</script>

</asp:Content>
