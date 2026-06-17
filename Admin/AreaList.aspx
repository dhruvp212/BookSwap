<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/AreaList.aspx.cs" Inherits="Admin_AreaList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
<div class="card">
  <div class="card-header d-flex justify-content-between">
    <h1>Area List</h1>
             <a href="Area.aspx" class="btn btn-secondary"><i class="fa fa-plus"></i>Add</a>
            </div>
                    <div class="card">
         <div class="card-body table-responsive">   
      <asp:GridView OnRowCommand="gridList_RowCommand" ID="gridList" CssClass="table table-hover border" runat="server" AutoGenerateColumns="False">
          <Columns>
              <asp:TemplateField HeaderText="AreaId">
                  <ItemTemplate>
                      <%#Eval("AreaId") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="CityId">
                  <ItemTemplate>
                      <%#Eval("CityId") %>
                  </ItemTemplate>
              </asp:TemplateField>

               <asp:TemplateField HeaderText="Area">
                  <ItemTemplate>
                      <%#Eval("Area") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Status">
                   <ItemTemplate>
                      <%#Eval("status") %>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                      <a href='Area.aspx?Edit= <%#Eval("AreaId") %>' class="btn btn-info">Edit</a>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Delete">
                   <ItemTemplate>
                        <asp:LinkButton OnClientClick="  return confirm(' Are You Sure Want to Delete Data')" ID="lnkDelete"  runat="server" CommandName="Del" CommandArgument='<%#Eval("AreaId") %>' CssClass="btn btn-danger">Delete</asp:LinkButton>
                     
                  </ItemTemplate>
              </asp:TemplateField>

              
              
          </Columns>

          

      </asp:GridView>
</div>
  </div>
  </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

