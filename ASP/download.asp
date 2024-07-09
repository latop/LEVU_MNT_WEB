<!--#include file="verificaloginaeropfunc.asp"-->

<%

'É necessário passar o nome do arquivo no FORM
Dim Arquivo
Arquivo = "apis.txt"

dataPrevista = request.QueryString("dataPrevista")
voo = request.QueryString("voo")

Response.Buffer = True
Response.AddHeader "Content-Type","application/x-msdownload"
Response.AddHeader "Content-Disposition","attachment; filename= APIS" & voo & "-" & dataPrevista & ".txt"
Response.Flush

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile Server.MapPath(Arquivo)
Response.BinaryWrite objStream.Read
objStream.Close
Set objStream = Nothing
Response.Flush

%>

