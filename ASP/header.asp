<% Option Explicit %>
<%Session.LCID = 1046%>
<%Response.Expires = -1%>
<%Response.Expiresabsolute = Now() - 1%>
<%Response.AddHeader "cache-control","private"%>
<%Response.CacheControl = "no-cache"%>

<%

	Session.Timeout = 120
	Dim StringConexaoSqlServer, StringConexaoSqlServerEncriptado, StringConexaoSqlServerUpdateEncriptado
	Dim strDataSource, strInitialCatalog, strUserID, strPassword

%>
<!--#include file="SiglaWebConnectionStrings.asp"-->
<%

	StringConexaoSqlServer			= "Database=" & strInitialCatalog & ";Provider=SQLOLEDB;Network Library=DBMSSOCN;Server=" & strDataSource & ";UID=" & strUserID & ";Pwd=" & strPassword & ";Encrypt=no;Trusted_Connection=no;"
	StringConexaoSqlServerEncriptado	= "Database=" & strInitialCatalog & ";Provider=SQLOLEDB;Network Library=DBMSSOCN;Server=" & strDataSource & ";UID=" & strUserID & ";Pwd=" & strPassword & ";Encrypt=yes;Trusted_Connection=no;"
	StringConexaoSqlServerUpdateEncriptado	= "Database=" & strInitialCatalog & ";Provider=SQLOLEDB;Network Library=DBMSSOCN;Server=" & strDataSource & ";UID=" & strUserID & ";Pwd=" & strPassword & ";Encrypt=yes;Trusted_Connection=no;"

%>
<!--#include file="SiglaWebAppSettings.asp"-->
<%

	function fnEncriptaSenha(pStrSenha)

		Dim ls_Criptografado, ls_CriptografadoFinal
		Dim li_char

		ls_criptografado = pStrSenha

		li_char = 70
		Do While Len(ls_criptografado) < 20
			ls_criptografado = ls_criptografado & Chr(li_char)
			li_char = li_char + 1
		LOOP

		ls_CriptografadoFinal = Chr(Asc(Mid(ls_criptografado, 1, 1)) + 1)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 2, 1)) - 2)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 3, 1)) + 3)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 4, 1)) - 4)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 5, 1)) + 5)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 6, 1)) - 1)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 7, 1)) + 2)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 8, 1)) - 3)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 9, 1)) + 4)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 10, 1)) - 5)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 11, 1)) + 1)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 12, 1)) - 2)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 13, 1)) + 3)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 14, 1)) - 4)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 15, 1)) + 5)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 16, 1)) - 1)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 17, 1)) + 2)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 18, 1)) - 3)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 19, 1)) + 4)
		ls_CriptografadoFinal = ls_CriptografadoFinal & Chr(Asc(Mid(ls_criptografado, 20, 1)) - 5)

		fnEncriptaSenha = UCase(ls_CriptografadoFinal)

	end function

	Function fnNaoNulo(strValor)
		strValor = CStr(strValor)
		if IsNull(strValor) then
			fnNaoNulo = "0"
		else
			fnNaoNulo = strValor
		end if
	end function

%>
<style type="text/css">
    <!--
    .botao1 {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 12px;
        font-weight: bold;
    }

    .defaultsmall {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 12px;
    }

    .ErrMsg {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 12px;
        font-style: normal;
        color: red;
        font-weight: bold;
    }

    .FieldLabel {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 12px;
        font-style: normal;
        color: #336899;
        font-weight: bold;
    }

    .collTitle {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 12px;
        font-weight: bold;
        color: #b0e0e6;
    }

    .bigTitle {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 80px;
        font-weight: bold;
        color: #b0e0e6;
    }

    A:link {
        font-family: Arial, Helvetica, sans-serif;
        text-decoration: none;
    }

    A:visited {
        font-family: Arial, Helvetica, sans-serif;
        text-decoration: none;
    }

    A:active {
        font-family: Arial, Helvetica, sans-serif;
        text-decoration: none;
    }

    A:hover {
        font-family: Arial, Helvetica, sans-serif;
        text-decoration: underline;
    }

    .CORPO {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 8pt;
    }

    .CORPO1 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 1pt;
    }

    .CORPO2 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 2pt;
    }

    .CORPO3 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 3pt;
    }

    .CORPO4 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 4pt;
    }

    .CORPO5 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 5pt;
    }

    .CORPO6 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 6pt;
    }

    .CORPO7 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 7pt;
    }

    .CORPO8 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 8pt;
    }

    .CORPO9 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 9pt;
    }

    .CORPO10 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 10pt;
    }

    .CORPO11 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 11pt;
    }

    .CORPO12 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 12pt;
    }

    .CORPO13 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 13pt;
    }

    .CORPO14 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 14pt;
    }

    .CORPO15 {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 15pt;
    }

    .Corpo6Bold {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 7pt;
        FONT-WEIGHT: BOLD;
    }

    .Corpo7Bold {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 7pt;
        FONT-WEIGHT: BOLD;
    }

    .Corpo8Bold {
        COLOR: black;
        FONT-FAMILY: Verdana;
        FONT-SIZE: 8pt;
        FONT-WEIGHT: BOLD;
    }

    .titulo {
        background-color: #aaaaaa;
        color: black;
        font-family: verdana, arial, helvetica, sans-serif;
        font-size: 12px;
        font-weight: bold;
        text-align: center;
    }

    // -->
