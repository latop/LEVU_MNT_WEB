<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeropfunc.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SIGLA - APIS</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<style type="text/css">
<!--
a:link {
	color: #FFFFFF;
}
a:visited {
	color: #FFFFFF;
}
a:active {
	color: #FFFFFF;
}
.style1 {color: #0000FF}
-->
</style>
</head>

<body>
<label>

<%
Dim dataOperacao 
Dim Arquivo
Dim objFS, objText, strLine
Dim empresa
Dim Header1
Dim Header2
Dim Header3
Dim Header4
Dim ls_Group1_1
Dim ls_Group1_2
Dim ls_Group1_3
Dim ls_Group2_1
Dim ls_Group3_1
Dim ls_Group3_2
Dim ls_Group3_3
Dim ls_Group3_4
Dim ls_Group4_1
Dim ls_Group4_2
Dim ls_Group4_3
Dim ls_Group4_4
Dim ls_Group4_5
Dim ls_Group4_6
Dim ls_Group4_7
Dim ls_Group4_8
Dim ls_Group4_9
Dim ls_Group4_10
Dim ls_Group4_11
Dim ls_Group4_12
Dim ls_Group4_13
Dim Transmission_Message_Trailers1
Dim Transmission_Message_Trailers2
Dim Transmission_Message_Trailers3
Dim Transmission_Message_Trailers4
Dim ll_Pos, ll_Pos1, ll_Pos2
Dim ls_count
Dim ls_count_linhas
Dim horaPartidaprev, minPartidaprev, horaChegadaprev, minChegadaprev, dataPartidaprev
Dim ls_Nome_Responsavel, ls_Sexo, li_Tel, li_Fax

Dim objConn, objConn_Empresa, RS, RS_Empresa
Dim ls_mes_vet, ll_trip
Dim ls_sql, ls_sqlcidade
Dim ls_siglaempresa, ls_nomeempresa, ls_siglaredempresa
Dim ll_seqvoodia, ll_seqtrecho, ll_page
Dim ls_nomecidadeorig, ls_nomecidadedest, ls_nomepaisorig, ls_nomepaisdest, ls_codcidadeorig, ls_codcidadedest
Dim ldt_dtoper, ls_dtoper, ll_nrvoo, ls_prefixo
Dim ls_funcao_vet, ls_nome_vet, ls_coddac_vet, ls_codcargo_vet, ls_passaporte_vet
Dim ll_seqcidadeorig, ll_seqcidadedest, ls_codiataorig, ls_codiatadest
Dim ls_extra
Dim sql_Empresa

ls_extra = Request.QueryString("extra")
ll_seqvoodia = Request.QueryString("seqvoodia")
ll_seqtrecho = Request.QueryString("seqtrecho")

If ll_seqvoodia="" Then ll_seqvoodia="0"
If ll_seqtrecho="" Then ll_seqtrecho="0"

Set objConn = CreateObject("ADODB.CONNECTION")
objConn.Open(StringConexaoSqlServer)
objConn.Execute "SET DATEFORMAT ymd"

ls_sql = 			" SELECT sig_diariotrecho.partidaprev, sig_diariotrecho.chegadaprev chegadaprev, sig_tripcargo.codcargo, sig_tripulante.nomeguerra nomeguerra, sig_tripulante.nome, sig_tripulante.coddac, sig_jornada.textojornada, "
ls_sql = ls_sql & "        sig_jornada.textojornadaaux, sig_tripulante.senioridade, sig_tripulante.passaporte, sig_cargo.ordem, sig_programacao.funcao, "
ls_sql = ls_sql & "        sig_diariovoo.nrvoo, sig_diariovoo.dtoper, aeroporig.codiata codiataorig, aeroporig.seqaeroporto seqaeroporig, "
ls_sql = ls_sql & "        aeroporig.seqcidade seqcidadeorig, aeropdest.codiata codiatadest, aeropdest.seqaeroporto seqaeropdest, "
ls_sql = ls_sql & "        aeropdest.seqcidade seqcidadedest, sig_aeronave.prefixo, 0 as c_ordemfuncao, sig_tripulante.sexo, sig_tripulante.dtnascimento,  cidadeorig.codpais codpaisorig, cidadedest.codpais codpaisdest, sig_tripcargo.codcargo, sig_tripulante.codpais, sig_tripulante.passaporte, sig_tripulante.codpaispass, sig_pais.codpaisicao paispass, sig_tripulante.dtpassaporte, sig_tripulante.endereco, sig_tripulante.bairro, sig_cidade.nomecidade, sig_tripulante.coduf, sig_tripulante.cep, sig_tripulante.codpais, sig_pais.codpaisicao paistrip, sig_programacao.funcao, paisorig.codpaisicao codpaisicaoorig, paisdest.codpaisicao codpaisicaodest, sig_uf.descruf uftrip "
ls_sql = ls_sql & "   FROM sig_jornada, sig_programacao, sig_escdiariovoo, sig_diariovoo, sig_diariotrecho, sig_aeroporto aeroporig, "
ls_sql = ls_sql & "        sig_aeroporto aeropdest, sig_tripcargo, sig_cargo, sig_aeronave, sig_pais paisorig, sig_pais paisdest, sig_cidade cidadeorig, sig_cidade cidadedest, sig_tripulante  LEFT OUTER JOIN sig_cidade ON sig_cidade.seqcidade = sig_tripulante.seqcidade LEFT OUTER JOIN sig_pais ON sig_pais.codpais = sig_tripulante.codpais LEFT OUTER JOIN sig_uf ON sig_uf.coduf = sig_tripulante.coduf "
ls_sql = ls_sql & "  WHERE sig_tripulante.seqtripulante = sig_jornada.seqtripulante "
ls_sql = ls_sql & "    AND sig_jornada.seqjornada = sig_programacao.seqjornada "
ls_sql = ls_sql & "    AND sig_programacao.seqvoodiaesc = sig_escdiariovoo.seqvoodiaesc "
ls_sql = ls_sql & "    AND sig_programacao.seqaeroporig = sig_diariotrecho.seqaeroporig "
ls_sql = ls_sql & "    AND sig_programacao.seqaeropdest = sig_diariotrecho.seqaeropdest "
ls_sql = ls_sql & "    AND sig_programacao.seqaeroporig = aeroporig.seqaeroporto "
ls_sql = ls_sql & "    AND sig_programacao.seqaeropdest = aeropdest.seqaeroporto "
ls_sql = ls_sql & "    AND paisorig.codpais = cidadeorig.codpais "
ls_sql = ls_sql & "    AND paisdest.codpais = cidadedest.codpais "
ls_sql = ls_sql & "    AND aeroporig.seqcidade = cidadeorig.seqcidade "
ls_sql = ls_sql & "    AND aeropdest.seqcidade = cidadedest.seqcidade "
ls_sql = ls_sql & "    AND sig_tripulante.seqtripulante = sig_tripcargo.seqtripulante  "
ls_sql = ls_sql & "    AND sig_jornada.flgcorrente = 'S' "
ls_sql = ls_sql & "    AND sig_tripcargo.seqtripulante = sig_tripulante.seqtripulante "
ls_sql = ls_sql & "    AND sig_tripcargo.dtinicio <= sig_jornada.dtjornada "
ls_sql = ls_sql & "    AND (sig_tripcargo.dtfim >= sig_jornada.dtjornada OR sig_tripcargo.dtfim is null) "
ls_sql = ls_sql & "    AND sig_cargo.codcargo = sig_tripcargo.codcargo "
ls_sql = ls_sql & "    AND sig_jornada.dtjornada = sig_diariovoo.dtoper "
ls_sql = ls_sql & "    AND sig_escdiariovoo.nrvoo = sig_diariovoo.nrvoo "
ls_sql = ls_sql & "    AND sig_diariotrecho.seqvoodia = sig_diariovoo.seqvoodia "
ls_sql = ls_sql & "    AND sig_diariotrecho.prefixoaeronave = sig_aeronave.prefixored "
ls_sql = ls_sql & "    AND sig_diariovoo.seqvoodia = " & ll_seqvoodia
ls_sql = ls_sql & "    AND sig_diariotrecho.seqtrecho = " & ll_seqtrecho
ls_sql = ls_sql & "  ORDER BY sig_cargo.ordem, c_ordemfuncao, sig_tripulante.senioridade, sig_tripulante.nomeguerra "


Set RS = objConn.Execute( ls_sql )


'////////////  INICIO TESTES SOBRE O SERVIDOR E AS PASTAS

'
		Dim Diretorio, strDriveName, strFile, objDrive, strDriveType, R
'		
		Set objFS = Server.CreateObject("Scripting.FileSystemObject")
		strFile = Request.ServerVariables("SCRIPT_NAME")
		strFile = Server.MapPath(strFile)
		strDriveName = objFS.GetDriveName(strFile)
'		
		Set objDrive = objFS.GetDrive(strDriveName)
'		
'		response.write "Letra do Drive = " & objDrive.DriveLetter & "<br>"
'		response.write "path = " & objDrive.Path & "<br>"
'		response.write "File System = " & objDrive.FileSystem & "<br>"
'		response.write "root folder = " & objDrive.RootFolder & "<br>"
'		response.write " arquivo = " & strFile & "<br/>"
'		
'		Response.write mid(strFile, 1, Instr(1, strFile, "gerarAPIS.asp", 1) -1)		 & "<br/>"
'		
'		
'		if objDrive.IsReady = true then
'			response.write "<br/>drive pronto para acesso" & "<br>"
'		else
'				response.write " <br/>drive sem permissão para acesso" & "<br>"
'		end if
		set objDrive = Nothing
'
'////////////  FIM TESTES SOBRE O SERVIDOR E AS PASTAS

if rs.eof then
	Response.Write( "Dados insuficientes na base de dados para gerar arquivo. Verifique se os tripulantes estao registrados")
	response.End()
End if


dataPartidaprev = formatDateTime(RS("partidaprev"),2)
horaPartidaprev = hour(RS("partidaprev"))
minPartidaprev = minute(RS("partidaprev"))

ls_Nome_Responsavel = Replace(UCase(Request.Form("txt_nome")), ".", " ")
ls_Sexo = UCase(Request.Form("rdbSexo"))
li_Tel = Request.Form("txt_telefone")
li_Fax = Request.Form("txt_fax")

'Parâmetros da empresa

sql_Empresa = "Select nomeempresa from sig_parametros"

set RS_Empresa = objConn.Execute(sql_Empresa)

Arquivo = mid(strFile, 1, Instr(1, strFile, "gerarAPIS.asp", 1) -1) & "APIS.txt"

Set objFS = Server.CreateObject("Scripting.FileSystemObject")
Set objText = objFS.CreateTextFile(Arquivo, true, false) ' arquivo no formato ASCII

Session("gereiApis") = true

'//////////  INICIO PERSONALIZAÇÃO PARA A EMPRESA

empresa = RS_Empresa("nomeempresa")
ll_Pos = InStr(RS_Empresa("nomeempresa"), chr(32))

'//////////  FIM PERSONALIZAÇÃO PARA A EMPRESA


If Not RS.EOF Then
	ls_count_linhas = 0
	'Cabeçalho
	Header1 = "UNA:+.? ' "
	Header2 = "UNB+UNOA:4+" & Left(empresa, ll_Pos - 1)  & ":" & Ucase(Request.Form("txt_Cod_Empresa")) & "+USCSAPIS:ZZ+" & right(Year(now()),2) & right(00 & Month(now()),2) & right(00 & Day(now()),2) & ":" & right(00 &  hour(now()),2) & right(00 &  minute(now()), 2) & "+000000001++APIS'"
	Header3 = "UNG+PAXLST+" & Left(empresa, ll_Pos - 1) & ":" & UCase(Request.Form("txt_Cod_Empresa")) & "+USCSAPIS:ZZ+" &  right(Year(now()),2) & right(00 & Month(now()),2) & right(00 & Day(now()),2) & ":" & right(00 &  hour(now()),2) & right(00 &  minute(now()), 2) & "+1+UN+D:02B'"
	ls_count_linhas = ls_count_linhas +1
	Header4 = "UNH+PAX001+PAXLST:D:02B:UN:IATA+ABC01+01:F'"
	ls_count_linhas = ls_count_linhas +1
	
	'Group1
	ls_Group1_1 = "BGM+250+" & Request.Form("slt_tipovoo") & "'"
	ls_count_linhas = ls_count_linhas +1
	
	ls_Group1_2 = "NAD+MS++++" & ls_Nome_Responsavel & "," & ls_Sexo & "'"
	ls_count_linhas = ls_count_linhas +1
	
	ls_Group1_3 = "COM+" & li_Tel & ":TE+" & li_Fax & ":FX'"
	ls_count_linhas = ls_count_linhas +1
	
	'Group2
	ls_Group2_1 = "TDT+20+06"	& Rs("nrvoo") & "'"
	ls_count_linhas = ls_count_linhas +1
	
	'Group3
	ls_Group3_1 = "LOC+125+" & Rs("codiataorig") & "'"
	ls_count_linhas = ls_count_linhas +1
	ls_Group3_2 = "DTM+189:" & right(Year(RS("partidaprev")),2) & right(00 & Month(RS("partidaprev")),2) & right(00 & Day(RS("partidaprev")),2) & right(00 & Hour(Rs("partidaprev")),2) & right(00 & Minute(RS("partidaprev")),2) & ":201'"
	ls_count_linhas = ls_count_linhas +1
	ls_Group3_3 = "LOC+87+" & Rs("codiatadest") & "'"
	ls_count_linhas = ls_count_linhas +1
	ls_Group3_4 = "DTM+232:" & right(Year(RS("chegadaprev")),2) & right(00 & Month(RS("chegadaprev")),2) & right(00 & Day(RS("chegadaprev")),2) & right(00 & Hour(Rs("chegadaprev")),2) & right(00 & Minute(RS("chegadaprev")),2) & ":201'"
	ls_count_linhas = ls_count_linhas +1
	
	'enviando dados para o arquivo
	objText.WriteLine(Header1)
	objText.WriteLine(Header2)
	objText.WriteLine(Header3)
	objText.WriteLine(Header4)
	objText.WriteLine(ls_Group1_1)
	objText.WriteLine(ls_Group1_2)
	objText.WriteLine(ls_Group1_3)
	objText.WriteLine(ls_Group2_1)
	objText.WriteLine(ls_Group3_1)
	objText.WriteLine(ls_Group3_2)
	objText.WriteLine(ls_Group3_3)
	objText.WriteLine(ls_Group3_4)
	
'	Response.Write(Header1 & "<br>" & chr(13) & Header2 & "<br>" & chr(13) & Header3 & "<br>" &chr(13) & Header4 & "<br>" & chr(13) & ls_Group1_1 & "<br>" & chr(13)& ls_Group1_2 & "<br>" & chr(13) & ls_group1_3  & "<br>" & chr(13) & ls_group2_1  & "<br>" & chr(13)& ls_group3_1  & "<br>" & chr(13) & ls_group3_2  & "<br>" & chr(13) & ls_group3_3  & "<br>" & chr(13) & ls_group3_4  & "<br>" & chr(13))
	
	ls_count = 0
	Do while Not RS.EOF
		ll_Pos1 = InStr(Rs("nome"), chr(32))
		ll_Pos2 = InStrRev(Rs("nome"), chr(32))
		Dim eTripulante
		Dim tripulante
			tripulante = "nao"
			eTripulante = false
		If ll_Pos1 <> ll_Pos2 then
'			Response.Write("NAD+")
			ls_Group4_1 = "NAD+"
			If Rs("funcao") = "E" Or Rs("funcao") = "J" Or Rs("funcao") = "O" Then
'				Response.Write("DDT+")
				ls_Group4_1 = ls_Group4_1 & "DDT+"
			Else
'				Response.Write("FM+")
				eTripulante = true
				ls_Group4_1 = ls_Group4_1 & "FM+++"
			End IF	
'			Response.Write(Trim(Right(Rs("nome") , Len(Rs("nome")) - ll_Pos2 ) & ":" & Left(Rs("nome"), ll_Pos1 - 1) & ":" & Mid(Rs("nome"),ll_Pos1 + 1,(ll_Pos2 - ll_Pos1)-1 )))
			ls_Group4_1 = ls_Group4_1 & TRIM(Right(Rs("nome") , Len(Rs("nome")) - ll_Pos2 ) & ":" & Left(Rs("nome"), ll_Pos1 - 1) & ":" & Mid(Rs("nome"),ll_Pos1 + 1,(ll_Pos2 - ll_Pos1)-1 )) & "'"
		Else
'			Response.Write("NAD+")
			ls_Group4_1 = "NAD+"
			If Rs("funcao") = "E" Or Rs("funcao") = "J" Or Rs("funcao") = "O" Then
'				Response.Write("DDT+")
				ls_Group4_1 = ls_Group4_1 & "DDT+"
			Else
'				Response.Write("FM+")
				eTripulante = true
				ls_Group4_1 = ls_Group4_1 & "FM+++"
			End IF	
'			Response.Write(Trim(Right(Rs("nome") , Len(Rs("nome")) - ll_Pos2 ) & ":" & Left(Rs("nome"), ll_Pos1 - 1)))
			ls_Group4_1 = ls_Group4_1 & Right(Rs("nome") , Len(Rs("nome")) - ll_Pos2 ) & ":" & Left(Rs("nome"), ll_Pos1 - 1) & "'"
		end if	
		'Response.Write(replace(replace(UCASE("+" & Rs("endereco") & " " & Rs("bairro") & "+" & Rs("nomecidade") & "+" & Rs("coduf") & "+" & Rs("cep") & "+" & Rs("codpais") & "'<br>"), ".", " "),":", " "))
		If (eTripulante = true)  Then
			ls_Group4_1 = ls_Group4_1 & replace(replace(UCASE("+" & Rs("endereco") & " " & Rs("bairro") & "+" & Rs("nomecidade") & "+" & Rs("uftrip") & "+" & Rs("cep") & "+" & Rs("paistrip") & "'"), ".", " "), ":", " ")
			tripulante = "sim"
			
		End If	
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("ATT+2++" & Rs("sexo") & "'<br>")
		ls_Group4_2 = "ATT+2++" & Rs("sexo") & "'"
		ls_count_linhas = ls_count_linhas +1
		
		If Not ISNULL(RS("dtnascimento")) Then
'			Response.Write("DTM+329:" & right(Year(RS("dtnascimento")),2) & right(00 & Month(RS("dtnascimento")),2) & right(00 & Day(RS("dtnascimento")),2)  & "'<BR>")
			ls_Group4_3 = "DTM+329:" & right(Year(RS("dtnascimento")),2) & right(00 & Month(RS("dtnascimento")),2) & right(00 & Day(RS("dtnascimento")),2) & "'"
			ls_count_linhas = ls_count_linhas +1
		Else
'			Response.Write("DTM+329:' <BR>")
			ls_Group4_3 = "DTM+329:'"
			ls_count_linhas = ls_count_linhas +1
		End If
		
'		Response.Write("LOC+22+" & Rs("codiatadest") & "'<BR>")
		ls_Group4_4 = 	"LOC+22+" & Rs("codiatadest")	 & "'"
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("LOC+174+" & Rs("codpaisdest") & "'<BR>")
		ls_Group4_5 = "LOC+174+" & Rs("codpaisicaodest") & "'"
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("LOC+178+" & Rs("codiataorig") & "'<BR>")
		ls_Group4_6 = "LOC+178+" & Rs("codiataorig") & "'"
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("LOC+179+" & Rs("codiatadest") & "'<br>")
		ls_Group4_7 = 	"LOC+179+" & Rs("codiatadest") & "'"
		ls_count_linhas = ls_count_linhas +1
		
		'If (tripulante = "sim" ) then
'			ls_Group4_8 = "Sim"
'		Else
'			ls_Group4_8 = "Não"	
'		End IF	
		
		If ISNULL(Rs("nomecidade")) then
			ls_Group4_8 = 	"LOC+180+" &  Rs("codpaisicaodest") & "+:::" & Rs("uftrip") & "'"
		Else 
			If IsNULL(Rs("uftrip"))	Then
				ls_Group4_8 = 	"LOC+180+" &  Rs("codpaisicaodest") & "+:::" & Rs("nomecidade") & "'"
			Else
				ls_Group4_8 = 	"LOC+180+" &  Rs("codpaisicaodest") & "+:::" & Rs("nomecidade") & "+:::" & Rs("uftrip") & "'"
			END iF
		END IF				
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("EMP+1+")
'		IF RS("codcargo") = "CMTE" Then  
'		 	Response.Write("CR1")
'		Else  
'			Response.Write("CR2")
'		End if 
'		Response.Write(":110+111' <bR>")
		ls_Group4_9 = "EMP+1+"
		IF RS("codcargo") = "CMTE" Then  
		 	ls_Group4_9 = ls_Group4_9 & "CR1"
		Else  
			ls_Group4_9 = ls_Group4_9 & "CR2"
		End if 
		ls_Group4_9 = ls_Group4_9 & ":110:111'"
		ls_count_linhas = ls_count_linhas +1
		
'		Response.Write("NAT+2+" & Rs("codpais") & "'<bR>")
		ls_Group4_10	= "NAT+2+" & Rs("paistrip") & "'"
		ls_count_linhas = ls_count_linhas +1	
		
'		Response.Write("DOC+P:110:111+" & Rs("passaporte") & "'<bR>")
		ls_Group4_11 = "DOC+P:110:111+" & Rs("passaporte") & "'"
		ls_count_linhas = ls_count_linhas +1	
		
'		Response.Write("DTM+36:" & Rs("dtpassaporte") & "'<bR>")
		ls_Group4_12 = "DTM+36:" & Rs("dtpassaporte") & "'"
		ls_count_linhas = ls_count_linhas +1	
		
'		Response.Write("LOC+91+" & Rs("codpaispass") & "'")
		ls_Group4_13 = "LOC+91+" & Rs("paispass") & "'"
		ls_count_linhas = ls_count_linhas +1	
		
'		Response.Write("<br>")
		objText.WriteLine(ls_Group4_1)
		objText.WriteLine(ls_Group4_2)
		objText.WriteLine(ls_Group4_3)
		objText.WriteLine(ls_Group4_4)
		objText.WriteLine(ls_Group4_5)
		objText.WriteLine(ls_Group4_6)
		objText.WriteLine(ls_Group4_7)
		If (tripulante = "sim" ) then
			objText.WriteLine(ls_Group4_8)
		end if	
		objText.WriteLine(ls_Group4_9)
		objText.WriteLine(ls_Group4_10)
		objText.WriteLine(ls_Group4_11)
		objText.WriteLine(ls_Group4_12)
		objText.WriteLine(ls_Group4_13)
		ls_count = CInt(ls_count + 1)
			
		Rs.movenext
	Loop	
	Transmission_Message_Trailers1 = "CNT+41:" & ls_count & "'"
	ls_count_linhas = ls_count_linhas +1
	Transmission_Message_Trailers2 = "UNT+" & ls_count_linhas & "+PAX001'"
	Transmission_Message_Trailers3 = "UNE+1+1'"
	Transmission_Message_Trailers4 = "UNZ+1+000000001'"
	
	objText.WriteLine(Trim(Transmission_Message_Trailers1))
	objText.WriteLine(Trim(Transmission_Message_Trailers2))
	objText.WriteLine(Trim(Transmission_Message_Trailers3))
	objText.WriteLine(Trim(Transmission_Message_Trailers4))
	
'	Response.Write(Transmission_Message_Trailers1 & "<br>" & Transmission_Message_Trailers2 & "<br>" & Transmission_Message_Trailers3 & "<br>" & Transmission_Message_Trailers4)
	
End if
objText.close
objConn.close

%>
</label>
<br/>

<%
Dim dataPrevista, voo

dataPrevista = request.QueryString("dataPrevista")
voo = request.QueryString("voo")

'response.Redirect("home.asp")
'response.Redirect "download.asp?dataPrevista=" & dataPrevista & "&voo=" & voo
%>

<h3><center> 
  <span class="CORPO14">Baixar Apis.txt</span>
  
  <a href= "download.asp?dataPrevista=<% response.write(dataPrevista & "&voo=" & voo) %>" class="bigTitle" >  </a><a href= "download.asp?dataPrevista=<% response.write(dataPrevista & "&voo=" & voo) %>" ><br/>
<img src="imagens/txt.gif" /></a></center></h3>

<% 
Dim link

link = "download.asp?dataPrevista=" & dataPrevista & "&voo=" & voo

response.Redirect(link)  

%>

</body>
</html>
