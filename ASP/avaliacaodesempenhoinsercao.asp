<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="avaliacaodesempenhoinsercao_asp.asp"-->

<html>

<head>
	<title>SIGLA - Avalia&#231&#227;o de Desempenho</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
	<script src="jquery.tablesorter.js" type="text/javascript"></script>
	<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script src="javascript.js" type="text/javascript"></script>
	<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
	<script type="text/javascript" language="javascript" src="avaliacaodesempenhoinsercao.js"></script>

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
				<font size="4"><b>Nova<br />Avalia&#231&#227;o&nbsp;de&nbsp;Desempenho</b></font>
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
	<form action="avaliacaodesempenhoinsercao.asp" method="post">
		<input type="hidden" id="hidDataEntradaPagina" name="hidDataEntradaPagina" value="<% Call PreencherDataEntradaPagina("hidDataEntradaPagina") %>" />
		<div id='divNovaAvaliacao' style="width:90%; text-align:left; margin-top:20px; display:block;" class='Corpo9'>
			<div>
				<div>
					Tripulante&nbsp;Avaliado:
					<input type="text" id="txtTripulanteAvaliado" name="txtTripulanteAvaliado" size="25" maxlength="20" style="text-transform:uppercase;" tabindex='1' onkeyup="lookup(this.value);" onblur="fill();" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					Data&nbsp;da&nbsp;Avalia&#231;&#227;o:
					<input type="text" id="txtDataAvaliacao" name="txtDataAvaliacao" size="11" maxlength="10" tabindex='2' />
					<input type="button" id="botaoCalendario" name="botaoCalendario" value=" " class="calendarECM" style="background:url(imagens/calendario.gif); width:24px; height:23px;" />
				</div>
				<div style="position:absolute;">
					<div class="suggestionsBox" id="suggestions" style="display: none;">
						<img src="imagens/upArrow.png" style="position: relative; top: -12px; left: 30px;" alt="upArrow" />
						<div class="suggestionList" id="autoSuggestionsList">
							&nbsp;
						</div>
					</div>
				</div>
			</div>
			<p>
				Tipo&nbsp;de&nbsp;Avalia&#231&#227;o:
				<select id="cmbTipoAvaliacao" name="cmbTipoAvaliacao" tabindex='3'>
					<option value=''>&nbsp;</option>
					<% Call PreencherTipoAvaliacao("") %>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Item&nbsp;Avaliado:
				<select id="cmbItemAvaliado" name="cmbItemAvaliado" tabindex='4'>
				<option value=''>&nbsp;</option>
					<% Call PreencherItemAvaliado("") %>
				</select>
			</p>
			<p>
				Avalia&#231&#227;o:<br />
				<textarea id="txaAvaliacao" name="txaAvaliacao" cols="80" rows="5" tabindex='5'></textarea>
				(no&nbsp;m&#225;ximo&nbsp;500&nbsp;caracteres)
			</p>
			<p>
				<input type="submit" id="btnInsereNovaAvaliacao" name="btnInsereNovaAvaliacao" class="botao1" onclick="javascript:return VerificarCamposInserirNovaAvaliacao();" value="Inserir" tabindex='6' />
				&nbsp;
				<input type="button" id="btnLimpaNovaAvaliacao" name="btnLimpaNovaAvaliacao" class="botao1" value="Limpar" tabindex='7' onclick="javascript:return LimparNovaAvaliacao();" />
				&nbsp;
				<input type="submit" id="btnVoltar" name="btnVoltar" class="botao1" value="Voltar" tabindex='8' />
			</p>
		</div>
		<hr style="width:97%; margin-top:20px; display:block; font-weight:bold;" />
		<div id='div1' style="width:97%; text-align:center; margin-top:20px; display:block; font-weight:bold;" class='Corpo10'>
			&#218;ltimas Avalia&#231;&#245es Inseridas
		</div>
		<table width="97%" border="1" cellpadding="0" cellspacing="0" id="tblTripChequeUltimasAvaliacoes" style="margin-top:20px;" >
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
				<% Call PreencherTabelaTripChequeUltimasAvaliacoes() %>
			</tbody>
		</table>
	</form>
</center>

<div id="calendarDiv"></div>

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
