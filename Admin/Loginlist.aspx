<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/Loginlist.aspx.cs" Inherits="Admin_Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     <h1>Login</h1>
    
     <div class="card">
        <div class="card-header">
            <h2> Login List</h2>
        </div>

        <div class="card-body table-responsive">
             <asp:GridView ID="GridView1" CssClass="table table-responsive table-hover" runat="server" AutoGenerateColumns="False">
          <Columns>
              <asp:TemplateField HeaderText="id">
                  <ItemTemplate>
                      <%#Eval("LoginId") %>
                  </ItemTemplate>
              </asp:TemplateField>
              
               <asp:TemplateField HeaderText="id">
                  <ItemTemplate>
                      <%#Eval("Email") %>
                  </ItemTemplate>
              </asp:TemplateField>
              

               <asp:TemplateField HeaderText="Password">
                  <ItemTemplate>
                      <%#Eval("Password") %>
                  </ItemTemplate>
              </asp:TemplateField>

               <asp:TemplateField HeaderText="IsVerified">
                  <ItemTemplate>
                      <%#Eval("IsVerified").ToString()=="True"?"Yes":"No" %>
                  </ItemTemplate>
              </asp:TemplateField>

               <asp:TemplateField HeaderText="IsActive">
                  <ItemTemplate>
                      <%#Eval("IsActive").ToString()=="True"?"Yes":"No" %>
                  </ItemTemplate>
              </asp:TemplateField>

               <asp:TemplateField HeaderText="EntryDate">
                  <ItemTemplate>
                      <%#Eval("EntryDate") %>
                  </ItemTemplate>
              </asp:TemplateField>


              
              <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-warning">Edit</asp:LinkButton>
                     
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Delete">
                   <ItemTemplate>
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-warning">Delete</asp:LinkButton>
                     
                  </ItemTemplate>
              </asp:TemplateField>

              
              
          </Columns>

          

          
      </asp:GridView>

  </div>
  </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

