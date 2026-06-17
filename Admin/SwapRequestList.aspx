<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/SwapRequestList.aspx.cs" Inherits="Admin_SwapRequestList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .badge-pending   { background-color: #f0ad4e; color: #fff; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .badge-approved  { background-color: #5cb85c; color: #fff; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .badge-denied    { background-color: #d9534f; color: #fff; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .book-thumb      { width: 60px; height: 70px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; cursor: pointer; }
        .book-thumb-placeholder { width: 60px; height: 70px; background: #f0f0f0; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 11px; border: 1px solid #ddd; }
        .filter-bar      { background: #f8f9fa; border-radius: 8px; padding: 14px 18px; margin-bottom: 18px; }
        .action-btns .btn { min-width: 80px; }
        /* Modal image */
        #imgModal .modal-body img { max-width: 100%; border-radius: 8px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h1 class="mb-0"><i class="ti ti-books me-2"></i>Swap Book Requests</h1>
            <span class="badge bg-primary fs-6" id="totalBadge" runat="server"></span>
        </div>

        <!-- Filter Bar -->
        <div class="card-body pb-0">
            <div class="filter-bar d-flex flex-wrap gap-3 align-items-center">
                <label class="fw-semibold mb-0">Filter by Status:</label>
                <asp:LinkButton ID="btnFilterAll"      runat="server" CssClass="btn btn-sm btn-outline-secondary" CommandArgument="All"      OnClick="FilterStatus_Click">All</asp:LinkButton>
                <asp:LinkButton ID="btnFilterPending"  runat="server" CssClass="btn btn-sm btn-warning"           CommandArgument="0"       OnClick="FilterStatus_Click">Pending</asp:LinkButton>
                <asp:LinkButton ID="btnFilterApproved" runat="server" CssClass="btn btn-sm btn-success"           CommandArgument="1"       OnClick="FilterStatus_Click">Approved</asp:LinkButton>
                <asp:LinkButton ID="btnFilterDenied"   runat="server" CssClass="btn btn-sm btn-danger"            CommandArgument="2"       OnClick="FilterStatus_Click">Denied</asp:LinkButton>
            </div>
        </div>

        <div class="card-body table-responsive">
            <asp:GridView ID="gridSwapList"
                          runat="server"
                          AutoGenerateColumns="False"
                          CssClass="table table-hover border align-middle"
                          OnRowCommand="gridSwapList_RowCommand"
                          EmptyDataText="No swap requests found.">
                <Columns>

                    <asp:TemplateField HeaderText="#">
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Request ID">
                        <ItemTemplate>
                            <strong>#<%# Eval("SwapRequestId") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="User ID">
                        <ItemTemplate><%# Eval("Userid") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Education">
                        <ItemTemplate><%# Eval("EducationId") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Level">
                        <ItemTemplate><%# Eval("EducationLevelId") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Semester">
                        <ItemTemplate><%# Eval("Semester") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Front Photo">
                        <ItemTemplate>
                            <%# !string.IsNullOrEmpty(Eval("PhotoFront").ToString())
                                ? "<img src='" + ResolveUrl(Eval("PhotoFront").ToString()) + "' class='book-thumb' onclick=\"showImage(this.src)\" title='Click to enlarge' />"
                                : "<div class='book-thumb-placeholder'>No Image</div>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Back Photo">
                        <ItemTemplate>
                            <%# !string.IsNullOrEmpty(Eval("PhotoEnd").ToString())
                                ? "<img src='" + ResolveUrl(Eval("PhotoEnd").ToString()) + "' class='book-thumb' onclick=\"showImage(this.src)\" title='Click to enlarge' />"
                                : "<div class='book-thumb-placeholder'>No Image</div>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Original Amount">
                        <ItemTemplate>
                            <span class="fw-semibold">&#8377;<%# string.Format("{0:N2}", Eval("OriganalTotalAmount")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Second Amount">
                        <ItemTemplate>
                            <span class="fw-semibold">&#8377;<%# string.Format("{0:N2}", Eval("SecondTotalAmount")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Payment">
                        <ItemTemplate>
                            <%# (Eval("PaymentType") != DBNull.Value && Eval("PaymentType") != null && Convert.ToBoolean(Eval("PaymentType")))
                                ? "<span class='badge bg-info'>Online</span>"
                                : "<span class='badge bg-secondary'>Cash</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Paid">
                        <ItemTemplate>
                            <%# (Eval("Ispaid") != DBNull.Value && Eval("Ispaid") != null && Convert.ToBoolean(Eval("Ispaid")))
                                ? "<span class='badge bg-success'>Yes</span>"
                                : "<span class='badge bg-danger'>No</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Description">
                        <ItemTemplate>
                            <span title='<%# Eval("Discription") %>'>
                                <%# Eval("Discription") != null && Eval("Discription").ToString().Length > 30
                                    ? Eval("Discription").ToString().Substring(0, 30) + "..."
                                    : Eval("Discription") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Entry Date">
                        <ItemTemplate>
                            <%# Eval("EntryDate") != null && Eval("EntryDate").ToString() != ""
                                ? Convert.ToDateTime(Eval("EntryDate")).ToString("dd MMM yyyy")
                                : "-" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Swap Status">
                        <ItemTemplate>
                            <%# GetSwapStatusBadge(Eval("SwapStatus")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="d-flex gap-2 action-btns">
                                <asp:LinkButton
                                    ID="lnkApprove"
                                    runat="server"
                                    CommandName="Approve"
                                    CommandArgument='<%# Eval("SwapRequestId") %>'
                                    CssClass="btn btn-success btn-sm"
                                    OnClientClick="return confirm('Approve this swap request?')"
                                    Visible='<%# !(Eval("SwapStatus") != DBNull.Value && Eval("SwapStatus") != null && Convert.ToByte(Eval("SwapStatus")) == 1) %>'>
                                    <i class="ti ti-check me-1"></i>Approve
                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="lnkDeny"
                                    runat="server"
                                    CommandName="Deny"
                                    CommandArgument='<%# Eval("SwapRequestId") %>'
                                    CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Deny this swap request?')"
                                    Visible='<%# !(Eval("SwapStatus") != DBNull.Value && Eval("SwapStatus") != null && Convert.ToByte(Eval("SwapStatus")) == 2) %>'>
                                    <i class="ti ti-x me-1"></i>Deny
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Image Preview Modal -->
    <div class="modal fade" id="imgModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Book Photo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImg" src="" alt="Book Photo" class="img-fluid" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" runat="Server">
    <script>
        function showImage(src) {
            document.getElementById('modalImg').src = src;
            var modal = new bootstrap.Modal(document.getElementById('imgModal'));
            modal.show();
        }
    </script>
</asp:Content>
