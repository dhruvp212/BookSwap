<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/Educationfrom.aspx.cs" Inherits="Admin_Educationfrom" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     <div class="card">
        <div class="card-body">
           <div class="d-flex justify-content-between mb-2">
                <h5 class="card-title fw-semibold mb-4">Education Form</h5>
               <a href="Education.aspx" class="btn btn-info">Back</a>
           </div>
            </div>
            <div class="card">
                <div class="card-body">
                        <div class="mb-3">
                            <label for="TxtCategory" class="form-label">Education name</label>
                            <asp:TextBox CssClass="form-control" ID="txtEducation" runat="server"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label for="DropStatus" class="form-label">Status</label>
                            <asp:DropDownList CssClass="form-control" ID="DropStatus" runat="server">
                                <asp:ListItem Value="">----Select Value----</asp:ListItem>
                                <asp:ListItem Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:DropDownList>
                             <div class="card-footer text-body-secondary text-center" >
     <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-success" class="fa fa-save" OnClick="btnsave_Click1">Save</asp:LinkButton>
     
      <button type="reset" class="btn btn-danger">Cancle</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

