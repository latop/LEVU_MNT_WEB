<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SIGLA - Despesas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<meta http-equiv='Page-Exit' content='blendTrans(Duration=1)'>
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<script src="javascript.js"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.tablesorter.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>

<script language="javascript" >
		/* Mscara da data */
		$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data1").mask("99/99/9999");
			$("#txt_Data2").mask("99/99/9999");
			
		});
		
		
		$(document).ready(function() {
			$('table#Table2 tbody  tr').hover(function(){
				$(this).css("background-color","#CCFFFF");
				}, function(){
				$(this).css("background-color","");
			});
		});
		$(document).ready(function() {
			$('#Table2').tableSorter();	 
		});
		function VerificaCampos() {
				
				if ($("#txt_Data1").val() == '' ) {
					alert("Preencha a primeira data!");
					$("#txt_Data1").focus();
					return false;
				}
		}		
		function ValidaData(dval1,dval2) {	
			var reDate5 = /^((0[1-9]|[12]\d)\/(0[1-9]|1[0-2])|30\/(0[13-9]|1[0-2])|31\/(0[13578]|1[02]))\/\d{4}$/;
			var campo1
			var campo2
			
			if (reDate5.test(dval1)){
				campo1 = "true"
			}else{
				alert('Digite uma data Valida!');
				$("#txt_Data1").focus();
				campo1 = "false"
			}
			if (campo1 == "true") {
				return true;
			}else{
				return false;
			}		
		}
			
</script>
</head>
<body bgcolor="white" link="blue">
<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>

<STYLE type="text/css">
 TABLE { empty-cells: show; 
 }
 body { margin-left: 0px;
 }
 </style>
<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
      <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
      	<img src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center" width="30%" rowspan="2">
      	<font size="4"><b>
      	&nbsp;Consulta de Despesas
     	 	</b></font>
      </td>
      <td class="corpo" align="right" valign="top" width="35%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
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
<%
	Dim Conn
	Dim sSql
	Dim SqlSelectAeroporto
	Dim intSeqUsuarioAerop
	Dim intSeqAeroporto
	Dim Rs
	Dim RsAeroporto
	Dim ll_dia1, ll_mes1, ll_ano1
	Dim ll_dia2, ll_mes2, ll_ano2
	Dim Data1, Data2
	Dim ls_Voltar 
	
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"
	
	Data1 = Request.Form("txt_Data1")
	Data2 = Request.Form("txt_Data2")

	ll_dia1 = Day(Data1)
	ll_mes1 = Month(Data1)
	ll_ano1 = Year(Data1)		
	If ISDATE(Data2) Then
		ll_dia2 = Day(Data2)
		ll_mes2 = Month(Data2)
		ll_ano2 = Year(Data2)	
	End IF
	
	ls_Voltar = Request.QueryString("voltar")
	
	If ls_Voltar = "voltar" Then
		ll_dia1 = Day(Request.QueryString("txt_Data1"))
		ll_mes1 = Month(Request.QueryString("txt_Data1"))
		ll_ano1 = Year(Request.QueryString("txt_Data1"))
		If ISDATE(Request.QueryString("txt_Data2")) Then
			ll_dia2 = Day(Request.QueryString("txt_Data2"))
			ll_mes2 = Month(Request.QueryString("txt_Data2"))
			ll_ano2 = Year(Request.QueryString("txt_Data2"))
		End IF
	end if	
		
	intSeqUsuarioAerop = 0

	Dim intDominio
	intDominio = Session("dominio")
	if (intDominio = 3) then 'Aeroporto
		intSeqUsuarioAerop = Session("member")
	end if
	
	If IsDate(ll_ano1&"/"&ll_mes1&"/"&ll_dia1) then
		Data1 = ll_ano1&"/"&ll_mes1&"/"&ll_dia1
		Data2 = ll_ano2&"/"&ll_mes2&"/"&ll_dia2
	
		sSql = "Select * from sig_liberacaodespesa where sequsuarioaerop = " & intSeqUsuarioAerop & " "	
		If isDate(ll_ano2&"/"&ll_mes2&"/"&ll_dia2) Then
			sSql = sSql & " And dthrregistro >= '" & Data1 & "' And dthrregistro <= '" & Data2 & " 23:59:59' "
		Else
			sSql = sSql & " And dthrregistro >= '" & Data1 & "' And dthrregistro <= '" & Data1 & " 23:59:59' "
		End If	
		sSql = sSql & "Order by seqdespesa"

		set Rs = conn.Execute(Ssql)

	End if
	
%>
<center>
<table width="95%">
<form method= "post"  ACTION="desp_consultadespesas.asp" Name= "Ordena_data"  onsubmit="return VerificaCampos();">

