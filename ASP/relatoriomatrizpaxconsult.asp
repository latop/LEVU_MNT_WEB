<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = True%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<html>

<head>
	<title>Relatório Origem e Destino</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	<script src="javascript.js"></script>
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
	<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
	<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script language="javascript">
		function VerificaCampos() {
				if (window.frm_Filtro.txt_DeData.value == "") {
					alert('Preencha a 1º Data!');
					window.frm_Filtro.txt_DeData.focus();
					return false;
				}
				else if (window.frm_Filtro.txt_AteData.value == "") {
					alert('Preencha a 2º Data!');
					window.frm_Filtro.txt_AteData.focus();
					return false;1
				}	
		}	
		$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_DeData").mask("99/99/9999");
			$("#txt_AteData").mask("99/99/9999");
       });	
	</script>			
      
    <style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
    <style type="text/css">
body {
	margin-left: 0px;
}
</style>

</head>

<body>
<%

	function isVazio(var)
		if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
			isVazio = true
		else
			isVazio = false
		end if
	end function

  Server.ScriptTimeout = 300

  Dim objConn1, objConn2, objConn3, objConn4, objConn5, objConn6
  Dim objRs1, objRs2, objRs3, objRs4, objRsOrigens, objRsDestinos
  Dim strQuery1, strSqlSelect1, strSqlFrom1, strSqlWhere1, strSqlOrder, strSqlGroup1, strSqlHaving1
  Dim strQuery3, strSqlOrder3
  Dim strQuery4, strSqlOrder4
  Dim strQuery2, strSqlSelect2, strSqlFrom2, strSqlWhere2, strSqlGroup2, strSqlHaving2
  Dim strQueryOrigens, strSqlSelectOrigens, strSqlOrderOrigens
  Dim strQueryDestinos, strSqlSelectDestinos, strSqlOrderDestinos
  Dim strDeDia, strDeMes, strDeAno, strAteDia, strAteMes, strAteAno
  Dim blnFazConsulta
  Dim intTipoVoo, strCodLinhaSelecionada

  blnFazConsulta = True

'if (Request.Form("txt_DeData") <> null) then
  strDeDia = day(Request.Form("txt_DeData"))
  strDeMes = month(Request.Form("txt_DeData"))
  strDeAno = year(Request.Form("txt_DeData"))
  strAteDia = day(Request.Form("txt_AteData"))
  strAteMes = month(Request.Form("txt_AteData"))
  strAteAno = year(Request.Form("txt_AteData"))
