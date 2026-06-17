<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/Categoryfrom.aspx.cs" Inherits="Admin_Categoryfrom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     <div class="card">
        <div class="card-body">
           <div class="d-flex justify-content-between mb-2">
                <h5 class="card-title fw-semibold mb-4">
                    Categoty Form</h5>
               <a href="CategoryList.aspx" class="btn btn-info">Back</a>
           </div>
            <div class="card">
                <div class="card-body">
                        <div class="mb-3">
                            <label for="TxtCategory" class="form-label">Category Name</label>
                            <asp:TextBox CssClass="form-control" ID="TxtCategory" runat="server"></asp:TextBox>
                        </div>
                    <div class="row">
                        <div class="col-8">
                            <div class="mb-3">
                            <label for="TxtCategory" class="form-label">Icon</label>
                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                        </div>
                        </div>
                        <div class="col-4">
                            <asp:Image ID="imgIcon" Height="100" Width="100" runat="server" />
                        </div>
                    </div>
                        <div class="mb-3">
                            <label for="DropStatus" class="form-label">Status</label>
                            <asp:DropDownList CssClass="form-control" ID="DropStatus" runat="server">
                                <asp:ListItem Value="">----Select Value----</asp:ListItem>
                                <asp:ListItem Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                </div>
                <div class="card-footer text-body-secondary text-center" >
                    <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-success" class="fa fa-save" OnClick="btnsave_Click1">Save</asp:LinkButton>
     
      <button type="reset" class="btn btn-danger">Cancle</button>
  </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

