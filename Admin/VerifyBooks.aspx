<%@ Page Title="Verify Books" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="VerifyBooks.aspx.cs" Inherits="Admin_VerifyBooks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
    <div class="container-fluid py-4">
        <h3 class="mb-4 text-primary">
            <asp:Label ID="lblTitle" runat="server" Text="Pending Book Approvals"></asp:Label>
        </h3>

        <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gridBooks" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover table-striped mb-0 text-center" 
                        DataKeyNames="BookId" OnRowCommand="gridBooks_RowCommand">
                        <HeaderStyle CssClass="bg-dark text-white" />
                        <Columns>
                            <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            <asp:BoundField DataField="Auther" HeaderText="Author" />
                            <asp:BoundField DataField="INSBNO" HeaderText="ISBN" />
                            
                            <asp:TemplateField HeaderText="Rent Price">
                                <ItemTemplate>
                                    <%# Eval("RentPriceperDay", "{0:C}") %> / day
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Cover Photo">
                                <ItemTemplate>
                                    <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' alt="Book Cover" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# Convert.ToBoolean(Eval("IsVerified")) ? "badge bg-success" : "badge bg-warning text-dark" %>'>
                                        <%# Convert.ToBoolean(Eval("IsVerified")) ? "Verified" : "Pending" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnAccept" runat="server" CommandName="AcceptBook" 
                                        CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-sm btn-success m-1" 
                                        Visible='<%# !Convert.ToBoolean(Eval("IsVerified")) %>'
                                        OnClientClick="return confirm('Approve this book?');">
                                        Accept
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnReject" runat="server" CommandName="RejectBook" 
                                        CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-sm btn-danger m-1" 
                                        Visible='<%# !Convert.ToBoolean(Eval("IsVerified")) %>'
                                        OnClientClick="return confirm('Reject and delete this book?');">
                                        Reject
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="p-4 text-muted border-top text-center">
                                No books found matching the active criteria.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
