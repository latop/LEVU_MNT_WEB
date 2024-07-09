<head>
</head>
<body>
<%
Dim ls_color, ls_textojornadaaux, ldt_dtjornada, ll_seqtripulante, ls_codfrota, ls_codcargo, ll_seqcidade, ls_nomeguerra, ls_diasemana, ls_textojornada
Dim ls_flgestado

ls_flgestado = Request.QueryString("flgestado")
ls_textojornadaaux = Request.QueryString("textojornadaaux")
ldt_dtjornada = Request.QueryString("dtjornada")
ll_seqtripulante = Request.QueryString("seqtripulante")
ls_codfrota = Request.QueryString("codfrota")
ls_codcargo = Request.QueryString("codcargo")
ll_seqcidade = Request.QueryString("seqcidade")
ls_nomeguerra = Request.QueryString("nomeguerra")
ls_diasemana = Request.QueryString("diasemana")
ls_textojornada = Request.QueryString("textojornada")

If ls_flgestado = "N" Then
	ls_color = "#000000"
ElseIf ls_flgestado = "A" Then
	ls_color = "#C00000"
ElseIf ls_flgestado = "V" Then
	ls_color = "#800000"
ElseIf ls_flgestado = "R" Then
	ls_color = "#C0C0C0"
Else
	ls_color = "#000080"
End If

Response.Write(   "<table width='90'>")
Response.Write(      "<tr>")
Response.Write(         "<td class='CORPO6' align='left'><font color='" & ls_color & "'>")
If Trim(ls_textojornadaaux) > "" Then
	Response.Write( Trim( ls_textojornadaaux ) )
End if
Response.Write(            "</font>")
Response.Write(         "</td>")
Response.Write(         "<td valign='top' align='right'>")

Response.Write(            "<a href='fol_programacao.asp?dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "' onmouseout='hideddrivetip()' onmouseover='ddrivetip(&quot;<font class=corpo7>" & ls_nomeguerra & "<br>" & Right("00"&Day(ldt_dtjornada),2)&"/"&Right("00"&Month(ldt_dtjornada),2)&"/"&Year(ldt_dtjornada) & " (" & ls_diasemana & ")</font>&quot;)'; onclick='window.open(&quot;fol_programacao.asp?dtjornada=" & ldt_dtjornada & "&seqtripulante=" & ll_seqtripulante & "&codfrota=" & ls_codfrota & "&codcargo=" & ls_codcargo & "&seqcidade=" & ll_seqcidade & "&quot;,&quot;popup&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=990,height=430&quot;);return false;' ><img src='imagens/edit_reg.gif' align='right' border='0'></a>" )

Response.Write(         "</td>")
Response.Write(      "</tr>")
Response.Write(   "</table>")
Response.Write(   "<table width='90' height='25'>")
Response.Write(      "<tr>")
Response.Write(         "<td class='CORPO6' valign='top' align='center'><font color='" & ls_color & "'>")
If ls_textojornada > "" Then
	Response.Write( Replace( Trim( ls_textojornada ), "/", " / " ) )
End if
Response.Write(            "</font>")
Response.Write(         "</td>" )
Response.Write(      "</tr>")
Response.Write(   "</table>")
%>
</body>
</html>