'end if
  intTipoVoo = Request.Form ("ddl_TipoVoo")
  strCodLinhaSelecionada = Request.Form ("ddl_Linha")

  Set objConn1 = CreateObject("ADODB.CONNECTION")
  Set objConn2 = CreateObject("ADODB.CONNECTION")
  Set objConn3 = CreateObject("ADODB.CONNECTION")
  Set objConn4 = CreateObject("ADODB.CONNECTION")
  Set objConn5 = CreateObject("ADODB.CONNECTION")
  Set objConn6 = CreateObject("ADODB.CONNECTION")
  objConn1.Open (StringConexaoSqlServer)
  objConn2.Open (StringConexaoSqlServer)
  objConn3.Open (StringConexaoSqlServer)
  objConn4.Open (StringConexaoSqlServer)
  objConn5.Open (StringConexaoSqlServer)
  objConn6.Open (StringConexaoSqlServer)
  objConn1.Execute "SET DATEFORMAT ymd"
  objConn2.Execute "SET DATEFORMAT ymd"
  objConn3.Execute "SET DATEFORMAT ymd"
  objConn4.Execute "SET DATEFORMAT ymd"
  objConn5.Execute "SET DATEFORMAT ymd"
  objConn6.Execute "SET DATEFORMAT ymd"

  strSqlSelect1 = " SELECT 1 tipo,"
  strSqlSelect1 = strSqlSelect1 & "        aeroporig.codiata codiataorig, "
  strSqlSelect1 = strSqlSelect1 & "        aeropdest.codiata codiatadest, "
  strSqlSelect1 = strSqlSelect1 & "        SUM(sig_diariotrechocomb.paxprimeira + sig_diariotrechocomb.paxeconomica + sig_diariotrechocomb.paxturismo + sig_diariotrechocomb.paxespecial - sig_diariotrechocomb.paxtrc) totalpax "

  strSqlFrom1 = " FROM "
  strSqlFrom1 = strSqlFrom1 & " sig_diariovoo, "
  strSqlFrom1 = strSqlFrom1 & " sig_diariotrecho, "
  strSqlFrom1 = strSqlFrom1 & " sig_diariotrechocomb, "
  strSqlFrom1 = strSqlFrom1 & " sig_aeroporto aeroporig, "
  strSqlFrom1 = strSqlFrom1 & " sig_aeroporto aeropdest "

  strSqlWhere1 = " WHERE "
  strSqlWhere1 = strSqlWhere1 & "       ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariotrechocomb.seqvoodia = sig_diariotrecho.seqvoodia ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariotrechocomb.seqtrecho = sig_diariotrecho.seqtrecho ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.statusvoo = 'N' ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariotrecho.flgcancelado = 'N' ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
  strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariotrechocomb.seqaeropdest = aeropdest.seqaeroporto ) "
  Select Case intTipoVoo
	Case 0
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.tipovoo NOT IN ('3', '6', 'A', 'B') ) "
	Case 1
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.tipovoo IN ('0', '1', '4') ) "
	Case 2
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.tipovoo IN ('2', '5', '8', 'C', 'D') ) "
	Case 3
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.tipovoo IN ('7') ) "
	Case 4
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.tipovoo IN ('9') ) "
  End Select
  if (Not isVazio(strCodLinhaSelecionada)) then
		strSqlWhere1 = strSqlWhere1 & "   AND ( sig_diariovoo.codlinha = '" & strCodLinhaSelecionada & "') "
  end if

  if strDeDia <> "" and strDeMes <> "" and strDeAno <> "" and strAteDia <> "" and strAteMes <> "" and strAteAno <> "" then
    strSqlWhere1 = strSqlWhere1 & " AND ( sig_diariovoo.dtoper BETWEEN '" & strDeAno & "-" & strDeMes & "-" & strDeDia & "' AND '" & strAteAno & "-" & strAteMes & "-" & strAteDia & "') "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if

  strSqlGroup1 = " GROUP BY aeroporig.codiata, aeropdest.codiata "
  strSqlHaving1 = " HAVING SUM(sig_diariotrechocomb.paxprimeira + sig_diariotrechocomb.paxeconomica + sig_diariotrechocomb.paxturismo + sig_diariotrechocomb.paxespecial - sig_diariotrechocomb.paxtrc) > 0 "

  strSqlSelect2 = " SELECT 2 tipo,"
  strSqlSelect2 = strSqlSelect2 & "        aeroporig.codiata codiataorig, "
  strSqlSelect2 = strSqlSelect2 & "        aeropdest.codiata codiatadest, "
  strSqlSelect2 = strSqlSelect2 & "        SUM(sig_diariotrechocombtran.paxprimeira + sig_diariotrechocombtran.paxeconomica + sig_diariotrechocombtran.paxturismo + sig_diariotrechocombtran.paxespecial) totalpax "

  strSqlFrom2 = " FROM "
  strSqlFrom2 = strSqlFrom2 & " sig_diariovoo, "
  strSqlFrom2 = strSqlFrom2 & " sig_diariotrecho, "
  strSqlFrom2 = strSqlFrom2 & " sig_diariotrechocomb, "
  strSqlFrom2 = strSqlFrom2 & " sig_diariotrechocombtran, "
  strSqlFrom2 = strSqlFrom2 & " sig_aeroporto aeroporig, "
  strSqlFrom2 = strSqlFrom2 & " sig_aeroporto aeropdest "

  strSqlWhere2 = " WHERE "
  strSqlWhere2 = strSqlWhere2 & "       ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrecho.seqvoodia = sig_diariotrechocomb.seqvoodia ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrecho.seqtrecho = sig_diariotrechocomb.seqtrecho ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrechocomb.seqvoodia = sig_diariotrechocombtran.seqvoodia ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrechocomb.seqtrecho = sig_diariotrechocombtran.seqtrecho ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrechocomb.seqcombinada = sig_diariotrechocombtran.seqcombinada ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.statusvoo = 'N' ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrecho.flgcancelado = 'N' ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
  strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariotrechocombtran.seqaeropdest = aeropdest.seqaeroporto ) "
  Select Case intTipoVoo
	Case 0
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.tipovoo NOT IN ('3', '6', 'A', 'B') ) "
	Case 1
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.tipovoo IN ('0', '1', '4') ) "
	Case 2
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.tipovoo IN ('2', '5', '8', 'C', 'D') ) "
	Case 3
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.tipovoo IN ('7') ) "
	Case 4
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.tipovoo IN ('9') ) "
  End Select
  if (Not isVazio(strCodLinhaSelecionada)) then
		strSqlWhere2 = strSqlWhere2 & "   AND ( sig_diariovoo.codlinha = '" & strCodLinhaSelecionada & "') "
  end if

  if strDeDia <> "" and strDeMes <> "" and strDeAno <> "" and strAteDia <> "" and strAteMes <> "" and strAteAno <> "" then
    strSqlWhere2 = strSqlWhere2 & " AND ( sig_diariovoo.dtoper BETWEEN '" & strDeAno & "-" & strDeMes & "-" & strDeDia & "' AND '" & strAteAno & "-" & strAteMes & "-" & strAteDia & "') "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if

  strSqlGroup2 = " GROUP BY aeroporig.codiata, aeropdest.codiata "
  strSqlHaving2 = " HAVING SUM(sig_diariotrechocombtran.paxprimeira + sig_diariotrechocombtran.paxeconomica + sig_diariotrechocombtran.paxturismo + sig_diariotrechocombtran.paxespecial) > 0 "
  strSqlOrder = " ORDER BY codiatadest, codiataorig "
  strSqlOrder3 = " ORDER BY codiataorig, codiatadest "
  strSqlOrder4 = " ORDER BY codiataorig, codiatadest "

  ' ********************************************
  ' *** SELECT PARA OBTER SOMENTE AS ORIGENS ***
  ' ********************************************
  strSqlSelectOrigens = " SELECT DISTINCT aeroporig.codiata codiataorig "
  strSqlOrderOrigens = " ORDER BY codiataorig "

  ' *********************************************
  ' *** SELECT PARA OBTER SOMENTE OS DESTINOS ***
  ' *********************************************
  strSqlSelectDestinos = " SELECT DISTINCT aeropdest.codiata codiatadest "
  strSqlOrderDestinos = " ORDER BY codiatadest "

  strQuery1 = strSqlSelect1 & strSqlFrom1 & strSqlWhere1 & strSqlGroup1 & strSqlHaving1 & strSqlOrder
  strQuery2 = strSqlSelect2 & strSqlFrom2 & strSqlWhere2 & strSqlGroup2 & strSqlHaving2 & strSqlOrder
  strQuery3 = strSqlSelect1 & strSqlFrom1 & strSqlWhere1 & strSqlGroup1 & strSqlHaving1 & strSqlOrder3
  strQuery4 = strSqlSelect2 & strSqlFrom2 & strSqlWhere2 & strSqlGroup2 & strSqlHaving2 & strSqlOrder4
  strQueryOrigens = strSqlSelectOrigens & strSqlFrom1 & strSqlWhere1 & strSqlGroup1 & strSqlHaving1 & "UNION" & strSqlSelectOrigens & strSqlFrom2 & strSqlWhere2 & strSqlGroup2 & strSqlHaving2 & strSqlOrderOrigens
  strQueryDestinos = strSqlSelectDestinos & strSqlFrom1 & strSqlWhere1 & strSqlGroup1 & strSqlHaving1 & "UNION" & strSqlSelectDestinos & strSqlFrom2 & strSqlWhere2 & strSqlGroup2 & strSqlHaving2 & strSqlOrderDestinos

