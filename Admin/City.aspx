<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/City.aspx.cs" Inherits="Admin_City" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
   <div class="page-header">
        <div class="page-block">
          <div class="row align-items-center">
                <div class="col-md-12 ">
                    <div class="d-flex align-items-center justify-content-between">
              <div class="page-header-title">
                <h4 class="m-b-10">City</h4>
              </div>
             <a href="CityList.aspx" class="btn btn-secondary"><i class="fa fa-angle-left"></i>Back</a>
            </div>
          </div>
        </div>
      </div>
        </div>
    <div class="card my-3">
  <div class="card-header">
    City Form
  </div>
  <div class="card-body">
   <div class="mb-3">
       <label for="exampleInputEmail" class="form-label">City</label>
       <asp:TextBox ID="txtCity"  CssClass="form-control" runat="server"></asp:TextBox>
   </div>
      <div class="mb-3">
       <label for="exampleInputPassword" class="form-label">Status</label>
          <asp:DropDownList ID="dropstatus" CssClass="form-control" runat="server">
              <asp:ListItem>---Select value---</asp:ListItem>
              <asp:ListItem>Active</asp:ListItem>
              <asp:ListItem>DeActive</asp:ListItem>
          </asp:DropDownList>

  </div>
  <div class="card-footer text-body-secondary text-center">
      <asp:LinkButton OnClick="LinkSave_Click" ID="LinkSave" runat="server" CssClass="btn btn-success"><i class="fa fa-save"></i>Save</asp:LinkButton>
      <button type="reset" class="btn btn-danger">Cancle</button>
  </div>
</div>
        

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

