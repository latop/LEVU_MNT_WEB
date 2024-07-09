<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->
<!--#include file="auditoria.asp"-->

<%
	Dim objConn
	Dim objRs, strSqlSelect, strSqlFrom, strSqlWhere, strQuery
	Dim intSeqUsuarioAerop, intSeqVooDia, intSeqTrecho
	intSeqUsuarioAerop = Session("member")
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' ********************
	' *** FUSO BSB-GMT ***
	' ********************
	Dim objRsFuso, strQueryFuso
	Dim intFusoGMT
	strQueryFuso =                "SELECT sig_fusovalor.fuso "
	strQueryFuso = strQueryFuso & "  FROM sig_fusovalor, "
	strQueryFuso = strQueryFuso & "       sig_parametros, "
	strQueryFuso = strQueryFuso & "       sig_diariovoo "
	strQueryFuso = strQueryFuso & " WHERE sig_fusovalor.codfuso = sig_parametros.codfusoref "
	strQueryFuso = strQueryFuso & "   AND sig_fusovalor.dtinicio <= sig_diariovoo.dtoper "
	strQueryFuso = strQueryFuso & "   AND (sig_fusovalor.dtfim >= sig_diariovoo.dtoper OR sig_fusovalor.dtfim IS NULL) "
	strQueryFuso = strQueryFuso & "   AND sig_diariovoo.seqvoodia=" & intSeqVooDia
	Set objRsFuso = Server.CreateObject("ADODB.Recordset")
	objRsFuso.Open strQueryFuso, objConn
	if (Not objRsFuso.EOF) then
		intFusoGMT = CInt(objRsFuso("fuso"))
	else
		intFusoGMT = CInt(0)
	end if
	objRsFuso.Close()
	Set objRsFuso = Nothing

	Dim strGravar, strVoltar, strServAerop
	strGravar = Request.Form("btnGravar")
	strVoltar = Request.Form("btnVoltar")
	strServAerop = Request.Form("btnServAerop")
	
	if (strVoltar <> "") then
		Response.Redirect("listagemhorariovoos.asp")
	elseif (strServAerop <> "") then
		Response.Redirect("servicoaerop.asp?seqvoodia=" + intSeqVooDia + "&seqtrecho=" + intSeqTrecho)
	elseif (strGravar <> "") then
		GravarDadosAeroportoPouso()
	end if

	strSqlSelect =                " SELECT sig_diariovoo.nrvoo, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.dtoper, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqtrecho, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.prefixoaeronave, "
	strSqlSelect = strSqlSelect & "        aeroporig.codiata Origem, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata Destino, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.partidaprev) partidaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.chegadaprev) chegadaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.partidaest) partidaest, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.chegadaest) chegadaest, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.partidamotor) partidamotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.decolagem) decolagem, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.pouso) pouso, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.cortemotor) cortemotor, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxeconomica, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxgratis, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxpago, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxpad, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxdhc, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.baglivre, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.bagexcesso, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.cargapaga, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.cargagratis, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.correioao, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.correiolc, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustificativatraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustifinternatraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.observacaotraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.combcortemotor, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzdec, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzpou, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzdecint, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzpouint "
	strSqlFrom =                  " FROM sig_diariovoo sig_diariovoo, "
	strSqlFrom = strSqlFrom &     "      sig_diariotrecho sig_diariotrecho, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeroporig, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeropdest "
	strSqlWhere =                 " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqvoodia = " & intSeqVooDia & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqtrecho = " & intSeqTrecho & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto "

	strQuery = strSqlSelect & strSqlFrom & strSqlWhere

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	' **************************
	' *** DADOS DO AEROPORTO ***
	' **************************
	Dim objRsAeroporto, strSqlSelectAeroporto, strSqlFromAeroporto, strSqlWhereAeroporto, strQueryAeroporto
	Dim strNomeAeroporto, strCodAeroporto, intSeqAeroporto
	intSeqAeroporto = Session("seqaeroporto")
	strSqlSelectAeroporto = " SELECT seqaeroporto, codiata, nomeaeroporto "
	strSqlFromAeroporto = "   FROM sig_aeroporto "
	strSqlWhereAeroporto = "  WHERE seqaeroporto = " & intSeqAeroporto
	strQueryAeroporto = strSqlSelectAeroporto & strSqlFromAeroporto & strSqlWhereAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeroporto = objRsAeroporto("nomeaeroporto")
	strCodAeroporto = objRsAeroporto("codiata")

	' *********************
	' *** JUSTIFICATIVA ***
	' *********************
	Dim objRsJustificativa, strSqlSelectJustificativa, strSqlFromJustificativa, strSqlWhereJustificativa, strSqlOrderJustificativa, strQueryJustificativa
	strSqlSelectJustificativa = " SELECT SJI.idjustifinterna, SJI.codarearesp, SJI.idjustificativa, SJI.descrjustifinterna, "
	strSqlSelectJustificativa = strSqlSelectJustificativa & " SJI.idjustifinterna + ' - ' + SJI.descrjustifinterna AS Id_Desc "
	strSqlFromJustificativa = "   FROM sig_justifinterna SJI, sig_justificativa SJ "
	strSqlWhereJustificativa = " WHERE SJI.flgbloqueado = 'N' "
	strSqlWhereJustificativa = strSqlWhereJustificativa & " AND SJ.tipojustificativa <> 'B' "
	strSqlWhereJustificativa = strSqlWhereJustificativa & " AND SJ.idjustificativa = SJI.idjustificativa "
	strSqlOrderJustificativa = "      ORDER BY SJI.idjustifinterna "
	strQueryJustificativa = strSqlSelectJustificativa & strSqlFromJustificativa & strSqlWhereJustificativa & strSqlOrderJustificativa
	Set objRsJustificativa = Server.CreateObject("ADODB.Recordset")
	objRsJustificativa.Open strQueryJustificativa, objConn

	' ***********************************
	' *** CHEGADA PREVISTA / ESTIMADA ***
	' ***********************************
	Dim dtData, strDataHora, strDataHoraEst, dtChegadaPrevista
	dtChegadaPrevista = ObjRs("chegadaprev")
	strDataHora = Right("00" & Day(dtChegadaPrevista), 2) & "/" & Right("00" & Month(dtChegadaPrevista), 2) & "/" & Year(dtChegadaPrevista)
	strDataHora = strDataHora & " " & FormatDateTime(dtChegadaPrevista, 4)

	dtData = ObjRs("chegadaest")
	if(Not IsNull(dtData)) then
		strDataHoraEst = Right("00" & Day(dtData), 2) & "/" & Right("00" & Month(dtData), 2) & "/" & Year(dtData)
		strDataHoraEst = strDataHoraEst & " " & FormatDateTime(dtData, 4)
	else
		strDataHoraEst = ""
	end if

	' *********************
	' *** PARTIDA MOTOR ***
	' *********************
	Dim strDataHoraPartidaMotor
	Dim dtPartidaMotor
	dtPartidaMotor = ObjRs("partidamotor")
	if (IsNull(dtPartidaMotor) or IsEmpty(dtPartidaMotor)) then
		strDataHoraPartidaMotor = ""
	else
		strDataHoraPartidaMotor = Right("00" & Day(dtPartidaMotor), 2) & "/" & Right("00" & Month(dtPartidaMotor), 2) & "/" & Year(dtPartidaMotor)
		strDataHoraPartidaMotor = strDataHoraPartidaMotor & " " & FormatDateTime(dtPartidaMotor, 4)
	end if

	' *****************
	' *** DECOLAGEM ***
	' *****************
	Dim strDataHoraDecolagem
	Dim dtDecolagem
	dtDecolagem = ObjRs("decolagem")
	if (IsNull(dtDecolagem) or IsEmpty(dtDecolagem)) then
		strDataHoraDecolagem = ""
	else
		strDataHoraDecolagem = Right("00" & Day(dtDecolagem), 2) & "/" & Right("00" & Month(dtDecolagem), 2) & "/" & Year(dtDecolagem)
		strDataHoraDecolagem = strDataHoraDecolagem & " " & FormatDateTime(dtDecolagem, 4)
	end if

	' *************
	' *** POUSO ***
	' *************
	Dim strAnoPouso, strMesPouso, strDiaPouso, strHoraPouso, strMinutoPouso
	Dim dtPouso
	dtPouso = ObjRs("pouso")
	if (IsNull(dtPouso) or IsEmpty(dtPouso)) then
		strAnoPouso = Year(dtChegadaPrevista)
		strMesPouso = Right("00" & Month(dtChegadaPrevista), 2)
		strDiaPouso = Right("00" & Day(dtChegadaPrevista), 2)
		strHoraPouso = ""
		strMinutoPouso = ""
	else
		strAnoPouso = Year(dtPouso)
		strMesPouso = Right("00" & Month(dtPouso), 2)
		strDiaPouso = Right("00" & Day(dtPouso), 2)
		strHoraPouso = Right("00" & Hour(dtPouso), 2)
		strMinutoPouso = Right("00" & Minute(dtPouso), 2)
	end if

	' *******************
	' *** CORTE MOTOR ***
	' *******************
	Dim strAnoCorteMotor, strMesCorteMotor, strDiaCorteMotor, strHoraCorteMotor, strMinutoCorteMotor
	Dim dtCorteMotor
	dtCorteMotor = ObjRs("cortemotor")
	if (IsNull(dtCorteMotor) or IsEmpty(dtCorteMotor)) then
		strAnoCorteMotor = Year(dtChegadaPrevista)
		strMesCorteMotor = Right("00" & Month(dtChegadaPrevista), 2)
		strDiaCorteMotor = Right("00" & Day(dtChegadaPrevista), 2)
		strHoraCorteMotor = ""
		strMinutoCorteMotor = ""
	else
		strAnoCorteMotor = Year(dtCorteMotor)
		strMesCorteMotor = Right("00" & Month(dtCorteMotor), 2)
		strDiaCorteMotor = Right("00" & Day(dtCorteMotor), 2)
		strHoraCorteMotor = Right("00" & Hour(dtCorteMotor), 2)
		strMinutoCorteMotor = Right("00" & Minute(dtCorteMotor), 2)
	end if

