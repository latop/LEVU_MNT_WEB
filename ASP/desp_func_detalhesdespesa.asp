<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="header.asp"-->
<!--#include file="verificaloginfuncionario.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SIGLA - Detalhes da Despesa</title>
</head>

<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
   <tr>
      <td class="corpo" align="left" valign="middle" width="35%" rowspan="2">
         <img src="imagens/logo_empresa.gif" border="0"></a>
      </td>
      <td class="corpo" align="center" width="30%" rowspan="2">
         <font size="4"><b>
            Consulta de Despesas
         </b></font>
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
<br />
<%
	Dim Conn
	Dim sSql, sSqlVoo, sSqlUpdate
	Dim Rs, RSVoo, RsUpdate
	Dim ll_seqdespesa
	Dim ls_tipodespesa, dt_datadespesa, ll_seqvoodia, ll_seqtrecho, ll_Valor, ls_Motivo, ls_notafiscal, ls_Situacao
	Dim ls_aeronave, dt_dtoper, ls_Voo, ls_Aeroporto, ls_atualizar
	Dim dt_Data1, dt_Data2
	
	Set Conn = CreateObject("ADODB.CONNECTION")
	Conn.Open (StringConexaoSqlServer)
	Conn.Execute "SET DATEFORMAT ymd"
	
	ll_seqdespesa = Request.QueryString("seqdespesa")
	ls_Aeroporto = Request.QueryString("Aeroporto")
	dt_Data1 = request.QueryString("data1")
	dt_Data2 = request.QueryString("data2")
	
	sSql = "Select * From sig_liberacaodespesa Where seqdespesa = " & ll_seqdespesa
	set Rs = Conn.Execute(sSql)
	
	ls_tipodespesa = Rs("tipodespesa")
	dt_datadespesa = Rs("dthrregistro")
	ll_seqvoodia = Rs("seqvoodia")
	ll_seqtrecho = Rs("seqtrecho")
	ll_Valor = Rs("valor")
	ls_Motivo = Rs("motivo")
	ls_notafiscal = Rs("notafiscal")
	ls_Situacao = Rs("situacao")
	
	
	sSqlVoo =        	" SELECT sig_diariovoo.dtoper, sig_diariovoo.nrvoo, sig_diariovoo.seqvoodia, sig_diariotrecho.seqtrecho, sig_diariotrecho.prefixoaeronave "
	sSqlVoo = sSqlVoo & " FROM sig_diariovoo, sig_diariotrecho "
	sSqlVoo = sSqlVoo & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
	sSqlVoo = sSqlVoo & " AND sig_diariovoo.seqvoodia = '" & ll_seqvoodia & "' "
	
	set RSVoo = Conn.Execute(sSqlVoo)
	
	ls_aeronave = RSVoo("prefixoaeronave")
	dt_dtoper = RSVoo("dtoper")
	ls_Voo = RSVoo("nrvoo")
	
	ls_atualizar = Request.Form("status")

	If ls_atualizar = "A" OR ls_atualizar = "N" Then
		Dim ConnUpdate
		
		Set ConnUpdate = CreateObject("ADODB.CONNECTION")
		ConnUpdate.Open (StringConexaoSqlServer)
		ConnUpdate.Execute "SET DATEFORMAT ymd"

		sSqlUpdate = "Update SIG_LIBERACAODESPESA SET situacao = '" & ls_atualizar & "', dthrliberacao = '" & Year(NOW()) & "/" & Month(Now()) & "/" & Day(Now()) & " " & Right("00" & Hour(NOW()),2) & ":" & Right("00" & Minute(NOW()),2)  & "', sequsuario=" & Session("member") & " Where seqdespesa = " & ll_seqdespesa
		
		set RsUpdate = ConnUpdate.Execute(sSqlUpdate)
		ConnUpdate.close
		
		sSql = "Select * From sig_liberacaodespesa Where seqdespesa = " & ll_seqdespesa
		set Rs = Conn.Execute(sSql)
		
		ls_tipodespesa = Rs("tipodespesa")
		dt_datadespesa = Rs("dthrregistro")
		ll_seqvoodia = Rs("seqvoodia")
		ll_seqtrecho = Rs("seqtrecho")
		ll_Valor = Rs("valor")
		ls_Motivo = Rs("motivo")
		ls_notafiscal = Rs("notafiscal")
		ls_Situacao = Rs("situacao")
		
		
		sSqlVoo =        	" SELECT sig_diariovoo.dtoper, sig_diariovoo.nrvoo, sig_diariovoo.seqvoodia, sig_diariotrecho.seqtrecho, sig_diariotrecho.prefixoaeronave "
		sSqlVoo = sSqlVoo & " FROM sig_diariovoo, sig_diariotrecho "
		sSqlVoo = sSqlVoo & " WHERE sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia "
		sSqlVoo = sSqlVoo & " AND sig_diariovoo.seqvoodia = '" & ll_seqvoodia & "' "
		
		set RSVoo = Conn.Execute(sSqlVoo)
		
		ls_aeronave = RSVoo("prefixoaeronave")
		dt_dtoper = RSVoo("dtoper")
		ls_Voo = RSVoo("nrvoo")
	

	End IF	
