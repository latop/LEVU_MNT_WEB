<%@language="vbscript" %>
<%
	Dim usuario, dominio, login

	usuario = Session("member")
	dominio = Session("dominio")
	login = Session("login")

	if ((usuario = "") or (dominio = "") or (login = "") or _
	    ((dominio <> 1) and (dominio <> 2) and (dominio <> 3))) then
		Response.Redirect("../ASP/Default.asp")
		Response.End()
	end if

	Response.Write("<html>")
	Response.Write("<head>")
	Response.Write("	<title></title>")
	Response.Write("</head>")
	Response.Write("<body>")
	Response.Write("<form id='formASP' action='ASP2ASPX.aspx' method='post'>")

	for each Item in Session.Contents
		Response.Write("	<input type='hidden' name='" & Item & "' value='" & Session(Item) & "' />")
	next

	Response.Write("	<input type='hidden' name='paginaDestino' value='" & Request.QueryString("paginaDestino") & "' />")
	Response.Write("	<input type='hidden' name='dominioDestino' value='" & Request.QueryString("dominioDestino") & "' />")

	Response.Write("</form>")
	Response.Write("</body>")
	Response.Write("</html>")

	Response.Write("<script type='text/javascript'>")
	Response.Write("	document.getElementById('formASP').submit();")
	Response.Write("</script>")
%>
