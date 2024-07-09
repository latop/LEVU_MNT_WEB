<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="libgeral.asp"-->

<html>
<head>
	<title>Apresentação de Tripulantes</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	<script language="javascript">

		function CarregaPagina() {
			window.form1.Senha.focus();
		}

		function VerificaCampos() {
			if (window.form1.Senha.value == '') {
				alert('Preencha o campo senha, por favor!');
				window.form1.Senha.focus();
				return false;
			}
			else {
				return confirm('Corfirma a apresentação do tripulante?');
			}
		}

	</script>
</head>

<body onLoad="CarregaPagina()">
<%
	Dim intSeqJornada
	Dim objConn
	Dim blnFazConsulta
	Dim strConfirmar, strVoltar

	blnFazConsulta = true

	strConfirmar = Request.Form("btnConfirmar")
	strVoltar = Request.Form("btnVoltar")

	intSeqJornada = Request.QueryString("seqjornada")

	if (strVoltar <> "") then
		Response.Redirect("relatorioescalaapresentacao.asp")
	elseif (strConfirmar <> "") then
		Dim strSenha, strSenhaEncriptada

		intSeqJornada = Request.Form("hidSeqJornada")

		strSenha = Request.Form("Senha")

		if (strSenha <> "") then
			strSenhaEncriptada = fnEncriptaSenha(strSenha)

			Set objConn = CreateObject("ADODB.CONNECTION")
			objConn.Open (StringConexaoSqlServer)

			' ****************************************
			' *** Verifica se a senha está correta ***
			' ****************************************
			Dim objRsSenha, strQuerySenha
			strQuerySenha = "SELECT ST.seqtripulante "
			strQuerySenha = strQuerySenha & "  FROM sig_tripulante ST, sig_jornada SJ "
			strQuerySenha = strQuerySenha & " WHERE ST.seqtripulante = SJ.seqtripulante "
			strQuerySenha = strQuerySenha & "   AND SJ.seqjornada = " & intSeqJornada
			strQuerySenha = strQuerySenha & "   AND ST.senha=" & Plic(strSenhaEncriptada) & " "
