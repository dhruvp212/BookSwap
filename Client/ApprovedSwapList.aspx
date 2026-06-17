<%@ Page Title="Approved Swap Books" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="ApprovedSwapList.aspx.cs" Inherits="Client_ApprovedSwapList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <style>
        /* ── Page header ── */
        .page-header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            border-radius: 16px;
            padding: 36px 32px;
            margin-bottom: 32px;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .page-header::before {
            content: "\1F4DA";
            font-size: 120px;
            position: absolute;
            right: 24px;
            top: -10px;
            opacity: 0.08;
        }
        .page-header h2 { font-size: 2rem; font-weight: 700; margin: 0; }
        .page-header p  { margin: 6px 0 0; opacity: .75; font-size: 1rem; }

        /* ── Approved badge strip ── */
        .approved-strip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #d4edda;
            color: #155724;
            font-size: 13px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            margin-bottom: 24px;
            border: 1px solid #c3e6cb;
        }
        .approved-strip .dot {
            width: 8px; height: 8px;
            background: #28a745;
            border-radius: 50%;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%,100% { opacity: 1; }
            50%      { opacity: .3; }
        }

        /* ── Book card ── */
        .book-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,.08);
            transition: transform .25s ease, box-shadow .25s ease;
            overflow: hidden;
            height: 100%;
        }
        .book-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px rgba(0,0,0,.15);
        }
        .book-card .card-img-wrap {
            position: relative;
            background: #f0f4f8;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .book-card .card-img-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            cursor: pointer;
        }
        .book-card .card-img-wrap .no-img {
            color: #adb5bd;
            font-size: 48px;
        }
        .approved-ribbon {
            position: absolute;
            top: 12px; right: -28px;
            background: #28a745;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 36px;
            transform: rotate(45deg);
            letter-spacing: 1px;
        }
        .book-card .card-body { padding: 18px 20px; }
        .book-card .req-id {
            font-size: 12px;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .book-card .amount-row {
            display: flex;
            gap: 10px;
            margin: 12px 0;
        }
        .book-card .amount-box {
            flex: 1;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 10px 12px;
            text-align: center;
        }
        .book-card .amount-box .label {
            font-size: 11px;
            color: #6c757d;
            display: block;
        }
        .book-card .amount-box .value {
            font-size: 16px;
            font-weight: 700;
            color: #212529;
        }
        .book-card .desc-text {
            font-size: 13px;
            color: #6c757d;
            line-height: 1.5;
            border-top: 1px solid #f0f0f0;
            padding-top: 10px;
            margin-top: 8px;
        }
        .book-card .meta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 12px;
        }
        .book-card .meta-chip {
            background: #e9ecef;
            border-radius: 20px;
            padding: 3px 10px;
            font-size: 12px;
            color: #495057;
        }
        .book-card .card-footer-custom {
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            padding: 10px 20px;
            font-size: 12px;
            color: #6c757d;
        }

        /* ── Photo modal ── */
        #photoModal .modal-body img { max-width: 100%; border-radius: 10px; }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 64px 24px; }
        .empty-state .icon { font-size: 72px; margin-bottom: 16px; }
        .empty-state h4 { color: #495057; }
        .empty-state p  { color: #adb5bd; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">

    <!-- Page Header -->
    <div class="page-header">
        <h2><span style="color:#28a745;font-size:1.6rem;">&#10003;</span> Approved Swap Books</h2>
        <p>Browse all swap book requests that have been approved and are ready to swap.</p>
    </div>

    <!-- Live record count -->
    <div class="approved-strip">
        <span class="dot"></span>
        <asp:Label ID="lblCount" runat="server" Text="Loading..."></asp:Label>
    </div>

    <!-- Repeater — card grid -->
    <div class="row g-4" id="bookGrid">
        <asp:Repeater ID="rptBooks" runat="server" OnItemDataBound="rptBooks_ItemDataBound">
            <ItemTemplate>
                <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                    <a href='BookExchange.aspx?id=<%# Eval("SwapRequestId") %>' class="text-decoration-none">
                    <div class="book-card card" style="cursor:pointer;">

                        <!-- Front Photo -->
                        <div class="card-img-wrap">
                            <asp:Image ID="imgFront" runat="server" CssClass="book-front-img" AlternateText="Book Front" />
                            <div class="no-img" id="divNoImg" runat="server">&#128218;</div>
                            <span class="approved-ribbon">APPROVED</span>
                        </div>

                        <div class="card-body">
                            <div class="req-id">Request #<%# Eval("SwapRequestId") %></div>

                            <!-- Amount boxes -->
                            <div class="amount-row">
                                <div class="amount-box">
                                    <span class="label">Original</span>
                                    <span class="value">&#8377;<%# string.Format("{0:N2}", Eval("OriganalTotalAmount") == DBNull.Value ? 0 : Eval("OriganalTotalAmount")) %></span>
                                </div>
                                <div class="amount-box">
                                    <span class="label">Swap Price</span>
                                    <span class="value" style="color:#0f3460;">&#8377;<%# string.Format("{0:N2}", Eval("SecondTotalAmount") == DBNull.Value ? 0 : Eval("SecondTotalAmount")) %></span>
                                </div>
                            </div>

                            <!-- Meta chips -->
                            <div class="meta-row">
                                <span class="meta-chip">Edu: <%# Eval("EducationId") %></span>
                                <span class="meta-chip">Level: <%# Eval("EducationLevelId") %></span>
                                <span class="meta-chip">Sem: <%# Eval("Semester") %></span>
                                <span class="meta-chip">
                                    <%# (Eval("PaymentType") != DBNull.Value && Eval("PaymentType") != null && Convert.ToBoolean(Eval("PaymentType")))
                                        ? "Online" : "Cash" %>
                                </span>
                            </div>

                            <!-- Description -->
                            <asp:Panel ID="pnlDesc" runat="server" CssClass="desc-text"></asp:Panel>

                            <!-- Back photo button -->
                            <asp:HyperLink ID="lnkBackPhoto" runat="server" CssClass="btn btn-outline-secondary btn-sm mt-2 w-100">
                                View Back Photo
                            </asp:HyperLink>
                        </div>

                        <div class="card-footer-custom d-flex justify-content-between align-items-center">
                            <span>
                                <%# Eval("EntryDate") != DBNull.Value
                                    ? Convert.ToDateTime(Eval("EntryDate")).ToString("dd MMM yyyy")
                                    : "No Date" %>
                            </span>
                            <span class="badge bg-success">Approved</span>
                        </div>
                    </div><%-- book-card --%>
                    </a><%-- clickable link --%>
                </div><%-- col --%>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Empty state (shown when no records) -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-state">
            <div class="icon">&#128236;</div>
            <h4>No Approved Swap Books Yet</h4>
            <p>Check back later — approved swap requests will appear here.</p>
            <a href="SwapBook.aspx" class="btn btn-primary mt-2">Browse Available Books</a>
        </div>
    </asp:Panel>

    <!-- Photo Preview Modal -->
    <div class="modal fade" id="photoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="photoModalLabel">Book Photo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center pb-4">
                    <img id="modalPhotoImg" src="" alt="Book Photo" class="img-fluid" style="max-height:500px;" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
    <script>
        function showPhoto(src, title) {
            document.getElementById('modalPhotoImg').src = src;
            document.getElementById('photoModalLabel').innerText = title || 'Book Photo';
            var modal = new bootstrap.Modal(document.getElementById('photoModal'));
            modal.show();
        }

        // Make front-photo images clickable via delegation
        document.querySelectorAll('.book-front-img').forEach(function (img) {
            img.style.cursor = 'pointer';
            img.addEventListener('click', function () {
                showPhoto(this.src, 'Front Photo');
            });
        });
    </script>
</asp:Content>
