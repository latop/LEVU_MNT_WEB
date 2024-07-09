<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="avaliacaodesempenho_asp.asp"-->

<html>

<head>
	<title>SIGLA - Avalia&#231&#227;o de Desempenho</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
</head>

<body>

<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
		<tr>
			<td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
				<img src="imagens/logo_empresa.gif" border="0" alt='' />
			</td>
			<td class="corpo" align="center" width="30%" rowspan="2">
				<font size="4"><b>Avalia&#231&#227;o&nbsp;de&nbsp;Desempenho</b></font>
			</td>
			<td class="corpo" align="right" valign="top" width="35%">
				<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0" alt='' /></a>
			</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="3"><!--#include file="Menu.asp"--></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
</center>
<center>
	<form action="avaliacaodesempenho.asp" method="post">
		<div style="width:90%; margin-top:50px;">
			<input type="submit" id="btnPesquisar" name="btnPesquisar" class="botao1" value="Pesquisar" tabindex='1' />
			&nbsp;
			<input type="submit" id="btnNovaAvaliacao" name="btnNovaAvaliacao" class="botao1" value="Nova Avalia&#231&#227;o" tabindex='2' />
			&nbsp;
			<input type="submit" id="btnVoltar" name="btnVoltar" class="botao1" value="Voltar" tabindex='3' />
		</div>
	</form>
</center>
</body>

</html>