'  Response.Write(strQuery1)
'  Response.Write(strQuery2)
'  Response.End

  If blnFazConsulta Then
    Set ObjRs1 = Server.CreateObject("ADODB.Recordset")
    Set ObjRs2 = Server.CreateObject("ADODB.Recordset")
    Set ObjRs3 = Server.CreateObject("ADODB.Recordset")
    Set ObjRs4 = Server.CreateObject("ADODB.Recordset")
    Set ObjRsOrigens = Server.CreateObject("ADODB.Recordset")
    Set ObjRsDestinos = Server.CreateObject("ADODB.Recordset")

    objRs1.Open strQuery1, objConn1
    objRs2.Open strQuery2, objConn2
    objRs3.Open strQuery3, objConn3
    objRs4.Open strQuery4, objConn4

    objRsOrigens.Open strQueryOrigens, objConn5
    objRsDestinos.Open strQueryDestinos, objConn6
  End If

%>

<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="middle" width="30%" rowspan="2">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="40%" rowspan="2">
			<font size="4"><b>
				Origem e Destino
			</b></font>
		</td>
		<td class="corpo" align="right" valign="top" width="30%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
	</tr>
   <tr>
      <td></td>
      <td></td>
   </tr>
   <tr>   
      <td colspan="2">
      	<!--#include file="Menu.asp"-->
      </td>
   </tr>
   <tr>
   	<td>&nbsp;</td>
   </tr>
	<tr>
		<td align="right" colspan="3"><font size="2">Período: 
		<%
			if Request.form("txt_DeData") <> "" then
				Response.Write(strDeDia & "/" & strDeMes & "/" & strDeAno)
			else
				Response.Write("--/--/----")
			end if
			if Request.form("txt_AteData") <> "" then
				Response.Write(" até " & strAteDia & "/" & strAteMes & "/" & strAteAno)
			else
				Response.Write(" até --/--/----")
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
			<form id="frm_Filtro" name="frm_Filtro" method="post" action="relatoriomatrizpaxconsult.asp" onSubmit="Javascript: return VerificaCampos();">
