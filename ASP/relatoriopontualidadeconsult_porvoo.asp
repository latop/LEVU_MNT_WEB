<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<html>

<head>
	<title>Relatório de Pontualidade e Regularidade dos Voos</title>
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
  Dim objConn, objRs
  Dim strQuery, strSqlSelect, strSqlFrom, strSqlWhere, strSqlOrder
  Dim strDeDia, strDeMes, strDeAno, strAteDia, strAteMes, strAteAno
  Dim blnFazConsulta
  blnFazConsulta = True

  strDeDia = day(Request.Form("txt_DeData"))
  strDeMes = month(Request.Form("txt_DeData"))
  strDeAno = year(Request.Form("txt_DeData"))
  strAteDia = day(Request.Form("txt_AteData"))
  strAteMes = month(Request.Form("txt_AteData"))
  strAteAno = year(Request.Form("txt_AteData"))

  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"
  
  strSqlSelect = " SELECT "
  strSqlSelect = strSqlSelect & "        sig_diariovoo.dtoper, "
  strSqlSelect = strSqlSelect & "        sig_diariovoo.nrvoo, "
  strSqlSelect = strSqlSelect & "        qtdnaoreg = CASE "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt1, sig_justificativa sj1 "
  strSqlSelect = strSqlSelect & "                WHERE sdt1.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt1.idjustificativa = sj1.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj1.flgpenalizareg = 'S' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt1.flghotran = 'N' AND sdt1.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt1.flghotran = 'S' AND sdt1.flgcancelado = 'S') ) ) > 0 THEN 1 "
  strSqlSelect = strSqlSelect & "          ELSE 0 "
  strSqlSelect = strSqlSelect & "        END, "
  strSqlSelect = strSqlSelect & "        qtdnaoregnaopen = CASE "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt1, sig_justificativa sj1 "
  strSqlSelect = strSqlSelect & "                WHERE sdt1.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt1.idjustificativa = sj1.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj1.flgpenalizareg = 'S' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt1.flghotran = 'N' AND sdt1.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt1.flghotran = 'S' AND sdt1.flgcancelado = 'S') ) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt3, sig_justificativa sj3 "
  strSqlSelect = strSqlSelect & "                WHERE sdt3.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt3.idjustificativa = sj3.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj3.flgpenalizareg = 'N' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt3.flghotran = 'N' AND sdt3.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt3.flghotran = 'S' AND sdt3.flgcancelado = 'S') ) ) > 0 THEN 1 "
  strSqlSelect = strSqlSelect & "          ELSE 0 "
  strSqlSelect = strSqlSelect & "        END, "
  strSqlSelect = strSqlSelect & "        qtdnaopon = CASE "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt1, sig_justificativa sj1 "
  strSqlSelect = strSqlSelect & "                WHERE sdt1.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt1.idjustificativa = sj1.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj1.flgpenalizareg = 'S' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt1.flghotran = 'N' AND sdt1.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt1.flghotran = 'S' AND sdt1.flgcancelado = 'S') ) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt3, sig_justificativa sj3 "
  strSqlSelect = strSqlSelect & "                WHERE sdt3.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt3.idjustificativa = sj3.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj3.flgpenalizareg = 'N' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt3.flghotran = 'N' AND sdt3.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt3.flghotran = 'S' AND sdt3.flgcancelado = 'S') ) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt2, sig_justificativa sj2 "
  strSqlSelect = strSqlSelect & "                WHERE sdt2.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt2.idjustificativa = sj2.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj2.flgpenalizapon = 'S' "
  strSqlSelect = strSqlSelect & "                  AND sdt2.flghotran = 'S' "
  strSqlSelect = strSqlSelect & "                  AND sdt2.flgcancelado = 'N' "
  strSqlSelect = strSqlSelect & "                  AND (sdt2.atzdec < -10 OR sdt2.atzdec > 15 OR sdt2.atzpou > 15) ) > 0 THEN 1 "
  strSqlSelect = strSqlSelect & "          ELSE 0 "
  strSqlSelect = strSqlSelect & "        END, "
  strSqlSelect = strSqlSelect & "        qtdnaoponnaopen = CASE "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt1, sig_justificativa sj1 "
  strSqlSelect = strSqlSelect & "                WHERE sdt1.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt1.idjustificativa = sj1.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj1.flgpenalizareg = 'S' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt1.flghotran = 'N' AND sdt1.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt1.flghotran = 'S' AND sdt1.flgcancelado = 'S') ) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt3, sig_justificativa sj3 "
  strSqlSelect = strSqlSelect & "                WHERE sdt3.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt3.idjustificativa = sj3.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj3.flgpenalizareg = 'N' "
  strSqlSelect = strSqlSelect & "                  AND ( (sdt3.flghotran = 'N' AND sdt3.flgcancelado = 'N') OR "
  strSqlSelect = strSqlSelect & "                        (sdt3.flghotran = 'S' AND sdt3.flgcancelado = 'S') ) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt2, sig_justificativa sj2 "
  strSqlSelect = strSqlSelect & "                WHERE sdt2.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt2.idjustificativa = sj2.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj2.flgpenalizapon = 'S' "
  strSqlSelect = strSqlSelect & "                  AND sdt2.flghotran = 'S' "
  strSqlSelect = strSqlSelect & "                  AND sdt2.flgcancelado = 'N' "
  strSqlSelect = strSqlSelect & "                  AND (sdt2.atzdec < -10 OR sdt2.atzdec > 15 OR sdt2.atzpou > 15) ) > 0 THEN 0 "
  strSqlSelect = strSqlSelect & "          WHEN (SELECT Count(*) FROM sig_diariotrecho sdt4, sig_justificativa sj4 "
  strSqlSelect = strSqlSelect & "                WHERE sdt4.seqvoodia = sig_diariovoo.seqvoodia "
  strSqlSelect = strSqlSelect & "                  AND sdt4.idjustificativa = sj4.idjustificativa "
  strSqlSelect = strSqlSelect & "                  AND sj4.flgpenalizapon = 'N' "
  strSqlSelect = strSqlSelect & "                  AND sdt4.flghotran = 'S' "
  strSqlSelect = strSqlSelect & "                  AND sdt4.flgcancelado = 'N' "
  strSqlSelect = strSqlSelect & "                  AND (sdt4.atzdec < -10 OR sdt4.atzdec > 15 OR sdt4.atzpou > 15)) > 0 THEN 1 "
  strSqlSelect = strSqlSelect & "          ELSE 0 "
  strSqlSelect = strSqlSelect & "        END "

  strSqlFrom = " FROM "
  strSqlFrom = strSqlFrom & " sig_diariovoo "

  strSqlWhere = " WHERE "
  strSqlWhere = strSqlWhere & "       sig_diariovoo.tipovoo = '0' "
  if strDeDia <> "" and strDeMes <> "" and strDeAno <> "" and strAteDia <> "" and strAteMes <> "" and strAteAno <> "" then
    strSqlWhere = strSqlWhere & " AND sig_diariovoo.dtoper BETWEEN '" & strDeAno & "-" & strDeMes & "-" & strDeDia & "' AND '" & strAteAno & "-" & strAteMes & "-" & strAteDia & "' "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if

  strSqlOrder = " ORDER BY "
  strSqlOrder = strSqlOrder & " sig_diariovoo.nrvoo, sig_diariovoo.dtoper "

  strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

  If blnFazConsulta Then
    Set ObjRs = Server.CreateObject("ADODB.Recordset")
    objRs.Open strQuery, objConn
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
				Pontualidade e Regularidade<br>dos Voos
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
			if Request.Form("txt_DeData") <> "" then
				Response.Write(strDeDia & "/" & strDeMes & "/" & strDeAno)
			else
				Response.Write("--/--/----")
			end if
			if Request.Form("txt_AteData") <> "" then
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
			<form id="frm_Filtro" method="post" action="relatoriopontualidadeconsult.asp" onSubmit="Javascript: return VerificaCampos();">
