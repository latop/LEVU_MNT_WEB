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
</head>

<body onload='javascript:window.print(); window.close();'>

    <% call PreencherDetalheEtapa() %>

    <center>
<table width="80%" class="tabelaComBordas" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
	<tr>
		<td style="width:98%; text-align:left; vertical-align:top;">
			<table style="width:100%;">
				<tr>
					<td style="width:20%; border:none; text-align:left; padding: 2px 1px 2px 5px;">
						<img style="height:25px" src="imagens/logo_empresa.gif" border="0" alt="" />
					</td>
					<td style="width:60%; border:none; text-align:center; font-family:Verdana,Arial,Sans-Serif; font-size:8pt; font-weight:bold; padding: 2px 1px 2px 1px;">
						WEIGHT&nbsp;&#38;&nbsp;BALANCE&nbsp;AND&nbsp;TAKE&nbsp;OFF&nbsp;COMPUTATION
					</td>
					<td style="width:20%; border:none; text-align:right; padding: 2px 5px 2px 1px;">
						<img style="height:25px" src="imagens/sigla.gif" border="0" alt="SIGLA" />
					</td>
				</tr>
			</table>
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
								<td style="font-size:6pt; border:none; padding:5px 10px 0 10px; white-space:nowrap;">ADT&nbsp;-&nbsp;<%=pesoAdulto %>kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 0 10px; white-space:nowrap;">CHD&nbsp;-&nbsp;<%=pesoCrianca %>kg</td>
							</tr>
							<tr>
								<td style="font-size:6pt; border:none; padding:0 10px 5px 10px; white-space:nowrap;">INF&nbsp;-&nbsp;<%=pesoInfo %>kg</td>
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
		</td>
	</tr>
</table>
</center>

</body>

</html>
