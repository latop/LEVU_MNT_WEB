<%@ Language=VBScript %>
<!--#include file="header.asp"-->

<%
	Dim objConexao
	Dim strQuery, strSqlUpdate, strSqlSet, strSqlWhere

	set objConexao = Server.CreateObject ("ADODB.Connection")
	objConexao.Open (StringConexaoAccess)

	strSqlUpdate = " UPDATE Historico_Usuario "
	strSqlSet = " SET "
	strSqlSet = strSqlSet & " Hora_Logout = #" & now() & "# "
	strSqlWhere = " WHERE "
	strSqlWhere = strSqlWhere & " Id_Usuario = " & Session("member") & " AND "
	strSqlWhere = strSqlWhere & " Id_Sessao = " & Session.SessionID & " AND "
	strSqlWhere = strSqlWhere & " Hora_Login = #" & Session("HoraLogin") & "# AND "
	strSqlWhere = strSqlWhere & " IP_Usuario = '" & Request.ServerVariables("REMOTE_ADDR") & "' "
	strQuery = strSqlUpdate & strSqlSet & strSqlWhere

	objConexao.Execute (strQuery)
	objConexao.close
	set objConexao= nothing

	Session.Abandon
%>

	<CENTER>
	<p class=FieldLabel>Sessão Finalizada!</p>
	<font class=fieldLabel>Efetuar</font> <a href="Default.asp" class=errmsg>Login?</a>
	</CENTER>