String.prototype.trim = function()
{
return this.replace(/^\s*/, "").replace(/\s*$/, "");
}

function excluirRegistro(){
	
	var answer= confirm('Deseja excluir esse registro?'); 
	if (answer){	
		document.getElementById('hiddenAcao').value = "e";
		document.form1.submit();
	};

}

function gravarAlterarRegistro(){

	unLockCampos();

	if (document.getElementById('hiddenAcao').value != "i"){
		document.getElementById('hiddenAcao').value = "a";
	}

	if (VerificaCampos())
	{
		document.form1.submit();
	}

}

$(document).ready(function($){
	$.mask.addPlaceholder('~',"[+-]");
	$("#txtData").mask("99/99/9999");
	$("#txtDtAcaoMnt").mask("99/99/9999");
	$("#txtDiarioBordo").mask("999/aa-aaa/99-99");
});


function habilitarGravarAtualizar(){
	
	//alert("function habilitarGravarAtualizar");
	
	
	if (!isDataValida(document.getElementById("txtData").value)){
		alert("data inválida");
			//document.getElementById("btnTemp").disabled = "false";
	}
	else {
		document.getElementById("btnTemp").disabled = false;
//		alert("data válida");
	}
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

function lockCampos(){

	if (document.getElementById("hiddenLock").value == "true"){
	
		document.getElementById("txtData").disabled = "disabled";	
		document.getElementById("comboAeronave").disabled = "disabled";	
		document.getElementById("txtVoo").disabled = "disabled";	
		document.getElementById("comboOrigem").disabled = "disabled";	
		document.getElementById("comboDestino").disabled = "disabled";	
		document.getElementById("botaoCalendario").disabled = "disabled";	
	
	}
}


function unLockCampos(){

	document.getElementById("txtData").disabled = 0;	
	document.getElementById("comboAeronave").disabled = 0;	
	document.getElementById("txtVoo").disabled = 0;	
	document.getElementById("comboOrigem").disabled = 0;	
	document.getElementById("comboDestino").disabled = 0;	
	document.getElementById("botaoCalendario").disabled = 0;	

}

function VerificaCampos() {

	// *********************************
	// ***  Reporte de Discrepancia  ***
	// *********************************
	if (document.getElementById("txtData").value.trim() == '') {
		alert('Preencha o campo Data no Reporte de Discrepancia, por favor!');
		document.getElementById("txtData").focus();
		return false;
	}
	if (isDataValida(document.getElementById("txtData").value) != true){
		alert("Informe uma Data valida no Reporte de Discrepancia, por favor!");
		document.getElementById("txtData").focus();
		return false;
	}
	if (document.getElementById("comboAeronave").value == '0') {
		alert('Selecione a Aeronave no Reporte de Discrepancia, por favor!');
		document.getElementById("comboAeronave").focus();
		return false;
	}
	if ( (document.getElementById("txtVoo").value.trim() != '') &&
	     (document.getElementById("comboOrigem").value == '0') ) {
		alert("Caso o campo Voo esteja preenchido, torna-se necessario selecionar a Etapa correspondente!");
		document.getElementById("comboOrigem").focus();
		return false;
	}
	if ( (document.getElementById("txtVoo").value.trim() != '') &&
	     (document.getElementById("comboDestino").value == '0') ) {
		alert("Caso o campo Voo esteja preenchido, torna-se necessario selecionar a Etapa correspondente!");
		document.getElementById("comboDestino").focus();
		return false;
	}
	if (document.getElementById("txtDescrDiscrep").value.trim() == '') {
		alert('Preencha a descricao do Reporte de Discrepancia, por favor!');
		document.getElementById("txtDescrDiscrep").focus();
		return false;
	}
	if (document.getElementById("txtDiarioBordo").value.trim() == '') {
		alert('Preencha o campo TLB/PG no Reporte de Discrepancia, por favor!');
		document.getElementById("txtDiarioBordo").focus();
		return false;
	}

	// ****************************
	// ***  Acao de Manutencao  ***
	// ****************************
	if (document.getElementById("txtDtAcaoMnt").value.trim() == '') {
		alert('Preencha o campo Data na Acao de Manutencao, por favor!');
		document.getElementById("txtDtAcaoMnt").focus();
		return false;
	}
	if (isDataValida(document.getElementById("txtDtAcaoMnt").value) != true){
		alert("Informe uma Data valida na Acao de Manutencao, por favor!");
		document.getElementById("txtDtAcaoMnt").focus();
		return false;
	}
	if (document.getElementById("comboAta100").value == '0') {
		alert('Selecione a ATA 100 na Acao de Manutencao, por favor!');
		document.getElementById("comboAta100").focus();
		return false;
	}
	if (document.getElementById("txtBaseStation").value.trim() == '') {
		alert('Preencha o campo Base Station na Acao de Manutencao, por favor!');
		document.getElementById("txtBaseStation").focus();
		return false;
	}
	if (document.getElementById("txtCodAnac").value.trim() == '') {
		alert('Preencha o campo Cod. Anac na Acao de Manutencao, por favor!');
		document.getElementById("txtCodAnac").focus();
		return false;
	}
	if (document.getElementById("txtDescrMnt").value.trim() == '') {
		alert('Preencha a descricao da Acao de Manutencao, por favor!');
		document.getElementById("txtDescrMnt").focus();
		return false;
	}
	if (document.getElementById("txtE1").value.trim() == '') {
		alert('Preencha o campo E1 na Acao de Manutencao, por favor!');
		document.getElementById("txtE1").focus();
		return false;
	}
	if (document.getElementById("txtE2").value.trim() == '') {
		alert('Preencha o campo E2 na Acao de Manutencao, por favor!');
		document.getElementById("txtE2").focus();
		return false;
	}
	if (document.getElementById("txtAPU").value.trim() == '') {
		alert('Preencha o campo APU na Acao de Manutencao, por favor!');
		document.getElementById("txtAPU").focus();
		return false;
	}
	if (document.getElementById("txtHA1G").value.trim() == '') {
		alert('Preencha o campo HA1G na Acao de Manutencao, por favor!');
		document.getElementById("txtHA1G").focus();
		return false;
	}

	return true;
}
