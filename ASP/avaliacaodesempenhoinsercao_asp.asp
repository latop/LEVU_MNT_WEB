<!--#include file="verificalogintripulante.asp"-->
<%
Dim IsPostBack
IsPostBack = (Request.ServerVariables("REQUEST_METHOD") = "POST")

Call Page_Load()

Function Page_Load()
	If (Not PossuiAcessoPagina()) Then
		Response.Write("<h1>Acesso negado. [" & Session("codcargo") & "/" & Session("IS_CHECADOR_CHR") & "]</h1>")
		Response.End()
	End If

	If (IsPostBack) Then
		If (Not IsVazio(Request.Form("btnInsereNovaAvaliacao"))) Then
			Call InserirNovaAvaliacao()
		ElseIf (Not IsVazio(Request.Form("btnVoltar"))) Then
			Response.Redirect("avaliacaodesempenho.asp")
		End If
	End If
End Function

Function PossuiAcessoPagina()
	Dim strCodCargoTripLogado
	strCodCargoTripLogado = Session("codcargo")
	If ((strCodCargoTripLogado = "CMTE") And Session("IS_CHECADOR_CHR")) Then
		PossuiAcessoPagina = True
	Else
		PossuiAcessoPagina = False
	End If
End Function

Sub PreencherDataEntradaPagina(idCampo)
	If (IsPostBack) Then
		Response.Write(ObterValorCampo(idCampo))
	Else
		Response.Write(Now())
	End If
End Sub

Function ObterSeqAvaliador()
	ObterSeqAvaliador = Session("member")
End Function

Function ObterValorCampo(idCampo)
	ObterValorCampo = Request.Form(idCampo)
End Function

Sub PreencherCampo(idCampo)
	Response.Write(ObterValorCampo(idCampo))
End Sub

Sub PreencherItemAvaliado(idCmbItemAvaliado)

	Dim strQueryItemAvaliado
	strQueryItemAvaliado = "SELECT seqitemavaliado, descritemavaliado FROM sig_itemavaliado ORDER BY descritemavaliado ASC"

	Dim objConnItemAvaliado
	Set objConnItemAvaliado = CreateObject("ADODB.CONNECTION")
	objConnItemAvaliado.Open(StringConexaoSqlServer)

	Dim objRsItemAvaliado
	Set objRsItemAvaliado = Server.CreateObject("ADODB.Recordset")
	objRsItemAvaliado.Open strQueryItemAvaliado, objConnItemAvaliado

	Dim strListaSeqItemAvaliado, strListaDescrItemAvaliado
	strListaSeqItemAvaliado = ""
	strListaDescrItemAvaliado = ""
	Do While (Not objRsItemAvaliado.EOF)
		strListaSeqItemAvaliado = strListaSeqItemAvaliado & "||" & objRsItemAvaliado("seqitemavaliado")
		strListaDescrItemAvaliado = strListaDescrItemAvaliado & "||" & objRsItemAvaliado("descritemavaliado")
		objRsItemAvaliado.MoveNext()
	Loop

	objRsItemAvaliado.Close()
	Set objRsItemAvaliado = Nothing

	objConnItemAvaliado.Close()
	Set objConnItemAvaliado = Nothing

	Dim arrSeqItemAvaliado, arrDescrItemAvaliado
	arrSeqItemAvaliado = Split(strListaSeqItemAvaliado, "||")
	arrDescrItemAvaliado = Split(strListaDescrItemAvaliado, "||")

	Dim strSeqItemAvaliadoSelecionado
	strSeqItemAvaliadoSelecionado = ObterValorCampo(idCmbItemAvaliado)

	Dim intCont
	For intCont = 1 To UBound(arrSeqItemAvaliado)
		Response.Write("<option value='" & arrSeqItemAvaliado(intCont) & "'")
		If (Not IsVazio(strSeqItemAvaliadoSelecionado)) Then
			If (CInt(arrSeqItemAvaliado(intCont)) = CInt(strSeqItemAvaliadoSelecionado)) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrDescrItemAvaliado(intCont) & "</option>" & vbCrLf)
	Next

