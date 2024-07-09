<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="includes\gerarSequencial.asp"-->
<%
	Dim seqteclog	
	Dim regData, aeronave, ls_voo, origem, destino, reportado, codatasubata, codAta, codsubata, baseStation, codAnac, descricao, mntData 
	Dim pnRemovido, snRemovido, posAtualRemovido, pnInstalado, snInstalado, posAtualInstalado, e1, e2, e3, e4, ha1g
	Dim hb2b, h3sy, li_origem, li_destino, descrMnt, apu, descrDiscrep, hiddenAcao, hiddenLock, diarioBordo, ll_item	
	Dim seqvoodia, trecho
	Dim ldt_data1, ldt_data2
	Dim objConn
	
	'**********************************************************************************************
	'*   SE O É UM NOVO REGISTRO SIMPLES: PEGO-O POR REQUEST FORM.
	'*   SE O NOVO REGISTRO VEM DO LINK DO DIÁRIO DE BORDO: COMPLETO-O COM AS QUERYSTRINGS
	'**********************************************************************************************
	
	
	diarioBordo = Request.QueryString("diariobordo")
	ldt_data1 = Request.QueryString("data1")
	ldt_data2 = Request.QueryString("data2")

	if isVazio(diariobordo) then
		regData = Request.Form("txtData")
		aeronave = Request.Form("comboAeronave")
		ls_voo = Request.Form("txtVoo")
		origem = Request.Form("comboOrigem")
		destino = Request.Form("comboDestino")
		reportado = Request.Form("txtReportado")
		codatasubata = Split( Request.Form("comboAta100"), "-" )
		If UBound(codatasubata) > 0 Then
			codAta = Right( "00" & codatasubata(0), 2 )
			codsubata = Right( "00" & codatasubata(1), 2 )
		End if
		baseStation = Request.Form("txtBaseStation")
		codAnac = Request.Form("txtCodAnac")
		descrMnt = Request.Form("txtDescrMnt")
		mntData = Request.Form("txtDtAcaoMnt")
		pnRemovido = Request.Form("txtPnRemovido")
		snRemovido = Request.Form("txtSnRemovido")
		posAtualRemovido = Request.Form("txtPosAtualremov")
		pnInstalado = Request.Form("txtPnInstalado")
		snInstalado = Request.Form("txtSnInstalado")
		posAtualInstalado = Request.Form("txtPosAtualInst")
		e1 = Request.Form("txtE1")
		e2 = Request.Form("txtE2")
		e3 = Request.Form("txtE3")
		e4 = Request.Form("txtE4")
		ha1g = Request.Form("txtHA1G")
		hb2b = Request.Form("txtHB2B")
		h3sy = Request.Form("txtH3SY")
		apu = Request.Form("txtAPU")
		descrDiscrep = Request.Form("txtDescrDiscrep")
		hiddenAcao = Request.Form("hiddenAcao")	
		ll_item = Request.Form("txtItem")
		diarioBordo = Request.Form("txtDiarioBordo")
	else
		regData = right("0" & Request.QueryString("strDia"), 2) & "/" & right( "0" & Request.QueryString("strMes"), 2) & "/" & request.QueryString("strAno")
		reportado = Request.QueryString("CODCARGO") & " " & Request.QueryString("NomeGuerra")
		aeronave = request.QueryString("aeronave")
		if isVazio(aeronave) then
			aeronave = Request.Form("comboAeronave")
		end if
		ls_voo = request.QueryString("voo")
	end if 
	
	hiddenLock = Request.QueryString("lk")
	seqteclog =  Request.QueryString("seqteclog")
	origem = request.QueryString("seqaeroporig")
	destino = request.QueryString("seqaeropdest")

	'********************************************************************************
	'*
	'*    INÍCIO DA EXECUÇÃO DA PÁGINA ( C.R.U.D )
	'*
	'********************************************************************************
	if (isVazio(seqteclog)) and (isVazio(hiddenAcao)) then
		hiddenAcao = "i"				
	else		
		if (isVazio(hiddenAcao) = false) then		
			if (hiddenAcao = "e") then
				call excluirRegistro
			else
				if (hiddenAcao = "a") then
					call alterarRegistro
				else
					if (hiddenAcao = "i") then
						call incluirRegistro
					end if
				end if
				
			end if
		else 
			if (isVazio(seqteclog) = false) and (isVazio(hiddenAcao) = true) then
				call abrirRegistro(seqteclog)	
				hiddenAcao = "a"
			end if
		end if		
	end if


