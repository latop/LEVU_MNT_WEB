<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<html>
<head>
	<title>Relatório de Voos Planejados</title>
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
  Dim objConn, objRs
  Dim strQueryCount, strSqlSelectCount, strQuery, strSqlSelect, strSqlFrom, strSqlWhere, strSqlOrder
  Dim strCenario
  Dim blnFazConsulta
  blnFazConsulta = True

  strCenario = Request.Form ("ddl_Cenario")

  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"
  
  strSqlSelect = " SELECT "
  strSqlSelect = strSqlSelect & "        SPV.codcenario,  "
  strSqlSelect = strSqlSelect & "        SPH.codhotran,  "
  strSqlSelect = strSqlSelect & "        SPH.dtinicio,  "
  strSqlSelect = strSqlSelect & "        SPH.dtfim,  "
  strSqlSelect = strSqlSelect & "        SPV.nrvoo voo,  "
  strSqlSelect = strSqlSelect & "        SFR.codfrota,  "
  strSqlSelect = strSqlSelect & "        SPV.freqseg,  "
  strSqlSelect = strSqlSelect & "        SPV.freqter,  "
  strSqlSelect = strSqlSelect & "        SPV.freqqua,  "
  strSqlSelect = strSqlSelect & "        SPV.freqqui,  "
  strSqlSelect = strSqlSelect & "        SPV.freqsex,  "
  strSqlSelect = strSqlSelect & "        SPV.freqsab,  "
  strSqlSelect = strSqlSelect & "        SPV.freqdom,  "
  strSqlSelect = strSqlSelect & "        'N' statusvoo,  "
  strSqlSelect = strSqlSelect & "        SPV.tipotransporte,  "
  strSqlSelect = strSqlSelect & "        SPT.seqtrecho trecho,  "
  strSqlSelect = strSqlSelect & "        AEROPORIG.codiata origem,  "
  strSqlSelect = strSqlSelect & "        AEROPDEST.codiata destino,  "
  strSqlSelect = strSqlSelect & "        SPT.partida,  "
  strSqlSelect = strSqlSelect & "        SPT.partidadia,  "
  strSqlSelect = strSqlSelect & "        SPT.chegada,  "
  strSqlSelect = strSqlSelect & "        SPT.chegadadia,  "
  strSqlSelect = strSqlSelect & "        'S' original  "

  strSqlFrom = " FROM "
  strSqlFrom = strSqlFrom & "        sig_planejtrecho SPT,  "
  strSqlFrom = strSqlFrom & "        sig_frota SFR,  "
  strSqlFrom = strSqlFrom & "        sig_aeroporto AEROPORIG,  "
  strSqlFrom = strSqlFrom & "        sig_aeroporto AEROPDEST,  "
  strSqlFrom = strSqlFrom & "        sig_planejvoo SPV LEFT OUTER JOIN sig_propostavoo ON SPV.seqvoo = sig_propostavoo.seqvoo  "
  strSqlFrom = strSqlFrom & "        LEFT OUTER JOIN sig_propostahotran SPH ON sig_propostavoo.seqproposta = SPH.seqproposta  "

  strSqlWhere = " WHERE 1 = 1 "
  strSqlWhere = strSqlWhere & "    AND ( SPV.seqvoo = SPT.seqvoo )  "
  strSqlWhere = strSqlWhere & "    AND ( SPV.seqfrota = SFR.seqfrota )  "
  strSqlWhere = strSqlWhere & "    AND ( SPT.seqaeroporig = AEROPORIG.seqaeroporto )  "
  strSqlWhere = strSqlWhere & "    AND ( SPT.seqaeropdest = AEROPDEST.seqaeroporto )  "
  if strCenario <> "" then
    strSqlWhere = strSqlWhere & "    AND ( SPV.codcenario = '" & strCenario & "' )  "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if
  
  strSqlOrder = " ORDER BY voo, partida "

  strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

  strSqlSelectCount = " SELECT COUNT(*) AS QtdRegistros "
  strQueryCount  = strSqlSelectCount & strSqlFrom & strSqlWhere

  If blnFazConsulta Then
    Dim intQtdReg
    Set ObjRs = Server.CreateObject("ADODB.Recordset")
    objRs.Open strQueryCount, objConn
    intQtdReg = objRs("QtdRegistros")
    
    If intQtdReg > 0 Then
      objRs.Close
      objRs.Open strQuery, objConn
    End If
  End If

  Dim objRsCenario, strQueryCenario, strSqlSelectCenario, strSqlFromCenario, strSqlWhereCenario

  strSqlSelectCenario = " SELECT SPC.codcenario "
  strSqlFromCenario = " FROM sig_planejcenario SPC "
  strSqlWhereCenario = " WHERE SPC.flgdivulgar = 'S' "
  strQueryCenario = strSqlSelectCenario & strSqlFromCenario & strSqlWhereCenario

  Set objRsCenario = Server.CreateObject("ADODB.Recordset")
  objRsCenario.Open strQueryCenario, objConn

