<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeropfunc.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="shortcut icon" href="favicon.ico">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">   
<title>SIGLA - Relatório de Movimento de Aeronaves</title>
<script src="javascript.js"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script type="text/javascript">
	String.prototype.trim = function()
	{
		return this.replace(/^\s*/, "").replace(/\s*$/, "");
	}

	function VerificaCampos()
	{
		if (document.getElementById('txt_Data1').value.trim() == '') {
			alert('Preencha o 1º campo de período, por favor!');
			document.getElementById('txt_Data1').focus();
			return false;
		}
		else if (document.getElementById('txt_Data2').value.trim() == '') {
			alert('Preencha o 2º campo de período, por favor!');
			document.getElementById('txt_Data2').focus();
			return false;
		}
	}	
	$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data1").mask("99/99/9999");	
			$("#txt_Data2").mask("99/99/9999");	
	});
</script>

<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
<style type="text/css" media="screen,projection">
	@import url(calendar/calendar.css);
</style>
<style type="text/css">
body {
	margin-left: 0px;
	size: landscape;
}

page {
size: landscape;
}

div.breakafter {page-break-after:always;
	color: silver
}
div.breakbefore {page-break-before:always;
	color: silver
}


</style>

<style type="text/css" media="print">
div.page  { 
writing-mode: tb-rl;
height: 80%;
margin: 10% 0%;
}

div.page table {
margin-right: 80pt;
filter: progid:DXImageTransform.Microsoft.BasicImage(Rotation=1);
}
</style>


<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>

<body>
<%
Dim sSql, Conn, Rs
Dim DtInicio, DtFim
Dim DiaInicio, MesInicio, AnoInicio
Dim DiaFim, MesFim, AnoFim
Dim ls_prefixored, ll_seqfrota, ll_nrvoo, ls_base, ls_origem_filtro, ls_destino_filtro
Dim ls_codfrota_vet, ll_seqfrota_vet, ll_contador

DiaInicio = Day(Request.Form("txt_Data1")) 
MesInicio = Month(Request.Form("txt_Data1"))
AnoInicio = Year(Request.Form("txt_Data1"))
ls_prefixored = Request.Form("prefixored")
ll_seqfrota = Request.Form("seqfrota")
ll_nrvoo = Request.Form("nrvoo")
ls_base = Request.Form("base")
ls_origem_filtro = Request.Form("origem")
ls_destino_filtro = Request.Form("destino")

DiaFim = Day(Request.Form("txt_Data2"))
MesFim = Month(Request.Form("txt_Data2"))
AnoFim = Year(Request.Form("txt_Data2"))

DtInicio =  AnoInicio & "/" & Right( "00" & MesInicio,2 ) & "/" & Right( "00" & DiaInicio,2 )
DtFim =  AnoFim & "/" & Right( "00"& MesFim,2 ) & "/" & Right( "00" & DiaFim,2 )

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Set Rs = Conn.Execute( "SELECT seqfrota, codfrota FROM sig_frota ORDER BY codfrota" )
ll_seqfrota_vet = ""
ls_codfrota_vet = ""
Do While NOT Rs.EOF
	ll_seqfrota_vet = ll_seqfrota_vet & "," & Rs("seqfrota")
	ls_codfrota_vet = ls_codfrota_vet & "," & Rs("codfrota")
	Rs.MoveNext
Loop

ll_seqfrota_vet = Split(ll_seqfrota_vet,",")
ls_codfrota_vet = Split(ls_codfrota_vet,",")

