<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="libgeral.asp"-->
<%
  Dim DiarioBordo, Origem, Destino
  Dim CodCargo, NomeGuerra
  Dim ll_SeqVooDia, ll_SeqTrecho, Seqmnt
  Dim strDia, strMes, strAno
  
  DiarioBordo = Request.QueryString("DiarioBordo")
  Origem = Request.querystring("Origem")
  Destino = Request.querystring("Destino") 
  NomeGuerra = Request.QueryString("NomeGuerra")
  CodCargo = Request.QueryString("CodCargo") 
  ll_SeqVooDia = Request.querystring("SeqVooDia")
  ll_SeqTrecho = Request.Querystring("SeqTrecho")
  Seqmnt = Request.QueryString("Seqmnt")
  strDia = Request.QueryString("strDia")
  strMes = Request.QueryString("strMes")
  strAno = Request.QueryString("strAno")
%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">  
   <title>SIGLA - Novo Registro</title>
   <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<script src="javascript.js"></script>
	<script src="jquery-1.1.4.js" type="text/javascript"></script>
   <style type="text/css">@import url(jquery-calendar.css);</style>
   <script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
   <script type="text/javascript">  
		$(document).ready(function(){
			$.mask.addPlaceholder('~',"[+-]");
			$("#dtacaomnt").mask("99/99/9999");
		});
	</script>
   <script language="javascript">
		function VerificaCampos() {
				if (document.Novo.Descrdiscrep.value == '...Digite a descrição aqui'){
					alert('Preencha o campo Descrição do Reporte de Discrepância, por favor!');
					document.Novo.Descrdiscrep.focus();
					return false;
				}
				if (document.Novo.Descrdiscrep.value == ''){
					alert('Preencha o campo Descrição do Reporte de Discrepância, por favor!');
					document.Novo.Descrdiscrep.focus();
					return false;
				}				
				if (document.Novo.Ata100.value == '') {
					alert('Preencha o campo Ata 100 da Ação de Manutenção, por favor!');
					document.Novo.Ata100.focus();
					return false;
				}
		}		
   </script>
</head>