%>

<html>
	<head>
		<title>SIGLA - Aeroportos</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
      <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<script src="javascript.js"></script>
		<script type="text/javascript" language="javascript">
			function CarregaPagina() {
				document.getElementById('txtHoraPouso').focus();
				document.getElementById('hidCorrigirDecolagem').value = !(document.getElementById('divPartidaMotorLabel').style.display == 'block');
			}

			function VerificaCampos() {
				if (document.getElementById('divPartidaMotorText').style.display == 'block') {
					if (document.getElementById('txtDiaPartidaMotor').value == '') {
						alert('Preencha o campo dia da partida motor, por favor!');
						document.getElementById('txtDiaPartidaMotor').focus();
						return false;
					}
					else if (document.getElementById('txtMesPartidaMotor').value == '') {
						alert('Preencha o campo mês da partida motor, por favor!');
						document.getElementById('txtMesPartidaMotor').focus();
						return false;
					}
					else if (document.getElementById('txtAnoPartidaMotor').value == '') {
						alert('Preencha o campo ano da partida motor, por favor!');
						document.getElementById('txtAnoPartidaMotor').focus();
						return false;
					}
					else if (document.getElementById('txtHoraPartidaMotor').value == '') {
						alert('Preencha o campo hora da partida motor, por favor!');
						document.getElementById('txtHoraPartidaMotor').focus();
						return false;
					}
					else if (document.getElementById('txtMinutoPartidaMotor').value == '') {
						alert('Preencha o campo minuto da partida motor, por favor!');
						document.getElementById('txtMinutoPartidaMotor').focus();
						return false;
					}
					else if (document.getElementById('txtDiaDecolagem').value == '') {
						alert('Preencha o campo dia da decolagem, por favor!');
						document.getElementById('txtDiaDecolagem').focus();
						return false;
					}
					else if (document.getElementById('txtMesDecolagem').value == '') {
						alert('Preencha o campo mês da decolagem, por favor!');
						document.getElementById('txtMesDecolagem').focus();
						return false;
					}
					else if (document.getElementById('txtAnoDecolagem').value == '') {
						alert('Preencha o campo ano da decolagem, por favor!');
						document.getElementById('txtAnoDecolagem').focus();
						return false;
					}
					else if (document.getElementById('txtHoraDecolagem').value == '') {
						alert('Preencha o campo hora da decolagem, por favor!');
						document.getElementById('txtHoraDecolagem').focus();
						return false;
					}
					else if (document.getElementById('txtMinutoDecolagem').value == '') {
						alert('Preencha o campo minuto da decolagem, por favor!');
						document.getElementById('txtMinutoDecolagem').focus();
						return false;
					}
				}

				if (document.getElementById('txtDiaPouso').value == '') {
					alert('Preencha o campo dia do pouso, por favor!');
					document.getElementById('txtDiaPouso').focus();
					return false;
				}
				else if (document.getElementById('txtMesPouso').value == '') {
					alert('Preencha o campo mês do pouso, por favor!');
					document.getElementById('txtMesPouso').focus();
					return false;
				}
				else if (document.getElementById('txtAnoPouso').value == '') {
					alert('Preencha o campo ano do pouso, por favor!');
					document.getElementById('txtAnoPouso').focus();
					return false;
				}
				else if (document.getElementById('txtHoraPouso').value == '') {
					alert('Preencha o campo hora do pouso, por favor!');
					document.getElementById('txtHoraPouso').focus();
					return false;
				}
				else if (document.getElementById('txtMinutoPouso').value == '') {
					alert('Preencha o campo minuto do pouso, por favor!');
					document.getElementById('txtMinutoPouso').focus();
					return false;
				}
				else if (document.getElementById('txtDiaCorteMotor').value == '') {
					alert('Preencha o campo dia do corte motor, por favor!');
					document.getElementById('txtDiaCorteMotor').focus();
					return false;
				}
				else if (document.getElementById('txtMesCorteMotor').value == '') {
					alert('Preencha o campo mês do corte motor, por favor!');
					document.getElementById('txtMesCorteMotor').focus();
					return false;
				}
				else if (document.getElementById('txtAnoCorteMotor').value == '') {
					alert('Preencha o campo ano do corte motor, por favor!');
					document.getElementById('txtAnoCorteMotor').focus();
					return false;
				}
				else if (document.getElementById('txtHoraCorteMotor').value == '') {
					alert('Preencha o campo hora do corte motor, por favor!');
					document.getElementById('txtHoraCorteMotor').focus();
					return false;
				}
				else if (document.getElementById('txtMinutoCorteMotor').value == '') {
					alert('Preencha o campo minuto do corte motor, por favor!');
					document.getElementById('txtMinutoCorteMotor').focus();
					return false;
				}

				return true;
			}

			function CorrecaoDecolagem() {
				if (document.getElementById('divPartidaMotorLabel').style.display == 'block') {

					document.getElementById('divPartidaMotorLabel').style.display = 'none';
					document.getElementById('divDecolagemLabel').style.display = 'none';
					document.getElementById('divPartidaMotorText').style.display = 'block';
					document.getElementById('divDecolagemText').style.display = 'block';

					document.getElementById('imgBtnCorrecaoDecolagem').src='imagens/cancel.png';
					document.getElementById('imgBtnCorrecaoDecolagem').alt='Cancelar Correção de Decolagem';
					document.getElementById('imgBtnCorrecaoDecolagem').title='Cancelar Correção de Decolagem';
					document.getElementById('btnCorrecaoDecolagem').title='Cancelar Correção de Decolagem';

					LimparCamposDecolagem();
					PreencherCamposDecolagem();
					document.getElementById('txtDiaPartidaMotor').focus();

					document.getElementById('hidCorrigirDecolagem').value = 'true';
				}
				else {

					document.getElementById('divPartidaMotorLabel').style.display = 'block';
					document.getElementById('divDecolagemLabel').style.display = 'block';
					document.getElementById('divPartidaMotorText').style.display = 'none';
					document.getElementById('divDecolagemText').style.display = 'none';

					document.getElementById('imgBtnCorrecaoDecolagem').src='imagens/tick.png';
					document.getElementById('imgBtnCorrecaoDecolagem').alt='Correção de Decolagem';
					document.getElementById('imgBtnCorrecaoDecolagem').title='Correção de Decolagem';
					document.getElementById('btnCorrecaoDecolagem').title='Correção de Decolagem';

					LimparCamposDecolagem();
					document.getElementById('txtHoraPouso').focus();

					document.getElementById('hidCorrigirDecolagem').value = 'false';
				}
				return false;
			}

			function LimparCamposDecolagem() {
				document.getElementById('txtDiaPartidaMotor').value = '';
				document.getElementById('txtMesPartidaMotor').value = '';
				document.getElementById('txtAnoPartidaMotor').value = '';
				document.getElementById('txtHoraPartidaMotor').value = '';
				document.getElementById('txtMinutoPartidaMotor').value = '';
				document.getElementById('txtDiaDecolagem').value = '';
				document.getElementById('txtMesDecolagem').value = '';
				document.getElementById('txtAnoDecolagem').value = '';
				document.getElementById('txtHoraDecolagem').value = '';
				document.getElementById('txtMinutoDecolagem').value = '';
			}

			function PreencherCamposDecolagem() {
				var dataHoraPartidaMotor = new String(document.getElementById('lblDataHoraPartidaMotor').innerHTML);
				if (dataHoraPartidaMotor.length > 15) {
					document.getElementById('txtDiaPartidaMotor').value = dataHoraPartidaMotor.substr(0, 2);
					document.getElementById('txtMesPartidaMotor').value = dataHoraPartidaMotor.substr(3, 2);
					document.getElementById('txtAnoPartidaMotor').value = dataHoraPartidaMotor.substr(6, 4);
					document.getElementById('txtHoraPartidaMotor').value = dataHoraPartidaMotor.substr(11, 2);
					document.getElementById('txtMinutoPartidaMotor').value = dataHoraPartidaMotor.substr(14, 2);
				}

				var dataHoraDecolagem = new String(document.getElementById('lblDataHoraDecolagem').innerHTML);
				if (dataHoraDecolagem.length > 15) {
					document.getElementById('txtDiaDecolagem').value = dataHoraDecolagem.substr(0, 2);
					document.getElementById('txtMesDecolagem').value = dataHoraDecolagem.substr(3, 2);
					document.getElementById('txtAnoDecolagem').value = dataHoraDecolagem.substr(6, 4);
					document.getElementById('txtHoraDecolagem').value = dataHoraDecolagem.substr(11, 2);
					document.getElementById('txtMinutoDecolagem').value = dataHoraDecolagem.substr(14, 2);
				}
			}

		</script>
	</head>
	<body onload="javascript:CarregaPagina();">
		<table width="98%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0" />
				</td>
				<td class="corpo" align="center">
					<font size="5"><b>Pouso</b></font><br /><br />
					<font size="4"><b><% Response.Write(strNomeAeroporto & " (" & strCodAeroporto & ")")%></b></font>
				</td>
				<td class="corpo" align="right" valign="bottom" width="35%">
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
		<br />
		<br />
		<br />
		<form action="entradadosaeroportopouso.asp" method="post" id="form1" name="form1">
			<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0'>
				<tr>
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%;">
							<table>
								<tr>
									<td>
										<table border='0' cellpadding='0' align="left" cellspacing='0'>
											<tr style="padding-top: 5px; padding-bottom: 5px">
												<td style="padding-left: 88px; font-weight: bold" align="right">
													Voo:
												</td>
												<td style="padding-left: 5px">
													<%=ObjRs("nrvoo")%>
												</td>
												<td style="padding-left: 129px; font-weight: bold" align="right">
													Aeronave:
												</td>
												<td style="padding-left: 5px">
													<%=ObjRs("prefixoaeronave")%>
												</td>
												<td style="padding-left: 129px; font-weight: bold" align="right">
													Origem:
												</td>
												<td style="padding-left: 5px">
													<%=ObjRs("Origem")%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table style="white-space:nowrap;" border='0' cellpadding='0' align="left" cellspacing='0'>
											<tr style="padding-top: 5px; padding-bottom: 5px">
												<td style="padding-left: 20px; font-weight: bold" align="right">
													Partida Motor:
												</td>
												<td style="padding-left: 5px">
													<div id="divPartidaMotorLabel" style="display:block;">
														<label id="lblDataHoraPartidaMotor"><%=strDataHoraPartidaMotor%></label>
													</div>
