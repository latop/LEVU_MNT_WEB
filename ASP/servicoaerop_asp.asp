<!--#include file="verificaloginaeropfunc.asp"-->

<%
	Dim strGravar
	strGravar = Request.Form("btnGravar")
	if (strGravar <> "") then
		call GravarServicosAeroportuarios()
	end if

	Dim intSeqVooDia, intSeqTrecho
	Dim objConn

	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")

	Dim intEmpresa
	intEmpresa = Session("Empresa")

	Dim qtdVolta
	qtdVolta = Request.Form("hidQtdVolta")
	if (IsVazio(qtdVolta)) then
		qtdVolta = CInt(1)
	else
		qtdVolta = CInt(qtdVolta + 1)
	end if

	Dim blnHabilitaBtnGravar
	blnHabilitaBtnGravar = "visible"

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
	set objRsFuso = Nothing

	' **************
	' *** TRECHO ***
	' **************
	Dim objRsVoo, strQueryVoo, strSqlSelectVoo, strSqlFromVoo, strSqlWhereVoo
	strSqlSelectVoo = " SELECT "
	strSqlSelectVoo = strSqlSelectVoo & " DV.seqvoodia SeqVooDia, "
	strSqlSelectVoo = strSqlSelectVoo & " DT.seqtrecho SeqTrecho, "
	strSqlSelectVoo = strSqlSelectVoo & " DT.seqaeroporig SeqAeroporig, "
	strSqlSelectVoo = strSqlSelectVoo & " DV.nrvoo Numero_Voo, "
	strSqlSelectVoo = strSqlSelectVoo & " Fr.codfrota Codigo_Frota, "
	strSqlSelectVoo = strSqlSelectVoo & " DT.prefixoaeronave PrefixoAeronave, "
	strSqlSelectVoo = strSqlSelectVoo & " ApOrig.codiata Codigo_IATA_Origem, "
	strSqlSelectVoo = strSqlSelectVoo & " ApDest.codiata Codigo_IATA_Destino, "
	strSqlSelectVoo = strSqlSelectVoo & " DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) partidaprev, "
	strSqlSelectVoo = strSqlSelectVoo & " DATEADD(hh, " & -intFusoGMT & ", DT.chegadaprev) chegadaprev, "
	strSqlSelectVoo = strSqlSelectVoo & " DATEADD(hh, " & -intFusoGMT & ", DT.partidamotor) partidamotor, "
	strSqlSelectVoo = strSqlSelectVoo & " DATEADD(hh, " & -intFusoGMT & ", DT.cortemotor) cortemotor "

	strSqlFromVoo = " FROM "
	strSqlFromVoo = strSqlFromVoo & " sig_diariotrecho DT, "
	strSqlFromVoo = strSqlFromVoo & " sig_diariovoo DV, "
	strSqlFromVoo = strSqlFromVoo & " sig_frota Fr, "
	strSqlFromVoo = strSqlFromVoo & " sig_aeroporto ApOrig, "
	strSqlFromVoo = strSqlFromVoo & " sig_aeroporto ApDest "

	strSqlWhereVoo = " WHERE "
	strSqlWhereVoo = strSqlWhereVoo & "       ( DT.seqvoodia = " & intSeqVooDia & " ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DV.seqvoodia = " & intSeqVooDia & " ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DT.seqtrecho = " & intSeqTrecho & " ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DV.seqvoodia = DT.seqvoodia ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DT.seqaeroporig = ApOrig.seqaeroporto ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DT.seqaeropdest = ApDest.seqaeroporto ) "
	strSqlWhereVoo = strSqlWhereVoo & " AND   ( DT.seqfrota = Fr.seqfrota ) "

	strQueryVoo = strSqlSelectVoo & strSqlFromVoo & strSqlWhereVoo

	Set objRsVoo = Server.CreateObject("ADODB.Recordset")
	objRsVoo.Open strQueryVoo, objConn
	If objRsVoo.eof then
		Response.Write("Nenhum registro encontrado")
		Response.End()
	end if

	Dim ldt_partidamotor, ls_partidamotor
	ldt_partidamotor = objRsVoo("PartidaMotor")
	if Not IsNull(ldt_partidamotor) Then
		ls_partidamotor = Right("00"&Day(ldt_partidamotor),2) & "/" & Right("00"&Month(ldt_partidamotor),2) & "/" & Year(ldt_partidamotor)
		ls_partidamotor = ls_partidamotor & " " & FormatDateTime( ldt_partidamotor, 4 )
	Else
		ls_partidamotor = "&nbsp;"
	End If

	Dim ldt_cortemotor, ls_cortemotor
	ldt_cortemotor = objRsVoo("Cortemotor")
	if Not IsNull(ldt_cortemotor) Then
		ls_cortemotor = Right("00"&Day(ldt_cortemotor),2) & "/" & Right("00"&Month(ldt_cortemotor),2) & "/" & Year(ldt_cortemotor)
		ls_cortemotor = ls_cortemotor & " " & FormatDateTime( ldt_cortemotor, 4 )
	Else
		ls_cortemotor = "&nbsp;"
	End If

	Dim ldt_partidaprev, ls_partidaprev
	ldt_partidaprev = objRsVoo("PartidaPrev")
	if Not IsNull(ldt_partidaprev) Then
		ls_partidaprev = Right("00"&Day(ldt_partidaprev),2) & "/" & Right("00"&Month(ldt_partidaprev),2) & "/" & Year(ldt_partidaprev)
		ls_partidaprev = ls_partidaprev & " " & FormatDateTime( ldt_partidaprev, 4 )
	Else
		ls_partidaprev = "&nbsp;"
	End If

	Dim ldt_chegadaprev, ls_chegadaprev
	ldt_chegadaprev = objRsVoo("ChegadaPrev")
	if Not IsNull(ldt_cortemotor) Then
		ls_chegadaprev = Right("00"&Day(ldt_chegadaprev),2) & "/" & Right("00"&Month(ldt_chegadaprev),2) & "/" & Year(ldt_chegadaprev)
		ls_chegadaprev = ls_chegadaprev & " " & FormatDateTime( ldt_chegadaprev, 4 )
	Else
		ls_chegadaprev = "&nbsp;"
	End If

	Dim ldt_Numero_Voo, ls_Numero_Voo
	ldt_Numero_Voo = objRsVoo("Numero_Voo")
	If Not IsNull(ldt_Numero_Voo) Then
	  ls_Numero_Voo = ldt_Numero_Voo
	Else
	  ls_Numero_Voo = "&nbsp;"
	End If

	Dim ldt_Codigo_Frota, ls_Codigo_Frota
	ldt_Codigo_Frota = objRsVoo("Codigo_Frota")
	If Not IsNull(ldt_Codigo_Frota) Then
	  ls_Codigo_Frota = ldt_Codigo_Frota
	Else
	  ls_Codigo_Frota = "&nbsp;"
	End If

	Dim ldt_PrefixoAeronave, ls_PrefixoAeronave
	ldt_PrefixoAeronave = objRsVoo("PrefixoAeronave")
	If Not IsNull(ldt_PrefixoAeronave) Then
	  ls_PrefixoAeronave = ldt_PrefixoAeronave
	Else
	  ls_PrefixoAeronave = "&nbsp;"
	End IF

	Dim ldt_Codigo_IATA_Origem, ls_Codigo_IATA_Origem
	ldt_Codigo_IATA_Origem = objRsVoo("Codigo_IATA_Origem")
	If Not IsNull(ldt_Codigo_IATA_Origem) Then
	   ls_Codigo_IATA_Origem = ldt_Codigo_IATA_Origem
	Else
	   ls_Codigo_IATA_Origem = "&nbsp;"
	End If

	Dim ldt_Codigo_IATA_Destino, ls_Codigo_IATA_Destino
	ldt_Codigo_IATA_Destino = objRsVoo("Codigo_IATA_Destino")
	If Not IsNull(ldt_Codigo_IATA_Destino) Then
	   ls_Codigo_IATA_Destino = ldt_Codigo_IATA_Destino
	Else
	   ls_Codigo_IATA_Destino = "&nbsp;"
	End If

	objRsVoo.Close()
	set objRsVoo = Nothing

	objConn.close
	set objConn = nothing



