<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="fol_programacao_functions.asp"-->
<SCRIPT TYPE="text/javascript">
<!-- 
//-->
</SCRIPT>

<html><head>
<title>SIGLA - Programação</TITLE>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<span style="font-family: arial ; sans-serif"  >
<script src="javascript.js"></script>

</head><body bgcolor="white" link="blue">

<STYLE type="text/css">
 TABLE { empty-cells: show; }
</style>

<%
Public Function f_permissao_gravacao( ByVal al_sequsuario, ByVal as_codfuncao, ByRef aConn, ByRef aRS )
   ' Recupera a Permissão do Usuário
	Dim intDominio

	intDominio = Session("dominio")

	If CInt( al_sequsuario ) = 1 Then
		f_permissao_gravacao = True
	ElseIf CInt( intDominio ) = 2 Then
		f_permissao_gravacao = False
	Else
		Set aRS = aConn.Execute( "SELECT * FROM sig_usuariofuncao WHERE sequsuario = " & al_sequsuario & " AND codfuncao = '" & as_codfuncao & "'" )
		
		If NOT aRS.EOF Then
			f_permissao_gravacao = ( aRS( "flgpermissao" ) = "A" )
		Else
			f_permissao_gravacao = False
		End if
	End if
End Function

Dim Conn, ConnVooAtividade, ConnInsPlanej, RS, RSVoo, RSAtividade, RSTrip
Dim ls_sqljornada, ls_sqlprog, ls_sqlvoo, ls_sqlinsplanej, ls_sqltrip, ls_sqlinsprog_vet(40), ls_sqlinsprog, ls_sqlalterajornada
Dim strGravar, strAdicionar, strExcluir, strErro, strMensagem, strErro_aux, strColumnErro, ll_pageopen, ls_type, ls_disable_voo, ls_disable_atividade
Dim lb_insereplanejado, ls_selecionado, lb_inserejornada, lb_permissao_gravacao, lb_fechar_janela
Dim ll_linhaprogramacao, ll_incrementolinha, ll_contador, ll_contador_aux, ldt_dthratividade, ldt_dthratividade_aux
Dim ls_flgpedido, ls_observacao_jornada, ls_textojornada, ls_textojornadaaux, ls_textojornadaant
Dim ll_seqtripulante, ldt_dtjornada, ll_dtjornada_dia, ll_dtjornada_mes, ll_dtjornada_ano, ll_dia_semana_dtjornada, ls_codcargo, ls_codfrota, ll_seqcidade
Dim ldt_dtjornada_seg, ldt_menorhoraprog, ldt_maiorhoraprog, ll_tempoapresentacao, ll_tempocorte
Dim ls_flgestado, ldt_dthralteracao, ldt_dthravisado, ldt_dthrapresentacaorealiz, ldt_dthrcorte, ldt_dthrapresentacao
Dim ll_seqjornada, ll_seqprogramacao, ll_qtdprogramacao, ls_siglaempresa_vet, ll_seqaeroporto_vet, ls_codicaoiata_vet, ll_seqjornadaant
Dim ls_codfuncaobordo_vet, ls_codredfuncaobordo_vet, ll_seqatividade_vet, ls_codatividade_vet, ll_nrvoo_vet
Dim ls_flgtipo, ls_flgtipo_orig, ls_siglaempresa, ls_siglaempresa_orig, ll_seqaeroporig, ll_seqaeropdest, ls_funcao, ls_funcao_ant
Dim ll_nrvoo, ll_nrvoo_ant, ll_nrvoo_orig, ll_seqatividade, ll_seqatividade_orig, ll_seqaeropatividade
Dim ll_dthrinicio_dia, ll_dthrinicio_mes, ll_dthrinicio_ano, ll_dthrinicio_hora, ll_dthrinicio_minuto, ls_dthrinicio_aux, ls_dthrinicioexec_aux
Dim ll_dthrfim_dia, ll_dthrfim_mes, ll_dthrfim_ano, ll_dthrfim_hora, ll_dthrfim_minuto, ls_dthrfim_aux, ls_dthrfimexec_aux
Dim ldt_partidamotor, ldt_cortemotor, ls_observacao, ls_codtipoatividade
Dim ll_seqvoodiaesc, ll_seqtrecho, ll_seqfrota, ls_tipovoo, ll_seqvooesc, ls_planejfreq_vet
Dim ll_kmnormal, ll_hrdiurna, ll_hrnoturna, ll_hrespdiurna, ll_hrespnoturna, lb_diaesp1, lb_diaesp2, ll_hrtotal
Dim ll_hrdiurnaexec, ll_hrnoturnaexec, ll_hrespdiurnaexec, ll_hrespnoturnaexec, ll_hrtotalexec
Dim ll_kmsav, ll_kmres, ll_kmvoo
Dim ll_prog_order_vet, ll_linhaprog_vet, ldt_dthrinicio_vet
Dim ls_usuario, ls_nomechage, ls_nomeguerra, ls_nomechave, ls_nomeavisado, ls_diasemana_vet

Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Set ConnVooAtividade = CreateObject("ADODB.CONNECTION")
ConnVooAtividade.Open (StringConexaoSqlServer)
ConnVooAtividade.Execute "SET DATEFORMAT ymd"

Set ConnInsPlanej = CreateObject("ADODB.CONNECTION")
ConnInsPlanej.Open (StringConexaoSqlServer)
ConnInsPlanej.Execute "SET DATEFORMAT ymd"

strGravar = Request.Form("btnGravar")
strAdicionar = Request.Form("btnAdicionar")
strExcluir = Request.Form("btnExcluir")
strErro = ""
strMensagem = ""

ldt_dtjornada = Request.QueryString("dtjornada")
ll_seqtripulante = Request.QueryString("seqtripulante")
ls_codcargo = Request.QueryString("codcargo")
ls_codfrota = Request.QueryString("codfrota")
ll_seqcidade = Request.QueryString("seqcidade")

