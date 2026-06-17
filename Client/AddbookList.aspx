<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="~/Client/AddbookList.aspx.cs" Inherits="Client_Student_AddbookList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StudentContent" runat="Server">
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-4">
                <h5 class="card-title fw-semibold mb-4">Addbooklist</h5>
                <a href="Addbook.aspx" class="btn btn-info">Add</a>
            </div>
            <div class="card">
                <div class="card-body table-responsive">
                    <asp:GridView OnRowCommand="gridList_RowCommand1" ID="gridList"
                        CssClass="table table-hover border" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="CategoryId">
                                <ItemTemplate>
                                    <%#Eval("CategoryId") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="EducationLevelId">
                                <ItemTemplate>
                                    <%#Eval("EducationLevelId") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BookTitle">
                                <ItemTemplate>
                                    <%#Eval("BookTitle") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Auther">
                                <ItemTemplate>
                                    <%#Eval("Auther") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="INSBNO">
                                <ItemTemplate>
                                    <%#Eval("INSBNO") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Description">
                                <ItemTemplate>
                                    <%#Eval("Description") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Photo1">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" Height="100" Width="100" ImageUrl=' <%#Eval("Photo1") %>'
                                        runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Photo2">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" Height="100" Width="100" ImageUrl=' <%#Eval("Photo2") %>'
                                        runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Photo3">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" Height="100" Width="100" ImageUrl=' <%#Eval("Photo3") %>'
                                        runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Photo4">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" Height="100" Width="100" ImageUrl=' <%#Eval("Photo4") %>'
                                        runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Photo5">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" Height="100" Width="100" ImageUrl='<%#Eval("Photo5") %>'
                                        runat="server" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsVerified">
                                <ItemTemplate>
                                    <%#Eval("IsVerified") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsActive">

                                <ItemTemplate>
                                    <%#Eval("IsActive").ToString()=="True" ?"Active":"Active"%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="EntryDate">
                                <ItemTemplate>
                                    <%#Eval("EntryDate") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <a href='AddbookList.aspx?Edit=<%#Eval("CategoryId") %>'
                                        class="btn btn-info">Edit</a>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:LinkButton
                                        OnClientClick="return confirm('Are you sure Want to Delete Category?')"
                                        CommandName="Del" CommandArgument='<%#Eval("BookId") %>'
                                        CssClass="btn btn-danger" ID="lnkDelete" runat="server">Delete
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

