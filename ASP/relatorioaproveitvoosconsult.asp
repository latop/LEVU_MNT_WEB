<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<html>

<head>
	<title>Relatório de Aproveitamento de Etapas de Voo</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	<script src="javascript.js"></script>
   <script src="jquery-1.1.4.js" type="text/javascript"></script>
   <script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
   <script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
	<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
   <script type="text/javascript">  
		$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data1").mask("99/99/9999");
			$("#txt_Data2").mask("99/99/9999");
       });
		 
		 function VerificaCampos() {
				if (window.form1.txt_Data1.value == "") {
					alert('Preencha a 1º Data!');
					window.form1.txt_Data1.focus();
					return false;
				}
				else if (window.form1.txt_Data2.value == "") {
					alert('Preencha a 2º Data!');
					window.form1.txt_Data2.focus();
					return false;1
				}	
		 }	
	</script>	 
    <style type="text/css">
body {
	margin-left: 0px;
}
</style>

</head>

<body>
<%
  Dim objConn, objRs
  Dim strQuery, strSqlSelect, strSqlFrom, strSqlWhere, strSqlGroup, strSqlOrder
  Dim strOrigem, strDestino, strDeDia, strDeMes, strDeAno, strAteDia, strAteMes, strAteAno, intDiaSemana
  Dim blnFazConsulta
  blnFazConsulta = True

  strOrigem = UCase(Request.Form ("txt_Origem"))
  strDestino = UCase(Request.Form ("txt_Destino"))
  strDeDia = Day(Request.Form ("txt_Data1"))
  strDeMes = Month(Request.Form ("txt_Data1"))
  strDeAno = Year(Request.Form ("txt_Data1"))
  strAteDia = Day(Request.Form ("txt_Data2"))
  strAteMes = Month(Request.Form ("txt_Data2"))
  strAteAno = Year(Request.Form ("txt_Data2"))
  intDiaSemana = Request.Form ("ddl_DiaSemana")

  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"
  
  strSqlSelect = " SELECT "
  strSqlSelect = strSqlSelect & " ApOrig.codiata Codigo_IATA_Origem, "
  strSqlSelect = strSqlSelect & " ApDest.codiata Codigo_IATA_Destino, "
  strSqlSelect = strSqlSelect & " DV.nrvoo Numero_Voo, "
  strSqlSelect = strSqlSelect & " Fr.codfrota Codigo_Frota, "
  strSqlSelect = strSqlSelect & " Count(DV.nrvoo) Total_Operacoes, "
  strSqlSelect = strSqlSelect & " Sum(DTC.paxprimeira + DTC.paxeconomica + DTC.paxespecial + DTC.paxturismo + DTC.paxprimeiratran + DTC.paxeconomicatran + DTC.paxespecialtran + DTC.paxturismotran) Total_Passageiros, "
  strSqlSelect = strSqlSelect & " Sum(AN.capac_pax) Total_Oferta "

  strSqlFrom = " FROM "
  strSqlFrom = strSqlFrom & " sig_diariotrecho DT, "
  strSqlFrom = strSqlFrom & " sig_diariotrechocomb DTC, "
  strSqlFrom = strSqlFrom & " sig_diariovoo DV, "
  strSqlFrom = strSqlFrom & " sig_aeronave AN, "
  strSqlFrom = strSqlFrom & " sig_frota Fr, "
  strSqlFrom = strSqlFrom & " sig_aeroporto ApOrig, "
  strSqlFrom = strSqlFrom & " sig_aeroporto ApDest "

  strSqlWhere = " WHERE "
  strSqlWhere = strSqlWhere & "       ( DV.seqvoodia = DT.seqvoodia ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.seqvoodia = DTC.seqvoodia ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.seqtrecho = DTC.seqtrecho ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.prefixoaeronave = AN.prefixored ) "
  strSqlWhere = strSqlWhere & " AND   ( ApOrig.seqaeroporto = DT.seqaeroporig ) "
  strSqlWhere = strSqlWhere & " AND   ( ApDest.seqaeroporto = DTC.seqaeropdest ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.seqfrota = Fr.seqfrota ) "
  strSqlWhere = strSqlWhere & " AND   ( DV.statusvoo = 'N' ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.flgcancelado = 'N' ) "
  if strOrigem <> "" then
    strSqlWhere = strSqlWhere & " AND   ( ApOrig.codiata = '" & strOrigem & "' ) "
  end if
  if strDestino <> "" then
    strSqlWhere = strSqlWhere & " AND   ( ApDest.codiata = '" & strDestino & "' ) "
  end if
  if strDeDia <> "" and strDeMes <> "" and strDeAno <> "" and strAteDia <> "" and strAteMes <> "" and strAteAno <> "" then
    strSqlWhere = strSqlWhere & " AND   ( DV.dtoper BETWEEN '" & strDeAno & "-" & strDeMes & "-" & strDeDia & "' AND '" & strAteAno & "-" & strAteMes & "-" & strAteDia & "' ) "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if
  if intDiaSemana > 0 then
    strSqlWhere = strSqlWhere & " AND   DATEPART ( dw, DV.dtoper) = " & intDiaSemana
  end if

  strSqlGroup = " GROUP BY "
  strSqlGroup = strSqlGroup & " ApOrig.codiata, ApDest.codiata, DV.nrvoo, Fr.codfrota "

  strSqlOrder = " ORDER BY "
  strSqlOrder = strSqlOrder & " ApOrig.codiata, ApDest.codiata, DV.nrvoo, Fr.codfrota "

  strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlGroup & strSqlOrder

  If blnFazConsulta Then
    Set ObjRs = Server.CreateObject("ADODB.Recordset")
    objRs.Open strQuery, objConn
  End If