ll_dtjornada_dia = Right("00"&Day( ldt_dtjornada ),2)
ll_dtjornada_mes = Right("00"&Month( ldt_dtjornada ),2)
ll_dtjornada_ano = Year( ldt_dtjornada )

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' GRAVAÇÃO DOS DADOS
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
If strGravar <> "" Then
	' Verifica se é dia especial para a Data Jornada e o dia seguinte
	lb_diaesp1 = f_isferiado( ldt_dtjornada, ll_seqcidade, Conn, RS )
	lb_diaesp2 = f_isferiado( DateAdd( "d", 1, ldt_dtjornada ), ll_seqcidade, Conn, RS )
	
	ldt_dthrapresentacaorealiz = Request.Form("dthrapresentacaorealiz")
	
	' Verificação dos Dados
   ll_qtdprogramacao = CInt(Request.Form("qtdprogramacao"))
	
	ll_linhaprog_vet = ""
	ldt_dthrinicio_vet = ""
	
	ll_contador = 1
	
	If ll_qtdprogramacao = 0 Then
		strErro = "Informe a Programação"
	End if
	
	Do While ll_contador <= ll_qtdprogramacao AND strErro = ""
		ls_flgtipo = Request.Form("flgtipo"&ll_contador)
		ls_flgtipo_orig = Request.Form("flgtipo_orig"&ll_contador)
		
		If ls_flgtipo = "" Then
		   strErro = "Informe o Tipo de Programação"
			strColumnErro = "flgtipo"&ll_contador
		ElseIf ls_flgtipo = "V" Then
			ls_funcao = Request.Form("funcao"&ll_contador)
			ll_nrvoo = Request.Form("nrvoo"&ll_contador)
			ll_nrvoo_orig = Request.Form("nrvoo_orig"&ll_contador)
			
			If ll_nrvoo = "" Then
			   strErro = "Informe o número do Voo"
				strColumnErro = "nrvoo" & ll_contador
			ElseIf IsNull( ls_funcao ) OR ls_funcao = "" OR NOT ( ls_funcao = "E" OR ls_funcao = "J" OR ls_funcao = "O" ) THEN
			   ' Verifica se o Tripulante está habilitado para Frota da Etapa
				ls_sqlvoo =             "SELECT * FROM sig_escdiariovoo, sig_escdiariotrecho "
				ls_sqlvoo = ls_sqlvoo & "WHERE sig_escdiariovoo.seqvoodiaesc = sig_escdiariotrecho.seqvoodiaesc "
				ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.dtoper = '" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "'"
				ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.nrvoo = " & ll_nrvoo
				
				Set RS = Conn.Execute( ls_sqlvoo )
				
				If NOT RS.Eof Then
					ll_seqfrota = RS("seqfrota")
					
					ls_sqltrip =              "SELECT COUNT(*) FROM sig_tripfrota "
					ls_sqltrip = ls_sqltrip & "WHERE sig_tripfrota.seqtripulante = " & ll_seqtripulante
					ls_sqltrip = ls_sqltrip &  " AND sig_tripfrota.seqfrota = " & ll_seqfrota
					ls_sqltrip = ls_sqltrip &  " AND sig_tripfrota.dtinicio <= '" & Year(ldt_dtjornada)&"/"&Month(ldt_dtjornada)&"/"&Day(ldt_dtjornada) & "' "
					ls_sqltrip = ls_sqltrip &  " AND (sig_tripfrota.dtfim >= '" & Year(ldt_dtjornada)&"/"&Month(ldt_dtjornada)&"/"&Day(ldt_dtjornada) & "' "
					ls_sqltrip = ls_sqltrip &        "OR sig_tripfrota.dtfim IS NULL)"
					
					Set RS = Conn.Execute( ls_sqltrip )
					
					If RS.EOF Then
					   strErro = "O Tripulante não está habilitado para Frota do Voo " & ll_nrvoo
					End if
				End if
			End if
		ElseIf ls_flgtipo = "A" Then
			ll_seqatividade = Request.Form("seqatividade"&ll_contador)
			
			If ll_seqatividade = "" Then
			   strErro = "Informe a Atividade"
				strColumnErro = "seqatividade" & ll_contador
			End if
		End If
		
		ll_dthrinicio_dia = Request.Form("dthrinicio_dia"&ll_contador)
		ll_dthrinicio_mes = Request.Form("dthrinicio_mes"&ll_contador)
		ll_dthrinicio_ano = Request.Form("dthrinicio_ano"&ll_contador)
		ll_dthrinicio_hora = Request.Form("dthrinicio_hora"&ll_contador)
		ll_dthrinicio_minuto = Request.Form("dthrinicio_minuto"&ll_contador)
		
		ls_dthrinicio_aux = ll_dthrinicio_dia & "/" & ll_dthrinicio_mes & "/" & ll_dthrinicio_ano & " " & ll_dthrinicio_hora & ":" & ll_dthrinicio_minuto
		
		ll_linhaprog_vet = ll_linhaprog_vet & ll_contador & ","
		ldt_dthrinicio_vet = ldt_dthrinicio_vet & ls_dthrinicio_aux & ","
		
		ll_dthrfim_dia = Request.Form("dthrfim_dia"&ll_contador)
		ll_dthrfim_mes = Request.Form("dthrfim_mes"&ll_contador)
		ll_dthrfim_ano = Request.Form("dthrfim_ano"&ll_contador)
		ll_dthrfim_hora = Request.Form("dthrfim_hora"&ll_contador)
		ll_dthrfim_minuto = Request.Form("dthrfim_minuto"&ll_contador)
		
		ls_dthrfim_aux = ll_dthrfim_dia & "/" & ll_dthrfim_mes & "/" & ll_dthrfim_ano & " " & ll_dthrfim_hora & ":" & ll_dthrfim_minuto
		
		If IsDate( ls_dthrinicio_aux ) AND IsDate( ls_dthrfim_aux ) Then
			If DateDiff( "n", ls_dthrinicio_aux, ls_dthrfim_aux ) <= 0 Then
				strErro = "A data de início deve ser menor que a data final"
				strColumnErro = "dthrinicio_dia"&ll_contador
			End if
		End if
		
		ll_contador = ll_contador + 1
	Loop
	
	If ll_qtdprogramacao > 0 Then
		ll_linhaprog_vet = Split( "," & Left( ll_linhaprog_vet, Len( ll_linhaprog_vet ) - 1 ), "," )
		ldt_dthrinicio_vet = Split( "," & Left( ldt_dthrinicio_vet, Len( ldt_dthrinicio_vet ) - 1 ), "," )
		
		ll_prog_order_vet = f_ordena_programacao( ll_linhaprog_vet, ldt_dthrinicio_vet )
	End if
	
	If strErro = "" Then
		''''''''''''''''''''''''''''''''''''''''''''''''''
		' Grava as alterações de SIG_JORNADA
		''''''''''''''''''''''''''''''''''''''''''''''''''
		ll_seqjornada = Request.Form("seqjornada")
		If Request.Form("flgpedido") = "on" Then
			ls_flgpedido = "S"
		Else
			ls_flgpedido = "N"
		End if
		ls_observacao_jornada = Request.Form("observacao")
		ls_textojornadaant = Request.Form("textojornada")
		ls_flgestado = Request.Form("flgestado")
		
		ll_seqjornadaant = ll_seqjornada
		If IsNull( ll_seqjornada ) OR ll_seqjornada = "" OR ls_flgestado = "P" Then
		   ' Cria novo sequencial de jornada
			ll_seqjornada = f_sequencial( "SIG_JORNADA", "", StringConexaoSqlServer )
			lb_inserejornada = True
		Else
		   lb_inserejornada = False
		End if
		
		ls_textojornada = ""
		ls_textojornadaaux = ""
		ldt_menorhoraprog = ""
		ldt_maiorhoraprog = ""
		ll_kmsav = 0
		ll_kmres = 0
		ll_kmvoo = 0
		ll_nrvoo_ant = 0
		ls_funcao_ant = ""
		
		'Response.Write( "<br>" )
		'For ll_contador = 0 to ll_qtdprogramacao
		'   Response.Write( "<br>" & ll_contador & " - " & ll_prog_order_vet(ll_contador) )
		'Next
		'Response.End()
		
		' Gera os Inserts da SIG_PROGRAMACAO
		For ll_contador_aux = 1 TO ll_qtdprogramacao
			ll_contador = ll_prog_order_vet(ll_contador_aux)
			
			ls_flgtipo = Request.Form("flgtipo"&ll_contador)
			ls_siglaempresa = Request.Form("siglaempresa"&ll_contador)
			ll_seqaeroporig = Request.Form("seqaeroporig"&ll_contador)
			ll_seqaeropdest = Request.Form("seqaeropdest"&ll_contador)
			ls_funcao = Request.Form("funcao"&ll_contador)
			ll_nrvoo = Request.Form("nrvoo"&ll_contador)
			ll_seqatividade = Request.Form("seqatividade"&ll_contador)
			ll_seqaeropatividade = Request.Form("seqaeropatividade"&ll_contador)
			ll_dthrinicio_dia = Request.Form("dthrinicio_dia"&ll_contador)
			ll_dthrinicio_mes = Request.Form("dthrinicio_mes"&ll_contador)
			ll_dthrinicio_ano = Request.Form("dthrinicio_ano"&ll_contador)
			ll_dthrinicio_hora = Request.Form("dthrinicio_hora"&ll_contador)
			ll_dthrinicio_minuto = Request.Form("dthrinicio_minuto"&ll_contador)
			ll_dthrfim_dia = Request.Form("dthrfim_dia"&ll_contador)
			ll_dthrfim_mes = Request.Form("dthrfim_mes"&ll_contador)
			ll_dthrfim_ano = Request.Form("dthrfim_ano"&ll_contador)
			ll_dthrfim_hora = Request.Form("dthrfim_hora"&ll_contador)
			ll_dthrfim_minuto = Request.Form("dthrfim_minuto"&ll_contador)
			ldt_partidamotor = Request.Form("partidamotor"&ll_contador)
			ldt_cortemotor = Request.Form("cortemotor"&ll_contador)
			ls_observacao = Request.Form("observacao"&ll_contador)
			ll_seqvoodiaesc = Request.Form("seqvoodiaesc"&ll_contador)
			ll_seqtrecho = Request.Form("seqtrecho"&ll_contador)
			ll_hrnoturna = 0
			ll_hrdiurna = 0
			
			' Verifica se o Tripulante está habilitado para Frota da Etapa
			
			If IsDate( ldt_partidamotor ) AND IsDate( ldt_cortemotor ) Then
				ls_dthrinicioexec_aux =Day(ldt_partidamotor)&"/"&Month(ldt_partidamotor)&"/"&Year(ldt_partidamotor)&" "&Hour(ldt_partidamotor)&":"&Minute(ldt_partidamotor)
				ls_dthrfimexec_aux = Day(ldt_cortemotor)&"/"&Month(ldt_cortemotor)&"/"&Year(ldt_cortemotor)&" "&Hour(ldt_cortemotor)&":"&Minute(ldt_cortemotor)
			End if
			
			ls_dthrinicio_aux = ll_dthrinicio_dia&"-"&ll_dthrinicio_mes&"-"&ll_dthrinicio_ano&" "&ll_dthrinicio_hora&":"&ll_dthrinicio_minuto
			ls_dthrfim_aux = ll_dthrfim_dia&"-"&ll_dthrfim_mes&"-"&ll_dthrfim_ano&" "&ll_dthrfim_hora&":"&ll_dthrfim_minuto
			
			' Verifica Menor Hora e Maior Hora (textojornadaaux)
			If IsDate( ldt_partidamotor ) AND IsDate( ldt_cortemotor ) Then
				ldt_menorhoraprog = f_menordatahora( ldt_menorhoraprog, ldt_partidamotor )
				ldt_maiorhoraprog = f_maiordatahora( ldt_maiorhoraprog, ldt_cortemotor )
			Else
				ldt_menorhoraprog = f_menordatahora( ldt_menorhoraprog, ls_dthrinicio_aux )
				ldt_maiorhoraprog = f_maiordatahora( ldt_maiorhoraprog, ls_dthrfim_aux )
			End if
		
			' Calcula a distância entre as bases (kmnormal)
			If ( ll_dthrinicio_dia > "" AND ll_dthrfim_dia > "" ) OR ls_flgtipo = "A" Then
				ll_kmnormal = f_distancia(ls_flgtipo,ll_seqaeroporig,ll_seqaeropdest,ls_codfrota,ls_codcargo,ls_dthrinicio_aux,ls_dthrfim_aux,ll_seqatividade,Conn,RS,strErro)
			Else
				ll_kmnormal = 0
			End if
			
			If ls_flgtipo = "V" Then
				If ll_nrvoo <> ll_nrvoo_ant OR ( ls_funcao <> ls_funcao_ant AND ll_nrvoo = ll_nrvoo_ant ) Then
					ls_textojornada = ls_textojornada & f_funcaobordo( ls_funcao, Conn, RS )
					ls_textojornada = ls_textojornada & ll_nrvoo & "/"
					ll_nrvoo_ant = ll_nrvoo
					ls_funcao_ant = ls_funcao
				End if
				ll_kmvoo = ll_kmvoo + ll_kmnormal
			Else
				ls_textojornada = ls_textojornada & f_atividade( ll_seqatividade, ls_codtipoatividade, Conn, RS )
				If ll_seqaeropatividade > "" Then
					ls_textojornada = ls_textojornada & "-" & f_aeroporto( ll_seqaeropatividade, StringConexaoSqlServer )
				End if
				ls_textojornada = ls_textojornada & "/"
				
				Select Case ls_codtipoatividade
					Case "SAV"
					   ll_kmsav = ll_kmsav + ll_kmnormal
					Case "RES"
					   ll_kmres = ll_kmres + ll_kmnormal
				End Select
			End if
			
			' Calcula as Horas
			ll_hrdiurna = Int(f_hrdiurna( ldt_dtjornada, ls_dthrinicio_aux, ls_dthrfim_aux, lb_diaesp1, lb_diaesp2 ) * 100) / 100
			ll_hrnoturna = Int(f_hrnoturna( ldt_dtjornada, ls_dthrinicio_aux, ls_dthrfim_aux, lb_diaesp1, lb_diaesp2 ) * 100 ) / 100
			ll_hrespdiurna = Int( f_hrdiurna( ldt_dtjornada, ls_dthrinicio_aux, ls_dthrfim_aux, NOT lb_diaesp1, NOT lb_diaesp2 ) * 100 ) / 100
			ll_hrespnoturna = Int( f_hrnoturna( ldt_dtjornada, ls_dthrinicio_aux, ls_dthrfim_aux, NOT lb_diaesp1, NOT lb_diaesp2 ) * 100 ) / 100
			ll_hrtotal = ll_hrdiurna + ll_hrnoturna + ll_hrespdiurna + ll_hrespnoturna
			
			If IsDate( ldt_partidamotor ) AND IsDate( ldt_cortemotor ) Then
				ll_hrdiurnaexec = Int(f_hrdiurna( ldt_dtjornada, ls_dthrinicioexec_aux, ls_dthrfimexec_aux, lb_diaesp1, lb_diaesp2 ) * 100) / 100
				ll_hrnoturnaexec = Int(f_hrnoturna( ldt_dtjornada, ls_dthrinicioexec_aux, ls_dthrfimexec_aux, lb_diaesp1, lb_diaesp2 ) * 100) / 100
				ll_hrespdiurnaexec = Int(f_hrdiurna( ldt_dtjornada, ls_dthrinicioexec_aux, ls_dthrfimexec_aux, NOT lb_diaesp1, NOT lb_diaesp2 ) * 100) / 100
				ll_hrespnoturnaexec = Int(f_hrnoturna( ldt_dtjornada, ls_dthrinicioexec_aux, ls_dthrfimexec_aux, NOT lb_diaesp1, NOT lb_diaesp2 ) * 100) / 100
				ll_hrtotalexec = ll_hrdiurnaexec + ll_hrnoturnaexec + ll_hrespdiurnaexec + ll_hrespnoturnaexec
			Else
				ll_hrdiurnaexec = ll_hrdiurna
				ll_hrnoturnaexec = ll_hrnoturna
				ll_hrespdiurnaexec = ll_hrespdiurna
				ll_hrespnoturnaexec = ll_hrespnoturna
				ll_hrtotalexec = ll_hrtotal
			End if
			
			' Gera o Insert na sig_programacao
			ls_sqlinsprog =                 "INSERT INTO sig_programacao (seqjornada,seqprogramacao,flgtipo,seqvoodiaesc,seqtrecho,"
			ls_sqlinsprog = ls_sqlinsprog &  "funcao,seqatividade,dthrinicio,dthrfim,observacao,kmnormal,kmdiurna,kmnoturna,"
			ls_sqlinsprog = ls_sqlinsprog &  "kmespdiurna,kmespnoturna,hrdiurna,hrnoturna,seqaeropatividade,seqaeroporig,"
			ls_sqlinsprog = ls_sqlinsprog &  "seqaeropdest, hrespdiurna, hrespnoturna,kmdiurnaexec,kmnoturnaexec,kmespdiurnaexec,"
			ls_sqlinsprog = ls_sqlinsprog &  "kmespnoturnaexec,hrdiurnaexec,hrnoturnaexec, hrespdiurnaexec, hrespnoturnaexec ) "
			ls_sqlinsprog = ls_sqlinsprog & "VALUES (" & ll_seqjornada & "," & ll_contador_aux & ",'" & ls_flgtipo & "',"
			' seqvoodiaesc
			If ll_seqvoodiaesc = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
				ls_sqlinsprog = ls_sqlinsprog & ll_seqvoodiaesc & ","
			End if
			' seqtrecho
			If ll_seqtrecho = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & ll_seqtrecho & ","
			End if
			' funcao
			If ls_funcao = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & "'" & ls_funcao & "',"
			End if
			' seqatividade
			If ll_seqatividade = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & ll_seqatividade & ","
			End if
			' dthrinicio
			If ll_dthrinicio_ano > "" Then
				ls_sqlinsprog = ls_sqlinsprog &    "'" & ll_dthrinicio_ano & "/" & ll_dthrinicio_mes & "/" & ll_dthrinicio_dia
				ls_sqlinsprog = ls_sqlinsprog &    " " & ll_dthrinicio_hora & ":" & ll_dthrinicio_minuto & "',"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			End if
			' dthrfim
			If ll_dthrfim_ano > "" Then
				ls_sqlinsprog = ls_sqlinsprog &    "'" & ll_dthrfim_ano & "/" & ll_dthrfim_mes & "/" & ll_dthrfim_dia
				ls_sqlinsprog = ls_sqlinsprog &    " " & ll_dthrfim_hora & ":" & ll_dthrfim_minuto & "',"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			End if
			' observacao
			If ls_observacao = "" Then
				ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
				ls_sqlinsprog = ls_sqlinsprog & "'" & ls_observacao & "',"
			End if
			' kmnormal
			ls_sqlinsprog = ls_sqlinsprog &    ll_kmnormal & ","
			If ll_hrtotal > 0 Then
				' kmdiurna
				ls_sqlinsprog = ls_sqlinsprog &    Replace(Int(ll_kmnormal * ll_hrdiurna / ll_hrtotal * 100) / 100,",",".") & ","
				' kmnoturna
				ls_sqlinsprog = ls_sqlinsprog &    Replace(Int(ll_kmnormal * ll_hrnoturna / ll_hrtotal * 100) / 100,",",".") & ","
				' kmespdiurna
				ls_sqlinsprog = ls_sqlinsprog &    Replace(Int( ll_kmnormal * ll_hrespdiurna / ll_hrtotal * 100) / 100,",",".") & ","
				' kmespnoturna
				ls_sqlinsprog = ls_sqlinsprog &    Replace(Int( ll_kmnormal * ll_hrespnoturna / ll_hrtotal * 100) / 100,",",".") & ","
			Else
				ls_sqlinsprog = ls_sqlinsprog &    "0,"
				ls_sqlinsprog = ls_sqlinsprog &    "0,"
				ls_sqlinsprog = ls_sqlinsprog &    "0,"
				ls_sqlinsprog = ls_sqlinsprog &    "0,"
			End if
			' hrdiurna
			ls_sqlinsprog = ls_sqlinsprog &    Replace(ll_hrdiurna,",",".") & ","
			' hrnoturna
			ls_sqlinsprog = ls_sqlinsprog &    Replace(ll_hrnoturna,",",".") & ","
			'seqaeropatividade
			If ll_seqaeropatividade = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
				ls_sqlinsprog = ls_sqlinsprog & ll_seqaeropatividade & ","
			End if
			' seqaeroporig
			If ll_seqaeroporig = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & ll_seqaeroporig & ","
			End if
			' seqaeropdest
			If ll_seqaeropdest = "" Then
			   ls_sqlinsprog = ls_sqlinsprog & "NULL,"
			Else
			   ls_sqlinsprog = ls_sqlinsprog & ll_seqaeropdest & ","
			End if
			' hrespdiurna
			ls_sqlinsprog = ls_sqlinsprog &    Replace(ll_hrespdiurna,",",".") & ","
			' hrespnoturna
			ls_sqlinsprog = ls_sqlinsprog &    Replace(ll_hrespnoturna, ",",".") & ","
			' kmdiurnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(Int(ll_kmnormal * ll_hrdiurnaexec / ll_hrtotalexec * 100) / 100,",",".") & ","
			' kmnoturnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(Int(ll_kmnormal * ll_hrnoturnaexec / ll_hrtotalexec * 100) / 100,",",".") & ","
			' kmespdiurnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(Int(ll_kmnormal * ll_hrespdiurnaexec / ll_hrtotalexec * 100) / 100,",",".") & ","
			' kmespnoturnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(Int(ll_kmnormal * ll_hrespnoturnaexec / ll_hrtotalexec * 100) / 100,",",".") & ","
			' hrdiurnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(ll_hrdiurnaexec,",",".") & ","
			' hrnoturnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(ll_hrnoturnaexec,",",".") & ","
			' hrespdiurnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(ll_hrespdiurnaexec,",",".") & ","
			' hrespnoturnaexec
			ls_sqlinsprog = ls_sqlinsprog & Replace(ll_hrespnoturnaexec,",",".") & ")"
			
			ls_sqlinsprog_vet(ll_contador_aux) = ls_sqlinsprog
		Next
		
		If ls_textojornada > "" Then
			ls_textojornada = Left( ls_textojornada, Len( ls_textojornada ) - 1 )
		End if
		
		If ldt_menorhoraprog > "" AND ldt_maiorhoraprog > "" Then
		   ls_textojornadaaux = Right("00"&Hour(ldt_menorhoraprog),2) & ":" & Right("00"&Minute(ldt_menorhoraprog),2)
			ls_textojornadaaux = ls_textojornadaaux & " " & Right("00"&Hour(ldt_maiorhoraprog),2) & ":" & Right("00"&Minute(ldt_maiorhoraprog),2)
		End if
		
		ls_sqlalterajornada = ""
		
		strErro_aux = f_parametros( ll_tempoapresentacao, ll_tempocorte, Conn, RS )
		
		If strErro_aux > "" Then
		   strErro = strErro_aux
		End if
		
		If IsDate( ldt_menorhoraprog ) Then
			ldt_dthrapresentacao = DateAdd( "n", CInt(ll_tempoapresentacao) * -1, ldt_menorhoraprog )
		Else
		   ldt_dthrapresentacao = Null
		End if
		
		If IsDate( ldt_maiorhoraprog ) Then
			ldt_dthrcorte = DateAdd( "n", ll_tempocorte, ldt_maiorhoraprog )
		Else
		   ldt_dthrcorte = Null
		End if
				
		If strErro = "" Then
			If ls_flgestado = "P" Then
				' Jornada Publicada: 
				' Altera Jornada anterior
				ls_sqlalterajornada =                       "UPDATE sig_jornada "
				ls_sqlalterajornada = ls_sqlalterajornada & "SET flgcorrente = 'N' "
				ls_sqlalterajornada = ls_sqlalterajornada & "WHERE seqjornada = " & ll_seqjornadaant
				
				' Insere Nova Jornada
				ls_sqljornada = 					  "INSERT INTO sig_jornada (seqjornada,seqtripulante,dtjornada,flgcorrente,textojornada,textojornadaaux,"
				ls_sqljornada = ls_sqljornada &    "kmsav,kmres,kmvoo,flgestado,seqchave,dthrapresentacao,dthrapresentacaorealiz,dthrcorte,"
				ls_sqljornada = ls_sqljornada &    "sequsuario,dthralteracao,dtchave,flgotm,flgpedido,observacao,textojornadaant,nomeavisado,dthravisado) "
				ls_sqljornada = ls_sqljornada & "VALUES (" & ll_seqjornada & "," & ll_seqtripulante & ","
				ls_sqljornada = ls_sqljornada &    "'" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "','S',"
				ls_sqljornada = ls_sqljornada &    "'" & ls_textojornada &"','" & ls_textojornadaaux & "'," & ll_kmsav & "," & ll_kmres & "," & ll_kmvoo & ","
				ls_sqljornada = ls_sqljornada &    "'A', NULL, "
				If IsDate( ldt_dthrapresentacao ) Then
					ls_sqljornada = ls_sqljornada & "'" & Year(ldt_dthrapresentacao) & "/" & Month(ldt_dthrapresentacao) & "/" & Day(ldt_dthrapresentacao)
					ls_sqljornada = ls_sqljornada & " " & Hour(ldt_dthrapresentacao) & ":" & Minute(ldt_dthrapresentacao) & "',"
				Else
					ls_sqljornada = ls_sqljornada & "NULL, "
				End if
				If IsDate(ldt_dthrapresentacaorealiz) Then
				   ls_sqljornada = ls_sqljornada & "'" & Year(ldt_dthrapresentacaorealiz) & "/" & Month(ldt_dthrapresentacaorealiz) & "/" & Day(ldt_dthrapresentacaorealiz)
					ls_sqljornada = ls_sqljornada & " " & Hour(ldt_dthrapresentacaorealiz) & ":" & Minute(ldt_dthrapresentacaorealiz) & "',"
				Else
					ls_sqljornada = ls_sqljornada & "NULL, "
				End if
				If IsDate(ldt_dthrcorte) Then
				   ls_sqljornada = ls_sqljornada & "'" & Year(ldt_dthrcorte) & "/" & Month(ldt_dthrcorte) & "/" & Day(ldt_dthrcorte)
					ls_sqljornada = ls_sqljornada & " " & Hour(ldt_dthrcorte) & ":" & Minute(ldt_dthrcorte) & "',"
				Else
				   ls_sqljornada = ls_sqljornada & "NULL,"
				End if
				If Session("member") = "1" Then
					ls_sqljornada = ls_sqljornada & "NULL,"
					ls_sqljornada = ls_sqljornada & "NULL,"
				Else
					ls_sqljornada = ls_sqljornada & Session("member") & ","
					ls_sqljornada = ls_sqljornada &    "'" & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & "',"
				End if
				ls_sqljornada = ls_sqljornada &    "NULL, 'I', '" & ls_flgpedido & "', "
				If ls_observacao_jornada = "" Then
				   ls_sqljornada = ls_sqljornada & "NULL, "
				Else
				   ls_sqljornada = ls_sqljornada & "'" & ls_observacao_jornada & "',"
				End if
				ls_sqljornada = ls_sqljornada &    "'" & ls_textojornadaant & "', NULL, NULL )"
			ElseIf lb_inserejornada Then
				' Nova Jornada
				ls_sqljornada = 					  "INSERT INTO sig_jornada (seqjornada,seqtripulante,dtjornada,flgcorrente,textojornada,textojornadaaux,"
				ls_sqljornada = ls_sqljornada &    "kmsav,kmres,kmvoo,flgestado,seqchave,dthrapresentacao,dthrapresentacaorealiz,dthrcorte,"
				ls_sqljornada = ls_sqljornada &    "sequsuario,dthralteracao,dtchave,flgotm,flgpedido,observacao,textojornadaant,nomeavisado,dthravisado) "
				ls_sqljornada = ls_sqljornada & "VALUES (" & ll_seqjornada & "," & ll_seqtripulante & ","
				ls_sqljornada = ls_sqljornada &    "'" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "','S',"
				ls_sqljornada = ls_sqljornada &    "'" & ls_textojornada &"','" & ls_textojornadaaux & "'," & ll_kmsav & "," & ll_kmres & "," & ll_kmvoo & ","
				ls_sqljornada = ls_sqljornada &    "'N', NULL, "
				If IsDate( ldt_dthrapresentacao ) Then
					ls_sqljornada = ls_sqljornada & "'" & Year(ldt_dthrapresentacao) & "/" & Month(ldt_dthrapresentacao) & "/" & Day(ldt_dthrapresentacao)
					ls_sqljornada = ls_sqljornada & " " & Hour(ldt_dthrapresentacao) & ":" & Minute(ldt_dthrapresentacao) & "',"
				Else
					ls_sqljornada = ls_sqljornada & "NULL,"
				End if
				ls_sqljornada = ls_sqljornada & "NULL,"
				If IsDate(ldt_dthrcorte) Then
				   ls_sqljornada = ls_sqljornada & "'" & Year(ldt_dthrcorte) & "/" & Month(ldt_dthrcorte) & "/" & Day(ldt_dthrcorte)
					ls_sqljornada = ls_sqljornada & " " & Hour(ldt_dthrcorte) & ":" & Minute(ldt_dthrcorte) & "',"
				Else
				   ls_sqljornada = ls_sqljornada & "NULL,"
				End if
				If Session("member") = "1" Then
				   ls_sqljornada = ls_sqljornada & "NULL,"
				   ls_sqljornada = ls_sqljornada & "NULL,"
				Else
					ls_sqljornada = ls_sqljornada &    Session("member") & ","
					ls_sqljornada = ls_sqljornada &    "'" & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & "',"
				End if
				ls_sqljornada = ls_sqljornada &    "NULL, 'N', '" & ls_flgpedido & "', "
				If ls_observacao_jornada = "" Then
				   ls_sqljornada = ls_sqljornada & "NULL, "
				Else
				   ls_sqljornada = ls_sqljornada & "'" & ls_observacao_jornada & "',"
				End if
				ls_sqljornada = ls_sqljornada &    "NULL, NULL, NULL )"
			ElseIf ls_flgestado = "N" Then
				' Mantem flgestado = "N"
			   ls_sqljornada =                 "UPDATE sig_jornada "
				ls_sqljornada = ls_sqljornada & "SET flgestado = 'N', nomeavisado = NULL, dthravisado = NULL, textojornada = "
				If ls_textojornada > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornada & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &      "textojornadaaux = "
				If ls_textojornadaaux > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornadaaux & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "kmsav = " & ll_kmsav & ", kmres = " & ll_kmres & ", "
				ls_sqljornada = ls_sqljornada &     "kmvoo = " & ll_kmvoo & ", dthrapresentacao = "
				If IsDate( ldt_dthrapresentacao ) Then
					ls_sqljornada = ls_sqljornada &  "'" & Year(ldt_dthrapresentacao) & "/" & Month(ldt_dthrapresentacao) & "/" & Day(ldt_dthrapresentacao) & " "
					ls_sqljornada = ls_sqljornada &  Hour(ldt_dthrapresentacao) & ":" & Minute(ldt_dthrapresentacao) & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "dthrcorte = "
				If IsDate( ldt_dthrcorte ) Then
					ls_sqljornada = ls_sqljornada &  "'" & Year(ldt_dthrcorte) & "/" & Month(ldt_dthrcorte) & "/" & Day(ldt_dthrcorte) & " "
					ls_sqljornada = ls_sqljornada &  Hour(ldt_dthrcorte) & ":" & Minute(ldt_dthrcorte) & "',"
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				If Session("member") <> "1" Then
					ls_sqljornada = ls_sqljornada & 	"sequsuario = " & Session("member") & ", "
					ls_sqljornada = ls_sqljornada &  "dthralteracao = '" & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & "', "
				End if
				ls_sqljornada = ls_sqljornada &     "flgotm = 'N', flgpedido = '" & ls_flgpedido & "', observacao = "
				IF ls_observacao_jornada > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_observacao_jornada & "', "
				Else
				   ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "textojornadaant = "
				If ls_textojornadaant > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornadaant & "' "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL "
				End if
				ls_sqljornada = ls_sqljornada & "WHERE seqjornada = " & ll_seqjornada
			Else
			   ls_sqljornada =                 "UPDATE sig_jornada "
				ls_sqljornada = ls_sqljornada & "SET flgestado = 'A', nomeavisado = NULL, dthravisado = NULL, textojornada = "
				If ls_textojornada > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornada & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &      "textojornadaaux = "
				If ls_textojornadaaux > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornadaaux & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "kmsav = " & ll_kmsav & ", kmres = " & ll_kmres & ", "
				ls_sqljornada = ls_sqljornada &     "kmvoo = " & ll_kmvoo & ", dthrapresentacao = "
				If IsDate( ldt_dthrapresentacao ) Then
					ls_sqljornada = ls_sqljornada &  "'" & Year(ldt_dthrapresentacao) & "/" & Month(ldt_dthrapresentacao) & "/" & Day(ldt_dthrapresentacao) & " "
					ls_sqljornada = ls_sqljornada &  Hour(ldt_dthrapresentacao) & ":" & Minute(ldt_dthrapresentacao) & "', "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "dthrcorte = "
				If IsDate( ldt_dthrcorte ) Then
					ls_sqljornada = ls_sqljornada &  "'" & Year(ldt_dthrcorte) & "/" & Month(ldt_dthrcorte) & "/" & Day(ldt_dthrcorte) & " "
					ls_sqljornada = ls_sqljornada &  Hour(ldt_dthrcorte) & ":" & Minute(ldt_dthrcorte) & "',"
				Else
					ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				If Session("member") <> "1" Then
					ls_sqljornada = ls_sqljornada &  "sequsuario = " & Session("member") & ", "
					ls_sqljornada = ls_sqljornada &  "dthralteracao = '" & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & "', "
				End if
				ls_sqljornada = ls_sqljornada &     "flgotm = 'N', flgpedido = '" & ls_flgpedido & "', observacao = "
				IF ls_observacao_jornada > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_observacao_jornada & "', "
				Else
				   ls_sqljornada = ls_sqljornada &  "NULL, "
				End if
				ls_sqljornada = ls_sqljornada &     "textojornadaant = "
				If ls_textojornadaant > "" Then
					ls_sqljornada = ls_sqljornada &  "'" & ls_textojornadaant & "' "
				Else
					ls_sqljornada = ls_sqljornada &  "NULL "
				End if
				ls_sqljornada = ls_sqljornada & "WHERE seqjornada = " & ll_seqjornada
			End if
			
			' Grava as informações
			Conn.BeginTrans
			
			ON ERROR RESUME NEXT
			
			If ls_sqlalterajornada > "" Then
				Conn.Execute( ls_sqlalterajornada )
				If ERR Then
				   strErro = "Erro ao atualizar os dados (sig_jornada)"
					Conn.RollbackTrans
				End if
			End if
			
			If strErro = "" Then
				Conn.Execute( ls_sqljornada )
				If ERR Then
				   strErro = "Erro ao atualizar os dados (sig_jornada)"
					Conn.RollbackTrans
				End if
			End if
			
			' Verifica se existe outra jornada para esta data
			
			
			' Exclui a Programação anterior
			If strErro = "" Then
				Conn.Execute( "DELETE FROM sig_programacao WHERE seqjornada = " & ll_seqjornada )
				If ERR Then
				   strErro = "Erro ao atualizar os dados (sig_programacao)"
					Conn.RollbackTrans
				End if
			End if
			
			' Inclui a Programação
			ll_contador = 1
			Do While ll_contador <= ll_qtdprogramacao AND strErro = ""
				Conn.Execute( ls_sqlinsprog_vet(ll_contador) )
				If ERR Then
					strErro = "Erro ao atualizar os dados (sig_programacao)"
					Conn.RollbackTrans
				End if
				ll_contador = ll_contador + 1
			Loop
			
			If strErro = "" Then			
				Conn.CommitTrans
			Else
				Conn.RollbackTrans
			End if
			
			If ERR Then
				strErro = "Erro ao atualizar os dados"
				Conn.RollbackTrans
			Else
				strMensagem = "Operação Realizada com Sucesso!"
				lb_fechar_janela = True
			End if
			
			ON ERROR GOTO 0
		End if
	End if