function obterSeqTrecho(seqvoodia, ls_aeronave, seq_origem, seq_destino)
	Dim sSqlVoo, RS, objConn
	
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)

	'************************************'
	' Obtendo seqvoodia e seqtrecho		 '
	'************************************'
	sSqlVoo =        " SELECT sig_diariotrecho.seqtrecho "
	sSqlVoo = sSqlVoo & " FROM sig_diariotrecho "
	sSqlVoo = sSqlVoo & " WHERE sig_diariotrecho.seqvoodia = " & seqvoodia 
	sSqlVoo = sSqlVoo & " AND sig_diariotrecho.flgcancelado ='N' "
	sSqlVoo = sSqlVoo & " AND sig_diariotrecho.seqaeroporig = " & UCASE(seq_origem)
	sSqlVoo = sSqlVoo & " AND sig_diariotrecho.seqaeropdest = " & UCASE(seq_destino)
	
	set RS = objConn.Execute(sSqlVoo)

	if RS.EOF then	   
		obterSeqTrecho = "-1"
	else
 		obterSeqTrecho = RS("seqtrecho")
	end if

	objConn.close
	set objConn = nothing
end function


function buscarSeqVooDia(adt_data, as_voo)
	Dim SQL, objConn, rsResult
	
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	
	SQL = "SELECT SEQVOODIA FROM SIG_DIARIOVOO WHERE NRVOO = " & as_voo & " AND DTOPER = '" & formatarData(adt_data, "amd") & "'"
	
	Set rsResult = Server.CreateObject("ADODB.Recordset")

	objConn.Execute "SET DATEFORMAT ymd"
	rsResult.Open SQL, objConn	
	
	if not rsResult.eof then
		buscarSeqVooDia = rsResult("seqvoodia")
	else
		buscarSeqVooDia = "-1"
	end if

	objConn.close
	set objConn = nothing
end function

function obterAeronave(seqvoo, seqtrecho)
	Dim SQL, objConn, rsResult
	
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	
	SQL = "SELECT PREFIXOAERONAVE FROM SIG_DIARIOTRECHO WHERE SEQVOODIA =" & seqvoo & " AND SEQTRECHO =" & seqtrecho
		
	Set rsResult = Server.CreateObject("ADODB.Recordset")

	objConn.Execute "SET DATEFORMAT ymd"
	rsResult.Open SQL, objConn	

	if not rsResult.eof then
		obterAeronave = rsResult("prefixoaeronave")
	else
		obterAeronave= "-1"
	end if

	objConn.close
	set objConn = nothing
end function


function isVazio(var)
	if (isempty(var) or isnull(var) or (Trim(var) = "") or (var = "") or (var= " " ) or (var= "  " )) then
		isVazio = true
	else
		isVazio = false
	end if
end function


function formatarData(data, tipo)
	Dim dataOriginal, novaData

	if (isVazio(data)) then
		exit function
	end if

	dataOriginal = data
	select case tipo
		Case "ddmmaa","dma"
			novaData = day(data) & "." & month(data) & "." & year(data)
		Case "aammdd", "amd"
			novaData = year(data) & "." & month(data) & "." & day(data)
	end select
	formatarData = novaData
end function 

