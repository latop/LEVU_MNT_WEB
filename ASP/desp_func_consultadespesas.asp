<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="libgeral.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SIGLA - Consulta de Despesas</title>
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

		function checkAll( n ) {
			var f = document.Ordena_data;
			var c = f.toggle.checked;
			var n2 = 0;
			for (i=0; i < n; i++) {
				cb = eval( 'f.cb' + i );
				if (cb) {
					cb.checked = c;
					n2++;
				}
			}
			if (c) {
				document.Ordena_data.boxchecked.value = n2;
			} else {
				document.Ordena_data.boxchecked.value = 0;
			}
		}
		
		 function atualizarStatus( nome, quantidade ) {  
			 var selecionados = "";  
			 var status = document.getElementById("ststatus").value
			 // ITERA BASEADO NA QUANTIDADE DE ELEMENTOS  
			 for ( i = 0; i < quantidade; i++ ) {  
		
				 // OBTÉM CADA ELEMENTO PELO ID  
				 checkBox = document.getElementById( nome + ( i + 1 ) );  
				 
				 // SE O CHECKBOX ESTIVER MARCADO, ADICIONA MAIS UMA LINHA NA STRING DE SAIDA.  
				 if ( checkBox.checked ) {  
					 selecionados += "," + checkBox.value;   
				 }  
			 }  
			 // TIRA A PRIMEIRA VIRGULA DA VARIAVEL  
			 selecionados=selecionados.substring(1);
		
			 if (selecionados == "") {
				alert('Nenhum registro foi selecionado !');
			 } else {
				if (status == -1){
				   alert('Nenhum Status foi selecionado !');
				}else{
				if(confirm("Deseja atualizar todos os registros selecionados?")) {
					document.location.href = 'desp_func_consultadespesas.asp?voltar=voltar&txt_Data1='+document.getElementById("txt_Data1").value+'&txt_Data2='+document.getElementById("txt_Data2").value+'&atualizarSelecionados=sim&Status='+status+'&selecionados=' + selecionados;
				}
			 }
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
		
		function VerificaCampos() {				
			if ($("#txt_Data1").val() == '' ) {
				alert("Preencha a primeira data!");
				$("#txt_Data1").focus();
				return false;
			}
		}		

</script>
</head>

<body>
<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
   <tr>
      <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
         <img src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center" width="30%" rowspan="2">
         <font size="4"><b>
            Consulta de Despesas
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
<%
	Dim Conn
	Dim sSql
	Dim SqlSelectAeroporto
	Dim intSeqUsuario
	Dim intSeqAeroporto
	Dim Rs
	Dim RsAeroporto
	Dim ll_dia1, ll_mes1, ll_ano1
	Dim ll_dia2, ll_mes2, ll_ano2
	Dim Data1, Data2
	Dim ls_Voltar
	Dim ll_cont
	Dim RsUpdate
	Dim sSqlUpdate
	Dim ls_Status
	
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
		End If
	end if	
	
	If IsDate(ll_ano1&"/"&ll_mes1&"/"&ll_dia1) then 
	
		Data1 = ll_ano1&"/"&ll_mes1&"/"&ll_dia1
		Data2 = ll_ano2&"/"&ll_mes2&"/"&ll_dia2
	
		sSql = 		  "Select sig_liberacaodespesa.sequsuarioaerop, sig_aeroporto.codiata, sig_aeroporto.seqaeroporto, "
		sSql = sSql & "sig_liberacaodespesa.seqdespesa, sig_liberacaodespesa.dthrregistro, sig_liberacaodespesa.tipodespesa, "
		sSql = sSql & "sig_liberacaodespesa.motivo, sig_liberacaodespesa.valor, sig_liberacaodespesa.situacao, sig_liberacaodespesa.dthrliberacao "
		sSql = sSql & "From sig_liberacaodespesa, sig_aeroporto Where sig_liberacaodespesa.sequsuarioaerop = sig_aeroporto.seqaeroporto "
		If isDate(ll_ano2&"/"&ll_mes2&"/"&ll_dia2) Then
			sSql = sSql & " And dthrregistro >= '" & Data1 & "' And dthrregistro <= '" & Data2 & " 23:59:59' "
		Else
			sSql = sSql & " And dthrregistro >= '" & Data1 & "' And dthrregistro <= '" & Data1 & " 23:59:59' "
		End If	
		sSql = sSql & "Order by seqdespesa"

		set Rs = conn.Execute(Ssql)

	end IF	
	
	ls_Status = Request.Form("ststatus")	
		
	If trim(lcase(Request.QueryString("atualizarSelecionados"))) = "sim" Then
		Dim ConnUpdate
		
		Set ConnUpdate = CreateObject("ADODB.CONNECTION")
		ConnUpdate.Open (StringConexaoSqlServer)
		ConnUpdate.Execute "SET DATEFORMAT ymd"
	
		sSqlUpdate = "Update SIG_LIBERACAODESPESA SET situacao = '" & request.querystring("Status") & "', dthrliberacao='" & Year(NOW()) & "-" & Month(NOW()) & "-" & Day(NOW()) & " " & Right("00" & Hour(Now()),2) & ":" & Right("00" & Minute(Now()),2) & "' , sequsuario=" & Session("member") & " Where seqdespesa IN (" & request.QueryString("selecionados") & ") "'
'		Response.Write(sSqlUpdate)
'		Response.End()
		set RsUpdate = ConnUpdate.Execute(sSqlUpdate)

        set RsUpdate = nothing
	    set ConnUpdate = nothing
	End If	
%>
<br />
<center>

<table width="95%">
<form method= "post"  ACTION="desp_func_consultadespesas.asp" Name= "Ordena_data"  onsubmit="return VerificaCampos();">
<input name="boxchecked" value="0" type="hidden">
<tr>
  	<td class='CORPO10' align='left' valign='bottom' colspan='3'>
      	<div>
			<label>Per&iacute;odo:&nbsp;</label>  
            <label class="Corpo9">
              <input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9" Value="<% if ls_Voltar <> "voltar" then  response.Write(trim(Request.Form("txt_Data1"))) else response.Write(Right("00" & Day(Request.QueryString("txt_Data1")),2) & "/" & Right("00" & Month(Request.QueryString("txt_Data1")),2) & "/" & year(Request.QueryString("txt_Data1"))) end If %>"/>&nbsp;
              <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button> &nbsp;At&eacute;:</label>
              <label class="Corpo9">
              <input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9"  Value="<% If ISDATE(Request.QueryString("txt_Data2")) or ISDATE(Request.form("txt_Data2"))  Then  Response.Write(ll_dia2 & "/" & ll_mes2 & "/" & ll_ano2) End IF %>"/>&nbsp;
              <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></label>
      &nbsp;<input type= "submit" value="Pesquisar" class="botao1" onclick='return ValidaData(getElementById("txt_Data1").value , getElementById("txt_Data2").value);' >
&nbsp;      </b> 
     	</div>
  	</td>
	<td width="61%" align="left">
    	<strong class="CORPO8">Atualizar pedidos como:</strong>&nbsp;
        <select id="ststatus" name="ststatus" >
	 		<option selected value = -1 selected="selected">--Escolha--</option>
            <option value ="A">Aprovado</option>
            <option Value ="N" >Negado</option>
        </select>    
        <input name="atuboleto" class="botao1" Value="Atualizar" type="Button" onClick=atualizarStatus('cb',contador) >
    </td>
</tr>
</table>
</div>
<br />
<center>
<table align="center" border=1 cellpadding="0" cellspacing="0" ID="Table2" width="98%">
	<thead>	
      <tr bgcolor='#AAAAAA' align='center'>
        <th width="1%" class="CORPO9">&nbsp;</th>
        <th width="5%" class="CORPO9">N&deg;</th>
        <th width="8%" class="CORPO9">Aeroporto</th>
        <th width="12%" class="CORPO9">Data de Registro</th>
        <th width="11%" class="CORPO9">Tipo</th>
        <% If int_menu_Empresa <> 2 Then %>
       	<th width="29%" class="CORPO9">Motivo</th>
		<% End IF %>            
        <th width="8%" class="CORPO9">Valor</th>
        <th width="9%" class="CORPO9">Situa&ccedil;&atilde;o</th>
        <th width="17%" class="CORPO9">Data de Libera&ccedil;&atilde;o</th>
      </tr>
	</thead>   
    <tbody>
    <%
		ll_cont = 0
		
		Do While Not Rs.EOF
			ll_cont = ll_cont + 1
			
			Response.Write("<tr class='corpo8' align='center' >")
			Response.Write(" 	<td width='1'>")
			Response.Write(" 		<input id='cb"& ll_cont & "' type='checkbox' name="& Rs("seqdespesa") & " value="& Rs("seqdespesa") )
			If Rs("situacao") <> "P" Then 
				Response.Write(" disabled='disabled'/>") 
			Else 
				Response.Write(">") 
			
			End If
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write("    <a href = 'desp_func_detalhesdespesa.asp?Aeroporto=" & Rs("codiata") & "&data1=" & ll_dia1 &"/" & ll_mes1 & "/" & ll_ano1 & "&data2= " & ll_dia2 &"/" & ll_mes2 & "/" & ll_ano2 &  "&seqdespesa= " & Rs("seqdespesa") & "'> ")
			Response.Write( 		Rs("seqdespesa") )
			Response.Write("	</a>")
			Response.Write(" 	</td>")
			Response.Write(" 	<td class='corpo8Bold'>")
			Response.Write(			Rs("codiata") & "&nbsp;")
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write(			Right("00"&Day(Rs("dthrregistro")),2) & "/" & Right("00"&month(Rs("dthrregistro")),2) & "/" & Year(Rs("dthrregistro")) & " " & Right("00"&Hour(Rs("dthrregistro")),2)) & ":" & Right("00"&minute(Rs("dthrregistro")),2)
			Response.Write(" 	</td>")
			Response.Write(" 	<td>")
			Response.Write(			Rs("tipodespesa"))
			Response.Write(" 	</td>")
			If int_menu_Empresa <> 2 Then
				Response.Write(" 	<td>")
				Response.Write(			Rs("motivo")&"&nbsp;")
				Response.Write(" 	</td>")
			End If	
			Response.Write(" 	<td>")
			Response.Write(			FormatCurrency(Rs("valor")))
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
			Response.Write(" 	<td>")
			If NOT ISNULL(Rs("dthrliberacao")) Then
				Response.Write(			Right("00"&Day(Rs("dthrliberacao")),2) & "/" & Right("00"&month(Rs("dthrliberacao")),2) & "/" & Year(Rs("dthrliberacao")) & " " & Right("00"&Hour(Rs("dthrliberacao")),2)) & ":" & Right("00"&minute(Rs("dthrliberacao")),2)
			Else
				Response.Write(" 	&nbsp;")	
			end If	

			
			Response.Write(" 	</td>")
			Response.Write("</tr>")
			Rs.movenext
		LOOP	
	%>
    	<script>
			var contador = <%=ll_cont%>;
			var cbcont = <%=ll_cont%> + 1;
		 </script>
    </tbody> 
</table>
</form> 
</center>          
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div>
</body>
</html>
