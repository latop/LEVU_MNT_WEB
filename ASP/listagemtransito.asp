<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="listagemtransito_asp.asp"-->

<html>

<head>
	<title>Movimento de Tr&#226;nsito</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	<script src="javascript.js"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
	<script src="jquery.tablesorter.js" type="text/javascript"></script>
	<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
	<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
	<script type="text/javascript" src="listagemtransito.js"></script>

	<style type="text/css">
	<!--
		body {
			margin-left: 0px;
		}
	-->
	</style>
</head>

<body>

<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
		<tr>
			<td class="corpo" align="left" valign="middle" width="35%">
				<img src="imagens/logo_empresa.gif" border="0" />
			</td>
			<td class="corpo" align="center" width="30%" rowspan="2">
				<font size="4"><b>Movimento&nbsp;de&nbsp;Tr&#226;nsito<br />[Horário&nbsp;UTC]</b></font>
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
<br />
<center>
	<table width="98%" ID="Table2">
		<tr>
			<td>
				<form method="post" action="listagemtransito.asp" id="form1" onsubmit="Javascript: return VerificarCampos();">
					<div id="default" class="tab_group1 container">
						<label class="Corpo9">Data:</label>
						<input type="text" name="txtData" id="txtData" size="11" maxlength="10" class="Corpo9" value="<%=strTxtData%>" />
						&nbsp;
						<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
						&nbsp;&nbsp;
						<label class="Corpo9">Voo:</label>
						<input type="text" name="txtVoo" id="txtVoo" size="5" maxlength="4" class="Corpo9" onkeypress="ChecarTAB();" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=strTxtVoo%>" />
						&nbsp;&nbsp;
						<label class="Corpo9">Base:</label>
						<input type="text" name="txtLocalidade" id="txtLocalidade" size="5" maxlength="4" class="Corpo9" onkeypress="ChecarTAB();" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" style="text-transform:uppercase;" value="<%=strTxtLocalidade%>" />
						&nbsp;&nbsp;
						<input type="checkbox" name="chkExibirSetores" id="chkExibirSetores" value="ExibirSetores"
						<%
							If (chkExibirSetores = "ExibirSetores") Then
								Response.Write("checked='checked'")
							End If
						%>
						/>
						<label class="Corpo9" for="chkExibirSetores">Exibir&nbsp;Setores</label>
						&nbsp;&nbsp;
						<input type="submit" name="submit" value="Pesquisar" tabindex="10" />
					</div>
				</form>
			</td>
		</tr>
	</table>
</center>
<center>
	<table width="98%" border="1" cellpadding="0" cellspacing="0" class="tablesorter" ID="Table3">
		<thead>
			<tr bgcolor="#AAAAAA" style='cursor:pointer;cursor:hand' class="Corpo8Bold">
				<th style="text-align:center">Voo</th>
				<th style="text-align:center">Frota</th>
				<th style="text-align:center">Aeronave</th>
				<th style="text-align:center">Origem</th>
				<th style="text-align:center">Destino</th>
				<th style="text-align:center">Part. Prev.</th>
				<th style="text-align:center">Cheg. Prev.</th>
				<th style="text-align:center">Partida Motor</th>
				<th style="text-align:center">Corte Motor</th>
			</tr>
		</thead>
		<tbody>
			<% call PreencherTabelaEtapas() %>
		</tbody>
		<tfoot>
			<tr>
				<th colspan="9"></th>
			</tr>
		</tfoot>
	</table>
</center>

<div id="calendarDiv"></div>
</body>

</html>
