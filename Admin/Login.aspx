<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Admin/Login.aspx.cs" Inherits="Admin_Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>

body{
    background-image:url('images/books.jpg'); /* book photo path */
    background-size:cover;
    background-position:center;
    background-repeat:no-repeat;

    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
}


.login-box{
    background:#f1f1f1;
    border-radius:10px;
    width:700px;
    padding:50px;
}

.login-btn{
    background:#2f4356;
    color:white;
    width:100%;
}

.login-btn:hover{
    background:#1e2f3e;
}

.form-control{
    background:#dfe6ee;
}

.links{
    text-align:center;
    margin-top:15px;
}

</style>

</head>

<body>
<form runat="server" method="post">
        <div class="login-box">
            <h2>Login</h2>
            <asp:label ID="lblMsg" runat="server" Text=""></asp:label>
            <asp:TextBox ID="txtUsername" placeholder="Username" runat="server"></asp:TextBox>

            <asp:TextBox ID="txtpassword" placeholder="password" runat="server"></asp:TextBox>

            <asp:LinkButton ID="lnklogin" OnClick="lnklogin_Click"  CssClass="green-btn" runat="server">Login</asp:LinkButton>
            </div>
    </form>
</body>
</html>
