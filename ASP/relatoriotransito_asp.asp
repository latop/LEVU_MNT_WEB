<!--#include file="verificaloginaeropfunc.asp"-->
<%

	' **************
	' *** TRECHO ***
	' **************
	Dim strNumeroVoo
	Dim strDataOperacao
	Dim strPouso
	Dim strDecolagem
	Dim strObservacao
	Dim strCodigoIataOrigem
	Dim strCodigoIataDestino
	Dim strPrefixoAeronave

	' ******************
	' *** TRIPULANTE ***
	' ******************
	Dim strComandante

	' *********************
	' *** TOTAL A BORDO ***
	' *********************
	Dim strPaxAdtTotal
	Dim strPaxChdTotal
	Dim strPaxInfTotal
	Dim strPaxDhcExtraTotal
	Dim strPaxPadGratisTotal
	Dim strPesoBagagemTotal
	Dim strPesoCorreioTotal
	Dim strCargaPagaTotal



Sub PreencherDetalheMovimentoTransito()

	Dim intSeqVooDia, intSeqTrecho
	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDia) Or IsVazio(intSeqTrecho)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If


	' ********************
	' *** FUSO BSB-GMT ***
	' ********************
	Dim strQueryFuso
	strQueryFuso =                "SELECT sig_fusovalor.fuso "
	strQueryFuso = strQueryFuso & "  FROM sig_fusovalor, "
	strQueryFuso = strQueryFuso & "       sig_parametros, "
	strQueryFuso = strQueryFuso & "       sig_diariovoo "
	strQueryFuso = strQueryFuso & " WHERE sig_fusovalor.codfuso = sig_parametros.codfusoref "
	strQueryFuso = strQueryFuso & "   AND sig_fusovalor.dtinicio <= sig_diariovoo.dtoper "
	strQueryFuso = strQueryFuso & "   AND (sig_fusovalor.dtfim >= sig_diariovoo.dtoper OR sig_fusovalor.dtfim IS NULL) "
	strQueryFuso = strQueryFuso & "   AND sig_diariovoo.seqvoodia = " & intSeqVooDia

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


	' **************
	' *** TRECHO ***
	' **************
	Dim strQueryTrecho
	strQueryTrecho = " SELECT "
	strQueryTrecho = strQueryTrecho & " DV.nrvoo NUMERO_VOO, "
	strQueryTrecho = strQueryTrecho & " DV.dtoper DATA_OPERACAO, "
	strQueryTrecho = strQueryTrecho & " DATEADD(hh, " & -intFusoGMT & ", DT.pouso) POUSO, "
	strQueryTrecho = strQueryTrecho & " DATEADD(hh, " & -intFusoGMT & ", DT.decolagem) DECOLAGEM, "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.paxprimeira, 0) + COALESCE(DT.paxespecial, 0) + COALESCE(DT.paxeconomica, 0) + "
	strQueryTrecho = strQueryTrecho & "    COALESCE(DT.paxturismo, 0) - COALESCE(DT.paxchd, 0) PAX_ADT, "
	strQueryTrecho = strQueryTrecho & " DT.paxchd PAX_CHD, "
	strQueryTrecho = strQueryTrecho & " DT.paxinf PAX_INF, "
	strQueryTrecho = strQueryTrecho & " DT.paxdhc PAX_DHC_EXTRA, "
	strQueryTrecho = strQueryTrecho & " DT.paxpad PAX_PAD_GRATIS, "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.baglivre, 0) + COALESCE(DT.bagexcesso, 0) PESO_BAGAGEM, "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.correioao, 0) + COALESCE(DT.correiolc, 0) PESO_CORREIO, "
	strQueryTrecho = strQueryTrecho & " DT.cargapaga CARGA_PAGA, "
	strQueryTrecho = strQueryTrecho & " DT.observacaotraf OBSERVACAO, "
	strQueryTrecho = strQueryTrecho & " ApOrig.codiata CODIGO_IATA_ORIGEM, "
	strQueryTrecho = strQueryTrecho & " ApDest.codiata CODIGO_IATA_DESTINO, "
	strQueryTrecho = strQueryTrecho & " Arnv.prefixo PREFIXO_AERONAVE "
	strQueryTrecho = strQueryTrecho & " FROM sig_diariovoo DV "
	strQueryTrecho = strQueryTrecho & "      INNER JOIN sig_diariotrecho DT ON DT.seqvoodia = DV.seqvoodia "
	strQueryTrecho = strQueryTrecho & "      INNER JOIN sig_aeroporto ApOrig ON ApOrig.seqaeroporto = DT.seqaeroporig "
	strQueryTrecho = strQueryTrecho & "      INNER JOIN sig_aeroporto ApDest ON ApDest.seqaeroporto = DT.seqaeropdest "
	strQueryTrecho = strQueryTrecho & "      INNER JOIN sig_aeronave Arnv ON Arnv.prefixored = DT.prefixoaeronave "
	strQueryTrecho = strQueryTrecho & " WHERE DT.seqvoodia = " & intSeqVooDia
	strQueryTrecho = strQueryTrecho & "   AND DT.seqtrecho = " & intSeqTrecho

	Dim objRsTrecho
	Set objRsTrecho = Server.CreateObject("ADODB.Recordset")
	objRsTrecho.Open strQueryTrecho, objConn

	If (objRsTrecho.EOF) Then
		objRsTrecho.Close()
		Set objRsTrecho = Nothing
		objConn.Close()
		Set objConn = Nothing
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	strNumeroVoo = objRsTrecho("NUMERO_VOO")
	If (IsVazio(strNumeroVoo)) Then strNumeroVoo = "&nbsp;"

	strPaxAdtTotal = objRsTrecho("PAX_ADT")
	If (IsVazio(strPaxAdtTotal)) Then strPaxAdtTotal = "0"

	strPaxChdTotal = objRsTrecho("PAX_CHD")
	If (IsVazio(strPaxChdTotal)) Then strPaxChdTotal = "0"

	strPaxInfTotal = objRsTrecho("PAX_INF")
	If (IsVazio(strPaxInfTotal)) Then strPaxInfTotal = "0"

	strPaxDhcExtraTotal = objRsTrecho("PAX_DHC_EXTRA")
	If (IsVazio(strPaxDhcExtraTotal)) Then strPaxDhcExtraTotal = "0"

	strPaxPadGratisTotal = objRsTrecho("PAX_PAD_GRATIS")
	If (IsVazio(strPaxPadGratisTotal)) Then strPaxPadGratisTotal = "0"

	strPesoBagagemTotal = objRsTrecho("PESO_BAGAGEM")
	If (IsVazio(strPesoBagagemTotal)) Then strPesoBagagemTotal = "0"

	strPesoCorreioTotal = objRsTrecho("PESO_CORREIO")
	If (IsVazio(strPesoCorreioTotal)) Then strPesoCorreioTotal = "0"

	strCargaPagaTotal = objRsTrecho("CARGA_PAGA")
	If (IsVazio(strCargaPagaTotal)) Then strCargaPagaTotal = "0"

	strObservacao = objRsTrecho("OBSERVACAO")
	If (IsVazio(strObservacao)) Then strObservacao = "&nbsp;"

	strCodigoIataOrigem = objRsTrecho("CODIGO_IATA_ORIGEM")
	If (IsVazio(strCodigoIataOrigem)) Then strCodigoIataOrigem = "&nbsp;"

	strCodigoIataDestino = objRsTrecho("CODIGO_IATA_DESTINO")
	If (IsVazio(strCodigoIataDestino)) Then strCodigoIataDestino = "&nbsp;"

	strPrefixoAeronave = objRsTrecho("PREFIXO_AERONAVE")
	If (IsVazio(strPrefixoAeronave)) Then strPrefixoAeronave = "&nbsp;"

	Dim dtDataOperacao
	dtDataOperacao = objRsTrecho("DATA_OPERACAO")
	If (IsVazio(dtDataOperacao)) Then
		strDataOperacao = "&nbsp;"
	Else
		strDataOperacao = Right("00" & Day(dtDataOperacao), 2) & "/" & Right("00" & Month(dtDataOperacao), 2) & "/" & Year(dtDataOperacao)
	End If

	Dim dtPouso
	dtPouso = objRsTrecho("POUSO")
	If (IsVazio(dtPouso)) Then
		strPouso = "&nbsp;"
	Else
		strPouso = Right("00" & Day(dtPouso), 2) & "/" & Right("00" & Month(dtPouso), 2) & "/" & Year(dtPouso)
		strPouso = strPouso & "&nbsp;" & FormatDateTime(dtPouso, 4)
	End If

	Dim dtDecolagem
	dtDecolagem = objRsTrecho("DECOLAGEM")
	If (IsVazio(dtDecolagem)) Then
		strDecolagem = "&nbsp;"
	Else
		strDecolagem = Right("00" & Day(dtDecolagem), 2) & "/" & Right("00" & Month(dtDecolagem), 2) & "/" & Year(dtDecolagem)
		strDecolagem = strDecolagem & "&nbsp;" & FormatDateTime(dtDecolagem, 4)
	End If

	objRsTrecho.Close()
	Set objRsTrecho = Nothing


	' ******************
	' *** TRIPULANTE ***
	' ******************
	Dim strQueryTrip
	strQueryTrip = "SELECT ST.nomeguerra, "
	strQueryTrip = strQueryTrip & "       ST.coddac "
	strQueryTrip = strQueryTrip & "  FROM sig_tripulante ST, "
	strQueryTrip = strQueryTrip & "       sig_jornada SJ, "
	strQueryTrip = strQueryTrip & "       sig_programacao SP, "
	strQueryTrip = strQueryTrip & "       sig_escdiariovoo SEDV, "
	strQueryTrip = strQueryTrip & "       sig_escdiariotrecho SEDT, "
	strQueryTrip = strQueryTrip & "       sig_tripcargo STC, "
	strQueryTrip = strQueryTrip & "       sig_cargo SC, "
	strQueryTrip = strQueryTrip & "       sig_diariovoo SDV, "
	strQueryTrip = strQueryTrip & "       sig_diariotrecho SDT "
	strQueryTrip = strQueryTrip & " WHERE SJ.seqjornada = SP.seqjornada "
	strQueryTrip = strQueryTrip & "   AND SJ.flgcorrente = 'S' "
	strQueryTrip = strQueryTrip & "   AND SJ.seqtripulante = ST.seqtripulante "
	strQueryTrip = strQueryTrip & "   AND SP.seqvoodiaesc = SEDV.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "   AND SP.seqvoodiaesc = SEDT.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "   AND SP.seqtrecho = SEDT.seqtrecho "
	strQueryTrip = strQueryTrip & "   AND SEDT.seqaeroporig = SDT.seqaeroporig "
	strQueryTrip = strQueryTrip & "   AND SEDT.seqaeropdest = SDT.seqaeropdest "
	strQueryTrip = strQueryTrip & "   AND ST.seqtripulante = STC.seqtripulante "
	strQueryTrip = strQueryTrip & "   AND STC.dtinicio <= SJ.dtjornada "
	strQueryTrip = strQueryTrip & "   AND (STC.dtfim >= SJ.dtjornada OR STC.dtfim IS NULL) "
	strQueryTrip = strQueryTrip & "   AND STC.codcargo = SC.codcargo "
	strQueryTrip = strQueryTrip & "   AND SC.ordem = 1 "
	strQueryTrip = strQueryTrip & "   AND (SP.funcao = 'I' OR SP.funcao IS NULL) "
	strQueryTrip = strQueryTrip & "   AND SJ.dtjornada = SDV.dtoper "
	strQueryTrip = strQueryTrip & "   AND SEDV.nrvoo = SDV.nrvoo "
	strQueryTrip = strQueryTrip & "   AND SDV.seqvoodia = SDT.seqvoodia "
	strQueryTrip = strQueryTrip & "   AND SDV.seqvoodia = " & intSeqVoodia
	strQueryTrip = strQueryTrip & "   AND SDT.seqtrecho = " & intSeqTrecho

	Dim objRsTrip
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn

	Dim strNomeGuerra, strCodDac
	strComandante = ""
	If (objRsTrip.EOF) Then
		strComandante = "&nbsp;"
	Else
		strNomeGuerra = objRsTrip("nomeguerra")
		strCodDac = objRsTrip("coddac")
		If (IsVazio(strNomeGuerra) And IsVazio(strCodDac)) Then
			strComandante = "&nbsp;"
		Else
			If (Not IsVazio(strNomeGuerra)) Then strComandante = strNomeGuerra
			If (Not IsVazio(strCodDac)) Then strComandante = strComandante & "&nbsp;-&nbsp;" & strCodDac & "&nbsp;"
		End If
	End If

	objRsTrip.Close()
	Set objRsTrip = Nothing

	objConn.Close()
	Set objConn = Nothing

