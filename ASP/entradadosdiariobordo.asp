<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<% Response.Charset = "ISO-8859-1"%>
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="libgeral.asp"-->
<%
	Dim objConn
	Dim objRs, strSqlSelect, strSqlFrom, strSqlWhere, strQuery
	Dim intSeqVooDia, intSeqTrecho
	Dim strDia, strMes, strAno
	
   	
		 strDia = Request.QueryString("strDia")
		 strMes = Request.QueryString("strMes")
		 strAno = Request.QueryString("strAno")
		 intSeqVooDia = Request.QueryString("seqvoodia")
		 intSeqTrecho = Request.QueryString("seqtrecho")
	

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	' ********************
	' *** FUSO BSB-GMT ***
	' ********************
	Dim objRsFuso, strSqlSelectFuso, strSqlFromFuso, strSqlWhereFuso, strQueryFuso
	Dim intFusoGMT
	
	strSqlSelectFuso =                  " SELECT sig_aeropfuso.fusogmt "
	strSqlFromFuso =                    " FROM sig_aeropfuso sig_aeropfuso, sig_aeroporto sig_aeroporto, sig_diariovoo sig_diariovoo "
	strSqlWhereFuso =                   " WHERE sig_aeropfuso.seqaeroporto = sig_aeroporto.seqaeroporto "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_aeroporto.codicao = 'SBBR' "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_aeropfuso.dtinicio <= sig_diariovoo.dtoper "
	strSqlWhereFuso = strSqlWhereFuso & "   AND (sig_aeropfuso.dtfim >= sig_diariovoo.dtoper OR sig_aeropfuso.dtfim IS NULL) "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_diariovoo.seqvoodia=" & intSeqVooDia
	strQueryFuso = strSqlSelectFuso & strSqlFromFuso & strSqlWhereFuso
	
	Set objRsFuso = Server.CreateObject("ADODB.Recordset")
	objRsFuso.Open strQueryFuso, objConn
	if (Not objRsFuso.EOF) then
		intFusoGMT = CInt(objRsFuso("fusogmt"))
	else
		intFusoGMT = CInt(0)
	end if
	objRsFuso.Close()
	Set objRsFuso = Nothing

	Dim strGravar, strVoltar
	strGravar = Request.Form("btnGravar")
	strVoltar = Request.Form("btnVoltar")

	if (strVoltar <> "") then
		Response.Redirect("listagemdiariobordo.asp")
	elseif (strGravar <> "") then
		Dim strTxtDiaPartidaMotor, strTxtMesPartidaMotor, strTxtAnoPartidaMotor, strTxtHoraPartidaMotor, strTxtMinutoPartidaMotor
		Dim strTxtDiaDecolagem, strTxtMesDecolagem, strTxtAnoDecolagem, strTxtHoraDecolagem, strTxtMinutoDecolagem
		Dim strTxtDiaPouso, strTxtMesPouso, strTxtAnoPouso, strTxtHoraPouso, strTxtMinutoPouso
		Dim strTxtDiaCorteMotor, strTxtMesCorteMotor, strTxtAnoCorteMotor, strTxtHoraCorteMotor, strTxtMinutoCorteMotor
		Dim strTxtDiarioBordo, strTxtCombLocal, strTxtCombTotal, strTxtCombPartidaMotor, strTxtCombDecolagem, strTxtCombPouso, strTxtCombCorteMotor

		strTxtDiaPartidaMotor = Request.Form("txtDiaPartidaMotor")
		strTxtMesPartidaMotor = Request.Form("txtMesPartidaMotor")
		strTxtAnoPartidaMotor = Request.Form("txtAnoPartidaMotor")
		strTxtHoraPartidaMotor = Request.Form("txtHoraPartidaMotor")
		strTxtMinutoPartidaMotor = Request.Form("txtMinutoPartidaMotor")
		strTxtDiaDecolagem = Request.Form("txtDiaDecolagem")
		strTxtMesDecolagem = Request.Form("txtMesDecolagem")
		strTxtAnoDecolagem = Request.Form("txtAnoDecolagem")
		strTxtHoraDecolagem = Request.Form("txtHoraDecolagem")
		strTxtMinutoDecolagem = Request.Form("txtMinutoDecolagem")
		strTxtDiaPouso = Request.Form("txtDiaPouso")
		strTxtMesPouso = Request.Form("txtMesPouso")
		strTxtAnoPouso = Request.Form("txtAnoPouso")
		strTxtHoraPouso = Request.Form("txtHoraPouso")
		strTxtMinutoPouso = Request.Form("txtMinutoPouso")
		strTxtDiaCorteMotor = Request.Form("txtDiaCorteMotor")
		strTxtMesCorteMotor = Request.Form("txtMesCorteMotor")
		strTxtAnoCorteMotor = Request.Form("txtAnoCorteMotor")
		strTxtHoraCorteMotor = Request.Form("txtHoraCorteMotor")
		strTxtMinutoCorteMotor = Request.Form("txtMinutoCorteMotor")
		strTxtCombLocal = Request.Form("txtCombPartidaMotor")
		strTxtCombTotal = Request.Form("hdCombTotal")
		strTxtCombPartidaMotor = Request.Form("txtCombPartidaMotor")
		strTxtCombDecolagem = Request.Form("txtCombDecolagem")
		strTxtCombPouso = Request.Form("txtCombPouso")
		strTxtCombCorteMotor = Request.Form("txtCombCorteMotor")
		strTxtDiarioBordo = Request.Form("txtDiarioBordo")
		
		'Response.Write(strTxtCombPartidaMotor& "<br>")
		'Response.Write(strTxtCombDecolagem& "<br>")
		'Response.Write(strTxtCombPouso& "<br>")
		'Response.Write(strTxtCombCorteMotor& "<br>")
		'Response.Write(strTxtCombTotal& "<br>")
		'Response.End()

		Dim strTxtDataPartidaMotor, datTxtDataPartidaMotor
		strTxtDataPartidaMotor = strTxtAnoPartidaMotor & "-" & strTxtMesPartidaMotor & "-" & strTxtDiaPartidaMotor & " " & strTxtHoraPartidaMotor & ":" & strTxtMinutoPartidaMotor
		datTxtDataPartidaMotor = CDate(strTxtDataPartidaMotor)
		datTxtDataPartidaMotor = CDate(DateAdd("h", -intFusoGMT, datTxtDataPartidaMotor))
		strTxtDataPartidaMotor = CStr(Year(datTxtDataPartidaMotor)) & "/" & Right("00"&CStr(Month(datTxtDataPartidaMotor)),2) & "/" & Right("00"&CStr(Day(datTxtDataPartidaMotor)),2) & " " & Right("00"&CStr(Hour(datTxtDataPartidaMotor)),2) & ":" & Right("00"&CStr(Minute(datTxtDataPartidaMotor)),2)

		Dim strTxtDataDecolagem, datTxtDataDecolagem
		strTxtDataDecolagem = strTxtAnoDecolagem & "-" & strTxtMesDecolagem & "-" & strTxtDiaDecolagem & " " & strTxtHoraDecolagem & ":" & strTxtMinutoDecolagem
		datTxtDataDecolagem = CDate(strTxtDataDecolagem)
		datTxtDataDecolagem = CDate(DateAdd("h", -intFusoGMT, datTxtDataDecolagem))
		strTxtDataDecolagem = CStr(Year(datTxtDataDecolagem)) & "/" & Right("00"&CStr(Month(datTxtDataDecolagem)),2) & "/" & Right("00"&CStr(Day(datTxtDataDecolagem)),2) & " " & Right("00"&CStr(Hour(datTxtDataDecolagem)),2) & ":" & Right("00"&CStr(Minute(datTxtDataDecolagem)),2)

		Dim strTxtDataPouso, datTxtDataPouso
		strTxtDataPouso = strTxtAnoPouso & "-" & strTxtMesPouso & "-" & strTxtDiaPouso & " " & strTxtHoraPouso & ":" & strTxtMinutoPouso

		datTxtDataPouso = CDate(strTxtDataPouso)
		datTxtDataPouso = CDate(DateAdd("h", -intFusoGMT, datTxtDataPouso))
		strTxtDataPouso = CStr(Year(datTxtDataPouso)) & "/" & Right("00"&CStr(Month(datTxtDataPouso)),2) & "/" & Right("00"&CStr(Day(datTxtDataPouso)),2) & " " & Right("00"&CStr(Hour(datTxtDataPouso)),2) & ":" & Right("00"&CStr(Minute(datTxtDataPouso)),2)

		Dim strTxtDataCorteMotor, datTxtDataCorteMotor
		strTxtDataCorteMotor = strTxtAnoCorteMotor & "-" & strTxtMesCorteMotor & "-" & strTxtDiaCorteMotor & " " & strTxtHoraCorteMotor & ":" & strTxtMinutoCorteMotor
		datTxtDataCorteMotor = CDate(strTxtDataCorteMotor)
		datTxtDataCorteMotor = CDate(DateAdd("h", -intFusoGMT, datTxtDataCorteMotor))
		strTxtDataCorteMotor = CStr(Year(datTxtDataCorteMotor)) & "/" & Right("00"&CStr(Month(datTxtDataCorteMotor)),2) & "/" & Right("00"&CStr(Day(datTxtDataCorteMotor)),2) & " " & Right("00"&CStr(Hour(datTxtDataCorteMotor)),2) & ":" & Right("00"&CStr(Minute(datTxtDataCorteMotor)),2)

		if CamposPreenchidosCorretamente(datTxtDataPartidaMotor, datTxtDataDecolagem) then

			Dim objConexaoSqlServerUpdate, objRecordSetSqlServerUpdate, RS, objConexaoSqlServerInsert
			Dim strSqlUpdate, strSqlSet, strSqlFromUpdate, strSqlWhereUpdate, strQueryUpdate, sSql, objRecordSetSqlServerInsert, strSqlInsert
			
			set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
			objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
			objConexaoSqlServerUpdate.Execute "SET DATEFORMAT ymd"
			
         sSql = "Select * FROM sig_diariotrechodb WHERE seqvoodia='" & intSeqVooDia & "' AND seqtrecho='" & intSeqTrecho & "'"
			Set RS = objConn.Execute(sSql)
			
			If RS.EOF Then 
			  		strSqlInsert =                " INSERT INTO sig_diariotrechodb (seqvoodia,seqtrecho,partidamotor, "
					strSqlInsert = strSqlInsert &	"  decolagem,pouso,cortemotor,diariobordo,comblocal,combtotal,"
					strSqlInsert = strSqlInsert &	"  combpartidamotor,combdecolagem,combpouso,combcortemotor)"
					strSqlInsert = strSqlInsert &	" VALUES (" & intSeqVooDia & "," & intSeqTrecho & ",'" & strTxtDataPartidaMotor & "',"
					strSqlInsert = strSqlInsert &	" '" & strTxtDataDecolagem & "','" & strTxtDataPouso & "','"& strTxtDataCorteMotor &"',"
					strSqlInsert = strSqlInsert & " '" & UCase(strTxtDiarioBordo) &"',"
					If strTxtComblocal = "" Then
						strSqlInsert = strSqlInsert & "NULL,"
					Else
						strSqlInsert = strSqlInsert & strTxtComblocal  & ","
					End if
					If strTxtCombTotal = "" Then
						strSqlInsert = strSqlInsert & "NULL,"
					Else
						strSqlInsert = strSqlInsert & strTxtCombTotal &","
					End if
					If strTxtCombPartidaMotor = "" Then
						strSqlInsert = strSqlInsert & "NULL,"
					Else
						strSqlInsert = strSqlInsert & strTxtCombPartidaMotor & ","
					End if
					If strTxtCombDecolagem = "" Then
						strSqlInsert = strSqlInsert & "NULL,"
					Else
						strSqlInsert = strSqlInsert & strTxtCombDecolagem & ","
					End if
					If strTxtCombPouso = "" Then
						strSqlInsert = strSqlInsert & "NULL,"
					Else
						strSqlInsert = strSqlInsert & strTxtCombPouso & "," 
					End if
					If strTxtCombCorteMotor = "" Then
						strSqlInsert = strSqlInsert & "NULL )"
					Else
						strSqlInsert = strSqlInsert & strTxtCombCorteMotor & " )"
					End if
					
					set objRecordSetSqlServerUpdate = objConexaoSqlServerUpdate.Execute(strSqlInsert)
					objConexaoSqlServerUpdate.Close
					set objRecordSetSqlServerUpdate = nothing
					
			Else			
					strSqlUpdate =           " UPDATE sig_diariotrechodb "
					strSqlSet =              " SET sig_diariotrechodb.partidamotor='" & strTxtDataPartidaMotor & "'"
					strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.decolagem='" & strTxtDataDecolagem & "'"
					strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.pouso='" & strTxtDataPouso & "'"
					strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.cortemotor='" & strTxtDataCorteMotor & "'"
					strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.diariobordo='" & UCase(strTxtDiarioBordo) & "'"
					If strTxtComblocal = "" Then
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.comblocal=NULL"
					Else
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.comblocal="& Plic(strTxtComblocal) 
					End if
					If strTxtCombPartidaMotor = "" Then
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combpartidamotor=NULL"
					Else
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combpartidamotor="& Plic(strTxtCombPartidaMotor) 
					End if
					If strTxtCombDecolagem = "" Then
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combdecolagem=NULL"
					Else
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combdecolagem="& Plic(strTxtCombDecolagem) 
  					End if
					If strTxtCombPouso = "" Then
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combpouso=NULL"
					Else
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combpouso="& Plic(strTxtCombPouso) 	
					End if
					If strTxtCombCorteMotor = "" Then
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combcortemotor=NULL"
					Else
						strSqlSet = strSqlSet &  " ,sig_diariotrechodb.combcortemotor="& Plic(strTxtCombCorteMotor) 					
					End if
					If strTxtCombTotal = "" Then
						strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.combtotal=NULL"
					Else
						strSqlSet = strSqlSet &  "    ,sig_diariotrechodb.combtotal="& Plic(strTxtCombTotal)
					End if
					strSqlWhereUpdate =      " WHERE seqvoodia=" & intSeqVooDia
					strSqlWhereUpdate = strSqlWhereUpdate & "   AND seqtrecho=" & intSeqTrecho
					strQueryUpdate = strSqlUpdate & strSqlSet & strSqlWhereUpdate
					
					set objRecordSetSqlServerUpdate = objConexaoSqlServerUpdate.Execute(strQueryUpdate)
		
					objConexaoSqlServerUpdate.Close
					set objRecordSetSqlServerUpdate = nothing
					set objConexaoSqlServerUpdate = nothing
			End If
			Response.Write("<script language='javascript'>alert('Operação realizada com sucesso!');</script>")
			
		end if

	end if

	strSqlSelect =                " SELECT sig_diariovoo.nrvoo, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.dtoper, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.seqvoodia, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqtrecho, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.prefixoaeronave, "
	strSqlSelect = strSqlSelect & "        aeroporig.codiata Origem, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata Destino, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.comblocal,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combnf,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combabastec,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combtotal,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combna,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combfat,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combvalor,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.diariobordo, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combpartidamotor, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combdecolagem, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combpouso, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combcortemotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrecho.partidaprev) partidaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrecho.chegadaprev) chegadaprev, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrechodb.partidamotor) partidamotor, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrechodb.decolagem) decolagem, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrechodb.pouso) pouso, "
	strSqlSelect = strSqlSelect & "        DATEADD(hh, " & intFusoGMT & ", sig_diariotrechodb.cortemotor) cortemotor "
	strSqlFrom =                  " FROM sig_diariovoo sig_diariovoo, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeroporig, "
	strSqlFrom = strSqlFrom &     "      sig_aeroporto aeropdest, "
	strSqlFrom = strSqlFrom &     "      sig_diariotrecho sig_diariotrecho "
	strSqlFrom = strSqlFrom &     "      LEFT OUTER JOIN sig_diariotrechodb ON sig_diariotrechodb.seqvoodia = sig_diariotrecho.seqvoodia "
	strSqlFrom = strSqlFrom &     "           AND sig_diariotrechodb.seqtrecho = sig_diariotrecho.seqtrecho "
	strSqlWhere =                 " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqvoodia = " & intSeqVooDia & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqtrecho = " & intSeqTrecho & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto "

	strQuery = strSqlSelect & strSqlFrom & strSqlWhere

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	' *****************************
	' *** Diário de Bordo ***
	' *****************************
	Dim strDiarioBordo
	strDiarioBordo = ObjRs("diariobordo")

	' *******************************************
	' *** PARTIDA PREVISTA / CHEGADA PREVISTA ***
	' ***          PARTIDA / CHEGADA          ***
	' *******************************************
	Dim strHora, strData, strMinuto, strPartidaPrev, strChegadaPrev, strPartida, strChegada
	strHora = FormatDateTime(ObjRs("partidaprev"), 4)
	strData = FormatDateTime(ObjRs("partidaprev"), 2)
	strData = Right("00"&Day(strData),2) & "/" & Right("00"&Month(strData),2) & "/" & Year(strData)
	strPartidaPrev = strData & "&nbsp;" & strHora
	
	strHora = FormatDateTime(ObjRs("chegadaprev"), 4)
	strData = FormatDateTime(ObjRs("chegadaprev"), 2)
	strData = Right("00"&Day(strData),2) & "/" & Right("00"&Month(strData),2) & "/" & Year(strData)
	strChegadaPrev = strData & "&nbsp;" & strHora
	If ISNULL(ObjRs("partidamotor")) Then
		strHora = "00"
		strData = "00"
	Else
		strHora = FormatDateTime(ObjRs("partidamotor"), 4)
	   strData = FormatDateTime(ObjRs("partidamotor"), 2)
		strData = Right("00"&Day(strData),2) & "/" & Right("00"&Month(strData),2) & "/" & Year(strData)
	End IF	
	strMinuto = Minute(ObjRs("decolagem"))
	strPartida = strData & "&nbsp;" & strHora & "&nbsp;(" & strMinuto & ")"
	
	If ISNULL(ObjRs("pouso")) Then
	   strHora = "00"
		strData = "00"
	Else
	   strHora = FormatDateTime(ObjRs("pouso"), 4)
	   strData = FormatDateTime(ObjRs("pouso"), 2)
		strData = Right("00"&Day(strData),2) & "/" & Right("00"&Month(strData),2) & "/" & Year(strData)
	End If	
	strMinuto = Minute(ObjRs("cortemotor"))
	strChegada = strData & "&nbsp;" & strHora & "&nbsp;(" & strMinuto & ")"

	' *****************
	' *** DECOLAGEM ***
	' *****************
	Dim strAnoDecolagem, strMesDecolagem, strDiaDecolagem, strHoraDecolagem, strMinutoDecolagem
	Dim dtDecolagem, dtPartidaPrevista
	dtDecolagem = ObjRs("decolagem")
	dtPartidaPrevista = ObjRs("partidaprev")
	if (IsNull(dtDecolagem) or IsEmpty(dtDecolagem)) then
		strAnoDecolagem = Year(dtPartidaPrevista)
		if (Month(dtPartidaPrevista) < 10) then strMesDecolagem = "0"
		strMesDecolagem = strMesDecolagem & Month(dtPartidaPrevista)
		if (Day(dtPartidaPrevista) < 10) then strDiaDecolagem = "0"
		strDiaDecolagem = strDiaDecolagem & Day(dtPartidaPrevista)
		strHoraDecolagem = ""
		strMinutoDecolagem = ""
	else
		strAnoDecolagem = Year(dtDecolagem)
		if (Month(dtDecolagem) < 10) then strMesDecolagem = "0"
		strMesDecolagem = strMesDecolagem & Month(dtDecolagem)
		if (Day(dtDecolagem) < 10) then strDiaDecolagem = "0"
		strDiaDecolagem = strDiaDecolagem & Day(dtDecolagem)
		if (Hour(dtDecolagem) < 10) then strHoraDecolagem = "0"
		strHoraDecolagem = strHoraDecolagem & Hour(dtDecolagem)
		if (Minute(dtDecolagem) < 10) then strMinutoDecolagem = "0"
		strMinutoDecolagem = strMinutoDecolagem & Minute(dtDecolagem)
	end if

	' *********************
	' *** PARTIDA MOTOR ***
	' *********************
	Dim strAnoPartidaMotor, strMesPartidaMotor, strDiaPartidaMotor, strHoraPartidaMotor, strMinutoPartidaMotor
	Dim dtPartidaMotor
	dtPartidaMotor = ObjRs("partidamotor")
	if (IsNull(dtPartidaMotor) or IsEmpty(dtPartidaMotor)) then
		strAnoPartidaMotor = Year(dtPartidaPrevista)
		if (Month(dtPartidaPrevista) < 10) then strMesPartidaMotor = "0"
		strMesPartidaMotor = strMesPartidaMotor & Month(dtPartidaPrevista)
		if (Day(dtPartidaPrevista) < 10) then strDiaPartidaMotor = "0"
		strDiaPartidaMotor = strDiaPartidaMotor & Day(dtPartidaPrevista)
		strHoraPartidaMotor = ""
		strMinutoPartidaMotor = ""
	else
		strAnoPartidaMotor = Year(dtPartidaMotor)
		if (Month(dtPartidaMotor) < 10) then strMesPartidaMotor = "0"
		strMesPartidaMotor = strMesPartidaMotor & Month(dtPartidaMotor)
		if (Day(dtPartidaMotor) < 10) then strDiaPartidaMotor = "0"
		strDiaPartidaMotor = strDiaPartidaMotor & Day(dtPartidaMotor)
		if (Hour(dtPartidaMotor) < 10) then strHoraPartidaMotor = "0"
		strHoraPartidaMotor = strHoraPartidaMotor & Hour(dtPartidaMotor)
		if (Minute(dtPartidaMotor) < 10) then strMinutoPartidaMotor = "0"
		strMinutoPartidaMotor = strMinutoPartidaMotor & Minute(dtPartidaMotor)
	end if

	' *************
	' *** POUSO ***
	' *************
	Dim strAnoPouso, strMesPouso, strDiaPouso, strHoraPouso, strMinutoPouso
	Dim dtPouso, dtChegadaPrevista
	dtPouso = ObjRs("pouso")
	dtChegadaPrevista = ObjRs("chegadaprev")
	if (IsNull(dtPouso) or IsEmpty(dtPouso)) then
		strAnoPouso = Year(dtChegadaPrevista)
		if (Month(dtChegadaPrevista) < 10) then strMesPouso = "0"
		strMesPouso = strMesPouso & Month(dtChegadaPrevista)
		if (Day(dtChegadaPrevista) < 10) then strDiaPouso = "0"
		strDiaPouso = strDiaPouso & Day(dtChegadaPrevista)
		strHoraPouso = ""
		strMinutoPouso = ""
	else
		strAnoPouso = Year(dtPouso)
		if (Month(dtPouso) < 10) then strMesPouso = "0"
		strMesPouso = strMesPouso & Month(dtPouso)
		if (Day(dtPouso) < 10) then strDiaPouso = "0"
		strDiaPouso = strDiaPouso & Day(dtPouso)
		if (Hour(dtPouso) < 10) then strHoraPouso = "0"
		strHoraPouso = strHoraPouso & Hour(dtPouso)
		if (Minute(dtPouso) < 10) then strMinutoPouso = "0"
		strMinutoPouso = strMinutoPouso & Minute(dtPouso)
	end if

	' *******************
	' *** CORTE MOTOR ***
	' *******************
	Dim strAnoCorteMotor, strMesCorteMotor, strDiaCorteMotor, strHoraCorteMotor, strMinutoCorteMotor
	Dim dtCorteMotor
	dtCorteMotor = ObjRs("Cortemotor")
	if (IsNull(dtCorteMotor) or IsEmpty(dtCorteMotor)) then
		strAnoCorteMotor = Year(dtChegadaPrevista)
		if (Month(dtChegadaPrevista) < 10) then strMesCorteMotor = "0"
		strMesCorteMotor = strMesCorteMotor & Month(dtChegadaPrevista)
		if (Day(dtChegadaPrevista) < 10) then strDiaCorteMotor = "0"
		strDiaCorteMotor = strDiaCorteMotor & Day(dtChegadaPrevista)
		strHoraCorteMotor = ""
		strMinutoCorteMotor = ""
	else
		strAnoCorteMotor = Year(dtCorteMotor)
		if (Month(dtCorteMotor) < 10) then strMesCorteMotor = "0"
		strMesCorteMotor = strMesCorteMotor & Month(dtCorteMotor)
		if (Day(dtCorteMotor) < 10) then strDiaCorteMotor = "0"
		strDiaCorteMotor = strDiaCorteMotor & Day(dtCorteMotor)
		if (Hour(dtCorteMotor) < 10) then strHoraCorteMotor = "0"
		strHoraCorteMotor = strHoraCorteMotor & Hour(dtCorteMotor)
		if (Minute(dtCorteMotor) < 10) then strMinutoCorteMotor = "0"
		strMinutoCorteMotor = strMinutoCorteMotor & Minute(dtCorteMotor)
	end if

	' ******************
	' *** TRIPULAÇÃO ***
	' ******************
	Dim objRsTrip, strQueryTrip

	strQueryTrip =                " SELECT TRIPCARGO.codcargo, "
	strQueryTrip = strQueryTrip & "        TRIPULANTE.nomeguerra, "
	strQueryTrip = strQueryTrip & "        TRIPULANTE.seqtripulante, "
	strQueryTrip = strQueryTrip & "        CARGO.ordem, "
	strQueryTrip = strQueryTrip & "        PROGRAMACAO.funcao "
	strQueryTrip = strQueryTrip & "   FROM sig_tripulante AS TRIPULANTE, "
	strQueryTrip = strQueryTrip & "        sig_jornada AS JORNADA, "
	strQueryTrip = strQueryTrip & "        sig_programacao AS PROGRAMACAO, "
	strQueryTrip = strQueryTrip & "        sig_escdiariovoo AS ESCDIARIOVOO, "
	strQueryTrip = strQueryTrip & "        sig_tripcargo AS TRIPCARGO, "
	strQueryTrip = strQueryTrip & "        sig_cargo AS CARGO, "
	strQueryTrip = strQueryTrip & "        sig_diariovoo AS DIARIOVOO, "
	strQueryTrip = strQueryTrip & "        sig_diariotrecho AS DIARIOTRECHO "
	strQueryTrip = strQueryTrip & "  WHERE TRIPULANTE.seqtripulante = JORNADA.seqtripulante "
	strQueryTrip = strQueryTrip & "    AND JORNADA.dtjornada = DIARIOVOO.dtoper "
	strQueryTrip = strQueryTrip & "    AND JORNADA.seqjornada = PROGRAMACAO.seqjornada "
	strQueryTrip = strQueryTrip & "    AND PROGRAMACAO.seqvoodiaesc = ESCDIARIOVOO.seqvoodiaesc "
	strQueryTrip = strQueryTrip & "    AND PROGRAMACAO.seqaeroporig = DIARIOTRECHO.seqaeroporig "
	strQueryTrip = strQueryTrip & "    AND PROGRAMACAO.seqaeropdest = DIARIOTRECHO.seqaeropdest "
	strQueryTrip = strQueryTrip & "    AND JORNADA.flgcorrente = 'S' "
	strQueryTrip = strQueryTrip & "    AND ESCDIARIOVOO.nrvoo = DIARIOVOO.nrvoo "
	strQueryTrip = strQueryTrip & "    AND TRIPCARGO.seqtripulante = TRIPULANTE.seqtripulante "
	strQueryTrip = strQueryTrip & "    AND TRIPCARGO.dtinicio <= JORNADA.dtjornada "
	strQueryTrip = strQueryTrip & "    AND (TRIPCARGO.dtfim >= JORNADA.dtjornada OR TRIPCARGO.dtfim is null) "
	strQueryTrip = strQueryTrip & "    AND CARGO.codcargo = TRIPCARGO.codcargo "
	strQueryTrip = strQueryTrip & "    AND DIARIOVOO.seqvoodia = " & intSeqVooDia & " "
	strQueryTrip = strQueryTrip & "    AND DIARIOTRECHO.seqvoodia =" & intSeqVooDia & " "
	strQueryTrip = strQueryTrip & "    AND DIARIOTRECHO.seqtrecho = " & intSeqTrecho & " "
	strQueryTrip = strQueryTrip & " ORDER BY CARGO.ordem, PROGRAMACAO.funcao, TRIPULANTE.nomeguerra "
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn

