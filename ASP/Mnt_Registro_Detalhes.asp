<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="libgeral.asp"-->
<%
  Dim SeqVooDia
  Dim SeqTrecho
  Dim Seqmnt
  Dim Origem
  Dim Destino
  Dim DiarioBordo
  Dim CodCargo, NomeGuerra
  Dim Rs
  Dim objConn
  Dim SelectMnt
  Dim Descrdiscrep , Descrmnt
  Dim Acaomnt, codanac, oleoe1, oleoe2, oleoe3, oleoe4, oleoapu, oleoha1g, oleohb2b, oleoh3sy, Ata100
  Dim ls_pnremovido, ls_snremovido, ls_pninstalado, ls_sninstalado, ldt_dtacaomnt, ls_posatualremov, ls_posatualinst
  Dim strDia, strMes, strAno  
  
  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"
  
  DiarioBordo = Request.QueryString("DiarioBordo")
  Origem = Request.querystring("Origem")
  Destino = Request.querystring("Destino")  
  SeqVooDia = Request.querystring("SeqVooDia")
  SeqTrecho = Request.Querystring("SeqTrecho")
  Seqmnt = Request.QueryString("Seqmnt")
  NomeGuerra = Request.QueryString("NomeGuerra")
  CodCargo = Request.QueryString("CodCargo")
  strDia = Request.QueryString("strDia")
  strMes = Request.QueryString("strMes")
  strAno = Request.QueryString("strAno")
