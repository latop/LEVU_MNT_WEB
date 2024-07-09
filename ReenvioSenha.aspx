<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReenvioSenha.aspx.cs" Inherits="SIGLA.Web.ReenvioSenha" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title>SIGLA - Reenvio de senha</title>
	<link rel="shortcut icon" href="~/Images/favicon.ico" type="image/x-icon" />
</head>
<body>
	<form id="form1" runat="server">
		<!-- Header -->
		<div id="Header">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" valign="middle" width="35%">
						<img id="imgLogoEmpresa" src="ASP/imagens/logo_empresa.gif" alt="Marca da Empresa" border="0" />
					</td>
					<td align="center" width="30%">
						<span id="TituloPagina" style="vertical-align: bottom">Reenvio de senha para tripulantes</span>
					</td>
					<td align="right" valign="top" width="35%">
						<a href="http://www.latop.com.br">
							<img id="imgSigla" src="Images/sigla.gif" alt="SIGLA" border="0" />
						</a>
					</td>
				</tr>
			</table>
		</div>
		<!-- Menu -->
		<div id="Menu">
			<hr />
		</div>
		<!-- Content -->
		<div id="Content">
			<div style="width: 30%; margin: 20px auto 20px auto; font-size: 0.85em;">
				Para enviar uma nova senha para o seu e-mail, preencha os campos abaixo e aperte o bot&#227;o enviar.
			</div>
			<div>
				<fieldset style="width: 30%; margin-left: auto; margin-right: auto;">
					<table style="margin-left: auto; margin-right: auto; font-size: 0.85em;">
						<tr>
							<td style="text-align: right;">Usu&#225;rio:</td>
							<td style="text-align: left;"><asp:TextBox ID="txtUsuario" runat="server" 
									MaxLength="20"></asp:TextBox>
								<asp:RequiredFieldValidator ID="rfvUsuario" runat="server" 
									ControlToValidate="txtUsuario" 
									ErrorMessage="Preencha o campo Usuário, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td style="text-align: right;">CPF:</td>
							<td style="text-align: left;">
								<asp:TextBox ID="txtCpf" runat="server" 
									MaxLength="11" TextMode="Password"></asp:TextBox>
								<asp:RequiredFieldValidator ID="rfvCpf" runat="server" 
									ControlToValidate="txtCpf" ErrorMessage="Preencha o campo CPF, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<asp:Button ID="btnEnviar" runat="server" Text="Enviar" 
									onclick="btnEnviar_Click" />
								<asp:Button ID="btnVoltar" runat="server" Text="Voltar" 
									onclick="btnVoltar_Click" CausesValidation="False" />
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<asp:ValidationSummary ID="vsReenvioSenha" runat="server" ShowMessageBox="True" 
				ShowSummary="False" />
		</div>
	</form>
</body>
</html>
