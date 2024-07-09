<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	' Habilita ou desabilita o bloqueio da entrada de dados de decolagem da aeronave
	' quando os dados do pouso dessa aeronave ainda não tiverem sido fornecidos.
	Dim habilitaBloqueioEntradaDadosDecolagem
	If (IsVazio(Session("HABILITA_BLOQUEIO_ENTRADA_DADOS_DECOLAGEM"))) Then
		habilitaBloqueioEntradaDadosDecolagem = True
	ElseIf ((Session("HABILITA_BLOQUEIO_ENTRADA_DADOS_DECOLAGEM") <> False) And (UCase(Session("HABILITA_BLOQUEIO_ENTRADA_DADOS_DECOLAGEM")) <> "FALSE")) Then
		habilitaBloqueioEntradaDadosDecolagem = True
	Else
		habilitaBloqueioEntradaDadosDecolagem = False
	End If

	Dim objConn
	Dim objRs, strSqlSelect, strSqlFrom, strSqlWhere, strSqlOrder, strQuery
	Dim objRsAeroporto, strSqlSelectAeroporto, strSqlFromAeroporto, strSqlWhereAeroporto, strQueryAeroporto
	Dim strNomeAeroporto, strCodAeroporto
	Dim intSeqUsuarioAerop, intSeqAeroporto
	Dim intAno1, intMes1, intDia1, strHora1, strData1, strDataA
	Dim intAno2, intMes2, intDia2, strHora2, strData2, strDataB

	intSeqUsuarioAerop = Session("member")
	intSeqAeroporto = Session("seqaeroporto")



	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' ******************
	' *** PARÂMTEROS ***
	' ******************
	Dim strQueryParametros
	strQueryParametros =                      " SELECT PARAM.horariovooini, "
	strQueryParametros = strQueryParametros & "        PARAM.horariovoofim "
	strQueryParametros = strQueryParametros & "  FROM sig_parametros PARAM "

	Dim objRsParametros
	Set objRsParametros = Server.CreateObject("ADODB.Recordset")
	objRsParametros.Open strQueryParametros, objConn

	Dim intHorarioVooIni, intHorarioVooFim
	if (Not objRsParametros.EOF) then
		intHorarioVooIni = objRsParametros("horariovooini")
		if (IsVazio(intHorarioVooIni)) then
			intHorarioVooIni = CInt(18)
		else
			intHorarioVooIni = CInt(intHorarioVooIni)
		end if
		intHorarioVooFim = objRsParametros("horariovoofim")
		if (IsVazio(intHorarioVooFim)) then
			intHorarioVooFim = CInt(12)
		else
			intHorarioVooFim = CInt(intHorarioVooFim)
		end if
	else
		intHorarioVooIni = CInt(18)
		intHorarioVooFim = CInt(12)
	end if

