	function VerificarCampos()
	{
		if (document.getElementById('txtData').value == '')
		{
			alert('Informe a data, por favor!');
			document.getElementById('txtData').focus();
			return false;
		}

		return true;
	}

	$(document).ready(function()
	{
		$('table#Table3 tbody  tr').hover(function(){
			$(this).css("background-color","#CCCC00");
		}, function(){
			$(this).css("background-color","");
		});
		$('#Table3').tableSorter();
	});

	$(document).ready(function($)
	{
		$.mask.addPlaceholder('~',"[+-]");
		$("#txtData").mask("99/99/9999");
	});
