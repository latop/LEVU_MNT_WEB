<!--#include file="header.asp"-->
<!--#include file="verify_login.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<html><head>
<TITLE>Sigla - Coordenação de Voo [Horário Oficial do Brasil]</TITLE>
<span style="font-family: arial ; sans-serif"  >
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="javascript.js"></script>

<style type="text/css">

	#dhtmltooltip{
		position: absolute;
		width: 150px;
		border: 2px solid black;
		padding: 2px;
		background-color: lightyellow;
		visibility: hidden;
		z-index: 100;
		filter: progid:DXImageTransform.Microsoft.Shadow(color=gray,direction=135);
	}

</style>
</head>
<body bgcolor="white" link="blue">
<div id="dhtmltooltip"></div>
<script src="tooltip.js"></script>
<script language="javascript">
function ZoomMais()
{
	var resaux = parseInt(document.getElementById("resolucao").value);
	resaux = resaux - 128;
	document.body.style.zoom = screen.width/resaux ;
	document.getElementById("resolucao").value = resaux;
}

function ZoomMenos()
{
	var resaux = parseInt(document.getElementById("resolucao").value);
	resaux = resaux + 128;
	document.body.style.zoom = screen.width/resaux;
	document.getElementById("resolucao").value = resaux;
}
$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data").mask("99/99/9999");	
});

function VerificaCampos() {
	if (window.form1.txt_Data.value == "") {
		alert('Preencha o campo Data!');
		window.form1.txt_Data.focus();
		return false;
	}
}	
</script>
<STYLE type="text/css">
	 TABLE { empty-cells: show; }
	 body {
	margin-left: 0px;
}
</style>
<STYLE>
  .clsTeenyWeeny  { zoom: 0.10 }
</STYLE>

<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
   <tr>
      <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
         <img style="height:35px" src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center" width="30%" rowspan="2">
         <font size="4"><b>Coordenação de Voo<br /><label class="CORPO7">(Horário oficial do Brasil)</label></b></font>
      </td>
      <td class="corpo" align="right" valign="top" width="35%">
         <a href="http://www.latop.com.br"><img style="height:35px" src="imagens/sigla.gif" border="0"></a>
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

If (Session("dominio") <> 3) and f_permissao( ll_menu_sequsuario, "I11", Menu_Conn, Menu_RS ) = "" Then
    Response.Write("<h1>Acesso negado.</h1>")
    Response.End()
End IF

Dim dia, mes, ano, ll_dia1, ll_mes1, ll_ano1, ldt_data, ll_dia2, ll_mes2, ll_ano2, ldt_data1, ldt_data2, dtData_Corrente
Dim Conn, RS, sSql, ls_sqlfrota, ll_seqatividade
Dim ls_codfrota_vet, ll_seqfrota_vet
Dim ls_textura, ll_contador, Contador
Dim Aviao_ant, DataHora_Ult, Aviao, Partida, Chegada, Voo, trecho, VooDia
Dim Origem, Ordem, Ordem_ant, Frota, Cor_vet, CorFrota, SeqAtividade
Dim dia_Semana_Vet, mes_Vet, semana
Dim ll_width, cor_hora_vet
Dim paxpago, paxchd, paxinf, paxadt
Dim PartidaReal, ChegadaReal
Dim Decolagem, Pouso

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

ll_dia1 = Day(Request.Form( "txt_Data" ))
ll_mes1 = Month(Request.Form( "txt_Data" ))
ll_ano1 = Year(Request.Form( "txt_Data" ))
ldt_data = ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1

dia = ll_dia1
%>
<br />  
<form method='post' action="CoordenacaoGrafico.asp" name="form1" id="form1" onSubmit="Javascript: return VerificaCampos();">
	<%
   ' Executa função para gravar na sig_usuariolog
     If f_grava_usuariolog( "I11", Conn ) > "" Then
        Response.End()
     End if
   %>        
  
   
   <table width="98%" border="0">
      <tr>
         <td class='CORPO' align="left">
            <b>A Partir de:</b>
            <input type="text" name="txt_Data" id="txt_Data"  size="11" maxlength="10" value="<%=Request.Form("txt_Data")%>"/>&nbsp;               
            <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>&nbsp;&nbsp;&nbsp;
            <input type='submit' name='submit' value='Pesquisar' tabindex='3' class="botao1">&nbsp;&nbsp;&nbsp;
            <input type="hidden" name='resolucao' id="resolucao" value=''>
         </td>
         <td class='CORPO' align="left" width="40">
            <b>Frota:</b>
         </td>
