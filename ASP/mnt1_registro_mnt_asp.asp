<!--#include file="verificaloginfuncionario.asp"-->

<%

Sub PreencherData1()
	if (isDate(request.form("txt_data1"))) then
		response.write(request.form("txt_data1"))
	else
		if ( isDate(request.QueryString("data1")) ) then
			response.write(request.QueryString("data1"))
		else
			response.write("")
		end if
	end if
end sub

Sub PreencherData2()
	if (isDate(request.form("txt_data2"))) then
		response.write(request.form("txt_data2"))
	else
		if ( isDate(request.QueryString("data2")) ) then
			response.write(request.QueryString("data2"))
		else
			response.write("")
		end if
	end if
end sub

Sub PreencherTLB()
	response.write(request.form("txt_TLB"))
end sub

Sub PreencherItem()
	response.write(request.form("txt_Item"))
end sub

Sub PreencherFrota()
	Dim Conn, Rs
	Dim ll_contador, ll_seqfrota_vet, ll_seqfrota, ls_codfrota_vet

	ll_seqfrota = Request.Form("cmbFrota")

	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)

	Set Rs = Conn.Execute( "SELECT seqfrota, codfrota FROM sig_frota ORDER BY codfrota ASC" )
	ll_seqfrota_vet = ""
	ls_codfrota_vet = ""
	Do While NOT Rs.EOF
		ll_seqfrota_vet = ll_seqfrota_vet & "," & Rs("seqfrota")
		ls_codfrota_vet = ls_codfrota_vet & "," & Rs("codfrota")
		Rs.MoveNext
	Loop

	ll_seqfrota_vet = Split(ll_seqfrota_vet,",")
	ls_codfrota_vet = Split(ls_codfrota_vet,",")

	For ll_contador = 1 To UBound(ll_seqfrota_vet)
		Response.Write( "<option value=" & ll_seqfrota_vet(ll_contador) )
		If ll_seqfrota > "" Then
			If CInt(ll_seqfrota_vet(ll_contador)) = CInt(ll_seqfrota) Then
				Response.Write(" selected")
			End if
		End if
		Response.Write(">" & ls_codfrota_vet(ll_contador) & "</option>")
	Next

	conn.close
	set Conn = nothing
	set Rs = nothing

end sub

Sub PreencherAeronave()
	Response.Write(Request.Form("txt_Aeronave"))
end sub

Sub PreencherCmbAeronave()
	Dim Conn, Rs
	Dim ll_contador, ll_prefixo_vet, ll_prefixo, ls_prefixored_vet

	ll_prefixo = Request.Form("cmbAeronave")

	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)

	Set Rs = Conn.Execute( "SELECT prefixo, prefixored FROM sig_aeronave ORDER BY prefixored ASC" )
	ll_prefixo_vet = ""
	ls_prefixored_vet = ""
	Do While NOT Rs.EOF
		ll_prefixo_vet = ll_prefixo_vet & "," & Rs("prefixo")
		ls_prefixored_vet = ls_prefixored_vet & "," & Rs("prefixored")
		Rs.MoveNext
	Loop

	ll_prefixo_vet = Split(ll_prefixo_vet,",")
	ls_prefixored_vet = Split(ls_prefixored_vet,",")

	For ll_contador = 1 To UBound(ll_prefixo_vet)
		Response.Write( "<option value=" & ls_prefixored_vet(ll_contador) )
		If ll_prefixo > "" Then
			If (ls_prefixored_vet(ll_contador) = ll_prefixo) Then
				Response.Write(" selected")
			End if
		End if
		Response.Write(">" & ls_prefixored_vet(ll_contador) & "</option>")
	Next

	conn.close
	set Conn = nothing
	set Rs = nothing

end sub

Sub PreencherAta100()
	Dim rsResult, SQL, objConn, espaco
	Dim selecionou
	Dim itemValor

	selecionou = false
	SQL = "SELECT * FROM sig_ata100 ORDER BY codata,codsubata ASC"
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.open(StringConexaoSqlServer)
	Set rsResult = Server.CreateObject("ADODB.Recordset")
	rsResult.Open SQL, objConn

	Dim ll_codatasubata
	ll_codatasubata = Request.Form("cmbAta100")
	if (not isVazio(ll_codatasubata)) then
		ll_codatasubata = ucase(ll_codatasubata)
		selecionou = true
	end if

	while not rsResult.eof
		itemValor = Right( "00" & rsResult("codata"), 2 ) & "-" & Right( "00"&rsResult("codsubata"),2)

		if (selecionou = false) then 'se não selecionei nada, simplesmente exibo todos sem marcar nenhum
			response.write("<option value='" & itemValor & "'>" & itemValor & espaco & "&nbsp;&nbsp;" & rsResult("descrata") & "</option>" )
		else 'se tem algum selecionado como parametro
			if itemValor = ll_codatasubata then
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
end sub

