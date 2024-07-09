<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<html>
<body>

<%
Dim ll_seqnotaabastec
Dim ll_dia1, ll_mes1, ll_ano1, ll_dia2, ll_mes2, ll_ano2
Dim Conn

ll_seqnotaabastec = Request.QueryString("intSeqNota")
ll_dia1           = Request.QueryString("dia_ini")
ll_mes1           = Request.QueryString("mes_ini")
ll_ano1           = Request.QueryString("ano_ini")
ll_dia2           = Request.QueryString("dia_fim")
ll_mes2           = Request.QueryString("mes_fim")
ll_ano2           = Request.QueryString("ano_fim")

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Dim ls_SQL, RS
Dim dtNota

ls_SQL =  " SELECT dtnota FROM sig_combnotaabastec WHERE seqnotaabastec = " & ll_seqnotaabastec
Set RS = Conn.Execute( ls_SQL )

IF (Not RS.EOF) THEN
	dtNota = RS("dtnota")
END IF

ls_SQL = " SELECT dtfechadocomb FROM sig_parametros "
Set RS = Conn.Execute( ls_SQL )

IF (Not RS.EOF) THEN
	Dim dtFechadoComb
	dtFechadoComb = RS("dtfechadocomb")
	IF (IsDate(dtFechadoComb) AND IsDate(dtNota)) THEN
		IF (CDate(dtNota) < CDate(dtFechadoComb)) THEN
			FecharConexoes()
			Dim strMensagem
			strMensagem = "Não é possível excluir uma nota cuja Data da Nota seja menor do que " & dtFechadoComb & " !"
			response.write ("<script language=javascript> alert(' " & strMensagem & " '); history.go(-1);</script>")
			response.End()
		END IF
	END IF
END IF

Conn.execute "DELETE FROM sig_combnotaabastec WHERE seqnotaabastec = " & ll_seqnotaabastec

FecharConexoes()

Response.Redirect("na_Consulta_nota.asp?dia_ini="&ll_dia1&"&mes_ini="&ll_mes1&"&ano_ini="&ll_ano1&"&dia_fim="&ll_dia2&"&mes_fim="&ll_mes2&"&ano_fim="&ll_ano2)



Function FecharConexoes()

	On Error Resume Next

	Conn.Close
	set Conn = nothing

	On Error Goto 0

End Function

%>

</body>
</html>