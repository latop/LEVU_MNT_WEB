// JavaScript Document

String.prototype.trim = function()
{
	return this.replace(/^\s*/, "").replace(/\s*$/, "");
}

$(document).ready(function()
{
	$("#txtPaxAdtLocal").css("text-align", "right");
	$("#txtPaxChdLocal").css("text-align", "right");
	$("#txtPaxInfLocal").css("text-align", "right");
	$("#txtPaxPagoLocal").css("text-align", "right");
	$("#txtPaxAdtCnxIn").css("text-align", "right");
	$("#txtPaxChdCnxIn").css("text-align", "right");
	$("#txtPaxInfCnxIn").css("text-align", "right");
	$("#txtPaxPagoCnxIn").css("text-align", "right");
	$("#txtPaxAdtTotal").css("text-align", "right");
	$("#txtPaxChdTotal").css("text-align", "right");
	$("#txtPaxInfTotal").css("text-align", "right");
	$("#txtPaxPagoTotal").css("text-align", "right");
	$("#txtBagLivreLocal").css("text-align", "right");
	$("#txtBagExcessoLocal").css("text-align", "right");
	$("#txtBagLivreCnxIn").css("text-align", "right");
	$("#txtBagExcessoCnxIn").css("text-align", "right");
	$("#txtBagLivreTotal").css("text-align", "right");
	$("#txtBagExcessoTotal").css("text-align", "right");
	$("#txtCargaPagaLocal").css("text-align", "right");
	$("#txtCargaGratisLocal").css("text-align", "right");
	$("#txtCargaPagaCnxIn").css("text-align", "right");
	$("#txtCargaGratisCnxIn").css("text-align", "right");
	$("#txtCargaPagaTotal").css("text-align", "right");
	$("#txtCargaGratisTotal").css("text-align", "right");
	$("#txtPaxPAD").css("text-align", "right");
	$("#txtPaxDHC").css("text-align", "right");
	$("#txtPaxCS").css("text-align", "right");
	$("#txtPaxCSRes").css("text-align", "right");
	$("#txtPorao1").css("text-align", "right");
	$("#txtPorao2").css("text-align", "right");
	$("#txtPorao3").css("text-align", "right");
	$("#txtPorao4").css("text-align", "right");
	$("#txtPaxAdtTran").css("text-align", "right");
	$("#txtPaxChdTran").css("text-align", "right");
	$("#txtPaxInfTran").css("text-align", "right");
	$("#txtPaxEconomicaTran").css("text-align", "right");
	$("#txtPaxGratisTran").css("text-align", "right");
	$("#txtBagLivreTran").css("text-align", "right");
	$("#txtBagExcessoTran").css("text-align", "right");
	$("#txtCargaPagaTran").css("text-align", "right");
	$("#txtCargaGratisTran").css("text-align", "right");
	$("#txtPorao1Tran").css("text-align", "right");
	$("#txtPorao2Tran").css("text-align", "right");
	$("#txtPorao3Tran").css("text-align", "right");
	$("#txtPorao4Tran").css("text-align", "right");
});

