<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="libgeral.asp"-->
<!--#include file="grava_usuariolog.asp"-->

<%
	Dim objConn
	Dim objRsUsuario, strSqlUsuario, intSeqUsuario
	Dim objRs, strSqlSelect
	Dim objRsAeroporto, strSqlSelectAeroporto, strSqlFromAeroporto, strSqlWhereAeroporto, strQueryAeroporto
	Dim strNomeAeroporto, strCodAeroporto
	Dim intSeqUsuarioAerop, intSeqAeroporto
	Dim intAno1, intMes1, intDia1, strHora1, strData1, strDataA
	Dim intAno2, intMes2, intDia2, strHora2, strData2, strDataB
	Dim ll_dia, ll_dia_ant, ll_hora, ll_hora_ant, ll_nrvoo, ll_nrvoo_ant, ls_codatividade, ls_codatividade_ant
	Dim ldt_dthrapresentacao, ldt_dthrapresentacaorealiz, ls_dthrapresentacao, ls_dthrapresentacaorealiz

	intSeqUsuario = session("member")

	intAno1 = Year(DateAdd("h", -1, Now()))
	intMes1 = Month(DateAdd("h", -1, Now()))
	intDia1 = Day(DateAdd("h", -1, Now()))
	
	strHora1 = FormatDateTime(DateAdd("h", -1, Now()), 4)
	strData1 = intAno1 & "-" & intMes1 & "-" & intDia1 & " " & strHora1
	strDataA = intAno1 & "-" & intMes1 & "-" & intDia1

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServerEncriptado)
	objConn.Execute "SET DATEFORMAT ymd"

	' Executa função para gravar na sig_usuariolog
	If f_grava_usuariolog( "I08", objConn ) > "" Then
		Response.End()
	End if


	' ******************
	' *** PARÂMTEROS ***
	' ******************
	Dim strQueryParametros
	strQueryParametros =                      " SELECT PARAM.horariolimapresent "
	strQueryParametros = strQueryParametros & "  FROM sig_parametros PARAM "

	Dim objRsParametros
	Set objRsParametros = Server.CreateObject("ADODB.Recordset")
	objRsParametros.Open strQueryParametros, objConn

	Dim intHorarioLimiteApresent
	if (Not objRsParametros.EOF) then
		intHorarioLimiteApresent = objRsParametros("horariolimapresent")
		if (IsVazio(intHorarioLimiteApresent)) then
			intHorarioLimiteApresent = CInt(20)
		else
			intHorarioLimiteApresent = CInt(intHorarioLimiteApresent)
		end if
	else
		intHorarioLimiteApresent = CInt(20)
	end if

	objRsParametros.Close()
	Set objRsParametros = Nothing


	intAno2 = Year(DateAdd("h", intHorarioLimiteApresent, Now()))
	intMes2 = Month(DateAdd("h", intHorarioLimiteApresent, Now()))
	intDia2 = Day(DateAdd("h", intHorarioLimiteApresent, Now()))

	strHora2 = FormatDateTime(DateAdd("h", intHorarioLimiteApresent, Now()), 4)
	strData2 = intAno2 & "-" & intMes2 & "-" & intDia2 & " " & strHora2
	strDataB = intAno2 & "-" & intMes2 & "-" & intDia2

	' ****************************************
	' ***   DADOS DO USUÁRIO DO DESPACHO   ***
	' *** DEVE ESTAR NO FORMATO DO.CODIATA ***
	' ****************************************
	strSqlUsuario =                 " SELECT SIA.seqaeroporto "
	strSqlUsuario = strSqlUsuario & " FROM sig_usuario SUS, sig_aeroporto SIA "
	strSqlUsuario = strSqlUsuario & " WHERE SUS.sequsuario=" & intSeqUsuario
	strSqlUsuario = strSqlUsuario & " AND RIGHT(UPPER(SUS.usuario), 3)=SIA.codiata "
	Set objRsUsuario = Server.CreateObject("ADODB.Recordset")

	objRsUsuario.Open strSqlUsuario, objConn
	intSeqAeroporto = objRsUsuario("seqaeroporto")

	' **************************
	' *** DADOS DO AEROPORTO ***
	' **************************
	strSqlSelectAeroporto = " SELECT seqaeroporto, codiata, nomeaeroporto "
	strSqlFromAeroporto = "   FROM sig_aeroporto "
	strSqlWhereAeroporto = "  WHERE seqaeroporto = " & intSeqAeroporto
	strQueryAeroporto = strSqlSelectAeroporto & strSqlFromAeroporto & strSqlWhereAeroporto
	Set objRsAeroporto = Server.CreateObject("ADODB.Recordset")
	objRsAeroporto.Open strQueryAeroporto, objConn
	strNomeAeroporto = objRsAeroporto("nomeaeroporto")
	strCodAeroporto = objRsAeroporto("codiata")

	'********************
	' *** Apresentação ***
	' ********************
	strSqlSelect =                "SELECT DISTINCT sig_tripulante.nomeguerra, "
	strSqlSelect = strSqlSelect & "       sig_jornada.seqjornada, "
	strSqlSelect = strSqlSelect & "       sig_jornada.textojornada, "
	strSqlSelect = strSqlSelect & "       sig_escdiariovoo.siglaempresa, "
	strSqlSelect = strSqlSelect & "       sig_escdiariovoo.nrvoo, "
	strSqlSelect = strSqlSelect & "       sig_atividade.codatividade, "
	strSqlSelect = strSqlSelect & "       sig_programacao.funcao, "
	strSqlSelect = strSqlSelect & "       sig_programacao.dthrinicio, "
	strSqlSelect = strSqlSelect & "       sig_programacao.seqaeroporig, "
	strSqlSelect = strSqlSelect & "       sig_programacao.seqaeropdest, "
	strSqlSelect = strSqlSelect & "       sig_jornada.dthrapresentacao, "
	strSqlSelect = strSqlSelect & "       sig_jornada.dthrapresentacaorealiz, "
	strSqlSelect = strSqlSelect & "       CASE sig_programacao.funcao WHEN 'I' THEN 0 WHEN 'C' THEN 0 ELSE 1 END as c_ordemfuncao, "
	strSqlSelect = strSqlSelect & "       sig_cargo.ordem, "
	strSqlSelect = strSqlSelect & "       sig_tripulante.senioridade, "
	strSqlSelect = strSqlSelect & "       sig_tripulante.nomeguerra, "
	strSqlSelect = strSqlSelect & "       sig_funcaobordo.codfuncaobordo "
	strSqlSelect = strSqlSelect & "  FROM sig_jornada, "
	strSqlSelect = strSqlSelect & "       sig_programacao "
	strSqlSelect = strSqlSelect & "       LEFT OUTER JOIN sig_atividade ON sig_programacao.seqatividade = sig_atividade.seqatividade "
	strSqlSelect = strSqlSelect & "       LEFT OUTER JOIN sig_escdiariovoo ON sig_programacao.seqvoodiaesc = sig_escdiariovoo.seqvoodiaesc "
	strSqlSelect = strSqlSelect & "       LEFT OUTER JOIN sig_funcaobordo ON sig_programacao.funcao = sig_funcaobordo.codredfuncaobordo, "
	strSqlSelect = strSqlSelect & "       sig_tripulante, "
	strSqlSelect = strSqlSelect & "       sig_tripbase, "
	strSqlSelect = strSqlSelect & "       sig_aeroporto, "
	strSqlSelect = strSqlSelect & "       sig_tripcargo, "
	strSqlSelect = strSqlSelect & "       sig_cargo "
	strSqlSelect = strSqlSelect & " WHERE sig_jornada.seqjornada = sig_programacao.seqjornada "
	strSqlSelect = strSqlSelect & "   and sig_jornada.seqtripulante = sig_tripulante.seqtripulante "
	strSqlSelect = strSqlSelect & "   and sig_jornada.flgcorrente = 'S' "
	strSqlSelect = strSqlSelect & "   and sig_tripcargo.seqtripulante = sig_tripulante.seqtripulante "
	strSqlSelect = strSqlSelect & "   AND sig_tripcargo.dtinicio <= sig_jornada.dtjornada "
	strSqlSelect = strSqlSelect & "   AND (sig_tripcargo.dtfim >= sig_jornada.dtjornada OR sig_tripcargo.dtfim is null) "
	strSqlSelect = strSqlSelect & "   AND sig_cargo.codcargo = sig_tripcargo.codcargo "
	strSqlSelect = strSqlSelect & "   and ((sig_programacao.flgtipo = 'V' AND sig_programacao.seqaeroporig = sig_aeroporto.seqaeroporto) "
	strSqlSelect = strSqlSelect & "        OR (sig_programacao.flgtipo = 'A' "
	strSqlSelect = strSqlSelect & "            AND (rtrim(sig_atividade.codtipoatividade) = 'COND' AND sig_programacao.seqaeropatividade = sig_aeroporto.seqaeroporto)) "
	strSqlSelect = strSqlSelect & "        OR (rtrim(sig_atividade.codtipoatividade) = 'RES' "
	strSqlSelect = strSqlSelect & "            AND (sig_programacao.seqaeropatividade = sig_aeroporto.seqaeroporto "
	strSqlSelect = strSqlSelect & "                 OR (sig_programacao.seqaeropatividade IS NULL AND sig_aeroporto.seqcidade = sig_tripbase.seqcidade))) "
	strSqlSelect = strSqlSelect & "        OR (rtrim(sig_atividade.codtipoatividade) = 'SAV' "
	strSqlSelect = strSqlSelect & "            AND EXISTS (SELECT * FROM sig_programacao sp_aux WHERE sp_aux.seqjornada = sig_programacao.seqjornada AND sp_aux.flgtipo = 'V' AND sp_aux.seqaeroporig = sig_aeroporto.seqaeroporto))) "
	strSqlSelect = strSqlSelect & "   and sig_tripulante.seqtripulante = sig_tripbase.seqtripulante "
	strSqlSelect = strSqlSelect & "   and sig_tripbase.dtinicio <= sig_jornada.dtjornada "
	strSqlSelect = strSqlSelect & "   and (sig_tripbase.dtfim >= sig_jornada.dtjornada OR sig_tripbase.dtfim IS NULL) "
	strSqlSelect = strSqlSelect & "   and sig_programacao.seqprogramacao = 1 "
	strSqlSelect = strSqlSelect & "   and sig_jornada.dtjornada between '" & strDataA & "' AND '" & strDataB & "' "
	strSqlSelect = strSqlSelect & "   and sig_jornada.dthrapresentacao between '" & strData1 & "' AND '" & strData2 & "' "
	strSqlSelect = strSqlSelect & "   and sig_aeroporto.seqaeroporto = " & intSeqAeroporto
	strSqlSelect = strSqlSelect & " order by sig_jornada.dthrapresentacao, sig_atividade.codatividade, sig_escdiariovoo.nrvoo, sig_cargo.ordem, sig_tripulante.senioridade, c_ordemfuncao, sig_tripulante.nomeguerra "

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strSqlSelect, objConn

