<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="relatoriotransito_asp.asp"-->

<html>

<head>
	<title>Movimento de Tr&#226;nsito</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">

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
				<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0" /></a>
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

<% call PreencherDetalheMovimentoTransito() %>

<div style="min-width:760px;">
<center>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:22.5%;">V&#212;O:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strNumeroVoo%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:34.1%;">PREFIXO:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strPrefixoAeronave%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:43.4%;">LOCAL/DATA:&nbsp;&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strCodigoIataOrigem%>&nbsp;-&nbsp;<%=strDataOperacao%></label></td>
	</tr>
</table>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:22.5%;">CMT:&nbsp;<label style="font-size:10pt; font-weight:bold; white-space:nowrap;"><%=strComandante%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:22.5%;">COP:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt;">COM:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:31.0%;">COM:&nbsp;</td>
	</tr>
</table>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:10.5%;">JUMP-SEAT:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:22.5%;">destino:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:36.0%;">nome:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:31.0%;">fun&#231;&#227;o:&nbsp;</td>
	</tr>
</table>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:16.5%;">ORIG:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strCodigoIataOrigem%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:16.5%;">DEST:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strCodigoIataDestino%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:23.9%;">POUSO:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strPouso%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:29.5%;">DECOLAGEM:&nbsp;real&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strDecolagem%></label></td>
		<td style="padding-left:5px; font-size:9pt; width:13.6%;">visual:&nbsp;</td>
	</tr>
</table>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
	<tbody>
		<tr style="font-size:9pt; text-align:center;">
			<td style="width:8.5%;" rowspan="2">Destino</td>
			<td style="width:1.95%;" rowspan="2">&nbsp;</td>
			<td style="width:35.82%;" colspan="6">PAX</td>
			<td style="width:17.91%;" colspan="3">BAG</td>
			<td style="width:17.91%;" colspan="3">RPN</td>
			<td style="width:17.91%;" colspan="3">CGA PAGA</td>
		</tr>
		<tr style="font-size:9pt; text-align:center;">
			<td style="width:5.97%;">ADT</td>
			<td style="width:5.97%;">CHD</td>
			<td style="width:5.97%;">INF</td>
			<td style="width:5.97%;">INSPAC</td>
			<td style="width:5.97%;">EXTRA</td>
			<td style="width:5.97%;">GRATIS</td>
			<td style="width:5.97%;">NR.&nbsp;VOL</td>
			<td style="width:5.97%;">PESO</td>
			<td style="width:5.97%;">POR&#195;O</td>
			<td style="width:5.97%;">NR.&nbsp;VOL</td>
			<td style="width:5.97%;">PESO</td>
			<td style="width:5.97%;">POR&#195;O</td>
			<td style="width:5.97%;">NR.&nbsp;VOL</td>
			<td style="width:5.97%;">PESO</td>
			<td style="width:5.97%;">POR&#195;O</td>
		</tr>
		<% call PreencherTabelaCombinada() %>


		<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
			<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;A&nbsp;BORDO</td>
			<td style='padding-right:10px;'><%=strPaxAdtTotal%></td>
			<td style='padding-right:10px;'><%=strPaxChdTotal%></td>
			<td style='padding-right:10px;'><%=strPaxInfTotal%></td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'><%=strPaxDhcExtraTotal%></td>
			<td style='padding-right:10px;'><%=strPaxPadGratisTotal%></td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'><%=strPesoBagagemTotal%></td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'><%=strPesoCorreioTotal%></td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'>&nbsp;</td>
			<td style='padding-right:10px;'><%=strCargaPagaTotal%></td>
			<td style='padding-right:10px;'>&nbsp;</td>
		</tr>


	</tbody>
	<tfoot>
		<tr>
			<th colspan="17"></th>
		</tr>
	</tfoot>
</table>
<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:100%;" colspan="2">OBS.:&nbsp;<label style="font-size:10pt; font-weight:bold;"><%=strObservacao%></label></td>
	</tr>
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:100%;" colspan="2">ATD. ESPECIAIS:&nbsp;</td>
	</tr>
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:52%;">ENVELOPE:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:48%;">MALOTES:&nbsp;</td>
	</tr>
	<tr>
		<td style="padding-left:5px; font-size:9pt; width:52%;">DESPACHANTE:&nbsp;</td>
		<td style="padding-left:5px; font-size:9pt; width:48%;">SUPERVISOR:&nbsp;</td>
	</tr>
</table>
</center>
</div>

</body>

</html>
