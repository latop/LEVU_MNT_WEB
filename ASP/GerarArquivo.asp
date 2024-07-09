<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<%

Dim objConn, sSql, Rs, ls_sql
Dim Diretorio, strDriveName, strFile, objDrive, strDriveType, R, objFS, Arquivo, Agora, ate 
Dim sql_Empresa, Rs_Empresa
Dim PaxEmb
Dim objText
Dim ls_HoraA, ls_HoraB

ls_HoraA = DateAdd("n", -30, Now())
ls_HoraB = DateAdd("h", 12, Now())

Set objConn = CreateObject("ADODB.CONNECTION")
objConn.Open(StringConexaoSqlServer)
objConn.Execute "SET DATEFORMAT ymd"

ls_sql = "                SELECT sig_diariovoo.nrvoo, sig_diariovoo.idjustificativa, sig_diariovoo.statusvoo, "
ls_sql  = ls_sql & "         sig_diariovoo.dtoper, "
ls_sql = ls_sql & "          sig_diariotrecho.partidamotor , sig_diariotrecho.cortemotor , sig_diariotrecho.decolagem , sig_diariotrecho.pouso , "
ls_sql = ls_sql & "          sig_diariotrecho.partidaplanej , sig_diariotrecho.chegadaplanej , sig_diariotrecho.partidaprev, sig_diariotrecho.chegadaprev , "
ls_sql = ls_sql & "          sig_diariotrecho.seqvoodia, "
ls_sql = ls_sql & "          sig_diariotrecho.seqtrecho, "
ls_sql = ls_sql & "          sig_frota.codfrota, sig_diariotrecho.seqfrota , sig_frota.seqfrota, "
ls_sql = ls_sql & "          sig_diariotrecho.prefixoaeronave, sig_aeronave.prefixo, "
ls_sql = ls_sql & "          sig_diariotrecho.paxprimeira, sig_diariotrecho.paxeconomica, sig_diariotrecho.paxespecial, sig_diariotrecho.paxturismo, sig_diariotrecho.paxpago, "
ls_sql = ls_sql & "          aeroporig.codicao AS Origem, "
ls_sql = ls_sql & "          aeropdest.codicao AS Destino "
ls_sql = ls_sql & "       FROM sig_diariovoo sig_diariovoo, "
ls_sql = ls_sql & "          sig_diariotrecho sig_diariotrecho, "
ls_sql = ls_sql & "          sig_aeroporto aeroporig, "
ls_sql = ls_sql & "          sig_aeroporto aeropdest, sig_frota, sig_aeronave "
ls_sql = ls_sql & "          WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia  "
ls_sql = ls_sql & "          AND sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto " 
ls_sql = ls_sql & "          AND sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto "
ls_sql = ls_sql & "          AND sig_frota.seqfrota = sig_diariotrecho.seqfrota " 
ls_sql = ls_sql & "          AND sig_aeronave.prefixored = sig_diariotrecho.prefixoaeronave "
ls_sql = ls_sql & "          AND ( sig_diariotrecho.partidaprev BETWEEN '" & Year(ls_HoraA) & "/" & Month(ls_HoraA) & "/" & Day(ls_HoraA) & " " & Right("00" & Hour(ls_HoraA),2) & ":" & Right("00" & Minute(ls_HoraA),2)  & "' AND '" & Year(ls_HoraB) & "/" & Month(ls_HoraB) & "/" & Day(ls_HoraB) & " " & Right("00" & Hour(ls_HoraB),2) & ":" & Right("00" & Minute(ls_HoraB),2) & "') "
ls_sql = ls_sql & "          AND ((sig_diariotrecho.flgcapturadec <> 'N' or sig_diariotrecho.flgcapturadec is null)) "
ls_sql = ls_sql & "          AND (((sig_diariotrecho.flgcapturapou <> 'N' or sig_diariotrecho.flgcapturapou is null))) "
ls_sql = ls_sql & "          ORDER BY sig_diariotrecho.partidaprev "