%>

<html>
	<head>
		<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">   
		<title>SIGLA - Diário de Bordo</title>
      <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
  		<style type="text/css">

		#dhtmltooltip{
		position: absolute;
		width: 150px;
		border: 2px solid black;
		padding: 2px;
		background-color: lightyellow;
		visibility: hidden;
		z-index: 100;
		filter: progid:DXImageTransform.Microsoft.Shadow(color=gray,direction=135);
		}
		
		</style>

		<script src="javascript.js"></script>
      <script src="jquery-1.1.4.js" type="text/javascript"></script>
		<script language="javascript">
		$(document).ready(function() {
		   $('#txtDiarioBordo').focus();
		});
		function CalculaCombTotal(){
					var Parametro1=document.form1.txtCombPartidaMotor.value;
					var Parametro2=document.form1.txtCombCorteMotor.value;
					var Soma=0;
					//isNaN = Verifica se o valor pode ser convertido para um número, se não puder ser ele devolve NaN
					if (isNaN(Parametro1) || isNaN(Parametro2) || Parametro1=='' || Parametro2=='') {
						Soma=0
					}
					else
					{
						Soma=((parseInt(Parametro1))-(parseInt(Parametro2)));
					}
					
					document.form1.txtCombTotal.value=Soma;
					document.form1.hdCombTotal.value=Soma;
					
		}			
		
		function VerificaCampos() {
				if (window.form1.txtDiarioBordo.value == '') {
					alert('Preencha o campo Diario de Bordo, por favor!');
					window.form1.txtDiarioBordo.focus();
					return false;
				}
				if (window.form1.txtDiaPartidaMotor.value == '') {
					alert('Preencha o campo dia da partida motor, por favor!');
					window.form1.txtDiaPartidaMotor.focus();
					return false;
				}
				else if (window.form1.txtMesPartidaMotor.value == '') {
					alert('Preencha o campo mês da partida motor, por favor!');
					window.form1.txtMesPartidaMotor.focus();
					return false;
				}
				else if (window.form1.txtAnoPartidaMotor.value == '') {
					alert('Preencha o campo ano da partida motor, por favor!');
					window.form1.txtAnoPartidaMotor.focus();
					return false;
				}
				else if (window.form1.txtHoraPartidaMotor.value == '') {
					alert('Preencha o campo hora da partida motor, por favor!');
					window.form1.txtHoraPartidaMotor.focus();
					return false;
				}
				else if (window.form1.txtMinutoPartidaMotor.value == '') {
					alert('Preencha o campo minuto da partida motor, por favor!');
					window.form1.txtMinutoPartidaMotor.focus();
					return false;
				}
				else if (window.form1.txtDiaDecolagem.value == '') {
					alert('Preencha o campo dia da decolagem, por favor!');
					window.form1.txtDiaDecolagem.focus();
					return false;
				}
				else if (window.form1.txtMesDecolagem.value == '') {
					alert('Preencha o campo mês da decolagem, por favor!');
					window.form1.txtMesDecolagem.focus();
					return false;
				}
				else if (window.form1.txtAnoDecolagem.value == '') {
					alert('Preencha o campo ano da decolagem, por favor!');
					window.form1.txtAnoDecolagem.focus();
					return false;
				}
				else if (window.form1.txtHoraDecolagem.value == '') {
					alert('Preencha o campo hora da decolagem, por favor!');
					window.form1.txtHoraDecolagem.focus();
					return false;
				}
				else if (window.form1.txtMinutoDecolagem.value == '') {
					alert('Preencha o campo minuto da decolagem, por favor!');
					window.form1.txtMinutoDecolagem.focus();
					return false;
				}
				else if (window.form1.txtDiaPouso.value == '') {
					alert('Preencha o campo dia do pouso, por favor!');
					window.form1.txtDiaPouso.focus();
					return false;
				}	
				else if (window.form1.txtMesPouso.value == '') {
					alert('Preencha o campo mês do pouso, por favor!');
					window.form1.txtMesPouso.focus();
					return false;
				}	
				else if (window.form1.txtAnoPouso.value == '') {
					alert('Preencha o campo Ano do pouso, por favor!');
					window.form1.txtAnoPouso.focus();
					return false;
				}	
				else if (window.form1.txtHoraPouso.value == '') {
					alert('Preencha o campo hora do pouso, por favor!');
					window.form1.txtHoraPouso.focus();
					return false;
				}
				else if (window.form1.txtMinutoPouso.value == '') {
					alert('Preencha o campo minuto do pouso, por favor!');
					window.form1.txtMinutoPouso.focus();
					return false;
				}		
				else if (window.form1.txtDiaCorteMotor.value == '') {
					alert('Preencha o campo dia do corte do motor, por favor!');
					window.form1.txtDiaCorteMotor.focus();
					return false;
				}
				else if (window.form1.txtMesCorteMotor.value == '') {
					alert('Preencha o campo mês do corte do motor, por favor!');
					window.form1.txtMesCorteMotor.focus();
					return false;
				}
				else if (window.form1.txtAnoCorteMotor.value == '') {
					alert('Preencha o campo Ano do corte do motor, por favor!');
					window.form1.txtAnoCorteMotor.focus();
					return false;
				}
				else if (window.form1.txtHoraCorteMotor.value == '') {
					alert('Preencha o campo Hora do corte do motor, por favor!');
					window.form1.txtHoraCorteMotor.focus();
					return false;
				}
				else if (window.form1.txtMinutoCorteMotor.value == '') {
					alert('Preencha o campo minuto do corte do motor, por favor!');
					window.form1.txtMinutoCorteMotor.focus();
					return false;
				}
		}
		
		</script>
	</head>
	<body>
   <div id="dhtmltooltip"></div>
	<script src="tooltip.js"></script>
	 <center>
         <table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
            <tr>
               <td class="corpo" align="left" valign="middle" width="33%">
                  <img src="imagens/logo_empresa.gif" border="0"></a>            </td>
               <td class="corpo" align="center" width="29%" rowspan="2">
                  <font size="4"><b>&nbsp;Diário de Bordo</b></font>            </td>
               <td class="corpo" align="right" valign="top" width="29%" colspan="20">
               	<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
              	</td>
            </tr>
            <tr>
               <td></td>
               <td></td>
            </tr>
            <tr>   
               <td colspan="25">
                  <!--#include file="Menu.asp"-->
               </td>
            </tr>   
         </table>
   </center>
	 <br />
	 <br />
      <% 
		Dim Voo
		Dim Aeronave
		Dim Origem
		Dim Destino
		Dim PartidaPrev
		Dim CodCargo
		Dim NomeGuerra
		Dim SeqVoo
		Dim SeqTrecho
		Dim CombLocal
		Dim CombTotal
		Dim CombAbastec
		Dim CombPartidaMotor
		Dim CombDecolagem
		Dim CombCorteMotor
		Dim CombPouso
		

		Voo = ObjRs("nrvoo")
		Aeronave = ObjRs("prefixoaeronave") 
		Origem = ObjRs("Origem")
		Destino = ObjRs("Destino")
		CombLocal = ObjRs("comblocal")
      CombTotal = ObjRs("combtotal")
		CombAbastec = ObjRs("combabastec")
		If ObjRs.EOF Then 
			CombPartidaMotor = ""
			CombDecolagem = ""
			CombCorteMotor = ""
			CombPouso = ""
		Else
			CombPartidaMotor = ObjRs("combpartidamotor")
			CombDecolagem = ObjRs("combdecolagem")
			CombCorteMotor = ObjRs("combcortemotor")
			CombPouso = ObjRs("combpouso")
		End IF

	%>
      
		<form action="entradadosdiariobordo.asp?strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>&seqvoodia=<%=intSeqVooDia%>&seqtrecho=<%=intSeqTrecho%>" method="post" id="form1" name="form1">
			<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0' ID="Table1">
				<tr style="padding-top: 5px; padding-bottom: 5px">
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table2">
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Voo:									</td>
									<td style="padding-left: 5px">
										<%=Voo%>									</td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Aeronave:									</td>
									<td style="padding-left: 5px">
										<%=Aeronave%>									</td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Origem:									</td>
									<td style="padding-left: 5px">
										<%=Origem%>									</td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Destino:									</td>
									<td style="padding-left: 5px">
										<%=Destino%>									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Partida Prev.:									</td>
									<td style="padding-left: 5px">
										<%=strPartidaPrev%>									</td>
									<td colspan="2"></td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Chegada Prev.:									</td>
									<td style="padding-left: 5px">
										<%=strChegadaPrev%>									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Partida:									</td>
									<td style="padding-left: 5px">
										<%=strPartida%>									</td>
									<td colspan="2"></td>
									<td style="padding-left: 20px; font-weight: bold" align="right">
										Chegada:									</td>
									<td style="padding-left: 5px">
										<%=strChegada%>									</td>
								</tr>
							</table>
						</fieldset>					</td>
				</tr>
				<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<legend style="color: #000000;"><font style="font-weight: bold">Diário de Bordo:</font>&nbsp;</legend>
							<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table3">
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Diário de Bordo:									</td>
									<td style="padding-left: 5px"><span style="color: #000000;">
                           <input type="text" name="txtDiarioBordo" value="<%=strDiarioBordo%>" size="13" class="CORPO9" maxlength="20" style="text-transform:uppercase;" id="txtDiarioBordo" onKeyUp="SimulaTab(this);" onKeyDown="ChecarTAB();" onFocus="PararTAB(this);" tabindex="1"/>
                           </span></td>
								</tr>
							</table>
						</fieldset>					</td>
				</tr>
				<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
					<td style="padding-left: 50px; padding-right: 50px">
						<fieldset style="width: 98%">
							<legend style="color: #000000;"><font style="font-weight: bold">Horários:</font>&nbsp;</legend>
					<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table4">
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Partida motor:									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaPartidaMotor" value="<%=strDiaPartidaMotor%>" size="1" class="CORPO9" maxlength="2" id="txtDiaPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="2" />&nbsp;/
										<input type="text" name="txtMesPartidaMotor" value="<%=strMesPartidaMotor%>" size="1" class="CORPO9" maxlength="2" id="txtMesPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="3" />&nbsp;/
										<input type="text" name="txtAnoPartidaMotor" value="<%=strAnoPartidaMotor%>" size="3" class="CORPO9" maxlength="4" id="txtAnoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="4" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraPartidaMotor" value="<%=strHoraPartidaMotor%>" size="1" class="CORPO9" maxlength="2" id="txtHoraPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="5" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoPartidaMotor" value="<%=strMinutoPartidaMotor%>" size="1" class="CORPO9" maxlength="2" id="txtMinutoPartidaMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="6" />&nbsp;m									</td>
                           <td style="padding-left: 50px; font-weight: bold" align="right">
										Pouso:									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaPouso" value="<%=strDiaPouso%>" size="1" class="CORPO9" maxlength="2" id="txtDiaPouso" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="12" />&nbsp;/
										<input type="text" name="txtMesPouso" value="<%=strMesPouso%>" size="1" class="CORPO9" maxlength="2" id="txtMesPouso" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="13" />&nbsp;/
										<input type="text" name="txtAnoPouso" value="<%=strAnoPouso%>" size="3" class="CORPO9" maxlength="4" id="txtAnoPouso" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="14" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraPouso" value="<%=strHoraPouso%>" size="1" class="CORPO9" maxlength="2" id="txtHoraPouso" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="15" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoPouso" value="<%=strMinutoPouso%>" size="1" class="CORPO9" maxlength="2" id="txtMinutoPouso" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="16" />&nbsp;m									</td>
								</tr>
								<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Decolagem:									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaDecolagem" value="<%=strDiaDecolagem%>" size="1" class="CORPO9" maxlength="2" id="txtDiaDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="7" />&nbsp;/
										<input type="text" name="txtMesDecolagem" value="<%=strMesDecolagem%>" size="1" class="CORPO9" maxlength="2" id="txtMesDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="8" />&nbsp;/
										<input type="text" name="txtAnoDecolagem" value="<%=strAnoDecolagem%>" size="3" class="CORPO9" maxlength="4" id="txtAnoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="9" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraDecolagem" value="<%=strHoraDecolagem%>" size="1" class="CORPO9" maxlength="2" id="txtHoraDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="10" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoDecolagem" value="<%=strMinutoDecolagem%>" size="1" class="CORPO9" maxlength="2" id="txtMinutoDecolagem" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="11" />&nbsp;m									</td>
									<td style="padding-left: 50px; font-weight: bold" align="right">
										Corte motor:									</td>
									<td style="padding-left: 5px">
										<input type="text" name="txtDiaCorteMotor" value="<%=strDiaCorteMotor%>" size="1" class="CORPO9" maxlength="2" id="txtDiaCorteMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="17" />&nbsp;/
										<input type="text" name="txtMesCorteMotor" value="<%=strMesCorteMotor%>" size="1" class="CORPO9" maxlength="2" id="txtMesCorteMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="18" />&nbsp;/
										<input type="text" name="txtAnoCorteMotor" value="<%=strAnoCorteMotor%>" size="3" class="CORPO9" maxlength="4" id="txtAnoCorteMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="19" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="text" name="txtHoraCorteMotor" value="<%=strHoraCorteMotor%>" size="1" class="CORPO9" maxlength="2" id="txtHoraCorteMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="20" />&nbsp;h&nbsp;:&nbsp;
										<input type="text" name="txtMinutoCorteMotor" value="<%=strMinutoCorteMotor%>" size="1" class="CORPO9" maxlength="2" id="txtMinutoCorteMotor" onKeyDown="ChecarTAB();" onKeyPress="return SoNumeros(window.event.keyCode, this);" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="21" />&nbsp;m									</td>
								</tr>
							</table>
						</fieldset>					</td>
				</tr>
				<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
						<td style="padding-left: 50px; padding-right: 50px">
							<fieldset style="width: 98%">
								<legend style="color: #000000;"><font style="font-weight: bold">Combustível:</font>&nbsp;</legend>
								<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table5">
                            <tr class="CORPO9">
                             <td width="124" align="right" style="padding-left: 20px; font-weight: bold">
                                    Partida Motor: </td>
									<td width="29" style="padding-left: 5px">
										<input type="text" name="txtCombPartidaMotor" value="<%=CombPartidaMotor%>" size="4" class="CORPO9" maxlength="22" id="txtCombLocal" tabindex="22" onKeyDown="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);"/> </td>
                             <td width="124" align="right" style="padding-left: 20px; font-weight: bold">
         		                     Pouso: </td>
	                        <td width="29" style="padding-left: 5px">
  	      	                  <input type="text" name="txtCombPouso" value="<%=CombPouso%>" size="4" class="CORPO9" maxlength="20" id="txtCombPouso" tabindex="24" onKeyDown="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);"/>						</td>
                              <td width="124" align="right" style="padding-left: 20px; font-weight: bold">
                                    Cons. Etp(Kg): </td>
										<td width="175" style="padding-left: 5px">
										 <input type="text" name="txtCombTotal" value="<%=CombTotal%>" size="4" class="CORPO9" maxlength="20" id="txtCombTotal" onKeyDown="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" Disabled/>						</td>
     									 <input type="hidden" name="hdCombTotal" value="<%=CombTotal%>" size="4" maxlength="20" id="hdCombTotal" /></td>
                           </tr>
                            <tr class="CORPO9">
                              <td style="padding-left: 20px; font-weight: bold" align="right">
                                    Decolagem: </td>
										<td style="padding-left: 5px">
												<input type="text" name="txtCombDecolagem" value="<%=CombDecolagem%>" size="4" class="CORPO9" maxlength="20" id="txtCombLocal" onKeyDown="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" tabindex="23" /> </td> 
                              <td style="padding-left: 20px; font-weight: bold" align="right">
                                    Corte Motor: </td>
										<td style="padding-left: 5px">
												<input type="text" name="txtCombCorteMotor" onChange="CalculaCombTotal()" value="<%=CombCorteMotor%>" size="4" class="CORPO9" maxlength="20" id="txtCombLocal" tabindex="25"  onKeyDown="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" /> </td>      
 								</table>
                     </fieldset>   	                                
				<%
				Dim strFuncao

			  	If (Not ObjRsTrip.Eof) Then
				%>
					<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
						<td style="padding-left: 50px; padding-right: 50px">
							<fieldset style="width: 98%">
								<legend style="color: #000000;"><font style="font-weight: bold">Tripulantes:</font>&nbsp;</legend>
								<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table5">
								<%
								Do While Not ObjRsTrip.Eof
									CodCargo = ObjRsTrip("codcargo")
									NomeGuerra = ObjRsTrip("nomeguerra")
									strFuncao = ObjRsTrip("funcao")
									Select case strFuncao
										case "E"
											strFuncao = "[Extra]"
										case "J"
											strFuncao = "[Jump Seat]"
										case "C"
											strFuncao = "[Checador]"
										case "D"
											strFuncao = "[Re-Cheque]"
										case "R"
											strFuncao = "[Readaptação]"
										case "A"
											strFuncao = "[Aluno]"
										case "I"
											strFuncao = "[Instrutor]"
										case "O"
											strFuncao = "[Observador]"
									End Select
								%>
									<tr style="padding-top: 5px; padding-bottom: 5px" class="CORPO9">
									<td class="corpo" nowrap align="center">
									<td class="corpo" nowrap align="left"><%=CodCargo%> &nbsp;</td>
									<td class="corpo" nowrap align="left"><%=NomeGuerra%> &nbsp;</td>
									<td class="corpo" nowrap align="left"><%=strfuncao%> &nbsp;</td>
									</tr>                          
								<%
									ObjRsTrip.movenext
								loop
								%>
								</table>
							</fieldset>						</td>
					</tr>
				<%
			  	End If
			  	objRsTrip.Close
				%>

				<tr>
					<td width="100%" align="center" style="padding-top: 20px">
						<input type="submit" value="Gravar" name="btnGravar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnGravar" tabindex="30" onClick="Javascript: return VerificaCampos();" > 
						<input type="button" value="Voltar" name="btnVoltar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnVoltar" tabindex="31" onClick="Javascript: location.href='listagemdiariobordo.asp?strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>&voltar=voltar '"/>	</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<%
	Function CamposPreenchidosCorretamente(datDataPartidaMotor, datDataDecolagem)
		if (datDataPartidaMotor >= datDataDecolagem) then
			CamposPreenchidosCorretamente = false
			Response.Write("<script language='javascript'>alert('A data da partida motor deve ser menor do que a data da decolagem!');</script>")
		else
			CamposPreenchidosCorretamente = true
		end if
	end function
%>
