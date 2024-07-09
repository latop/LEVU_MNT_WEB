<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	Dim objConn
	Dim objRs, strSqlSelect, strSqlFrom, strSqlWhere, strQuery
	Dim intSeqUsuarioAerop, intSeqVooDia, intSeqTrecho
	intSeqUsuarioAerop = Session("member")
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)

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

		' ****************************************
		' *** CAPACIDADE MÁXIMA DE PASSAGEIROS ***
		' ****************************************
		Dim objRsCapMaxPax, strQueryCapMaxPax
		Dim intSeqFrota, intCapMaxPax
		intSeqFrota = Request.Form("hidSeqFrota")
		if (IsNull(intSeqFrota) or IsEmpty(intSeqFrota) or (not IsNumeric(intSeqFrota))) then
			intSeqFrota = CInt(0)
		else
			intSeqFrota = CInt(intSeqFrota)
		end if
		strQueryCapMaxPax =                     " SELECT sig_frota.capac_pax_max "
		strQueryCapMaxPax = strQueryCapMaxPax & " FROM sig_frota sig_frota "
		strQueryCapMaxPax = strQueryCapMaxPax & " WHERE seqfrota=" & intSeqFrota
		Set objRsCapMaxPax = Server.CreateObject("ADODB.Recordset")
		objRsCapMaxPax.Open strQueryCapMaxPax, objConn
		if (Not objRsCapMaxPax.EOF) then
			intCapMaxPax = CInt(objRsCapMaxPax("capac_pax_max"))
		else
			intCapMaxPax = CInt(1000)
		end if
		objRsCapMaxPax.Close()
		Set objRsCapMaxPax = Nothing

		Dim strTxtPaxPago, strTxtPaxPAD, strTxtPaxDHC, strTxtPaxEsp
		Dim strTxtDiaDecolagem, strTxtMesDecolagem, strTxtAnoDecolagem, strTxtHoraDecolagem, strTxtMinutoDecolagem
		Dim strTxtDiaPartidaMotor, strTxtMesPartidaMotor, strTxtAnoPartidaMotor, strTxtHoraPartidaMotor, strTxtMinutoPartidaMotor
		Dim strTxtDiaFechamPorta, strTxtMesFechamPorta, strTxtAnoFechamPorta, strTxtHoraFechamPorta, strTxtMinutoFechamPorta
		Dim strDdlJustificativa, strTxtObservacao

		strTxtPaxPago = Request.Form("txtPaxPago")
		if (IsNull(strTxtPaxPago) or IsEmpty(strTxtPaxPago) or (not IsNumeric(strTxtPaxPago))) then
			Response.Write("<script language='javascript'>alert('PAX Vazio');</script>")
			strTxtPaxPago = CInt(0)
		else
			strTxtPaxPago = CInt(strTxtPaxPago)
		end if

		strTxtPaxPAD = Request.Form("txtPaxPAD")
		if (IsNull(strTxtPaxPAD) or IsEmpty(strTxtPaxPAD) or (not IsNumeric(strTxtPaxPAD))) then
			strTxtPaxPAD = CInt(0)
		else
			strTxtPaxPAD = CInt(strTxtPaxPAD)
		end if

		strTxtPaxDHC = Request.Form("txtPaxDHC")
		if (IsNull(strTxtPaxDHC) or IsEmpty(strTxtPaxDHC) or (not IsNumeric(strTxtPaxDHC))) then
			strTxtPaxDHC = CInt(0)
		else
			strTxtPaxDHC = CInt(strTxtPaxDHC)
		end if

		strTxtPaxEsp = Request.Form("txtPaxEsp")
		if (IsNull(strTxtPaxEsp) or IsEmpty(strTxtPaxEsp) or (not IsNumeric(strTxtPaxEsp))) then
			strTxtPaxEsp = CInt(0)
		else
			strTxtPaxEsp = CInt(strTxtPaxEsp)
		end if

        Dim txtCombustivelDecolagem
        txtCombustivelDecolagem = Request.Form("txtCombustivelDecolagem")

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
		if (Not IsVazio(strTxtAnoDecolagem) And Not IsVazio(strTxtMesDecolagem) And Not IsVazio(strTxtDiaDecolagem) And _
			Not IsVazio(strTxtHoraDecolagem) And Not IsVazio(strTxtMinutoDecolagem)) then
			strTxtDataDecolagem = strTxtAnoDecolagem & "-" & strTxtMesDecolagem & "-" & strTxtDiaDecolagem & " " & strTxtHoraDecolagem & ":" & strTxtMinutoDecolagem
			datTxtDataDecolagem = CDate(strTxtDataDecolagem)
			datTxtDataDecolagem = CDate(DateAdd("h", intFusoGMT, datTxtDataDecolagem))
			strTxtDataDecolagem = CStr(Year(datTxtDataDecolagem)) & "-" & CStr(Month(datTxtDataDecolagem)) & "-" & CStr(Day(datTxtDataDecolagem)) & " " & CStr(Hour(datTxtDataDecolagem)) & ":" & CStr(Minute(datTxtDataDecolagem))
		else
			strTxtDataDecolagem = ""
			datTxtDataDecolagem = ""
		end if

		Dim strTxtDataPartidaMotor, datTxtDataPartidaMotor
		if (Not IsVazio(strTxtAnoPartidaMotor) And Not IsVazio(strTxtMesPartidaMotor) And Not IsVazio(strTxtDiaPartidaMotor) And _
			Not IsVazio(strTxtHoraPartidaMotor) And Not IsVazio(strTxtMinutoPartidaMotor)) then
			strTxtDataPartidaMotor = strTxtAnoPartidaMotor & "-" & strTxtMesPartidaMotor & "-" & strTxtDiaPartidaMotor & " " & strTxtHoraPartidaMotor & ":" & strTxtMinutoPartidaMotor
			datTxtDataPartidaMotor = CDate(strTxtDataPartidaMotor)
			datTxtDataPartidaMotor = CDate(DateAdd("h", intFusoGMT, datTxtDataPartidaMotor))
			strTxtDataPartidaMotor = CStr(Year(datTxtDataPartidaMotor)) & "-" & CStr(Month(datTxtDataPartidaMotor)) & "-" & CStr(Day(datTxtDataPartidaMotor)) & " " & CStr(Hour(datTxtDataPartidaMotor)) & ":" & CStr(Minute(datTxtDataPartidaMotor))
		else
			strTxtDataPartidaMotor = ""
			datTxtDataPartidaMotor = ""
		end if

		Dim strTxtDataFechamPorta, datTxtDataFechamPorta
		strTxtDataFechamPorta = strTxtAnoFechamPorta & "-" & strTxtMesFechamPorta & "-" & strTxtDiaFechamPorta & " " & strTxtHoraFechamPorta & ":" & strTxtMinutoFechamPorta
		if IsDate(strTxtDataFechamPorta) then
			datTxtDataFechamPorta = CDate(strTxtDataFechamPorta)
			datTxtDataFechamPorta = CDate(DateAdd("h", intFusoGMT, datTxtDataFechamPorta))
			strTxtDataFechamPorta = CStr(Year(datTxtDataFechamPorta)) & "-" & CStr(Month(datTxtDataFechamPorta)) & "-" & CStr(Day(datTxtDataFechamPorta)) & " " & CStr(Hour(datTxtDataFechamPorta)) & ":" & CStr(Minute(datTxtDataFechamPorta))
		end if

		if ((CamposPreenchidosCorretamente(datTxtDataFechamPorta, datTxtDataPartidaMotor, datTxtDataDecolagem, intFusoGMT))) then

			Dim objConexaoSqlServerUpdate, objRecordSetSqlServerUpdate
			Dim strSqlUpdate, strSqlSet, strSqlFromUpdate, strSqlWhereUpdate, strQueryUpdate
			set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
			objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
			objConexaoSqlServerUpdate.Execute "SET DATEFORMAT ymd"

			strSqlUpdate =                          " UPDATE sig_diariotrecho "
			strSqlSet =                             " SET paxpago=" & strTxtPaxPago & ", "
			strSqlSet = strSqlSet &                 "     paxeconomica=" & strTxtPaxPago & ", "
			strSqlSet = strSqlSet &                 "     paxpad=" & strTxtPaxPAD & ", "
			strSqlSet = strSqlSet &                 "     paxgratis=" & strTxtPaxPAD & ", "
			strSqlSet = strSqlSet &                 "     paxdhc=" & strTxtPaxDHC & ", "
			strSqlSet = strSqlSet &                 "     paxespecial=" & strTxtPaxEsp & ", "
            If (Trim(txtCombustivelDecolagem) <> "") Then
	            strSqlSet = strSqlSet &                 "     sig_diariotrecho.combpartidamotor = " & Trim(txtCombustivelDecolagem) & ", "
            End If
			if (IsVazio(strTxtDataDecolagem)) then
				strSqlSet = strSqlSet &                 "     decolagem=NULL, "
			else
				strSqlSet = strSqlSet &                 "     decolagem=" & Plic(strTxtDataDecolagem) & ", "
			end if
			if (IsVazio(strTxtDataPartidaMotor)) then
				strSqlSet = strSqlSet &                 "     partidamotor=NULL, "
				strSqlSet = strSqlSet &                 "     atzdec=NULL, "
				strSqlSet = strSqlSet &                 "     atzdecint=NULL, "
			else
				strSqlSet = strSqlSet &                 "     partidamotor=" & Plic(strTxtDataPartidaMotor) & ", "
				strSqlSet = strSqlSet &                 "     atzdec=DATEDIFF(mi, partidaplanej, " & Plic(strTxtDataPartidaMotor) & "), "
				strSqlSet = strSqlSet &                 "     atzdecint=DATEDIFF(mi, partidaprev, " & Plic(strTxtDataPartidaMotor) & "), "
			end if
			if IsDate(strTxtDataFechamPorta) then
				strSqlSet = strSqlSet &         "     fechamporta=" & Plic(strTxtDataFechamPorta) & ", "
			end if
			strSqlSet = strSqlSet &                 "     flgcapturadec='S', "
			if (strDdlJustificativa = "0") then
				strSqlSet = strSqlSet &             "     idjustifinternatraf=NULL, "
				strSqlSet = strSqlSet &             "     idjustificativatraf=NULL, "
			else
				strSqlSet = strSqlSet &             "     idjustifinternatraf=" & Plic(strDdlJustificativa) & ", "
				strSqlSet = strSqlSet &             "     idjustificativatraf=SJUST.idjustificativa, "
			end if
			if (strTxtObservacao = "") then
				strSqlSet = strSqlSet &             "     observacaotraf=NULL "
			else
				strSqlSet = strSqlSet &             "     observacaotraf=" & Plic(strTxtObservacao) & " "
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

			' *****************************************
			' *** SEQUENCIAL DA TABELA DE AUDITORIA ***
			' *****************************************
			Dim objRsSeq, strQuerySeq, intSeq
			strQuerySeq = " SELECT MAX(sig_auditoria.seqauditoria) seqauditoriamax FROM sig_auditoria "
			Set objRsSeq = Server.CreateObject("ADODB.Recordset")
			objRsSeq.Open strQuerySeq, objConn
			if (Not objRsSeq.EOF) then
				intSeq = objRsSeq("seqauditoriamax")
				if IsNull(intSeq) Then
					intSeq = 0
				Else
					intSeq = CLng(intSeq)
				End If
			else
				intSeq = CLng(0)
			end if
			objRsSeq.Close()
			Set objRsSeq = Nothing
			intSeq = intSeq + 1

			' ************************************
			' *** DADOS DA TABELA DE AUDITORIA ***
			' ************************************
			Dim ConnInsert, RsInsert, sSqlInsert, strDescricao
			Set ConnInsert = CreateObject("ADODB.CONNECTION")
			ConnInsert.Open (StringConexaoSqlServer)
			ConnInsert.Execute "SET DATEFORMAT ymd"

			if (IsVazio(strTxtDataDecolagem)) then strTxtDataDecolagem = "NULL"
			if (IsVazio(strTxtDataPartidaMotor)) then strTxtDataPartidaMotor = "NULL"

			strDescricao = "[seqvoodia:" & intSeqVooDia & " seqtrecho:" & intSeqTrecho & "]"
			strDescricao = strDescricao & " / PAGO:" & strTxtPaxPago & " / PAD:" & strTxtPaxPAD & " / DHC:" & strTxtPaxDHC
			strDescricao = strDescricao & " / Fecham. Porta:" & strTxtDataFechamPorta & " / Decolagem:" & strTxtDataDecolagem & " / Part. Motor:" & strTxtDataPartidaMotor
			strDescricao = strDescricao & " / Just. Int.:" & strDdlJustificativa

			sSqlInsert = " INSERT INTO sig_auditoria (seqauditoria, nometabela, dthralteracao, sequsuario, dominio, comando, descricao) "
			sSqlInsert = sSqlInsert & "  VALUES (" & intSeq & ", 'SIG_DIARIOTRECHO', getdate(), " & intSeqUsuarioAerop & ", 'A', 'UPDATE', '" & strDescricao & "') "
			set RsInsert = ConnInsert.Execute(sSqlInsert)
			ConnInsert.close

			Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
		end if

	end if

	strSqlSelect =                " SELECT sig_diariovoo.nrvoo, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.dtoper, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqtrecho, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.prefixoaeronave, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.combpartidamotor, "
	strSqlSelect = strSqlSelect & "        aeroporig.codiata Origem, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata Destino, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.partidaprev) partidaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.chegadaprev) chegadaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.partidamotor) partidamotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.decolagem) decolagem, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.pouso) pouso, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.cortemotor) cortemotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & -intFusoGMT & ", sig_diariotrecho.fechamporta) fechamporta, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxeconomica, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxgratis, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxpago, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxpad, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxdhc, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.paxespecial, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.baglivre, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.bagexcesso, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.cargapaga, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.cargagratis, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.correioao, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.correiolc, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustificativa, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustifinterna, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustificativatraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.idjustifinternatraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.observacao, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.observacaotraf, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzdec, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzpou, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzdecint, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.atzpouint, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqfrota "
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

	' ************************
	' *** PARTIDA PREVISTA ***
	' ************************
	Dim strHora, strData, strDataHora
	strHora = FormatDateTime(ObjRs("partidaprev"), 4)
	strData = FormatDateTime(ObjRs("partidaprev"), 2)
	strDataHora = strData & "&nbsp;&nbsp;&nbsp;" & strHora
	
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
	Dim intPaxPago, intPaxPad, intPaxDHC, intPaxEsp, intBagLivre, intBagExcesso, intCargaPaga, intCargaGratis
	intPaxPago = ObjRs("paxpago")
	intPaxPad = ObjRs("paxpad")
	intPaxDHC = ObjRs("paxdhc")
	intPaxEsp = ObjRs("paxespecial")
	intBagLivre = ObjRs("baglivre")
	intBagExcesso = ObjRs("bagexcesso")
	intCargaPaga = ObjRs("cargapaga")
	intCargaGratis = ObjRs("cargagratis")
	if (IsNull(intPaxPago) or IsEmpty(intPaxPago)) then
		intPaxPago = CInt(0)
	else
		intPaxPago = CInt(intPaxPago)
	end if
	if (IsNull(intPaxPad) or IsEmpty(intPaxPad)) then
		intPaxPad = CInt(0)
	else
		intPaxPad = CInt(intPaxPad)
	end if
	if (IsNull(intPaxDHC) or IsEmpty(intPaxDHC)) then
		intPaxDHC = CInt(0)
	else
		intPaxDHC = CInt(intPaxDHC)
	end if
	if (IsNull(intPaxEsp) or IsEmpty(intPaxEsp)) then
		intPaxEsp = CInt(0)
	else
		intPaxEsp = CInt(intPaxEsp)
	end if
	if (IsNull(intBagLivre) or IsEmpty(intBagLivre)) then
		intBagLivre = CInt(0)
	else
		intBagLivre = CInt(intBagLivre)
	end if
	if (IsNull(intBagExcesso) or IsEmpty(intBagExcesso)) then
		intBagExcesso = CInt(0)
	else
		intBagExcesso = CInt(intBagExcesso)
	end if
	if (IsNull(intCargaPaga) or IsEmpty(intCargaPaga)) then
		intCargaPaga = CInt(0)
	else
		intCargaPaga = CInt(intCargaPaga)
	end if
	if (IsNull(intCargaGratis) or IsEmpty(intCargaGratis)) then
		intCargaGratis = CInt(0)
	else
		intCargaGratis = CInt(intCargaGratis)
	end if
	
	' ******************************
	' *** Capacidade da Aeronave ***
	' ******************************
	
	Dim objRsCombSel, strQueryCombSel
		strQueryCombSel =                   " SELECT SDTC.seqvoodia, SDTC.seqtrecho, SDTC.seqcombinada, "
		strQueryCombSel = strQueryCombSel & "        AERDEST.codiata, AERDEST.nomeaeroporto, SDTC.seqaeropdest, "
		strQueryCombSel = strQueryCombSel & "        SDTC.paxpago, SDTC.paxeconomica, "
		strQueryCombSel = strQueryCombSel & "        SDTC.paxpad, SDTC.paxgratis, SDTC.paxdhc, SDTC.paxtrc, "
		strQueryCombSel = strQueryCombSel & "        SDTC.baglivre, SDTC.bagexcesso, "
		strQueryCombSel = strQueryCombSel & "        SDTC.cargapaga, SDTC.cargagratis, "
		strQueryCombSel = strQueryCombSel & "        SDTC.paxchd, SDTC.paxinf, "
		strQueryCombSel = strQueryCombSel & "        SDTC.seqaeropdesttran, SDTC.paxeconomicatran, "
		strQueryCombSel = strQueryCombSel & "        SDTC.paxgratistran, SDTC.baglivretran, SDTC.bagexcessotran, "
		strQueryCombSel = strQueryCombSel & "        SDTC.cargapagatran, SDTC.cargagratistran, "
		strQueryCombSel = strQueryCombSel & "        SDTC.paxchdtran, SDTC.paxinftran, "
		strQueryCombSel = strQueryCombSel & "        SDTC.Porao1, SDTC.Porao2, SDTC.Porao3, SDTC.Porao4, "
		strQueryCombSel = strQueryCombSel & "        SDTC.Porao1tran, SDTC.Porao2tran, SDTC.Porao3tran, SDTC.Porao4tran, "
		strQueryCombSel = strQueryCombSel & "        SA.flgporao1, SA.flgporao2, SA.flgporao3, SA.flgporao4, SA.capac_pax, SA.capac_cga "
		strQueryCombSel = strQueryCombSel & " FROM sig_diariotrechocomb SDTC, sig_aeroporto AERDEST, sig_diariotrecho SDT, sig_aeronave SA "
		strQueryCombSel = strQueryCombSel & " WHERE SDTC.seqaeropdest = AERDEST.seqaeroporto "
		strQueryCombSel = strQueryCombSel & "   AND SDTC.seqvoodia = SDT.seqvoodia "
		strQueryCombSel = strQueryCombSel & "   AND SDTC.seqtrecho = SDT.seqtrecho "
		strQueryCombSel = strQueryCombSel & "   AND SDT.prefixoaeronave = SA.prefixored "
		strQueryCombSel = strQueryCombSel & "   AND SDTC.seqvoodia=" & intSeqVooDia & " "
		strQueryCombSel = strQueryCombSel & "   AND SDTC.seqtrecho=" & intSeqTrecho & " "
		'strQueryCombSel = strQueryCombSel & "   AND SDTC.seqcombinada=" & intSeqCombinada & " "
		strQueryCombSel = strQueryCombSel & "   AND SDTC.seqvoodia = SDT.seqvoodia "

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
				window.form1.txtPaxPago.focus();
			}

			function VerificaCampos() {
				if (window.form1.txtDiaFechamPorta.value == '') {
					alert('Preencha o campo dia do fechamento de porta, por favor!');
					window.form1.txtDiaFechamPorta.focus();
					return false;
				}
				else if (window.form1.txtMesFechamPorta.value == '') {
					alert('Preencha o campo mês do fechamento de porta, por favor!');
					window.form1.txtMesFechamPorta.focus();
					return false;
				}
				else if (window.form1.txtAnoFechamPorta.value == '') {
					alert('Preencha o campo ano do fechamento de porta, por favor!');
					window.form1.txtAnoFechamPorta.focus();
					return false;
				}
				else if (window.form1.txtHoraFechamPorta.value == '') {
					alert('Preencha o campo hora do fechamento de porta, por favor!');
					window.form1.txtHoraFechamPorta.focus();
					return false;
				}
				else if (window.form1.txtMinutoFechamPorta.value == '') {
					alert('Preencha o campo minuto do fechamento de porta, por favor!');
					window.form1.txtMinutoFechamPorta.focus();
					return false;
				}

				if ((window.form1.txtDiaDecolagem.value != '') &&
					(window.form1.txtMesDecolagem.value != '') &&
					(window.form1.txtAnoDecolagem.value != '') &&
					(window.form1.txtHoraDecolagem.value != '') &&
					(window.form1.txtMinutoDecolagem.value != '')) {
					if (window.form1.txtDiaPartidaMotor.value == '') {
						alert('Preencha o campo dia da partida motor, por favor!');
						window.form1.txtDiaPartidaMotor.focus();
						return false;
					}
					else if (window.form1.txtMesPartidaMotor.value == '') {
						alert('Preencha o campo mês da partida motor, por favor!');
						window.form1.txtMesPartidaMotor.focus();
						return false;
					}
					else if (window.form1.txtAnoPartidaMotor.value == '') {
						alert('Preencha o campo ano da partida motor, por favor!');
						window.form1.txtAnoPartidaMotor.focus();
						return false;
					}
					else if (window.form1.txtHoraPartidaMotor.value == '') {
						alert('Preencha o campo hora da partida motor, por favor!');
						window.form1.txtHoraPartidaMotor.focus();
						return false;
					}
					else if (window.form1.txtMinutoPartidaMotor.value == '') {
						alert('Preencha o campo minuto da partida motor, por favor!');
						window.form1.txtMinutoPartidaMotor.focus();
						return false;
					}
				}
			}

		</script>
	</head>
	<body onLoad="CarregaPagina();">
		<table width="98%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center">
					<font size="4"><b>Decolagem</b></font>
					<font size="3"><b><% Response.Write(" (" & strCodAeroporto & ")")%></b></font><br /><br />
					<font size="2"><b>[Horário UTC]</b></font>
				</td>
				<td class="corpo" align="right" valign="bottom" width="35%">
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
		<br />
		<br />
		<br />
		<form action="entradadosaeroportodecolagemred.asp" method="post" id="form1" name="form1">
			<input type="hidden" id="hidSeqFrota" name="hidSeqFrota" value="<%=ObjRs("seqfrota")%>" />
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
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Destino:
									</td>
									<td style="padding-left: 5px">
										<%=ObjRs("Destino")%>
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Partida prevista:
									</td>
									<td style="padding-left: 5px">
										<%=strDataHora%>
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
							<legend style="color: #000000;"><font style="font-weight: bold">Passageiros:</font>&nbsp;</legend>
							<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table5">
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Pago:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtPaxPago" value="<%=intPaxPago%>" size="1" maxlength="3" id="txtPaxPago" onKeyPress="return SoNumeros(window.event.keyCode, this);" tabindex="1" />
									</td>
									<td style="padding-left: 50px; font-weight: bold" align="right">
										PAD:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtPaxPad" value="<%=intPaxPad%>" size="1" maxlength="3" id="txtPaxPad" onKeyPress="return SoNumeros(window.event.keyCode, this);" tabindex="2" />
									</td>
									<td style="padding-left: 50px; font-weight: bold" align="right">
										DHC:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtPaxDHC" value="<%=intPaxDHC%>" size="1" maxlength="3" id="txtPaxDHC" onKeyPress="return SoNumeros(window.event.keyCode, this);" tabindex="3" />
									</td>
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Esp:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtPaxEsp" value="<%=intPaxEsp%>" size="1" maxlength="3" id="txtPaxEsp" onKeyPress="return SoNumeros(window.event.keyCode, this);" tabindex="4" />
									</td>
								</tr>
                                 <tr>
                              	<td colspan="4">
                                    <table border="0">
                                    <% If CInt(intPaxPago) > CInt(objRsCombSel("capac_pax")) Then %>
	                                    <tr>
    		                                <td colspan="4">
                        			           	 <font class="Corpo9" style="color:#FF0000"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aviso! Capacidade de passageiros excedida. Capacidade Máxima: <%=CInt(objRsCombSel("capac_pax"))%>.</b></font>
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
										<input type="text" name="txtDiaFechamPorta" value="<%=strDiaFechamPorta%>" size="1" maxlength="2" id="txtDiaFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="5" />&nbsp;/
										<input type="text" name="txtMesFechamPorta" value="<%=strMesFechamPorta%>" size="1" maxlength="2" id="txtMesFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="6" />&nbsp;/
										<input type="text" name="txtAnoFechamPorta" value="<%=strAnoFechamPorta%>" size="3" maxlength="4" id="txtAnoFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="7" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraFechamPorta" value="<%=strHoraFechamPorta%>" size="1" maxlength="2" id="txtHoraFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="8" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoFechamPorta" value="<%=strMinutoFechamPorta%>" size="1" maxlength="2" id="txtMinutoFechamPorta" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="9" />&nbsp;m
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Partida motor:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaPartidaMotor" value="<%=strDiaPartidaMotor%>" size="1" maxlength="2" id="txtDiaPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="10" />&nbsp;/
										<input type="text" name="txtMesPartidaMotor" value="<%=strMesPartidaMotor%>" size="1" maxlength="2" id="txtMesPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="11" />&nbsp;/
										<input type="text" name="txtAnoPartidaMotor" value="<%=strAnoPartidaMotor%>" size="3" maxlength="4" id="txtAnoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="12" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraPartidaMotor" value="<%=strHoraPartidaMotor%>" size="1" maxlength="2" id="txtHoraPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="13" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoPartidaMotor" value="<%=strMinutoPartidaMotor%>" size="1" maxlength="2" id="txtMinutoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="14" />&nbsp;m
									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Decolagem:
									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaDecolagem" value="<%=strDiaDecolagem%>" size="1" maxlength="2" id="txtDiaDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="15" />&nbsp;/
										<input type="text" name="txtMesDecolagem" value="<%=strMesDecolagem%>" size="1" maxlength="2" id="txtMesDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="16" />&nbsp;/
										<input type="text" name="txtAnoDecolagem" value="<%=strAnoDecolagem%>" size="3" maxlength="4" id="txtAnoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="17" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraDecolagem" value="<%=strHoraDecolagem%>" size="1" maxlength="2" id="txtHoraDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="18" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoDecolagem" value="<%=strMinutoDecolagem%>" size="1" maxlength="2" id="txtMinutoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="19" />&nbsp;m
									</td>
								</tr>

                                <tr>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
										Combustível de decolagem:
									</td>
									<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
										<input type="text" name="txtCombustivelDecolagem" value="<%=ObjRs("combpartidamotor")%>" size="6" maxlength="6" id="txtCombustivelDecolagem" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" tabindex="20" />
									</td>
								</tr>

								<tr style="padding-top: 5px; padding-bottom: 5px">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Justificativa:
									</td>
									<td style="padding-left: 5px">
										<select id="ddlJustificativa" name="ddlJustificativa" style="width: 500px" enabled>
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
										<input type="text" name="txtObservacao" id="txtObservacao" style="width: 500px" maxlength="200" value="<%=ObjRs("observacaotraf")%>" enabled />
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td width="100%" align="center" style="padding-top: 20px">
						<input type="submit" value="Gravar" name="btnGravar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnGravar" tabindex="21" onClick="return VerificaCampos();" />
						<input type="submit" value="Serv. Aerop." name="btnServAerop" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnServAerop" tabindex="22" />
						<input type="submit" value="Voltar" name="btnVoltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnVoltar" tabindex="23" />
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<%
	Function CamposPreenchidosCorretamente(datDataFechamPorta, datDataPartidaMotor, datDataDecolagem, intFusoGMT)

		Dim msgErro, strAux
		msgErro = ""
		strAux = ""

		if (Not IsVazio(datDataPartidaMotor)) then
			if (datDataFechamPorta > datDataPartidaMotor) then
				msgErro = msgErro & strAux & "- A data do fechamento de porta ( " & CDate(DateAdd("h", -intFusoGMT, datDataFechamPorta)) & " ) deve ser menor ou igual à data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " )!"
				strAux = "\n"
			end if
		end if

		if (Not IsVazio(datDataPartidaMotor) And Not IsVazio(datDataDecolagem)) then
			if (datDataPartidaMotor >= datDataDecolagem) then
				msgErro = msgErro & strAux & "- A data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) deve ser menor do que a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datDataDecolagem)) & " )!"
				strAux = "\n"
			end if
		end if

		if (Not IsVazio(datDataPartidaMotor)) then
			if (Abs(DateDiff("n", datDataFechamPorta, datDataPartidaMotor)) > 60) then
				msgErro = msgErro & strAux & "- A diferença entre a data do fechamento de porta ( " & CDate(DateAdd("h", -intFusoGMT, datDataFechamPorta)) & " ) e a data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) não pode ser maior do que 1 hora!"
				strAux = "\n"
			end if
		end if

		if (Not IsVazio(datDataPartidaMotor) And Not IsVazio(datDataDecolagem)) then
			if (Abs(DateDiff("n", datDataPartidaMotor, datDataDecolagem)) > 60) then
				msgErro = msgErro & strAux & "- A diferença entre a data da partida motor ( " & CDate(DateAdd("h", -intFusoGMT, datDataPartidaMotor)) & " ) e a data da decolagem ( " & CDate(DateAdd("h", -intFusoGMT, datDataDecolagem)) & " ) não pode ser maior do que 1 hora!"
				strAux = "\n"
			end if
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
