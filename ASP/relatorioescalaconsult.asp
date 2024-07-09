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
Dim intMes, intAno, intAnoAtual, intMesAtual, blnFazConsulta, intTripulante, intContador, strFuncao
Dim intMesSelecionado, intAnoSelecionado
Dim strFlgEstado, intDiaAvisado
Dim intEmpresa

strFlgEstado = Request.QueryString("flgestado")
intDiaAvisado = Request.QueryString("diaavisado")

blnFazConsulta = true
intAnoAtual = Year(Now())
intMesAtual = Month(Now())
intMes = CInt(Request.Form ("ddl_Mes"))
intAno = CInt(Request.Form ("ddl_Ano"))
intTripulante = Session("member")
intEmpresa = Session("Empresa")

if ((strFlgEstado = "P") and (intEmpresa <> "1") and (intEmpresa <> "2") and (intEmpresa <> "12") and (intEmpresa <> "13") and (intEmpresa <> "10") and (intEmpresa <> "5") and (intEmpresa <> "14")) then
	Response.Redirect "Default.asp"
end if

Dim strRdoKmHr
strRdoKmHr = Request.Form("rdoKmHr")
if (strRdoKmHr = "") then
    strRdoKmHr = Request.QueryString("rdoKmHr")
end if

if ((intMes > 0) and (intAno > 0)) then
	intMesSelecionado = intMes
	intAnoSelecionado = intAno
else
	intMesSelecionado = intMesAtual
	intAnoSelecionado = intAnoAtual
end if

if intDiaAvisado > 0 then
  	intMes = Request.QueryString("mes")
  	intAno = Request.QueryString("ano")
	Response.Write("<script language='javascript'>alert('Tripulante avisado em " & Now() & "!');</script>")

	Dim objConexaoSql, objRecordSetSql
	Dim strUpdate, strDataJornada
	set objConexaoSql = Server.CreateObject ("ADODB.Connection")
	objConexaoSql.Open (StringConexaoSqlServerUpdateEncriptado)
	objConexaoSql.Execute "SET DATEFORMAT ymd"

	strDataJornada = intAno & "-" & intMes & "-" & intdiaAvisado

	strUpdate =             " UPDATE sig_jornada "
	strUpdate = strUpdate & "    SET flgestado = 'V', "
	strUpdate = strUpdate & "        nomeavisado = (SELECT sig_tripulante.nomeguerra FROM sig_tripulante WHERE sig_tripulante.seqtripulante = sig_jornada.seqtripulante), "
	strUpdate = strUpdate & "        dthravisado = getdate() "
	strUpdate = strUpdate & "  WHERE seqtripulante = " & intTripulante & " "
	strUpdate = strUpdate & "    AND dtjornada = " & Plic(strDataJornada) & " "
	strUpdate = strUpdate & "    AND flgcorrente = 'S' "
	strUpdate = strUpdate & "    AND flgestado = 'A' "
'	response.write("strUpdate: " & strUpdate)

	set objRecordSetSql = objConexaoSql.Execute(strUpdate)

	objConexaoSql.Close
	set objRecordSetSql = nothing
	set objConexaoSql = nothing
end if

Set objConn = CreateObject("ADODB.CONNECTION")
objConn.Open (StringConexaoSqlServer)
objConn.Execute "SET DATEFORMAT ymd"

strSqlSelectJornada = " SELECT "
strSqlSelectJornada = strSqlSelectJornada & " TRIP.seqtripulante, TRIP.nomeguerra, TRIP.nome, TRIP.matricula, "
strSqlSelectJornada = strSqlSelectJornada & " JORN.dtjornada, JORN.textojornada, JORN.textojornadaaux, JORN.flgestado, "
strSqlSelectJornada = strSqlSelectJornada & " JORN.seqjornada, JORN.kmsav, JORN.kmres, JORN.kmvoo, "
strSqlSelectJornada = strSqlSelectJornada & " CONVERT(char(5), JORN.dthrapresentacao, 8) AS dthrapresentacaoFormatada, "
strSqlSelectJornada = strSqlSelectJornada & " DAY(JORN.dthrapresentacao) AS diaApresentacao, "
strSqlSelectJornada = strSqlSelectJornada & " MONTH(JORN.dthrapresentacao) AS mesApresentacao, "
strSqlSelectJornada = strSqlSelectJornada & " YEAR(JORN.dthrapresentacao) AS anoApresentacao, "
strSqlSelectJornada = strSqlSelectJornada & " CONVERT(char(12), JORN.dtjornada, 103) AS data, "
strSqlSelectJornada = strSqlSelectJornada & " DATEPART( dw, JORN.dtjornada) AS diasemana, "
strSqlSelectJornada = strSqlSelectJornada & " DAY(JORN.dtjornada) AS dia, "
strSqlSelectJornada = strSqlSelectJornada & " MONTH(JORN.dtjornada) AS mes, "
strSqlSelectJornada = strSqlSelectJornada & " YEAR(JORN.dtjornada) AS ano "
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
if intMes > 0 then
    strSqlWhereJornada = strSqlWhereJornada & " AND  MONTH(JORN.dtjornada) = " & intMes
else
    blnFazConsulta = false
end if
if intAno > 0 then
    strSqlWhereJornada = strSqlWhereJornada & " AND  YEAR(JORN.dtjornada) = " & intAno
else
    blnFazConsulta = false
end if
strSqlOrderJornada = " ORDER BY "
strSqlOrderJornada = strSqlOrderJornada & " JORN.dtjornada ASC, JORN.seqjornada DESC "

strQueryJornada = strSqlSelectJornada & strSqlFromJornada & strSqlWhereJornada & strSqlOrderJornada

strSqlSelectFuncao = " SELECT "
strSqlSelectFuncao = strSqlSelectFuncao & " seqtripulante, codfuncaotrip, dtinicio, dtfim "
strSqlFromFuncao = " FROM "
strSqlFromFuncao = strSqlFromFuncao & " sig_tripfuncaotrip "
strSqlWhereFuncao = " WHERE "
strSqlWhereFuncao = strSqlWhereFuncao & " seqtripulante = " & intTripulante
if intMes > 0 then
    strSqlWhereFuncao = strSqlWhereFuncao & " AND  MONTH(dtinicio) = " & intMes
end if
if intAno > 0 then
    strSqlWhereFuncao = strSqlWhereFuncao & " AND  YEAR(dtinicio) = " & intAno
end if
strSqlOrderFuncao = " ORDER BY "
strSqlOrderFuncao = strSqlOrderFuncao & " dtinicio "

strQueryFuncao = strSqlSelectFuncao & strSqlFromFuncao & strSqlWhereFuncao & strSqlOrderFuncao

if intDiaAvisado > 0 then
    blnFazConsulta = CBool(True)