</style>
<%
	if ((Session("dominio") = 2) and (Session("member") <> "") and (Session("dominio") <> "") and (Session("login") <> "")) then
		if (VerificarDocObrigatorioPendente()) then
			Response.Redirect("../ASP2ASPX/ASP2ASPX.asp?paginaDestino=DocumentosTripulantes.aspx&dominioDestino=Tripulantes")
		end if
	end if

	function VerificarDocObrigatorioPendente()

'	    VerificarDocObrigatorioPendente = false
'        Exit Function

		Dim seqTripulante, dominio
		seqTripulante = Session("member")
		dominio = Session("dominio")

		Dim strDominio
		Select Case dominio
			Case 1
				strDominio = "Funcionarios"
			Case 2
				strDominio = "Tripulantes"
			Case 3
				strDominio = "Aeroporto"
		End Select

		Dim objConn
		Set objConn = CreateObject("ADODB.CONNECTION")
		objConn.Open (StringConexaoSqlServer)
		objConn.Execute "SET DATEFORMAT ymd"

	    Dim objRs
		Set ObjRs = Server.CreateObject("ADODB.Recordset")


		    Dim strQuery
		    strQuery =            " SELECT COUNT(*) AS QtdArquivosPendentes "
		    strQuery = strQuery & " FROM (SELECT Arq.flgobrigatorio, "
		    strQuery = strQuery & "              ArqGrpUsu.sequsuario, "
		    strQuery = strQuery & "              ArqGrpUsu.dominio, "
		    strQuery = strQuery & "              (SELECT COUNT(*) "
		    strQuery = strQuery & "               FROM sig_auditoriadoc AS AudDoc "
		    strQuery = strQuery & "               WHERE (AudDoc.dominio = '" & strDominio & "') "
		    strQuery = strQuery & "                 AND (AudDoc.sequsuario = " & seqTripulante & ") "
		    strQuery = strQuery & "                 AND (AudDoc.nomearquivo = Arq.nomearquivo) "
		    ' Essa linha foi retirada para resolver um problema na consulta da Avianca em 25/04/2018.
            'strQuery = strQuery & "                 AND (AudDoc.dthralteracao > Arq.dtarquivo) "
		    strQuery = strQuery & "                 AND (AudDoc.nomearquivogrupo = ArqGrp.nomegrupo)) AS QtdAcessos "
		    strQuery = strQuery & "       FROM sig_arquivo AS Arq "
		    strQuery = strQuery & "       INNER JOIN sig_arquivogrupousuario AS ArqGrpUsu ON Arq.seqarquivogrupo = ArqGrpUsu.seqarquivogrupo "
		    strQuery = strQuery & "       INNER JOIN sig_arquivogrupo AS ArqGrp ON ArqGrp.seqarquivogrupo = Arq.seqarquivogrupo AND ArqGrp.nomegrupo <> 'TRIPULANTES' AND ArqGrp.nomegrupo <> 'AEROPORTOS') AS ArqPend "
		    strQuery = strQuery & " WHERE (ArqPend.QtdAcessos = 0) AND (UPPER(ArqPend.flgobrigatorio) = 'S') AND (ArqPend.sequsuario = " & seqTripulante & ") AND (ArqPend.dominio = " & dominio & ") "

		    objRs.Open strQuery, objConn

		    Dim qtdArqPend
		    If (Not ObjRs.Eof) Then
			    qtdArqPend = ObjRs("QtdArquivosPendentes")
			    if (Not IsVazio(qtdArqPend)) then
				    qtdArqPend = CInt(qtdArqPend)
				    if (qtdArqPend > 0) Then
					    VerificarDocObrigatorioPendente = true
				    else
					    VerificarDocObrigatorioPendente = false
				    end if
			    end if
		    Else
			    VerificarDocObrigatorioPendente = false
		    End If
		    objRs.Close

            If(VerificarDocObrigatorioPendente) Then
                Exit Function
            End If

