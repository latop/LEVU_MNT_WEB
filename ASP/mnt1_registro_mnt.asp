<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<% 'Response.Charset ="ISO-8859-1" %>
<!--#include file="grava_usuariolog.asp"-->
<!--#include file="mnt1_registro_mnt_asp.asp"-->

<html><head>
<title>SIGLA - Technical Logbook</TITLE>
<span style="font-family: arial ; sans-serif"  >
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.tablesorter.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="mnt1_registro_mnt.js" type="text/javascript"></script>
<script src="javascript.js" type="text/javascript"></script>
<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
</head>

<body>

<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
      <tr>
         <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
            <img src="imagens/logo_empresa.gif" border="0"></a>		</td>
         <td class="corpo" align="center" width="30%" rowspan="2">
            <font size="4"><b>
               &nbsp;Technical Logbook
            </b></font>		</td>
         <td class="corpo" align="right" valign="top" width="35%">
            <a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>		</td>
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
	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim Perm_RS
	Dim strPermissao
	strPermissao = f_permissao(Session("member"), "I16", objConn, Perm_RS)
	if (isVazio(strPermissao)) then
		Response.Redirect("home.asp")
	end if

	' Executa função para gravar na sig_usuariolog
	If f_grava_usuariolog( "I16", objConn ) <> "" Then
		Response.End()
	End if

	objConn.close
	Set objConn = Nothing
%>
<form action="mnt1_registro_mnt.asp" method="post">
	<table width="97%" border="0" cellpadding="0" align="center" cellspacing="0" Id="Table" >
		<tr>
			<td align="left" nowrap>
				<label class="Corpo9">Período:</label>
				<label class="Corpo9">
					<input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9"  value="<% call PreencherData1 %>"/>&nbsp;
					<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
					&nbsp;At&eacute;:
				</label>
				<label class="Corpo9">
					<input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9" value="<% call PreencherData2 %>"/>&nbsp;
					<button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>
				</label>
				&nbsp;&nbsp;
				<label class="Corpo9">Frota:</label>
				<select name="cmbFrota" id="cmbFrota" class="CORPO9">
					<option value=''>&nbsp;</option>
					<% call PreencherFrota() %>
				</select>
				&nbsp;&nbsp;
				<label class="Corpo9">Aeronave:</label>
				<input type="text" name="txt_Aeronave" id="txt_Aeronave" size="4" maxlength="3" class="CORPO9" style="text-transform:uppercase;" Value="<% call PreencherAeronave() %>"/>
				&nbsp;&nbsp;
				<label class="Corpo9">TLB/PG:</label>
				<input type="text" name="txt_TLB" id="txt_TLB" size="20" maxlength="16" class="CORPO9" style="text-transform:uppercase;" Value="<% call PreencherTLB() %>"/>
				&nbsp;&nbsp;
				<label class="Corpo9">Item:</label>
				<input type="text" name="txt_Item" id="txt_Item" size="1" maxlength="1" class="CORPO9" onKeyPress="return SoNumeros(window.event.keyCode, this);" style="text-transform:uppercase;" Value="<% call PreencherItem() %>"/>
			</td>
		</tr>
		<tr style="padding-top:10">
			<td align="left" nowrap>
				<label class="Corpo9">ATA 100:</label>
				<select name="cmbAta100" id="cmbAta100" class="CORPO9">
					<option value=''>&nbsp;</option>
					<% call PreencherAta100() %>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="btnPesquisar" type="submit" class="botao1" id="btnPesquisar" value="Pesquisar" />
				&nbsp;&nbsp;
<%
	Response.Write("<input name='btnNovoReg' type='button' class='botao1' id='btnNovoReg' onclick='novoRegistro();' value='Novo Registro' ")
	if (strPermissao <> "A") then Response.Write("disabled='disabled' ") end if
	Response.Write("/>" & vbCrLf)
%>
			</td>
		</tr>
	</table>     
	<br>
	<table width="97%" border="1" cellpadding="0" align="center" cellspacing="0" Id="Table3" >
		<thead>
			<tr bgcolor="#AAAAAA" style='cursor:pointer;cursor:hand' class="Corpo8Bold">
				<td width="15%" align="center" >N&deg; TLB</td>
				<td width="5%" align="center" >Item</td>
				<td width="6%" align="center" >Base</td>
				<td width="37%" align="center" >Reporte da Discrep&acirc;ncia</td>
				<td width="37%" align="center" >A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o</td>
			</tr>
		</thead>
		<tbody>
			<% call PreencherTabelaManutencao %>
		</tbody>
	</table>
</form>

<div id="calendarDiv"></div>
<div id="calendarDiv2"></div>
</body>
</html>