End if

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>
<FORM ACTION="fol_programacao.asp?dtjornada=<%Response.Write(ldt_dtjornada)%>&seqtripulante=<%Response.Write(ll_seqtripulante)%>&codcargo=<%Response.Write(ls_codcargo)%>&codfrota=<%Response.Write(ls_codfrota)%>&seqcidade=<%Response.Write(ll_seqcidade)%>" METHOD=POST NAME=FolProg>
<%

ll_pageopen = Request.Form( "pageopen" )
If ll_pageopen = "" OR IsNull( ll_pageopen ) Then
   ll_pageopen = 1
Else
   ll_pageopen = CInt(ll_pageopen) + 1
End if

Response.Write( "<input type='hidden' name='pageopen' value="&ll_pageopen&" >" )

''''''''''''''''''''''''''''''''''''''
' Recupera Empresa
''''''''''''''''''''''''''''''''''''''
Set RS = Conn.Execute("SELECT * FROM sig_empresaaerea ORDER BY siglaempresa")

ls_siglaempresa_vet = ""

Do While NOT RS.Eof
   ls_siglaempresa_vet = ls_siglaempresa_vet & RS("siglaempresa") & ","
   RS.MoveNext
Loop

ls_siglaempresa_vet = Split( Left(ls_siglaempresa_vet,Len(ls_siglaempresa_vet)-1),"," )

