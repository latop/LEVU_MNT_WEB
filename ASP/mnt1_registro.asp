<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<% 'Response.Charset ="ISO-8859-1" %>
<!--#include file="includes\combobox.asp"-->
<!--#include file="mnt1_registro_asp.asp"-->

<%

'call abrirRegistro(seqteclog)

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>SIGLA - Technical Logbook</title>

<script src ="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="mnt1_registro.js" type="text/javascript" language="javascript"></script>

<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
<style type="text/css" media="all">@import url(estilo.css);</style>


</head>

<body onLoad="lockCampos()">
<center>
<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
   <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
      <img src="imagens/logo_empresa.gif" border="0"></a>      </td>
   <td class="corpo" align="center" width="30%" rowspan="2">
      <font size="4"><b>
         &nbsp;Technical Logbook
      </b></font>      </td>
   <td class="corpo" align="right" valign="top" width="35%">
      <a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
   </td>
</tr>
<tr>
   <td></td>
   <td></td>
</tr>
<tr>   
   <td colspan="3"><!--#include file="Menu.asp"--></td>
</tr>
<tr>
   <td>&nbsp;</td>
</tr>   
</table>
</center>
<%
	Dim objConnPerm
	Set objConnPerm = CreateObject("ADODB.CONNECTION")
	objConnPerm.Open (StringConexaoSqlServer)
	objConnPerm.Execute "SET DATEFORMAT ymd"

	Dim Perm_RS
	Dim strPermissao
	strPermissao = f_permissao(Session("member"), "I16", objConnPerm, Perm_RS)
	if (isVazio(strPermissao)) then
		Response.Redirect("home.asp")
	end if

	objConnPerm.close
	Set objConnPerm = Nothing
%>
<form id="form1" name="form1" method="post" action="mnt1_registro.asp?seqteclog=<%=seqteclog %>&data1=<%=ldt_data1%>&data2=<%=ldt_data2%>">
<table width="750">
   <tbody>
   <tr>
      <td><fieldset>
         <legend><strong class="CORPO9">Reporte de Discrep&acirc;ncia</strong></legend>   
         <table width="857" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
               <td width="183"><label class="CORPO9">(*)Data: <input type="text" name="txtData" id="txtData" size="11" maxlength="10" class="Corpo9" Value="<%=regData%>"/>&nbsp;
                  <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></label>
               </td>
               <td></td>
               <td width="218"><label class="CORPO9">(*)Aeronave: </label>
                  <label class="CORPO9">
                     <select name="comboAeronave" id="comboAeronave">
                        <option value="0">Selecione </option>
                        <% 
                        call preencherComboSimples("sig_aeronave", "prefixored", "prefixored", "prefixored", aeronave)
                        %>
                     </select>
                  </label>
               </td>
               <td width="167" class="CORPO9">Voo:
                  <input name="txtVoo" type="text" id="txtVoo" size="10" value="<%=ls_voo%>"/></td>
               <td width="289"><fieldset><legend><strong class="CORPO9">Etapa</strong></legend>
                    <legend class="CORPO9"><br />
                     Origem:
                     <select name="comboOrigem" id="comboOrigem">
                        <option value="0"></option>
                        <% 
                        call preencherComboAeroportos(origem)
                        %>
                     </select>              
                     <select name="comboDestino" id="comboDestino">
                          <option value="0"></option>        
                         <% 
                        call preencherComboAeroportos(destino)
                        %>
                     </select>
                     <br />
                  </legend>
                  </fieldset>
               </td>
            </tr>
            <tr>
               <td colspan="5"><label class="CORPO9">
                  <textarea name="txtDescrDiscrep" id="txtDescrDiscrep" cols="90" rows="5"><%=descrdiscrep%></textarea>(*)
               </label></td>
            </tr>
            <tr>
               <td colspan="2" class="CORPO9">(*)TLB/PG: 
                    <input type="text" name="txtDiarioBordo" id="txtDiarioBordo" value="<%=diarioBordo %>" size="24" maxlength="16" style="text-transform:uppercase;" />
               </td>
               <td colspan="2" class="CORPO9">(*)Item:
                  <input name="txtItem" type="radio" id="txtItem" value="1" <%If (ll_item = "1" or (ll_item <> "2" and ll_item <> "3")) Then Response.Write("checked")%> />1&nbsp;&nbsp;
                  <input name="txtItem" type="radio" id="txtItem" value="2" <%If ll_item = "2" Then Response.Write("checked")%> />2&nbsp;&nbsp;
                  <input name="txtItem" type="radio" id="txtItem" value="3" <%If ll_item = "3" Then Response.Write("checked")%> />3&nbsp;&nbsp;
               </td>
               <td colspan="2" class="CORPO9">Reportado por:
                  <label class="CORPO9">
                  <input name="txtReportado" type="text" id="txtReportado" size="40" maxlength="40" value="<%=reportado %>"/>
                  </label>
               </td>
            </tr>
         </table>
         </fieldset>
      </td>
   </tr>
   </tbody>
