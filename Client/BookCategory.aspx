<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/BookCategory.aspx.cs" Inherits="bookCategoryClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
   
     <style>
        .card img
        {
            width:100%;
            height:200px;
            object-fit:contain;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     
    <div class="py-5 container">
        <h1> Book Category</h1>
        <hr />
        <div class="row">
            <asp:Repeater ID="rptbookcategory" runat="server">
                <ItemTemplate>
                    <div class="col-4">
                        <a href="#">
                            <div class="card text-center shadow">
                                <asp:Image ID="Image1" ImageUrl='<%#Eval("icon") %>' runat="server" class="card-img-top" />
                                <div class="card-body">
                                    <h5 class="card-title"><%#Eval("Category") %></h5>
                                </div>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" Runat="Server">
</asp:Content>

