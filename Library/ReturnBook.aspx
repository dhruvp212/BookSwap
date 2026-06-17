<%@ Page Title="Handle Returns" Language="C#" MasterPageFile="~/Library/Library.master" AutoEventWireup="true" CodeFile="ReturnBook.aspx.cs" Inherits="Library_ReturnBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="LibraryContent" runat="Server">
    <div class="mb-4 d-flex justify-content-between align-items-center">
        <h3 class="text-primary fw-bold mb-0">Process Book Returns</h3>
        <span class="badge bg-warning text-dark p-2">Borrowed Books List</span>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

    <div class="table-responsive">
        <asp:GridView ID="gridReturns" runat="server" AutoGenerateColumns="False" 
            CssClass="table table-hover border text-center align-middle" 
            DataKeyNames="BookBorrowId" OnRowCommand="gridReturns_RowCommand">
            <HeaderStyle CssClass="bg-dark text-white" />
            <Columns>
                <asp:TemplateField HeaderText="Book Details">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' style="width:40px; height:60px; object-fit:cover; border-radius:4px; margin-right:10px;" />
                            <div class="text-start">
                                <strong class="d-block text-dark"><%# Eval("BookTitle") %></strong>
                                <small class="text-muted">ID: #<%# Eval("BookId") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="StudentName" HeaderText="Borrowed By" />
                <asp:TemplateField HeaderText="Deadlines">
                    <ItemTemplate>
                        <div class="text-success fw-bold"><%# Eval("BorrowDate", "{0:dd/MM/yyyy}") %></div>
                        <div class="text-danger fw-bold"><%# Eval("ReturnDate", "{0:dd/MM/yyyy}") %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Fine Calculation">
                    <ItemTemplate>
                        <%# (DateTime.Now > Convert.ToDateTime(Eval("ReturnDate"))) ? 
                            "<span class='text-danger fw-bold'>Overdue: " + (DateTime.Now - Convert.ToDateTime(Eval("ReturnDate"))).Days + " Days</span>" : 
                            "<span class='text-success fw-bold'>In Time</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Payment & Request Status">
                    <ItemTemplate>
                        <div class="mb-2">
                            <%# ToBool(Eval("IsReturnRequested")) ? "<span class='badge bg-info'>Return Requested</span>" : "<span class='badge bg-light text-dark'>Active Loan</span>" %>
                        </div>
                        <div>
                            <%# ToBool(Eval("IsFinePaid")) ? "<span class='badge bg-success'>Fine Paid</span>" : (ToDecimal(Eval("TotalFine")) > 0 ? "<span class='badge bg-danger'>Fine Pending</span>" : "<span class='badge bg-light text-dark'>No Fine</span>") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:PlaceHolder runat="server" Visible='<%# !ToBool(Eval("IsReturn")) %>'>
                            <asp:LinkButton ID="btnReturn" runat="server" CommandName="ProcessReturn" 
                                CommandArgument='<%# Eval("BookBorrowId") %>' 
                                CssClass='<%# "btn btn-sm shadow-sm px-3 " + (ToBool(Eval("IsReturnRequested")) ? "btn-success" : "btn-primary") %>'>
                                <i class='<%# ToBool(Eval("IsReturnRequested")) ? "ti ti-check" : "ti ti-rotate-clockwise" %>'></i> 
                                <%# ToBool(Eval("IsReturnRequested")) ? "Confirm Return" : "Force Return" %>
                            </asp:LinkButton>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder runat="server" Visible='<%# ToBool(Eval("IsReturn")) && !ToBool(Eval("IsFinePaid")) %>'>
                            <span class="text-danger fw-bold small">Awaiting Payment</span>
                        </asp:PlaceHolder>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-5 text-center">
                    <i class="ti ti-mood-smile fs-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">All books are currently in the library inventory.</h5>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