''''''''''''''''''''''''''''''''''''''
' Recupera Aeroporto
''''''''''''''''''''''''''''''''''''''
Set RS = Conn.Execute("SELECT * FROM sig_aeroporto ORDER BY codiata, codicao")

ll_seqaeroporto_vet = ""
ls_codicaoiata_vet = ""

Do While NOT RS.Eof
   ll_seqaeroporto_vet = ll_seqaeroporto_vet & RS("seqaeroporto") & ","
   If IsNull( RS("codiata") ) Then
      ls_codicaoiata_vet = ls_codicaoiata_vet & RS("codicao") & ","
   Else
      ls_codicaoiata_vet = ls_codicaoiata_vet & RS("codiata") & ","
   End If
   RS.MoveNext
Loop

ll_seqaeroporto_vet = Split( Left(ll_seqaeroporto_vet,Len(ll_seqaeroporto_vet)-1),"," )
ls_codicaoiata_vet = Split( Left(ls_codicaoiata_vet,Len(ls_codicaoiata_vet)-1),"," )

''''''''''''''''''''''''''''''''''''''
' Recupera Função Bordo
''''''''''''''''''''''''''''''''''''''
Set RS = Conn.Execute("SELECT * FROM sig_funcaobordo ORDER BY codfuncaobordo")

ls_codfuncaobordo_vet = ""
ls_codredfuncaobordo_vet = ""

Do While NOT RS.Eof
   ls_codfuncaobordo_vet = ls_codfuncaobordo_vet & RS("codfuncaobordo") & ","
   ls_codredfuncaobordo_vet = ls_codredfuncaobordo_vet & RS("codredfuncaobordo") & ","
   RS.MoveNext
Loop

ls_codfuncaobordo_vet = Split( Left(ls_codfuncaobordo_vet,Len(ls_codfuncaobordo_vet)-1),"," )
ls_codredfuncaobordo_vet = Split( Left(ls_codredfuncaobordo_vet,Len(ls_codredfuncaobordo_vet)-1),"," )

''''''''''''''''''''''''''''''''''''''
' Recupera Atividades
''''''''''''''''''''''''''''''''''''''
Set RS = Conn.Execute("SELECT * FROM sig_atividade WHERE flgbloqueado <> 'S' ORDER BY codatividade")

ll_seqatividade_vet = ""
ls_codatividade_vet = ""

Do While NOT RS.Eof
   ll_seqatividade_vet = ll_seqatividade_vet & RS("seqatividade") & ","
   ls_codatividade_vet = ls_codatividade_vet & RS("codatividade")
   If ( NOT IsNull( RS("hrinicio") ) ) Or ( NOT IsNull( RS("hrfim") ) ) Then
       ls_codatividade_vet = ls_codatividade_vet & " ("
		 If NOT IsNull( RS("hrinicio") ) Then
		    ls_codatividade_vet = ls_codatividade_vet & FormatDateTime(RS("hrinicio"),4)
		 End if
       ls_codatividade_vet = ls_codatividade_vet & "-"
		 If NOT IsNull( RS("hrfim") ) Then
		    ls_codatividade_vet = ls_codatividade_vet & FormatDateTime(RS("hrfim"),4)
	    End if
		 ls_codatividade_vet = ls_codatividade_vet & ")"
   End if
   ls_codatividade_vet = ls_codatividade_vet  & ","
   RS.MoveNext
Loop

ll_seqatividade_vet = Split( Left(ll_seqatividade_vet,Len(ll_seqatividade_vet)-1),"," )
ls_codatividade_vet = Split( Left(ls_codatividade_vet,Len(ls_codatividade_vet)-1),"," )

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ls_sqljornada =                 "SELECT * "
ls_sqljornada = ls_sqljornada & "FROM sig_tripulante, "
ls_sqljornada = ls_sqljornada &     " sig_jornada "
ls_sqljornada = ls_sqljornada &     " LEFT OUTER JOIN sig_chave ON sig_chave.seqchave = sig_jornada.seqchave "
ls_sqljornada = ls_sqljornada &     " LEFT OUTER JOIN sig_usuario ON sig_usuario.sequsuario = sig_jornada.sequsuario "
ls_sqljornada = ls_sqljornada & "WHERE sig_tripulante.seqtripulante = sig_jornada.seqtripulante "
ls_sqljornada = ls_sqljornada &  " AND sig_tripulante.seqtripulante = " & ll_seqtripulante
ls_sqljornada = ls_sqljornada &  " AND sig_jornada.dtjornada = '" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "' "
ls_sqljornada = ls_sqljornada &  " AND sig_jornada.flgcorrente = 'S' "

