<!--#include file="verificaloginaeropfunc.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%
	Dim objConnLog
	Set objConnLog = CreateObject("ADODB.CONNECTION")
	objConnLog.Open (StringConexaoSqlServer)
	objConnLog.Execute "SET DATEFORMAT ymd"

	' Executa função para gravar na sig_usuariolog
	If f_grava_usuariolog( "I06", objConnLog ) <> "" Then
		Response.End()
	End If

	objConnLog.close
	Set objConnLog = Nothing



	Dim strTxtData, strTxtVoo, strTxtLocalidade, chkExibirSetores

	strTxtData = Request.Form("txtData")
	strTxtVoo = Request.Form("txtVoo")
	strTxtLocalidade = Request.Form("txtLocalidade")
	chkExibirSetores = Request.Form("chkExibirSetores")



Sub PreencherTabelaEtapas()

	If (IsVazio(strTxtData)) Then
		Exit Sub
	End If

	Dim dtData
	dtData = CDate(strTxtData)

	Dim strDia, strMes, strAno
	strDia = Day(dtData)
	strMes = Month(dtData)
	strAno = Year(dtData)

	' ********************
	' *** FUSO BSB-GMT ***
	' ********************
	Dim strQueryFuso
	strQueryFuso =                "SELECT sig_fusovalor.fuso "
	strQueryFuso = strQueryFuso & "  FROM sig_fusovalor, "
	strQueryFuso = strQueryFuso & "       sig_parametros "
	strQueryFuso = strQueryFuso & " WHERE sig_fusovalor.codfuso = sig_parametros.codfusoref "
	strQueryFuso = strQueryFuso & " AND ( sig_fusovalor.dtinicio <= '" & strAno & "-" & strMes & "-" & strDia & "' ) "
	strQueryFuso = strQueryFuso & " AND (sig_fusovalor.dtfim >= '" & strAno & "-" & strMes & "-" & strDia & "' OR sig_fusovalor.dtfim IS NULL) "

	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim objRsFuso
	Set objRsFuso = Server.CreateObject("ADODB.Recordset")
	objRsFuso.Open strQueryFuso, objConn

	Dim intFusoGMT
	If (Not objRsFuso.EOF) Then
		intFusoGMT = CInt(objRsFuso("fuso"))
	Else
		intFusoGMT = CInt(0)
	End If

	objRsFuso.Close()
	Set objRsFuso = Nothing



	Dim strSqlSelect
	strSqlSelect = " SELECT "
	strSqlSelect = strSqlSelect & " DV.seqvoodia SEQ_VOO_DIA, "
	strSqlSelect = strSqlSelect & " DT.seqtrecho SEQ_TRECHO, "
	strSqlSelect = strSqlSelect & " DV.nrvoo NUMERO_VOO, "
	strSqlSelect = strSqlSelect & " Fr.codfrota CODIGO_FROTA, "
	strSqlSelect = strSqlSelect & " DT.prefixoaeronave PREFIXO_AERONAVE, "
	strSqlSelect = strSqlSelect & " ApOrig.codiata CODIGO_IATA_ORIGEM, "
	strSqlSelect = strSqlSelect & " ApDest.codiata CODIGO_IATA_DESTINO, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) PARTIDA_PREVISTA, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.chegadaprev) CHEGADA_PREVISTA, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidamotor) PARTIDA_MOTOR, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.cortemotor) CORTE_MOTOR "

	Dim strSqlFrom
	strSqlFrom = " FROM "
	strSqlFrom = strSqlFrom & " sig_diariovoo DV "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_diariotrecho DT ON DT.seqvoodia = DV.seqvoodia "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_aeroporto ApOrig ON ApOrig.seqaeroporto = DT.seqaeroporig "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_aeroporto ApDest ON ApDest.seqaeroporto = DT.seqaeropdest "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_frota Fr ON Fr.seqfrota = DT.seqfrota "

	Dim strSqlWhere
	strSqlWhere = " WHERE "
	strSqlWhere = strSqlWhere & "       ( DV.statusvoo = 'N' ) "
	strSqlWhere = strSqlWhere & " AND   ( DT.flgcancelado = 'N' ) "
	strSqlWhere = strSqlWhere & " AND   ( DV.dtoper = '" & strAno & "-" & strMes & "-" & strDia & "' ) "
	If (Not IsVazio(strTxtVoo)) Then
		strSqlWhere = strSqlWhere & " AND   ( DV.nrvoo = '" & strTxtVoo & "' ) "
	End If
	If (Not IsVazio(strTxtLocalidade)) Then
		strSqlWhere = strSqlWhere & " AND   ( ApOrig.codiata = '" & UCase(strTxtLocalidade) & "' OR ApDest.codiata = '" & UCase(strTxtLocalidade) & "' ) "
	End If

	Dim strSqlOrder
	strSqlOrder = " ORDER BY "
	strSqlOrder = strSqlOrder & " DT.partidaprev "

	Dim strQuery
	strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

	Dim objRs
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	Do While Not objRs.Eof
		Dim strSeqVooDia, strSeqTrecho
		strSeqVooDia = objRs("SEQ_VOO_DIA")
		strSeqTrecho = objRs("SEQ_TRECHO")

		Dim strNumeroVoo
		strNumeroVoo = objRs("NUMERO_VOO")
		If (IsVazio(strNumeroVoo)) Then strNumeroVoo = "&nbsp;"

		Dim strCodigoFrota
		strCodigoFrota = objRs("CODIGO_FROTA")
		If (IsVazio(strCodigoFrota)) Then strCodigoFrota = "&nbsp;"

		Dim strPrefixoAeronave
		strPrefixoAeronave = objRs("PREFIXO_AERONAVE")
		If (IsVazio(strPrefixoAeronave)) Then strPrefixoAeronave = "&nbsp;"

		Dim strCodigoIataOrigem
		strCodigoIataOrigem = objRs("CODIGO_IATA_ORIGEM")
		If (IsVazio(strCodigoIataOrigem)) Then strCodigoIataOrigem = "&nbsp;"

		Dim strCodigoIataDestino
		strCodigoIataDestino = objRs("CODIGO_IATA_DESTINO")
		If (IsVazio(strCodigoIataDestino)) Then strCodigoIataDestino = "&nbsp;"

		Dim strPartidaMotor, dtPartidaMotor
		dtPartidaMotor = objRs("PARTIDA_MOTOR")
		If (IsVazio(dtPartidaMotor)) Then
			strPartidaMotor = "&nbsp;"
		Else
			strPartidaMotor = Right("00" & Day(dtPartidaMotor), 2) & "/" & Right("00" & Month(dtPartidaMotor), 2) & "/" & Year(dtPartidaMotor)
			strPartidaMotor = strPartidaMotor & " " & FormatDateTime(dtPartidaMotor, 4)
		End If

		Dim strCorteMotor, dtCorteMotor
		dtCorteMotor = objRs("CORTE_MOTOR")
		If (IsVazio(dtCorteMotor)) Then
			strCorteMotor = "&nbsp;"
		Else
			strCorteMotor = Right("00" & Day(dtCorteMotor), 2) & "/" & Right("00" & Month(dtCorteMotor), 2) & "/" & Year(dtCorteMotor)
			strCorteMotor = strCorteMotor & " " & FormatDateTime(dtCorteMotor, 4)
		End If

		Dim strPartidaPrevista, dtPartidaPrevista
		dtPartidaPrevista = objRs("PARTIDA_PREVISTA")
		If (IsVazio(dtPartidaPrevista)) Then
			strPartidaPrevista = "&nbsp;"
		Else
			strPartidaPrevista = Right("00" & Day(dtPartidaPrevista), 2) & "/" & Right("00" & Month(dtPartidaPrevista), 2) & "/" & Year(dtPartidaPrevista)
			strPartidaPrevista = strPartidaPrevista & " " & FormatDateTime(dtPartidaPrevista, 4)
		End If

		Dim strChegadaPrevista, dtChegadaPrevista
		dtChegadaPrevista = objRs("CHEGADA_PREVISTA")
		If (IsVazio(dtChegadaPrevista)) Then
			strChegadaPrevista = "&nbsp;"
		Else
			strChegadaPrevista = Right("00" & Day(dtChegadaPrevista), 2) & "/" & Right("00" & Month(dtChegadaPrevista), 2) & "/" & Year(dtChegadaPrevista)
			strChegadaPrevista = strChegadaPrevista & " " & FormatDateTime(dtChegadaPrevista, 4)
		End If

		Dim dominio, strDominio
		dominio = Session("dominio")
		If (dominio = 1) Then
			strDominio = "Funcionarios"
		ElseIf (dominio = 3) Then
			strDominio = "Aeroporto"
		End If

		Dim blnExibirSetores
		If (chkExibirSetores = "ExibirSetores") Then
			blnExibirSetores = "True"
		Else
			blnExibirSetores = "False"
		End If

		Response.Write("			<tr onclick=""return RedirecionaPagina(this, '" & strDominio & "');"" style='cursor:pointer;cursor:hand'>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'><a href='RelatorioTransito.aspx?seqvoodia=" & strSeqVooDia & "&seqtrecho=" & strSeqTrecho & "&exibirsetores=" & blnExibirSetores & "'></a>" & strNumeroVoo & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strCodigoFrota & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strPrefixoAeronave & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strCodigoIataOrigem & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strCodigoIataDestino & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strPartidaPrevista & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strChegadaPrevista & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strPartidaMotor & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' align='center'>" & strCorteMotor & "</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)

		objRs.movenext
	Loop

	objRs.Close
	objConn.Close
	Set objRs = Nothing
	Set objConn = Nothing

End Sub



Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
