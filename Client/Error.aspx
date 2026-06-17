<%@ Page Title="System Error - BookSwap" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="py-5 text-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="glass-form-card shadow-lg py-5">
                    <div class="mb-4">
                        <div class="p-4 rounded-circle bg-danger bg-opacity-10 d-inline-block">
                            <i data-lucide="alert-triangle" class="size-12 text-danger"></i>
                        </div>
                    </div>
                    <h1 class="display-3 fw-bold text-danger mb-2">Error</h1>
                    <h2 class="fw-bold mb-4">Something went wrong</h2>
                    <p class="text-secondary mb-5 px-md-5">
                        Our librarians are working to fix a system error. 
                        Please try refreshing the page or come back in a few minutes.
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="Home.aspx" class="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2">
                            <i data-lucide="refresh-cw" class="size-5"></i> Refresh Page
                        </a>
                        <a href="Home.aspx" class="btn btn-outline-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2">
                            <i data-lucide="home" class="size-5"></i> Return Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