Set RS = Conn.Execute(ls_sqljornada)

If NOT RS.Eof Then
   ll_seqjornada = RS("seqjornada")
   ls_flgestado = RS("flgestado")
   ldt_dthralteracao = RS("dthralteracao")
   ldt_dthravisado = RS("dthravisado")
   ldt_dthrapresentacaorealiz = RS("dthrapresentacaorealiz")
	ls_textojornada = RS("textojornada")
	ls_nomeguerra = RS("nomeguerra")
	ls_usuario = RS("usuario")
	ls_nomechave = RS("nomechave")
	ls_flgpedido = RS("flgpedido")
	ls_nomeavisado = RS("nomeavisado")
	ls_observacao = RS("observacao")
	ls_textojornada = RS("textojornada")
	ls_textojornadaaux = RS("textojornadaaux")
Else
	ls_sqltrip = "SELECT * FROM sig_tripulante WHERE seqtripulante = " & ll_seqtripulante
	Set RSTrip = Conn.Execute( ls_sqltrip )
	
	If NOT RSTrip.EOF Then
		ls_nomeguerra = RSTrip("nomeguerra")
	Else
		ls_nomeguerra = "&nbsp;"
	End if
	
	ll_seqjornada = Null
	ls_flgestado = "N"
   ldt_dthralteracao = Null
	ldt_dthravisado = Null
	ldt_dthrapresentacaorealiz = Null
	ls_textojornada = Null
	ls_usuario = Null
	ls_nomechave = Null
	ls_flgpedido = ""
	ls_nomeavisado = ""
	ls_observacao = ""
End if
	
Response.Write( "<table border='1' cellpadding='1' cellspacing='1'>" )
Response.Write(    "<tr>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Tripulante</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Data</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Estado</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Chave de Voo</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Usuário</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Última Alteração</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Pedido</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Avisado Por</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Avisado Em</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Apresentação</b></td>" )
Response.Write(    "</tr>" )
Response.Write(    "<tr>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>" & ls_nomeguerra & "</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>" & Right("0"&ll_dtjornada_dia,2) & "/" & Right("0"&ll_dtjornada_mes,2) & "/" )
Response.Write(         ll_dtjornada_ano & "</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>" )
Select Case ls_flgestado
	Case "N"
		Response.Write(    "Normal" )
	Case "P"
		Response.Write(    "Publicado" )
	Case "A"
		Response.Write(    "Alterado" )
	Case "V"
		Response.Write(    "Avisado" )
	Case "R"
		Response.Write(    "Realizado" )
End Select
Response.Write(          "<input type='hidden' name='flgestado' value='" & ls_flgestado & "'>" )
Response.Write(       "</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" & ls_nomechave & "&nbsp;</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" & ls_usuario & "&nbsp;</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" )
If Not IsNull( ldt_dthralteracao ) Then
	Response.Write(        Right("0"&Day(ldt_dthralteracao),2) & "/" & Right("0"&Month(ldt_dthralteracao),2) & "/" & Year(ldt_dthralteracao) & " " & FormatDateTime(ldt_dthralteracao,4) )
End if
Response.Write( "&nbsp;</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap><input TYPE='checkbox' NAME='flgpedido' " )
If ( strAdicionar = "" AND strExcluir = "" AND ll_pageopen = 1 ) OR ( strGravar <> "" AND strErro = "" ) Then
	If ls_flgpedido = "S" Then
		Response.Write(    "checked" )
	End if
Else
	If Request.Form("flgpedido") = "on" Then
		Response.Write(    "checked" )
	End if
End If
Response.Write(       "></td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" & ls_nomeavisado & "&nbsp;</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" )
If Not IsNull( ldt_dthravisado ) Then
	Response.Write(        Right("0"&Day(ldt_dthravisado),2) & "/" & Right("0"&Month(ldt_dthravisado),2) & "/" & Year(ldt_dthravisado) & " " & FormatDateTime(ldt_dthravisado,4) )
End If
Response.Write(       "&nbsp;</td>" )
Response.Write(       "<td class='CORPO8' align='center' nowrap>&nbsp;" )
If Not IsNull( ldt_dthrapresentacaorealiz ) Then
	Response.Write(        Right("0"&Day(ldt_dthrapresentacaorealiz),2) & "/" & Right("0"&Month(ldt_dthrapresentacaorealiz),2) & "/" & Year(ldt_dthrapresentacaorealiz) & " " & FormatDateTime(ldt_dthrapresentacaorealiz,4) )
	Response.Write(       "<input type='hidden' name='dthrapresentacaorealiz' value='" & ldt_dthrapresentacaorealiz & "'>" )
End If
Response.Write(       "&nbsp;</td>" )
Response.Write(    "</tr>" )
Response.Write(    "<tr>" )
Response.Write(       "<td class='CORPO8' align='left' colspan='10'><input TYPE='text' NAME='observacao' maxlength='200' size='150' " )
If ( strAdicionar = "" AND strExcluir = "" AND ll_pageopen = 1 ) OR ( strGravar <> "" AND strErro = "" ) Then
	Response.Write(       "value='" & ls_observacao & "'" )
Else
	Response.Write(       "value='" & Request.Form("observacao") & "'" )
End If
Response.Write(       "></td>" )
Response.Write(    "</tr>" )
Response.Write( "</table><br><br>" )

Response.Write( "<input type='hidden' name='seqjornada' value=" & ll_seqjornada & ">" )
Response.Write( "<input type='hidden' name='textojornada' value='" & ls_textojornada & "'>" )                                                                     

''''''''''''''''''''''''''''''''''''''
' Recupera a Programação
''''''''''''''''''''''''''''''''''''''
ll_qtdprogramacao = CInt(Request.Form("qtdprogramacao"))

If ( strAdicionar = "" AND strExcluir = "" AND ll_pageopen = 1 AND NOT RS.EOF ) OR ( strGravar <> "" AND strErro = "" ) Then
	Set RS = Conn.Execute( "SELECT count(*) as qtdprogramacao FROM sig_programacao WHERE sig_programacao.seqjornada = " & ll_seqjornada )
	ll_qtdprogramacao = CInt( RS("qtdprogramacao") )

	ls_sqlprog =              "SELECT * "
	ls_sqlprog = ls_sqlprog & "FROM sig_programacao "
	ls_sqlprog = ls_sqlprog &     " LEFT OUTER JOIN sig_escdiariovoo ON sig_escdiariovoo.seqvoodiaesc = sig_programacao.seqvoodiaesc "
	ls_sqlprog = ls_sqlprog &     " LEFT OUTER JOIN sig_escdiariotrecho ON sig_escdiariotrecho.seqvoodiaesc = sig_programacao.seqvoodiaesc AND "
	ls_sqlprog = ls_sqlprog &          " sig_escdiariotrecho.seqtrecho = sig_programacao.seqtrecho "
	ls_sqlprog = ls_sqlprog & "WHERE sig_programacao.seqjornada = " & ll_seqjornada & " "
	ls_sqlprog = ls_sqlprog & "ORDER BY seqprogramacao"

	Set RS = Conn.Execute( ls_sqlprog )
Else
	If strAdicionar <> "" OR ll_qtdprogramacao = 0 Then
	   strAdicionar = "YES"
		ll_qtdprogramacao = ll_qtdprogramacao + 1
	End if
End If

Response.Write( "<table border='1' cellpadding='1' cellspacing='1'>" )
Response.Write(    "<tr>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap>&nbsp;</td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Tipo Prog.</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Empresa</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Voo</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Origem</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Destino</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Função</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Atividade</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Localidade</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Início</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Fim</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Observação</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Partida Motor</b></td>" )
Response.Write(       "<td class='CORPO' align='center' bgcolor='#AAAAAA' nowrap><b>Corte Motor</b></td>" )
Response.Write(    "</tr>" )

ll_incrementolinha = 0