Sub abrirRegistro(id_registro)   
	Dim ConnReg, rsReg, i, SQLReg
	
	SQLReg = "SELECT MANUT.*, TRECHO.DIARIOBORDO as trecho_diariobordo FROM SIG_TECHNICALLOGBOOK MANUT "
	SQLReg = SQLReg + "LEFT OUTER JOIN SIG_DIARIOTRECHODB TRECHO ON "
	SQLReg = SQLReg + "MANUT.SEQVOODIA = TRECHO.SEQVOODIA AND "
	SQLReg = SQLReg + "MANUT.SEQTRECHO = TRECHO.SEQTRECHO "
	SQLReg = SQLReg + "WHERE SEQTECLOG = " & id_registro 

	Set ConnReg = CreateObject("ADODB.CONNECTION")
	ConnReg.Open (StringConexaoSqlServer)
	ConnReg.Execute SQLReg
	Set rsReg = Server.CreateObject("ADODB.Recordset")
	rsReg.Open SQLReg, ConnReg
	
	regData = rsReg("dtregistro")
	aeronave = rsReg("prefixo")		
	trecho = rsReg("seqtrecho")
	reportado = rsReg("nomereport")
	codAta = Right( "00" & rsReg("codata"), 2 )
	codsubata = Right( "00" & rsReg("codsubata"), 2 )
	baseStation = rsReg("basestation")
	codAnac = rsReg("codanac")
	descrMnt = rsReg("descrmnt")
	mntData = rsReg("dtacaomnt")
	pnRemovido = rsReg("pnremovido")
	snRemovido = rsReg("snremovido")
	posAtualRemovido = rsReg("posatualremov")
	pnInstalado = rsReg("pninstalado")
	snInstalado = rsReg("sninstalado")
	posAtualInstalado = rsReg("posatualinst")
	e1 = rsReg("oleoe1")
	e2 = rsReg("oleoe2")
	e3 = rsReg("oleoe3")
	e4 = rsReg("oleoe4")
	ha1g = rsReg("oleoha1g")
	hb2b = rsReg("oleohb2b")
	h3sy = rsReg("oleoh3sy")
	apu = rsReg("oleoapu")
	descrDiscrep = rsReg("descrdiscrep")
	seqvoodia = rsReg("seqvoodia")
	diarioBordo = rsReg("diariobordo")
	ll_item = rsReg("item")
	origem = rsReg("seqaeroporig")
	destino = rsReg("seqaeropdest")
	
	regData = RIGHT("0" & DAY(regData),2) & "/" & RIGHT("0" & MONTH(regData),2) & "/" & YEAR(regData)
	if not isnull(mntData) then
		mntData = RIGHT("0" & DAY(mntData),2) & "/" & RIGHT("0" & MONTH(mntData),2) & "/" & YEAR(mntData)		
	end if
	
	rsReg.close
	ConnReg.close		               
	ConnReg.open
	
	'*******************************************************************************
	'*
	'*    CASO VOO E TRECHO ESTEJAM CADASTRADOS, CAPTURO-OS PARA MOSTRAR NA TELA
	'*
	'*******************************************************************************

	if (not isVazio(trecho)) then
		SQLReg =          "SELECT D.NRVOO, AORIG.SEQAEROPORTO AS AEROPORIGEM, ADEST.SEQAEROPORTO AS AEROPDESTINO "
		SQLReg = SQLReg & "FROM SIG_DIARIOTRECHO T ,"		
		SQLReg = SQLReg & "SIG_AEROPORTO AORIG, " 
		SQLReg = SQLReg & "SIG_AEROPORTO ADEST, "
		SQLReg = SQLReg & "SIG_DIARIOVOO D "
		SQLReg = SQLReg & "WHERE T.SEQVOODIA = D.SEQVOODIA "
		SQLReg = SQLReg & "AND D.SEQVOODIA = " &  seqvoodia
		SQLReg = SQLReg & "AND AORIG.SEQAEROPORTO = T.SEQAEROPORIG "
		SQLReg = SQLReg & "AND ADEST.SEQAEROPORTO = T.SEQAEROPDEST "
		SQLReg = SQLReg & "AND T.SEQTRECHO =" & trecho

		ConnReg.Execute SQLReg
		rsReg.Open SQLReg, ConnReg
		
		ls_voo = rsReg("nrvoo")	
		origem = rsReg("aeroporigem") 
		destino = rsReg("aeropdestino")	
	end if
	
	ConnReg.close
	set ConnReg = nothing
	set rsReg = nothing
end Sub


