<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/contactpage.aspx.cs" Inherits="contactpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <div class="row justify-content-center">
        <div class="col-lg-11">
            <div class="card border-0 shadow-lg rounded-5 overflow-hidden">
                <div class="row g-0">
                    <!-- Contact Form Side -->
                    <div class="col-lg-7 p-4 p-md-5">
                        <h2 class="fw-bold text-dark mb-4"><i class="ti ti-mail-forward text-primary me-2"></i>Send an Inquiry</h2>
                        <p class="text-muted mb-5">Have questions? Our team typically responds within 24 business hours.</p>
                        
                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Query Subject</label>
                                <asp:DropDownList ID="dropSubject" CssClass="form-select" runat="server">
                                    <asp:ListItem>General Inquiry</asp:ListItem>
                                    <asp:ListItem>Library Support</asp:ListItem>
                                    <asp:ListItem>Technical Issue</asp:ListItem>
                                    <asp:ListItem>Partnership Idea</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Full Name</label>
                                <asp:TextBox ID="txtFullName" CssClass="form-control" placeholder="John Doe" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfv1" runat="server" CssClass="text-danger small" ErrorMessage="Name required" ControlToValidate="txtFullName" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Mobile Number</label>
                                <asp:TextBox ID="txtMobile" CssClass="form-control" placeholder="9876543210" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfv2" runat="server" CssClass="text-danger small" ErrorMessage="Mobile required" ControlToValidate="txtMobile" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email Address</label>
                                <asp:TextBox ID="txtEmail" type="Email" CssClass="form-control" placeholder="john@example.com" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfv3" runat="server" CssClass="text-danger small" ErrorMessage="Email required" ControlToValidate="txtEmail" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold">Message Details</label>
                                <asp:TextBox ID="txtMessage" Rows="4" TextMode="MultiLine" CssClass="form-control" placeholder="Tell us how we can help..." runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfv4" runat="server" CssClass="text-danger small" ErrorMessage="Message required" ControlToValidate="txtMessage" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-12 pt-3">
                                <asp:LinkButton OnClick="lnkSend_Click" ID="lnkSend" CssClass="btn btn-primary btn-lg px-5 rounded-3 fw-bold shadow-sm" runat="server">Send Message</asp:LinkButton>
                            </div>
                        </div>
                    </div>

                    <!-- Information Side -->
                    <div class="col-lg-5 text-white p-4 p-md-5 d-flex flex-column" style="background: linear-gradient(135deg, #0f3460 0%, #16213e 100%);">
                        <div class="mb-5">
                            <h3 class="fw-bold mb-4">Contact Information</h3>
                            <div class="d-flex mb-4">
                                <i class="ti ti-phone-call fs-1 me-3 text-info"></i>
                                <div>
                                    <h6 class="mb-1 text-info fw-bold">Call Us</h6>
                                    <p class="mb-0">+91-93131 99537</p>
                                    <p class="mb-0">+91-93287 15837</p>
                                </div>
                            </div>
                            <div class="d-flex mb-4">
                                <i class="ti ti-map-pin fs-1 me-3 text-info"></i>
                                <div>
                                    <h6 class="mb-1 text-info fw-bold">Headquarters</h6>
                                    <p class="small mb-0">Asian Institute of Technology, Vadali (969), Near Railway Crossing, Ambaji Highway Road, Vadali, Gujarat 383235</p>
                                </div>
                            </div>
                        </div>

                        <!-- Map -->
                        <div class="mt-auto overflow-hidden rounded-4 border border-white border-opacity-10 shadow-lg" style="height: 250px;">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3646.083059201103!2d73.03243527512187!3d23.957502878529667!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x395d0a63a874cf51%3A0xb6dc2a3f8a69b6a5!2sAsian%20Institute%20Of%20Technology%2CVadali!5e0!3m2!1sen!2sin!4v1762149780446!5m2!1sen!2sin" 
                                width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" Runat="Server">
</asp:Content>

