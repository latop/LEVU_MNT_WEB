<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim intSeqVooDia, intSeqTrecho, intSeqCombinada
	intSeqVooDia = Session("seqvoodia")
	intSeqTrecho = Session("seqtrecho")
	intSeqCombinada = Request.QueryString("seqcombinada")

	Dim intSeqAeroporto
	intSeqAeroporto = Session("seqaeroporto")

	' ************************************
	' *** DADOS DO AEROPORTO DE ORIGEM ***
	' ************************************
	Dim objRsAeroporto, strQueryAeroporto
	Dim strNomeAeropOrig, strCodAeropOrig, strNomeAeropDestino, strCodAeropDestino

	strQueryAeroporto =                     " SELECT seqaeroporto, codiata, nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto "
	strQueryAeroporto = strQueryAeroporto & "  WHERE seqaeroporto = " & intSeqAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeropOrig = objRsAeroporto("nomeaeroporto")
	strCodAeropOrig = objRsAeroporto("codiata")
	objRsAeroporto.Close

	' *************************************
	' *** DADOS DO AEROPORTO DE DESTINO ***
	' *************************************
	strQueryAeroporto =                     " SELECT AEROP.seqaeroporto, AEROP.codiata, AEROP.nomeaeroporto "
	strQueryAeroporto = strQueryAeroporto & "   FROM sig_aeroporto AEROP, sig_diariotrechocomb SDTC "
	strQueryAeroporto = strQueryAeroporto & "  WHERE AEROP.seqaeroporto = SDTC.seqaeropdest "
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqvoodia = " & intSeqVooDia
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqtrecho = " & intSeqTrecho
	strQueryAeroporto = strQueryAeroporto & "    AND SDTC.seqcombinada = " & intSeqCombinada

	objRsAeroporto.Open strQueryAeroporto, objConn

	strNomeAeropDestino = objRsAeroporto("nomeaeroporto")
	strCodAeropDestino = objRsAeroporto("codiata")

	objRsAeroporto.Close

	' ********************
	' *** DADOS DO VOO ***
	' ********************
	Dim strQueryVoo
	strQueryVoo =               " SELECT SDV.nrvoo "
	strQueryVoo = strQueryVoo & " FROM sig_diariovoo SDV "
	strQueryVoo = strQueryVoo & " WHERE SDV.seqvoodia = " & intSeqVooDia

	Dim objRsVoo
	Set objRsVoo = Server.CreateObject("ADODB.Recordset")
	objRsVoo.Open strQueryVoo, objConn

	Dim strNrVoo
	strNrVoo = objRsVoo("nrvoo")
	objRsVoo.Close

	' ********************
	' *** DISTRIBUIÇÃO ***
	' ********************
	Dim objRs, strQuery
	strQuery =            " SELECT SDTCC.iduld, SDTCC.cargapaga, SDTCC.cargapagaexp, "
	strQuery = strQuery & "        SDTCC.cargagratis, SDTCC.correioao, SDTCC.correiolc, "
	strQuery = strQuery & "        SDTCC.codtipocarga1, TC1.descrtipocarga descrtipocarga1, "
	strQuery = strQuery & "        SDTCC.codtipocarga2, TC2.descrtipocarga descrtipocarga2, "
	strQuery = strQuery & "        SDTCC.codtipocarga3, TC3.descrtipocarga descrtipocarga3, "
	strQuery = strQuery & "        SDTCC.observacao, SDTCC.cubagem, SDTCC.pesobruto, "
	strQuery = strQuery & "        SDTCC.flguld "
	strQuery = strQuery & " FROM sig_diariotrechocombcarga SDTCC "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC1 ON TC1.codtipocarga = SDTCC.codtipocarga1 "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC2 ON TC2.codtipocarga = SDTCC.codtipocarga2 "
	strQuery = strQuery & "      LEFT OUTER JOIN sig_tipocarga TC3 ON TC3.codtipocarga = SDTCC.codtipocarga3 "
	strQuery = strQuery & " WHERE SDTCC.seqvoodia = " & intSeqVooDia & " "
	strQuery = strQuery & "   AND SDTCC.seqtrecho = " & intSeqTrecho & " "
	strQuery = strQuery & "   AND SDTCC.seqcombinada = " & intSeqCombinada & " "

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

%>

