<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="dispatchdetalhe_asp.asp"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>Detalhe da Etapa (Dispatch Release)</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
	<link href="dispatchdetalhe.css" rel="stylesheet" type="text/css" />
</head>

<body onload='javascript:window.print(); window.close();'>

<% call PreencherDetalheEtapa() %>

<div id="planovoo">
<center>
<table width="80%" class="tabelaComBordas" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="width:98%; text-align:left; vertical-align:top;">
			<table style="width:100%;">
				<tr>
					<td style="width:20%; border:none; text-align:left; padding: 2px 1px 2px 5px;">
						<img style="height:25px" src="imagens/logo_empresa.gif" border="0" alt="" />
					</td>
					<td style="width:60%; border:none; text-align:center; font-family:Verdana,Arial,Sans-Serif; font-size:10pt; font-weight:bold; padding: 2px 1px 2px 1px;">
						Plano&nbsp;de&nbsp;Voo
					</td>

					<td style="width:20%; border:none; text-align:right; padding: 2px 5px 2px 1px;">
						<img style="height:25px" src="imagens/sigla.gif" border="0" alt="SIGLA" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="width:98%; text-align:left; vertical-align:top;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; width:15%; text-align:right; padding-left:5px; padding-right:5px; border-top:none; border-left:none;">Comandante:</td>
					<td style="font-size:7pt; width:25%; text-align:left; padding-left:5px; padding-right:5px; border-top:none;"><%=strNomeGuerra%>&nbsp;</td>
					<td style="font-size:7pt; width:10%; text-align:right; padding-left:5px; padding-right:5px; border-top:none;">ANAC</td>
					<td style="font-size:7pt; width:15%; text-align:left; padding-left:5px; padding-right:5px; border-top:none;"><%=strCodDac%>&nbsp;</td>
					<td style="font-size:7pt; width:5%; text-align:right; padding-left:5px; padding-right:5px; border-top:none;">Ass.</td>
					<td style="font-size:7pt; border-top:none; border-right:none;">&nbsp;</td>
				</tr>
				<tr>
					<td style="font-size:7pt; width:15%; text-align:right; padding-left:5px; padding-right:5px; border-bottom:none; border-left:none;">DOV:</td>
					<td style="font-size:7pt; width:25%; text-align:left; padding-left:5px; padding-right:5px; border-bottom:none; border-right:none;" colspan="5"><%=strPreparedBy%>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="width:98%; text-align:left; vertical-align:top;">
			<p><%=strPlanoVoo%></p>
		</td>
	</tr>
</table>
</center>
</div>

</body>

</html>
