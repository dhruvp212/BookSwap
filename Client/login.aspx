<%@ Page Title="Login - BookSwap" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/login.aspx.cs" Inherits="login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
  <%-- Internal styles removed to use global ModernUI theme --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="container py-5">
    <div class="row justify-content-center align-items-center" style="min-height: 70vh;">
        <div class="col-md-5 col-lg-4">
            <div class="login-card glass-card p-5 fade-in">
                <div class="text-center mb-5">
                    <div class="brand-icon mb-3">
                        <i data-lucide="lock" class="size-12 animate-color"></i>
                    </div>
                    <h2 class="login-title fw-bold">Welcome Back</h2>
                    <p class="text-secondary small">Access your account to continue swapping.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center mb-3 fw-bold"></asp:Label>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0 border-glass"><i data-lucide="mail" class="size-4 text-secondary"></i></span>
                        <asp:TextBox ID="txtEmail" type="Email" runat="server" CssClass="form-control border-start-0" placeholder="name@example.com"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator2" runat="server" 
                        ErrorMessage="Email is required" ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <label class="form-label small fw-bold">Password</label>
                        <a href="#" class="small text-primary text-decoration-none">Forgot?</a>
                    </div>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0 border-glass"><i data-lucide="key" class="size-4 text-secondary"></i></span>
                        <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" CssClass="form-control border-start-0" placeholder="********"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator4" runat="server" 
                        ErrorMessage="Password is required" ControlToValidate="txtPassword"></asp:RequiredFieldValidator>
                </div>

                <asp:LinkButton ID="lnkLogin" runat="server" CssClass="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2" OnClick="lnkLogin_Click1">
                    <i data-lucide="log-in" class="size-4"></i> Sign In
                </asp:LinkButton>
                
                <div class="divider"><span>OR</span></div>

                <div class="text-center">
                    <p class="text-secondary small mb-2">New here? <a href="StudentReg.aspx" class="text-primary fw-bold text-decoration-none">Create Student Account</a></p>
                    <p class="text-secondary small">Running a library? <a href="registerpage.aspx" class="text-primary fw-bold text-decoration-none text-accent">Register Library</a></p>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
</asp:Content>
