<%@language="vbscript" %>
<%
	for i = 1 to Request.Form.Count
		Session(Request.Form.Key(i)) = Request.Form(i)
	next

	Dim paginaDestino
	paginaDestino = Session("paginaDestino")
	Session.Contents.Remove("paginaDestino")

	Response.Redirect("../ASP/" & paginaDestino)
'	Response.Redirect("ShowSession.asp?paginaDestino=" & paginaDestino)
%>