Sub PreencherServicosAeroportuarios(p_intSeqVooDia, p_intSeqTrecho)

	Dim objConnServicos

	Set objConnServicos = CreateObject("ADODB.CONNECTION")
	objConnServicos.Open (StringConexaoSqlServer)
	objConnServicos.Execute "SET DATEFORMAT ymd"

	' *******************************
	' *** SERVIÇOS AEROPORTUÁRIOS ***
	' *******************************
	Dim objRsServicos, strQueryServicos, strSqlSelectServicos, strSqlFromServicos, strSqlWhereServicos, strSqlOrderServicos
	strSqlSelectServicos = " SELECT "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.seqaeroporto, "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.codempresa, "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.codservicoaerop, "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.dtinicio, "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.dtfim, "
	strSqlSelectServicos = strSqlSelectServicos & " VSA.valor, "
	strSqlSelectServicos = strSqlSelectServicos & " ESA.descrempresa, "
	strSqlSelectServicos = strSqlSelectServicos & " TSA.descrservicoaerop, "
	strSqlSelectServicos = strSqlSelectServicos & " SAT.qtdservico "

	strSqlFromServicos = " FROM "
	strSqlFromServicos = strSqlFromServicos & " sig_valorservicoaerop VSA "
	strSqlFromServicos = strSqlFromServicos & " INNER JOIN sig_diariotrecho DT ON DT.seqaeroporig = VSA.seqaeroporto "
	strSqlFromServicos = strSqlFromServicos & " INNER JOIN sig_diariovoo DV ON DV.seqvoodia = DT.seqvoodia "
	strSqlFromServicos = strSqlFromServicos & " INNER JOIN sig_empresaservicoaerop ESA ON ESA.codempresa = VSA.codempresa "
	strSqlFromServicos = strSqlFromServicos & " INNER JOIN sig_tiposervicoaerop TSA ON TSA.codservicoaerop = VSA.codservicoaerop "
	strSqlFromServicos = strSqlFromServicos & " LEFT OUTER JOIN sig_servicoaeroptrecho SAT ON SAT.codempresa = VSA.codempresa AND SAT.codservicoaerop = VSA.codservicoaerop "
	strSqlFromServicos = strSqlFromServicos & " AND SAT.seqvoodia = DT.seqvoodia AND SAT.seqtrecho = DT.seqtrecho "

	strSqlWhereServicos = " WHERE "
	strSqlWhereServicos = strSqlWhereServicos & "       ( DT.seqvoodia = " & p_intSeqVooDia & " ) "
	strSqlWhereServicos = strSqlWhereServicos & " AND   ( DV.seqvoodia = " & p_intSeqVooDia & " ) "
	strSqlWhereServicos = strSqlWhereServicos & " AND   ( DT.seqtrecho = " & p_intSeqTrecho & " ) "
	strSqlWhereServicos = strSqlWhereServicos & " AND   ( VSA.dtinicio <= DV.dtoper ) "
	strSqlWhereServicos = strSqlWhereServicos & " AND   ( VSA.dtfim IS NULL OR VSA.dtfim >= DV.dtoper ) "

	strSqlOrderServicos = " ORDER BY TSA.descrservicoaerop, ESA.descrempresa "

	strQueryServicos = strSqlSelectServicos & strSqlFromServicos & strSqlWhereServicos & strSqlOrderServicos

	Set objRsServicos = Server.CreateObject("ADODB.Recordset")
	objRsServicos.Open strQueryServicos, objConnServicos

	Dim i
	i = CInt(0)

	Response.Write("<table border='0' cellpadding='0' align='left' cellspacing='0'>")
	If (Not objRsServicos.Eof) Then
		Do While Not objRsServicos.Eof
			Dim strHidServico, strTxtServico, intQtdServico

			if (Not IsVazio(objRsServicos("qtdservico"))) then
				intQtdServico = CInt(objRsServicos("qtdservico"))
			else
				intQtdServico = CInt(0)
			end if

			strHidServico = "<input type='hidden' id='hidServico_" & i & "' name='hidServico_" & i & "'"
			strHidServico = strHidServico & " value='" & objRsServicos("codservicoaerop") & "|" & objRsServicos("codempresa") & "' />"

			strTxtServico = "<input type='text' id='txtServico_" & i & "' name='txtServico_" & i & "'"
			strTxtServico = strTxtServico & " maxlength='3' size='1' onKeyPress='return SoNumeros(window.event.keyCode, this);'"
			strTxtServico = strTxtServico & " value='" & intQtdServico & "' />"
			strTxtServico = strTxtServico & "&nbsp;" & objRsServicos("descrservicoaerop") & "&nbsp;&nbsp;(" & objRsServicos("descrempresa") & ")"

			Response.Write("<tr style='padding-top: 5px; padding-bottom: 5px'>")
			Response.Write("<td style='padding-left: 20px' class='CORPO9'>")
			Response.Write(strHidServico)
			Response.Write(strTxtServico)
			Response.Write("</td>")
			Response.Write("</tr>")
			i = i + 1
			objRsServicos.movenext
		loop
	Else
		blnHabilitaBtnGravar = "hidden"
		Response.Write("<tr style='padding-top: 5px; padding-bottom: 5px'>")
		Response.Write("<td style='padding-left: 20px'>")
		Response.Write("Nenhum Serviço Disponível")
		Response.Write("</td>")
		Response.Write("</tr>")
	End If
	Response.Write("</table>")
	Response.Write("<input type='hidden' id='hidQtdServicos' name='hidQtdServicos' value='" & i & "' />")

	objRsServicos.Close
	set objRsServicos = nothing
	objConnServicos.close
	set objConnServicos = nothing

