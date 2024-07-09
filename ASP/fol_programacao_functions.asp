<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Gera Sequencial
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_sequencial( ByVal as_nometabela, ByVal as_coluna, as_StringConexaoSqlServer )
	Dim ConnSeqBanco, RSSeqBanco
	
	Set ConnSeqBanco = CreateObject("ADODB.CONNECTION")
	ConnSeqBanco.Open (as_StringConexaoSqlServer)
	ConnSeqBanco.Execute "SET DATEFORMAT ymd"
	
	ConnSeqBanco.BeginTrans
	ConnSeqBanco.Execute( "UPDATE sig_seqbanco SET sequencial = sequencial + 1 WHERE nometabela = '" & as_nometabela & "'" )
	Set RSSeqBanco = ConnSeqBanco.Execute( "SELECT sequencial FROM sig_seqbanco WHERE nometabela = '" & as_nometabela & "'" )
	f_sequencial = RSSeqBanco("sequencial")
	ConnSeqBanco.CommitTrans
	ConnSeqBanco.Close
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Recuperar a Distância entre as Bases
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_distancia( ByVal as_flgtipo, ByVal al_seqaeroporig, ByVal al_seqaeropdest, ByVal as_codfrota, ByVal as_codcargo, ByVal as_dthrinicio, ByVal as_dthrfim, ByVal al_seqatividade, ByRef aConn, ByRef aRS, ByRef astr_Erro )
   Dim ll_seqfrota
	
	If as_flgtipo = "V" Then
		Set aRS = aConn.Execute( "SELECT * FROM sig_distancia WHERE seqaeroportoorig = " & al_seqaeroporig & " AND seqaeroportodest = " & al_seqaeropdest )
		If NOT aRS.EOF Then
			f_distancia = CInt( aRS("distanciaesc") )
		Else
			astrErro = "Distância entre bases não cadastrada."
			f_distancia = 0
		End if
	Else
		Set aRS = aConn.Execute( "SELECT seqfrota FROM sig_frota WHERE codfrota = '" & as_codfrota & "'" )
		ll_seqfrota = aRS("seqfrota")
		Set aRS = aConn.Execute( "SELECT * FROM sig_atividadepagamento WHERE seqatividade="&al_seqatividade&" AND seqfrota="&ll_seqfrota&" AND codcargo='"&as_codcargo&"'" )
		If aRS.EOF Then
			f_distancia = 0
		Else
			f_distancia = CInt(aRS("kmhora")) * ( DateDiff("n", as_dthrinicio, as_dthrfim ) / 60 )
		End if
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Função para calcular o HrDiurna
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_hrdiurna( ByVal adt_dtjornada, ByVal adt_dthrinicio, ByVal adt_dthrfim, ByVal ab_diaesp1, ByVal ab_diaesp2 )
   Dim ldt_data_aux, ldt_dthrinicio_aux, ldt_dthrfim_aux, ldt_dtjornada_seg
	
	f_hrdiurna = 0
	
	If NOT IsDate( adt_dthrinicio ) OR NOT IsDate( adt_dthrfim ) Then
	   If NOT ab_diaesp1 Then
		   f_hrdiurna = 12
		End if
	Else
		' Calcula Horas Diurnas do primeiro dia
		ldt_data_aux = Day(adt_dthrinicio) & "-" & Month(adt_dthrinicio) & "-" & Year(adt_dthrinicio)
		
		If ( DateDiff( "d", adt_dtjornada, ldt_data_aux ) = 0 AND NOT ab_diaesp1 ) Then 'OR ( DateDiff( "d", adt_dtjornada, ldt_data_aux ) = 1 AND NOT ab_diaesp2 ) Then
			' Somente qdo não for dia especial
			ldt_dthrinicio_aux = adt_dthrinicio
			ldt_dthrfim_aux = adt_dthrfim
			
			If DateDiff( "n", adt_dthrinicio, ldt_data_aux & " 06:00" ) > 0 Then
				ldt_dthrinicio_aux = ldt_data_aux & " 06:00"
			End if
			
			If DateDiff( "n", adt_dthrfim, ldt_data_aux & " 18:00" ) < 0 Then
				ldt_dthrfim_aux = ldt_data_aux & " 18:00"
			End if
			
			If DateDiff( "n", ldt_dthrinicio_aux, ldt_dthrfim_aux ) > 0 Then
				f_hrdiurna = DateDiff( "n", ldt_dthrinicio_aux, ldt_dthrfim_aux )
			End if
		End if
		
		' Calcula Horas Diurnas do segundo dia
		ldt_data_aux = Day(adt_dthrfim) & "-" & Month(adt_dthrfim) & "-" & Year(adt_dthrfim)
		ldt_dtjornada_seg = DateAdd( "d", 1, adt_dtjornada )
		
		ldt_dthrinicio_aux = adt_dthrinicio
		ldt_dthrfim_aux = adt_dthrfim
		
		If ( DateDiff( "d", ldt_dtjornada_seg, ldt_data_aux ) = 0 AND NOT ab_diaesp2 ) Then
			' Somente qdo não for dia especial
			If DateDiff( "n", adt_dthrinicio, ldt_data_aux & " 06:00" ) > 0 Then
				ldt_dthrinicio_aux = ldt_data_aux & " 06:00"
			End if
			
			If DateDiff( "n", adt_dthrfim, ldt_data_aux & " 18:00" ) < 0 Then
				ldt_dthrfim_aux = ldt_data_aux & " 18:00"
			End if
			
			If DateDiff( "n", ldt_dthrinicio_aux, ldt_dthrfim_aux ) > 0 Then
				f_hrdiurna = f_hrdiurna + DateDiff( "n", ldt_dthrinicio_aux, ldt_dthrfim_aux )
			End if
		End if
		
		' Converte a diferença calculada em Minutos para Horas
		f_hrdiurna = f_hrdiurna / 60
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Função para calcular o HrNoturna
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_hrnoturna( ByVal adt_dtjornada, ByVal adt_dthrinicio, ByVal adt_dthrfim, ByVal ab_diaesp1, ByVal ab_diaesp2 )
   Dim ldt_data_aux, ldt_dthrinicio_aux, ldt_dthrfim_aux, ldt_dtjornada_seg
	
	f_hrnoturna = 0
	
	If NOT IsDate( adt_dthrinicio ) OR NOT IsDate( adt_dthrfim ) Then
	   If NOT ab_diaesp1 Then
	   	f_hrnoturna = 12
		End if
	Else
		ldt_data_aux = Day(adt_dthrinicio) & "-" & Month(adt_dthrinicio) & "-" & Year(adt_dthrinicio)
		
		ldt_dthrinicio_aux = adt_dthrinicio
		ldt_dthrfim_aux = adt_dthrfim
		ldt_dtjornada_seg = DateAdd( "d", 1, adt_dtjornada )
		
		If ( DateDiff( "d", adt_dtjornada, ldt_data_aux ) = 0 AND NOT ab_diaesp1 ) Then
			' Calcula horas para o primeiro dia
			If DateDiff( "n", adt_dthrfim, ldt_dtjornada_seg & " 00:00" ) < 0 Then
				ldt_dthrfim_aux = ldt_dtjornada_seg & " 00:00"
			End if
			
			f_hrnoturna = (DateDiff("n",ldt_dthrinicio_aux,ldt_dthrfim_aux)/60 )- f_hrdiurna(adt_dtjornada,ldt_dthrinicio_aux,ldt_dthrfim_aux,ab_diaesp1,ab_diaesp2 )
		End if
		
		ldt_data_aux = Day(adt_dthrfim) & "-" & Month(adt_dthrfim) & "-" & Year(adt_dthrfim)
		
		ldt_dthrinicio_aux = adt_dthrinicio
		ldt_dthrinicio_aux = adt_dthrinicio
		ldt_dthrfim_aux = adt_dthrfim
		
		If ( DateDiff( "d", ldt_dtjornada_seg, ldt_data_aux ) = 0 AND NOT ab_diaesp2 ) Then
			' Se for o segundo dia
			If DateDiff( "n", ldt_dthrinicio_aux, ldt_dtjornada_seg & " 00:00" ) > 0 Then
				ldt_dthrinicio_aux = ldt_dtjornada_seg & " 00:00"
			End if
			
			f_hrnoturna = f_hrnoturna + (DateDiff("n",ldt_dthrinicio_aux,ldt_dthrfim_aux)/60 )- f_hrdiurna(adt_dtjornada,ldt_dthrinicio_aux,ldt_dthrfim_aux,ab_diaesp1,ab_diaesp2 )
		End if
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Recuperar a Função Bordo
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_funcaobordo( ByVal as_funcao, ByRef aConn, ByRef aRS )
	Set aRS = aConn.Execute( "SELECT codfuncaobordo FROM sig_funcaobordo WHERE codredfuncaobordo = '" & as_funcao & "'" )
	If NOT aRS.EOF Then
		f_funcaobordo = aRS("codfuncaobordo")
	Else
		f_funcaobordo = ""
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Recuperar CODIATA/CODICAO do Aeroporto
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_aeroporto( ByVal al_seqaeroporto, ByVal as_StringConexaoSqlServer )
	Dim ConnAerop, RSAerop
	
	f_aeroporto = ""
	
	If al_seqaeroporto > "" Then
		Set ConnAerop = CreateObject("ADODB.CONNECTION")
		ConnAerop.Open (as_StringConexaoSqlServer)
		ConnAerop.Execute "SET DATEFORMAT ymd"
		
		Set RSAerop = ConnAerop.Execute( "SELECT codiata, codicao FROM sig_aeroporto WHERE seqaeroporto = " & al_seqaeroporto )
		
		If Not RSAerop.EOF Then
			If IsNull( RSAerop("codiata") ) Then
				f_aeroporto = RSAerop("codicao")
			Else
				f_aeroporto = RSAerop("codiata")
			End if
		End if
		
		ConnAerop.Close
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Recupera Atividade
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_atividade( ByVal al_seqatividade, ByRef as_codtipoatividade, ByRef aConn, ByRef aRS )
	Set aRS = aConn.Execute( "SELECT codatividade, codtipoatividade FROM sig_atividade WHERE seqatividade = " & al_seqatividade )
	If NOT aRS.EOF Then
		f_atividade = aRS("codatividade")
		as_codtipoatividade = aRS("codtipoatividade")
	Else
	   f_atividade = ""
		as_codtipoatividade = ""
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Retorna Menor Data/Hora
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_menordatahora( ByVal adt_datahora1, ByVal adt_datahora2 )
   If IsDate( adt_datahora1 ) AND IsDate( adt_datahora2 ) Then
	   If DateDiff( "n", adt_datahora1, adt_datahora2 ) > 0 Then
		   f_menordatahora = adt_datahora1
		Else
		   f_menordatahora = adt_datahora2
		End if
	Else
	   If ( NOT IsDate( adt_datahora1 ) ) AND IsDate( adt_datahora2 ) Then
			f_menordatahora = adt_datahora2
		ElseIf IsDate( adt_datahora1 ) AND ( NOT IsDate( adt_datahora2 ) ) Then
		   f_menordatahora = adt_datahora1
		Else
		   f_menordatahora = ""
		End if
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Retorna Maior Data/Hora
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_maiordatahora( ByVal adt_datahora1, ByVal adt_datahora2 )
   If IsDate( adt_datahora1 ) AND IsDate( adt_datahora2 ) Then
	   If DateDiff( "n", adt_datahora1, adt_datahora2 ) < 0 Then
		   f_maiordatahora = adt_datahora1
		Else
		   f_maiordatahora = adt_datahora2
		End if
	Else
	   If NOT IsDate( adt_datahora1 ) AND IsDate( adt_datahora2 ) Then
			f_maiordatahora = adt_datahora2
		ElseIf IsDate( adt_datahora1 ) AND NOT IsDate( adt_datahora2 ) Then
		   f_maiordatahora = adt_datahora1
		Else
		   f_maiordatahora = ""
		End if
	End if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Recupera Parametros
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_parametros( ByRef al_tempoapresentacao, ByRef al_tempocorte, ByRef aConn, ByRef aRS )
	Set aRS = aConn.Execute( "SELECT tempoapresentacao, tempocorte FROM sig_parametros" )
	If NOT aRS.EOF Then
	   al_tempoapresentacao = aRS("tempoapresentacao")
		al_tempocorte = aRS("tempocorte")
	Else
	   al_tempoapresentacao = 0
		al_tempocorte = 0
	End if
	
	f_parametros = ""
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Verifica se é feriado
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_isferiado( ByVal adt_dataref, ByVal al_seqcidade, ByRef aConn, ByRef aRS )
   Dim ls_sql
	f_isferiado = False
	
	If WeekDay( adt_dataref ) = 1 Then
		f_isferiado = True
	Else
		ls_sql = "SELECT * FROM sig_feriado WHERE dtferiado='"&Year(adt_dataref)&"/"&Month(adt_dataref)&"/"&Day(adt_dataref)&"' AND seqcidade="&al_seqcidade
	   Set aRS = aConn.Execute( ls_sql )
		f_isferiado = NOT aRS.EOF
	End if
