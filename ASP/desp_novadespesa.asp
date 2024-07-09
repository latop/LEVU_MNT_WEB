<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<!--#include file="includes\combobox.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>SIGLA - Nova Despesa</title>
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <meta http-equiv='Page-Exit' content='blendTrans(Duration=1)'>
        <script src="jquery-1.1.4.js" type="text/javascript"></script>
		<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
        <script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
		<script src="calendar/calendarECM2.js" type="text/javascript" language="javascript"></script>
		<style type="text/css" media="screen,projection">@import url(calendar/calendar.css);</style>
        <STYLE type="text/css">
			.muda {
				background: #ffe; /* Fundo amarelo palha */
				border: 2px solid #000000; /* Borda vermelha de 2px */
			}
		</STYLE>
        <script language="javascript">
			/* Máscara da data */
			$(document).ready(function($){
				$.mask.addPlaceholder('~',"[+-]");
				$("#datavoo").mask("99/99/9999");
				$("#tipodespesa").focus();
			});
			
			/* Faz a validação dos campos verificando se os mesmos estão vazios  */
			function VerificaCampos() {
			
				if ($("#tipodespesa").val() == '' ) {
					alert("Preencha o campo tipo da despesa!");
					$("#tipodespesa").focus();
					return false;
				}
				else if ($("#aeronave").val() == '' ) {
					alert("Preencha o campo aeronave!");
					$("#aeronave").focus();
					return false;
				}
				else if ($("#datavoo").val() == '' ) {
					alert("Preencha o campo data da aeronave!");
					$("#datavoo").focus();
					return false;
				}
				else if ($("#voo").val() == '' ) {
					alert("Preencha o campo voo!");
					$("#voo").focus();
					return false;
				}
			}
			
			/* Função para digitar somente números, no caso, foi alterada para também aceitar pontos e vírgulas */
			function SoNumeros(keypress, objeto){
			
			  campo = eval (objeto);
			
			  if((keypress < 43) || (keypress > 57)) {
				return false;
			  }
			}
			
			/* Função para limitar o tamanho de algum campo */
			function LimitarTamanho(campo, qtd){
				
				if (document.getElementById(campo).value.length >= qtd) {
					alert('Limite máximo de caracteres excedido!');	
					return false;				
				}
				
			}
			
			/* Função para validar a data */
			function ValidaData(dval2) {	
				var reDate5 = /^((0[1-9]|[12]\d)\/(0[1-9]|1[0-2])|30\/(0[13-9]|1[0-2])|31\/(0[13578]|1[02]))\/\d{4}$/;

				if (reDate5.test(dval2)){
					return true;
				}else{
					alert('Digte uma data Valida!');
					$("#datavoo").focus();
					return false;
				}
			}
				
			</script>
						
    </head>
    
    <body>
        <table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
           <tr>
              <td class="corpo" align="left" valign="top" width="35%" rowspan="2">
                <img src="imagens/logo_empresa.gif" border="0"></a>
              </td>
              <td class="corpo" align="center" width="30%" rowspan="2">
                <font size="4">
                    <b>&nbsp;Nova Despesa</b>
                </font>
              </td>
              <td class="corpo" align="right" valign="top" width="35%">
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
        </table>
        <br />
        <form action="desp_inserirdespesa.asp?data1=<%=request.querystring("data1")%>&data2=<%=request.QueryString("data2")%>" method="post" name="novadespesa" id="novadespesa" onsubmit='return ValidaData(getElementById("datavoo").value);'>
        	<input type="hidden" name="tipo" id="tipo" value="insert" />
            <fieldset style="width:600px">
                <table width="98%"  border="0" cellpadding="3"  cellspacing="1">
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Tipo da Despesa:</td>
                    <td width="77%" align="left"><input type="text" name="tipodespesa" id="tipodespesa" size="30" maxlength="40" onFocus="this.className='muda'" onBlur="this.className=''" /></td>
                  </tr>
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Aeronave:</td>
<td width="77%" align="left"><select name="aeronave" id="aeronave" >
               		 		<% 
								call preencherComboSimples("sig_aeronave", "prefixored", "prefixored", "prefixored", "")
							%>
                		</select></td>
                  </tr>
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Data do Voo:</td>
                    <td width="77%" align="left"><input type="text" name="datavoo" id="datavoo" size="10" onFocus="this.className='muda'" onBlur="this.className=''" />  <button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button></td>
                  </tr>
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Voo:</td>
                    <td width="77%" align="left"><input name="voo" type="text" id="voo" onFocus="this.className='muda'" onBlur="this.className=''" size="5" maxlength="4" onKeyPress="return SoNumeros(window.event.keyCode, this);"/></td>
                  </tr>
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Valor:</td>
                    <td width="77%" align="left"><input type="text" name="valor" id="valor" size="10" maxlength="8" onFocus="this.className='muda'" onBlur="this.className=''" onKeyPress="return SoNumeros(window.event.keyCode, this);"><label class="CORPO8">&nbsp;&nbsp;Ex.:(1258,35)</label>
                    </td>
                  </tr>
                  <tr>
                    <td width="23%" height="28" class="CORPO9" align="right">Nota Fiscal:</td>
                    <td width="77%" align="left"><input type="text" name="notaFiscal" id="notaFiscal" size="30" maxlength="40" onFocus="this.className='muda'" onBlur="this.className=''">
                    </td>
                  </tr>
                  <% If int_menu_Empresa <> 2 Then %>
                      <tr>
                        <td width="23%" height="28" class="CORPO9" align="right" valign="top">Motivo:</td>
                        <td width="77%" align="left"><textarea name="motivo" cols="50" rows="20" id="motivo" onFocus="this.className='muda'" onBlur="this.className=''" onKeyPress="return LimitarTamanho('motivo', 1000);"></textarea></td>
                  </tr>
                  <% End IF %>    
                </table>
          </fieldset>
          <br />
		  &nbsp;&nbsp;<input name="Submit" type="submit" class="botao1"  value="Gravar" size="10"  onclick='return VerificaCampos();' />
          &nbsp;&nbsp;<input type="button" name="voltar" id="voltar" value="Voltar" class="botao1" onClick="history.go(-1);"  />
        </form> 
        <div id="calendarDiv"></div> 	
	<div id="calendarDiv2"></div>   
</body>
</html>
