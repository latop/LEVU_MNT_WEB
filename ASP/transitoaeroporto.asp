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

	Dim strMensagemErro, blnMostrarMensagemErro
	blnMostrarMensagemErro = False

	Dim strQueryUpdate
	Dim objRsPax, strQueryPax

	Dim strGravar, strVoltar, strCancelar, strExcluir
	strGravar = Request.Form("btnGravar")
	strVoltar = Request.Form("btnVoltar")
	strCancelar = Request.Form("btnCancelar")
	strExcluir = Request.Form("btnExcluir")

	Dim intSeqVooDia, intSeqTrecho, intSeqCombinada
	Dim intPorao1, intPorao2, intPorao3, intPorao4
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")
	intSeqCombinada = Request.QueryString("seqcombinada")
	intSeqAeropDest = Request.QueryString("seqaeropdest")
	
	Dim objConnUpdate
	Dim objRsPassageiros, strSqlPassageiros, strSqlUpdatePassageiros

	if (strVoltar <> "") then
		Response.Redirect("combinadaaeroporto.asp")
	elseif (strCancelar <> "") then
		intSeqCombinada = Request.Form("hidSeqCombinada")
		Response.Redirect("transitoaeroporto.asp?seqcombinada=" & intSeqCombinada)
	elseif (strExcluir <> "") then
		intSeqCombinada = Request.Form("hidSeqCombinada")
		intSeqAeropDest = Request.Form("hidSeqAeropDest")

		If (Not IsVazio(intSeqCombinada) And Not IsVazio(intSeqAeropDest)) Then
			Dim strQueryExcluir
			strQueryExcluir =                  " DELETE FROM sig_diariotrechocombtran "
			strQueryExcluir = strQueryExcluir & " WHERE seqvoodia = " & intSeqVooDia & " "
			strQueryExcluir = strQueryExcluir & "   AND seqtrecho = " & intSeqTrecho & " "
			strQueryExcluir = strQueryExcluir & "   AND seqcombinada = " & intSeqCombinada & " "
			strQueryExcluir = strQueryExcluir & "   AND seqaeropdest = " & intSeqAeropDest & " "

			Dim objConnExcluir
			Set objConnExcluir = CreateObject("ADODB.CONNECTION")
			objConnExcluir.Open (StringConexaoSqlServerUpdateEncriptado)
			objConnExcluir.BeginTrans
			objConnExcluir.Execute "SET DATEFORMAT ymd"

			'Enable error handling
			On Error Resume Next

			objConnExcluir.Execute(strQueryExcluir)
			If Err.number <> 0 Then
				strMensagemErro = "\nErro na exclusão de um registro da tabela sig_diariotrechocombtran\n" & Replace(Err.Description, "'", "\'")
			Else
				strMensagemErro = ""
			End If

			If (IsVazio(strMensagemErro)) Then
				' ****************************
				' *** ATUALIZA A COMBINADA ***
				' ****************************
				strQueryPax =               "SELECT sum(SDTCT.paxprimeira) paxprimeira, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxeconomica) paxeconomica, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxespecial) paxespecial, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxturismo) paxturismo, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxgratis) paxgratis, "
				strQueryPax = strQueryPax & "       sum(SDTCT.baglivre) baglivre, "
				strQueryPax = strQueryPax & "       sum(SDTCT.bagexcesso) bagexcesso, "
				strQueryPax = strQueryPax & "       sum(SDTCT.cargapaga) cargapaga, "
				strQueryPax = strQueryPax & "       sum(SDTCT.cargagratis) cargagratis, "
				strQueryPax = strQueryPax & "       sum(SDTCT.correioao) correioao, "
				strQueryPax = strQueryPax & "       sum(SDTCT.correiolc) correiolc, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxchd) paxchd, "
				strQueryPax = strQueryPax & "       sum(SDTCT.paxinf) paxinf "
				strQueryPax = strQueryPax & "  FROM sig_diariotrechocombtran SDTCT "
				strQueryPax = strQueryPax & " WHERE SDTCT.seqvoodia = " & intSeqVooDia
				strQueryPax = strQueryPax & "   AND SDTCT.seqtrecho = " & intSeqTrecho
				strQueryPax = strQueryPax & "   AND SDTCT.seqcombinada = " & intSeqCombinada

				Set objRsPax = Server.CreateObject("ADODB.Recordset")
				objRsPax.Open strQueryPax, objConnExcluir
				If Err.number <> 0 Then
					strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocombtran\n" & Replace(Err.Description, "'", "\'")
				Else
					strMensagemErro = ""
				End If

				If (IsVazio(strMensagemErro)) Then
					if IsNull(objRsPax("paxprimeira")) then
						strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
						strQueryUpdate = strQueryUpdate & " SET paxprimeiratran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxeconomicatran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxespecialtran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxturismotran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxgratistran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxchdtran = 0, "
						strQueryUpdate = strQueryUpdate & "     paxinftran = 0, "
						strQueryUpdate = strQueryUpdate & "     baglivretran = 0, "
						strQueryUpdate = strQueryUpdate & "     bagexcessotran = 0, "
						strQueryUpdate = strQueryUpdate & "     cargapagatran = 0, "
						strQueryUpdate = strQueryUpdate & "     cargagratistran = 0, "
						strQueryUpdate = strQueryUpdate & "     correioaotran = 0, "
						strQueryUpdate = strQueryUpdate & "     correiolctran = 0 "
						strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
						strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
						strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "
					else
						strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
						strQueryUpdate = strQueryUpdate & " SET paxprimeiratran = " & objRsPax("paxprimeira") & ", "
						strQueryUpdate = strQueryUpdate & "     paxeconomicatran = " & objRsPax("paxeconomica") & ", "
						strQueryUpdate = strQueryUpdate & "     paxespecialtran = " & objRsPax("paxespecial") & ", "
						strQueryUpdate = strQueryUpdate & "     paxturismotran = " & objRsPax("paxturismo") & ", "
						strQueryUpdate = strQueryUpdate & "     paxgratistran = " & objRsPax("paxgratis") & ", "
						strQueryUpdate = strQueryUpdate & "     paxchdtran = " & objRsPax("paxchd") & ", "
						strQueryUpdate = strQueryUpdate & "     paxinftran = " & objRsPax("paxinf") & ", "
						strQueryUpdate = strQueryUpdate & "     baglivretran = " & objRsPax("baglivre") & ", "
						strQueryUpdate = strQueryUpdate & "     bagexcessotran = " & objRsPax("bagexcesso") & ", "
						strQueryUpdate = strQueryUpdate & "     cargapagatran = " & objRsPax("cargapaga") & ", "
						strQueryUpdate = strQueryUpdate & "     cargagratistran = " & objRsPax("cargagratis") & ", "
						strQueryUpdate = strQueryUpdate & "     correioaotran = " & objRsPax("correioao") & ", "
						strQueryUpdate = strQueryUpdate & "     correiolctran = " & objRsPax("correiolc") & " "
						strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
						strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
						strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "
					end if

					objRsPax.Close()
					Set objRsPax = Nothing

					objConnExcluir.Execute(strQueryUpdate)
					If Err.number <> 0 Then
						strMensagemErro = "\nErro na atualização da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
					Else
						strMensagemErro = ""
					End If

					If (IsVazio(strMensagemErro)) Then
						' ********************************************
						' *** ATUALIZA PASSAGEIROS NA ETAPA BÁSICA ***
						' ********************************************
						strSqlPassageiros =                     "SELECT sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxpago, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxeconomica, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxpad, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxgratis, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxdhc) paxdhc, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.baglivre + SDTC.baglivretran) baglivre, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.bagexcesso + SDTC.bagexcessotran) bagexcesso, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargapaga + SDTC.cargapagatran) cargapaga, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargagratis + SDTC.cargagratistran) cargagratis, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correioao + SDTC.correioaotran) correioao, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correiolc + SDTC.correiolctran) correiolc, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxchd + SDTC.paxchdtran) paxchd, "
						strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxinf + SDTC.paxinftran) paxinf "
						strSqlPassageiros = strSqlPassageiros & "  FROM sig_diariotrechocomb SDTC "
						strSqlPassageiros = strSqlPassageiros & " WHERE SDTC.seqvoodia = " & intSeqVooDia
						strSqlPassageiros = strSqlPassageiros & "   AND SDTC.seqtrecho <= " & intSeqTrecho
						strSqlPassageiros = strSqlPassageiros & "   AND (select Min(seqtrecho) "
						strSqlPassageiros = strSqlPassageiros & "          from sig_diariotrecho SDT2 "
						strSqlPassageiros = strSqlPassageiros & "         where SDT2.seqvoodia = SDTC.seqvoodia "
						strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqaeropdest = SDTC.seqaeropdest "
						strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqtrecho >= SDTC.seqtrecho) >= " & intSeqTrecho
						Set objRsPassageiros = Server.CreateObject("ADODB.Recordset")
						objRsPassageiros.Open strSqlPassageiros, objConnExcluir
						If Err.number <> 0 Then
							strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
						Else
							strMensagemErro = ""
						End If

						If (IsVazio(strMensagemErro)) Then
							strSqlUpdatePassageiros =                           " UPDATE sig_diariotrecho "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & " SET paxpago      = " & CInt(ObjRsPassageiros("paxpago")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxeconomica = " & CInt(ObjRsPassageiros("paxeconomica")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxpad       = " & CInt(ObjRsPassageiros("paxpad")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxgratis    = " & CInt(ObjRsPassageiros("paxgratis")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxdhc       = " & CInt(ObjRsPassageiros("paxdhc")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     baglivre     = " & CInt(ObjRsPassageiros("baglivre")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     bagexcesso   = " & CInt(ObjRsPassageiros("bagexcesso")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargapaga    = " & CInt(ObjRsPassageiros("cargapaga")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargagratis  = " & CInt(ObjRsPassageiros("cargagratis")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxchd       = " & CInt(ObjRsPassageiros("paxchd")) & ", "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxinf       = " & CInt(ObjRsPassageiros("paxinf")) & " "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & " WHERE seqvoodia=" & intSeqVooDia & " "
							strSqlUpdatePassageiros = strSqlUpdatePassageiros & "   AND seqtrecho=" & intSeqTrecho & " "

							objRsPassageiros.Close()
							Set objRsPassageiros = Nothing

							objConnExcluir.Execute(strSqlUpdatePassageiros)
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
				If (blnMostrarMensagemErro) Then
					Response.Write("<script language='javascript'>alert('" & strMensagemErro & "');</script>")
					'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
				Else
					Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
					'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
				End If
			End If

			objConnExcluir.Close()
			Set objConnExcluir = Nothing

			'Reset error handling
			On Error Goto 0
		Else
			Response.Write("<script language='javascript'>alert('Favor selecionar um registro!');</script>")
		End If

	elseif (strGravar <> "") then
		Dim hidSeqAeropDest
		intSeqCombinada = Request.Form("hidSeqCombinada")
		hidSeqAeropDest = Request.Form("hidSeqAeropDest")

		Dim strTxtddlAerop, strTxtPaxEconomica, strTxtPaxGratis, strTxtPaxCHD, strTxtPaxInf
		Dim strTxtBagLivre, strTxtBagExcesso, strTxtCargaPaga, strTxtCargaGratis, strTxtNrVoo
		Dim strTxtPorao1, strTxtPorao2, strTxtPorao3, strTxtPorao4
		strTxtddlAerop = Request.Form("ddlAerop")
		intSeqAeropdest = CInt(strTxtddlAerop)
		strTxtPaxEconomica = Request.Form("hdPaxEconomica")
		strTxtPaxGratis = Request.Form("txtPaxGratis")
		strTxtPaxCHD = Request.Form("txtPaxCHD")
		strTxtPaxInf = Request.Form("txtPaxInf")
		strTxtBagLivre = Request.Form("txtBagLivre")
		strTxtBagExcesso = Request.Form("txtBagExcesso")
		strTxtCargaPaga = Request.Form("txtCargaPaga")
		strTxtCargaGratis = Request.Form("txtCargaGratis")
		strTxtNrVoo = Request.Form("txtNrVoo")
		strTxtPorao1 = Request.Form("txtPorao1")
		strTxtPorao2 = Request.Form("txtPorao2")
		strTxtPorao3 = Request.Form("txtPorao3")
		strTxtPorao4 = Request.Form("txtPorao4")
		
		'Response.Write(strTxtPaxEconomica & "<br>" & strTxtPaxGratis & "<br>" &  strTxtPaxCHD & "<br>" & strTxtPaxInf)
		'Response.End()

		if strTxtPaxCHD = "" then strTxtPaxCHD = "0"
		if strTxtPaxInf = "" then strTxtPaxInf = "0"
		
		if ((hidSeqAeropDest <> "") and (IsNumeric(hidSeqAeropDest))) then
			strQueryUpdate =                  " UPDATE sig_diariotrechocombtran "
			strQueryUpdate = strQueryUpdate & " SET paxeconomica = " & strTxtPaxEconomica & ", "
			strQueryUpdate = strQueryUpdate & "     paxgratis = " & strTxtPaxGratis & ", "
			strQueryUpdate = strQueryUpdate & "     paxchd = " & strTxtPaxCHD & ", "
			strQueryUpdate = strQueryUpdate & "     paxinf = " & strTxtPaxInf & ", "
			strQueryUpdate = strQueryUpdate & "     baglivre = " & strTxtBagLivre & ", "
			strQueryUpdate = strQueryUpdate & "     bagexcesso = " & strTxtBagExcesso & ", "
			strQueryUpdate = strQueryUpdate & "     cargapaga = " & strTxtCargaPaga & ", "
			strQueryUpdate = strQueryUpdate & "     cargagratis = " & strTxtCargaGratis & ", "
			strQueryUpdate = strQueryUpdate & "     nrvoo = " & strTxtNrVoo & ", "
			strQueryUpdate = strQueryUpdate & "     porao1 = " & strTxtPorao1 & ", "
			strQueryUpdate = strQueryUpdate & "     porao2 = " & strTxtPorao2 & ", "
			strQueryUpdate = strQueryUpdate & "     porao3 = " & strTxtPorao3 & ", "
			strQueryUpdate = strQueryUpdate & "     porao4 = " & strTxtPorao4 & " "
			strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
			strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
			strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinada & " "
			strQueryUpdate = strQueryUpdate & "   AND seqaeropdest = " & hidSeqAeropDest & " "
		elseif (intSeqAeropDest > 0) then
			strQueryUpdate =                  " INSERT INTO sig_diariotrechocombtran  "
			strQueryUpdate = strQueryUpdate & "         ( seqvoodia, seqtrecho, seqcombinada, seqaeropdest, "
			strQueryUpdate = strQueryUpdate & "           paxprimeira, paxeconomica, paxespecial, paxturismo, paxgratis, "
			strQueryUpdate = strQueryUpdate & "           baglivre, bagexcesso, cargapaga, cargagratis, correioao, correiolc, "
			strQueryUpdate = strQueryUpdate & "           paxchd, paxinf, nrvoo, porao1, porao2, porao3, porao4 ) "
			strQueryUpdate = strQueryUpdate & "  VALUES ( " & intSeqVooDia & ", "
			strQueryUpdate = strQueryUpdate & "           " & intSeqTrecho & ", "
			strQueryUpdate = strQueryUpdate & "           " & intSeqCombinada & ", "
			strQueryUpdate = strQueryUpdate & "           " & intSeqAeropdest & ", "
			strQueryUpdate = strQueryUpdate & "           0, " 
			strQueryUpdate = strQueryUpdate & "           " & strTxtPaxEconomica & ", "
			strQueryUpdate = strQueryUpdate & "           0, "
			strQueryUpdate = strQueryUpdate & "           0, "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPaxGratis & ", " 
			strQueryUpdate = strQueryUpdate & "           " & strTxtBagLivre & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtBagExcesso & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtCargaPaga & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtCargaGratis & ", "
			strQueryUpdate = strQueryUpdate & "           0, "
			strQueryUpdate = strQueryUpdate & "           0, "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPaxCHD & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPaxInf & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtNrVoo & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPorao1 & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPorao2 & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPorao3 & ", "
			strQueryUpdate = strQueryUpdate & "           " & strTxtPorao4 & ") "
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
			strMensagemErro = "\nErro na atualização/inclusão de um registro na tabela sig_diariotrechocombtran\n" & Replace(Err.Description, "'", "\'")
		Else
			strMensagemErro = ""
		End If

		If (IsVazio(strMensagemErro)) Then
			' ****************************
			' *** ATUALIZA A COMBINADA ***
			' ****************************
			strQueryPax =                     "SELECT sum(SDTCT.paxprimeira) paxprimeira, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxeconomica) paxeconomica, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxespecial) paxespecial, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxturismo) paxturismo, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxgratis) paxgratis, "
			strQueryPax = strQueryPax & "       sum(SDTCT.baglivre) baglivre, "
			strQueryPax = strQueryPax & "       sum(SDTCT.bagexcesso) bagexcesso, "
			strQueryPax = strQueryPax & "       sum(SDTCT.cargapaga) cargapaga, "
			strQueryPax = strQueryPax & "       sum(SDTCT.cargagratis) cargagratis, "
			strQueryPax = strQueryPax & "       sum(SDTCT.correioao) correioao, "
			strQueryPax = strQueryPax & "       sum(SDTCT.correiolc) correiolc, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxchd) paxchd, "
			strQueryPax = strQueryPax & "       sum(SDTCT.paxinf) paxinf, "
			strQueryPax = strQueryPax & "       sum(SDTCT.porao1) porao1, "
			strQueryPax = strQueryPax & "       sum(SDTCT.porao2) porao2, "
			strQueryPax = strQueryPax & "       sum(SDTCT.porao3) porao3, "
			strQueryPax = strQueryPax & "       sum(SDTCT.porao4) porao4 "
			strQueryPax = strQueryPax & "  FROM sig_diariotrechocombtran SDTCT "
			strQueryPax = strQueryPax & " WHERE SDTCT.seqvoodia = " & intSeqVooDia
			strQueryPax = strQueryPax & "   AND SDTCT.seqtrecho = " & intSeqTrecho
			strQueryPax = strQueryPax & "   AND SDTCT.seqcombinada = " & intSeqCombinada
			Set objRsPax = Server.CreateObject("ADODB.Recordset")
			objRsPax.Open strQueryPax, objConnGravar
			If Err.number <> 0 Then
				strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocombtran\n" & Replace(Err.Description, "'", "\'")
			Else
				strMensagemErro = ""
			End If

			If (IsVazio(strMensagemErro)) Then
				strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
				strQueryUpdate = strQueryUpdate & " SET paxprimeiratran = " & objRsPax("paxprimeira") & ", "
				strQueryUpdate = strQueryUpdate & "     paxeconomicatran = " & objRsPax("paxeconomica") & ", "
				strQueryUpdate = strQueryUpdate & "     paxespecialtran = " & objRsPax("paxespecial") & ", "
				strQueryUpdate = strQueryUpdate & "     paxturismotran = " & objRsPax("paxturismo") & ", "
				strQueryUpdate = strQueryUpdate & "     paxgratistran = " & objRsPax("paxgratis") & ", "
				strQueryUpdate = strQueryUpdate & "     paxchdtran = " & objRsPax("paxchd") & ", "
				strQueryUpdate = strQueryUpdate & "     paxinftran = " & objRsPax("paxinf") & ", "
				strQueryUpdate = strQueryUpdate & "     baglivretran = " & objRsPax("baglivre") & ", "
				strQueryUpdate = strQueryUpdate & "     bagexcessotran = " & objRsPax("bagexcesso") & ", "
				strQueryUpdate = strQueryUpdate & "     cargapagatran = " & objRsPax("cargapaga") & ", "
				strQueryUpdate = strQueryUpdate & "     cargagratistran = " & objRsPax("cargagratis") & ", "
				strQueryUpdate = strQueryUpdate & "     correioaotran = " & objRsPax("correioao") & ", "
				strQueryUpdate = strQueryUpdate & "     correiolctran = " & objRsPax("correiolc") & ", "
				strQueryUpdate = strQueryUpdate & "     porao1tran = " & objRsPax("porao1") & ", "
				strQueryUpdate = strQueryUpdate & "     porao2tran = " & objRsPax("porao2") & ", "
				strQueryUpdate = strQueryUpdate & "     porao3tran = " & objRsPax("porao3") & ", "
				strQueryUpdate = strQueryUpdate & "     porao4tran = " & objRsPax("porao4") & " "
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
					' ********************************************
					' *** ATUALIZA PASSAGEIROS NA ETAPA BÁSICA ***
					' ********************************************
					strSqlPassageiros =                     "SELECT sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxpago, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxeconomica, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxpad, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxgratis, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxdhc) paxdhc, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.baglivre + SDTC.baglivretran) baglivre, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.bagexcesso + SDTC.bagexcessotran) bagexcesso, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargapaga + SDTC.cargapagatran) cargapaga, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.cargagratis + SDTC.cargagratistran) cargagratis, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correioao + SDTC.correioaotran) correioao, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.correiolc + SDTC.correiolctran) correiolc, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxchd + SDTC.paxchdtran) paxchd, "
					strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxinf + SDTC.paxinftran) paxinf "
					strSqlPassageiros = strSqlPassageiros & "  FROM sig_diariotrechocomb SDTC "
					strSqlPassageiros = strSqlPassageiros & " WHERE SDTC.seqvoodia = " & intSeqVooDia
					strSqlPassageiros = strSqlPassageiros & "   AND SDTC.seqtrecho <= " & intSeqTrecho
					strSqlPassageiros = strSqlPassageiros & "   AND (select Min(seqtrecho) "
					strSqlPassageiros = strSqlPassageiros & "          from sig_diariotrecho SDT2 "
					strSqlPassageiros = strSqlPassageiros & "         where SDT2.seqvoodia = SDTC.seqvoodia "
					strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqaeropdest = SDTC.seqaeropdest "
					strSqlPassageiros = strSqlPassageiros & "           and SDT2.seqtrecho >= SDTC.seqtrecho) >= " & intSeqTrecho
					Set objRsPassageiros = Server.CreateObject("ADODB.Recordset")
					objRsPassageiros.Open strSqlPassageiros, objConnGravar
					If Err.number <> 0 Then
						strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
					Else
						strMensagemErro = ""
					End If

					If (IsVazio(strMensagemErro)) Then
						strSqlUpdatePassageiros =                           " UPDATE sig_diariotrecho "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & " SET paxpago      = " & CInt(ObjRsPassageiros("paxpago")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxeconomica = " & CInt(ObjRsPassageiros("paxeconomica")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxpad       = " & CInt(ObjRsPassageiros("paxpad")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxgratis    = " & CInt(ObjRsPassageiros("paxgratis")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxdhc       = " & CInt(ObjRsPassageiros("paxdhc")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     baglivre     = " & CInt(ObjRsPassageiros("baglivre")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     bagexcesso   = " & CInt(ObjRsPassageiros("bagexcesso")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargapaga    = " & CInt(ObjRsPassageiros("cargapaga")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargagratis  = " & CInt(ObjRsPassageiros("cargagratis")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxchd       = " & CInt(ObjRsPassageiros("paxchd")) & ", "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxinf       = " & CInt(ObjRsPassageiros("paxinf")) & " "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & " WHERE seqvoodia=" & intSeqVooDia & " "
						strSqlUpdatePassageiros = strSqlUpdatePassageiros & "   AND seqtrecho=" & intSeqTrecho & " "

						objRsPassageiros.Close()
						Set objRsPassageiros = Nothing

						objConnGravar.Execute(strSqlUpdatePassageiros)
						If Err.number <> 0 Then
							strMensagemErro = "\nErro na atualização da tabela sig_diariotrecho\n" & Replace(Err.Description, "'", "\'")
						Else
							strMensagemErro = ""
						End If

						If (IsVazio(strMensagemErro)) Then
							Dim strSqlVerificaCapac
							strSqlVerificaCapac =                          " SELECT DT.paxpago, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        DT.paxpad, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        DT.baglivre, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        DT.bagexcesso, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        DT.cargapaga, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        DT.cargagratis, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        SA.capac_pax, "
							strSqlVerificaCapac = strSqlVerificaCapac & "        SA.capac_cga "
							strSqlVerificaCapac = strSqlVerificaCapac & " FROM sig_diariotrecho DT "
							strSqlVerificaCapac = strSqlVerificaCapac & "      INNER JOIN sig_aeronave SA ON SA.prefixored = DT.prefixoaeronave "
							strSqlVerificaCapac = strSqlVerificaCapac & " WHERE DT.seqvoodia = " & intSeqVooDia & " "
							strSqlVerificaCapac = strSqlVerificaCapac & "   AND DT.seqtrecho = " & intSeqTrecho & " "

							Dim objRsVerificaCapac
							Set objRsVerificaCapac = Server.CreateObject("ADODB.Recordset")
							objRsVerificaCapac.Open strSqlVerificaCapac, objConnGravar
							If Err.number <> 0 Then
								strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrecho X sig_aeronave\n" & Replace(Err.Description, "'", "\'")
							Else
								strMensagemErro = ""
								If (Not objRsVerificaCapac.EOF) Then
									Dim intVerifCapacPax
									intVerifCapacPax = objRsVerificaCapac("capac_pax")
									If (Not IsVazio(intVerifCapacPax)) Then
										intVerifCapacPax = CLng(intVerifCapacPax)

										Dim intVerifPaxPago
										intVerifPaxPago = objRsVerificaCapac("paxpago")
										If (IsVazio(intVerifPaxPago)) Then
											intVerifPaxPago = CLng(0)
										Else
											intVerifPaxPago = CLng(intVerifPaxPago)
										End If

										Dim intVerifPaxPad
										intVerifPaxPad = objRsVerificaCapac("paxpad")
										If (IsVazio(intVerifPaxPad)) Then
											intVerifPaxPad = CLng(0)
										Else
											intVerifPaxPad = CLng(intVerifPaxPad)
										End If

										If ((intVerifPaxPago + intVerifPaxPad) > intVerifCapacPax) Then
											strMensagemErro = "A capacidade de passageiros foi excedida. Capacidade Máxima: " & intVerifCapacPax
											blnMostrarMensagemErro = True
										End If
									End If
									If (IsVazio(strMensagemErro)) Then
										Dim intVerifCapacCga
										intVerifCapacCga = objRsVerificaCapac("capac_cga")
										If (Not IsVazio(intVerifCapacCga)) Then
											intVerifCapacCga = CLng(intVerifCapacCga)

											Dim intVerifBagLivre
											intVerifBagLivre = objRsVerificaCapac("baglivre")
											If (IsVazio(intVerifBagLivre)) Then
												intVerifBagLivre = CLng(0)
											Else
												intVerifBagLivre = CLng(intVerifBagLivre)
											End If

											Dim intVerifBagExcesso
											intVerifBagExcesso = objRsVerificaCapac("bagexcesso")
											If (IsVazio(intVerifBagExcesso)) Then
												intVerifBagExcesso = CLng(0)
											Else
												intVerifBagExcesso = CLng(intVerifBagExcesso)
											End If

											Dim intVerifCargaPaga
											intVerifcargapaga = objRsVerificaCapac("cargapaga")
											If (IsVazio(intVerifCargaPaga)) Then
												intVerifCargaPaga = CLng(0)
											Else
												intVerifCargaPaga = CLng(intVerifCargaPaga)
											End If

											Dim intVerifCargaGratis
											intVerifCargaGratis = objRsVerificaCapac("cargagratis")
											If (IsVazio(intVerifCargaGratis)) Then
												intVerifCargaGratis = CLng(0)
											Else
												intVerifCargaGratis = CLng(intVerifCargaGratis)
											End If

											If ((intVerifBagLivre + intVerifBagExcesso + intVerifCargaPaga + intVerifCargaGratis) > intVerifCapacCga) Then
												strMensagemErro = "A capacidade de carga foi excedida. Capacidade Máxima: " & intVerifCapacCga
												blnMostrarMensagemErro = True
											End If
										End If
									End If
								End If
							End If

							objRsVerificaCapac.Close()
							Set objRsVerificaCapac = Nothing

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
			If (blnMostrarMensagemErro) Then
				Response.Write("<script language='javascript'>alert('" & strMensagemErro & "');</script>")
				'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
			Else
				Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
				'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
			End If
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
	Dim strNomeAeropOrig, strCodAeropOrig, strNomeAeropConexao, strCodAeropConexao
	Dim ls_flgporao1, ls_flgporao2, ls_flgporao3, ls_flgporao4
	
	strQueryAeroporto =                     " SELECT seqaeroporto, codiata, nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto "
	strQueryAeroporto = strQueryAeroporto & "  WHERE seqaeroporto = " & intSeqAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeropOrig = objRsAeroporto("nomeaeroporto")
	strCodAeropOrig = objRsAeroporto("codiata")
	objRsAeroporto.Close

	if(IsNumeric(intSeqCombinada)) then
		intSeqCombinada = intSeqCombinada
	else
		intSeqCombinada = Request.Form("hidSeqCombinada")
	end if
	
	' *************************************
	' *** DADOS DO AEROPORTO DA CONEXÃO ***
	' *************************************
	strQueryAeroporto =                     " SELECT AEROP.seqaeroporto, AEROP.codiata, AEROP.nomeaeroporto, "
	strQueryAeroporto = strQueryAeroporto & "        SA.flgporao1, SA.flgporao2, SA.flgporao3, SA.flgporao4 "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto AEROP, sig_diariotrechocomb SDTC, sig_diariotrecho SDT, sig_aeronave SA "
	strQueryAeroporto = strQueryAeroporto & "  WHERE AEROP.seqaeroporto = SDTC.seqaeropdest "
	strQueryAeroporto = strQueryAeroporto & "    AND SDT.seqvoodia = SDTC.seqvoodia "
	strQueryAeroporto = strQueryAeroporto & "    AND SDT.seqtrecho = SDTC.seqtrecho "
	strQueryAeroporto = strQueryAeroporto & "    AND SDT.prefixoaeronave = SA.prefixored "
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqvoodia = " & intSeqVooDia
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqtrecho = " & intSeqTrecho
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqcombinada = " & intSeqCombinada
'	response.write("strQueryAeroporto: " & strQueryAeroporto)
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeropConexao = objRsAeroporto("nomeaeroporto")
	strCodAeropConexao = objRsAeroporto("codiata")
	ls_flgporao1 = objRsAeroporto("flgporao1")
	ls_flgporao2 = objRsAeroporto("flgporao2")
	ls_flgporao3 = objRsAeroporto("flgporao3")
	ls_flgporao4 = objRsAeroporto("flgporao4")
	If IsNull(ls_flgporao1) Then ls_flgporao1 = "N"
	If IsNull(ls_flgporao2) Then ls_flgporao2 = "N"
	If IsNull(ls_flgporao3) Then ls_flgporao3 = "N"
	If IsNull(ls_flgporao4) Then ls_flgporao4 = "N"
	
	objRsAeroporto.Close

	' ****************
	' *** TRANSITO ***
	' ****************
	Dim objRs, strQuery
	strQuery =            " SELECT SDTCT.seqvoodia, SDTCT.seqtrecho, SDTCT.seqcombinada, "
	strQuery = strQuery & "        SDTCT.seqaeropdest, AERDEST.codiata,  "
	strQuery = strQuery & "        SDTCT.paxeconomica, SDTCT.paxgratis, SDTCT.paxchd, SDTCT.paxinf, "
	strQuery = strQuery & "        SDTCT.baglivre, SDTCT.bagexcesso, "
	strQuery = strQuery & "        SDTCT.cargapaga, SDTCT.cargagratis, SDTCT.nrvoo "
	strQuery = strQuery & " FROM sig_diariotrechocombtran SDTCT, sig_aeroporto AERDEST "
	strQuery = strQuery & " WHERE SDTCT.seqaeropdest = AERDEST.seqaeroporto "
	strQuery = strQuery & "   AND SDTCT.seqvoodia=" & intSeqVooDia & " "
	strQuery = strQuery & "   AND SDTCT.seqtrecho=" & intSeqTrecho & " "
	strQuery = strQuery & "   AND SDTCT.seqcombinada=" & intSeqCombinada & " "
'	response.write("strQuery: " & strQuery)
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	' ***************************
	' *** Aeroportos da Lista ***
	' ***************************
	Dim objRsListaAerop, strQueryListaAerop
	strQueryListaAerop = " SELECT seqaeroporto, codiata "
	strQueryListaAerop = strQueryListaAerop & "   FROM sig_aeroporto "
	strQueryListaAerop = strQueryListaAerop & " WHERE sig_aeroporto.codiata IS NOT NULL "
	strQueryListaAerop = strQueryListaAerop & "  ORDER BY codiata "
	Set objRsListaAerop = Server.CreateObject("ADODB.Recordset")
	objRsListaAerop.Open strQueryListaAerop, objConn

%>

<html>
	<head>
		<title>Aeroportos</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
      <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<script src="javascript.js"></script>
      <script src="jquery-1.1.4.js"></script>
     	<STYLE type="text/css">
		   .input_rigthText{
				text-align: right;
			}
		</style>	 
		<script language="javascript">
		$(document).ready(function() {
			$("#txtPaxGratis").css("text-align","right");
			$("#txtPaxADT").css("text-align","right");
			$("#txtPaxEconomica").css("text-align","right");
			$("#txtPaxCHD").css("text-align","right");
			$("#txtPaxInf").css("text-align","right");
			$("#txtBagLivre").css("text-align","right");
			$("#txtBagExcesso").css("text-align","right");
			$("#txtCargaPaga").css("text-align","right");
			$("#txtCargaGratis").css("text-align","right");
			$("#txtPorao1").css("text-align","right");
			$("#txtPorao2").css("text-align","right");
			$("#txtPorao3").css("text-align","right");
			$("#txtPorao4").css("text-align","right");
		});
		
			
		function CalculaVolume(){
				var Parametro1=document.form1.txtPaxADT.value;
				var Parametro2=document.form1.txtPaxCHD.value;
				var Soma=0;
				//isNaN = Verifica se o valor pode ser convertido para um número, se não puder ser ele devolve NaN
				if (isNaN(Parametro1) || isNaN(Parametro2) || Parametro1=='' || Parametro2=='') {
					Soma=0
				}
				else
				{
					Soma=((parseInt(Parametro1))+(parseInt(Parametro2)));
				}
				document.form1.txtPaxEconomica.value=Soma;
				document.form1.hdPaxEconomica.value=Soma;					
			}  
			function VerificaCampos() {
				if (window.form1.ddlAerop.value == '-1') {
					alert('Preencha o campo Aerop. Dest, por favor!');
					window.form1.ddlAerop.focus();
					return false;
				}
				else if (window.form1.txtNrVoo.value == '') {
					alert('Preencha o campo Voo, por favor!');
					window.form1.txtNrVoo.focus();
					return false;
				}
				else if (window.form1.txtPaxADT.value == '') {
					alert('Preencha o campo Passageiros ADT, por favor!');
					window.form1.txtPaxADT.focus();
					return false;
				}
				else if (window.form1.txtPaxCHD.value == '') {
					alert('Preencha o campo Passageiros CHD, por favor!');
					window.form1.txtPaxCHD.focus();
					return false;
				}
				else if (window.form1.txtPaxInf.value == '') {
					alert('Preencha o campo Passageiros Inf, por favor!');
					window.form1.txtPaxInf.focus();
					return false;
				}
				else if (window.form1.txtPaxGratis.value == '') {
					alert('Preencha o campo Passageiros PAD, por favor!');
					window.form1.txtPaxGratis.focus();
					return false;
				}
				else if (window.form1.txtBagLivre.value == '') {
					alert('Preencha o campo bagagem livre, por favor!');
					window.form1.txtBagLivre.focus();
					return false;
				}
				else if (window.form1.txtBagExcesso.value == '') {
					alert('Preencha o campo bagagem excesso, por favor!');
					window.form1.txtBagExcesso.focus();
					return false;
				}
				else if (window.form1.txtBagExcesso.value == '') {
					alert('Preencha o campo bagagem excesso, por favor!');
					window.form1.txtBagExcesso.focus();
					return false;
				}
				else if (window.form1.txtCargaPaga.value == '') {
					alert('Preencha o campo carga paga, por favor!');
					window.form1.txtCargaPaga.focus();
					return false;
				}
				else if (window.form1.txtCargaGratis.value == '') {
					alert('Preencha o campo carga grátis, por favor!');
					window.form1.txtCargaGratis.focus();
					return false;
				}
				else if (window.form1.txtPorao1.value == '') {
					alert('Preencha o campo porão 1, por favor!');
					window.form1.txtPorao1.focus();
					return false;
				}
				else if (window.form1.txtPorao2.value == '') {
					alert('Preencha o campo porão 2, por favor!');
					window.form1.txtPorao2.focus();
					return false;
				}
				else if (window.form1.txtPorao3.value == '') {
					alert('Preencha o campo porão 3, por favor!');
					window.form1.txtPorao3.focus();
					return false;
				}
				else if (window.form1.txtPorao4.value == '') {
					alert('Preencha o campo porão 4, por favor!');
					window.form1.txtPorao4.focus();
					return false;
				}
				else if ( (Number(window.form1.txtBagLivre.value) + Number(window.form1.txtBagExcesso.value) + Number(window.form1.txtCargaPaga.value) + Number(window.form1.txtCargaGratis.value)) != (Number(window.form1.txtPorao1.value) + Number(window.form1.txtPorao2.value) + Number(window.form1.txtPorao3.value) + Number(window.form1.txtPorao4.value) ) && ( window.form1.txtFlgPorao1.value=='S' || window.form1.txtFlgPorao2.value=='S' || window.form1.txtFlgPorao3.value=='S' || window.form1.txtFlgPorao4.value=='S') ) {
				alert('O somatório do peso dos porões deve ser igual ao total dos pesos de bagagens e carga!');
					window.form1.txtBagLivre.focus();
					return false;
				}
			}
		</script>
	</head>
	<body>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="left">
					<font size="5"><b>Conexão
					<% Response.Write("  (" & strCodAeropOrig & " -> " & strCodAeropConexao & ")")%></b></font>
				</td>
            <td align="right">
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
		<table border='1' cellpadding='0' align="center" cellspacing='0' ID='Table2'>
			<tr bgcolor='#AAAAAA'>
         	<th class="CORPO9" colspan="2">&nbsp;</th>
            <th class="CORPO9" colspan="5" >Passageiros</th>
            <th class="CORPO9" colspan="2" >Bagagem</th>
            <th class="CORPO9" colspan="2" >Carga</th>           
         </tr>
         <tr bgcolor='#AAAAAA'>
				<th class='CORPO9' width='83' >Destino</th>
            <th class='CORPO9' width='83' >Voo</th>
				<th class='CORPO9' width='83' >ADT</th>
				<th class='CORPO9' width='83' >CHD</th>
				<th class='CORPO9' width='83' >INF</th>
				<th class='CORPO9' width='83' >PAGO</th>
            <th class='CORPO9' width='83' >PAD</th>
				<th class='CORPO9' width='83' >Livre</th>
				<th class='CORPO9' width='83' >Excesso</th>
				<th class='CORPO9' width='83' >Paga</th>
				<th class='CORPO9' width='83' >Grátis</th>
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
		
		Dim ll_PaxAdt, ll_PaxChd, ll_PaxInf, ll_PaxPago, ll_PaxPad, ll_SeqCombinada
		
		ll_SeqCombinada = objRs("seqcombinada")		
		ll_PaxPago = cInt(objRs("paxeconomica"))
		ll_PaxAdt  = cInt(ll_PaxPago) - CInt(objRs("paxchd"))		
		ll_PaxChd  = cInt(objRs("paxchd"))
		ll_PaxInf  = cInt(objRs("paxinf"))
		ll_PaxPad  = cInt(objRs("paxgratis"))

		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='transitoaeroporto.asp?seqcombinada=" & intSeqCombinada & "&seqaeropdest=" & objRs("seqaeropdest") & "'>" & vbCrLf)
		Response.Write("		" & objRs("codiata") & "</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & objRs("nrvoo") & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxAdt & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxChd & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxInf & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxPago & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxPad & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & cInt(objRs("baglivre")) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & cInt(objRs("bagexcesso")) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & cInt(objRs("cargapaga")) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & cInt(objRs("cargagratis")) & "&nbsp;</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		objRs.movenext
	loop

	objRs.Close
	Set objRs = Nothing
%>
			<tr>
				<th colspan="8"></th>
			</tr>
		</table>
      <br>
      <table border="0" align="center">
      	<tr>
          <td>

<%
   'Response.Write(objRsAeroporto("capac_cga") & " ; " & objRsAeroporto("capac_pax"))
	'Response.End()
	Dim intSeqAeropdest
	Dim strNomeAeropDest, strCodIataDest, intNrVoo
	Dim intPaxEconomica, intPaxGratis, intPaxChd, intPaxInf
	Dim intBagLivre, intBagExcesso, intCargaPaga, intCargaGratis

	intSeqAeropdest = Request.QueryString("seqaeropdest")
	if ((intSeqAeropdest > "") and (IsNumeric(intSeqAeropdest))) then

		' ****************************
		' *** TRANSITO SELECIONADO ***
		' ****************************
		Dim objRsTranSel, strQueryTranSel
		strQueryTranSel =                   " SELECT SDTCT.seqvoodia, SDTCT.seqtrecho, SDTCT.seqcombinada, "
		strQueryTranSel = strQueryTranSel & "        SDTCT.seqaeropdest, AERDEST.nomeaeroporto, AERDEST.codiata,  "
		strQueryTranSel = strQueryTranSel & "        SDTCT.paxeconomica, SDTCT.paxgratis, SDTCT.paxchd, SDTCT.paxinf, "
		strQueryTranSel = strQueryTranSel & "        SDTCT.baglivre, SDTCT.bagexcesso, "
		strQueryTranSel = strQueryTranSel & "        SDTCT.cargapaga, SDTCT.cargagratis, SDTCT.nrvoo, "
		strQueryTranSel = strQueryTranSel & "        SDTCT.Porao1, SDTCT.Porao2, SDTCT.Porao3, SDTCT.Porao4 "
		strQueryTranSel = strQueryTranSel & " FROM sig_diariotrechocombtran SDTCT, sig_aeroporto AERDEST "
		strQueryTranSel = strQueryTranSel & " WHERE SDTCT.seqaeropdest = AERDEST.seqaeroporto "
		strQueryTranSel = strQueryTranSel & "   AND SDTCT.seqvoodia=" & intSeqVooDia & " "
		strQueryTranSel = strQueryTranSel & "   AND SDTCT.seqtrecho=" & intSeqTrecho & " "
		strQueryTranSel = strQueryTranSel & "   AND SDTCT.seqcombinada=" & intSeqCombinada & " "
		strQueryTranSel = strQueryTranSel & "   AND SDTCT.seqaeropdest=" & intSeqAeropdest & " "

		Set objRsTranSel = Server.CreateObject("ADODB.Recordset")
		objRsTranSel.Open strQueryTranSel, objConn

		strNomeAeropDest = objRsTranSel("nomeaeroporto")
		strCodIataDest = objRsTranSel("codiata")
		intNrVoo = objRsTranSel("nrvoo")
		intPaxEconomica = objRsTranSel("paxeconomica")
		ll_PaxAdt  = cInt(intPaxEconomica) - CInt(objRsTranSel("paxchd"))	
		intPaxGratis = objRsTranSel("paxgratis")
		intPaxChd = objRsTranSel("paxchd")
		intPaxInf = objRsTranSel("paxinf")
		intBagLivre = objRsTranSel("baglivre")
		intBagExcesso = objRsTranSel("bagexcesso")
		intCargaPaga = objRsTranSel("cargapaga")
		intCargaGratis = objRsTranSel("cargagratis")
		intPorao1 = objRsTranSel("porao1")
		intPorao2 = objRsTranSel("porao2")
		intPorao3 = objRsTranSel("porao3")
		intPorao4 = objRsTranSel("porao4")
		
		If intPorao1 = "" OR IsNull( intPorao1 ) Then intPorao1 = "0"
		If intPorao2 = "" OR IsNull( intPorao2 ) Then intPorao2 = "0"
		If intPorao3 = "" OR IsNull( intPorao3 ) Then intPorao3 = "0"
		If intPorao4 = "" OR IsNull( intPorao4 ) Then intPorao4 = "0"

		objRsTranSel.Close
		Set objRsTranSel = Nothing
	else
		ll_PaxAdt = "0"
		strNomeAeropDest = ""
		strCodIataDest = ""
		intNrVoo = "0"
		intPaxEconomica = "0"
		intPaxGratis = "0"
		intPaxChd = "0"
		intPaxInf = "0"
		intBagLivre = "0"
		intBagExcesso = "0"
		intCargaPaga = "0"
		intCargaGratis = "0"
		intPorao1 = "0"
		intPorao2 = "0"
		intPorao3 = "0"
		intPorao4 = "0"
	end if
	Response.Write("<form action='transitoaeroporto.asp' method='post' id='form1' name='form1' >" & vbCrLf)
	Response.Write("	<input type='hidden' name='hidSeqCombinada' id='hidSeqCombinada' value='" & intSeqCombinada & "' />" & vbCrLf)
	Response.Write("	<input type='hidden' name='hidSeqAeropDest' id='hidSeqAeropDest' value='" & intSeqAeropDest & "' />" & vbCrLf)
	Response.Write("	<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table1'>" & vbCrLf)
	Response.Write("		<tr>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
'	Response.write("intSeqAeropDest: " & intSeqAeropDest)
'	Response.Write("banco: " & objRsListaAerop("seqaeroporto"))
	Response.Write("			</td>" & vbCrLf)
	Response.Write("		</tr>" & vbCrLf)
	Response.Write("		<tr>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Aerop. Dest.:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	if ((intSeqAeropdest <> "") and (IsNumeric(intSeqAeropdest))) then
		Response.Write("				<select id='ddlAerop' name='ddlAerop' style='width: 60px' disabled>" & vbCrLf)
	else
		Response.Write("				<select id='ddlAerop' name='ddlAerop' style='width: 60px' tabindex='1'>" & vbCrLf)
	end if
	Response.Write("				<option value='-1'></option>" & vbCrLf)
								Do While (Not objRsListaAerop.EOF)
									if (CInt(intSeqAeropDest) = CInt(objRsListaAerop("seqaeroporto"))) then
										Response.Write("<option value=" & objRsListaAerop("seqaeroporto") & " selected>" & objRsListaAerop("codiata") & "</option>")
									else
										Response.Write("<option value=" & objRsListaAerop("seqaeroporto") & ">" & objRsListaAerop("codiata") & "</option>")
									end if
									objRsListaAerop.MoveNext
								Loop
								objRsListaAerop.Close
								Set objRsListaAerop = Nothing
	Response.Write("				</select>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Voo:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtNrVoo' value='" & intNrVoo & "'  style='input_rightText' size='4' maxlength='4' id='txtNrVoo' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='2' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("		</tr>" & vbCrLf)
	Response.Write("  </table>")
%>
			 </td>
		  </tr>
		  <tr>
			 <td>  
<% 	
	Response.Write("<table border='0' align='center'  class='corpo9' width='1'>" & vbCrLf)
	Response.Write(" <tr>")
	Response.Write("  <td valign='top'align='center' colspan='2' class='corpo9'>" & vbCrLf)
	Response.Write("   <fieldset style='width: 100%' align='center' >" & vbCrLf)
	Response.Write("	  <legend>Passageiros</legend>" & vbCrLf)	
	Response.Write("	  <table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)    
	Response.Write("		 <tr>" & vbCrLf)
	Response.Write("			  <td style='padding-left: 5px' nowrap width='1px' class='corpo9' align='right'>" & vbCrLf)
	Response.Write("			   	ADT:" & vbCrLf)
	Response.Write("			  </td>" & vbCrLf)
	Response.Write("			  <td style='padding-left: 4px' class='corpo9'>" & vbCrLf)
	Response.Write("				  <input type='text' name='txtPaxADT' value='" & ll_PaxAdt & "' size='4' maxlength='3' id='txtPaxADT' onChange='CalculaVolume()'  onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='3' />" & vbCrLf)
	Response.Write("			  </td>" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("				Chd:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtPaxCHD' value=" & intPaxChd & " size='4' maxlength='3' id='txtPaxCHD' onChange='CalculaVolume()' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='4' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("				Inf:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtPaxInf' value=" & intPaxInf & " size='4' maxlength='3' id='txtPaxInf' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='5' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("				Pago:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtPaxEconomica' value=" & intPaxEconomica & " size='4' maxlength='3' id='txtPaxEconomica' onKeyPress='return SoNumeros(window.event.keyCode, this);' disabled/>" & vbCrLf)
	Response.Write("				<input type='hidden' name='hdPaxEconomica' size='4' maxlength='3' id='hdPaxEconomica' tabindex='4' value=" & intPaxEconomica & " />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px' align='right'>" & vbCrLf)
	Response.Write("				PAD:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtPaxGratis' value='" & intPaxGratis & "' size='4' maxlength='3' id='txtPaxGratis' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='6' />" & vbCrLf)
	Response.Write("		 </tr>" & vbCrLf)
	Response.Write("		 <tr>")	
	Response.Write("		 	 <td colspan='2'></td>")
	Response.Write("		 </tr>" & vbCrLf)
	Response.Write("	  </table>") 		
	Response.Write(" <tr>")  
	Response.Write("  <td>")
	Response.Write("   <fieldset style='width: 49%' align='center' >")
	Response.Write("	  <legend>Bagagem</legend>")	
	Response.Write("	  <table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)
	Response.Write("		 <tr>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Livre:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtBagLivre' value='" & intBagLivre & "' size='4' maxlength='5' id='txtBagLivre' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='7' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Excesso:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtBagExcesso' value='" & intBagExcesso & "' size='4' maxlength='5' id='txtBagExcesso' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='8' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("      </tr>")
	Response.Write("		 <tr>")	
	Response.Write("		 	 <td colspan='2'></td>")
	Response.Write("		 </tr>" & vbCrLf)
	Response.Write("    </table>")  
	Response.Write("   </fieldset>")
	Response.Write("  </td>")
	Response.Write("  <td>")
	Response.Write("   <fieldset style='width: 49%' align='center' >")
	Response.Write("	  <legend>Carga</legend>")	
	Response.Write("	  <table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo9' ID='Table2'>" & vbCrLf)
	Response.Write("		 <tr>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Paga:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtCargaPaga' value='" & intCargaPaga & "' size='4' maxlength='6' id='txtCargaPaga' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='9' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 20px' align='right'>" & vbCrLf)
	Response.Write("				Gratis:" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td style='padding-left: 5px'>" & vbCrLf)
	Response.Write("				<input type='text' name='txtCargaGratis' value='" & intCargaGratis & "' size='4' maxlength='6' id='txtCargaGratis' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='10' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("			<td colspan='2'>" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("		 </tr>" & vbCrLf)
	Response.Write("		 <tr>")	
	Response.Write("		 	 <td colspan='2'></td>")
	Response.Write("		 </tr>" & vbCrLf)
	Response.Write("    </table>")
	Response.Write("   </fieldset>") 
	Response.Write("  </td>")
	Response.Write(" <tr>")
	Response.Write("</table>")      
	Response.Write("<table align='center' class='corpo9'>") 
	Response.Write("		 <tr>" & vbCrLf)
	Response.Write("			<input type='hidden' name='txtFlgPorao1' value='" & ls_flgporao1 & "' id='txtFlgPorao1'>" )
	If ls_flgporao1 = "S" Then
		Response.Write("		<td style='padding-left: 20px' align='right'>" & vbCrLf)
		Response.Write("			Porão 1:" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
		Response.Write("		<td style='padding-left: 5px'>" & vbCrLf)
		Response.Write("			<input type='text' name='txtPorao1' value='" & intPorao1 & "' size='4' maxlength='5' id='txtPorao1' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='11' />" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
	Else
		Response.Write("		<input type='hidden' name='txtPorao1' value='0' id='txtPorao1'/>" & vbCrLf)
	End if
	Response.Write("			<input type='hidden' name='txtFlgPorao2' value='" & ls_flgporao2 & "' id='txtFlgPorao2'>" )
	If ls_flgporao2 = "S" Then
		Response.Write("		<td style='padding-left: 20px' align='right'>" & vbCrLf)
		Response.Write("			Porão 2:" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
		Response.Write("		<td style='padding-left: 5px'>" & vbCrLf)
		Response.Write("			<input type='text' name='txtPorao2' value='" & intPorao2 & "' size='4' maxlength='5' id='txtPorao2' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='12' />" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
	Else
		Response.Write("		<input type='hidden' name='txtPorao2' value='0' id='txtPorao2'/>" & vbCrLf)
	End if
	Response.Write("			<input type='hidden' name='txtFlgPorao3' value='" & ls_flgporao3 & "' id='txtFlgPorao3'>" )
	If ls_flgporao3 = "S" Then
		Response.Write("		<td style='padding-left: 20px' align='right'>" & vbCrLf)
		Response.Write("			Porão 3:" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
		Response.Write("		<td style='padding-left: 5px'>" & vbCrLf)
		Response.Write("			<input type='text' name='txtPorao3' value='" & intPorao3 & "' size='4' maxlength='5' id='txtPorao3' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='13' />" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
	Else
		Response.Write("		<input type='hidden' name='txtPorao3' value='0' id='txtPorao3'/>" & vbCrLf)
	End if
	Response.Write("			<input type='hidden' name='txtFlgPorao4' value='" & ls_flgporao4 & "' id='txtFlgPorao4'>" )
	If ls_flgporao4 = "S" Then
		Response.Write("		<td style='padding-left: 20px' align='right'>" & vbCrLf)
		Response.Write("			Porão 4:" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
		Response.Write("		<td style='padding-left: 5px'>" & vbCrLf)
		Response.Write("			<input type='text' name='txtPorao4' value='" & intPorao4 & "' size='4' maxlength='5' id='txtPorao4' onKeyPress='return SoNumeros(window.event.keyCode, this);' tabindex='14' />" & vbCrLf)
		Response.Write("		</td>" & vbCrLf)
	Else
		Response.Write("		<input type='hidden' name='txtPorao4' value='0' id='txtPorao4'/>" & vbCrLf)
	End if
	Response.Write("    </tr>")
	Response.Write("</table>" & vbCrLf)

	Response.Write("	<table border='0' cellpadding='0' align='center' cellspacing='0' ID='Table3'>" & vbCrLf)
	Response.Write("		<tr style='padding-top: 20px;'>" & vbCrLf)
	Response.Write("			<td align='center' width='100%' colspan='6'>" & vbCrLf)
	Response.Write("				<input type='submit' value='Cancelar' name='btnCancelar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnCancelar' tabindex='20' />" & vbCrLf)
	Response.Write("				<input type='submit' value='Gravar' name='btnGravar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnGravar' tabindex='21' onclick='return VerificaCampos();'/>" & vbCrLf)
	Response.Write("				<input type='submit' value='Excluir' name='btnExcluir' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnExcluir' tabindex='22' />" & vbCrLf)
	Response.Write("				<input type='submit' value='Voltar' name='btnVoltar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnVoltar' tabindex='23' />" & vbCrLf)
	Response.Write("			</td>" & vbCrLf)
	Response.Write("		</tr>" & vbCrLf)
	Response.Write("	</table>" & vbCrLf)
	Response.Write("</form>" & vbCrLf)	
%>

		    </td>
        </tr> 
      </table> 
	</body>
</html>

<%
' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
