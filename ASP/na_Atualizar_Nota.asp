<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Server.ScriptTimeout=900%>

<html>
<head><title></title></head>
<body>

<%

Dim strMensagem

Dim ll_dia1, ll_mes1, ll_ano1, ll_dia2, ll_mes2, ll_ano2, ll_aerop_abastec
ll_dia1 = Request.QueryString("dia_ini")
ll_mes1 = Request.QueryString("mes_ini")
ll_ano1 = Request.QueryString("ano_ini")
ll_dia2 = Request.QueryString("dia_fim")
ll_mes2 = Request.QueryString("mes_fim")
ll_ano2 = Request.QueryString("ano_fim")
ll_aerop_abastec = Request.QueryString("aerop_abastec")

Dim strGravar, strExcluir
strGravar = Request.Form("btnGravar")
strExcluir = Request.Form("btnExcluir")

Dim intSeqNota_Alterar
intSeqNota_Alterar = Request.Form("intSeqNota_Alterar")

Dim Conn
Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open(StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

IF (strGravar <> "") THEN
	Dim intNotaAbastec, dtNota, prefixoRedAeronave, dtDataVoo, intVoo, Distribuidor
	intNotaAbastec = Request.Form("Nota_Abastecimento")
	dtNota = Request.Form("Data_nota_ano") & "/" & Request.Form("Data_nota_mes") & "/" & Request.Form("Data_nota_dia")
	prefixoRedAeronave = UCase(Request.Form("Aeronave"))
	dtDataVoo = Request.Form("Data_voo_ano") & "/" & Request.Form("Data_voo_mes") & "/" & Request.Form("Data_voo_dia")
	intVoo = Request.Form("Voo")
	Distribuidor = Request.Form("Distribuidor")

	Dim intAerop
	intAerop = Session("seqaeroporto")
	if (IsVazio(intAerop)) then
		intAerop = Request.form("comboAeropAbastec")
	end if

	Dim dtInicioAbastec
	IF (IsVazio(Request.Form("Data_inicio_dia")) OR IsVazio(Request.Form("Data_inicio_mes")) OR IsVazio(Request.Form("Data_inicio_ano")) OR IsVazio(Request.Form("Hora_Inicial")) OR IsVazio(Request.Form("Minuto_inicial"))) THEN
		dtInicioAbastec = ""
	ELSE
		dtInicioAbastec = Request.Form("Data_inicio_ano") & "/" & Request.Form("Data_inicio_mes") & "/" & Request.Form("Data_inicio_dia") & " " & Request.Form("Hora_inicial") & ":" & Request.Form("Minuto_inicial")
	END IF

	Dim dtFimAbastec
	IF (IsVazio(Request.Form("Data_fim_dia")) OR IsVazio(Request.Form("Data_fim_mes")) OR IsVazio(Request.Form("Data_fim_ano")) OR IsVazio(Request.Form("Hora_final")) OR IsVazio(Request.Form("Minuto_final"))) THEN
		dtFimAbastec = ""
	ELSE
		dtFimAbastec = Request.Form("Data_fim_ano") & "/" & Request.Form("Data_fim_mes") & "/" & Request.Form("Data_fim_dia") & " " & Request.Form("Hora_final") & ":" & Request.Form("Minuto_final")
	END IF

	Dim intQtdInicioAbastec, intQtdFimAbastec, intVolumeAbastec
	intQtdInicioAbastec = Request.Form("Qtd_inicio_abastec")
	intQtdFimAbastec = Request.Form("Qtd_fim_abastec")
	intVolumeAbastec = intQtdFimAbastec - intQtdInicioAbastec

	Dim intCombPartidaMotor
	intCombPartidaMotor = Request.Form("comb_partida_motor")
	if (IsVazio(intCombPartidaMotor)) then intCombPartidaMotor = "NULL"

	Dim sSql, RS
	IF (NOT IsDate(dtNota)) THEN
		FecharConexoes()
		Response.Write("<script language=javascript> alert(' Data da Nota Inválida! '); history.go(-1);</script>")
		Response.End()
	ELSE
		sSQL = " SELECT dtfechadocomb FROM sig_parametros "
		Set RS = Conn.Execute(sSQL)

		IF (Not RS.EOF) THEN
			Dim dtFechadoComb
			dtFechadoComb = RS("dtfechadocomb")
			IF (IsDate(dtFechadoComb)) THEN
				IF (CDate(dtNota) < CDate(dtFechadoComb)) THEN
					FecharConexoes()
					strMensagem = "A Data da Nota não pode ser menor do que " & dtFechadoComb & " !"
					Response.Write("<script language=javascript> alert(' " & strMensagem & " '); history.go(-1);</script>")
					Response.End()
				END IF
			END IF
		END IF

	END IF

	IF (IsVazio(dtInicioAbastec)) THEN
		dtInicioAbastec = "NULL"
	ELSE
		IF NOT IsDate(dtInicioAbastec) THEN
			FecharConexoes()
			response.write ("<script language=javascript> alert(' Data de Início do Abastecimento Inválida! '); history.go(-1);</script>")
			response.End()
		ELSE
			dtInicioAbastec = "'" & dtInicioAbastec & "'"
		END IF
	END IF

	IF (IsVazio(dtFimAbastec)) THEN
		dtFimAbastec = "NULL"
	ELSE
		IF NOT IsDate(dtFimAbastec) THEN
			FecharConexoes()
			response.write ("<script language=javascript> alert(' Data de Fim do Abastecimento Inválida! '); history.go(-1);</script>")
			response.End()
		ELSE
			dtFimAbastec = "'" & dtFimAbastec & "'"
		END IF
	END IF

	sSQL =          " SELECT prefixo "
	sSQL = sSQL & " FROM sig_aeronave "
	sSQL = sSQL & " WHERE prefixored = '" & prefixoRedAeronave & "' "

	Set RS = Conn.Execute(sSQL)

	IF (RS.EOF) THEN
		FecharConexoes()
		Response.Write("<script language=javascript> alert(' Aeronave não encontrada! '); history.go(-1);</script>")
		Response.End()
	END IF

	Dim ls_prefixo
	ls_prefixo = RS("prefixo")

	Dim ll_seqvoodia, ll_seqtrecho
	if (IsVazio(intVoo)) then
		ll_seqvoodia = "NULL"
		ll_seqtrecho = "NULL"
	else
		if (Not IsDate(dtDataVoo)) then
			FecharConexoes()
			response.write ("<script language=javascript> alert(' Data do Voo Inválida! '); history.go(-1);</script>")
			response.End()
		elseif (Abs(DateDiff("d", dtNota, dtDataVoo)) > 2) then
			FecharConexoes()
			response.write ("<script language=javascript> alert(' A Data da Nota é inconsistente com a Data do Voo. '); history.go(-1);</script>")
			response.End()
		end if

		sSql =        " SELECT sig_diariovoo.seqvoodia, sig_diariotrecho.seqtrecho "
		sSql = sSql & " FROM sig_diariovoo, sig_diariotrecho "
		sSql = sSql & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
		sSql = sSql & " AND sig_diariovoo.nrvoo = '" & intVoo & "' "
		sSql = sSql & " AND sig_diariovoo.dtoper = '" & dtDataVoo & "' "
		sSql = sSql & " AND sig_diariotrecho.seqaeroporig = " & intAerop

		set RS = Conn.Execute(sSQL)

		IF RS.EOF THEN
			FecharConexoes()
			response.write ("<script language=javascript> alert(' Voo informado não encontrado! '); history.go(-1);</script>")
			response.End()
		END IF

		ll_seqvoodia = RS("seqvoodia")
		ll_seqtrecho = RS("seqtrecho")
	end if

	'Verifica se já existe alguma nota com o mesmo número
	Dim sqlCount
	sqlCount =            " Select Count(*) as Resultado "
	sqlCount = sqlCount & " FROM sig_combnotaabastec "
	sqlCount = sqlCount & " WHERE seqaeropabastec = " & intAerop & " "
	sqlCount = sqlCount & " And combna = '" & intNotaAbastec & "' "
	sqlCount = sqlCount & " And seqnotaabastec <> " & intSeqNota_Alterar

	set RS = Conn.Execute(sqlCount)

	if RS("Resultado") > 0 then
		FecharConexoes()
		response.write ("<script language=javascript> alert(' Nota já cadastrada! '); history.go(-1);</script>")
		response.End()
	end if

	Dim sqlValor
	sqlValor =            " SELECT sig_combvalor.valor * " & intVolumeAbastec & " as valor_total "
	sqlValor = sqlValor & " FROM sig_combvalor "
	sqlValor = sqlValor & " WHERE sig_combvalor.seqaeroporto = '" & intAerop & "' "
	sqlValor = sqlValor & " AND sig_combvalor.coddistribuidor = '" & Distribuidor & "' "
	sqlValor = sqlValor & " AND sig_combvalor.dtinicio <= '" & dtNota & "' "
	sqlValor = sqlValor & " AND (sig_combvalor.dtfim >= '" & dtNota & "' OR sig_combvalor.dtfim IS NULL)"

	set RS = Conn.Execute(sqlValor)

	Dim ldec_valor
	IF RS.EOF THEN
		ldec_valor = 0
	ELSE
		Dim valor_total
		valor_total = CDbl(RS("valor_total"))
		if (valor_total >= 100000.00) then
			FecharConexoes()
			response.write ("<script language=javascript> alert(' O volume abastecido está muito grande! '); history.go(-1);</script>")
			response.End()
		end if
		ldec_valor = Replace(RS("valor_total"), ",", ".")
	END IF

	Dim dataHoraAtual
	dataHoraAtual = Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now())

	Dim sqlUpdate
	sqlUpdate =             " UPDATE sig_combnotaabastec "
	sqlUpdate = sqlUpdate & " SET coddistribuidor = '" & Distribuidor & "', "
	sqlUpdate = sqlUpdate & " prefixo = '" & ls_prefixo & "', "
	sqlUpdate = sqlUpdate & " seqvoodia = " & ll_seqvoodia & ", "
	sqlUpdate = sqlUpdate & " seqtrecho = " & ll_seqtrecho & ", "
	sqlUpdate = sqlUpdate & " seqaeropabastec = " & intAerop & ", "
	sqlUpdate = sqlUpdate & " dtnota = '" & dtNota & " ', "
	sqlUpdate = sqlUpdate & " combna = '" & intNotaAbastec & "', "
	sqlUpdate = sqlUpdate & " dtinicioabastec = " & dtInicioAbastec & ", "
	sqlUpdate = sqlUpdate & " dtfimabastec = " & dtFimAbastec & ", "
	sqlUpdate = sqlUpdate & " abastecvol = '" & intVolumeAbastec & "', "
	sqlUpdate = sqlUpdate & " valor = " & ldec_valor & ", "
	sqlUpdate = sqlUpdate & " abastecini = " & intQtdInicioAbastec & ", "
	sqlUpdate = sqlUpdate & " abastecfim = " & intQtdFimAbastec & ", "
	sqlUpdate = sqlUpdate & " combpartidamotor = " & intCombPartidaMotor & ", "
	sqlUpdate = sqlUpdate & " sequsuario = " & usuario & ", "
	sqlUpdate = sqlUpdate & " dthralteracao = '" & dataHoraAtual & "' "
	sqlUpdate = sqlUpdate & " WHERE seqnotaabastec = " & intSeqNota_Alterar

	'response.write("<BR><BR>"&sqlUpdate&"<BR>"&Len(sqlUpdate))
	'response.End()

	On Error Resume Next

	Conn.Execute(sqlUpdate)
	If (Err.Number <> 0) then
		'Response.write (Err.description)
		FecharConexoes()
		Response.Write("<script language=javascript> alert('Ocorreu um erro inesperado no sistema!'); history.go(-1);</script>")
		On Error Goto 0
		Response.End()
	end if

	FecharConexoes()

	On Error Goto 0