End Sub



Sub GravarServicosAeroportuarios()

	Dim i, qtdServicos, seqVooDia, seqTrecho
	qtdServicos = Request.Form("hidQtdServicos")
	seqVooDia = Request.Form("hidSeqVooDia")
	seqTrecho = Request.Form("hidSeqTrecho")

	Dim objConnGravarServicosAerop

	Set objConnGravarServicosAerop = CreateObject("ADODB.CONNECTION")
	objConnGravarServicosAerop.Open (StringConexaoSqlServer)
	objConnGravarServicosAerop.BeginTrans
	objConnGravarServicosAerop.Execute "SET DATEFORMAT ymd"

	Dim strMensagemErro
	strMensagemErro = ExcluirRegistrosServicoAerop(seqVooDia, seqTrecho, objConnGravarServicosAerop)

	if (IsVazio(strMensagemErro)) then
		For i = 0 to qtdServicos - 1
			Dim hidServico, txtServico, intQtdServico
			hidServico = Request.Form("hidServico_" & i)
			txtServico = Request.Form("txtServico_" & i)
			if (Not IsVazio(txtServico)) then
				intQtdServico = CInt(txtServico)
			end if
			if (intQtdServico > 0) then
				strMensagemErro = IncluirRegistroServicoAerop(hidServico, intQtdServico, seqVooDia, seqTrecho, objConnGravarServicosAerop)
				if (Not IsVazio(strMensagemErro)) then
					exit For
				end if
			end if
		Next
	end if

	if (IsVazio(strMensagemErro)) then
		objConnGravarServicosAerop.CommitTrans
		Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
	else
		objConnGravarServicosAerop.RollbackTrans
		Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
		'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
	end if

	objConnGravarServicosAerop.close
	set objConnGravarServicosAerop = nothing

