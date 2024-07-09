<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeropfunc.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>

<html>
<head>
	<title>Mensagem de Decolagem e Pouso</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
   <style type="text/css">
body {
	margin-left: 0px;
}

</style>

</head>

<body>
<%
	Dim intSeqVooDia, intSeqTrecho, intSeqCombinada
	Dim objConn
	Dim blnFazConsulta
	Dim dataPrevista
	Dim voo
	blnFazConsulta = true

	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")
	dataPrevista = Request.QueryString("dataPrevista")
	voo = Request.QueryString("voo")

	

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

	' ***************
	' *** TRECHOS ***
	' ***************
	Dim objRsVoo, strQueryVoo
	strQueryVoo = " SELECT "
	strQueryVoo = strQueryVoo & " SDV.nrvoo, "
	strQueryVoo = strQueryVoo & " SDV.dtoper, "
	strQueryVoo = strQueryVoo & " AN.prefixo, "
	strQueryVoo = strQueryVoo & " AO.codiata Origem, "
	strQueryVoo = strQueryVoo & " AD.codiata Destino, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.partidamotor) partidamotor, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.decolagem) decolagem, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.pouso) pouso, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.cortemotor) cortemotor, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.partidaest) partidaest, "
	strQueryVoo = strQueryVoo & " DATEADD(hh, " & -intFusoGMT & ", SDT.chegadaest) chegadaest, "
	strQueryVoo = strQueryVoo & " SDT.paxeconomica, "
	strQueryVoo = strQueryVoo & " SDT.paxdhc, "
	strQueryVoo = strQueryVoo & " SDT.paxgratis, "
	strQueryVoo = strQueryVoo & " SDT.paxchd, "
	strQueryVoo = strQueryVoo & " SDT.paxinf, "
	strQueryVoo = strQueryVoo & " SDT.baglivre, "
	strQueryVoo = strQueryVoo & " SDT.bagexcesso, "
	strQueryVoo = strQueryVoo & " SDT.cargapaga, "
	strQueryVoo = strQueryVoo & " SDT.cargagratis, "
	strQueryVoo = strQueryVoo & " SDT.atzdecint, "
	strQueryVoo = strQueryVoo & " SDT.idjustifinterna, "
	strQueryVoo = strQueryVoo & " SJI.idjustifiata, "
	strQueryVoo = strQueryVoo & " SDT.combustivel, "
	strQueryVoo = strQueryVoo & " SDT.idjustifinternatraf, "
	strQueryVoo = strQueryVoo & " SDT.observacaotraf "
	strQueryVoo = strQueryVoo & " FROM sig_diariovoo SDV, "
	strQueryVoo = strQueryVoo & " sig_diariotrecho SDT "
	strQueryVoo = strQueryVoo & " LEFT OUTER JOIN sig_justifinterna SJI ON SDT.idjustifinterna = SJI.idjustifinterna, "
	strQueryVoo = strQueryVoo & " sig_aeroporto AO, "
	strQueryVoo = strQueryVoo & " sig_aeroporto AD, "
	strQueryVoo = strQueryVoo & " sig_aeronave AN "
	strQueryVoo = strQueryVoo & " WHERE SDV.seqvoodia = SDT.seqvoodia "
	strQueryVoo = strQueryVoo & "   AND SDT.seqvoodia = " & intSeqVooDia
	strQueryVoo = strQueryVoo & "   AND SDT.seqtrecho = " & intSeqTrecho
	strQueryVoo = strQueryVoo & "   AND SDT.seqaeroporig = AO.seqaeroporto "
	strQueryVoo = strQueryVoo & "   AND SDT.seqaeropdest = AD.seqaeroporto "
	strQueryVoo = strQueryVoo & "   AND SDT.prefixoaeronave = AN.prefixored "
	Set objRsVoo = Server.CreateObject("ADODB.Recordset")
	objRsVoo.Open strQueryVoo, objConn
	If objRsVoo.eof then
		response.write "Nenhum registro encontrado"
		Response.End()
	end if

	' *****************
	' *** COMBINADA ***
	' *****************
	Dim objRsComb, strQueryComb
	strQueryComb = " SELECT "
	strQueryComb = strQueryComb & " AD.codiata DestinoComb, "
	strQueryComb = strQueryComb & " STC.seqcombinada, "
	strQueryComb = strQueryComb & " STC.paxprimeira, "
	strQueryComb = strQueryComb & " STC.paxeconomica, "
	strQueryComb = strQueryComb & " STC.paxespecial, "
	strQueryComb = strQueryComb & " STC.paxgratis, "
	strQueryComb = strQueryComb & " STC.paxdhc, "
	strQueryComb = strQueryComb & " STC.paxchd, "
	strQueryComb = strQueryComb & " STC.paxinf, "
	strQueryComb = strQueryComb & " STC.baglivre, "
	strQueryComb = strQueryComb & " STC.bagexcesso, "
	strQueryComb = strQueryComb & " STC.cargapaga, "
	strQueryComb = strQueryComb & " STC.cargagratis, "
	strQueryComb = strQueryComb & " STC.porao1, "
	strQueryComb = strQueryComb & " STC.porao2, "
	strQueryComb = strQueryComb & " STC.porao3, "
	strQueryComb = strQueryComb & " STC.porao4, "
	strQueryComb = strQueryComb & " STC.paxprimeiratran, "
	strQueryComb = strQueryComb & " STC.paxeconomicatran, "
	strQueryComb = strQueryComb & " STC.paxespecialtran, "
	strQueryComb = strQueryComb & " STC.paxgratistran, "
	strQueryComb = strQueryComb & " STC.paxchdtran, "
	strQueryComb = strQueryComb & " STC.paxinftran, "
	strQueryComb = strQueryComb & " STC.baglivretran, "
	strQueryComb = strQueryComb & " STC.bagexcessotran, "
	strQueryComb = strQueryComb & " STC.cargapagatran, "
	strQueryComb = strQueryComb & " STC.cargagratistran, "
	strQueryComb = strQueryComb & " STC.porao1tran, "
	strQueryComb = strQueryComb & " STC.porao2tran, "
	strQueryComb = strQueryComb & " STC.porao3tran, "
	strQueryComb = strQueryComb & " STC.porao4tran, "
	strQueryComb = strQueryComb & " STC.paxpad, "
	strQueryComb = strQueryComb & " SDV.nrvoo, "
	strQueryComb = strQueryComb & " SDV.dtoper, "
	strQueryComb = strQueryComb & " STC.seqaeropdest "
	strQueryComb = strQueryComb & " FROM sig_diariovoo SDV, "
	strQueryComb = strQueryComb & " sig_diariotrecho SDT, "
	strQueryComb = strQueryComb & " sig_diariotrechocomb STC, "
	strQueryComb = strQueryComb & " sig_aeroporto AD "
	strQueryComb = strQueryComb & " WHERE SDV.seqvoodia = SDT.seqvoodia "
	strQueryComb = strQueryComb & "   AND SDV.seqvoodia = STC.seqvoodia "
	strQueryComb = strQueryComb & "   AND SDT.seqtrecho = STC.seqtrecho "
	strQueryComb = strQueryComb & "   AND SDT.seqvoodia = " & intSeqVooDia
	strQueryComb = strQueryComb & "   AND SDT.seqtrecho = " & intSeqTrecho
	strQueryComb = strQueryComb & "   AND STC.seqaeropdest = AD.seqaeroporto "
	strQueryComb = strQueryComb & " ORDER BY STC.seqcombinada "
	Set objRsComb = Server.CreateObject("ADODB.Recordset")
	objRsComb.Open strQueryComb, objConn

	' ******************
	' *** TRIPULANTE ***
	' ******************
	Dim objRsTrip, strQueryTrip
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
'	strQueryTrip = strQueryTrip & "   AND (SP.funcao = 'I' OR SP.funcao IS NULL) "
	strQueryTrip = strQueryTrip & "   AND SJ.dtjornada = SDV.dtoper "
	strQueryTrip = strQueryTrip & "   AND SEDV.nrvoo = SDV.nrvoo "
	strQueryTrip = strQueryTrip & "   AND SDV.seqvoodia = SDT.seqvoodia "
	strQueryTrip = strQueryTrip & "   AND SDV.seqvoodia = " & intSeqVoodia
	strQueryTrip = strQueryTrip & "   AND SDT.seqtrecho = " & intSeqTrecho
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn
'	If objRsTrip.eof then
'		response.write "Nenhum registro encontrado"
'	end if

	' ******************
	' *** PARAMETROS ***
	' ******************
	Dim objRsParam, strQueryParam
	strQueryParam = " SELECT SP.siglaredempresa FROM sig_parametros SP "
	Set objRsParam = Server.CreateObject("ADODB.Recordset")
	objRsParam.Open strQueryParam, objConn

