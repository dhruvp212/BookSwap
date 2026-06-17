<%@ Page Title="Library Dashboard" Language="C#" MasterPageFile="~/Library/Library.master" AutoEventWireup="true" CodeFile="LibraryHome.aspx.cs" Inherits="Library_LibraryHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="LibraryContent" Runat="Server">
    <div class="p-3">
        <h3 class="text-primary border-bottom pb-2 mb-4">Welcome to the Library Control Panel</h3>
        <p class="text-muted">Use the navigation menu on the left to manage your library's books, assignments, returns, and reports.</p>
        
        <div class="row mt-4">
            <div class="col-md-4 mb-3">
                <div class="card text-center shadow-sm">
                    <div class="card-body">
                        <h1 class="display-4 text-primary">&#128218;</h1>
                        <h5 class="card-title">Manage Books</h5>
                        <p class="card-text text-muted small">Add, update, or remove books</p>
                        <a href="ManageBookCenter.aspx" class="btn btn-outline-primary btn-sm">Go to Book Center</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center shadow-sm">
                    <div class="card-body">
                        <h1 class="display-4 text-success">&#128221;</h1>
                        <h5 class="card-title">Assignments</h5>
                        <p class="card-text text-muted small">Assign books to users</p>
                        <a href="ManageAssignBook.aspx" class="btn btn-outline-success btn-sm">Manage Assign</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center shadow-sm">
                    <div class="card-body">
                        <h1 class="display-4 text-info">&#128202;</h1>
                        <h5 class="card-title">View Reports</h5>
                        <p class="card-text text-muted small">Check activity reports</p>
                        <a href="Report.aspx" class="btn btn-outline-info btn-sm">View Report</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center shadow-sm border-warning">
                    <div class="card-body">
                        <h1 class="display-4 text-warning">&#128250;</h1>
                        <h5 class="card-title">Book Returns</h5>
                        <p class="card-text text-muted small">Process return requests & fines</p>
                        <a href="ReturnBook.aspx" class="btn btn-outline-warning btn-sm">Manage Returns</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
