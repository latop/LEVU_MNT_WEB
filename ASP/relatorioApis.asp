<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeropfunc.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<% Response.Charset = "ISO-8859-1"%>
<html>
<head>
	<title>Tripulantes</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<style type="text/css">
body {
	margin-left: 0px;
}
</style>
<script type="text/javascript">
function VerificaCampos() {
		if (window.form1.txt_nome.value == '') {
			alert('Preencha o campo Nome, por favor!');
			window.form1.txt_nome.focus();
			return false;
		}
		if (window.form1.txt_telefone.value == '') {
			alert('Preencha o campo Telefone, por favor!');
			window.form1.txt_telefone.focus();
			return false;
		}
		if (window.form1.txt_fax.value == '') {
			alert('Preencha o campo Fax, por favor!');
			window.form1.txt_fax.focus();
			return false;
		}
}
</script>				
</head>
<%
Dim intSeqVooDia
Dim intSeqTrecho
Dim dataPrevista
Dim voo

intSeqVooDia = Request.QueryString("seqVooDia")
intSeqTrecho = Request.QueryString("seqTrecho")
dataPrevista = Request.QueryString("dataPrevista")
voo = Request.QueryString("voo")

%>	
<body>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Gera&ccedil;&atilde;o do Relat&oacute;rio Apis
			</b></font>
		</td>
		<td class="corpo" align="right" valign="top" width="35%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
	</tr>
   <tr>
         <td></td>
         <td></td>
     </tr>
     <tr>   
         <td colspan="3">
            <!--#include file="Menu.asp"-->
         </td>
     </tr>   
	</table>
</center>
<br>
<form method="post" action="gerarAPIS.asp?seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>&dataPrevista=<%=dataPrevista%>&voo=<%=voo%>" name="form1" id="form1">
<table>
	<tr>	
      <td class="CORPO9">Preencha os dados da parte respons&aacute;vel para gera&ccedil;&atilde;o do relat&oacute;rio:</td>
   </tr>
   <tr>
      <td>&nbsp;</td>
   </tr> 
</table>   
<table >
   <tr>	
      <td class="CORPO9" align="right">Nome:</td>
      <td><input type="text" size="20" name="txt_nome" style="text-transform:uppercase;" class="CORPO9"></td>
   </tr>   
   <tr>
   	<td  align="right">Sexo:</td>
      <td class="CORPO9"><input type="radio" name="rdbSexo" value="SR" checked>Masculino</td>
      <td class="CORPO9"><input type="radio" name="rdbSexo" value="SRA">Feminino</td>
   <tr>
      <td class="CORPO9" align="right">Telefone:</td>
      <td><input type="text" size="20" name="txt_telefone" class="CORPO9"></td>
   </tr>   
   <tr>	
      <td class="CORPO9" align="right">Fax:</td>
      <td><input type="text" size="20" name="txt_fax" class="CORPO9"></td>
   </tr>
   <tr>
   	<td class="CORPO9" align="right">Código do tipo de voo:</td>   
   	<td class="CORPO9">
      	<select name="slt_tipovoo">
         	<option value="C">C</option>
            <option value="CC">CC</option>
            <option value="B">B</option>
            <option value="BC">BC</option>
            <option value="A">A</option>
            <option value="D">D</option>
            <option value="E">E</option>
            <option value="EC">EC</option>
            <option value="F">F</option>
            <option value="FC">FC</option>
         </select>   
      </td> 
   </tr>
   <tr class="CORPO9"> 
   	<td align="right" class="CORPO9">Código da Empresa:</td>
      <td><input name="txt_Cod_Empresa" maxlength="2" size="3" style="text-transform:uppercase" class="CORPO9"></td>
   </tr>   
   <tr>
   	<td></td>
   <tr>   
   <tr>
   	<td><input type="submit" value="Gerar APIS" onClick="Javascript: return VerificaCampos();" ></td>
   </tr>   
</table>
</form>