%>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Aproveitamento de<br>Etapas de Voo
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
		<td align="right" colspan="3"><font size="2">Período: 
		<%
			if Request.form("txt_Data1") <> "" then
				Response.Write(strDeDia & "/" & strDeMes & "/" & strDeAno)
			else
				Response.Write("--/--/----")
			end if
			if Request.form("txt_Data2") <> "" then
				Response.Write(" at&#233; " & strAteDia & "/" & strAteMes & "/" & strAteAno)
			else
				Response.Write(" at&#233; --/--/----")
			end if
		%>
		</td>
	</tr>
	</table>
</center>
<center>
	<table width="98%">
	<tr>
		<td>
			<form method="post" action="relatorioaproveitvoosconsult.asp" name="form1" id="form1" onSubmit="Javascript: return VerificaCampos();">
<%
           ' Executa função para gravar na sig_usuariolog
           If f_grava_usuariolog( "I01", objConn ) > "" Then
              Response.End()
           End if
%>
				<div>
					<label class="CORPO9">Origem:&nbsp;&nbsp;</label><input type="text" name="txt_Origem" value="<%=UCase(Request.Form ("txt_Origem"))%>" size="5" maxlength="3" style="text-transform:uppercase;" id="txt_Origem" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="1" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="CORPO9">Destino:&nbsp;&nbsp;</label><input type="text" name="txt_Destino" value="<%=UCase(Request.Form ("txt_Destino"))%>" size="5" maxlength="3" style="text-transform:uppercase;" id="txt_Destino" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="2" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="CORPO9">Período:&nbsp;&nbsp;</label>
					<label class="Corpo9">
					<input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9" Value="<%=Request.form("txt_Data1")%>" tabindex="3" />&nbsp;
					<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" tabindex="4" ></button> &nbsp;Até:</label>
					<label class="Corpo9">
					<input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9"  Value="<%=Request.form("txt_Data2")%>" tabindex="5" />&nbsp;
					<button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" tabindex="6" ></button></label>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="CORPO9">Dia da semana:&nbsp;&nbsp;</label>
					<select name="ddl_DiaSemana" id="ddl_DiaSemana" tabindex="9">
					<option value="0" <%if intDiaSemana = 0 then Response.Write("selected")%>>Todos</option>
					<option value="2" <%if intDiaSemana = 2 then Response.Write("selected")%>>Segunda-Feira</option>
					<option value="3" <%if intDiaSemana = 3 then Response.Write("selected")%>>Terça-Feira</option>
					<option value="4" <%if intDiaSemana = 4 then Response.Write("selected")%>>Quarta-Feira</option>
					<option value="5" <%if intDiaSemana = 5 then Response.Write("selected")%>>Quinta-Feira</option>
					<option value="6" <%if intDiaSemana = 6 then Response.Write("selected")%>>Sexta-Feira</option>
					<option value="7" <%if intDiaSemana = 7 then Response.Write("selected")%>>Sábado</option>
					<option value="1" <%if intDiaSemana = 1 then Response.Write("selected")%>>Domingo</option>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="submit" name="submit" value="Pesquisar" tabindex="10">
				</div>
			</form>
		</td>
	</tr>
	</table>
