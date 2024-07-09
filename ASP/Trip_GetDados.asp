
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<%
 	Dim objConn
	Dim ls_Querystring
	Dim sSqlBusca
	Dim RsBusca
	Dim ls_NomeGuerra
 
 	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"
	
	sSqlBusca = "Select nomeguerra From sig_tripulante Where nomeguerra Like '" & ls_Querystring & "' Limit 10 "
	
	Set RsBusca = objConn.Execute(sSqlBusca)
	
	Do While Not RsBusca.EOF
			ls_NomeGuerra = RsBusca("NomeGuerra")
			Response.Write("<li onClick='fill(\ '" & ls_NomeGuerra & "' /)';> '" & ls_NomeGuerra & "' <li> ")
			
			RsBusca.MoveNext
	Loop		
	
	
%>

</body>
</html>