%>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>

		<td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Voos Planejados
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
   <tr>
   	<td>&nbsp;</td>
   </tr>   
	<tr>
		<td align="right" colspan="3"><font size="2">Cenário: 
		<%
			if strCenario <> "" then
				Response.Write(strCenario)
			else
				Response.Write("------")
			end if
		%>
		</td>
	</tr>
	</table>
</center>

<br>
<center>
	<table width="98%">
	<tr>
		<td>
			<form method="post" action="relatoriovoosplanejconsult.asp">
<%
           ' Executa função para gravar na sig_usuariolog
           If f_grava_usuariolog( "I02", objConn ) > "" Then
              Response.End()
           End if
%>        
			<p>
				<label class="CORPO9">Cenário:&nbsp;</label>
				<select name="ddl_Cenario" id="ddl_Cenario">
					<option></option>
					<%
						Do While Not objRsCenario.EOF
							If StrComp(strCenario, objRsCenario("codcenario")) = 0 Then
								Response.Write("<option selected>" & objRsCenario("codcenario") & "</option>")
							Else
								Response.Write("<option>" & objRsCenario("codcenario") & "</option>")
							End If
							objRsCenario.MoveNext
						loop
					%>
				</select>
				<br><br>
				<input type="submit" name="submit" value="Pesquisar">
			</p>
			</form>
		</td>
	</tr>
	</table>
</center>
<br>
<center>
  <table width="98%" border="1" cellspacing="1" ID="Table2">
    <tr bgcolor="#AAAAAA" class="CORPO9">
      <th>Hotran</th>
      <th>Voo</th>
      <th>Vigência</th>
      <th>Freqüência</th>
      <th>Equipamento</th>
      <th>Rota</th>
      <th>Horário Brasília</th>
    </tr>