sSql =       "SELECT sig_diariovoo.nrvoo,"
sSql = sSql & "  sig_diariovoo.dtoper,"
sSql = sSql & "  sig_diariovoo.statusvoo,"
sSql = sSql & "  sig_diariotrecho.seqvoodia,"
sSql = sSql & "  sig_diariotrecho.seqtrecho,"
sSql = sSql & "  sig_diariotrecho.seqfrota,"
sSql = sSql & "  aeroporig.codiata as Codigo_IATA_Origem,"
sSql = sSql & "  aeropdest.codiata as Codigo_IATA_Destino,"
sSql = sSql & "  sig_diariotrecho.seqaeroporig,"
sSql = sSql & "  sig_diariotrecho.seqaeropdest,"
sSql = sSql & "  sig_diariotrecho.fechamporta,"
sSql = sSql & "  sig_diariotrecho.partidaprev,"
sSql = sSql & "  sig_diariotrecho.chegadaprev,"
sSql = sSql & "  sig_diariotrecho.partidamotor,"
sSql = sSql & "  sig_diariotrecho.decolagem,"
sSql = sSql & "  sig_diariotrecho.pouso,"
sSql = sSql & "  sig_diariotrecho.cortemotor,"
sSql = sSql & "  sig_diariotrecho.combustivel,"
sSql = sSql & "  sig_diariotrecho.prefixoaeronave,"
sSql = sSql & "  sig_diariotrecho.paxeconomica,"
sSql = sSql & "  sig_diariotrecho.paxespecial,"
sSql = sSql & "  sig_diariotrecho.paxturismo,"
sSql = sSql & "  sig_diariotrecho.paxgratis,"
sSql = sSql & "  sig_diariotrecho.baglivre,"
sSql = sSql & "  sig_diariotrecho.bagexcesso,"
sSql = sSql & "  sig_diariotrecho.cargapaga,"
sSql = sSql & "  sig_diariotrecho.cargagratis,"
sSql = sSql & "  sig_diariotrecho.atzdec,"
sSql = sSql & "  sig_diariotrecho.atzpou,"
sSql = sSql & "  sig_diariotrecho.atzdecint,"
sSql = sSql & "  sig_diariotrecho.atzpouint,"
sSql = sSql & "  sig_diariotrecho.flgcancelado,"
sSql = sSql & "  sig_diariotrecho.idjustifinterna,"
sSql = sSql & "  sig_diariotrecho.idjustificativa,"
sSql = sSql & "  sig_diariotrecho.paxpago,"
sSql = sSql & "  sig_diariotrecho.paxpad,"
sSql = sSql & "  sig_diariotrecho.paxdhc,"
'sSql = sSql & "  sig_diariovoo.observacao,"
sSql = sSql & "  sig_diariotrecho.observacao,"
sSql = sSql & "  (SELECT sum(sig_diariotrechocomb.paxeconomica + sig_diariotrechocomb.paxprimeira + sig_diariotrechocomb.paxespecial + sig_diariotrechocomb.paxturismo - sig_diariotrechocomb.paxtrc)"
sSql = sSql & "  FROM sig_diariotrechocomb"
sSql = sSql & "  WHERE sig_diariotrechocomb.seqvoodia = sig_diariotrecho.seqvoodia"
sSql = sSql & "    AND sig_diariotrechocomb.seqtrecho = sig_diariotrecho.seqtrecho ) paxembarcado,"
sSql = sSql & "  (SELECT sum(sig_diariotrechocomb.paxtrc)"
sSql = sSql & "  FROM sig_diariotrechocomb"
sSql = sSql & "  WHERE sig_diariotrechocomb.seqvoodia = sig_diariotrecho.seqvoodia"
sSql = sSql & "    AND sig_diariotrechocomb.seqtrecho = sig_diariotrecho.seqtrecho ) paxtrc,"
sSql = sSql & "    (SELECT sum(sig_diariotrechocombtran.paxeconomica + sig_diariotrechocombtran.paxprimeira + sig_diariotrechocombtran.paxespecial + sig_diariotrechocombtran.paxturismo)"
sSql = sSql & "    FROM sig_diariotrechocombtran"
sSql = sSql & "    WHERE sig_diariotrechocombtran.seqvoodia = sig_diariotrecho.seqvoodia"
sSql = sSql & "      AND sig_diariotrechocombtran.seqtrecho = sig_diariotrecho.seqtrecho ) paxtransito,"
sSql = sSql & "  sig_diariovoo.tipovoo "
sSql = sSql & "FROM sig_diariotrecho,"
sSql = sSql & "  sig_diariovoo,"
sSql = sSql & "  sig_aeroporto aeroporig,"
sSql = sSql & "  sig_aeroporto aeropdest "
sSql = sSql & "WHERE sig_diariotrecho.seqvoodia = sig_diariovoo.seqvoodia"
sSql = sSql & "  AND sig_diariovoo.statusvoo <> 'I'"
sSql = sSql & "  AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto"
sSql = sSql & "  AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto"