<%
	Dim blnHabilitaCorrecaoDecolagem
	If (IsVazio(Session("HABILITA_CORRECAO_DECOLAGEM"))) Then
		blnHabilitaCorrecaoDecolagem = True
	ElseIf ((Session("HABILITA_CORRECAO_DECOLAGEM") <> False) And (UCase(Session("HABILITA_CORRECAO_DECOLAGEM")) <> "FALSE")) Then
		blnHabilitaCorrecaoDecolagem = True
	Else
		blnHabilitaCorrecaoDecolagem = False
	End If

	If (blnHabilitaCorrecaoDecolagem) Then
%>
													<div id="divPartidaMotorText" style="display:none;">
														<input type="text" id="txtDiaPartidaMotor" name="txtDiaPartidaMotor" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="1" />&nbsp;/
														<input type="text" id="txtMesPartidaMotor" name="txtMesPartidaMotor" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="2" />&nbsp;/
														<input type="text" id="txtAnoPartidaMotor" name="txtAnoPartidaMotor" size="3" maxlength="4" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="3" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="text" id="txtHoraPartidaMotor" name="txtHoraPartidaMotor" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="4" />&nbsp;h&nbsp;:&nbsp;
														<input type="text" id="txtMinutoPartidaMotor" name="txtMinutoPartidaMotor" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="5" />&nbsp;m
													</div>