</center>
<center>
	<table width="98%" border="1" cellpadding="0" cellspacing="0" ID="Table2">
		<tr bgcolor="#AAAAAA" class="CORPO9">
			<th>Origem</th>
			<th>Destino</th>
			<th>Voo</th>
			<th>Frota</th>
			<th>Total Oper</th>
			<th>PAX Embarcado</th>
			<th>Total Ofer</th>
			<th align=right>Aproveitamento&nbsp;&nbsp;&nbsp;&nbsp;</th>
		</tr>
<%
  Dim CodOrigemAtual, CodOrigemNovo, Cor1, Cor2
  Dim Cor, CorAtual

  Cor1 = "#FFFFFF"
  Cor2 = "#EEEEEE"

  Cor = Cor1
  CorAtual = Cor1

  If blnFazConsulta Then
    If (Not ObjRs.Eof) Then
		CodOrigemAtual = ObjRs("Codigo_IATA_Origem")

		Dim intTotalPassageirosGlobal, intTotalOfertaGlobal, AproveitamentoGlobal, intTotalOperacoesGlobal
		intTotalPassageirosGlobal = CInt(0)
		intTotalOfertaGlobal = CInt(0)
		AproveitamentoGlobal = CInt(0)
		intTotalOperacoesGlobal = CInt(0)

		Do While Not ObjRs.Eof
			Dim intTotalPassageiros, intTotalOferta, Aproveitamento, intTotalOperacoes

			CodOrigemNovo = ObjRs("Codigo_IATA_Origem")
			If (CodOrigemNovo <> CodOrigemAtual) Then
			If (CorAtual = Cor1) Then
				CodOrigemAtual = CodOrigemNovo
				Cor = Cor2
				CorAtual = Cor2
			ElseIf (CorAtual = Cor2) Then
				CodOrigemAtual = CodOrigemNovo
				Cor = Cor1
				CorAtual = Cor1
			End If
			End If

			intTotalPassageiros = CInt(ObjRs("Total_Passageiros"))
			intTotalOferta = CInt(ObjRs("Total_Oferta"))
			intTotalOperacoes = CInt(ObjRs("Total_Operacoes"))

			if (intTotalOferta = 0) then
				Aproveitamento = CInt(100)
			else
				Aproveitamento = (CInt(10000*(intTotalPassageiros/intTotalOferta)))/100
			end if

			intTotalPassageirosGlobal = intTotalPassageirosGlobal + intTotalPassageiros
			intTotalOfertaGlobal = intTotalOfertaGlobal + intTotalOferta
			intTotalOperacoesGlobal = intTotalOperacoesGlobal + intTotalOperacoes

%>

			<tr bgcolor=<%=Cor%>>
				<td class="corpo" nowrap align="center">
				<%=ObjRs("Codigo_IATA_Origem")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRs("Codigo_IATA_Destino")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRs("Numero_Voo")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=ObjRs("Codigo_Frota")%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=intTotalOperacoes%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=intTotalPassageiros%> &nbsp;</td>
				<td class="corpo" nowrap align="center">
				<%=intTotalOferta%> &nbsp;</td>
				<td class="corpo" nowrap align="right" width="140">
				<%=FormatNumber(Aproveitamento,2)%>&nbsp;%&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>

<%
			ObjRs.movenext
		loop

		if (intTotalOfertaGlobal = 0) then
			AproveitamentoGlobal = CInt(100)
		else
			AproveitamentoGlobal = (CInt(10000*(intTotalPassageirosGlobal/intTotalOfertaGlobal)))/100
		end if
%>
		<tr class="CORPO9">
			<th style="text-align: right; padding-right: 10px; background-color: #AAAAAA;" colspan="4">Total:</th>
			<th class="corpo"><%=intTotalOperacoesGlobal%> &nbsp;</th>
			<th class="corpo"><%=intTotalPassageirosGlobal%> &nbsp;</th>
			<th class="corpo"><%=intTotalOfertaGlobal%> &nbsp;</th>
			<th class="corpo" style="text-align:right;"><%=FormatNumber(AproveitamentoGlobal,2)%>&nbsp;%&nbsp;&nbsp;&nbsp;&nbsp;</th>
		</tr>
<%

	End If
	objRs.Close
  End If

%>
		<tr>
			<th colspan="8"></th>
		</tr>
	</table>
</center>

<%
  objConn.close
  Set objRs = Nothing
  Set objConn = Nothing
%>

<script language="javascript">
	document.all('txt_Origem').focus();
</script>
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div>
</body>

</html>