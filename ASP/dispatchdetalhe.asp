<%@  language="VBScript" %>
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
    <script type="text/javascript" src="dispatchdetalhe.js"></script>
</head>

<body onload="init();">

    <center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
		<tr>
			<td class="corpo" align="left" valign="middle" width="35%">
				<img style="height:35px" src="imagens/logo_empresa.gif" border="0" alt="" />
			</td>
			<td class="corpo" align="center" width="30%" rowspan="2" style="font-weight:bold;">
				<span class="CORPO12">Detalhe da Etapa</span><br /><span class="CORPO10">(Dispatch Release)</span>
			</td>
			<td class="corpo" align="right" valign="top" width="35%">
				<a href="http://www.latop.com.br"><img style="height:35px" src="imagens/sigla.gif" border="0" alt="SIGLA" /></a>
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

    <% call PreencherDetalheEtapa()
    
    
    
    Dim strSqlSelect
	strSqlSelect = " SELECT "
	strSqlSelect = strSqlSelect & " pesoadt PESOADT, "
	strSqlSelect = strSqlSelect & " pesochd PESOCHD, "
	strSqlSelect = strSqlSelect & " pesoinf PESOINF "
	Dim strSqlFrom
	strSqlFrom = " FROM "
	strSqlFrom = strSqlFrom & " sig_parametros "
	Dim strQuery
	strQuery = strSqlSelect & strSqlFrom
	Dim objRs
	Set objRs = Server.CreateObject("ADODB.Recordset")

    Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	objRs.Open strQuery, objConn

	Do While Not objRs.Eof
    
        'Dim pesoAdulto
	        pesoAdulto = objRs("PESOADT")
        If (IsVazio(pesoAdulto)) Then
			pesoAdulto = 80
		End If

        'Dim pesoCrianca
	    pesoCrianca = objRs("PESOCHD")
        If (IsVazio(pesoCrianca)) Then
			pesoCrianca = 35
		End If

        'Dim pesoInfo
	    pesoInfo = objRs("PESOINF")
        If (IsVazio(pesoInfo)) Then
			pesoInfo = 10
		End If
    
        objRs.movenext
	Loop

	objRs.Close
	Set objRs = Nothing

	objConn.Close
	Set objConn = Nothing
    
    
    %>

    <ul id="tabs">
        <li><a class="selected" href="#balanceamento">Balanceamento</a></li>
        <!--<li><a href="#carregamentoporoes">Carregamento de Porões</a></li>-->
        <li><a href="#planovoo">Navega&#231;&#227;o/Notam</a></li>
    </ul>

    <div class="tabContent" id="balanceamento">
        <center>