End Sub

Sub PreencherTabelaCombinada()

	Dim intSeqVooDiaComb, intSeqTrechoComb
	intSeqVooDiaComb = Request.QueryString("seqvoodia")
	intSeqTrechoComb = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDiaComb) Or IsVazio(intSeqTrechoComb)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	Dim objConnComb
	Set objConnComb = CreateObject("ADODB.CONNECTION")
	objConnComb.Open (StringConexaoSqlServer)
	objConnComb.Execute "SET DATEFORMAT ymd"

	' *****************
	' *** COMBINADA ***
	' *****************
	Dim strQueryComb
	strQueryComb =                " SELECT MAX(DTC2.seqcombinada) ORDEM, "
	strQueryComb = strQueryComb & "        ApDest.codiata DESTINO_COMB, "
	strQueryComb = strQueryComb & "        'T' TIPO_EMBARQUE, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxprimeira, 0) + COALESCE(DTC.paxprimeiratran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxespecial, 0) + COALESCE(DTC.paxespecialtran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxeconomica, 0) + COALESCE(DTC.paxeconomicatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxturismo, 0) + COALESCE(DTC.paxturismotran, 0) - "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxchd, 0) - COALESCE(DTC.paxchdtran, 0)) PAX_ADT, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxchd, 0) + COALESCE(DTC.paxchdtran, 0)) PAX_CHD, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxinf, 0) + COALESCE(DTC.paxinftran, 0)) PAX_INF, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxdhc, 0)) PAX_DHC_EXTRA, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxgratis, 0) + COALESCE(DTC.paxgratistran, 0)) PAX_GRATIS, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.baglivre, 0) + COALESCE(DTC.baglivretran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.bagexcesso, 0) + COALESCE(DTC.bagexcessotran, 0)) PESO_BAGAGEM, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.correioao, 0) + COALESCE(DTC.correioaotran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.correiolc, 0) + COALESCE(DTC.correiolctran, 0)) PESO_CORREIO, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.cargapaga, 0) + COALESCE(DTC.cargapagatran, 0)) PESO_CARGA_PAGA "
	strQueryComb = strQueryComb & " FROM sig_diariotrechocomb DTC "
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrechocomb DTC2 ON DTC.seqvoodia = DTC2.seqvoodia "
	strQueryComb = strQueryComb & "                                          AND DTC.seqaeropdest = DTC2.seqaeropdest "
	strQueryComb = strQueryComb & "                                          AND DTC2.seqtrecho = " & intSeqTrechoComb
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrecho DT ON DTC.seqvoodia = DT.seqvoodia "
	strQueryComb = strQueryComb & "                                    AND DTC.seqtrecho = DT.seqtrecho "
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrecho DT2 ON DTC.seqvoodia = DT2.seqvoodia "
	strQueryComb = strQueryComb & "                                     AND DTC.seqaeropdest = DT2.seqaeropdest "
	strQueryComb = strQueryComb & "      INNER JOIN sig_aeroporto ApDest ON DTC.seqaeropdest = ApDest.seqaeroporto "
	strQueryComb = strQueryComb & " WHERE DTC.seqvoodia = " & intSeqVooDiaComb
	strQueryComb = strQueryComb & "   AND DTC.seqtrecho < " & intSeqTrechoComb
	strQueryComb = strQueryComb & "   AND DT2.seqtrecho >= " & intSeqTrechoComb
	strQueryComb = strQueryComb & " GROUP BY ApDest.codiata "
	strQueryComb = strQueryComb & " UNION "
	strQueryComb = strQueryComb & " SELECT MAX(DTC.seqcombinada) ORDEM, "
	strQueryComb = strQueryComb & "        ApDest.codiata DESTINO_COMB, "
	strQueryComb = strQueryComb & "        'L' TIPO_EMBARQUE, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxprimeira, 0) + COALESCE(DTC.paxprimeiratran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxespecial, 0) + COALESCE(DTC.paxespecialtran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxeconomica, 0) + COALESCE(DTC.paxeconomicatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxturismo, 0) + COALESCE(DTC.paxturismotran, 0) - "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxchd, 0) - COALESCE(DTC.paxchdtran, 0)) PAX_ADT, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxchd, 0) + COALESCE(DTC.paxchdtran, 0)) PAX_CHD, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxinf, 0) + COALESCE(DTC.paxinftran, 0)) PAX_INF, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxdhc, 0)) PAX_DHC_EXTRA, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxgratis, 0) + COALESCE(DTC.paxgratistran, 0)) PAX_GRATIS, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.baglivre, 0) + COALESCE(DTC.baglivretran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.bagexcesso, 0) + COALESCE(DTC.bagexcessotran, 0)) PESO_BAGAGEM, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.correioao, 0) + COALESCE(DTC.correioaotran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.correiolc, 0) + COALESCE(DTC.correiolctran, 0)) PESO_CORREIO, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.cargapaga, 0) + COALESCE(DTC.cargapagatran, 0)) PESO_CARGA_PAGA "
	strQueryComb = strQueryComb & " FROM sig_diariotrechocomb DTC "
	strQueryComb = strQueryComb & "      INNER JOIN sig_aeroporto ApDest ON DTC.seqaeropdest = ApDest.seqaeroporto "
	strQueryComb = strQueryComb & " WHERE DTC.seqvoodia = " & intSeqVooDiaComb
	strQueryComb = strQueryComb & "   AND DTC.seqtrecho = " & intSeqTrechoComb
	strQueryComb = strQueryComb & " GROUP BY ApDest.codiata "
	strQueryComb = strQueryComb & " ORDER BY 1, 2, 3 DESC "

	Dim objRsComb
	Set objRsComb = Server.CreateObject("ADODB.Recordset")
	objRsComb.Open strQueryComb, objConnComb

	Dim strDestinoCombAnterior, strDestinoCombNovo

	Do While (Not objRsComb.EOF)

		Dim strPaxAdtTran, strPaxChdTran, strPaxInfTran
		Dim strPesoBagagemTran, strPesoCorreioTran, strPesoCargaPagaTran
		strPaxAdtTran = "0"
		strPaxChdTran = "0"
		strPaxInfTran = "0"
		strPesoBagagemTran = "0"
		strPesoCorreioTran = "0"
		strPesoCargaPagaTran = "0"

		Dim strPaxAdt, strPaxChd, strPaxInf, strPaxDhcExtra, strPaxGratis
		Dim strPesoBagagem, strPesoCorreio, strPesoCargaPaga
		strPaxAdt = "0"
		strPaxChd = "0"
		strPaxInf = "0"
		strPaxDhcExtra = "0"
		strPaxGratis = "0"
		strPesoBagagem = "0"
		strPesoCorreio = "0"
		strPesoCargaPaga = "0"

		Dim strDestinoComb
		strDestinoComb = objRsComb("DESTINO_COMB")
		If (IsVazio(strDestinoComb)) Then strDestinoComb = "&nbsp;"

		strDestinoCombAnterior = strDestinoComb

		Do While (Not objRsComb.EOF And _
		          (IsVazio(strDestinoCombNovo) Or (strDestinoCombAnterior = strDestinoCombNovo)))

			Dim strTipoEmbarque
			strTipoEmbarque = objRsComb("TIPO_EMBARQUE")

			If (strTipoEmbarque = "T") Then
				strPaxAdtTran = objRsComb("PAX_ADT")
				If (IsVazio(strPaxAdtTran)) Then strPaxAdtTran = "0"

				strPaxChdTran = objRsComb("PAX_CHD")
				If (IsVazio(strPaxChdTran)) Then strPaxChdTran = "0"

				strPaxInfTran = objRsComb("PAX_INF")
				If (IsVazio(strPaxInfTran)) Then strPaxInfTran = "0"

				strPesoBagagemTran = objRsComb("PESO_BAGAGEM")
				If (IsVazio(strPesoBagagemTran)) Then strPesoBagagemTran = "0"

				strPesoCorreioTran = objRsComb("PESO_CORREIO")
				If (IsVazio(strPesoCorreioTran)) Then strPesoCorreioTran = "0"

				strPesoCargaPagaTran = objRsComb("PESO_CARGA_PAGA")
				If (IsVazio(strPesoCargaPagaTran)) Then strPesoCargaPagaTran = "0"
			ElseIf (strTipoEmbarque = "L") Then
				strPaxAdt = objRsComb("PAX_ADT")
				If (IsVazio(strPaxAdt)) Then strPaxAdt = "0"

				strPaxChd = objRsComb("PAX_CHD")
				If (IsVazio(strPaxChd)) Then strPaxChd = "0"

				strPaxInf = objRsComb("PAX_INF")
				If (IsVazio(strPaxInf)) Then strPaxInf = "0"

				strPaxDhcExtra = objRsComb("PAX_DHC_EXTRA")
				If (IsVazio(strPaxDhcExtra)) Then strPaxDhcExtra = "0"

				strPaxGratis = objRsComb("PAX_GRATIS")
				If (IsVazio(strPaxGratis)) Then strPaxGratis = "0"

				strPesoBagagem = objRsComb("PESO_BAGAGEM")
				If (IsVazio(strPesoBagagem)) Then strPesoBagagem = "0"

				strPesoCorreio = objRsComb("PESO_CORREIO")
				If (IsVazio(strPesoCorreio)) Then strPesoCorreio = "0"

				strPesoCargaPaga = objRsComb("PESO_CARGA_PAGA")
				If (IsVazio(strPesoCargaPaga)) Then strPesoCargaPaga = "0"
			End If

			objRsComb.MoveNext
			If (Not objRsComb.EOF) Then
				strDestinoCombNovo = objRsComb("DESTINO_COMB")
			Else
				strDestinoCombNovo = "XXXXX"
			End If

		Loop

		Response.Write("			<tr style='text-align:right; font-size:10pt; font-weight:bold;'>" & vbCrLf)
		Response.Write("				<td style='text-align:center;' rowspan='2'>" & strDestinoComb & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:center; font-size:9pt; font-weight:normal;'>T</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxAdtTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxChdTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxInfTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoBagagemTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCorreioTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCargaPagaTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)
		Response.Write("			<tr style='text-align:right; font-size:10pt; font-weight:bold;'>" & vbCrLf)
		Response.Write("				<td style='text-align:center; font-size:9pt; font-weight:normal;'>L</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxAdt & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxChd & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxInf & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxDhcExtra & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxGratis & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoBagagem & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCorreio & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCargaPaga & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>&nbsp;</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)

	Loop

	objRsComb.Close
	Set objRsComb = Nothing

	objConnComb.Close()
	Set objConnComb = Nothing

End Sub



Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
