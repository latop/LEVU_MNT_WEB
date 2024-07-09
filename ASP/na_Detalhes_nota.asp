<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->

<%

Dim ll_dia1, ll_mes1, ll_ano1, ll_dia2, ll_mes2, ll_ano2, ll_aerop_abastec
ll_dia1 = Request.QueryString("dia_ini")
ll_mes1 = Request.QueryString("mes_ini")
ll_ano1 = Request.QueryString("ano_ini")
ll_dia2 = Request.QueryString("dia_fim")
ll_mes2 = Request.QueryString("mes_fim")
ll_ano2 = Request.QueryString("ano_fim")
ll_aerop_abastec = Request.QueryString("aerop_abastec")

Dim intSeqNota
intSeqNota= Request.QueryString("seqnotaabastec")

Dim Conn
Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open(StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Dim strNomeAeroporto, strCodAeroporto, intSeqAeroporto
intSeqAeroporto = Session("seqaeroporto")
if (Not IsVazio(intSeqAeroporto)) then
	Dim SqlSelectAeroporto
	SqlSelectAeroporto =                      " SELECT seqaeroporto, codiata, nomeaeroporto "
	SqlSelectAeroporto = SqlSelectAeroporto & " FROM sig_aeroporto WHERE seqaeroporto = " & intSeqAeroporto

	Dim RSAeroporto
	set RSAeroporto = Conn.Execute(SqlSelectAeroporto)

	strNomeAeroporto = RSAeroporto("nomeaeroporto")
	strCodAeroporto = RSAeroporto("codiata")
end if

'Agora criamos a sentença SQL que nos servirá para falar à BD
Dim sSql
sSQL =        " SELECT sig_combnotaabastec.seqnotaabastec, sig_combnotaabastec.coddistribuidor, "
sSQL = sSQL & " sig_aeronave.prefixored,sig_combnotaabastec.seqvoodia, "
sSQL = sSQL & " sig_combnotaabastec.seqtrecho, sig_combnotaabastec.seqaeropabastec, sig_aeroporto.codiata, sig_aeroporto.codicao, "
sSQL = sSQL & " sig_combnotaabastec.dtnota, sig_combnotaabastec.combna, "
sSQL = sSQL & " sig_combnotaabastec.dtinicioabastec, sig_combnotaabastec.dtfimabastec, "
sSQL = sSQL & " sig_combnotaabastec.abastecini, sig_combnotaabastec.abastecfim, "
sSQL = sSQL & " sig_combnotaabastec.abastecvol, sig_combnotaabastec.valor, sig_combnotaabastec.combpartidamotor, "
sSQL = sSQL & " sig_diariovoo.nrvoo, sig_diariovoo.dtoper, sig_diariotrecho.seqaeroporig "
sSQL = sSQL & " FROM sig_combnotaabastec "
sSQL = sSQL & " LEFT OUTER JOIN sig_diariovoo ON sig_diariovoo.seqvoodia = sig_combnotaabastec.seqvoodia "
sSQL = sSQL & " LEFT OUTER JOIN sig_diariotrecho ON sig_diariotrecho.seqvoodia = sig_combnotaabastec.seqvoodia AND sig_diariotrecho.seqtrecho = sig_combnotaabastec.seqtrecho, "
sSQL = sSQL & " sig_aeroporto, sig_aeronave "
sSQL = sSQL & " WHERE sig_combnotaabastec.seqaeropabastec = sig_aeroporto.seqaeroporto "
sSQL = sSQL & " AND sig_combnotaabastec.prefixo = sig_aeronave.prefixo "
sSQL = sSQL & " AND sig_combnotaabastec.seqnotaabastec = " & intSeqNota

'Executamos a ordem
Dim RsDetalhesNota
set RsDetalhesNota = Conn.Execute(sSql)

%>

<html>
<head>
	<title>Detalhes da Nota de Abastecimento</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv='Page-Exit' content='blendTrans(Duration=1)' />
	<style type="text/css">
	<!--
		.CORPO10 { COLOR: black; FONT-FAMILY: Verdana; FONT-SIZE: 10pt }
	-->
	</style>
	<script type="text/javascript" src="javascript.js"></script>
	<script type="text/javascript" language="javascript">
		function CalculaVolume()
		{
			var Parametro1 = document.getElementById("Qtd_inicio_abastec").value;
			var Parametro2 = document.getElementById("Qtd_fim_abastec").value;
			var Soma = 0;

			Parametro1 = parseInt(parseFloat(Parametro1));
			Parametro2 = parseInt(parseFloat(Parametro2));

			//isNaN = Verifica se o valor pode ser convertido para um número, se não puder ser ele devolve NaN
			if (isNaN(Parametro1) || isNaN(Parametro2))
			{
				Soma = 0;
			}
			else
			{
				Soma = Parametro2 - Parametro1;
			}

			document.getElementById("Qtd_inicio_abastec").value = isNaN(Parametro1) ? '' : Parametro1;
			document.getElementById("Qtd_fim_abastec").value = isNaN(Parametro2) ? '' : Parametro2;
			document.getElementById("volume_abastec").value = Soma;
		}

		function VerificaCampos()
		{
			if (document.getElementById("Nota_Abastecimento").value == '')
			{
				alert('Preencha o campo Nota de Abastecimento, por favor!');
				document.getElementById("Nota_Abastecimento").focus();
				return false;
			}
			else if (document.getElementById("Data_Nota_dia").value == '' || document.getElementById("Data_Nota_mes").value == '' || document.getElementById("Data_Nota_ano").value == '')
			{
				alert('Preencha o campo Data da Nota, por favor!');
				document.getElementById("Data_Nota_dia").focus();
				return false;
			}
			else if (document.getElementById("Aeronave").value == '')
			{
				alert('Selecione a Aeronave, por favor!');
				document.getElementById("Aeronave").focus();
				return false;
			}
			else if (document.getElementById("Voo").value != '')
			{
				if (document.getElementById("Data_voo_dia").value == '' || document.getElementById("Data_voo_mes").value == '' || document.getElementById("Data_voo_ano").value == '')
				{
					alert('Preencha o campo Data do Voo, por favor!');
					document.getElementById("Data_voo_dia").focus();
					return false;
				}
				else
				{
					var datDataNota = new Date(document.getElementById("Data_Nota_ano").value, document.getElementById("Data_Nota_mes").value - 1, document.getElementById("Data_Nota_dia").value);
					var datDataVoo = new Date(document.getElementById("Data_voo_ano").value, document.getElementById("Data_voo_mes").value - 1, document.getElementById("Data_voo_dia").value);
					var dateDiff = Math.abs((datDataNota - datDataVoo) / (24 * 60 * 60 * 1000));
					if (dateDiff > 2)
					{
						alert(' A Data da Nota é inconsistente com a Data do Voo. ');
						document.getElementById("Data_Nota_dia").focus();
						return false;
					}
				}
			}
			else if (document.getElementById("comboAeropAbastec").value == '')
			{
				alert('Selecione o Aerop. Abastec., por favor!');
				document.getElementById("comboAeropAbastec").focus();
				return false;
			}
			else if (document.getElementById("Distribuidor").value == '')
			{
				alert('Selecione o Distribuidor, por favor!');
				document.getElementById("Distribuidor").focus();
				return false;
			}
			else if (document.getElementById("Qtd_inicio_abastec").value == '')
			{
				alert('Preencha a quantidade de inicio do abastecimento, por favor!');
				document.getElementById("Qtd_inicio_abastec").focus();
				return false;
			}
			else if (document.getElementById("Qtd_fim_abastec").value == '')
			{
				alert('Preencha a quantidade final do abastecimento, por favor!');
				document.getElementById("Qtd_fim_abastec").focus();
				return false;
			}
			else
			{
				var lb_retorno = new Boolean(true)

				if (parseInt(document.getElementById("Data_Nota_dia").value) != parseInt(document.getElementById("Data_voo_dia").value) || parseInt(document.getElementById("Data_Nota_mes").value) != parseInt(document.getElementById("Data_voo_mes").value) || parseInt(document.getElementById("Data_Nota_ano").value) != parseInt(document.getElementById("Data_voo_ano").value))
				{
					lb_retorno = confirm('Data da Nota diferente da Data do Voo. Confirma alteração da Nota?');
				}
				if (lb_retorno == true && (parseInt(document.getElementById("volume_abastec").value) < 0))
				{
					lb_retorno = confirm('Volume de abastecimento inferior a zero. Confirma alteração da Nota?');
				}

				return lb_retorno;
			}
		}

	</script>
</head>

<body bgcolor="white" link="blue">
<br />
<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%" rowspan="2">
			<img src="imagens/logo_empresa.gif" border="0" />
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>Nota de Abastecimento</b></font>
<%
	if (Not IsVazio(strNomeAeroporto) Or Not IsVazio(strCodAeroporto)) then
		Response.Write("<br /><font size='4'><b>" & strNomeAeroporto & "&nbsp;(" & strCodAeroporto & ")</b></font>")
	end if
%>
		</td>
		<td class="corpo" align="right" valign="top" width="35%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0" /></a>
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
<form action="na_Atualizar_Nota.asp?dia_ini=<%=ll_dia1%>&mes_ini=<%=ll_mes1%>&ano_ini=<%=ll_ano1%>&dia_fim=<%=ll_dia2%>&mes_fim=<%=ll_mes2%>&ano_fim=<%=ll_ano2%>&aerop_abastec=<%=ll_aerop_abastec%>" method="post">
<input type='hidden' name="intSeqNota_Alterar" id="intSeqNota_Alterar" value="<%=intSeqNota%>" />

<fieldset style="margin: 10px 80px 10px 80px; padding-left: 20px;">
<table width="5%"  border="0"  cellspacing="1" cellpadding="3">
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Nota de Abastecimento:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type= "text" name="Nota_Abastecimento" id="Nota_Abastecimento" maxlength="20" size="20" value="<%=RsDetalhesNota("combna")%>" /> (n&#250;mero da nota, sem separa&#231;&#227;o)
		</td>
	</tr>
<%
	Dim ldt_dtnota
	ldt_dtnota = RsDetalhesNota("dtnota")
%>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Data da Nota:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type= "text" name="Data_Nota_dia" id="Data_Nota_dia" maxlength="2" size=1 onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=Right("00"&Day(ldt_dtnota),2)%>" /> <b>/</b>
			<input type= "text" name="Data_Nota_mes" id="Data_Nota_mes" maxlength="2" size=1 onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=Right("00"&Month(ldt_dtnota),2)%>" /> <b>/</b>
			<input type= "text" name="Data_Nota_ano" id="Data_Nota_ano" maxlength="4" size=3 onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=Year(ldt_dtnota)%>" /> (data impressa na nota)
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Aeronave:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<select name="Aeronave" id="Aeronave">
				<option value=''></option>
<%
				Dim RsAeronave
				Set RsAeronave = Conn.Execute(" SELECT prefixored FROM sig_aeronave ORDER BY prefixored ")
				Do While Not RsAeronave.EOF
					If (RsAeronave("prefixored") = RsDetalhesNota("prefixored")) Then
						Response.Write("<option value='" & RsAeronave("prefixored") & "' selected='selected'>" & RsAeronave("prefixored") & "</option>")
					else
						Response.Write("<option value='" & RsAeronave("prefixored") & "'>" & RsAeronave("prefixored") & "</option>")
					End if
					RsAeronave.MoveNext
				Loop
				RsAeronave.Close
				Set RsAeronave = Nothing
%>
			</select>
		</td>
	</tr>
<%
	Dim ldt_dtOper
	ldt_dtOper = RsDetalhesNota("dtoper")
	Dim dtOperDia, dtOperMes, dtOperAno
	if (Not IsVazio(ldt_dtOper)) then
		dtOperDia = Right("00"&Day(ldt_dtOper),2)
		dtOperMes = Right("00"&Month(ldt_dtOper),2)
		dtOperAno = Year(ldt_dtOper)
	end if
%>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Data do Voo:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type= "text" name="Data_voo_dia" id="Data_voo_dia" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtOperDia%>" /> <b>/</b>
			<input type= "text" name="Data_voo_mes" id="Data_voo_mes" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtOperMes%>" /> <b>/</b>
			<input type= "text" name="Data_voo_ano" id="Data_voo_ano" maxlength="4" size="3" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtOperAno%>" />
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Voo:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type= "text" name="Voo" id="Voo" maxlength="4" size="4" onkeypress="return SoNumeros(window.event.keyCode, this);" value="<%=RsDetalhesNota("nrvoo")%>" />
			<b>NOVO:</b>
			<a target="_blank" href="CoordenacaoGrafico.asp">clique aqui para localizar os voos!</a>
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Aerop. Abastec.:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<select name="comboAeropAbastec" id="comboAeropAbastec" <% if (Not IsVazio(intSeqAeroporto)) then %> disabled="disabled" <% end if %>>
				<option value=""></option>
				<%
					call preencherComboAeroportos(RsDetalhesNota("seqaeropabastec"))
				%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Distribuidor:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<select name="Distribuidor" id="Distribuidor">
				<option value=''>Escolha o distribuidor</option>
				<option value=''>-----------------------</option>
<%
			Dim RsDistribuidor
			set RsDistribuidor = Conn.Execute("SELECT coddistribuidor FROM sig_distribuidor")
			Do While Not RsDistribuidor.Eof
				if (RsDistribuidor("coddistribuidor") = RsDetalhesNota("coddistribuidor")) then
					Response.Write("<option value='" & RsDistribuidor("coddistribuidor") & "' selected='selected'>" & RsDistribuidor("coddistribuidor") & "</option>")
				else
					Response.Write("<option value='" & RsDistribuidor("coddistribuidor") & "'>" & RsDistribuidor("coddistribuidor") & "</option>")
				end if
				RsDistribuidor.MoveNext
			Loop
			RsDistribuidor.Close
			Set RsDistribuidor = Nothing
%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Abastecimento (lt):&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type="text" name="Qtd_inicio_abastec" id="Qtd_inicio_abastec" onchange="CalculaVolume()" maxlength="10" size="20" onkeypress="return SoNumeros(window.event.keyCode, this);" value="<%=RsDetalhesNota("abastecini")%>" />
			<b>Até:</b> <input type="text" name="Qtd_fim_abastec" id="Qtd_fim_abastec" onchange="CalculaVolume()" maxlength="10" size="20" onkeypress="return SoNumeros(window.event.keyCode, this);" value="<%=RsDetalhesNota("abastecfim")%>" />
			(não digitar zeros à esquerda)
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Volume Abastec. (lt):&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type="text" name="volume_abastec" id="volume_abastec" maxlength="15" size="20" value="<%=RsDetalhesNota("abastecvol")%>"  disabled="disabled" />
			(confira: <i>volume = bomba final - bomba inicial</i>)
		</td>
	</tr>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Comb. Partida Motor (lt):&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type="text" name="comb_partida_motor" id="comb_partida_motor" maxlength="6" size="20" onkeypress="return SoNumeros(window.event.keyCode, this);" value="<%=RsDetalhesNota("combpartidamotor")%>" />
		</td>
	</tr>
<%
	Dim ldt_dtInicioAbastec, dtInicioAbastecDia, dtInicioAbastecMes, dtInicioAbastecAno, dtInicioAbastecHora, dtInicioAbastecMinuto
	ldt_dtInicioAbastec = RsDetalhesNota("dtinicioabastec")
	if (Not IsVazio(ldt_dtInicioAbastec)) then
		dtInicioAbastecDia = Right("00" & Day(ldt_dtInicioAbastec), 2)
		dtInicioAbastecMes = Right("00" & Month(ldt_dtInicioAbastec), 2)
		dtInicioAbastecAno = Year(ldt_dtInicioAbastec)
		dtInicioAbastecHora = Right("00" & Hour(ldt_dtInicioAbastec), 2)
		dtInicioAbastecMinuto = Right("00" & Minute(ldt_dtInicioAbastec), 2)
	end if

	Dim ldt_dtFimAbastec, dtFimAbastecDia, dtFimAbastecMes, dtFimAbastecAno, dtFimAbastecHora, dtFimAbastecMinuto
	ldt_dtFimAbastec = RsDetalhesNota("dtfimabastec")
	if (Not IsVazio(ldt_dtFimAbastec)) then
		dtFimAbastecDia = Right("00" & Day(ldt_dtFimAbastec), 2)
		dtFimAbastecMes = Right("00" & Month(ldt_dtFimAbastec), 2)
		dtFimAbastecAno = Year(ldt_dtFimAbastec)
		dtFimAbastecHora = Right("00" & Hour(ldt_dtFimAbastec), 2)
		dtFimAbastecMinuto = Right("00" & Minute(ldt_dtFimAbastec), 2)
	end if

%>
	<tr>
		<td class="corpo10" nowrap="nowrap" align="right"><b>Período Abastec.:&nbsp;&nbsp;</b></td>
		<td class="corpo10" nowrap="nowrap" align="left">
			<input type= "text" name="Data_inicio_dia" id="Data_inicio_dia" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtInicioAbastecDia%>" /> <b>/</b>
			<input type= "text" name="Data_inicio_mes" id="Data_inicio_mes" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtInicioAbastecMes%>" /> <b>/</b>
			<input type= "text" name="Data_inicio_ano" id="Data_inicio_ano" maxlength="4" size="3" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtInicioAbastecAno%>" /> <b>às</b>
			<input type= "text" name="Hora_inicial" id="Hora_inicial" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtInicioAbastecHora%>" />:<input type= "text" name="Minuto_inicial" id="Minuto_inicial" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtInicioAbastecMinuto%>" /> <b>Até</b>
			<input type= "text" name="Data_fim_dia" id="Data_fim_dia" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtFimAbastecDia%>" /> <b>/</b>
			<input type= "text" name="Data_fim_mes" id="Data_fim_mes" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtFimAbastecMes%>" /> <b>/</b>
			<input type= "text" name="Data_fim_ano" id="Data_fim_ano" maxlength="4" size="3" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtFimAbastecAno%>" /> <b>às<b>
			<input type= "text" name="Hora_final" id="Hora_final" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtFimAbastecHora%>" />:<input type= "text" name="Minuto_final" id="Minuto_final" maxlength="2" size="1" onkeydown="ChecarTAB();" onkeypress="return SoNumeros(window.event.keyCode, this);" onkeyup="SimulaTab(this);" onfocus="PararTAB(this);" value="<%=dtFimAbastecMinuto%>" />
			(quando ocorreu o abastecimento)
		</td>
	</tr>
</table>
</fieldset>
<div style="margin: 10px 80px 10px 80px;">
	<input type="submit" name="btnGravar" id="btnGravar" value="Gravar" onclick="Javascript:return VerificaCampos();" class="botao1" style="margin-left:200px;" />
	<input type="button" name="btnVoltar" id="btnVoltar" value="Voltar" onclick="Javascript:history.go(-1);" class="botao1" />
	<input type="submit" name="btnExcluir" id="btnExcluir" value="Excluir Nota" onclick="Javascript:return confirm('Corfirma a exclusão da Nota?');" class="botao1" style="margin-left:200px;" />
</div>
</form>
</body>
</html>

<%

RsDetalhesNota.Close
Set RsDetalhesNota = Nothing

Conn.Close
Set Conn = Nothing

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
				Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODICAO") & "</option>"& chr(13))						
			else			
				Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODIATA") & "</option>"& chr(13))			
			end if
		else				'se tem algum selecionado como parametro
			if (cint(rsResult("SEQAEROPORTO")) = cint(selecionado)) then
				if isVazio(rsResult("CODIATA")) then
					Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODICAO") & "</option>"& chr(13))						
				else			
					Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODIATA") & "</option>"& chr(13))			
				end if
			else
				if isVazio(rsResult("CODIATA")) then
					Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "'>" & rsResult("CODICAO") & "</option>"& chr(13))						
				else			
					Response.Write("<option value='" & rsResult("SEQAEROPORTO") & "'>" &  rsResult("CODIATA") & "</option>"& chr(13))			
				end if
			end if
		end if		
		rsResult.MoveNext
	wend
	
	objConn.Close
	set rsResult = nothing
	set objConn = nothing
	
end Sub

%>
