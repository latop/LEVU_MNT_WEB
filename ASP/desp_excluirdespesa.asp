<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeroporto.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SIGLA - </title>
</head>

<body>
<% 
	Dim Conn, Rs
	Dim sSql
	Dim ll_seqdespesa
	
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"
	
	ll_seqdespesa = Request.QueryString("seqdespesa")
	
	sSql = " Delete From sig_liberacaodespesa Where seqdespesa = " & ll_seqdespesa

	Set Rs = Conn.Execute(sSql)

	Response.redirect("desp_consultadespesas.asp?voltar=voltar&txt_Data1=" & request.querystring("data1") & "&txt_Data2=" & request.querystring("data2") ) 
	
%>
</body>
</html>
