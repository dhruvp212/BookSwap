<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master"AutoEventWireup="true" CodeFile="~/Admin/CityList.aspx.cs" Inherits="Admin_CityList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
  <div class="page-header">
        <div class="page-block">
          <div class="row align-items-center">
                <div class="col-md-12 ">
                    <div class="d-flex align-items-center justify-content-between">
              <div class="page-header-title">
                <h4 class="m-b-10">City List</h4>
              </div>
             <a href="City.aspx" class="btn btn-secondary"><i class="fa fa-plus"></i>Add</a>
            </div>
                    <div class="card">
         <div class="card-body table-responsive">   
      <asp:GridView OnRowCommand="gridList_RowCommand" ID="gridList" CssClass="table table-hover border" runat="server" AutoGenerateColumns="False">
          <Columns>
              <asp:TemplateField HeaderText="Id">
                  <ItemTemplate>
                      <%#Eval("CityId") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="City">
                     <ItemTemplate>
                      <%#Eval("City") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Status">
                     <ItemTemplate>
                      <%#Eval("Status") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Edit">
                  <ItemTemplate>
                      <a href='City.aspx?Edit=<%#Eval("CityId") %>' class="btn btn-info">Edit</a>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Delete">
                  <ItemTemplate>
                      <asp:LinkButton OnClientClick=" return confirm('Are You Sure Want  to Delete Data')" CommandName="Del" CommandArgument='<%#Eval("CityId") %>' CssClass="btn btn-danger" ID="lnkDelete" runat="server">Delete</asp:LinkButton>
                  </ItemTemplate>
              </asp:TemplateField>             
          </Columns>    
      </asp:GridView>
</div>
  </div>
  </div>
</div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