Sub PreencherTabelaManutencao()
	Dim Conn, RS, i
	Dim data1, data2, SQL
	Dim ll_seqfrota, ll_prefixo, ll_TLB, ll_item, ll_codatasubata, ll_codata, ll_codsubata

	if not (isDate(Request.QueryString("data1"))) then
		data1 = Request.Form("txt_Data1")
	else
		data1 = Request.QueryString("data1")
	end if

	if not (isDate(Request.QueryString("data2"))) then
		data2 = Request.Form("txt_Data2")
	else
		data2 = Request.QueryString("data2")
	end if

	if (not isDate(data2)) then
		data2 = data1
	end if

	ll_seqfrota = Request.Form("cmbFrota")
	ll_prefixo = Request.Form("txt_Aeronave")
	ll_TLB = Request.Form("txt_TLB")
	ll_item = Request.Form("txt_Item")
	ll_codatasubata = Split( Request.Form("cmbAta100"), "-" )

	Dim Cor1, Cor2, Cor, intContador	

	if (isDate(data2) and isDate(data1)) then
		SQL = " SELECT TLB.* "
		SQL = SQL & " FROM SIG_TECHNICALLOGBOOK TLB "
		if (not isVazio(ll_seqfrota)) then
			SQL = SQL & " INNER JOIN SIG_AERONAVE AER ON AER.prefixored = TLB.prefixo "
		end if
		SQL = SQL & " WHERE TLB.DTREGISTRO BETWEEN '" & year(data1) & "." & month(data1) & "." & day(data1) & "' "
		SQL = SQL & " AND '" & year(data2) & "." & month(data2) & "." & day(data2) & "' "
		if (not isVazio(ll_seqfrota)) then
			SQL = SQL & " AND AER.seqfrota = " & ll_seqfrota & " "
		end if
		if (not isVazio(ll_prefixo)) then
			SQL = SQL & " AND TLB.prefixo = '" & ll_prefixo & "' "
		end if
		if (not isVazio(ll_TLB)) then
			SQL = SQL & " AND TLB.diariobordo = '" & ll_TLB & "' "
		end if
		if (not isVazio(ll_item)) then
			SQL = SQL & " AND TLB.item = '" & ll_item & "' "
		end if
		If UBound(ll_codatasubata) > 0 Then
			ll_codata = CInt(Right( "00" & ll_codatasubata(0), 2 ))
			ll_codsubata = CInt(Right( "00" & ll_codatasubata(1), 2 ))
			SQL = SQL & " AND TLB.codata = " & ll_codata & " "
			SQL = SQL & " AND TLB.codsubata = " & ll_codsubata & " "
		End if
		SQL = SQL & " ORDER BY TLB.dtregistro, TLB.diariobordo, TLB.item, TLB.seqteclog "

		Set Conn = CreateObject("ADODB.CONNECTION")
		Conn.Open (StringConexaoSqlServer)
		Conn.Execute "SET DATEFORMAT ymd"
		Conn.Execute sql
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open sql, Conn
			
		intContador = CInt(0)
		Cor1 = "#FFFFFF"
		Cor2 = "#EEEEEE"
		do while not rs.eof 
				
			if ((intContador MOD 2) = 0) then
				Cor = Cor1
			else
				Cor = Cor2
			end if			
			response.write("<tr style='cursor:hand' class='corpo8' bgcolor=" & Cor & " onClick=window.location='mnt1_registro.asp?seqteclog=" & rs("seqteclog") )
			Response.Write("&data1=" & data1 & "&data2=" & data2 & "'> ")
			response.write("<td align='center'>" & rs("diariobordo") & "</td>")
			response.write("<td align='center'>" & rs("item") & "</td>")
			response.write("<td align='center'>" & Trim(rs("basestation")) & "</td>")
			response.write("<td>" & rs("descrdiscrep") & "&nbsp;</td>")
			response.write("<td>" & rs("descrmnt") & "&nbsp;</td>")			
			response.write("</tr>")			
			response.write(chr(13))
			response.write("					")
			intContador = intContador + 1
			rs.movenext
		loop
	
		conn.close
		set conn = nothing
		set rs = nothing

	else
		response.write("")
	end if
end sub

function isVazio(var)
	if (isempty(var) or isnull(var) or (Trim(var) = "")) then
		isVazio = true
	else
		isVazio = false
	end if
end function

%>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.tablesorter.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<script type="text/javascript">  
		$(document).ready(function() {
			$('table#Table3 tbody  tr').hover(function(){
				$(this).css("background-color","#CCCC00");
				}, function(){
				$(this).css("background-color","");
			});
		});
		$(document).ready(function() {
			$('#Table3').tableSorter();	 
		});
		
		$(document).ready(function($){
			$.mask.addPlaceholder('~',"[+-]");
			$("#txt_Data1").mask("99/99/9999");
			$("#txt_Data2").mask("99/99/9999");
			$("#txt_TLB").mask("999/aa-aaa/99-99");
       });
	   
	   
	 
</script>