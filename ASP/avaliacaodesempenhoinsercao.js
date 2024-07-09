// JavaScript Document

	String.prototype.trim = function()
	{
		return this.replace(/^\s*/, "").replace(/\s*$/, "");
	}

	$(document).ready(function() {
		$('table#tblTripChequeUltimasAvaliacoes tbody  tr').hover(function(){
			$(this).css("background-color","#CCCC00");
			}, function(){
			$(this).css("background-color","");
		});
	});

	$(document).ready(function() {
		$('#tblTripChequeUltimasAvaliacoes').tableSorter();
	});

	$(document).ready(function($) {
		$.mask.addPlaceholder('~',"[+-]");
		$("#txtDataAvaliacao").mask("99/99/9999");
	});

	function LimparNovaAvaliacao() {
		document.getElementById('txtTripulanteAvaliado').value = '';
		document.getElementById('txtDataAvaliacao').value = '';
		document.getElementById('cmbTipoAvaliacao').value = '';
		document.getElementById('cmbItemAvaliado').value = '';
		document.getElementById('txaAvaliacao').value = '';
		document.getElementById("txtTripulanteAvaliado").focus();
		return false;
	}

	function VerificarCamposInserirNovaAvaliacao() {
		if (document.getElementById("txtTripulanteAvaliado").value.trim() == '') {
			alert('Preencha o tripulante avaliado, por favor!');
			document.getElementById("txtTripulanteAvaliado").focus();
			return false;
		}
		if (document.getElementById("txtDataAvaliacao").value.trim() == '') {
			alert('Preencha a data da avaliação, por favor!');
			document.getElementById("txtDataAvaliacao").focus();
			return false;
		}
		if (!isDataValida(document.getElementById("txtDataAvaliacao").value)) {
			alert("Preencha a data da avaliação com uma data válida, por favor!");
			document.getElementById("txtDataAvaliacao").focus();
			return false;
		}
		if (DataMaiorQueDataAtual(document.getElementById('txtDataAvaliacao').value)) {
			alert("A data da avaliação não pode ser maior do que a data atual!");
			document.getElementById("txtDataAvaliacao").focus();
			return false;
		}
		if (document.getElementById("cmbTipoAvaliacao").value.trim() == '') {
			alert('Selecione o tipo de avaliação, por favor!');
			document.getElementById("cmbTipoAvaliacao").focus();
			return false;
		}
		if (document.getElementById("cmbItemAvaliado").value.trim() == '') {
			alert('Selecione o item avaliado, por favor!');
			document.getElementById("cmbItemAvaliado").focus();
			return false;
		}
		if (document.getElementById("txaAvaliacao").value.trim() == '') {
			alert('Preencha a avaliação, por favor!');
			document.getElementById("txaAvaliacao").focus();
			return false;
		}
		if (document.getElementById("txaAvaliacao").value.trim().length > 500) {
			alert('O campo avaliação não pode ter mais do que 500 caracteres.\nVerifique a quantidade de caracteres do campo avaliação, por favor!');
			document.getElementById("txaAvaliacao").focus();
			return false;
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

	function DataMaiorQueDataAtual(strData) // Recebe a data no formato ddmmyyyy ou dd/mm/yyyy ou dd-mm-yyyy e retorna se é maior do que a data atual
	{
		var dia, mes, ano;
		if(strData.length == 10) {
			dia = strData.substr(0,2);
			mes = strData.substr(3,2);
			ano = strData.substr(6,4);
		}
		else if(strData.length == 8) {
			dia = strData.substr(0,2);
			mes = strData.substr(2,2);
			ano = strData.substr(4,4);
		}

		var diaAtual, mesAtual, anoAtual;
		var dtDataAtual = new Date();
		diaAtual = dtDataAtual.getDate();
		mesAtual = dtDataAtual.getMonth() + 1;
		anoAtual = dtDataAtual.getFullYear();

		if (ano > anoAtual) {
			return true;
		}
		else if (ano == anoAtual) {
			if (mes > mesAtual) {
				return true;
			}
			else if ((mes == mesAtual) && (dia > diaAtual)) {
				return true;
			}
		}

		return false;
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
