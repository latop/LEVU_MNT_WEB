<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<title>Consulta de Tripulantes</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<script src="jquery-1.1.4.js"></script>
<script src="jquery.autocomplete.js"></script>
<script src="javascript.js"></script>
<script type="text/javascript">
	function lookup(txtNomeGuerra) {
		if(txtNomeGuerra.length == 0) {
			// Hide the suggestion box.
			$('#suggestions').hide();
		} else {
			$.post("Trip_Listagem_Dados.asp", {queryString: ""+txtNomeGuerra+""}, function(data){
				if(data.length >0) {
					$('#suggestions').show();
					$('#autoSuggestionsList').html(data);
				}
			});
		}
	} // lookup
	
	function fill(thisValue) {
		$('#txtNomeGuerra').val(thisValue);
		setTimeout("$('#suggestions').hide();", 200);
	}

</script>

	<style type="text/css">
		body {	margin-left: 0px;}

		.suggestionsBox {
			position: relative;
			left: 82px;
			margin: 10px 0px 0px 0px;
			width: 200px;
			background-color: #888888;
			-moz-border-radius: 7px;
			-webkit-border-radius: 7px;
			border: 2px solid #000;
			color: #fff;
		}

		.suggestionList {
			margin: 0px;
			padding: 0px;
		}

		.suggestionList li {
			margin: 0px 0px 3px 0px;
			padding: 3px;
			cursor: pointer;
		}

		.suggestionList li:hover {
			background-color: #659CD8;
		}
	</style>

</head>

<body>
<center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
      <tr>
	      <td class="corpo" align="left" valign="middle" width="35%">
   		   <img src="imagens/logo_empresa.gif" border="0"></a>
     		</td>
      	<td class="corpo" align="center" width="30%" rowspan="2">
      		<font size="4"><b>&nbsp;Consulta de Tripulantes</b></font>
      	</td>
      	<td class="corpo" align="right" valign="top" width="35%" colspan="3">
      		<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
      	</td>
      <tr>
         <td></td>
         <td></td>
      </tr>
      <tr>   
         <td colspan="3">
	         <!--#include file="Menu.asp"-->
         </td>
      </tr>
      <tr>
   	   <td>&nbsp;</td>
      </tr>   
	</table>
</center>
<% 
	Dim objConn
	Dim sSqlBusca
	Dim RsBusca
	
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

%>
	<table width="98%">
		<tr>
			<td>
				<form method="post" action="Trip_Listagem.asp" id="form1">
					<div>
						<div style="white-space:nowrap;">
							<label class="Corpo9">Nome de Guerra: </label>
							<input type="text" name="txtNomeGuerra" id="txtNomeGuerra" size="30" maxlength="30" class="Corpo9" Value="<%=Request.form("txtNomeGuerra")%>"  style="text-transform:uppercase;" onKeyUp="lookup(this.value);" onBlur="fill();"/>&nbsp;&nbsp;<input type="submit" name="Pesquisar"  value="Pesquisar" />
						</div>
						<div style="position:absolute;">
							<div class="suggestionsBox" id="suggestions" style="display: none;">
								<img src="imagens/upArrow.png" style="position: relative; top: -12px; left: 30px;" alt="upArrow" />
								<div class="suggestionList" id="autoSuggestionsList">
									&nbsp;
								</div>
							</div>
						</div>
					</div>
				</form>
			</td>
		</tr>
	</table>