'			response.write("strQuerySenha: " & strQuerySenha)

			Set objRsSenha = Server.CreateObject("ADODB.Recordset")
			objRsSenha.Open strQuerySenha, objConn

			if (objRsSEnha.eof) then
				Response.Write "<p class='errmsg' align='center'>Senha inválida.<br>Verifique e tente novamente, por favor!</p>"
			else
				' *************************
				' *** HORA APRESENTAÇÃO ***
				' *************************
				Dim strQueryHrApresent
				strQueryHrApresent =                      " SELECT SJ.dthrapresentacao, "
				strQueryHrApresent = strQueryHrApresent & "        GETDATE() AGORA "
				strQueryHrApresent = strQueryHrApresent & "   FROM sig_jornada SJ "
				strQueryHrApresent = strQueryHrApresent & "  WHERE SJ.seqjornada = " & intSeqJornada

				Dim objRsHrApresent
				Set objRsHrApresent = Server.CreateObject("ADODB.Recordset")
				objRsHrApresent.Open strQueryHrApresent, objConn

				Dim strHrApresentacao, strAgora
				strHrApresentacao = objRsHrApresent("dthrapresentacao")
				strAgora = objRsHrApresent("AGORA")

				objRsHrApresent.Close()
				Set objRsHrApresent = Nothing

				Dim dtHrApresentacao, dtAgora, blnUtilizarHorarioPrevisto
				blnUtilizarHorarioPrevisto = false
				if (IsDate(strHrApresentacao) And IsDate(strAgora)) then
					dtHrApresentacao = CDate(strHrApresentacao)
					dtAgora = CDate(strAgora)
					if (dtAgora < dtHrApresentacao) then
						blnUtilizarHorarioPrevisto = true
						Dim int_Empresa
						int_Empresa = Session("Empresa")
						If (int_Empresa <> "4") Then
							Dim strHrApresentFormatada
							strHrApresentFormatada = Right("00"&Day(dtHrApresentacao),2) & "/" & Right("00"&Month(dtHrApresentacao),2) & "/" & Year(dtHrApresentacao) & " "
							strHrApresentFormatada = strHrApresentFormatada & FormatDateTime( dtHrApresentacao, 4 )
							ExibeMensagemJS("O horário de apresentação é anterior ao previsto. Será considerado o horário previsto [" & strHrApresentFormatada & "].")
						End If
					end if
				end if

				Dim objConexaoSqlServerUpdate, objRecordSetSqlServerUpdate
				Dim strQueryUpdate

				set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
				objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)

				strQueryUpdate = " UPDATE sig_jornada "
				if (blnUtilizarHorarioPrevisto) then
					strQueryUpdate = strQueryUpdate & " SET dthrapresentacaorealiz = dthrapresentacao "
				else
					strQueryUpdate = strQueryUpdate & " SET dthrapresentacaorealiz = getdate() "
				end if
				strQueryUpdate = strQueryUpdate & " WHERE seqjornada = " & intSeqJornada
				set objRecordSetSqlServerUpdate = objConexaoSqlServerUpdate.Execute(strQueryUpdate)

				objConexaoSqlServerUpdate.Close
				set objRecordSetSqlServerUpdate = nothing
				set objConexaoSqlServerUpdate = nothing
			end if
		end if
		set objRsSenha= nothing
	end if

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' ******************
	' *** TRIPULANTE ***
	' ******************
	Dim objRsTrip, strQueryTrip
	strQueryTrip =                " SELECT ST.seqtripulante, "
	strQueryTrip = strQueryTrip & "        ST.nomeguerra, "
	strQueryTrip = strQueryTrip & "        SJ.textojornada, "
	strQueryTrip = strQueryTrip & "        SJ.dthrapresentacao, "
	strQueryTrip = strQueryTrip & "        SJ.dthrapresentacaorealiz "
	strQueryTrip = strQueryTrip & "   FROM sig_tripulante ST, "
	strQueryTrip = strQueryTrip & "        sig_jornada SJ "
	strQueryTrip = strQueryTrip & "  WHERE ST.seqtripulante = SJ.seqtripulante "
	strQueryTrip = strQueryTrip & "    AND SJ.seqjornada = " & intSeqJornada
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn

	Dim seqTripulante
	seqTripulante = objRsTrip("seqtripulante")

	' ****************
	' *** CARTEIRA ***
	' ****************
	Dim strQueryCarteira
	strQueryCarteira =                    " SELECT TC.seqtripulante, "
	strQueryCarteira = strQueryCarteira & "        TC.codcarteira, "
	strQueryCarteira = strQueryCarteira & "        TC.dtinivalidade, "
	strQueryCarteira = strQueryCarteira & "        TC.dtfimvalidade, "
	strQueryCarteira = strQueryCarteira & "        TC.dtprorrogacao "
	strQueryCarteira = strQueryCarteira & " FROM sig_tripcarteira TC "
	strQueryCarteira = strQueryCarteira & " WHERE TC.seqtripulante = " & seqTripulante
	'strQueryCarteira = strQueryCarteira & "   AND TC.dtinivalidade <= GETDATE() "
	'strQueryCarteira = strQueryCarteira & "   AND (TC.dtfimvalidade IS NULL OR TC.dtfimvalidade >= GETDATE()) "

	Dim objRsCarteira
	Set objRsCarteira = Server.CreateObject("ADODB.Recordset")
	objRsCarteira.Open strQueryCarteira, objConn

%>
<center>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td class="corpo" align="left" valign="top" width="35%">
			<img src="imagens/logo_empresa.gif" border="0"></a>
		</td>
		<td class="corpo" align="center" width="30%" rowspan="2">
			<font size="4"><b>
				&nbsp;Apresentação de Tripulantes
			</b></font>
		</td>
		<td class="corpo" align="right" valign="top" width="35%">
			<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
		</td>
	</tr>
	</table>
</center>
<br />
<br />
<br />
<center>
	<table width="98%" border="1" cellspacing="1" id="Table2">
		<tr>
			<td align="right" valign="middle" width="10%">Tripulante:</td>
			<td align="left" valign="middle" width="40%"><%=objRsTrip("nomeguerra")%>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" valign="middle" width="10%">Programação:</td>
			<td align="left" valign="middle" width="40%"><%=objRsTrip("textojornada")%>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" valign="middle" width="10%">Apresentação:</td>
			<td align="left" valign="middle" width="40%"><%=objRsTrip("dthrapresentacao")%>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" valign="middle" width="10%">Apresentação Realiz.:</td>
			<td align="left" valign="middle" width="40%"><%=objRsTrip("dthrapresentacaorealiz")%>&nbsp;</td>
		</tr>
	</table>
	<br />
	<table border='1' cellpadding='0' align="center" cellspacing='0'>
		<thead>
			<tr bgcolor='#AAAAAA'>
				<th class="CORPO9" nowrap="nowrap" style="white-space: nowrap; width: 140px;">Carteira</th>
				<th class="CORPO9" nowrap="nowrap" style="white-space: nowrap; width: 125px;">In&iacute;cio Validade</th>
				<th class="CORPO9" nowrap="nowrap" style="white-space: nowrap; width: 125px;">Fim Validade</th>
				<th class="CORPO9" nowrap="nowrap" style="white-space: nowrap; width: 125px;">Prorroga&ccedil;&atilde;o</th>
			</tr>
		</thead>
		<tbody>
