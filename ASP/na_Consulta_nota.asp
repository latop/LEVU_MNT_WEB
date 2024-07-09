<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%Server.ScriptTimeout=900%>

<html>
<head>
	<title>Cadastro de Nota de Abastecimento</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv='Page-Exit' content='blendTrans(Duration=1)' />
	<script src="javascript.js" type="text/javascript"></script>
	<script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
	<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
	<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
	<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>

	<style type="text/css">
		table 
		{
			empty-cells: show;
		}
		body  
		{
			margin-left: 0px;
		}
	</style>

	<script language="javascript" type="text/javascript">

		String.prototype.trim = function()
		{
			return this.replace(/^\s*/, "").replace(/\s*$/, "");
		}

		$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data1").mask("99/99/9999");
			$("#txt_Data2").mask("99/99/9999");
		});

		function VerificarCamposPesquisa()
		{
			if (document.getElementById("txt_Data1").value.trim() == '')
			{
				alert("Preencha a data inicial do período, por favor!");
				document.getElementById("txt_Data1").focus();
				return false;
			}
			else if (!isDataValida(document.getElementById("txt_Data1").value))
			{
				alert("Preencha a data inicial do período com uma data válida, por favor!");
				document.getElementById("txt_Data1").focus();
				return false;
			}

			if (document.getElementById("txt_Data2").value.trim() == '')
			{
				alert("Preencha a data final do período, por favor!");
				document.getElementById("txt_Data2").focus();
				return false;
			}
			else if (!isDataValida(document.getElementById("txt_Data2").value))
			{
				alert("Preencha a data final do período com uma data válida, por favor!");
				document.getElementById("txt_Data2").focus();
				return false;
			}

			if (ComparaDatas(document.getElementById('txt_Data1').value, document.getElementById('txt_Data2').value) > 0)
			{
				alert("A data inicial do período não pode ser maior do que a data final do período!");
				document.getElementById("txt_Data1").focus();
				return false;
			}

			return true;
		}

		function isDataValida(data) // Recebe a data no formato ddmmyyyy ou dd/mm/yyyy ou dd-mm-yyyy e retorna se está correta
		{
			var dia, mes, ano;
			var valida = false;
			var menorAno = 1900, maiorAno = 2100, nDiasMes; // Atribui o maior e o menor valor de ano.

			if (data.length == 8 || data.length == 10)
			{
				if (data.length == 10 && data.charAt(2) == '-' || data.charAt(2) == '/')
				{
					dia = data.substr(0, 2);
					mes = data.substr(3, 2);
					ano = data.substr(6, 4);

				} else
					if (data.length == 8 && !isNaN(data.charAt(2)))
				{
					dia = data.substr(0, 2);
					mes = data.substr(2, 2);
					ano = data.substr(4, 4);

				}

				nDiasMes = numDiasMes(ano, mes);

				if (ano >= menorAno && ano <= maiorAno)
				{
					if (mes > 0 && mes <= 12)
					{
						if (dia > 0 && dia <= nDiasMes)
						{
							valida = true;
						}
					}
				}

			}
			return valida;
		}

		function numDiasMes(ano, mes)//retorna o numero de dias no mês.
		{
			var numDias = 30;
			if (mes < 8 && mes % 2 != 0 || mes >= 8 && mes % 2 == 0)
			{
				numDias = 31;
			} else
				if (mes == 2)
			{
				numDias = isAnoBissexto(ano) ? 29 : 28;
			}
			return numDias;
		}

		function isAnoBissexto(ano)//retorna ano bissesto ou não
		{
			return ano % 400 == 0 || ano % 4 == 0 && ano % 100 != 0 ? true : false;
		}

		function ComparaDatas(strData1, strData2) // Recebe as datas no formato ddmmyyyy ou dd/mm/yyyy ou dd-mm-yyyy e retorna 0 se strData1 é igual a strData2, -1 se strData1 é menor do que strData2 e 1 se strData1 é maior do que strData2
		{
			var dia1, mes1, ano1;
			if (strData1.length == 10)
			{
				dia1 = strData1.substr(0, 2);
				mes1 = strData1.substr(3, 2);
				ano1 = strData1.substr(6, 4);
			}
			else if (strData1.length == 8)
			{
				dia1 = strData1.substr(0, 2);
				mes1 = strData1.substr(2, 2);
				ano1 = strData1.substr(4, 4);
			}

			var dia2, mes2, ano2;
			if (strData2.length == 10)
			{
				dia2 = strData2.substr(0, 2);
				mes2 = strData2.substr(3, 2);
				ano2 = strData2.substr(6, 4);
			}
			else if (strData2.length == 8)
			{
				dia2 = strData2.substr(0, 2);
				mes2 = strData2.substr(2, 2);
				ano2 = strData2.substr(4, 4);
			}

			if ((ano1 == ano2) && (mes1 == mes2) && (dia1 == dia2))
			{
				return 0;
			}

			if (ano1 > ano2)
			{
				return 1;
			}
			else if (ano1 == ano2)
			{
				if (mes1 > mes2)
				{
					return 1;
				}
				else if ((mes1 == mes2) && (dia1 > dia2))
				{
					return 1;
				}
			}

			return -1;
		}

	</script>