'Response.Write(strQuery)
'Response.End

        if(strDominio = "Tripulantes") Then
		    strQuery = " SELECT count(sig_arquivo.nomearquivo) AS QtdArquivosPendentes "
		    strQuery = strQuery & "   FROM sig_arquivo "
		    strQuery = strQuery & "INNER JOIN sig_arquivogrupo ON sig_arquivogrupo.seqarquivogrupo = sig_arquivo.seqarquivogrupo"
		    strQuery = strQuery & " WHERE (sig_arquivogrupo.nomegrupo = 'TRIPULANTES')"

 		    strQuery = strQuery & "AND ((sig_arquivo.codcargo IS NULL) OR (EXISTS(SELECT 1"
   		    strQuery = strQuery & "FROM sig_tripcargo "
		    strQuery = strQuery & "    WHERE (sig_tripcargo.seqtripulante = " & seqTripulante & ") AND (sig_tripcargo.codcargo = sig_arquivo.codcargo) AND (sig_tripcargo.dtfim is NULL OR sig_tripcargo.dtfim > getdate() )"
		    strQuery = strQuery & "    )))"

		    strQuery = strQuery & " AND ((sig_arquivo.seqfrota IS NULL) OR (EXISTS(SELECT 1"
		    strQuery = strQuery & "    FROM sig_tripfrota"
		    strQuery = strQuery & "    WHERE (sig_tripfrota.seqtripulante = " & seqTripulante & ") AND ((sig_tripfrota.seqfrota) = sig_arquivo.seqfrota) AND (sig_tripfrota.dtfim is NULL OR sig_tripfrota.dtfim > getdate() )"
		    strQuery = strQuery & "    ))) "

		    strQuery = strQuery & " AND ((sig_arquivo.seqcidade IS NULL) OR (EXISTS(SELECT 1"
		    strQuery = strQuery & "    FROM sig_tripbase "
		    strQuery = strQuery & "    WHERE (sig_tripbase.seqtripulante = " & seqTripulante & ") AND ((sig_tripbase.seqcidade) = sig_arquivo.seqcidade) AND (sig_tripbase.dtfim is NULL OR sig_tripbase.dtfim > getdate() )"
		    strQuery = strQuery & "    )))"

		    strQuery = strQuery & " AND ((sig_arquivo.codfuncaotrip IS NULL) OR (EXISTS(SELECT 1"
		    strQuery = strQuery & "    FROM sig_tripfuncaotrip "
		    strQuery = strQuery & "    WHERE (sig_tripfuncaotrip.seqtripulante = " & seqTripulante & ") AND ((sig_tripfuncaotrip.codfuncaotrip) = sig_arquivo.codfuncaotrip) AND (sig_tripfuncaotrip.dtfim is NULL OR sig_tripfuncaotrip.dtfim > getdate() )"
		    strQuery = strQuery & "    )))"

		    strQuery = strQuery & " AND flgobrigatorio = 'S' "
		    strQuery = strQuery & " AND (SELECT COUNT(*) FROM sig_auditoriadoc"
		    strQuery = strQuery & "    WHERE (sig_auditoriadoc.dominio = '" & strDominio & "') "
		    strQuery = strQuery & "	AND (sig_auditoriadoc.sequsuario = " & seqTripulante & ") "
		    strQuery = strQuery & "	AND (sig_auditoriadoc.nomearquivo = sig_arquivo.nomearquivo) "
		    strQuery = strQuery & "	AND (sig_auditoriadoc.nomearquivogrupo = sig_arquivogrupo.nomegrupo) "
		    strQuery = strQuery & " AND (sig_auditoriadoc.dthralteracao > sig_arquivo.dtarquivo) "
		    strQuery = strQuery & "	AND ((sig_arquivo.codcargo = sig_auditoriadoc.codcargo) OR ((sig_arquivo.codcargo IS NULL) AND (sig_auditoriadoc.codcargo IS NULL)))"
		    strQuery = strQuery & "	AND ((sig_arquivo.codfuncaotrip = sig_auditoriadoc.codfuncaotrip) OR ((sig_arquivo.codfuncaotrip IS NULL) AND (sig_auditoriadoc.codfuncaotrip IS NULL)))"
		    strQuery = strQuery & "	AND ((sig_arquivo.seqcidade = sig_auditoriadoc.seqcidade) OR ((sig_arquivo.seqcidade IS NULL) AND (sig_auditoriadoc.seqcidade IS NULL))) "
		    strQuery = strQuery & "	AND ((sig_arquivo.seqfrota = sig_auditoriadoc.seqfrota) OR ((sig_arquivo.seqfrota IS NULL) AND (sig_auditoriadoc.seqfrota IS NULL)))"
            strQuery = strQuery & "	AND (sig_arquivo.seqaeroporto IS NULL AND sig_auditoriadoc.seqaeroporto IS NULL)"
            strQuery = strQuery & "	AND (sig_arquivo.sequsuarioaerop IS NULL AND sig_auditoriadoc.sequsuarioaerop IS NULL)"
		    strQuery = strQuery & ") = 0"