end if

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
Response.Write("<meta http-equiv='Page-Exit' content='blendTrans(Duration=1)'>")
Response.Write("	<script src=""javascript.js""></script>" & vbCrLf)
Response.Write("</head>" & vbCrLf)

Response.Write("<body>" & vbCrLf)
Response.Write("<center>" & vbCrLf)
Response.Write("	<table width='100%' border='0' cellpadding='0' cellspacing='0' ID='Table1'>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO12' align='left' valign='top' width='25%'>" & vbCrLf)
Response.Write("			<img src='imagens/logo_empresa.gif' border='0'>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("		<td class='CORPO12' align='center' width='50%'>" & vbCrLf)
Response.Write("			<b>" & vbCrLf)
if strFlgEstado = "P" then
	Response.Write("		Escala Individual Planejada (Hor&#225;rio de Bras&#237;lia)<br />" & vbCrLf)
else
	Response.Write("		Escala Individual Executada (Hor&#225;rio de Bras&#237;lia)<br />" & vbCrLf)
end if
if blnFazConsulta then
	Response.Write(				fnMesPorExtenso(intMes) & " de " & intAno & vbCrLf)
end if
Response.Write("			</b>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
Response.Write("		<td class='corpo' align='right' valign='top' width='35%'>" & vbCrLf)
REsponse.Write("			<a href='http://www.latop.com.br'><img src='imagens/sigla.gif' border='0'></a>" & vbCrLf) 
Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("	   <td></td>" & vbCrLf)
Response.Write("	   <td></td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("    	<td colspan='3'>" & vbCrLf)
%>
								<!--#include file="Menu.asp"--> 
<%         
Response.Write("     </td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	</table>" & vbCrLf)
Response.Write("<br>" & vbCrLf)
Response.Write("	<table width='98%'>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO10' align='left' valign='bottom' width='100%' colspan='3'>" & vbCrLf)
Response.Write("			<b>Tripulante: </b>" & Session("login"))
if (strFuncao <> "") then
	Response.Write(" (" & strFuncao & ")")
end if
Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	<tr>" & vbCrLf)
Response.Write("		<td class='CORPO10'>" & vbCrLf)
Response.Write("			<form method='post' action='relatorioescalaconsult.asp?flgestado=" & strFlgEstado & "'>" & vbCrLf)
Response.Write("			<div>" & vbCrLf)
Response.Write("				<label>M&#234;s:&nbsp;</label>" & vbCrLf)
Response.Write("				<select class='CORPO10' name='ddl_Mes' id='ddl_Mes' tabindex='1'>" & vbCrLf)
if intMesSelecionado = 1 then 
	Response.Write("					<option value='1' selected>Janeiro</option>" & vbCrLf)
else
	Response.Write("					<option value='1'>Janeiro</option>" & vbCrLf)
end if
if intMesSelecionado = 2 then 
	Response.Write("					<option value='2' selected>Fevereiro</option>" & vbCrLf)
else
	Response.Write("					<option value='2'>Fevereiro</option>" & vbCrLf)
end if
if intMesSelecionado = 3 then 
	Response.Write("					<option value='3' selected>Mar&#231;o</option>" & vbCrLf)
else
	Response.Write("					<option value='3'>Mar&#231;o</option>" & vbCrLf)
end if
if intMesSelecionado = 4 then 
	Response.Write("					<option value='4' selected>Abril</option>" & vbCrLf)
else
	Response.Write("					<option value='4'>Abril</option>" & vbCrLf)
end if
if intMesSelecionado = 5 then 
	Response.Write("					<option value='5' selected>Maio</option>" & vbCrLf)
else
	Response.Write("					<option value='5'>Maio</option>" & vbCrLf)
end if
if intMesSelecionado = 6 then 
	Response.Write("					<option value='6' selected>Junho</option>" & vbCrLf)
else
	Response.Write("					<option value='6'>Junho</option>" & vbCrLf)
end if
if intMesSelecionado = 7 then 
	Response.Write("					<option value='7' selected>Julho</option>" & vbCrLf)
else
	Response.Write("					<option value='7'>Julho</option>" & vbCrLf)
end if
if intMesSelecionado = 8 then
	Response.Write("					<option value='8' selected>Agosto</option>" & vbCrLf)
else
	Response.Write("					<option value='8'>Agosto</option>" & vbCrLf)
end if
if intMesSelecionado = 9 then 
	Response.Write("					<option value='9' selected>Setembro</option>" & vbCrLf)
else
	Response.Write("					<option value='9'>Setembro</option>" & vbCrLf)
end if
if intMesSelecionado = 10 then 
	Response.Write("					<option value='10' selected>Outubro</option>" & vbCrLf)
else
	Response.Write("					<option value='10'>Outubro</option>" & vbCrLf)
end if
if intMesSelecionado = 11 then 
	Response.Write("					<option value='11' selected>Novembro</option>" & vbCrLf)
else
	Response.Write("					<option value='11'>Novembro</option>" & vbCrLf)
end if
if intMesSelecionado = 12 then 
	Response.Write("					<option value='12' selected>Dezembro</option>" & vbCrLf)
else
	Response.Write("					<option value='12'>Dezembro</option>" & vbCrLf)
end if
Response.Write("				</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf)

Response.Write("				<label>Ano:&nbsp;</label>" & vbCrLf)
Response.Write("				<select class='CORPO10' name='ddl_Ano' id='ddl_Ano' tabindex='2'>" & vbCrLf)

for intContador = 2005 To intAnoAtual + 1
	if (intAnoSelecionado = intContador) then 
		Response.Write("					<option value='" & intContador & "' selected>" & intContador & "</option>" & vbCrLf)
	else
		Response.Write("					<option value='" & intContador & "'>" & intContador & "</option>" & vbCrLf)
	end if
next
Response.Write("				</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf)

if Session("Empresa") = "14" Then 'Sideral
    if (strRdoKmHr = "Hr") then
	    Response.Write("				<input type='radio' id='rdoHr' name='rdoKmHr' checked='checked' value='Hr' /><label for='rdoHr'>Horas de Voo</label>" & vbCrLf)
    else
	    Response.Write("				<input type='radio' id='rdoHr' name='rdoKmHr' checked='checked' value='Hr' /><label for='rdoHr'>Horas de Voo</label>" & vbCrLf)
    end if
else
    if (strRdoKmHr = "Hr") then
	    Response.Write("				<input type='radio' id='rdoKm' name='rdoKmHr' value='Km' /><label for='rdoKm'>Quilometragem</label>" & vbCrLf)
	    Response.Write("				<input type='radio' id='rdoHr' name='rdoKmHr' checked='checked' value='Hr' /><label for='rdoHr'>Horas de Voo</label>" & vbCrLf)
    else
	    Response.Write("				<input type='radio' id='rdoKm' name='rdoKmHr' checked='checked' value='Km' /><label for='rdoKm'>Quilometragem</label>" & vbCrLf)
	    Response.Write("				<input type='radio' id='rdoHr' name='rdoKmHr' value='Hr' /><label for='rdoHr'>Horas de Voo</label>" & vbCrLf)
    end if
end if

Response.Write("				</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf)
Response.Write("				<input type='submit' name='submit' value='Pesquisar' tabindex='3'>" & vbCrLf)
Response.Write("			</div>" & vbCrLf)
Response.Write("			</form>" & vbCrLf)
Response.Write("		</td>" & vbCrLf)
'Response.Write("		<td align='right' valign='middle'>" & vbCrLf)
'Response.Write("			<a href='hometripulantes.asp' class='link' style='font-size: 14 px'>P&#225;gina Inicial</a>" & vbCrLf)
'Response.Write("		</td>" & vbCrLf)
Response.Write("	</tr>" & vbCrLf)
Response.Write("	</table>" & vbCrLf)

'Response.Write("Dia Avisado: " & intDiaAvisado & " / " & vbCrLf)
'Response.Write("Tripulante: " & intTripulante &  " / " & vbCrLf)
'Response.Write("M&#234;s: " & intMes &  " / " & vbCrLf)
'Response.Write("Ano: " & intAno &  "<BR>" & vbCrLf)

Response.Write("  <table width='98%' border='1' cellpadding='0' cellspacing='0' ID='Table2'>" & vbCrLf)
Response.Write("    <tr bgcolor='#AAAAAA'>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='80px'>Dia</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='60px'>Semana</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='150px'>Programa&#231;&#227;o</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='70px'>Apres.</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='85px'>ETD - ETA</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='3' width='35%'>Etapas</th>" & vbCrLf)
'if (intEmpresa = 6) then 'Varig Log
if (strRdoKmHr = "Hr") then
	if (intEmpresa = 4) then 'TRIP
		Response.Write("      <th class='CORPO8' colspan='6' width='250px'>Horas de Voo</th>" & vbCrLf)
	else
		Response.Write("      <th class='CORPO8' colspan='5' width='250px'>Horas de Voo</th>" & vbCrLf)
	end if
else
	if (intEmpresa = 4) then 'TRIP
		Response.Write("      <th class='CORPO8' colspan='6' width='250px'>Quilometragem</th>" & vbCrLf)
	else
		Response.Write("      <th class='CORPO8' colspan='5' width='250px'>Quilometragem</th>" & vbCrLf)
	end if
end if
Response.Write("    </tr>" & vbCrLf)
Response.Write("    <tr bgcolor='#AAAAAA'>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2' width='50px'>Diu.</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' rowspan='2' width='50px'>Not.</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' colspan='2' width='100px'>Especial</th>" & vbCrLf)
if (intEmpresa = 4) then 'TRIP
	Response.Write("      <th class='CORPO8' rowspan='2' width='50px'>Ativ.</th>" & vbCrLf)
end if
Response.Write("      <th class='CORPO8' rowspan='2' width='50px'>Total</th>" & vbCrLf)
Response.Write("    </tr>" & vbCrLf)
Response.Write("    <tr bgcolor='#AAAAAA'>" & vbCrLf)
Response.Write("      <th class='CORPO8' width='50px'>Diu.</th>" & vbCrLf)
Response.Write("      <th class='CORPO8' width='50px'>Not.</th>" & vbCrLf)
Response.Write("    </tr>" & vbCrLf)


Dim Cor1, Cor2, Cor, intDiaSemana, strDiaSemana
Dim blnFezConsultaJornada
blnFezConsultaJornada = CBool(False)

Cor1 = "#FFFFFF"
Cor2 = "#EEEEEE"

If blnFazConsulta Then
	blnFezConsultaJornada = CBool(True)

	Dim objRsProgramacao, strQueryProgramacao
	Dim strSqlSelectProgramacao, strSqlFromProgramacao, strSqlWhereProgramacao, strSqlOrderProgramacao
	Dim strSqlSelectProgramacao2, strSqlFromProgramacao2, strSqlWhereProgramacao2
	Dim intQtdDiasMes

	strSqlSelectProgramacao = " SELECT "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " TRIP.seqtripulante, JORN.seqjornada, JORN.dtjornada, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.seqprogramacao, PROG.flgtipo, EDV.nrvoo, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.funcao, PROG.seqaeroporig, PROG.seqaeropdest, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " EDT.partidaprev, EDT.chegadaprev, ATV.codatividade, "
'	strSqlSelectProgramacao = strSqlSelectProgramacao & " ATV.hrinicio, ATV.hrfim, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " ATV.descricao, "
	if strFlgEstado = "P" then
		strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), PROG.dthrinicio, 8) AS partidaprevFormatada, "
		strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), PROG.dthrfim, 8) AS chegadaprevFormatada, "
	else
		strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), EDT.partidaprev, 8) AS partidaprevFormatada, "
		strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), EDT.chegadaprev, 8) AS chegadaprevFormatada, "
	end if
