<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<% Response.Charset="ISO-8859-1" %>
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->

<html>
<head>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SIGLA - Sistema Integrado de Gestão de Linhas Aéreas</title>
<link rel="shortcut icon" href="favicon.ico">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<script language="javascript" src="dinamic_content.js"></script>
<script language="javascript">
   function TrataRelatorios() {
      ajax('home_relatorio.asp?aberto='+document.getElementById('aberto').value+'&','','divRelatorio');
      if (document.getElementById('aberto').value == 0){ 
         document.getElementById('aberto').value = 1
      }else{
         document.getElementById('aberto').value = 0;
      }
   }
</script>

<%
	Dim strMsg
	strMsg = Request.QueryString("msg")
	if (strMsg = "s") then
		Response.Write("<script language='javascript'>")
		Response.Write("	alert('Senha alterada com sucesso!');")
		Response.Write("</script>")
	end if
%>

</head>

<body>
<center>
   <table width="100%" border="0" cellpadding="0" cellspacing="0" ID="TableTitulo">
      <tr>
         <td class="corpo" align="left" valign="middle" width="35%" >
            <img src="imagens/logo_empresa.gif" border="0"></a>         </td>
         <td class="corpo" align="center">         </td>
         <td class="corpo" align="right" valign="middle" width="35%">
            <a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>         </td>
      </tr>
      <tr>
         <td colspan="3"><!--#include file="Menu.asp"--></td>
     </tr>
      <tr>
         <td colspan="3" align="center">         </td>
      </tr>
   </table>
  <table width="100%" height="80%" border="0" cellpadding="0" cellspacing="0" hspace="0" vspace="0">
   	<tr>	
      	<td align="center" valign="middle" bordercolor="0"><img src="imagens/bg_nuvens2.jpg" style="background:transparent;filter:alpha(opacity=50);-moz-opacity:.50;opacity:.50; vertical-align:middle;"></td>
    </tr>
  </table>      
</center>
</body>
</html>
