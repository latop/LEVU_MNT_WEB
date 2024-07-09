<%
	Dim usuario, dominio, login

	usuario = Session("member")
	dominio = Session("dominio")
	login = Session("login")

	if ((usuario = "") or (dominio = "") or (login = "") or (dominio <> 3)) then
		Response.Redirect "Default.asp"
	end if
%>