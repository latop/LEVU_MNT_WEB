<%
	Public Function gerarSequencial( ByVal as_nometabela, as_StringConexaoSqlServer )
	
		Dim ConnSeqBanco, RSSeqBanco
		Set ConnSeqBanco = CreateObject("ADODB.CONNECTION")
		ConnSeqBanco.Open (as_StringConexaoSqlServer)
		ConnSeqBanco.Execute "SET DATEFORMAT ymd"
		ConnSeqBanco.BeginTrans
		ConnSeqBanco.Execute( "UPDATE sig_seqbanco SET sequencial = sequencial + 1 WHERE nometabela = '" & as_nometabela & "' " )
		Set RSSeqBanco = ConnSeqBanco.Execute( "SELECT sequencial FROM sig_seqbanco WHERE nometabela = '" & as_nometabela & "' " )
		gerarSequencial = RSSeqBanco("sequencial")
		ConnSeqBanco.CommitTrans		
		ConnSeqBanco.Close
	End Function
%>

