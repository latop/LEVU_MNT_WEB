<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="combinadaaeroporto_asp.asp"-->

<html>

<head>
	<title>Aeroportos</title>
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
	<script type="text/javascript" src="javascript.js"></script>
	<script type="text/javascript" src="jquery-1.1.4.js"></script>
	<script type="text/javascript" language="javascript" src="combinadaaeroporto.js"></script>
</head>

<body>
	<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" id="TableTitulo">
		<tr>
			<td class="corpo" align="left" valign="middle" width="35%">
				<img src="imagens/logo_empresa.gif" border="0" />
			</td>
			<td class="corpo" align="center">
				<% Call PreencherTitulo() %>
			</td>
			<td class="corpo" align="right" valign="bottom" width="35%">&nbsp;
				<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0" /></a>
			</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="3">
				<!--#include file="Menu.asp"-->
			</td>
		</tr>
	</table>
	<br />
	<br />
	<br />
	<table border='1' cellpadding='0' align="center" cellspacing='0'>
		<thead>
			<tr bgcolor='#AAAAAA'>
				<th class="CORPO9">&nbsp;</th>
				<th class="CORPO9" colspan="7" >Passageiros</th>
				<th class="CORPO9" colspan="2" >Bagagem</th>
				<th class="CORPO9" colspan="2" >Carga</th>
				<th class="CORPO9">&nbsp;</th>
			</tr>
			<tr bgcolor='#AAAAAA'>
				<th class='CORPO9' width='70' >Destino</th>
				<th class='CORPO9' width='70' >ADT</th>
				<th class='CORPO9' width='70' >CHD</th>
				<th class='CORPO9' width='70' >INF</th>
				<th class='CORPO9' width='70' >PAGO</th>
				<th class='CORPO9' width='70' >PAD</th>
				<th class='CORPO9' width='70' >DHC</th>
				<th class='CORPO9' width='70' >Cnx. In</th>
				<th class='CORPO9' width='70' >Livre</th>
				<th class='CORPO9' width='70' >Excesso</th>
				<th class='CORPO9' width='70' >Paga</th>
				<th class='CORPO9' width='70' >Grátis</th>
				<th class='CORPO9' width='70' >Cnx. Out</th>
			</tr>
		</thead>
		<tbody>
			<% Call PreencherTabelaEtapasCombinadas() %>
		</tbody>
	</table>

	<form action='combinadaaeroporto.asp' method='post' id='form1'>

<%
If (CombinadaSelecionada()) Then
	Call PreencherDadosCombinadaSelecionada()
%>

<!--
		<h4 align='center'>Destino: <%=strNomeAeroportoCombSel%> (<%=strCodIataCombSel%>)</h4>