<html>
	<head>
		<title>Aeroportos</title>
		<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
		<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
		<style type="text/css">
			.input_rigthText{
				text-align: right;
			}
		</style>
	</head>
	<body onload='javascript:window.print();'>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0" />
				</td>
				<td class="corpo" align="center">
					<font size="3"><b>Distribuição&nbsp;do&nbsp;V&#244;o&nbsp;<%Response.Write(strNrVoo)%></b></font><br /><br />
					<font size="3"><b><%Response.Write("(" & strCodAeropOrig & "&nbsp;->&nbsp;" & strCodAeropDestino & ")")%></b></font>
				</td>
            <td align="right">
            	<img src="imagens/sigla.gif" border="0" />
            </td>
			</tr>
         <tr>
            <td></td>
            <td></td>
         </tr>
		</table>
		<br />
		<hr />
		<br />
		<table border='1' cellpadding='0' align="center" cellspacing='0' width='98%'>
			<tr bgcolor='#AAAAAA'>
				<th class="CORPO9" rowspan="2" width='14%' >C&#243;digo</th>
				<th class="CORPO9" rowspan="2" width='4%' >ULD</th>
				<th class="CORPO9" rowspan="2" width='7%' >Peso Bruto</th>
				<th class="CORPO9" colspan="3" width='18%' >Carga</th>
				<th class="CORPO9" colspan="2" width='14%' >Correio</th>
				<th class="CORPO9" rowspan="2" width='9%' >Cubagem (M<sup>3</sup>)</th>
				<th class="CORPO9" rowspan="2" colspan="3" width='17%' >SPL</th>
				<th class="CORPO9" rowspan="2" width='17%' >Observa&#231;&#227;o</th>
			</tr>
			<tr bgcolor='#AAAAAA'>
				<th class='CORPO9' width='6%' >STD</th>
				<th class='CORPO9' width='6%' >EXP</th>
				<th class='CORPO7' width='6%' >COMAT/ULD</th>
				<th class='CORPO9' width='7%' >VAC</th>
				<th class='CORPO9' width='7%' >RPN</th>
			</tr>

<%
	Dim Cor1, Cor2, Cor, intContador
	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	Do While Not objRs.Eof
		if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
		end if

		Dim ll_IdUld, ll_CargaPaga, ll_CargaPagaSTD, ll_CargaPagaEXP, ll_CargaGratis, ll_CorreioAo, ll_CorreioLc
		Dim ll_CodTipoCarga1, ll_CodTipoCarga2, ll_CodTipoCarga3
		Dim ll_DescrTipoCarga1, ll_DescrTipoCarga2, ll_DescrTipoCarga3
		Dim ll_Observacao, ll_Cubagem, ll_PesoBrutoUld
		Dim ll_FlgUld

		ll_IdUld = objRs("iduld")
		ll_CargaPaga = CLng(objRs("cargapaga"))
		ll_CargaGratis = CLng(objRs("cargagratis"))
		ll_CorreioAo = CLng(objRs("correioao"))
		ll_CorreioLc = CLng(objRs("correiolc"))
		ll_CodTipoCarga1 = objRs("codtipocarga1")
		ll_DescrTipoCarga1 = objRs("descrtipocarga1")
		ll_CodTipoCarga2 = objRs("codtipocarga2")
		ll_DescrTipoCarga2 = objRs("descrtipocarga2")
		ll_CodTipoCarga3 = objRs("codtipocarga3")
		ll_DescrTipoCarga3 = objRs("descrtipocarga3")
		ll_Observacao = objRs("observacao")
		ll_Cubagem = objRs("cubagem")
		If (Not IsVazio(ll_Cubagem)) Then ll_Cubagem = ll_Cubagem & "%"
		ll_PesoBrutoUld = objRs("pesobruto")
		If (Not IsVazio(ll_PesoBrutoUld)) Then ll_PesoBrutoUld = CLng(ll_PesoBrutoUld)
		ll_FlgUld = objRs("flguld")
		ll_CargaPagaEXP = objRs("cargapagaexp")
		If (IsVazio(ll_CargaPagaEXP)) Then
			ll_CargaPagaEXP = CLng(0)
		Else
			ll_CargaPagaEXP = CLng(ll_CargaPagaEXP)
		End If
		ll_CargaPagaSTD = CLng(ll_CargaPaga) - CLng(ll_CargaPagaEXP)


		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='CORPO9' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='combinadacarga.asp?seqcombinada=" & intSeqCombinada & "&iduld=" & ll_IdUld & "'>" & vbCrLf)
		Response.Write("		" & ll_IdUld & "</a></td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		If (UCase(ll_FlgUld) = "N") Then
			Response.Write("		<input type='checkbox' id='chkUld" & intContador & "' name='chkUld" & intContador & "' value='ULD' onclick='return false;' />" & vbCrLf)
		ElseIf (UCase(ll_FlgUld) = "S") Then
			Response.Write("		<input type='checkbox' id='chkUld" & intContador & "' name='chkUld" & intContador & "' value='ULD' onclick='return false;' checked='checked' />" & vbCrLf)
		Else
			Response.Write("&nbsp;")
		End If
		Response.Write("	</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center'>" & vbCrLf)
		Response.Write("		" & ll_PesoBrutoUld & "&nbsp;</td>" & vbCrLf)
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
		Response.Write("		" & ll_Cubagem & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga1 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga1 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga2 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga2 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' nowrap align='center' width='7%' title='" & ll_DescrTipoCarga3 & "'>" & vbCrLf)
		Response.Write("		" & ll_CodTipoCarga3 & "&nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='CORPO8' align='left'>" & vbCrLf)
		Response.Write("		&nbsp;" & ll_Observacao & "&nbsp;</td>" & vbCrLf)


		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		objRs.movenext
	loop

	objRs.Close
	Set objRs = Nothing
%>
			<tr>
				<th colspan="13"></th>
			</tr>
		</table>
      <br />
      <br />
      <br />

<%
	objConn.Close()
	Set objConn = Nothing

%>

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