End Sub

Sub PreencherTipoAvaliacao(idCmbTipoAvaliacao)

	Dim strListaIdTipoAvaliacao, strListaDescrTipoAvaliacao
	strListaIdTipoAvaliacao = "||R||S"
	strListaDescrTipoAvaliacao = "||Rota||Simulador"

	Dim arrIdTipoAvaliacao, arrDescrTipoAvaliacao
	arrIdTipoAvaliacao = Split(strListaIdTipoAvaliacao, "||")
	arrDescrTipoAvaliacao = Split(strListaDescrTipoAvaliacao, "||")

	Dim strIdTipoAvaliacaoSelecionado
	strIdTipoAvaliacaoSelecionado = ObterValorCampo(idCmbTipoAvaliacao)

	Dim intCont
	For intCont = 1 To UBound(arrIdTipoAvaliacao)
		Response.Write("<option value='" & arrIdTipoAvaliacao(intCont) & "'")
		If (Not IsVazio(strIdTipoAvaliacaoSelecionado)) Then
			If (arrIdTipoAvaliacao(intCont) = strIdTipoAvaliacaoSelecionado) Then
				Response.Write(" selected='selected'")
			End if
		End if
		Response.Write(">" & arrDescrTipoAvaliacao(intCont) & "</option>" & vbCrLf)
	Next

End Sub