'para aumentar periodo de teste
'intHorarioVooIni = cint(240)

	objRsParametros.Close()
	Set objRsParametros = Nothing



	intAno1 = Year(DateAdd("h", -intHorarioVooIni, Now()))
	intMes1 = Month(DateAdd("h", -intHorarioVooIni, Now()))
	intDia1 = Day(DateAdd("h", -intHorarioVooIni, Now()))
	strHora1 = FormatDateTime(DateAdd("h", -intHorarioVooIni, Now()), 4)
	strData1 = intAno1 & "-" & intMes1 & "-" & intDia1 & " " & strHora1
	strDataA = intAno1 & "-" & intMes1 & "-" & intDia1

	intAno2 = Year(DateAdd("h", +intHorarioVooFim, Now()))
	intMes2 = Month(DateAdd("h", +intHorarioVooFim, Now()))
	intDia2 = Day(DateAdd("h", +intHorarioVooFim, Now()))
	strHora2 = FormatDateTime(DateAdd("h", +intHorarioVooFim, Now()), 4)
	strData2 = intAno2 & "-" & intMes2 & "-" & intDia2 & " " & strHora2
	strDataB = intAno2 & "-" & intMes2 & "-" & intDia2



	' ********************
	' *** FUSO BSB-GMT ***
	' ********************
	Dim objRsFuso, strQueryFuso
	Dim intFusoGMT
	strQueryFuso =                "SELECT sig_fusovalor.fuso "
	strQueryFuso = strQueryFuso & "  FROM sig_fusovalor, "
	strQueryFuso = strQueryFuso & "       sig_parametros "
	strQueryFuso = strQueryFuso & " WHERE sig_fusovalor.codfuso = sig_parametros.codfusoref "
	strQueryFuso = strQueryFuso & "   AND sig_fusovalor.dtinicio <= GetDate() "
	strQueryFuso = strQueryFuso & "   AND (sig_fusovalor.dtfim >= GetDate() OR sig_fusovalor.dtfim IS NULL) "
	Set objRsFuso = Server.CreateObject("ADODB.Recordset")
	objRsFuso.Open strQueryFuso, objConn
	if (Not objRsFuso.EOF) then
		intFusoGMT = CInt(objRsFuso("fuso"))
	else
		intFusoGMT = CInt(0)
	end if
	objRsFuso.Close()
	Set objRsFuso = Nothing

	' **************************
	' *** DADOS DO AEROPORTO ***
	' **************************
	strSqlSelectAeroporto = " SELECT seqaeroporto, codiata, nomeaeroporto "
	strSqlFromAeroporto = "   FROM sig_aeroporto "
	strSqlWhereAeroporto = "  WHERE seqaeroporto = " & intSeqAeroporto
	strQueryAeroporto = strSqlSelectAeroporto & strSqlFromAeroporto & strSqlWhereAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeroporto = objRsAeroporto("nomeaeroporto")
	strCodAeroporto = objRsAeroporto("codiata")
	objRsAeroporto.Close()
	Set objRsAeroporto = Nothing


	strSqlSelect = "                SELECT DV.nrvoo NUMERO_VOO, "
	strSqlSelect = strSqlSelect & "        DV.dtoper DATA_OPERACAO, "
	strSqlSelect = strSqlSelect & "        DV.codnatlinha COD_NAT_LINHA, "
	strSqlSelect = strSqlSelect & "        DT.seqvoodia SEQ_VOO_DIA, "
	strSqlSelect = strSqlSelect & "        DT.seqtrecho SEQ_TRECHO, "
	strSqlSelect = strSqlSelect & "        DT.prefixoaeronave PREFIXO_AERONAVE, "
	' strSqlSelect = strSqlSelect & "        DT.checkinfinaliz CHECKIN_FINALIZ, "
	strSqlSelect = strSqlSelect & "        aeroporig.codiata CODIGO_IATA_ORIGEM, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata CODIGO_IATA_DESTINO, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) PARTIDA_PREVISTA, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.chegadaprev) CHEGADA_PREVISTA, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.partidamotor) PARTIDA_MOTOR, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.cortemotor) CORTE_MOTOR, "
	strSqlSelect = strSqlSelect & "        SA.tipotransporte TIPO_TRANSPORTE, "
	strSqlSelect = strSqlSelect & "        USUAEROP.flgcombinada FLG_COMBINADA "
	strSqlFrom = "                  FROM sig_diariovoo DV, "
	strSqlFrom = strSqlFrom & "          sig_diariotrecho DT "
	strSqlFrom = strSqlFrom & "          LEFT OUTER JOIN sig_aeronave SA ON SA.prefixored = DT.prefixoaeronave, "
	strSqlFrom = strSqlFrom & "          sig_aeroporto aeroporig, "
	strSqlFrom = strSqlFrom & "          sig_aeroporto aeropdest, "
	strSqlFrom = strSqlFrom & "          sig_usuarioaerop USUAEROP "
	strSqlWhere = "                 WHERE DV.seqvoodia = DT.seqvoodia "
	strSqlWhere = strSqlWhere & "     AND DT.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere & "     AND DT.seqaeropdest = aeropdest.seqaeroporto "
	strSqlWhere = strSqlWhere & "     AND DV.statusvoo = 'N' "
	strSqlWhere = strSqlWhere & "     AND DT.flgcancelado = 'N' "
	strSqlWhere = strSqlWhere & "     AND DT.prefixoaeronave IS NOT NULL "
	strSqlWhere = strSqlWhere & "     AND DV.dtoper between '" & strDataA & "' AND '" & strDataB & "' "
	strSqlWhere = strSqlWhere & "     AND DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) BETWEEN '" & strData1 & "' AND '" & strData2 & "' "
	strSqlWhere = strSqlWhere & "     AND ((DT.seqaeroporig = USUAEROP.seqaeroporto and (DT.flgcapturadec <> 'N' or DT.flgcapturadec is null)) OR (DT.seqaeropdest = USUAEROP.seqaeroporto and (DT.flgcapturapou <> 'N' or DT.flgcapturapou is null))) "
	strSqlWhere = strSqlWhere & "     AND USUAEROP.sequsuarioaerop = " & intSeqUsuarioAerop & " "
	strSqlOrder = "                 ORDER BY DT.partidaprev "

	strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	Dim blnMostraLinkCarregamento, intEmpresa
	intEmpresa = Session("Empresa")
	blnMostraLinkCarregamento = false
	if (intEmpresa <> 1) then
		if (Not objRs.Eof) then
			blnMostraLinkCarregamento = (objRs("FLG_COMBINADA") <> "N")
		end if
	end if

	Dim blnMostraLinkImportacaoDadosVoo
	blnMostraLinkImportacaoDadosVoo = false
	If ((blnMostraLinkCarregamento) And ((intEmpresa = 4) Or (intEmpresa = 2) Or (intEmpresa = 10))) Then 'TRIP = 4; Webjet = 2; LATOP = 10
		blnMostraLinkImportacaoDadosVoo = true
	End If

