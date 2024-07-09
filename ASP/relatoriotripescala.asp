<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<!--#include file="verificalogintripulante.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>

<html>
<head>
	<title>Tripulantes</title>
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
	Dim intSeqVooDiaEsc, intSeqTrecho
	Dim objConn
	Dim blnFazConsulta
	blnFazConsulta = true

	intSeqVooDiaEsc = Request.QueryString("seqvoodiaesc")
	intSeqTrecho = Request.QueryString("seqtrecho")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' *******************
	' *** TRIPULANTES ***
	' *******************
	Dim objRsTrip, strQueryTrip
	strQueryTrip = " SELECT "
	strQueryTrip = strQueryTrip & "        sig_tripcargo.codcargo, "
	strQueryTrip = strQueryTrip & "        sig_tripulante.nomeguerra nomeguerra, "
	strQueryTrip = strQueryTrip & "        sig_jornada.textojornada, "
	strQueryTrip = strQueryTrip & "        sig_jornada.textojornadaaux, "
	strQueryTrip = strQueryTrip & "        sig_tripulante.senioridade, "
	strQueryTrip = strQueryTrip & "        sig_cargo.ordem, "
	strQueryTrip = strQueryTrip & "        sig_programacao.funcao, "
	strQueryTrip = strQueryTrip & "        sig_escdiariovoo.nrvoo, "
	strQueryTrip = strQueryTrip & "        aeroporig.codiata origem, "
	strQueryTrip = strQueryTrip & "        aeropdest.codiata destino "
	strQueryTrip = strQueryTrip & "   FROM sig_tripulante, "
	strQueryTrip = strQueryTrip & "        sig_jornada, "
	strQueryTrip = strQueryTrip & "        sig_programacao, "
	strQueryTrip = strQueryTrip & "        sig_escdiariovoo, "
	strQueryTrip = strQueryTrip & "        sig_escdiariotrecho, "
	strQueryTrip = strQueryTrip & "        sig_aeroporto aeroporig, "
	strQueryTrip = strQueryTrip & "        sig_aeroporto aeropdest, "
	strQueryTrip = strQueryTrip & "        sig_tripcargo, "
	strQueryTrip = strQueryTrip & "        sig_cargo "
	strQueryTrip = strQueryTrip & "  WHERE sig_tripulante.seqtripulante = sig_jornada.seqtripulante "
	strQueryTrip = strQueryTrip & "    AND sig_jornada.seqjornada = sig_programacao.seqjornada "
	strQueryTrip = strQueryTrip & "    AND sig_programacao.seqvoodiaesc = sig_escdiariovoo.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "    AND sig_programacao.seqvoodiaesc = sig_escdiariotrecho.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "    AND sig_programacao.seqtrecho = sig_escdiariotrecho.seqtrecho "
	strQueryTrip = strQueryTrip & "    AND sig_programacao.seqaeroporig = aeroporig.seqaeroporto "
	strQueryTrip = strQueryTrip & "    AND sig_programacao.seqaeropdest = aeropdest.seqaeroporto "
	strQueryTrip = strQueryTrip & "    AND sig_jornada.flgcorrente = 'S' "
	strQueryTrip = strQueryTrip & "    AND sig_jornada.flgestado <> 'N' "
	strQueryTrip = strQueryTrip & "    AND sig_tripcargo.seqtripulante = sig_tripulante.seqtripulante "
	strQueryTrip = strQueryTrip & "    AND sig_tripcargo.dtinicio <= sig_jornada.dtjornada "
	strQueryTrip = strQueryTrip & "    AND (sig_tripcargo.dtfim >= sig_jornada.dtjornada OR sig_tripcargo.dtfim is null) "
	strQueryTrip = strQueryTrip & "    AND sig_cargo.codcargo = sig_tripcargo.codcargo "
	strQueryTrip = strQueryTrip & "    AND sig_escdiariovoo.seqvoodiaesc = sig_escdiariotrecho.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "    AND sig_escdiariovoo.seqvoodiaesc = " & intSeqVooDiaEsc
	strQueryTrip = strQueryTrip & "    AND sig_escdiariotrecho.seqtrecho = " & intSeqTrecho
	strQueryTrip = strQueryTrip & "  ORDER BY sig_cargo.ordem, sig_tripulante.senioridade "
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn
	If objRsTrip.eof then
		response.write "Nenhum tripulante encontrado"
	end if

%>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Tripulantes
			</b></font>
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
<br />
<table align="center" width="98%" border="1" cellpadding="0" cellspacing="0" ID="Table2">
  <tr bgcolor="#AAAAAA" class="CORPO9">
    <th>Cargo</th>
    <th>Tripulante</th>
    <th>Jornada</th>
    <th>Horário</th>
    <th>Função</th>
  </tr>

<%
  Dim Cor1, Cor2
  Dim Cor, CorAtual

  Cor1 = "#FFFFFF"
  Cor2 = "#EEEEEE"

  Cor = Cor1
  CorAtual = Cor1

  If blnFazConsulta Then
    If (Not ObjRsTrip.Eof) Then
		Response.Write("Voo: " & ObjRsTrip("nrvoo") & " [" & ObjRsTrip("origem") & " - " & ObjRsTrip("destino") & "]<br><br>" & vbCrLf)
		Do While Not ObjRsTrip.Eof
			If (CorAtual = Cor1) Then
				CorAtual = Cor2
			ElseIf (CorAtual = Cor2) Then
				CorAtual = Cor1
			End If
%>

			<tr bgcolor=<%=CorAtual%>>
				<td class="corpo" nowrap align="center">
				<%=ObjRsTrip("codcargo")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRsTrip("nomeguerra")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRsTrip("textojornada")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRsTrip("textojornadaaux")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRsTrip("funcao")%> &nbsp;</td>
				</td>
			</tr>

<%
			ObjRsTrip.movenext
		loop
	End If
	objRsTrip.Close
  End If
%>
    <tr>
      <th colspan="8"></th>
    </tr>
  </table>
   <br />
   <input type="button" Value="Voltar" onClick="history.go(-1)" style="margin-left:15px;" />

<%
  objConn.close
  Set objRsTrip = Nothing
  Set objConn = Nothing
%>

</body>

</html>

<%
	Function Funcaotrip(funcao)
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