<% End If %>
												</td>
												<td style="padding-left: 40px; font-weight: bold" align="right">
													Decolagem:
												</td>
												<td style="padding-left: 5px">
													<div id="divDecolagemLabel" style="display:block;">
														<label id="lblDataHoraDecolagem"><%=strDataHoraDecolagem%></label>
													</div>
<% If (blnHabilitaCorrecaoDecolagem) Then %>
													<div id="divDecolagemText" style="display:none;">
														<input type="text" id="txtDiaDecolagem" name="txtDiaDecolagem" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="6" />&nbsp;/
														<input type="text" id="txtMesDecolagem" name="txtMesDecolagem" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="7" />&nbsp;/
														<input type="text" id="txtAnoDecolagem" name="txtAnoDecolagem" size="3" maxlength="4" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="8" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="text" id="txtHoraDecolagem" name="txtHoraDecolagem" size="1" maxlength="2" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="9" />&nbsp;h&nbsp;:&nbsp;
														<input type="text" id="txtMinutoDecolagem" name="txtMinutoDecolagem" size="1" maxlength="2" onkeypress="return SoNumeros(window.event.keyCode, this);" tabindex="10" />&nbsp;m
													</div>
<% End If %>
												</td>
<% If (blnHabilitaCorrecaoDecolagem) Then %>
												<td style="padding-left: 10px">
													<button id="btnCorrecaoDecolagem" style="height:23px; width:30px;" title="Corre&#231;&#227;o de Decolagem" onclick="javascript:return CorrecaoDecolagem()">
														<img id="imgBtnCorrecaoDecolagem" src="imagens/tick.png" alt="Corre&#231;&#227;o de Decolagem" title="Corre&#231;&#227;o de Decolagem" />
													</button>
												</td>