<center>
<%
Dim RsDados
Dim RsCargo
Dim RsEquipamento
Dim RsCidade
Dim RsFuncao
Dim RsCarteira
Dim NomeGuerra
Dim sSqlDadosPessoais
Dim sSqlCargo
Dim sSqlEquipamento
Dim sSqlCidade
Dim sSqlFuncao
Dim sSqlCarteira
Dim Pesquisar
Dim ls_Nomeguerra
Dim ls_Nome
Dim ll_Matricula
Dim ll_Senioridade
Dim ll_Cpf
Dim ls_Sexo
Dim dt_DtNascimento
Dim ls_nacionalidade
Dim dt_Admissao
Dim dt_Desligamento
Dim ls_Endereco
Dim ll_Cep
Dim ls_Bairro
Dim ls_Cidade
Dim ls_Uf
Dim ls_Pais
Dim ls_Email
Dim ll_Tel01
Dim ll_Tel02
Dim ll_CodDac
Dim ll_Passaporte
Dim ls_CodPaisPass
Dim dt_Passaporte
Dim ll_Banco
Dim ll_Agencia 
Dim ll_CC 
Dim ll_Licenca
Dim ll_CodLicenca
Dim ls_Observacao
Dim ll_SeqTripulante
Dim ls_CodCargo
Dim dt_CargoDtInicio
Dim dt_CargoDtFim
Dim ls_CodFrota
Dim dt_FrotaDtInicio
Dim dt_FrotaDtFim
Dim ls_NomeCidade
Dim dt_CidadeDtInicio
Dim dt_CidadeDtFim
Dim ls_Funcao
Dim dt_FuncaoDtInicio
Dim dt_FuncaoDtFim
Dim ls_CodCarteira
Dim dt_CarteiraDtInicio
Dim dt_CarteiraDtFim

NomeGuerra = Request.Form("txtNomeGuerra")
Pesquisar = Request.Form("Pesquisar")

'Recuperando os dados do tripulante

sSqlDadosPessoais = 							 "Select * From sig_tripulante "
sSqlDadosPessoais = sSqlDadosPessoais & "LEFT OUTER JOIN sig_cidade ON sig_cidade.seqcidade = sig_tripulante.seqcidade "
sSqlDadosPessoais = sSqlDadosPessoais & "LEFT OUTER JOIN sig_pais ON sig_pais.codpais = sig_tripulante.codpais "
sSqlDadosPessoais = sSqlDadosPessoais & "Where sig_tripulante.nomeguerra = '" & UCase(NomeGuerra) & "' "
sSqlDadosPessoais = sSqlDadosPessoais & "ORDER BY nomeguerra "

Set RsDados = objConn.Execute(sSqlDadosPessoais)



