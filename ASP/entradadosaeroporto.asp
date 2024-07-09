<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->

<%
	Dim intEmpresa
	intEmpresa = Session("Empresa")

	Dim objConn
	Dim objRs, objRs2, strSqlSelect, strSqlFrom, strSqlWhere, strQuery
	Dim intSeqUsuarioAerop, intSeqVooDia, intSeqTrecho
	Dim intSeqAeroporto, intSeqAeropOrig, intSeqAeropDest
	Dim strFlgCombinada
	intSeqUsuarioAerop = Session("member")
	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")
	Session("seqvoodia") = intSeqVooDia
	Session("seqtrecho") = intSeqTrecho
	intSeqAeroporto = CInt(Session("seqaeroporto"))

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)

	strSqlSelect =                " SELECT sig_diariotrecho.seqaeroporig, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqaeropdest "
	strSqlFrom =                  " FROM sig_diariovoo sig_diariovoo, "
	strSqlFrom = strSqlFrom &     "      sig_diariotrecho sig_diariotrecho, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeroporig, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeropdest "
	strSqlWhere =                 " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqvoodia = " & intSeqVooDia & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqtrecho = " & intSeqTrecho & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto "

	strQuery = strSqlSelect & strSqlFrom & strSqlWhere

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	if (Not ObjRs.Eof) then
		intSeqAeropOrig = CInt(objRs("seqaeroporig"))
		intSeqAeropDest = CInt(objRs("seqaeropdest"))

		if (intSeqAeroporto = intSeqAeropOrig) then
			strQuery =                " SELECT sig_usuarioaerop.flgcombinada "
			strQuery = strQuery & " FROM sig_usuarioaerop "
			strQuery = strQuery & " WHERE sig_usuarioaerop.sequsuarioaerop = " & intSeqUsuarioAerop

			Set objRs2 = Server.CreateObject("ADODB.Recordset")
			objRs2.Open strQuery, objConn

			if (Not ObjRs2.Eof) then
				strFlgCombinada = CStr(objRs2("flgcombinada"))
				if (strFlgCombinada = "N" OR intEmpresa = 1) then
					Response.Redirect("entradadosaeroportodecolagemred.asp")
				else
					Response.Redirect("../ASP2ASPX/ASP2ASPX.asp?paginaDestino=EntraDadosAeropDecol.aspx&dominioDestino=Aeroporto")
'					Response.Redirect("entradadosaeroportodecolagem.asp")
				end if
			End If

'			if (intEmpresa = 1) then
'				Response.Redirect("entradadosaeroportodecolagemred.asp")
'			else
'				Response.Redirect("entradadosaeroportodecolagem.asp")
'			end if
		elseif (intSeqAeroporto = intSeqAeropDest) then
			if (intEmpresa = 1) then
				Response.Redirect("entradadosaeroportopouso.asp")
			else
				Response.Redirect("../ASP2ASPX/ASP2ASPX.asp?paginaDestino=EntraDadosAeropPouso.aspx&dominioDestino=Aeroporto")
			end if
		else
			Response.Redirect("Default.asp")
		end if
	else
		Response.Redirect("Default.asp")
	end if

	objRs.Close
	objConn.close
	Set objRs = Nothing
	Set objConn = Nothing
%>
