<!--#include file="verificaloginaeropfunc.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%
	' Executa função para gravar na sig_usuariolog
	'If f_grava_usuariolog( "I06", objConn ) <> "" Then
	'	Response.End()
	'End if

	Dim strTxtData, strTxtAeronave, strTxtOrigem, strTxtDestino
	strTxtData = Request.Form("txtData")
	strTxtAeronave = UCase(Request.Form("txtAeronave"))
	strTxtOrigem = UCase(Request.Form("txtOrigem"))
	strTxtDestino = UCase(Request.Form("txtDestino"))

	Dim strTxtOrigemDesabilitado
	strTxtOrigemDesabilitado = ""

	Dim intDominio
	intDominio = Session("dominio")

	if (intDominio = 3) then
		strTxtOrigemDesabilitado = "disabled='disabled'"

		Dim objConnAeroporto
		Set objConnAeroporto = CreateObject("ADODB.CONNECTION")
		objConnAeroporto.Open (StringConexaoSqlServer)
		objConnAeroporto.Execute "SET DATEFORMAT ymd"

		Dim intSeqAeroporto
		intSeqAeroporto = Session("seqaeroporto")

		' **************************
		' *** DADOS DO AEROPORTO ***
		' **************************
		Dim strQueryAeroporto, objRsAeroporto
		strQueryAeroporto =                     " SELECT codiata "
		strQueryAeroporto = strQueryAeroporto & " FROM sig_aeroporto "
		strQueryAeroporto = strQueryAeroporto & " WHERE seqaeroporto = " & intSeqAeroporto
		Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
		objRsAeroporto.Open strQueryAeroporto, objConnAeroporto
		strTxtOrigem = objRsAeroporto("codiata")
		objRsAeroporto.Close()
		Set objRsAeroporto = Nothing

		objConnAeroporto.Close
		Set objConnAeroporto = Nothing
	end if

	If (IsVazio(strTxtData)) Then
		Dim strDiaTemp, strMesTemp
		strDiaTemp = Day(Now)
		strMesTemp = Month(Now)
		If (Len(strDiaTemp) < 2) Then strDiaTemp = "0" & strDiaTemp End If
		If (Len(strMesTemp) < 2) Then strMesTemp = "0" & strMesTemp End If
		strTxtData = strDiaTemp & "/" & strMesTemp & "/" & Year(Now)
	End If



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
	if (Not objRsFuso.EOF) then
		intFusoGMT = CInt(objRsFuso("fuso"))
	else
		intFusoGMT = CInt(0)
	end if

	objRsFuso.Close()
	Set objRsFuso = Nothing



	Dim strSqlSelect
	strSqlSelect = " SELECT "
	strSqlSelect = strSqlSelect & " DV.seqvoodia SeqVooDia, "
	strSqlSelect = strSqlSelect & " DT.seqtrecho SeqTrecho, "
	strSqlSelect = strSqlSelect & " DV.nrvoo Voo, "
	strSqlSelect = strSqlSelect & " DV.dtoper Data_Operacao, "
	strSqlSelect = strSqlSelect & " ApOrig.codiata Origem, "
	strSqlSelect = strSqlSelect & " ApDest.codiata Destino, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) Partida_Prevista, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.chegadaprev) Chegada_Prevista, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidaest) Partida_Estimada, "
	strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.chegadaest) Chegada_Estimada, "
	strSqlSelect = strSqlSelect & " Fr.codfrota Frota, "
	strSqlSelect = strSqlSelect & " DT.prefixoaeronave Aeronave "

	Dim strSqlFrom
	strSqlFrom = " FROM "
	strSqlFrom = strSqlFrom & " sig_diariotrecho DT, "
	strSqlFrom = strSqlFrom & " sig_diariovoo DV, "
	strSqlFrom = strSqlFrom & " sig_frota Fr, "
	strSqlFrom = strSqlFrom & " sig_aeroporto ApOrig, "
	strSqlFrom = strSqlFrom & " sig_aeroporto ApDest "

	Dim strSqlWhere
	strSqlWhere = " WHERE "
	strSqlWhere = strSqlWhere & "     DV.seqvoodia = DT.seqvoodia "
	strSqlWhere = strSqlWhere & " AND ApOrig.seqaeroporto = DT.seqaeroporig "
	strSqlWhere = strSqlWhere & " AND ApDest.seqaeroporto = DT.seqaeropdest "
	strSqlWhere = strSqlWhere & " AND DT.seqfrota = Fr.seqfrota "
	strSqlWhere = strSqlWhere & " AND DV.statusvoo = 'N' "
	strSqlWhere = strSqlWhere & " AND DT.flgcancelado = 'N' "
	strSqlWhere = strSqlWhere & " AND DV.dtoper = '" & strAno & "-" & strMes & "-" & strDia & "' "
	If (Not IsVazio(strTxtAeronave)) Then
		strSqlWhere = strSqlWhere & " AND UPPER(DT.prefixoaeronave) = '" & strTxtAeronave & "' "
	End If
	If (Not IsVazio(strTxtOrigem)) Then
		strSqlWhere = strSqlWhere & " AND UPPER(ApOrig.codiata) = '" & strTxtOrigem & "' "
	End If
	If (Not IsVazio(strTxtDestino)) Then
		strSqlWhere = strSqlWhere & " AND UPPER(ApDest.codiata) = '" & strTxtDestino & "' "
	End If
	strSqlWhere = strSqlWhere & " AND EXISTS ( SELECT 1 FROM sig_diariotrechodispatch DTD "
	strSqlWhere = strSqlWhere & "              WHERE DT.seqvoodia = DTD.seqvoodia "
	strSqlWhere = strSqlWhere & "                AND DT.seqtrecho = DTD.seqtrecho "
	strSqlWhere = strSqlWhere & "                AND DT.seqaeroporig = DTD.seqaeroporig "
	strSqlWhere = strSqlWhere & "                AND DT.prefixoaeronave = DTD.prefixored "
	strSqlWhere = strSqlWhere & "                AND UPPER(DTD.flgpublicado) = 'S' ) "

	Dim strSqlOrder
	strSqlOrder = " ORDER BY "
	strSqlOrder = strSqlOrder & " DT.partidaprev "

	Dim strQuery
	strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

	Dim objRs
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	Dim intSeqVooDia, intSeqTrecho
	Dim intVoo, strOrigem, strDestino, strFrota, strAeronave
	Dim dtDataOperacao, dtPartidaPrevista, dtChegadaPrevista, dtPartidaEstimada, dtChegadaEstimada
	Dim strDataOperacao, strPartidaPrevista, strChegadaPrevista, strPartidaEstimada, strChegadaEstimada

	Do While Not objRs.Eof
		intSeqVooDia = objRs("SeqVooDia")
		intSeqTrecho = objRs("SeqTrecho")

		intVoo = objRs("Voo")
		If (IsVazio(intVoo)) Then intVoo = "&nbsp;"

		strOrigem = objRs("Origem")
		If (IsVazio(strOrigem)) Then strOrigem = "&nbsp;"

		strDestino = objRs("Destino")
		If (IsVazio(strDestino)) Then strDestino = "&nbsp;"

		strFrota = objRs("Frota")
		If (IsVazio(strFrota)) Then strFrota = "&nbsp;"

		strAeronave = objRs("Aeronave")
		If (IsVazio(strAeronave)) Then strAeronave = "&nbsp;"

		dtDataOperacao = objRs("Data_Operacao")
		If (IsVazio(dtDataOperacao)) Then
			strDataOperacao = "&nbsp;"
		Else
			strDataOperacao = Right("00" & Day(dtDataOperacao), 2) & "/" & Right("00" & Month(dtDataOperacao), 2) & "/" & Year(dtDataOperacao)
		End If

		dtPartidaPrevista = objRs("Partida_Prevista")
		If (IsVazio(dtPartidaPrevista)) Then
			strPartidaPrevista = "&nbsp;"
		Else
			strPartidaPrevista = Right("00" & Day(dtPartidaPrevista), 2) & "/" & Right("00" & Month(dtPartidaPrevista), 2)
			strPartidaPrevista = strPartidaPrevista & " " & FormatDateTime(dtPartidaPrevista, 4)
		End If

		dtChegadaPrevista = objRs("Chegada_Prevista")
		If (IsVazio(dtChegadaPrevista)) Then
			strChegadaPrevista = "&nbsp;"
		Else
			strChegadaPrevista = Right("00" & Day(dtChegadaPrevista), 2) & "/" & Right("00" & Month(dtChegadaPrevista), 2)
			strChegadaPrevista = strChegadaPrevista & " " & FormatDateTime(dtChegadaPrevista, 4)
		End If

		dtPartidaEstimada = objRs("Partida_Estimada")
		If (IsVazio(dtPartidaEstimada)) Then
			strPartidaEstimada = "&nbsp;"
		Else
			strPartidaEstimada = Right("00" & Day(dtPartidaEstimada), 2) & "/" & Right("00" & Month(dtPartidaEstimada), 2)
			strPartidaEstimada = strPartidaEstimada & " " & FormatDateTime(dtPartidaEstimada, 4)
		End If

		dtChegadaEstimada = objRs("Chegada_Estimada")
		If (IsVazio(dtChegadaEstimada)) Then
			strChegadaEstimada = "&nbsp;"
		Else
			strChegadaEstimada = Right("00" & Day(dtChegadaEstimada), 2) & "/" & Right("00" & Month(dtChegadaEstimada), 2)
			strChegadaEstimada = strChegadaEstimada & " " & FormatDateTime(dtChegadaEstimada, 4)
		End If

		Response.Write("			<tr onclick=""location.href='dispatchdetalhe.asp?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'"" style='cursor:pointer;cursor:hand' >" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & intVoo & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strDataOperacao & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strOrigem & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strDestino & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strPartidaPrevista & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strChegadaPrevista & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strPartidaEstimada & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strChegadaEstimada & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strFrota & "</td>" & vbCrLf)
		Response.Write("				<td class='corpo' style='text-align:center'>" & strAeronave & "</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)

		objRs.movenext
	Loop

	objRs.Close
	Set objRs = Nothing

	objConn.Close
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
