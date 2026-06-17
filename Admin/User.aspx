<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/User.aspx.cs" Inherits="Admin_User" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <h1>User</h1>
    <div class="card">
        <div class="card-header">
            <h2>Users List</h2>
        </div>
        <div class="card-body table-responsive">
            <asp:GridView CssClass="table table-hover border" ID="gridList" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:TemplateField HeaderText="UserID">
                        <ItemTemplate>
                            <%#Eval("UserID") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <%#Eval("Name") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UserType">
                         <ItemTemplate>
                            <%#Eval("UserType") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email">
                        <ItemTemplate>
                            <%#Eval("Email") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mobile">
                        <ItemTemplate>
                            <%#Eval("Mobile") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Password">
                        <ItemTemplate>
                            <%#Eval("Password") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IsVerified">
                        <ItemTemplate>
                            <%#Eval("IsVerified") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IsActive">
                        
                         <ItemTemplate>
                                    <%#Eval("IsActive").ToString() =="True"?"Active":"Active"%>
                                </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="EntryDate">
                        <ItemTemplate>
                            <%#Eval("EntryDate") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
                        
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

