<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="libgeral.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<script src="javascript.js"></script>
   <script src="jquery-1.1.4.js" type="text/javascript"></script>
   <script src="jquery.tablesorter.js" type="text/javascript"></script>
   <script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
   	<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>

   <style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
   <script type="text/javascript">
   	$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#data1").mask("99/99/9999");
			$("#data2").mask("99/99/9999");	
       });
	</script>	 
    
	<script language="javascript">
             function VerificaCampos() {
                if (window.form1.Data1.value == "") {
                    alert('Preencha a 1º Data!');
                    window.form1.Data1.focus();
                    return false;
                }
                else if (window.form1.Data2value == "") {
                    alert('Preencha a 2º Data!');
                    window.form1.Data2.focus();
                    return false;
                }	
        }	
    </script>
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">  
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <title>SIGLA - Registro de Manutenção</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
   <style type="text/css">
body {
	margin-left: 0px;
}
</style>

</head>
<body>
<center>
<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center">
					<font size="4"><b>&nbsp;Registro de Manutenção</b></font><br /><br />
				</td>
				<td class="corpo" align="right" valign="top" width="35%" colspan="20">
			      <a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		      </td>
         </tr>
          <tr>
      <td></td>
      <td></td>
   </tr>
   <tr>   
      <td colspan="25">
      	<!--#include file="Menu.asp"-->
      </td>
   </tr>
</table>
</center>
<br />

<table width="98%">
	<tr>
		<td valign="middle">
			<form method="post" name="form1" id="form1" action="Mnt_Registro_Relatorio.asp" onSubmit="Javascript: return VerificaCampos();">
            <div id="default" class="tab_group1 container">
               <label class="Corpo9">Aeronave:</label>
               <input type="text" name="prefixored" id="prefixored" size="4" maxlength="3" class="Corpo9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=Request.form("prefixored")%>"/>&nbsp;&nbsp;&nbsp;
               <label class="CORPO9">Período:</label>
               <label class="Corpo9">
               <input type="text" name="data1" id="data1" size="11" maxlength="10" class="CORPO9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" value="<%=Request.Form("data1")%>"/>&nbsp;<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button> &nbsp;Até:</label>
               <label class="Corpo9">
               <input type="text" name="txt_Data2" id="data2" size="11" maxlength="10" class="Corpo9"  Value="<%=Request.form("txt_Data2")%>"/>&nbsp;
              <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" " class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></label>&nbsp;&nbsp;
               <input type="submit" value="Pesquisar"  />
            </div>
      	</form>       
      </td>
   </tr>
</table>
         
<center>

<%
Dim objConn, objRs, ls_sql
Dim ls_prefixored
Dim ls_ata100_ant
Dim ls_ata100, ls_basestation, ls_codanac, ls_descrmnt, ldt_dtacaomnt, ls_pnremovido

ls_prefixored = Request.Form("prefixored")

If ls_prefixored > "" Then
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"
	
	ls_sql = 			" SELECT SDTMNT.ata100, SDTMNT.basestation, SDTMNT.codanac, SDTMNT.descrmnt, SDTMNT.dtacaomnt,"
	ls_sql = ls_sql & 		 " SDTMNT.pnremovido, SDT.prefixoaeronave "
	ls_sql = ls_sql & " FROM sig_diariotrecho SDT, sig_diariotrechodbmnt SDTMNT"
	ls_sql = ls_sql & " WHERE SDT.seqvoodia = SDTMNT.seqvoodia"
	ls_sql = ls_sql &   " AND SDT.seqtrecho = SDTMNT.seqtrecho"
	ls_sql = ls_sql &   " AND SDT.prefixoaeronave = '" & UCase( ls_prefixored ) & "'"
	ls_sql = ls_sql & " ORDER BY SDTMNT.ata100"
	
	Set objRS = objConn.Execute( ls_sql )
	
	ls_ata100_ant = ""
	
	Do While NOT objRS.EOF
		ls_prefixored = objRS("prefixoaeronave")
		ls_ata100 = objRS("ata100")
		ls_basestation = objRS("basestation")
		ls_codanac = objRS("codanac")
		ls_descrmnt = objRS("descrmnt")
		ldt_dtacaomnt = objRS("dtacaomnt")
		ls_pnremovido = objRS("pnremovido")
		
		If ls_ata100 <> ls_ata100_ant Then
%>
         <table width="960" border="1" cellpadding="0" cellspacing="0" class="tablesorter" ID="Table2">
            <tr bgcolor="#AAAAAA">
            	<td class="Corpo8" align="center"><b>ATA 100:</b>&nbsp; <%=ls_ata100%></font> </td>
            </tr>
         </table>
         
<%
		End if

%>		
         <table width="960" border="1" cellpadding="0" cellspacing="0" class="tablesorter" ID="Table2">
            <tr>
            	<td colspan="2">
                  <table border="0" width="98%">
                  	<tr>
                     	<td class="CORPO8Bold" align="right" width="170">Aeronave:&nbsp;</td>
                        <td class="CORPO8" colspan="3" align="left"> <%=ls_prefixored%> &nbsp;</td>
                     </tr>
                  	<tr>
                        <td class="CORPO8Bold" align="right" width="170">Base Station:&nbsp;</td>
                        <td class="CORPO8" width="150" align="left"> <%=ls_basestation%> &nbsp;</td>
                        <td class="CORPO8Bold" align="right" width="170">Cod. Anac:&nbsp;</td>
                        <td class="CORPO8" align="left"> <%=ls_codanac%> &nbsp;</td>
                  	</tr>
                  	<tr>
                        <td class="CORPO8Bold" align="right" width="170" valign="top">Ação de Manutençao:&nbsp;</td>
                        <td class="CORPO8" colspan="3"> <%=ls_descrmnt%> &nbsp;</td>
                  	</tr>
	               </table>
               </td>
            </tr>
            <tr>
            	<td valign="top">
                  <table border="0" align="left" width="300" border="0">
                     <tr>
                        <td class="CORPO8Bold" align="right" width="170">Data:&nbsp;</td>
                        <td class="CORPO8"> <%=ldt_dtacaomnt%> &nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">PN Removido/Invertido:&nbsp;</td>
                        <td class="CORPO8" > <%=ls_pnremovido%> &nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">SN Removido/Invertido:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">Pos. Atual:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">PN Instalado/Invertido:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">SN Instalado/Invertido:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">Pos. Atual:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                  </table>               
               </td>
               <td>
                  <table border="0" align="left" width="300" border="0">
                     <tr>
                        <td class="CORPO8Bold" align="right" width="170">E1:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">E2:&nbsp;</td>
                        <td class="CORPO8" >&nbsp;</td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">E3:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">E4:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">APU:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">HA1G:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">HB2B:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                     <tr>
                        <td class="CORPO8Bold" align="right">H3SY:&nbsp;</td>
                        <td class="CORPO8" ></td>
                     </tr>
                  </table>               
               </td>
            </tr>
         </table>

<%

		objRS.MoveNext
		
		If NOT objRS.EOF Then
			If objRS("ata100") <> ls_ata100 Then
				'Response.Write("</table>")
				Response.Write("<br>")
			End if
		End if
		
		ls_ata100_ant = ls_ata100
	Loop
	
	objConn.close
	Set objRs = Nothing
	Set objConn = Nothing
End if
%>

</center>
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div>
</body>
</html>