If Not RsDados.EOF Then

	ll_SeqTripulante = RsDados("seqtripulante")	
	'Recuperando os cargos do tripulante	
	sSqlCargo = "Select * From sig_tripcargo where seqtripulante = " & ll_SeqTripulante & " ORDER BY dtinicio"

	'Recuperando os equipamentos do tripulante
	sSqlEquipamento = 						"Select sig_tripfrota.seqtripulante, sig_tripfrota.seqfrota, sig_tripfrota.dtinicio, sig_tripfrota.dtfim, sig_frota.codfrota " 
	sSqlEquipamento = sSqlEquipamento & "From sig_tripfrota "
	sSqlEquipamento = sSqlEquipamento & " LEFT OUTER JOIN sig_frota ON sig_frota.seqfrota = sig_tripfrota.seqfrota "
	sSqlEquipamento = sSqlEquipamento & "Where seqtripulante = " & ll_SeqTripulante & " ORDER BY dtinicio"

	sSqlCidade = 				 "SELECT sig_tripbase.seqtripulante, sig_tripbase.seqcidade, sig_tripbase.dtinicio, sig_tripbase.dtfim, sig_tripbase.flgbasetemp, sig_cidade.nomecidade "
	sSqlCidade = sSqlCidade & "FROM sig_tripbase "
	sSqlCidade = sSqlCidade & " LEFT OUTER JOIN sig_cidade ON sig_cidade.seqcidade = sig_tripbase.seqcidade "
	sSqlCidade = sSqlCidade & "WHERE sig_tripbase.seqtripulante = " & ll_SeqTripulante & " ORDER BY dtinicio"
	
	sSqlFuncao = 				 "SELECT sig_tripfuncaotrip.seqtripulante, sig_tripfuncaotrip.codfuncaotrip, sig_tripfuncaotrip.dtinicio, sig_tripfuncaotrip.dtfim , sig_funcaotrip.descrfuncaotrip "
	sSqlFuncao = sSqlFuncao & "FROM sig_tripfuncaotrip "
	sSqlFuncao = sSqlFuncao & " LEFT OUTER JOIN sig_funcaotrip ON sig_funcaotrip.codfuncaotrip = sig_tripfuncaotrip.codfuncaotrip "
	sSqlFuncao = sSqlFuncao & "WHERE sig_tripfuncaotrip.seqtripulante = " & ll_SeqTripulante & " ORDER BY dtinicio"
	
	sSqlCarteira = 					"SELECT * "
	sSqlCarteira = sSqlCarteira & "FROM sig_tripcarteira "
	sSqlCarteira = sSqlCarteira & "LEFT OUTER JOIN sig_carteira ON sig_carteira.codcarteira = sig_tripcarteira.codcarteira "
	sSqlCarteira = sSqlCarteira & "WHERE sig_tripcarteira.seqtripulante = " & ll_SeqTripulante & " ORDER BY dtinivalidade "
	
	'Response.Write(sSqlCarteira)
	'Response.End()
	
	ls_Nomeguerra = RsDados("nomeguerra")
	ls_Nome = RsDados("nome")
	ll_Matricula = RsDados("matricula")
	ll_Senioridade = RsDados("senioridade")
	ll_Cpf = RsDados("cpf")
	If RsDados("sexo") = "M" Then
		ls_Sexo = "Masculino"
	Else
		ls_Sexo = "Feminino"
	End IF
	dt_DtNascimento = RsDados("dtnascimento")
	ls_nacionalidade = RsDados("codpaistrip")
	dt_Admissao = RsDados("dtadmissao")
	dt_Desligamento = RsDados("dtdesligamento")
	ls_Endereco = RsDados("endereco")
	ll_Cep = RsDados("cep")
	ls_Bairro = RsDados("bairro")
	ls_Cidade = RsDados("nomecidade")
	ls_Uf = RsDados("coduf")
	ls_Pais = RsDados("nomepais")
	ls_Email = RsDados("email")
	ll_Tel01 = RsDados("telefone1")
	ll_Tel02 = RsDados("telefone2")
	ll_CodDac = RsDados("coddac")
	ll_Passaporte = RsDados("passaporte")
	ls_CodPaisPass = RsDados("codpaispass")
	dt_Passaporte = RsDados("dtpassaporte")
	ll_Banco = RsDados("banco")
	ll_Agencia = RsDados("agencia")
	ll_CC = RsDados("contacorrente")
	ll_Licenca =  RsDados("licenca")
	ll_CodLicenca = RsDados("codlicenca")
	ls_Observacao = RsDados("observacao")
		