<tr>
  <td class='CORPO10' align='left' valign='bottom' colspan='3'>
    <div>
        <label>
        	Per&iacute;odo:&nbsp;
        </label>  
        <label class="Corpo9">
            <input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9" Value="<% if ls_Voltar <> "voltar" then  response.Write(trim(Request.Form("txt_Data1"))) else response.Write(Right("00" & Day(Request.QueryString("txt_Data1")),2) & "/" & Right("00" & Month(Request.QueryString("txt_Data1")),2) & "/" & year(Request.QueryString("txt_Data1"))) end If %>"/>&nbsp;
            <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button> &nbsp;At&eacute;:
		</label>
        <label class="Corpo9">
            <input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9"  Value="<% If ISDATE(Request.QueryString("txt_Data2")) or ISDATE(Request.form("txt_Data2"))  Then  Response.Write(Right("00"&ll_dia2,2) & "/" & Right("00"&ll_mes2,2) & "/" & ll_ano2) End IF %>"/>&nbsp;
            <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
		</label>
        &nbsp;<input type= "submit" value="Pesquisar" class="botao1" onclick='return ValidaData(getElementById("txt_Data1").value , getElementById("txt_Data2").value);' >
        <% If ll_ano1 = "1899" Then %>
            &nbsp;<input type="button" value="Nova Despesa" class="botao1" onClick="location.href='desp_novadespesa.asp'"/>
        <% Else %>
            &nbsp;<input type="button" value="Nova Despesa" class="botao1" onClick="location.href='desp_novadespesa.asp?data1=<%=ll_dia1 & "/" & ll_mes1 & "/" & ll_ano1%>&data2=<%=ll_dia2 & "/" & ll_mes2 & "/" & ll_ano2%>'"/>
        <% End IF %>    
    </div>
  </td>
</form>
</table>
</center>
<br />
<center>
<table align="center" border=1 cellpadding="0" cellspacing="0" ID="Table2" width="100%">
<thead>    
        <tr bgcolor='#AAAAAA' align='center' style='cursor:pointer;cursor:hand'>
          <th width="3%" class="CORPO9">N&deg;</th>
          <th width="12%" class="CORPO9">Data de Registro</th>
          <th width="13%" class="CORPO9">Tipo</th>
	   	  <th width="34%" class="CORPO9">Motivo</th>
          <th width="9%" class="CORPO9">Valor</th>
          <th width="14%" class="CORPO9">Situa&ccedil;&atilde;o</th>
          <th width="15%" class="CORPO9">Data de Liberação</th>
    </tr>
    </thead>
    <tbody>    
<%
		Do While Not Rs.Eof	  
			Response.Write("<tr class='corpo8' align='center' style='cursor:pointer;cursor:hand' onclick='location.href=&quot;desp_detalhesdespesa.asp?data1=" & ll_dia1 &"/" & ll_mes1 & "/" & ll_ano1 & "&data2= " & ll_dia2 &"/" & ll_mes2 & "/" & ll_ano2 &  "&seqdespesa= " & Rs("seqdespesa") & " &quot; ' ")
			Response.Write("    <a href = 'desp_detalhesdespesa.asp?data1=" & ll_dia1 &"/" & ll_mes1 & "/" & ll_ano1 & "&data2= " & ll_dia2 &"/" & ll_mes2 & "/" & ll_ano2 &  "&seqdespesa= " & Rs("seqdespesa") & "'> ")
			Response.Write(" 	<td>")
			Response.Write( 		Rs("seqdespesa") )
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write(			Right("00"&Day(Rs("dthrregistro")),2) & "/" & Right("00"&month(Rs("dthrregistro")),2) & "/" & Year(Rs("dthrregistro")) & " " & Right("00"&Hour(Rs("dthrregistro")),2) & ":" & Right("00"&Minute(Rs("dthrregistro")),2))
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write(			Rs("tipodespesa"))
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write(			Rs("motivo")&"&nbsp;")
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			if Not IsNull(Rs("valor")) and Not IsEmpty(Rs("valor")) and Rs("valor") <> "" then
				Response.Write(			FormatCurrency(Rs("valor")))
			else
				Response.Write(			"&nbsp;")
			end if
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			If Rs("situacao") = "P" then
				Response.Write("		<font color='blue'><b>Pendente</b></font>")
			else
				If Rs("situacao") = "N" then
					Response.Write("		<font color='Red'><b>Negado</b></font>")
				else
					Response.Write("		<font color='green'><b>Aprovado</b></font>")	
				End If					
			End If
			Response.Write(" 	</td>")
			Response.Write("	</a>")
			Response.Write(" 	<td>")
			If NOT ISNULL(Rs("dthrliberacao")) Then
				Response.Write(			Right("00"&Day(Rs("dthrliberacao")),2) & "/" & Right("00"&month(Rs("dthrliberacao")),2) & "/" & Year(Rs("dthrliberacao")) & " " &  Right("00"&Hour(Rs("dthrliberacao")),2) & ":" &  Right("00"&Minute(Rs("dthrliberacao")),2) &"&nbsp;")
			Else
				Response.Write("&nbsp;")
			End IF		
			Response.Write(" 	</td>")
			Response.Write("</tr>")
			Rs.movenext
		LOOP	
%>		
	</tbody>
</table>   
</center> 
<br>
<script language="javascript">
	document.all('txt_Data1').focus();
</script>
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div>
</body>
</html>
