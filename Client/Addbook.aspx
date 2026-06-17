<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="~/Client/Addbook.aspx.cs" Inherits="Client_Student_Addbook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-success text-white py-3 border-0">
                    <h4 class="mb-0 fw-bold"><i class="ti ti-book-plus me-2"></i> List Your Book</h4>
                    <p class="mb-0 small opacity-75">Share your knowledge with others by listing your book for swapping.</p>
                </div>
                <div class="card-body p-4 p-md-5">
                    <div class="row g-4">
                        <!-- Categorization -->
                        <div class="col-12 border-bottom pb-4 mb-2">
                            <h5 class="text-secondary fw-bold mb-3">Classification</h5>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label fw-600">Category</label>
                                    <asp:DropDownList ID="DropCategory" CssClass="form-select" runat="server"></asp:DropDownList>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-600">Education</label>
                                    <asp:DropDownList OnSelectedIndexChanged="DropEducation_SelectedIndexChanged" AutoPostBack="true" ID="DropEducation" CssClass="form-select" runat="server"></asp:DropDownList>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-600">Edu Level / Semester</label>
                                    <asp:DropDownList ID="DropEducationlavel" CssClass="form-select" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <!-- Book Details -->
                        <div class="col-12 border-bottom pb-4 mb-2">
                            <h5 class="text-secondary fw-bold mb-3">Book Information</h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-600">Book Title</label>
                                    <asp:TextBox ID="TxtBookTitle" CssClass="form-control" runat="server" placeholder="e.g. Clean Code"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-600">Author Name</label>
                                    <asp:TextBox ID="TxtAuther" CssClass="form-control" runat="server" placeholder="e.g. Robert C. Martin"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-600">ISBN / Book No</label>
                                    <asp:TextBox ID="TxtINSBNO" CssClass="form-control" runat="server" placeholder="13-digit ISBN"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-600">Replacement Value (Approx)</label>
                                    <asp:TextBox ID="txtPrice" CssClass="form-control" runat="server" placeholder="Price in ₹"></asp:TextBox>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-600">Brief Description</label>
                                    <asp:TextBox ID="TxtDescription" CssClass="form-control" runat="server" TextMode="MultiLine" Rows="3" placeholder="Condition of the book, edition, etc."></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Photos -->
                        <div class="col-12">
                            <h5 class="text-secondary fw-bold mb-3">Upload Photos</h5>
                            <p class="text-muted small mb-3">Upload up to 5 clear photos of your book.</p>
                            <div class="row g-3">
                                <div class="col-md-auto"><asp:FileUpload ID="Uploadphoto1" runat="server" CssClass="form-control form-control-sm" /></div>
                                <div class="col-md-auto"><asp:FileUpload ID="Upload2" runat="server" CssClass="form-control form-control-sm" /></div>
                                <div class="col-md-auto"><asp:FileUpload ID="Upload3" runat="server" CssClass="form-control form-control-sm" /></div>
                                <div class="col-md-auto"><asp:FileUpload ID="Upload4" runat="server" CssClass="form-control form-control-sm" /></div>
                                <div class="col-md-auto"><asp:FileUpload ID="Upload5" runat="server" CssClass="form-control form-control-sm" /></div>
                            </div>
                        </div>

                        <div class="col-12 mt-5 text-center">
                            <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-success px-5 py-3 fw-bold rounded-pill shadow" OnClick="btnsave_Click">
                                <i class="ti ti-device-floppy me-2"></i>List My Book Now
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

