<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<!--#include file="verificalogintripulante.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>

<html>
<head>
	<title>Escala Individual de Tripulantes</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>

<body>
<%
	Dim intSeqJornada
	Dim objConn
	Dim blnFazConsulta
	blnFazConsulta = true

	intSeqJornada = Request.QueryString("seqjornada")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' *******************
	' *** PROGRAMAÇÃO ***
	' *******************
	Dim objRsProg, strQueryProgramacao
	strQueryProgramacao = " SELECT "
	strQueryProgramacao = strQueryProgramacao & " TRIP.seqtripulante, "
	strQueryProgramacao = strQueryProgramacao & " JORN.seqjornada, "
	strQueryProgramacao = strQueryProgramacao & " JORN.dtjornada, "
	strQueryProgramacao = strQueryProgramacao & " PROG.seqprogramacao, "
	strQueryProgramacao = strQueryProgramacao & " PROG.flgtipo, "
	strQueryProgramacao = strQueryProgramacao & " EDV.nrvoo, "
	strQueryProgramacao = strQueryProgramacao & " PROG.funcao, "
	strQueryProgramacao = strQueryProgramacao & " '' codatividade, "
	strQueryProgramacao = strQueryProgramacao & " '' descricao, "
	strQueryProgramacao = strQueryProgramacao & " CONVERT(char(5), EDT.partidaprev, 8) AS dthrinicio, "
	strQueryProgramacao = strQueryProgramacao & " CONVERT(char(5), EDT.chegadaprev, 8) AS dthrfim, "
	strQueryProgramacao = strQueryProgramacao & " AERORIG.codiata AS origem, "
	strQueryProgramacao = strQueryProgramacao & " AERDEST.codiata AS destino, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmdiurna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmnoturna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmespdiurna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmespnoturna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.observacao "
	strQueryProgramacao = strQueryProgramacao & " FROM "
	strQueryProgramacao = strQueryProgramacao & " sig_programacao AS PROG, "
	strQueryProgramacao = strQueryProgramacao & " sig_escdiariovoo AS EDV, "
	strQueryProgramacao = strQueryProgramacao & " sig_escdiariotrecho AS EDT, "
	strQueryProgramacao = strQueryProgramacao & " sig_jornada AS JORN, "
	strQueryProgramacao = strQueryProgramacao & " sig_tripulante AS TRIP, "
	strQueryProgramacao = strQueryProgramacao & " sig_aeroporto AS AERORIG, "
	strQueryProgramacao = strQueryProgramacao & " sig_aeroporto AS AERDEST "
	strQueryProgramacao = strQueryProgramacao & " WHERE "
	strQueryProgramacao = strQueryProgramacao & "     TRIP.seqtripulante = JORN.seqtripulante "
	strQueryProgramacao = strQueryProgramacao & " AND PROG.seqvoodiaesc = EDV.seqvoodiaesc "
	strQueryProgramacao = strQueryProgramacao & " AND PROG.seqvoodiaesc = EDT.seqvoodiaesc "
	strQueryProgramacao = strQueryProgramacao & " AND PROG.seqaeroporig = EDT.seqaeroporig "
	strQueryProgramacao = strQueryProgramacao & " AND PROG.seqaeropdest = EDT.seqaeropdest "
	strQueryProgramacao = strQueryProgramacao & " AND JORN.seqjornada = PROG.seqjornada "
	strQueryProgramacao = strQueryProgramacao & " AND JORN.seqjornada = " & intSeqJornada
	strQueryProgramacao = strQueryProgramacao & " AND PROG.flgtipo = 'V' "
	strQueryProgramacao = strQueryProgramacao & " AND AERORIG.seqaeroporto = EDT.seqaeroporig "
	strQueryProgramacao = strQueryProgramacao & " AND AERDEST.seqaeroporto = EDT.seqaeropdest "
	strQueryProgramacao = strQueryProgramacao & " UNION "
	strQueryProgramacao = strQueryProgramacao & " SELECT "
	strQueryProgramacao = strQueryProgramacao & " TRIP.seqtripulante, "
	strQueryProgramacao = strQueryProgramacao & " JORN.seqjornada, "
	strQueryProgramacao = strQueryProgramacao & " JORN.dtjornada, "
	strQueryProgramacao = strQueryProgramacao & " PROG.seqprogramacao, "
	strQueryProgramacao = strQueryProgramacao & " PROG.flgtipo, "
	strQueryProgramacao = strQueryProgramacao & " 0 nrvoo, "
	strQueryProgramacao = strQueryProgramacao & " PROG.funcao, "
	strQueryProgramacao = strQueryProgramacao & " ATV.codatividade, "
	strQueryProgramacao = strQueryProgramacao & " ATV.descricao, "
	strQueryProgramacao = strQueryProgramacao & " CONVERT(char(5), PROG.dthrinicio, 8) AS dthrinicio, "
	strQueryProgramacao = strQueryProgramacao & " CONVERT(char(5), PROG.dthrfim, 8) AS dthrfim, "
	strQueryProgramacao = strQueryProgramacao & " '' AS origem, "
	strQueryProgramacao = strQueryProgramacao & " '' AS destino, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmdiurna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmnoturna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmespdiurna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.kmespnoturna, "
	strQueryProgramacao = strQueryProgramacao & " PROG.observacao "
	strQueryProgramacao = strQueryProgramacao & " FROM "
	strQueryProgramacao = strQueryProgramacao & " sig_programacao AS PROG, "
	strQueryProgramacao = strQueryProgramacao & " sig_atividade AS ATV, "
	strQueryProgramacao = strQueryProgramacao & " sig_jornada AS JORN, "
	strQueryProgramacao = strQueryProgramacao & " sig_tripulante AS TRIP "
	strQueryProgramacao = strQueryProgramacao & " WHERE "
	strQueryProgramacao = strQueryProgramacao & "     TRIP.seqtripulante = JORN.seqtripulante "
	strQueryProgramacao = strQueryProgramacao & " AND PROG.seqatividade = ATV.seqatividade "
	strQueryProgramacao = strQueryProgramacao & " AND JORN.seqjornada = PROG.seqjornada "
	strQueryProgramacao = strQueryProgramacao & " AND JORN.seqjornada = " & intSeqjornada
	strQueryProgramacao = strQueryProgramacao & " AND PROG.flgtipo = 'A' "
	strQueryProgramacao = strQueryProgramacao & " ORDER BY "
	strQueryProgramacao = strQueryProgramacao & " PROG.seqprogramacao "

	Set objRsProg = Server.CreateObject("ADODB.Recordset")
	objRsProg.Open strQueryProgramacao, objConn
	If objRsProg.eof then
		response.write "Nenhum registro encontrado"
	end if