'	strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), PROG.dthrinicio, 8) AS dthrinicio, "
'	strSqlSelectProgramacao = strSqlSelectProgramacao & " CONVERT(char(5), PROG.dthrfim, 8) AS dthrfim, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " AERORIG.codiata AS origem, AERDEST.codiata AS destino, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " DAY(JORN.dtjornada) AS dia, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " DAY(EDT.partidaprev) AS diaPartida, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " MONTH(EDT.partidaprev) AS mesPartida, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " YEAR(EDT.partidaprev) AS anoPartida, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " DAY(EDT.chegadaprev) AS diaChegada, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " MONTH(EDT.chegadaprev) AS mesChegada, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " YEAR(EDT.chegadaprev) AS anoChegada, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.observacao, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.kmdiurna, PROG.kmnoturna, PROG.kmespdiurna, PROG.kmespnoturna, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.kmdiurnaexec, PROG.kmnoturnaexec, PROG.kmespdiurnaexec, PROG.kmespnoturnaexec, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.hrdiurna, PROG.hrnoturna, PROG.hrespdiurna, PROG.hrespnoturna, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " PROG.hrdiurnaexec, PROG.hrnoturnaexec, PROG.hrespdiurnaexec, PROG.hrespnoturnaexec, "
	strSqlSelectProgramacao = strSqlSelectProgramacao & " FB.flghora "
	strSqlFromProgramacao = " FROM "
	strSqlFromProgramacao = strSqlFromProgramacao & " sig_programacao AS PROG "
	strSqlFromProgramacao = strSqlFromProgramacao & " LEFT OUTER JOIN sig_escdiariovoo AS EDV ON PROG.seqvoodiaesc = EDV.seqvoodiaesc "
	strSqlFromProgramacao = strSqlFromProgramacao & " LEFT OUTER JOIN sig_escdiariotrecho AS EDT ON PROG.seqvoodiaesc = EDT.seqvoodiaesc "
	strSqlFromProgramacao = strSqlFromProgramacao & "      AND PROG.seqaeroporig = EDT.seqaeroporig AND PROG.seqaeropdest = EDT.seqaeropdest  "
	strSqlFromProgramacao = strSqlFromProgramacao & " LEFT OUTER JOIN sig_atividade AS ATV ON PROG.seqatividade = ATV.seqatividade "
	strSqlFromProgramacao = strSqlFromProgramacao & " LEFT OUTER JOIN sig_funcaobordo AS FB ON FB.codredfuncaobordo = PROG.funcao, "
	strSqlFromProgramacao = strSqlFromProgramacao & " sig_jornada AS JORN, "
	strSqlFromProgramacao = strSqlFromProgramacao & " sig_tripulante AS TRIP, "
	strSqlFromProgramacao = strSqlFromProgramacao & " sig_aeroporto AS AERORIG, "
	strSqlFromProgramacao = strSqlFromProgramacao & " sig_aeroporto AS AERDEST "
	strSqlWhereProgramacao = " WHERE "
	strSqlWhereProgramacao = strSqlWhereProgramacao & "     TRIP.seqtripulante = JORN.seqtripulante "
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND JORN.seqjornada = PROG.seqjornada "
	if strFlgEstado = "P" then
		strSqlWhereProgramacao = strSqlWhereProgramacao & " AND JORN.flgestado = 'P' "
	else
		strSqlWhereProgramacao = strSqlWhereProgramacao & " AND JORN.flgcorrente = 'S' AND JORN.flgestado <> 'N' "
	end if
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND TRIP.seqtripulante = " & intTripulante
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND MONTH(JORN.dtjornada) = " & intMes
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND YEAR(JORN.dtjornada) = " & intAno
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND PROG.flgtipo = 'V' "
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND AERORIG.seqaeroporto = PROG.seqaeroporig "
	strSqlWhereProgramacao = strSqlWhereProgramacao & " AND AERDEST.seqaeroporto = PROG.seqaeropdest "

	strSqlSelectProgramacao2 = " SELECT "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " TRIP.seqtripulante, JORN.seqjornada, JORN.dtjornada, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.seqprogramacao, PROG.flgtipo, EDV.nrvoo, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.funcao, EDT.seqaeroporig, EDT.seqaeropdest, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " EDT.partidaprev, EDT.chegadaprev, ATV.codatividade, "