<table width="60%" class="tabelaComBordas" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="width:98%; text-align:left; vertical-align:top;">
			<div style="text-align:right; padding-right:5px; font-size:8pt; font-family:Arial,Sans-Serif; font-weight:bold;">
				<a href="" onclick="window.open('dispatchdetalhebalprint.asp?seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=700,height=700');return false;">Imprimir</a>
			</div>
			<div style="padding-top:0; padding-bottom:5px; text-align:center; font-family:Verdana,Arial,Sans-Serif; font-size:12pt; font-weight:bold;">
				WEIGHT&nbsp;&#38;&nbsp;BALANCE&nbsp;AND&nbsp;TAKE&nbsp;OFF&nbsp;COMPUTATION
			</div>
			<table width="100%" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; border-left:none;">Num.&nbsp;Voo</td>
					<td style="font-size:7pt;">De</td>
					<td style="font-size:7pt;">Para</td>
					<td style="font-size:7pt;">Data/Hora&nbsp;da&nbsp;Edi&#231;&#227;o</td>
					<td style="font-size:7pt;">Data/Hora&nbsp;Despacho</td>
					<td style="font-size:7pt;">Prefixo</td>
					<td style="font-size:7pt;">Config</td>
					<td style="font-size:7pt; border-right:none;">DOV</td>
				</tr>
				<tr>
					<td style="font-size:7pt; font-weight:bold; border-left:none;"><%=strSiglaEmpresa%><%=strNrVoo%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strRouteOrigem%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strRouteDestino%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strDataAlteracao%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strDataDispatch%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strPrefixoAeronave%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strCrewConf%></td>
					<td style="font-size:7pt; font-weight:bold; border-right:none;"><%=strPreparedBy%></td>
				</tr>
			</table>
			<table width="100%" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; border-top:none; border-left:none;">Edi&#231;&#227;o</td>
					<td style="font-size:7pt; border-top:none;">RWY</td>
					<td style="font-size:7pt; border-top:none;">RWY&nbsp;Cond</td>
					<td style="font-size:7pt; border-top:none;">TO&nbsp;Mode</td>
					<td style="font-size:7pt; border-top:none;">Flap</td>
					<td style="font-size:7pt; border-top:none;">Dire&#231;&#227;o/Vento&nbsp;(&#176;/kts)</td>
					<td style="font-size:7pt; border-top:none;">T&nbsp;(&#176;C)</td>
					<td style="font-size:7pt; border-top:none; border-right:none;">QNH&nbsp;(hPa)</td>
				</tr>
				<tr>
					<td style="font-size:7pt; font-weight:bold; border-left:none;"><%=strEdition%></td>
					<td style="font-size:7pt; font-weight:bold; background-color:#A9A9A9;"><%=strRWY%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strRwyCondition%></td>
					<td style="font-size:7pt; font-weight:bold;"><%=strTakeOffMode%></td>
					<td style="font-size:7pt; font-weight:bold; background-color:#A9A9A9;"><%=strFlaps%></td>
					<td style="font-size:7pt; font-weight:bold; background-color:#A9A9A9;"><%=strWindDirection%>/<%=strWind%></td>
					<td style="font-size:7pt; font-weight:bold; background-color:#A9A9A9;"><%=strTemperature%></td>
					<td style="font-size:7pt; font-weight:bold; background-color:#A9A9A9; border-right:none;"><%=strQNH%></td>
				</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="width:35%; font-size:7pt; text-align:left; border:none; padding:5px 5px 5px 5px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
							<tr>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; font-weight:bold;">KG</td>
								<td style="font-size:7pt; font-weight:bold;">CG</td>
								<td style="font-size:7pt; font-weight:bold;">INDEX</td>
							</tr>
							<tr>
								<td style="font-size:7pt; font-weight:bold; text-align:left;">BOW</td>
								<td style="font-size:7pt;"><%=strBasicOperatingWeight%></td>
								<td style="font-size:7pt;"><%=strPboIndex%></td>
								<td style="font-size:7pt;"><%=strAeronavePboArm%></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Carga</td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intSomaPoroes%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Passageiros</td>
								<td style="font-size:7pt;"><%=intPaxPesoTotal%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Carga&nbsp;Total</td>
								<td style="font-size:7pt;"><%=(CInt(CInt(intSomaPoroes) + CInt(intPaxPesoTotal)))%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; font-weight:bold; text-align:left;">ZFW</td>
								<td style="font-size:7pt;"><%=strZeroFuelWeight%></td>
								<td style="font-size:7pt;"><%=strZfwIndex%></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left; white-space:nowrap;">ZFW&nbsp;LMC&nbsp;(+/-)</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Comb.&nbsp;Decol.</td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intTakeoffFuel%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left; white-space:nowrap;">Comb.&nbsp;LMC&nbsp;(+/-)</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt;">&nbsp;</td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; font-weight:bold; text-align:left;">TOW</td>
								<td style="font-size:7pt;"><%=strTakeoffWeight%></td>
								<td style="font-size:7pt;"><%=strTowIndex%></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left; white-space:nowrap;">TOW&nbsp;LMC&nbsp;(+/-)</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Comb.&nbsp;Etapa</td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intTripFuel%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; font-weight:bold; text-align:left;">ELW</td>
								<td style="font-size:7pt;"><%=strLandingWeight%></td>
								<td style="font-size:7pt;"><%=strLwIndex%></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left; white-space:nowrap;">ELW&nbsp;LMC&nbsp;(+/-)</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Comb.&nbsp;Pouso</td>
								<td style="font-size:7pt;"><%=(CInt(CInt(intTakeoffFuel) - CInt(intTripFuel)))%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Stab.&nbsp;TRIM</td>
								<td style="font-size:7pt;"><%=strStabTrim%></td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
							<tr>
								<td style="font-size:7pt; text-align:left;">Stab.&nbsp;Trim&nbsp;LMC</td>
								<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
								<td style="font-size:7pt; border:none;"></td>
								<td style="font-size:7pt; border:none;"></td>
							</tr>
						</table>
					</td>
					<td style="width:25%; font-size:7pt; vertical-align:top; border:none; padding:30px 5px 5px 5px;">
						<% call MontarTabelaSecaoFileira() %>
						<table class="tabelaComBordas" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif; margin-top:30px;">
							<tr>
								<td style="font-size:6pt; border:none; padding:5px 10px 0 10px; white-space:nowrap;">ADT&nbsp;-&nbsp;<%= pesoAdulto %>kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px; white-space:nowrap;">CHD&nbsp;-&nbsp;<%= pesoCrianca %>kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 5px 10px; white-space:nowrap;">INF&nbsp;-&nbsp;<%= pesoInfo %>kg</td>
							</tr>
						</table>
					</td>
					<td style="width:40%; font-size:7pt; vertical-align:top; border:none; padding:5px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
							<tr>
								<td style="font-size:7pt; font-weight:bold; border:none;"></td>
								<td style="font-size:7pt; font-weight:bold;">Bra&#231;o</td>
								<td style="font-size:7pt; font-weight:bold;">LMC</td>
								<td style="font-size:7pt; font-weight:bold;">INDEX</td>
								<td style="font-size:7pt; font-weight:bold;" rowspan="2">ADT</td>
								<td style="font-size:7pt; font-weight:bold;" rowspan="2">CHD</td>
								<td style="font-size:7pt; font-weight:bold;" rowspan="2">INF</td>
							</tr>
							<tr>
								<td style="font-size:7pt; font-weight:bold;">Setor</td>
								<td style="font-size:7pt;">(m)</td>
								<td style="font-size:7pt;">(kg)</td>
								<td style="font-size:7pt;">-</td>
							</tr>
							<% call PreencherTabelaPaxSecao() %>
							<tr>
								<td style="font-size:7pt; border:none;">&nbsp;</td>
							</tr>
							<tr>
								<td style="height:105px; font-size:6pt; text-align:left; padding:5px 5px 5px 5px; vertical-align:top;" colspan="7">
									Observa&#231;&#245;es:<br /><%=strRemarks%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; border:none;"></td>
					<td style="font-size:7pt; font-weight:bold; border-right:none;" colspan="5">Pesos&nbsp;(kg)</td>
				</tr>
				<tr>
					<td style="font-size:7pt; border:none;"></td>
					<td style="font-size:7pt; font-weight:bold;">Atual</td>
					<td style="font-size:7pt; font-weight:bold;">LMC</td>
					<td style="font-size:7pt; font-weight:bold;">Estrut.</td>
					<td style="font-size:7pt; font-weight:bold;">Perform.</td>
					<td style="font-size:7pt; font-weight:bold; border-right:none;">Carga<br />Paga&nbsp;Disp.</td>
				</tr>
				<tr>
					<td style="font-size:7pt; font-weight:bold; border-left:none;">ZFW</td>
					<td style="font-size:7pt;"><%=strZeroFuelWeight%></td>
					<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
					<td style="font-size:7pt;"><%=strMaximumZeroFuelWeight%></td>
					<td style="font-size:7pt; background-color:#333333;">////</td>
					<td style="font-size:7pt; border-right:none;" rowspan="3"><%=strActualUnderload%></td>
				</tr>
				<tr>
					<td style="font-size:7pt; font-weight:bold; border-left:none;">TOW</td>
					<td style="font-size:7pt;"><%=strTakeoffWeight%></td>
					<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
					<td style="font-size:7pt;"><%=strAeronaveMtogw%></td>
					<td style="font-size:7pt;"><%=strRwyLimitedCorrectedMtow%></td>
				</tr>
				<tr>
					<td style="font-size:7pt; font-weight:bold; border-left:none;">LW</td>
					<td style="font-size:7pt;"><%=strLandingWeight%></td>
					<td style="font-size:7pt; background-color:#99FFFF;">&nbsp;</td>
					<td style="font-size:7pt;"><%=strMaximumLandingWeight%></td>
					<td style="font-size:7pt;"><%=strRwnlw%></td>
				</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; width:15%; text-align:right; padding-left:5px; padding-right:5px; border-top:none; border-left:none;">Comandante:</td>
					<td style="font-size:7pt; width:25%; text-align:left; padding-left:5px; padding-right:5px; border-top:none;"><%=strNomeGuerra%>&nbsp;</td>
					<td style="font-size:7pt; width:10%; text-align:right; padding-left:5px; padding-right:5px; border-top:none;">ANAC</td>
					<td style="font-size:7pt; width:15%; text-align:left; padding-left:5px; padding-right:5px; border-top:none;"><%=strCodDac%>&nbsp;</td>
					<td style="font-size:7pt; width:5%; text-align:right; padding-left:5px; padding-right:5px; border-top:none;">Ass.</td>
					<td style="font-size:7pt; border-top:none; border-right:none;">&nbsp;</td>
				</tr>
			</table>
			<div align="center" style="border:solid 1px #000000; margin:5px; padding:1px 0 10px 0;">
				<iframe scrolling="no" frameborder="0" width="500px" height="250px" src="../Aeroporto/GraficoBalanceamento.aspx?prefixo=<%=strPrefixoAeronave%>&seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>&numedicao=<%=strEdition%>"></iframe>
			</div>
			<!--<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="font-size:7pt; vertical-align:top; border:none; padding:5px 5px 5px 5px;">
						<table class="tabelaComBordas" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">LMC:Corre&#231;&#245;es&nbsp;de&nbsp;&#250;ltima&nbsp;hora</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">Pax:&nbsp;M&#225;ximo&nbsp;LMC&nbsp;05&nbsp;PAX</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">Bagag.:M&#225;ximo&nbsp;LMC&nbsp;200Kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">Combust.:M&#225;ximo&nbsp;LMC&nbsp;500Kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">CXX:&nbsp;Bagag.lmc&nbsp;xx0&nbsp;Kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">FXX:Combust.LMC&nbsp;xx0Kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">Pax0:LMC&nbsp;sem&nbsp;sem&nbsp;consid.&nbsp;PAX</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">N&#186;PaxM:N&#186;m&#225;x&nbsp;Pax&nbsp;no&nbsp;LMC</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">CG&nbsp;xkg&nbsp;PaxM:&nbsp;CG&nbsp;Consid&nbsp;N&#186;</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px;">Max&nbsp;PAX&nbsp;c/&nbsp;bagag&nbsp;xkg&nbsp;cada.</td>
							</tr>
						</table>
					</td>
					<td style="font-size:7pt; text-align:left; border:none; padding:5px 5px 5px 5px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">Conf.</td>
								<td style="font-size:7pt;">CG<br />Pax</td>
								<td style="font-size:7pt; background-color:#FFFF99;">Conf.</td>
								<td style="font-size:7pt;">CG<br />Pax0</td>
								<td style="font-size:7pt; background-color:#A9A9A9;">CG<br />PaxM</td>
								<td style="font-size:7pt; background-color:#A9A9A9;">N&#186;<br />PaxM</td>
								<td style="font-size:7pt; background-color:#FFFF99;">Conf.</td>
								<td style="font-size:7pt;">CG<br />Pax0</td>
								<td style="font-size:7pt; background-color:#A9A9A9;">CG<br />0kg<br />PaxM</td>
								<td style="font-size:7pt; background-color:#A9A9A9;">N&#186;<br />PaxM</td>
								<td style="font-size:7pt;">CG<br />10kg<br />PaxM</td>
								<td style="font-size:7pt;">N&#186;<br />PaxM</td>
							</tr>
							<% call PreencherDadosLMC() %>
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">P1</td>
								<td style="font-size:7pt;"><%=dblPAX01TowIndex%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">C00</td>
								<td style="font-size:7pt; background-color:#333333;">////</td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblCAP00TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intCAP00PaxMax%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">F10</td>
								<td style="font-size:7pt;"><%=dblFUE10TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblFUP10TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intFUP10PaxMax%></td>
								<td style="font-size:7pt;"><%=dblFCP10TowIndex%></td>
								<td style="font-size:7pt;"><%=intFCP10PaxMax%></td>
							</tr>
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">P2</td>
								<td style="font-size:7pt;"><%=dblPAX02TowIndex%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">C05</td>
								<td style="font-size:7pt;"><%=dblCAR05TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblCAP05TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intCAP05PaxMax%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">F20</td>
								<td style="font-size:7pt;"><%=dblFUE20TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblFUP20TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intFUP20PaxMax%></td>
								<td style="font-size:7pt;"><%=dblFCP20TowIndex%></td>
								<td style="font-size:7pt;"><%=intFCP20PaxMax%></td>
							</tr>
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">P3</td>
								<td style="font-size:7pt;"><%=dblPAX03TowIndex%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">C10</td>
								<td style="font-size:7pt;"><%=dblCAR10TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblCAP10TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intCAP10PaxMax%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">F30</td>
								<td style="font-size:7pt;"><%=dblFUE30TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblFUP30TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intFUP30PaxMax%></td>
								<td style="font-size:7pt;"><%=dblFCP30TowIndex%></td>
								<td style="font-size:7pt;"><%=intFCP30PaxMax%></td>
							</tr>
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">P4</td>
								<td style="font-size:7pt;"><%=dblPAX04TowIndex%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">C15</td>
								<td style="font-size:7pt;"><%=dblCAR15TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblCAP15TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intCAP15PaxMax%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">F40</td>
								<td style="font-size:7pt;"><%=dblFUE40TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblFUP40TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intFUP40PaxMax%></td>
								<td style="font-size:7pt;"><%=dblFCP40TowIndex%></td>
								<td style="font-size:7pt;"><%=intFCP40PaxMax%></td>
							</tr>
							<tr>
								<td style="font-size:7pt; background-color:#FFFF99;">P5</td>
								<td style="font-size:7pt;"><%=dblPAX05TowIndex%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">C20</td>
								<td style="font-size:7pt;"><%=dblCAR20TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblCAP20TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intCAP20PaxMax%></td>
								<td style="font-size:7pt; background-color:#FFFF99;">F50</td>
								<td style="font-size:7pt;"><%=dblFUE50TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=dblFUP50TowIndex%></td>
								<td style="font-size:7pt; background-color:#A9A9A9;"><%=intFUP50PaxMax%></td>
								<td style="font-size:7pt;"><%=dblFCP50TowIndex%></td>
								<td style="font-size:7pt;"><%=intFCP50PaxMax%></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>-->
		</td>
	</tr>
</table>
</center>
    </div>

    <div style="display: none;" class="tabContent hide" id="carregamentoporoes">
        <table class="tblCarregamentoPoroes">
            <tr>
                <td id="coluna1">
                    <table class="tblInterna">
                        <tr>
                            <td>
                                <span class="destaque">webjet</span> ENG. OPERA&#199;&#213;ES / C.C.O. <span class="letrasPequenas">- FORM ISSUED DEC 24, 2008</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha destaque">INSTRU&#199;&#195;O DE CARREGAMENTO B737-300</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="larguraFixa5Col destaque">DATA</th>
                            <th class="larguraFixa5Col destaque">VOO NR</th>
                            <th class="larguraFixa5Col destaque">MATR&#205;CULA</th>
                            <th class="larguraFixa5Col destaque">ORIGEM</th>
                            <th class="larguraFixa5Col destaque">DESTINO</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa5Col destaque">27/02/2009</td>
                            <td class="larguraFixa5Col destaque">WEB6700</td>
                            <td class="larguraFixa5Col destaque">PR-WJB</td>
                            <td class="larguraFixa5Col destaque">GIG</td>
                            <td class="larguraFixa5Col destaque">POA</td>
                        </tr>
                        <tr>
                            <td colspan="5" class="ultimaLinha alturaFixa">&nbsp;</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="destaque" colspan="4">CHEGADA</th>
                        </tr>
                        <tr>
                            <th colspan="2">COMPARTIMENTO TRASEIRO</th>
                            <th colspan="2">COMPARTIMENTO DIANTEIRO</th>
                        </tr>
                        <tr>
                            <th class="larguraFixa4Col">4</th>
                            <th class="larguraFixa4Col">3</th>
                            <th class="larguraFixa4Col">2</th>
                            <th class="larguraFixa4Col">1</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao4%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao3%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao2%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao1%></td>
                        </tr>
                        <tr>
                            <td class="portas" colspan="2">
                                <div>PORTA TRASEIRA</div>
                            </td>
                            <td class="portas" colspan="2">
                                <div>PORTA DIANTEIRA</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 3469 KG</td>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 2206 KG</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="destaque" colspan="4">SA&#205;DA</th>
                        </tr>
                        <tr>
                            <th colspan="2">COMPARTIMENTO TRASEIRO</th>
                            <th colspan="2">COMPARTIMENTO DIANTEIRO</th>
                        </tr>
                        <tr>
                            <th class="larguraFixa4Col">4</th>
                            <th class="larguraFixa4Col">3</th>
                            <th class="larguraFixa4Col">2</th>
                            <th class="larguraFixa4Col">1</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao4%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao3%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao2%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao1%></td>
                        </tr>
                        <tr>
                            <td class="portas" colspan="2">
                                <div>PORTA TRASEIRA</div>
                            </td>
                            <td class="portas" colspan="2">
                                <div>PORTA DIANTEIRA</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 3469 KG</td>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 2206 KG</td>
                        </tr>
                    </table>
                    <table class="tblInterna tblInstrucoes">
                        <tr>
                            <td class="instrucoes destaque" rowspan="2">INSTRU&#199;&#213;ES ESPECIAIS<br />
                                <%=strCarregInstrucao%>
                            </td>
                            <td class="instrucoes destaque letrasMedias">A AERONAVE FOI CARREGADA DE ACORDO COM ESTA INSTRU&#199;&#195;O DE CARREGAMENTO
                            </td>
                        </tr>
                        <tr>
                            <td class="instrucoes assinatura destaque letrasMedias">ASSINATURA COORDENADOR DE RAMPA:
                            </td>
                        </tr>
                        <tr>
                            <td class="instrucoes destaque">DOV <span class="letrasMedias">ALVES 808568</span>
                            </td>
                            <td class="instrucoes continuaAssinatura"></td>
                        </tr>
                    </table>
                </td>
                <td id="coluna2">&nbsp;</td>
                <td id="coluna3">&nbsp;</td>
                <td id="coluna4">
                    <table class="tblInterna">
                        <tr>
                            <td>
                                <span class="destaque">webjet</span> ENG. OPERA&#199;&#213;ES / C.C.O. <span class="letrasPequenas">- FORM ISSUED DEC 24, 2008</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha destaque">INSTRU&#199;&#195;O DE CARREGAMENTO B737-300</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="larguraFixa5Col destaque">DATA</th>
                            <th class="larguraFixa5Col destaque">VOO NR</th>
                            <th class="larguraFixa5Col destaque">MATR&#205;CULA</th>
                            <th class="larguraFixa5Col destaque">ORIGEM</th>
                            <th class="larguraFixa5Col destaque">DESTINO</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa5Col destaque">27/02/2009</td>
                            <td class="larguraFixa5Col destaque">WEB6700</td>
                            <td class="larguraFixa5Col destaque">PR-WJB</td>
                            <td class="larguraFixa5Col destaque">GIG</td>
                            <td class="larguraFixa5Col destaque">POA</td>
                        </tr>
                        <tr>
                            <td colspan="5" class="ultimaLinha alturaFixa">&nbsp;</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="destaque" colspan="4">CHEGADA</th>
                        </tr>
                        <tr>
                            <th colspan="2">COMPARTIMENTO TRASEIRO</th>
                            <th colspan="2">COMPARTIMENTO DIANTEIRO</th>
                        </tr>
                        <tr>
                            <th class="larguraFixa4Col">4</th>
                            <th class="larguraFixa4Col">3</th>
                            <th class="larguraFixa4Col">2</th>
                            <th class="larguraFixa4Col">1</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao4%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao3%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao2%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregChegPorao1%></td>
                        </tr>
                        <tr>
                            <td class="portas" colspan="2">
                                <div>PORTA TRASEIRA</div>
                            </td>
                            <td class="portas" colspan="2">
                                <div>PORTA DIANTEIRA</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 3469 KG</td>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 2206 KG</td>
                        </tr>
                    </table>
                    <table class="tblInterna">
                        <tr>
                            <th class="destaque" colspan="4">SA&#205;DA</th>
                        </tr>
                        <tr>
                            <th colspan="2">COMPARTIMENTO TRASEIRO</th>
                            <th colspan="2">COMPARTIMENTO DIANTEIRO</th>
                        </tr>
                        <tr>
                            <th class="larguraFixa4Col">4</th>
                            <th class="larguraFixa4Col">3</th>
                            <th class="larguraFixa4Col">2</th>
                            <th class="larguraFixa4Col">1</th>
                        </tr>
                        <tr>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao4%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao3%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao2%></td>
                            <td class="larguraFixa4Col ultimaLinha"><%=strCarregPartPorao1%></td>
                        </tr>
                        <tr>
                            <td class="portas" colspan="2">
                                <div>PORTA TRASEIRA</div>
                            </td>
                            <td class="portas" colspan="2">
                                <div>PORTA DIANTEIRA</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 3469 KG</td>
                            <td class="ultimaLinha" colspan="2">PESO M&#193;XIMO 2206 KG</td>
                        </tr>
                    </table>
                    <table class="tblInterna tblInstrucoes">
                        <tr>
                            <td class="instrucoes destaque" rowspan="2">INSTRU&#199;&#213;ES ESPECIAIS<br />
                                <%=strCarregInstrucao%>
                            </td>
                            <td class="instrucoes destaque letrasMedias">A AERONAVE FOI CARREGADA DE ACORDO COM ESTA INSTRU&#199;&#195;O DE CARREGAMENTO
                            </td>
                        </tr>
                        <tr>
                            <td class="instrucoes assinatura destaque letrasMedias">ASSINATURA COORDENADOR DE RAMPA:
                            </td>
                        </tr>
                        <tr>
                            <td class="instrucoes destaque">DOV <span class="letrasMedias">ALVES 808568</span>
                            </td>
                            <td class="instrucoes continuaAssinatura"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

    <div class="tabContent hide" id="planovoo">
        <div style="text-align: right; padding-right: 5px; font-size: 8pt; font-family: Arial,Sans-Serif; font-weight: bold;">
            <a href="" onclick="window.open('dispatchdetalhenavprint.asp?seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=700,height=700');return false;">Imprimir</a>
        </div>
        <h2>Plano de Voo</h2>
        <div style="width: 80%; margin-top: 10px;">
            <table width="100%" class="tabelaComBordas" border="0" cellpadding="0" cellspacing="0" style="text-align: center; font-family: Verdana,Arial,Sans-Serif;">
                <tr>
                    <td style="font-size: 7pt; width: 15%; text-align: right; padding-left: 5px; padding-right: 5px; border-top: none; border-left: none;">Comandante:</td>
                    <td style="font-size: 7pt; width: 25%; text-align: left; padding-left: 5px; padding-right: 5px; border-top: none;"><%=strNomeGuerra%>&nbsp;</td>
                    <td style="font-size: 7pt; width: 10%; text-align: right; padding-left: 5px; padding-right: 5px; border-top: none;">ANAC</td>
                    <td style="font-size: 7pt; width: 15%; text-align: left; padding-left: 5px; padding-right: 5px; border-top: none;"><%=strCodDac%>&nbsp;</td>
                    <td style="font-size: 7pt; width: 5%; text-align: right; padding-left: 5px; padding-right: 5px; border-top: none;">Ass.</td>
                    <td style="font-size: 7pt; border-top: none; border-right: none;">&nbsp;</td>
                </tr>
                <tr>
                    <td style="font-size: 7pt; width: 15%; text-align: right; padding-left: 5px; padding-right: 5px; border-bottom: none; border-left: none;">DOV:</td>
                    <td style="font-size: 7pt; width: 25%; text-align: left; padding-left: 5px; padding-right: 5px; border-bottom: none; border-right: none;" colspan="5"><%=strPreparedBy%>&nbsp;</td>
                </tr>
            </table>
        </div>
        <div style="width: 80%">
            <p><%=strPlanoVoo%></p>
        </div>
    </div>

</body>

</html>