Sub PreencherTabelaTripChequeUltimasAvaliacoes()

	Dim strHidDataEntradaPagina
	strHidDataEntradaPagina = ObterValorCampo("hidDataEntradaPagina")
	If (IsVazio(strHidDataEntradaPagina)) Then
		strHidDataEntradaPagina = Now()
	End If

	Dim dtDataEntradaPagina
	dtDataEntradaPagina = CDate(strHidDataEntradaPagina)

	Dim dtDataCorteUltimasAtualizacoes
	dtDataCorteUltimasAtualizacoes = DateAdd("h", -8, dtDataEntradaPagina)

	' **********************
	' *** sig_tripcheque ***
	' **********************
	Dim strQueryTripCheque
	strQueryTripCheque =                      " SELECT "
	strQueryTripCheque = strQueryTripCheque & "        TC.seqtripulante SEQ_TRIPULANTE, "
	strQueryTripCheque = strQueryTripCheque & "        TC.dtcheque DATA_CHEQUE, "
	strQueryTripCheque = strQueryTripCheque & "        TC.seqchecador SEQ_CHECADOR, "
	strQueryTripCheque = strQueryTripCheque & "        TC.seqitemavaliado SEQ_ITEM_AVALIADO, "
	strQueryTripCheque = strQueryTripCheque & "        TC.avaliacao AVALIACAO, "
	strQueryTripCheque = strQueryTripCheque & "        TC.tipocheque TIPO_AVALIACAO, "
	strQueryTripCheque = strQueryTripCheque & "        TripAvaliado.nomeguerra TRIPULANTE_AVALIADO, "
	strQueryTripCheque = strQueryTripCheque & "        TripAvaliador.nomeguerra AVALIADOR, "
	strQueryTripCheque = strQueryTripCheque & "        IA.descritemavaliado DESCR_ITEM_AVALIADO "
	strQueryTripCheque = strQueryTripCheque & " FROM sig_tripcheque TC "
	strQueryTripCheque = strQueryTripCheque & "      INNER JOIN sig_tripulante TripAvaliado ON TripAvaliado.seqtripulante = TC.seqtripulante "
	strQueryTripCheque = strQueryTripCheque & "      INNER JOIN sig_tripulante TripAvaliador ON TripAvaliador.seqtripulante = TC.seqchecador "
	strQueryTripCheque = strQueryTripCheque & "      INNER JOIN sig_itemavaliado IA ON IA.seqitemavaliado = TC.seqitemavaliado "
	strQueryTripCheque = strQueryTripCheque & " WHERE TC.dtmovimento >= '" & FormatarDataHoraBD(dtDataCorteUltimasAtualizacoes) & "' "
	strQueryTripCheque = strQueryTripCheque & "   AND TripAvaliador.seqtripulante = " & ObterSeqAvaliador() & " "
	strQueryTripCheque = strQueryTripCheque & " ORDER BY TC.dtmovimento DESC "

	Dim objConnTripCheque
	Set objConnTripCheque = CreateObject("ADODB.CONNECTION")
	objConnTripCheque.Open(StringConexaoSqlServer)
	objConnTripCheque.Execute("SET DATEFORMAT ymd")

	Dim objRsTripCheque
	Set objRsTripCheque = Server.CreateObject("ADODB.Recordset")
	objRsTripCheque.Open strQueryTripCheque, objConnTripCheque

	Dim strTripulanteAvaliado, dtDataCheque, strDataCheque
	Dim strTipoAvaliacao, strDescrItemAvaliado, strAvaliacao, strAvaliador

	Dim intContCor
	intContCor = CInt(0)

	Do While Not objRsTripCheque.EOF
		strTripulanteAvaliado = objRsTripCheque("TRIPULANTE_AVALIADO")
		If (IsVazio(strTripulanteAvaliado)) Then strTripulanteAvaliado = "&nbsp;"

		dtDataCheque = objRsTripCheque("DATA_CHEQUE")
		If (IsVazio(dtDataCheque)) Then
			strDataCheque = "&nbsp;"
		Else
			strDataCheque = Right("00" & Day(dtDataCheque), 2) & "/" & Right("00" & Month(dtDataCheque), 2) & "/" & Year(dtDataCheque)
		End If

		strTipoAvaliacao = objRsTripCheque("TIPO_AVALIACAO")
		If (IsVazio(strTipoAvaliacao)) Then
			strTipoAvaliacao = "&nbsp;"
		ElseIf (strTipoAvaliacao = "S") Then
			strTipoAvaliacao = "Simulador"
		ElseIf (strTipoAvaliacao = "R") Then
			strTipoAvaliacao = "Rota"
		End If

		strDescrItemAvaliado = objRsTripCheque("DESCR_ITEM_AVALIADO")
		If (IsVazio(strDescrItemAvaliado)) Then strDescrItemAvaliado = "&nbsp;"

		strAvaliacao = objRsTripCheque("AVALIACAO")
		If (IsVazio(strAvaliacao)) Then strAvaliacao = "&nbsp;"

		strAvaliador = objRsTripCheque("AVALIADOR")
		If (IsVazio(strAvaliador)) Then strAvaliador = "&nbsp;"

		Response.Write("			<tr class='corpo' bgcolor='" & ObterCorFundoLinha(intContCor) & "'>" & vbCrLf)
		Response.Write("				<td style='text-align:left; padding:1px; padding-left:5px;'>" & strTripulanteAvaliado & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:center; padding:1px;'>" & strDataCheque & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:left; padding:1px; padding-left:5px;'>" & strTipoAvaliacao & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:left; padding:1px; padding-left:5px;'>" & strDescrItemAvaliado & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:left; padding:1px; padding-left:5px;'>" & strAvaliacao & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:left; padding:1px; padding-left:5px;'>" & strAvaliador & "</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)

		intContCor = intContCor + 1

		objRsTripCheque.MoveNext()
	Loop

	objRsTripCheque.Close()
	Set objRsTripCheque = Nothing

	objConnTripCheque.Close()
	Set objConnTripCheque = Nothing

End Sub