If ls_prefixored > "" Then
	sSql = sSql & "  AND sig_diariotrecho.prefixoaeronave = '" & UCase( ls_prefixored ) & "' "
End if

If ll_seqfrota > "" Then
	sSql = sSql & "  AND sig_diariotrecho.seqfrota = " & ll_seqfrota & " "
End if

If ll_nrvoo > "" Then
	sSql = sSql & "  AND sig_diariovoo.nrvoo = " & ll_nrvoo & " "
End if

If ls_base > "" Then
	sSql = sSql & "  AND ( aeroporig.codiata = '" & UCase( ls_base ) & "' OR aeropdest.codiata = '" & UCase( ls_base ) & "' ) "
End if
If ls_origem_filtro > "" Then
	sSql = sSql & "  AND ( aeroporig.codiata = '" & UCase( ls_origem_filtro ) & "' ) "
End if
If ls_destino_filtro > "" Then
	sSql = sSql & "  AND ( aeropdest.codiata = '" & UCase( ls_destino_filtro ) & "' ) "
End if

if isDate(DtInicio) and isDate(DtFim) then
	sSql = sSql & "  AND sig_diariovoo.dtoper >= '" & DtInicio & "' "
	sSql = sSql & "  AND sig_diariovoo.dtoper <= '" & DtFim & "' "
	sSql = sSql & "ORDER BY sig_diariovoo.dtoper, sig_diariovoo.nrvoo, sig_diariotrecho.seqtrecho "
	
	'Response.Write(sSQL)
	'Response.End()
	set RS = Conn.Execute(sSQL)
End If		  

%>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="middle" width="35%">
			<img src="imagens/logo_empresa.gif" border="0"></a>		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>&nbsp;Movimento de Aeronaves</b></font>		</td>
		<td class="corpo" align="right" valign="top" width="35%" colspan="3">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
   </tr>   
   <tr>
      <td></td>
      <td></td>
   </tr>
   <tr>   
      <td colspan="25"><!--#include file="Menu.asp"--></td>
   </tr>   
	</table>
</center>
<br>
<table width="100%">
   <tr>
      <td>
         <form method="post" action="Rel_Movacft_Coordenacao.asp" name="form1" onSubmit="Javascript: return VerificaCampos();">
            <div id="default" style="margin-left: 50px;" class="tab_group1 container">
            <div style="margin-bottom: 10px;">
              <label class="Corpo9">Período:</label>
              <label class="Corpo9">
              <input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9" Value="<%=Request.form("txt_Data1")%>"/>&nbsp;
              <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button> &nbsp;Até:</label>
              <label class="Corpo9">
              <input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9"  Value="<%=Request.form("txt_Data2")%>"/>&nbsp;
              <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></label>
              &nbsp;&nbsp;
             <label class="Corpo9">Frota:</label>
               <select name="seqfrota" id="seqfrota" class="CORPO9">
               	<option value=''>&nbsp;</option>
<%
					For ll_contador = 1 To UBound(ll_seqfrota_vet)
						Response.Write( "<option value=" & ll_seqfrota_vet(ll_contador) )
						If ll_seqfrota > "" Then
							If CInt(ll_seqfrota_vet(ll_contador)) = CInt(ll_seqfrota) Then
								Response.Write(" selected")
							End if
						End if
						Response.Write(">" & ls_codfrota_vet(ll_contador) & "</option>")
					Next
					
					Response.Write(ll_seqfrota)
%>
               </select>
               &nbsp;&nbsp;
               <label class="Corpo9">Aeronave:</label>
               <input type="text" name="prefixored" id="prefixored" size="4" maxlength="3" class="CORPO9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=Request.Form("prefixored")%>"/>
               &nbsp;&nbsp;
            </div>
            <div>
               <label class="Corpo9">Voo:</label>
               <input type="text" name="nrvoo" id="nrvoo" size="6" maxlength="4" class="CORPO9" onKeyPress="return SoNumeros(window.event.keyCode, this);" onkeypress="ChecarTAB();" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=ll_nrvoo%>"/>
               &nbsp;&nbsp;
               <label class="Corpo9">Base:</label>
               <input type="text" name="base" id="base" size="4" maxlength="3" class="CORPO9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=ls_base%>"/>
               &nbsp;&nbsp;
               <label class="Corpo9">Origem:</label>
               <input type="text" name="origem" id="origem" size="4" maxlength="3" class="CORPO9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=ls_origem_filtro%>"/>
               &nbsp;&nbsp;
               <label class="Corpo9">Destino:</label>
               <input type="text" name="destino" id="destino" size="4" maxlength="3" class="CORPO9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=ls_destino_filtro%>"/>
               &nbsp;&nbsp;
               <input type="submit" value="Pesquisar"  onClick="Javascript: return VerificaCampos()" />
            </div>
            </div>
         </form>       
      </td>
   </tr>