%>

<html>
	<head>
		<title>Aeroportos</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
      <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	</head>
	<body>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center">
					<font size="4"><b><% Response.Write(strNomeAeroporto & " (" & strCodAeroporto & ")")%></b></font>
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
         <tr>
            <td>&nbsp;</td>
         </tr>   
		</table>
		<br />
		<table width='95%' border='1' cellpadding='0' align="center" cellspacing='0' ID='Table2'>
			<tr bgcolor='#AAAAAA'>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">&nbsp;</th>
                <% If (blnMostraLinkCarregamento) Then %>
				    <th class='CORPO9' style="padding-left:3px; padding-right:3px;">&nbsp;</th>
				    <th class='CORPO9' style="padding-left:3px; padding-right:3px;">&nbsp;</th>
	                <% If (blnMostraLinkImportacaoDadosVoo) Then %>
				        <th class='CORPO9' style="padding-left:3px; padding-right:3px;">&nbsp;</th>
	                <% End If
                End If %>
				<th class='CORPO9' style="padding-left:5px; padding-right:5px;">Voo</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Data</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Aeronave</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Origem</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Destino</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Part.&nbsp;Prev.</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Cheg.&nbsp;Prev.</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Partida&nbsp;Motor</th>
				<th class='CORPO9' style="padding-left:3px; padding-right:3px;">Corte&nbsp;Motor</th>
			</tr>

