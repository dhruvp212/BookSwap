<%@ Page Title="Student Registration - BookSwap" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="StudentReg.aspx.cs" Inherits="Client_StudentLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="glass-form-card shadow-lg">
                    <div class="text-center mb-5">
                        <div class="p-3 rounded-circle bg-accent-light d-inline-block mb-3">
                            <i data-lucide="user-plus" class="size-8 text-primary"></i>
                        </div>
                        <h1 class="display-5 fw-bold animate-color">Join BookSwap</h1>
                        <p class="text-secondary">Create your account and become part of our local reading community.</p>
                    </div>

                    <div class="row g-4">
                        <!-- Left Column: Personal Info -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="d-flex align-items-center gap-2"><i data-lucide="user" class="size-4"></i> Full Name</label>
                                <asp:TextBox ID="Txtfullname" CssClass="form-control" runat="server" placeholder="John Doe"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator1" runat="server" 
                                    ErrorMessage="Name is required" ControlToValidate="Txtfullname"></asp:RequiredFieldValidator>
                            </div>
                            <div class="mb-4">
                                <label class="d-flex align-items-center gap-2"><i data-lucide="mail" class="size-4"></i> Email Address</label>
                                <asp:TextBox ID="Email" CssClass="form-control" type="email" runat="server" placeholder="johndoe@email.com"></asp:TextBox>
                            </div>
                            <div class="mb-4">
                                <label class="d-flex align-items-center gap-2"><i data-lucide="phone" class="size-4"></i> Mobile Number</label>
                                <asp:TextBox ID="Mobile" CssClass="form-control" runat="server" placeholder="10-digit number"></asp:TextBox>
                            </div>
                            <div class="mb-4">
                                <label class="d-flex align-items-center gap-2"><i data-lucide="lock" class="size-4"></i> Secure Password</label>
                                <asp:TextBox ID="Password" TextMode="Password" CssClass="form-control" runat="server" placeholder="********"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Right Column: Location -->
                        <div class="col-md-6">
                            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <div class="mb-4">
                                        <label class="d-flex align-items-center gap-2"><i data-lucide="map-pin" class="size-4"></i> City</label>
                                        <asp:DropDownList ID="dropCity" AutoPostBack="true" OnSelectedIndexChanged="dropCity_SelectedIndexChanged" CssClass="form-select" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="mb-4">
                                        <label class="d-flex align-items-center gap-2"><i data-lucide="map" class="size-4"></i> Area</label>
                                        <asp:DropDownList ID="dropArea" CssClass="form-select" runat="server"></asp:DropDownList>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <div class="row g-3">
                                <div class="col-8">
                                    <label class="d-flex align-items-center gap-2"><i data-lucide="home" class="size-4"></i> Full Address</label>
                                    <asp:TextBox ID="txtAddress" TextMode="MultiLine" Rows="2" CssClass="form-control" runat="server" placeholder="Street, Landmark..."></asp:TextBox>
                                </div>
                                <div class="col-4">
                                    <label class="d-flex align-items-center gap-2"><i data-lucide="hash" class="size-4"></i> Pincode</label>
                                    <asp:TextBox ID="txtPincode" CssClass="form-control" runat="server" placeholder="6-digit"></asp:TextBox>
                                    <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator3" runat="server" 
                                        ErrorMessage="Pincode is required" ControlToValidate="txtPincode"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Section -->
                        <div class="col-12 text-center mt-5">
                            <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2 shadow-lg" OnClick="btnsave_Click">
                                <i data-lucide="user-check" class="size-5"></i> Complete Registration
                            </asp:LinkButton>
                            <p class="mt-4 text-secondary">
                                Already have an account? <a href="login.aspx" class="text-primary fw-bold text-decoration-none hover-accent">Log In here</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
</asp:Content>