End Function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Ordenar a Programação
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function f_ordena_programacao( ByVal al_linhaprog_vet, ByVal adt_dthrinicio_vet )
	Dim ll_contador, ll_contador_aux, ldt_dthrmenor, ll_menor
	
	f_ordena_programacao = ""
	
	For ll_contador = 1 TO UBound( al_linhaprog_vet )
		ll_menor = 0
		ldt_dthrmenor = "01/01/2100 23:00"
		For ll_contador_aux = 1 TO UBound( al_linhaprog_vet )
		   If NOT IsDate( adt_dthrinicio_vet(ll_contador_aux) ) Then
				ll_menor = ll_contador_aux
				ldt_dthrmenor = "01/01/1900 00:00"
			Else
			   If DateDiff( "n", ldt_dthrmenor, adt_dthrinicio_vet(ll_contador_aux) ) < 0 Then
				   ll_menor = ll_contador_aux
					ldt_dthrmenor = adt_dthrinicio_vet(ll_contador_aux)
				End if
			End if
		Next
		
		f_ordena_programacao = f_ordena_programacao & ll_menor & ","
		
		adt_dthrinicio_vet(ll_menor) = "01/01/2100 23:00"
	Next
	
	If f_ordena_programacao > "" Then
	   f_ordena_programacao = Split( "," & Left( f_ordena_programacao, Len(f_ordena_programacao) - 1 ), "," )
	End if
	
End Function
%>
