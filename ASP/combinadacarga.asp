<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim strMensagemErro
	Dim strQueryUpdate
	Dim objRsPax, strQueryPax

	Dim strGravar, strVoltar, strCancelar, strExcluir
	strGravar = Request.Form("btnGravar")
	strVoltar = Request.Form("btnVoltar")
	strCancelar = Request.Form("btnCancelar")
	strExcluir = Request.Form("btnExcluir")

	Dim hidIdUld
	Dim intSeqVooDia, intSeqTrecho, intSeqCombinada
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")
	intSeqCombinada = Request.QueryString("seqcombinada")

	Dim objRsEtapaBasica, strSqlEtapaBasica, strSqlUpdateEtapaBasica, objConnUpdate

	if (strVoltar <> "") then
		Response.Redirect("combinadaaeroportocarga.asp")
	elseif (strCancelar <> "") then
		intSeqCombinada = Request.Form("hidSeqCombinada")
		Response.Redirect("combinadacarga.asp?seqcombinada=" & intSeqCombinada)
	elseif (strExcluir <> "") then
		intSeqCombinada = Request.Form("hidSeqCombinada")
		hidIdUld = Request.Form("hidIdUld")

		if (Not IsVazio(hidIdUld)) then
			Dim strQueryExcluir
			strQueryExcluir =                  " DELETE FROM sig_diariotrechocombcarga "
			strQueryExcluir = strQueryExcluir & " WHERE seqvoodia = " & intSeqVooDia & " "
			strQueryExcluir = strQueryExcluir & "   AND seqtrecho = " & intSeqTrecho & " "
			strQueryExcluir = strQueryExcluir & "   AND seqcombinada = " & intSeqCombinada & " "
			strQueryExcluir = strQueryExcluir & "   AND iduld = '" & hidIdUld & "' "

			Dim objConnExcluir
			Set objConnExcluir = CreateObject("ADODB.CONNECTION")
			objConnExcluir.Open (StringConexaoSqlServerUpdateEncriptado)
			objConnExcluir.BeginTrans
			objConnExcluir.Execute "SET DATEFORMAT ymd"

			'Enable error handling
			On Error Resume Next

			objConnExcluir.Execute(strQueryExcluir)
			If Err.number <> 0 Then
				strMensagemErro = "\nErro na exclusão de um registro da tabela sig_diariotrechocombcarga\n" & Replace(Err.Description, "'", "\'")
			Else
				strMensagemErro = ""
			End If

			If (IsVazio(strMensagemErro)) Then
				' ****************************
				' *** ATUALIZA A COMBINADA ***
				' ****************************
				strQueryPax =               " SELECT SUM(SDTCC.cargapaga) cargapaga, "
				strQueryPax = strQueryPax & "        SUM(SDTCC.cargapagaexp) cargapagaexp, "
				strQueryPax = strQueryPax & "        SUM(SDTCC.cargagratis) cargagratis, "
				strQueryPax = strQueryPax & "        SUM(SDTCC.correioao) correioao, "
				strQueryPax = strQueryPax & "        SUM(SDTCC.correiolc) correiolc, "
				strQueryPax = strQueryPax & "        SUM(SDTCC.pesobruto) pesobruto "
				strQueryPax = strQueryPax & " FROM sig_diariotrechocombcarga SDTCC "
				strQueryPax = strQueryPax & " WHERE SDTCC.seqvoodia = " & intSeqVooDia
				strQueryPax = strQueryPax & "   AND SDTCC.seqtrecho = " & intSeqTrecho
				strQueryPax = strQueryPax & "   AND SDTCC.seqcombinada = " & intSeqCombinada

				Set objRsPax = Server.CreateObject("ADODB.Recordset")
				objRsPax.Open strQueryPax, objConnExcluir
				If Err.number <> 0 Then
					strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocombcarga\n" & Replace(Err.Description, "'", "\'")
				Else
					strMensagemErro = ""
				End If

				If (IsVazio(strMensagemErro)) Then
					Dim cargaPagaAtualizaComb, cargaPagaExpAtualizaComb, cargaGratisAtualizaComb
					Dim correioAoAtualizaComb, correioLcAtualizaComb, pesoBrutoAtualizaComb

					if (IsVazio(objRsPax("cargapaga"))) then
						cargaPagaAtualizaComb = CLng(0)
					else
						cargaPagaAtualizaComb = CLng(objRsPax("cargapaga"))
					end if
					if (IsVazio(objRsPax("cargapagaexp"))) then
						cargaPagaExpAtualizaComb = CLng(0)
					else
						cargaPagaExpAtualizaComb = CLng(objRsPax("cargapagaexp"))
					end if
					if (IsVazio(objRsPax("cargagratis"))) then
						cargaGratisAtualizaComb = CLng(0)
					else
						cargaGratisAtualizaComb = CLng(objRsPax("cargagratis"))
					end if
					if (IsVazio(objRsPax("correioao"))) then
						correioAoAtualizaComb = CLng(0)
					else
						correioAoAtualizaComb = CLng(objRsPax("correioao"))
					end if
					if (IsVazio(objRsPax("correiolc"))) then
						correioLcAtualizaComb = CLng(0)
					else
						correioLcAtualizaComb = CLng(objRsPax("correiolc"))
					end if
					if (IsVazio(objRsPax("pesobruto"))) then
						pesoBrutoAtualizaComb = CLng(0)
					else
						pesoBrutoAtualizaComb = CLng(objRsPax("pesobruto"))
					end if

					objRsPax.Close()
					Set objRsPax = Nothing

					strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
					strQueryUpdate = strQueryUpdate & " SET cargapaga = " & cargaPagaAtualizaComb & ", "
					strQueryUpdate = strQueryUpdate & "     cargapagaexp = " & cargaPagaExpAtualizaComb & ", "
					strQueryUpdate = strQueryUpdate & "     cargagratis = " & cargaGratisAtualizaComb & ", "
					strQueryUpdate = strQueryUpdate & "     correioao = " & correioAoAtualizaComb & ", "
					strQueryUpdate = strQueryUpdate & "     correiolc = " & correioLcAtualizaComb & ", "
					strQueryUpdate = strQueryUpdate & "     pesobruto = " & pesoBrutoAtualizaComb & " "
					strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
					strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
					strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "

					objConnExcluir.Execute(strQueryUpdate)
					If Err.number <> 0 Then
						strMensagemErro = "\nErro na atualização da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
					Else
						strMensagemErro = ""
					End If

					If (IsVazio(strMensagemErro)) Then
						' *******************************
						' *** ATUALIZA A ETAPA BÁSICA ***
						' *******************************
						strSqlEtapaBasica =                     " SELECT SUM(SDTC.cargapaga) cargapaga, "
						strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.cargapagaexp) cargapagaexp, "
						strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.cargagratis) cargagratis, "
						strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.correioao) correioao, "
						strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.correiolc) correiolc "
						strSqlEtapaBasica = strSqlEtapaBasica & " FROM sig_diariotrechocomb SDTC "
						strSqlEtapaBasica = strSqlEtapaBasica & " WHERE SDTC.seqvoodia = " & intSeqVooDia
						strSqlEtapaBasica = strSqlEtapaBasica & "   AND SDTC.seqtrecho <= " & intSeqTrecho
						strSqlEtapaBasica = strSqlEtapaBasica & "   AND (select Min(seqtrecho) "
						strSqlEtapaBasica = strSqlEtapaBasica & "          from sig_diariotrecho SDT2 "
						strSqlEtapaBasica = strSqlEtapaBasica & "         where SDT2.seqvoodia = SDTC.seqvoodia "
						strSqlEtapaBasica = strSqlEtapaBasica & "           and SDT2.seqaeropdest = SDTC.seqaeropdest "
						strSqlEtapaBasica = strSqlEtapaBasica & "           and SDT2.seqtrecho >= SDTC.seqtrecho) >= " & intSeqTrecho

						Set objRsEtapaBasica = Server.CreateObject("ADODB.Recordset")
						objRsEtapaBasica.Open strSqlEtapaBasica, objConnExcluir
						If Err.number <> 0 Then
							strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
						Else
							strMensagemErro = ""
						End If

						If (IsVazio(strMensagemErro)) Then
							strSqlUpdateEtapaBasica =                           " UPDATE sig_diariotrecho "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & " SET cargapaga = " & CLng(ObjRsEtapaBasica("cargapaga")) & ", "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     cargapagaexp = " & CLng(ObjRsEtapaBasica("cargapagaexp")) & ", "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     cargagratis = " & CLng(ObjRsEtapaBasica("cargagratis")) & ", "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     correioao = " & CLng(ObjRsEtapaBasica("correioao")) & ", "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     correiolc = " & CLng(ObjRsEtapaBasica("correiolc")) & " "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & " WHERE seqvoodia=" & intSeqVooDia & " "
							strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "   AND seqtrecho=" & intSeqTrecho & " "

							objRsEtapaBasica.Close()
							Set objRsEtapaBasica = Nothing

							objConnExcluir.Execute(strSqlUpdateEtapaBasica)
							If Err.number <> 0 Then
								strMensagemErro = "\nErro na atualização da tabela sig_diariotrecho\n" & Replace(Err.Description, "'", "\'")
							Else
								strMensagemErro = ""
							End If
						End If
					End If
				End If
			End If

			If (IsVazio(strMensagemErro)) Then
				objConnExcluir.CommitTrans
				Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
			Else
				objConnExcluir.RollbackTrans
				Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
				'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
			End If

			objConnExcluir.Close()
			Set objConnExcluir = Nothing

			'Reset error handling
			On Error Goto 0
		Else
			Response.Write("<script language='javascript'>alert('Favor selecionar um registro!');</script>")
		End If

	elseif (strGravar <> "") then
		intSeqCombinada = Request.Form("hidSeqCombinada")
		hidIdUld = Request.Form("hidIdUld")

		Dim strTxtCodigoUld
		Dim strTxtCargaPagaSTD, strTxtCargaPagaEXP, strTxtCargaGratis
		Dim strTxtCorreioAo, strTxtCorreioLc
		Dim strDdlTipoCarga1, strDdlTipoCarga2, strDdlTipoCarga3
		Dim strTxtObservacao, strDdlCubagem
		Dim strTxtPesoBrutoUld
		Dim strChkUld

		strTxtCodigoUld = UCase(Request.Form("txtCodigoUld"))
		strTxtCargaPagaSTD = Request.Form("txtCargaPagaSTD")
		strTxtCargaPagaEXP = Request.Form("txtCargaPagaEXP")
		strTxtCargaGratis = Request.Form("txtCargaGratis")
		strTxtCorreioAo = Request.Form("txtCorreioAo")
		strTxtCorreioLc = Request.Form("txtCorreioLc")
		strDdlTipoCarga1 = Request.Form("ddlTipoCarga1")
		strDdlTipoCarga2 = Request.Form("ddlTipoCarga2")
		strDdlTipoCarga3 = Request.Form("ddlTipoCarga3")
		strTxtObservacao = Request.Form("txtObservacao")
		strDdlCubagem = Request.Form("ddlCubagem")
		strTxtPesoBrutoUld = Request.Form("txtPesoBrutoUld")
		strChkUld = Request.Form("chkUld")

		Dim blnChkUld
		blnChkUld = CBool(Not IsVazio(strChkUld))

		If (IsVazio(strTxtCodigoUld)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Código, por favor!'); history.back();</script>")
			Response.End
		End If
		If (blnChkUld And IsVazio(strTxtPesoBrutoUld)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Peso Bruto da ULD, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strTxtCargaPagaSTD)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Carga STD, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strTxtCargaPagaEXP)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Carga EXP, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strTxtCargaGratis)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Carga COMAT/ULD, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strTxtCorreioAo)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo Carga VAC, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strTxtCorreioLc)) Then
			Response.Write("<script language='javascript'>alert('Preencha o campo RPN, por favor!'); history.back();</script>")
			Response.End
		End If
		If (IsVazio(strDdlCubagem)) Then
			Response.Write("<script language='javascript'>alert('Selecione a Cubagem, por favor!'); history.back();</script>")
			Response.End
		End If

		If (blnChkUld) Then
			If (CLng(strTxtPesoBrutoUld) < (CLng(strTxtCargaPagaSTD) + CLng(strTxtCargaPagaEXP) + CLng(strTxtCargaGratis) + CLng(strTxtCorreioAo) + CLng(strTxtCorreioLc))) Then
				Response.Write("<script language='javascript'>alert('A soma dos pesos de carga e RPN não pode ser maior do que o Peso Bruto da ULD!'); history.back();</script>")
				Response.End
			End If
		Else
			If (IsVazio(strTxtPesoBrutoUld) Or (strTxtPesoBrutoUld = "0")) Then
				strTxtPesoBrutoUld = CLng(strTxtCargaPagaSTD) + CLng(strTxtCargaPagaEXP) + CLng(strTxtCargaGratis) + CLng(strTxtCorreioAo) + CLng(strTxtCorreioLc)
			End If
		End If


		If (blnChkUld) Then
			Dim strQueryVerifCargaQtdUld, objRsVerifCargaQtdUld
			' ************************************************************************************
			' *** FAZ AS SEGUINTES VERIFICAÇÕES:                                               ***
			' *** 1- Verifica se a soma das cargas e do correio (Paga + COMAT/ULD + VAC + RPN) ***
			' ***    é menor ou igual ao valor gravado no campo sig_aeronave.cargamaxuld para  ***
			' ***    a aeronave em questão                                                     ***
			' *** 2- Verifica se o número de ULDs para aquela etapa de voo é menor do que o    ***
			' ***    valor gravado no campo sig_aeronave.qtdmaxuld                             ***
			' ************************************************************************************
			strQueryVerifCargaQtdUld =                            " SELECT ARNV.cargamaxuld CARGA_MAX_ULD, "
			strQueryVerifCargaQtdUld = strQueryVerifCargaQtdUld & "        ARNV.qtdmaxuld QTD_MAX_ULD "
			strQueryVerifCargaQtdUld = strQueryVerifCargaQtdUld & " FROM sig_aeronave ARNV "
			strQueryVerifCargaQtdUld = strQueryVerifCargaQtdUld & "      INNER JOIN sig_diariotrecho SDT ON SDT.prefixoaeronave = ARNV.prefixored "
			strQueryVerifCargaQtdUld = strQueryVerifCargaQtdUld & " WHERE SDT.seqvoodia = " & intSeqVooDia
			strQueryVerifCargaQtdUld = strQueryVerifCargaQtdUld & "   AND SDT.seqtrecho = " & intSeqTrecho

			Set objRsVerifCargaQtdUld = Server.CreateObject("ADODB.Recordset")
			objRsVerifCargaQtdUld.Open strQueryVerifCargaQtdUld, objConn

			Dim intCargaMaxUld, intQtdMaxUld
			intCargaMaxUld = objRsVerifCargaQtdUld("CARGA_MAX_ULD")
			intQtdMaxUld = objRsVerifCargaQtdUld("QTD_MAX_ULD")

			objRsVerifCargaQtdUld.Close
			Set objRsVerifCargaQtdUld = Nothing

			If (IsVazio(intQtdMaxUld)) Then intQtdMaxUld = CInt(0)

			If (CInt(intQtdMaxUld) > 0) Then
				Dim strQueryQtdUld, objRsQtdUld, intQtdUlds
				' *************************************************************
				' *** Consulta a quantidade de ULDs para a etapa em questão ***
				' *************************************************************
				strQueryQtdUld =                  " SELECT COUNT(*) QtdUlds "
				strQueryQtdUld = strQueryQtdUld & " FROM sig_diariotrechocombcarga SDTCC "
				strQueryQtdUld = strQueryQtdUld & " WHERE SDTCC.seqvoodia = " & intSeqVooDia
				strQueryQtdUld = strQueryQtdUld & "   AND SDTCC.seqtrecho = " & intSeqTrecho
				strQueryQtdUld = strQueryQtdUld & "   AND SDTCC.seqcombinada = " & intSeqCombinada
				strQueryQtdUld = strQueryQtdUld & "   AND UPPER(SDTCC.flguld) = 'S' "
				If (Not IsVazio(hidIdUld)) Then 'UPDATE
					strQueryQtdUld = strQueryQtdUld & "   AND SDTCC.iduld <> '" & hidIdUld & "' "
				End If

				Set objRsQtdUld = Server.CreateObject("ADODB.Recordset")
				objRsQtdUld.Open strQueryQtdUld, objConn

				intQtdUlds = CInt(objRsQtdUld("QtdUlds"))

				objRsQtdUld.Close
				Set objRsQtdUld = Nothing

				If (CInt(intQtdUlds) >= CInt(intQtdMaxUld)) Then
					Response.Write("<script language='javascript'>alert('Essa aeronave só pode ter no máximo " & intQtdMaxUld & " ULDs!'); history.back();</script>")
					Response.End
				End If
			End If

			If (IsVazio(intCargaMaxUld)) Then intCargaMaxUld = CLng(0)

			If (CLng(intCargaMaxUld) > 0) Then
				If (CLng(intCargaMaxUld) < (CLng(strTxtCargaPagaSTD) + CLng(strTxtCargaPagaEXP) + CLng(strTxtCargaGratis) + CLng(strTxtCorreioAo) + CLng(strTxtCorreioLc))) Then
					Response.Write("<script language='javascript'>alert('Cada ULD dessa aeronave só pode ter no máximo uma carga de " & intCargaMaxUld & " Kg!'); history.back();</script>")
					Response.End
				End If
			End If

		End If


		Dim strQueryVerificaUld, objRsVerificaUld, intQtdRegistros
		' ***********************************************************
		' *** VERIFICA SE O ULD JÁ EXISTE PARA A ETAPA EM QUESTÃO ***
		' ***********************************************************
		strQueryVerificaUld =                       " SELECT COUNT(*) QtdRegistros "
		strQueryVerificaUld = strQueryVerificaUld & " FROM sig_diariotrechocombcarga SDTCC "
		strQueryVerificaUld = strQueryVerificaUld & " WHERE SDTCC.seqvoodia = " & intSeqVooDia
		strQueryVerificaUld = strQueryVerificaUld & "   AND SDTCC.seqtrecho = " & intSeqTrecho
		strQueryVerificaUld = strQueryVerificaUld & "   AND SDTCC.seqcombinada = " & intSeqCombinada
		strQueryVerificaUld = strQueryVerificaUld & "   AND SDTCC.iduld = '" & strTxtCodigoUld & "' "
		if (Not IsVazio(hidIdUld)) then 'UPDATE
			strQueryVerificaUld = strQueryVerificaUld & "   AND SDTCC.iduld <> '" & hidIdUld & "' "
		end if

		Set objRsVerificaUld = Server.CreateObject("ADODB.Recordset")
		objRsVerificaUld.Open strQueryVerificaUld, objConn

		intQtdRegistros = CInt(objRsVerificaUld("QtdRegistros"))

		objRsVerificaUld.Close
		Set objRsVerificaUld = Nothing

		if (intQtdRegistros > 0) then
			Response.Write("<script language='javascript'>alert('O Código informado já existe para essa etapa!'); history.back();</script>")
			Response.End
		end if

		Dim strTxtCargaPaga
		strTxtCargaPaga = CLng(strTxtCargaPagaSTD) + CLng(strTxtCargaPagaEXP)

		if (Not IsVazio(hidIdUld)) then 'UPDATE
			strQueryUpdate =                  " UPDATE sig_diariotrechocombcarga "
			strQueryUpdate = strQueryUpdate & " SET iduld = '" & strTxtCodigoUld & "', "
			strQueryUpdate = strQueryUpdate & "     cargapaga = " & strTxtCargaPaga & ", "
			strQueryUpdate = strQueryUpdate & "     cargapagaexp = " & strTxtCargaPagaEXP & ", "
			strQueryUpdate = strQueryUpdate & "     cargagratis = " & strTxtCargaGratis & ", "
			strQueryUpdate = strQueryUpdate & "     correioao = " & strTxtCorreioAo & ", "
			strQueryUpdate = strQueryUpdate & "     correiolc = " & strTxtCorreioLc & ", "
			If (IsVazio(strDdlTipoCarga1)) Then
				strQueryUpdate = strQueryUpdate & "     codtipocarga1 = NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "     codtipocarga1 = '" & strDdlTipoCarga1 & "', "
			End If
			If (IsVazio(strDdlTipoCarga2)) Then
				strQueryUpdate = strQueryUpdate & "     codtipocarga2 = NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "     codtipocarga2 = '" & strDdlTipoCarga2 & "', "
			End If
			If (IsVazio(strDdlTipoCarga3)) Then
				strQueryUpdate = strQueryUpdate & "     codtipocarga3 = NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "     codtipocarga3 = '" & strDdlTipoCarga3 & "', "
			End If
			If (IsVazio(strTxtObservacao)) Then
				strQueryUpdate = strQueryUpdate & "     observacao = NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "     observacao = '" & strTxtObservacao & "', "
			End If
			strQueryUpdate = strQueryUpdate & "     cubagem = " & strDdlCubagem & ", "
			strQueryUpdate = strQueryUpdate & "     pesobruto = " & strTxtPesoBrutoUld & ", "
			If (blnChkUld) Then
				strQueryUpdate = strQueryUpdate & "     flguld = 'S' "
			Else
				strQueryUpdate = strQueryUpdate & "     flguld = 'N' "
			End If
			strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
			strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
			strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "
			strQueryUpdate = strQueryUpdate & "   AND iduld = '" & hidIdUld & "' "
		else
			strQueryUpdate =                  " INSERT INTO sig_diariotrechocombcarga "
			strQueryUpdate = strQueryUpdate & " (seqvoodia, "
			strQueryUpdate = strQueryUpdate & "  seqtrecho, "
			strQueryUpdate = strQueryUpdate & "  seqcombinada, "
			strQueryUpdate = strQueryUpdate & "  iduld, "
			strQueryUpdate = strQueryUpdate & "  cargapaga, "
			strQueryUpdate = strQueryUpdate & "  cargapagaexp, "
			strQueryUpdate = strQueryUpdate & "  cargagratis, "
			strQueryUpdate = strQueryUpdate & "  correioao, "
			strQueryUpdate = strQueryUpdate & "  correiolc, "
			strQueryUpdate = strQueryUpdate & "  codtipocarga1, "
			strQueryUpdate = strQueryUpdate & "  codtipocarga2, "
			strQueryUpdate = strQueryUpdate & "  codtipocarga3, "
			strQueryUpdate = strQueryUpdate & "  observacao, "
			strQueryUpdate = strQueryUpdate & "  cubagem, "
			strQueryUpdate = strQueryUpdate & "  pesobruto, "
			strQueryUpdate = strQueryUpdate & "  flguld) "
			strQueryUpdate = strQueryUpdate & " VALUES "
			strQueryUpdate = strQueryUpdate & " ( " & intSeqVooDia & ", "
			strQueryUpdate = strQueryUpdate & "   " & intSeqTrecho & ", "
			strQueryUpdate = strQueryUpdate & "   " & intSeqCombinada & ", "
			strQueryUpdate = strQueryUpdate & "   '" & strTxtCodigoUld & "', "
			strQueryUpdate = strQueryUpdate & "   " & strTxtCargaPaga & ", "
			strQueryUpdate = strQueryUpdate & "   " & strTxtCargaPagaEXP & ", "
			strQueryUpdate = strQueryUpdate & "   " & strTxtCargaGratis & ", "
			strQueryUpdate = strQueryUpdate & "   " & strTxtCorreioAo & ", "
			strQueryUpdate = strQueryUpdate & "   " & strTxtCorreioLc & ", "
			If (IsVazio(strDdlTipoCarga1)) Then
				strQueryUpdate = strQueryUpdate & "   NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "   '" & strDdlTipoCarga1 & "', "
			End If
			If (IsVazio(strDdlTipoCarga2)) Then
				strQueryUpdate = strQueryUpdate & "   NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "   '" & strDdlTipoCarga2 & "', "
			End If
			If (IsVazio(strDdlTipoCarga3)) Then
				strQueryUpdate = strQueryUpdate & "   NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "   '" & strDdlTipoCarga3 & "', "
			End If
			If (IsVazio(strTxtObservacao)) Then
				strQueryUpdate = strQueryUpdate & "   NULL, "
			Else
				strQueryUpdate = strQueryUpdate & "   '" & strTxtObservacao & "', "
			End If
			strQueryUpdate = strQueryUpdate & "    " & strDdlCubagem & ", "
			strQueryUpdate = strQueryUpdate & "    " & strTxtPesoBrutoUld & ", "
			If (blnChkUld) Then
				strQueryUpdate = strQueryUpdate & "   'S') "
			Else
				strQueryUpdate = strQueryUpdate & "   'N') "
			End If
		end if

		Dim objConnGravar
		Set objConnGravar = CreateObject("ADODB.CONNECTION")
		objConnGravar.Open (StringConexaoSqlServerUpdateEncriptado)
		objConnGravar.BeginTrans
		objConnGravar.Execute "SET DATEFORMAT ymd"

		'Enable error handling
		On Error Resume Next

		objConnGravar.Execute(strQueryUpdate)
		If Err.number <> 0 Then
			strMensagemErro = "\nErro na atualização/inclusão de um registro na tabela sig_diariotrechocombcarga\n" & Replace(Err.Description, "'", "\'")
		Else
			strMensagemErro = ""
		End If

		If (IsVazio(strMensagemErro)) Then
			' ****************************
			' *** ATUALIZA A COMBINADA ***
			' ****************************
			strQueryPax =               " SELECT SUM(SDTCC.cargapaga) cargapaga, "
			strQueryPax = strQueryPax & "        SUM(SDTCC.cargapagaexp) cargapagaexp, "
			strQueryPax = strQueryPax & "        SUM(SDTCC.cargagratis) cargagratis, "
			strQueryPax = strQueryPax & "        SUM(SDTCC.correioao) correioao, "
			strQueryPax = strQueryPax & "        SUM(SDTCC.correiolc) correiolc, "
			strQueryPax = strQueryPax & "        SUM(SDTCC.pesobruto) pesobruto "
			strQueryPax = strQueryPax & " FROM sig_diariotrechocombcarga SDTCC "
			strQueryPax = strQueryPax & " WHERE SDTCC.seqvoodia = " & intSeqVooDia
			strQueryPax = strQueryPax & "   AND SDTCC.seqtrecho = " & intSeqTrecho
			strQueryPax = strQueryPax & "   AND SDTCC.seqcombinada = " & intSeqCombinada

			Set objRsPax = Server.CreateObject("ADODB.Recordset")
			objRsPax.Open strQueryPax, objConnGravar
			If Err.number <> 0 Then
				strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocombcarga\n" & Replace(Err.Description, "'", "\'")
			Else
				strMensagemErro = ""
			End If

			If (IsVazio(strMensagemErro)) Then
				strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
				strQueryUpdate = strQueryUpdate & " SET cargapaga = " & objRsPax("cargapaga") & ", "
				strQueryUpdate = strQueryUpdate & "     cargapagaexp = " & objRsPax("cargapagaexp") & ", "
				strQueryUpdate = strQueryUpdate & "     cargagratis = " & objRsPax("cargagratis") & ", "
				strQueryUpdate = strQueryUpdate & "     correioao = " & objRsPax("correioao") & ", "
				strQueryUpdate = strQueryUpdate & "     correiolc = " & objRsPax("correiolc") & ", "
				strQueryUpdate = strQueryUpdate & "     pesobruto = " & objRsPax("pesobruto") & " "
				strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
				strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
				strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "

				objRsPax.Close
				Set objRsPax = Nothing

				objConnGravar.Execute(strQueryUpdate)
				If Err.number <> 0 Then
					strMensagemErro = "\nErro na atualização da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
				Else
					strMensagemErro = ""
				End If

				If (IsVazio(strMensagemErro)) Then
					' *******************************
					' *** ATUALIZA A ETAPA BÁSICA ***
					' *******************************
					strSqlEtapaBasica =                     " SELECT SUM(SDTC.cargapaga) cargapaga, "
					strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.cargapagaexp) cargapagaexp, "
					strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.cargagratis) cargagratis, "
					strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.correioao) correioao, "
					strSqlEtapaBasica = strSqlEtapaBasica & "        SUM(SDTC.correiolc) correiolc "
					strSqlEtapaBasica = strSqlEtapaBasica & " FROM sig_diariotrechocomb SDTC "
					strSqlEtapaBasica = strSqlEtapaBasica & " WHERE SDTC.seqvoodia = " & intSeqVooDia
					strSqlEtapaBasica = strSqlEtapaBasica & "   AND SDTC.seqtrecho <= " & intSeqTrecho
					strSqlEtapaBasica = strSqlEtapaBasica & "   AND (select Min(seqtrecho) "
					strSqlEtapaBasica = strSqlEtapaBasica & "          from sig_diariotrecho SDT2 "
					strSqlEtapaBasica = strSqlEtapaBasica & "         where SDT2.seqvoodia = SDTC.seqvoodia "
					strSqlEtapaBasica = strSqlEtapaBasica & "           and SDT2.seqaeropdest = SDTC.seqaeropdest "
					strSqlEtapaBasica = strSqlEtapaBasica & "           and SDT2.seqtrecho >= SDTC.seqtrecho) >= " & intSeqTrecho

					Set objRsEtapaBasica = Server.CreateObject("ADODB.Recordset")
					objRsEtapaBasica.Open strSqlEtapaBasica, objConnGravar
					If Err.number <> 0 Then
						strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
					Else
						strMensagemErro = ""
					End If

					If (IsVazio(strMensagemErro)) Then
						strSqlUpdateEtapaBasica =                           " UPDATE sig_diariotrecho "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & " SET cargapaga = " & CLng(ObjRsEtapaBasica("cargapaga")) & ", "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     cargapagaexp = " & CLng(ObjRsEtapaBasica("cargapagaexp")) & ", "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     cargagratis = " & CLng(ObjRsEtapaBasica("cargagratis")) & ", "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     correioao = " & CLng(ObjRsEtapaBasica("correioao")) & ", "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "     correiolc = " & CLng(ObjRsEtapaBasica("correiolc")) & " "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & " WHERE seqvoodia=" & intSeqVooDia & " "
						strSqlUpdateEtapaBasica = strSqlUpdateEtapaBasica & "   AND seqtrecho=" & intSeqTrecho & " "

						objRsEtapaBasica.Close()
						Set objRsEtapaBasica = Nothing

						objConnGravar.Execute(strSqlUpdateEtapaBasica)
						If Err.number <> 0 Then
							strMensagemErro = "\nErro na atualização da tabela sig_diariotrecho\n" & Replace(Err.Description, "'", "\'")
						Else
							strMensagemErro = ""
						End If
					End If
				End If
			End If
		End If

		If (IsVazio(strMensagemErro)) Then
			objConnGravar.CommitTrans
			Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
		Else
			objConnGravar.RollbackTrans
			Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
			'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
		End If

		objConnGravar.Close()
		Set objConnGravar = Nothing

		'Reset error handling
		On Error Goto 0

	end if

	Dim intSeqUsuarioAerop, intSeqAeroporto
	intSeqUsuarioAerop = Session("member")
	intSeqAeroporto = Session("seqaeroporto")

	' ************************************
	' *** DADOS DO AEROPORTO DE ORIGEM ***
	' ************************************
	Dim objRsAeroporto, strQueryAeroporto
	Dim strNomeAeropOrig, strCodAeropOrig, strNomeAeropDestino, strCodAeropDestino

	strQueryAeroporto =                     " SELECT seqaeroporto, codiata, nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto "
	strQueryAeroporto = strQueryAeroporto & "  WHERE seqaeroporto = " & intSeqAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeropOrig = objRsAeroporto("nomeaeroporto")
	strCodAeropOrig = objRsAeroporto("codiata")
	objRsAeroporto.Close

	if(Not IsNumeric(intSeqCombinada)) then
		intSeqCombinada = Request.Form("hidSeqCombinada")
	end if

	' *************************************
	' *** DADOS DO AEROPORTO DE DESTINO ***
	' *************************************
	strQueryAeroporto =                     " SELECT AEROP.seqaeroporto, AEROP.codiata, AEROP.nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto AEROP, sig_diariotrechocomb SDTC "
	strQueryAeroporto = strQueryAeroporto & "  WHERE AEROP.seqaeroporto = SDTC.seqaeropdest "
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqvoodia = " & intSeqVooDia
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqtrecho = " & intSeqTrecho
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqcombinada = " & intSeqCombinada

	objRsAeroporto.Open strQueryAeroporto, objConn

	strNomeAeropDestino = objRsAeroporto("nomeaeroporto")
	strCodAeropDestino = objRsAeroporto("codiata")

	objRsAeroporto.Close

	' ********************
	' *** DADOS DO VOO ***
	' ********************
	Dim strQueryVoo
	strQueryVoo =               " SELECT SDV.nrvoo "
	strQueryVoo = strQueryVoo & " FROM sig_diariovoo SDV "
	strQueryVoo = strQueryVoo & " WHERE SDV.seqvoodia = " & intSeqVooDia

	Dim objRsVoo
	Set objRsVoo = Server.CreateObject("ADODB.Recordset")
	objRsVoo.Open strQueryVoo, objConn

	Dim strNrVoo
	strNrVoo = objRsVoo("nrvoo")
	objRsVoo.Close

	' ********************
	' *** DISTRIBUIÇÃO ***
	' ********************
	Dim objRs, strQuery
	strQuery =            " SELECT SDTCC.iduld, SDTCC.cargapaga, SDTCC.cargapagaexp, "
	strQuery = strQuery & "        SDTCC.cargagratis, SDTCC.correioao, SDTCC.correiolc, "
	strQuery = strQuery & "        SDTCC.codtipocarga1, TC1.descrtipocarga descrtipocarga1, "
	strQuery = strQuery & "        SDTCC.codtipocarga2, TC2.descrtipocarga descrtipocarga2, "
	strQuery = strQuery & "        SDTCC.codtipocarga3, TC3.descrtipocarga descrtipocarga3, "
	strQuery = strQuery & "        SDTCC.observacao, SDTCC.cubagem, SDTCC.pesobruto, "
	strQuery = strQuery & "        SDTCC.flguld "
	strQuery = strQuery & " FROM sig_diariotrechocombcarga SDTCC "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC1 ON TC1.codtipocarga = SDTCC.codtipocarga1 "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC2 ON TC2.codtipocarga = SDTCC.codtipocarga2 "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC3 ON TC3.codtipocarga = SDTCC.codtipocarga3 "
	strQuery = strQuery & " WHERE SDTCC.seqvoodia = " & intSeqVooDia & " "
	strQuery = strQuery & "   AND SDTCC.seqtrecho = " & intSeqTrecho & " "
	strQuery = strQuery & "   AND SDTCC.seqcombinada = " & intSeqCombinada & " "

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