'	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " ATV.hrinicio, ATV.hrfim, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " ATV.descricao, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " CONVERT(char(5), EDT.partidaprev, 8) AS partidaprevFormatada, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " CONVERT(char(5), EDT.chegadaprev, 8) AS chegadaprevFormatada, "
'	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " CONVERT(char(5), PROG.dthrinicio, 8) AS dthrinicio, "
'	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " CONVERT(char(5), PROG.dthrfim, 8) AS dthrfim, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " '' AS origem, '' AS destino, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " DAY(JORN.dtjornada) AS dia, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " DAY(EDT.partidaprev) AS diaPartida, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " MONTH(EDT.partidaprev) AS mesPartida, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " YEAR(EDT.partidaprev) AS anoPartida, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " DAY(EDT.chegadaprev) AS diaChegada, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " MONTH(EDT.chegadaprev) AS mesChegada, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " YEAR(EDT.chegadaprev) AS anoChegada, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.observacao, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.kmdiurna, PROG.kmnoturna, PROG.kmespdiurna, PROG.kmespnoturna, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.kmdiurnaexec, PROG.kmnoturnaexec, PROG.kmespdiurnaexec, PROG.kmespnoturnaexec, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.hrdiurna, PROG.hrnoturna, PROG.hrespdiurna, PROG.hrespnoturna, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " PROG.hrdiurnaexec, PROG.hrnoturnaexec, PROG.hrespdiurnaexec, PROG.hrespnoturnaexec, "
	strSqlSelectProgramacao2 = strSqlSelectProgramacao2 & " FB.flghora "
	strSqlFromProgramacao2 = " FROM "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " sig_programacao AS PROG "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " LEFT OUTER JOIN sig_escdiariovoo AS EDV ON PROG.seqvoodiaesc = EDV.seqvoodiaesc "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " LEFT OUTER JOIN sig_escdiariotrecho AS EDT ON PROG.seqvoodiaesc = EDT.seqvoodiaesc "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & "      AND PROG.seqaeroporig = EDT.seqaeroporig AND PROG.seqaeropdest = EDT.seqaeropdest "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " LEFT OUTER JOIN sig_atividade AS ATV ON PROG.seqatividade = ATV.seqatividade "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " LEFT OUTER JOIN sig_funcaobordo AS FB ON FB.codredfuncaobordo = PROG.funcao, "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " sig_jornada AS JORN, "
	strSqlFromProgramacao2 = strSqlFromProgramacao2 & " sig_tripulante AS TRIP "
	strSqlWhereProgramacao2 = " WHERE "
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & "     TRIP.seqtripulante = JORN.seqtripulante "
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND JORN.seqjornada = PROG.seqjornada "
	if strFlgEstado = "P" then
		strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND JORN.flgestado = 'P' "
	else
		strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND JORN.flgcorrente = 'S' AND JORN.flgestado <> 'N' "
	end if
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND TRIP.seqtripulante = " & intTripulante
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND MONTH(JORN.dtjornada) = " & intMes
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND YEAR(JORN.dtjornada) = " & intAno
	strSqlWhereProgramacao2 = strSqlWhereProgramacao2 & " AND PROG.flgtipo = 'A' "

	strSqlOrderProgramacao = " ORDER BY "
	strSqlOrderProgramacao = strSqlOrderProgramacao & " JORN.dtjornada, PROG.seqprogramacao "

	strQueryProgramacao = strSqlSelectProgramacao & strSqlFromProgramacao & strSqlWhereProgramacao
	strQueryProgramacao = strQueryProgramacao & " UNION " & strSqlSelectProgramacao2 & strSqlFromProgramacao2 & strSqlWhereProgramacao2 & strSqlOrderProgramacao

	Set objRsProgramacao = Server.CreateObject("ADODB.Recordset")
	objRsProgramacao.Open strQueryProgramacao, objConn



   Dim  intDiaProgramacao, intUltimoDiaProg, strObsProgramacao, strObservacao, strDataObs
	intUltimoDiaProg = CInt(0)
	Do While (Not objRsProgramacao.EOF)
		intDiaProgramacao = objRsProgramacao("dia")
		If IsNumeric(intDiaProgramacao) Then intDiaProgramacao = CInt(intDiaProgramacao)
		strObsProgramacao = Trim(objRsProgramacao("observacao"))
		if (strObsProgramacao <> "") then
			if (intUltimoDiaProg <> intDiaProgramacao) then
				if (strObservacao <> "") then
					strObservacao = strObservacao & "&nbsp;&nbsp;&nbsp;&nbsp;"
				end if
				strObservacao = strObservacao & "("
				strDataObs = CDate(intAno & "-" & intMes & "-" & intDiaProgramacao)
				if (intDiaProgramacao < 10) then
					strObservacao = strObservacao & "0"
				end if
				strObservacao = strObservacao & CStr(strDataObs) & ")&nbsp;-&nbsp;"
			else
				strObservacao = strObservacao & "&nbsp;|&nbsp;"
			end if
			strObservacao = strObservacao & strObsProgramacao
			intUltimoDiaProg = intDiaProgramacao
		end if
		objRsProgramacao.MoveNext
	Loop
	if (Not objRsProgramacao.BOF) then
		objRsProgramacao.MoveFirst
	end if


	Dim intDiaJornada, intMesJornada, intAnoJornada, dtJornada
	Dim intDiaPartida, intMesPartida, intAnoPartida, dtPartida
	Dim intDiaChegada, intMesChegada, intAnoChegada, dtChegada
	Dim strEtapas, strFlgestadoJornada, ll_jornada
	Dim strData, strTextoJornada, strTextoJornadaAux
	Dim strHrApresentacao, intDiaApresentacao, intMesApresentacao, intAnoApresentacao, dtApresentacao
	Dim strOrigem1, strOrigem2, strDestino1, strDestino2, strNumVoo1, strNumVoo2
	Dim strPartidaPrev, strChegadaPrev
	'Dim intKmSav, intKmRes, intKmVoo, intTotal
	'Dim intTotKmSav, intTotKmRes, intTotKmVoo, intTotTotal
	'intTotKmSav = CInt(0)
	'intTotKmRes = CInt(0)
	'intTotKmVoo = CInt(0)
	'intTotTotal = CInt(0)
	Dim intDiurna, intNoturna, intEspecialDiurna, intEspecialNoturna, intAtividade, intTotalDia
	Dim intTotalDiurna, intTotalNoturna, intTotalEspecialDiurna, intTotalEspecialNoturna, intTotalAtividade, intTotalMes
	intTotalDiurna = CDbl(0)
	intTotalNoturna = CDbl(0)
	intTotalEspecialDiurna = CDbl(0)
	intTotalEspecialNoturna = CDbl(0)
	intTotalAtividade = CDbl(0)
	intTotalMes = CDbl(0)

	intQtdDiasMes = fnQtdDiasMes(intMes, intAno)
	For intContador = 1 To intQtdDiasMes
		strObsProgramacao = ""
		strData = ""
		strDiaSemana = ""
		strTextoJornada = ""
		strTextoJornadaAux = ""
		strHrApresentacao = ""
		intDiaApresentacao = ""
		intMesApresentacao = ""
		intAnoApresentacao = ""
		strEtapas = ""
		'intKmSav = CInt(0)
		'intKmRes = CInt(0)
		'intKmVoo = CInt(0)
		'intTotal = CInt(0)
	    intDiurna = CDbl(0)
	    intNoturna = CDbl(0)
	    intEspecialDiurna = CDbl(0)
	    intEspecialNoturna = CDbl(0)
	    intAtividade = CDbl(0)
	    intTotalDia = CDbl(0)
		strPartidaPrev = ""
		strChegadaPrev = ""

		If (Not objRsJornada.EOF) Then
			intDiaJornada = objRsJornada("dia")
			If (IsNumeric(intDiaJornada)) Then
				intDiaJornada = CInt(intDiaJornada)
				Do While ((Not objRsJornada.EOF) And (intDiaJornada < intContador))
					objRsJornada.MoveNext()
					intDiaJornada = objRsJornada("dia")
					If (IsNumeric(intDiaJornada)) Then intDiaJornada = CInt(intDiaJornada)
				Loop
			End If
		End If

		If (Not objRsJornada.Eof) Then
			intDiaJornada = objRsJornada("dia")
			intMesJornada = objRsJornada("mes")
			intAnoJornada = objRsJornada("ano")
			dtJornada = DateSerial(intAnoJornada, intMesJornada, intDiaJornada)

			If IsNumeric(intDiaJornada) Then
				intDiaJornada = CInt(intDiaJornada)
				If (intContador = intDiaJornada) Then
					intDiaSemana = objRsJornada("diasemana")
					If IsNumeric(intDiaSemana) Then
						intDiaSemana = CInt(intDiaSemana)
						strDiaSemana = fnDiaSemanaAbrev(intDiaSemana)
					End If
					strData = CStr(objRsJornada("data"))
					strFlgestadoJornada = CStr(objRsJornada("flgestado"))

					strTextoJornada = objRsJornada("textojornada")
					if (IsVazio(strTextoJornada)) then strTextoJornada = ""
					strTextoJornada = CStr(strTextoJornada)

					strTextoJornadaAux = objRsJornada("textojornadaaux")
					if (IsVazio(strTextoJornadaAux)) then strTextoJornadaAux = ""
					strTextoJornadaAux = CStr(strTextoJornadaAux)

					strHrApresentacao = objRsJornada("dthrapresentacaoFormatada")
					if (IsVazio(strHrApresentacao)) then
						strHrApresentacao = ""
					else
						intDiaApresentacao = objRsJornada("diaApresentacao")
						intMesApresentacao = objRsJornada("mesApresentacao")
						intAnoApresentacao = objRsJornada("anoApresentacao")
						if (Not IsVazio(intDiaApresentacao) And Not IsVazio(intMesApresentacao) And Not IsVazio(intAnoApresentacao)) then
							dtApresentacao = DateSerial(intAnoApresentacao, intMesApresentacao, intDiaApresentacao)
						else
							dtApresentacao = NULL
						end if

						' Verifica se houve mudanca de dia na apresentacão.
						if (Not IsVazio(dtApresentacao)) then
							Dim diasEntreApresentacaoJornada
							diasEntreApresentacaoJornada = DateDiff("d", dtJornada, dtApresentacao)
							If (diasEntreApresentacaoJornada > 0) Then
								strHrApresentacao = strHrApresentacao & " [+" & diasEntreApresentacaoJornada & "]"
							ElseIf (diasEntreApresentacaoJornada < 0) Then
								strHrApresentacao = strHrApresentacao & " [" & diasEntreApresentacaoJornada & "]"
							End If
						end if
					end if

					strHrApresentacao = CStr(strHrApresentacao)

					ll_jornada = objRsJornada("seqjornada")
					'intKmSav = objRsJornada("kmsav")
					'intKmRes = objRsJornada("kmres")
					'intKmVoo = objRsJornada("kmvoo")
					'intTotal = CInt(0)
					'intKmSav = CInt(intKmSav)
					'intKmRes = CInt(intKmRes)
					'intKmVoo = CInt(intKmVoo)
					'intTotal = CInt(intKmSav) + CInt(intKmRes) + CInt(intKmVoo)
					strEtapas = ""
					strOrigem1 = ""
					strOrigem2 = ""
					strDestino1 = ""
					strDestino2 = ""
					strNumVoo1 = ""
					strNumVoo2 = ""
					if (Not objRsProgramacao.Eof) then
						intDiaProgramacao = objRsProgramacao("dia")

						If IsNumeric(intDiaProgramacao) Then intDiaProgramacao = CInt(intDiaProgramacao)

						if (intDiaProgramacao = intDiaJornada)then
							Dim strDiurna, strNoturna, strEspecialDiurna, strEspecialNoturna
							strDiurna = "diurna"
							strNoturna = "noturna"
							strEspecialDiurna = "espdiurna"
							strEspecialNoturna = "espnoturna"