%>
<center>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%" rowspan="2">
			<img src="imagens/logo_empresa.gif" width="129" height="62" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Programação do Tripulante
			</b></font>
		</td>
		<td class="corpo" align="right" valign="top" width="35%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
	</tr>
	</table>
</center>

<br>
<center>
	<table width="98%">
	<tr>
		<td align="right" valign="middle">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
	</tr>
	</table>
</center>
<br>
<center>

	<table width="98%" border="1" cellpadding="0" cellspacing="0" ID="Table2">
	<tr bgcolor="#AAAAAA">
		<th class='CORPO8' rowspan='2'>Voo</th>
		<th class='CORPO8' rowspan='2'>Atividade</th>
		<th class='CORPO8' rowspan='2'>Origem</th>
		<th class='CORPO8' rowspan='2'>Destino</th>
		<th class='CORPO8' rowspan='2'>Início</th>
		<th class='CORPO8' rowspan='2'>Fim</th>
		<th class='CORPO8' colspan='4'>Quilometragem</th>
		<th class='CORPO8' rowspan='2'>Observação</th>
	</tr>
	<tr bgcolor="#AAAAAA">
		<th>Diurna</th>
		<th>Noturna</th>
		<th>Esp. Diu.</th>
		<th>Esp. Not.</th>
	</tr>

	<%
	Do While Not objRsProg.Eof

Response.Write("		<tr>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
if ObjRsProg("flgtipo") = "V" then
	Response.Write(					ObjRsProg("nrvoo") & vbCrLf)
end if
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("codatividade") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("origem") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("destino") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("dthrinicio") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("dthrfim") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("kmdiurna") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("kmnoturna") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("kmespdiurna") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("kmespnoturna") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("			<td class='CORPO7' nowrap align='center' width='12%'>&nbsp;" & vbCrLf)
Response.Write(					ObjRsProg("observacao") & vbCrLf)
Response.Write("			&nbsp;</td>" & vbCrLf)
Response.Write("		</tr>" & vbCrLf)



		objRsProg.movenext
	loop
	objRsProg.Close
	Set objRsProg = Nothing
	%>

</center>

</body>

</html>
