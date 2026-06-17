<%@ Page Title="Library Reports" Language="C#" MasterPageFile="~/Library/Library.master" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Library_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="LibraryContent" runat="Server">
    <div class="mb-5">
        <h3 class="text-primary fw-bold">Library Performance Report</h3>
        <p class="text-muted">Overview of your inventory and borrowing statistics.</p>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card bg-primary text-white shadow-sm border-0 h-100">
                <div class="card-body text-center">
                    <i class="ti ti-books fs-1 mb-2"></i>
                    <h5 class="card-title opacity-75">Total Books</h5>
                    <h2 class="fw-bold"><asp:Literal ID="litTotalBooks" runat="server">0</asp:Literal></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white shadow-sm border-0 h-100">
                <div class="card-body text-center">
                    <i class="ti ti-check fs-1 mb-2"></i>
                    <h5 class="card-title opacity-75">Active Loans</h5>
                    <h2 class="fw-bold"><asp:Literal ID="litActiveLoans" runat="server">0</asp:Literal></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white shadow-sm border-0 h-100">
                <div class="card-body text-center">
                    <i class="ti ti-history fs-1 mb-2"></i>
                    <h5 class="card-title opacity-75">Total Returns</h5>
                    <h2 class="fw-bold"><asp:Literal ID="litTotalReturns" runat="server">0</asp:Literal></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-danger text-white shadow-sm border-0 h-100">
                <div class="card-body text-center">
                    <i class="ti ti-coin fs-1 mb-2"></i>
                    <h5 class="card-title opacity-75">Total Fines</h5>
                    <h2 class="fw-bold"><asp:Literal ID="litTotalFines" runat="server">0</asp:Literal></h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activity Table -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 border-bottom">
            <h5 class="mb-0 fw-bold">Recent Borrowing Activity</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="gridActivity" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover mb-0 text-center align-middle">
                    <HeaderStyle CssClass="bg-light" />
                    <Columns>
                        <asp:BoundField DataField="BookTitle" HeaderText="Book" />
                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                        <asp:BoundField DataField="EntryDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusClass(Eval("Status"), Eval("IsReturn")) %>'>
                                    <%# GetStatusText(Eval("Status"), Eval("IsReturn")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