'Response.Write(strQuery)
'Response.End

    		objRs.Open strQuery, objConn

    		If (Not ObjRs.Eof) Then
		    	qtdArqPend = ObjRs("QtdArquivosPendentes")
    			if (Not IsVazio(qtdArqPend)) then
	    			qtdArqPend = CInt(qtdArqPend)
		    		if (qtdArqPend > 0) Then
					    VerificarDocObrigatorioPendente = true
    				else
					    VerificarDocObrigatorioPendente = false
    				end if
			    end if
    		Else
			    VerificarDocObrigatorioPendente = false
    		End If

    		objRs.Close

            If(VerificarDocObrigatorioPendente) Then
                Exit Function
            End If
        end if

     if(strDominio = "Aeroporto") Then

            strQuery = " SELECT 1"
            strQuery = strQuery & " FROM [dbo].[sig_arquivo] AS [t0]"
            strQuery = strQuery & " INNER JOIN [dbo].[sig_arquivogrupo] AS [t1] ON [t0].[seqarquivogrupo] = [t1].[seqarquivogrupo]"
            strQuery = strQuery & " INNER JOIN [dbo].[sig_arquivogrupo] AS [t2] ON [t2].[seqarquivogrupo] = [t0].[seqarquivogrupo]"
            strQuery = strQuery & " WHERE ([t1].[nomegrupo] = 'AEROPORTOS') "
            strQuery = strQuery & " AND (([t0].[seqaeroporto] IS NULL) OR (EXISTS(SELECT NULL AS [EMPTY] FROM [dbo].[sig_usuarioaerop] AS [t3] WHERE ([t3].[sequsuarioaerop] = " & seqTripulante & ") AND (([t3].[seqaeroporto]) = [t0].[seqaeroporto]))))"
            strQuery = strQuery & " AND (([t0].[sequsuarioaerop] IS NULL) OR ([t0].[sequsuarioaerop] = " & seqTripulante & "))"
            strQuery = strQuery & " AND FlgObrigatorio = 'S'"
            strQuery = strQuery & " AND ( SELECT COUNT(*) "
            strQuery = strQuery & " 		FROM [dbo].[sig_auditoriadoc] AS [t4] "
            strQuery = strQuery & " 		WHERE ([t4].[dominio] = 'Aeroporto') "
            strQuery = strQuery & " 		AND ([t4].[sequsuario] = " & seqTripulante & ") "
            strQuery = strQuery & " 		AND ([t4].[nomearquivo] = [t0].[nomearquivo]) "
            strQuery = strQuery & " 		AND ([t4].[nomearquivogrupo] = [t2].[nomegrupo]) "
		    strQuery = strQuery & "         AND ([t4].[dthralteracao] > [t0].[dtarquivo]) "
            strQuery = strQuery & " 		AND (([t0].[seqaeroporto] = [t4].[seqaeroporto]) OR (([t0].[seqaeroporto] IS NULL) AND ([t4].[seqaeroporto] IS NULL))) "
            strQuery = strQuery & " 		AND (([t0].[sequsuarioaerop] = [t4].[sequsuarioaerop]) OR (([t0].[sequsuarioaerop] IS NULL) AND ([t4].[sequsuarioaerop] IS NULL))))  = 0"
'Response.Write(strQuery)
'Response.End

    		objRs.Open strQuery, objConn

    		If (Not ObjRs.Eof) Then
		    	VerificarDocObrigatorioPendente = true
    		Else
			    VerificarDocObrigatorioPendente = false
    		End If

    		objRs.Close

            If(VerificarDocObrigatorioPendente) Then
                Exit Function
            End If
        end if

	end function

' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
