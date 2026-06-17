<%@ Page Title="Page Not Found - BookSwap" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="py-5 text-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="glass-form-card shadow-lg py-5">
                    <div class="mb-4">
                        <div class="p-4 rounded-circle bg-accent-light d-inline-block">
                            <i data-lucide="search-x" class="size-12 text-primary"></i>
                        </div>
                    </div>
                    <h1 class="display-1 fw-bold text-primary mb-2">404</h1>
                    <h2 class="fw-bold mb-4">Page Not Found</h2>
                    <p class="text-secondary mb-5 px-md-5">
                        Oops! The book you're looking for seems to have been misplaced. 
                        The link might be broken or the page has been moved.
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="Home.aspx" class="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2">
                            <i data-lucide="home" class="size-5"></i> Back to Home
                        </a>
                        <a href="contactpage.aspx" class="btn btn-outline-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2">
                            <i data-lucide="help-circle" class="size-5"></i> Contact Support
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