Sub preencherComboAta(selecionado)
	Dim rsResult, SQL, objConn, espaco
	Dim selecionou
	Dim itemValor
	
	selecionou = false
	SQL = "SELECT * FROM sig_ata100 ORDER BY codata,codsubata ASC"
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.open(StringConexaoSqlServer)																					
	Set rsResult = Server.CreateObject("ADODB.Recordset")
	rsResult.Open SQL, objConn	
	
	if (not isnull(selecionado))	then
		selecionado = ucase(selecionado)
		selecionou = true
	end if
	
	while not rsResult.eof 
		itemValor = Right( "00" & rsResult("codata"), 2 ) & "-" & Right( "00"&rsResult("codsubata"),2)
		
		if (selecionou=false) then				 'se não selecionei nada, simplesmente exibo todos sem marcar nenhum
			response.write("<option value='" & itemValor & "'>" & itemValor & espaco & "&nbsp;&nbsp;" & rsResult("descrata") & "</option>" )
		else				'se tem algum selecionado como parametro
			if itemValor = selecionado then
				response.write("<option value='" & itemValor & "' selected='selected'>" & itemValor & espaco & "&nbsp;&nbsp;" & rsResult("descrata") & "</option>" )
			else
				response.write("<option value='" & itemValor & "'>" & itemValor & espaco & "&nbsp;&nbsp;" & rsResult("descrata") & "</option>" )
			end if
		end if		
		
		rsResult.movenext
	wend
	
	objConn.close
	set rsResult = nothing
	set objConn = nothing
end Sub

Sub incluirRegistro()

	CamposPreenchidosCorretamente()

	If ( ( isVazio(diarioBordo) = false ) And ( isVazio(ll_item) = false ) ) Then
		Dim qtdRegistros
		qtdRegistros = CInt(verificarTLBItemExistente(diarioBordo, ll_item, -1))
		if (qtdRegistros > 0) then
			Response.Write("<center><h3><br/><br/><br/>J&aacute; existe um registro com o mesmo TLB e item. <br/>")
			Response.Write("Clique em voltar e altere o campo TLB e/ou o campo item!</h3></center>")
			Response.End
		end if
	End if

	If ls_voo > "" Then
		'*********************************
		'* Recupera as Informações do Voo
		'*********************************
		seqvoodia = buscarSeqVooDia(regData, ls_voo)			
		if (seqvoodia = "-1" ) then
			response.write("<center><h3><br/><br/><br/>Registro de Voo n&atilde;o encontrado. <br/>")
			Response.Write("Clique em voltar e preencha o campo corretamente!</h3></center>")
			response.end
		end if
		
		trecho = obterSeqTrecho(seqvoodia, aeronave, request.form("comboOrigem"), request.form("comboDestino"))
		if (trecho = "-1") then		
			response.write("<center><h3><br/><br/><br/>Registro de Etapa n&atilde;o encontrado para o voo selecionado!<br/>")
			Response.Write("Clique em voltar e preencha os campos corretamente!</h3></center>")
			response.end
		end if
		
		aeronave = obterAeronave(seqvoodia, trecho)
		if ((aeronave = "-1" ) or (aeronave <> request.form("comboAeronave"))) then
			response.write("<center><h3><br/><br/><br/>A Aeronave selecionada n&atilde;o corresponde ao voo e dia informado. <br/>")
			Response.Write("Clique em voltar e preencha o campo corretamente!</h3></center>")
			response.end
		end if
	End if

	seqteclog = gerarSequencial("SIG_TECHNICALLOGBOOK", StringConexaoSqlServer )

	Dim SQL

	SQL =	    "INSERT INTO sig_technicallogbook"
	SQL = SQL & "	   (seqteclog"
	SQL = SQL & "	   ,seqvoodia"
	SQL = SQL & "	   ,seqtrecho"
	SQL = SQL & "	   ,descrdiscrep"
	SQL = SQL & "	   ,codata"
	SQL = SQL & "     ,codsubata"
	SQL = SQL & "	   ,basestation"
	SQL = SQL & "	   ,descrmnt"
	SQL = SQL & "	   ,codanac"
	SQL = SQL & "	   ,oleoe1"
	SQL = SQL & "	   ,oleoe2"
	SQL = SQL & "	   ,oleoe3"
	SQL = SQL & "	   ,oleoe4"
	SQL = SQL & "	   ,oleoapu"
	SQL = SQL & "	   ,oleoha1g"
	SQL = SQL & "	   ,oleohb2b"
	SQL = SQL & "	   ,oleoh3sy"
	SQL = SQL & "	   ,pnremovido"
	SQL = SQL & "	   ,snremovido"
	SQL = SQL & "	   ,pninstalado"
	SQL = SQL & "	   ,sninstalado"
	SQL = SQL & "     ,dtacaomnt"			
	SQL = SQL & "     ,posatualremov"
	SQL = SQL & "	   ,posatualinst"
	SQL = SQL & "	   ,nomereport"					   
	SQL = SQL & "	   ,dtregistro"					   					   
	SQL = SQL & "	   ,prefixo"
	SQL = SQL & "	   ,item"
	SQL = SQL & "     ,diariobordo"
	SQL = SQL & "     ,seqaeroporig"
	SQL = SQL & "     ,seqaeropdest) "
	SQL = SQL & "VALUES("																				
	SQL = SQL & seqteclog&", " 
	If seqvoodia > "" And trecho > "" Then
		SQL = SQL & seqvoodia & ","
		SQL = SQL & trecho & ","
	Else
		SQL = SQL & "NULL,"
		SQL = SQL & "NULL,"
	End if
	SQL = SQL & "'" & descrDiscrep & "',"
	If isVazio(codata) = false Then
		SQL = SQL  &codAta & ","
		SQL = SQL  &codsubata & ","
	Else
		SQL = SQL  & "NULL,"
		SQL = SQL  & "NULL,"
	End if
	SQL = SQL & "'" & baseStation & "',"
	SQL = SQL & "'" & descrMnt & "',"
	SQL = SQL & "'" & codAnac & "',"
	SQL = SQL & "'" & e1 & "',"
	SQL = SQL & "'" & e2 & "',"
	SQL = SQL & "'" & e3 & "',"
	SQL = SQL & "'" & e4 & "',"
	SQL = SQL & "'" & apu & "',"  
	SQL = SQL & "'" & Request.Form("txtha1g") & "',"
	SQL = SQL & "'" & Request.Form("txthb2b") & "',"
	SQL = SQL & "'" & Request.Form("txtH3SY") & "',"
	SQL = SQL & "'" & pnRemovido & "',"
	SQL = SQL & "'" & snRemovido & "',"
	SQL = SQL & "'" & pnInstalado & "',"
	SQL = SQL & "'" & snInstalado & "',"
	if ( isVazio(mntData) = false ) then
		SQL = SQL & "'" & formatarData(mntData, "amd") & "',"
	Else
		SQL = SQL & "NULL,"
	end if
	SQL = SQL & "'" & posAtualRemovido & "',"
	SQL = SQL & "'" & posAtualInstalado & "',"
	SQL = SQL & "'" & reportado & "',"		
	SQL = SQL & "'" & formatarData(regData, "amd") & "',"					   	   
	SQL = SQL & "'" & aeronave  &"',"
	If ( isVazio(diariobordo) = false ) Then
		SQL = SQL  &ll_item & ","
	Else
		SQL = SQL  & "NULL,"
	End if
	If ( isVazio(diariobordo) = false ) then
		SQL = SQL & "'" & UCase(diarioBordo) & "',"
	Else
		SQL = SQL & "NULL,"
	End if
	If request.Form("comboOrigem") <> "0" Then
		SQL = SQL & request.Form("comboOrigem") & ","
	Else
		SQL = SQL & "NULL,"
	End if
	If request.Form("comboDestino") <> "0" Then
		SQL = SQL & request.Form("comboDestino") 
	Else
		SQL = SQL & "NULL"
	End if
	SQL = SQL  &")"
	
	Dim Conn, RS
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"
	Conn.Execute sql
	conn.close
	set conn = nothing
	response.redirect("mnt1_registro_mnt.asp")
	'?data1=" & ldt_data1 & "&data2=" & ldt_data2 )	