%>

<html>
	<head>
		<title>Aeroportos</title>
		<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
		<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<script src="javascript.js"></script>
		<script src="jquery-1.1.4.js"></script>
		<style type="text/css">
			.input_rigthText{
				text-align: right;
			}
		</style>
		<script type="text/javascript" language="javascript">
			$(document).ready(function() {
				$("#txtCargaPagaSTD").css("text-align","right");
				$("#txtCargaPagaEXP").css("text-align","right");
				$("#txtCargaGratis").css("text-align","right");
				$("#txtCorreioAo").css("text-align","right");
				$("#txtCorreioLc").css("text-align","right");
				$("#txtPesoBrutoUld").css("text-align","right");
			});

			function VerificaCampos() {
				var blnChkUld = document.getElementById('chkUld').checked;

				if (Trim(document.getElementById('txtCodigoUld').value) == '') {
					alert('Preencha o campo Código, por favor!');
					document.getElementById('txtCodigoUld').focus();
					return false;
				}
				else if (blnChkUld && (Trim(document.getElementById('txtPesoBrutoUld').value) == '')) {
					alert('Preencha o campo Peso Bruto da ULD, por favor!');
					document.getElementById('txtPesoBrutoUld').focus();
					return false;
				}
				else if (Trim(document.getElementById('txtCargaPagaSTD').value) == '') {
					alert('Preencha o campo Carga STD, por favor!');
					document.getElementById('txtCargaPagaSTD').focus();
					return false;
				}
				else if (Trim(document.getElementById('txtCargaPagaEXP').value) == '') {
					alert('Preencha o campo Carga EXP, por favor!');
					document.getElementById('txtCargaPagaEXP').focus();
					return false;
				}
				else if (Trim(document.getElementById('txtCargaGratis').value) == '') {
					alert('Preencha o campo Carga COMAT/ULD, por favor!');
					document.getElementById('txtCargaGratis').focus();
					return false;
				}
				else if (Trim(document.getElementById('txtCorreioAo').value) == '') {
					alert('Preencha o campo Carga VAC, por favor!');
					document.getElementById('txtCorreioAo').focus();
					return false;
				}
				else if (Trim(document.getElementById('txtCorreioLc').value) == '') {
					alert('Preencha o campo RPN, por favor!');
					document.getElementById('txtCorreioLc').focus();
					return false;
				}
				else if (Trim(document.getElementById('ddlCubagem').value) == '') {
					alert('Selecione a Cubagem, por favor!');
					document.getElementById('ddlCubagem').focus();
					return false;
				}

				var pesoBrutoUld = Number(Trim(document.getElementById('txtPesoBrutoUld').value));
				var cargaPagaSTD = Number(Trim(document.getElementById('txtCargaPagaSTD').value));
				var cargaPagaEXP = Number(Trim(document.getElementById('txtCargaPagaEXP').value));
				var cargaGratis = Number(Trim(document.getElementById('txtCargaGratis').value));
				var correioAo = Number(Trim(document.getElementById('txtCorreioAo').value));
				var correioLc = Number(Trim(document.getElementById('txtCorreioLc').value));
				if (blnChkUld && (Number(pesoBrutoUld) < Number(cargaPagaSTD + cargaPagaEXP + cargaGratis + correioAo + correioLc))) {
					alert('A soma dos pesos de carga e RPN não pode ser maior do que o Peso Bruto da ULD!');
					document.getElementById('txtPesoBrutoUld').focus();
					return false;
				}
				return true;
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
					<font size="3"><b>Distribuição&nbsp;do&nbsp;V&#244;o&nbsp;<%Response.Write(strNrVoo)%></b></font><br /><br />
					<font size="3"><b><%Response.Write("(" & strCodAeropOrig & "&nbsp;->&nbsp;" & strCodAeropDestino & ")")%></b></font>
				</td>
            <td align="right">
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
		<table border='1' cellpadding='0' align="center" cellspacing='0' width='98%'>
			<tr bgcolor='#AAAAAA'>
				<th class="CORPO9" rowspan="2" width='14%' >C&#243;digo</th>
				<th class="CORPO9" rowspan="2" width='4%' >ULD</th>
				<th class="CORPO9" rowspan="2" width='7%' >Peso Bruto</th>
				<th class="CORPO9" colspan="4" width='25%' >Carga</th>
				<th class='CORPO9' rowspan="2" width='7%' >RPN</th>
				<th class="CORPO9" rowspan="2" width='9%' >Cubagem (M<sup>3</sup>)</th>
				<th class="CORPO9" rowspan="2" colspan="3" width='17%' >SPL</th>
				<th class="CORPO9" rowspan="2" width='17%' >Observa&#231;&#227;o</th>
			</tr>
			<tr bgcolor='#AAAAAA'>
				<th class='CORPO9' width='6.25%' >STD</th>
				<th class='CORPO9' width='6.25%' >EXP</th>
				<th class='CORPO7' width='6.25%' >COMAT/ULD</th>
				<th class='CORPO9' width='6.25%' >VAC</th>
			</tr>

<%
	Dim Cor1, Cor2, Cor, intContador
	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	Do While Not objRs.Eof
		if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
		end if

		Dim ll_IdUld, ll_CargaPaga, ll_CargaPagaSTD, ll_CargaPagaEXP, ll_CargaGratis, ll_CorreioAo, ll_CorreioLc
		Dim ll_CodTipoCarga1, ll_CodTipoCarga2, ll_CodTipoCarga3
		Dim ll_DescrTipoCarga1, ll_DescrTipoCarga2, ll_DescrTipoCarga3
		Dim ll_Observacao, ll_Cubagem, ll_PesoBrutoUld
		Dim ll_FlgUld

		ll_IdUld = objRs("iduld")
		ll_CargaPaga = CLng(objRs("cargapaga"))
		ll_CargaGratis = CLng(objRs("cargagratis"))
		ll_CorreioAo = CLng(objRs("correioao"))
		ll_CorreioLc = CLng(objRs("correiolc"))
		ll_CodTipoCarga1 = objRs("codtipocarga1")
		ll_DescrTipoCarga1 = objRs("descrtipocarga1")
		ll_CodTipoCarga2 = objRs("codtipocarga2")
		ll_DescrTipoCarga2 = objRs("descrtipocarga2")
		ll_CodTipoCarga3 = objRs("codtipocarga3")
		ll_DescrTipoCarga3 = objRs("descrtipocarga3")
		ll_Observacao = objRs("observacao")
		ll_Cubagem = objRs("cubagem")
		If (Not IsVazio(ll_Cubagem)) Then ll_Cubagem = ll_Cubagem & "%"
		ll_PesoBrutoUld = objRs("pesobruto")
		If (Not IsVazio(ll_PesoBrutoUld)) Then ll_PesoBrutoUld = CLng(ll_PesoBrutoUld)
		ll_FlgUld = objRs("flguld")
		ll_CargaPagaEXP = objRs("cargapagaexp")
		If (IsVazio(ll_CargaPagaEXP)) Then
			ll_CargaPagaEXP = CLng(0)
		Else
			ll_CargaPagaEXP = CLng(ll_CargaPagaEXP)
		End If
		ll_CargaPagaSTD = CLng(ll_CargaPaga) - CLng(ll_CargaPagaEXP)


		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='combinadacarga.asp?seqcombinada=" & intSeqCombinada & "&iduld=" & ll_IdUld & "'>" & vbCrLf)
		Response.Write("		" & ll_IdUld & "</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		If (UCase(ll_FlgUld) = "N") Then
			Response.Write("		<input type='checkbox' id='chkUld" & intContador & "' name='chkUld" & intContador & "' value='ULD' onclick='return false;' />" & vbCrLf)
		ElseIf (UCase(ll_FlgUld) = "S") Then
			Response.Write("		<input type='checkbox' id='chkUld" & intContador & "' name='chkUld" & intContador & "' value='ULD' onclick='return false;' checked='checked' />" & vbCrLf)
		Else
			Response.Write("&nbsp;")
		End If
		Response.Write("	</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PesoBrutoUld & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaPagaSTD & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaPagaEXP & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaGratis & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CorreioAo & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CorreioLc & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_Cubagem & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga1 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga1 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga2 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga2 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga3 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga3 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' align='left'>" & vbCrLf)
		Response.Write("		&nbsp;" & ll_Observacao & "&nbsp;</td>" & vbCrLf)


		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		objRs.movenext
	loop

	objRs.Close
	Set objRs = Nothing
%>
			<tr>
				<th colspan="13"></th>
			</tr>
		</table>
      <br />
      <br />
      <br />

<%
	Dim strIdUld
	Dim intCargaPaga, intCargaPagaSTD, intCargaPagaEXP, intCargaGratis
	Dim intCorreioAo, intCorreioLc
	Dim strCodTipoCarga1, strCodTipoCarga2, strCodTipoCarga3
	Dim strObservacao, strCubagem
	Dim intPesoBrutoUld
	Dim strFlgUld

	strIdUld = Request.QueryString("iduld")
	if (Not IsVazio(strIdUld)) then

		' ********************************
		' *** DISTRIBUIÇÃO SELECIONADA ***
		' ********************************
		Dim objRsDistSel, strQueryDistSel
		strQueryDistSel =                   " SELECT SDTCC.seqvoodia, SDTCC.seqtrecho, SDTCC.seqcombinada, "
		strQueryDistSel = strQueryDistSel & "        SDTCC.iduld, SDTCC.cargapaga, SDTCC.cargapagaexp, "
		strQueryDistSel = strQueryDistSel & "        SDTCC.cargagratis, SDTCC.correioao, SDTCC.correiolc, "
		strQueryDistSel = strQueryDistSel & "        SDTCC.codtipocarga1, SDTCC.codtipocarga2, SDTCC.codtipocarga3, "
		strQueryDistSel = strQueryDistSel & "        SDTCC.observacao, SDTCC.cubagem, SDTCC.pesobruto, "
		strQueryDistSel = strQueryDistSel & "        SDTCC.flguld "
		strQueryDistSel = strQueryDistSel & " FROM sig_diariotrechocombcarga SDTCC "
		strQueryDistSel = strQueryDistSel & " WHERE SDTCC.seqvoodia=" & intSeqVooDia & " "
		strQueryDistSel = strQueryDistSel & "   AND SDTCC.seqtrecho=" & intSeqTrecho & " "
		strQueryDistSel = strQueryDistSel & "   AND SDTCC.seqcombinada=" & intSeqCombinada & " "
		strQueryDistSel = strQueryDistSel & "   AND SDTCC.iduld='" & strIdUld & "' "

		Set objRsDistSel = Server.CreateObject("ADODB.Recordset")
		objRsDistSel.Open strQueryDistSel, objConn

		strIdUld = objRsDistSel("iduld")
		intCargaPaga = CLng(objRsDistSel("cargapaga"))
		intCargaGratis = CLng(objRsDistSel("cargagratis"))
		intCorreioAo = CLng(objRsDistSel("correioao"))
		intCorreioLc = CLng(objRsDistSel("correiolc"))
		strCodTipoCarga1 = objRsDistSel("codtipocarga1")
		strCodTipoCarga2 = objRsDistSel("codtipocarga2")
		strCodTipoCarga3 = objRsDistSel("codtipocarga3")
		strObservacao = objRsDistSel("observacao")
		strCubagem = objRsDistSel("cubagem")
		intPesoBrutoUld = objRsDistSel("pesobruto")
		if (IsVazio(intPesoBrutoUld)) then
			intPesoBrutoUld = CLng(0)
		end if
		strFlgUld = objRsDistSel("flguld")
		intCargaPagaEXP = objRsDistSel("cargapagaexp")
		If (IsVazio(intCargaPagaEXP)) Then
			intCargaPagaEXP = CLng(0)
		Else
			intCargaPagaEXP = CLng(intCargaPagaEXP)
		End If
		intCargaPagaSTD = CLng(intCargaPaga) - CLng(intCargaPagaEXP)

		objRsDistSel.Close
		Set objRsDistSel = Nothing
	else
		strIdUld = ""
		intCargaPagaSTD = CLng(0)
		intCargaPagaEXP = CLng(0)
		intCargaGratis = CLng(0)
		intCorreioAo = CLng(0)
		intCorreioLc = CLng(0)
		strCodTipoCarga1 = ""
		strCodTipoCarga2 = ""
		strCodTipoCarga3 = ""
		strObservacao = ""
		strCubagem = ""
		intPesoBrutoUld = CLng(0)
		strFlgUld = "S"
	end if



	' *********************
	' *** TIPO DE CARGA ***
	' *********************
	Dim strQueryTipoCarga
	strQueryTipoCarga = " SELECT codtipocarga, descrtipocarga FROM sig_tipocarga "

	Dim objRsTipoCarga
	Set objRsTipoCarga = Server.CreateObject("ADODB.Recordset")
	objRsTipoCarga.Open strQueryTipoCarga, objConn

	Dim strListaCodTipoCarga, strListaDescrTipoCarga
	strListaCodTipoCarga = ""
	strListaDescrTipoCarga = ""
	Do While (Not objRsTipoCarga.EOF)
		strListaCodTipoCarga = strListaCodTipoCarga & "||" & objRsTipoCarga("codtipocarga")
		strListaDescrTipoCarga = strListaDescrTipoCarga & "||" & objRsTipoCarga("descrtipocarga")
		objRsTipoCarga.MoveNext()
	Loop

	Dim arrCodTipoCarga, arrDescrTipoCarga
	arrCodTipoCarga = Split(strListaCodTipoCarga, "||")
	arrDescrTipoCarga = Split(strListaDescrTipoCarga, "||")



	Response.Write("<form action='combinadacarga.asp' method='post' id='form1' name='form1' >" & vbCrLf)
	Response.Write("	<input type='hidden' name='hidSeqCombinada' id='hidSeqCombinada' value='" & intSeqCombinada & "' />" & vbCrLf)
	Response.Write("	<input type='hidden' name='hidIdUld' id='hidIdUld' value='" & strIdUld & "' />" & vbCrLf)
	Response.Write("<table border='0' align='center'  class='corpo9' width='1'>" & vbCrLf)
	Response.Write("	<tr>")
	Response.Write("		<td style='padding-left: 5px' align='right'>")
	Response.Write("			C&#243;digo:" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td style='padding-left: 5px'>")
	Response.Write("			<input type='text' name='txtCodigoUld' value='" & strIdUld & "' size='20' maxlength='20' id='txtCodigoUld' tabindex='1' style='text-transform:uppercase;' />" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td style='padding-left: 15px' align='right'>")
	Response.Write("			<label for='chkUld'>ULD:</label>" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td>")
	If (UCase(strFlgUld) = "N") Then
		Response.Write("			<input type='checkbox' id='chkUld' name='chkUld' value='ULD' tabindex='2' />" & vbCrLf)
	Else
		Response.Write("			<input type='checkbox' id='chkUld' name='chkUld' value='ULD' tabindex='2' checked='checked' />" & vbCrLf)
	End If
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td style='padding-left: 15px' align='right'>" & vbCrLf)
	Response.Write("			Peso&nbsp;Bruto&nbsp;da&nbsp;ULD:" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("			<input type='text' name='txtPesoBrutoUld' value='" & intPesoBrutoUld & "' size='4' maxlength='6' id='txtPesoBrutoUld' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='3' />" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("	</tr>")
	Response.Write("</table>")
	Response.Write("<table border='0' align='center'  class='corpo9' width='1'>" & vbCrLf)
	Response.Write("	<tr>")
	Response.Write("		<td style='padding-left: 10px'>")
	Response.Write("			<fieldset style='width:435px' align='center' >")
	Response.Write("				<legend>Carga</legend>")
	Response.Write("				<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)
	Response.Write("					<tr>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("							STD:" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("							<input type='text' name='txtCargaPagaSTD' value='" & intCargaPagaSTD & "' size='4' maxlength='6' id='txtCargaPagaSTD' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='4' />" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	Response.Write("							EXP:" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("							<input type='text' name='txtCargaPagaEXP' value='" & intCargaPagaEXP & "' size='4' maxlength='6' id='txtCargaPagaEXP' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='5' />" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	Response.Write("							COMAT/ULD:" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("							<input type='text' name='txtCargaGratis' value='" & intCargaGratis & "' size='4' maxlength='6' id='txtCargaGratis' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='6' />" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("							VAC:" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("							<input type='text' name='txtCorreioAo' value='" & intCorreioAo & "' size='4' maxlength='6' id='txtCorreioAo' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='7' />" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("					</tr>" & vbCrLf)
	Response.Write("				</table>")
	Response.Write("			</fieldset>")
	Response.Write("		</td>")
	Response.Write("		<td style='padding-left: 10px'>")
	Response.Write("			<fieldset style='width:275px' align='center' >")
	Response.Write("				<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)
	Response.Write("					<tr>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	Response.Write("							RPN:" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("							<input type='text' name='txtCorreioLc' value='" & intCorreioLc & "' size='4' maxlength='6' id='txtCorreioLc' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='8' />" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	Response.Write("							Cubagem (M<sup>3</sup>):" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 5px'>" & vbCrLf)
	' ***************
	' *** CUBAGEM ***
	' ***************
	Response.Write("							<select name='ddlCubagem' id='ddlCubagem' tabindex='9'>" & vbCrLf)
	Response.Write("								<option value=''>&nbsp;</option>" & vbCrLf)
	Dim strListaCubagem, arrCubagem
	strListaCubagem = "100||75||50||25||0"
	arrCubagem = Split(strListaCubagem, "||")
	Dim intCont4
	For intCont4 = LBound(arrCubagem) To UBound(arrCubagem)
		Response.Write("<option value='" & arrCubagem(intCont4) & "'")
		If (Not IsVazio(strCubagem)) Then
			If (CInt(arrCubagem(intCont4)) = CInt(strCubagem)) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrCubagem(intCont4) & "%</option>" & vbCrLf)
	Next
	Response.Write("							</select>" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("					</tr>" & vbCrLf)
	Response.Write("				</table>")
	Response.Write("			</fieldset>")
	Response.Write("		</td>")
	Response.Write("	</tr>")
	Response.Write("</table>")
	Response.Write("<table border='0' align='center'  class='corpo9' width='1'>" & vbCrLf)
	Response.Write("	<tr>")
	Response.Write("		<td>")
	Response.Write("			<fieldset style='width:250px' align='center' >")
	Response.Write("				<legend>SPL</legend>")
	Response.Write("				<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)
	Response.Write("					<tr>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	' ***********************
	' *** TIPO DE CARGA 1 ***
	' ***********************
	Response.Write("							<select name='ddlTipoCarga1' id='ddlTipoCarga1' tabindex='10'>" & vbCrLf)
	Response.Write("								<option value=''>&nbsp;</option>" & vbCrLf)
	Dim intCont1
	For intCont1 = 1 To UBound(arrCodTipoCarga)
		Response.Write("<option value='" & arrCodTipoCarga(intCont1) & "'")
		Response.Write(" title='" & arrDescrTipoCarga(intCont1) & "'")
		If (Not IsVazio(strCodTipoCarga1)) Then
			If (arrCodTipoCarga(intCont1) = strCodTipoCarga1) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrCodTipoCarga(intCont1) & "</option>" & vbCrLf)
	Next
	Response.Write("							</select>" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	' ***********************
	' *** TIPO DE CARGA 2 ***
	' ***********************
	Response.Write("							<select name='ddlTipoCarga2' id='ddlTipoCarga2' tabindex='11'>" & vbCrLf)
	Response.Write("								<option value=''>&nbsp;</option>" & vbCrLf)
	Dim intCont2
	For intCont2 = 1 To UBound(arrCodTipoCarga)
		Response.Write("<option value='" & arrCodTipoCarga(intCont2) & "'")
		Response.Write(" title='" & arrDescrTipoCarga(intCont2) & "'")
		If (Not IsVazio(strCodTipoCarga2)) Then
			If (arrCodTipoCarga(intCont2) = strCodTipoCarga2) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrCodTipoCarga(intCont2) & "</option>" & vbCrLf)
	Next
	Response.Write("							</select>" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("						<td style='padding-left: 10px' align='right'>" & vbCrLf)
	' ***********************
	' *** TIPO DE CARGA 3 ***
	' ***********************
	Response.Write("							<select name='ddlTipoCarga3' id='ddlTipoCarga3' tabindex='12'>" & vbCrLf)
	Response.Write("								<option value=''>&nbsp;</option>" & vbCrLf)
	Dim intCont3
	For intCont3 = 1 To UBound(arrCodTipoCarga)
		Response.Write("<option value='" & arrCodTipoCarga(intCont3) & "'")
		Response.Write(" title='" & arrDescrTipoCarga(intCont3) & "'")
		If (Not IsVazio(strCodTipoCarga3)) Then
			If (arrCodTipoCarga(intCont3) = strCodTipoCarga3) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrCodTipoCarga(intCont3) & "</option>" & vbCrLf)
	Next
	Response.Write("							</select>" & vbCrLf)
	Response.Write("						</td>" & vbCrLf)
	Response.Write("					</tr>" & vbCrLf)
	Response.Write("				</table>")
	Response.Write("			</fieldset>")
	Response.Write("		</td>")
	Response.Write("		<td style='padding-left: 10px'>")
	Response.Write("			Obs:" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("		<td>")
	Response.Write("			<input type='text' name='txtObservacao' value='" & strObservacao & "' size='50' maxlength='200' id='txtObservacao' tabindex='13' />" & vbCrLf)
	Response.Write("		</td>" & vbCrLf)
	Response.Write("	</tr>")
	Response.Write("</table>")
	Response.Write("	<table border='0' cellpadding='0' align='center' cellspacing='0' ID='Table3'>" & vbCrLf)
	Response.Write("		<tr style='padding-top: 20px;'>" & vbCrLf)
	Response.Write("			<td align='center' width='100%' colspan='6'>" & vbCrLf)
	Response.Write("				<input type='submit' value='Cancelar' name='btnCancelar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnCancelar' tabindex='20' />" & vbCrLf)
	Response.Write("				<input type='submit' value='Gravar' name='btnGravar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnGravar' tabindex='21' onclick='return VerificaCampos();'/>" & vbCrLf)
	Response.Write("				<input type='submit' value='Excluir' name='btnExcluir' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnExcluir' tabindex='22' />" & vbCrLf)
	Response.Write("				<input type='submit' value='Voltar' name='btnVoltar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnVoltar' tabindex='23' />" & vbCrLf)
	Response.Write("				<input type='button' id='btnImprimir' name='btnImprimir' value='Imprimir' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' tabindex='24' ")
	Response.Write(" onclick=""window.open('combinadacargaprint.asp?seqcombinada=" & intSeqCombinada & "','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=500');return false;"" ")
	Response.Write(" />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("		</tr>" & vbCrLf)
	Response.Write("	</table>" & vbCrLf)
	Response.Write("</form>" & vbCrLf)

	objConn.Close()
	Set objConn = Nothing

%>

	</body>
</html>


<%

Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function

%>