%>
<fieldset style="width:600px">
    <table width="94%"  border="0" cellpadding="3"  cellspacing="1">
        <tr>
			<td width="22%" height="28" class="CORPO9" align="right">Tipo da Despesa:</td>
          	<td width="24%" align="left" class="CORPO9">
				<b><%=ls_tipodespesa%></b>
           	<input type="hidden" name="seqdespesa" id="seqdespesa" value="<%=ll_seqdespesa%>"  />            </td>
          	<td width="23%" height="28" class="CORPO9" align="right">Data da Despesa:</td>
   	  <td width="31%" align="left" class="CORPO9">
				<b><%=Right("00"&Day(dt_datadespesa),2) &"/"& Right("00"&Month(dt_datadespesa),2) &"/"& Year(dt_datadespesa) & " " & Hour(dt_datadespesa) & ":" & Minute(dt_datadespesa)%></b>          </td>
      </tr>
        <tr>
            <td width="22%" height="28" class="CORPO9" align="right">Aeronave:</td>
            <td width="24%" align="left" class="CORPO9">
	            <b><%=ls_aeronave%></b>            </td>
            <td width="23%" height="28" class="CORPO9" align="right">Data do Voo:</td>
      <td width="31%" align="left" class="CORPO9">
    	        <b><%=Right("00"&Day(dt_dtoper),2) &"/"& Right("00"&Month(dt_dtoper),2) &"/"& Year(dt_dtoper) %></b>            </td>
      </tr>
        <tr>    
            <td width="22%" height="28" class="CORPO9" align="right">Voo:</td>
            <td width="24%" align="left" class="CORPO9">
	            <b><%=ls_Voo%></b>            </td>
            <td width="23%" height="28" class="CORPO9" align="right">Situação:</td>
        <td width="31%" align="left" class="CORPO9">
        <%
                If ls_Situacao = "P" Then
                    Response.Write("<b>Pendente</b>")
                Else 
                    If ls_Situacao = "A" Then
                        Response.Write("<font color='green'><b>Aprovado</b></font>")
                    else
                        Response.Write("<font color='red'><b>Negado</b></font>")
                    end If
                End If			
              %>          	</td>
      	</tr>
        <tr>
          	<td width="22%" height="28" class="CORPO9" align="right">Valor:</td>
          	<td width="24%" align="left" class="CORPO9">
            	<b><%=FormatCurrency(ll_Valor)%></b>          	</td>
                <td width="23%" height="28" class="CORPO9" align="right">Aeroporto:</td>
                <td width="31%" align="left" class="CORPO9"><b><%=ls_Aeroporto%></b>
          </td>
  		 <% If int_menu_Empresa <> 2 Then %>        
          </tr>    
                <td width="22%" height="28" class="CORPO9" align="right">Nota Fiscal:</td>
                <td width="31%" align="left" class="CORPO9"><b><%=ls_notafiscal%></b>
            </tr>
          </tr>    
                <td width="22%" height="28" class="CORPO9" align="right" valign="middle">Motivo:</td>
                <td align="left" class="CORPO9" colspan="5"><b><%=ls_Motivo%></b></td>
            </tr>
         <% end If %>
</table>
</fieldset>
<form action="desp_func_detalhesdespesa.asp?seqdespesa=<%=ll_seqdespesa%>&Aeroporto=<%=ls_Aeroporto%>&data1=<%=dt_Data1%>&data2=<%=dt_Data2%>" method="post">
    <table>
        <tr>
            <td class="CORPO9">
                Atualizar Status para:
                <select id="status" name="status" <% If ls_Situacao <> "P" Then %> disabled="disabled" <% End If %> >
                    <option selected value = -1 selected="selected">--Escolha--</option>
                    <option value ="A">Aprovado</option>
                    <option Value ="N" >Negado</option>
                </select>    
            </td>
            <td>
            	&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                <input type="submit" class="botao1" name="Atualizar" id="Atualizar" value="Atualizar" <% If ls_Situacao <> "P" Then %> disabled="disabled" <% End If %> >
            </td>
            <td>&nbsp;
            	
            </td>        
            <td>
                <input type="button" name="Voltar" class="botao1" id="Voltar" value="Voltar" onclick="location.href='desp_func_consultadespesas.asp?voltar=voltar&txt_Data1=<%=request.QueryString("data1")%>&txt_Data2=<%=request.QueryString("data2")%>'"  />
            </td>
        </tr>
    </table>        
</form>    
</body>
</html>