<%   

		Dim ls_frotaselected_vet
	
		''''''''''''''''''''''''''''''''''''''''''
		' Recupera as Frotas
		''''''''''''''''''''''''''''''''''''''''''
		ls_sqlfrota = "SELECT seqfrota, codfrota FROM sig_frota WHERE sig_frota.flgfrotaempresa = 'S' ORDER BY codfrota"
		Set RS = Conn.Execute(ls_sqlfrota)
		
		
		ls_codfrota_vet = ""
		ll_seqfrota_vet = ""
		
		Do While Not RS.Eof
		   ll_seqfrota_vet = ll_seqfrota_vet & RS( "seqfrota" ) & ","
		   ls_codfrota_vet = ls_codfrota_vet & RS( "codfrota" ) & ","
			If Request.Form( "frota_" & RS( "codfrota" ) ) = "" Then
				ls_frotaselected_vet = ls_frotaselected_vet & "off,"
			Else
			ls_frotaselected_vet = ls_frotaselected_vet & Request.Form( "frota_" & RS( "codfrota" ) ) & ","
			End if
		   RS.MoveNext
		Loop
		
		ll_seqfrota_vet = Split( Left(ll_seqfrota_vet,Len(ll_seqfrota_vet)-1), "," )
		ls_codfrota_vet = Split( Left(ls_codfrota_vet,Len(ls_codfrota_vet)-1), "," )
		ls_frotaselected_vet = Split( Left(ls_frotaselected_vet,Len(ls_frotaselected_vet)-1), "," )



		Dim ls_infrota

        ls_infrota = " "
			
			FOR ll_contador = 0 TO UBound( ls_codfrota_vet )
            Response.Write( "<td class='CORPO' align='left' width='20'>" )
            Response.Write( "<input TYPE='checkbox' NAME='frota_" & ls_codfrota_vet(ll_contador) & "' " )
            If ls_frotaselected_vet(ll_contador) = "on" Then
               ls_infrota = ls_infrota & ll_seqfrota_vet(ll_contador) & ","
               Response.Write( "checked" )
            End If
            Response.Write( "/>" )
            Response.Write( "</td>" )
            Response.Write( "<td class='CORPO' align='left' width='31'>" )
            Response.Write( ls_codfrota_vet(ll_contador) )
            Response.Write( "</td>" )
         NEXT

        ls_infrota = Left( ls_infrota, Len(ls_infrota) - 1 )



		
		
				
		Dim i, qntFrota, tamVetor, temp, tamanhoStr
		Dim auxSQL
		Dim temFrota
		
		temFrota = false
		auxSQL = ""	
		qntFrota = 0 
		tamVetor = ubound(ll_seqfrota_vet) 
		
'		for i = 0 to tamVetor 
'			response.write("<br/>ll_seqfrota_vet("+ cstr(i) + ") = " + cstr(ll_seqfrota_vet(i)))
'		next
'			
'		
'		for i = 0 to tamVetor
'			response.write("<br/>ls_codfrota_vet("+ cstr(i) + ") = " +ls_codfrota_vet(i))
'		next
'		for i = 0 to tamVetor
'				response.write("<br/>ls_frotaselected_vet("+ cstr(i) + ") = " +ls_frotaselected_vet(i))
'		next
		
		
		
		FOR i = 0 TO tamVetor    ' sempre 4 nesse caso
			if (ls_frotaselected_vet(i) = "on" ) then
				temFrota = true
				qntFrota = qntFrota + 1
			end if
		next
		
		if (temFrota = true) then 
			if ( qntFrota = 1) then
				for i = 0 to tamVetor
					if (ls_frotaselected_vet(i) = "on") then
'						response.write("<br/>apenas um selecionado")
						auxSQL = "and sig_frota.seqfrota in (" + cstr(ll_seqfrota_vet(i))
					end if
				next
			else           ' até acima tudo ok
'				response.write("<br/>tem mais de um selecionado")
				auxSQL = "and sig_frota.seqfrota in ("
				temp = qntFrota
				for i = 0 TO tamVetor				
					if ((ls_frotaselected_vet(i) = "on") and (temp > 0)) then
						temp = temp - 1
						auxSQL = auxSQL + cstr(ll_seqfrota_vet(i)) + ","
					else 
						if ((ls_frotaselected_vet(i) = "on") and (temp = 0)) then
							temp = temp - 1
							auxSQL = auxSQL + cstr(ll_seqfrota_vet(i))
						end if
					end if
				next		
				auxSQL = mid(auxSQL, 1, len(auxSQL)-1)			
			end if
			
'			tamanhoStr = len(auxSQL)
'			response.write("<br/>tamanhoStr = " + cstr(tamanhoStr))
'			response.write("<br/>" + mid(auxSQL, 1, len(auxSQL)-1))
			auxSQL = auxSQL + ")"
'			response.write("<br/>qntFrota selecionados = " + cstr(qntFrota) + "<br/>")
			
		end if

						
						
						
						
						
'						
'						if ( (i < tamVetor ) and
'						auxSQL = auxSQL + cstr(ll_seqfrota_vet(i)) + ","
'					else
'						if ( (i = tamVetor) and (ls_frotaselected_vet(i) = "on")) then
'							auxSQL = auxSQL + cstr(ll_seqfrota_vet(i))
'						end if
'					end if
'				next
'			end if
'			auxSQL = auxSQL + ")"
'			response.write("<br/>qntFrota selecionados = " + cstr(qntFrota) + "<br/>")
'		end if
					
'		response.write("<br/>" + auxSQL)
'		response.write("<br/>tamVetor = " + cstr(tamVetor) )

%>
         <td width="70" align="right" valign="bottom">
            <a href="#" onClick="ZoomMenos(); return false;" ><img src="imagens/lentemenos.gif" border="0" width="25" valign="botton"></a><a href="#" onClick="ZoomMais(); return false;"><img src="imagens/lentemais.gif" border="0" width="25" ></a>
         </td>
      </tr>
   </table>