end Sub


Sub excluirRegistro()
	Dim SQL, Conn
	
	if ( hiddenAcao = "e" ) then
		SQL = " DELETE FROM SIG_TECHNICALLOGBOOK WHERE SEQTECLOG = " & seqteclog

		Set Conn = CreateObject("ADODB.CONNECTION")
		Conn.Open (StringConexaoSqlServer)
		Conn.Execute SQL
		conn.close
		set conn = nothing
	end if
	response.redirect("mnt1_registro_mnt.asp")
	'?data1=" & ldt_data1 & "&data2=" & ldt_data2 )
end Sub


Sub alterarRegistro()

	CamposPreenchidosCorretamente()

	If ( ( isVazio(diarioBordo) = false ) And ( isVazio(ll_item) = false ) ) Then
		Dim qtdRegistros
		qtdRegistros = CInt(verificarTLBItemExistente(diarioBordo, ll_item, seqteclog))
		if (qtdRegistros > 0) then
			Response.Write("<center><h3><br/><br/><br/>J&aacute; existe um registro com o mesmo TLB e item. <br/>")
			Response.Write("Clique em voltar e altere o campo TLB e/ou o campo item!</h3></center>")
			Response.End
		end if
	End if

	Dim sSqlUpdate, Conn, SQL, rsReg
	Set Conn = CreateObject("ADODB.CONNECTION")	
	
	sSqlUpdate = 			  "Update SIG_TECHNICALLOGBOOK SET "	
	sSqlUpdate = sSqlUpdate & "descrdiscrep='" & descrDiscrep & "', "
	If isVazio( codata ) = false Then
		sSqlUpdate = sSqlUpdate & "codata=" & codAta & ","
		sSqlUpdate = sSqlUpdate & "codsubata=" & codsubata & ","
	End if
	sSqlUpdate = sSqlUpdate & "basestation='" & baseStation	 & "',"
	sSqlUpdate = sSqlUpdate & "descrmnt='" & descrMnt  & "',"
	sSqlUpdate = sSqlUpdate & "codanac='" & codAnac & "', "
	sSqlUpdate = sSqlUpdate & "oleoe1='" & e1  & "',"
	sSqlUpdate = sSqlUpdate & "oleoe2='" & e2  & "', "
	sSqlUpdate = sSqlUpdate & "oleoe3='" & e3  & "', "
	sSqlUpdate = sSqlUpdate & "oleoe4='" & e4  & "', "
	sSqlUpdate = sSqlUpdate & "oleoapu='" & apu & "', "
	sSqlUpdate = sSqlUpdate & "oleoha1g='" & Request.Form("txtha1g")  & "', "
	sSqlUpdate = sSqlUpdate & "oleohb2b='" & Request.Form("txthb2b")  & "', "
	sSqlUpdate = sSqlUpdate & "oleoh3sy='" & Request.Form("txtH3SY") & "', "
	sSqlUpdate = sSqlUpdate & "pnremovido='" & pnRemovido  & "', "
	sSqlUpdate = sSqlUpdate & "snremovido='" & snRemovido  & "', "
	sSqlUpdate = sSqlUpdate & "pninstalado='" & pnInstalado  & "', "
	sSqlUpdate = sSqlUpdate & "sninstalado='" & snInstalado & "', "
	If ( isVazio(mntData) = false ) then
		sSqlUpdate = sSqlUpdate & "dtacaomnt='" & formatarData(mntData, "amd") & "', "
	End If	
	sSqlUpdate = sSqlUpdate & "posatualremov='" & posAtualRemovido  & "', "
	sSqlUpdate = sSqlUpdate & "posatualinst='" & posAtualInstalado  & "', "
	sSqlUpdate = sSqlUpdate & "nomereport='" & reportado & "', "
	sSqlUpdate = sSqlUpdate & "dtregistro='" & formatarData(regData, "amd")  & "', "