</table>
<br />

<table height="232">
   <tbody>
      <tr>
         <td width="811"><fieldset>
            <legend class="CORPO9"><strong>A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o</strong></legend>
            <table height="94" width="796">
               <tbody>
               <tr>
                  <td></td>
               </tr>
               <tr align="center">
                  <td width="233" class="CORPO9">(*)ATA 100:                
                     <label class="CORPO9">
                     <select name="comboAta100" id="comboAta100">
                         <option value = "0">  </option>   
                         <%
                         call preencherComboAta(codata&"-"&codsubata)
                         %>
                      </select>                                                 
                      </label>
                  </td>
                  <label class="CORPO9">(*)Data:</label>
                  <input type="text" name="txtDtAcaoMnt" id="txtDtAcaoMnt" class="CORPO9" size="11" maxlength="10" value="<%=mntData %>"/>
                  &nbsp;
                  <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" " class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
                  <td width="243" class="CORPO9">(*)Base Station:
                     <input name="txtBaseStation" type="text" id="txtBaseStation" maxlength="20" value="<%=baseStation %>"/></td>
                  <td width="304" class="CORPO9">(*)Cod. Anac:
                     <input name="txtCodAnac" type="text" id="txtCodAnac" maxlength="20" value="<%=codAnac %>"/></td>
               </tr>
               <tr>
                  <td colspan="9"><hr /></td>
               </tr>
               <tr>
                  <td colspan="9" class="CORPO9"><textarea name="txtDescrMnt" cols="90" rows="7" id="txtDescrMnt"><%= descrMnt %></textarea>(*)</td>
               </tr>
               <tr>
                  <td colspan="9"><hr /></td>
               </tr>
               </tbody>
            </table>
            <table border="1" cellpadding="0" cellspacing="0" bordercolor="#ECECEC" bgcolor="#FFFFFF" class="comDegradeCinza">
               <thead>
               <tr align="center" class="CORPO9">
                  <td align="center">PN Removido/Invertido</td>
                  <td align="center">SN Removido/Invertido</td>
                  <td align="center">Pos. Atual</td>
                  <td align="center">PN Instalado/Invertido</td>
                  <td align="center">SN Instalado/Invertido</td>
                  <td align="center">Pos. Atual</td>
               </tr>
               </thead>
               <tbody>
               <tr align="center">
                  <td height="23"><input name="txtPnRemovido" type="text" id="txtPnRemovido" size="25" maxlength="30" value="<%=pnRemovido %>"/></td>
                  <td height="23"><input name="txtSnRemovido" type="text" id="txtSnRemovido" size="25" maxlength="30" value="<%=snRemovido %>"/></td>
                  <td height="23"><input name="txtPosAtualremov" type="text" id="txtPosAtualremov" size="10" maxlength="20" value="<%=posAtualRemovido %>"/></td>
                  <td height="23"><input name="txtPnInstalado" type="text" id="txtPnInstalado" size="25" maxlength="30" value="<%=pnInstalado %>"/></td>
                  <td height="23"><input name="txtSnInstalado" type="text" id="txtSnInstalado" size="25" maxlength="30" value="<%=snInstalado %>"/></td>
                  <td height="23"><input name="txtPosAtualinst" type="text" id="txtPosAtualinst" size="10" maxlength="20" value="<%=posAtualInstalado %>"/></td>
               </tr>
               </tbody>
            </table>
            <br />
            <table width="767" border="1" cellpadding="0" cellspacing="0" bordercolor="#E2E2E2" class="comDegradeCinza">
               <thead>
               <tr align="center" class="CORPO9">
                  <td width="67" rowspan="2" background="imagens/branco.jpg">&Oacute;leo(Lata)</td>
                  <td width="60" align="center">(*)E1</td>
                  <td width="60" align="center">(*)E2</td>
                  <td width="60" align="center">E3</td>
                  <td width="60" align="center">E4</td>
                  <td width="90" align="center">(*)APU</td>
                  <td width="90" align="center">(*)HA1G</td>
                  <td width="90" align="center">HB2B</td>
                  <td width="90" align="center">H3SY</td>
               </tr>
               <tr align="center">
                  <td height="23"><input name="txtE1" type="text" id="txtE1" size="10" maxlength="20" value="<%=e1 %>"/></td>
                  <td height="23"><input name="txtE2" type="text" id="txtE2" size="10" maxlength="20" value="<%=e2 %>"/></td>
                  <td height="23"><input name="txtE3" type="text" id="txtE3" size="10" maxlength="20" value="<%=e3 %>"/></td>
                  <td height="23"><input name="txtE4" type="text" id="txtE4" size="10" maxlength="20" value="<%=e4 %>"/></td>
                  <td height="23"><input name="txtAPU" type="text" id="txtAPU" size="15" maxlength="20" value="<%=apu %>"/></td>
                  <td height="23"><input name="txtHA1G" type="text" id="txtHA1G" size="17" maxlength="20" value="<%=ha1g %>"/></td>
                  <td height="23"><input name="txtHB2B" type="text" id="txtHB2B" size="17" maxlength="20" value="<%=hb2b %>"/></td>
                  <td height="23"><input name="txtH3SY" type="text" id="txtH3SY" size="17" maxlength="20" value="<%=h3sy %>"/></td>
               </tr>
               </thead>
            </table>
            <br />
         </fieldset>
      </td>
   </tr>
   </tbody>
