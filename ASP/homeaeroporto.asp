<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<html>
	<head>
		<title>Cadastro dos Aeroportos</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
      <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<%
		Dim strMsg
		strMsg = Request.QueryString("msg")
		if (strMsg = "s") then
			Response.Write("<script language='javascript'>" & vbCrLf)
			Response.Write("	alert('Senha alterada com sucesso!');" & vbCrLf)
			Response.Write("</script>" & vbCrLf)
		end if

     if ((Session("dominio") = 3) and (Session("member") <> "") and (Session("dominio") <> "") and (Session("login") <> "")) then
		if (VerificarDocObrigatorioPendente()) then
			Response.Redirect("../ASP2ASPX/ASP2ASPX.asp?paginaDestino=DocumentosAeroportos.aspx&dominioDestino=Aeroporto")
		end if
	end if
%>
	</head>
	<body>

    
    
    
		<center>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="TableTitulo">
				<tr>
					<td class="corpo" align="left" valign="middle" width="35%">
						<img src="imagens/logo_empresa.gif" border="0"></a>
					</td>
					<td class="corpo" align="center">
						<font size="6"><b>&nbsp;Aeroporto </b></font>
					</td>
					<td class="corpo" align="right" valign="middle" width="35%">
						<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
					</td>
				</tr>
                <tr>
	                <td colspan="3"> <!-- #include file="Menu.asp"--> </td>
                </tr>
			</table>
        	<table width="100%" height="80%" border="0" cellpadding="0" cellspacing="0" hspace="0" vspace="0">
   			<tr>	
      			<td align="center" valign="middle" bordercolor="0"><img src="imagens/bg_nuvens2.jpg" style="background:transparent;filter:alpha(opacity=50);-moz-opacity:.50;opacity:.50; vertical-align:middle;"></td>
    			</tr>
		  	</table>      
	</body>
</html>