Sub InserirNovaAvaliacao()

	Dim strTxtTripulanteAvaliado
	strTxtTripulanteAvaliado = Trim(ObterValorCampo("txtTripulanteAvaliado"))

	Dim strTxtDataAvaliacao
	strTxtDataAvaliacao = Trim(ObterValorCampo("txtDataAvaliacao"))

	Dim strCmbTipoAvaliacao
	strCmbTipoAvaliacao = Trim(ObterValorCampo("cmbTipoAvaliacao"))

	Dim strCmbItemAvaliado
	strCmbItemAvaliado = Trim(ObterValorCampo("cmbItemAvaliado"))

	Dim strTxaAvaliacao
	strTxaAvaliacao = Trim(ObterValorCampo("txaAvaliacao"))

	Dim strMensagem
	strMensagem = ""
	If (IsVazio(strTxtTripulanteAvaliado)) Then
		strMensagem = "Preencha o tripulante avaliado, por favor!"
	ElseIf (IsVazio(strTxtDataAvaliacao)) Then
		strMensagem = "Preencha a data da avaliação, por favor!"
	ElseIf (Not IsDate(strTxtDataAvaliacao)) Then
		strMensagem = "Preencha a data da avaliação com uma data válida, por favor!"
	ElseIf (CDate(strTxtDataAvaliacao) > Now()) Then
		strMensagem = "A data da avaliação não pode ser maior do que a data atual!"
	ElseIf (IsVazio(strCmbTipoAvaliacao)) Then
		strMensagem = "Selecione o tipo de avaliação, por favor!"
	ElseIf (IsVazio(strCmbItemAvaliado)) Then
		strMensagem = "Selecione o item avaliado, por favor!"
	ElseIf (IsVazio(strTxaAvaliacao)) Then
		strMensagem = "Preencha a avaliação, por favor!"
	ElseIf (Len(strTxaAvaliacao) > 500) Then
		strMensagem = "O campo avaliação não pode ter mais do que 500 caracteres.\nVerifique a quantidade de caracteres do campo avaliação, por favor!"
	End If

	If (Not IsVazio(strMensagem)) Then
		ExibeMensagemVoltaJS(strMensagem)
		Exit Sub
	End If

	' **********************
	' *** sig_tripulante ***
	' **********************
	Dim strQueryTripulante
	strQueryTripulante =                      " SELECT "
	strQueryTripulante = strQueryTripulante & "        Trip.seqtripulante, "
	strQueryTripulante = strQueryTripulante & "        Trip.nomeguerra "
	strQueryTripulante = strQueryTripulante & " FROM sig_tripulante Trip "
	strQueryTripulante = strQueryTripulante & " WHERE UPPER(Trip.nomeguerra) = UPPER('" & strTxtTripulanteAvaliado & "') "

	Dim objConnInsertTripCheque
	Set objConnInsertTripCheque = CreateObject("ADODB.CONNECTION")
	objConnInsertTripCheque.Open(StringConexaoSqlServer)
	objConnInsertTripCheque.Execute("SET DATEFORMAT ymd")

	Dim objRsTripulante
	Set objRsTripulante = Server.CreateObject("ADODB.Recordset")
	objRsTripulante.Open strQueryTripulante, objConnInsertTripCheque

	Dim intSeqTripulante
	If (objRsTripulante.EOF) Then
		strMensagem = "O nome de guerra informado para o tripulante avaliado não existe.\nPreencha o tripulante avaliado com um nome de guerra válido, por favor!"
	Else
		intSeqTripulante = CInt(objRsTripulante("seqtripulante"))
		objRsTripulante.MoveNext()
		If (Not objRsTripulante.EOF) Then
			strMensagem = "O nome de guerra informado para o tripulante avaliado não é único.\nVerifique esse problema com o administrador do sistema, por favor!"
		End If
	End If

	objRsTripulante.Close()
	Set objRsTripulante = Nothing

	If (Not IsVazio(strMensagem)) Then
		objConnInsertTripCheque.Close()
		Set objConnInsertTripCheque = Nothing
		ExibeMensagemVoltaJS(strMensagem)
		Exit Sub
	End If

	Dim intCmbItemAvaliado
	intCmbItemAvaliado = CInt(strCmbItemAvaliado)

	Dim dtDataAvaliacao
	dtDataAvaliacao = CDate(strTxtDataAvaliacao)

	' **********************
	' *** sig_tripcheque ***
	' **********************
	Dim strInsertTripCheque
	strInsertTripCheque =                       " INSERT INTO sig_tripcheque "
	strInsertTripCheque = strInsertTripCheque & " (seqtripulante, "
	strInsertTripCheque = strInsertTripCheque & "  dtcheque, "
	strInsertTripCheque = strInsertTripCheque & "  seqchecador, "
	strInsertTripCheque = strInsertTripCheque & "  seqitemavaliado, "
	strInsertTripCheque = strInsertTripCheque & "  avaliacao, "
	strInsertTripCheque = strInsertTripCheque & "  dtmovimento, "
	strInsertTripCheque = strInsertTripCheque & "  tipocheque) "
	strInsertTripCheque = strInsertTripCheque & " VALUES "
	strInsertTripCheque = strInsertTripCheque & " (" & intSeqTripulante & ", "
	strInsertTripCheque = strInsertTripCheque & "  '" & FormatarDataBD(dtDataAvaliacao) & "', "
	strInsertTripCheque = strInsertTripCheque & "  " & ObterSeqAvaliador() & ", "
	strInsertTripCheque = strInsertTripCheque & "  " & intCmbItemAvaliado & ", "
	strInsertTripCheque = strInsertTripCheque & "  '" & strTxaAvaliacao & "', "
	strInsertTripCheque = strInsertTripCheque & "  GETDATE(), "
	strInsertTripCheque = strInsertTripCheque & "  '" & strCmbTipoAvaliacao & "'); "

	objConnInsertTripCheque.Execute(strInsertTripCheque)

	objConnInsertTripCheque.Close()
	Set objConnInsertTripCheque = Nothing

	strMensagem = "Operação efetuada com sucesso!"
	ExibeMensagemJS(strMensagem)