<%
           ' Executa função para gravar na sig_usuariolog
           If f_grava_usuariolog( "I03", objConn ) > "" Then
              Response.End()
           End if
%>        
			<div>
				<label class="CORPO9">Período:&nbsp;</label><input type="text" name="txt_DeData"  size="11" maxlength="10" value="<%=Request.Form ("txt_DeData")%>" size="1" maxlength="2" id="txt_DeData" tabindex="1">
                
				&nbsp;<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>

				<label class="CORPO9">&nbsp;at&eacute;&nbsp;</label><input type="text" name="txt_AteData"  size="11" maxlength="10" value="<%=Request.Form ("txt_AteData")%>" size="1" maxlength="2" id="txt_AteData" tabindex="2">

				&nbsp;<button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" " class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>

				<br><br>
				<input type="submit" name="submit" value="Pesquisar" tabindex="7">
			</div>
			</form>
		</td>
	</tr>
	</table>
</center>
<br>
<center>
  <table width="98%" border="1" cellpadding="0" cellspacing="0" ID="Table2">
    <tr bgcolor="#AAAAAA" class="CORPO9">
      <th rowspan="2" width="70">Voo</th>
      <th rowspan="2">Qtd. Operações<br>Previstas</th>
      <th colspan="2">Operações Não Regulares</th>
      <th colspan="2">Operações Não Pontuais</th>
      <th colspan="3">Índice</th>
    </tr>
    <tr bgcolor="#AAAAAA" class="CORPO9">
      <th>Penalizadas</th>
      <th>Não Penalizadas</th>
      <th>Penalizadas</th>
      <th>Não Penalizadas</th>
      <th align="right">Regularidade&nbsp;&nbsp;&nbsp;</th>
      <th align="right">Pontualidade&nbsp;&nbsp;&nbsp;</th>
      <th align="right">Eficiência&nbsp;&nbsp;&nbsp;</th>
    </tr>

