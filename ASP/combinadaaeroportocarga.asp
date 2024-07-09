<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	Dim strVoltar
	strVoltar = Request.Form("btnVoltar")

	Dim strChkId, strChkChecked
	strChkId = Request.Form("chkId")
	strChkChecked = Request.Form("chkChecked")

	Dim intSeqVooDia, intSeqTrecho
	If (Not IsVazio(Request.QueryString("seqvoodia"))) Then
		Session("seqvoodia") = Request.QueryString("seqvoodia")
	End If
	If (Not IsVazio(Request.QueryString("seqvoodia"))) Then
		Session("seqtrecho") = Request.QueryString("seqtrecho")
	End If
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")

	if (Not IsVazio(strChkId) And Not IsVazio(strChkChecked)) then
		Dim intSeqCombinadaClicada
		intSeqCombinadaClicada = Right(strChkId, Len(strChkId) - 3)
		if (Not IsVazio(intSeqCombinadaClicada)) then
			if (IsNumeric(intSeqCombinadaClicada)) then
				intSeqCombinadaClicada = CInt(intSeqCombinadaClicada)
			else
				intSeqCombinadaClicada = CInt(-1)
			end if
		else
			intSeqCombinadaClicada = CInt(-1)
		end if

		Dim strFlgFinalizado
		if (UCase(strChkChecked) = "TRUE") then
			strFlgFinalizado = "S"
		else
			strFlgFinalizado = "N"
		end if

'		Response.Write("<script language='javascript'>alert('strChkId não é vazio, strChkChecked não é vazio');</script>")
'		Response.Write("<script language='javascript'>alert('strChkId: " & strChkId & "');</script>")
'		Response.Write("<script language='javascript'>alert('strChkChecked: " & strChkChecked & "');</script>")
'		Response.Write("<script language='javascript'>alert('intSeqCombinadaClicada: " & intSeqCombinadaClicada & "'); history.back();</script>")
'		Response.End

		' ****************************
		' *** ATUALIZA A COMBINADA ***
		' ****************************
		Dim strQueryUpdate
		strQueryUpdate =                  " UPDATE sig_diariotrechocomb "
		strQueryUpdate = strQueryUpdate & " SET flgfinalizado = '" & strFlgFinalizado & "' "
		strQueryUpdate = strQueryUpdate & " WHERE seqvoodia = " & intSeqVooDia & " "
		strQueryUpdate = strQueryUpdate & "   AND seqtrecho = " & intSeqTrecho & " "
		strQueryUpdate = strQueryUpdate & "   AND seqcombinada = " & intSeqCombinadaClicada & " "

		Dim objConnUpdate
		Set objConnUpdate = CreateObject("ADODB.CONNECTION")
		objConnUpdate.Open (StringConexaoSqlServer)

		objConnUpdate.Execute(strQueryUpdate)

		objConnUpdate.close
		Set objConnUpdate = Nothing

	elseif (Not IsVazio(strVoltar)) then
		Response.Redirect("listagemhorariovoos.asp")
	end if

	Dim objConn
	Dim intSeqUsuarioAerop, intSeqAeroporto
	intSeqUsuarioAerop = Session("member")
	intSeqAeroporto = Session("seqaeroporto")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)

	' **************************
	' *** DADOS DO AEROPORTO ***
	' **************************
	Dim objRsAeroporto, strSqlSelectAeroporto, strSqlFromAeroporto, strSqlWhereAeroporto, strQueryAeroporto
	Dim strNomeAeroporto, strCodAeroporto
	strSqlSelectAeroporto = " SELECT seqaeroporto, codiata, nomeaeroporto "
	strSqlFromAeroporto = "   FROM sig_aeroporto "
	strSqlWhereAeroporto = "  WHERE seqaeroporto = " & intSeqAeroporto
	strQueryAeroporto = strSqlSelectAeroporto & strSqlFromAeroporto & strSqlWhereAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeroporto = objRsAeroporto("nomeaeroporto")
	strCodAeroporto = objRsAeroporto("codiata")


	' *****************
	' *** COMBINADA ***
	' *****************
	Dim objRs, strQuery
	Dim strNrVoo
	strQuery =            " SELECT SDV.nrvoo, SDTC.seqvoodia, SDTC.seqtrecho, SDTC.seqcombinada, "
	strQuery = strQuery & "        AERDEST.codiata, SDTC.seqaeropdest, "
	strQuery = strQuery & "        SDTC.cargapaga, SDTC.cargapagaexp, SDTC.cargagratis, "
	strQuery = strQuery & "        SDTC.correioao, SDTC.correiolc, "
	strQuery = strQuery & "        SDTC.cargapaga + SDTC.cargagratis + SDTC.correioao + SDTC.correiolc TOTAL_PESO, "
	strQuery = strQuery & "        (SELECT COUNT(1) "
	strQuery = strQuery & "           FROM sig_diariotrechocombcarga SDTCC "
	strQuery = strQuery & "          WHERE SDTCC.seqvoodia = SDTC.seqvoodia "
	strQuery = strQuery & "            AND SDTCC.seqtrecho = SDTC.seqtrecho "
	strQuery = strQuery & "            AND SDTCC.seqcombinada = SDTC.seqcombinada "
	strQuery = strQuery & "            AND SDTCC.flguld = 'S') TOTAL_ULD, "
	strQuery = strQuery & "        SDTC.pesobruto, "
	strQuery = strQuery & "        SDTC.flgfinalizado "
	strQuery = strQuery & " FROM sig_diariovoo SDV, sig_diariotrechocomb SDTC, sig_aeroporto AERDEST "
	strQuery = strQuery & " WHERE SDV.seqvoodia = SDTC.seqvoodia "
	strQuery = strQuery & "   AND SDTC.seqaeropdest = AERDEST.seqaeroporto "
	strQuery = strQuery & "   AND SDTC.seqvoodia=" & intSeqVooDia & " "
	strQuery = strQuery & "   AND SDTC.seqtrecho=" & intSeqTrecho & " "
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn
	strNrVoo = objRs("nrvoo")

