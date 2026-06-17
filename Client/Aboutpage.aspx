<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/Aboutpage.aspx.cs" Inherits="Aboutpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <!-- Premium About Page -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <!-- Hero Section -->
            <div class="text-center py-5 mb-5 rounded-5" style="background: linear-gradient(135deg, #0f3460 0%, #16213e 100%); color: white;">
                <h1 class="display-4 fw-bold mb-3">Reimagining Reading</h1>
                <p class="lead opacity-75 mx-auto" style="max-width: 700px;">BookSwap is a digital bridge connecting readers to a universe of shared knowledge, promoting affordability and sustainability in every chapter.</p>
            </div>

            <!-- Content Grid -->
            <div class="row g-5 align-items-center mb-5">
                <div class="col-md-6">
                    <h2 class="fw-bold mb-4">Our Vision</h2>
                    <p class="text-secondary fs-5 lh-lg">We believe that every book has the power to change lives, and through our platform, we aim to keep books circulating and stories alive. Our goal is to make reading accessible to every student and book lover without the burden of high costs.</p>
                </div>
                <div class="col-md-6">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="p-4 rounded-4 shadow-sm bg-white border text-center h-100">
                                <i class="ti ti-heart-handshake fs-1 text-primary mb-3"></i>
                                <h5 class="fw-bold">Community</h5>
                                <p class="small text-muted mb-0">Built by readers, for readers.</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-4 rounded-4 shadow-sm bg-white border text-center h-100">
                                <i class="ti ti-leaf fs-1 text-success mb-3"></i>
                                <h5 class="fw-bold">Eco-Friendly</h5>
                                <p class="small text-muted mb-0">Reusing books for a better planet.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Mission Footer -->
            <div class="alert alert-primary p-5 rounded-5 border-0 text-center shadow-sm">
                <h3 class="fw-bold mb-3">Help Us Grow the Digital Library</h3>
                <p class="mb-4">Every book shared is a door opened for someone else. Join thousands of students who are already part of the BookSwap revolution.</p>
                <a href="StudentReg.aspx" class="btn btn-primary btn-lg px-5 rounded-pill fw-bold shadow">Join the Community</a>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" Runat="Server">
</asp:Content>

