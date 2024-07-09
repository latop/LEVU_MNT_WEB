<%
' - Se o usuário tiver mais de um cargo no período, está sendo mostrado 2 vezes.
' ok - Alterar o posicionamento da imagem (link) na parte superior, e à direita da célula.
' ok - Tratar quando ainda não houver programação cadastrada.
' - Atualizar a tabela sig_usuariolog;
%>

<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<script language="javascript" src="dinamic_content.js"></script>

<%Server.ScriptTimeout=900%>

<html><head>
<title>SIGLA - Folhão</TITLE>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<span style="font-family: arial ; sans-serif"  >
<script src="javascript.js"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.tablesorter.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>

</head><body bgcolor="white" link="blue">
<div id="dhtmltooltip"></div>

<STYLE type="text/css">
 TABLE { empty-cells: show; }
body {	margin-left: 0px;}


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

<script type="text/javascript">

var offsetxpoint=-60 //Customize x offset of tooltip
var offsetypoint=20 //Customize y offset of tooltip
var ie=document.all
var ns6=document.getElementById && !document.all
var enabletip=false
if (ie||ns6)
var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""

function ietruebody(){
	return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function ddrivetip(thetext, thecolor, thewidth){
	if (ns6||ie){
		if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
		if (typeof thecolor!="undefined" && thecolor!="") tipobj.style.backgroundColor=thecolor
		tipobj.innerHTML=thetext
		enabletip=true
		return false
	}
}

function positiontip(e){
	if (enabletip){
		var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
		var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
		//Find out how close the mouse is to the corner of the window
		var rightedge=ie&&!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
		var bottomedge=ie&&!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20
		
		var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000
		
		//if the horizontal distance isn't enough to accomodate the width of the context menu
		if (rightedge<tipobj.offsetWidth)
			//move the horizontal position of the menu to the left by it's width
			tipobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tipobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tipobj.offsetWidth+"px"
		else if (curX<leftedge)
			tipobj.style.left="5px"
		else
			//position the horizontal position of the menu where the mouse is positioned
			tipobj.style.left=curX+offsetxpoint+"px"
			
		//same concept with the vertical position
		if (bottomedge<tipobj.offsetHeight)
			tipobj.style.top=ie? ietruebody().scrollTop+event.clientY-tipobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tipobj.offsetHeight-offsetypoint+"px"
		else
			tipobj.style.top=curY+offsetypoint+"px"
		tipobj.style.visibility="visible"
	}
}

function hideddrivetip(){
	if (ns6||ie){
		enabletip=false
		tipobj.style.visibility="hidden"
		tipobj.style.left="-1000px"
		tipobj.style.backgroundColor=''
		tipobj.style.width=''
	}
}

document.onmousemove=positiontip

$(document).ready(function($){
	$.mask.addPlaceholder('~',"[+-]");
	$("#txt_Data1").mask("99/99/9999");	
	$("#txt_Data2").mask("99/99/9999");	
});

function VerificaCampos() {
				if (window.Filtro.txt_Data1.value == "") {
					alert('Preencha a 1º Data!');
					window.Filtro.txt_Data1.focus();
					return false;
				}
				else if (window.Filtro.txt_Data2.value == "") {
					alert('Preencha a 2º Data!');
					window.Filtro.txt_Data2.focus();
					return false;1
				}	
		}	
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Folhão
			</b></font>
		</td>
      <td class="corpo" align="right" valign="top" width="35%" colspan="3">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
  	</tr>
   <tr> 
      <td></td>
      <td></td>
   </tr>
   <tr>   
      <td colspan="4">
      	<!--#include file="Menu.asp"-->	
      </td>
   </tr>
</table>

<%
If f_permissao( ll_menu_sequsuario, "I07", Menu_Conn, Menu_RS ) = "" Then
    Response.Write("<h1>Acesso negado.</h1>")
    Response.End()
End IF

Public Function f_permissao_gravacao( ByVal al_sequsuario, ByVal as_codfuncao, as_StringConexaoSqlServer )
   ' Recupera a Permissão do Usuário
	Dim ConnPermissao, RSPermissao

	Set ConnPermissao = CreateObject("ADODB.CONNECTION")
	ConnPermissao.Open (as_StringConexaoSqlServer)

	If CInt( al_sequsuario ) = 1 Then
		f_permissao_gravacao = True
	Else

		Set RSPermissao = ConnPermissao.Execute( "SELECT * FROM sig_usuariofuncao WHERE sequsuario = " & al_sequsuario & " AND codfuncao = '" & as_codfuncao & "'" )
		
		If NOT RSPermissao.EOF Then
			f_permissao_gravacao = ( RSPermissao( "flgpermissao" ) = "A" )
		Else
   		f_permissao_gravacao = False
		End if
	End if
	
	ConnPermissao.Close
End Function

Dim Conn, ConnJornada, RS, RSJornada
Dim lb_permissao
Dim ll_dia, ll_qtddias, ll_dia1, ll_dia2, ll_mes1, ll_mes2, ll_ano1, ll_ano2
Dim ldt_data1, ldt_data2, ldt_data, ls_data
Dim ll_diasemana, ls_diasemana_vet, ls_bgcolor, ls_color
Dim ls_sqlfrota, ls_sqlcargo, ls_sqlbase, ls_sqltripulante, ls_sqljornada
Dim ls_codfrota_vet, ll_seqfrota_vet, ls_frotaselected_vet, ls_infrota
Dim ls_codcargo_vet, ls_cargoselected_vet, ls_incargo
Dim ll_seqcidade_vet, ls_nomecidade_vet, ls_baseselected_vet, ls_inbase
Dim ls_ordenacao
Dim ll_contador, ll_linhatrip
Dim ll_seqtripulante, ll_seqtripulante_ant, ls_nomeguerra, ls_codfrota, ls_codcargo, ls_codcargo_ant
Dim ll_seqcidade, ll_seqcidade_ant, ls_nomecidade, ll_seqfrota, ll_seqfrota_ant
Dim ldt_dtjornada, ll_seqjornada, ls_flgestado, ls_flgotm
Dim ll_coluna_jornada, ldt_data_aux, ldt_dtjornada_aux

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Set ConnJornada = CreateObject("ADODB.CONNECTION")
ConnJornada.Open (StringConexaoSqlServer)
ConnJornada.Execute "SET DATEFORMAT ymd"

ls_diasemana_vet = "Domingo,Segunda,Ter&ccedil;a,Quarta,Quinta,Sexta,S&aacute;bado"
ls_diasemana_vet = Split(ls_diasemana_vet, ",")

If IsDate(Request.Form( "txt_Data1" )) And IsDate(Request.Form( "txt_Data2" )) Then

	ll_dia1 = Day(Request.Form( "txt_Data1" ))
	ll_mes1 = Month(Request.Form( "txt_Data1" ))
	ll_ano1 = Year(Request.Form( "txt_Data1" ))
	ll_dia2 = Day(Request.Form( "txt_Data2" ))
	ll_mes2 = Month(Request.Form( "txt_Data2" ))
	ll_ano2 = Year(Request.Form( "txt_Data2" ))
	
	ldt_data1 = ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1
	ldt_data2 = ll_ano2 & "/" & ll_mes2 & "/" & ll_dia2

End IF

''''''''''''''''''''''''''''''''''''''''''
' Verifica Permissão Gravaçao
''''''''''''''''''''''''''''''''''''''''''
If (Session("dominio") = 1) Then
	lb_permissao = f_permissao_gravacao(Session("member"), "I07", StringConexaoSqlServer)
Else
	lb_permissao = False
End If

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


''''''''''''''''''''''''''''''''''''''''''
' Recupera os Cargos
''''''''''''''''''''''''''''''''''''''''''
ls_sqlcargo = "SELECT sig_cargo.codcargo, sig_cargo.descrcargo FROM sig_cargo ORDER BY sig_cargo.codcargo"
Set RS = Conn.Execute(ls_sqlcargo)

ls_codcargo_vet = ""
ls_cargoselected_vet = ""

Do While Not RS.EOF
   ls_codcargo_vet = ls_codcargo_vet & RS( "codcargo" ) & ","
   ls_cargoselected_vet = ls_cargoselected_vet & Request.Form( "cargo_" & RS( "codcargo" ) ) & ","
   RS.MoveNext
Loop

ls_codcargo_vet = Split( Left(ls_codcargo_vet,Len(ls_codcargo_vet)-1), ",")
ls_cargoselected_vet = Split( Left(ls_cargoselected_vet,Len(ls_cargoselected_vet)-1), "," )

''''''''''''''''''''''''''''''''''''''''''
' Recupera as Bases
''''''''''''''''''''''''''''''''''''''''''
ls_sqlbase = "SELECT sig_basetrip.seqcidade, sig_cidade.codcidade, sig_cidade.nomecidade FROM sig_basetrip, sig_cidade WHERE ( sig_basetrip.seqcidade = sig_cidade.seqcidade ) ORDER BY sig_cidade.nomecidade"
Set RS = Conn.Execute(ls_sqlbase)

ll_seqcidade_vet = ""
ls_nomecidade_vet = ""
ls_baseselected_vet = ""

Do While Not RS.EOF
   ll_seqcidade_vet = ll_seqcidade_vet & RS( "seqcidade" ) & ","
   ls_nomecidade_vet = ls_nomecidade_vet & RS( "nomecidade" ) & ","
	If Request.Form( "base_" & RS( "seqcidade" ) ) = "" Then
		ls_baseselected_vet = ls_baseselected_vet & "off,"
	Else
   	ls_baseselected_vet = ls_baseselected_vet & Request.Form( "base_" & RS( "seqcidade" ) ) & ","
	End if
   RS.MoveNext
Loop

ll_seqcidade_vet = Split( Left(ll_seqcidade_vet,Len(ll_seqcidade_vet)-1), ",")
ls_nomecidade_vet = Split( Left(ls_nomecidade_vet,Len(ls_nomecidade_vet)-1), ",")
ls_baseselected_vet = Split( Left(ls_baseselected_vet, Len(ls_baseselected_vet)-1), ",")

''''''''''''''''''''''''''''''''''''''''''
' Recupera Ordenação (Filtro)
''''''''''''''''''''''''''''''''''''''''''
'ls_ordenacao = Request.Form( "ordenacao" )
ls_ordenacao = "1"

''''''''''''''''''''''''''''''''''''''''''
' Recupera Nome Guerra (Filtro)
''''''''''''''''''''''''''''''''''''''''''
ls_nomeguerra = Request.Form( "nomeguerra" )

%>

<form method='post' action='fol_consulta.asp' name='Filtro' onSubmit="Javascript: return VerificaCampos();">
<%
	' Executa função para gravar na sig_usuariolog
	If f_grava_usuariolog( "I07", Conn ) > "" Then
	  Response.End()
	End if
%>        
   <br>
   <table width="98%">
      <tr>
         <td class='CORPO' align="left">
            <b>Período: </b>
           <label class="Corpo9">
              <input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" class="Corpo9" Value="<%=Request.form("txt_Data1")%>"/>&nbsp;
              <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button> &nbsp;Até:</label>
              <label class="Corpo9">
              <input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10" class="Corpo9"  Value="<%=Request.form("txt_Data2")%>"/>&nbsp;
              <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></label>
         </td>
         <td class="CORPO" align="left" width="51">
            <b>Tripulante:</b>
         </td>
         <td>
            <input type = "text" class='CORPO' NAME="nomeguerra" MaxLength="20" size="20" id="txt_tripulante" value="<%Response.Write(ls_nomeguerra)%>">
         </td>
         <td><input type='submit' name='submit' value='Pesquisar' class='botao1' tabindex='3'></td>
       </tr>
   </table>

   <table>
      <tr>
         <td class='CORPO' align="left" width="51">
            <b>Frota:</b>
         </td>
<%
         ls_infrota = " "
			
			FOR ll_contador = 0 TO UBound( ls_codfrota_vet )
            Response.Write( "<td class='CORPO' align='left' width='20'>" )
            Response.Write( "<input TYPE='checkbox' NAME='frota_" & ls_codfrota_vet(ll_contador) & "' " )
            If ls_frotaselected_vet(ll_contador) = "on" Then
               ls_infrota = ls_infrota & ll_seqfrota_vet(ll_contador) & ","
               Response.Write( "checked" )
            End If
            Response.Write( ">" )
            Response.Write( "<td class='CORPO' align='left' width='50'>" )
            Response.Write( ls_codfrota_vet(ll_contador) )
            Response.Write( "</td>" )
         NEXT

         ls_infrota = Left( ls_infrota, Len(ls_infrota) - 1 )
%>
      </tr>
   </table>
   <table>
      <tr>
         <td class='CORPO' align='left' width='51'>
            <b>Cargo:</b>
         </td>
<%
         ls_incargo = " "

         FOR ll_contador = 0 TO UBound( ls_codcargo_vet )
            Response.Write( "<td class='CORPO' align='left' width='20'>" )
            Response.Write( "<input TYPE='checkbox' NAME='cargo_"&ls_codcargo_vet(ll_contador)&"' " )
            If ls_cargoselected_vet(ll_contador) = "on" Then
               ls_incargo = ls_incargo & "'" & ls_codcargo_vet(ll_contador) & "',"
               Response.Write( "checked" )
            End if
            Response.Write( ">" )
            Response.Write( "<td class='CORPO' align='left' width='50'>" )
            Response.Write( ls_codcargo_vet(ll_contador) )
            Response.Write( "</td>" )
         NEXT

         ls_incargo = Left( ls_incargo, Len(ls_incargo ) - 1 )
%>
      </tr>
   </table>

   <table>
      <tr>
         <td class='CORPO' align="left" width='51'>
            <b>Base:</b>
         </td>
<%
         ls_inbase = " "

         FOR ll_contador = 0 TO UBound( ls_nomecidade_vet )
            Response.Write( "<td class='CORPO' align='left' width='20'>" )
            Response.Write( "<input TYPE='checkbox' NAME='base_"&ll_seqcidade_vet(ll_contador)&"' " )
            If ls_baseselected_vet(ll_contador) = "on" Then
               ls_inbase = ls_inbase & ll_seqcidade_vet(ll_contador) & ","
               Response.Write( "checked" )
            End if
            Response.Write( ">" )
            Response.Write( "<td class='CORPO' align='left' width='128'>" )
            Response.Write( ls_nomecidade_vet(ll_contador) )
            Response.Write( "</td>" )
         NEXT

         ls_inbase = Left( ls_inbase, Len(ls_inbase) - 1 )
%>
   </table>
</form>

<%
if isdate( ldt_data1 ) AND isdate( ldt_data2 ) and ll_ano1 > 1900 Then
	If DateDiff( "d", ldt_data1, ldt_data2 ) > 35 Then
		Response.Write( "<p class=errmsg>O período informado não deve ser superior a 35 dias!</p>" )
		Response.End()
	End if

   ll_qtddias = DateDiff("d", ldt_data1, ldt_data2 )

%>
<form name="Folhao">
   <table border='1' cellpadding='0' cellspacing='0' ID='Table2' width='100'>
      <tr>
         <td class='CORPO' rowspan='2' align='center' bgcolor='#AAAAAA' nowrap><b>Tripulante</b></td>

<%
         for ll_dia = 0 TO ll_qtddias
            ldt_data = DateAdd( "d", ll_dia, ldt_data1 )
            ls_data = Right( "0"&Day(ldt_data), 2 ) & "/" & Right( "0"&Month(ldt_data), 2 ) & "/" & Year( ldt_data )
            ll_diasemana = Weekday( ldt_data )
            If ll_diasemana=1 OR ll_diasemana=7 Then
               ls_bgcolor="#808000"
            Else
               ls_bgcolor="#AAAAAA"
            End if
            Response.Write( "<td class='CORPO8' colspan='1' align='center' bgcolor='" & ls_bgcolor & "' width='150'><b>" & ls_data & "</b></td>" )
         next
%>

      </tr>
      <tr>
<%
         for ll_dia = 0 TO ll_qtddias
            ldt_data = DateAdd( "d", ll_dia, ldt_data1 )
            ll_diasemana = Weekday( ldt_data )
            If ll_diasemana=1 OR ll_diasemana=7 Then
               ls_bgcolor="#808000"
            Else
               ls_bgcolor="#AAAAAA"
            End if
            Response.Write( "<td class='CORPO8' colspan='1' align='center' bgcolor='" & ls_bgcolor & "' width='150'><b>" & ls_diasemana_vet(ll_diasemana-1) & "</b></td>" )
         next
%>
      </tr>
<%
      ls_sqltripulante =                    "SELECT sig_tripulante.seqtripulante, sig_tripulante.nomeguerra, sig_tripulante.nome, sig_tripulante.matricula, "
      ls_sqltripulante = ls_sqltripulante & " sig_tripulante.senioridade, sig_tripulante.dtadmissao, sig_tripulante.dtdesligamento, sig_tripulante.dtnascimento, "
      ls_sqltripulante = ls_sqltripulante & " sig_frota.codfrota, sig_tripcargo.codcargo, sig_tripbase.seqcidade, sig_cidade.nomecidade, "
		ls_sqltripulante = ls_sqltripulante & " sig_frota.seqfrota, sig_cargo.ordem "
      ls_sqltripulante = ls_sqltripulante & "FROM sig_tripulante, sig_tripfrota, sig_tripbase, sig_tripcargo, sig_frota, sig_cidade, sig_cargo "
      ls_sqltripulante = ls_sqltripulante & "WHERE sig_tripulante.dtadmissao <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripulante.dtdesligamento >= '"&ldt_data1&"' OR sig_tripulante.dtdesligamento IS NULL) "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripfrota.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripcargo.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripbase.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripfrota.dtfim >= '"&ldt_data1&"' or sig_tripfrota.dtfim is null) "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.seqfrota = sig_frota.seqfrota "
		If ls_infrota > "" Then
         ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.seqfrota in ("&ls_infrota&")"
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripcargo.dtfim >= '"&ldt_data1&"' or sig_tripcargo.dtfim is null) "
		If ls_incargo > "" Then
         ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.codcargo in ("&ls_incargo&") "
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.codcargo = sig_cargo.codcargo "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_cargo.flgtecnico = 'S' "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripbase.dtfim >= '"&ldt_data1&"' or sig_tripbase.dtfim is null) "
      If ls_inbase > "" Then
		   ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.seqcidade in ("&ls_inbase&") "
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.seqcidade = sig_cidade.seqcidade "
		If ls_nomeguerra > "" Then
		   ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.nomeguerra LIKE '" & ls_nomeguerra & "%' "
		End If
      ls_sqltripulante = ls_sqltripulante & "UNION "
      ls_sqltripulante = ls_sqltripulante & "SELECT sig_tripulante.seqtripulante, sig_tripulante.nomeguerra, sig_tripulante.nome, sig_tripulante.matricula, "
      ls_sqltripulante = ls_sqltripulante & " sig_tripulante.senioridade, sig_tripulante.dtadmissao, sig_tripulante.dtdesligamento, sig_tripulante.dtnascimento, "
      ls_sqltripulante = ls_sqltripulante & " MAX( sig_frota.codfrota ) as max_codfrota, sig_tripcargo.codcargo, sig_tripbase.seqcidade, sig_cidade.nomecidade, "
		ls_sqltripulante = ls_sqltripulante & " 0 as seqfrota, sig_cargo.ordem "
      ls_sqltripulante = ls_sqltripulante & "FROM sig_tripulante, sig_tripfrota, sig_tripbase, sig_tripcargo, sig_frota, sig_cidade, sig_cargo "
      ls_sqltripulante = ls_sqltripulante & "WHERE sig_tripulante.dtadmissao <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripulante.dtdesligamento >= '"&ldt_data1&"' OR sig_tripulante.dtdesligamento IS NULL) "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripfrota.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripcargo.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.seqtripulante = sig_tripbase.seqtripulante "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripfrota.dtfim >= '"&ldt_data1&"' or sig_tripfrota.dtfim is null) "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.seqfrota = sig_frota.seqfrota "
		If ls_infrota > "" Then
         ls_sqltripulante = ls_sqltripulante &  " AND sig_tripfrota.seqfrota in ("&ls_infrota&")"
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripcargo.dtfim >= '"&ldt_data1&"' or sig_tripcargo.dtfim is null) "
		If ls_incargo > "" Then
         ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.codcargo in ("&ls_incargo&") "
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripcargo.codcargo = sig_cargo.codcargo "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_cargo.flgtecnico = 'N' "
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.dtinicio <= '"&ldt_data2&"' "
      ls_sqltripulante = ls_sqltripulante &  " AND (sig_tripbase.dtfim >= '"&ldt_data1&"' or sig_tripbase.dtfim is null) "
		If ls_inbase > "" Then
         ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.seqcidade in ("&ls_inbase&") "
		End If
      ls_sqltripulante = ls_sqltripulante &  " AND sig_tripbase.seqcidade = sig_cidade.seqcidade "
		If ls_nomeguerra > "" Then
		   ls_sqltripulante = ls_sqltripulante &  " AND sig_tripulante.nomeguerra LIKE '" & ls_nomeguerra & "%' "
		End If
      ls_sqltripulante = ls_sqltripulante & "GROUP BY sig_tripulante.seqtripulante, sig_tripulante.nomeguerra, sig_tripulante.nome, sig_tripulante.matricula, "
      ls_sqltripulante = ls_sqltripulante & " sig_tripulante.senioridade, sig_tripulante.dtadmissao, sig_tripulante.dtdesligamento, sig_tripulante.dtnascimento, "
      ls_sqltripulante = ls_sqltripulante & " sig_tripcargo.codcargo, sig_tripbase.seqcidade, sig_cidade.nomecidade, sig_cargo.ordem "
      ls_sqltripulante = ls_sqltripulante & "ORDER BY sig_tripcargo.codcargo, sig_tripbase.seqcidade, sig_frota.seqfrota, sig_cargo.ordem "

      If ls_ordenacao = "1" Then
         ls_sqltripulante = ls_sqltripulante & ", sig_tripulante.nomeguerra"
      Else
         ls_sqltripulante = ls_sqltripulante & ", sig_tripulante.senioridade, sig_tripulante.nomeguerra"
      End if

      ls_sqljornada =                 "SELECT sig_jornada.seqjornada, sig_jornada.seqtripulante, sig_jornada.dtjornada, sig_jornada.flgcorrente, "
      ls_sqljornada = ls_sqljornada &       " sig_jornada.flgestado, sig_jornada.textojornada, sig_jornada.textojornadaaux, sig_jornada.kmsav, "
      ls_sqljornada = ls_sqljornada &       " sig_jornada.kmres, sig_jornada.kmvoo, sig_jornada.seqchave, sig_jornada.dthrapresentacao, "
      ls_sqljornada = ls_sqljornada &       " sig_jornada.dthrapresentacaorealiz, sig_jornada.dthrcorte, sig_jornada.sequsuario, sig_jornada.dthralteracao, "
      ls_sqljornada = ls_sqljornada &       " sig_jornada.dtchave, sig_jornada.flgotm,  sig_jornada.flgpedido, sig_jornada.observacao, "
      ls_sqljornada = ls_sqljornada &       " sig_jornada.textojornadaant, sig_jornada.nomeavisado, sig_jornada.dthravisado "
      ls_sqljornada = ls_sqljornada & "FROM sig_jornada "
      ls_sqljornada = ls_sqljornada & "WHERE sig_jornada.flgcorrente = 'S' "
      If Not lb_permissao Then
          ls_sqljornada = ls_sqljornada & "   AND sig_jornada.flgestado IN ('P', 'A', 'V') "
      End If
      ls_sqljornada = ls_sqljornada &   "AND sig_jornada.dtjornada BETWEEN '"&ldt_data1&"' AND '"&ldt_data2&"'"

      Set RS = Conn.Execute(ls_sqltripulante)

      ll_linhatrip = 1
      ll_seqtripulante_ant = 0
      ls_codcargo_ant = ""
      ll_seqfrota_ant = 0
      ll_seqcidade_ant = 0

      Do While Not RS.EOF
         ll_seqtripulante = Clng( RS( "seqtripulante" ) )
         ls_nomeguerra = RS( "nomeguerra" )
         ls_codcargo = RS( "codcargo" )
         ls_codfrota = RS( "codfrota" )
         ll_seqcidade = Clng( RS( "seqcidade" ) )
         ls_nomecidade = RS( "nomecidade" )
         ll_seqfrota = Cint( RS( "seqfrota" ) )

         RS.MoveNext

         If ls_codcargo <> ls_codcargo_ant OR ll_seqfrota_ant <> ll_seqfrota OR ll_seqcidade <> ll_seqcidade_ant Then
            Response.Write( "<tr bgcolor='#AAAAAA'>" )
            Response.Write( "<td class='CORPO9' colspan='" & ll_qtddias + 2 & "' align='Left'>" )
            Response.Write( "Folh&atilde;o de " & ls_codcargo & " da Base " & ls_nomecidade )
            If ll_seqfrota > 0 AND ll_seqfrota < 9999 Then
               Response.Write( " - Equipamento: " & ls_codfrota )
            End if
            Response.Write( "</td>" )
            Response.Write( "</tr>" )

            ll_seqtripulante_ant = 0
         End If

         If RS.EOF OR ll_seqtripulante <> ll_seqtripulante_ant THEN
            Response.Write( "<tr>" )
            Response.Write( "<td class='CORPO6' nowrap>" )
            Response.Write( "[" & ll_linhatrip & "] " & ls_nomeguerra )
            Response.Write( "</td>" )

            Set RSJornada = ConnJornada.Execute( ls_sqljornada & " AND sig_jornada.seqtripulante = "&ll_seqtripulante & " ORDER BY sig_jornada.dtjornada" )

            ll_coluna_jornada = 0

            If RSJornada.EOF Then
               For ll_contador = 0 TO ll_qtddias
                  Response.Write("<td class='CORPO6' valign='top' align='Left'>" )
						Response.Write(   "<div id='" & ll_seqtripulante&"_"&Year(ldt_data_aux)&Right("00"&Month(ldt_data_aux),2)&Right("00"&Day(ldt_data_aux),2) & "'>")
						Response.Write(   "<table width='90'>")
						Response.Write(      "<tr>")
						Response.Write(         "<td valign='top' align='right'>")
						ldt_data_aux = DateAdd( "d", ll_contador, ldt_data1 )
						If lb_permissao Then
                  	Response.Write(         "<a href='fol_programacao.asp?dtjornada=" & ldt_data_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "' onmouseout='hideddrivetip()' onmouseover='ddrivetip(&quot;<font class=corpo7>" & ls_nomeguerra & "<br>" & Right("00"&Day(ldt_data_aux),2)&"/"&Right("00"&Month(ldt_data_aux),2)&"/"&Year(ldt_data_aux) & " (" & ls_diasemana_vet(WeekDay(ldt_data_aux)-1) & ")</font>&quot;)'; onclick='open(&quot;fol_programacao.asp?dtjornada=" & ldt_data_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&quot;,&quot;popup&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=990,height=430&quot;);return false;'><img src='imagens/new_reg.gif' align='right' border='0'></a>" )
						Else
							Response.Write(			"&nbsp;")
						End if

                  Response.Write(         "</td>")
						Response.Write(      "</tr>")
						Response.Write(   "</table>")
						Response.Write(   "<table width='90' height='25'>")
						Response.Write(      "<tr>")
						Response.Write(         "<td class='CORPO6' valign='top' align='center'>&nbsp;")
                  Response.Write(         "</td>" )
						Response.Write(      "</tr>")
						Response.Write(   "</table>")
						Response.Write(	"</div>")
						Response.Write("</td>")
               Next
            Else
               Do While Not RSJornada.EOF
                  ldt_dtjornada = RSJornada( "dtjornada" )
                  ls_flgestado = RSJornada( "flgestado" )
                  ls_flgotm = RSJornada( "flgotm" )

                  ldt_data_aux = DateAdd("d", ll_coluna_jornada, ldt_data1 )

                  FOR ll_contador = 1 TO DateDiff("d", ldt_data_aux, ldt_dtjornada )
							Response.Write("<td class='CORPO6' valign='top' align='Left'>" )
							Response.Write(   "<div id='" & ll_seqtripulante&"_"&Year(ldt_dtjornada_aux)&Right("00"&Month(ldt_dtjornada_aux),2)&Right("00"&Day(ldt_dtjornada_aux),2) & "'>")
							Response.Write(   "<table width='90'>")
							Response.Write(      "<tr>")
							Response.Write(         "<td valign='top' align='right'>")
							ldt_dtjornada_aux = DateAdd( "d", ll_contador - 1, ldt_data_aux )
							If lb_permissao Then
								Response.Write(         "<a href='fol_programacao.asp?dtjornada=" & ldt_dtjornada_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "' onmouseout='hideddrivetip()' onmouseover='ddrivetip(&quot;<font class=corpo7>" & ls_nomeguerra & "<br>" & Right("00"&Day(ldt_dtjornada_aux),2)&"/"&Right("00"&Month(ldt_dtjornada_aux),2)&"/"&Year(ldt_dtjornada_aux) & " (" & ls_diasemana_vet(WeekDay(ldt_dtjornada_aux)-1) & ")</font>&quot;)'; onclick='window.open(&quot;fol_programacao.asp?dtjornada=" & ldt_dtjornada_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&quot;,&quot;popup&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=990,height=430&quot;);return false;' ><img src='imagens/new_reg.gif' align='right' border='0'></a>" )
							Else
								Response.Write( 			"&nbsp;")
							End if
	
							Response.Write(         "</td>")
							Response.Write(      "</tr>")
							Response.Write(   "</table>")
							Response.Write(   "<table width='90' height='25'>")
							Response.Write(      "<tr>")
							Response.Write(         "<td class='CORPO6' valign='top' align='center'>&nbsp;")
							Response.Write(         "</td>" )
							Response.Write(      "</tr>")
							Response.Write(   "</table>")
							Response.Write(	"</div>")
							Response.Write("</td>")
                     ll_coluna_jornada = ll_coluna_jornada + 1
                  NEXT

						
						If ls_flgestado = "N" Then
                     If ls_flgotm = "S" Then
                        'Response.Write( "<font color='#008000'>" )
								ls_color = "#008000"
                     Else
                        'Response.Write( "<font color='#000000'>" )
								ls_color = "#000000"
                     End if
                  ElseIf ls_flgestado = "A" Then
                     'Response.Write( "<font color='#C00000'>" )
							ls_color = "#C00000"
                  ElseIf ls_flgestado = "V" Then
                     'Response.Write( "<font color='#800000'>" )
							ls_color = "#800000"
                  ElseIf ls_flgestado = "R" Then
                     'Response.Write( "<font color='#C0C0C0'>" )
							ls_color = "#C0C0C0"
                  Else
                     'Response.Write( "<font color='#000080'>" )
							ls_color = "#000080"
                  End If

                  Response.Write("<td class='CORPO6' valign='top' align='Left'>" )
						Response.Write(   "<div id='" & ll_seqtripulante&"_"&Year(ldt_dtjornada)&Right("00"&Month(ldt_dtjornada),2)&Right("00"&Day(ldt_dtjornada),2) & "'>")
						Response.Write(   "<table width='90'>")
						Response.Write(      "<tr>")
						Response.Write(         "<td class='CORPO6' align='left'><font color='" & ls_color & "'>")
						If ls_flgestado = "N" And Not lb_permissao Then
							Response.Write(			"&nbsp;")
						Else
							If Trim(RSJornada("textojornadaaux"))>"" Then
								Response.Write( Trim( RSJornada("textojornadaaux") ) )
							End if
						End if
						Response.Write(            "</font>")
						Response.Write(         "</td>")
						Response.Write(         "<td valign='top' align='right'>")
						
						If ls_flgestado = "N" And Not lb_permissao Then
							Response.Write(			"<img src='imagens/edit_reg_block.gif' align='right' border='0'>" )
						Else
							Response.Write(         "<a href='fol_programacao.asp?dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "' onmouseout='hideddrivetip()' onmouseover='ddrivetip(&quot;<font class=corpo7>" & ls_nomeguerra & "<br>" & Right("00"&Day(ldt_dtjornada),2)&"/"&Right("00"&Month(ldt_dtjornada),2)&"/"&Year(ldt_dtjornada) & " (" & ls_diasemana_vet(WeekDay(ldt_dtjornada)-1) & ")</font>&quot;)'; onclick='window.open(&quot;fol_programacao.asp?dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&quot;,&quot;popup&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=990,height=430&quot;);return false;' ><img src='imagens/edit_reg.gif' align='right' border='0'></a>" )
						End if
						
                  Response.Write(         "</td>")
						Response.Write(      "</tr>")
						Response.Write(   "</table>")
						Response.Write(   "<table width='90' height='25'>")
						Response.Write(      "<tr>")
						Response.Write(         "<td class='CORPO6' valign='top' align='center'><font color='" & ls_color & "'>")
						If ls_flgestado = "N" And Not lb_permissao Then
							Response.Write(			"&nbsp;")
						Else
							If RSJornada("textojornada") > "" Then
								Response.Write( Replace( Trim( RSJornada("textojornada") ), "/", " / " ) )
							End if
						End if
						Response.Write(            "</font>")
                  Response.Write(         "</td>" )
						Response.Write(      "</tr>")
						Response.Write(   "</table>")

						'Response.Write("<script language='javascript'>")
						'Response.Write("ajax('fol_consulta_jornada.asp?color=" & ls_color & "&textojornada=Texto Jornada&dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&nomeguerra=" & ls_nomeguerra & "&diasemana=" & ls_diasemana_vet(WeekDay(ldt_dtjornada)-1) & "&textojornada=" & Trim( RSJornada("textojornada") ) & "&','','" & ll_seqtripulante&"_"&Month(ldt_dtjornada)&Day(ldt_dtjornada) & "');")
						'Response.Write("</script>")
						
                  ll_coluna_jornada = ll_coluna_jornada + 1

                  RSJornada.MoveNext
               Loop

               For ll_contador = ll_coluna_jornada TO ll_qtddias
					   ldt_data_aux = DateAdd( "d",ll_contador,ldt_data1 )
                  Response.Write("<td class='CORPO6' valign='top' align='Left'>" )
						Response.Write(   "<div id='" & ll_seqtripulante&"_"&Year(ldt_data_aux)&Right("00"&Month(ldt_data_aux),2)&Right("00"&Day(ldt_data_aux),2) & "'>")
						Response.Write(   "<table width='90'>")
						Response.Write(      "<tr>")
						Response.Write(         "<td class='CORPO6' align='left'>&nbsp;</td>")
						Response.Write(         "<td valign='top' align='right'>")
						
                  If lb_permissao Then
                     Response.Write(         "<a href='fol_programacao.asp?dtjornada=" & ldt_data_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "' onmouseout='hideddrivetip()' onmouseover='ddrivetip(&quot;<font class=corpo7>" & ls_nomeguerra & "<br>" & Right("00"&Day(ldt_data_aux),2)&"/"&Right("00"&Month(ldt_data_aux),2)&"/"&Year(ldt_data_aux) & " (" & ls_diasemana_vet(WeekDay(ldt_data_aux)-1) & ")</font>&quot;)'; onclick='window.open(&quot;fol_programacao.asp?dtjornada=" & ldt_data_aux & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&quot;,&quot;popup&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=990,height=430&quot;);return false;' ><img src='imagens/new_reg.gif' align='right' border='0'></a>" )
                  Else
                  	Response.Write(			"&nbsp;")
                  End if
                  Response.Write(         "</td>")
						Response.Write(      "</tr>")
						Response.Write(   "</table>")
						Response.Write(   "<table width='90' height='25'>")
						Response.Write(      "<tr><td class='CORPO6' valign='top' align='center'>&nbsp;</td></tr>")
						Response.Write(   "</table>")
						Response.Write(	"</div>")
						Response.Write("</td>")
               Next
            End If

            ll_linhatrip = ll_linhatrip + 1
            ll_seqtripulante_ant = ll_seqtripulante
            ls_codcargo_ant = ls_codcargo
            ll_seqfrota_ant = ll_seqfrota
            ll_seqcidade_ant = ll_seqcidade
         End If
      Loop
%>
      </tr>
   </table>
<%
   'response.Write( "<br>"&ls_sqltripulante )
   'response.End()
end if

Conn.Close
ConnJornada.Close
%>

</font>
</form>

<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div> 
</BODY></span>

</HTML>
