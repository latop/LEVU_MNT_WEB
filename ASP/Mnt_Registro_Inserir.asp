<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="libgeral.asp"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<%
Dim Rs
Dim objConn
Dim SelectMnt
Dim SeqVooDia, SeqTrecho, Seqmnt
Dim ll_SeqVooDia 
Dim ll_SeqTrecho
Dim ll_Seqmnt
Dim Descrdiscrep
Dim Descrmnt
Dim Ata100
Dim Acaomnt
Dim codanac
Dim oleoe1 
Dim oleoe2
Dim oleoe3
Dim oleoe4
Dim oleoapu
Dim oleoha1g
Dim oleohb2b
Dim oleoh3sy
Dim SqlInsert
Dim Basestation
Dim SqlUpdate
Dim ll_Gravar
Dim strDia, strMes, strAno
Dim ls_pnremovido, ls_snremovido, ls_pninstalado, ls_sninstalado, ldt_dtacaomnt, ls_posatualremov, ls_posatualinst

Set objConn = CreateObject("ADODB.CONNECTION")
objConn.Open (StringConexaoSqlServer)
objConn.Execute "SET DATEFORMAT ymd"

ll_SeqVooDia = Request.Form("SeqVooDia")
ll_SeqTrecho = Request.Form("SeqTrecho")
ll_Seqmnt = Request.Form("Seqmnt")
Descrdiscrep = Request.Form("Descrdiscrep")
Descrmnt = Request.Form("Descrmnt")
ll_Gravar = Request.Form("Gravar")

strDia = Request.QueryString("strDia")
strMes = Request.QueryString("strMes")
strAno = Request.QueryString("strAno")
Ata100 = Request.Form("Ata100")
Basestation = Request.Form("basestation")	
Acaomnt = Request.Form("Acaomnt")
codanac = Request.Form("codanac")
oleoe1 = Request.Form("E1")
oleoe2 = Request.Form("E2")
oleoe3 = Request.Form("E3")
oleoe4 = Request.Form("E4")
oleoapu = Request.Form("APU")
oleoha1g = Request.Form("HA1G")
oleohb2b = Request.Form("HB2B")
oleoh3sy = Request.Form("H3SY")
ls_pnremovido = Request.Form("pnremovido")
ls_snremovido = Request.Form("snremovido")
ls_pninstalado = Request.Form("pninstalado")
ls_sninstalado = Request.Form("sninstalado")
ldt_dtacaomnt = Request.Form("dtacaomnt")
ls_posatualremov = Request.Form("posatualremov")
ls_posatualinst = Request.Form("posatualinst")

' Valida Data da Manutenção
If ldt_dtacaomnt > "" Then
	If Not IsDate( ldt_dtacaomnt ) Then
		Response.Write("<script language='javascript'>")
		Response.Write("alert('Data da Ação de Manutenção Inválida!');history.go(-1);")
		Response.Write("</script>")
		Response.End()
	End if
End if
 
Set objConn = CreateObject("ADODB.CONNECTION")
objConn.Open (StringConexaoSqlServer)
objConn.Execute "SET DATEFORMAT ymd"

