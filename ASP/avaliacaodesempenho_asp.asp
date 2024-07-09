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
		If (Not IsVazio(Request.Form("btnPesquisar"))) Then
			Response.Redirect("avaliacaodesempenhoconsulta.asp")
		ElseIf (Not IsVazio(Request.Form("btnNovaAvaliacao"))) Then
			Response.Redirect("avaliacaodesempenhoinsercao.asp")
		ElseIf (Not IsVazio(Request.Form("btnVoltar"))) Then
			Response.Redirect("@~/TRIPULANTES/Home.aspx")
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



' *****************************************************************************
' *****************************************************************************
' *****************************************************************************
Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

%>
