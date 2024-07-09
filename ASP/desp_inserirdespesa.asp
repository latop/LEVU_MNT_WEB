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
<!--#include file="desp_insere_seqdespesa.asp"-->
<%
	Dim Conn, Rs
	Dim ls_tipodespesa, dt_datadespesa, ls_aeronave, dt_datavoo, ls_voo, ll_valor, ls_notaFiscal, ls_motivo, ls_tipo
	Dim sSqlAeronave, sSqlAeroporto, sSqlVoo, sSqlInsert, sSqlUpdate
	Dim intSeqUsuarioAerop, intAerop
	Dim ll_sequencial, ls_situacao, ll_seqvoodia, ll_seqtrecho 
	Dim ls_sequsuario, ls_seqdespesa
	Dim dt_data1, dt_data2
	
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"

	ls_tipodespesa = Request.Form("tipodespesa")
	dt_datadespesa = Year(NOW()) & "-" & Month(NOW()) & "-" & Day(NOW()) & " " & Right("00" & Hour(Now()),2) & ":" & Right("00" & Minute(Now()),2)
	ls_aeronave = Request.Form("aeronave")
	dt_datavoo = Year(Request.Form("datavoo")) & "/" & Month(Request.Form("datavoo")) & "/" & Day(Request.Form("datavoo"))
	ls_voo = Request.Form("voo")
	ll_valor = Request.Form("valor")
	ls_notaFiscal = Request.Form("notaFiscal")
	ls_motivo = Request.Form("motivo")
	ls_tipo = Request.Form("tipo")
	ls_seqdespesa = Request.Form("seqdespesa")
	
	'******************************'
	' Verifica se aeronave existe  '
	'******************************'
	sSqlAeronave =          	  " SELECT prefixo "
	sSqlAeronave = sSqlAeronave & " FROM sig_aeronave "
	sSqlAeronave = sSqlAeronave & " WHERE prefixored = '" & ls_aeronave & "' "
	
	Set RS = Conn.Execute( sSqlAeronave )
	
	IF RS.EOF THEN
	   response.write ("<script language=javascript> alert(' Aeronave nao encontrada! '); history.go(-1);</script>")
	   response.End()
	END IF
	'********************'
	' Fim da verificação '
	'********************'
	
	intSeqUsuarioAerop = 0

	Dim intDominio
	intDominio = Session("dominio")
	if (intDominio = 3) then 'Aeroporto
		intSeqUsuarioAerop = Session("member")
	end if

	'************************************'
	' Obtendo seqvoodia e seqtrecho		 '
	'************************************'
	
	sSqlVoo =        " SELECT sig_diariovoo.seqvoodia, sig_diariotrecho.seqtrecho "
	sSqlVoo = sSqlVoo & " FROM sig_diariovoo, sig_diariotrecho "
	sSqlVoo = sSqlVoo & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	sSqlVoo = sSqlVoo & " AND sig_diariovoo.nrvoo = '" & ls_voo & "' "
	sSqlVoo = sSqlVoo & " AND sig_diariovoo.dtoper = '" & dt_datavoo & "' "
'	sSqlVoo = sSqlVoo & " AND sig_diariotrecho.flgcancelado ='N' "
	sSqlVoo = sSqlVoo & " AND sig_diariotrecho.prefixoaeronave = '" & UCASE(ls_aeronave) & "' "

	set RS = Conn.Execute(sSqlVoo)

	IF RS.EOF THEN
	   response.write ("<script language=javascript> alert(' Voo informado não encontrado! '); history.go(-1);</script>")
	   response.End()
	END IF
	
	ll_seqvoodia = RS( "seqvoodia" )
	ll_seqtrecho = RS( "seqtrecho" )
	
	'*****************'
	' Fim da obtenção '
	'*****************'
	
	If ls_tipo = "insert" then
		Dim ConnInsert, RsInsert
		
		Set ConnInsert = CreateObject("ADODB.CONNECTION")
		ConnInsert.Open (StringConexaoSqlServer)
		ConnInsert.Execute "SET DATEFORMAT ymd"
		
		dt_data1 = request.querystring("data1")
		dt_data2 = request.querystring("data2")
		
		ll_sequencial = f_sequencial("SIG_LIBERACAODESPESA", "", StringConexaoSqlServer )
		ls_situacao = "P"
		
		ll_valor = Replace(ll_valor, ",",".")
		If ll_valor = "" or IsEmpty(ll_valor) or IsNull(ll_valor) Then
			ll_valor = "NULL"
		End If	
		
		sSqlInsert = 			  "Insert into SIG_LIBERACAODESPESA(seqdespesa, sequsuarioaerop, seqvoodia, seqtrecho, tipodespesa, "
		sSqlInsert = sSqlInsert & " motivo, valor, notafiscal, situacao, dthrregistro) "
		sSqlInsert = sSqlInsert & " Values(" & ll_sequencial & ", " & intSeqUsuarioAerop & ", " & ll_seqvoodia & ", " & ll_seqtrecho & ", "
		sSqlInsert = sSqlInsert & " '" & ls_tipodespesa & "', '" & ls_motivo & "', " & ll_valor & ", '" & ls_notaFiscal & "', '" & ls_situacao & "', '" & dt_datadespesa & "' )"

		set RsInsert = ConnInsert.Execute(sSqlInsert)
		
		ConnInsert.close
		
		
		If IsDate(dt_data1) then 
			Response.Redirect("desp_consultadespesas.asp?voltar=voltar&txt_Data1=" & dt_data1 & "&txt_Data2=" & dt_data2 )
		else
			Response.Redirect("desp_consultadespesas.asp")
		end If
		
	else
		
		Dim ConnUpdate, RsUpdate
		
		Set ConnUpdate = CreateObject("ADODB.CONNECTION")
		ConnUpdate.Open (StringConexaoSqlServer)
		ConnUpdate.Execute "SET DATEFORMAT ymd"
		
		dt_data1 = request.querystring("data1")
		dt_data2 = request.querystring("data2")
		ls_situacao = Request.form("situacao")
		ls_sequsuario = Request.form("sequsuario")
		ls_seqdespesa = Request.Form("seqdespesa")

		ll_valor = Replace(ll_valor, ",",".")
		If ll_valor = "" or IsEmpty(ll_valor) or IsNull(ll_valor) Then
			ll_valor = "NULL"
		End If	
		
		sSqlUpdate = 			  "Update SIG_LIBERACAODESPESA SET seqvoodia = " & ll_seqvoodia & ", seqtrecho = " & ll_seqtrecho & ", "
		sSqlUpdate = sSqlUpdate & " tipodespesa ='" & ls_tipodespesa & "', valor=  " & ll_valor & ", notafiscal='" & ls_notaFiscal & "', motivo='" & ls_motivo & "', "
		sSqlUpdate = sSqlUpdate & " dthrregistro='" & dt_datadespesa & "' "
		sSqlUpdate = sSqlUpdate & "Where seqdespesa = " & ls_seqdespesa & " "
		
		set RsUpdate = ConnUpdate.Execute(sSqlUpdate)
		
		ConnUpdate.close
		
		Response.Redirect("desp_consultadespesas.asp?voltar=voltar&txt_Data1=" & dt_data1 & "&txt_Data2=" & dt_data2 ) 
			
	end If

%>
</body>
</html>