If ll_Gravar = "Insert" Then
	SelectMnt =              "Select Max( seqmnt ) as seqmnt "     
	SelectMnt = SelectMnt &  "From sig_diariotrechodbmnt "
	SelectMnt = SelectMnt &  "Where seqvoodia = " & ll_SeqVooDia & " AND seqtrecho = " & ll_SeqTrecho
	
	Set RS = objConn.Execute(SelectMnt)
	
	If NOT RS.EOF Then
		ll_Seqmnt = RS("seqmnt")
		
		If IsNull( ll_Seqmnt ) Then
			ll_SeqMnt = 0
		End if
	Else
		ll_SeqMnt = 0
	End If
	
	ll_SeqMnt = CInt( ll_SeqMnt ) + 1
			
	SqlInsert =  				" Insert INTO sig_diariotrechodbmnt (seqmnt, descrdiscrep, descrmnt, ata100, acaomnt, codanac, oleoe1, oleoe2, basestation, "   
	SqlInsert = SqlInsert & "   oleoe3, oleoe4, oleoapu, oleoha1g, oleohb2b, oleoh3sy, seqvoodia, seqtrecho, pnremovido, snremovido, pninstalado,"
	SqlInsert = SqlInsert & "   sninstalado, dtacaomnt, posatualremov, posatualinst)"
	SqlInsert = SqlInsert & " VALUES	('" & ll_Seqmnt & "','"& Descrdiscrep &"','"& Descrmnt &"',"
	
	If Ata100 = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & Ata100 & "',"
	End If   
	
	If Acaomnt = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & Acaomnt & "',"
	End If   
	
	If codanac = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & codanac & "',"
	End If   
	
	If oleoe1 = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoe1 & "',"
	End If   
	
	If oleoe2 = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoe2 & "',"
	End If 
	
	If Basestation = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & Basestation & "',"
	End If   
	
	If oleoe3 = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoe3 & "',"
	End If
	
	If oleoe4 = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoe4 & "',"
	End If 
	
	If oleoapu = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoapu & "',"
	End If 
	
	If oleoha1g = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoha1g & "',"
	End If 
	
	If oleohb2b = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleohb2b & "',"
	End If 
	
	If oleoh3sy = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & oleoh3sy & "',"
	End If 
	
	SqlInsert = SqlInsert & ll_SeqVooDia & "," & ll_SeqTrecho & ", "
	
	If ls_pnremovido = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & ls_pnremovido & "',"
	End if
	
	If ls_snremovido = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & ls_snremovido & "',"
	End if
	
	If ls_pninstalado = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & ls_pninstalado & "',"
	End if
	
	If ls_sninstalado = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & ls_sninstalado & "',"
	End if
	
	If ldt_dtacaomnt = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & Year(ldt_dtacaomnt) & "/" & Right("00"&Month(ldt_dtacaomnt),2) & "/" & Right("00"&Day(ldt_dtacaomnt),2) & "',"
	End if
	
	If ls_posatualremov = "" Then
		SqlInsert = SqlInsert & "NULL,"
	Else
		SqlInsert = SqlInsert & "'" & ls_posatualremov & "',"
	End if
	
	If ls_posatualinst = "" Then
		SqlInsert = SqlInsert & "NULL)"
	Else
		SqlInsert = SqlInsert & "'" & ls_posatualinst & "')"
	End if
	
	Set RS = objConn.Execute(SqlInsert)
	