</table>         

<% 
Dim ls_Aeronave
Dim ls_Voo
Dim ls_Origem
Dim ls_Destino
Dim ls_Fech
Dim dt_Partida
Dim dt_Chegada
Dim ls_Perm
Dim ll_AtzDec
Dim ll_AtzPou
Dim ll_AtzDecInt
Dim ll_AtzPouInt
Dim ll_Pago
Dim ll_Economica
Dim ll_Bordo
Dim ll_Especial
Dim ll_Turismo
Dim ll_Gratis
Dim ll_Emblocal
Dim ll_Embarcado
Dim ll_TRC
Dim ll_Transito
Dim ls_Int
Dim ls_Dac
Dim ls_Observacao
Dim dt_PartidaPrevista
Dim dt_ChegadaPrevista
Dim dt_PartidaMotor
Dim dt_Decolagem
Dim dt_Pouso
Dim dt_CorteMotor
Dim dt_DtOper
Dim dt_DtOper_Ant 
Dim ls_flgcancelado
Dim lb_quebra, ll_totalvoos, ll_totalminoper, ll_totalminvoo, ll_totalpaxeconomica, ll_totalpaxespecial, ll_totalpaxturismo,ll_totalpaxgratis, ll_totalbordo
Dim ll_totalpaxemblocal, ll_totaltrc, ll_totalpaxtransito, ll_totalembarcado
Dim ll_totalvoos_geral, ll_totalminoper_geral, ll_totalminvoo_geral, ll_totalpaxeconomica_geral, ll_totalpaxespecial_geral, ll_totalbordo_geral
Dim ll_totalpaxturismo_geral,ll_totalpaxgratis_geral, ll_totalpaxemblocal_geral, ll_totaltrc_geral, ll_totalpaxtransito_geral, ll_totalembarcado_geral
Dim dia_Semana_Vet, dt_Data_corrente

if isDate(DtInicio) and isDate(DtFim) then
	
	dt_DtOper_Ant = CDate("1/1/1900")
	ll_totalvoos = 0
	ll_totalminoper = 0
	ll_totalminvoo = 0
	ll_totalpaxeconomica = 0
	ll_totalpaxespecial = 0
	ll_totalpaxturismo = 0
	ll_totalpaxgratis = 0
	ll_totalbordo = 0
	ll_totalpaxemblocal = 0
	ll_totaltrc = 0
	ll_totalpaxtransito = 0
	ll_totalembarcado = 0
	ll_totalvoos_geral = 0
	ll_totalminoper_geral = 0
	ll_totalminvoo_geral = 0
	ll_totalpaxeconomica_geral = 0
	ll_totalpaxespecial_geral = 0
	ll_totalpaxturismo_geral = 0
	ll_totalpaxgratis_geral = 0
	ll_totalbordo_geral = 0
	ll_totalpaxemblocal_geral = 0
	ll_totaltrc_geral = 0
	ll_totalpaxtransito_geral = 0
	ll_totalembarcado_geral = 0

	dia_Semana_Vet = "Domingo,Segunda-feira,Ter&ccedil;a-feira,Quarta-feira,Quinta-feira,Sexta-feira,S&aacute;bado"
	dia_Semana_Vet = SPLIT(dia_Semana_Vet,",")
		
	Dim Cor1, Cor2, Cor, intContador
	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	Do While Not Rs.Eof
	
		if ((intContador MOD 2) = 0) then
      			Cor = Cor1
      		else
      			Cor = Cor2
      end if
   
		dt_DtOper = Rs("dtoper")
		dt_Data_corrente = WeekDay(Rs("dtoper"))
		
		ls_flgcancelado = Rs("flgcancelado")
		
		If ls_flgcancelado = "N" Then ll_totalvoos = ll_totalvoos + 1
		
		If dt_DtOper <> dt_DtOper_Ant Then
