<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginElmah.aspx.cs" Inherits="SIGLA.Web.LoginElmah" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    	<asp:Label ID="lblUsuario" runat="server" Text="Usuário:"></asp:Label>
		<asp:TextBox ID="txtUsuario" runat="server"></asp:TextBox>
		<br />
		<asp:Label ID="lblSenha" runat="server" Text="Senha:"></asp:Label>
		<asp:TextBox ID="txtSenha" runat="server" TextMode="Password"></asp:TextBox>
		<br />
		<asp:Button ID="btnEntrar" runat="server" onclick="btnEntrar_Click" 
			Text="Entrar" />
    
    </div>
    </form>
</body>
</html>