%>

<html>
	<head>
		<title>Aeroportos</title>
		<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
		<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<script src="javascript.js"></script>
		<script src="jquery-1.1.4.js"></script>
		<script type="text/javascript" language="javascript">
			function SubmitForm(obj)
			{
				document.getElementById('chkId').value = obj.id;
				document.getElementById('chkChecked').value = obj.checked;
				document.getElementById('frmTabela').submit();
			}
		</script>
	</head>
	<body>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center">
					<font size="3"><b>Etapas&nbsp;Combinadas&nbsp;do&nbsp;V&#244;o&nbsp;<%Response.Write(strNrVoo)%></b></font><br /><br />
					<font size="2"><b><% Response.Write(strNomeAeroporto & "&nbsp;(" & strCodAeroporto & ")")%></b></font>
				</td>
				<td class="corpo" align="right" valign="bottom" width="35%">&nbsp;
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
		<br />
		<br />
		<form id='frmTabela' action='combinadaaeroportocarga.asp' method='post'>
			<input type='hidden' id='chkId' name='chkId' value='' />
			<input type='hidden' id='chkChecked' name='chkChecked' value='' />
			<table border='1' cellpadding='0' align="center" cellspacing='0'>
			<thead>
				<tr bgcolor='#AAAAAA'>
					<th class='CORPO9' rowspan='2' width='100px' >Destino</th>
					<th class="CORPO9" colspan='4' width='300px' >Carga</th>
					<th class='CORPO9' rowspan='2' width='75px' >RPN</th>
					<th class="CORPO9" colspan='3' width='225px' >Total</th>
					<th class='CORPO8' rowspan='2' width='100px' >Carregamento<br />Finalizado</th>
				</tr>
				<tr bgcolor='#AAAAAA'>
					<th class='CORPO9' width='75px' >STD</th>
					<th class='CORPO9' width='75px' >EXP</th>
					<th class='CORPO7' width='75px' >COMAT/ULD</th>
					<th class='CORPO9' width='75px' >VAC</th>
					<th class='CORPO9' width='75px' >Peso</th>
					<th class='CORPO9' width='75px' >ULD</th>
					<th class='CORPO8' width='75px' >Peso&nbsp;Bruto</th>
				</tr>
			</thead>
			<tbody>

<%
	Dim Cor1, Cor2, Cor, intContador
	Dim intSeqCombinada
	Dim ll_CargaPaga, ll_CargaPagaSTD, ll_CargaPagaEXP, ll_CargaGratis, ll_CorreioAo, ll_CorreioLc
	Dim ll_TotalPeso, ll_TotalUld, ll_PesoBruto, ll_FlgFinalizado

	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	Do While Not objRs.Eof
		if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
		end if

		intSeqCombinada = objRs("seqcombinada")
		ll_CargaPaga = objRs("cargapaga")
		ll_CargaGratis = objRs("cargagratis")
		ll_CorreioAo = objRs("correioao")
		ll_CorreioLc = objRs("correiolc")
		ll_TotalPeso = objRs("TOTAL_PESO")
		ll_TotalUld = objRs("TOTAL_ULD")
		ll_PesoBruto = objRs("pesobruto")
		If (IsVazio(ll_PesoBruto)) Then
			ll_PesoBruto = CLng(0)
		Else
			ll_PesoBruto = CLng(ll_PesoBruto)
		End If
		ll_FlgFinalizado = objRs("flgfinalizado")
		ll_CargaPagaEXP = objRs("cargapagaexp")
		If (IsVazio(ll_CargaPagaEXP)) Then
			ll_CargaPagaEXP = CLng(0)
		Else
			ll_CargaPagaEXP = CLng(ll_CargaPagaEXP)
		End If
		ll_CargaPagaSTD = CLng(ll_CargaPaga) - CLng(ll_CargaPagaEXP)

		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='combinadacarga.asp?seqcombinada=" & intSeqCombinada & "&seqvoodia=" & intSeqVooDia & "&seqtrecho=" & intSeqTrecho & "'>" & vbCrLf)
		Response.Write("		" & objRs("codiata") & "</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaPagaSTD & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaPagaEXP & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CargaGratis & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CorreioAo & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_CorreioLc & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_TotalPeso & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_TotalUld & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PesoBruto & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		<input type='checkbox' id='chk" & intSeqCombinada & "' name='chk" & intSeqCombinada & "'" & vbCrLf)
		If (Not IsVazio(ll_FlgFinalizado)) Then
			If (UCase(ll_FlgFinalizado) = "S") Then
				Response.Write(" checked='checked'" & vbCrLf)
			End If
		End If
		Response.Write(" onclick='javascript:SubmitForm(this);' />&nbsp;</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		objRs.movenext
	loop

	objRs.Close
	Set objRs = Nothing

	objConn.close
	Set objConn = Nothing

%>
				<tr>
					<th colspan="9"></th>
				</tr>
			</tbody>
			</table>
		</form>
		<form action='combinadaaeroportocarga.asp' method='post' id='form2' name='form2'>
			<table border='0' cellpadding='0' cellspacing='0' align='center'>
				<tr>
					<td style='padding-top: 20px;'>
						<input type='submit' value='Voltar' name='btnVoltar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' ID='btnVoltar' tabindex='1' />
					</td>
				</tr>
			</table>
		</form>
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

%>
