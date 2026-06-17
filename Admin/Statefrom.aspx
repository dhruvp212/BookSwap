<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/Statefrom.aspx.cs" Inherits="Admin_Statefrom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     <!-- Begin Page Content -->
                        <div class="container">

                            
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">State Form</h1>
        <a href="StateList.aspx" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i class="fas fa-angle-left fa-sm text-white-50"></i>Back</a>
    </div>
     
        
        
    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="form-group">
                <b>
                    <label>State</label></b>
                <input name="ctl00$ContentPage$TxtState" type="text" id="ContentPage_TxtState" class="form-control" />
                <span id="ContentPage_RequiredFieldValidator1" class="text-danger" style="visibility:hidden;">Plese Enter State*</span>
            </div>
            <div class="form-group">
                <b>
                    <label>Country</label></b>
                <select name="ctl00$ContentPage$DropCountryy" id="ContentPage_DropCountryy" class="form-control">
	<option value="">-----Select Value-----</option>
	<option value="1">United States</option>
	<option value="2">India</option>
	<option value="3">Brazil</option>
	<option value="4">Australia</option>
	<option value="5">Canada</option>

</select>
                <span id="ContentPage_RequiredFieldValidator3" class="text-danger" style="visibility:hidden;">Plese Select Country*</span>
            </div>
            <div class="form-group">
                <b>
                    <label>Status</label></b>
                <select name="ctl00$ContentPage$DropStatus" id="ContentPage_DropStatus" class="form-control">
	<option value="">----Select Status----</option>
	<option value="Active">Active</option>
	<option value="Deactive">Deactive</option>

</select>
                 <span id="ContentPage_RequiredFieldValidator2" class="text-danger" style="visibility:hidden;">Plese Fill Status*</span>
            </div>
        </div>

        <div class="card-footer text-center">
            
            <button type="reset" class="btn btn-danger"><i class="fa fa-times mr-2"></i>&nbsp;Clear</button>
        </div>
    </div>

                            <!-- Begin Page Content -->

                            <!-- /.container-fluid -->



                            <!-- /.container-fluid -->
                        </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

