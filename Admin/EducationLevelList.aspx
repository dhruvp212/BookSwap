<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/EducationLevelList.aspx.cs" Inherits="Admin_EducationLevel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-2">
                <h5 class="card-title fw-semibold mb-4">EducationLevel</h5>
                <a href="EducationLevelFrom.aspx" class="btn btn-info">add</a>
            </div>
             <div class="card">
                <div class="card-body table-responsive">
                    <asp:GridView OnRowCommand="gridList_RowCommand" ID="gridList" CssClass="table table-hover border" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="Id">
                                <ItemTemplate>
                                    <%#Eval("EducationLevelId") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="EducationId">
                                <ItemTemplate>
                                    <%#Eval("EducationId") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="EducationLevel">
                                <ItemTemplate>
                                    <%#Eval("EducationLevel") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%#Eval("Status").ToString() =="True"?"Active":"Deactive"%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                   
                                     <a href='EducationLevelFrom.aspx?Edit=<%#Eval("EducationLevelId") %>'class="btn btn-info">Edit</a>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:LinkButton OnClientClick="return confirm('Are you sure Want to Delete Category?')" CommandName="Del" CommandArgument='<%#Eval("EducationLevelId") %>' CssClass="btn btn-danger" ID="lnkDelete" runat="server">Delete</asp:LinkButton>
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

