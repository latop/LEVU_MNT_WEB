<%
	Dim usuario, dominio, login

	usuario = Session("member")
	dominio = Session("dominio")
	login = Session("login")

	if ((usuario = "") or (dominio = "") or (login = "") or _
	    ((dominio <> 1) and (dominio <> 2) and (dominio <> 3))) then
		Response.Redirect "Default.asp"
	end if
%>