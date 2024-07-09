<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="header.asp"-->
<% Response.Charset="ISO-8859-1" %>
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<%

Public Function f_permissao( ByVal al_sequsuario, ByVal as_codfuncao, ByRef aConn, ByRef aRS )
   ' Recupera a Permissão do Usuário
	If CInt( al_sequsuario ) = 1 Then
	   f_permissao = "A"
	Else
		Set aRS = aConn.Execute( "SELECT * FROM sig_usuariofuncao WHERE sequsuario = " & al_sequsuario & " AND codfuncao = '" & as_codfuncao & "'" )
		
		If NOT aRS.EOF Then
			f_permissao = aRS( "flgpermissao" )
		Else
   		f_permissao = ""
		End if
	End if
End Function
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; chaRSet=iso-8859-1">
<title>SIGLA - Sistema Integrado de Gestão de Linhas Aéreas</title>
</head>

<body>
<%

Dim Conn, RS, ll_sequsuario

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

ll_sequsuario = Session("member")

%>
<dt>
   <a href='#' class='CORPO' style='font-size: 17 px' onClick="TrataRelatorios()" >Relatórios...</a>
</dt>    
<%
	
If Request.QueryString("aberto") = 0 Then
	Response.Write("<dd>")
		If f_permissao( ll_sequsuario, "I05", Conn, RS ) = "A" Then
		Response.Write(    "<a href='relatorioaproveitcargasconsult.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Aproveitamento de Carga</font></a><br>")
	End if
	If f_permissao( ll_sequsuario, "I01", Conn, RS ) = "A" Then			
		Response.Write(     "<a href='relatorioaproveitvoosconsult.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Aproveitamento de Etapas de Voo</font></a><br>" )
	End if
	If f_permissao( ll_sequsuario, "I12", Conn, RS ) = "A" Then
		Response.Write(    "<a href='Rel_Movacft_Coordenacao.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Movimento de Aeronaves</font></a><br>" )
	End if
	If f_permissao( ll_sequsuario, "I04", Conn, RS ) = "A" Then
		Response.Write(    "<a href='relatoriomatrizpaxconsult.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Origem e Destino</font></a><br>" )
	End if
	If f_permissao( ll_sequsuario, "I03", Conn, RS ) = "A" Then
		Response.Write(    "<a href='relatoriopontualidadeconsult.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Pontualidade e Regularidade dos Voos</font></a><br>")
	End if
	If f_permissao( ll_sequsuario, "I13", Conn, RS ) = "A" Then
		Response.Write(    "<a href='Mnt_Registro_Relatorio.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Registro de Manutenção</font></a><br>")
	End if
	If f_permissao( ll_sequsuario, "I02", Conn, RS ) = "A" Then
		Response.Write(    "<a href='relatoriovoosplanejconsult.asp' class='CORPO' style='font-size: 17 px'><font color='red'>Voos Planejados</font></a><br>")
	End if
	Response.Write("</dd>")
End If			

Conn.close				
%>
</body>
</html>
