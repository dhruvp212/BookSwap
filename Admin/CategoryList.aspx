<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/CategoryList.aspx.cs" Inherits="Admin_CategoryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-4">
                <h5 class="card-title fw-semibold mb-4">Categotylist</h5>
                <a href="categoryfrom.aspx" class="btn btn-info">add</a>
            </div>
            <div class="card">
                <div class="card-body table-responsive">
                    <asp:GridView OnRowCommand="gridList_RowCommand" ID="gridList" CssClass="table table-hover border" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="Id">
                                <ItemTemplate>
                                    <%#Eval("CategoryId") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Category">
                                <ItemTemplate>
                                    <%#Eval("Category") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Icon">
                              <ItemTemplate>
                                  <asp:Image ID="Image1" Height="100" Width="100" ImageUrl=' <%#Eval("icon") %>' runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%#Eval("Status").ToString() =="True"?"Active":"Deactive"%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <a href='Categoryfrom.aspx?Edit=<%#Eval("CategoryId") %>'class="btn btn-info">Edit</a>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:LinkButton OnClientClick="return confirm('Are you sure Want to Delete Category?')" CommandName="Del" CommandArgument='<%#Eval("CategoryId") %>' CssClass="btn btn-danger" ID="lnkDelete" runat="server">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

            </div>
        </div>
    </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