<% End If %>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table border='0' cellpadding='0' align="left" cellspacing='0'>
											<tr style="padding-top: 5px; padding-bottom: 5px">
												<td style="padding-left: 37px; font-weight: bold" align="right">
													Cheg. Prev.:
												</td>
												<td style="padding-left: 5px">
													<%=strDataHora%>
												</td>
												<td style="padding-left: 46px; font-weight: bold" align="right">
													Cheg. Est.:
												</td>
												<td style="padding-left: 5px">
													<%=strDataHoraEst%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<table border='0' cellpadding='0' align="left" cellspacing='0'>
								<tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
										Pouso:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<input type="text" name="txtDiaPouso" value="<%=strDiaPouso%>" size="1" maxlength="2" id="txtDiaPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="11" />&nbsp;/
										<input type="text" name="txtMesPouso" value="<%=strMesPouso%>" size="1" maxlength="2" id="txtMesPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="12" />&nbsp;/
										<input type="text" name="txtAnoPouso" value="<%=strAnoPouso%>" size="3" maxlength="4" id="txtAnoPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="13" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraPouso" value="<%=strHoraPouso%>" size="1" maxlength="2" id="txtHoraPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="14" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoPouso" value="<%=strMinutoPouso%>" size="1" maxlength="2" id="txtMinutoPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="15" />&nbsp;m
									</td>
								</tr>
								<tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
										Corte motor:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<input type="text" name="txtDiaCorteMotor" value="<%=strDiaCorteMotor%>" size="1" maxlength="2" id="txtDiaCorteMotor" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="16" />&nbsp;/
										<input type="text" name="txtMesCorteMotor" value="<%=strMesCorteMotor%>" size="1" maxlength="2" id="txtMesCorteMotor" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="17" />&nbsp;/
										<input type="text" name="txtAnoCorteMotor" value="<%=strAnoCorteMotor%>" size="3" maxlength="4" id="txtAnoCorteMotor" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="18" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraCorteMotor" value="<%=strHoraCorteMotor%>" size="1" maxlength="2" id="txtHoraCorteMotor" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="19" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoCorteMotor" value="<%=strMinutoCorteMotor%>" size="1" maxlength="2" id="txtMinutoCorteMotor" onkeypress="return SoNumeros(window.event.keyCode, this);" tabindex="20" />&nbsp;m
									</td>
								</tr>


                                <tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
										Combustível de pouso:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<input type="text" name="txtCombustivelPouso" value="<%=ObjRs("combcortemotor")%>" size="6" maxlength="6" id="txtCombustivelPouso" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="21" />
									</td>
								</tr>

								<tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
										Justificativa:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<select id="ddlJustificativa" name="ddlJustificativa" style="width: 500px" disabled>
											<option value="0"></option>
											<%
												Do While (Not objRsJustificativa.EOF)
													if (ObjRs("idjustifinternatraf") = objRsJustificativa("idjustifinterna")) then
														Response.Write("<option selected value='" & objRsJustificativa("idjustifinterna") & "'>" & objRsJustificativa("Id_Desc") & "</option>")
													else
														Response.Write("<option value='" & objRsJustificativa("idjustifinterna") & "'>" & objRsJustificativa("Id_Desc") & "</option>")
													end if
													objRsJustificativa.MoveNext
												Loop
											%>
										</select>
									</td>
								</tr>
								<tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right" valign="top">
										Observa&#231;&#227;o:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<input type="text" name="txtObservacao" id="txtObservacao" style="width: 500px" maxlength="200" value="<%=ObjRs("observacaotraf")%>" disabled />
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td width="100%" align="center" style="padding-top: 20px">
						<input type="submit" value="Gravar" name="btnGravar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" id="btnGravar" tabindex="22" onclick="return VerificaCampos();" /> 
