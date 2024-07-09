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

	' ****************************
	' *** ATUALIZA PASSAGEIROS ***
	' ****************************
	Dim objRsPassageiros
	Dim strSqlPassageiros

	strSqlPassageiros =                     "SELECT sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxpago, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxeconomica, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxpad, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxgratis, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxdhc) paxdhc, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.baglivre + SDTC.baglivretran) baglivre, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.bagexcesso + SDTC.bagexcessotran) bagexcesso, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargapaga + SDTC.cargapagatran) cargapaga, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargapagaexp) cargapagaexp, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargagratis + SDTC.cargagratistran) cargagratis, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correioao + SDTC.correioaotran) correioao, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correiolc + SDTC.correiolctran) correiolc, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxchd + SDTC.paxchdtran) paxchd, "
	strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxinf + SDTC.paxinftran) paxinf "
	strSqlPassageiros = strSqlPassageiros & "  FROM sig_diariotrechocomb SDTC, "
	strSqlPassageiros = strSqlPassageiros & "       sig_diariotrecho SDT "
	strSqlPassageiros = strSqlPassageiros & " WHERE SDTC.seqvoodia = SDT.seqvoodia "
	strSqlPassageiros = strSqlPassageiros & "   AND SDTC.seqtrecho = SDT.seqtrecho "
	strSqlPassageiros = strSqlPassageiros & "   AND SDT.seqvoodia = " & intSeqVooDia
	strSqlPassageiros = strSqlPassageiros & "   AND SDTC.seqtrecho <= " & intSeqTrecho
	strSqlPassageiros = strSqlPassageiros & "   AND (select Min(seqtrecho) "
	strSqlPassageiros = strSqlPassageiros & "          from sig_diariotrecho SDT2 "
	strSqlPassageiros = strSqlPassageiros & "         where SDT2.seqvoodia = SDTC.seqvoodia "
	strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqaeropdest = SDTC.seqaeropdest "
	strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqtrecho >= SDTC.seqtrecho) >= " & intSeqTrecho