<%
	Dim intCont
	intCont = CInt(0)

	Dim vetAeronaveDestinoCorteMotorVoo()

	Do While Not objRs.Eof
		Dim intSeqVooDia, intSeqTrecho
		intSeqVooDia = objRs("SEQ_VOO_DIA")
		intSeqTrecho = objRs("SEQ_TRECHO")

		'Dim ls_CheckInFinaliz
		'ls_CheckInFinaliz = objRs("CHECKIN_FINALIZ")
		'If (IsVazio(ls_CheckInFinaliz)) Then ls_CheckInFinaliz = "N"

		Dim ls_NumeroVoo
		ls_NumeroVoo = objRs("NUMERO_VOO")
		If (IsVazio(ls_NumeroVoo)) Then ls_NumeroVoo = "&nbsp;"

		Dim ls_PrefixoAeronave
		ls_PrefixoAeronave = objRs("PREFIXO_AERONAVE")
		If (IsVazio(ls_PrefixoAeronave)) Then ls_PrefixoAeronave = "&nbsp;"

		Dim ls_Codigo_IATA_Origem
		ls_Codigo_IATA_Origem = objRs("CODIGO_IATA_ORIGEM")
		If (IsVazio(ls_Codigo_IATA_Origem)) Then ls_Codigo_IATA_Origem = "&nbsp;"

		Dim ls_Codigo_IATA_Destino
		ls_Codigo_IATA_Destino = objRs("CODIGO_IATA_DESTINO")
		If (IsVazio(ls_Codigo_IATA_Destino)) Then ls_Codigo_IATA_Destino = "&nbsp;"

		Dim ldt_DataOperacao, ls_DataOperacao
		ldt_DataOperacao = objRs("DATA_OPERACAO")
		If (Not IsVazio(ldt_DataOperacao)) Then
			ls_DataOperacao = Right("00"&Day(ldt_DataOperacao),2) & "/" & Right("00"&Month(ldt_DataOperacao),2) & "/" & Year(ldt_DataOperacao)
		Else
			ls_DataOperacao = "&nbsp;"
		End If

		Dim ldt_PartidaPrevista, ls_PartidaPrevista
		ldt_PartidaPrevista = objRs("PARTIDA_PREVISTA")
		If (Not IsVazio(ldt_PartidaPrevista)) Then
			ls_PartidaPrevista = Right("00"&Day(ldt_PartidaPrevista),2) & "/" & Right("00"&Month(ldt_PartidaPrevista),2) & "/" & Year(ldt_PartidaPrevista)
			ls_PartidaPrevista = ls_PartidaPrevista & " " & FormatDateTime( ldt_PartidaPrevista, 4 )
		Else
			ls_PartidaPrevista = "&nbsp;"
		End If

		Dim ldt_ChegadaPrevista, ls_ChegadaPrevista
		ldt_ChegadaPrevista = objRs("CHEGADA_PREVISTA")
		If (Not IsVazio(ldt_ChegadaPrevista)) Then
			ls_ChegadaPrevista = Right("00"&Day(ldt_ChegadaPrevista),2) & "/" & Right("00"&Month(ldt_ChegadaPrevista),2) & "/" & Year(ldt_ChegadaPrevista)
			ls_ChegadaPrevista = ls_ChegadaPrevista & " " & FormatDateTime( ldt_ChegadaPrevista, 4 )
		Else
			ls_ChegadaPrevista = "&nbsp;"
		End If

		Dim ldt_PartidaMotor, ls_PartidaMotor
		ldt_PartidaMotor = objRs("PARTIDA_MOTOR")
		If (Not IsVazio(ldt_PartidaMotor)) Then
			ls_PartidaMotor = Right("00"&Day(ldt_PartidaMotor),2) & "/" & Right("00"&Month(ldt_PartidaMotor),2) & "/" & Year(ldt_PartidaMotor)
			ls_PartidaMotor = ls_PartidaMotor & " " & FormatDateTime( ldt_PartidaMotor, 4 )
		Else
			ls_PartidaMotor = "&nbsp;"
		End If

		Dim ldt_CorteMotor, ls_CorteMotor
		ldt_CorteMotor = objRs("CORTE_MOTOR")
		If (Not IsVazio(ldt_CorteMotor)) Then
			ls_CorteMotor = Right("00"&Day(ldt_CorteMotor),2) & "/" & Right("00"&Month(ldt_CorteMotor),2) & "/" & Year(ldt_CorteMotor)
			ls_CorteMotor = ls_CorteMotor & " " & FormatDateTime( ldt_CorteMotor, 4 )
		Else
			ls_CorteMotor = "&nbsp;"
		End If

		Dim ls_TipoTransporte
		ls_TipoTransporte = objRs("TIPO_TRANSPORTE")

		Dim ls_CodNatLinha
		ls_CodNatLinha = objRs("COD_NAT_LINHA")

        Dim ls_pax
        If (ls_TipoTransporte = "PAX") Then
            ls_pax = "S"
        ElseIf (ls_TipoTransporte = "CGA") Then
                ls_pax = "N"
        ElseIf (ls_TipoTransporte = "MIS") Then
            If (ls_CodNatLinha = "C" OR ls_CodNatLinha = "G" OR ls_CodNatLinha = "L") Then
                ls_pax = "N"
            Else
                ls_pax = "S"
            End If
        End If

		Dim bloqueiaEntradaDadosDecolagem
		bloqueiaEntradaDadosDecolagem = CBool(False)

		Dim prefixoAeronave, numeroVoo
		If (strCodAeroporto = ls_Codigo_IATA_Origem And habilitaBloqueioEntradaDadosDecolagem) Then
			Dim i
			i = CInt(0)
			For i = (intCont - 1) to 0 Step -1
				prefixoAeronave = vetAeronaveDestinoCorteMotorVoo(0, i)
				If (prefixoAeronave = ls_PrefixoAeronave) Then
					Dim destino, corteMotor
					destino = vetAeronaveDestinoCorteMotorVoo(1, i)
					corteMotor = vetAeronaveDestinoCorteMotorVoo(2, i)
					numeroVoo = vetAeronaveDestinoCorteMotorVoo(3, i)
					bloqueiaEntradaDadosDecolagem = CBool(destino = strCodAeroporto And IsVazio(corteMotor))
					Exit For
				End If
			Next
		End If

		Response.Write("<tr bgcolor='" & ObterCorFundoLinha(intCont) & "'>" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center' style='padding: 2px 0px 2px 0px;'>")
		If (bloqueiaEntradaDadosDecolagem) Then
			Dim strMensagemBloqueio
			strMensagemBloqueio = "Favor informar os dados do pouso da aeronave " & prefixoAeronave & " no voo " & numeroVoo & "!"
			Response.Write("<a href=""javascript:alert('" & strMensagemBloqueio & "');""><img alt='Hor&aacute;rio' title='Hor&aacute;rio' src='imagens/cancel.png' style='border-color:#000000; border-width:0;' />")
		Else
			'If (IsVazio(ls_TipoTransporte) Or (UCase(ls_TipoTransporte) <> "CGA")) Then
            If (ls_pax = "S") Then
				Response.Write("<a href='entradadosaeroporto.asp?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Hor&aacute;rio' title='Hor&aacute;rio' src='imagens/clock.png' style='border-color:#000000; border-width:0;' />")
			Else
				Response.Write("<a href='entradadosaeroportocarga.asp?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Hor&aacute;rio' title='Hor&aacute;rio' src='imagens/clock.png' style='border-color:#000000; border-width:0;' />")
			End If
		End If
		Response.Write("</a></td>" & vbCrLf)
		If (blnMostraLinkCarregamento) Then
			Response.Write("	<td class='CORPO9' nowrap align='center' style='padding: 2px 0px 2px 0px;'>")
			If (strCodAeroporto = ls_Codigo_IATA_Origem) Then
				'If (IsVazio(ls_TipoTransporte) Or (UCase(ls_TipoTransporte) <> "CGA")) Then
                If (ls_pax = "S") Then
					Response.Write("<span onclick=""return RedirecionaPagina(this, 'Aeroporto');""><a href='CombinadaAeropSec.aspx?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Carregamento' title='Carregamento' src='imagens/group.png' style='border-color:#000000; border-width:0;' /></a></span>")
				Else
					Response.Write("<a href='combinadaaeroportocarga.asp?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Carregamento' src='imagens/box.png' style='border-color:#000000; border-width:0;' /></a>")
				End If
    		Else
				Response.Write("&nbsp;")
			End If
			Response.Write("</td>" & vbCrLf)
		End If
		If (blnMostraLinkCarregamento) Then
			Response.Write("	<td class='CORPO9' nowrap align='center' style='padding: 2px 0px 2px 0px;'>")
			If (strCodAeroporto = ls_Codigo_IATA_Origem) Then
				'If (IsVazio(ls_TipoTransporte) Or (UCase(ls_TipoTransporte) <> "CGA")) Then
                If (ls_pax = "S") Then
					Response.Write("<span onclick=""return RedirecionaPagina(this, 'Aeroporto');""><a href='DadosAeropDecolSec.aspx?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Balanceamento' title='Balanceamento' src='imagens/balance.png' style='border-color:#000000; border-width:0;' /></a></span>")
				Else
					Response.Write("&nbsp;")
				End If
			Else
				Response.Write("&nbsp;")
			End If
			Response.Write("</td>" & vbCrLf)
		End If
		If (blnMostraLinkImportacaoDadosVoo) Then
			Response.Write("	<td class='CORPO9' nowrap align='center' style='padding: 2px 0px 2px 0px;'>")
			'If ((strCodAeroporto = ls_Codigo_IATA_Origem) And (IsVazio(ls_TipoTransporte) Or (UCase(ls_TipoTransporte) <> "CGA"))) Then
            If ((strCodAeroporto = ls_Codigo_IATA_Origem) And (ls_pax = "S")) Then
					Response.Write("<span onclick=""return RedirecionaPagina(this, 'Aeroporto');""><a href='ImportarDadosVoo.aspx?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'><img alt='Importar Dados do Voo' title='Importar Dados do Voo' src='imagens/document-import.png' style='border-color:#000000; border-width:0;' /></a></span>")
			Else
				Response.Write("&nbsp;")
			End If
			Response.Write("</td>" & vbCrLf)
		End If

		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:5px; padding-right:5px;'>" & vbCrLf)
		Response.Write("		" & ls_NumeroVoo & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_DataOperacao & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_PrefixoAeronave & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		if (strCodAeroporto = ls_Codigo_IATA_Origem) then
			Response.Write("		<font style='font-weight: bold;'>" & ls_Codigo_IATA_Origem & "</font>" & vbCrLf)
		else
			Response.Write("		" & ls_Codigo_IATA_Origem & vbCrLf)
		end if
		Response.Write("	</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		if (strCodAeroporto = ls_Codigo_IATA_Destino) then
			Response.Write("		<font style='font-weight: bold;'>" & ls_Codigo_IATA_Destino & "</font>" & vbCrLf)
		else
			Response.Write("		" & ls_Codigo_IATA_Destino & vbCrLf)
		end if
		Response.Write("	</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_PartidaPrevista & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_ChegadaPrevista & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_PartidaMotor & "</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' style='padding-left:3px; padding-right:3px;'>" & vbCrLf)
		Response.Write("		" & ls_CorteMotor & "</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		ReDim Preserve vetAeronaveDestinoCorteMotorVoo(3, intCont)
		vetAeronaveDestinoCorteMotorVoo(0, intCont) = ls_PrefixoAeronave
		vetAeronaveDestinoCorteMotorVoo(1, intCont) = ls_Codigo_IATA_Destino
		vetAeronaveDestinoCorteMotorVoo(2, intCont) = ldt_CorteMotor
		vetAeronaveDestinoCorteMotorVoo(3, intCont) = ls_NumeroVoo

		intCont = intCont + 1
		objRs.MoveNext()
	loop

	objRs.Close()
	objConn.Close()
	Set objRs = Nothing
	Set objConn = Nothing

%>
			<tr>
				<th colspan="11"></th>
			</tr>
		</table>
	</body>
</html>


<%

Function ObterCorFundoLinha(intNumLinha)

	Dim Cor1, Cor2, Cor
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	If ((intNumLinha MOD 2) = 0) Then
		Cor = Cor1
	Else
		Cor = Cor2
	End If

	ObterCorFundoLinha = Cor

End Function

Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if
end Function

%>