'	aeronave = "oaf"
	sSqlUpdate = sSqlUpdate & "prefixo='" & aeronave & "', "
	If isVazio( ll_item ) = false Then
		sSqlUpdate = sSqlUpdate & "item=" & ll_item & " "
	Else
		sSqlUpdate = sSqlUpdate & "item=NULL "
	End if
	If ( isVazio( diarioBordo ) = false ) then
		sSqlUpdate = sSqlUpdate & ", diariobordo = '" & UCase(diarioBordo) & "' "
	End if
	
	'**************************************************************************************************************
	'*
	'*    SE TEM ORIGEM E DESTINO MARCADOS, ENTÃO VOU DESCOBRIR PRIMEIRO O SEQVOODIA PARA DEPOIS PEGAR O SEQTRECHO
	'*
	'**************************************************************************************************************			
	
	if not ( isVazio(Request.Form("comboOrigem")) and isVazio(Request.Form("comboDestino"))) then
		If CInt( Request.Form("comboOrigem")) > 0 Then
			sSqlUpdate = sSqlUpdate & ", seqaeroporig = " & Request.Form("comboOrigem") & " "
		Else
			sSqlUpdate = sSqlUpdate & ", seqaeroporig = NULL "
		End if
		If CInt( Request.Form("comboDestino")) > 0 Then
			sSqlUpdate = sSqlUpdate & ", seqaeropdest = " & Request.Form("comboDestino") & " "
		Else
			sSqlUpdate = sSqlUpdate & ", seqaeropdest = NULL "
		End if
		
		if ls_voo <> "" then	
					
			'************************************************
			'** Confere se o voo existiu
			'************************************************		
			If isnull( ls_voo ) or ls_voo = "" Then
				ls_voo = 0
			End if
			
			SQL = 		" SELECT SEQVOODIA FROM SIG_DIARIOVOO WHERE NRVOO = " & ls_voo
			SQL = SQL & " AND DTOPER = '" & formatarData(regData, "amd") & "'"

			Set rsReg = Server.CreateObject("ADODB.Recordset")		
		
			Conn.Open (StringConexaoSqlServer)
			Conn.Execute "SET DATEFORMAT ymd"
			
			rsReg.Open SQL, Conn
			
			if (rsReg.eof ) then		
				response.write("<center><h3><br/><br/><br/>O voo selecionado n&atilde;o foi encontrado em nossa base de dados<br/> Clique em voltar e preencha os campos corretamente! (540)</h3></center>")
				rsReg.close
				Conn.close
				response.end
			else
				seqvoodia = rsReg("seqvoodia")
				rsReg.close
				Conn.close
			end if 
	
			'************************************************************
			'** devo conferir se a etapa foi informada corretamente
			'************************************************************		
			SQL =       " SELECT SEQTRECHO FROM SIG_DIARIOTRECHO WHERE"
			SQL = SQL & " SEQAEROPORIG = " & Request.Form("comboOrigem")
			SQL = SQL & " AND SEQAEROPDEST = " & Request.Form("comboDestino")
			SQL = SQL & " AND SEQVOODIA = " & seqvoodia
			
			seqvoodia = buscarSeqVooDia(regData, ls_voo)
						
			if (seqvoodia = "-1" ) then
				response.write("<center><h3><br/><br/><br/>Registro de Voo n&atilde;o encontrado. <br/>Clique em voltar e preencha o campo corretamente!</h3></center>")
				response.end
			end if
			
			trecho = obterSeqTrecho(seqvoodia, aeronave, request.form("comboOrigem"), request.form("comboDestino"))
		
			if (trecho = "-1") then		
				response.write("<center><h3><br/><br/><br/>Registro de Etapa n&atilde;o encontrado para o voo selecionado!<br/> Clique em voltar e preencha os campos corretamente!</h3></center>")
				response.end
			end if
		
			aeronave = obterAeronave(seqvoodia, trecho)
			if ((aeronave = "-1" ) or (aeronave <> request.form("comboAeronave"))) then
				response.write("<center><h3><br/><br/><br/>A Aeronave selecionada n&atilde;o corresponde ao voo e dia informado. <br/>Clique em voltar e preencha o campo corretamente!</h3></center>")
				response.end
			end if
	
			
			sSqlUpdate = sSqlUpdate & ", seqtrecho = " & trecho
			sSqlUpdate = sSqlUpdate & ", seqvoodia = " & seqvoodia				
		else
			sSqlUpdate = sSqlUpdate & ", seqtrecho = null" 
			sSqlUpdate = sSqlUpdate & ", seqvoodia = null" 
		end if	
	end if
	
	sSqlUpdate = sSqlUpdate & " WHERE seqteclog = " & seqteclog & " "
	
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"	
	Conn.Execute sSqlUpdate
	conn.close
	set conn = nothing

	response.redirect("mnt1_registro_mnt.asp")
	'?data1=" & ldt_data1 & "&data2=" & ldt_data2 )