ELSEIF (strExcluir <> "") THEN
	Dim ls_SqlExcluir, RsExcluir
	Dim dtNotaExcluir

	ls_SqlExcluir =  " SELECT dtnota FROM sig_combnotaabastec WHERE seqnotaabastec = " & intSeqNota_Alterar
	Set RsExcluir = Conn.Execute(ls_SqlExcluir)

	IF (Not RsExcluir.EOF) THEN
		dtNotaExcluir = RsExcluir("dtnota")
	else
		FecharConexoes()
		strMensagem = "Não foi possível excluir a nota selecionada!"
		response.write ("<script language=javascript> alert(' " & strMensagem & " '); history.go(-1);</script>")
		response.End()
	END IF

	ls_SqlExcluir = " SELECT dtfechadocomb FROM sig_parametros "
	Set RsExcluir = Conn.Execute(ls_SqlExcluir)

	IF (Not RsExcluir.EOF) THEN
		Dim dtFechadoCombExcluir
		dtFechadoCombExcluir = RsExcluir("dtfechadocomb")
		IF (IsDate(dtFechadoCombExcluir) AND IsDate(dtNotaExcluir)) THEN
			IF (CDate(dtNotaExcluir) < CDate(dtFechadoCombExcluir)) THEN
				FecharConexoes()
				strMensagem = "Não é possível excluir uma nota cuja Data da Nota seja menor do que " & dtFechadoCombExcluir & " !"
				response.write ("<script language=javascript> alert(' " & strMensagem & " '); history.go(-1);</script>")
				response.End()
			END IF
		END IF
	END IF

	On Error Resume Next

	Conn.execute "DELETE FROM sig_combnotaabastec WHERE seqnotaabastec = " & intSeqNota_Alterar
	If (Err.Number <> 0) then
		'Response.write (Err.description)
		FecharConexoes()
		Response.Write("<script language=javascript> alert('Ocorreu um erro inesperado no sistema!'); history.go(-1);</script>")
		On Error Goto 0
		Response.End()
	end if

	FecharConexoes()

	On Error Goto 0

END IF

Response.Redirect("na_Consulta_nota.asp?dia_ini="&ll_dia1&"&mes_ini="&ll_mes1&"&ano_ini="&ll_ano1&"&dia_fim="&ll_dia2&"&mes_fim="&ll_mes2&"&ano_fim="&ll_ano2&"&aerop_abastec="&ll_aerop_abastec)



'******************************************************************

Function FecharConexoes()

	On Error Resume Next

	Conn.Close
	set Conn = Nothing

	On Error Goto 0

End Function



Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function



%>

</body>
</html>
