<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->
<!--#include file="auditoria.asp"-->

<%

Dim objConn
Dim strNomeAeroportoCombSel
Dim strCodIataCombSel
Dim strFlgPorao1CombSel
Dim strFlgPorao2CombSel
Dim strFlgPorao3CombSel
Dim strFlgPorao4CombSel
Dim txtPaxAdtLocal
Dim txtPaxChdLocal
Dim txtPaxInfLocal
Dim txtPaxPagoLocal
Dim txtPaxAdtCnxIn
Dim txtPaxChdCnxIn
Dim txtPaxInfCnxIn
Dim txtPaxPagoCnxIn
Dim txtPaxAdtTotal
Dim txtPaxChdTotal
Dim txtPaxInfTotal
Dim txtPaxPagoTotal
Dim txtBagLivreLocal
Dim txtBagExcessoLocal
Dim txtBagLivreCnxIn
Dim txtBagExcessoCnxIn
Dim txtBagLivreTotal
Dim txtBagExcessoTotal
Dim txtCargaPagaLocal
Dim txtCargaGratisLocal
Dim txtCargaPagaCnxIn
Dim txtCargaGratisCnxIn
Dim txtCargaPagaTotal
Dim txtCargaGratisTotal
Dim txtPaxPAD
Dim txtPaxDHC
Dim txtPaxCS
Dim txtPaxCSRes
Dim txtPorao1
Dim txtPorao2
Dim txtPorao3
Dim txtPorao4
Dim txtPaxAdtTran
Dim txtPaxChdTran
Dim txtPaxInfTran
Dim txtPaxEconomicaTran
Dim txtPaxGratisTran
Dim txtBagLivreTran
Dim txtBagExcessoTran
Dim txtCargaPagaTran
Dim txtCargaGratisTran
Dim txtPorao1Tran
Dim txtPorao2Tran
Dim txtPorao3Tran
Dim txtPorao4Tran



Dim IsPostBack
IsPostBack = (Request.ServerVariables("REQUEST_METHOD") = "POST")

Call Page_Load()

Function Page_Load()
	If (IsPostBack) Then
		If (Not IsVazio(ObterValorCampo("btnVoltar"))) Then
			Response.Redirect("entradadosaeroportodecolagem.asp")
		ElseIf (Not IsVazio(ObterValorCampo("btnCancelar"))) Then
			Response.Redirect("combinadaaeroporto.asp")
		ElseIf (Not IsVazio(ObterValorCampo("btnGravar"))) Then
			Call GravarEtapaCombinada()
		End If
	End If
End Function

Function ObterValorVariavelSessao(idVariavelSessao)
	ObterValorVariavelSessao = Session(idVariavelSessao)
End Function

Function ObterValorQueryString(idQueryString)
	ObterValorQueryString = Request.QueryString(idQueryString)
End Function

Function ObterValorCampo(idCampo)
	ObterValorCampo = Request.Form(idCampo)
End Function

Function CombinadaSelecionada()

	Dim intSeqCombinada
	intSeqCombinada = ObterValorQueryString("seqcombinada")

	If (Not IsVazio(intSeqCombinada) And IsNumeric(intSeqCombinada)) Then
		CombinadaSelecionada = True
	Else
		CombinadaSelecionada = False
	End If

End Function

Sub PreencherTitulo()

	Dim intSeqAeroporto
	intSeqAeroporto = ObterValorVariavelSessao("seqaeroporto")

	' **************************
	' *** DADOS DO AEROPORTO ***
	' **************************
	Dim strQueryAeroportoVoo
	strQueryAeroportoVoo =                        " SELECT codiata COD_IATA, "
	strQueryAeroportoVoo = strQueryAeroportoVoo & "        nomeaeroporto NOME_AEROPORTO "
	strQueryAeroportoVoo = strQueryAeroportoVoo & " FROM sig_aeroporto "
	strQueryAeroportoVoo = strQueryAeroportoVoo & " WHERE seqaeroporto = " & intSeqAeroporto

	Dim objConnAeroportoVoo
	Set objConnAeroportoVoo = CreateObject("ADODB.CONNECTION")
	objConnAeroportoVoo.Open (StringConexaoSqlServer)

	Dim objRsAeroportoVoo
	Set objRsAeroportoVoo = Server.CreateObject("ADODB.Recordset")
	objRsAeroportoVoo.Open strQueryAeroportoVoo, objConnAeroportoVoo

	Dim strNomeAeroporto, strCodAeroporto
	strNomeAeroporto = objRsAeroportoVoo("NOME_AEROPORTO")
	strCodAeroporto = objRsAeroportoVoo("COD_IATA")

	objRsAeroportoVoo.Close()



	Dim intSeqVooDia
	intSeqVooDia = ObterValorVariavelSessao("seqvoodia")
	' ********************
	' *** DADOS DO VOO ***
	' ********************
	strQueryAeroportoVoo =                        " SELECT SDV.nrvoo NUMERO_VOO "
	strQueryAeroportoVoo = strQueryAeroportoVoo & " FROM sig_diariovoo SDV "
	strQueryAeroportoVoo = strQueryAeroportoVoo & " WHERE SDV.seqvoodia = " & intSeqVooDia

	objRsAeroportoVoo.Open strQueryAeroportoVoo, objConnAeroportoVoo

	Dim strNrVoo
	strNrVoo = objRsAeroportoVoo("NUMERO_VOO")

	objRsAeroportoVoo.Close()
	Set objRsAeroportoVoo = Nothing

	objConnAeroportoVoo.Close()
	Set objConnAeroportoVoo = Nothing


	'**************
	'*** TÍTULO ***
	'**************
	Response.Write("<font size='3'><b>" & vbCrLf)
	Response.Write("Etapas Combinadas do Voo " & strNrVoo & vbCrLf)
	Response.Write("</b></font>" & vbCrLf)
	Response.Write("<br /><br />" & vbCrLf)
	Response.Write("<font size='2'><b>" & vbCrLf)
	Response.Write(strNomeAeroporto & " (" & strCodAeroporto & ")" & vbCrLf)
	Response.Write("</b></font>" & vbCrLf)

End Sub