<%
           ' Executa função para gravar na sig_usuariolog
           If f_grava_usuariolog( "I04", objConn1 ) > "" Then
              Response.End()
           End if
%>        
			<div>
				<label class="CORPO9">Período:&nbsp;</label><input type="text" name="txt_DeData"  size="11" maxlength="10" value="<%=Request.Form ("txt_DeData")%>" size="1" maxlength="2" id="txt_DeData" tabindex="1">
				&nbsp;
				<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
				<label class="CORPO9">&nbsp;at&eacute;&nbsp;</label><input type="text" name="txt_AteData"  size="11" maxlength="10" value="<%=Request.Form ("txt_AteData")%>" size="1" maxlength="2" id="txt_AteData" tabindex="2">
				&nbsp;
				<button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" " class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
				&nbsp;&nbsp;&nbsp;
				<label class="CORPO9">Tipo de Voo:&nbsp;</label>
				<select name="ddl_tipovoo" id="ddl_tipovoo" tabindex="3">
					<option value="0" <%if intTipoVoo = 0 then Response.Write("selected")%>>Todos</option>
					<option value="1" <%if intTipoVoo = 1 then Response.Write("selected")%>>Regulares</option>
					<option value="2" <%if intTipoVoo = 2 then Response.Write("selected")%>>Não-Regulares</option>
					<option value="3" <%if intTipoVoo = 3 then Response.Write("selected")%>>Frete</option>
					<option value="4" <%if intTipoVoo = 4 then Response.Write("selected")%>>Charter</option>
				</select>
				&nbsp;&nbsp;&nbsp;
				<label class="CORPO9">Linha:&nbsp;</label>
				<select name="ddl_Linha" id="ddl_Linha" tabindex="4">