<%
  Dim NumVooAtual, NumVooNovo, Cor1, Cor2, Cor, i
  Dim TotOperacoes, TotQtdNaoReg, TotQtdNaoRegNaoPen, TotQtdNaoPon, TotQtdNaoPonNaoPen
  Dim IndReg, IndPont, IndEfic
  Dim TotOperacoesGeral, TotQtdNaoRegGeral, TotQtdNaoRegNaoPenGeral, TotQtdNaoPonGeral, TotQtdNaoPonNaoPenGeral
  Dim IndRegGeral, IndPontGeral, IndEficGeral

  TotOperacoes = 0
  TotQtdNaoReg = 0
  TotQtdNaoRegNaoPen = 0
  TotQtdNaoPon = 0
  TotQtdNaoPonNaoPen = 0

  TotOperacoesGeral = 0
  TotQtdNaoRegGeral = 0
  TotQtdNaoRegNaoPenGeral = 0
  TotQtdNaoPonGeral = 0
  TotQtdNaoPonNaoPenGeral = 0

  i = 0

  Cor1 = "#FFFFFF"
  Cor2 = "#EEEEEE"

  Cor = Cor1

  If blnFazConsulta Then
    If (Not ObjRs.Eof) Then
		NumVooAtual = CInt(ObjRs("nrvoo"))

		Do
			If (Not ObjRs.Eof) Then NumVooNovo = CInt(ObjRs("nrvoo"))

			If (NumVooNovo <> NumVooAtual) OR (ObjRs.Eof) Then
				IndReg = FormatNumber(((TotOperacoes - TotQtdNaoReg) / TotOperacoes) * 100, 2)
				IndPont = FormatNumber(((TotOperacoes - TotQtdNaoPon) / TotOperacoes) * 100, 2)
				IndEfic = FormatNumber((IndReg * IndPont) / 100, 2)

				TotOperacoesGeral = TotOperacoesGeral + TotOperacoes
				TotQtdNaoRegGeral = TotQtdNaoRegGeral + TotQtdNaoReg
				TotQtdNaoRegNaoPenGeral = TotQtdNaoRegNaoPenGeral + TotQtdNaoRegNaoPen
				TotQtdNaoPonGeral = TotQtdNaoPonGeral + TotQtdNaoPon
				TotQtdNaoPonNaoPenGeral = TotQtdNaoPonNaoPenGeral + TotQtdNaoPonNaoPen