</head>

<body bgcolor="white" link="blue">

<%
Dim ll_dia1, ll_mes1, ll_ano1, ll_dia2, ll_mes2, ll_ano2
Dim sSql
Dim Conn
Dim RS
Dim ls_codiata
Dim ls_codicao
Dim strNomeAeroporto, strCodAeroporto, intSeqAeroporto
Dim SqlSelectAeroporto
Dim RSAeroporto
Dim ldt_dtnota, ls_dtnota
Dim ldt_dtoper, ls_dtoper
Dim ls_nrvoo

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Dim strTxt_Data1, strTxt_Data2
strTxt_Data1 = Request.Form("txt_Data1")
strTxt_Data2 = Request.Form("txt_Data2")

if (Not IsVazio(strTxt_Data1)) then
	ll_dia1 = Day(strTxt_Data1)
	ll_mes1 = Month(strTxt_Data1)
	ll_ano1 = Year(strTxt_Data1)
else
	ll_dia1 = Request.QueryString("dia_ini")
	ll_mes1 = Request.QueryString("mes_ini")
	ll_ano1 = Request.QueryString("ano_ini")
end if

if (Not IsVazio(strTxt_Data2)) then
	ll_dia2 = Day(strTxt_Data2)
	ll_mes2 = Month(strTxt_Data2)
	ll_ano2 = Year(strTxt_Data2)
else
	ll_dia2 = Request.QueryString("dia_fim")
	ll_mes2 = Request.QueryString("mes_fim")
	ll_ano2 = Request.QueryString("ano_fim")
end if


if (IsDate(ll_ano1 & "/" & ll_mes1 & "/" & ll_dia1)) then
	strTxt_Data1 = Right("00" & ll_dia1, 2) & "/" & Right("00" & ll_mes1, 2) & "/" & ll_ano1
else
	ll_dia1 = ""
	ll_mes1 = ""
	ll_ano1 = ""
	strTxt_Data1 = ""
end if

if (IsDate(ll_ano2 & "/" & ll_mes2 & "/" & ll_dia2)) then
	strTxt_Data2 = Right("00" & ll_dia2, 2) & "/" & Right("00" & ll_mes2, 2) & "/" & ll_ano2
else
	ll_dia2 = ""
	ll_mes2 = ""
	ll_ano2 = ""
	strTxt_Data2 = ""
end if


' *****************************************
' ***   DADOS DO USUÁRIO DO DESPACHO    ***
' *** DEVE ESTAR NO FORMATO XXX.CODIATA ***
' *****************************************
Dim loginUsuario
loginUsuario = Session("login")

Dim posicaoPonto
posicaoPonto = InStr(loginUsuario, ".")

Dim aerop
if (Not IsVazio(posicaoPonto) And posicaoPonto > 0) then
	aerop = Mid(login, posicaoPonto + 1)
end if

Session("seqaeroporto") = NULL
if (Len(aerop) = 3) then
	SqlSelectAeroporto =                 " SELECT SIA.seqaeroporto, SIA.codiata, SIA.nomeaeroporto "
	SqlSelectAeroporto = SqlSelectAeroporto & " FROM sig_aeroporto SIA "
	SqlSelectAeroporto = SqlSelectAeroporto & " WHERE SIA.codiata = '" & aerop & "'"
	set RsAeroporto = conn.Execute(SqlSelectAeroporto)

	if (Not RSAeroporto.Eof) then
		intSeqAeroporto = RSAeroporto("seqaeroporto")
		strNomeAeroporto = RSAeroporto("nomeaeroporto")
		strCodAeroporto = RSAeroporto("codiata")

		Session("seqaeroporto") = intSeqAeroporto
	end if
end if

Dim intAeropAbastec
intAeropAbastec = Request.form("comboAeropAbastec")
if (IsVazio(intAeropAbastec)) then
	intAeropAbastec = Request.QueryString("aerop_abastec")
end if

%>

<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
      <td class="corpo" align="left" valign="top" width="35%" rowspan="2">
      	<img src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center" width="30%" rowspan="2">
      	<font size="4"><b>Notas de Abastecimento</b></font>
<%
	if (Not IsVazio(strNomeAeroporto) Or Not IsVazio(strCodAeroporto)) then
		Response.Write("<br /><font size='4'><b>" & strNomeAeroporto & "&nbsp;(" & strCodAeroporto & ")</b></font>")
	end if
