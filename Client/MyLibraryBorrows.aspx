<%@ Page Title="My Library Borrows" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="MyLibraryBorrows.aspx.cs" Inherits="Client_MyLibraryBorrows" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    <div class="mb-4">
        <h3 class="text-primary fw-bold">My Library Borrows</h3>
        <p class="text-muted">Track all your current and past borrowings from verified libraries.</p>
    </div>

    <asp:GridView ID="gridMyBorrows" runat="server" AutoGenerateColumns="False" 
        CssClass="table table-hover border text-center align-middle bg-white shadow-sm" 
        DataKeyNames="BookBorrowId" OnRowCommand="gridMyBorrows_RowCommand">
        <HeaderStyle CssClass="bg-dark text-white" />
        <Columns>
            <asp:TemplateField HeaderText="Book">
                <ItemTemplate>
                    <div class="d-flex align-items-center">
                        <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' style="width:40px; height:55px; object-fit:cover; border-radius:4px; margin-right:10px;" />
                        <div class="text-start">
                            <strong class="d-block text-dark"><%# Eval("BookTitle") %></strong>
                            <small class="text-muted"><%# Eval("Auther") %></small>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:BoundField DataField="LibraryName" HeaderText="Library" />
            
            <asp:TemplateField HeaderText="Dates">
                <ItemTemplate>
                    <div class="small">
                        <strong>Borrow:</strong> <%# Eval("BorrowDate", "{0:dd MMM yyyy}") %><br />
                        <strong>Return:</strong> <%# Eval("ReturnDate", "{0:dd MMM yyyy}") %>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <div class="mb-2">
                        <span class='<%# GetStatusClass(Eval("Status"), Eval("IsReturn")) %>'>
                            <%# GetStatusText(Eval("Status"), Eval("IsReturn")) %>
                        </span>
                    </div>
                    
                    <div class="mt-2 text-center">
                        <%-- Pay Fine Button --%>
                        <asp:HyperLink ID="lnkPayFine" runat="server" 
                            Visible='<%# IsFineUnpaid(Eval("IsFineAplicable"), Eval("IsFinePaid")) %>'
                            NavigateUrl='<%# "Payment.aspx?id=" + Eval("BookBorrowId") + "&amt=" + Eval("TotalFine") %>'
                            CssClass="btn btn-warning btn-sm fw-bold px-3 shadow-sm mb-1 d-block mx-auto">
                            Pay Fine: <%# string.Format("{0:C}", Eval("TotalFine")) %>
                        </asp:HyperLink>

                        <%-- Normal Return Button --%>
                        <asp:LinkButton ID="btnRequestReturn" runat="server" 
                            CommandName="RequestReturn" CommandArgument='<%# Eval("BookBorrowId") %>'
                            Visible='<%# !ToBool(Eval("IsReturn")) && !ToBool(Eval("IsReturnRequested")) && Convert.ToInt32(Eval("Status")) == 1 %>'
                            CssClass="btn btn-outline-primary btn-sm fw-bold px-3 shadow-sm mb-1 d-block mx-auto">
                            Return Book
                        </asp:LinkButton>

                        <%-- requested Badge --%>
                        <asp:PlaceHolder runat="server" Visible='<%# ToBool(Eval("IsReturnRequested")) && !ToBool(Eval("IsReturn")) %>'>
                            <span class="badge bg-info d-block mx-auto" style="max-width:140px;">Return Requested</span>
                        </asp:PlaceHolder>

                        <%-- final Done Badge --%>
                        <asp:PlaceHolder runat="server" Visible='<%# ToBool(Eval("IsReturn")) && (!ToBool(Eval("IsFineAplicable")) || ToBool(Eval("IsFinePaid"))) %>'>
                            <span class="badge bg-success d-block mx-auto" style="max-width:100px;">
                                <i class="ti ti-check me-1"></i>Done
                            </span>
                        </asp:PlaceHolder>

                        <%-- Returned but fine pending --%>
                         <asp:PlaceHolder runat="server" Visible='<%# ToBool(Eval("IsReturn")) && ToBool(Eval("IsFineAplicable")) && !ToBool(Eval("IsFinePaid")) %>'>
                            <span class="badge bg-danger d-block mx-auto" style="max-width:140px;">Returned (Fine Due)</span>
                        </asp:PlaceHolder>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Days Left">
                <ItemTemplate>
                    <%# GetDaysLeftText(Eval("Status"), Eval("IsReturn"), Eval("ReturnDate")) %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="p-5 text-center text-muted">
                <h5 class="mb-0">You haven't borrowed any books from libraries yet.</h5>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>
