<%@ Page Title="Verify Library" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="VerifyLibrary.aspx.cs" Inherits="Admin_VerifyLibrary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
    <div class="container-fluid py-4">
        <h3 class="mb-4 text-primary">Pending Library Approvals</h3>

        <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gridLibraries" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover table-striped mb-0 text-center" 
                        DataKeyNames="UserId" OnRowCommand="gridLibraries_RowCommand">
                        <HeaderStyle CssClass="bg-dark text-white" />
                        <Columns>
                            <asp:BoundField DataField="LibraryName" HeaderText="Library Name" />
                            <asp:BoundField DataField="OwnerName" HeaderText="Owner" />
                            <asp:BoundField DataField="LibraryContactNo" HeaderText="Contact No" />
                            <asp:BoundField DataField="Address" HeaderText="Address" />
                            
                            <asp:TemplateField HeaderText="Documents">
                                <ItemTemplate>
                                    <a href='<%# ResolveUrl(Eval("AddressProof").ToString()) %>' target="_blank" class="btn btn-sm btn-outline-secondary">Proof</a>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# Convert.ToBoolean(Eval("IsVerified")) ? "badge bg-success" : "badge bg-warning text-dark" %>'>
                                        <%# Convert.ToBoolean(Eval("IsVerified")) ? "Verified" : "Pending" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnAccept" runat="server" CommandName="Accept" 
                                        CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-sm btn-success m-1" 
                                        Visible='<%# !Convert.ToBoolean(Eval("IsVerified")) %>'
                                        OnClientClick="return confirm('Approve this library?');">
                                        Accept
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnReject" runat="server" CommandName="Reject" 
                                        CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-sm btn-danger m-1" 
                                        Visible='<%# !Convert.ToBoolean(Eval("IsVerified")) %>'
                                        OnClientClick="return confirm('Reject and delete this library application?');">
                                        Reject
                                    </asp:LinkButton>
                                    
                                    <a href='VerifyBooks.aspx?uid=<%# Eval("UserId") %>' class="btn btn-sm btn-info text-white m-1 shadow-sm">
                                        &#128218; View Books
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="p-4 text-muted border-top text-center">
                                No pending library registrations found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
