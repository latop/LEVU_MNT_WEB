<%
	Public Function f_auditoria(as_nometabela, as_sequsuario, as_comando, as_descricao, as_StringConexaoSqlServer)
		' *****************************************
		' *** SEQUENCIAL DA TABELA DE AUDITORIA ***
		' *****************************************
		Dim objRsSeq, strQuerySeq, intSeq
		strQuerySeq = " SELECT MAX(sig_auditoria.seqauditoria) seqauditoriamax FROM sig_auditoria "
		Set objRsSeq = Server.CreateObject("ADODB.Recordset")
		objRsSeq.Open strQuerySeq, objConn
		if (Not objRsSeq.EOF) then
			intSeq = objRsSeq("seqauditoriamax")
			if IsNull(intSeq) Then
				intSeq = 0
			Else
				intSeq = CLng(intSeq)
			End If
		else
			intSeq = CLng(0)
		end if
		objRsSeq.Close()
		Set objRsSeq = Nothing
		intSeq = intSeq + 1

		' ************************************
		' *** DADOS DA TABELA DE AUDITORIA ***
		' ************************************
		Dim ConnInsert, RsInsert, sSqlInsert
		Set ConnInsert = CreateObject("ADODB.CONNECTION")
		ConnInsert.Open (as_StringConexaoSqlServer)
		ConnInsert.Execute "SET DATEFORMAT ymd"

		sSqlInsert = " INSERT INTO sig_auditoria (seqauditoria, nometabela, dthralteracao, sequsuario, dominio, comando, descricao) "
		sSqlInsert = sSqlInsert & "  VALUES (" & intSeq & ", '" & as_nometabela & "', getdate(), " & as_SeqUsuario & ", 'A', '" & as_comando & "', '" & as_descricao & "') "
		set RsInsert = ConnInsert.Execute(sSqlInsert)
		ConnInsert.close
		f_auditoria = 1
	End Function
%>
