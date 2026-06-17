<%@ Page Title="Secure Payment" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="Payment.aspx.cs" Inherits="Client_Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    <div class="row justify-content-center py-5">
        <div class="col-md-6">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary text-white p-4 text-center">
                    <i class="ti ti-credit-card fs-1 mb-2"></i>
                    <h3 class="fw-bold mb-0">Secure Fine Payment</h3>
                </div>
                <div class="card-body p-5">
                    <div class="text-center mb-4 pb-4 border-bottom">
                        <p class="text-muted mb-1 text-uppercase fw-bold small">Amount to Pay</p>
                        <h1 class="display-4 fw-800 text-dark">
                            <asp:Label ID="lblAmount" runat="server"></asp:Label>
                        </h1>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold small text-muted text-uppercase">Card Number</label>
                        <div class="input-group border rounded-3 p-1">
                            <span class="input-group-text bg-transparent border-0"><i class="ti ti-credit-card"></i></span>
                            <asp:TextBox ID="txtCard" runat="server" CssClass="form-control border-0" placeholder="XXXX XXXX XXXX XXXX"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">Expiry (MM/YY)</label>
                            <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="12/25"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="form-label fw-bold small text-muted text-uppercase">Name on Card</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control text-uppercase" placeholder="Student Name"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnPay" runat="server" Text="Pay Securely Now" CssClass="btn btn-primary w-100 py-3 fw-bold rounded-3 shadow" OnClick="btnPay_Click" />
                    
                    <div class="text-center mt-4 text-muted small">
                        <i class="ti ti-lock me-1"></i> SSL Encrypted & Secure
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