end Sub

Sub preencherComboAeroportos(selecionado)

	'******************************************************************************* 
	'*
	'*		NO CASO DESSA TABELA, COMO HÁ A POSSIBILIDADE DO CAMPO D0E EXIBIÇÃO ESTAR NULO(CODIATA),
	'*      ESSA FUNÇÃO COLOCA O CODICAO NO LUGAR 
	'* 	
	'******************************************************************************* 
	Dim rsResult, SQL, objConn
	Dim selecionou
	selecionou = false
	SQL = "SELECT SEQAEROPORTO, CODIATA, CODICAO FROM SIG_AEROPORTO ORDER BY CODIATA ASC"
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.open(StringConexaoSqlServer)																					
	Set rsResult = Server.CreateObject("ADODB.Recordset")
	rsResult.Open SQL, objConn	
	
	if (not isVazio(selecionado))	then
		selecionado = ucase(selecionado)
		selecionou = true
	end if
	
	while not rsResult.eof 
		if (selecionou=false) then				 'se não selecionei nada, simplesmente exibo todos sem marcar nenhum
			if isVazio(rsResult("CODIATA")) then
				response.write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODICAO") & "</option>"& chr(13) )						
			else			
				response.write("<option value='" & rsResult("SEQAEROPORTO") & "'> " & rsResult("CODIATA") & "</option>"& chr(13) )			
			end if
		else				'se tem algum selecionado como parametro
			if (cint(rsResult("SEQAEROPORTO")) = cint(selecionado)) then
				if isVazio(rsResult("CODIATA")) then
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODICAO") & "</option>"& chr(13) )						
				else			
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "' selected = 'selected'> " & rsResult("CODIATA") & "</option>"& chr(13) )			
				end if
			else
				if isVazio(rsResult("CODIATA")) then
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "'>" & rsResult("CODICAO") & "</option>"& chr(13) )						
				else			
					response.write("<option value='" & rsResult("SEQAEROPORTO") & "'>" &  rsResult("CODIATA") & "</option>"& chr(13) )			
				end if
			end if
		end if		
		rsResult.movenext
	wend
	
	objConn.close
	set rsResult = nothing
	set objConn = nothing
	
