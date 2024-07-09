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
		If (Not IsVazio(Request.Form("btnVoltar"))) Then
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

Sub PreencherTabelaTripCheque()

	If (Not IsPostBack) Then
		Exit Sub
	End If

	If (IsVazio(Request.Form("btnPesquisar"))) Then
		Exit Sub
	End If

	Dim strTxtData1, strTxtData2
	strTxtData1 = ObterValorCampo("txtData1")
	strTxtData2 = ObterValorCampo("txtData2")

	Dim strMensagem
	strMensagem = ""
	If (Not IsVazio(strTxtData1)) Then
		If (Not IsDate(strTxtData1)) Then
			strMensagem = "Preencha a data inicial do período com uma data válida, por favor!"
		End If
	End If
	If (IsVazio(strMensagem) And Not IsVazio(strTxtData2)) Then
		If (Not IsDate(strTxtData2)) Then
			strMensagem = "Preencha a data final do período com uma data válida, por favor!"
		End If
	End If
	If (IsVazio(strMensagem) And Not IsVazio(strTxtData1) And Not IsVazio(strTxtData2)) Then
		If (CDate(strTxtData1) > CDate(strTxtData2)) Then
			strMensagem = "A data inicial do período não pode ser maior do que a data final do período!"
		End If
	End If

	If (Not IsVazio(strMensagem)) Then
		ExibeMensagemVoltaJS(strMensagem)
		Exit Sub
	End If

	Dim dtData1, dtData2
	If (Not IsVazio(strTxtData1)) Then
		dtData1 = CDate(strTxtData1)
	End If
	If (Not IsVazio(strTxtData2)) Then
		dtData2 = CDate(strTxtData2)
	End If

	Dim strTxtTripulanteAvaliado, strCmbTipoAvaliacao
	Dim strCmbItemAvaliado, strTxtAvaliador
	strTxtTripulanteAvaliado = ObterValorCampo("txtTripulanteAvaliado")
	strCmbTipoAvaliacao = ObterValorCampo("cmbTipoAvaliacao")
	strCmbItemAvaliado = ObterValorCampo("cmbItemAvaliado")
	strTxtAvaliador = ObterValorCampo("txtAvaliador")

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
	strQueryTripCheque = strQueryTripCheque & " WHERE 1 = 1 "
	If (Not IsVazio(strCmbItemAvaliado)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TC.seqitemavaliado = " & strCmbItemAvaliado & " "
	End If
	If (Not IsVazio(strCmbTipoAvaliacao)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TC.tipocheque = '" & strCmbTipoAvaliacao & "' "
	End If
	If (Not IsVazio(strTxtData1)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TC.dtcheque >= '" & FormatarDataBD(dtData1) & "' "
	End If
	If (Not IsVazio(strTxtData2)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TC.dtcheque <= '" & FormatarDataBD(dtData2) & "' "
	End If
	If (Not IsVazio(strTxtTripulanteAvaliado)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TripAvaliado.nomeguerra LIKE '%" & strTxtTripulanteAvaliado & "%' "
	End If
	If (Not IsVazio(strTxtAvaliador)) Then
		strQueryTripCheque = strQueryTripCheque & "   AND TripAvaliador.nomeguerra LIKE '%" & strTxtAvaliador & "%' "
	End If
	strQueryTripCheque = strQueryTripCheque & " ORDER BY TripAvaliado.nomeguerra ASC, TC.dtcheque DESC, TC.dtmovimento DESC "

	Dim objConnTripCheque
	Set objConnTripCheque = CreateObject("ADODB.CONNECTION")
	objConnTripCheque.Open(StringConexaoSqlServer)
	objConnTripCheque.Execute("SET DATEFORMAT ymd")

	Dim objRsTripCheque
	Set objRsTripCheque = Server.CreateObject("ADODB.Recordset")
	objRsTripCheque.Open strQueryTripCheque, objConnTripCheque

	Dim strAvaliacao, strTripulanteAvaliado, strAvaliador, strDescrItemAvaliado
	Dim dtDataCheque, strDataCheque, strTipoAvaliacao

	Dim intContCor
	intContCor = CInt(0)

	If (objRsTripCheque.EOF) Then
		Response.Write("			<tr class='corpo10'>" & vbCrLf)
		Response.Write("				<td colspan='6' style='text-align:left; padding:1px; padding-left:5px;'>" & vbCrLf)
		Response.Write("					Nenhuma avalia&#231&#227;o encontrada")
		Response.Write("				</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)
	Else
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
	End If

	objRsTripCheque.Close()
	Set objRsTripCheque = Nothing

	objConnTripCheque.Close()
	Set objConnTripCheque = Nothing

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
