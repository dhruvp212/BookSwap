<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master"AutoEventWireup="true" CodeFile="~/Admin/EducationLevelFrom.aspx.cs" Inherits="Admin_EducationLevelFrom" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-2">
                <h5 class="card-title fw-semibold mb-4">EducationLevelForm</h5>
                <a href="EducationLevelList.aspx" class="btn btn-info">Back</a>
            </div>
            </div>
            <div class="card">
                <div class="card-body">
                    <div class="mb-3">
                        <label for="TxtEducationlevel" class="form-label">EducationName</label>

                        <asp:DropDownList ID="DropEducationlevel" CssClass="form-control" runat="server">
                            <asp:ListItem Value="">----Select Education----</asp:ListItem>
                           
                        </asp:DropDownList>                
                </div>
                   <div class="mb-3">
                        <label for="TxtEducationlevel" class="form-label">EducationName</label>

                        <asp:DropDownList  ID="Education" CssClass="form-control" runat="server">
                            <asp:ListItem Value="">----Select Education----</asp:ListItem>
                           
                        </asp:DropDownList>                
                    <div class="mb-3">
                        <label for="DropStatus" class="form-label">Status</label>
                        <asp:DropDownList CssClass="form-control" ID="DropStatus" runat="server">
                            <asp:ListItem Value="">----Select Value----</asp:ListItem>
                            <asp:ListItem Value="Active">Active</asp:ListItem>
                            <asp:ListItem Value="Deactive">Deactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="card-footer text-body-secondary text-center">

                    <asp:LinkButton ID="btnsave" runat="server" CssClass="btn btn-success" OnClick="btnsave_Click1">Save</asp:LinkButton>

                    <button type="reset" class="btn btn-danger">Cancle</button>
                </div>
            </div>
        </div>
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" runat="Server">
</asp:Content>


