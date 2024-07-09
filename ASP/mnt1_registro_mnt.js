// JavaScript Document

function novoRegistro(){

	var data1 = document.getElementById('txt_Data1').value;	
	var data2 = document.getElementById('txt_Data2').value;		
//	alert("novo registro");	
	window.location ='mnt1_registro.asp?from=mnt1&data1=' + data1 + '&data2=' + data2;
	//window.location ='mnt1_registro.asp';
	
}