'	strSqlPassageiros =                     "SELECT SUM(SDTC.paxpago) paxpago, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.paxeconomica) paxeconomica, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.paxpad) paxpad, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.paxgratis) paxgratis, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.paxdhc) paxdhc, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.baglivre) baglivre, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.bagexcesso) bagexcesso, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.cargapaga) cargapaga, "
'	strSqlPassageiros = strSqlPassageiros & "       SUM(SDTC.cargagratis) cargagratis "
'	strSqlPassageiros = strSqlPassageiros & "  FROM sig_diariotrechocomb SDTC "
'	strSqlPassageiros = strSqlPassageiros & " WHERE SDTC.seqvoodia=" & intSeqVooDia
'	strSqlPassageiros = strSqlPassageiros & "   AND SDTC.seqtrecho=" & intSeqTrecho
	Set objRsPassageiros = Server.CreateObject("ADODB.Recordset")
	objRsPassageiros.Open strSqlPassageiros, objConn

	Dim objConnUpdate
	Set objConnUpdate = Server.CreateObject ("ADODB.Connection")
	objConnUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
	objConnUpdate.Execute "SET DATEFORMAT ymd"

	Dim strSqlUpdatePassageiros
	strSqlUpdatePassageiros =                           " UPDATE sig_diariotrecho "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & " SET paxpago      = " & CLng(ObjRsPassageiros("paxpago")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxeconomica = " & CLng(ObjRsPassageiros("paxeconomica")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxpad       = " & CLng(ObjRsPassageiros("paxpad")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxgratis    = " & CLng(ObjRsPassageiros("paxgratis")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxdhc       = " & CLng(ObjRsPassageiros("paxdhc")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     baglivre     = " & CLng(ObjRsPassageiros("baglivre")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     bagexcesso   = " & CLng(ObjRsPassageiros("bagexcesso")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargapaga    = " & CLng(ObjRsPassageiros("cargapaga")) & ", "
	If (Not IsVazio(ObjRsPassageiros("cargapagaexp"))) Then
		strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargapagaexp    = " & CLng(ObjRsPassageiros("cargapagaexp")) & ", "
	End If
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargagratis  = " & CLng(ObjRsPassageiros("cargagratis")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     correioao  = " & CLng(ObjRsPassageiros("correioao")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     correiolc  = " & CLng(ObjRsPassageiros("correiolc")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxchd       = " & CLng(ObjRsPassageiros("paxchd")) & ", "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxinf       = " & CLng(ObjRsPassageiros("paxinf")) & " "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & " WHERE seqvoodia=" & intSeqVooDia & " "
	strSqlUpdatePassageiros = strSqlUpdatePassageiros & "   AND seqtrecho=" & intSeqTrecho & " "

	objConnUpdate.Execute(strSqlUpdatePassageiros)
	objConnUpdate.Close
	Set objConnUpdate = nothing

	objRsPassageiros.Close()
	Set objRsPassageiros = Nothing

	Dim strGravar, strVoltar, strCarregamento
	strGravar = Request.Form("btnGravar")
	strVoltar = Request.Form("btnVoltar")
	strCarregamento = Request.Form("btnCarregamento")

	if (strVoltar <> "") then
		Response.Redirect("listagemhorariovoos.asp")
	elseif (strCarregamento <> "") then
		Dim strTipoTransporte
		strTipoTransporte = Request.Form("hdTipoTransporte")
		if (UCase(strTipoTransporte) <> "CGA") then
			'Erro: Todas as aeronaves nessa página devem ser de carga (TipoTransporte = CGA)
			Response.Redirect("listagemhorariovoos.asp")
		else
			Response.Redirect("combinadaaeroportocarga.asp")
		end if
	elseif (strGravar <> "") then
		Dim strTxtDiaDecolagem, strTxtMesDecolagem, strTxtAnoDecolagem, strTxtHoraDecolagem, strTxtMinutoDecolagem
		Dim strTxtDiaPartidaMotor, strTxtMesPartidaMotor, strTxtAnoPartidaMotor, strTxtHoraPartidaMotor, strTxtMinutoPartidaMotor
		Dim strTxtDiaFechamPorta, strTxtMesFechamPorta, strTxtAnoFechamPorta, strTxtHoraFechamPorta, strTxtMinutoFechamPorta
		Dim strDdlJustificativa, strTxtObservacao
		strTxtDiaDecolagem = Request.Form("txtDiaDecolagem")
		strTxtMesDecolagem = Request.Form("txtMesDecolagem")
		strTxtAnoDecolagem = Request.Form("txtAnoDecolagem")
		strTxtHoraDecolagem = Request.Form("txtHoraDecolagem")
		strTxtMinutoDecolagem = Request.Form("txtMinutoDecolagem")
		strTxtDiaPartidaMotor = Request.Form("txtDiaPartidaMotor")
		strTxtMesPartidaMotor = Request.Form("txtMesPartidaMotor")
		strTxtAnoPartidaMotor = Request.Form("txtAnoPartidaMotor")
		strTxtHoraPartidaMotor = Request.Form("txtHoraPartidaMotor")
		strTxtMinutoPartidaMotor = Request.Form("txtMinutoPartidaMotor")
		strTxtDiaFechamPorta = Request.Form("txtDiaFechamPorta")
		strTxtMesFechamPorta = Request.Form("txtMesFechamPorta")
		strTxtAnoFechamPorta = Request.Form("txtAnoFechamPorta")
		strTxtHoraFechamPorta = Request.Form("txtHoraFechamPorta")
		strTxtMinutoFechamPorta = Request.Form("txtMinutoFechamPorta")
		strDdlJustificativa = Request.Form("ddlJustificativa")
		strTxtObservacao = Request.Form("txtObservacao")

		Dim strTxtDataDecolagem, datTxtDataDecolagem
		strTxtDataDecolagem = strTxtAnoDecolagem & "-" & strTxtMesDecolagem & "-" & strTxtDiaDecolagem & " " & strTxtHoraDecolagem & ":" & strTxtMinutoDecolagem
		datTxtDataDecolagem = CDate(strTxtDataDecolagem)
		datTxtDataDecolagem = CDate(DateAdd("h", intFusoGMT, datTxtDataDecolagem))
		strTxtDataDecolagem = CStr(Year(datTxtDataDecolagem)) & "-" & CStr(Month(datTxtDataDecolagem)) & "-" & CStr(Day(datTxtDataDecolagem)) & " " & CStr(Hour(datTxtDataDecolagem)) & ":" & CStr(Minute(datTxtDataDecolagem))

		Dim strTxtDataPartidaMotor, datTxtDataPartidaMotor
		strTxtDataPartidaMotor = strTxtAnoPartidaMotor & "-" & strTxtMesPartidaMotor & "-" & strTxtDiaPartidaMotor & " " & strTxtHoraPartidaMotor & ":" & strTxtMinutoPartidaMotor
		datTxtDataPartidaMotor = CDate(strTxtDataPartidaMotor)
		datTxtDataPartidaMotor = CDate(DateAdd("h", intFusoGMT, datTxtDataPartidaMotor))
		strTxtDataPartidaMotor = CStr(Year(datTxtDataPartidaMotor)) & "-" & CStr(Month(datTxtDataPartidaMotor)) & "-" & CStr(Day(datTxtDataPartidaMotor)) & " " & CStr(Hour(datTxtDataPartidaMotor)) & ":" & CStr(Minute(datTxtDataPartidaMotor))

		Dim strTxtDataFechamPorta, datTxtDataFechamPorta
		strTxtDataFechamPorta = strTxtAnoFechamPorta & "-" & strTxtMesFechamPorta & "-" & strTxtDiaFechamPorta & " " & strTxtHoraFechamPorta & ":" & strTxtMinutoFechamPorta
		if IsDate(strTxtDataFechamPorta) then
			datTxtDataFechamPorta = CDate(strTxtDataFechamPorta)
			datTxtDataFechamPorta = CDate(DateAdd("h", intFusoGMT, datTxtDataFechamPorta))
			strTxtDataFechamPorta = CStr(Year(datTxtDataFechamPorta)) & "-" & CStr(Month(datTxtDataFechamPorta)) & "-" & CStr(Day(datTxtDataFechamPorta)) & " " & CStr(Hour(datTxtDataFechamPorta)) & ":" & CStr(Minute(datTxtDataFechamPorta))
		end if

		if CamposPreenchidosCorretamente(datTxtDataFechamPorta, datTxtDataPartidaMotor, datTxtDataDecolagem, intFusoGMT) then

			Dim objConexaoSqlServerUpdate, objRecordSetSqlServerUpdate
			Dim strSqlUpdate, strSqlSet, strSqlFromUpdate, strSqlWhereUpdate, strQueryUpdate
			set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
			objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
			objConexaoSqlServerUpdate.Execute "SET DATEFORMAT ymd"

			strSqlUpdate =                          " UPDATE sig_diariotrecho "
			strSqlSet =                             " SET sig_diariotrecho.decolagem=" & Plic(strTxtDataDecolagem) & ", "
			strSqlSet = strSqlSet &                 "     sig_diariotrecho.partidamotor=" & Plic(strTxtDataPartidaMotor) & ", "
			if IsDate(strTxtDataFechamPorta) then
				strSqlSet = strSqlSet &                 "     sig_diariotrecho.fechamporta=" & Plic(strTxtDataFechamPorta) & ", "
			end if
			strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzdec=DATEDIFF(mi, sig_diariotrecho.partidaplanej, " & Plic(strTxtDataPartidaMotor) & "), "
			strSqlSet = strSqlSet &                 "     sig_diariotrecho.atzdecint=DATEDIFF(mi, sig_diariotrecho.partidaprev, " & Plic(strTxtDataPartidaMotor) & "), "
			strSqlSet = strSqlSet &                 "     sig_diariotrecho.flgcapturadec='S', "
			if (strDdlJustificativa = "0") then
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustifinterna=NULL, "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustificativa=NULL, "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustifinternatraf=NULL, "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustificativatraf=NULL, "
			else
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustifinterna=" & Plic(strDdlJustificativa) & ", "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustificativa=SJUST.idjustificativa, "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustifinternatraf=" & Plic(strDdlJustificativa) & ", "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.idjustificativatraf=SJUST.idjustificativa, "
			end if
			if (strTxtObservacao = "") then
				strSqlSet = strSqlSet &             "     sig_diariotrecho.observacao=NULL, "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.observacaotraf=NULL "
			else
				strSqlSet = strSqlSet &             "     sig_diariotrecho.observacao=" & Plic(strTxtObservacao) & ", "
				strSqlSet = strSqlSet &             "     sig_diariotrecho.observacaotraf=" & Plic(strTxtObservacao) & " "
			end if
			strSqlFromUpdate =                      " FROM sig_diariotrecho "
			if (strDdlJustificativa <> "0") then
				strSqlFromUpdate = strSqlFromUpdate &    " LEFT OUTER JOIN sig_justifinterna SJUST ON SJUST.idjustifinterna=" & Plic(strDdlJustificativa) & " "
			end if
			strSqlWhereUpdate =                     " WHERE seqvoodia=" & intSeqVooDia
			strSqlWhereUpdate = strSqlWhereUpdate & "   AND seqtrecho=" & intSeqTrecho
			strQueryUpdate = strSqlUpdate & strSqlSet & strSqlFromUpdate & strSqlWhereUpdate

			set objRecordSetSqlServerUpdate = objConexaoSqlServerUpdate.Execute(strQueryUpdate)

			objConexaoSqlServerUpdate.Close
			set objRecordSetSqlServerUpdate = nothing
			set objConexaoSqlServerUpdate = nothing

			' ************************************
			' *** DADOS DA TABELA DE AUDITORIA ***
			' ************************************
			Dim strDescricao, intRet
			strDescricao = "[seqvoodia:" & intSeqVooDia & " seqtrecho:" & intSeqTrecho & "]"
			strDescricao = strDescricao & " / Fecham. Porta:" & strTxtDataFechamPorta & " / Decolagem:" & strTxtDataDecolagem & " / Part. Motor:" & strTxtDataPartidaMotor
			strDescricao = strDescricao & " / Just. Int.:" & strDdlJustificativa

			intRet = f_auditoria("SIG_DIARIOTRECHO", intSeqUsuarioAerop, "UPDATE", strDescricao, StringConexaoSqlServer)

			Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
		end if

	end if

	strSqlSelect =                " SELECT DV.nrvoo, "
	strSqlSelect = strSqlSelect & "        DT.prefixoaeronave, "
	strSqlSelect = strSqlSelect & "        aeroporig.codiata Origem, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata Destino, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) partidaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.partidaest) partidaest, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.partidamotor) partidamotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.decolagem) decolagem, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", DT.fechamporta) fechamporta, "
	strSqlSelect = strSqlSelect & "        DT.paxpago, "
	strSqlSelect = strSqlSelect & "        DT.cargapaga, "
	strSqlSelect = strSqlSelect & "        DT.cargapagaexp, "
	strSqlSelect = strSqlSelect & "        DT.cargagratis, "
	strSqlSelect = strSqlSelect & "        DT.correioao, "
	strSqlSelect = strSqlSelect & "        DT.correiolc, "
	strSqlSelect = strSqlSelect & "        DT.cargapaga + DT.cargagratis + DT.correioao + DT.correiolc TOTAL_PESO, "
	strSqlSelect = strSqlSelect & "        (SELECT COUNT(1) "
	strSqlSelect = strSqlSelect & "          FROM sig_diariotrechocombcarga DTCC, "
	strSqlSelect = strSqlSelect & "               sig_diariotrechocomb DTC "
	strSqlSelect = strSqlSelect & "          WHERE DTC.seqvoodia = DT.seqvoodia "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqvoodia = DTC.seqvoodia "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqtrecho = DTC.seqtrecho "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqcombinada = DTC.seqcombinada "
	strSqlSelect = strSqlSelect & "            AND DTC.seqtrecho <= DT.seqtrecho "
	strSqlSelect = strSqlSelect & "            AND (select Min(seqtrecho) "
	strSqlSelect = strSqlSelect & "                 from sig_diariotrecho DT2 "
	strSqlSelect = strSqlSelect & "                 where DT2.seqvoodia = DTC.seqvoodia "
	strSqlSelect = strSqlSelect & "                   and DT2.seqaeropdest = DTC.seqaeropdest "
	strSqlSelect = strSqlSelect & "                   and DT2.seqtrecho >= DTC.seqtrecho) >= DT.seqtrecho "
	strSqlSelect = strSqlSelect & "            AND DTCC.flguld = 'S') TOTAL_ULD, "
	strSqlSelect = strSqlSelect & "        (SELECT SUM(DTCC.pesobruto) "
	strSqlSelect = strSqlSelect & "          FROM sig_diariotrechocombcarga DTCC, "
	strSqlSelect = strSqlSelect & "               sig_diariotrechocomb DTC "
	strSqlSelect = strSqlSelect & "          WHERE DTC.seqvoodia = DT.seqvoodia "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqvoodia = DTC.seqvoodia "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqtrecho = DTC.seqtrecho "
	strSqlSelect = strSqlSelect & "            AND DTCC.seqcombinada = DTC.seqcombinada "
	strSqlSelect = strSqlSelect & "            AND DTC.seqtrecho <= DT.seqtrecho "
	strSqlSelect = strSqlSelect & "            AND (select Min(seqtrecho) "
	strSqlSelect = strSqlSelect & "                 from sig_diariotrecho DT2 "
	strSqlSelect = strSqlSelect & "                 where DT2.seqvoodia = DTC.seqvoodia "
	strSqlSelect = strSqlSelect & "                   and DT2.seqaeropdest = DTC.seqaeropdest "
	strSqlSelect = strSqlSelect & "                   and DT2.seqtrecho >= DTC.seqtrecho) >= DT.seqtrecho) TOTAL_PESO_BRUTO, "
	strSqlSelect = strSqlSelect & "        DT.idjustifinternatraf, "
	strSqlSelect = strSqlSelect & "        DT.observacaotraf "
	strSqlFrom =                  " FROM sig_diariovoo DV, "
	strSqlFrom = strSqlFrom &     "      sig_diariotrecho DT, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeroporig, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeropdest "
	strSqlWhere =                 " WHERE DV.seqvoodia = DT.seqvoodia "
	strSqlWhere = strSqlWhere &   "   AND DT.seqvoodia = " & intSeqVooDia & " "
	strSqlWhere = strSqlWhere &   "   AND DT.seqtrecho = " & intSeqTrecho & " "
	strSqlWhere = strSqlWhere &   "   AND DT.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere &   "   AND DT.seqaeropdest = aeropdest.seqaeroporto "

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
	' *** PARTIDA PREVISTA / ESTIMADA ***
	' ***********************************
	Dim dtData, strHora, strData, strDataHora, strDataHoraEst
	strHora = FormatDateTime(ObjRs("partidaprev"), 4)
	strData = FormatDateTime(ObjRs("partidaprev"), 2)
	strDataHora = strData & "&nbsp;&nbsp;&nbsp;" & strHora
	dtData = ObjRs("partidaest")
	if(Not IsNull(dtData)) then
		strHora = FormatDateTime(ObjRs("partidaest"), 4)
		strData = FormatDateTime(ObjRs("partidaest"), 2)
		strDataHoraEst = strData & "&nbsp;&nbsp;&nbsp;" & strHora
	else
		strDataHoraEst = ""
	end if

	' *****************
	' *** DECOLAGEM ***
	' *****************
	Dim strAnoDecolagem, strMesDecolagem, strDiaDecolagem, strHoraDecolagem, strMinutoDecolagem
	Dim dtDecolagem, dtPartidaPrevista
	dtDecolagem = ObjRs("decolagem")
	dtPartidaPrevista = ObjRs("partidaprev")
	if (IsNull(dtDecolagem) or IsEmpty(dtDecolagem)) then
		strAnoDecolagem = Year(dtPartidaPrevista)
		if (Month(dtPartidaPrevista) < 10) then strMesDecolagem = "0"
		strMesDecolagem = strMesDecolagem & Month(dtPartidaPrevista)
		if (Day(dtPartidaPrevista) < 10) then strDiaDecolagem = "0"
		strDiaDecolagem = strDiaDecolagem & Day(dtPartidaPrevista)
		strHoraDecolagem = ""
		strMinutoDecolagem = ""
	else
		strAnoDecolagem = Year(dtDecolagem)
		if (Month(dtDecolagem) < 10) then strMesDecolagem = "0"
		strMesDecolagem = strMesDecolagem & Month(dtDecolagem)
		if (Day(dtDecolagem) < 10) then strDiaDecolagem = "0"
		strDiaDecolagem = strDiaDecolagem & Day(dtDecolagem)
		if (Hour(dtDecolagem) < 10) then strHoraDecolagem = "0"
		strHoraDecolagem = strHoraDecolagem & Hour(dtDecolagem)
		if (Minute(dtDecolagem) < 10) then strMinutoDecolagem = "0"
		strMinutoDecolagem = strMinutoDecolagem & Minute(dtDecolagem)
	end if

	' *********************
	' *** PARTIDA MOTOR ***
	' *********************
	Dim strAnoPartidaMotor, strMesPartidaMotor, strDiaPartidaMotor, strHoraPartidaMotor, strMinutoPartidaMotor
	Dim dtPartidaMotor
	dtPartidaMotor = ObjRs("partidamotor")
	if (IsNull(dtPartidaMotor) or IsEmpty(dtPartidaMotor)) then
		strAnoPartidaMotor = Year(dtPartidaPrevista)
		if (Month(dtPartidaPrevista) < 10) then strMesPartidaMotor = "0"
		strMesPartidaMotor = strMesPartidaMotor & Month(dtPartidaPrevista)
		if (Day(dtPartidaPrevista) < 10) then strDiaPartidaMotor = "0"
		strDiaPartidaMotor = strDiaPartidaMotor & Day(dtPartidaPrevista)
		strHoraPartidaMotor = ""
		strMinutoPartidaMotor = ""
	else
		strAnoPartidaMotor = Year(dtPartidaMotor)
		if (Month(dtPartidaMotor) < 10) then strMesPartidaMotor = "0"
		strMesPartidaMotor = strMesPartidaMotor & Month(dtPartidaMotor)
		if (Day(dtPartidaMotor) < 10) then strDiaPartidaMotor = "0"
		strDiaPartidaMotor = strDiaPartidaMotor & Day(dtPartidaMotor)
		if (Hour(dtPartidaMotor) < 10) then strHoraPartidaMotor = "0"
		strHoraPartidaMotor = strHoraPartidaMotor & Hour(dtPartidaMotor)
		if (Minute(dtPartidaMotor) < 10) then strMinutoPartidaMotor = "0"
		strMinutoPartidaMotor = strMinutoPartidaMotor & Minute(dtPartidaMotor)
	end if

	' ***************************
	' *** FECHAMENTO DE PORTA ***
	' ***************************
	Dim strAnoFechamPorta, strMesFechamPorta, strDiaFechamPorta, strHoraFechamPorta, strMinutoFechamPorta
	Dim dtFechamPorta
	dtFechamPorta = ObjRs("FechamPorta")
	if (IsNull(dtFechamPorta) or IsEmpty(dtFechamPorta)) then
		strAnoFechamPorta = Year(dtPartidaPrevista)
		if (Month(dtPartidaPrevista) < 10) then strMesFechamPorta = "0"
		strMesFechamPorta = strMesFechamPorta & Month(dtPartidaPrevista)
		if (Day(dtPartidaPrevista) < 10) then strDiaFechamPorta = "0"
		strDiaFechamPorta = strDiaFechamPorta & Day(dtPartidaPrevista)
		strHoraFechamPorta = ""
		strMinutoFechamPorta = ""
	else
		strAnoFechamPorta = Year(dtFechamPorta)
		if (Month(dtFechamPorta) < 10) then strMesFechamPorta = "0"
		strMesFechamPorta = strMesFechamPorta & Month(dtFechamPorta)
		if (Day(dtFechamPorta) < 10) then strDiaFechamPorta = "0"
		strDiaFechamPorta = strDiaFechamPorta & Day(dtFechamPorta)
		if (Hour(dtFechamPorta) < 10) then strHoraFechamPorta = "0"
		strHoraFechamPorta = strHoraFechamPorta & Hour(dtFechamPorta)
		if (Minute(dtFechamPorta) < 10) then strMinutoFechamPorta = "0"
		strMinutoFechamPorta = strMinutoFechamPorta & Minute(dtFechamPorta)
	end if

	' *******************
	' *** PASSAGEIROS ***
	' *******************
	Dim intCargaPaga, intCargaPagaSTD, intCargaPagaEXP, intCargaGratis
	Dim intCorreioVAC, intCorreioRPN
	Dim intTotalPeso, intTotalULD, intTotalPesoBruto
	Dim intPaxPago
	intPaxPago = ObjRs("paxpago")
	intCargaPaga = ObjRs("cargapaga")
	intCargaPagaEXP = ObjRs("cargapagaexp")
	intCargaGratis = ObjRs("cargagratis")
	intTotalPeso = ObjRs("TOTAL_PESO")
	intTotalULD = ObjRs("TOTAL_ULD")
	intTotalPesoBruto = ObjRs("TOTAL_PESO_BRUTO")
	intCorreioVAC = ObjRs("correioao")
	intCorreioRPN = ObjRs("correiolc")

	if (IsNull(intPaxPago) or IsEmpty(intPaxPago)) then
		intPaxPago = CLng(0)
	else
		intPaxPago = CLng(intPaxPago)
	end if
	if (IsNull(intCargaPaga) or IsEmpty(intCargaPaga)) then
		intCargaPaga = CLng(0)
	else
		intCargaPaga = CLng(intCargaPaga)
	end if
	if (IsNull(intCargaPagaEXP) or IsEmpty(intCargaPagaEXP)) then
		intCargaPagaEXP = CLng(0)
	else
		intCargaPagaEXP = CLng(intCargaPagaEXP)
	end if
	if (IsNull(intCargaGratis) or IsEmpty(intCargaGratis)) then
		intCargaGratis = CLng(0)
	else
		intCargaGratis = CLng(intCargaGratis)
	end if
	intCargaPagaSTD = CLng(intCargaPaga) - CLng(intCargaPagaEXP)

	if (IsNull(intCorreioVAC) or IsEmpty(intCorreioVAC)) then
		intCorreioVAC = CLng(0)
	else
		intCorreioVAC = CLng(intCorreioVAC)
	end if
	if (IsNull(intCorreioRPN) or IsEmpty(intCorreioRPN)) then
		intCorreioRPN = CLng(0)
	else
		intCorreioRPN = CLng(intCorreioRPN)
	end if

	if (IsNull(intTotalPeso) or IsEmpty(intTotalPeso)) then
		intTotalPeso = CLng(0)
	else
		intTotalPeso = CLng(intTotalPeso)
	end if
	if (IsNull(intTotalULD) or IsEmpty(intTotalULD)) then
		intTotalULD = CLng(0)
	else
		intTotalULD = CLng(intTotalULD)
	end if
	if (IsNull(intTotalPesoBruto) or IsEmpty(intTotalPesoBruto)) then
		intTotalPesoBruto = CLng(0)
	else
		intTotalPesoBruto = CLng(intTotalPesoBruto)
	end if


	' ******************************
	' *** Capacidade da Aeronave ***
	' ******************************
	
	Dim objRsCombSel, strQueryCombSel
		strQueryCombSel =                   " SELECT SA.capac_pax, "
		strQueryCombSel = strQueryCombSel & "        SA.capac_cga, "
		strQueryCombSel = strQueryCombSel & "        SA.tipotransporte "
		strQueryCombSel = strQueryCombSel & " FROM sig_diariotrecho SDT, "
		strQueryCombSel = strQueryCombSel & "      sig_aeronave SA "
		strQueryCombSel = strQueryCombSel & " WHERE SDT.prefixoaeronave = SA.prefixored "
		strQueryCombSel = strQueryCombSel & "   AND SDT.seqvoodia = " & intSeqVooDia & " "
		strQueryCombSel = strQueryCombSel & "   AND SDT.seqtrecho = " & intSeqTrecho & " "

		Set objRsCombSel = Server.CreateObject("ADODB.Recordset")
		objRsCombSel.Open strQueryCombSel, objConn

%>

<html>
	<head>
		<title>Aeroportos</title>
      	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	    <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<script src="javascript.js"></script>
		<script language="javascript">

			function CarregaPagina() {
				document.getElementById('txtHoraDecolagem').focus();
			}

			function VerificaCampos() {
				if (document.getElementById('txtDiaFechamPorta').value == '') {
					alert('Preencha o campo dia do fechamento de porta, por favor!');
					document.getElementById('txtDiaFechamPorta').focus();
					return false;
				}
				else if (document.getElementById('txtMesFechamPorta').value == '') {
					alert('Preencha o campo mês do fechamento de porta, por favor!');
					document.getElementById('txtMesFechamPorta').focus();
					return false;
				}
				else if (document.getElementById('txtAnoFechamPorta').value == '') {
					alert('Preencha o campo ano do fechamento de porta, por favor!');
					document.getElementById('txtAnoFechamPorta').focus();
					return false;
				}
				else if (document.getElementById('txtHoraFechamPorta').value == '') {
					alert('Preencha o campo hora do fechamento de porta, por favor!');
					document.getElementById('txtHoraFechamPorta').focus();
					return false;
				}
				else if (document.getElementById('txtMinutoFechamPorta').value == '') {
					alert('Preencha o campo minuto do fechamento de porta, por favor!');
					document.getElementById('txtMinutoFechamPorta').focus();
					return false;
				}
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

		</script>
	</head>
	<body>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0" />
				</td>
				<td class="corpo" align="center">
					<font size="4"><b>Decolagem</b></font>
					<font size="3"><b><% Response.Write(" (" & strCodAeroporto & ")")%></b></font><br /><br />
					<font size="2"><b>[Horário UTC]</b></font>
				</td>
				<td class="corpo" align="right" valign="bottom" width="35%">&nbsp;
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
		<form action="entradadosaeroportodecolagemcarga.asp" method="post" id="form1" name="form1">
			<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0' ID="Table1">
				<tr style="padding-top: 5px; padding-bottom: 5px">
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table2">
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Voo:
									</td>
									<td style="padding-left: 5px">
										<%=ObjRs("nrvoo")%>
									</td>
									<td colspan="2"></td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Aeronave:
									</td>
									<td style="padding-left: 5px">
										<%=ObjRs("prefixoaeronave")%>
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Origem:
									</td>
									<td style="padding-left: 5px">
										<%=ObjRs("Origem")%>
									</td>
									<td colspan="2"></td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Destino:
									</td>
									<td style="padding-left: 5px">
										<%=ObjRs("Destino")%>
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Part. Prev.:
									</td>
									<td style="padding-left: 5px">
										<%=strDataHora%>
									</td>
									<td colspan="2"></td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Part. Est.:
									</td>
									<td style="padding-left: 5px">
										<%=strDataHoraEst%>
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
							<table border='0' cellpadding='0' align="left" cellspacing='0' id="Table4">
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="white-space:nowrap; padding-left: 15px; padding-right: 15px;" align="right">
										<fieldset style="width:250px;">
											<legend style="color: #000000;"><span style="font-weight: bold">Carga:</span>&nbsp;</legend>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">STD:</span>
											<%=intCargaPagaSTD%>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">EXP:</span>
											<%=intCargaPagaEXP%>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">COMAT/ULD:</span>
											<span style="padding-right: 8px;"><%=intCargaGratis%></span>
										</fieldset>
									</td>
									<td style="white-space:nowrap; padding-left: 15px; padding-right: 15px;" align="right">
										<fieldset style="width:140px;">
											<legend style="color: #000000;"><span style="font-weight: bold">Correio:</span>&nbsp;</legend>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">VAC:</span>
											<%=intCorreioVAC%>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">RPN:</span>
											<span style="padding-right: 8px;"><%=intCorreioRPN%></span>
										</fieldset>
									</td>
									<td style="white-space:nowrap; padding-left: 15px; padding-right: 15px;" align="right" >
										<fieldset style="width:250px;">
											<legend style="color: #000000;"><span style="font-weight: bold">Total:</span>&nbsp;</legend>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">Peso:</span>
											<%=intTotalPeso%>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">ULD:</span>
											<%=intTotalULD%>
											<span class="CORPO10" style="padding-left: 8px; font-weight: bold">Peso Bruto:</span>
											<span style="padding-right: 8px;"><%=intTotalPesoBruto%></span>
										</fieldset>
									</td>
                              </tr>
                              <tr>
                              	<td colspan="4">
                                    <table border="0">
                                    <% If CLng(intPaxPago) > CLng(objRsCombSel("capac_pax")) Then %>
	                                    <tr>
    		                                <td colspan="4">
                        			           	 <font class="Corpo9" style="color:#FF0000"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aviso! Capacidade de passageiros excedida. Capacidade Máxima: <%=objRsCombSel("capac_pax")%>.</b></font>
                                    		</td>                        
                                    	</tr>
                                    <% end If %>
                                    <% If CLng(intCargaPaga) + CLng(intCargaGratis) > CLng(objRsCombSel("capac_cga")) Then %>    
                                    	<tr>
                                    		<td>
        				                       <font class="Corpo9" style="color:#FF0000"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aviso! Capacidade de carga excedida. Capacidade Máxima: <%=objRsCombSel("capac_cga")%>.</b></font>
                                    		</td>      
                                    	</tr>
                                    <% end If %>    
                                    </table>
                                </td>
                              </tr>                                    
							</table>
						</fieldset>
					</td>
                </tr>        
				<tr style="padding-top: 5px; padding-bottom: 5px">
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table3">
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Fechamento de Porta:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaFechamPorta" value="<%=strDiaFechamPorta%>" size="1" maxlength="2" id="txtDiaFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="1" />&nbsp;/
										<input type="text" name="txtMesFechamPorta" value="<%=strMesFechamPorta%>" size="1" maxlength="2" id="txtMesFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="2" />&nbsp;/
										<input type="text" name="txtAnoFechamPorta" value="<%=strAnoFechamPorta%>" size="3" maxlength="4" id="txtAnoFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="3" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraFechamPorta" value="<%=strHoraFechamPorta%>" size="1" maxlength="2" id="txtHoraFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="4" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoFechamPorta" value="<%=strMinutoFechamPorta%>" size="1" maxlength="2" id="txtMinutoFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="5" />&nbsp;m
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Partida motor:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaPartidaMotor" value="<%=strDiaPartidaMotor%>" size="1" maxlength="2" id="txtDiaPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="6" />&nbsp;/
										<input type="text" name="txtMesPartidaMotor" value="<%=strMesPartidaMotor%>" size="1" maxlength="2" id="txtMesPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="7" />&nbsp;/
										<input type="text" name="txtAnoPartidaMotor" value="<%=strAnoPartidaMotor%>" size="3" maxlength="4" id="txtAnoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="8" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraPartidaMotor" value="<%=strHoraPartidaMotor%>" size="1" maxlength="2" id="txtHoraPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="9" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoPartidaMotor" value="<%=strMinutoPartidaMotor%>" size="1" maxlength="2" id="txtMinutoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="10" />&nbsp;m
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Decolagem:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaDecolagem" value="<%=strDiaDecolagem%>" size="1" maxlength="2" id="txtDiaDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="11" />&nbsp;/
										<input type="text" name="txtMesDecolagem" value="<%=strMesDecolagem%>" size="1" maxlength="2" id="txtMesDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="12" />&nbsp;/
										<input type="text" name="txtAnoDecolagem" value="<%=strAnoDecolagem%>" size="3" maxlength="4" id="txtAnoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="13" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraDecolagem" value="<%=strHoraDecolagem%>" size="1" maxlength="2" id="txtHoraDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="14" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoDecolagem" value="<%=strMinutoDecolagem%>" size="1" maxlength="2" id="txtMinutoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="15" />&nbsp;m
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Justificativa:
									</td>
									<td style="padding-left: 5px">
										<select id="ddlJustificativa" name="ddlJustificativa" style="width: 700px" tabindex="16">
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
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right" valign="top">
										Observação:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtObservacao" id="txtObservacao" style="width: 700px" maxlength="200" value="<%=ObjRs("observacaotraf")%>" tabindex="17" />
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td width="100%" align="center" style="padding-top: 20px">
						<!--<input type="submit" value="Carregamento" name="btnCarregamento" class="botao1" style="WIDTH: 100px; HEIGHT: 25px" id="btnCarregamento" tabindex="18" />-->
						<input type="submit" value="Gravar" name="btnGravar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" id="btnGravar" tabindex="19" onclick="return VerificaCampos();" /> 
						<input type="submit" value="Voltar" name="btnVoltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" id="btnVoltar" tabindex="20" />
					</td>
				</tr>
			</table>
			<input type="hidden" id="hdTipoTransporte" name="hdTipoTransporte" value="<%=objRsCombSel("tipotransporte")%>" />
		</form>
	</body>
</html>
<%
	if (strGravar <> "") then
'		Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
	end if
%>
<%
	Function CamposPreenchidosCorretamente(datDataFechamPorta, datDataPartidaMotor, datDataDecolagem, intFusoGMT)

		Dim msgErro, strAux
		msgErro = ""
		strAux = ""

		if (datDataFechamPorta > datDataPartidaMotor) then
			msgErro = msgErro & strAux & "- A data do fechamento de porta ( " & CDate(DateAdd("h", -intFusoGMT, datDataFechamPorta)) & " ) deve ser menor ou igual à data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " )!"
			strAux = "\n"
		end if

		if (datDataPartidaMotor >= datDataDecolagem) then
			msgErro = msgErro & strAux & "- A data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) deve ser menor do que a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datDataDecolagem)) & " )!"
			strAux = "\n"
		end if

		if (Abs(DateDiff("n", datDataFechamPorta, datDataPartidaMotor)) > 60) then
			msgErro = msgErro & strAux & "- A diferença entre a data do fechamento de porta ( " & CDate(DateAdd("h", -intFusoGMT, datDataFechamPorta)) & " ) e a data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) não pode ser maior do que 1 hora!"
			strAux = "\n"
		end if

		if (Abs(DateDiff("n", datDataPartidaMotor, datDataDecolagem)) > 60) then
			msgErro = msgErro & strAux & "- A diferença entre a data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) e a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datDataDecolagem)) & " ) não pode ser maior do que 1 hora!"
			strAux = "\n"
		end if

		if (IsVazio(msgErro)) then
			CamposPreenchidosCorretamente = true
		else
			CamposPreenchidosCorretamente = false
			Response.Write("<script language='javascript'>alert('" & msgErro & "');</script>")
		end if

	end function

	Function IsVazio(var)

		if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
			IsVazio = true
		else
			IsVazio = false
		end if

	end Function
%>
