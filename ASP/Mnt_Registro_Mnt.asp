<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<%' Response.Charset ="ISO-8859-1" %>
<!--#include file="libgeral.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">  
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script type="text/javascript">  
	$(document).ready(function() {
		$('table#Table3 tbody  tr').hover(function(){
			$(this).css("background-color","#CCCC00");
		}, function(){
			$(this).css("background-color","");
		});
	});
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SIGLA - Registro de Manutenção</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>
<body>
<%
Dim SeqTrecho
Dim SeqVooDia
Dim strSqlSelect, strSqlFrom, strSqlWhere, strQuery
Dim objRs  
Dim objRsFuso, strSqlSelectFuso, strSqlFromFuso, strSqlWhereFuso, strQueryFuso
Dim intFusoGMT
Dim objConn
Dim strSelectMnt , RS
Dim strDia, strMes, strAno

	SeqVooDia = Request.QueryString("SeqVooDia")
	SeqTrecho = Request.QueryString("SeqTrecho")
	strDia = Request.QueryString("strDia")
   strMes = Request.QueryString("strMes")
   strAno = Request.QueryString("strAno")

	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	strSqlSelectFuso =                  " SELECT sig_aeropfuso.fusogmt "
	strSqlFromFuso =                    " FROM sig_aeropfuso sig_aeropfuso, sig_aeroporto sig_aeroporto, sig_diariovoo sig_diariovoo "
	strSqlWhereFuso =                   " WHERE sig_aeropfuso.seqaeroporto = sig_aeroporto.seqaeroporto "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_aeroporto.codicao = 'SBBR' "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_aeropfuso.dtinicio <= sig_diariovoo.dtoper "
	strSqlWhereFuso = strSqlWhereFuso & "   AND (sig_aeropfuso.dtfim >= sig_diariovoo.dtoper OR sig_aeropfuso.dtfim IS NULL) "
	strSqlWhereFuso = strSqlWhereFuso & "   AND sig_diariovoo.seqvoodia=" & SeqVooDia
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



	strSqlSelect =                " SELECT sig_diariovoo.nrvoo, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.dtoper, "
	strSqlSelect = strSqlSelect & "        sig_diariovoo.seqvoodia, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.seqtrecho, "
	strSqlSelect = strSqlSelect & "        sig_diariotrecho.prefixoaeronave, "
	strSqlSelect = strSqlSelect & "        aeroporig.seqaeroporto as seqaeroporig, "	      ' linha posta pelo hugo
	strSqlSelect = strSqlSelect & "        aeropdest.seqaeroporto as seqaeropdest, "	      ' linha posta pelo hugo
	strSqlSelect = strSqlSelect & "        aeroporig.codiata Origem, "
	strSqlSelect = strSqlSelect & "        aeropdest.codiata Destino, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.nat, "
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.comblocal,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combnf,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combabastec,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combtotal,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combna,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combfat,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.combvalor,"
	strSqlSelect = strSqlSelect & "        sig_diariotrechodb.diariobordo, "
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
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqvoodia = " & SeqVooDia & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqtrecho = " & SeqTrecho & " "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto "
	strSqlWhere = strSqlWhere &   "   AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto "

	strQuery = strSqlSelect & strSqlFrom & strSqlWhere

	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn
	
	' *******************************************
	' *** PARTIDA PREVISTA / CHEGADA PREVISTA ***
	' ***          PARTIDA / CHEGADA          ***
	' *******************************************
	Dim strHora, strData, strMinuto, strPartidaPrev, strChegadaPrev, strPartida, strChegada, seqaeroporig, seqaeropdest
	
	seqaeroporig = ObjRs("seqaeroporig")
	seqaeropdest = ObjRs("seqaeropdest")
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
	strQueryTrip = strQueryTrip & "    AND DIARIOVOO.seqvoodia = " & SeqVooDia & " "
	strQueryTrip = strQueryTrip & "    AND DIARIOTRECHO.seqvoodia = " & SeqVooDia & " "
	strQueryTrip = strQueryTrip & "    AND DIARIOTRECHO.seqtrecho = " & SeqTrecho & " "
	strQueryTrip = strQueryTrip & " ORDER BY CARGO.ordem, PROGRAMACAO.funcao, TRIPULANTE.nomeguerra "
	Set objRsTrip = Server.CreateObject("ADODB.Recordset")
	objRsTrip.Open strQueryTrip, objConn

	strSelectMnt = 					"Select techlogbook.seqteclog, techlogbook.descrdiscrep , techlogbook.descrmnt From sig_technicallogbook as techlogbook "
	strSelectMnt = strSelectMnt & "Where techlogbook.seqvoodia = '" & SeqVooDia & "' AND techlogbook.seqtrecho = '" & SeqTrecho & "' "

	
'	strSelectMnt = 					"Select diariotrechodbmnt.seqmnt, diariotrechodbmnt.descrdiscrep , diariotrechodbmnt.descrmnt From sig_diariotrechodbmnt as diariotrechodbmnt "
'	strSelectMnt = strSelectMnt & "Where diariotrechodbmnt.seqvoodia = '" & SeqVooDia & "' AND diariotrechodbmnt.seqtrecho = '" & SeqTrecho & "' "
	
	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSelectMnt, objConn
	