-->
		<h4 align='center' style='margin:0 0 0 0;'>Embarque para <%=strNomeAeroportoCombSel%> (<%=strCodIataCombSel%>)</h4>
		<input type='hidden' name='hidSeqCombinada' id='hidSeqCombinada' value='<%=ObterValorQueryString("seqcombinada")%>' />
		<input type='hidden' id='hidFlgPorao1' name='hidFlgPorao1' value='<%=strFlgPorao1CombSel%>' />
		<input type='hidden' id='hidFlgPorao2' name='hidFlgPorao2' value='<%=strFlgPorao2CombSel%>' />
		<input type='hidden' id='hidFlgPorao3' name='hidFlgPorao3' value='<%=strFlgPorao3CombSel%>' />
		<input type='hidden' id='hidFlgPorao4' name='hidFlgPorao4' value='<%=strFlgPorao4CombSel%>' />
		<table border='0' align='center'>
			<tr>
				<td valign='top'align='center'>
					<fieldset style='width:300px;' align='center' class='corpo8'>
						<legend>Passageiros Pagos</legend>
						<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo8'>
							<tr>
								<td>
									&nbsp;
								</td>
								<td style='text-align:center;'>
									ADT
								</td>
								<td style='text-align:center;'>
									CHD
								</td>
								<td style='text-align:center;'>
									INF
								</td>
								<td style='text-align:center;'>
									Pago
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Local:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxAdtLocal' name='txtPaxAdtLocal' class='corpo8' value='<%=txtPaxAdtLocal%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='1' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxChdLocal' name='txtPaxChdLocal' class='corpo8' value='<%=txtPaxChdLocal%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='2' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxInfLocal' name='txtPaxInfLocal' class='corpo8' value='<%=txtPaxInfLocal%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='3' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxPagoLocal' name='txtPaxPagoLocal' class='corpo8' size='4' maxlength='4' value='<%=txtPaxPagoLocal%>' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='4' disabled='disabled' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Cnx. In:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxAdtCnxIn' name='txtPaxAdtCnxIn' class='corpo8' value='<%=txtPaxAdtCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='5' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxChdCnxIn' name='txtPaxChdCnxIn' class='corpo8' value='<%=txtPaxChdCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='6' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxInfCnxIn' name='txtPaxInfCnxIn' class='corpo8' value='<%=txtPaxInfCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='7' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxPagoCnxIn' name='txtPaxPagoCnxIn' class='corpo8' size='4' maxlength='4' value='<%=txtPaxPagoCnxIn%>' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='8' disabled='disabled' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Total:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxAdtTotal' name='txtPaxAdtTotal' class='corpo8' value='<%=txtPaxAdtTotal%>' size='4' maxlength='4' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='9' disabled='disabled' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxChdTotal' name='txtPaxChdTotal' class='corpo8' value='<%=txtPaxChdTotal%>' size='4' maxlength='4' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='10' disabled='disabled' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxInfTotal' name='txtPaxInfTotal' class='corpo8' value='<%=txtPaxInfTotal%>' size='4' maxlength='4' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='11' disabled='disabled' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtPaxPagoTotal' name='txtPaxPagoTotal' class='corpo8' value='<%=txtPaxPagoTotal%>' size='4' maxlength='4' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='12' disabled='disabled' />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td valign='top'align='center'>
					<fieldset style='width: 185px' align='center' class='corpo8'>
						<legend>Bagagem</legend>
						<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo8'>
							<tr>
								<td>
									&nbsp;
								</td>
								<td style='text-align:center;'>
									Livre
								</td>
								<td style='text-align:center;'>
									Excesso
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Local:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagLivreLocal' name='txtBagLivreLocal' class='corpo8' value='<%=txtBagLivreLocal%>' onchange='CalculaCampos()' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='101' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagExcessoLocal' name='txtBagExcessoLocal' class='corpo8' value='<%=txtBagExcessoLocal%>' onchange='CalculaCampos()' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='102' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Cnx. In:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagLivreCnxIn' name='txtBagLivreCnxIn' class='corpo8' value='<%=txtBagLivreCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='103' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagExcessoCnxIn' name='txtBagExcessoCnxIn' class='corpo8' value='<%=txtBagExcessoCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='104' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Total:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagLivreTotal' name='txtBagLivreTotal' class='corpo8' value='<%=txtBagLivreTotal%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='105' disabled='disabled' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtBagExcessoTotal' name='txtBagExcessoTotal' class='corpo8' value='<%=txtBagExcessoTotal%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='106' disabled='disabled' />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td valign='top'align='center'>
					<fieldset style='width: 185px' align='center' class='corpo8'>
						<legend>Carga</legend>
						<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo8'>
							<tr>
								<td>
									&nbsp;
								</td>
								<td style='text-align:center;'>
									Paga
								</td>
								<td style='text-align:center;'>
									Gratis
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Local:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaPagaLocal' name='txtCargaPagaLocal' class='corpo8' value='<%=txtCargaPagaLocal%>' onchange='CalculaCampos()' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='201' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaGratisLocal' name='txtCargaGratisLocal' class='corpo8' value='<%=txtCargaGratisLocal%>' onchange='CalculaCampos()' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='202' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Cnx. In:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaPagaCnxIn' name='txtCargaPagaCnxIn' class='corpo8' value='<%=txtCargaPagaCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='203' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaGratisCnxIn' name='txtCargaGratisCnxIn' class='corpo8' value='<%=txtCargaGratisCnxIn%>' onchange='CalculaCampos()' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='204' />
								</td>
							</tr>
							<tr>
								<td style='text-align:right;'>
									Total:
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaPagaTotal' name='txtCargaPagaTotal' class='corpo8' value='<%=txtCargaPagaTotal%>' size='4' maxlength='7' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='205' disabled='disabled' />
								</td>
								<td style='padding:0 3px 0 3px;'>
									<input type='text' id='txtCargaGratisTotal' name='txtCargaGratisTotal' class='corpo8' value='<%=txtCargaGratisTotal%>' size='4' maxlength='7' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='206' disabled='disabled' />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr> 
				<td>
					<fieldset style='width:300px;' class='corpo8'>
						<legend>Passageiros Não Pagos</legend>
						<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo8'>
							<tr>
								<td>
									PAD:
								</td>
								<td style='padding:0 20px 0 3px;'>
									<input type='text' id='txtPaxPAD' name='txtPaxPad' class='corpo8' value='<%=txtPaxPad%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='301' />
								</td>
								<td>
									DHC:
								</td>
								<td style='padding:0 0 0 3px;'>
									<input type='text' id='txtPaxDHC' name='txtPaxDHC' class='corpo8' value='<%=txtPaxDHC%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='302' />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td colspan='2'>
					<fieldset class='corpo8'>
						<legend>Passageiros Code-Shared</legend>
						<table border='0' cellpadding='0' align='center' cellspacing='0' class='corpo8'>
							<tr>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Embarcados:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPaxCS' name='txtPaxCS' class='corpo8' value='<%=txtPaxCS%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='351' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Reservados:
								</td>
								<td style='padding-left: 5px' class='corpo8'>
									<input type='text' id='txtPaxCSRes' name='txtPaxCSRes' class='corpo8' value='<%=txtPaxCSRes%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='352' />
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td colspan='3'>
<%
	If ((strFlgPorao1CombSel = "S") Or (strFlgPorao2CombSel = "S") Or (strFlgPorao3CombSel = "S") Or (strFlgPorao4CombSel = "S")) Then
