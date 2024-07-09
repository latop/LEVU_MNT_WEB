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
	Dim objConn
	Dim sSqlBusca
	Dim sSqlBusca2
	Dim RsBusca
	
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	'Response.Write(UCASE(Request.Form("queryString")))
	'Response.End()
	
	sSqlBusca = "Select nomeguerra From sig_tripulante where nomeguerra like '" & UCase(Request.Form("querystring")) & "%' "
	
	Set RsBusca = objConn.Execute(sSqlBusca)

	Do While Not RsBusca.EOF 	
		Response.Write("<li class='CORPO8' onclick='fill(&quot;"&RsBusca("nomeguerra")&"&quot;);'><font color='white'>" & RsBusca("nomeguerra") & "</font></li>")
		RsBusca.MoveNext
	Loop
	
	objConn.close
 
      	
%>

</body>
</html>
