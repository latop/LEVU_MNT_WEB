<%

Dim strVoltar, intSeqVooDia, intSeqTrecho
strVoltar = Request.Form("btnVoltar")

intSeqVooDia = Request.Form("hidSeqVooDia")
if (IsVazio(intSeqVooDia)) then
	intSeqVooDia = Request.QueryString("seqvoodia")
end if

intSeqTrecho = Request.Form("hidSeqTrecho")
if (IsVazio(intSeqTrecho)) then
	intSeqTrecho = Request.QueryString("seqtrecho")
end if

if (strVoltar <> "") then
	Response.Redirect("../ASP2ASPX/ASP2ASPX.asp?paginaDestino=CombinadaAeropSec.aspx%3fseqvoodia%3d" & intSeqVooDia & "%26seqtrecho%3d" & intSeqTrecho & "&dominioDestino=Aeroporto")
end if



sub PreencherTitulo()

	Dim strNrVoo, strDtOper, strSeqAeropDest
	Dim intNrVoo, intSeqAeropDest
	strNrVoo = Request.QueryString("nrvoo")
	intNrVoo = CInt(strNrVoo)
	strDtOper = Request.QueryString("dtoper")
	strSeqAeropDest = Request.QueryString("seqaeropdest")
	intSeqAeropDest = CInt(strSeqAeropDest)

	Dim dtDataOper, intDiaOper, intMesOper, intAnoOper
	Dim strDiaOper, strMesOper, strAnoOper
	dtDataOper = CDate(strDtOper)
	intDiaOper = Day(dtDataOper)
	intMesOper = Month(dtDataOper)
	intAnoOper = Year(dtDataOper)
	strDiaOper = CStr(intDiaOper)
	strMesOper = CStr(intMesOper)
	strAnoOper = CStr(intAnoOper)
	if (Len(strDiaOper) < 2) then
		strDiaOper = "0" & strDiaOper
	end if
	if (Len(strMesOper) < 2) then
		strMesOper = "0" & strMesOper
	end if

	' *************************************
	' *** DADOS DO AEROPORTO DE DESTINO ***
	' *************************************
	Dim strQueryAeroporto
	strQueryAeroporto = " SELECT seqaeroporto, codiata, nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto "
	strQueryAeroporto = strQueryAeroporto & "  WHERE seqaeroporto = " & intSeqAeropDest

	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim objRsAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn

	Dim strNomeAeroporto, strCodAeroporto
	strNomeAeroporto = objRsAeroporto("nomeaeroporto")
	strCodAeroporto = objRsAeroporto("codiata")

	objRsAeroporto.Close
	objConn.Close
	Set objRsAeroporto = Nothing
	Set objConn = Nothing

	'**************
	'*** TÍTULO ***
	'**************
	Response.Write("<font size='3'><b>")
	Response.Write("Conexões Inbound do<br />")
	Response.Write("Voo " & intNrVoo & " [" & strDiaOper & "/" & strMesOper & "/" & strAnoOper & "]<br />")
	Response.Write("Aeroporto " & strCodAeroporto)
	Response.Write("</b></font>")

end sub