%>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>&nbsp;Mensagem de Decolagem e Pouso [Horário UTC]</b></font>
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
	</table>
</center>
<br>


	<table width="98%" border="1" cellspacing="1" ID="Table2">
		<%
		Dim dtPartidaMotor, intTotalCombTran, strNomeGuerra, strCodDac
		Dim intPorao

		if (ObjRsTrip.EOF) then
			strNomeGuerra = ""
			strCodDac = ""
		else
			strNomeGuerra = ObjRsTrip("nomeguerra")
			strCodDac = ObjRsTrip("coddac")
			if (IsNull(strCodDac)) then
				strCodDac = ""
			end if
		end if
				
		Response.Write("<B>MVT DEP</B><BR>" & vbCrLf)
		Response.Write(ObjRsParam("siglaredempresa") & ObjRsVoo("nrvoo") & "/" & Day(ObjRsVoo("dtoper")) & "." & Trim(ObjRsVoo("prefixo")) & "." & ObjRsVoo("origem") & "<BR>" & vbCrLf)

		dtPartidaMotor=ObjRsVoo("partidamotor")
		if (IsNull(dtPartidaMotor) or IsEmpty(dtPartidaMotor)) then
			Response.Write("AD    /     EA" & FormataHora(ObjRsVoo("chegadaest")) & " " & ObjRsVoo("destino") & "<BR>" & vbCrLf)
		else
			Response.Write("AD" & FormataHora(ObjRsVoo("partidamotor")) & "/" & FormataHora(ObjRsVoo("decolagem")) & " EA" & FormataHora(ObjRsVoo("chegadaest")) & " " & ObjRsVoo("destino") & "<BR>" & vbCrLf)
		end if

		Response.Write("DL " & ObjRsVoo("idjustifiata") & " / " & ObjRsVoo("atzdecint") & "<BR>" & vbCrLf)
		Response.Write("PX " & ObjRsVoo("paxeconomica") & " / " & CInt(objRsComb("paxeconomica")) & "<BR>" & vbCrLf)
		Response.Write("DHC/" & ObjRsVoo("paxdhc") & ".PAD/0/0/" & ObjRsVoo("paxgratis") & "<BR>" & vbCrLf)
		Response.Write("LOAD " & CStr(CInt(ObjRsVoo("baglivre"))+CInt(ObjRsVoo("bagexcesso"))+CInt(ObjRsVoo("cargapaga"))+CInt(ObjRsVoo("cargagratis"))) & "/" & CStr(CInt(ObjRsComb("baglivre"))+CInt(ObjRsComb("bagexcesso"))+CInt(ObjRsComb("cargapaga"))+CInt(ObjRsComb("cargagratis"))+CInt(ObjRsComb("baglivretran"))+CInt(ObjRsComb("bagexcessotran"))+CInt(ObjRsComb("cargapagatran"))+CInt(ObjRsComb("cargagratistran"))) & "<BR>" & vbCrLf)
		Response.Write("CAPTAIN - " & strNomeGuerra & " (" & strCodDac & ") <a href='relatoriotrip.asp?seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "&dataPrevista="& dataPrevista &"&voo=" &voo&"'>Crew Members</a><BR>" & vbCrLf)
		Response.Write("FUEL OUT " & ObjRsVoo("combustivel") & "<BR>" & vbCrLf)
		Response.Write("SI<BR>")
		Response.Write("[" & ObjRsVoo("idjustifinternatraf") & "] " & ObjRsVoo("observacaotraf") & "<BR>" & vbCrLf)

		%>

		<BR><B>LDM</B><BR>
		<%
			Do While Not objRsComb.Eof
		%>
			-<%=objRsComb("destinocomb")%>.
			<%=CInt(objRsComb("paxprimeira"))+CInt(objRsComb("paxespecial"))+CInt(objRsComb("paxeconomica"))+CInt(objRsComb("paxgratis"))-CInt(objRsComb("paxchd"))%>/<%=CInt(objRsComb("paxchd"))%>/<%=CInt(objRsComb("paxinf"))%>.
			T<%=CInt(ObjRsComb("baglivre"))+CInt(ObjRsComb("bagexcesso"))+CInt(ObjRsComb("cargapaga"))+CInt(ObjRsComb("cargagratis"))%>.
			1/<%=ObjRsComb("porao1")%>
			2/<%=ObjRsComb("porao2")%>
			3/<%=ObjRsComb("porao3")%>
			4/<%=ObjRsComb("porao4")%>.
			PAX 0/<%=CInt(objRsComb("paxespecial"))%>/<%=CInt(objRsComb("paxeconomica"))%>.
			PAD 0/0/<%=CInt(objRsComb("paxgratis"))%>.
			DHC/<%=objRsComb("paxdhc")%>.
			BAG/<%=CInt(ObjRsComb("baglivre"))+CInt(ObjRsComb("bagexcesso"))%>
			EXC/<%=CInt(ObjRsComb("bagexcesso"))%>
			CGA/<%=CInt(ObjRsComb("cargapaga"))%>
			CMT/<%=CInt(ObjRsComb("cargagratis"))%>
			<%
				Dim ll_NrVoo, ll_DtOper, ll_SeqAeropDest
				ll_NrVoo = CInt(ObjRsComb("nrvoo"))
				ll_DtOper = CDate(ObjRsComb("dtoper"))
				ll_SeqAeropDest = CInt(ObjRsComb("seqaeropdest"))
				Response.Write("&nbsp;<a href='conexoesinbound.asp?nrvoo=" & ll_NrVoo & "&dtoper=" & Year(ll_DtOper) & "+" & Month(ll_DtOper) & "+" & Day(ll_DtOper) & "&seqaeropdest=" & ll_SeqAeropDest & "'>" & vbCrLf)
				Response.Write("Conexão Inbound</a>" & vbCrLf)
			%>
			<BR>

			<%
			intTotalCombTran = CInt(objRsComb("paxeconomicatran"))+CInt(objRsComb("paxespecialtran"))+CInt(objRsComb("paxgratistran"))+CInt(objRsComb("paxchdtran"))+CInt(objRsComb("paxinftran"))+CInt(ObjRsComb("baglivretran"))+CInt(ObjRsComb("bagexcessotran"))+CInt(ObjRsComb("cargapagatran"))+CInt(ObjRsComb("cargagratistran"))
			if intTotalCombTran > 0 then
				intSeqCombinada = CInt(ObjRsComb("seqcombinada"))

				' ****************
				' *** TRANSITO ***
				' ****************
				Dim objRsCombTran, strQueryCombTran
				strQueryCombTran = " SELECT "
				strQueryCombTran = strQueryCombTran & " AD.codiata DestinoComb, "
				strQueryCombTran = strQueryCombTran & " STCT.nrvoo, "
				strQueryCombTran = strQueryCombTran & " STCT.paxprimeira, "
				strQueryCombTran = strQueryCombTran & " STCT.paxespecial, "
				strQueryCombTran = strQueryCombTran & " STCT.paxeconomica, "
				strQueryCombTran = strQueryCombTran & " STCT.paxgratis, "
				strQueryCombTran = strQueryCombTran & " STCT.paxchd, "
				strQueryCombTran = strQueryCombTran & " STCT.paxinf, "
				strQueryCombTran = strQueryCombTran & " STCT.baglivre, "
				strQueryCombTran = strQueryCombTran & " STCT.bagexcesso, "
				strQueryCombTran = strQueryCombTran & " STCT.cargapaga, "
				strQueryCombTran = strQueryCombTran & " STCT.cargagratis, "
				strQueryCombTran = strQueryCombTran & " STCT.porao1, "
				strQueryCombTran = strQueryCombTran & " STCT.porao2, "
				strQueryCombTran = strQueryCombTran & " STCT.porao3, "
				strQueryCombTran = strQueryCombTran & " STCT.porao4 "
				strQueryCombTran = strQueryCombTran & " FROM sig_diariotrechocombtran STCT, "
				strQueryCombTran = strQueryCombTran & " sig_aeroporto AD "
				strQueryCombTran = strQueryCombTran & " WHERE STCT.seqvoodia = " & intSeqVooDia
				strQueryCombTran = strQueryCombTran & "   AND STCT.seqtrecho = " & intSeqTrecho
				strQueryCombTran = strQueryCombTran & "   AND STCT.seqcombinada = " & intSeqCombinada
				strQueryCombTran = strQueryCombTran & "   AND STCT.seqaeropdest = AD.seqaeroporto "
				strQueryCombTran = strQueryCombTran & " ORDER BY STCT.seqcombinada "
				Set objRsCombTran = Server.CreateObject("ADODB.Recordset")
				objRsCombTran.Open strQueryCombTran, objConn

				Do While Not objRsCombTran.Eof
					Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-J." & vbCrLf)
					Response.Write(objRsCombTran("DestinoComb") & " " & objRsCombTran("nrvoo") & " - " & vbCrLf)
					Response.Write(CStr(Cint(objRsCombTran("paxprimeira"))+Cint(objRsCombTran("paxespecial"))+Cint(objRsCombTran("paxeconomica"))+CInt(objRsCombTran("paxgratis"))-CInt(objRsCombTran("paxchd"))) & "/" & objRsCombTran("paxchd") & "/" & objRsCombTran("paxinf") & vbCrLf)

					Response.Write("T" & CStr(CInt(ObjRsCombTran("baglivre"))+CInt(ObjRsCombTran("bagexcesso"))+CInt(ObjRsCombTran("cargapaga"))+CInt(ObjRsCombTran("cargagratis"))) & vbCrLf)
					Response.Write("1/" & ObjRsCombTran("porao1") & " 2/" & ObjRsCombTran("porao2") & " 3/" & ObjRsCombTran("porao3") & " 4/" & ObjRsCombTran("porao4") & "." & vbCrLf)
					Response.Write("PAX " & objRsCombTran("paxprimeira") & "/" & objRsCombTran("paxespecial") & "/" & objRsCombTran("paxeconomica") & vbCrLf)
					Response.Write("PAD 0/0/" & objRsCombTran("paxgratis") & vbCrLf)
					Response.Write("DHC/0." & vbCrLf)
					Response.Write("BAG/" & CStr(CInt(ObjRsCombTran("baglivre"))+CInt(ObjRsCombTran("bagexcesso"))) & vbCrLf)
					Response.Write("EXC/" & ObjRsCombTran("bagexcesso") & vbCrLf)
					Response.Write("CGA/" & ObjRsCombTran("cargapaga") & vbCrLf)
					Response.Write("CMT/" & ObjRsCombTran("cargagratis") & vbCrLf)
					Response.Write("<BR>" & vbCrLf)

					objRsCombTran.movenext
				loop
				objRsCombTran.Close
				Set objRsCombTran = Nothing

				Response.Write("<BR>" & vbCrLf)
			end if

			objRsComb.movenext
		loop
		objRsComb.Close
		Set objRsComb = Nothing
		%>
	</table>

	<BR>
	<BR>
	<BR>
	<table width="98%" border="0" cellspacing="1" ID="Table3">
		<%
		Dim dtCorteMotor

		Response.Write("<B>MVT ARR</B><BR>" & vbCrLf)
		Response.Write(ObjRsParam("siglaredempresa") & ObjRsVoo("nrvoo") & "/" & Day(ObjRsVoo("dtoper")) & "." & Trim(ObjRsVoo("prefixo")) & "." & ObjRsVoo("destino") & "<BR>" & vbCrLf)

		dtCorteMotor=ObjRsVoo("cortemotor")
		if (IsNull(dtCorteMotor) or IsEmpty(dtCorteMotor)) then
			Response.Write("AA    /     <BR>" & vbCrLf)
		else
			Response.Write("AA" & FormataHora(ObjRsVoo("pouso")) & "/" & FormataHora(ObjRsVoo("cortemotor")) & vbCrLf)
		end if
		%>
	</table>



<%
  objRsVoo.Close
  objConn.close
  Set objRsVoo = Nothing
  Set objConn = Nothing
%>

</body>

</html>

<%
	Function FormataHora(dtHora)
		Dim intHora, strHora
		Dim intMinuto, strMinuto

		intHora = CInt(Hour(dtHora))
		if intHora < 10 then
			strHora = "0" & CStr(intHora)
		else
			strHora = CStr(intHora)
		end if

		intMinuto = CInt(Minute(dtHora))
		if intMinuto < 10 then
			strMinuto = "0" & CStr(intMinuto)
		else
			strMinuto = CStr(intMinuto)
		end if

		FormataHora = strHora & strMinuto
	end function
%>