%>

<!--  <div class="breakafter">Page break after here.</div>  ->

<!-- <div class="page"> -->

         <center>
         <table border="0" width="960">
         	<tr>
            	<td>
                  <font class="Corpo8">
                     <b>Data:&nbsp;</b> 
                     <% Response.Write(Right("00"&Day(dt_dtoper),2) & "/" & Right("00"&Month(dt_dtoper),2) & "/" & Year(dt_dtoper)) & "&nbsp;&nbsp;&nbsp;<b>" & dia_Semana_Vet(dt_Data_corrente -1) & "</b>" %> 
                  </font>
               </td>
            </tr>
         </table>
         <table cellpadding="0" cellspacing="0"  border="0" ID="Table2" width="960" style="border: 1px solid black;">
            <thead>
               <tr bgcolor="#AAAAAA" >
                  <th class="CORPO8Bold" colspan="9" width='1' style="border: 1px solid black;">&nbsp;</th>
                  <th class="CORPO8Bold" colspan="2" width='53' style="border: 1px solid black;">Atz Hot.</th>
                  <th class="CORPO8Bold" colspan="2" width='50' align="center" style="border: 1px solid black;">Atz Int</th>
                  <th class="CORPO8Bold" colspan="3" align='center' style="border: 1px solid black;">A Bordo</th>
                  <th class="CORPO8Bold" colspan="1" align='center' style="border: 1px solid black;"> - </th>
                  <th class="CORPO8Bold" colspan="3" align='center' style="border: 1px solid black;">Embarcado Pago</th>
                  <th class="CORPO8Bold" colspan="3" width='350' align='center' style="border: 1px solid black;">Coordenação</th>
               </tr>
               <tr bgcolor="#AAAAAA"   >
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Aeron</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Voo</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Origem</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Destino</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Part. Prev.</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Cheg. Prev.</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">&nbsp;Fech&nbsp;</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Partida</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Chegada</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Dec</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Pou</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Dec</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Pou</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Pago</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Grátis</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Total</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;" >Cnx In</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Loc</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;" >Cnx Out</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;" >Total</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;" >Int</th>
                  <th class="CORPO8Bold" width='1' style="border: 1px solid black;">Dac</th>
                  <th class="CORPO8Bold" width='350' align='center' style="border: 1px solid black;">Observação</th>
               </tr>   
            </thead>
            <tbody>