%>
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
<br />
<form method="post"  action="na_Consulta_nota.asp">
<%
   ' Executa função para gravar na sig_usuariolog
   If f_grava_usuariolog( "I10", Conn ) > "" Then
      Response.End()
   End if
%>        
	<table width="90%" align="center" class='CORPO10'>
		<tr>
			<td style="white-space:nowrap;">
				Período:
				<input type="text" name="txt_Data1" id="txt_Data1" size="11" maxlength="10" Value="<%=strTxt_Data1%>"/>&nbsp;
				<button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>&nbsp;
				Até:
				<input type="text" name="txt_Data2" id="txt_Data2" size="11" maxlength="10"  Value="<%=strTxt_Data2%>"/>&nbsp;
				<button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>&nbsp;
				Aerop. Abastec.:
				<select name="comboAeropAbastec" id="comboAeropAbastec" <% if (Not IsVazio(intSeqAeroporto)) then %> disabled="disabled" <% end if %>>
					<option value=""></option>
					<%
						if (Not IsVazio(intSeqAeroporto)) then
							call preencherComboAeroportos(intSeqAeroporto)
						else
							call preencherComboAeroportos(intAeropAbastec)
						end if
					%>
				</select>&nbsp;&nbsp;&nbsp;
				<input type= "submit" value="Pesquisar" class="botao1" onclick="javascript:return VerificarCamposPesquisa();" />&nbsp;
				<input type='button' value='&nbsp;Nova Nota&nbsp;' onClick="location.href='na_Nova_nota.asp?dia_ini=<%=ll_dia1%>&mes_ini=<%=ll_mes1%>&ano_ini=<%=ll_ano1%>&dia_fim=<%=ll_dia2%>&mes_fim=<%=ll_mes2%>&ano_fim=<%=ll_ano2%>&aerop_abastec=<%=intAeropAbastec%>'" class="botao1" />
			</td>
		</tr>
	</table>
</form>
<br />
<%


'Agora criamos a sentença SQL que nos servirá para falar à BD
sSQL=        " SELECT sig_combnotaabastec.seqnotaabastec, sig_combnotaabastec.coddistribuidor, "
sSQL= sSQL & " sig_aeronave.prefixored,sig_combnotaabastec.seqvoodia, "
sSQL= sSQL & " sig_combnotaabastec.seqtrecho, sig_combnotaabastec.seqaeropabastec, "
sSQL= sSQL & " sig_combnotaabastec.dtnota, sig_combnotaabastec.combna, "
sSQL= sSQL & " sig_combnotaabastec.dtinicioabastec, sig_combnotaabastec.dtfimabastec, "
sSQL= sSQL & " sig_combnotaabastec.abastecini, sig_combnotaabastec.abastecfim, "
sSQL= sSQL & " sig_combnotaabastec.abastecvol, sig_combnotaabastec.valor, "
sSQL= sSQL & " sig_diariovoo.nrvoo, sig_diariovoo.dtoper, sig_diariotrecho.seqaeroporig, "
sSQL= sSQL & " sig_aeroporto.codiata, sig_aeroporto.codicao "
sSQL= sSQL & " FROM sig_combnotaabastec"
sSQL= sSQL & " LEFT OUTER JOIN sig_diariovoo ON sig_diariovoo.seqvoodia = sig_combnotaabastec.seqvoodia "
sSQL= sSQL & " LEFT OUTER JOIN sig_diariotrecho ON sig_diariotrecho.seqvoodia = sig_combnotaabastec.seqvoodia AND sig_diariotrecho.seqtrecho = sig_combnotaabastec.seqtrecho, "
sSQL= sSQL & " sig_aeroporto, sig_aeronave "
sSQL= sSQL & " WHERE sig_combnotaabastec.seqaeropabastec = sig_aeroporto.seqaeroporto "
sSQL= sSQL & " AND sig_combnotaabastec.prefixo = sig_aeronave.prefixo "
if (Not IsVazio(intSeqAeroporto)) then
	sSQL= sSQL & " AND sig_combnotaabastec.seqaeropabastec = " & intSeqAeroporto
elseif (Not IsVazio(intAeropAbastec)) then
	sSQL= sSQL & " AND sig_combnotaabastec.seqaeropabastec = " & intAeropAbastec
end if
if isDate(ll_ano1&"/"&ll_mes1&"/"&ll_dia1) and isDate(ll_ano2&"/"&ll_mes2&"/"&ll_dia2) then
	sSQL= sSql & " AND dtnota >= '" & ll_ano1&"/"&ll_mes1&"/"&ll_dia1 & "' AND dtnota <= '" & ll_ano2&"/"&ll_mes2&"/"&ll_dia2 & " 23:59:59' "
	sSQL= sSql & " ORDER BY sig_combnotaabastec.dtnota, sig_aeronave.prefixored"

	'Executamos a ordem
	set RS = Conn.Execute(sSQL)