end Sub


function verificarTLBItemExistente(pDiarioBordo, pItem, pSeqTecLog)
	Dim SQL, objConn, rsResult

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)

	SQL = "SELECT COUNT(1) AS qtdRegistros FROM sig_technicallogbook WHERE seqteclog <> " & pSeqTecLog & " "
	If ( isVazio(pDiarioBordo) = false ) Then
		SQL = SQL  & " AND diariobordo = '" & pDiarioBordo & "' "
	End if
	If ( isVazio(pItem) = false ) Then
		SQL = SQL  & " AND item = " & pItem
	End if

	Set rsResult = Server.CreateObject("ADODB.Recordset")

	objConn.Execute "SET DATEFORMAT ymd"
	rsResult.Open SQL, objConn

	verificarTLBItemExistente = CInt(rsResult("qtdRegistros"))

	objConn.close
	set objConn = nothing
end function

Sub CamposPreenchidosCorretamente()

	' *********************************
	' ***  Reporte de Discrepancia  ***
	' *********************************
	if (isVazio(Request.Form("txtData"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Data no Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if
	if (Not IsDate(Request.Form("txtData"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Data com uma data v&aacute;lida no Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("comboAeronave")) or Request.Form("comboAeronave") = "0") then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e selecione a Aeronave no Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if
	if (Not isVazio(Request.Form("txtVoo")) and _
	    (isVazio(Request.Form("comboOrigem")) or Request.Form("comboOrigem") = "0" or _
	     isVazio(Request.Form("comboDestino")) or Request.Form("comboDestino") = "0")) then
		Response.Write("<center><h3><br/><br/><br/>Caso o campo Voo esteja preenchido, torna-se necess&aacute;rio selecionar a Etapa correspondente!</h3></center>")
		Response.Write("<center><h3>Clique em voltar e selecione a Etapa correspondente no Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtDescrDiscrep"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha a descri&ccedil;&atilde;o do Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtDiarioBordo"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo TLB/PG no Reporte de Discrep&acirc;ncia, por favor!</h3></center>")
		Response.End
	end if

	' ****************************
	' ***  Acao de Manutencao  ***
	' ****************************
	if (isVazio(Request.Form("txtDtAcaoMnt"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Data na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (Not IsDate(Request.Form("txtDtAcaoMnt"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Data com uma data v&aacute;lida na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("comboAta100")) or Request.Form("comboAta100") = "0") then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e selecione a ATA 100 na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtBaseStation"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Base Station na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtCodAnac"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo Cod. Anac na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtDescrMnt"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha a descri&ccedil;&atilde;o da A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtE1"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo E1 na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtE2"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo E2 na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtAPU"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo APU na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if
	if (isVazio(Request.Form("txtHA1G"))) then
		Response.Write("<center><h3><br/><br/><br/>Clique em voltar e preencha o campo HA1G na A&ccedil;&atilde;o de Manuten&ccedil;&atilde;o, por favor!</h3></center>")
		Response.End
	end if

end Sub

%>