<%
  Dim CodOrigemAtual, CodOrigemNovo, Cor1, Cor2
  Dim Cor, CorAtual

  Cor1 = "#FFFFFF"
  Cor2 = "#EEEEEE"

  Cor = Cor1
  CorAtual = Cor1

  If blnFazConsulta And intQtdReg > 0 Then
    Dim strBordaDireitaLargura, strBordaEsquerdaLargura, strBordaInferiorLargura
    Dim strBordaSuperiorLargura0, strBordaSuperiorLargura1, strBordaSuperiorEstilo, strBordaSuperior
    Dim intCont
    intCont = 0

	strBordaDireitaLargura = " border-right-width: 0; "
	strBordaEsquerdaLargura = " border-left-width: 0; "
	strBordaSuperiorLargura0 = " border-top-width: 0; "
	strBordaSuperiorLargura1 = " border-top-width: 1; border-top-color: #555555 "
	strBordaInferiorLargura = " border-bottom-width: 0; "
	strBordaSuperiorEstilo = " border-top-style: dashed; "

	Do While Not ObjRs.Eof
		Dim strFrequencia, voo, blnEscreve
		Dim strBordaPrimeiraCelula, strBordaUltimaCelula, strBordaCelulaMeio
		intCont = intCont + 1
		
		If ObjRs("freqseg") = "S" Then strFrequencia = "1" Else strFrequencia = "-"
		If ObjRs("freqter") = "S" Then strFrequencia = strFrequencia & "2" Else strFrequencia = strFrequencia & "-"
		If ObjRs("freqqua") = "S" Then strFrequencia = strFrequencia & "3" Else strFrequencia = strFrequencia & "-"
		If ObjRs("freqqui") = "S" Then strFrequencia = strFrequencia & "4" Else strFrequencia = strFrequencia & "-"
		If ObjRs("freqsex") = "S" Then strFrequencia = strFrequencia & "5" Else strFrequencia = strFrequencia & "-"
		If ObjRs("freqsab") = "S" Then strFrequencia = strFrequencia & "6" Else strFrequencia = strFrequencia & "-"
		If ObjRs("freqdom") = "S" Then strFrequencia = strFrequencia & "7" Else strFrequencia = strFrequencia & "-"
		
		If StrComp(voo, ObjRs("voo")) = 0 Then
			strBordaSuperior = strBordaSuperiorLargura0
			blnEscreve = False
		Else
			strBordaSuperior = strBordaSuperiorEstilo & strBordaSuperiorLargura1
			blnEscreve = True
		End If

		If intCont = 1 Then
			strBordaPrimeiraCelula = "style='" & strBordaDireitaLargura & strBordaInferiorLargura & "'"
			strBordaCelulaMeio = "style='" & strBordaDireitaLargura & strBordaEsquerdaLargura & strBordaInferiorLargura & "'"
			strBordaUltimaCelula = "style='" & strBordaEsquerdaLargura & strBordaInferiorLargura & "'"
		ElseIf intCont = intQtdReg Then
			strBordaPrimeiraCelula = "style='" & strBordaDireitaLargura & strBordaSuperior & "'"
			strBordaCelulaMeio = "style='" & strBordaDireitaLargura & strBordaEsquerdaLargura & strBordaSuperior & "'"
			strBordaUltimaCelula = "style='" & strBordaEsquerdaLargura & strBordaSuperior & "'"
		Else
			strBordaPrimeiraCelula = "style='" & strBordaDireitaLargura & strBordaInferiorLargura & strBordaSuperior & "'"
			strBordaCelulaMeio = "style='" & strBordaDireitaLargura & strBordaEsquerdaLargura & strBordaInferiorLargura & strBordaSuperior & "'"
			strBordaUltimaCelula = "style='" & strBordaEsquerdaLargura & strBordaInferiorLargura & strBordaSuperior & "'"
		End If
		
		voo = ObjRs("voo")
%>

		<tr bgcolor=<%=Cor%>>
			<td class="corpo" nowrap align="center" <%=strBordaPrimeiraCelula%>>
				<%If blnEscreve Then Response.Write(ObjRs("codhotran"))%> &nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaCelulaMeio%>>
				<%If blnEscreve Then Response.Write(ObjRs("voo"))%> &nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaCelulaMeio%>>
				<%If blnEscreve Then Response.Write(ObjRs("dtinicio") & "&nbsp;-&nbsp;" & ObjRs("dtfim"))%> &nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaCelulaMeio%>>
				<%If blnEscreve Then Response.Write(strFrequencia)%> &nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaCelulaMeio%>>
				<%If blnEscreve Then Response.Write(ObjRs("codfrota"))%> &nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaCelulaMeio%>>
				<%=ObjRs("origem")%>&nbsp;/&nbsp;<%=ObjRs("destino")%>&nbsp;</td>
			<td class="corpo" nowrap align="center" <%=strBordaUltimaCelula %>>
				<%=FormatDateTime(ObjRs("partida"), 4)%>&nbsp;/&nbsp;<%=FormatDateTime(ObjRs("chegada"), 4)%>&nbsp;</td>
		</tr>

<%
		ObjRs.movenext
	loop
	objRs.Close
  End If
%>
    <tr>
      <th colspan="7"></th>
    </tr>
  </table>
</center>

<%
  objRsCenario.Close
  objConn.close
  Set objRsCenario = Nothing
  Set objRs = Nothing
  Set objConn = Nothing
%>

</body>

</html>