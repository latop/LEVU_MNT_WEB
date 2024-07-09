<%
	Function Plic(ByVal strTexto)
		If InStr(strTexto, Chr(39)) Then
			Plic = Chr(39) & Replace(strTexto, Chr(39), Chr(39) & Chr(39)) & Chr(39)
		Else
			Plic = Chr(39) & strTexto & Chr(39)
		End If
	End Function

	function fnQtdDiasMes(pIntMes, pIntAno)
		Select Case pIntMes
			Case 1
				fnQtdDiasMes = 31
			Case 2
				if ((pIntAno Mod 4) = 0) then
					fnQtdDiasMes = 29
				else
					fnQtdDiasMes = 28
				end if
			Case 3
				fnQtdDiasMes = 31
			Case 4
				fnQtdDiasMes = 30
			Case 5
				fnQtdDiasMes = 31
			Case 6
				fnQtdDiasMes = 30
			Case 7
				fnQtdDiasMes = 31
			Case 8
				fnQtdDiasMes = 31
			Case 9
				fnQtdDiasMes = 30
			Case 10
				fnQtdDiasMes = 31
			Case 11
				fnQtdDiasMes = 30
			Case 12
				fnQtdDiasMes = 31
		End Select
	end function

	function fnMesPorExtenso(pIntMes)
		Select Case pIntMes
			Case 1
				fnMesPorExtenso = "Janeiro"
			Case 2
				fnMesPorExtenso = "Fevereiro"
			Case 3
				fnMesPorExtenso = "Março"
			Case 4
				fnMesPorExtenso = "Abril"
			Case 5
				fnMesPorExtenso = "Maio"
			Case 6
				fnMesPorExtenso = "Junho"
			Case 7
				fnMesPorExtenso = "Julho"
			Case 8
				fnMesPorExtenso = "Agosto"
			Case 9
				fnMesPorExtenso = "Setembro"
			Case 10
				fnMesPorExtenso = "Outubro"
			Case 11
				fnMesPorExtenso = "Novembro"
			Case 12
				fnMesPorExtenso = "Dezembro"
		End Select
	end function
	
	function fnDiaSemanaAbrev(pIntDiaSemana)
		Select Case pIntDiaSemana
		Case 1
			fnDiaSemanaAbrev = "DOM"
		Case 2
			fnDiaSemanaAbrev = "SEG"
		Case 3
			fnDiaSemanaAbrev = "TER"
		Case 4
			fnDiaSemanaAbrev = "QUA"
		Case 5
			fnDiaSemanaAbrev = "QUI"
		Case 6
			fnDiaSemanaAbrev = "SEX"
		Case 7
			fnDiaSemanaAbrev = "SAB"
		End Select
	end function

%>