%>

				<tr bgcolor=<%If (i MOD 2 = 0) Then Response.Write(Cor1) Else Response.Write(Cor2)%>>
					<td class="corpo" nowrap align="center"><%=NumVooAtual%>&nbsp;</td>
					<td class="corpo" nowrap align="center"><%=TotOperacoes%>&nbsp;</td>
					<td class="corpo" nowrap align="center"><%=TotQtdNaoReg%>&nbsp;</td>
					<td class="corpo" nowrap align="center"><%=TotQtdNaoRegNaoPen%>&nbsp;</td>
					<td class="corpo" nowrap align="center"><%=TotQtdNaoPon%>&nbsp;</td>
					<td class="corpo" nowrap align="center"><%=TotQtdNaoPonNaoPen%>&nbsp;</td>
					<td class="corpo" nowrap align="right"><%=IndReg%>&nbsp;%&nbsp;&nbsp;&nbsp;</td>
					<td class="corpo" nowrap align="right"><%=IndPont%>&nbsp;%&nbsp;&nbsp;&nbsp;</td>
					<td class="corpo" nowrap align="right"><%=IndEfic%>&nbsp;%&nbsp;&nbsp;&nbsp;</td>
				</tr>

<%
				NumVooAtual = NumVooNovo
				If (Not ObjRs.Eof) Then 
					TotOperacoes = 1
					TotQtdNaoReg = CInt(ObjRs("qtdnaoreg"))
					TotQtdNaoRegNaoPen = CInt(ObjRs("qtdnaoregnaopen"))
					TotQtdNaoPon = CInt(ObjRs("qtdnaopon"))
					TotQtdNaoPonNaoPen = CInt(ObjRs("qtdnaoponnaopen"))
				End If
				i = i + 1
			Else
				TotOperacoes = TotOperacoes + 1
				TotQtdNaoReg = TotQtdNaoReg + CInt(ObjRs("qtdnaoreg"))
				TotQtdNaoRegNaoPen = TotQtdNaoRegNaoPen + CInt(ObjRs("qtdnaoregnaopen"))
				TotQtdNaoPon = TotQtdNaoPon + CInt(ObjRs("qtdnaopon"))
				TotQtdNaoPonNaoPen = TotQtdNaoPonNaoPen + CInt(ObjRs("qtdnaoponnaopen"))
			End If

			If (ObjRs.Eof) Then Exit Do
			ObjRs.movenext
			
		Loop

		IndRegGeral = FormatNumber(((TotOperacoesGeral - TotQtdNaoRegGeral) / TotOperacoesGeral) * 100, 2)
		IndPontGeral = FormatNumber(((TotOperacoesGeral - TotQtdNaoPonGeral) / TotOperacoesGeral) * 100, 2)
		IndEficGeral = FormatNumber((IndRegGeral * IndPontGeral) / 100, 2)
%>

		<tr bgcolor=<%If (i MOD 2 = 0) Then Response.Write(Cor1) Else Response.Write(Cor2)%>>
			<td class="corpo" nowrap align="center"><b>Total&nbsp;</b></td>
			<td class="corpo" nowrap align="center"><b><%=TotOperacoesGeral%>&nbsp;</b></td>
			<td class="corpo" nowrap align="center"><b><%=TotQtdNaoRegGeral%>&nbsp;</b></td>
			<td class="corpo" nowrap align="center"><b><%=TotQtdNaoRegNaoPenGeral%>&nbsp;</b></td>
			<td class="corpo" nowrap align="center"><b><%=TotQtdNaoPonGeral%>&nbsp;</b></td>
			<td class="corpo" nowrap align="center"><b><%=TotQtdNaoPonNaoPenGeral%>&nbsp;</b></td>
			<td class="corpo" nowrap align="right"><b><%=IndRegGeral%>&nbsp;%&nbsp;&nbsp;&nbsp;</b></td>
			<td class="corpo" nowrap align="right"><b><%=IndPontGeral%>&nbsp;%&nbsp;&nbsp;&nbsp;</b></td>
			<td class="corpo" nowrap align="right"><b><%=IndEficGeral%>&nbsp;%&nbsp;&nbsp;&nbsp;</b></td>
		</tr>

<%
	End If
	objRs.Close
  End If
%>

    <tr>
      <th colspan="9"></th>
    </tr>
  </table>
</center>

<%
  objConn.close
  Set objRs = Nothing
  Set objConn = Nothing
%>

<script language="javascript">
	document.all('txt_DeData').focus();
</script>
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div> 	

</body>

</html>