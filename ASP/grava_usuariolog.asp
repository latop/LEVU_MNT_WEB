<%
'--------------------------------------------------------------------------------------------------------------------
' Grava registro na sig_usuariolog
'--------------------------------------------------------------------------------------------------------------------
Public Function f_grava_usuariolog( ByVal as_codfuncao, ByRef aConn )
	Dim ls_sql, ll_sequsuario, ls_insereusuariolog, ConnUL, intDominio

	intDominio = Session("dominio")

	Set ConnUL = CreateObject("ADODB.CONNECTION")
	ConnUL.Open (StringConexaoSqlServer)

	ls_insereusuariolog = Request.Form( "insereusuariolog" )

	If ls_insereusuariolog <> "N" Then
		ll_sequsuario = Session("member")
		
		ls_sql =          "INSERT INTO sig_usuariolog "
		ls_sql = ls_sql &   "( sequsuario, codfuncao, dtacesso, versaoatual, dominio ) "
		ls_sql = ls_sql & "VALUES ( "
		ls_sql = ls_sql &   ll_sequsuario & ", "
		ls_sql = ls_sql &   "'" & as_codfuncao & "', "
		ls_sql = ls_sql &   "'" & Year(Now) & "-" & Right("00"&Month(Now),2) & "-" & Right("00"&Day(Now),2) & " "
		ls_sql = ls_sql &   Right("00"&Hour(Now),2) & ":" & Right("00"&Minute(Now),2) & "', "
		ls_sql = ls_sql &   "'INTERNET', "
		ls_sql = ls_sql &   intDominio & " )"

		On Error Resume Next
		ConnUL.Execute "SET DATEFORMAT ymd"
		ConnUL.Execute( ls_sql )
		ConnUL.Close
		On Error Goto 0
	End if
	
	Response.Write( "<input type='hidden' name='insereusuariolog' value='N'>" )
	
	f_grava_usuariolog = ""
End Function
%>