'							if (intEmpresa = 6) then 'Varig Log
							if (strRdoKmHr = "Hr") then
								strDiurna = "hr" & strDiurna
								strNoturna = "hr" & strNoturna
								strEspecialDiurna = "hr" & strEspecialDiurna
								strEspecialNoturna = "hr" & strEspecialNoturna
							else
								strDiurna = "km" & strDiurna
								strNoturna = "km" & strNoturna
								strEspecialDiurna = "km" & strEspecialDiurna
								strEspecialNoturna = "km" & strEspecialNoturna
							end if
							if strFlgEstado <> "P" then
								strDiurna = strDiurna & "exec"
								strNoturna = strNoturna & "exec"
								strEspecialDiurna = strEspecialDiurna & "exec"
								strEspecialNoturna = strEspecialNoturna & "exec"
							end if

							Do While ((Not objRsProgramacao.Eof) And (intDiaProgramacao = intDiaJornada))
								Dim strFlgHoraFuncaoBordo
								strFlgHoraFuncaoBordo = objRsProgramacao("flghora")
								if (IsVazio(strFlgHoraFuncaoBordo)) then strFlgHoraFuncaoBordo = ""
								strFlgHoraFuncaoBordo = UCase(strFlgHoraFuncaoBordo)

								Dim intTempDiurna, intTempNoturna, intTempEspecialDiurna, intTempEspecialNoturna, intTempAtividade
								if (intEmpresa = 4) then 'TRIP
									If ((strRdoKmHr <> "Hr") Or (CStr(objRsProgramacao("flgtipo")) = "A") Or _
										((CStr(objRsProgramacao("flgtipo")) = "V") And (strFlgHoraFuncaoBordo <> "N"))) Then
										intTempDiurna = objRsProgramacao(strDiurna)
										intTempNoturna = objRsProgramacao(strNoturna)
										intTempEspecialDiurna = objRsProgramacao(strEspecialDiurna)
										intTempEspecialNoturna = objRsProgramacao(strEspecialNoturna)
										if (IsVazio(intTempDiurna)) then
											intTempDiurna = CDbl(0)
										else
											intTempDiurna = CDbl(intTempDiurna)
										end if
										if (IsVazio(intTempNoturna)) then
											intTempNoturna = CDbl(0)
										else
											intTempNoturna = CDbl(intTempNoturna)
										end if
										if (IsVazio(intTempEspecialDiurna)) then
											intTempEspecialDiurna = CDbl(0)
										else
											intTempEspecialDiurna = CDbl(intTempEspecialDiurna)
										end if
										if (IsVazio(intTempEspecialNoturna)) then
											intTempEspecialNoturna = CDbl(0)
										else
											intTempEspecialNoturna = CDbl(intTempEspecialNoturna)
										end if

										if (CStr(objRsProgramacao("flgtipo")) = "A") then
											intAtividade = CDbl(intAtividade) + CDbl(intTempDiurna) + CDbl(intTempNoturna) + CDbl(intTempEspecialDiurna) + CDbl(intTempEspecialNoturna)
										else
											intDiurna = CDbl(intDiurna) + CDbl(intTempDiurna)
											intNoturna = CDbl(intNoturna) + CDbl(intTempNoturna)
											intEspecialDiurna = CDbl(intEspecialDiurna) + CDbl(intTempEspecialDiurna)
											intEspecialNoturna = CDbl(intEspecialNoturna) + CDbl(intTempEspecialNoturna)
										end if
									End If
								else
									If ((strRdoKmHr <> "Hr") Or _
										((CStr(objRsProgramacao("flgtipo")) = "V") And (strFlgHoraFuncaoBordo <> "N"))) Then
										intTempDiurna = objRsProgramacao(strDiurna)
										intTempNoturna = objRsProgramacao(strNoturna)
										intTempEspecialDiurna = objRsProgramacao(strEspecialDiurna)
										intTempEspecialNoturna = objRsProgramacao(strEspecialNoturna)
										if (IsVazio(intTempDiurna)) then
											intTempDiurna = CDbl(0)
										else
											intTempDiurna = CDbl(intTempDiurna)
										end if
										if (IsVazio(intTempNoturna)) then
											intTempNoturna = CDbl(0)
										else
											intTempNoturna = CDbl(intTempNoturna)
										end if
										if (IsVazio(intTempEspecialDiurna)) then
											intTempEspecialDiurna = CDbl(0)
										else
											intTempEspecialDiurna = CDbl(intTempEspecialDiurna)
										end if
										if (IsVazio(intTempEspecialNoturna)) then
											intTempEspecialNoturna = CDbl(0)
										else
											intTempEspecialNoturna = CDbl(intTempEspecialNoturna)
										end if
										intDiurna = CDbl(intDiurna) + CDbl(intTempDiurna)
										intNoturna = CDbl(intNoturna) + CDbl(intTempNoturna)
										intEspecialDiurna = CDbl(intEspecialDiurna) + CDbl(intTempEspecialDiurna)
										intEspecialNoturna = CDbl(intEspecialNoturna) + CDbl(intTempEspecialNoturna)
									End If
								end if

								If (CStr(objRsProgramacao("flgtipo")) = "V") Then
									strNumVoo2 = objRsProgramacao("nrvoo")
									if (IsVazio(strNumVoo2)) then strNumVoo2 = ""
									strNumVoo2 = CStr(strNumVoo2)

									strOrigem2 = objRsProgramacao("origem")
									if (IsVazio(strOrigem2)) then strOrigem2 = ""
									strOrigem2 = CStr(strOrigem2)

									strDestino2 = objRsProgramacao("destino")
									if (IsVazio(strDestino2)) then strDestino2 = ""
									strDestino2 = CStr(strDestino2)

									strPartidaPrev = objRsProgramacao("partidaprevFormatada")
									if (IsVazio(strPartidaPrev)) then strPartidaPrev = "--:--"
									strChegadaPrev = objRsProgramacao("chegadaprevFormatada")
									if (IsVazio(strChegadaPrev)) then strChegadaPrev = "--:--"

									If (strNumVoo2 <> strNumVoo1) Then
										strEtapas = strEtapas & " " & strNumVoo2 & " " & strOrigem2
									End If
									strEtapas = strEtapas & " " & strPartidaPrev
						            intDiaPartida = objRsProgramacao("diaPartida")
						            intMesPartida = objRsProgramacao("mesPartida")
						            intAnoPartida = objRsProgramacao("anoPartida")
						            if (Not IsVazio(intDiaPartida) And Not IsVazio(intMesPartida) And Not IsVazio(intAnoPartida)) then
										dtPartida = DateSerial(intAnoPartida, intMesPartida, intDiaPartida)
									else
										dtPartida = NULL
						            end if
						            intDiaChegada = objRsProgramacao("diaChegada")
						            intMesChegada = objRsProgramacao("mesChegada")
						            intAnoChegada = objRsProgramacao("anoChegada")
						            if (Not IsVazio(intDiaChegada) And Not IsVazio(intMesChegada) And Not IsVazio(intAnoChegada)) then
										dtChegada = DateSerial(intAnoChegada, intMesChegada, intDiaChegada)
									else
										dtChegada = NULL
						            end if

									' Verifica se houve mudanca de dia na partida.
									if (Not IsVazio(dtPartida)) then
										Dim diasEntrePartidaJornada
										diasEntrePartidaJornada = DateDiff("d", dtJornada, dtPartida)
										If (diasEntrePartidaJornada > 0) Then
											strEtapas = strEtapas & " [+" & diasEntrePartidaJornada & "]"
										ElseIf (diasEntrePartidaJornada < 0) Then
											strEtapas = strEtapas & " [" & diasEntrePartidaJornada & "]"
										End If
									end if

									strEtapas = strEtapas & " " & strDestino2
									strEtapas = strEtapas & " " & strChegadaPrev
									' Verifica se houve mudanca de dia na chegada.
									if (Not IsVazio(dtChegada)) then
										Dim diasEntreChegadaJornada
										diasEntreChegadaJornada = DateDiff("d", dtJornada, dtChegada)
										If (diasEntreChegadaJornada > 0) Then
											strEtapas = strEtapas & " [+" & diasEntreChegadaJornada & "]"
										ElseIf (diasEntreChegadaJornada < 0) Then
											strEtapas = strEtapas & " [" & diasEntreChegadaJornada & "]"
										End If
									end if

									strOrigem1 = strOrigem2
									strDestino1 = strDestino2
									strNumVoo1 = strNumVoo2
								ElseIf (CStr(objRsProgramacao("flgtipo")) = "A") Then
									strEtapas = strEtapas & " " & objRsProgramacao("descricao") & " [" & objRsProgramacao("codatividade") & "]"
									strOrigem1 = ""
									strOrigem2 = ""
									strDestino1 = ""
									strDestino2 = ""
									strNumVoo1 = ""
									strNumVoo2 = ""
								End If
								objRsProgramacao.MoveNext
								if (Not objRsProgramacao.Eof) then
									intDiaProgramacao = objRsProgramacao("dia")
								end if
							Loop
							
							intTotalDia = CDbl(intDiurna) + CDbl(intNoturna) + CDbl(intEspecialDiurna) + CDbl(intEspecialNoturna) + CDbl(intAtividade)
						end if
					end if
					objRsJornada.movenext
				End If
			End If
		Else
			strFlgestadoJornada = "N"
		End If

		If ((intContador Mod 2) = 0) Then
			Cor = Cor2
		Else
			Cor = Cor1
		End If
		strData = CDate(intAno & "-" & intMes & "-" & intContador)
		strDiaSemana = fnDiaSemanaAbrev(Weekday(strData))

		Dim strDiaTemp, strMesTemp, strAnoTemp, strDataTemp
		strDiaTemp = Day(strData)
		strMesTemp = Month(strData)
		strAnoTemp = Year(strData)
		if (Len(strDiaTemp) < 2) then strDiaTemp = "0" & strDiaTemp end if
		if (Len(strMesTemp) < 2) then strMesTemp = "0" & strMesTemp end if

		Dim Data
		Data = strDiaTemp & "/" & strMesTemp & "/" & strAnoTemp

		Response.Write("<tr bgcolor='" & Cor & "'>" & vbCrLf)
		if (strFlgestadoJornada = "N") then
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			Data & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strDiaSemana & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			if (intEmpresa = 4) then 'TRIP
				Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
			end if
			Response.Write("      <td class='CORPO7' nowrap align='center'>-</td>" & vbCrLf)
		Elseif (strFlgestadoJornada = "A") then
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			Data & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strDiaSemana & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write("		<a href='relatorioescalaconsult.asp?rdoKmHr=" + strRdoKmHr + "&flgestado=E&diaavisado=" & intContador & "&mes=" & intMes & "&ano=" & intAno & "'>Alterado" & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			if (intEmpresa = 4) then 'TRIP
				Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
			end if
			Response.Write("      <td class='CORPO7' nowrap align='center'>---</td>" & vbCrLf)
		else
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write("	<a href='progtripulante.asp?ll_jornada= " & ll_jornada & "&Data=" & Data & "'>" & Data & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strDiaSemana & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strTextoJornada & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strHrApresentacao & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
			Response.Write(			strTextoJornadaAux & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			Response.Write("	<td class='CORPO6' align='left'>" & vbCrLf)
			Response.Write(			Trim(strEtapas) & vbCrLf)
			Response.Write("	&nbsp;</td>" & vbCrLf)
			if (strRdoKmHr = "Hr") then
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intDiurna, 2) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intNoturna, 2) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intEspecialDiurna, 2) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intEspecialNoturna, 2) & "&nbsp;</td>" & vbCrLf)
				if (intEmpresa = 4) then 'TRIP
					Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intAtividade, 2) & "&nbsp;</td>" & vbCrLf)
				end if
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalDia, 2) & "&nbsp;</td>" & vbCrLf)
			else
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intDiurna, 0) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intNoturna, 0) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intEspecialDiurna, 0) & "&nbsp;</td>" & vbCrLf)
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intEspecialNoturna, 0) & "&nbsp;</td>" & vbCrLf)
				if (intEmpresa = 4) then 'TRIP
					Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intAtividade, 0) & "&nbsp;</td>" & vbCrLf)
				end if
				Response.Write("	<td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalDia, 0) & "&nbsp;</td>" & vbCrLf)
			end if
		end if
		Response.Write("			</tr>" & vbCrLf)

		intTotalDiurna = CDbl(intTotalDiurna) + CDbl(intDiurna)
		intTotalNoturna = CDbl(intTotalNoturna) + CDbl(intNoturna)
		intTotalEspecialDiurna = CDbl(intTotalEspecialDiurna) + CDbl(intEspecialDiurna)
		intTotalEspecialNoturna = CDbl(intTotalEspecialNoturna) + CDbl(intEspecialNoturna)
		intTotalAtividade = CDbl(intTotalAtividade) + CDbl(intAtividade)
		intTotalMes = CDbl(intTotalMes) + CDbl(intTotalDia)

		'intTotKmSav = CLng(intTotKmSav) + CLng(intKmSav)
		'intTotKmRes = CLng(intTotKmRes) + CLng(intKmRes)
		'intTotKmVoo = CLng(intTotKmVoo) + CLng(intKmVoo)
		'intTotTotal = CLng(intTotTotal) + CLng(intTotal)

	Next

	Response.Write("<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
	Response.Write("	<td class='CORPO7Bold' nowrap align='right' colspan='6'>TOTAL&nbsp;&nbsp;</td>" & vbCrLf)
	if (strRdoKmHr = "Hr") then
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalDiurna, 2) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalNoturna, 2) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalEspecialDiurna, 2) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalEspecialNoturna, 2) & "&nbsp;</td>" & vbCrLf)
		if (intEmpresa = 4) then 'TRIP
			Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalAtividade, 2) & "&nbsp;</td>" & vbCrLf)
		end if
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalMes, 2) & "&nbsp;</td>" & vbCrLf)
	else
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalDiurna, 0) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalNoturna, 0) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalEspecialDiurna, 0) & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalEspecialNoturna, 0) & "&nbsp;</td>" & vbCrLf)
		if (intEmpresa = 4) then 'TRIP
			Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalAtividade, 0) & "&nbsp;</td>" & vbCrLf)
		end if
		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & FormatNumber(intTotalMes, 0) & "&nbsp;</td>" & vbCrLf)
	end if
	Response.Write("</tr>" & vbCrLf)
	Response.Write("<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
'	if (intEmpresa = 6) then 'Varig Log
	if (strRdoKmHr = "Hr") then
		if (intEmpresa = 4) then 'TRIP
			Response.Write("	<td class='CORPO7Bold' nowrap align='left' colspan='12'>As horas geradas por essa consulta s&#227;o uma aproxima&#231;&#227;o com objetivo demonstrativo. A gera&#231;&#227;o do pagamento &#233; realizada no m&#234;s subseq&#252;&#234;nte com as corre&#231;&#245;es necess&#225;rias.</td>" & vbCrLf)
		else
			Response.Write("	<td class='CORPO7Bold' nowrap align='left' colspan='11'>As horas geradas por essa consulta s&#227;o uma aproxima&#231;&#227;o com objetivo demonstrativo. A gera&#231;&#227;o do pagamento &#233; realizada no m&#234;s subseq&#252;&#234;nte com as corre&#231;&#245;es necess&#225;rias.</td>" & vbCrLf)
		end if
	else
		if (intEmpresa = 4) then 'TRIP
			Response.Write("	<td class='CORPO7Bold' nowrap align='left' colspan='12'>A quilometragem gerada por essa consulta &#233; uma aproxima&#231;&#227;o com objetivo demonstrativo. A gera&#231;&#227;o do pagamento &#233; realizada no m&#234;s subseq&#252;&#234;nte com as corre&#231;&#245;es necess&#225;rias.</td>" & vbCrLf)
		else
			Response.Write("	<td class='CORPO7Bold' nowrap align='left' colspan='11'>A quilometragem gerada por essa consulta &#233; uma aproxima&#231;&#227;o com objetivo demonstrativo. A gera&#231;&#227;o do pagamento &#233; realizada no m&#234;s subseq&#252;&#234;nte com as corre&#231;&#245;es necess&#225;rias.</td>" & vbCrLf)
		end if
	end if
	Response.Write("</tr>" & vbCrLf)

'	if (intEmpresa <> 6) then 'Varig Log
'		Response.Write("<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='right' colspan='6'>TOTAL&nbsp;&nbsp;</td>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & intTotKmSav & "&nbsp;</td>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & intTotKmRes & "&nbsp;</td>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & intTotKmVoo & "&nbsp;</td>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;" & intTotTotal & "&nbsp;</td>" & vbCrLf)
'		Response.Write("</tr>" & vbCrLf)
'		Response.Write("<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
'		Response.Write("	<td class='CORPO7Bold' nowrap align='left' colspan='11'>A quilometragem gerada por essa consulta &#233; uma aproxima&#231;&#227;o com objetivo demonstrativo. A gera&#231;&#227;o do pagamento &#233; realizada no m&#234;s subseq&#252;&#234;nte com as corre&#231;&#245;es necess&#225;rias.</td>" & vbCrLf)
'		Response.Write("</tr>" & vbCrLf)
'	End If



   Response.Write("			<tr bgcolor='" & Cor1 & "'>" & vbCrLf)
   if (intEmpresa = 4) then 'TRIP
	Response.Write("				<td class='CORPO6' align='left' colspan='12'>&nbsp;Observa&#231;&#245;es:&nbsp;" & vbCrLf)
   else
	Response.Write("				<td class='CORPO6' align='left' colspan='11'>&nbsp;Observa&#231;&#245;es:&nbsp;" & vbCrLf)
   end if
   Response.Write(						strObservacao & vbCrLf)
   Response.Write("				&nbsp;</td>" & vbCrLf)
   Response.Write("			</tr>" & vbCrLf)


	If blnFezConsultaJornada Then
		objRsProgramacao.Close
		Set objRsProgramacao = Nothing
	End If
	objRsJornada.Close
End If

objConn.close
Set objRsJornada = Nothing
Set objConn = Nothing

Response.Write("    <tr>" & vbCrLf)
if (intEmpresa = 4) then 'TRIP
	Response.Write("      <th colspan='12'></th>" & vbCrLf)
else
	Response.Write("      <th colspan='11'></th>" & vbCrLf)
end if
Response.Write("    </tr>" & vbCrLf)
Response.Write("  </table>" & vbCrLf)
Response.Write("</center>" & vbCrLf)
Response.Write("</body>" & vbCrLf)
Response.Write("</html>" & vbCrLf)



Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function

%>
