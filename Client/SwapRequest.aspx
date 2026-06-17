<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Student.master" AutoEventWireup="true" CodeFile="SwapRequest.aspx.cs" Inherits="Client_SwapRequest" %>

<asp:Content ID="Content2" ContentPlaceHolderID="StudentContent" runat="server">

<div class="card">
    <div class="card-body">

        <h5 class="card-title mb-4">Swap Request Form</h5>

        <!-- Education -->
       <div class="mb-3">
                    <label for="exampleInputEmail" class="form-label">Education</label>
                    <asp:DropDownList OnSelectedIndexChanged="DropEducation_SelectedIndexChanged" AutoPostBack="true" ID="DropEducation" CssClass="form-control" runat="server"></asp:DropDownList>
                </div>

        <!-- Education Level -->
       <div class="mb-3">
                    <label for="exampleInputEmail" class="form-label">Education lavel Id</label>
                    <asp:DropDownList ID="DropEducationlavel" CssClass="form-control" runat="server"></asp:DropDownList>
                </div>

        <!-- Semester -->
        <div class="mb-3">
            <label>Semester</label>
            <asp:DropDownList ID="DroupSemester" runat="server" CssClass="form-control">
                <asp:ListItem Text="Select Semester" Value="" />
                <asp:ListItem Text="Sem 1" Value="1" />
                <asp:ListItem Text="Sem 2" Value="2" />
                <asp:ListItem Text="Sem 3" Value="3" />
                <asp:ListItem Text="Sem 4" Value="4" />
                <asp:ListItem Text="Sem 5" Value="5" />
                <asp:ListItem Text="Sem 6" Value="6" />
                <asp:ListItem Text="Sem 7" Value="7" />
                <asp:ListItem Text="Sem 8" Value="8" />
            </asp:DropDownList>
        </div>
        <div class="row">
                        <div class="col-8">
                            <div class="mb-3">
                            <label for="TxtPhoto" class="form-label">PhotoFront</label>
                        <asp:FileUpload ID="PhotoFront" runat="server" CssClass="form-control" />
                        </div>
                        </div>
            <div class="row">
                        <div class="col-8">
                            <div class="mb-3">
                            <label for="TxtPhotoEnd" class="form-label">PhotoEnd</label>
                        <asp:FileUpload ID="PhotoEnd" runat="server" CssClass="form-control" />
                        </div>
                        </div>


        <!-- Amount -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Original Amount</label>
                <asp:TextBox ID="txtAmt1" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label>Second Amount</label>
                <asp:TextBox ID="txtAmt2" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>

        <!-- Description -->
        <div class="mb-3">
            <label>Description</label>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
        </div>

        <!-- Buttons -->
        <div class="text-center">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success px-4" OnClick="btnSubmit_Click" />
           <%--<asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary px-4" OnClick="btnReset_Click" />--%>
        </div>

        <!-- Message -->
        <asp:Label ID="lblMsg" runat="server" ForeColor="Green"></asp:Label>

    </div>
</div>
        </div>
    </div>

</asp:Content>
