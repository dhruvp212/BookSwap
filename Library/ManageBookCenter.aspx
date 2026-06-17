<%@ Page Title="Manage Book Center" Language="C#" MasterPageFile="~/Library/Library.master" AutoEventWireup="true" CodeFile="ManageBookCenter.aspx.cs" Inherits="Library_ManageBookCenter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="LibraryContent" Runat="Server">
    <div class="p-3">
        <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
            <i data-lucide="book-open" class="size-8 text-primary animate-color"></i>
            <div>
                <h3 class="mb-0 fw-bold">Manage Book Center</h3>
                <p class="text-secondary small mb-0">Upload, edit, and maintain the library book inventory here.</p>
            </div>
        </div>
        
        <asp:HiddenField ID="hfBookId" runat="server" />

        <div class="card glass-card shadow-sm mb-5">
            <div class="card-header d-flex align-items-center gap-2">
                <i data-lucide="edit-3" class="size-5"></i>
                <h5 class="m-0">Book Details Form</h5>
            </div>
            <div class="card-body row p-4">
                
                <div class="col-md-4 mb-3">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="DropCategory" CssClass="form-control" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Education</label>
                    <asp:DropDownList OnSelectedIndexChanged="DropEducation_SelectedIndexChanged" AutoPostBack="true" ID="DropEducation" CssClass="form-control" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Education Level / Semester</label>
                    <asp:DropDownList ID="DropEducationlavel" CssClass="form-control" runat="server"></asp:DropDownList>
                </div>

                <div class="col-md-4 mb-3">
                    <label class="form-label">Book Title</label>
                    <asp:TextBox ID="TxtBookTitle" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Author</label>
                    <asp:TextBox ID="TxtAuther" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">ISBN / Book No</label>
                    <asp:TextBox ID="TxtINSBNO" CssClass="form-control" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-4 mb-3">
                    <label class="form-label">Rent Price (Per Day)</label>
                    <asp:TextBox ID="txtPrice" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-8 mb-3">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="TxtDescription" CssClass="form-control" runat="server" TextMode="MultiLine" Rows="1"></asp:TextBox>
                </div>

                <div class="col-md-12 mb-3">
                    <label class="form-label">Update Photos (Optional if already uploaded)</label>
                    <div class="row g-2">
                        <div class="col-md-2.4 col-6"><asp:FileUpload ID="Uploadphoto1" runat="server" CssClass="form-control" /></div>
                        <div class="col-md-2.4 col-6"><asp:FileUpload ID="Upload2" runat="server" CssClass="form-control" /></div>
                        <div class="col-md-2.4 col-6"><asp:FileUpload ID="Upload3" runat="server" CssClass="form-control" /></div>
                        <div class="col-md-2.4 col-6"><asp:FileUpload ID="Upload4" runat="server" CssClass="form-control" /></div>
                        <div class="col-md-2.4 col-6"><asp:FileUpload ID="Upload5" runat="server" CssClass="form-control" /></div>
                    </div>
                </div>

            </div>
            <div class="card-footer p-4 text-center border-top border-glass">
                <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-primary px-5 py-2 d-inline-flex align-items-center gap-2" OnClick="btnsave_Click">
                    <i data-lucide="save" class="size-4"></i> Save Book
                </asp:LinkButton>
                <asp:LinkButton ID="btnclear" runat="server" CssClass="btn btn-outline-secondary ms-2 px-4 py-2 d-inline-flex align-items-center gap-2" OnClick="btnclear_Click">
                    <i data-lucide="refresh-cw" class="size-4"></i> Clear
                </asp:LinkButton>
            </div>
        </div>

        <div class="d-flex align-items-center gap-2 mb-3">
            <i data-lucide="list" class="size-6 text-accent"></i>
            <h4 class="mb-0 fw-bold">My Library Books</h4>
        </div>
        <div class="table-responsive">
            <asp:GridView ID="gridBooks" runat="server" AutoGenerateColumns="False" CssClass="gv" DataKeyNames="BookId" OnRowCommand="gridBooks_RowCommand" OnRowDeleting="gridBooks_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="BookTitle" HeaderText="Title" />
                    <asp:BoundField DataField="Auther" HeaderText="Author" />
                    <asp:BoundField DataField="INSBNO" HeaderText="ISBN" />
                    <asp:BoundField DataField="EducationLevel" HeaderText="Edu Level" />
                    <asp:BoundField DataField="RentPriceperDay" HeaderText="Price/Day" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Preview">
                        <ItemTemplate>
                            <div class="p-1 glass-card d-inline-block">
                                <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' alt="Book Cover" style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="d-flex gap-2">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="SelectBook" CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-sm btn-accent d-flex align-items-center gap-1">
                                    <i data-lucide="edit-2" class="size-3"></i> Edit
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("BookId") %>' CssClass="btn btn-sm btn-danger d-flex align-items-center gap-1" OnClientClick="return confirm('Are you sure you want to delete this book?');">
                                    <i data-lucide="trash-2" class="size-3"></i> Delete
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

    </div>
</asp:Content>