%>

 		<fieldset style="width: 80%">
      	<legend class="CORPO9">Dados Pessoais</legend>
            <table border="0" width="776">
               <tr>
                  <td>&nbsp;
                     
                  </td>
               </tr>   
               <tr>
                  <td width="146" align="right" class="CORPO9">Nome Guerra:</td>
                  <td width="240"><input name="txtNomeGuerra" class="CORPO8" type="text" value="<%=ls_Nomeguerra%>" size="30" maxlength="30" readonly="true" /></td>
                  <td width="30" ></td>
                  <td align="right" class="CORPO9">Nome:</td> 
                  <td><input name="txtNome" type="text" value="<%=ls_Nome%>" class="CORPO8" size="60" maxlength="30" readonly="readonly" /></td> 
               </tr>
            </table>
            <table width="776">   
               <tr>
                  <td width="5"></td>
                  <td align="right" width="114" class="CORPO9">Matrícula:</td>
                  <td width="256"><input name="txtMatricula" type="text"  class="CORPO8" value="<%=ll_Matricula%>" size="30" maxlength="30" readonly="true" /> </td>
                  <td width="9" class="CORPO9"></td>
                  <td width="80" class="CORPO9">Senioridade:</td>
                  <td width="112"><input name="txtSenioridade" type="text"  class="CORPO8" value="<%=ll_Senioridade%>" size="20" maxlength="20" readonly="true" /> </td>
                  <td width="26" class="CORPO9">&nbsp;</td>
                  <td width="30" class="CORPO9">CPF:</td>
                  <td width="107"><input name="txtCPF" type="text"  class="CORPO8" value="<%=ll_Cpf%>" size="20" maxlength="12" readonly="true" /> </td>   
               </tr>   
            </table>
            <table width="776">
               <tr>
                  <td align="right" width="107" class="CORPO9">Sexo:</td>
                  <td width="493"><input name="txtSexo" type="text"  class="CORPO8" value="<%=ls_Sexo%>" size="20" maxlength="10" readonly="true" /></td>   
                  <td width="1">&nbsp;</td>
                  <td width="75" class="CORPO9">Nascimento:</td>
                  <td width="90"><input name="txtDtNasc" type="text" class="CORPO8" value="<%=dt_DtNascimento%>" size="15" maxlength="10" readonly="true" /></td>
               </tr>     
            </table>
            <table width="776">
               <tr>
                  <td width="113" align="right" class="CORPO9">Nacionalidade:</td>
                  <td width="90"><input name="txtNacionalidade" class="CORPO8" type="text" value="<%=ls_nacionalidade%>" size="15" maxlength="20" readonly="true" /></td>
                  <td width="12">&nbsp;&nbsp;</td>
                  <td width="134" class="CORPO9" align="right" >Admissão:</td>
                  <td width="417"><input name="dtAdmissão" class="CORPO8" type="text" value="<%=Right("00"&Day(dt_Admissao),2) & "/" & Right("00"&Month(dt_Admissao),2) & "/" & Year(dt_Admissao)%>" size="15" maxlength="10"  readonly="readonly" /></td>
                  <td class="CORPO9">Desligamento</td>
                  <% If ISDATE(dt_Desligamento) Then %>
                  	<td><input name="dtDesligamento" type="text" class="CORPO8" value="<%=Right("00"&Day(dt_Desligamento),2) & "/" & Right("00"&Month(dt_Desligamento),2) & "/" & Year(dt_Desligamento)%>" size="15" maxlength="10" readonly="true" /></td>
                  <% Else %>
                  	<td><input name="dtDesligamento" type="text" class="CORPO8" value="" size="15" maxlength="10" readonly="true" /></td>
                  <% End IF %>   
               </tr>
            </table>
            <table width="776">
               <tr>
                  <td width="116" class="CORPO9" align="right">Endereço:</td>
                  <td width="648"><input name="txtEndereco" type="text" class="CORPO8" size="108" maxlength="100" readonly="true" value="<%=ls_Endereco%>"/></td>
               </tr>
            </table>
            <table width="776">
               <tr>
                  <td width="112" class="CORPO9" align="right">CEP:</td>
                  <td width="92"><input name="nrCEP" id="nrCEP"  type="text" class="CORPO8" value="<%=ll_Cep%>" size="13" maxlength="12" readonly="readonly" /></td>
                  <td width="79" class="CORPO9" align="right">Bairro:</td>
                  <td width="150"><input name="txtBairro" type="text" class="CORPO8" size="25" maxlength="20" value="<%=ls_Bairro%>" readonly="readonly" /></td>
                  <td width="195" align="right" class="CORPO9">Cidade:</td>
                  <td width="120"><input name="txtCidade" type="text" class="CORPO8" value="<%=ls_Cidade%>" size="20" value="<%=ls_Cidade%>" maxlength="30" readonly="true" /> </td>
               </tr>
            </table>
            <table width="776">
               <tr>
                  <td width="100" align="right" class="CORPO9">UF:</td>
                  <td width="135"><input name="txtUf" type="text" class="CORPO8" value="<%=ls_Uf%>" size="15" maxlength="20" readonly="true" /></td>
                  <td width="35" align="right" class="CORPO9">País:</td>
                  <td width="486"><input name="txtPais" type="text" class="CORPO8" value="<%=ls_Pais%>" size="15" maxlength="20" readonly="true" /></td>
               </tr>
            </table>  
            <table width="776">
               <tr>
                  <td width="116" class="CORPO9" align="right">Email:</td>
                  <td width="648"><input name="txtEmail" type="text" class="CORPO8" size="108" value="<%=ls_Email%>" maxlength="100" readonly="true" /></td>
               </tr>
            </table> 
            <table width="776">
               <tr>
                  <td width="117" align="right" class="CORPO9">Telefone:</td>
                  <td width="272"><input name="txtTelefone" type="text" class="CORPO8" value="<%=ll_Tel01%>" size="45" maxlength="20" readonly="true" /></td>
                  <td width="97" align="right" class="CORPO9">Celular:</td>
                  <td width="270"><input name="txtCelular" type="text" class="CORPO8" value="<%=ll_Tel02%>" size="45" maxlength="20" readonly="true" /></td>
               </tr>
            </table>  
            <table width="776">
               <tr>
                  <td width="112" align="right" class="CORPO9">Código DAC:</td>
                  <td width="172"><input name="txtCodDAC" type="text" class="CORPO8" value="<%=ll_CodDac%>" size="25" maxlength="20" readonly="true" /></td>
                  <td width="116" align="right" class="CORPO9">Cod. Licença:</td>
                  <td width="120"><input name="txtCodLicenca" type="text" class="CORPO8" value="<%=ll_CodLicenca%>" size="20" maxlength="20" readonly="true" /></td>
                  <td width="108" align="right" class="CORPO9">Licença:</td>
                  <td width="120"><input name="txtLicenca" type="text" class="CORPO8" value="<%=ll_Licenca%>" size="20" maxlength="20" readonly="true" /></td>
               </tr>
            </table>
            <table width="776">
               <tr>
                  <td width="108" align="right" class="CORPO9">Passaporte:</td>
                  <td width="154"><input name="txtPassaporte" type="text" class="CORPO8" value="<%=ll_Passaporte%>" size="25" maxlength="20" readonly="true" /></td>
                  <td width="155" align="right" class="CORPO9">País Passaporte:</td>
                  <td width="90"><input name="txtPaisPassaporte" type="text" class="CORPO8" value="<%=ls_CodPaisPass%>" size="15" maxlength="20" readonly="true" /></td>
                  <td width="181" align="right" class="CORPO9">Validade Passaporte:</td>
                  <td width="60"><input name="txtValidadePassaporte" type="text" class="CORPO8" value="<%=dt_Passaporte%>" size="10" maxlength="20" readonly="true" /></td>
               </tr>
            </table>  
            <table width="776">
               <tr>
                  <td width="103" align="right" class="CORPO9">Banco:</td>
                  <td width="147"><input name="txtBanco" type="text" class="CORPO8" value="<%=ll_Banco%>" size="10" maxlength="20" readonly="true" /></td>
                  <td width="137" align="right" class="CORPO9">Agência:</td>
                  <td width="97"><input name="txtAgencia" type="text" class="CORPO8" value="<%=ll_Agencia%>" size="10" maxlength="20" readonly="true" /></td>
                  <td width="172" align="right" class="CORPO9">Conta Corrente:</td>
                  <td width="92"><input name="txtContaCorrente" type="text" class="CORPO8" value="<%=ll_CC%>" size="15" maxlength="20" readonly="true" /></td>
               </tr>
            </table>  
            <table width="776">
               <tr>
                  <td width="102" align="right" class="CORPO9" valign="top"><br />Observação:</td>
                  <td width="662"><textarea name="textareaObservacao" siza='100%' cols="80" class="CORPO8" rows="5"><%=ls_Observacao%></textarea></td>
               </tr>
            </table>   
     </fieldset>

     <fieldset style="width: 80%">
     		<legend class="CORPO9">Dados Técnicos</legend>		
            <table width="935"> 
               <tr> 
                  <td width="461" height="244" valign="top"> 
                  	<div align="center">
                        <table width="395" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid black;">
                           <tr bgcolor="#999999">
                              <th width="167" class="CORPO9" style="border: 1px solid black;">Cargo</th>
                              <th width="114" class="CORPO9" style="border: 1px solid black;">Início</th>
                              <th width="106" class="CORPO9" style="border: 1px solid black;">Fim</th>
                           </tr>
						<% 
							Set RsCargo = objConn.Execute(sSqlCargo)
							
							Dim Cor1, Cor2, Cor, intContador
							intContador = CInt(0)
							Cor1 = "#FFFFFF"
							Cor2 = "#EEEEEE"

						   DO WHILE NOT RsCargo.EOF 
								if ((intContador MOD 2) = 0) then
											Cor = Cor1
								else
											Cor = Cor2
								end if
								
								ls_CodCargo = RsCargo("codcargo")
								If ISDate(RsCargo("dtinicio")) Then
									dt_CargoDtInicio = Right("00"&Day(RsCargo("dtinicio")),2)& "/" & Right("00"&Month(RsCargo("dtinicio")),2)& "/" & Year(RsCargo("dtinicio"))
								Else
									dt_CargoDtInicio = "&nbsp;"
								End IF
								
								If ISDate(RsCargo("dtfim")) Then		
									dt_CargoDtFim = Right("00"&Day(RsCargo("dtfim")),2)& "/" & Right("00"&Month(RsCargo("dtfim")),2)& "/" & Year(RsCargo("dtfim"))
								Else
									dt_CargoDtFim = "&nbsp;"
								End IF	
								
							%> 
                           <tr style="border: 1px solid black;" bgcolor="<%=Cor%>">
                           	<td class="CORPO8" align="center"><%=ls_CodCargo%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_CargoDtInicio%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_CargoDtFim%>&nbsp;</td>
                           </tr>   
                  <%       
								intContador = intContador + 1
								RsCargo.MoveNext
						   Loop
						 %>          
                        </table>
                     </div>
                  </td>
                  <td width="462" height="244" valign="top" >
                     <div align="center">
                        <table width="395" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid black;">
                           <tr bgcolor="#999999">
                              <th width="167" class="CORPO9" style="border: 1px solid black;">Equipamento</th>
                              <th width="114" class="CORPO9" style="border: 1px solid black;" align="center">Início</th>
                              <th width="106" class="CORPO9" style="border: 1px solid black;" align="center">Fim</th>
                           </tr>
						<% 
							Set RsEquipamento = objConn.Execute(sSqlEquipamento)
							intContador = CInt(0)
							Cor1 = "#FFFFFF"
							Cor2 = "#EEEEEE"
							DO WHILE NOT RsEquipamento.EOF
									if ((intContador MOD 2) = 0) then
											Cor = Cor1
									else
											Cor = Cor2
									end if
														
									ls_CodFrota = RsEquipamento("codfrota")
									If ISDate(RsEquipamento("dtinicio")) Then
										dt_FrotaDtInicio = Right("00"&Day(RsEquipamento("dtinicio")),2)& "/" & Right("00"&Month(RsEquipamento("dtinicio")),2)& "/" & Year(RsEquipamento("dtinicio"))
									Else
										dt_FrotaDtInicio = "&nbsp;"
									End IF
									
									If ISDate(RsEquipamento("dtfim")) Then		
										dt_FrotaDtFim = Right("00"&Day(RsEquipamento("dtfim")),2)& "/" & Right("00"&Month(RsEquipamento("dtfim")),2)& "/" & Year(RsEquipamento("dtfim"))
									Else
										dt_FrotaDtFim = "&nbsp;"
									End IF	
	
						%>
                     
                           <tr class="CORPO8" style="border: 1px solid black;" bgcolor="<%=Cor%>">
                           	<td class="CORPO8" align="center"><%=ls_CodFrota%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_FrotaDtInicio%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_FrotaDtFim%>&nbsp;</td>
                           </tr>  
						<%       
									intContador = intContador + 1
									RsEquipamento.MoveNext
						   Loop
						 %>       
                        </table>
                     </div>
                  </td>
               </tr>
               <tr>
                  <td height="244" valign="top">
                     <div align="center">
                        <table width="395" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid black;">
                           <tr bgcolor="#999999">
                              <th width="167" class="CORPO9" style="border: 1px solid black;">Cidade</th>
                              <th width="114" class="CORPO9" style="border: 1px solid black;" align="center">Início</th>
                              <th width="106" class="CORPO9" style="border: 1px solid black;" align="center">Fim</th>
                              <th width="106" class="CORPO9" style="border: 1px solid black;" align="center">Temp</th>
                           </tr>   
						<% 
							Set RsCidade = objConn.Execute(sSqlCidade)
							intContador = CInt(0)
							Cor1 = "#FFFFFF"
							Cor2 = "#EEEEEE"
							DO WHILE NOT RsCidade.EOF
									if ((intContador MOD 2) = 0) then
											Cor = Cor1
									else
											Cor = Cor2
									end if
									ls_NomeCidade = RsCidade("nomecidade")
									If ISDate(RsCidade("dtinicio")) Then
										dt_CidadeDtInicio = Right("00"&Day(RsCidade("dtinicio")),2)& "/" & Right("00"&Month(RsCidade("dtinicio")),2)& "/" & Year(RsCidade("dtinicio"))
									Else
										dt_CidadeDtInicio = "&nbsp;"
									End IF
									
									If ISDate(RsCidade("dtfim")) Then		
										dt_CidadeDtFim = Right("00"&Day(RsCidade("dtfim")),2)& "/" & Right("00"&Month(RsCidade("dtfim")),2)& "/" & Year(RsCidade("dtfim"))
									Else
										dt_CidadeDtFim = "&nbsp;"
									End IF	
						%>		
                   			<tr class="CORPO8" style="border: 1px solid black;" bgcolor="<%=Cor%>">
                           	<td class="CORPO8" align="center"><%=ls_NomeCidade%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_CidadeDtInicio%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_CidadeDtFim%>&nbsp;</td>
                              <td class="CORPO8" align="center"><input type="checkbox" name="checkTemp" 
                 <% 			If  RsCidade("flgbasetemp") = "S" Then  %>
                             	checked="checked" 
                 <%			End IF    %> 	     
                 					disabled="disabled"/>        
                           </tr>  
						<%       
									intContador = intContador + 1
									RsCidade.MoveNext
						   Loop
						 %>       
                        </table>
                     </div>
                  </td>
                  <td height="244" valign="top">
                     <div align="center">
                        <table width="395" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid black;">
                           <tr bgcolor="#999999">
                              <th width="167" class="CORPO9" style="border: 1px solid black;">Função do Tripulante</th>
                              <th width="114" class="CORPO9" style="border: 1px solid black;" align="center">Início</th>
                              <th width="106" class="CORPO9" style="border: 1px solid black;" align="center">Fim</th>
                           </tr>   