Set RS = objConn.Execute( ls_sql )
'Response.Write(ls_sql)
'Response.End()

Set objFS = Server.CreateObject("Scripting.FileSystemObject")
strFile = Request.ServerVariables("SCRIPT_NAME")
strFile = Server.MapPath(strFile)
strDriveName = objFS.GetDriveName(strFile)
'		
Set objDrive = objFS.GetDrive(strDriveName)
'		
'response.write "Letra do Drive = " & objDrive.DriveLetter & "<br>"
'response.write "path = " & objDrive.Path & "<br>"
'response.write "File System = " & objDrive.FileSystem & "<br>"
'response.write "root folder = " & objDrive.RootFolder & "<br>"
'response.write " arquivo = " & strFile & "<br/>"			

ate = instrRev(strFile, "\", -1,1)
		
diretorio = Mid(strFile, 1, ate)

'response.Write("diretorio = " & diretorio)
'		
if objDrive.IsReady = true then
		'response.write "<br/>drive pronto para acesso" & "<br>"
else
		response.write " <br/>drive sem permissão para acesso" & "<br>"
end if
set objDrive = Nothing

Agora = now()

' NOME DO ARQUIVO A SER GERADO

Arquivo = diretorio & year(Agora) & right("00" & month(Agora),2) & right("00" & day(Agora),2) & right("0" & hour(Agora),2) & right("0" & minute(Agora),2) & right("0" & second(Agora),2) & "ONE.txt"		
'Arquivo = "teste.txt"


response.write("gerando o arquivo <b>" & arquivo & "</b> no servidor...<br/>")

'////////////  FIM TESTES SOBRE O SERVIDOR E AS PASTAS

Set objFS = Server.CreateObject("Scripting.FileSystemObject")

Set objText = objFS.CreateTextFile(Arquivo, true, false) ' arquivo no formato ASCII

Session("gereiApis") = true

Dim ls_body
Dim ll_count_linhas
Dim ll_Voo, ls_Prefixo, ls_Frota, ls_Origem, ls_Destino, ls_StatusVoo, ls_Justificativa
Dim ll_Ano_PartidaPlanej, ll_Mes_PartidaPlanej, ll_Dia_PartidaPlanej, ls_Hora_PartidaPlanej
Dim ll_Ano_ChegadaPlanej, ll_Mes_ChegadaPlanej, ll_Dia_ChegadaPlanej, ls_Hora_ChegadaPlanej
Dim ll_Ano_PartidaPrev, ll_Mes_PartidaPrev, ll_Dia_PartidaPrev, ls_Hora_PartidaPrev
Dim ll_Ano_ChegadaPrev, ll_Mes_ChegadaPrev, ll_Dia_ChegadaPrev, ls_Hora_ChegadaPrev
Dim ll_Ano_PartidaMotor, ll_Mes_PartidaMotor, ll_Dia_PartidaMotor, ls_Hora_PartidaMotor
Dim ll_Ano_CorteMotor, ll_Mes_CorteMotor, ll_Dia_CorteMotor, ls_Hora_CorteMotor
Dim ll_Ano_Decolagem, ll_Mes_Decolagem, ll_Dia_Decolagem, ls_Hora_Decolagem
Dim ll_Ano_Pouso, ll_Mes_Pouso, ll_Dia_Pouso, ls_Hora_Pouso
Dim ll_paxprimeira, ll_paxeconomica, ll_paxespecial, ll_paxturismo, ll_paxpago
Dim ll_Trecho

If Not RS.EOF Then
	Do While Not RS.EOF
		ll_Voo = RS("nrvoo")
		ls_Prefixo = RS("prefixo")
		ls_Frota = RS("codfrota") 
		ls_Origem = RS("ORIGEM") 
		ls_Destino = RS("DESTINO")
		ls_StatusVoo = RS("statusvoo")
		Response.Write(ll_Voo & "," & ls_Prefixo & "," & ls_Frota & "," & ls_Origem & "," & ls_Destino & "," & ls_StatusVoo)
		ls_body = ll_Voo & "," & ls_Prefixo & "," & ls_Frota & "," & ls_Origem & "," & ls_Destino & "," & ls_StatusVoo
		If Not IsNull(RS("idjustificativa")) Then
			ls_Justificativa = RS("idjustificativa")			
		Else
			ls_Justificativa = ""
		End If		
		Response.Write("," & ls_Justificativa)
		ls_body = ls_body & "," & ls_Justificativa
		If IsDate(RS("partidaplanej")) Then
			ll_Ano_PartidaPlanej = Year(RS("partidaplanej"))
			ll_Mes_PartidaPlanej = Right("00" & Month(RS("partidaplanej")),2)
			ll_Dia_PartidaPlanej = Right("00" & Day(RS("partidaplanej")),2)
			ls_Hora_PartidaPlanej = FormatDatetime(RS("partidaplanej"),4)
		Else
			ll_Ano_PartidaPlanej = ""
			ll_Mes_PartidaPlanej = ""
			ll_Dia_PartidaPlanej = ""
			ls_Hora_PartidaPlanej = ""
		End If				
		Response.Write(","& ll_Ano_PartidaPlanej & ll_Mes_PartidaPlanej & ll_Dia_PartidaPlanej &" "& ls_Hora_PartidaPlanej)
		ls_body = ls_body & ","& ll_Ano_PartidaPlanej & ll_Mes_PartidaPlanej & ll_Dia_PartidaPlanej &" "& ls_Hora_PartidaPlanej 
		If IsDate(RS("chegadaplanej")) Then
			ll_Ano_ChegadaPlanej = Year(RS("chegadaplanej"))
			ll_Mes_ChegadaPlanej = Right("00" & Month(RS("chegadaplanej")),2)
			ll_Dia_ChegadaPlanej = Right("00" & Day(RS("chegadaplanej")),2)
			ls_Hora_ChegadaPlanej = FormatDateTime(RS("chegadaplanej"),4)
		Else
			ll_Ano_ChegadaPlanej = ""
			ll_Mes_ChegadaPlanej = ""
			ll_Dia_ChegadaPlanej = ""
			ls_Hora_ChegadaPlanej = ""
		End If	
		Response.Write(","& ll_Ano_ChegadaPlanej & ll_Mes_ChegadaPlanej & ll_Dia_ChegadaPlanej &" "& ls_Hora_ChegadaPlanej)
		ls_body = ls_body & ","& ll_Ano_ChegadaPlanej & ll_Mes_ChegadaPlanej & ll_Dia_ChegadaPlanej &" "& ls_Hora_ChegadaPlanej
		If IsDate(RS("partidaprev")) Then
			ll_Ano_PartidaPrev = Year(RS("partidaprev"))
			ll_Mes_PartidaPrev = Right("00" & Month(RS("partidaprev")),2)
			ll_Dia_PartidaPrev = Right("00" & Day(RS("partidaprev")),2)
			ls_Hora_PartidaPrev = FormatDateTime(RS("partidaprev"),4)
		Else
			ll_Ano_PartidaPrev = ""
			ll_Mes_PartidaPrev = ""
			ll_Dia_PartidaPrev = ""
			ls_Hora_PartidaPrev = ""
		End If	
		Response.Write(","& ll_Ano_PartidaPrev & ll_Mes_PartidaPrev & ll_Dia_PartidaPrev &" "& ls_Hora_PartidaPrev)
			ls_body = ls_body & ","& ll_Ano_PartidaPrev & ll_Mes_PartidaPrev & ll_Dia_PartidaPrev &" "& ls_Hora_PartidaPrev
		If IsDate(RS("chegadaprev")) Then
			ll_Ano_ChegadaPrev = Year(RS("chegadaprev"))
			ll_Mes_ChegadaPrev = Right("00" & Month(RS("chegadaprev")),2)
			ll_Dia_ChegadaPrev = Right("00" & Day(RS("chegadaprev")),2)
			ls_Hora_ChegadaPrev = FormatDateTime(RS("chegadaprev"),4)
		Else
			ll_Ano_ChegadaPrev = ""
			ll_Mes_ChegadaPrev = ""
			ll_Dia_ChegadaPrev = ""
			ls_Hora_ChegadaPrev = ""
		End If
		Response.Write(","& ll_Ano_ChegadaPrev & ll_Mes_ChegadaPrev & ll_Dia_ChegadaPrev &" "& ls_Hora_ChegadaPrev)
		ls_body = ls_body & ","& ll_Ano_ChegadaPrev & ll_Mes_ChegadaPrev & ll_Dia_ChegadaPrev &" "& ls_Hora_ChegadaPrev
		If IsDate(RS("partidamotor")) Then
			ll_Ano_PartidaMotor = Year(RS("partidamotor"))
			ll_Mes_PartidaMotor = Right("00" & Month(RS("partidamotor")),2)
			ll_Dia_PartidaMotor = Right("00" & Day(RS("partidamotor")),2)
			ls_Hora_PartidaMotor = FormatDateTime(RS("partidamotor"),4)
		Else
			ll_Ano_PartidaMotor = ""
			ll_Mes_PartidaMotor = ""
			ll_Dia_PartidaMotor = ""
			ls_Hora_PartidaMotor = ""
		End If
		Response.Write(","& ll_Ano_PartidaMotor & ll_Mes_PartidaMotor & ll_Dia_PartidaMotor &" "& ls_Hora_PartidaMotor)
		ls_body = ls_body & ","& ll_Ano_PartidaMotor & ll_Mes_PartidaMotor & ll_Dia_PartidaMotor &" "& ls_Hora_PartidaMotor
		If IsDate(RS("cortemotor")) Then
			ll_Ano_CorteMotor = Year(RS("cortemotor"))
			ll_Mes_CorteMotor = Right("00" & Month(RS("cortemotor")),2)
			ll_Dia_CorteMotor = Right("00" & Day(RS("cortemotor")),2)
			ls_Hora_CorteMotor = FormatDateTime(RS("cortemotor"),4)
		Else
			ll_Ano_CorteMotor = ""
			ll_Mes_CorteMotor = ""
			ll_Dia_CorteMotor = ""
			ls_Hora_CorteMotor = ""
		End IF
		Response.Write(","& ll_Ano_CorteMotor & ll_Mes_CorteMotor & ll_Dia_CorteMotor &" "& ls_Hora_CorteMotor)
		ls_body = ls_body & ","& ll_Ano_CorteMotor & ll_Mes_CorteMotor & ll_Dia_CorteMotor &" "& ls_Hora_CorteMotor
		If IsDate(RS("decolagem")) Then
			ll_Ano_Decolagem = Year(RS("decolagem"))
			ll_Mes_Decolagem = Right("00" & Month(RS("decolagem")),2)
			ll_Dia_Decolagem = Right("00" & Day(RS("decolagem")),2)
			ls_Hora_Decolagem = FormatDateTime(RS("decolagem"),4)
		Else
			ll_Ano_Decolagem = ""
			ll_Mes_Decolagem = ""
			ll_Dia_Decolagem = ""
			ls_Hora_Decolagem = ""
		End If
		Response.Write(","& ll_Ano_Decolagem & ll_Mes_Decolagem & ll_Dia_Decolagem &" "& ls_Hora_Decolagem)
		ls_body = ls_body & ","& ll_Ano_Decolagem & ll_Mes_Decolagem & ll_Dia_Decolagem &" "& ls_Hora_Decolagem
		If IsDate(RS("pouso")) Then
			ll_Ano_Pouso = Year(RS("pouso"))
			ll_Mes_Pouso = Right("00" & Month(RS("pouso")),2)
			ll_Dia_Pouso = Right("00" & Day(RS("pouso")),2)
			ls_Hora_Pouso = FormatDateTime(RS("pouso"),4)
		Else
			ll_Ano_Pouso = ""
			ll_Mes_Pouso = ""
			ll_Dia_Pouso = ""
			ls_Hora_Pouso = ""
		End If
		Response.Write(","& ll_Ano_Pouso & ll_Mes_Pouso & ll_Dia_Pouso &" "& ls_Hora_Pouso)
		ls_body = ls_body & ","& ll_Ano_Pouso & ll_Mes_Pouso & ll_Dia_Pouso &" "& ls_Hora_Pouso
		ll_Trecho = Right("00" & RS("seqtrecho"),2)
		If IsNumeric(RS("paxprimeira")) Then
			ll_paxprimeira = CInt(RS("paxprimeira"))
		Else
			ll_paxprimeira = "0"
		End If	
		If IsNumeric(RS("paxeconomica")) Then
			ll_paxeconomica = CInt(RS("paxeconomica")) 
		Else
			ll_paxeconomica = "0"
		End If	
		If IsNumeric(RS("paxespecial")) Then
			ll_paxespecial = CInt(RS("paxespecial"))
		Else
			ll_paxespecial = "0"
		End If	
		If IsNumeric(RS("paxturismo")) Then
			ll_paxturismo = CInt(RS("paxturismo"))
		Else
			ll_paxturismo = "0"
		End If	
		If IsNumeric(RS("paxpago")) Then
			ll_paxpago = CInt(RS("paxpago"))
		Else
			ll_paxpago = "0"
		End If		
		
		PaxEmb = CInt(ll_paxprimeira + ll_paxeconomica + ll_paxespecial + ll_paxturismo + ll_paxpago)
		'ls_body = RS("nrvoo") & "," & RS("prefixo") & "," & RS("codfrota") & "," & RS("ORIGEM") & "," & RS("DESTINO") & "," & RS("idjustificativa") & "," & Year(RS("partidaplanej")) & Right("00" & Month(RS("partidaplanej")),2) & Right("00" & Day(RS("partidaplanej")),2) &" "& FormatDatetime(RS("partidaplanej"),4) & "," & Year(RS("chegadaplanej")) & Right("00" & Month(RS("chegadaplanej")),2) & Right("00" & Day(RS("chegadaplanej")),2) &" "& FormatDateTime(RS("chegadaplanej"),4) &","& Year(RS("partidaprev")) & Right("00" & Month(RS("partidaprev")),2) & Right("00" & Day(RS("partidaprev")),2) &" "& FormatDateTime(RS("partidaprev"),4) &","& Year(RS("chegadaprev")) & Right("00" & Month(RS("chegadaprev")),2) & Right("00" & Day(RS("chegadaprev")),2) &" "& FormatDateTime(RS("chegadaprev"),4) &","& Year(RS("partidamotor")) & Right("00" & Month(RS("partidamotor")),2) & Right("00" & Day(RS("partidamotor")),2) &" "& FormatDateTime(RS("partidamotor"),4) &","& Year(RS("cortemotor")) & Right("00" & Month(RS("cortemotor")),2) & Right("00" & Day(RS("cortemotor")),2) &" "& FormatDateTime(RS("cortemotor"),4) &","& Year(RS("decolagem")) & Right("00" & Month(RS("decolagem")),2) & Right("00" & Day(RS("decolagem")),2) &" "& FormatDateTime(RS("decolagem"),4) &","& Year(RS("pouso")) & Right("00" & Month(RS("pouso")),2) & Right("00" & Day(RS("pouso")),2) &" "& FormatDateTime(RS("pouso"),4) &","& Right("00" & RS("seqtrecho"),2) &","& PaxEmb &","& "0"
		objText.WriteLine(ls_body)
		'll_count_linhas = ll_count_linhas + 1		
		Response.Write(","& Right("00" & RS("seqtrecho"),2) & "," & PaxEmb &","& "0")
		Response.Write("<br>")
		ls_body = ls_body & ","& Right("00" & RS("seqtrecho"),2) & "," & PaxEmb &","& "0"
		objText.WriteLine(ls_body)
		'Response.End()
		RS.MoveNext
	Loop		  
End If	
objText.close
objConn.close
Set Rs = Nothing
Set objConn = Nothing

%>
</body>
</html>
