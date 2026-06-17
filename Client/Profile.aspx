<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="Client_Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-primary text-white py-3 border-0">
                        <h4 class="mb-0 fw-bold"><i class="ti ti-user-edit me-2"></i> Manage My Profile</h4>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-4"></asp:Label>

                        <div class="row g-4">
                            <!-- Basic Account Details -->
                            <div class="col-12 border-bottom pb-4 mb-2">
                                <h5 class="text-secondary fw-bold mb-4">Account Information</h5>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">Full Name</label>
                                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter Full Name"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtFullName" 
                                            ErrorMessage="Name is required" Display="Dynamic" CssClass="text-danger small"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">Mobile Number</label>
                                        <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="10 Digit Mobile"></asp:TextBox>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">Email Address (Login ID)</label>
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                                        <small class="text-muted">Email cannot be changed.</small>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">Password</label>
                                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                        <small class="text-muted">Leave blank to keep current password.</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Address and Location -->
                            <div class="col-12">
                                <h5 class="text-secondary fw-bold mb-4">Contact & Location</h5>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">City</label>
                                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-600">Area</label>
                                        <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-8">
                                        <label class="form-label fw-600">Address Details</label>
                                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Apartment, Street..."></asp:TextBox>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-600">Pincode</label>
                                        <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control" placeholder="6 Digit Code"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 mt-5 text-end border-top pt-4">
                                <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn btn-primary px-5 py-2 fw-bold shadow-sm" OnClick="btnUpdate_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