%>
					<fieldset class='corpo8'>
						<legend>Porão</legend>
						<table border='0' cellpadding='0' align='left' cellspacing='0' class='corpo8'>
							<tr>
<%
		If (strFlgPorao1CombSel = "S") Then
%>
								<td style='padding-left: 40px' align='right' class='corpo8'>
									1:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao1' name='txtPorao1' class='corpo8' value='<%=txtPorao1%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='401' />
								</td>
<%
		End If
		If (strFlgPorao2CombSel = "S") Then
%>
								<td style='padding-left: 40px' align='right' class='corpo8'>
									2:
								</td>
								<td style='padding-left: 5px' class='corpo8'>
									<input type='text' id='txtPorao2' name='txtPorao2' class='corpo8' value='<%=txtPorao2%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='402' />
								</td>
<%
		End If
		If (strFlgPorao3CombSel = "S") Then
%>
								<td style='padding-left: 40px' align='right' class='corpo8'>
									3:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao3' name='txtPorao3' class='corpo8' value='<%=txtPorao3%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='403' />
								</td>
<%
		End If
		If (strFlgPorao4CombSel = "S") Then
%>
								<td style='padding-left: 40px' align='right' class='corpo8'>
									4:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao4' name='txtPorao4' class='corpo8' value='<%=txtPorao4%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='404' />
								</td>
<%
		End If
%>
							</tr>
						</table>
					</fieldset>
<%
	End If
