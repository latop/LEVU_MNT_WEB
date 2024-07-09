<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<!--#include file="includes\combobox.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>SIGLA - Detalhes da Despesa</title>
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
				border: 2px solid #000000; /* Borda preta de 2px */
			}
		</STYLE>
        <script language="javascript">
			$(document).ready(function($){
				$.mask.addPlaceholder('~',"[+-]");
				$("#datavoo").mask("99/99/9999");
				$("#tipodespesa").focus();
			});
				
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
					
				function SoNumeros(keypress, objeto){
				  campo = eval (objeto);
				  if((keypress < 43) || (keypress > 57)) {
					return false;
				  }
				}
					
				function Confirmation() {
					var answer = confirm("Corfirma a exclusão do pedido?")
					if (answer){
						window.location = "desp_excluirdespesa.asp?data1=<%=request.QueryString("data1")%>&data2=<%=request.QueryString("data2")%>&seqdespesa=<%=Request.QueryString("seqdespesa")%>";
					}
				}	
		</script>	
    </head>
    <%
		Dim Conn, Rs, RSVoo, RsUsuario
		Dim sSql, sSqlVoo, sSqlUsuario
		Dim ll_seqdespesa
		Dim ls_aeronave, dt_dtoper, ls_Voo, ls_tipodespesa, dt_datadespesa, ll_seqvoodia, ll_seqtrecho, ll_Valor, ls_NotaFiscal, ls_Motivo, ls_Situacao, ls_usuario
		
		Set Conn = CreateObject("ADODB.CONNECTION")
		Conn.Open (StringConexaoSqlServer)
		Conn.Execute "SET DATEFORMAT ymd"
		
		ll_seqdespesa = Request.QueryString("seqdespesa")

		
		sSql = "Select * From sig_liberacaodespesa Where seqdespesa = " & ll_seqdespesa 
		set Rs = Conn.Execute(sSql)
		
		ls_tipodespesa = Rs("tipodespesa")
		dt_datadespesa = Rs("dthrregistro")
		ll_seqvoodia = Rs("seqvoodia")
		ll_seqtrecho = Rs("seqtrecho")
		ll_Valor = Rs("valor")
		ls_NotaFiscal = Rs("notafiscal")
		ls_Motivo = Rs("motivo")
		ls_Situacao = Rs("situacao")
		ls_usuario = Rs("sequsuario")
		
		
		sSqlVoo =        	" SELECT sig_diariovoo.dtoper, sig_diariovoo.nrvoo, sig_diariovoo.seqvoodia, sig_diariotrecho.seqtrecho, sig_diariotrecho.prefixoaeronave "
		sSqlVoo = sSqlVoo & " FROM sig_diariovoo, sig_diariotrecho "
		sSqlVoo = sSqlVoo & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
		sSqlVoo = sSqlVoo & " AND sig_diariotrecho.flgcancelado ='N' "
		sSqlVoo = sSqlVoo & " AND sig_diariovoo.seqvoodia = '" & ll_seqvoodia & "' "
		
		set RSVoo = Conn.Execute(sSqlVoo)
		
		ls_aeronave = RSVoo("prefixoaeronave")
		dt_dtoper = RSVoo("dtoper")
		ls_Voo = RSVoo("nrvoo")

		If Not IsNull(ls_usuario) Then
			sSqlUsuario = "Select nome from sig_usuario where sequsuario = " & ls_usuario		
			Set RsUsuario = Conn.Execute(sSqlUsuario)
			ls_usuario = RsUsuario("nome")
		End If	

	%>
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
        <form action="desp_inserirdespesa.asp?data1=<%=request.querystring("data1")%>&data2=<%=request.QueryString("data2")%>" method="post" name="novadespesa" id="novadespesa" onSubmit="return VerificaCampos();" onload="reais(this,event)">
            <fieldset style="width:600px">
                <table width="72%"  border="0" cellpadding="3"  cellspacing="1">
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Tipo da Despesa:</td>
                    <td width="44%" align="left"><input type="text" name="tipodespesa" id="tipodespesa" size="30" onFocus="this.className='muda'" onBlur="this.className=''" value="<%=ls_tipodespesa%>" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %>/>
                    	<input type="hidden" name="seqdespesa" id="seqdespesa" value="<%=ll_seqdespesa%>"  />
                    </td>
                  </tr>                 
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Aeronave:</td>
                    <td width="44%" align="left"> 
                    	<select name="aeronave" id="aeronave" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> >
               		 		<% 
								call preencherComboSimples("sig_aeronave", "prefixored", "prefixored", "prefixored", ls_aeronave)
							%>
                		</select>
                	</td>
                  </tr>
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Data do Voo:</td>
                    <td width="44%" align="left"><input type="text" name="datavoo" id="datavoo" size="10" onFocus="this.className='muda'" onBlur="this.className=''" value="<%=Right("00"&Day(dt_dtoper),2) &"/"& Right("00"&Month(dt_dtoper),2) &"/"& Year(dt_dtoper)%>"  <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> /><button name="botaoCalendario2" id="botaoCalendario2" type="button" value=" "class="calendarECM2" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;"  <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> ></button></td>
                  </tr>
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Voo:</td>
                    <td width="44%" align="left"><input name="voo" type="text" id="voo" onFocus="this.className='muda'" onBlur="this.className=''" size="5" maxlength="4" value="<%=ls_Voo%>" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> onKeyPress="return SoNumeros(window.event.keyCode, this);"/></td>
                  </tr>
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Valor:</td>
                    <td width="44%" align="left"><input type="text" name="valor" id="valor" size="8" onFocus="this.className='muda'" onBlur="this.className=''" value="<%=ll_Valor%>" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> maxlength="8" onKeyPress="return SoNumeros(window.event.keyCode, this);"/></td>
                  </tr>
                  <tr>
                    <td width="36%" height="28" class="CORPO9" align="right">Nota Fiscal:</td>
                    <td width="44%" align="left"><input type="text" name="notaFiscal" id="notaFiscal" size="30" onFocus="this.className='muda'" onBlur="this.className=''" value="<%=ls_NotaFiscal%>" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> maxlength="40"/></td>
                  </tr>
                      <tr>
                        <td width="36%" height="28" class="CORPO9" align="right" valign="top">Motivo:</td>
                        <td width="44%" align="left"><textarea name="motivo" cols="50" rows="20" id="motivo" onFocus="this.className='muda'" onBlur="this.className=''" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %> ><%=ls_Motivo%></textarea></td>
                      </tr>
                </table>
          	</fieldset>
          	<br />
            
          	<% 	if ls_Situacao = "A" then %>
    		        <label class="CORPO8" style="color:#006600">
            			<b>Aprovado por: <%=ls_usuario%></b>
            		</label>
           	<% Else
					if ls_Situacao = "N" then %>
						<label class="CORPO8" style="color:#FF0000">
            				<b>Negado por: <%=ls_usuario%></b>
            			</label>
           	<%
					End IF
			   End IF	
			%>
            <br />
            <br />
		  &nbsp;&nbsp;<input name="Submit" type="submit" class="botao1"  value="Gravar" size="10" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %>  onclick='return ValidaData(getElementById("datavoo").value);'/>
          &nbsp;&nbsp;<input type="button" name="Excluir" id="Excluir" value="Excluir" size="10" class="botao1" onClick="return Confirmation()" <% if ls_Situacao = "A" Or ls_Situacao = "N" then %> disabled="disabled" <% end if %>  />
          &nbsp;&nbsp;<input type="button" name="voltar" id="voltar" value="Voltar" class="botao1" onClick="history.go(-1);"  />
        </form>   
        <div id="calendarDiv"></div> 	
		<div id="calendarDiv2"></div>    
    </body>
</html>