<%
	Dim objConnLinha, objRsLinha, strQueryLinha

	if (isVazio(strCodLinhaSelecionada)) then
		Response.Write("<option value='' selected>Todas</option>")
	else
		Response.Write("<option value=''>Todas</option>")
	end if

	strQueryLinha = " SELECT codlinha, descrlinha FROM sig_linhavoo "
	
	Set objConnLinha = CreateObject("ADODB.CONNECTION")
	Set objRsLinha = Server.CreateObject("ADODB.Recordset")
	objConnLinha.Open(StringConexaoSqlServer)
	objConnLinha.Execute("SET DATEFORMAT ymd")
	objRsLinha.Open strQueryLinha, objConnLinha

	Do While NOT objRsLinha.EOF
		Dim strCodLinha, strDescrLinha
		strCodLinha = objRsLinha("codlinha")
		strDescrLinha = objRsLinha("descrlinha")
		
		if (strCodLinha = strCodLinhaSelecionada) then
			Response.Write("<option value='" & strCodLinha & "' selected>" & strDescrLinha & "</option>")
		else
			Response.Write("<option value='" & strCodLinha & "'>" & strDescrLinha & "</option>")
		end if
		objRsLinha.MoveNext
	Loop

	objConnLinha.close
	Set objRsLinha = Nothing
	Set objConnLinha = Nothing

%>
				</select>

				<br>
				<br>
				<input type="submit" name="submit" value="Pesquisar" tabindex="7">
			</div>
			</form>
		</td>
	</tr>
	</table>
</center>
<br>

<%
	Dim strOrigem1, strOrigem2, strOrigem3, strDestino1, strDestino2, strDestino3
	Dim strValorCelula, intValorCelula
	Dim intTotalComb, intTotalTran, intTotalGeral
	Dim intTotalCombGlobal, intTotalTranGlobal, intTotalGeralGlobal
	Dim intTotalCombColuna
	intTotalGeral = 0
	intTotalCombGlobal = 0
	intTotalTranGlobal = 0
	intTotalGeralGlobal = 0

	If blnFazConsulta and IsDate(Request.form("txt_DeData"))Then
%>
	<table border="1" cellpadding="0" cellspacing="0" ID="Table2">
		<tr>
			<th class="titulo">&nbsp;Aeroporto&nbsp;</th>
<%
		Do While Not ObjRsOrigens.Eof
%>
			<th class="titulo">&nbsp;<%=ObjRsOrigens("codiataorig")%>&nbsp;</th>
<%
			ObjRsOrigens.movenext
		Loop
%>
			<th class="titulo">Total</th>
		</tr>
<%
		Do While Not ObjRsDestinos.Eof
			intTotalComb = 0
			intTotalTran = 0
			strDestino1 = ObjRsDestinos("codiatadest")
%>

			<tr>
				<td class="titulo">&nbsp;<%=strDestino1%>&nbsp;</td>
				
<%
			If Not ObjRsOrigens.Bof Then ObjRsOrigens.MoveFirst
			Do While Not ObjRsOrigens.Eof
				strOrigem1 = ObjRsOrigens("codiataorig")
				If Not objRs1.Eof Then
					strOrigem2 = objRs1("codiataorig")
					strDestino2 = objRs1("codiatadest")
				Else
					strOrigem2 = ""
					strDestino2 = ""
				End If

				If Not objRs2.Eof Then
					strOrigem3 = objRs2("codiataorig")
					strDestino3 = objRs2("codiatadest")
				Else
					strOrigem3 = ""
					strDestino3 = ""
				End If

				If strOrigem1 = strOrigem2 AND strDestino1 = strDestino2 Then
					intTotalComb = intTotalComb + CInt(objRs1("totalpax"))
					If strOrigem1 = strOrigem3 AND strDestino1 = strDestino3 Then
						intTotalTran = intTotalTran + CInt(objRs2("totalpax"))
						intValorCelula = CInt(objRs1("totalpax")) + CInt(objRs2("totalpax"))
						strValorCelula = intValorCelula
						objRs2.MoveNext
					Else
						strValorCelula = CInt(objRs1("totalpax"))
					End If