sub PreencherTabelaConexoesInbound()

	Dim strNrVoo, strDtOper, strSeqAeropDest
	Dim intNrVoo, intSeqAeropDest
	strNrVoo = Request.QueryString("nrvoo")
	intNrVoo = CInt(strNrVoo)
	strDtOper = Request.QueryString("dtoper")
	strSeqAeropDest = Request.QueryString("seqaeropdest")
	intSeqAeropDest = CInt(strSeqAeropDest)

	Dim dtDataOper, intDiaOper, intMesOper, intAnoOper
	Dim strDiaOper, strMesOper, strAnoOper
	dtDataOper = CDate(strDtOper)
	intDiaOper = Day(dtDataOper)
	intMesOper = Month(dtDataOper)
	intAnoOper = Year(dtDataOper)
	strDiaOper = CStr(intDiaOper)
	strMesOper = CStr(intMesOper)
	strAnoOper = CStr(intAnoOper)
	if (Len(strDiaOper) < 2) then
		strDiaOper = "0" & strDiaOper
	end if
	if (Len(strMesOper) < 2) then
		strMesOper = "0" & strMesOper
	end if

	' ************************
	' *** CONEXÕES INBOUND ***
	' ************************
	Dim strQueryConexoesInbound
	strQueryConexoesInbound =                           " SELECT sig_diariovoo.dtoper, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariovoo.nrvoo, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        aeroporigtrecho.codiata origembarque, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        aeropdestcomb.codiata conexao, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        aeropdesttran.codiata destino, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        (sig_diariotrechocombtran.paxeconomica - sig_diariotrechocombtran.paxchd)  paxadt, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.paxchd, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.paxinf, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.paxeconomica paxpago, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.paxgratis paxpad, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.baglivre, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.bagexcesso, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.cargapaga, "
	strQueryConexoesInbound = strQueryConexoesInbound & "        sig_diariotrechocombtran.cargagratis "
	strQueryConexoesInbound = strQueryConexoesInbound & " FROM sig_diariovoo, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_diariotrecho, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_diariotrechocomb, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_diariotrechocombtran, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_aeroporto aeroporigtrecho, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_aeroporto aeropdestcomb, "
	strQueryConexoesInbound = strQueryConexoesInbound & "      sig_aeroporto aeropdesttran "
	strQueryConexoesInbound = strQueryConexoesInbound & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrecho.seqvoodia = sig_diariotrechocomb.seqvoodia "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrecho.seqtrecho = sig_diariotrechocomb.seqtrecho "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocomb.seqvoodia = sig_diariotrechocombtran.seqvoodia "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocomb.seqtrecho = sig_diariotrechocombtran.seqtrecho "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocomb.seqcombinada = sig_diariotrechocombtran.seqcombinada "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrecho.seqaeroporig = aeroporigtrecho.seqaeroporto "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocomb.seqaeropdest = aeropdestcomb.seqaeroporto "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocombtran.seqaeropdest = aeropdesttran.seqaeroporto "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariovoo.dtoper = '" & strAnoOper & "-" & strMesOper & "-" & strDiaOper & "' "
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocombtran.nrvoo = " & intNrVoo
	strQueryConexoesInbound = strQueryConexoesInbound & "   AND sig_diariotrechocombtran.seqaeropdest = " & intSeqAeropDest
	strQueryConexoesInbound = strQueryConexoesInbound & " ORDER BY sig_diariovoo.dtoper, sig_diariovoo.nrvoo, origembarque, conexao, destino "

	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim objRsConexoesInbound
	Set objRsConexoesInbound = Server.CreateObject("ADODB.Recordset")
	objRsConexoesInbound.Open strQueryConexoesInbound, objConn

	Dim Cor1, Cor2, Cor, intContador
	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	Dim ll_DtOper, ll_NrVoo, ll_OrigEmbarque, ll_Conexao, ll_Destino
	Dim ll_PaxaAdt, ll_PaxChd, ll_PaxInf, ll_PaxPago, ll_PaxPad
	Dim ll_BagLivre, ll_BagExcesso, ll_CargaPaga, ll_CargaGratis

	Do While Not objRsConexoesInbound.Eof
		if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
		end if

		ll_DtOper = objRsConexoesInbound("dtoper")
		ll_NrVoo = objRsConexoesInbound("nrvoo")
		ll_OrigEmbarque = objRsConexoesInbound("origembarque")
		ll_Conexao = objRsConexoesInbound("conexao")
		ll_Destino = objRsConexoesInbound("destino")
		ll_PaxaAdt = objRsConexoesInbound("paxadt")
		ll_PaxChd = objRsConexoesInbound("paxchd")
		ll_PaxInf = objRsConexoesInbound("paxinf")
		ll_PaxPago = objRsConexoesInbound("paxpago")
		ll_PaxPad = objRsConexoesInbound("paxpad")
		ll_BagLivre = objRsConexoesInbound("baglivre")
		ll_BagExcesso = objRsConexoesInbound("bagexcesso")
		ll_CargaPaga = objRsConexoesInbound("cargapaga")
		ll_CargaGratis = objRsConexoesInbound("cargagratis")

		if (not IsVazio(ll_DtOper)) then
			ll_DtOper = CDate(ll_DtOper)
		else
			ll_DtOper = " "
		end if
		if (not IsVazio(ll_NrVoo)) then
			ll_NrVoo = CInt(ll_NrVoo)
		else
			ll_NrVoo = " "
		end if
		if (not IsVazio(ll_OrigEmbarque)) then
			ll_OrigEmbarque = CStr(ll_OrigEmbarque)
		else
			ll_OrigEmbarque = " "
		end if
		if (not IsVazio(ll_Conexao)) then
			ll_Conexao = CStr(ll_Conexao)
		else
			ll_Conexao = " "
		end if
		if (not IsVazio(ll_Destino)) then
			ll_Destino = CStr(ll_Destino)
		else
			ll_Destino = " "
		end if
		if (not IsVazio(ll_PaxaAdt)) then
			ll_PaxaAdt = CInt(ll_PaxaAdt)
		else
			ll_PaxaAdt = " "
		end if
		if (not IsVazio(ll_PaxChd)) then
			ll_PaxChd = CInt(ll_PaxChd)
		else
			ll_PaxChd = " "
		end if
		if (not IsVazio(ll_PaxInf)) then
			ll_PaxInf = CInt(ll_PaxInf)
		else
			ll_PaxInf = " "
		end if
		if (not IsVazio(ll_PaxPago)) then
			ll_PaxPago = CInt(ll_PaxPago)
		else
			ll_PaxPago = " "
		end if
		if (not IsVazio(ll_PaxPad)) then
			ll_PaxPad = CInt(ll_PaxPad)
		else
			ll_PaxPad = " "
		end if
		if (not IsVazio(ll_BagLivre)) then
			ll_BagLivre = CInt(ll_BagLivre)
		else
			ll_BagLivre = " "
		end if
		if (not IsVazio(ll_BagExcesso)) then
			ll_BagExcesso = CInt(ll_BagExcesso)
		else
			ll_BagExcesso = " "
		end if
		if (not IsVazio(ll_CargaPaga)) then
			ll_CargaPaga = CInt(ll_CargaPaga)
		else
			ll_CargaPaga = " "
		end if
		if (not IsVazio(ll_CargaGratis)) then
			ll_CargaGratis = CInt(ll_CargaGratis)
		else
			ll_CargaGratis = " "
		end if

		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_NrVoo & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_DtOper & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_OrigEmbarque & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_Conexao & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_Destino & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxaAdt & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxChd & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxInf & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxPago & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PaxPad & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_BagLivre & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_BagExcesso & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaPaga & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaGratis & "&nbsp;</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		objRsConexoesInbound.movenext
	loop

	objRsConexoesInbound.Close
	objConn.Close
	Set objRsConexoesInbound = Nothing
	Set objConn = Nothing

end sub



function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		isVazio = true
	else
		isVazio = false
	end if

end function

%>
