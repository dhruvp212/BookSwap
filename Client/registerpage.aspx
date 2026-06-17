<%@ Page Title="Library Registration - BookSwap" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/registerpage.aspx.cs" Inherits="registerpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
  <style>
    .lib-reg-container { background: #f8fbff; min-height: 100vh; padding: 60px 0; }
    .lib-reg-card { background: #fff; border-radius: 24px; box-shadow: 0 20px 60px rgba(0,0,0,0.04); overflow: hidden; border: 1px solid rgba(0,0,0,0.01); }
    .lib-reg-header { background: linear-gradient(135deg, #0f3460 0%, #16213e 100%); padding: 50px 40px; color: white; text-align: center; }
    .lib-reg-body { padding: 50px; }
    .form-label { font-weight: 700; color: #1e293b; font-size: 0.85rem; margin-bottom: 8px; }
    .form-control, .form-select { border-radius: 12px; padding: 12px 16px; border: 1.5px solid #e2e8f0; transition: 0.3s; background-color: #fcfdfe; }
    .form-control:focus, .form-select:focus { border-color: #4e73df; box-shadow: 0 0 0 4px rgba(78, 115, 223, 0.1); background-color: #fff; }
    .section-header { position: relative; padding-bottom: 12px; margin-bottom: 30px; font-weight: 800; color: #0f3460; letter-spacing: 0.5px; }
    .section-header::after { content: ''; position: absolute; bottom: 0; left: 0; width: 60px; height: 4px; background: #4e73df; border-radius: 10px; }
    .btn-register { background: #4e73df; color: white; padding: 16px 50px; border-radius: 14px; font-weight: 700; border: none; transition: 0.3s; font-size: 1.1rem; }
    .btn-register:hover { background: #375ace; transform: translateY(-3px); box-shadow: 0 15px 30px rgba(78, 115, 223, 0.25); color: white; }
    .upload-box { background: #f8fafc; border: 2px dashed #e2e8f0; padding: 15px; border-radius: 14px; text-align: center; transition: 0.3s; }
    .upload-box:hover { border-color: #4e73df; background: #f1f5f9; }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="lib-reg-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="lib-reg-card">
                    <div class="lib-reg-header">
                        <h2 class="fw-bold mb-2">Library Partnership Program</h2>
                        <p class="mb-0 opacity-75">Register your library and help students access books easily.</p>
                    </div>

                    <div class="lib-reg-body">
                        <div class="row g-4">
                            
                            <!-- Section: Owner Info -->
                            <div class="col-12 mt-2">
                                <h5 class="section-header">1. Account & Owner Information</h5>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Owner Full Name *</label>
                                <asp:TextBox ID="Txtfullname" CssClass="form-control" runat="server" placeholder="Enter name"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Required" ControlToValidate="Txtfullname" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Email Address * (Login ID)</label>
                                <asp:TextBox ID="txtEmail" type="Email" CssClass="form-control" runat="server" placeholder="library@example.com"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Required" ControlToValidate="txtEmail" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Create Password *</label>
                                <asp:TextBox ID="TxtPassword" TextMode="Password" CssClass="form-control" runat="server" placeholder="********"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator4" runat="server" ErrorMessage="Required" ControlToValidate="TxtPassword" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Verify Password *</label>
                                <asp:TextBox ID="TxtConformPassword" TextMode="Password" CssClass="form-control" runat="server" placeholder="********"></asp:TextBox>
                                <asp:RequiredFieldValidator CssClass="text-danger small mt-1 d-block" ID="RequiredFieldValidator5" runat="server" ErrorMessage="Required" ControlToValidate="TxtConformPassword" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Passwords do not match" CssClass="text-danger small mt-1 d-block" ControlToCompare="TxtPassword" ControlToValidate="TxtConformPassword" Display="Dynamic"></asp:CompareValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Owner Mobile Number *</label>
                                <asp:TextBox ID="txtOwnerContact" CssClass="form-control" runat="server" placeholder="10-digit mobile"></asp:TextBox>
                            </div>

                            <!-- Section: Library Info -->
                            <div class="col-12 mt-5">
                                <h5 class="section-header">2. Library Physical Location</h5>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Library Name *</label>
                                <asp:TextBox ID="txtLibraryName" CssClass="form-control" runat="server" placeholder="Empire Public Library"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Official Contact Number *</label>
                                <asp:TextBox ID="txtLibraryContact" CssClass="form-control" runat="server" placeholder="Library phone"></asp:TextBox>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Select City *</label>
                                <asp:DropDownList ID="dropCity" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="dropCity_SelectedIndexChanged"></asp:DropDownList>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Select Area *</label>
                                <asp:DropDownList ID="dropArea" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>

                            <div class="col-12">
                                <label class="form-label text-uppercase">Complete Physical Address *</label>
                                <asp:TextBox ID="txtAddress" TextMode="MultiLine" Rows="3" CssClass="form-control" runat="server" placeholder="Floor, Building, Street details..."></asp:TextBox>
                            </div>

                            <!-- Section: Verification -->
                            <div class="col-12 mt-5">
                                <h5 class="section-header">3. Identity & Verification Documents</h5>
                                <p class="text-secondary small mb-4">Please upload clear photos/documents for account verification.</p>
                            </div>

                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Address Proof *</label>
                                    <asp:FileUpload ID="fuAddressProof" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Aadhar Card *</label>
                                    <asp:FileUpload ID="fuAadhar" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Shop/Library Photo *</label>
                                    <asp:FileUpload ID="fuShopPhoto" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Owner Profile Photo *</label>
                                    <asp:FileUpload ID="fuOwnerPhoto" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Brand Logo (Optional)</label>
                                    <asp:FileUpload ID="fuLibraryLogo" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="upload-box">
                                    <label class="form-label text-uppercase d-block mb-2">Banner Image (Optional)</label>
                                    <asp:FileUpload ID="fuBannerPhoto" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-12 text-center mt-5">
                                <asp:LinkButton ID="BtnRegister" CssClass="btn-register" OnClick="BtnRegister_Click" runat="server">Partner with BookSwap</asp:LinkButton>
                                <p class="mt-4 text-secondary small">Already part of the network? <a href="login.aspx" class="text-primary fw-bold text-decoration-none">Log In to Panel</a></p>
                            </div>

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
