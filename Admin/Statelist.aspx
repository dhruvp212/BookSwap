<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="~/Admin/Statelist.aspx.cs" Inherits="Admin_Statelist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
     <!-- Begin Page Content -->
                        <div class="container">

                            
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">State List</h1>
        <a href="Statefrom.aspx" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i class="fas fa-plus fa-sm text-white-50"></i> Add</a>
      </div>

        <div class="card shadow mb-4">
          <div class="card-header">
            <h5>State List</h5>
          </div>
          <div class="card-body table-responsive">
              <div>
	<table class="table table-hover table-bordered text-center" cellspacing="0" rules="all" border="1" id="ContentPage_GridView1" style="border-collapse:collapse;">
		<tr>
			<th scope="col">ID</th><th scope="col">Country ID</th><th scope="col">State</th><th scope="col">Status</th><th scope="col">Edit</th><th scope="col">Delete</th>
		</tr><tr>
			<td>
                              1
                          </td><td>
                             india
                          </td><td>
                             gujarat
                          </td><td>
                              Active
                          </td><td>
                              <a href='StateForm.aspx?Edit=1' class="btn btn-info"><i class="fa fa-edit"></i>&nbsp;Edit</a>
                              <td><a class="btn btn-danger" href="StateForm.aspx"><i class="fas fa-trash"></i>&nbsp;Delete</a></td>
                          </td><td>
                              
                          </td>
		</tr><tr>
			<td>
                              2
                          </td><td>
                              india
                          </td><td>
                             punjab
                          </td><td>
                              Active
                          </td><td>
                              <a href='StateForm.aspx?Edit=2' class="btn btn-info"><i class="fa fa-edit"></i>&nbsp;Edit</a>
                              <td><a class="btn btn-danger" href="StateForm.aspx"><i class="fas fa-trash"></i>&nbsp;Delete</a></td>
                          </td><td>
                              
                          </td>
		</tr><tr>
			<td>
                              3
                          </td><td>
                              india
                          </td><td>
                             rajasthan
                          </td><td>
                              Active
                          </td><td>
                              <a href='StateForm.aspx?Edit=3' class="btn btn-info"><i class="fa fa-edit"></i>&nbsp;Edit</a>
                              <td><a class="btn btn-danger" href="StateForm.aspx"><i class="fas fa-trash"></i>&nbsp;Delete</a></td>
                          </td><td>
                              
                          </td>
		</tr><tr>
			<td>
                              4
                          </td><td>
                              India
                          </td><td>
                              Maharashtra
                          </td><td>
                              Active
                          </td><td>
                              <a href='StateForm.aspx?Edit=4' class="btn btn-info"><i class="fa fa-edit"></i>&nbsp;Edit</a>
                              <td><a class="btn btn-danger" href="StateForm.aspx"><i class="fas fa-trash"></i>&nbsp;Delete</a></td>
                          </td><td>
                              
                          </td>
		</tr><tr>
			<td>
                              5
                          </td><td>
                              India
                          </td><td>
                              Uttar Pradesh
                          </td><td>
                              Active
                          </td><td>
                              <a href='StateForm.aspx?Edit=5' class="btn btn-info"><i class="fa fa-edit"></i>&nbsp;Edit</a>
                              <td><a class="btn btn-danger" href="StateForm.aspx"><i class="fas fa-trash"></i>&nbsp;Delete</a></td>
                          </td><td>
                              
                          </td>
		</tr>
	</table>
</div>
              
          </div>
        </div>

                            <!-- Begin Page Content -->

                            <!-- /.container-fluid -->



                            <!-- /.container-fluid -->
                        </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentJavascript" Runat="Server">
</asp:Content>