<%								
		end If
		
		If ls_flgcancelado = "S" Then
			ls_Aeronave = "<font color='red'>CLD</font>"
		Else
			ls_Aeronave = Rs("prefixoaeronave")
			If Not IsNull(ls_Aeronave) Then
				ls_Aeronave = ls_Aeronave
			Else
				ls_Aeronave = "&nbsp;"
			End IF		
		End if
				
		ls_Voo = Rs("nrvoo")
		If Not IsNull(ls_Voo) Then
			ls_Voo = ls_Voo
		Else
			ls_Voo = "&nbsp;"
		End If
		
		ls_Origem = Rs("Codigo_IATA_Origem")
		If Not IsNull(ls_Origem) Then
			ls_Origem = ls_Origem
		Else
			ls_Origem = "&nbsp;"
		End If
		
		ls_Destino = Rs("Codigo_IATA_Destino")
		If Not IsNull(ls_Destino) Then
			ls_Destino = ls_Destino
		Else
			ls_Destino = "&nbsp;"
		End IF
		
		If Not IsNull(Rs("Fechamporta")) Or Isdate(Rs("Fechamporta")) Then
			ls_Fech = Right("00"&Hour(Rs("Fechamporta")),2)&":"& Right("00"&Minute(Rs("Fechamporta")),2)
		Else
			ls_Fech = "&nbsp;"
		End If

		If (Not IsNull(Rs("partidaprev")) And IsDate(Rs("partidaprev"))) Then
			dt_PartidaPrevista = Right("00"&Hour(Rs("partidaprev")),2)&":"& Right("00"&Minute(Rs("partidaprev")),2)
		Else
			dt_PartidaPrevista= "&nbsp;"
		End If

		If (Not IsNull(Rs("chegadaprev")) And IsDate(Rs("chegadaprev"))) Then
			dt_ChegadaPrevista = Right("00"&Hour(Rs("chegadaprev")),2)&":"& Right("00"&Minute(Rs("chegadaprev")),2)
		Else
			dt_ChegadaPrevista= "&nbsp;"
		End If

		'Response.Write(FormatDateTime(Rs("partidamotor"),4))
		'Response.End()
		dt_PartidaMotor = Right("00"&Hour(Rs("partidamotor")),2)&":"& Right("00"&Minute(Rs("partidamotor")),2)
		dt_Decolagem = Right("00"&Minute(Rs("decolagem")),2)
		
		If (Not IsNull(Rs("partidamotor")) or IsDate(Rs("partidamotor"))) And (Not IsNull(Rs("decolagem")) or IsDate(Rs("decolagem"))) Then
			dt_Partida = dt_PartidaMotor & "/" & dt_Decolagem
		Else
			dt_Partida= "&nbsp;"
		End If
		
		dt_Pouso = Right("00"&Hour(Rs("Pouso")),2)&":"& Right("00"&Minute(Rs("Pouso")),2)
		dt_CorteMotor = Right("00"&Minute(Rs("cortemotor")),2)
		
		If (Not IsNull(Rs("Pouso")) or IsDate(Rs("Pouso"))) And (Not IsNull(Rs("cortemotor")) or IsDate(Rs("cortemotor"))) Then
			dt_Chegada = dt_Pouso & "/" & dt_CorteMotor
		Else
			dt_Chegada= "&nbsp;"
		End If
		
		ll_AtzDec = Rs("atzdec")
		If Not IsNull(ll_AtzDec) Then
			ll_AtzDec = ll_AtzDec
		Else
			ll_AtzDec= "&nbsp;"
		End If
		
		ll_AtzPou = Rs("atzpou")
		If Not IsNull(ll_AtzPou) Then
			ll_AtzPou = ll_AtzPou
		Else
			ll_AtzPou= "&nbsp;"
		End If
		
		ll_AtzDecInt = Rs("AtzDecint")
		If Not IsNull(ll_AtzDecInt) Then
			ll_AtzDecInt = ll_AtzDecInt
		Else
			ll_AtzDecInt= "&nbsp;"
		End If
		
		ll_AtzPouInt = Rs("AtzPouInt")
		If Not IsNull(ll_AtzPouInt) Then
			ll_AtzPouInt = ll_AtzPouInt
		Else
			ll_AtzPouInt= "&nbsp;"
		End If

		' Passageiros a Bordo
		ll_Bordo = 0
		ll_Economica = Rs("paxeconomica")
		If Not IsNull(ll_Economica) Then
			ll_Bordo = ll_Bordo + CInt(ll_Economica)
			If ls_flgcancelado = "N" Then ll_totalpaxeconomica = ll_totalpaxeconomica + CInt(ll_Economica)
			ll_Pago = Rs("paxpago")
			If IsNull( ll_Pago ) Then
				ll_Economica = "<font color='red'>" & ll_Economica & "</font>"
			Else
				If CInt( ll_Economica ) <> CInt( ll_Pago ) Then
					ll_Economica = "<font color='red'>" & ll_Economica & "</font>"
				End if
			End if
		Else
			ll_Economica= "&nbsp;"
		End If

		ll_Gratis = Rs("paxgratis")
		If Not IsNull(ll_Gratis) Then
			ll_Bordo = ll_Bordo + CInt(ll_Gratis)
			ll_Gratis = ll_Gratis
			If ls_flgcancelado = "N" Then ll_totalpaxgratis = ll_totalpaxgratis + CInt(ll_Gratis)
		Else
			ll_Gratis= "&nbsp;"
		End If
		If ls_flgcancelado = "N" Then ll_totalBordo = ll_totalBordo + ll_Bordo

		' Passageiros Embarcados
		ll_embarcado = 0
		ll_Emblocal = Rs("paxembarcado")
		If Not IsNull(ll_Emblocal) Then
			ll_embarcado = ll_embarcado + CInt(ll_emblocal)
			If ls_flgcancelado = "N" Then ll_totalpaxemblocal = ll_totalpaxemblocal + CInt(ll_Emblocal)
		Else
			ll_Emblocal = "0&nbsp;"
		End If
		
		ll_trc = Rs("paxtrc")
		If Not IsNull(ll_trc) Then
			ll_embarcado = ll_embarcado + CInt(ll_trc)
			If ls_flgcancelado = "N" Then ll_totaltrc = ll_totaltrc + CInt(ll_trc)
		Else
			ll_trc= "0&nbsp;"
		End If

		ll_Transito = Rs("paxtransito")
		If Not IsNull(ll_Transito) Then 
			ll_embarcado = ll_embarcado + CInt(ll_transito)
			ll_Transito = ll_Transito
			If ls_flgcancelado = "N" Then ll_totalpaxtransito = ll_totalpaxtransito + CInt(ll_Transito)
		Else
			ll_Transito= "0&nbsp;"
		End If
		If ls_flgcancelado = "N" Then ll_totalembarcado = ll_totalembarcado + ll_embarcado

		ls_Int = Rs("idjustifinterna")

		ls_Dac = Rs("idjustificativa")
		If Not IsNull(ls_Dac) Then 
			ls_Dac = ls_Dac
		Else
			ls_Dac = "&nbsp;"
		End If

		ls_Observacao = Rs("observacao")
		If Not IsNull(ls_Observacao) Then
			ls_Observacao = ls_Observacao
		Else
			ls_Observacao= "&nbsp;"
		End If
		
		If ( NOT IsNull(Rs("partidamotor"))) AND ( NOT IsNull(Rs("cortemotor"))) Then
			ll_totalminoper = ll_totalminoper + DateDiff("n", Rs("partidamotor"), Rs("cortemotor"))
		End if
		
		If ( NOT IsNull( Rs("decolagem"))) AND ( NOT IsNull(Rs("pouso"))) Then
			ll_totalminvoo = ll_totalminvoo + DateDiff("n", Rs("decolagem"), Rs("pouso"))
		End if
		
		Response.Write("<tr class='corpo7' align='center' bgcolor=" & Cor & " >")
		Response.Write(" <td class='corpo7'>" & ls_Aeronave & "</td>")
		Response.Write(" <td class='corpo7'>" & ls_Voo & "</td>")
		Response.Write(" <td class='corpo7'>" & ls_Origem & "</td>")
		Response.Write(" <td class='corpo7'>" & ls_Destino & "</td>")
		Response.Write(" <td class='corpo7'>" & dt_PartidaPrevista & "</td>")
		Response.Write(" <td class='corpo7'>" & dt_ChegadaPrevista & "</td>")
		Response.Write(" <td class='corpo7'>" & ls_Fech & "</td>")
		Response.Write(" <td class='corpo7'>" & dt_Partida & "</td>")
		Response.Write(" <td class='corpo7'>" & dt_Chegada & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_AtzDec & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_AtzPou & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_AtzDecInt & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_AtzPouInt & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Economica & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Gratis & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Bordo & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_trc & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Emblocal & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Transito & "</td>")
		Response.Write(" <td class='corpo7'>" & ll_Embarcado & "</td>")
		Response.Write(" <td class='corpo7'>" & ls_Int & "&nbsp;</td>")
		Response.Write(" <td class='corpo7'>" & ls_Dac & "</td>")
		Response.Write(" <td class='corpo6' align='left'>" & ls_Observacao & "</td>")
		Response.Write(" <td class='corpo7' height='20'></td>")
		Response.Write("</tr>")
		
		intContador = intContador + 1
		Rs.Movenext
		
		If Rs.EOF Then
			lb_quebra = True
		Else
			lb_quebra = ( Rs("dtoper") <> dt_dtoper )
		End if
		
		If lb_quebra Then
			Response.Write(	"<tr bgcolor='#AAAAAA'>")
			Response.Write(		"<td class='corpo6' colspan='3' style='border: 1px solid black;'>")
			Response.Write(			"<b>Total do dia:</b>")
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' colspan='4' align='right' style='border: 1px solid black;'>")
			Response.Write(			ll_totalvoos & "&nbsp;Ciclos")
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' colspan='2' align='right' style='border: 1px solid black;'>")
			Response.Write(			FormatNumber(ll_totalminoper / 60,2)  & "&nbsp;hr. oper.")
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' colspan='4' align='right' style='border: 1px solid black;'>")
			Response.Write(			FormatNumber(ll_totalminvoo / 60,2)  & "&nbsp;hr. voadas")
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalpaxeconomica)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalpaxgratis)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalbordo)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totaltrc)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalpaxemblocal)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalpaxtransito)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
			Response.Write(			ll_totalembarcado)
			Response.Write(		"</td>")
			Response.Write(		"<td class='corpo6' align='center' colspan='3' style='border: 1px solid black;'>&nbsp;</td>")
			Response.write(	"</tr>")

			ll_totalvoos_geral = ll_totalvoos_geral + ll_totalvoos
			ll_totalminoper_geral = ll_totalminoper_geral + ll_totalminoper
			ll_totalminvoo_geral = ll_totalminvoo_geral + ll_totalminvoo
			ll_totalpaxeconomica_geral = ll_totalpaxeconomica_geral + ll_totalpaxeconomica
			ll_totalpaxespecial_geral = ll_totalpaxespecial_geral + ll_totalpaxespecial
			ll_totalpaxturismo_geral = ll_totalpaxturismo_geral + ll_totalpaxturismo
			ll_totalpaxgratis_geral = ll_totalpaxgratis_geral + ll_totalpaxgratis
			ll_totalbordo_geral = ll_totalbordo_geral + ll_totalbordo
			ll_totaltrc_geral = ll_totaltrc_geral + ll_totaltrc
			ll_totalpaxemblocal_geral = ll_totalpaxemblocal_geral + ll_totalpaxemblocal
			ll_totalpaxtransito_geral = ll_totalpaxtransito_geral + ll_totalpaxtransito
			ll_totalembarcado_geral = ll_totalembarcado_geral + ll_totalembarcado

			'Response.Write(ll_totalvoos_geral & "<BR>" & ll_totalminoper_geral & "<BR>" & FormatNumber(ll_totalminoper_geral / 60,1) & "<BR>" & ll_totalminvoo_geral & "<BR>" & ll_totalpaxeconomica_geral & "<BR>" & ll_totalpaxespecial_geral & "<BR>" & ll_totalpaxturismo_geral & "<BR>" & ll_totalpaxgratis_geral & "<BR>" & ll_totalpaxemblocal_geral & "<BR>" & ll_totalpaxtransito_geral)
			'Response.End()

			If Rs.EOF Then
				' Mostra o total geral
				Response.Write(	"<tr bgcolor='#AAAAAA'>")
				Response.Write(		"<td class='corpo6' colspan='3' style='border: 1px solid black;'>")
				Response.Write(			"<b>Total do Período:</b>")
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' colspan='4' align='right' style='border: 1px solid black;'>")
				Response.Write(			ll_totalvoos_geral & "&nbsp;Ciclos")
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' colspan='2' align='right' style='border: 1px solid black;'>")
				Response.Write(			FormatNumber(ll_totalminoper_geral / 60,2) & "&nbsp;hr. oper.")
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' colspan='4' align='right' style='border: 1px solid black;'>")
				Response.Write(			FormatNumber(ll_totalminvoo_geral / 60,2) & "&nbsp;hr. voadas")
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalpaxeconomica_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalpaxgratis_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalbordo_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totaltrc_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalpaxemblocal_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalpaxtransito_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' style='border: 1px solid black;'>")
				Response.Write(			ll_totalembarcado_geral)
				Response.Write(		"</td>")
				Response.Write(		"<td class='corpo6' align='center' colspan='3' style='border: 1px solid black;'>&nbsp;</td>")
				Response.write(	"</tr>")
			End if
			
			Response.Write("</table>")
			Response.Write("<br />")
'Response.Write("</div>")                            '// COLOCADO PARA FECHAR A DIV QUE MUDA DE LADO			
'Response.Write("<div class= 'breakbefore'>Page break before here.</div>") 
			
			ll_totalvoos = 0
			ll_totalminoper = 0
			ll_totalminvoo = 0
			ll_totalpaxeconomica = 0
			ll_totalpaxespecial = 0
			ll_totalpaxturismo = 0
			ll_totalpaxgratis = 0
			ll_totalbordo = 0
			ll_totalpaxemblocal = 0
			ll_totaltrc = 0
			ll_totalpaxtransito = 0
			ll_totalembarcado = 0
		End if 
		
		dt_DtOper_Ant = dt_DtOper
	Loop	
	
	Response.Write("</tbody>")
	Response.Write("</table>")
End IF	
%>			           
<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div> 	
</body>
</html>
