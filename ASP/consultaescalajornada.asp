<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%	Response.Expires = 0 %>
<%	Response.Buffer = true %>
<!--#include file="verificalogintripulante.asp"-->
<!--#include file="libgeral.asp"-->
<%
  Dim objConn
  Dim objRsJornada, strQueryJornada, strSqlSelectJornada, strSqlFromJornada, strSqlWhereJornada, strSqlOrderJornada
  Dim objRsFuncao, strQueryFuncao, strSqlSelectFuncao, strSqlFromFuncao, strSqlWhereFuncao, strSqlOrderFuncao
  Dim intMes, intAno, intAnoAtual, blnFazConsulta, intTripulante, intContador, strFuncao
  Dim strAnoIni, strMesIni, strDiaIni, strAnoFim, strMesFim, strDiaFim
  Dim strTxtinicio, strTxtFim, strFlgEstado

  strFlgEstado = Request.QueryString("flgestado")

  blnFazConsulta = true

  intAnoAtual = Year(Now())
  intMes = CInt(Request.Form ("ddl_Mes"))
  intAno = CInt(Request.Form ("ddl_Ano"))
  intTripulante = Session("member")

  if intMes = 0 then
    blnFazConsulta = false
  end if

  strAnoIni = Cstr(Request.Form ("ddl_Ano"))
  strMesIni = CStr(Request.Form ("ddl_Mes"))
  strDiaIni = "01"
  strAnoFim = CStr(Request.Form ("ddl_Ano"))
  strMesFim = CStr(Request.Form ("ddl_Mes"))
  if intMes = 1 or intMes = 3 or intMes = 5 or intMes = 7 or intMes = 8 or intMes = 10 or intMes = 12 then
  	strDiaFim = "31"
  elseif intMes = 4 or intMes = 6 or intMes = 9 or intMes = 11 then
  	strDiaFim = "30"
  elseif intMes = 2 then
  	strDiaFim = "28"
  end if
  strTxtInicio = strAnoIni & "-" & strMesIni & "-" & strDiaIni
  strTxtFim = strAnoFim & "-" & strMesFim & "-" & strDiaFim

  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"

  strSqlSelectJornada = " SELECT "
  strSqlSelectJornada = strSqlSelectJornada & " TRIP.seqtripulante, "
  strSqlSelectJornada = strSqlSelectJornada & " TRIP.nomeguerra, "
  strSqlSelectJornada = strSqlSelectJornada & " TRIP.nome, "
  strSqlSelectJornada = strSqlSelectJornada & " TRIP.matricula, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.seqjornada, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.dtjornada, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.textojornada, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.textojornadaaux, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.kmsav, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.kmres, "
  strSqlSelectJornada = strSqlSelectJornada & " JORN.kmvoo, "
  strSqlSelectJornada = strSqlSelectJornada & " CONVERT(char(12), JORN.dtjornada, 103) AS data, "
  strSqlSelectJornada = strSqlSelectJornada & " DATEPART( dw, JORN.dtjornada) AS diasemana, "
  strSqlSelectJornada = strSqlSelectJornada & " DAY(JORN.dtjornada) AS dia "
  strSqlFromJornada = " FROM "
  strSqlFromJornada = strSqlFromJornada & " sig_jornada AS JORN, "
  strSqlFromJornada = strSqlFromJornada & " sig_tripulante AS TRIP "
  strSqlWhereJornada = " WHERE "
  strSqlWhereJornada = strSqlWhereJornada & "         TRIP.seqtripulante = JORN.seqtripulante "
  if strFlgEstado = "P" then
	strSqlWhereJornada = strSqlWhereJornada & "   AND   JORN.flgestado = 'P' "
  else
	strSqlWhereJornada = strSqlWhereJornada & "   AND   JORN.flgcorrente = 'S' AND JORN.flgestado <> 'N' "
  end if
  strSqlWhereJornada = strSqlWhereJornada & "   AND   TRIP.seqtripulante = " & intTripulante
  strSqlWhereJornada = strSqlWhereJornada & " AND  JORN.dtjornada BETWEEN '" & strTxtInicio & "' AND '" & strTxtFim & "' "
  strSqlOrderJornada = " ORDER BY "
  strSqlOrderJornada = strSqlOrderJornada & " JORN.dtjornada "

  strQueryJornada = strSqlSelectJornada & strSqlFromJornada & strSqlWhereJornada & strSqlOrderJornada

  strSqlSelectFuncao = " SELECT "
  strSqlSelectFuncao = strSqlSelectFuncao & " seqtripulante, codfuncaotrip, dtinicio, dtfim "
  strSqlFromFuncao = " FROM "
  strSqlFromFuncao = strSqlFromFuncao & " sig_tripfuncaotrip "
  strSqlWhereFuncao = " WHERE "
  strSqlWhereFuncao = strSqlWhereFuncao & " seqtripulante = " & intTripulante
  strSqlWhereFuncao = strSqlWhereFuncao & " AND  dtinicio = '" & strTxtInicio & "' "
  strSqlOrderFuncao = " ORDER BY "
  strSqlOrderFuncao = strSqlOrderFuncao & " dtinicio "

  strQueryFuncao = strSqlSelectFuncao & strSqlFromFuncao & strSqlWhereFuncao & strSqlOrderFuncao

  strFuncao = ""
  If blnFazConsulta Then
    Set objRsJornada = Server.CreateObject("ADODB.Recordset")
    objRsJornada.Open strQueryJornada, objConn
    Set objRsFuncao = Server.CreateObject("ADODB.Recordset")
    objRsFuncao.Open strQueryFuncao, objConn

    Do While (Not objRsFuncao.EOF)
		if (strFuncao <> "") then
			strFuncao = strFuncao & ", "
		end if
		strFuncao = strFuncao & Trim(objRsFuncao("codfuncaotrip"))
		objRsFuncao.MoveNext
    Loop
    objRsFuncao.Close
    Set objRsFuncao = Nothing

  End If