For ll_linhaprogramacao = 1 TO ll_qtdprogramacao
	If ( strAdicionar = "" AND strExcluir = "" AND ll_pageopen = 1 ) OR ( strGravar <> "" AND strErro = "" ) Then
		ls_flgtipo = RS("flgtipo")
		ls_flgtipo_orig = ls_flgtipo
		ls_siglaempresa = RS("siglaempresa")
		ls_siglaempresa_orig = ls_siglaempresa
		ll_nrvoo = RS("nrvoo")
		ll_nrvoo_orig = ll_nrvoo
		ll_seqaeroporig = RS("seqaeroporig")
		ll_seqaeropdest = RS("seqaeropdest")
		ls_funcao = RS("funcao")
		ll_seqatividade = RS("seqatividade")
		ll_seqatividade_orig = ll_seqatividade
		ll_seqaeropatividade = RS("seqaeropatividade")
		If IsDate( RS("dthrinicio") ) Then
			ll_dthrinicio_dia = Right( "0"&Day( RS("dthrinicio") ), 2 )
			ll_dthrinicio_mes = Right( "0"&Month( RS("dthrinicio") ), 2 )
			ll_dthrinicio_ano = Year( RS("dthrinicio") )
			ll_dthrinicio_hora = Right( "0"&Hour( RS("dthrinicio") ), 2 )
			ll_dthrinicio_minuto = Right( "0"&Minute( RS("dthrinicio") ), 2 )
		Else
			ll_dthrinicio_dia = ""
			ll_dthrinicio_mes = ""
			ll_dthrinicio_ano = ""
			ll_dthrinicio_hora = ""
			ll_dthrinicio_minuto = ""
		End If
		If IsDate( RS("dthrfim") ) Then
			ll_dthrfim_dia = Right( "0"&Day( RS("dthrfim") ), 2 )
			ll_dthrfim_mes = Right( "0"&Month( RS("dthrfim") ), 2 )
			ll_dthrfim_ano = Year( RS("dthrfim") )
			ll_dthrfim_hora = Right( "0"&Hour( RS("dthrfim") ), 2 )
			ll_dthrfim_minuto = Right( "0"&Minute( RS("dthrfim") ), 2 )
		Else
			ll_dthrfim_dia = ""
			ll_dthrfim_mes = ""
			ll_dthrfim_ano = ""
			ll_dthrfim_hora = ""
			ll_dthrfim_minuto = ""
		End If
		ldt_partidamotor = RS("partidamotor" )
		ldt_cortemotor = RS("cortemotor" )
		ls_observacao = RS("observacao")
		ll_seqvoodiaesc = RS("seqvoodiaesc")
		ll_seqtrecho = RS("seqtrecho")
	Else
		ls_selecionado = Request.Form("selecionado"&ll_linhaprogramacao)
		ls_flgtipo = Request.Form("flgtipo"&ll_linhaprogramacao)
		ls_flgtipo_orig = Request.Form("flgtipo_orig"&ll_linhaprogramacao)
		ls_siglaempresa = Request.Form("siglaempresa"&ll_linhaprogramacao)
		ls_siglaempresa_orig = Request.Form("siglaempresa_orig"&ll_linhaprogramacao)
		ll_nrvoo = Request.Form("nrvoo"&ll_linhaprogramacao)
		ll_nrvoo_orig = Request.Form("nrvoo_orig"&ll_linhaprogramacao)
		ll_seqaeroporig = Request.Form("seqaeroporig"&ll_linhaprogramacao)
		ll_seqaeropdest = Request.Form("seqaeropdest"&ll_linhaprogramacao)
		ls_funcao = Request.Form("funcao"&ll_linhaprogramacao)
		ll_seqatividade = Request.Form("seqatividade"&ll_linhaprogramacao)
		ll_seqatividade_orig = Request.Form("seqatividade_orig"&ll_linhaprogramacao)
		ll_seqaeropatividade = Request.Form("seqaeropatividade"&ll_linhaprogramacao)
		ll_dthrinicio_dia = Request.Form("dthrinicio_dia"&ll_linhaprogramacao)
		ll_dthrinicio_mes = Request.Form("dthrinicio_mes"&ll_linhaprogramacao)
		ll_dthrinicio_ano = Request.Form("dthrinicio_ano"&ll_linhaprogramacao)
		ll_dthrinicio_hora = Request.Form("dthrinicio_hora"&ll_linhaprogramacao)
		ll_dthrinicio_minuto = Request.Form("dthrinicio_minuto"&ll_linhaprogramacao)
		ll_dthrfim_dia = Request.Form("dthrfim_dia"&ll_linhaprogramacao)
		ll_dthrfim_mes = Request.Form("dthrfim_mes"&ll_linhaprogramacao)
		ll_dthrfim_ano = Request.Form("dthrfim_ano"&ll_linhaprogramacao)
		ll_dthrfim_hora = Request.Form("dthrfim_hora"&ll_linhaprogramacao)
		ll_dthrfim_minuto = Request.Form("dthrfim_minuto"&ll_linhaprogramacao)
		ldt_partidamotor = Request.Form("partidamotor"&ll_linhaprogramacao)
		ldt_cortemotor = Request.Form("cortemotor"&ll_linhaprogramacao)
		ls_observacao = Request.Form("observacao"&ll_linhaprogramacao)
		ll_seqvoodiaesc = Request.Form("seqvoodiaesc"&ll_linhaprogramacao)
		ll_seqtrecho = Request.Form("seqtrecho"&ll_linhaprogramacao)
		
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' Trata mudança do Tipo
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		If ls_flgtipo <> ls_flgtipo_orig Then
			ls_siglaempresa = ""
			ll_nrvoo = ""
			ll_nrvoo_orig = ""
			ll_seqaeroporig = ""
			ll_seqaeropdest = ""
			ls_funcao = ""
			ll_seqatividade = ""
			ll_seqatividade_orig = ""
			ll_seqaeropatividade = ""
			ll_dthrinicio_dia = ""
			ll_dthrinicio_mes = ""
			ll_dthrinicio_ano = ""
			ll_dthrinicio_hora = ""
			ll_dthrinicio_minuto = ""
			ll_dthrfim_dia = ""
			ll_dthrfim_mes = ""
			ll_dthrfim_ano = ""
			ll_dthrfim_hora = ""
			ll_dthrfim_minuto = ""
			ldt_partidamotor = ""
			ldt_cortemotor = ""
		End if
	End if
	
	If strExcluir = "" OR (strExcluir <> "" AND ls_selecionado <> "on") Then
			' Não exclui o registro
		If ls_flgtipo = "A" Then
			ls_disable_voo = " disabled "
			ls_disable_atividade = ""
		ElseIf ls_flgtipo = "V" Then
			ls_disable_voo = ""
			ls_disable_atividade = " disabled "
		Else
			ls_disable_voo = " disabled "
			ls_disable_atividade = "disabled"
		End if
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Trata mudança da Empresa
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		If ls_siglaempresa <> ls_siglaempresa_orig Then
			ll_nrvoo = ""
			ll_nrvoo_orig = ""
			ll_seqaeroporig = ""
			ll_seqaeropdest = ""
			ls_funcao = ""
			ll_dthrinicio_dia = ""
			ll_dthrinicio_mes = ""
			ll_dthrinicio_ano = ""
			ll_dthrinicio_hora = ""
			ll_dthrinicio_minuto = ""
			ll_dthrfim_dia = ""
			ll_dthrfim_mes = ""
			ll_dthrfim_ano = ""
			ll_dthrfim_hora = ""
			ll_dthrfim_minuto = ""
			ldt_partidamotor = ""
			ldt_cortemotor = ""
		End if
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Trata mudança do Voo
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		If ls_flgtipo = "V" AND ( ll_nrvoo = "" AND ll_nrvoo_orig > "" ) Then
			ll_nrvoo = ""
			ll_nrvoo_orig = ""
			ll_seqaeroporig = ""
			ll_seqaeropdest = ""
			ls_funcao = ""
			ll_dthrinicio_dia = ""
			ll_dthrinicio_mes = ""
			ll_dthrinicio_ano = ""
			ll_dthrinicio_hora = ""
			ll_dthrinicio_minuto = ""
			ll_dthrfim_dia = ""
			ll_dthrfim_mes = ""
			ll_dthrfim_ano = ""
			ll_dthrfim_hora = ""
			ll_dthrfim_minuto = ""
			ldt_partidamotor = ""
			ldt_cortemotor = ""
			strErro = "Número do Voo inválido!!!"
		ElseIf ll_nrvoo > "" Then
			If ll_nrvoo_orig = "" Then
				ll_nrvoo_orig = "0"
			End if
			
			If CInt( ll_nrvoo ) <> CInt( ll_nrvoo_orig ) AND ll_nrvoo > "" Then
				ls_sqlvoo =             "SELECT * FROM sig_escdiariovoo, sig_escdiariotrecho "
				ls_sqlvoo = ls_sqlvoo & "WHERE sig_escdiariovoo.seqvoodiaesc = sig_escdiariotrecho.seqvoodiaesc "
				ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.dtoper = '" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "'"
				ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.nrvoo = " & ll_nrvoo
				
				If IsNull( ls_siglaempresa ) OR ls_siglaempresa = "" Then
					ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.siglaempresa IS NULL"
				Else
					ls_sqlvoo = ls_sqlvoo &  " AND sig_escdiariovoo.siglaempresa = '" & ls_siglaempresa & "'"
				End if
				
				lb_insereplanejado = False
				
				Set RSVoo = ConnVooAtividade.Execute( ls_sqlvoo )
				
				If RSVoo.EOF Then
					ll_dia_semana_dtjornada = WeekDay( ldt_dtjornada)
					ls_planejfreq_vet = "freqdom,freqseg,freqter,freqqua,freqqui,freqsex,freqsab"
					ls_planejfreq_vet = Split( ls_planejfreq_vet, "," )
					
					ls_sqlvoo =             "SELECT * FROM sig_escplanejvoo, sig_escplanejtrecho "
					ls_sqlvoo = ls_sqlvoo & "WHERE sig_escplanejvoo.seqvooesc = sig_escplanejtrecho.seqvooesc "
					ls_sqlvoo = ls_sqlvoo &  " AND sig_escplanejvoo.dtinicio <= '" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "'"
					ls_sqlvoo = ls_sqlvoo &  " AND ( sig_escplanejvoo.dtfim >= '" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "'"
					ls_sqlvoo = ls_sqlvoo &        " OR sig_escplanejvoo.dtfim IS NULL ) "
					ls_sqlvoo = ls_sqlvoo &  " AND sig_escplanejvoo.nrvoo = " & ll_nrvoo
					ls_sqlvoo = ls_sqlvoo &  " AND sig_escplanejvoo." & ls_planejfreq_vet(ll_dia_semana_dtjornada-1) & " = 'S'"
					
					If IsNull( ls_siglaempresa ) OR ls_siglaempresa = "" Then
						ls_sqlvoo = ls_sqlvoo &  " AND sig_escplanejvoo.siglaempresa IS NULL"
					Else
						ls_sqlvoo = ls_sqlvoo &  " AND sig_escplanejvoo.siglaempresa = '" & ls_siglaempresa & "'"
					End if
					
					lb_insereplanejado = True
					
					Set RSVoo = ConnVooAtividade.Execute( ls_sqlvoo )
				End if
				
				If NOT RSVoo.EOF Then
					If lb_insereplanejado Then
						' Insere registro na Sig_EscDiarioVoo (Gerando Sequencial)
						ll_seqvoodiaesc = f_sequencial( "SIG_ESCDIARIOVOO", "", StringConexaoSqlServer )
						
						ls_tipovoo = RSVoo("tipovoo")
						ll_seqvooesc = RSVoo("seqvooesc")
						
						ls_sqlinsplanej = 						"INSERT INTO sig_escdiariovoo "
						ls_sqlinsplanej = ls_sqlinsplanej & "(seqvoodiaesc,siglaempresa,nrvoo,dtoper,tipovoo,seqvooesc,statusvoo,flggersistema) " 
						ls_sqlinsplanej = ls_sqlinsplanej & "VALUES (" & ll_seqvoodiaesc & ","
						If ls_siglaempresa = "" OR IsNull( ls_siglaempresa ) Then
							ls_sqlinsplanej = ls_sqlinsplanej & "NULL,"
						Else
							ls_sqlinsplanej = ls_sqlinsplanej & "'" & ls_siglaempresa & "',"
						End if
						ls_sqlinsplanej = ls_sqlinsplanej & ll_nrvoo & ",'" & ll_dtjornada_ano & "/" & ll_dtjornada_mes & "/" & ll_dtjornada_dia & "',"
						ls_sqlinsplanej = ls_sqlinsplanej & "'" & ls_tipovoo & "'," & ll_seqvooesc & ",'N','S' )"
						
						ConnInsPlanej.BeginTrans
						ConnInsPlanej.Execute( ls_sqlinsplanej )
					Else
						ll_seqvoodiaesc = RSVoo("seqvoodiaesc")
					End if
					
					Do While NOT RSVoo.EOF
						ll_seqaeroporig = RSVoo( "seqaeroporig" )
						ll_seqaeropdest = RSVoo( "seqaeropdest" )
						ll_seqtrecho = RSVoo( "seqtrecho" )
						ll_seqfrota = RSVoo("seqfrota")
						If lb_insereplanejado Then	' Recuperando os registros do Planejamento: Calcula Data de Chegada!!!
							ll_dthrinicio_dia = Right( "0"&Day(DateAdd("d", RSVoo("partidadia"), ldt_dtjornada)),2)
							ll_dthrinicio_mes = Right( "0"&Month(DateAdd("d", RSVoo("partidadia"), ldt_dtjornada)),2)
							ll_dthrinicio_ano = Year( DateAdd("d", RSVoo("partidadia"), ldt_dtjornada))
							ll_dthrinicio_hora = Right( "0"&Hour(RSVoo("partida")),2)
							ll_dthrinicio_minuto = Right( "0"&Minute(RSVoo("partida")),2)
							ll_dthrfim_dia = Right( "0"&Day(DateAdd("d", RSVoo("chegadadia"), ldt_dtjornada)),2)
							ll_dthrfim_mes = Right( "0"&Month(DateAdd("d", RSVoo("chegadadia"), ldt_dtjornada)),2)
							ll_dthrfim_ano = Year(DateAdd("d", RSVoo("chegadadia"), ldt_dtjornada))
							ll_dthrfim_hora = Right( "0"&Hour(RSVoo("chegada")),2)
							ll_dthrfim_minuto = Right( "0"&Minute(RSVoo("chegada")),2)
						Else
							ll_dthrinicio_dia = Right( "0"&Day(RSVoo("partidaprev")),2)
							ll_dthrinicio_mes = Right( "0"&Month(RSVoo("partidaprev")),2)
							ll_dthrinicio_ano = Year(RSVoo("partidaprev"))
							ll_dthrinicio_hora = Right( "0"&Hour(RSVoo("partidaprev")),2)
							ll_dthrinicio_minuto = Right( "0"&Minute(RSVoo("partidaprev")),2)
							ll_dthrfim_dia = Right( "0"&Day(RSVoo("chegadaprev")),2)
							ll_dthrfim_mes = Right( "0"&Month(RSVoo("chegadaprev")),2)
							ll_dthrfim_ano = Year(RSVoo("chegadaprev"))
							ll_dthrfim_hora = Right( "0"&Hour(RSVoo("chegadaprev")),2)
							ll_dthrfim_minuto = Right( "0"&Minute(RSVoo("chegadaprev")),2)
							ldt_partidamotor = RSVoo("partidamotor")
							ldt_cortemotor = RSVoo("cortemotor")
						End if
						
						IF lb_insereplanejado Then
							' Insere registro na Sig_EscDiarioTrecho
							ls_sqlinsplanej = 						"INSERT INTO sig_escdiariotrecho "
							ls_sqlinsplanej = ls_sqlinsplanej & "(seqvoodiaesc,seqtrecho,seqfrota,seqaeroporig,seqaeropdest,partidaprev,chegadaprev,flgcancelado) " 
							ls_sqlinsplanej = ls_sqlinsplanej & "VALUES (" & ll_seqvoodiaesc & "," & ll_seqtrecho & "," & ll_seqfrota & "," & ll_seqaeroporig & ","
							ls_sqlinsplanej = ls_sqlinsplanej &  ll_seqaeropdest & ",'" & ll_dthrinicio_ano & "/" & ll_dthrinicio_mes & "/" & ll_dthrinicio_dia & " "
							ls_sqlinsplanej = ls_sqlinsplanej &  ll_dthrinicio_hora & ":" & ll_dthrinicio_minuto & "','" & ll_dthrfim_ano & "/" & ll_dthrfim_mes & "/"
							ls_sqlinsplanej = ls_sqlinsplanej &  ll_dthrfim_dia & " " & ll_dthrfim_hora & ":" & ll_dthrfim_minuto & "','N')"
							
							ConnInsPlanej.Execute( ls_sqlinsplanej )
						End if
						
						' Lê o próximo Registro
						RSVoo.MoveNext
						
						If NOT RSVoo.EOF Then
							Response.Write( "<tr>" )
							Response.Write(    "<td><input type='checkbox' name='selecionado"&(ll_linhaprogramacao+ll_incrementolinha)&"' " )
							If ls_selecionado = "on" Then Response.Write( "checked" )
							Response.Write(    "></td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='flgtipo"&(ll_linhaprogramacao+ll_incrementolinha)&"' onChange='javascript:submit()'>" )
							Response.Write(          "<option value='' selected></option><option value='V' selected>Voo</option><option value='A'>Atividade</option>" )
							Response.Write(       "</select>" )
							Response.Write(       "<input type='hidden' name='flgtipo_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ls_flgtipo&">" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type='hidden' name='siglaempresa_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ls_siglaempresa&" >" )
							Response.Write(       "<select name='siglaempresa"&(ll_linhaprogramacao+ll_incrementolinha)&"'"&ls_disable_voo&" onChange='javascript:submit()'>" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 TO UBound(ls_siglaempresa_vet)
								Response.Write(       "<option value='"&ls_siglaempresa_vet(ll_contador)&"' " )
								If ls_siglaempresa = ls_siglaempresa_vet(ll_contador) Then
									Response.Write(       "selected" )
								End If
								Response.Write( ">"&ls_siglaempresa_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type='hidden' name='nrvoo_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ll_nrvoo&" >" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='nrvoo"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='4' size='4' id='txt_nrvoo"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_nrvoo & "' onChange='javascript:submit()'" & ls_disable_voo & ">" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='seqaeroporig"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
								Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
								If NOT IsNull( ll_seqaeroporig ) AND ll_seqaeroporig > "" Then
									If CInt(ll_seqaeroporig) = CInt(ll_seqaeroporto_vet(ll_contador)) Then
										Response.Write(       "selected" )
									End If
								End if
								Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='seqaeropdest"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
								Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
								If NOT IsNull( ll_seqaeropdest ) AND ll_seqaeropdest > "" Then
									If CInt(ll_seqaeropdest) = CInt(ll_seqaeroporto_vet(ll_contador)) Then
										Response.Write(       "selected" )
									End If
								End if
								Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='funcao"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 TO UBound(ls_codredfuncaobordo_vet)
								Response.Write(       "<option value='"&ls_codredfuncaobordo_vet(ll_contador)&"' " )
								If ls_funcao = ls_codredfuncaobordo_vet(ll_contador) Then
									Response.Write(          "selected" )
								End if
								Response.Write( ">"&ls_codfuncaobordo_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='seqatividade"&(ll_linhaprogramacao+ll_incrementolinha)&"' disabled>" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 TO UBound(ll_seqatividade_vet)
								Response.Write(       "<option value='"&ll_seqatividade_vet(ll_contador)&"'>"&ls_codatividade_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(       "<input type='hidden' name='seqatividade_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value=" &ll_seqatividade&">" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<select name='seqaeropatividade"&(ll_linhaprogramacao+ll_incrementolinha)&"' disabled>" )
							Response.Write(          "<option value='' selected></option>" )
							For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
								Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
								If NOT IsNull( ll_seqaeropatividade ) AND ll_seqaeropatividade > "" Then
									If CInt( ll_seqaeropatividade ) = CInt( ll_seqaeroporto_vet(ll_contador) ) Then
										Response.Write(       "selected" )
									End If
								End If
								Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
							Next
							Response.Write(       "</select>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='dia_aux' size='1' id='txt_dia_aux' value='" & ll_dthrinicio_dia & "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='mes_aux' size='1' id='txt_mes_aux' value='" & ll_dthrinicio_mes & "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='ano_aux' size='3' id='txt_ano_aux' value='" & ll_dthrinicio_ano & "' disabled>  " )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='hora_aux' size='1' id='txt_hora_aux' value='"&ll_dthrinicio_hora& "' disabled>:" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='minuto_aux' size='1' id='txt_minuto_aux' value='"&ll_dthrinicio_minuto&"' disabled>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrinicio_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrinicio_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrinicio_dia & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrinicio_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrinicio_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrinicio_mes & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrinicio_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrinicio_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrinicio_ano & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrinicio_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrinicio_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrinicio_hora & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrinicio_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrinicio_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrinicio_minuto & "'>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='dia_aux' size='1' id='txt_dia_aux' value='" & ll_dthrfim_dia & "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='mes_aux' size='1' id='txt_mes_aux' value='" & ll_dthrfim_mes & "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='ano_aux' size='3' id='txt_ano_aux' value='" & ll_dthrfim_ano & "' disabled>  " )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='hora_aux' size='1' id='txt_hora_aux' value='" & ll_dthrfim_hora & "' disabled>:" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='minuto_aux' size='1' id='txt_minuto_aux' value='" &ll_dthrfim_minuto & "' disabled>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrfim_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrfim_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrfim_dia & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrfim_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrfim_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrfim_mes & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrfim_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrfim_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrfim_ano & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrfim_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrfim_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrfim_hora & "'>" )
							Response.Write(       "<input type = 'hidden' NAME='dthrfim_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' id='txt_dthrfim_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='" & ll_dthrfim_minuto & "'>" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type = 'text' class='CORPO' NAME='observacao"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='200' size='80' id='txt_observacao"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ls_observacao & "'>" )
							Response.Write(       "<input type = 'hidden' name='seqvoodiaesc"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ll_seqvoodiaesc&">" )
							Response.Write(       "<input type = 'hidden' name='seqtrecho"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ll_seqtrecho&">" )
							Response.Write(    "</td>" )
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_partidamotor > "" Then Response.Write( Right("00"&Day(ldt_partidamotor),2) )
							Response.Write(          "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_partidamotor > "" Then Response.Write( Right("00"&Month(ldt_partidamotor),2) )
							Response.Write(          "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' size='3' value='" )
							If ldt_partidamotor > "" Then Response.Write( Year(ldt_partidamotor) )
							Response.Write(          "' disabled>  " )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_partidamotor > "" Then Response.Write( Right("00"&Hour(ldt_partidamotor),2) )
							Response.Write(          "' disabled>:" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_partidamotor > "" Then Response.Write( Right("00"&Minute(ldt_partidamotor),2) )
							Response.Write(          "' disabled>" )
							Response.Write(       "<input type = 'hidden' NAME='partidamotor"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='"&ldt_partidamotor&"'>" )
							Response.Write(    "</td>" )								
							Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_cortemotor > "" Then Response.Write( Right("00"&Day(ldt_cortemotor),2) )
							Response.Write(          "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_cortemotor > "" Then Response.Write( Right("00"&Month(ldt_cortemotor),2) )
							Response.Write(          "' disabled>/" )
							Response.Write(       "<input type = 'text' class='CORPO' size='3' value='" )
							If ldt_cortemotor > "" Then Response.Write( Year(ldt_cortemotor) )
							Response.Write(          "' disabled>  " )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_cortemotor > "" Then Response.Write( Right("00"&Hour(ldt_cortemotor),2) )
							Response.Write(          "' disabled>:" )
							Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
							If ldt_cortemotor > "" Then Response.Write( Right("00"&Minute(ldt_cortemotor),2) )
							Response.Write(          "' disabled>" )
							Response.Write(       "<input type = 'hidden' NAME='cortemotor"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='"&ldt_cortemotor&"'>" )
							Response.Write(    "</td>" )								
					
							Response.Write( "</tr>" )
	
							ll_incrementolinha = ll_incrementolinha + 1
						End if
					Loop
					
					If lb_insereplanejado Then
						ConnInsPlanej.CommitTrans
					End if
				Else
					strErro = "Voo " & ll_nrvoo & " não cadastrado!"
					ll_nrvoo = ""
					ll_seqaeroporig = ""
					ll_seqaeropdest = ""
					ll_dthrinicio_dia = ""
					ll_dthrinicio_mes = ""
					ll_dthrinicio_ano = ""
					ll_dthrinicio_hora = ""
					ll_dthrinicio_minuto = ""
					ll_dthrfim_dia = ""
					ll_dthrfim_mes = ""
					ll_dthrfim_ano = ""
					ll_dthrfim_hora = ""
					ll_dthrfim_minuto = ""
					ldt_partidamotor = ""
					ldt_cortemotor = ""
				End if
			End if
		End if
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Trata mudança da Atividade
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		If ll_seqatividade&"" <> ll_seqatividade_orig&"" Then
			Set RSAtividade = ConnVooAtividade.Execute( "SELECT * FROM sig_atividade WHERE flgbloqueado <> 'S' AND seqatividade = " & ll_seqatividade )
			
			If NOT RSAtividade.EOF Then
				If IsNull( RSAtividade("hrfim") ) Then
					ll_dthrinicio_dia = ""
					ll_dthrinicio_mes = ""
					ll_dthrinicio_ano = ""
					ll_dthrinicio_hora = ""
					ll_dthrinicio_minuto = ""
					ll_dthrfim_hora = ""
					ll_dthrfim_minuto = ""
					ll_dthrfim_dia = ""
					ll_dthrfim_mes = ""
					ll_dthrfim_ano = ""
				Else
					ll_dthrinicio_dia = Right("00"&Day( ldt_dtjornada ),2)
					ll_dthrinicio_mes = Right("00"&Month( ldt_dtjornada ),2)
					ll_dthrinicio_ano = Year( ldt_dtjornada )
					ll_dthrinicio_hora = Right("00"&Hour( RSAtividade("hrinicio") ),2)
					ll_dthrinicio_minuto = Right("00"&Minute( RSAtividade("hrinicio" ) ),2)
					ll_dthrfim_hora = Right("00"&Hour( RSAtividade("hrfim") ),2)
					ll_dthrfim_minuto = Right("00"&Minute( RSAtividade("hrfim" ) ),2)
					If ll_dthrfim_hora&ll_dthrfim_minuto < ll_dthrinicio_hora&ll_dthrinicio_minuto Then
						ll_dthrfim_dia = Right("00"&Day( DateAdd("d",1,ldt_dtjornada) ),2)
						ll_dthrfim_mes = Right("00"&Month( DateAdd("d",1,ldt_dtjornada) ),2)
						ll_dthrfim_ano = Year( DateAdd("d",1,ldt_dtjornada) )
					Else
						ll_dthrfim_dia = Right("00"&Day( ldt_dtjornada ),2)
						ll_dthrfim_mes = Right("00"&Month( ldt_dtjornada ),2)
						ll_dthrfim_ano = Year( ldt_dtjornada )
					End if
				End if
			End if
		End if
		
		Response.Write( "<tr>" )
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Seleção
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td>" )
		Response.Write(       "<input type='checkbox' name='selecionado"&(ll_linhaprogramacao+ll_incrementolinha)&"' " )
		If ls_selecionado = "on" Then Response.Write(     "checked" )
		Response.Write(    "></td>" ) 
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Tipo Programação
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='flgtipo"&(ll_linhaprogramacao+ll_incrementolinha)&"' onChange='javascript:submit()'>" )
		Response.Write(          "<option value='' selected></option>" )
		Response.Write(          "<option value='V' " )
		If ls_flgtipo = "V" Then Response.Write( "selected" )
		Response.Write(             ">Voo</option>" )
		Response.Write(          "<option value='A' " )
		If ls_flgtipo = "A" Then Response.Write( "selected" )
		Response.Write(             ">Atividade</option>" )
		Response.Write(       "</select>" )
		Response.Write(       "<input type='hidden' name='flgtipo_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ls_flgtipo&">" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Empresa
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<input type='hidden' name='siglaempresa_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ls_siglaempresa&" >" )
		Response.Write(       "<select name='siglaempresa"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & " onChange='javascript:submit()'>" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 TO UBound(ls_siglaempresa_vet)
			Response.Write(       "<option value='"&ls_siglaempresa_vet(ll_contador)&"' " )
			If ls_siglaempresa = ls_siglaempresa_vet(ll_contador) Then
				Response.Write(       "selected" )
			End If
			Response.Write( ">"&ls_siglaempresa_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Número do Voo
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<input type='hidden' name='nrvoo_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ll_nrvoo&" >" )
		Response.Write(       "<input type = 'text' class='CORPO' NAME='nrvoo"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='4' size='4' id='txt_nrvoo"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_nrvoo & "' onChange='javascript:submit()'" & ls_disable_voo & ">" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Aeroporto Origem
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='seqaeroporig"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
			Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
			If NOT IsNull( ll_seqaeroporig ) AND ll_seqaeroporig > "" Then
				If CInt(ll_seqaeroporig) = CInt(ll_seqaeroporto_vet(ll_contador)) Then
					Response.Write(       "selected" )
				End If
			End if
			Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Aeroporto Destino
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='seqaeropdest"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
			Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
			If NOT IsNull( ll_seqaeropdest ) AND ll_seqaeropdest > "" Then
				If CInt(ll_seqaeropdest) = CInt(ll_seqaeroporto_vet(ll_contador)) Then
					Response.Write(       "selected" )
				End If
			End if
			Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(    "</td>" )

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Função
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='funcao"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_voo & ">" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 TO UBound(ls_codredfuncaobordo_vet)
			Response.Write(       "<option value='"&ls_codredfuncaobordo_vet(ll_contador)&"' " )
			If ls_funcao = ls_codredfuncaobordo_vet(ll_contador) Then
				Response.Write(          "selected" )
			End if
			Response.Write( ">"&ls_codfuncaobordo_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Atividade
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='seqatividade"&(ll_linhaprogramacao+ll_incrementolinha)&"' onChange='javascript:submit()'" & ls_disable_atividade & ">" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 TO UBound(ll_seqatividade_vet)
			Response.Write(       "<option value='"&ll_seqatividade_vet(ll_contador)&"' " )
			If NOT IsNull( ll_seqatividade ) AND ll_seqatividade > "" Then
				If CInt( ll_seqatividade ) = CInt( ll_seqatividade_vet(ll_contador) ) Then
					Response.Write(       "selected" )
				End If
			End if
			Response.Write( ">"&ls_codatividade_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(       "<input type='hidden' name='seqatividade_orig"&(ll_linhaprogramacao+ll_incrementolinha)&"' value="&ll_seqatividade&">" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Aeroporto Atividade
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<select name='seqaeropatividade"&(ll_linhaprogramacao+ll_incrementolinha)&"'" & ls_disable_atividade & ">" )
		Response.Write(          "<option value='' selected></option>" )
		For ll_contador = 0 To UBound(ll_seqaeroporto_vet)
			Response.Write(       "<option value='"&ll_seqaeroporto_vet(ll_contador)&"' " )
			If NOT IsNull( ll_seqaeropatividade ) AND ll_seqaeropatividade > "" Then
				If CInt( ll_seqaeropatividade ) = CInt( ll_seqaeroporto_vet(ll_contador) ) Then
					Response.Write(       "selected" )
				End If
			End If
			Response.Write( ">"&ls_codicaoiata_vet(ll_contador)&"</option>" )
		Next
		Response.Write(       "</select>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Data/Hora Início
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		If ls_flgtipo = "V" OR ls_flgtipo = "" Then
			ls_type = "hidden"
			Response.Write(    "<input type = 'text' class='CORPO' NAME='dia_aux' size='1' id='txt_dia_aux' value='" & ll_dthrinicio_dia & "' disabled>/" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='mes_aux' size='1' id='txt_mes_aux' value='" & ll_dthrinicio_mes & "' disabled>/" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='ano_aux' size='3' id='txt_ano_aux' value='" & ll_dthrinicio_ano & "' disabled>  " )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='hora_aux' size='1' id='txt_hora_aux' value='" & ll_dthrinicio_hora & "' disabled>:" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='minuto_aux' size='1' id='txt_minuto_aux' value='" & ll_dthrinicio_minuto & "' disabled>" )
		Else
			ls_type = "text"
		End if
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrinicio_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrinicio_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrinicio_dia & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "/" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrinicio_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrinicio_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrinicio_mes & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "/" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrinicio_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='4' size='3' id='txt_dthrinicio_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrinicio_ano & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "  " )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrinicio_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrinicio_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrinicio_hora & "'>" )
		If ls_flgtipo = "A" Then Response.Write( ":" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrinicio_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrinicio_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrinicio_minuto & "'>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Data/Hora Término
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		If ls_flgtipo = "V" OR ls_flgtipo = "" Then
			ls_type = "hidden"
			Response.Write(    "<input type = 'text' class='CORPO' NAME='dia_aux' size='1' id='txt_dia_aux' value='" & ll_dthrfim_dia & "' disabled>/" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='mes_aux' size='1' id='txt_mes_aux' value='" & ll_dthrfim_mes & "' disabled>/" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='ano_aux' size='3' id='txt_ano_aux' value='" & ll_dthrfim_ano & "' disabled>  " )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='hora_aux' size='1' id='txt_hora_aux' value='" & ll_dthrfim_hora & "' disabled>:" )
			Response.Write(    "<input type = 'text' class='CORPO' NAME='minuto_aux' size='1' id='txt_minuto_aux' value='" & ll_dthrfim_minuto & "' disabled>" )
		Else
			ls_type = "text"
		End if
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrfim_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrfim_dia"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrfim_dia & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "/" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrfim_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrfim_mes"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrfim_mes & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "/" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrfim_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='4' size='3' id='txt_dthrfim_ano"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrfim_ano & "'>" )
		If ls_flgtipo = "A" Then Response.Write( "  " )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrfim_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrfim_hora"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrfim_hora & "'>" )
		If ls_flgtipo = "A" Then Response.Write( ":" )
		Response.Write(       "<input type = '" & ls_type & "' class='CORPO' NAME='dthrfim_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='2' size='1' id='txt_dthrfim_minuto"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ll_dthrfim_minuto & "'>" )
		Response.Write(    "</td>" )
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Observação
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<input type = 'text' class='CORPO' NAME='observacao"&(ll_linhaprogramacao+ll_incrementolinha)&"' MaxLength='200' size='80' id='txt_observacao"&(ll_linhaprogramacao+ll_incrementolinha)&"' onKeyPress='ChecarTAB();' onKeyUp='SimulaTab(this);' onFocus='PararTAB(this);' value='" & ls_observacao & "'>" )
		Response.Write(    "</td>" )

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Partida Motor
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_partidamotor > "" Then Response.Write( Right("00"&Day(ldt_partidamotor),2) )
		Response.Write(          "' disabled>/" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_partidamotor > "" Then Response.Write( Right("00"&Month(ldt_partidamotor),2) )
		Response.Write(          "' disabled>/" )
		Response.Write(       "<input type = 'text' class='CORPO' size='3' value='" )
		If ldt_partidamotor > "" Then Response.Write( Year(ldt_partidamotor) )
		Response.Write(          "' disabled>  " )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_partidamotor > "" Then Response.Write( Right("00"&Hour(ldt_partidamotor),2) )
		Response.Write(          "' disabled>:" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_partidamotor > "" Then Response.Write( Right("00"&Minute(ldt_partidamotor),2) )
		Response.Write(          "' disabled>" )
		Response.Write(       "<input type = 'hidden' NAME='partidamotor"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='"&ldt_partidamotor&"'>" )
		Response.Write(    "</td>" )								
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' Corte Motor
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Response.Write(    "<td class='CORPO8' align='center' nowrap>" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_cortemotor > "" Then Response.Write( Right("00"&Day(ldt_cortemotor),2) )
		Response.Write(          "' disabled>/" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_cortemotor > "" Then Response.Write( Right("00"&Month(ldt_cortemotor),2) )
		Response.Write(          "' disabled>/" )
		Response.Write(       "<input type = 'text' class='CORPO' size='3' value='" )
		If ldt_cortemotor > "" Then Response.Write( Year(ldt_cortemotor) )
		Response.Write(          "' disabled>  " )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_cortemotor > "" Then Response.Write( Right("00"&Hour(ldt_cortemotor),2) )
		Response.Write(          "' disabled>:" )
		Response.Write(       "<input type = 'text' class='CORPO' size='1' value='" )
		If ldt_cortemotor > "" Then Response.Write( Right("00"&Minute(ldt_cortemotor),2) )
		Response.Write(          "' disabled>" )
		Response.Write(       "<input type = 'hidden' NAME='cortemotor"&(ll_linhaprogramacao+ll_incrementolinha)&"' value='"&ldt_cortemotor&"'>" )
		Response.Write(    "</td>" )								
		
		Response.Write(    "<input type = 'hidden' name='seqvoodiaesc"&(ll_linhaprogramacao+ll_incrementolinha)&"' value=" & ll_seqvoodiaesc & ">" )
		Response.Write(    "<input type = 'hidden' name='seqtrecho"&(ll_linhaprogramacao+ll_incrementolinha)&"' value=" & ll_seqtrecho & ">" )

		Response.Write( "</tr>" )
	Else
		' O registro foi excluído: Utiliza variável "Incremento" para criar os objetos na sequência.
		ll_incrementolinha = ll_incrementolinha - 1
		ll_qtdprogramacao = ll_qtdprogramacao - 1
	End if

	If ( strAdicionar = "" AND strExcluir = "" AND ll_pageopen = 1 ) OR ( strGravar <> "" AND strErro = "" ) Then
		RS.MoveNext
	End if
Next

Response.Write( "</table>" )

If strExcluir = "" Then
	ll_qtdprogramacao = ll_qtdprogramacao + ll_incrementolinha
End if

Response.Write( "<input type='hidden' name='qtdprogramacao' value="&ll_qtdprogramacao&" >" )

lb_permissao_gravacao = f_permissao_gravacao( Session("member"), "I07", Conn, RS )

%>
</FORM>

<%
If strErro > "" Then
	Response.Write("<script language='javascript'>")
	Response.Write("alert('" & strErro & "');")
	If strColumnErro > "" Then
		Response.Write("document.all('" & strColumnErro & "').focus();")
	End if
	Response.Write("</script>")
End if

Conn.Close
ConnVooAtividade.Close
ConnInsPlanej.Close

If strMensagem > "" Then
	Response.Write("<script language='javascript'>")
	Response.Write("alert('" & strMensagem & "');")
	Response.Write("</script>")
End if

If lb_fechar_janela Then
	ls_diasemana_vet = "Domingo,Segunda,Terça,Quarta,Quinta,Sexta,Sábado"
	ls_diasemana_vet = Split(ls_diasemana_vet, ",")
	
	Response.Write("<script language='javascript'>")
	'Response.Write("window.opener.document.Filtro.165_11.value=Teste;")
	Response.Write("window.opener.ajax('fol_consulta_jornada.asp?flgestado=" & ls_flgestado & "&textojornadaaux=" & ls_textojornadaaux & "&dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&nomeguerra=" & ls_nomeguerra & "&diasemana=" & ls_diasemana_vet(WeekDay(ldt_dtjornada)-1) & "&textojornada=" & ls_textojornada & "&','','" & ll_seqtripulante&"_"&Year(ldt_dtjornada)&Right("00"&Month(ldt_dtjornada),2)&Right("00"&Day(ldt_dtjornada),2) & "');")
	Response.Write("window.close();")
	Response.Write("</script>")
	Response.End()
End if
%>

</font>
</BODY></span>

</HTML>
