<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="libgeral.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>
<body>
<%
   Dim ll_Seqmnt
	Dim ll_SeqVooDia
	Dim ll_SeqTrecho
	Dim RS
	Dim sqlDelete
	Dim objConn
	Dim strDia, strMes, strAno
	
	Set objConn = CreateObject("ADODB.CONNECTION")
   objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"
	
   ll_Seqmnt = Request.QueryString("Seqmnt")
	ll_SeqVooDia = Request.QueryString("SeqVooDia")
	ll_SeqTrecho = Request.QueryString("SeqTrecho")
	strDia = Request.QueryString("strDia")
   strMes = Request.QueryString("strMes")
   strAno = Request.QueryString("strAno")
	
	sqlDelete = " Delete FROM sig_diariotrechodbmnt WHERE seqvoodia = '" & ll_SeqVooDia & "' AND seqtrecho = '" & ll_SeqTrecho & "' And seqmnt = '" & ll_Seqmnt & "' "
	
	Set RS = objConn.Execute(sqlDelete)
	objConn.Close
	
	Response.Redirect("Mnt_Registro_Mnt.asp?SeqVooDia=" & ll_SeqVooDia & "&SeqTrecho=" & ll_SeqTrecho & "&strDia=" & strDia &"&strMes=" & strMes & "&strAno=" & strAno)
%>	
</body>
</html>
