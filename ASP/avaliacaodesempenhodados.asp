<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="header.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Untitled Document</title>
</head>

<body>
<%
	Dim strQueryNomeGuerra
	strQueryNomeGuerra = "Select nomeguerra From sig_tripulante where UPPER(nomeguerra) like UPPER('" & UCase(Request.Form("querystring")) & "%') "

	Dim objConnNomeGuerra
	Set objConnNomeGuerra = CreateObject("ADODB.CONNECTION")
	objConnNomeGuerra.Open(StringConexaoSqlServer)

	Dim objRsNomeGuerra
	Set objRsNomeGuerra = Server.CreateObject("ADODB.Recordset")
	objRsNomeGuerra.Open strQueryNomeGuerra, objConnNomeGuerra

	Do While Not objRsNomeGuerra.EOF
		Response.Write("<li class='CORPO8' onclick='fill(&quot;" & objRsNomeGuerra("nomeguerra") & "&quot;);'><font color='white'>" & objRsNomeGuerra("nomeguerra") & "</font></li>")
		objRsNomeGuerra.MoveNext()
	Loop

	objRsNomeGuerra.Close()
	Set objRsNomeGuerra = Nothing

	objConnNomeGuerra.Close()
	Set objConnNomeGuerra = Nothing
%>
</body>

</html>