<table width="98%">
      <tr>
         <td> 
            
            <%
            if isdate(ldt_data) and ll_ano1 > 1900 Then
					ll_ano2 = Day(Request.Form( "txt_Data" ))
					ll_mes2 = Month(Request.Form( "txt_Data" ))
					ll_dia2 = Year(Request.Form( "txt_Data" ))
            
					ldt_data1 = ll_ano2 & "/" & ll_mes2 & "/" & ll_dia2
					ldt_data1 = DateAdd("d",6,ldt_data1)
            
					ll_ano2 = Year(ldt_data1)
					ll_mes2 = Month(ldt_data1)
					ll_dia2 = Day(ldt_data1)
																
					ldt_data1 = ll_ano2 & "/" & ll_mes2 & "/" & ll_dia2
				%>
            <table border="0" cellspacing="0" frame="below">
               <tr>
                  <td>
                     <table border="0" cellspacing="0" width="150">
                     </table>
                  </td>
                  <td>
				<%
					dia_Semana_Vet = "Domingo,Segunda-feira,Terça-feira,Quarta-feira,Quinta-feira,Sexta-feira,Sábado"
					dia_Semana_Vet = SPLIT(dia_Semana_Vet,",")
					
					mes_Vet = "Janeiro,Fevereiro,Março,Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro"
					mes_Vet = SPLIT(mes_Vet,",")
					
					ldt_data2 =  ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1
					
					FOR Contador = 1 to 7
				%>
                     <table border="0" cellspacing="0" width="1440" align="left">
                     	<tr>
				<%
                  dtData_Corrente = DateAdd("d",Contador -1,ldt_data2)
                  
                  dia = Day(dtData_Corrente)
                  mes = Month(dtData_Corrente)
                  ano = Year(dtData_Corrente)
                  semana = WeekDay(dtData_Corrente)
                                                                              
						Response.Write("<td align='center' class='corpo9'><b>"& dia_Semana_Vet(semana -1) &", "& dia &" de "& mes_Vet(mes -1) &"                                                                      de "& ano & "</b></td>" )
				%>
                        </tr>
                     </table>
				<%
					NEXT
					
					cor_hora_vet = "#CCCCCC,#999999"
					cor_hora_vet = SPLIT(cor_hora_vet,",") 
					
            %>
         </td>
      </tr>
   </table>
                                                   <table border="1" bordercolor="000000" cellspacing="0" frame="below">
                                                     <tr>
                                                      <td height="1">
                                                           <table width="70" border="0" cellspacing="0">
                                                               <tr>
                                                                  <td  height="1" align="center" ><FONT SIZE='2'>Aeronaves</td>
                                                               </tr>
                                                           </table>
                                                        <td height="1" align="center" >
                                                             <table width="900" border="0" bordercolor="000000" cellspacing="0" cellpadding="0" frame="void" rules="cols">
                                                                  <tr>
                                                                     <td height="1" align="center" >
                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                           <tr>
                                       <%
                                                                                  For ll_contador = 0 To ( 24 * 7 ) - 1
                                       %>
                                                                              <td>
                                                                                 <table width="60" border="0" cellspacing="0" cellpadding="0" >
                                                                                    <tr>
                                                                                       <td bgcolor="<%=cor_hora_vet(ll_contador MOD 2)%>" align="center" height="1" class="Corpo8Bold"><%Response.Write( ll_contador Mod 24 )%></td>
                                                                                    </tr>
                                                                                 </table>
                                                                              </td>
                                       <%
                                                                                  Next
                                       %>
                                                                           </tr>
                                                                        </table>
                                                                     </td>
                                                                  </tr>
                                                             </table>
                                                        </td>
                                                      </td>
                                                     </tr>
                                                   </table>
                                            
