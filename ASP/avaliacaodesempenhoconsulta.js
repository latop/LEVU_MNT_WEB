// JavaScript Document

	String.prototype.trim = function()
	{
		return this.replace(/^\s*/, "").replace(/\s*$/, "");
	}

	$(document).ready(function() {
		$('table#tblTripCheque tbody  tr').hover(function(){
			$(this).css("background-color","#CCCC00");
			}, function(){
			$(this).css("background-color","");
		});
	});

	$(document).ready(function() {
		$('#tblTripCheque').tableSorter();
	});

	$(document).ready(function($) {
		$.mask.addPlaceholder('~',"[+-]");
		$("#txtData1").mask("99/99/9999");
		$("#txtData2").mask("99/99/9999");
	});

	function VerificarCamposPesquisa() {
		if ((document.getElementById("txtData1").value.trim() != '') &&
			(!isDataValida(document.getElementById("txtData1").value))) {
			alert("Preencha a data inicial do período com uma data válida, por favor!");
			document.getElementById("txtData1").focus();
			return false;
		}
		if ((document.getElementById("txtData2").value.trim() != '') &&
			(!isDataValida(document.getElementById("txtData2").value))) {
			alert("Preencha a data final do período com uma data válida, por favor!");
			document.getElementById("txtData2").focus();
			return false;
		}
		if ((document.getElementById("txtData1").value.trim() != '') &&
			(document.getElementById("txtData2").value.trim() != '')) {
			if (ComparaDatas(document.getElementById('txtData1').value, document.getElementById('txtData2').value) > 0) {
				alert("A data inicial do período não pode ser maior do que a data final do período!");
				document.getElementById("txtData1").focus();
				return false;
			}
		}
		return true;
	}

	function isDataValida(data) // Recebe a data no formato ddmmyyyy ou dd/mm/yyyy ou dd-mm-yyyy e retorna se está correta
	{
		var dia, mes, ano;
		var valida = false;
		var menorAno = 1900, maiorAno = 2100, nDiasMes; // Atribui o maior e o menor valor de ano.
				
		if(data.length == 8 || data.length == 10)
		{
			if(data.length == 10 && data.charAt(2) == '-' || data.charAt(2) == '/'){
				dia = data.substr(0,2);
				mes = data.substr(3,2);
				ano = data.substr(6,4);

			}else
			if(data.length == 8 && !isNaN(data.charAt(2))){
				dia = data.substr(0,2);
				mes = data.substr(2,2);
				ano = data.substr(4,4);

			}
			
			nDiasMes = numDiasMes(ano,mes);
		
			if(ano >= menorAno && ano <= maiorAno){
				if(mes > 0 && mes <= 12){
					if(dia > 0 && dia <= nDiasMes){
						valida = true;
					}
				}
			}
			
		}
		return valida;
	}

	function numDiasMes(ano, mes)//retorna o numero de dias no mês.
	{
		var numDias = 30;
		if(mes < 8 && mes % 2 != 0 || mes >=8 && mes % 2 == 0){
			numDias = 31;
		}else
		if(mes == 2){
			numDias = isAnoBissexto(ano) ? 29 : 28;
		}	
		return numDias;
	}

	function isAnoBissexto(ano)//retorna ano bissesto ou não
	{
		return ano % 400 == 0 || ano % 4 == 0 && ano % 100 != 0 ? true : false;
	}

	function ComparaDatas(strData1, strData2) // Recebe as datas no formato ddmmyyyy ou dd/mm/yyyy ou dd-mm-yyyy e retorna 0 se strData1 é igual a strData2, -1 se strData1 é menor do que strData2 e 1 se strData1 é maior do que strData2
	{
		var dia1, mes1, ano1;
		if(strData1.length == 10) {
			dia1 = strData1.substr(0,2);
			mes1 = strData1.substr(3,2);
			ano1 = strData1.substr(6,4);
		}
		else if(strData1.length == 8) {
			dia1 = strData1.substr(0,2);
			mes1 = strData1.substr(2,2);
			ano1 = strData1.substr(4,4);
		}

		var dia2, mes2, ano2;
		if(strData2.length == 10) {
			dia2 = strData2.substr(0,2);
			mes2 = strData2.substr(3,2);
			ano2 = strData2.substr(6,4);
		}
		else if(strData2.length == 8) {
			dia2 = strData2.substr(0,2);
			mes2 = strData2.substr(2,2);
			ano2 = strData2.substr(4,4);
		}

		if ((ano1 == ano2) && (mes1 == mes2) && (dia1 == dia2)) {
			return 0;
		}

		if (ano1 > ano2) {
			return 1;
		}
		else if (ano1 == ano2) {
			if (mes1 > mes2) {
				return 1;
			}
			else if ((mes1 == mes2) && (dia1 > dia2)) {
				return 1;
			}
		}

		return -1;
	}

	function lookup(txtNomeGuerra) {
		if(txtNomeGuerra.length == 0) {
			// Hide the suggestion box.
			$('#suggestions').hide();
		} else {
			$.post("avaliacaodesempenhodados.asp", {queryString: ""+txtNomeGuerra+""}, function(data){
				if(data.length >0) {
					$('#suggestions').show();
					$('#autoSuggestionsList').html(data);
				}
			});
		}
	}

	function fill(thisValue) {
		$('#txtTripulanteAvaliado').val(thisValue);
		setTimeout("$('#suggestions').hide();", 200);
	}
