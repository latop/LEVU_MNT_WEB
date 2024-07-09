<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<!--#include file="servicoaerop_asp.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>

<html>
<head>
	<title>Serviços Aeroportuários</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	<script src="javascript.js"></script>
	<style type="text/css">
		body { margin-left: 0px; }
	</style>
</head>

<body>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
		<tr>
			<td class="corpo" align="left" valign="top" width="35%">
				<img src="imagens/logo_empresa.gif" border="0"></a>
			</td>
			<td class="corpo" align="center" width="30%" rowspan="2">
				<font size="4"><b>&nbsp;Serviços Aeroportuários [Horário UTC]</b></font>
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

<form id="form1" name="form1" method="post" action="servicoaerop.asp?seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>">
<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0'>
	<tr style="padding-top: 5px; padding-bottom: 5px">
		<td style="padding-left: 50px; padding-right: 50px">
			<fieldset style="width: 98%">
				<legend><strong class="CORPO9">Informações sobre o trecho</strong></legend>
				<table border='0' cellpadding='0' align="left" cellspacing='0'>
					<tr style="padding-top: 5px; padding-bottom: 5px">
						<td style="padding-left: 20px; font-weight: bold" align="right">
							Voo:
						</td>
						<td style="padding-left: 5px">
							<%=ls_Numero_Voo%>
						</td>
						<td style="padding-left: 20px; font-weight: bold" align="right">
							Aeronave:
						</td>
						<td style="padding-left: 5px">
							<%=ls_PrefixoAeronave%>
						</td>
					</tr>
					<tr style="padding-top: 5px; padding-bottom: 5px">
						<td style="padding-left: 20px; font-weight: bold" align="right">
							Origem:
						</td>
						<td style="padding-left: 5px">
							<%=ls_Codigo_IATA_Origem%>
						</td>
						<td style="padding-left: 20px; font-weight: bold" align="right">
							Destino:
						</td>
						<td style="padding-left: 5px">
							<%=ls_Codigo_IATA_Destino%>
						</td>
					</tr>
					<tr style="padding-top: 5px; padding-bottom: 5px">
						<td style="padding-left: 20px; font-weight: bold" align="right">
							Partida prevista:
						</td>
						<td style="padding-left: 5px">
							<%=ls_partidaprev%>
						</td>
						<td colspan="2"></td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
	<tr style="padding-top: 5px; padding-bottom: 5px">
		<td style="padding-left: 50px; padding-right: 50px">
			<fieldset style="width: 98%">
				<legend><strong class="CORPO9">Serviços</strong></legend>
				<%call PreencherServicosAeroportuarios(intSeqVooDia, intSeqTrecho) %>
			</fieldset>
		</td>
	</tr>
	<tr>
		<td width="100%" align="center" style="padding-top: 20px">
			<input type="submit" name="btnGravar" id="btnGravar" value="Gravar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px; visibility:<%=blnHabilitaBtnGravar%>" />
		<% if ((dominio <> 3) or (intEmpresa = 1)) then %>
			<input type="button" name="btnVoltar" id="btnVoltar" value="Voltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" onclick="javascript: history.go(-<%=qtdVolta%>)" />
		<% else %>
			<span onclick="return RedirecionaPagina(this, 'Aeroporto');">
				<a href="CombinadaAeropSec.aspx?seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>">
					<input type="button" name="btnVoltar" id="btnVoltarAeroporto" value="Voltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" />
				</a>
			</span>
		<% end if %>
		</td>
	</tr>
</table>
<input type="hidden" id="hidSeqVooDia" name="hidSeqVooDia" value="<%=intSeqVooDia%>" />
<input type="hidden" id="hidSeqTrecho" name="hidSeqTrecho" value="<%=intSeqTrecho%>" />
<input type="hidden" id="hidQtdVolta" name="hidQtdVolta" value="<%=qtdVolta%>" />
</form>
</body>
</html>