<body>
<center>
	<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" ID="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center">
					<font size="4"><b>Registro de Manutenção</b></font><br /><br />
				</td>
				<td class="corpo" align="right" valign="top" width="35%">
			      <a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0"></a>
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
</center>
<form method="post" action="Mnt_Registro_Inserir.asp?strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>" name="Novo" onSubmit="VerificaCampos()">
 <table>
   <tr>
     <td width="434">
       <fieldset style="width: 98%">
         <legend style="color: #000000;"><font class="Corpo9"><b>Reporte de Discrepância</b></font></legend>
  			  <table width="424" height="94" >	
           <input type="hidden" name="SeqVooDia" value="<%=ll_SeqVooDia%>"  />
           <input type="hidden" name="SeqTrecho" value="<%=ll_SeqTrecho%>"  />
           <input type="hidden" name="Seqmnt" value="<%=Seqmnt%>"  />
           <input type="hidden" name="Gravar" value="Insert"  />
            <tr>
              <td></td>
            </tr>
            <tr align="center" > 
              <td width="197" class="CORPO8bold">Etapa:
                 <input type="text" name="Etapa" class="CORPO8" value="<%=Origem%> / <%=Destino%>" readonly="readonly"/></td>
              <td width="215" class="CORPO8bold">TLB/PG:
                 <input type="text" class="CORPO8" name="DiarioBordo" value="<%=DiarioBordo%>"  readonly="readonly"/></td>
           </tr>
           <tr>
              <td colspan="2"><hr /></td>
           </tr>   
           <tr>   
              <td class="corpo8" colspan="2"><textarea class="CORPO8" cols="75" rows="7" name="Descrdiscrep"></textarea></td>
           </tr>
           <tr>
              <td colspan="2"><hr /></td>
           </tr>   
           <tr>  
           <tr>
              <td class="corpo8Bold" colspan="2">Reportado por: <input type="text" class="CORPO8" name="Tripulante" size="50" value="<%=CodCargo%>&nbsp;<%=NomeGuerra%>" readonly="readonly"/></td>
           </table> 
       </fieldset>
     </td>
   </tr>
 </table>
 <br />
 <br />
 <table height="232">
   <tr>
     <td width="811">
       <fieldset  style="width: 98%">
         <legend style="color: #000000;"><font class="Corpo9"><b>Ação de Manutenção</b></font></legend>
  			  <table width="796" height="94" >	
               <tr>
                 <td></td>
               </tr>
               <tr align="center" > 
                 <td width="233" class="CORPO8bold">ATA 100:
                  <input type="text" name="Ata100" maxlength="20" class="CORPO8" /></td>
                 <td width="243" class="CORPO8bold">Base Station:
                  <input type="text" class="CORPO8" maxlength="20" name="BaseStation" /></td>
                 <td width="304" class="CORPO8bold">Cod. Anac:
                  <input type="text" name="CodAnac" maxlength="20" class="CORPO8" /></td>   
              </tr>
              <tr>
                 <td colspan="9"><hr /></td>
              </tr>   
              <tr>   
                 <td class="corpo8" colspan="9"><textarea class="CORPO8" cols="150" rows="7" name="Descrmnt"></textarea></td>
              </tr>
              <tr>
                 <td colspan="9"><hr /></td>
              </tr> 
           </table>
           <table border="1">
              <tr align="center">
                 <td colspan="4">&nbsp;</td>
                 <td align="right" class="CORPO8Bold" colspan="2">
                    Data:
                    <input type="text" name="dtacaomnt" id="dtacaomnt" class="CORPO8" size="10" />
                 </td>
              </tr>
              <tr align="center" class="CORPO8Bold">
                 <td align="center">PN Removido/Invertido</td>
                 <td align="center">SN Removido/Invertido</td>
                 <td align="center">Pos. Atual</td>
                 <td align="center">PN Instalado/Invertido</td>
                 <td align="center">SN Instalado/Invertido</td>
                 <td align="center">Pos. Atual</td>
              </tr>
              <tr align="center">
                 <td height="23"><input type="text" name="pnremovido" class="CORPO8" size="28" maxlength="30"/></td>
                 <td height="23"><input type="text" name="snremovido" class="CORPO8" size="28" maxlength="30"/></td>
                 <td height="23"><input type="text" name="posatualremov" class="CORPO8" size="10" maxlength="20"/></td>
                 <td height="23"><input type="text" name="pninstalado" class="CORPO8" size="28" maxlength="30"/></td>
                 <td height="23"><input type="text" name="sninstalado" class="CORPO8" size="28" maxlength="30"/></td>
                 <td height="23"><input type="text" name="posatualinst" class="CORPO8" size="10" maxlength="20"/></td>
              </tr>
           </table>
           <table border="1">   
              <tr align="center" class="CORPO8Bold">
                 <td width="67" rowspan="2" >Óleo(Lata)</td>
                 <td width="50" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E1</td>
                 <td width="50" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E2</td>
                 <td width="50" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E3</td>
                 <td width="50" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E4</td>
                 <td width="106" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;APU</td>
                 <td width="100" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HA1G</td>
                 <td width="115" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HB2B</td>
                 <td width="145" align="center">H3SY</td>
              </tr>
              <tr align="center">
                 <td height="23"><input type="text" name="E1" class="CORPO8" size="10" maxlength="20"/></td>
                 <td height="23"><input type="text" name="E2" class="CORPO8" size="10" maxlength="20"/></td>
                 <td height="23"><input type="text" name="E3" class="CORPO8" size="10" maxlength="20"/></td>
                 <td height="23"><input type="text" name="E4" class="CORPO8" size="10" maxlength="20"/></td>
                 <td height="23"><input type="text" name="APU" class="CORPO8" size="17" maxlength="20"/></td>
                 <td height="23"><input type="text" name="HA1G" class="CORPO8" size="20" maxlength="20"/></td>
                 <td height="23"><input type="text" name="HB2B" class="CORPO8" size="20" maxlength="20"/></td>
                 <td height="23"><input type="text" name="H3SY" class="CORPO8" size="0" maxlength="20"/></td>
              </tr>               
           </table>
           <br />
       </fieldset>
     </td>
   </tr>
 </table>
 <br />
 <Input type="submit" class="botao1" value="Gravar" onClick="Javascript: return VerificaCampos(); return False;" />
 <input type="button" class="botao1" value="Voltar" onClick="Javascript: history.go(-1)" />  
</form>
</body>
</html>
