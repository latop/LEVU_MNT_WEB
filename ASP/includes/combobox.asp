<%

Sub preencherComboSimples(tabela, colunaBuscar, itemMostrar, itemValor, selecionado)

'******************************************************************************* 
'*
'*		colunaBuscar pode ser "*"
'* 
'******************************************************************************* 
	Dim rsResult, SQL, objConn
	Dim selecionou
	selecionou = false
	SQL = "SELECT " + colunaBuscar + " FROM " + tabela	+ " ORDER BY " + itemMostrar + " ASC"
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.open(StringConexaoSqlServer)																					
	Set rsResult = Server.CreateObject("ADODB.Recordset")
	rsResult.Open SQL, objConn

	response.write("<option value=''></option>" )

	If ((Not IsEmpty(selecionado)) And (Not IsNull(selecionado)) And (Not (Trim(selecionado) = ""))) Then
		selecionado = ucase(selecionado)
		selecionou = true
	End If

	while not rsResult.eof
		if (selecionou = false) then 'se não selecionei nada, simplesmente exibo todos sem marcar nenhum
			response.write("<option value='" + rsResult(itemValor) + "'>" + rsResult(itemMostrar) + "</option>" )
		else                         'se tem algum selecionado como parametro
			if ucase(rsResult(itemValor)) = selecionado then
				response.write("<option value='" + rsResult(itemValor) + "' selected='selected'>" + rsResult(itemMostrar) + "</option>" )
			else
				response.write("<option value='" + rsResult(itemValor) + "'>" + rsResult(itemMostrar) + "</option>" )
			end if
		end if		
		rsResult.movenext
	wend
	
	objConn.close
	set rsResult = nothing
	set objConn = nothing
	
end Sub


%>