end Sub



Function IncluirRegistroServicoAerop(p_hidServico, p_qtdServico, p_seqVooDia, p_seqTrecho, p_ObjConnIncluirServicosAerop)

	'Enable error handling
	On Error Resume Next

	Dim valores, codServicoAerop, codEmpresa
	valores = Split(p_hidServico, "|")
	codServicoAerop = valores(0)
	codEmpresa = valores(1)


	' ************************************
	' *** INSERE SERVIÇO AEROPORTUÁRIO ***
	' ************************************
	Dim strInsertServicoAerop
	strInsertServicoAerop = " INSERT INTO sig_servicoaeroptrecho "
	strInsertServicoAerop = strInsertServicoAerop & " (seqvoodia, seqtrecho, codservicoaerop, codempresa, qtdservico) "
	strInsertServicoAerop = strInsertServicoAerop & " VALUES "
	strInsertServicoAerop = strInsertServicoAerop & " ( "
	strInsertServicoAerop = strInsertServicoAerop & " " & p_seqVooDia & ", "
	strInsertServicoAerop = strInsertServicoAerop & " " & p_seqTrecho & ", "
	strInsertServicoAerop = strInsertServicoAerop & " '" & codServicoAerop & "', "
	strInsertServicoAerop = strInsertServicoAerop & " '" & codEmpresa & "', "
	strInsertServicoAerop = strInsertServicoAerop & " " & p_qtdServico & " "
	strInsertServicoAerop = strInsertServicoAerop & " ) "

	p_ObjConnIncluirServicosAerop.Execute strInsertServicoAerop
	If Err.number <> 0 Then
		IncluirRegistroServicoAerop = "\nErro na função IncluirRegistroServicoAerop\n" & Replace(Err.Description, "'", "\'")
	Else
		IncluirRegistroServicoAerop = ""
	End If

	'Reset error handling
	On Error Goto 0

end Function



Function ExcluirRegistrosServicoAerop(p_seqVooDia, p_seqTrecho, p_ObjConnExcluirServicosAerop)

	'Enable error handling
	On Error Resume Next

	' *************************************************
	' *** EXCLUI REGISTROS DE SERVIÇO AEROPORTUÁRIO ***
	' *************************************************
	Dim strDeleteServicoAerop
	strDeleteServicoAerop = " DELETE FROM sig_servicoaeroptrecho WHERE "
	strDeleteServicoAerop = strDeleteServicoAerop & "     seqvoodia = " & p_seqVooDia
	strDeleteServicoAerop = strDeleteServicoAerop & " AND seqtrecho = " & p_seqTrecho

	p_ObjConnExcluirServicosAerop.Execute strDeleteServicoAerop
	If Err.number <> 0 Then
		ExcluirRegistrosServicoAerop = "\nErro na função ExcluirRegistrosServicoAerop\n" & Replace(Err.Description, "'", "\'")
	Else
		ExcluirRegistrosServicoAerop = ""
	End If

	'Reset error handling
	On Error Goto 0

end Function



Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function



%>