<%
	Do While Not objRsCarteira.EOF
		Dim codCarteira, dtIniValidade, dtFimValidade, dtProrrogacao
		codCarteira = objRsCarteira("codcarteira")
		dtIniValidade = objRsCarteira("dtinivalidade")
		dtFimValidade = objRsCarteira("dtfimvalidade")
		dtProrrogacao = objRsCarteira("dtprorrogacao")
		Dim corFundoLinha, corTexto, verde, vermelho, amarelo, branco, preto
		verde = "#90EE90"
		vermelho = "#FF0000"
		amarelo = "#FFFF7F"
		branco = "#FFFFFF"
		preto = "#000000"
		corFundoLinha = branco
		corTexto = preto
		If (Not IsVazio(dtIniValidade)) Then
			If (CDate(dtIniValidade) > Now()) Then
				corFundoLinha = vermelho
				corTexto = branco
			ElseIf (IsVazio(dtFimValidade)) Then
				corFundoLinha = verde
			ElseIf (CDate(dtFimValidade) < Now()) Then
				corFundoLinha = vermelho
				corTexto = branco
			ElseIf (DateDiff("d", Now(), CDate(dtFimValidade)) <= 30) Then
				corFundoLinha = amarelo
			Else
				corFundoLinha = verde
			End If
		Else
			corFundoLinha = vermelho
			corTexto = branco
		End If
%>
			<tr style='background-color:<%=corFundoLinha%>;'>
				<td class='CORPO8' nowrap="nowrap" style="color:<%=corTexto%>; text-align: center; white-space: nowrap;"><%=codCarteira%>&nbsp;</td>
				<td class='CORPO8' nowrap="nowrap" style="color:<%=corTexto%>; text-align: center; white-space: nowrap;"><%=dtIniValidade%>&nbsp;</td>
				<td class='CORPO8' nowrap="nowrap" style="color:<%=corTexto%>; text-align: center; white-space: nowrap;"><%=dtFimValidade%>&nbsp;</td>
				<td class='CORPO8' nowrap="nowrap" style="color:<%=corTexto%>; text-align: center; white-space: nowrap;"><%=dtProrrogacao%>&nbsp;</td>
			</tr>
<%
		objRsCarteira.MoveNext()
	Loop
%>
			<tr>
				<th colspan='4'></th>
			</tr>
		</tbody>
	</table>
	<form action="relatorioescalaapresentacaoregistro.asp" method="post" id="form1" name="form1">
		<input type="hidden" name='hidSeqJornada' id='hidSeqJornada' value='<%=intSeqJornada%>' />
		<table ID="Table3">
			<tr>
				<td class="fieldlabel" align="right" width="30%">Senha:</td>
				<td align="left" width="70%">
					<input type="password" id="Senha" name="Senha" class="defaultsmall" size="20" maxlength="20" />
				</td>
			</tr>
			<tr>
				<td width="100%" colspan="3" align="center">
					<input type="submit" onclick="return VerificaCampos()" value="Confirmar" name="btnConfirmar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnConfirmar" />
					<input type="submit" value="Voltar"  name="btnVoltar"  class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnVoltar" />
				</td>
			</tr>
		</table>
	</form>

</center>

</body>

</html>

<%
	objRsTrip.Close()
	Set objRsTrip = Nothing

	objRsCarteira.Close()
	Set objRsCarteira = Nothing

	objConn.Close()
	Set objConn = Nothing

' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

Function ObterCorFundoLinha(intNumLinha)

	Dim Cor1, Cor2, Cor
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	If ((intNumLinha MOD 2) = 0) Then
		Cor = Cor1
	Else
		Cor = Cor2
	End If

	ObterCorFundoLinha = Cor

End Function

Sub ExibeMensagemJS(mensagem)

	Response.Write("<script language='javascript' type='text/javascript'> " & vbCrLf)
	Response.Write("	alert(' " & mensagem & " '); " & vbCrLf)
	Response.Write("</script> " & vbCrLf)

End Sub
%>
