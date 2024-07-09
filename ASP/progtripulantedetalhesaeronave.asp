<!--#include file="header.asp"-->
<!--#include file="verificalogintripulante.asp"-->
<%
	Dim prefixored
	prefixored = Request.QueryString("prefixo")

	Dim Conn
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"

	Dim RS, sSql
	sSql=        " SELECT ARNV.prefixo "
	sSql= sSql & " FROM sig_aeronave ARNV "
	sSql= sSql & " WHERE ARNV.prefixored = '" & prefixored & "' "

	set RS = conn.execute(sSql)

	Dim prefixo
	prefixo = RS("prefixo")

%>
<html>
<head>
	<title>Programação do Tripulante - Detalhes da Aeronave</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<script type="text/javascript" src="javascript.js"></script>
	<style type="text/css">
		table { empty-cells: show; }
	</style>
</head>

<body bgcolor="white" link="blue">
<div align="left" style="border:solid 1px #000000; margin:5px; padding:1px 0 10px 0;">
	<iframe scrolling="no" frameborder="0" width="850px" height="435px" src="../Tripulantes/DetalhesAeronave.aspx?prefixo=<%=prefixo%>"></iframe>
	<a href="http://biblioteca.webjet.ws/biblioteca/arquivos/MEL%20-%20REV%2007%20-%2014OCT2011.pdf" target="_blank" style="margin-left:10px;">Manual MEL 737-300</a>
	<br />
	<a href="https://sites.google.com/a/webjet.com.br/biblioteca-eletronica/manuais-tecnicos/equipamento-b737-ng" target="_blank" style="margin-left:10px;">Manual MEL 737-800</a>
</div>
</body>

</html>