%>
<center>
<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
   <tr>
      <td class="corpo" align="left" valign="middle" width="35%">
         <img src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center">
         <font size="4"><b>&nbsp;Registro de Manutenção</b></font><br /><br />
      </td>
      <td class="corpo" align="right" valign="top" width="35%" colspan="20">
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
			Dim Seqmnt, Descrdiscrep, Descrmnt
			Dim DiarioBordo
			Dim CodCargo
			Dim NomeGuerra
			
			DiarioBordo = ObjRs("diariobordo")
			Voo = ObjRs("nrvoo")
			Aeronave = ObjRs("prefixoaeronave") 
			Origem = ObjRs("Origem")
			Destino = ObjRs("Destino")
			CodCargo = ObjRsTrip("codcargo")
			NomeGuerra = ObjRsTrip("nomeguerra")
			
			
		 Dim Cor1, Cor2
       Dim Cor, CorAtual, intContador	
		 
    	 Cor1 = "#FFFFFF"
		 Cor2 = "#EEEEEE"
		
 		%>
      
		<form method="post" id="form1" name="form1">
      	
			<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0' ID="Table1">
				<tr style="padding-top: 5px; padding-bottom: 5px">
					<td style="padding-left: 51px; padding-right: 50px">
						<fieldset style="width: 98%">
							<input type="hidden" name="hiddenDiarioBordo" id="hiddenDiarioBordo" value="<%=request.QueryString("diarioBordo")%>"/>
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
						</fieldset>              </td>
				</tr>
            <tr style="padding-top: 5px; padding-bottom: 5px">
					<td style="padding-left: 30px; padding-right: 50px">   
                   <table width="97%" border="1" cellpadding="0" align="center" cellspacing="0" Id="Table3" >
                    <thead>
                      <tr bgcolor="#AAAAAA" class="Corpo8Bold">
                        <td width="4%" align="center" >Nº</td>
                        <td width="53%" align="center" >Reporte da Discrepância</td>
                        <td width="43%" align="center" >Ação de Manutenção</td>
                      </tr>
                    </thead>
                    <tbody>    

<% Do While Not RS.Eof
      if ((intContador MOD 2) = 0) then
			Cor = Cor1
		else
			Cor = Cor2
      end if
		
		Seqmnt = RS("seqteclog")
		Descrdiscrep = RS("descrdiscrep")			
		Descrmnt = RS("descrmnt")		
		
		NomeGuerra =  replace(NomeGuerra, " ", "%20")
  '    Response.Write("<tr class='Corpo8' bgcolor="& Cor & " style='cursor:pointer;cursor:hand' onclick=window.location.href='Mnt_Registro_Detalhes.asp?SeqVooDia="& SeqVooDia &"&SeqTrecho="& SeqTrecho &"&Seqmnt="& Seqmnt &"&Origem="& Origem & "&Destino="& Destino &"&DiarioBordo="& DiarioBordo &"&NomeGuerra=&middot;"& NomeGuerra &"&middot;&CodCargo="&CodCargo &"&strDia=" & strDia &"&strMes=" & strMes & "&strAno=" & strAno & "' ><a href='Mnt_Registro_Detalhes.asp?SeqVooDia="& SeqVooDia &"&SeqTrecho="& SeqTrecho &"&Seqmnt="& Seqmnt &"&Origem="& Origem & "&Destino="& Destino &"&DiarioBordo="& DiarioBordo &"&NomeGuerra="& NomeGuerra &"&CodCargo="&CodCargo &"&strDia=" & strDia &"&strMes=" & strMes & "&strAno=" & strAno & "'>")
		Response.Write("<tr class='Corpo8' bgcolor="& Cor & " style='cursor:pointer;cursor:hand' onclick=window.location.href='mnt1_registro.asp?seqteclog=" & seqmnt & "&lk=true&diariobordo=" & request.QueryString("diarioBordo") & "&aeronave=" & aeronave & "lk=true&from=mnt&data1=" & strPartidaPrev & "' ><a href='mnt1_registro.asp?seqteclog=" & seqmnt & "&lk=true&from=mnt&data1=" & strPartidaPrev & "'>")  
		If Not IsNULL(Seqmnt) Then 
		  Response.Write("<td align='center' class='Corpo8Bold'>"& Seqmnt &"</td>")
		Else
		  Response.Write(  "<td align='center'>-</td>")
		End If
		If Descrdiscrep <> "" Then   
		  Response.Write(  "<td>"& Descrdiscrep &"</td>")
		Else
		  Response.Write(  "<td>&nbsp;</td>")
		End IF
		If Descrmnt <> "" Then     
        Response.Write(  "<td>"& Descrmnt &"</td>")
		Else  
		  Response.Write(  "<td>&nbsp;</td>")
      End IF
		Response.Write("</a></tr>")
		
		intContador = intContador + 1	
	RS.movenext	
	Loop
%>				
						  </tbody>	
					    </table>              </td>
            </tr>     						
         </table>
         <br />
         

        
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <input type="button"  class="botao1" onClick="location.href='Mnt1_Registro.asp?Origem=<%=Origem%>&Destino=<%=Destino%>&DiarioBordo=<%=DiarioBordo%>&NomeGuerra=<%=NomeGuerra%>&CodCargo=<%=CodCargo%>&Seqmnt=<%=Seqmnt%>&SeqVooDia=<%=SeqVooDia%>&SeqTrecho=<%=SeqTrecho%>&strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>&seqaeroporig=<%=seqaeroporig%>&seqaeropdest=<%=seqaeropdest%>&aeronave=<%=Aeronave%>&voo=<%=Voo%>&lk=true'" value="Novo Registro" /> &nbsp;&nbsp;<input type="button" value="Voltar" class="botao1" ID="btnVoltar" tabindex="31" onClick="location.href='entradadosdiariobordo.asp?seqvoodia=<%=SeqVooDia%>&seqtrecho=<%=SeqTrecho%>&strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>'"/> 
      </form>       
      
<%

  objConn.close
  Set objRs = Nothing
  Set objConn = Nothing
  Set RS = Nothing
%>
         
</body>
</html>
