<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/browse.aspx.cs" Inherits="Client_browse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">


    <h2 class="fw-bold mb-4">Browse Books</h2>

    <!-- Search Section -->
    <div class="row mb-4">
        <div class="col-md-6">
            <input type="text" class="form-control" placeholder="Search by title, author, or ISBN..."/>
        </div>

        <div class="col-md-2">
            <select class="form-select">
                <option>All Categories</option>
                <option>Novel</option>
                <option>Story</option>
                <option>Education</option>
            </select>
        </div>

        <div class="col-md-2">
            <select class="form-select">
                <option>All Conditions</option>
                <option>New</option>
                <option>Good</option>
                <option>Fair</option>
            </select>
        </div>

        <div class="col-md-2">
            <button class="btn btn-primary w-100">Search</button>
        </div>
    </div>

    <!-- Book Cards -->
    <div class="row g-4">

        <!-- Book 1 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm">
                <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f" class="card-img-top">
                <div class="card-body">
                    <h6 class="card-title">The Great Gatsby</h6>
                    <p class="text-muted small">F. Scott Fitzgerald</p>
                    <div class="d-flex justify-content-between">
                        <span class="badge bg-secondary">Like New</span>
                        <span class="fw-bold text-primary">?150</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Book 2 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm">
                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794" class="card-img-top">
                <div class="card-body">
                    <h6 class="card-title">To Kill a Mockingbird</h6>
                    <p class="text-muted small">Harper Lee</p>
                    <div class="d-flex justify-content-between">
                        <span class="badge bg-success">Good</span>
                        <span class="fw-bold text-primary">?120</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Book 3 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm">
                <img src="https://images.unsplash.com/photo-1524578271613-d550eacf6090" class="card-img-top">
                <div class="card-body">
                    <h6 class="card-title">1984</h6>
                    <p class="text-muted small">George Orwell</p>
                    <div class="d-flex justify-content-between">
                        <span class="badge bg-primary">New</span>
                        <span class="fw-bold text-primary">?180</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Book 4 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm">
                <img src="https://images.unsplash.com/photo-1519681393784-d120267933ba" class="card-img-top">
                <div class="card-body">
                    <h6 class="card-title">Pride and Prejudice</h6>
                    <p class="text-muted small">Jane Austen</p>
                    <div class="d-flex justify-content-between">
                        <span class="badge bg-warning text-dark">Fair</span>
                        <span class="fw-bold text-primary">?100</span>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Pagination -->
    <nav class="mt-5">
        <ul class="pagination justify-content-center">
            <li class="page-item"><a class="page-link" href="#">Previous</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">Next</a></li>
        </ul>
    </nav>
    
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
</asp:Content>

