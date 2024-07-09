<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="avaliacaodesempenhoconsulta_asp.asp"-->

<html>

<head>
	<title>SIGLA - Avalia&#231&#227;o de Desempenho</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
	<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
	<script src="jquery.tablesorter.js" type="text/javascript"></script>
	<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script src="javascript.js" type="text/javascript"></script>
	<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
	<script type="text/javascript" language="javascript" src="avaliacaodesempenhoconsulta.js"></script>

	<style type="text/css">
		.suggestionsBox {
			position: relative;
			left: 100px;
			margin: 10px 0px 0px 0px;
			width: 200px;
			background-color: #888888;
			-moz-border-radius: 7px;
			-webkit-border-radius: 7px;
			border: 2px solid #000;	
			color: #fff;
		}

		.suggestionList {
			margin: 0px;
			padding: 0px;
		}

		.suggestionList li {
			margin: 0px 0px 3px 0px;
			padding: 3px;
			cursor: pointer;
		}

		.suggestionList li:hover {
			background-color: #659CD8;
		}
	</style>

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
	<form action="avaliacaodesempenhoconsulta.asp" method="post">
		<table width="90%" border="0" cellpadding="0" cellspacing="0" id="Table" >
			<tr class='Corpo9'>
				<td style="white-space:nowrap;">
					<div>
						Tripulante&nbsp;Avaliado:
						<input type="text" id="txtTripulanteAvaliado" name="txtTripulanteAvaliado" size="25" maxlength="20" style="text-transform:uppercase;" value="<% Call PreencherCampo("txtTripulanteAvaliado") %>" tabindex='1' onkeyup="lookup(this.value);" onblur="fill();" />
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Per&#237;odo:
						<input type="text" id="txtData1" name="txtData1" size="11" maxlength="10" value="<% Call PreencherCampo("txtData1") %>" tabindex='2' />
						<input type="button" id="botaoCalendario" name="botaoCalendario" value=" " class="calendarECM" style="background:url(imagens/calendario.gif); width:24px; height:23px;" />
						&nbsp;
						At&eacute;:
						<input type="text" id="txtData2" name="txtData2" size="11" maxlength="10" value="<% Call PreencherCampo("txtData2") %>" tabindex='3' />
						<input type="button" id="botaoCalendario2" name="botaoCalendario2" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif); width:24px; height:23px;" />
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Tipo&nbsp;de&nbsp;Avalia&#231&#227;o:
						<select id="cmbTipoAvaliacao" name="cmbTipoAvaliacao" tabindex='4'>
							<option value=''>&nbsp;</option>
							<% Call PreencherTipoAvaliacao("cmbTipoAvaliacao") %>
						</select>
					</div>
					<div style="position:absolute;">
						<div class="suggestionsBox" id="suggestions" style="display: none;">
							<img src="imagens/upArrow.png" style="position: relative; top: -12px; left: 30px;" alt="upArrow" />
							<div class="suggestionList" id="autoSuggestionsList">
								&nbsp;
							</div>
						</div>
					</div>
				</td>
			</tr>
			<tr class='Corpo9'>
				<td style="padding-top:10px; white-space:nowrap;">
					Item&nbsp;Avaliado:
					<select id="cmbItemAvaliado" name="cmbItemAvaliado" tabindex='5'>
						<option value=''>&nbsp;</option>
						<% Call PreencherItemAvaliado("cmbItemAvaliado") %>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					Avaliador:
					<input type="text" id="txtAvaliador" name="txtAvaliador" size="25" maxlength="20" style="text-transform:uppercase;" value="<% Call PreencherCampo("txtAvaliador") %>" tabindex='6' />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="submit" id="btnPesquisar" name="btnPesquisar" class="botao1" value="Pesquisar" onclick="javascript:return VerificarCamposPesquisa();" tabindex='7' />
					&nbsp;
					<input type="submit" id="btnVoltar" name="btnVoltar" class="botao1" value="Voltar" tabindex='8' />
				</td>
			</tr>
		</table>
		<table width="97%" border="1" cellpadding="0" cellspacing="0" id="tblTripCheque" style="margin-top:20px;" >
			<thead>
				<tr style='cursor:pointer;cursor:hand; background-color:#AAAAAA;' class="Corpo8">
					<th style="width:10%; padding:1px;">Tripulante Avaliado</th>
					<th style="width:10%; padding:1px;">Data da Avalia&#231;&#227;o</th>
					<th style="width:10%; padding:1px;">Tipo de Avalia&#231;&#227;o</th>
					<th style="width:20%; padding:1px;">Item Avaliado</th>
					<th style="width:40%; padding:1px;">Avalia&#231;&#227;o</th>
					<th style="width:10%; padding:1px;">Avaliador</th>
				</tr>
			</thead>
			<tbody>
				<% Call PreencherTabelaTripCheque() %>
			</tbody>
		</table>
	</form>
</center>

<div id="calendarDiv"></div>
<div id="calendarDiv2"></div>

</body>

</html>

<%
Call Page_PreRender()

Function Page_PreRender()
	If (Not IsPostBack) Then
		Call ColocarFocoJS("txtTripulanteAvaliado")
	End If
End Function

%>
