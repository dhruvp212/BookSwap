<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master"AutoEventWireup="true" CodeFile="~/Admin/Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <h2>Dashboard</h2>
    <div class="row">
         <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Users</h5>
                    <p class="card-text fs-4"><b>450</b></p>

                </div>
            </div>
        </div>

        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Library Partner</h5>
                    <p class="card-text fs-4"><b>50</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Student Partner</h5>
                    <p class="card-text fs-4"><b>45</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Today Book</h5>
                    <p class="card-text fs-4"><b>20</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Weekly Book</h5>
                    <p class="card-text fs-4"><b>30</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Monthly Book</h5>
                    <p class="card-text fs-4"><b>31</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Yearly Book</h5>
                    <p class="card-text fs-4"><b>350</b></p>

                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card shadow-sm text-center p-3 bg-danger">
                <i data-lucide="users" class="size-12 animate-color"></i>
                <div class="card-body">
                    <h5 class="card-title">Payments</h5>
                    <p class="card-text fs-4">
                        <b>₹4500</b>

                    </p>

                </div>
            </div>
        </div>  
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