Response.Write(vbCrLf)
Response.Write("<html>" & vbCrLf)

Response.Write("<head>" & vbCrLf)
Response.Write("	<title>Escala Individual de Tripulantes</title>" & vbCrLf)
Response.Write("<link rel='shortcut icon' href='imagens/favicon.ico'>")
Response.Write("	<script src=""javascript.js""></script>" & vbCrLf)
Response.Write("</head>" & vbCrLf)

Response.Write("<body>" & vbCrLf)
Response.Write("<center>" & vbCrLf)
Response.Write("	<table width='98%' border='0' cellpadding='0' cellspacing='0' ID='Table1'>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO12' align='left' valign='top' width='25%'>" & vbCrLf)
Response.Write("			<img src='imagens/logo_empresa.gif' border='0'></a>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("		<td class='CORPO12' align='center' width='50%'>" & vbCrLf)
Response.Write("			<b>" & vbCrLf)
if strFlgEstado = "P" then
	Response.Write("		Escala Individual Planejada (Horário Oficial do Brasil)<br />" & vbCrLf)
else
	Response.Write("		Escala Individual Executada (Horário Oficial do Brasil)<br />" & vbCrLf)
end if
if blnFazConsulta then
	Response.Write(				fnMesPorExtenso(intMes) & " de " & intAno & vbCrLf)
end if
Response.Write("			</b>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("		<td class='CORPO12' align='right' valign='top' width='25%'>" & vbCrLf)
Response.Write("			&nbsp;" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO10' align='left' valign='bottom' width='100%' colspan='3'>" & vbCrLf)
Response.Write("			<b>Tripulante: </b>" & Session("login"))
if (strFuncao <> "") then
	Response.Write(" (" & strFuncao & ")")
end if
Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	</table>" & vbCrLf)
Response.Write("	<table width='98%'>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO10'>" & vbCrLf)
Response.Write("			<form method='post' action='consultaescalajornada.asp?flgestado=" & strFlgEstado & "'>" & vbCrLf)
Response.Write("			<div>" & vbCrLf)
Response.Write("				<label>Mês:&nbsp;</label>" & vbCrLf)
Response.Write("				<select class='CORPO10' name='ddl_Mes' id='ddl_Mes' tabindex='1'>" & vbCrLf)
if intMes = 1 then 
	Response.Write("					<option value='1' selected>Janeiro</option>" & vbCrLf)
else
	Response.Write("					<option value='1'>Janeiro</option>" & vbCrLf)
end if
if intMes = 2 then 
	Response.Write("					<option value='2' selected>Fevereiro</option>" & vbCrLf)
else
	Response.Write("					<option value='2'>Fevereiro</option>" & vbCrLf)
end if
if intMes = 3 then 
	Response.Write("					<option value='3' selected>Março</option>" & vbCrLf)
else
	Response.Write("					<option value='3'>Março</option>" & vbCrLf)
end if
if intMes = 4 then 
	Response.Write("					<option value='4' selected>Abril</option>" & vbCrLf)
else
	Response.Write("					<option value='4'>Abril</option>" & vbCrLf)
end if
if intMes = 5 then 
	Response.Write("					<option value='5' selected>Maio</option>" & vbCrLf)
else
	Response.Write("					<option value='5'>Maio</option>" & vbCrLf)
end if
if intMes = 6 then 
	Response.Write("					<option value='6' selected>Junho</option>" & vbCrLf)
else
	Response.Write("					<option value='6'>Junho</option>" & vbCrLf)
end if
if intMes = 7 then 
	Response.Write("					<option value='7' selected>Julho</option>" & vbCrLf)
else
	Response.Write("					<option value='7'>Julho</option>" & vbCrLf)
end if
if intMes = 8 then 
	Response.Write("					<option value='8' selected>Agosto</option>" & vbCrLf)
else
	Response.Write("					<option value='8'>Agosto</option>" & vbCrLf)
end if
if intMes = 9 then 
	Response.Write("					<option value='9' selected>Setembro</option>" & vbCrLf)
else
	Response.Write("					<option value='9'>Setembro</option>" & vbCrLf)
end if
if intMes = 10 then 
	Response.Write("					<option value='10' selected>Outubro</option>" & vbCrLf)
else
	Response.Write("					<option value='10'>Outubro</option>" & vbCrLf)
end if
if intMes = 11 then 
	Response.Write("					<option value='11' selected>Novembro</option>" & vbCrLf)
else
	Response.Write("					<option value='11'>Novembro</option>" & vbCrLf)
end if
if intMes = 12 then 
	Response.Write("					<option value='12' selected>Dezembro</option>" & vbCrLf)
else
	Response.Write("					<option value='12'>Dezembro</option>" & vbCrLf)
end if
Response.Write("				</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf)

Response.Write("				<label>Ano:&nbsp;</label>" & vbCrLf)
Response.Write("				<select class='CORPO10' name='ddl_Ano' id='ddl_Ano' tabindex='2'>" & vbCrLf)
for intContador = intAnoAtual - 1 To intAnoAtual + 1
	if (intAnoAtual = intContador) then 
		Response.Write("					<option value='" & intContador & "' selected>" & intContador & "</option>" & vbCrLf)
	else
		Response.Write("					<option value='" & intContador & "'>" & intContador & "</option>" & vbCrLf)
	end if
next
Response.Write("				</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf)
Response.Write("				<input type='submit' name='submit' value='Pesquisar' tabindex='3'>" & vbCrLf)
Response.Write("			</div>" & vbCrLf)
Response.Write("			</form>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("		<td align='right' valign='middle'>" & vbCrLf)
Response.Write("			<a href='~/TRIPULANTES/Home.aspx' class='link' style='font-size: 14 px'>Página Inicial</a>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	</table>" & vbCrLf)
Response.Write("  <table width='98%' border='1' cellpadding='0' cellspacing='0' ID='Table2'>" & vbCrLf)
Response.Write("    <tr bgcolor='#AAAAAA'>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2'>Dia</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2'>Semana</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2'>Programação</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2'>ETD - ETA</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' colspan='4'>Quilometragem</th>" & vbCrLf)
Response.Write("    </tr>" & vbCrLf)
Response.Write("    <tr bgcolor='#AAAAAA'>" & vbCrLf)
Response.Write("      <th class='CORPO8'>Sav</th>" & vbCrLf)
Response.Write("      <th class='CORPO8'>Res</th>" & vbCrLf)
Response.Write("      <th class='CORPO8'>Voo</th>" & vbCrLf)
Response.Write("      <th class='CORPO8'>Total</th>" & vbCrLf)
Response.Write("    </tr>" & vbCrLf)


  Dim Cor1, Cor2, Cor, intDiaSemana, strDiaSemana
  Dim blnFezConsultaJornada
  blnFezConsultaJornada = CBool(False)

  Cor1 = "#FFFFFF"
  Cor2 = "#EEEEEE"

  If blnFazConsulta Then
	blnFezConsultaJornada = CBool(True)

	Dim intQtdDiasMes

	Dim  intDiaProgramacao, intUltimoDiaProg, strObsProgramacao, strObservacao, strDataObs
	intUltimoDiaProg = CInt(0)

	intQtdDiasMes = fnQtdDiasMes(intMes, intAno)
	Dim intTotKmSav, intTotKmRes, intTotKmVoo, intTotTotal
	intTotKmSav = CInt(0)
	intTotKmRes = CInt(0)
	intTotKmVoo = CInt(0)
	intTotTotal = CInt(0)
	For intContador = 1 To intQtdDiasMes
		Dim intSeqJornada, intDiaJornada, strEtapas
		Dim strData, strTextoJornada, strTextoJornadaAux, intKmSav, intKmRes, intKmVoo, intTotal
		Dim strOrigem1, strOrigem2, strDestino1, strDestino2, strNumVoo1, strNumVoo2
		Dim strPartidaPrev, strChegadaPrev

		intSeqJornada = CInt(0)
		strObsProgramacao = ""
		strData = ""
		strDiaSemana = ""
		strTextoJornada = ""
		strTextoJornadaAux = ""
		strEtapas = ""
		intKmSav = CInt(0)
		intKmRes = CInt(0)
		intKmVoo = CInt(0)
		intTotal = CInt(0)
		strPartidaPrev = ""
		strChegadaPrev = ""

		If (Not objRsJornada.Eof) Then
			intSeqJornada = objRsJornada("seqjornada")
			intDiaJornada = objRsJornada("dia")
			If IsNumeric(intDiaJornada) Then
				intDiaJornada = CInt(intDiaJornada)
				If (intContador = intDiaJornada) Then
					intDiaSemana = objRsJornada("diasemana")
					If IsNumeric(intDiaSemana) Then
						intDiaSemana = CInt(intDiaSemana)
						strDiaSemana = fnDiaSemanaAbrev(intDiaSemana)
					End If
					strData = CStr(objRsJornada("data"))
					
					strTextoJornada = objRsJornada("textojornada")
					if (IsNull(strTextoJornada) or IsEmpty(strTextoJornada)) then strTextoJornada = ""
					strTextoJornada = CStr(strTextoJornada)
					
					strTextoJornadaAux = objRsJornada("textojornadaaux")
					if (IsNull(strTextoJornadaAux) or IsEmpty(strTextoJornadaAux)) then strTextoJornadaAux = ""
					strTextoJornadaAux = CStr(strTextoJornadaAux)
					
					intKmSav = objRsJornada("kmsav")
					intKmRes = objRsJornada("kmres")
					intKmVoo = objRsJornada("kmvoo")
					intTotal = CInt(0)
					intKmSav = CInt(intKmSav)
					intKmRes = CInt(intKmRes)
					intKmVoo = CInt(intKmVoo)
					intTotal = CInt(intKmSav) + CInt(intKmRes) + CInt(intKmVoo)
					strEtapas = ""
					strOrigem1 = ""
					strOrigem2 = ""
					strDestino1 = ""
					strDestino2 = ""
					strNumVoo1 = ""
					strNumVoo2 = ""
					objRsJornada.movenext
				End If
			End If
		End If

		If ((intContador Mod 2) = 0) Then
			Cor = Cor2
		Else
			Cor = Cor1
		End If
		strData = CDate(intAno & "-" & intMes & "-" & intContador)
		strDiaSemana = fnDiaSemanaAbrev(Weekday(strData))

Response.Write("			<tr bgcolor='" & Cor & "'>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
if (intContador < 10) then Response.Write("0")
Response.Write(						CStr(strData) & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(						strDiaSemana & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write("					<a href='consultaescalaprogramacao.asp?seqjornada=" & intSeqJornada & "'>" & vbCrLf)
Response.Write(						strTextoJornada & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(						strTextoJornadaAux & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='right' width='6%'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intKmSav & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='right' width='6%'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intKmRes & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='right' width='6%'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intKmVoo & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7' nowrap align='right' width='6%'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intTotal & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("			</tr>" & vbCrLf)

		intTotKmSav = CLng(intTotKmSav) + CLng(intKmSav)
		intTotKmRes = CLng(intTotKmRes) + CLng(intKmRes)
		intTotKmVoo = CLng(intTotKmVoo) + CLng(intKmVoo)
		intTotTotal = CLng(intTotTotal) + CLng(intTotal)

	Next

Response.Write("			<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
Response.Write("				<td class='CORPO7Bold' nowrap align='right' colspan='4'>TOTAL&nbsp;&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intTotKmSav & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intTotKmRes & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intTotKmVoo & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("				<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & vbCrLf)
Response.Write(						intTotTotal & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("			</tr>" & vbCrLf)



Response.Write("			<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
Response.Write("				<td class='CORPO6' align='left' colspan='9'>&nbsp;Observações:&nbsp;" & vbCrLf)
Response.Write(						strObservacao & vbCrLf)
Response.Write("				&nbsp;</td>" & vbCrLf)
Response.Write("			</tr>" & vbCrLf)


	objRsJornada.Close
  End If

  objConn.close
  Set objRsJornada = Nothing
  Set objConn = Nothing

Response.Write("    <tr>" & vbCrLf)
Response.Write("      <th colspan='9'></th>" & vbCrLf)
Response.Write("    </tr>" & vbCrLf)
Response.Write("  </table>" & vbCrLf)
Response.Write("</center>" & vbCrLf)
Response.Write("</body>" & vbCrLf)
Response.Write("</html>" & vbCrLf)

%>