function CalculaCampos()
{
	// Pax ADT
	var txtPaxAdtLocal = document.getElementById('txtPaxAdtLocal').value;
	if (isNaN(txtPaxAdtLocal) || txtPaxAdtLocal.trim() == '') { txtPaxAdtLocal = 0; }
	var txtPaxAdtCnxIn = document.getElementById('txtPaxAdtCnxIn').value;
	if (isNaN(txtPaxAdtCnxIn) || txtPaxAdtCnxIn.trim() == '') { txtPaxAdtCnxIn = 0; }
	var txtPaxAdtTotal = ((parseInt(txtPaxAdtLocal)) + (parseInt(txtPaxAdtCnxIn)));

	// Pax CHD
	var txtPaxChdLocal = document.getElementById('txtPaxChdLocal').value;
	if (isNaN(txtPaxChdLocal) || txtPaxChdLocal.trim() == '') { txtPaxChdLocal = 0; }
	var txtPaxChdCnxIn = document.getElementById('txtPaxChdCnxIn').value;
	if (isNaN(txtPaxChdCnxIn) || txtPaxChdCnxIn.trim() == '') { txtPaxChdCnxIn = 0; }
	var txtPaxChdTotal = ((parseInt(txtPaxChdLocal)) + (parseInt(txtPaxChdCnxIn)));

	// Pax INF
	var txtPaxInfLocal = document.getElementById('txtPaxInfLocal').value;
	if (isNaN(txtPaxInfLocal) || txtPaxInfLocal.trim() == '') { txtPaxInfLocal = 0; }
	var txtPaxInfCnxIn = document.getElementById('txtPaxInfCnxIn').value;
	if (isNaN(txtPaxInfCnxIn) || txtPaxInfCnxIn.trim() == '') { txtPaxInfCnxIn = 0; }
	var txtPaxInfTotal = ((parseInt(txtPaxInfLocal)) + (parseInt(txtPaxInfCnxIn)));

	// Pax Pago
	var txtPaxPagoLocal = ((parseInt(txtPaxAdtLocal)) + (parseInt(txtPaxChdLocal)));
	var txtPaxPagoCnxIn = ((parseInt(txtPaxAdtCnxIn)) + (parseInt(txtPaxChdCnxIn)));
	var txtPaxPagoTotal = ((parseInt(txtPaxAdtTotal)) + (parseInt(txtPaxChdTotal)));

	// Bagagem Livre
	var txtBagLivreLocal = document.getElementById('txtBagLivreLocal').value;
	if (isNaN(txtBagLivreLocal) || txtBagLivreLocal.trim() == '') { txtBagLivreLocal = 0; }
	var txtBagLivreCnxIn = document.getElementById('txtBagLivreCnxIn').value;
	if (isNaN(txtBagLivreCnxIn) || txtBagLivreCnxIn.trim() == '') { txtBagLivreCnxIn = 0; }
	var txtBagLivreTotal = ((parseInt(txtBagLivreLocal)) + (parseInt(txtBagLivreCnxIn)));

	// Bagagem Excesso
	var txtBagExcessoLocal = document.getElementById('txtBagExcessoLocal').value;
	if (isNaN(txtBagExcessoLocal) || txtBagExcessoLocal.trim() == '') { txtBagExcessoLocal = 0; }
	var txtBagExcessoCnxIn = document.getElementById('txtBagExcessoCnxIn').value;
	if (isNaN(txtBagExcessoCnxIn) || txtBagExcessoCnxIn.trim() == '') { txtBagExcessoCnxIn = 0; }
	var txtBagExcessoTotal = ((parseInt(txtBagExcessoLocal)) + (parseInt(txtBagExcessoCnxIn)));

	// Carga Paga
	var txtCargaPagaLocal = document.getElementById('txtCargaPagaLocal').value;
	if (isNaN(txtCargaPagaLocal) || txtCargaPagaLocal.trim() == '') { txtCargaPagaLocal = 0; }
	var txtCargaPagaCnxIn = document.getElementById('txtCargaPagaCnxIn').value;
	if (isNaN(txtCargaPagaCnxIn) || txtCargaPagaCnxIn.trim() == '') { txtCargaPagaCnxIn = 0; }
	var txtCargaPagaTotal = ((parseInt(txtCargaPagaLocal)) + (parseInt(txtCargaPagaCnxIn)));

	// Carga Gratis
	var txtCargaGratisLocal = document.getElementById('txtCargaGratisLocal').value;
	if (isNaN(txtCargaGratisLocal) || txtCargaGratisLocal.trim() == '') { txtCargaGratisLocal = 0; }
	var txtCargaGratisCnxIn = document.getElementById('txtCargaGratisCnxIn').value;
	if (isNaN(txtCargaGratisCnxIn) || txtCargaGratisCnxIn.trim() == '') { txtCargaGratisCnxIn = 0; }
	var txtCargaGratisTotal = ((parseInt(txtCargaGratisLocal)) + (parseInt(txtCargaGratisCnxIn)));

	document.getElementById('txtPaxAdtTotal').value = txtPaxAdtTotal;
	document.getElementById('txtPaxChdTotal').value = txtPaxChdTotal;
	document.getElementById('txtPaxInfTotal').value = txtPaxInfTotal;
	document.getElementById('txtPaxPagoLocal').value = txtPaxPagoLocal;
	document.getElementById('txtPaxPagoCnxIn').value = txtPaxPagoCnxIn;
	document.getElementById('txtPaxPagoTotal').value = txtPaxPagoTotal;
	document.getElementById('txtBagLivreTotal').value = txtBagLivreTotal;
	document.getElementById('txtBagExcessoTotal').value = txtBagExcessoTotal;
	document.getElementById('txtCargaPagaTotal').value = txtCargaPagaTotal;
	document.getElementById('txtCargaGratisTotal').value = txtCargaGratisTotal;

}

