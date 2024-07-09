<%
   
Dim dia1, mes1, ano1
Dim dia2, mes2, ano2

dia1 = Request.form("dia1")
mes1 = Request.form("mes1")
ano1 = Request.form("ano1")
dia2 = Request.form("dia2")
mes2 = Request.form("mes2")
ano2 = Request.form("ano2")

if isDate(ano1&"/"&mes1&"/"&dia1) and isDate(ano2&"/"&mes2&"/"&dia2) then
   'response.Write("na_Consulta_nota.asp?dia_ini=" & dia1 & "&mes_ini=" & mes1 & "&ano_ini=" & ano1 & "&dia_fim=" & dia2 & "&mes_fim=" & mes2 & "&ano_fim=" & ano2)
   'response.End()
   Response.Redirect("na_Consulta_nota.asp?dia_ini=" & dia1 & "&mes_ini=" & mes1 & "&ano_ini=" & ano1 & "&dia_fim=" & dia2 & "&mes_fim=" & mes2 & "&ano_fim=" & ano2)
else
   Response.Redirect("na_Consulta_nota.asp")
end if

%>