<%
	Dim intEmpresa
	intEmpresa = Session("Empresa")
	if (intEmpresa = 1) then
%>
						<input type="submit" value="Serv. Aerop." name="btnServAerop" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnServAerop" tabindex="23" />
<%	end if %>
						<input type="submit" value="Voltar" name="btnVoltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" id="btnVoltar" tabindex="24" />
						<input type="hidden" name="hidPartidaMotor" id="hidPartidaMotor" value="<%=strDataHoraPartidaMotor%>" />
						<input type="hidden" name="hidDecolagem" id="hidDecolagem" value="<%=strDataHoraDecolagem%>" />
						<input type="hidden" id="hidCorrigirDecolagem" name="hidCorrigirDecolagem" value="false" />
					</td>
				</tr>
			</table>
		</form>               
	</body>
</html>


<%

Sub GravarDadosAeroportoPouso()

	Dim strHidCorrigirDecolagem
	strHidCorrigirDecolagem = Request.Form("hidCorrigirDecolagem")

	Dim strMensagem
	strMensagem = ""

	Dim strTxtDiaPartidaMotor, strTxtMesPartidaMotor, strTxtAnoPartidaMotor, strTxtHoraPartidaMotor, strTxtMinutoPartidaMotor
	Dim strTxtDiaDecolagem, strTxtMesDecolagem, strTxtAnoDecolagem, strTxtHoraDecolagem, strTxtMinutoDecolagem
	Dim strTxtDataPartidaMotor, strTxtDataDecolagem
	If (strHidCorrigirDecolagem) Then
		strTxtDiaPartidaMotor = Request.Form("txtDiaPartidaMotor")
		strTxtMesPartidaMotor = Request.Form("txtMesPartidaMotor")
		strTxtAnoPartidaMotor = Request.Form("txtAnoPartidaMotor")
		strTxtHoraPartidaMotor = Request.Form("txtHoraPartidaMotor")
		strTxtMinutoPartidaMotor = Request.Form("txtMinutoPartidaMotor")

		strTxtDiaDecolagem = Request.Form("txtDiaDecolagem")
		strTxtMesDecolagem = Request.Form("txtMesDecolagem")
		strTxtAnoDecolagem = Request.Form("txtAnoDecolagem")
		strTxtHoraDecolagem = Request.Form("txtHoraDecolagem")
		strTxtMinutoDecolagem = Request.Form("txtMinutoDecolagem")

		If (IsVazio(strTxtDiaPartidaMotor)) Then
			strMensagem = "Preencha o campo dia da partida motor, por favor!"
		ElseIf (IsVazio(strTxtMesPartidaMotor)) Then
			strMensagem = "Preencha o campo mês da partida motor, por favor!"
		ElseIf (IsVazio(strTxtAnoPartidaMotor)) Then
			strMensagem = "Preencha o campo ano da partida motor, por favor!"
		ElseIf (IsVazio(strTxtHoraPartidaMotor)) Then
			strMensagem = "Preencha o campo hora da partida motor, por favor!"
		ElseIf (IsVazio(strTxtMinutoPartidaMotor)) Then
			strMensagem = "Preencha o campo minuto da partida motor, por favor!"
		ElseIf (IsVazio(strTxtDiaDecolagem)) Then
			strMensagem = "Preencha o campo dia da decolagem, por favor!"
		ElseIf (IsVazio(strTxtMesDecolagem)) Then
			strMensagem = "Preencha o campo mês da decolagem, por favor!"
		ElseIf (IsVazio(strTxtAnoDecolagem)) Then
			strMensagem = "Preencha o campo ano da decolagem, por favor!"
		ElseIf (IsVazio(strTxtHoraDecolagem)) Then
			strMensagem = "Preencha o campo hora da decolagem, por favor!"
		ElseIf (IsVazio(strTxtMinutoDecolagem)) Then
			strMensagem = "Preencha o campo minuto da decolagem, por favor!"
		Else
			strTxtDataPartidaMotor = strTxtAnoPartidaMotor & "-" & strTxtMesPartidaMotor & "-" & strTxtDiaPartidaMotor & " " & strTxtHoraPartidaMotor & ":" & strTxtMinutoPartidaMotor
			strTxtDataDecolagem = strTxtAnoDecolagem & "-" & strTxtMesDecolagem & "-" & strTxtDiaDecolagem & " " & strTxtHoraDecolagem & ":" & strTxtMinutoDecolagem
		End If
	Else
		strTxtDataPartidaMotor = request.Form("hidPartidaMotor")
		strTxtDataDecolagem = request.Form("hidDecolagem")
		If (IsVazio(strTxtDataDecolagem)) Then
			strMensagem = "A data da decolagem ainda não foi informada!"
		End If
	End If

	Dim strTxtDiaPouso, strTxtMesPouso, strTxtAnoPouso, strTxtHoraPouso, strTxtMinutoPouso
	strTxtDiaPouso = Request.Form("txtDiaPouso")
	strTxtMesPouso = Request.Form("txtMesPouso")
	strTxtAnoPouso = Request.Form("txtAnoPouso")
	strTxtHoraPouso = Request.Form("txtHoraPouso")
	strTxtMinutoPouso = Request.Form("txtMinutoPouso")

	Dim strTxtDiaCorteMotor, strTxtMesCorteMotor, strTxtAnoCorteMotor, strTxtHoraCorteMotor, strTxtMinutoCorteMotor
	strTxtDiaCorteMotor = Request.Form("txtDiaCorteMotor")
	strTxtMesCorteMotor = Request.Form("txtMesCorteMotor")
	strTxtAnoCorteMotor = Request.Form("txtAnoCorteMotor")
	strTxtHoraCorteMotor = Request.Form("txtHoraCorteMotor")
	strTxtMinutoCorteMotor = Request.Form("txtMinutoCorteMotor")
    
    Dim txtCombustivelPouso
    txtCombustivelPouso = Request.Form("txtCombustivelPouso")

	If (IsVazio(strMensagem)) Then
		If (IsVazio(strTxtDiaPouso)) Then
			strMensagem = "Preencha o campo dia do pouso, por favor!"
		ElseIf (IsVazio(strTxtMesPouso)) Then
			strMensagem = "Preencha o campo mês do pouso, por favor!"
		ElseIf (IsVazio(strTxtAnoPouso)) Then
			strMensagem = "Preencha o campo ano do pouso, por favor!"
		ElseIf (IsVazio(strTxtHoraPouso)) Then
			strMensagem = "Preencha o campo hora do pouso, por favor!"
		ElseIf (IsVazio(strTxtMinutoPouso)) Then
			strMensagem = "Preencha o campo minuto do pouso, por favor!"
		ElseIf (IsVazio(strTxtDiaCorteMotor)) Then
			strMensagem = "Preencha o campo dia do corte motor, por favor!"
		ElseIf (IsVazio(strTxtMesCorteMotor)) Then
			strMensagem = "Preencha o campo mês do corte motor, por favor!"
		ElseIf (IsVazio(strTxtAnoCorteMotor)) Then
			strMensagem = "Preencha o campo ano do corte motor, por favor!"
		ElseIf (IsVazio(strTxtHoraCorteMotor)) Then
			strMensagem = "Preencha o campo hora do corte motor, por favor!"
		ElseIf (IsVazio(strTxtMinutoCorteMotor)) Then
			strMensagem = "Preencha o campo minuto do corte motor, por favor!"
		End If
	End If

	If (Not IsVazio(strMensagem)) Then
		Response.Write("<script type='text/javascript' language='javascript'> alert(' " & strMensagem & " ');</script>")
		Exit Sub
	End If

	Dim datTxtDataPartidaMotor
	datTxtDataPartidaMotor = CDate(strTxtDataPartidaMotor)
	datTxtDataPartidaMotor = CDate(DateAdd("h", intFusoGMT, datTxtDataPartidaMotor))
	strTxtDataPartidaMotor = CStr(Year(datTxtDataPartidaMotor)) & "-" & CStr(Month(datTxtDataPartidaMotor)) & "-" & CStr(Day(datTxtDataPartidaMotor)) & " " & CStr(Hour(datTxtDataPartidaMotor)) & ":" & CStr(Minute(datTxtDataPartidaMotor))

	Dim datTxtDataDecolagem
	datTxtDataDecolagem = CDate(strTxtDataDecolagem)
	datTxtDataDecolagem = CDate(DateAdd("h", intFusoGMT, datTxtDataDecolagem))
	strTxtDataDecolagem = CStr(Year(datTxtDataDecolagem)) & "-" & CStr(Month(datTxtDataDecolagem)) & "-" & CStr(Day(datTxtDataDecolagem)) & " " & CStr(Hour(datTxtDataDecolagem)) & ":" & CStr(Minute(datTxtDataDecolagem))

	Dim strTxtDataPouso, datTxtDataPouso
	strTxtDataPouso = strTxtAnoPouso & "-" & strTxtMesPouso & "-" & strTxtDiaPouso & " " & strTxtHoraPouso & ":" & strTxtMinutoPouso
	datTxtDataPouso = CDate(strTxtDataPouso)
	datTxtDataPouso = CDate(DateAdd("h", intFusoGMT, datTxtDataPouso))
	strTxtDataPouso = CStr(Year(datTxtDataPouso)) & "-" & CStr(Month(datTxtDataPouso)) & "-" & CStr(Day(datTxtDataPouso)) & " " & CStr(Hour(datTxtDataPouso)) & ":" & CStr(Minute(datTxtDataPouso))

	Dim strTxtDataCorteMotor, datTxtDataCorteMotor
	strTxtDataCorteMotor = strTxtAnoCorteMotor & "-" & strTxtMesCorteMotor & "-" & strTxtDiaCorteMotor & " " & strTxtHoraCorteMotor & ":" & strTxtMinutoCorteMotor
	datTxtDataCorteMotor = CDate(strTxtDataCorteMotor)
	datTxtDataCorteMotor = CDate(DateAdd("h", intFusoGMT, datTxtDataCorteMotor))
	strTxtDataCorteMotor = CStr(Year(datTxtDataCorteMotor)) & "-" & CStr(Month(datTxtDataCorteMotor)) & "-" & CStr(Day(datTxtDataCorteMotor)) & " " & CStr(Hour(datTxtDataCorteMotor)) & ":" & CStr(Minute(datTxtDataCorteMotor))

	Dim strAux
	strAux = ""
	strMensagem = ""

	If (strHidCorrigirDecolagem) Then
		If (datTxtDataPartidaMotor >= datTxtDataDecolagem) Then
			strMensagem = strMensagem & strAux & "- A data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPartidaMotor)) & " ) deve ser menor do que a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataDecolagem)) & " )!"
			strAux = "\n"
		End If
	End If

	If (datTxtDataDecolagem > datTxtDataPouso) Then
		strMensagem = strMensagem & strAux & "- A data do pouso ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPouso)) & " ) deve ser maior que a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataDecolagem)) & " )!"
		strAux = "\n"
	End If

	If (datTxtDataPouso >= datTxtDataCorteMotor) Then
		strMensagem = strMensagem & strAux & "- A data do corte do motor ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataCorteMotor)) & " )  deve ser maior que a data do pouso ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPouso)) & " )!"
		strAux = "\n"
	End If

	If (strHidCorrigirDecolagem) Then
		If (Abs(DateDiff("n", datTxtDataPartidaMotor, datTxtDataDecolagem)) > 60) Then
			strMensagem = strMensagem & strAux & "- A diferença entre a data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPartidaMotor)) & " ) e a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataDecolagem)) & " ) não pode ser maior do que 1 hora!"
			strAux = "\n"
		End If
	End If

	If (Abs(DateDiff("n", datTxtDataDecolagem, datTxtDataPouso)) > 1200) Then
		strMensagem = strMensagem & strAux & "- A diferença entre a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataDecolagem)) & " ) e a data do pouso ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPouso)) & " ) não pode ser maior do que 20 horas!"
		strAux = "\n"
	End If

	If (Abs(DateDiff("n", datTxtDataPouso, datTxtDataCorteMotor)) > 60) Then
		strMensagem = strMensagem & strAux & "- A diferença entre a data do pouso ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataPouso)) & " ) e a data do corte do motor ( " & CDate(DateAdd("h", -intFusoGMT, datTxtDataCorteMotor)) & " ) não pode ser maior do que 1 hora!"
		strAux = "\n"
	End If

	If (Not IsVazio(strMensagem)) Then
		Response.Write("<script type='text/javascript' language='javascript'> alert(' " & strMensagem & " ');</script>")
		Exit Sub
	End If



	' ***********************
	' *** ABRINDO CONEXÃO ***
	' ***********************
	Dim objConexaoSqlServerUpdate
	Set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
	objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
	objConexaoSqlServerUpdate.Execute "SET DATEFORMAT ymd"

	' *****************************************
	' *** UPDATE DA TABELA SIG_DIARIOTRECHO ***
	' *****************************************
	Dim strSqlUpdate, strSqlSet, strSqlFromUpdate, strSqlWhereUpdate, strQueryUpdate
	strSqlUpdate =                          " UPDATE sig_diariotrecho "
	strSqlSet =                             " SET sig_diariotrecho.pouso = " & Plic(strTxtDataPouso) & ", "
	strSqlSet = strSqlSet &                 "     sig_diariotrecho.cortemotor = " & Plic(strTxtDataCorteMotor) & ", "
	strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzpou = DATEDIFF(mi, sig_diariotrecho.chegadaplanej, " & Plic(strTxtDataCorteMotor) & "), "
	strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzpouint = DATEDIFF(mi, sig_diariotrecho.chegadaprev, " & Plic(strTxtDataCorteMotor) & "), "
	If (strHidCorrigirDecolagem) Then
		strSqlSet = strSqlSet &                 "     sig_diariotrecho.decolagem = " & Plic(strTxtDataDecolagem) & ", "
		strSqlSet = strSqlSet &                 "     sig_diariotrecho.partidamotor = " & Plic(strTxtDataPartidaMotor) & ", "
		strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzdec = DATEDIFF(mi, sig_diariotrecho.partidaplanej, " & Plic(strTxtDataPartidaMotor) & "), "
		strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzdecint = DATEDIFF(mi, sig_diariotrecho.partidaprev, " & Plic(strTxtDataPartidaMotor) & "), "
		strSqlSet = strSqlSet &                 "     sig_diariotrecho.flgcapturadec = 'S', "
	End If
    If (Trim(txtCombustivelPouso) <> "") Then
	    strSqlSet = strSqlSet &                 "     sig_diariotrecho.combcortemotor = " & Trim(txtCombustivelPouso) & ", "
    End If
	strSqlSet = strSqlSet &                 "     sig_diariotrecho.flgcapturapou = 'S' "
	strSqlFromUpdate =                      " FROM sig_diariotrecho "
	strSqlWhereUpdate =                     " WHERE seqvoodia = " & intSeqVooDia
	strSqlWhereUpdate = strSqlWhereUpdate & "   AND seqtrecho = " & intSeqTrecho
	strQueryUpdate = strSqlUpdate & strSqlSet & strSqlFromUpdate & strSqlWhereUpdate

	objConexaoSqlServerUpdate.Execute(strQueryUpdate)

	' ************************
	' *** FECHANDO CONEXÃO ***
	' ************************
	objConexaoSqlServerUpdate.Close()
	Set objConexaoSqlServerUpdate = Nothing



	' ************************************
	' *** DADOS DA TABELA DE AUDITORIA ***
	' ************************************
	Dim strDescricao
	strDescricao = "[seqvoodia:" & intSeqVooDia & " seqtrecho:" & intSeqTrecho & "]"
	strDescricao = strDescricao & " / Pouso:" & strTxtDataPouso & " / Corte Motor:" & strTxtDataCorteMotor
	If (strHidCorrigirDecolagem) Then
		strDescricao = strDescricao & " / Partida Motor:" & strTxtDataPartidaMotor & " / Decolagem:" & strTxtDataDecolagem
	End If

	Dim intRet
	intRet = f_auditoria("SIG_DIARIOTRECHO", intSeqUsuarioAerop, "UPDATE", strDescricao, StringConexaoSqlServer)



	strMensagem = "Operação realizada com sucesso!"
	Response.Write("<script type='text/javascript' language='javascript'> alert(' " & strMensagem & " ');</script>")

End Sub



Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