<%
                                       			' ORDEM = 0: PREVISTO
																' ORDEM = 1: REALIZADO
																' Recupera as informações Planejadas
                                                sSql =        "SELECT sig_diariovoo.seqvoodia, "
                                                sSql = sSql &   "sig_diariovoo.nrvoo, "
                                                sSql = sSql &   "'' as codatividade, "
                                                sSql = sSql &   "sig_diariotrecho.seqtrecho, "
                                                sSql = sSql &   "0 as seqatividade, "
												sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diariotrecho.prefixoaeronave, "
                                                sSql = sSql &   "aeroporig.codiata origem, "
                                                sSql = sSql &   "aeropdest.codiata destino, "
																sSql = sSql &   "sig_diariotrecho.decolagem, "
																sSql = sSql &   "sig_diariotrecho.pouso, "
																sSql = sSql &   "sig_diariotrecho.paxpago, "
																sSql = sSql &   "sig_diariotrecho.paxchd, "
																sSql = sSql &   "sig_diariotrecho.paxinf, "
                                                sSql = sSql &   "sig_diariotrecho.partidaprev as partida, "
                                                sSql = sSql &   "sig_diariotrecho.chegadaprev as chegada, "
                                                sSql = sSql &   "0 as ORDEM, "
                                                sSql = sSql &   "'textura01.jpg' as textura "
                                                sSql = sSql & "FROM sig_diariovoo, "
                                                sSql = sSql &   "sig_diariotrecho, "
                                                sSql = sSql &   "sig_aeroporto aeroporig, "
                                                sSql = sSql &   "sig_aeroporto aeropdest, "
                                                sSql = sSql &   "sig_frota "
                                                sSql = sSql & "WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.flgcancelado = 'N' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.flghotran = 'S' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidaprev <='" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.chegadaprev >= '"&ldt_data&"' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.prefixoaeronave IS NOT NULL) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidaprev IS NOT NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.chegadaprev IS NOT NULL ) " & auxSQL																
                                                sSql = sSql & "UNION "
																' Recupera as informações Previstas
																sSql = sSql & "SELECT sig_diariovoo.seqvoodia, "
                                                sSql = sSql &   "sig_diariovoo.nrvoo, "
                                                sSql = sSql &   "'' as codatividade, "
                                                sSql = sSql &   "sig_diariotrecho.seqtrecho, "
                                                sSql = sSql &   "0 as seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diariotrecho.prefixoaeronave, "
                                                sSql = sSql &   "aeroporig.codiata origem, "
                                                sSql = sSql &   "aeropdest.codiata destino, "
																sSql = sSql &   "sig_diariotrecho.decolagem, "
																sSql = sSql &   "sig_diariotrecho.pouso, "
																sSql = sSql &   "sig_diariotrecho.paxpago, "
																sSql = sSql &   "sig_diariotrecho.paxchd, "
																sSql = sSql &   "sig_diariotrecho.paxinf, "
                                                sSql = sSql &   "sig_diariotrecho.partidaprev as partida, "
                                                sSql = sSql &   "sig_diariotrecho.chegadaprev as chegada, "
                                                sSql = sSql &   "0 as ORDEM, "
                                                sSql = sSql &   "'textura01.jpg' as textura "
                                                sSql = sSql & "FROM sig_diariovoo, "
                                                sSql = sSql &   "sig_diariotrecho, "
                                                sSql = sSql &   "sig_aeroporto aeroporig, "
                                                sSql = sSql &   "sig_aeroporto aeropdest, "
                                                sSql = sSql &   "sig_frota "
                                                sSql = sSql & "WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.flgcancelado = 'N' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.flghotran <> 'S' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidaprev <='" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.chegadaprev >= '"&ldt_data&"' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.prefixoaeronave IS NOT NULL) " & auxSQL
                                                sSql = sSql & "UNION "
																' Recupera as informações realizadas
                                                sSql = sSql & "SELECT sig_diariovoo.seqvoodia, "
                                                sSql = sSql &   "sig_diariovoo.nrvoo, "
                                                sSql = sSql &   "'' as codatividade, "
                                                sSql = sSql &   "sig_diariotrecho.seqtrecho, "
                                                sSql = sSql &   "0 as seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diariotrecho.prefixoaeronave, "
                                                sSql = sSql &   "aeroporig.codiata origem, "
                                                sSql = sSql &   "aeropdest.codiata destino, "
																sSql = sSql &   "sig_diariotrecho.decolagem, "
																sSql = sSql &   "sig_diariotrecho.pouso, "
																sSql = sSql &   "sig_diariotrecho.paxpago, "
																sSql = sSql &   "sig_diariotrecho.paxchd, "
																sSql = sSql &   "sig_diariotrecho.paxinf, "
                                                sSql = sSql &   "sig_diariotrecho.partidamotor as partida, "
                                                sSql = sSql &   "sig_diariotrecho.cortemotor as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura03.jpg' as textura "
                                                sSql = sSql & "FROM sig_diariovoo, "
                                                sSql = sSql &   "sig_diariotrecho, "
                                                sSql = sSql &   "sig_aeroporto aeroporig, "
                                                sSql = sSql &   "sig_aeroporto aeropdest, "
                                                sSql = sSql &   "sig_frota "
                                                sSql = sSql & "WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.flgcancelado = 'N' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidamotor <='" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.cortemotor >= '"&ldt_data&"' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidamotor IS NOT NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.cortemotor IS NOT NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "UNION "
																' Recupera as informações realizadas (ESTIMADAS)
                                                sSql = sSql & "SELECT sig_diariovoo.seqvoodia, "
                                                sSql = sSql &   "sig_diariovoo.nrvoo, "
                                                sSql = sSql &   "'' as codatividade, "
                                                sSql = sSql &   "sig_diariotrecho.seqtrecho, "
                                                sSql = sSql &   "0 as seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diariotrecho.prefixoaeronave, "
                                                sSql = sSql &   "aeroporig.codiata origem, "
                                                sSql = sSql &   "aeropdest.codiata destino, "
																sSql = sSql &   "sig_diariotrecho.decolagem, "
																sSql = sSql &   "sig_diariotrecho.pouso, "
																sSql = sSql &   "sig_diariotrecho.paxpago, "
																sSql = sSql &   "sig_diariotrecho.paxchd, "
																sSql = sSql &   "sig_diariotrecho.paxinf, "
                                                sSql = sSql &   "sig_diariotrecho.partidaest as partida, "
                                                sSql = sSql &   "sig_diariotrecho.chegadaest as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura05.jpg' as textura "
                                                sSql = sSql & "FROM sig_diariovoo, "
                                                sSql = sSql &   "sig_diariotrecho, "
                                                sSql = sSql &   "sig_aeroporto aeroporig, "
                                                sSql = sSql &   "sig_aeroporto aeropdest, "
                                                sSql = sSql &   "sig_frota "
                                                sSql = sSql & "WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.flgcancelado = 'N' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidaest <='" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.chegadaest >= '"&ldt_data&"' ) "
																'sSql = sSql &   "AND ( sig_diariotrecho.partidaest > '"&ldt_data&"' )"
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidamotor IS NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "UNION "
																
																sSql = sSql & "SELECT sig_diariovoo.seqvoodia, "
                                                sSql = sSql &   "sig_diariovoo.nrvoo, "
                                                sSql = sSql &   "'' as codatividade, "
                                                sSql = sSql &   "sig_diariotrecho.seqtrecho, "
                                                sSql = sSql &   "0 as seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diariotrecho.prefixoaeronave, "
                                                sSql = sSql &   "aeroporig.codiata origem, "
                                                sSql = sSql &   "aeropdest.codiata destino, "
																sSql = sSql &   "sig_diariotrecho.decolagem, "
																sSql = sSql &   "sig_diariotrecho.chegadaprev pouso, "
																sSql = sSql &   "sig_diariotrecho.paxpago, "
																sSql = sSql &   "sig_diariotrecho.paxchd, "
																sSql = sSql &   "sig_diariotrecho.paxinf, "
                                                sSql = sSql &   "sig_diariotrecho.partidamotor as partida, "
                                                sSql = sSql &   "sig_diariotrecho.chegadaest as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura06.jpg' as textura "
                                                sSql = sSql & "FROM sig_diariovoo, "
                                                sSql = sSql &   "sig_diariotrecho, "
                                                sSql = sSql &   "sig_aeroporto aeroporig, "
                                                sSql = sSql &   "sig_aeroporto aeropdest, "
                                                sSql = sSql &   "sig_frota "
                                                sSql = sSql & "WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.flgcancelado = 'N' ) "
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidaest <='" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diariotrecho.chegadaest >= '"&ldt_data&"' ) "
																'sSql = sSql &   "AND ( sig_diariotrecho.partidaest > '"&ldt_data&"' )"
                                                sSql = sSql &   "AND ( sig_diariotrecho.partidamotor IS NOT NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.cortemotor IS NULL ) "
																sSql = sSql &   "AND ( sig_diariotrecho.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "UNION "
																' Recupera as informações da manutenção Prevista
                                                sSql = sSql & "SELECT 0, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.codatividade, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diarioatividade.prefixoaeronave, "
                                                sSql = sSql &   "sig_aeroporto.codiata as origem, "
                                                sSql = sSql &   "sig_aeroporto.codiata as destino, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.dtinicio as partida, "
                                                sSql = sSql &   "sig_diarioatividade.dtfim as chegada, "
                                                sSql = sSql &   "0 as ORDEM, "
                                                sSql = sSql &   "'textura04.jpg' as textura "
                                                sSql = sSql & "FROM sig_diarioatividade, "
                                                sSql = sSql &   "sig_aeronave, "
                                                sSql = sSql &   "sig_frota, "
                                                sSql = sSql &   "sig_aeroporto "
                                                sSql = sSql & "WHERE ( sig_diarioatividade.prefixoaeronave = sig_aeronave.prefixored ) "
                                                sSql = sSql &   "AND ( sig_aeronave.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.seqaeroporto = sig_aeroporto.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtinicio IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfim IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfim > '" & ldt_data & "' ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtinicio < '" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diarioatividade.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "UNION "
																
                                                sSql = sSql & "SELECT 0, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.codatividade, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diarioatividade.prefixoaeronave, "
                                                sSql = sSql &   "sig_aeroporto.codiata as origem, "
                                                sSql = sSql &   "sig_aeroporto.codiata as destino, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.dtiniciorealiz as partida, "
                                                sSql = sSql &   "sig_diarioatividade.dtfim as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura06.jpg' as textura "
                                                sSql = sSql & "FROM sig_diarioatividade, "
                                                sSql = sSql &   "sig_aeronave, "
                                                sSql = sSql &   "sig_frota, "
                                                sSql = sSql &   "sig_aeroporto "
                                                sSql = sSql & "WHERE ( sig_diarioatividade.prefixoaeronave = sig_aeronave.prefixored ) "
                                                sSql = sSql &   "AND ( sig_aeronave.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.seqaeroporto = sig_aeroporto.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtiniciorealiz IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfimrealiz IS NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfim > '" & ldt_data & "' ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtiniciorealiz < '" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diarioatividade.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "UNION "
																' Recupera as informações realizadas, com Data Início e Fim informados
                                                sSql = sSql & "SELECT 0, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.codatividade, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diarioatividade.prefixoaeronave, "
                                                sSql = sSql &   "sig_aeroporto.codiata as origem, "
                                                sSql = sSql &   "sig_aeroporto.codiata as destino, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.dtiniciorealiz as partida, "
                                                sSql = sSql &   "sig_diarioatividade.dtfimrealiz as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura07.jpg' as textura "
                                                sSql = sSql & "FROM sig_diarioatividade, "
                                                sSql = sSql &   "sig_aeronave, "
                                                sSql = sSql &   "sig_frota, "
                                                sSql = sSql &   "sig_aeroporto "
                                                sSql = sSql & "WHERE ( sig_diarioatividade.prefixoaeronave = sig_aeronave.prefixored ) "
                                                sSql = sSql &   "AND ( sig_aeronave.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.seqaeroporto = sig_aeroporto.seqaeroporto ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtiniciorealiz IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfimrealiz IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfimrealiz > '" & ldt_data & "' ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtiniciorealiz < '" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diarioatividade.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                'sSql = sSql & "ORDER by sig_frota.seqfrota, sig_diariotrecho.prefixoaeronave, ORDEM, "
                                                'sSql = sSql &   "partida "
                                       			sSql = sSql & "UNION "
																' Recupera as informações realizadas, com Data Início e Fim informados
                                                sSql = sSql & "SELECT 0, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.codatividade, "
                                                sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.seqatividade, "
																sSql = sSql &   "sig_frota.seqfrota, "
                                                sSql = sSql &   "sig_frota.codfrota, "
                                                sSql = sSql &   "sig_frota.corfrota, "
                                                sSql = sSql &   "sig_diarioatividade.prefixoaeronave, "
                                                sSql = sSql &   "sig_aeroporto.codiata as origem, "
                                                sSql = sSql &   "sig_aeroporto.codiata as destino, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "Null, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
																sSql = sSql &   "0, "
                                                sSql = sSql &   "sig_diarioatividade.dtinicio as partida, "
                                                sSql = sSql &   "sig_diarioatividade.dtfim as chegada, "
                                                sSql = sSql &   "1 as ORDEM, "
                                                sSql = sSql &   "'textura05.jpg' as textura "
                                                sSql = sSql & "FROM sig_diarioatividade, "
                                                sSql = sSql &   "sig_aeronave, "
                                                sSql = sSql &   "sig_frota, "
                                                sSql = sSql &   "sig_aeroporto "
                                                sSql = sSql & "WHERE ( sig_diarioatividade.prefixoaeronave = sig_aeronave.prefixored ) "
                                                sSql = sSql &   "AND ( sig_aeronave.seqfrota = sig_frota.seqfrota ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.seqaeroporto = sig_aeroporto.seqaeroporto ) "
																sSql = sSql &   "AND ( sig_diarioatividade.dtinicio IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfim IS NOT NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtiniciorealiz IS NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfimrealiz IS NULL ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtfim > '" & ldt_data & "' ) "
                                                sSql = sSql &   "AND ( sig_diarioatividade.dtinicio < '" & ldt_data1 & " 23:59' ) "
																sSql = sSql &   "AND ( sig_diarioatividade.prefixoaeronave IS NOT NULL) " & auxSQL																
                                                sSql = sSql & "ORDER by sig_frota.seqfrota, sig_diariotrecho.prefixoaeronave, ORDEM, "
                                                sSql = sSql &   "partida "
																
                                       
                                          'Executamos a ordem
                                          set RS = Conn.Execute(sSql)
                                       
                                          Aviao_ant = ""
                                          Ordem_ant = "0"
                                       
					DO WHILE NOT RS.EOF
						Aviao= RS("prefixoaeronave")
						Partida = RS("partida")
						Chegada = RS("chegada")
						Voo = RS("nrvoo")
						Origem = RS("origem")
						Ordem = RS("ORDEM")
						VooDia = RS("seqvoodia")
						Trecho = RS("seqtrecho")
						Frota = RS("codfrota")
						ls_textura = RS("textura")
						ll_seqatividade = RS("seqatividade")
						paxpago = RS("paxpago")
						If IsNull(paxpago) Then
							paxpago = 0
						End If
						paxchd = RS("paxchd")
						If IsNull(paxchd) Then
							paxchd = 0
						End If
						paxinf =RS("paxinf")
						paxadt = CInt(paxpago) - CInt(paxchd)
						PartidaReal = RS("partida")
						ChegadaReal = RS("chegada")
						Decolagem = RS("decolagem")
						Pouso = RS("pouso")
						If IsNull(Pouso) then
							Pouso = ChegadaReal
						End If
						If DateDiff( "n", Partida, ldt_data & " 00:00" ) > 0 Then
							Partida = ldt_data & " 00:00" 
						End if
						If DateDiff( "n", Chegada, ldt_data1 & " 23:59" ) < 0 Then
							Chegada = ldt_data1 & " 23:59"
						End if
						Cor_vet =                            ",#000000,#FFFFFF,#800000,#FF0000,#80FF80,#FFFF00,#00FF00,#80FF00,#80FFFF,#00FFFF,#004080,#0000FF,#800080,#FF80FF,#808080,#C0C0C0"
						Cor_vet = SPLIT(left(Cor_vet, Len(Cor_vet)-1), ",")

                                             If Aviao <> Aviao_ant Then
                                                   If Aviao_ant <> "" Then
                                             			If DateDiff("n",DataHora_Ult,ldt_data1 & " 23:59") > 0 Then
																			Response.Write("   <td>")
																			Response.Write("      <table border='0' cellspacing='0' cellpadding='0' >")
																			Response.Write("          <tr>")
																			Response.Write("                <td height='7'  ><img src='textura02.jpg' width=")
																			Response.Write(                 DateDiff("n",DataHora_Ult,ldt_data1 & " 23:59")/1)
																			Response.Write(               " height='1' border='0' ALT='XY'></td>")
																			Response.Write("          </tr>")
																			Response.Write("      </table>")
																			Response.Write("   </td>")
																		End if
                                                      Response.Write("   </tr>")
                                                      Response.Write(" </table>")
                                                   End If
                                                   CorFrota= RS("corfrota")
                                                   Response.Write("<table border='0' cellspacing='0' cellpadding='0'>")
                                                   Response.Write("   <tr>")
                                                   Response.Write("       <td height='1' bgcolor=" & Cor_vet(CorFrota) & ">")
                                                   Response.Write("            <table  border='0' cellspacing='0' cellpadding='0' Width='77'  >")
                                                   Response.Write("               <tr bgcolor=" & Cor_vet(CorFrota) & ">")
                                                   Response.Write("                  <td width='150' align='center' valign='bottom' height='1' class='CORPO6'>")
																	If  CorFrota <> "2" AND CorFrota <> "5" AND CorFrota <> "6" AND CorFrota <> "7" AND CorFrota <> "8" AND CorFrota <> "9" AND CorFrota <> "10" AND CorFrota <> "16" Then
																	  Response.Write("   <font color='White'> ")
																	End If	
                                                   Response.Write(                        "["& Frota &"]")
                                                   Response.Write("                  </font></td>")
                                                   Response.Write("               </tr>")
                                                   Response.Write("            </table>")
                                                   Response.Write("       </td>")
                                                   Aviao_ant = Aviao
                                                   Ordem_ant = Ordem
                                                   DataHora_Ult = ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1 & " 00:00" 
                                             ElseIf Ordem <> Ordem_Ant Then
                                                   If Aviao_ant <> "" Then
                                                      Response.Write("   </tr>")
                                                      Response.Write("</table>")
                                                   End If
                                                   Response.Write("<table Style='border-bottom: solid' border='0' cellspacing='0' height='5' cellpadding='0'>")
                                                   Response.Write("  <tr>")
                                                   Response.Write("       <td bgcolor=" & Cor_vet(CorFrota) & ">")
                                                   Response.Write("             <table border='0' cellspacing='0' cellpadding='0' Width='77' >")
                                                   Response.Write("                 <tr bgcolor=" & Cor_vet(CorFrota) & ">")
                                                   Response.Write("                  <td width='150' align='center' class='CORPO7' height='5'>")
																	If  CorFrota <> "2" AND CorFrota <> "5" AND CorFrota <> "6" AND CorFrota <> "7" AND CorFrota <> "8" AND CorFrota <> "9" AND CorFrota <> "10" AND CorFrota <> "16" Then
																	  Response.Write(" <font color='White'> ")
																	End If
                                                   Response.Write(                          Aviao)
                                                   Response.Write("                  </font></td>")
                                                   Response.Write("                 </tr>")
                                                   Response.Write("             </table>")
                                                   Response.Write("       </td>")
                                                   Aviao_ant = Aviao
                                                   Ordem_ant = Ordem
                                                   DataHora_Ult = ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1 & " 00:00"
                                             END IF
											If DateDiff("n",DataHora_Ult,Partida) > 0 Then
												Response.Write("            <td>")
												Response.Write("               <table border='0' cellspacing='0' cellpadding='0' >")
												Response.Write("                  <tr>")
												Response.Write("                     <td height='1'  ><img src='textura02.jpg' width=")
												Response.Write(                          DateDiff("n",DataHora_Ult,Partida)/1)
												Response.Write(                          " height='1' border='0' ALT='XY'></td>")
												Response.Write("                  </tr>")
												Response.Write("               </table>")
												Response.Write("            </td>")
											End if
											Response.Write("<td>" & vbCrLf)
											Response.Write("	<table  border='0' cellspacing='0' height='1' cellpadding='0'>" & vbCrLf)
											Response.Write("		<tr>" & vbCrLf)
											If Ordem = 0 Then
												Response.Write("			<td height='1' class='corpo6' >" & Origem & "</td>" & vbCrLf)
											End If
											Response.Write("		</tr>" & vbCrLf)
											Response.Write("		<tr>" & vbCrLf)

											If ll_seqatividade = "0" then
												If DateDiff("n",Partida,DataHora_Ult) > 0 Then
													' Se a partida for menor que a Última hora
													ll_width = DateDiff("n",DataHora_Ult,Chegada)/1
												Else
													ll_width = DateDiff("n",Partida,Chegada)/1
												End if
												Response.Write("			<td height='1' class='CORPO6' style='cursor:pointer;' ")
												Response.Write("background='imagens/" & ls_textura & "' ")
												Response.Write("width='" & ll_width & "' ")
												Response.Write("border='0' ")
												Response.Write("onmouseout='hideddrivetip()' ")
												Response.Write("onclick=""window.open('CoordenacaoGraficoDetalhes.asp?VooDia=" & RS("seqvoodia") & "&Trecho=" & RS("seqtrecho") & "&SeqAtividade=" & RS("seqatividade") & "','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=900,height=500');return false;"" ")

												If Ordem = 0 Then
													Response.Write("onmouseover=""ddrivetip('<font class=corpo8>[" & Frota & "] " & Aviao & " - " & Voo & "<br />" & FormatDateTime(PartidaReal,4) & "-" & FormatDateTime(ChegadaReal,4) & "<br />Pax:" & paxadt & "/" & paxchd & "/" & paxinf & "</font>','','120')"" ")
												Else
													If  ls_textura <> "textura05.jpg" Then
														Response.Write("onmouseover=""ddrivetip('<font class=corpo8>[" & Frota & "] " & Aviao & " - " & Voo & "<br />" & FormatDateTime(PartidaReal,4) & "/" & Right(00&Minute(Decolagem),2) & "&nbsp;-&nbsp;" & FormatDateTime(Pouso,4) & "/" & Right(00&Minute(ChegadaReal),2) & "<br />Pax:" & paxadt & "/" & paxchd & "/" & paxinf & "</font>','','130')"" ")
													Else
														Response.Write("onmouseover=""ddrivetip('<font class=corpo8>[" & Frota & "] " & Aviao & " - " & Voo & "<br />" & FormatDateTime(PartidaReal,4) & "-" & FormatDateTime(ChegadaReal,4) & "<br />Pax:" & paxadt & "/" & paxchd & "/" & paxinf & "</font>','','120')"" ")
													End If
												End If
												Response.Write(">" & vbCrLf)

											Else
												If DateDiff("n",Partida,DataHora_Ult) > 0 Then
													' Se a partida for menor que a Última hora
													ll_width = DateDiff("n",DataHora_Ult,Chegada)/1
												Else
													ll_width = DateDiff("n",Partida,Chegada)/1
												End if

												Response.Write("			<td height='1' style='font-size:1pt; cursor:pointer;' ")
												Response.Write("onmouseout='hideddrivetip()' ")
												Response.Write("onmouseover=""ddrivetip('<font class=corpo8><center>[" & Frota & "] " & Aviao & "<br />" & Right(00&Day(PartidaReal),2) & "/" & Right(00&Month(PartidaReal),2) & "/" & Year(PartidaReal) & "&nbsp;" & FormatDateTime(PartidaReal,4) & "<br />" & Right(00&Day(ChegadaReal),2) & "/" & Right(00&Month(ChegadaReal),2) & "/" & Year(ChegadaReal) & "&nbsp;" & FormatDateTime(ChegadaReal,4) & "</center></font>','','110')"" ")
												Response.Write("onclick=""window.open('CoordenacaoGraficoDetalhes.asp?VooDia=" & RS("seqvoodia") & "&Trecho=" & RS("seqtrecho") & "&SeqAtividade=" & RS("seqatividade") & "','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=530,height=430');return false;"" >" & vbCrLf)
												Response.Write("				<img  src='imagens/" & ls_textura & "' width='" & ll_width & "'  height='7' border='0' />" & vbCrLf)

											End If

											If ls_textura <> "textura05.jpg" Then
												Response.Write("				<font color='white'>" & Voo & "</font>" & vbCrLf)
											Else
												Response.Write("				<font color='black'>" & Voo & "</font>" & vbCrLf)
											End If

											Response.Write("			</td>" & vbCrLf)
											Response.Write("		</tr>" & vbCrLf)
											Response.Write("		<tr>" & vbCrLf)
											Response.Write("			<td style='font-size: 6pt;' height='1' >" & vbCrLf)
											Response.Write("			</td>" & vbCrLf)
											Response.Write("		</tr>" & vbCrLf)
											Response.Write("	</table>" & vbCrLf)
											Response.Write("</td>" & vbCrLf)

                                             If Voo > "" and ll_width < 23 Then
                                             	DataHora_Ult = DateAdd( "n", 23 - ll_width, Chegada  )
															ElseIf Origem > "" and ll_width < 16 Then
                                             	DataHora_Ult = DateAdd( "n", 16 - ll_width, Chegada )
															Else
                                             	DataHora_Ult = Chegada
															End if
															
                                             RS.MoveNext
                                          Loop
														Response.Write("   <td>")
														Response.Write("      <table border='0' cellspacing='0' cellpadding='0' >")
														Response.Write("          <tr>")
														Response.Write("                <td height='7'  ><img src='textura02.jpg' width=")
														Response.Write(                 DateDiff("n",DataHora_Ult,ldt_data1 & " 23:59")/1)
														Response.Write(               " height='1' border='0' ALT='XY'></td>")
														Response.Write("          </tr>")
														Response.Write("      </table>")
														Response.Write("   </td>")
                                          Response.Write("           </tr>")
                                          Response.Write("         </table>")
                                 End IF

                              'Fechamos o sistema de conexão
                              Conn.Close
                              
                     %>
  
   </table>
   <div style="margin-left:30px">
      <img src="imagens/legenda_coordenacao_voo.gif" />
   </div>
</form>
<script language="javascript">
	document.getElementById("resolucao").value = screen.width
</script>
<div id="calendarDiv"></div>
</body>
</Html>