%>
					<td class="corpo" nowrap align="center">&nbsp;<%=strValorCelula%>&nbsp;</td>
<%
					objRs1.MoveNext
				Else
					If strOrigem1 = strOrigem3 AND strDestino1 = strDestino3 Then
						intTotalTran = intTotalTran + CInt(objRs2("totalpax"))
						strValorCelula = CInt(objRs2("totalpax"))
						objRs2.MoveNext
%>
						<td class="corpo" nowrap align="center">&nbsp;<%=strValorCelula%>&nbsp;</td>
<%
					Else
%>
						<td class="corpo" nowrap align="center">&nbsp;</td>
<%
					End If
				End If
				ObjRsOrigens.movenext
			Loop
			intTotalGeral = intTotalComb + intTotalTran
			intTotalCombGlobal = intTotalCombGlobal + intTotalComb
			intTotalTranGlobal = intTotalTranGlobal + intTotalTran
			intTotalGeralGlobal = intTotalGeralGlobal + intTotalGeral
%>
				<td class="corpo" nowrap align="center" width="50"><b>&nbsp;<%=intTotalGeral%>&nbsp;</b></td>
			</tr>

<%
			ObjRsDestinos.movenext
		Loop

%>
			<tr>
				<td class="titulo">Total</td>
<%
		If Not ObjRsOrigens.Bof Then ObjRsOrigens.MoveFirst
		Do While Not ObjRsOrigens.Eof
			intTotalCombColuna = 0
			If Not ObjRs3.Eof Then
				Do While ObjRsOrigens("codiataorig") = ObjRs3("codiataorig")
					intTotalCombColuna = intTotalCombColuna + CInt(ObjRs3("totalpax"))
					ObjRs3.MoveNext
					If ObjRs3.Eof Then Exit Do
				Loop
			End If
			If Not ObjRs4.Eof Then
				Do While ObjRsOrigens("codiataorig") = ObjRs4("codiataorig")
					intTotalCombColuna = intTotalCombColuna + CInt(ObjRs4("totalpax"))
					ObjRs4.MoveNext
					If ObjRs4.Eof Then Exit Do
				Loop
			End If
%>
				<td class="corpo" nowrap align="center"><b>&nbsp;<%=intTotalCombColuna%>&nbsp;</b></td>
<%
			ObjRsOrigens.MoveNext
		Loop
%>
				<td class="corpo" nowrap align="center" width="50"><b>&nbsp;<%=intTotalGeralGlobal%>&nbsp;</b></td>
			</tr>

<%
		objRs1.Close
		objRs2.Close
		objRs3.Close
		objRs4.Close
		ObjRsOrigens.Close
		ObjRsDestinos.Close
	End If
%>
  </table>

</center>

<%
	objConn1.close
	objConn2.close
	objConn3.close
	objConn4.close
	objConn5.close
	objConn6.close
	Set objRs1 = Nothing
	Set objRs2 = Nothing
	Set objRs3 = Nothing
	Set objRs4 = Nothing
	Set ObjRsOrigens = Nothing
	Set ObjRsDestinos = Nothing
	Set objConn1 = Nothing
	Set objConn2 = Nothing
	Set objConn3 = Nothing
	Set objConn4 = Nothing
	Set objConn5 = Nothing
	Set objConn6 = Nothing
%>

<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div> 	


</body>

</html>