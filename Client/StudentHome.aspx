<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="~/Client/StudentHome.aspx.cs" Inherits="Client_Student_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    
    <!-- Hero Greeting -->
    <div class="mb-5">
        <h2 class="fw-bold text-dark">Hello, Student! 👋</h2>
        <p class="text-muted fs-5">Welcome back to your academic hub. What would you like to do today?</p>
    </div>

    <!-- Quick Actions / Stats -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <i class="ti ti-books fs-1"></i>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">Inventory</span>
                    </div>
                    <h5 class="card-title fw-bold">My Books</h5>
                    <p class="card-text mb-3 opacity-75">Manage the books you've listed for swapping.</p>
                    <a href="AddbookList.aspx" class="btn btn-light btn-sm fw-bold rounded-pill px-4">View All</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 text-white" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <i class="ti ti-rotate fs-1"></i>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">History</span>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Exchange History</h5>
                    <p class="card-text mb-3 text-dark opacity-75">Check your completed book swaps.</p>
                    <a href="ApprovedSwapList.aspx" class="btn btn-dark btn-sm fw-bold rounded-pill px-4">See History</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 text-white" style="background: linear-gradient(135deg, #38f9d7 0%, #43e97b 100%);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <i class="ti ti-building-library fs-1"></i>
                        <span class="badge bg-white bg-opacity-25 rounded-pill px-3 py-2">Library</span>
                    </div>
                    <h5 class="card-title fw-bold text-dark">Library Borrows</h5>
                    <p class="card-text mb-3 text-dark opacity-75">Track your active library bookings.</p>
                    <a href="MyLibraryBorrows.aspx" class="btn btn-dark btn-sm fw-bold rounded-pill px-4">Manage Borrows</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Secondary Call to Action -->
    <div class="row">
        <div class="col-12">
            <div class="p-5 rounded-5 border-dashed border-2 d-flex flex-column align-items-center justify-content-center text-center" style="background: #fdfdfd; border: 2px dashed #e2e8f0;">
                <div class="bg-primary bg-opacity-10 p-4 rounded-circle mb-4">
                    <i class="ti ti-plus fs-1 text-primary"></i>
                </div>
                <h4 class="fw-bold">Start a New Adventure</h4>
                <p class="text-muted mb-4" style="max-width: 400px;">Share a book from your collection or find something new to learn today from our community.</p>
                <div class="d-flex gap-3">
                    <a href="Addbook.aspx" class="btn btn-primary px-5 py-2 rounded-3 fw-bold shadow">Add a New Book</a>
                    <a href="SwapBook.aspx" class="btn btn-outline-primary px-5 py-2 rounded-3 fw-bold">Browse Library</a>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