%>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">  
<title>Detalhes Registro de Discrepância/Ação de Manutenção</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<script src="javascript.js"></script>
<script src="jquery-1.1.4.js" type="text/javascript"></script>
<script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
<style type="text/css">@import url(jquery-calendar.css);</style>
<script src="jquerycalendar.js" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function(){
	$.mask.addPlaceholder('~',"[+-]");
	$("#dtacaomnt").mask("99/99/9999");
});
		function VerificaCampos() {
				if (document.Detalhes.Descrdiscrep.value == '') {
					alert('Preencha o campo Descrição do Reporte de Discrepância, por favor!');
					document.Detalhes.Descrdiscrep.focus();
					return false;
				}
				if (document.Detalhes.Ata100.value == '') {
					alert('Preencha o campo Ata 100 da Ação de Manutenção, por favor!');
					document.Detalhes.Ata100.focus();
					return false;
				}
		}
		function Exclusao(){
		     var resposta = confirm('Confirma Exclusão do Registro ?')
			  if (resposta){
			      location.href = "Mnt_Registro_Exclusao.asp?Seqmnt=<%=Seqmnt%>&SeqVooDia=<%=SeqVooDia%>&SeqTrecho=<%=SeqTrecho%>&strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%> ";
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
				<td class="corpo" align="right" valign="top" width="35%" colspan="3">
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
<br />
<br />

<%
   
  SelectMnt =              "Select sig_diariotrechodbmnt.seqmnt, sig_diariotrechodbmnt.descrdiscrep , sig_diariotrechodbmnt.descrmnt, sig_diariotrechodbmnt.ata100, "
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.acaomnt, sig_diariotrechodbmnt.codanac, sig_diariotrechodbmnt.oleoe1, sig_diariotrechodbmnt.oleoe2,"
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.basestation, sig_diariotrechodbmnt.codanac, "
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.oleoe3, sig_diariotrechodbmnt.oleoe4, sig_diariotrechodbmnt.oleoapu, sig_diariotrechodbmnt.oleoha1g, " 
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.oleohb2b, sig_diariotrechodbmnt.oleoh3sy, " 
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.pnremovido, sig_diariotrechodbmnt.snremovido, sig_diariotrechodbmnt.pninstalado, "
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.sninstalado, sig_diariotrechodbmnt.dtacaomnt, sig_diariotrechodbmnt.posatualremov, "
  SelectMnt = SelectMnt &  "  sig_diariotrechodbmnt.posatualinst "
  SelectMnt = SelectMnt &  "From sig_diariotrechodbmnt as sig_diariotrechodbmnt, sig_diariotrechodb as sig_diariotrechodb "
  SelectMnt = SelectMnt &  "Where sig_diariotrechodbmnt.seqvoodia = '" & SeqVooDia & "' AND sig_diariotrechodbmnt.seqtrecho = '" & SeqTrecho & "' "
  SelectMnt = SelectMnt &  "  And sig_diariotrechodbmnt.seqmnt = '" & Seqmnt & "' "
  
  Set RS = Server.CreateObject("ADODB.Recordset")
  RS.Open SelectMnt, objConn
  
  Descrdiscrep = RS("descrdiscrep")			
  Descrmnt = RS("descrmnt")
  Ata100 = RS("ata100")
  Acaomnt = RS("Acaomnt")
  codanac = RS("codanac")
  oleoe1 = RS("oleoe1")
  oleoe2 = RS("oleoe2")
  oleoe3 = RS("oleoe3")
  oleoe4 = RS("oleoe4")
  oleoapu = RS("oleoapu")
  oleoha1g = RS("oleoha1g")
  oleohb2b = RS("oleohb2b")
  oleoh3sy = RS("oleoh3sy")
  ls_pnremovido = RS("pnremovido")
  ls_snremovido = RS("snremovido")
  ls_pninstalado = RS("pninstalado")
  ls_sninstalado = RS("sninstalado")
  ldt_dtacaomnt = RS("dtacaomnt")
  ls_posatualremov = RS("posatualremov")
  ls_posatualinst = RS("posatualinst")
  
  If IsDate( ldt_dtacaomnt ) Then
     ldt_dtacaomnt = Right( "00"&Day(ldt_dtacaomnt),2) & "/" & Right("00"&Month(ldt_dtacaomnt),2) & "/" & Year(ldt_dtacaomnt)
  End if
%>

<form method="post" action="Mnt_Registro_Inserir.asp?strDia=<%=strDia%>&strMes=<%=strMes%>&strAno=<%=strAno%>" name="Detalhes" onSubmit="VerificaCampos()" >
 <table>
   <tr>
     <td width="434">
       <fieldset style="width: 98%">
         <legend style="color: #000000;"><font class="Corpo9"><b>Reporte de Discrepância</b></font></legend>
  			  <table width="424" height="94" >	
           <input type="hidden" name="SeqVooDia" value='<%=SeqVooDia%>'  />
           <input type="hidden" name="SeqTrecho" value='<%=SeqTrecho%>'  />
           <input type="hidden" name="Seqmnt" value='<%=Seqmnt%>'  />
           <input type="hidden" name="Gravar" value="Update"  />
               <tr>
                 <td></td>
               </tr>
               <tr align="center" > 
                 <td width="197" class="CORPO8bold">Etapa:
                    <input type="text" name="Etapa" class="CORPO8" value="<%=Origem%> / <%=Destino%>" readonly="readonly"/></td>
                 <td width="215" class="CORPO8bold">TLB/PG:
                    <input type="text" class="CORPO8" name="DiarioBordo" value="<%=DiarioBordo%>" readonly="readonly"/></td>
               </tr>
               <tr>
                 <td colspan="2"><hr /></td>
               </tr>   
               <tr>   
                 <td class="corpo8" colspan="2"><textarea class="CORPO8" cols="75" rows="7" name="Descrdiscrep"><%=Descrdiscrep%></textarea>   </td>
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
                  <input type="text" name="Ata100" maxlength="20" class="CORPO8" value="<%=Ata100%>" /></td>
                 <td width="243" class="CORPO8bold">Base Station:
                  <input type="text" class="CORPO8" name="BaseStation" maxlength="20" value="<%=RS("basestation")%>" /></td>
                 <td width="304" class="CORPO8bold">Cod. Anac:
                  <input type="text" name="CodAnac" maxlength="20" class="CORPO8" value="<%=RS("codanac")%>" /></td>   
              </tr>
              <tr>
                 <td colspan="9"><hr /></td>
              </tr>   
              <tr>   
                 <td class="corpo8" colspan="9"><textarea class="CORPO8" cols="150" rows="7" name="Descrmnt"><%=Descrmnt%></textarea></td>
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
                   <input type="text" name="dtacaomnt" id="dtacaomnt" class="CORPO8" value="<%=ldt_dtacaomnt%>"size="10" />
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
                <td height="23"><input type="text" name="pnremovido" class="CORPO8" size="28" value="<%=ls_pnremovido%>" maxlength="30"/></td>
                <td height="23"><input type="text" name="snremovido" class="CORPO8" size="28" value="<%=ls_snremovido%>" maxlength="30"/></td>
                <td height="23"><input type="text" name="posatualremov" class="CORPO8" size="10" value="<%=ls_posatualremov%>" maxlength="20"/></td>
                <td height="23"><input type="text" name="pninstalado" class="CORPO8" size="28" value="<%=ls_pninstalado%>" maxlength="30"/></td>
                <td height="23"><input type="text" name="sninstalado" class="CORPO8" size="28" value="<%=ls_sninstalado%>" maxlength="30"/></td>
                <td height="23"><input type="text" name="posatualinst" class="CORPO8" size="10" value="<%=ls_posatualinst%>" maxlength="20"/></td>
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
                 <td height="23"><input type="text" name="E1" class="CORPO8" size="10" value="<%=oleoe1%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="E2" class="CORPO8" size="10" value="<%=oleoe2%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="E3" class="CORPO8" size="10" value="<%=oleoe3%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="E4" class="CORPO8" size="10" value="<%=oleoe4%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="APU" class="CORPO8" size="17" value="<%=oleoapu%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="HA1G" class="CORPO8" size="20" value="<%=oleoha1g%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="HB2B" class="CORPO8" size="20" value="<%=oleohb2b%>" maxlength="20" /></td>
                 <td height="23"><input type="text" name="H3SY" class="CORPO8" size="0" value="<%=oleoh3sy%>" maxlength="20" /></td>
              </tr>               
           </table>
           <br />
       </fieldset>
     </td>
   </tr>
 </table>
 <br />
 <Input type="submit" class="botao1" value="Gravar" onClick="Javascript: return VerificaCampos(); return False;" />&nbsp;
 <input type="button" class="botao1" value="Voltar" onClick="Javascript: history.go(-1)" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <input type="button" class="botao1" value="Excluir" name="excluir" onClick="Javascript: return Exclusao();" />
 
 
</form>                   
           
</body>

</html>