End Sub



' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
Function ObterCorFundoLinha(intNumLinha)

	Dim Cor1, Cor2, Cor
	Cor1 = "#FFFFFF"
	Cor2 = "#EEEEEE"

	If ((intNumLinha MOD 2) = 0) Then
		Cor = Cor1
	Else
		Cor = Cor2
	End If

	ObterCorFundoLinha = Cor

End Function

Function FormatarDataBD(dtData)

	Dim strDia, strMes, strAno
	strDia = Day(dtData)
	strMes = Month(dtData)
	strAno = Year(dtData)
	FormatarDataBD = strAno & "-" & strMes & "-" & strDia

End Function

Function FormatarDataHoraBD(dtData)

	Dim strDia, strMes, strAno
	Dim strHora, strMinuto, strSegundo
	strDia = Day(dtData)
	strMes = Month(dtData)
	strAno = Year(dtData)
	strHora = Hour(dtData)
	strMinuto = Minute(dtData)
	strSegundo = Second(dtData)
	FormatarDataHoraBD = strAno & "-" & strMes & "-" & strDia & " " & strHora & ":" & strMinuto & ":" & strSegundo

End Function

Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

Sub ExibeMensagemJS(mensagem)

	Response.Write("<script language='javascript' type='text/javascript'> " & vbCrLf)
	Response.Write("	alert(' " & mensagem & " '); " & vbCrLf)
	Response.Write("</script> " & vbCrLf)

End Sub

Sub ExibeMensagemVoltaJS(mensagem)

	Response.Write("<script language='javascript' type='text/javascript'> " & vbCrLf)
	Response.Write("	alert(' " & mensagem & " '); " & vbCrLf)
	Response.Write("	history.go(-1);" & vbCrLf)
	Response.Write("</script> " & vbCrLf)

End Sub

Sub RedirectJS(target)

	Response.Write("<script language='javascript' type='text/javascript'> " & vbCrLf)
	Response.Write("	document.location.href ='" & target & "'; " & vbCrLf)
	Response.Write("</script> " & vbCrLf)

End Sub

Sub ColocarFocoJS(idElemento)

	Response.Write("<script language='javascript' type='text/javascript'> " & vbCrLf)
	Response.Write("	document.getElementById('" & idElemento & "').focus(); " & vbCrLf)
	Response.Write("</script> " & vbCrLf)

End Sub

%>