%>

<html>
	<head>
		<title>Apresentação de Tripulantes</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
      <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
	</head>
	<body>
		<table width="98%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="30%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center" width="40%">
					<font size="4"><b>&nbsp;Apresentação de Tripulantes</b><BR></font>
					<font size="4"><b><% Response.Write("Aeroporto: " & objRsAeroporto("codiata"))%></b></font>
				</td>
				<td class="corpo" align="right" valign="middle" width="35%">
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

<%
	Dim Cor1, Cor2, Cor, intContador
	Dim strOrigem, strDestino
	intContador = CInt(0)
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"
	
	Response.Write( "<table width='90%' border='1' cellpadding='0' align='center' cellspacing='0' ID='Table2'>" )

	ll_dia_ant = 0
	ll_hora_ant = 0
	ll_nrvoo_ant = 0
	ls_codatividade_ant = ""
	
	Do While Not ObjRs.Eof
		ldt_dthrapresentacao = ObjRs("dthrapresentacao")
		ldt_dthrapresentacaorealiz = ObjRs("dthrapresentacaorealiz")
		ll_nrvoo = ObjRs("nrvoo")
		ls_codatividade = ObjRs("codatividade")
		
		If IsNull( ll_nrvoo ) Then
			ll_nrvoo = 0
		Else
			ll_nrvoo = CInt(ll_nrvoo)
		End if
		If IsNull( ls_codatividade ) Then ls_codatividade = ""
		
		ll_dia = Day( ldt_dthrapresentacao )
		ll_hora = Hour( ldt_dthrapresentacao )
		
		If ll_dia <> ll_dia_ant OR ll_hora <> ll_hora_ant OR ll_nrvoo <> ll_nrvoo_ant OR ls_codatividade <> ls_codatividade_ant Then
			' Provoca QUEBRA de tabela
			If ll_dia_ant <> 0 Then Response.Write( "<tr><td colspan='8' height='10'></td></tr>" )
			
			Response.Write( "   <tr bgcolor='#AAAAAA'>" )
			Response.Write( "      <th>Sen.</th>" )
			Response.Write( "      <th>Nome de Guerra</th>" )
			Response.Write( "      <th>Jornada</th>" )
			Response.Write( "      <th>Voo</th>" )
			Response.Write( "      <th>Atividade</th>" )
			Response.Write( "      <th>Função a Bordo</th>" )
			Response.Write( "      <th>Hora Apresentação</th>" )
			Response.Write( "      <th>Apresentação Realiz.</th>" )
			Response.Write( "   </tr>" )
			intContador = CInt(0)
		End if
		
		if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
		end if
		
		If IsDate( ldt_dthrapresentacao ) Then
			ls_dthrapresentacao = Right("00"&Day(ldt_dthrapresentacao),2) & "/" & Right("00"&Month(ldt_dthrapresentacao),2) & "/" & Year(ldt_dthrapresentacao) & " "
			ls_dthrapresentacao = ls_dthrapresentacao & FormatDateTime( ldt_dthrapresentacao, 4 )
		Else
			ls_dthrapresentacao = ""
		End if
		
		If IsDate( ldt_dthrapresentacaorealiz ) Then
			ls_dthrapresentacaorealiz = Right("00"&Day(ldt_dthrapresentacaorealiz),2) & "/" & Right("00"&Month(ldt_dthrapresentacaorealiz),2) & "/" 
			ls_dthrapresentacaorealiz = ls_dthrapresentacaorealiz & Year(ldt_dthrapresentacaorealiz) & " "
			ls_dthrapresentacaorealiz = ls_dthrapresentacaorealiz & FormatDateTime( ldt_dthrapresentacaorealiz, 4 )
		Else
			ls_dthrapresentacaorealiz = ""
		End if
				
		Response.Write("<tr bgcolor=" & Cor & ">" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='right'>" & ObjRs("senioridade") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & vbCrLf)
		Response.Write("		<a href='relatorioescalaapresentacaoregistro.asp?seqjornada=" & objRs("SeqJornada") & "'>" & ObjRs("NomeGuerra") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ObjRs("textojornada") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ObjRs("nrvoo") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ObjRs("codatividade") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ObjRs("codfuncaobordo") & " &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ls_dthrapresentacao & "  &nbsp;</td>" & vbCrLf)
		Response.Write("	<td class='corpo' nowrap align='center'>" & ls_dthrapresentacaorealiz & " &nbsp;</td>" & vbCrLf)
		Response.Write("	</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)

		intContador = intContador + 1
		ll_dia_ant = ll_dia
		ll_hora_ant = ll_hora
		ll_nrvoo_ant = ll_nrvoo
		ls_codatividade_ant = ls_codatividade
		objRs.movenext
	loop

	objRs.Close
	objConn.close
	Set objRs = Nothing
	Set objConn = Nothing
	
	If intContador > 0 Then
		Response.Write( "<tr>" )
		Response.Write( "<th colspan='8'></th>" )
		Response.Write( "</tr>" )
	End if
	Response.Write( "</table>" )
%>
		<br />
		<br />
		<br />
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