Sub PreencherTabelaEtapasCombinadas()

	Dim intSeqVooDia, intSeqTrecho
	intSeqVooDia = ObterValorVariavelSessao("seqvoodia")
	intSeqTrecho = ObterValorVariavelSessao("seqtrecho")

	' *****************
	' *** COMBINADA ***
	' *****************
	Dim strQueryCombinada
	strQueryCombinada =                     " SELECT SDV.nrvoo NUMERO_VOO, " 'numeric(4,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDV.dtoper DATA_OPERACAO, " 'datetime Not Null
	strQueryCombinada = strQueryCombinada & "        AERDEST.codiata COD_IATA, " 'char(3) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.seqcombinada SEQ_COMBINADA, " 'numeric(2,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.seqaeropdest SEQ_AEROP_DESTINO, " 'numeric(4,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxeconomica PAX_ECONOMICA, " 'numeric(3,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxpad PAX_PAD, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxdhc PAX_DHC, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxtrc PAX_TRC, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.baglivre BAG_LIVRE, " 'numeric(5,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.bagexcesso BAG_EXCESSO, " 'numeric(5,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.cargapaga CARGA_PAGA, " 'numeric(6,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.cargagratis CARGA_GRATIS, " 'numeric(6,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxchd PAX_CHD, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxinf PAX_INF, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxeconomicatran PAX_ECONOMICA_TRAN, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxgratistran PAX_GRATIS_TRAN, " 'numeric(3,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.baglivretran BAG_LIVRE_TRAN, " 'numeric(5,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.bagexcessotran BAG_EXCESSO_TRAN, " 'numeric(5,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.cargapagatran CARGA_PAGA_TRAN, " 'numeric(6,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.cargagratistran CARGA_GRATIS_TRAN, " 'numeric(6,0) Not Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxchdtran PAX_CHD_TRAN, " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & "        SDTC.paxinftran PAX_INF_TRAN " 'numeric(3,0) Null
	strQueryCombinada = strQueryCombinada & " FROM sig_diariotrechocomb SDTC "
	strQueryCombinada = strQueryCombinada & "      INNER JOIN sig_diariovoo SDV ON SDV.seqvoodia = SDTC.seqvoodia "
	strQueryCombinada = strQueryCombinada & "      INNER JOIN sig_aeroporto AERDEST ON AERDEST.seqaeroporto = SDTC.seqaeropdest "
	strQueryCombinada = strQueryCombinada & " WHERE SDTC.seqvoodia = " & ObterValorVariavelSessao("seqvoodia") & " "
	strQueryCombinada = strQueryCombinada & "   AND SDTC.seqtrecho = " & ObterValorVariavelSessao("seqtrecho") & " "

	Dim objConnCombinada
	Set objConnCombinada = CreateObject("ADODB.CONNECTION")
	objConnCombinada.Open(StringConexaoSqlServer)
	objConnCombinada.Execute("SET DATEFORMAT ymd")

	Dim objRsCombinada
	Set objRsCombinada = Server.CreateObject("ADODB.Recordset")
	objRsCombinada.Open strQueryCombinada, objConnCombinada

	Dim intContCor
	intContCor = CInt(0)

	Do While Not objRsCombinada.Eof

		Dim intNumeroVoo
		intNumeroVoo = objRsCombinada("NUMERO_VOO")
		intNumeroVoo = CInt(intNumeroVoo)

		Dim dtDataOperacao
		dtDataOperacao = objRsCombinada("DATA_OPERACAO")
		dtDataOperacao = CDate(dtDataOperacao)

		Dim strCodIata
		strCodIata = objRsCombinada("COD_IATA")
		If (IsVazio(strCodIata)) Then strCodIata = "&nbsp;"

		Dim intSeqCombinada
		intSeqCombinada = objRsCombinada("SEQ_COMBINADA")
		intSeqCombinada = CInt(intSeqCombinada)

		Dim intSeqAeropDestino
		intSeqAeropDestino = objRsCombinada("SEQ_AEROP_DESTINO")
		intSeqAeropDestino = CInt(intSeqAeropDestino)

		Dim intPaxEconomica
		intPaxEconomica = objRsCombinada("PAX_ECONOMICA")
		intPaxEconomica = CInt(intPaxEconomica)

		Dim intPaxPad
		intPaxPad = objRsCombinada("PAX_PAD")
		If (IsVazio(intPaxPad)) Then
			intPaxPad = CInt(0)
		Else
			intPaxPad = CInt(intPaxPad)
		End If

		Dim intPaxDhc
		intPaxDhc = objRsCombinada("PAX_DHC")
		If (IsVazio(intPaxDhc)) Then
			intPaxDhc = CInt(0)
		Else
			intPaxDhc = CInt(intPaxDhc)
		End If

		Dim intPaxTrc
		intPaxTrc = objRsCombinada("PAX_TRC")
		If (IsVazio(intPaxTrc)) Then
			intPaxTrc = CInt(0)
		Else
			intPaxTrc = CInt(intPaxTrc)
		End If
		If (intPaxTrc = 0) Then intPaxTrc = "--*--"

		Dim lngBagLivre
		lngBagLivre = objRsCombinada("BAG_LIVRE")
		lngBagLivre = CLng(lngBagLivre)

		Dim lngBagExcesso
		lngBagExcesso = objRsCombinada("BAG_EXCESSO")
		lngBagExcesso = CLng(lngBagExcesso)

		Dim lngCargaPaga
		lngCargaPaga = objRsCombinada("CARGA_PAGA")
		lngCargaPaga = CLng(lngCargaPaga)

		Dim lngCargaGratis
		lngCargaGratis = objRsCombinada("CARGA_GRATIS")
		lngCargaGratis = CLng(lngCargaGratis)

		Dim intPaxChd
		intPaxChd = objRsCombinada("PAX_CHD")
		If (IsVazio(intPaxChd)) Then
			intPaxChd = CInt(0)
		Else
			intPaxChd = CInt(intPaxChd)
		End If

		Dim intPaxInf
		intPaxInf = objRsCombinada("PAX_INF")
		If (IsVazio(intPaxInf)) Then
			intPaxInf = CInt(0)
		Else
			intPaxInf = CInt(intPaxInf)
		End If

		Dim intPaxEconomicaTran
		intPaxEconomicaTran = objRsCombinada("PAX_ECONOMICA_TRAN")
		If (IsVazio(intPaxEconomicaTran)) Then
			intPaxEconomicaTran = CInt(0)
		Else
			intPaxEconomicaTran = CInt(intPaxEconomicaTran)
		End If

		Dim intPaxGratisTran
		intPaxGratisTran = objRsCombinada("PAX_GRATIS_TRAN")
		intPaxGratisTran = CInt(intPaxGratisTran)

		Dim lngBagLivreTran
		lngBagLivreTran = objRsCombinada("BAG_LIVRE_TRAN")
		lngBagLivreTran = CLng(lngBagLivreTran)

		Dim lngBagExcessoTran
		lngBagExcessoTran = objRsCombinada("BAG_EXCESSO_TRAN")
		lngBagExcessoTran = CLng(lngBagExcessoTran)

		Dim lngCargaPagaTran
		lngCargaPagaTran = objRsCombinada("CARGA_PAGA_TRAN")
		lngCargaPagaTran = CLng(lngCargaPagaTran)

		Dim lngCargaGratisTran
		lngCargaGratisTran = objRsCombinada("CARGA_GRATIS_TRAN")
		lngCargaGratisTran = CLng(lngCargaGratisTran)

		Dim intPaxChdTran
		intPaxChdTran = objRsCombinada("PAX_CHD_TRAN")
		If (IsVazio(intPaxChdTran)) Then
			intPaxChdTran = CInt(0)
		Else
			intPaxChdTran = CInt(intPaxChdTran)
		End If

		Dim intPaxInfTran
		intPaxInfTran = objRsCombinada("PAX_INF_TRAN")
		If (IsVazio(intPaxInfTran)) Then
			intPaxInfTran = CInt(0)
		Else
			intPaxInfTran = CInt(intPaxInfTran)
		End If

		Dim intPaxAdt, intPaxChdSoma, intPaxInfSoma, intPaxPadSoma, intPaxEconomicaSoma
		Dim lngBagLivreSoma, lngBagExcessoSoma, lngCargaPagaSoma, lngCargaGratisSoma

		intPaxAdt  = (CInt(intPaxEconomicaTran) - CInt(intPaxChdTran)) + (CInt(intPaxEconomica) - CInt(intPaxChd))		
		intPaxChdSoma  = CInt(intPaxChd) + CInt(intPaxChdTran)
		intPaxInfSoma  = CInt(intPaxInf) + CInt(intPaxInfTran)
		intPaxPadSoma  = CInt(intPaxPad) + CInt(intPaxGratisTran)
		intPaxEconomicaSoma = CInt(intPaxEconomica) + CInt(intPaxEconomicaTran)
		lngBagLivreSoma = CLng(lngBagLivre) + CLng(lngBagLivreTran)
		lngBagExcessoSoma = CLng(lngBagExcesso) + CLng(lngBagExcessoTran)
		lngCargaPagaSoma = CLng(lngCargaPaga) + CLng(lngCargaPagaTran)
		lngCargaGratisSoma = CLng(lngCargaGratis) + CLng(lngCargaGratisTran)

		Response.Write("<tr bgcolor='" & ObterCorFundoLinha(intContCor) & "'>" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='combinadaaeroporto.asp?seqcombinada=" & intSeqCombinada & "'>" & vbCrLf)
		Response.Write("		" & strCodIata & "</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & intPaxAdt & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & intPaxChdSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & intPaxInfSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' >" & vbCrLf)
		Response.Write("		" & intPaxEconomicaSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & intPaxPadSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & intPaxDhc & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='conexoesinbound.asp?nrvoo=" & intNumeroVoo & "&dtoper=" & Year(dtDataOperacao) & "+" & Month(dtDataOperacao) & "+" & Day(dtDataOperacao) & "&seqaeropdest=" & intSeqAeropDestino & "'>" & vbCrLf)
		Response.Write("		" & intPaxTrc & "&nbsp;</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & lngBagLivreSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & lngBagExcessoSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & lngCargaPagaSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & lngCargaGratisSoma & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='transitoaeroporto.asp?seqcombinada=" & intSeqCombinada & "&seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'>" & vbCrLf)
		Response.Write("		" & strCodIata & "</a></td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		intContCor = intContCor + 1
		objRsCombinada.MoveNext()
	Loop

	objRsCombinada.Close()
	Set objRsCombinada = Nothing

	objConnCombinada.Close()
	Set objConnCombinada = Nothing

	Response.Write("<tr>" & vbCrLf)
	Response.Write("	<th colspan='13'></th>" & vbCrLf)
	Response.Write("</tr>" & vbCrLf)

End Sub

Sub PreencherDadosCombinadaSelecionada()

	Dim intSeqVooDia, intSeqTrecho
	intSeqVooDia = ObterValorVariavelSessao("seqvoodia")
	intSeqTrecho = ObterValorVariavelSessao("seqtrecho")

	Dim intSeqCombinada
	intSeqCombinada = ObterValorQueryString("seqcombinada")

	' *****************************
	' *** COMBINADA SELECIONADA ***
	' *****************************
	Dim strQueryCombSel
	strQueryCombSel =                   " SELECT AERDEST.nomeaeroporto NOME_AEROPORTO, " 'varchar(40) Not Null
	strQueryCombSel = strQueryCombSel & "        AERDEST.codiata COD_IATA, " 'char(3) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxeconomica PAX_ECONOMICA, " 'numeric(3,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxpad PAX_PAD, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxdhc PAX_DHC, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxtrc PAX_TRC, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxcs PAX_CS, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxcsres PAX_CS_RES, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.baglivre BAG_LIVRE, " 'numeric(5,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.bagtrc BAG_TRC, " 'numeric(5,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.bagexcesso BAG_EXCESSO, " 'numeric(5,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.bagexcessotrc BAG_EXCESSO_TRC, " 'numeric(5,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargapaga CARGA_PAGA, " 'numeric(6,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargatrc CARGA_TRC, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargagratis CARGA_GRATIS, " 'numeric(6,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargagratistrc CARGA_GRATIS_TRC, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxchd PAX_CHD, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxchdtrc PAX_CHD_TRC, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxinf PAX_INF, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxinftrc PAX_INF_TRC, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxeconomicatran PAX_ECONOMICA_TRAN, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxgratistran PAX_GRATIS_TRAN, " 'numeric(3,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.baglivretran BAG_LIVRE_TRAN, " 'numeric(5,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.bagexcessotran BAG_EXCESSO_TRAN, " 'numeric(5,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargapagatran CARGA_PAGA_TRAN, " 'numeric(6,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.cargagratistran CARGA_GRATIS_TRAN, " 'numeric(6,0) Not Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxchdtran PAX_CHD_TRAN, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.paxinftran PAX_INF_TRAN, " 'numeric(3,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao1 PORAO1, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao2 PORAO2, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao3 PORAO3, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao4 PORAO4, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao1tran PORAO1_TRAN, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao2tran PORAO2_TRAN, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao3tran PORAO3_TRAN, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SDTC.porao4tran PORAO4_TRAN, " 'numeric(6,0) Null
	strQueryCombSel = strQueryCombSel & "        SA.flgporao1 FLG_PORAO1, " 'char(1) Null
	strQueryCombSel = strQueryCombSel & "        SA.flgporao2 FLG_PORAO2, " 'char(1) Null
	strQueryCombSel = strQueryCombSel & "        SA.flgporao3 FLG_PORAO3, " 'char(1) Null
	strQueryCombSel = strQueryCombSel & "        SA.flgporao4 FLG_PORAO4 " 'char(1) Null
	strQueryCombSel = strQueryCombSel & " FROM sig_diariotrechocomb SDTC "
	strQueryCombSel = strQueryCombSel & "      INNER JOIN sig_aeroporto AERDEST ON AERDEST.seqaeroporto = SDTC.seqaeropdest "
	strQueryCombSel = strQueryCombSel & "      INNER JOIN sig_diariotrecho SDT ON SDT.seqvoodia = SDTC.seqvoodia "
	strQueryCombSel = strQueryCombSel & "                                     AND SDT.seqtrecho = SDTC.seqtrecho "
	strQueryCombSel = strQueryCombSel & "      INNER JOIN sig_aeronave SA ON SA.prefixored = SDT.prefixoaeronave "
	strQueryCombSel = strQueryCombSel & " WHERE SDTC.seqvoodia = " & intSeqVooDia & " "
	strQueryCombSel = strQueryCombSel & "   AND SDTC.seqtrecho = " & intSeqTrecho & " "
	strQueryCombSel = strQueryCombSel & "   AND SDTC.seqcombinada = " & intSeqCombinada & " "

	Dim objConnCombSel
	Set objConnCombSel = CreateObject("ADODB.CONNECTION")
	objConnCombSel.Open(StringConexaoSqlServer)
	objConnCombSel.Execute("SET DATEFORMAT ymd")

	Dim objRsCombSel
	Set objRsCombSel = Server.CreateObject("ADODB.Recordset")
	objRsCombSel.Open strQueryCombSel, objConnCombSel

	strNomeAeroportoCombSel = objRsCombSel("NOME_AEROPORTO")

	strCodIataCombSel = objRsCombSel("COD_IATA")
	If (IsVazio(strCodIataCombSel)) Then strCodIataCombSel = "&nbsp;"

	Dim intPaxEconomicaCombSel
	intPaxEconomicaCombSel = objRsCombSel("PAX_ECONOMICA")
	intPaxEconomicaCombSel = CInt(intPaxEconomicaCombSel)

	Dim intPaxPadCombSel
	intPaxPadCombSel = objRsCombSel("PAX_PAD")
	If (IsVazio(intPaxPadCombSel)) Then
		intPaxPadCombSel = CInt(0)
	Else
		intPaxPadCombSel = CInt(intPaxPadCombSel)
	End If

	Dim intPaxDhcCombSel
	intPaxDhcCombSel = objRsCombSel("PAX_DHC")
	If (IsVazio(intPaxDhcCombSel)) Then
		intPaxDhcCombSel = CInt(0)
	Else
		intPaxDhcCombSel = CInt(intPaxDhcCombSel)
	End If

	Dim intPaxTrcCombSel
	intPaxTrcCombSel = objRsCombSel("PAX_TRC")
	If (IsVazio(intPaxTrcCombSel)) Then
		intPaxTrcCombSel = CInt(0)
	Else
		intPaxTrcCombSel = CInt(intPaxTrcCombSel)
	End If

	Dim intPaxCSCombSel
	intPaxCSCombSel = objRsCombSel("PAX_CS")
	If (IsVazio(intPaxCSCombSel)) Then
		intPaxCSCombSel = CInt(0)
	Else
		intPaxCSCombSel = CInt(intPaxCSCombSel)
	End If

	Dim intPaxCSResCombSel
	intPaxCSResCombSel = objRsCombSel("PAX_CS_RES")
	If (IsVazio(intPaxCSResCombSel)) Then
		intPaxCSResCombSel = CInt(0)
	Else
		intPaxCSResCombSel = CInt(intPaxCSResCombSel)
	End If

	Dim lngBagLivreCombSel
	lngBagLivreCombSel = objRsCombSel("BAG_LIVRE")
	lngBagLivreCombSel = CLng(lngBagLivreCombSel)

	Dim lngBagTrcCombSel
	lngBagTrcCombSel = objRsCombSel("BAG_TRC")
	If (IsVazio(lngBagTrcCombSel)) Then
		lngBagTrcCombSel = CLng(0)
	Else
		lngBagTrcCombSel = CLng(lngBagTrcCombSel)
	End If

	Dim lngBagExcessoCombSel
	lngBagExcessoCombSel = objRsCombSel("BAG_EXCESSO")
	lngBagExcessoCombSel = CLng(lngBagExcessoCombSel)

	Dim lngBagExcessoTrcCombSel
	lngBagExcessoTrcCombSel = objRsCombSel("BAG_EXCESSO_TRC")
	If (IsVazio(lngBagExcessoTrcCombSel)) Then
		lngBagExcessoTrcCombSel = CLng(0)
	Else
		lngBagExcessoTrcCombSel = CLng(lngBagExcessoTrcCombSel)
	End If

	Dim lngCargaPagaCombSel
	lngCargaPagaCombSel = objRsCombSel("CARGA_PAGA")
	lngCargaPagaCombSel = CLng(lngCargaPagaCombSel)

	Dim lngCargaTrcCombSel
	lngCargaTrcCombSel = objRsCombSel("CARGA_TRC")
	If (IsVazio(lngCargaTrcCombSel)) Then
		lngCargaTrcCombSel = CLng(0)
	Else
		lngCargaTrcCombSel = CLng(lngCargaTrcCombSel)
	End If

	Dim lngCargaGratisCombSel
	lngCargaGratisCombSel = objRsCombSel("CARGA_GRATIS")
	lngCargaGratisCombSel = CLng(lngCargaGratisCombSel)

	Dim lngCargaGratisTrcCombSel
	lngCargaGratisTrcCombSel = objRsCombSel("CARGA_GRATIS_TRC")
	If (IsVazio(lngCargaGratisTrcCombSel)) Then
		lngCargaGratisTrcCombSel = CLng(0)
	Else
		lngCargaGratisTrcCombSel = CLng(lngCargaGratisTrcCombSel)
	End If

	Dim intPaxChdCombSel
	intPaxChdCombSel = objRsCombSel("PAX_CHD")
	If (IsVazio(intPaxChdCombSel)) Then
		intPaxChdCombSel = CInt(0)
	Else
		intPaxChdCombSel = CInt(intPaxChdCombSel)
	End If

	Dim intPaxChdTrcCombSel
	intPaxChdTrcCombSel = objRsCombSel("PAX_CHD_TRC")
	If (IsVazio(intPaxChdTrcCombSel)) Then
		intPaxChdTrcCombSel = CInt(0)
	Else
		intPaxChdTrcCombSel = CInt(intPaxChdTrcCombSel)
	End If

	Dim intPaxInfCombSel
	intPaxInfCombSel = objRsCombSel("PAX_INF")
	If (IsVazio(intPaxInfCombSel)) Then
		intPaxInfCombSel = CInt(0)
	Else
		intPaxInfCombSel = CInt(intPaxInfCombSel)
	End If

	Dim intPaxInfTrcCombSel
	intPaxInfTrcCombSel = objRsCombSel("PAX_INF_TRC")
	If (IsVazio(intPaxInfTrcCombSel)) Then
		intPaxInfTrcCombSel = CInt(0)
	Else
		intPaxInfTrcCombSel = CInt(intPaxInfTrcCombSel)
	End If

	Dim intPaxEconomicaTranCombSel
	intPaxEconomicaTranCombSel = objRsCombSel("PAX_ECONOMICA_TRAN")
	If (IsVazio(intPaxEconomicaTranCombSel)) Then
		intPaxEconomicaTranCombSel = CInt(0)
	Else
		intPaxEconomicaTranCombSel = CInt(intPaxEconomicaTranCombSel)
	End If

	Dim intPaxGratisTranCombSel
	intPaxGratisTranCombSel = objRsCombSel("PAX_GRATIS_TRAN")
	intPaxGratisTranCombSel = CInt(intPaxGratisTranCombSel)

	Dim lngBagLivreTranCombSel
	lngBagLivreTranCombSel = objRsCombSel("BAG_LIVRE_TRAN")
	lngBagLivreTranCombSel = CLng(lngBagLivreTranCombSel)

	Dim lngBagExcessoTranCombSel
	lngBagExcessoTranCombSel = objRsCombSel("BAG_EXCESSO_TRAN")
	lngBagExcessoTranCombSel = CLng(lngBagExcessoTranCombSel)

	Dim lngCargaPagaTranCombSel
	lngCargaPagaTranCombSel = objRsCombSel("CARGA_PAGA_TRAN")
	lngCargaPagaTranCombSel = CLng(lngCargaPagaTranCombSel)

	Dim lngCargaGratisTranCombSel
	lngCargaGratisTranCombSel = objRsCombSel("CARGA_GRATIS_TRAN")
	lngCargaGratisTranCombSel = CLng(lngCargaGratisTranCombSel)

	Dim intPaxChdTranCombSel
	intPaxChdTranCombSel = objRsCombSel("PAX_CHD_TRAN")
	If (IsVazio(intPaxChdTranCombSel)) Then
		intPaxChdTranCombSel = CInt(0)
	Else
		intPaxChdTranCombSel = CInt(intPaxChdTranCombSel)
	End If

	Dim intPaxInfTranCombSel
	intPaxInfTranCombSel = objRsCombSel("PAX_INF_TRAN")
	If (IsVazio(intPaxInfTranCombSel)) Then
		intPaxInfTranCombSel = CInt(0)
	Else
		intPaxInfTranCombSel = CInt(intPaxInfTranCombSel)
	End If

	Dim lngPorao1CombSel
	lngPorao1CombSel = objRsCombSel("PORAO1")
	If (IsVazio(lngPorao1CombSel)) Then
		lngPorao1CombSel = CLng(0)
	Else
		lngPorao1CombSel = CLng(lngPorao1CombSel)
	End If

	Dim lngPorao2CombSel
	lngPorao2CombSel = objRsCombSel("PORAO2")
	If (IsVazio(lngPorao2CombSel)) Then
		lngPorao2CombSel = CLng(0)
	Else
		lngPorao2CombSel = CLng(lngPorao2CombSel)
	End If

	Dim lngPorao3CombSel
	lngPorao3CombSel = objRsCombSel("PORAO3")
	If (IsVazio(lngPorao3CombSel)) Then
		lngPorao3CombSel = CLng(0)
	Else
		lngPorao3CombSel = CLng(lngPorao3CombSel)
	End If

	Dim lngPorao4CombSel
	lngPorao4CombSel = objRsCombSel("PORAO4")
	If (IsVazio(lngPorao4CombSel)) Then
		lngPorao4CombSel = CLng(0)
	Else
		lngPorao4CombSel = CLng(lngPorao4CombSel)
	End If

	Dim lngPorao1TranCombSel
	lngPorao1TranCombSel = objRsCombSel("PORAO1_TRAN")
	If (IsVazio(lngPorao1TranCombSel)) Then
		lngPorao1TranCombSel = CLng(0)
	Else
		lngPorao1TranCombSel = CLng(lngPorao1TranCombSel)
	End If

	Dim lngPorao2TranCombSel
	lngPorao2TranCombSel = objRsCombSel("PORAO2_TRAN")
	If (IsVazio(lngPorao2TranCombSel)) Then
		lngPorao2TranCombSel = CLng(0)
	Else
		lngPorao2TranCombSel = CLng(lngPorao2TranCombSel)
	End If

	Dim lngPorao3TranCombSel
	lngPorao3TranCombSel = objRsCombSel("PORAO3_TRAN")
	If (IsVazio(lngPorao3TranCombSel)) Then
		lngPorao3TranCombSel = CLng(0)
	Else
		lngPorao3TranCombSel = CLng(lngPorao3TranCombSel)
	End If

	Dim lngPorao4TranCombSel
	lngPorao4TranCombSel = objRsCombSel("PORAO4_TRAN")
	If (IsVazio(lngPorao4TranCombSel)) Then
		lngPorao4TranCombSel = CLng(0)
	Else
		lngPorao4TranCombSel = CLng(lngPorao4TranCombSel)
	End If

	strFlgPorao1CombSel = objRsCombSel("FLG_PORAO1")
	If (IsVazio(strFlgPorao1CombSel)) Then strFlgPorao1CombSel = "N"

	strFlgPorao2CombSel = objRsCombSel("FLG_PORAO2")
	If (IsVazio(strFlgPorao2CombSel)) Then strFlgPorao2CombSel = "N"

	strFlgPorao3CombSel = objRsCombSel("FLG_PORAO3")
	If (IsVazio(strFlgPorao3CombSel)) Then strFlgPorao3CombSel = "N"

	strFlgPorao4CombSel = objRsCombSel("FLG_PORAO4")
	If (IsVazio(strFlgPorao4CombSel)) Then strFlgPorao4CombSel = "N"


	objRsCombSel.Close()
	Set objRsCombSel = Nothing

	objConnCombSel.Close()
	Set objConnCombSel = Nothing



	txtPaxAdtLocal = (CInt(intPaxEconomicaCombSel) - CInt(intPaxTrcCombSel)) - (CInt(intPaxChdCombSel) - CInt(intPaxChdTrcCombSel))
	txtPaxChdLocal = CInt(intPaxChdCombSel) - CInt(intPaxChdTrcCombSel)
	txtPaxInfLocal = CInt(intPaxInfCombSel) - CInt(intPaxInfTrcCombSel)
	txtPaxPagoLocal = CInt(intPaxEconomicaCombSel) - CInt(intPaxTrcCombSel)
	txtPaxAdtCnxIn = CInt(intPaxTrcCombSel) - CInt(intPaxChdTrcCombSel)
	txtPaxChdCnxIn = CInt(intPaxChdTrcCombSel)
	txtPaxInfCnxIn = CInt(intPaxInfTrcCombSel)
	txtPaxPagoCnxIn = CInt(intPaxTrcCombSel)
	txtPaxAdtTotal = CInt(intPaxEconomicaCombSel) - CInt(intPaxChdCombSel)
	txtPaxChdTotal = CInt(intPaxChdCombSel)
	txtPaxInfTotal = CInt(intPaxInfCombSel)
	txtPaxPagoTotal = CInt(intPaxEconomicaCombSel)
	txtBagLivreLocal = CLng(lngBagLivreCombSel) - CLng(lngBagTrcCombSel)
	txtBagExcessoLocal = CLng(lngBagExcessoCombSel) - CLng(lngBagExcessoTrcCombSel)
	txtBagLivreCnxIn = CLng(lngBagTrcCombSel)
	txtBagExcessoCnxIn = CLng(lngBagExcessoTrcCombSel)
	txtBagLivreTotal = CLng(lngBagLivreCombSel)
	txtBagExcessoTotal = CLng(lngBagExcessoCombSel)
	txtCargaPagaLocal = CLng(lngCargaPagaCombSel) - CLng(lngCargaTrcCombSel)
	txtCargaGratisLocal = CLng(lngCargaGratisCombSel) - CLng(lngCargaGratisTrcCombSel)
	txtCargaPagaCnxIn = CLng(lngCargaTrcCombSel)
	txtCargaGratisCnxIn = CLng(lngCargaGratisTrcCombSel)
	txtCargaPagaTotal = CLng(lngCargaPagaCombSel)
	txtCargaGratisTotal = CLng(lngCargaGratisCombSel)
	txtPaxPAD = CInt(intPaxPadCombSel)
	txtPaxDHC = CInt(intPaxDhcCombSel)
	txtPaxCS = CInt(intPaxCSCombSel)
	txtPaxCSRes = CInt(intPaxCSResCombSel)
	txtPorao1 = CLng(lngPorao1CombSel)
	txtPorao2 = CLng(lngPorao2CombSel)
	txtPorao3 = CLng(lngPorao3CombSel)
	txtPorao4 = CLng(lngPorao4CombSel)
	txtPaxAdtTran = CInt(intPaxEconomicaTranCombSel) - CInt(intPaxChdTranCombSel)
	txtPaxChdTran = CInt(intPaxChdTranCombSel)
	txtPaxInfTran = CInt(intPaxInfTranCombSel)
	txtPaxEconomicaTran = CInt(intPaxEconomicaTranCombSel)
	txtPaxGratisTran = CInt(intPaxGratisTranCombSel)
	txtBagLivreTran = CLng(lngBagLivreTranCombSel)
	txtBagExcessoTran = CLng(lngBagExcessoTranCombSel)
	txtCargaPagaTran = CLng(lngCargaPagaTranCombSel)
	txtCargaGratisTran = CLng(lngCargaGratisTranCombSel)
	txtPorao1Tran = CLng(lngPorao1TranCombSel)
	txtPorao2Tran = CLng(lngPorao2TranCombSel)
	txtPorao3Tran = CLng(lngPorao3TranCombSel)
	txtPorao4Tran = CLng(lngPorao4TranCombSel)

End Sub

Sub GravarEtapaCombinada()

	Dim strTxtPaxAdtLocal, strTxtPaxChdLocal, strTxtPaxInfLocal
	Dim strTxtPaxAdtCnxIn, strTxtPaxChdCnxIn, strTxtPaxInfCnxIn
	Dim strTxtBagLivreLocal, strTxtBagExcessoLocal, strTxtBagLivreCnxIn, strTxtBagExcessoCnxIn
	Dim strTxtCargaPagaLocal, strTxtCargaGratisLocal, strTxtCargaPagaCnxIn, strTxtCargaGratisCnxIn
	Dim strTxtPaxPAD, strTxtPaxDHC
	Dim strTxtPaxCS, strTxtPaxCSRes
	Dim strTxtPorao1, strTxtPorao2, strTxtPorao3, strTxtPorao4
	strTxtPaxAdtLocal = Trim(ObterValorCampo("txtPaxAdtLocal"))
	strTxtPaxChdLocal = Trim(ObterValorCampo("txtPaxChdLocal"))
	strTxtPaxInfLocal = Trim(ObterValorCampo("txtPaxInfLocal"))
	strTxtPaxAdtCnxIn = Trim(ObterValorCampo("txtPaxAdtCnxIn"))
	strTxtPaxChdCnxIn = Trim(ObterValorCampo("txtPaxChdCnxIn"))
	strTxtPaxInfCnxIn = Trim(ObterValorCampo("txtPaxInfCnxIn"))
	strTxtBagLivreLocal = Trim(ObterValorCampo("txtBagLivreLocal"))
	strTxtBagExcessoLocal = Trim(ObterValorCampo("txtBagExcessoLocal"))
	strTxtBagLivreCnxIn = Trim(ObterValorCampo("txtBagLivreCnxIn"))
	strTxtBagExcessoCnxIn = Trim(ObterValorCampo("txtBagExcessoCnxIn"))
	strTxtCargaPagaLocal = Trim(ObterValorCampo("txtCargaPagaLocal"))
	strTxtCargaGratisLocal = Trim(ObterValorCampo("txtCargaGratisLocal"))
	strTxtCargaPagaCnxIn = Trim(ObterValorCampo("txtCargaPagaCnxIn"))
	strTxtCargaGratisCnxIn = Trim(ObterValorCampo("txtCargaGratisCnxIn"))
	strTxtPaxPAD = Trim(ObterValorCampo("txtPaxPAD"))
	strTxtPaxDHC = Trim(ObterValorCampo("txtPaxDHC"))
	strTxtPaxCS = Trim(ObterValorCampo("txtPaxCS"))
	strTxtPaxCSRes = Trim(ObterValorCampo("txtPaxCSRes"))
	strTxtPorao1 = Trim(ObterValorCampo("txtPorao1"))
	strTxtPorao2 = Trim(ObterValorCampo("txtPorao2"))
	strTxtPorao3 = Trim(ObterValorCampo("txtPorao3"))
	strTxtPorao4 = Trim(ObterValorCampo("txtPorao4"))

	Dim intTxtPaxAdtLocal, intTxtPaxChdLocal, intTxtPaxInfLocal
	Dim intTxtPaxAdtCnxIn, intTxtPaxChdCnxIn, intTxtPaxInfCnxIn
	Dim lngTxtBagLivreLocal, lngTxtBagExcessoLocal, lngTxtBagLivreCnxIn, lngTxtBagExcessoCnxIn
	Dim lngTxtCargaPagaLocal, lngTxtCargaGratisLocal, lngTxtCargaPagaCnxIn, lngTxtCargaGratisCnxIn
	Dim intTxtPaxPAD, intTxtPaxDHC
	Dim intTxtPaxCS, intTxtPaxCSRes
	Dim lngTxtPorao1, lngTxtPorao2, lngTxtPorao3, lngTxtPorao4

	If (IsVazio(strTxtPaxAdtLocal) Or Not IsNumeric(strTxtPaxAdtLocal)) Then
		intTxtPaxAdtLocal = CInt(0)
	Else
		intTxtPaxAdtLocal = CInt(strTxtPaxAdtLocal)
	End If

	If (IsVazio(strTxtPaxChdLocal) Or Not IsNumeric(strTxtPaxChdLocal)) Then
		intTxtPaxChdLocal = CInt(0)
	Else
		intTxtPaxChdLocal = CInt(strTxtPaxChdLocal)
	End If

	If (IsVazio(strTxtPaxInfLocal) Or Not IsNumeric(strTxtPaxInfLocal)) Then
		intTxtPaxInfLocal = CInt(0)
	Else
		intTxtPaxInfLocal = CInt(strTxtPaxInfLocal)
	End If

	If (IsVazio(strTxtPaxAdtCnxIn) Or Not IsNumeric(strTxtPaxAdtCnxIn)) Then
		intTxtPaxAdtCnxIn = CInt(0)
	Else
		intTxtPaxAdtCnxIn = CInt(strTxtPaxAdtCnxIn)
	End If

	If (IsVazio(strTxtPaxChdCnxIn) Or Not IsNumeric(strTxtPaxChdCnxIn)) Then
		intTxtPaxChdCnxIn = CInt(0)
	Else
		intTxtPaxChdCnxIn = CInt(strTxtPaxChdCnxIn)
	End If

	If (IsVazio(strTxtPaxInfCnxIn) Or Not IsNumeric(strTxtPaxInfCnxIn)) Then
		intTxtPaxInfCnxIn = CInt(0)
	Else
		intTxtPaxInfCnxIn = CInt(strTxtPaxInfCnxIn)
	End If

	If (IsVazio(strTxtBagLivreLocal) Or Not IsNumeric(strTxtBagLivreLocal)) Then
		lngTxtBagLivreLocal = CLng(0)
	Else
		lngTxtBagLivreLocal = CLng(strTxtBagLivreLocal)
	End If

	If (IsVazio(strTxtBagExcessoLocal) Or Not IsNumeric(strTxtBagExcessoLocal)) Then
		lngTxtBagExcessoLocal = CLng(0)
	Else
		lngTxtBagExcessoLocal = CLng(strTxtBagExcessoLocal)
	End If

	If (IsVazio(strTxtBagLivreCnxIn) Or Not IsNumeric(strTxtBagLivreCnxIn)) Then
		lngTxtBagLivreCnxIn = CLng(0)
	Else
		lngTxtBagLivreCnxIn = CLng(strTxtBagLivreCnxIn)
	End If

	If (IsVazio(strTxtBagExcessoCnxIn) Or Not IsNumeric(strTxtBagExcessoCnxIn)) Then
		lngTxtBagExcessoCnxIn = CLng(0)
	Else
		lngTxtBagExcessoCnxIn = CLng(strTxtBagExcessoCnxIn)
	End If

	If (IsVazio(strTxtCargaPagaLocal) Or Not IsNumeric(strTxtCargaPagaLocal)) Then
		lngTxtCargaPagaLocal = CLng(0)
	Else
		lngTxtCargaPagaLocal = CLng(strTxtCargaPagaLocal)
	End If

	If (IsVazio(strTxtCargaGratisLocal) Or Not IsNumeric(strTxtCargaGratisLocal)) Then
		lngTxtCargaGratisLocal = CLng(0)
	Else
		lngTxtCargaGratisLocal = CLng(strTxtCargaGratisLocal)
	End If

	If (IsVazio(strTxtCargaPagaCnxIn) Or Not IsNumeric(strTxtCargaPagaCnxIn)) Then
		lngTxtCargaPagaCnxIn = CLng(0)
	Else
		lngTxtCargaPagaCnxIn = CLng(strTxtCargaPagaCnxIn)
	End If

	If (IsVazio(strTxtCargaGratisCnxIn) Or Not IsNumeric(strTxtCargaGratisCnxIn)) Then
		lngTxtCargaGratisCnxIn = CLng(0)
	Else
		lngTxtCargaGratisCnxIn = CLng(strTxtCargaGratisCnxIn)
	End If

	If (IsVazio(strTxtPaxPAD) Or Not IsNumeric(strTxtPaxPAD)) Then
		intTxtPaxPAD = CInt(0)
	Else
		intTxtPaxPAD = CInt(strTxtPaxPAD)
	End If

	If (IsVazio(strTxtPaxDHC) Or Not IsNumeric(strTxtPaxDHC)) Then
		intTxtPaxDHC = CInt(0)
	Else
		intTxtPaxDHC = CInt(strTxtPaxDHC)
	End If

	If (IsVazio(strTxtPaxCS) Or Not IsNumeric(strTxtPaxCS)) Then
		intTxtPaxCS = CInt(0)
	Else
		intTxtPaxCS = CInt(strTxtPaxCS)
	End If

	If (IsVazio(strTxtPaxCSRes) Or Not IsNumeric(strTxtPaxCSRes)) Then
		intTxtPaxCSRes = CInt(0)
	Else
		intTxtPaxCSRes = CInt(strTxtPaxCSRes)
	End If

	If (IsVazio(strTxtPorao1) Or Not IsNumeric(strTxtPorao1)) Then
		lngTxtPorao1 = CLng(0)
	Else
		lngTxtPorao1 = CLng(strTxtPorao1)
	End If

	If (IsVazio(strTxtPorao2) Or Not IsNumeric(strTxtPorao2)) Then
		lngTxtPorao2 = CLng(0)
	Else
		lngTxtPorao2 = CLng(strTxtPorao2)
	End If

	If (IsVazio(strTxtPorao3) Or Not IsNumeric(strTxtPorao3)) Then
		lngTxtPorao3 = CLng(0)
	Else
		lngTxtPorao3 = CLng(strTxtPorao3)
	End If

	If (IsVazio(strTxtPorao4) Or Not IsNumeric(strTxtPorao4)) Then
		lngTxtPorao4 = CLng(0)
	Else
		lngTxtPorao4 = CLng(strTxtPorao4)
	End If


	Dim intPaxPago, intPaxTrc, intPaxChd, intPaxChdTrc
	Dim intPaxInf, intPaxInfTrc, intPaxPad, intPaxDhc
	Dim intPaxCS, intPaxCSRes
	Dim lngBagLivre, lngBagTrc, lngBagExcesso, lngBagExcessoTrc
	Dim lngCargaPaga, lngCargaTrc, lngCargaGratis, lngCargaGratisTrc
	Dim lngPorao1, lngPorao2, lngPorao3, lngPorao4
	intPaxPago = CInt(intTxtPaxAdtLocal) + CInt(intTxtPaxChdLocal) + CInt(intTxtPaxAdtCnxIn) + CInt(intTxtPaxChdCnxIn)
	intPaxTrc = CInt(intTxtPaxAdtCnxIn) + CInt(intTxtPaxChdCnxIn)
	intPaxChd = CInt(intTxtPaxChdLocal) + CInt(intTxtPaxChdCnxIn)
	intPaxChdTrc = CInt(intTxtPaxChdCnxIn)
	intPaxInf = CInt(intTxtPaxInfLocal) + CInt(intTxtPaxInfCnxIn)
	intPaxInfTrc = CInt(intTxtPaxInfCnxIn)
	intPaxPad = CInt(intTxtPaxPAD)
	intPaxDhc = CInt(intTxtPaxDHC)
	intPaxCS = CInt(intTxtPaxCS)
	intPaxCSRes = CInt(intTxtPaxCSRes)
	lngBagLivre = CLng(lngTxtBagLivreLocal) + CLng(lngTxtBagLivreCnxIn)
	lngBagTrc = CLng(lngTxtBagLivreCnxIn)
	lngBagExcesso = CLng(lngTxtBagExcessoLocal) + CLng(lngTxtBagExcessoCnxIn)
	lngBagExcessoTrc = CLng(lngTxtBagExcessoCnxIn)
	lngCargaPaga = CLng(lngTxtCargaPagaLocal) + CLng(lngTxtCargaPagaCnxIn)
	lngCargaTrc = CLng(lngTxtCargaPagaCnxIn)
	lngCargaGratis = CLng(lngTxtCargaGratisLocal) + CLng(lngTxtCargaGratisCnxIn)
	lngCargaGratisTrc = CLng(lngTxtCargaGratisCnxIn)
	lngPorao1 = CLng(lngTxtPorao1)
	lngPorao2 = CLng(lngTxtPorao2)
	lngPorao3 = CLng(lngTxtPorao3)
	lngPorao4 = CLng(lngTxtPorao4)

	Dim intSeqVooDia, intSeqTrecho
	intSeqVooDia = ObterValorVariavelSessao("seqvoodia")
	intSeqTrecho = ObterValorVariavelSessao("seqtrecho")

	Dim strHidSeqCombinada
	strHidSeqCombinada = ObterValorCampo("hidSeqCombinada")

	Dim strQueryUpdate
	strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
	strQueryUpdate = strQueryUpdate & " SET paxpago = " & intPaxPago & ", "
	strQueryUpdate = strQueryUpdate & "     paxeconomica = " & intPaxPago & ", "
	strQueryUpdate = strQueryUpdate & "     paxtrc = " & intPaxTrc & ", "
	strQueryUpdate = strQueryUpdate & "     paxchd = " & intPaxChd & ", "
	strQueryUpdate = strQueryUpdate & "     paxchdtrc = " & intPaxChdTrc & ", "
	strQueryUpdate = strQueryUpdate & "     paxinf = " & intPaxInf & ", "
	strQueryUpdate = strQueryUpdate & "     paxinftrc = " & intPaxInfTrc & ", "
	strQueryUpdate = strQueryUpdate & "     paxpad = " & intPaxPad & ", "
	strQueryUpdate = strQueryUpdate & "     paxgratis = " & intPaxPad & ", "
	strQueryUpdate = strQueryUpdate & "     paxdhc = " & intPaxDhc & ", "
	strQueryUpdate = strQueryUpdate & "     paxcs = " & intPaxCS & ", "
	strQueryUpdate = strQueryUpdate & "     paxcsres = " & intPaxCSRes & ", "
	strQueryUpdate = strQueryUpdate & "     baglivre = " & lngBagLivre & ", "
	strQueryUpdate = strQueryUpdate & "     bagtrc = " & lngBagTrc & ", "
	strQueryUpdate = strQueryUpdate & "     bagexcesso = " & lngBagExcesso & ", "
	strQueryUpdate = strQueryUpdate & "     bagexcessotrc = " & lngBagExcessoTrc & ", "
	strQueryUpdate = strQueryUpdate & "     cargapaga = " & lngCargaPaga & ", "
	strQueryUpdate = strQueryUpdate & "     cargatrc = " & lngCargaTrc & ", "
	strQueryUpdate = strQueryUpdate & "     cargagratis = " & lngCargaGratis & ", "
	strQueryUpdate = strQueryUpdate & "     cargagratistrc = " & lngCargaGratisTrc & ", "
	strQueryUpdate = strQueryUpdate & "     porao1 = " & lngPorao1 & ", "
	strQueryUpdate = strQueryUpdate & "     porao2 = " & lngPorao2 & ", "
	strQueryUpdate = strQueryUpdate & "     porao3 = " & lngPorao3 & ", "
	strQueryUpdate = strQueryUpdate & "     porao4 = " & lngPorao4 & " "
	strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
	strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
	strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & strHidSeqCombinada & " "


	Dim objConnGravarEtapaCombinada
	Set objConnGravarEtapaCombinada = CreateObject("ADODB.CONNECTION")
	objConnGravarEtapaCombinada.Open (StringConexaoSqlServerUpdateEncriptado)
	objConnGravarEtapaCombinada.BeginTrans
	objConnGravarEtapaCombinada.Execute "SET DATEFORMAT ymd"

	Dim strMensagemErro, blnMostrarMensagemErro
	blnMostrarMensagemErro = False

	'Enable error handling
	On Error Resume Next

	objConnGravarEtapaCombinada.Execute(strQueryUpdate)
	If Err.number <> 0 Then
		strMensagemErro = "\nErro na atualização da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
	Else
		strMensagemErro = ""
	End If

	If (IsVazio(strMensagemErro)) Then
		' ********************************************
		' *** ATUALIZA PASSAGEIROS NA ETAPA BÁSICA ***
		' ********************************************
		Dim strSqlPassageiros
		strSqlPassageiros =                     "SELECT sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxpago, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxeconomica + SDTC.paxeconomicatran) paxeconomica, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxpad, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxgratis + SDTC.paxgratistran) paxgratis, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxdhc) paxdhc, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxcs) paxcs, "
		strSqlPassageiros = strSqlPassageiros & "       sum(SDTC.paxcsres) paxcsres, "
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

		Dim objRsPassageiros
		Set objRsPassageiros = Server.CreateObject("ADODB.Recordset")
		objRsPassageiros.Open strSqlPassageiros, objConnGravarEtapaCombinada
		If Err.number <> 0 Then
			strMensagemErro = "\nErro na recuperação de dados da tabela sig_diariotrechocomb\n" & Replace(Err.Description, "'", "\'")
			objRsPassageiros.Close()
			Set objRsPassageiros = Nothing
		Else
			strMensagemErro = ""
		End If

		If (IsVazio(strMensagemErro)) Then
			Dim strSqlUpdatePassageiros
			strSqlUpdatePassageiros =                           " UPDATE sig_diariotrecho "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & " SET paxpago      = " & CInt(ObjRsPassageiros("paxpago")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxeconomica = " & CInt(ObjRsPassageiros("paxeconomica")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxpad       = " & CInt(ObjRsPassageiros("paxpad")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxgratis    = " & CInt(ObjRsPassageiros("paxgratis")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxdhc       = " & CInt(ObjRsPassageiros("paxdhc")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxcs        = " & CInt(ObjRsPassageiros("paxcs")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxcsres     = " & CInt(ObjRsPassageiros("paxcsres")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     baglivre     = " & CLng(ObjRsPassageiros("baglivre")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     bagexcesso   = " & CLng(ObjRsPassageiros("bagexcesso")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargapaga    = " & CLng(ObjRsPassageiros("cargapaga")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     cargagratis  = " & CLng(ObjRsPassageiros("cargagratis")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxchd       = " & CInt(ObjRsPassageiros("paxchd")) & ", "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "     paxinf       = " & CInt(ObjRsPassageiros("paxinf")) & " "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & " WHERE seqvoodia=" & intSeqVooDia & " "
			strSqlUpdatePassageiros = strSqlUpdatePassageiros & "   AND seqtrecho=" & intSeqTrecho & " "

			objRsPassageiros.Close()
			Set objRsPassageiros = Nothing

			objConnGravarEtapaCombinada.Execute(strSqlUpdatePassageiros)
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
				objRsVerificaCapac.Open strSqlVerificaCapac, objConnGravarEtapaCombinada
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

	If (IsVazio(strMensagemErro)) Then
		objConnGravarEtapaCombinada.CommitTrans
		Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
	Else
		objConnGravarEtapaCombinada.RollbackTrans
		If (blnMostrarMensagemErro) Then
			Response.Write("<script language='javascript'>alert('" & strMensagemErro & "');</script>")
			'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
		Else
			Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema!');</script>")
			'Response.Write("<script language='javascript'>alert('Ocorreu um erro inesperado no sistema! " & strMensagemErro & "');</script>")
		End If
	End If

	objConnGravarEtapaCombinada.Close()
	Set objConnGravarEtapaCombinada = Nothing

	'Reset error handling
	On Error Goto 0

	If (IsVazio(strMensagemErro)) Then
		Dim intSeqUsuarioAerop
		intSeqUsuarioAerop = ObterValorVariavelSessao("member")

		' ************************************
		' *** DADOS DA TABELA DE AUDITORIA ***
		' ************************************
		Dim strDescricao, intRet
		strDescricao =                "[seqvoodia:" & intSeqVooDia & " seqtrecho:" & intSeqTrecho
		strDescricao = strDescricao & " seqcombinada:" & strHidSeqCombinada & "]"
		strDescricao = strDescricao & " / PAX Econom.:" & intPaxPago & " / PAX Gratis:" & intPaxPad
		strDescricao = strDescricao & " / PAX DHC:" & intPaxDhc & " / PAX TRC:" & intPaxTrc
		strDescricao = strDescricao & " / PAX Chd:" & intPaxChd & " / PAX Inf:" & intPaxInf
		strDescricao = strDescricao & " / PAX Chd TRC:" & intPaxChdTrc & " / PAX Inf TRC:" & intPaxInfTrc
		strDescricao = strDescricao & " / PAX CS:" & intPaxCS & " / PAX CS Res:" & intPaxCSRes
		strDescricao = strDescricao & " / Bag. Livre:" & lngBagLivre & " / Bag. Excesso:" & lngBagExcesso
		strDescricao = strDescricao & " / Bag. TRC:" & lngBagTrc & " / Bag. Excesso TRC:" & lngBagExcessoTrc
		strDescricao = strDescricao & " / Carga Paga:" & lngCargaPaga & " / Carga Gratis:" & lngCargaGratis
		strDescricao = strDescricao & " / Carga TRC:" & lngCargaTrc & " / Carga Gratis TRC:" & lngCargaGratisTrc
		strDescricao = strDescricao & " / Porao1:" & lngPorao1 & " / Porao2:" & lngPorao2
		strDescricao = strDescricao & " / Porao3:" & lngPorao3 & " / Porao4:" & lngPorao4

		Set objConn = CreateObject("ADODB.CONNECTION")
		objConn.Open (StringConexaoSqlServer)
		objConn.Execute "SET DATEFORMAT ymd"

		intRet = f_auditoria("SIG_DIARIOTRECHOCOMB", intSeqUsuarioAerop, "UPDATE", strDescricao, StringConexaoSqlServer)

		objConn.Close()
		Set objConn = Nothing
	End If

End Sub



' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
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

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
