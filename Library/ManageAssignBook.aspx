<%@ Page Title="Manage Assign Books" Language="C#" MasterPageFile="~/Library/Library.master" AutoEventWireup="true" CodeFile="ManageAssignBook.aspx.cs" Inherits="Library_ManageAssignBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="LibraryContent" runat="Server">
    <div class="mb-4 d-flex justify-content-between align-items-center">
        <h3 class="text-primary fw-bold mb-0">Pending Borrow Requests</h3>
        <span class="badge bg-info p-2">Awaiting Approval</span>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

    <div class="table-responsive">
        <asp:GridView ID="gridAssign" runat="server" AutoGenerateColumns="False" 
            CssClass="table table-hover border text-center align-middle" 
            DataKeyNames="BookBorrowId" OnRowCommand="gridAssign_RowCommand">
            <HeaderStyle CssClass="bg-dark text-white" />
            <Columns>
                <asp:TemplateField HeaderText="Book">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' style="width:40px; height:60px; object-fit:cover; border-radius:4px; margin-right:10px;" />
                            <div class="text-start">
                                <strong class="d-block text-dark"><%# Eval("BookTitle") %></strong>
                                <small class="text-muted"><%# Eval("Auther") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="StudentName" HeaderText="Student" />
                <asp:TemplateField HeaderText="Duration">
                    <ItemTemplate>
                        <div><%# Eval("BorrowDate", "{0:dd MMM yyyy}") %> - <%# Eval("ReturnDate", "{0:dd MMM yyyy}") %></div>
                        <small class="text-primary fw-bold"><%# Eval("TotalDay") %> Days</small>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="EntryDate" HeaderText="Requested On" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="ApproveRequest" 
                            CommandArgument='<%# Eval("BookBorrowId") %>' CssClass="btn btn-sm btn-success shadow-sm">
                            <i class="ti ti-check"></i> Approve & Assign
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnReject" runat="server" CommandName="RejectRequest" 
                            CommandArgument='<%# Eval("BookBorrowId") %>' CssClass="btn btn-sm btn-danger shadow-sm ms-2"
                            OnClientClick="return confirm('Are you sure you want to reject this request?');">
                            <i class="ti ti-x"></i> Reject
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-5 text-center">
                    <i class="ti ti-clipboard-x fs-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">No pending borrow requests found.</h5>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