<% 
							Set RsFuncao = objConn.Execute(sSqlFuncao)
							intContador = CInt(0)
							Cor1 = "#FFFFFF"
							Cor2 = "#EEEEEE"
							DO WHILE NOT RsFuncao.EOF
									if ((intContador MOD 2) = 0) then
											Cor = Cor1
									else
											Cor = Cor2
									end if
									ls_Funcao = RsFuncao("descrfuncaotrip")
									If ISDate(RsFuncao("dtinicio")) Then
										dt_FuncaoDtInicio = Right("00"&Day(RsFuncao("dtinicio")),2)& "/" & Right("00"&Month(RsFuncao("dtinicio")),2)& "/" & Year(RsFuncao("dtinicio"))
									Else
										dt_FuncaoDtInicio = "&nbsp;"
									End IF
									
									If ISDate(RsFuncao("dtfim")) Then		
										dt_FuncaoDtFim = Right("00"&Day(RsFuncao("dtfim")),2)& "/" & Right("00"&Month(RsFuncao("dtfim")),2)& "/" & Year(RsFuncao("dtfim"))
									Else
										dt_FuncaoDtFim = "&nbsp;"
									End IF	
						%>		
                   			<tr class="CORPO8" bgcolor="<%=Cor%>">
                           	<td class="CORPO8" align="center"><%=ls_Funcao%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_FuncaoDtInicio%>&nbsp;</td>
                              <td class="CORPO8" align="center"><%=dt_FuncaoDtFim%>&nbsp;</td>
                           </tr>  
						<%       
									intContador = intContador + 1
									RsFuncao.MoveNext
						   Loop
						 %>       
                        </table>
                     </div>
                  </td>
               </tr>
            </table>         
     </fieldset>
     <fieldset style="width: 80%">
     		<legend class="CORPO9">Carteira</legend>		
               <table width="501" cellpadding="0" cellspacing="0" border="0" style="border: 1px solid black;">
                  <tr bgcolor="#999999">
                     <th width="298" class="CORPO9" style="border: 1px solid black;">Carteira</th>
                     <th width="109" class="CORPO9" style="border: 1px solid black;">Inicio</th>
                     <th width="111" class="CORPO9" style="border: 1px solid black;">Fim</th>
                  </tr>
                  <%
								Set RsCarteira = objConn.Execute(sSqlCarteira)					
								intContador = CInt(0)
								Cor1 = "#FFFFFF"
								Cor2 = "#EEEEEE"
								DO WHILE NOT RsCarteira.EOF
										if ((intContador MOD 2) = 0) then
											Cor = Cor1
										else
											Cor = Cor2
										end if
										ls_CodCarteira = RsCarteira("codcarteira")
										If ISDate(RsCarteira("dtinivalidade")) Then
											dt_CarteiraDtInicio = Right("00"&Day(RsCarteira("dtinivalidade")),2)& "/" & Right("00"&Month(RsCarteira("dtinivalidade")),2)& "/" & Year(RsCarteira("dtinivalidade"))
										Else
											dt_CarteiraDtInicio = "&nbsp;"
										End IF
										
										If ISDate(RsCarteira("dtfimvalidade")) Then		
											dt_CarteiraDtFim = Right("00"&Day(RsCarteira("dtfimvalidade")),2)& "/" & Right("00"&Month(RsCarteira("dtfimvalidade")),2)& "/" & Year(RsCarteira("dtfimvalidade"))
										Else
											dt_CarteiraDtFim = "&nbsp;"
										End IF	
						%>		
										<tr class="CORPO8" style="border: 1px solid black;" bgcolor="<%=Cor%>">
											<td class="CORPO8" align="center"><%=ls_CodCarteira%>&nbsp;</td>
											<td class="CORPO8" align="center"><%=dt_CarteiraDtInicio%>&nbsp;</td>
											<td class="CORPO8" align="center"><%=dt_CarteiraDtFim%>&nbsp;</td>
										</tr>  
						<%       
										intContador = intContador + 1
										RsCarteira.MoveNext
								Loop		
						%>       
               </table>
               <br />      
     </fieldset>
               
<%
End IF

%>
</center>  	   
</body>
</html>