</table>
<input type="hidden" name="hiddenAcao" id="hiddenAcao"  value="<%=hiddenAcao%>"/>
<input type="hidden" name="hiddenLock" id="hiddenLock"  value="<%=hiddenLock%>"/>

<!--<input type="button" name="teste" id="teste" onclick="lockCampos()" />-->

<br />
<%
	Response.Write("<input name='btnGravar' type='button' class='botao1' id='btnGravar' onclick='gravarAlterarRegistro();' value='Gravar' style='margin-left:30px;' ")
	if (strPermissao <> "A") then Response.Write("disabled='disabled' ") end if
	Response.Write("/>" & vbCrLf)
	Response.Write("<input name='btnExcluir' type='button' class='botao1' id='btnExcluir' onclick='excluirRegistro();' value='Excluir' ")
	if (strPermissao <> "A") then Response.Write("disabled='disabled' ") end if
	Response.Write("/>" & vbCrLf)
%>
<!--<input name="btnTemp" type="button" class="botao1" id="btnTemp" value="Botão de testes temporário" disabled="disabled" /> -->
<input name="btnVoltar" type="button" class="botao1" id="btnVoltar" onclick="javascript:history.go(-1)" value="Voltar"/>
</form> 
<div id="calendarDiv"></div>    
<div id="calendarDiv2"></div>    

<p>&nbsp;</p>
</body>
</html>