function VerificaCampos()
{
	if (document.getElementById('txtPaxAdtLocal').value.trim() == '')
	{
		alert('Preencha o campo passageiros ADT local, por favor!');
		document.getElementById('txtPaxAdtLocal').focus();
		return false;
	}
	else if (document.getElementById('txtPaxChdLocal').value.trim() == '')
	{
		alert('Preencha o campo passageiros CHD local, por favor!');
		document.getElementById('txtPaxChdLocal').focus();
		return false;
	}
	else if (document.getElementById('txtPaxInfLocal').value.trim() == '')
	{
		alert('Preencha o campo passageiros INF local, por favor!');
		document.getElementById('txtPaxInfLocal').focus();
		return false;
	}
	else if (document.getElementById('txtPaxAdtCnxIn').value.trim() == '')
	{
		alert('Preencha o campo passageiros ADT cnx. in, por favor!');
		document.getElementById('txtPaxAdtCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtPaxChdCnxIn').value.trim() == '')
	{
		alert('Preencha o campo passageiros CHD cnx. in, por favor!');
		document.getElementById('txtPaxChdCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtPaxInfCnxIn').value.trim() == '')
	{
		alert('Preencha o campo passageiros INF cnx. in, por favor!');
		document.getElementById('txtPaxInfCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtBagLivreLocal').value.trim() == '')
	{
		alert('Preencha o campo bagagem livre local, por favor!');
		document.getElementById('txtBagLivreLocal').focus();
		return false;
	}
	else if (document.getElementById('txtBagExcessoLocal').value.trim() == '')
	{
		alert('Preencha o campo bagagem excesso local, por favor!');
		document.getElementById('txtBagExcessoLocal').focus();
		return false;
	}
	else if (document.getElementById('txtBagLivreCnxIn').value.trim() == '')
	{
		alert('Preencha o campo bagagem livre cnx. in, por favor!');
		document.getElementById('txtBagLivreCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtBagExcessoCnxIn').value.trim() == '')
	{
		alert('Preencha o campo bagagem excesso cnx. in, por favor!');
		document.getElementById('txtBagExcessoCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtCargaPagaLocal').value.trim() == '')
	{
		alert('Preencha o campo carga paga local, por favor!');
		document.getElementById('txtCargaPagaLocal').focus();
		return false;
	}
	else if (document.getElementById('txtCargaGratisLocal').value.trim() == '')
	{
		alert('Preencha o campo carga grátis local, por favor!');
		document.getElementById('txtCargaGratisLocal').focus();
		return false;
	}
	else if (document.getElementById('txtCargaPagaCnxIn').value.trim() == '')
	{
		alert('Preencha o campo carga paga cnx. in, por favor!');
		document.getElementById('txtCargaPagaCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtCargaGratisCnxIn').value.trim() == '')
	{
		alert('Preencha o campo carga grátis cnx. in, por favor!');
		document.getElementById('txtCargaGratisCnxIn').focus();
		return false;
	}
	else if (document.getElementById('txtPaxPAD').value.trim() == '')
	{
		alert('Preencha o campo passageiros PAD, por favor!');
		document.getElementById('txtPaxPAD').focus();
		return false;
	}
	else if (document.getElementById('txtPaxDHC').value.trim() == '')
	{
		alert('Preencha o campo passageiros DHC, por favor!');
		document.getElementById('txtPaxDHC').focus();
		return false;
	}
	else if (document.getElementById('txtPaxCS').value.trim() == '')
	{
		alert('Preencha o campo passageiros code-shared embarcados, por favor!');
		document.getElementById('txtPaxCS').focus();
		return false;
	}
	else if (document.getElementById('txtPaxCSRes').value.trim() == '')
	{
		alert('Preencha o campo passageiros code-shared reservados, por favor!');
		document.getElementById('txtPaxCSRes').focus();
		return false;
	}
	else if ((document.getElementById('hidFlgPorao1').value == 'S') &&
		         (document.getElementById('txtPorao1').value.trim() == ''))
	{
		alert('Preencha o campo porão 1, por favor!');
		document.getElementById('txtPorao1').focus();
		return false;
	}
	else if ((document.getElementById('hidFlgPorao2').value == 'S') &&
		         (document.getElementById('txtPorao2').value.trim() == ''))
	{
		alert('Preencha o campo porão 2, por favor!');
		document.getElementById('txtPorao2').focus();
		return false;
	}
	else if ((document.getElementById('hidFlgPorao3').value == 'S') &&
		         (document.getElementById('txtPorao3').value.trim() == ''))
	{
		alert('Preencha o campo porão 3, por favor!');
		document.getElementById('txtPorao3').focus();
		return false;
	}
	else if ((document.getElementById('hidFlgPorao4').value == 'S') &&
		         (document.getElementById('txtPorao4').value.trim() == ''))
	{
		alert('Preencha o campo porão 4, por favor!');
		document.getElementById('txtPorao4').focus();
		return false;
	}
	else
	{
		var txtPaxPagoTotal = document.getElementById('txtPaxPagoTotal').value;
		if (isNaN(txtPaxPagoTotal) || txtPaxPagoTotal.trim() == '') { txtPaxPagoTotal = 0; }

		var txtPaxCS = document.getElementById('txtPaxCS').value;
		if (isNaN(txtPaxCS) || txtPaxCS.trim() == '') { txtPaxCS = 0; }

		var txtPaxCSRes = document.getElementById('txtPaxCSRes').value;
		if (isNaN(txtPaxCSRes) || txtPaxCSRes.trim() == '') { txtPaxCSRes = 0; }

		if (parseInt(txtPaxCS) > parseInt(txtPaxCSRes))
		{
			alert('O campo passageiros code-shared embarcados não pode ser maior do que o campo passageiros code-shared reservados!');
			document.getElementById('txtPaxCS').focus();
			return false;
		}
		else if (parseInt(txtPaxCS) > parseInt(txtPaxPagoTotal))
		{
			alert('O campo passageiros code-shared embarcados não pode ser maior do que o total de passageiros pagos!');
			document.getElementById('txtPaxCS').focus();
			return false;
		}
	}
}