%>
				</td>
			</tr>
			<tr>
				<td colspan='3' class='corpo7'>
					Local: Passageiros que realizaram check-in no aeroporto.<br />
					Cnx. In: Passageiros que não realizaram novo check-in no aeroporto.
				</td>
			</tr>
		</table>
		<h4 align='center' style='margin:20px 0 0 0;'>Conexão (Total embarcado para outras bases)</h4>
		<table border='0' align='center'  class='corpo8'>
			<tr>
				<td valign='top'align='center' colspan='2' class='corpo8'>
					<fieldset style='width: 100%' align='center' >
						<legend>Passageiros</legend>	
						<table border='0' cellpadding='0' align='center' cellspacing='0' id='Table1'>
							<tr>
								<td style='padding-left: 5px' nowrap width='1px' class='corpo8' align='right'>
									ADT:
								</td>
								<td style='padding-left: 4px' class='corpo8'>
									<input type='text' id='txtPaxAdtTran' name='txtPaxAdtTran' class='corpo8'  value='<%=txtPaxAdtTran%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='501' disabled='disabled' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									CHD:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPaxChdTran' name='txtPaxChdTran' class='corpo8' value='<%=txtPaxChdTran%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='502' disabled='disabled' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									INF:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPaxInfTran' name='txtPaxInfTran' class='corpo8' value='<%=txtPaxInfTran%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='503' disabled='disabled' />
								</td>
								<td style='padding-left: 5px'  width='1px' align='right' class='corpo8'>
									PAGO:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPaxEconomicaTran' name='txtPaxEconomicaTran' class='corpo8' value='<%=txtPaxEconomicaTran%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='504' disabled='disabled' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									PAD:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPaxGratisTran' name='txtPaxGratisTran' class='corpo8' value='<%=txtPaxGratisTran%>' size='4' maxlength='3' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='505' disabled='disabled' />
								</td>
							</tr>
							<tr>	
								<td colspan='2'></td>
							</tr>
						</table> 
					</fieldset>		
				</td>
			</tr>
			<tr>  
				<td>
					<fieldset style='width: 49%' align='center'>
						<legend>Bagagem</legend>	
						<table border='0' cellpadding='0' align='center' cellspacing='0' id='Table2'>
							<tr>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Livre:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtBagLivreTran' name='txtBagLivreTran' class='corpo8' value='<%=txtBagLivreTran%>' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='601' disabled='disabled' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Excesso:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtBagExcessoTran' name='txtBagExcessoTran' class='corpo8' value='<%=txtBagExcessoTran%>' size='4' maxlength='5' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='602' disabled='disabled' />
								</td>
							</tr>
							<tr>	
								<td colspan='2'></td>
							</tr>
						</table>  
					</fieldset>
				</td>
				<td>
					<fieldset style='width: 49%' align='center' >
						<legend>Carga</legend>	
						<table border='0' cellpadding='0' align='center' cellspacing='0' id='Table3'>
							<tr>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Paga:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtCargaPagaTran' name='txtCargaPagaTran' class='corpo8' value='<%=txtCargaPagaTran%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='701' disabled='disabled' />
								</td>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									Gratis:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtCargaGratisTran' name='txtCargaGratisTran' class='corpo8' value='<%=txtCargaGratisTran%>' size='4' maxlength='6' onkeypress='return SoNumeros(window.event.keyCode, this);' tabindex='702' disabled='disabled' />
								</td>
								<td colspan='2'>
								</td>
							</tr>
							<tr>
								<td colspan='2'></td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
<%
	If ((strFlgPorao1CombSel = "S") Or (strFlgPorao2CombSel = "S") Or (strFlgPorao3CombSel = "S") Or (strFlgPorao4CombSel = "S")) Then
%>
			<tr>
				<td valign='top'align='center' colspan='2' class='corpo8'>
					<fieldset style='width: 98%' align='center' >
						<legend>Porão</legend>	
						<table border='0' cellpadding='0' align='center' cellspacing='0' id='Table4'>
							<tr>
<%
		If (strFlgPorao1CombSel = "S") Then
%>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									1:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao1Tran' name='txtPorao1Tran' class='corpo8' value='<%=txtPorao1Tran%>' size='4' disabled='disabled' />
								</td>
<%
		End If
		If (strFlgPorao2CombSel = "S") Then
%>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									2:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao2Tran' name='txtPorao2Tran' class='corpo8' value='<%=txtPorao2Tran%>' size='4' disabled='disabled' />
								</td>
<%
		End If
		If (strFlgPorao3CombSel = "S") Then
%>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									3:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao3Tran' name='txtPorao3Tran' class='corpo8' value='<%=txtPorao3Tran%>' size='4' disabled='disabled' />
								</td>
<%
		End If
		If (strFlgPorao4CombSel = "S") Then
%>
								<td style='padding-left: 20px' align='right' class='corpo8'>
									4:
								</td>
								<td style='padding-left: 5px'>
									<input type='text' id='txtPorao4Tran' name='txtPorao4Tran' class='corpo8' value='<%=txtPorao4Tran%>' size='4' disabled='disabled' />
								</td>
<%
		End If
%>
							</tr>
						</table> 
					</fieldset>		
				</td>
			</tr>
<%
	End If
End If
%>
		</table>
		<table border='0' cellpadding='0' align='center' cellspacing='0'>
			<tr style='padding-top: 10px;'>
				<td align='center' width='100%'>
<%
If (CombinadaSelecionada()) Then
%>
					<input type='submit' value='Cancelar' name='btnCancelar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' id='btnCancelar' tabindex='801' />
					<input type='submit' value='Gravar' name='btnGravar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' id='btnGravar' tabindex='802' onclick='return VerificaCampos();'/>
<%
End If
%>
					<input type='submit' value='Voltar' id='btnVoltar' name='btnVoltar' class='botao1' style='WIDTH: 80px; HEIGHT: 25px' tabindex='803' />
				</td>
			</tr>
		</table>
	</form>
</body>

</html>