Else
  
	SqlUpdate =             " UPDATE sig_diariotrechodbmnt SET descrdiscrep = '" & Descrdiscrep & "', descrmnt='" & Descrmnt & "' "

	If Ata100 = "" Then
		SqlUpdate = SqlUpdate & ",ata100=NULL "
	Else
		SqlUpdate = SqlUpdate & ",ata100='" & Ata100 & "' "
	End If   

	If Acaomnt = "" Then
		SqlUpdate = SqlUpdate & ",acaomnt=NULL "
	Else
		SqlUpdate = SqlUpdate & ",acaomnt='" & Acaomnt & "' "
	End If   

	If codanac = "" Then
		SqlUpdate = SqlUpdate & ",codanac=NULL "
	Else
		SqlUpdate = SqlUpdate & ",codanac='" & codanac & "' "
	End If   

	If oleoe1 = "" Then
		SqlUpdate = SqlUpdate & ",oleoe1=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoe1='" & oleoe1 & "' "
	End If   

	If oleoe2 = "" Then
		SqlUpdate = SqlUpdate & ",oleoe2=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoe2='" & oleoe2 & "' "
	End If   
	
	If Basestation = "" Then
		SqlUpdate = SqlUpdate & ",basestation=NULL "
	Else
		SqlUpdate = SqlUpdate & ",basestation='" & Basestation & "' "
	End If   

	If oleoe3 = "" Then
		SqlUpdate = SqlUpdate & ",oleoe3=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoe3='" & oleoe3 & "' "
	End If   
	
	If oleoe4 = "" Then
		SqlUpdate = SqlUpdate & ",oleoe4=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoe4='" & oleoe4 & "' "
	End If   
	
	If oleoapu = "" Then
		SqlUpdate = SqlUpdate & ",oleoapu=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoapu='" & oleoapu & "' "
	End If   
	
	If oleoha1g = "" Then
		SqlUpdate = SqlUpdate & ",oleoha1g=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoha1g='" & oleoha1g & "' "
	End If   
	
	If oleohb2b = "" Then
		SqlUpdate = SqlUpdate & ",oleohb2b=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleohb2b='" & oleohb2b & "' "
	End If   
	
	If oleoh3sy = "" Then
		SqlUpdate = SqlUpdate & ",oleoh3sy=NULL "
	Else
		SqlUpdate = SqlUpdate & ",oleoh3sy='" & oleoh3sy & "' "
	End If   
	
	If ls_pnremovido = "" Then
		SqlUpdate = SqlUpdate & ",pnremovido=NULL "
	Else
		SqlUpdate = SqlUpdate & ",pnremovido='" & ls_pnremovido & "' "
	End If   
	
	If ls_snremovido = "" Then
		SqlUpdate = SqlUpdate & ",snremovido=NULL "
	Else
		SqlUpdate = SqlUpdate & ",snremovido='" & ls_snremovido & "' "
	End If   
	
	If ls_pninstalado = "" Then
		SqlUpdate = SqlUpdate & ",pninstalado=NULL "
	Else
		SqlUpdate = SqlUpdate & ",pninstalado='" & ls_pninstalado & "' "
	End If   
	
	If ls_sninstalado = "" Then
		SqlUpdate = SqlUpdate & ",sninstalado=NULL "
	Else
		SqlUpdate = SqlUpdate & ",sninstalado='" & ls_sninstalado & "' "
	End If   
	
	If ldt_dtacaomnt = "" Then
		SqlUpdate = SqlUpdate & ",dtacaomnt=NULL "
	Else
		SqlUpdate = SqlUpdate & ",dtacaomnt='" & Year(ldt_dtacaomnt) & "/" & Right("00"&Month(ldt_dtacaomnt),2) & "/" & Right("00"&Day(ldt_dtacaomnt),2) & "' "
	End If   

	If ls_posatualremov = "" Then
		SqlUpdate = SqlUpdate & ",posatualremov=NULL "
	Else
		SqlUpdate = SqlUpdate & ",posatualremov='" & ls_posatualremov & "' "
	End If   
	
	If ls_posatualinst = "" Then
		SqlUpdate = SqlUpdate & ",posatualinst=NULL "
	Else
		SqlUpdate = SqlUpdate & ",posatualinst='" & ls_posatualinst & "' "
	End If
	
	SqlUpdate = SqlUpdate & "WHERE  seqvoodia = '" & ll_SeqVooDia & "' AND seqtrecho = '" & ll_SeqTrecho & "' And sig_diariotrechodbmnt.seqmnt = '" & ll_Seqmnt & "' " 	
	Set RS = objConn.Execute(SqlUpdate)

End If    

objConn.Close

'Response.Write("<script language='javascript'>")
'Response.Write("alert('Operação Realizada com Sucesso!');")
'Response.Write("</script>")

Response.Redirect("Mnt_Registro_Mnt.asp?SeqVooDia=" & ll_SeqVooDia & "&SeqTrecho=" & ll_SeqTrecho & "&strDia=" & strDia &"&strMes=" & strMes & "&strAno=" & strAno)

%>	 
</body>
</html>