%>
	<table align="center" border=1 cellpadding="0" cellspacing="0" ID="Table1">

		<tr bgcolor='#AAAAAA'>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Nota&nbsp;de&nbsp;Abastecimento</th>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Data&nbsp;da&nbsp;Nota</th>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Aeronave</th>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Aerop.&nbsp;Abastec.</th>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Voo</th>
			<th class="CORPO9" style="padding-left:10px; padding-right:10px;">Data&nbsp;do&nbsp;Voo</th>
		</tr>
<%
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

		ldt_dtnota = RS("dtnota")
		ls_dtnota = Right("00"&Day(ldt_dtnota),2) & "/" & Right("00"&Month(ldt_dtnota),2) & "/" & Year(ldt_dtnota)

		ldt_dtoper = RS("dtoper")
		if (Not IsVazio(ldt_dtoper)) then
			ls_dtoper = Right("00"&Day(ldt_dtoper),2) & "/" & Right("00"&Month(ldt_dtoper),2) & "/" & Year(ldt_dtoper)
		else
			ls_dtoper = "&nbsp;"
		end if

		ls_nrvoo = RS("nrvoo")
		if (IsVazio(ls_nrvoo)) then ls_nrvoo = "&nbsp;"
%>
		<tr bgcolor=<%=Cor%> >
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;"><a href = 'na_Detalhes_nota.asp?seqnotaabastec=<% =RS("seqnotaabastec")%>&dia_ini=<%=ll_dia1%>&mes_ini=<%=ll_mes1%>&ano_ini=<%=ll_ano1%>&dia_fim=<%=ll_dia2%>&mes_fim=<%=ll_mes2%>&ano_fim=<%=ll_ano2%>&aerop_abastec=<%=intAeropAbastec%>'><%=RS("combna")%></a></td>
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;"><%=ls_dtnota%></td>
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;"><%=RS("prefixored")%></td>
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;">
<%
		ls_codiata = RS( "codiata" )
		ls_codicao = RS( "codicao" )

		IF ls_codiata > "" THEN
			Response.Write( ls_codiata )
		ELSE
			Response.Write( ls_codicao )
		END IF
%>
			</td>
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;"><%=ls_nrvoo%></td>
			<td class="corpo8" style="padding-left:10px; padding-right:10px; text-align:center;"><%=ls_dtoper%></td>

		</tr>

<%
		intContador = intContador + 1
		RS.MoveNext
	loop

	'Fechamos o sistema de conexão
	Conn.Close
%>

	</table>

<%
else
   Conn.Close
end if
%>

<script language="javascript" type="text/javascript">
	document.getElementById("txt_Data1").focus();
</script>

<div id="calendarDiv"></div> 	
<div id="calendarDiv2"></div>

</body>
</html>


<%

Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function

Sub preencherComboAeroportos(selecionado)

	'******************************************************************************* 
	'*
	'*		NO CASO DESSA TABELA, COMO HÁ A POSSIBILIDADE DO CAMPO DE EXIBIÇÃO ESTAR NULO(CODIATA),
	'*      ESSA FUNÇÃO COLOCA O CODICAO NO LUGAR 
	'* 	
	'******************************************************************************* 
	Dim rsResult, SQL, objConn
	Dim selecionou
	selecionou = false
	SQL = "SELECT SEQAEROPORTO, CODIATA, CODICAO FROM SIG_AEROPORTO ORDER BY CODIATA ASC"
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.open(StringConexaoSqlServer)																					
	Set rsResult = Server.CreateObject("ADODB.Recordset")
	rsResult.Open SQL, objConn	
	
	if (not isVazio(selecionado))	then
		selecionado = ucase(selecionado)
		selecionou = true
	end if
	
	while not rsResult.eof 
		if (selecionou=false) then				 'se não selecionei nada, simplesmente exibo todos sem marcar nenhum
			if isVazio(rsResult("CODIATA")) then
				response.write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODICAO") & "</option>"& chr(13) )						
			else			
				response.write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODIATA") & "</option>"& chr(13) )			
			end if
		else				'se tem algum selecionado como parametro
			if (cint(rsResult("SEQAEROPORTO")) = cint(selecionado)) then
				if isVazio(rsResult("CODIATA")) then
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODICAO") & "</option>"& chr(13) )						
				else			
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODIATA") & "</option>"& chr(13) )			
				end if
			else
				if isVazio(rsResult("CODIATA")) then
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "'>" & rsResult("CODICAO") & "</option>"& chr(13) )						
				else			
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "'>" &  rsResult("CODIATA") & "</option>"& chr(13) )			
				end if
			end if
		end if		
		rsResult.movenext
	wend
	
	objConn.close
	set rsResult = nothing
	set objConn = nothing
	
end Sub

%>
