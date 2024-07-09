<%@  language="VBScript" %>
<!--#include file="header.asp"-->
<!--#include file="grava_usuariolog.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeropfunc.asp"-->

<html>

<head>
    <title>Listagem dos Voos para Mensagens de Decolagem e Pouso</title>
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
    <script src="javascript.js"></script>
    <script src="jquery-1.1.4.js" type="text/javascript"></script>
    <script src="jquery.tablesorter.js" type="text/javascript"></script>
    <style type="text/css" media="screen,projection">
        @import url(calendar/calendar.css);
    </style>
    <script src="jquery.maskedinput-1.0.js" type="text/javascript"></script>
    <script src="calendar/calendarECM.js" type="text/javascript" language="javascript"></script>
    <script type="text/javascript">

        function VerificarCampos() {
            if (document.form1.txt_Data.value == '') {
                alert('Informe a data, por favor!');
                document.form1.txt_Data.focus();
                return false;
            }
        }

        $(document).ready(function () {
            $('table#Table3 tbody  tr').hover(function () {
                $(this).css("background-color", "#CCCC00");
            }, function () {
                $(this).css("background-color", "");
            });
            $('#Table3').tableSorter();
        });
        $(document).ready(function ($) {
            $.mask.addPlaceholder('~', "[+-]");
            $("#txt_Data").mask("99/99/9999");
        });
    </script>
    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
        }
        -->
    </style>
</head>

<body>
    <%

  Dim objConn, objRs
  Dim strQuery, strSqlSelect, strSqlFrom, strSqlWhere, strSqlOrder
  Dim strDia, strMes, strAno
  Dim strVoo
  Dim blnFazConsulta
  Dim strLocalidade
  
  blnFazConsulta = True

  strDia = Day(Request.Form ("txt_Data"))
  strMes = Month(Request.Form ("txt_Data"))
  strAno = Year(Request.Form ("txt_Data"))
  strVoo = Request.Form("txt_Voo")
  strLocalidade = UCase( Request.Form("txt_Localidade") )

  Set objConn = CreateObject("ADODB.CONNECTION")
  objConn.Open (StringConexaoSqlServer)
  objConn.Execute "SET DATEFORMAT ymd"



Public Function f_permissao2( ByVal al_sequsuario, ByVal as_codfuncao, ByVal as_StringConexaoSqlServer )
   ' Recupera a Permiss�o do Usu�rio
	Dim ConnPermissao, RSPermissao

	Set ConnPermissao = CreateObject("ADODB.CONNECTION")
	ConnPermissao.Open (as_StringConexaoSqlServer)

	If CInt( al_sequsuario ) = 1 Then
		f_permissao2 = True
	Else

        'Response.Write("SELECT * FROM sig_usuariofuncao WHERE sequsuario = " & al_sequsuario & " AND codfuncao = '" & as_codfuncao & "'")

		Set RSPermissao = ConnPermissao.Execute( "SELECT * FROM sig_usuariofuncao WHERE sequsuario = " & al_sequsuario & " AND codfuncao = '" & as_codfuncao & "'" )
		
		If NOT RSPermissao.EOF Then
			f_permissao2 = true
		Else
   		f_permissao2 = False
		End if
	End if
	
	ConnPermissao.Close
End Function



  ' ********************
  ' *** FUSO BSB-GMT ***
  ' ********************
  Dim objRsFuso, strQueryFuso
  Dim intFusoGMT
  strQueryFuso =                "SELECT sig_fusovalor.fuso "
  strQueryFuso = strQueryFuso & "  FROM sig_fusovalor, "
  strQueryFuso = strQueryFuso & "       sig_parametros "
  strQueryFuso = strQueryFuso & " WHERE sig_fusovalor.codfuso = sig_parametros.codfusoref "
  if strDia <> "" and strMes <> "" and strAno <> "" then
    strQueryFuso = strQueryFuso & " AND ( sig_fusovalor.dtinicio <= '" & strAno & "-" & strMes & "-" & strDia & "' ) "
    strQueryFuso = strQueryFuso & " AND (sig_fusovalor.dtfim >= '" & strAno & "-" & strMes & "-" & strDia & "' OR sig_fusovalor.dtfim IS NULL) "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if
  If blnFazConsulta Then
    Set objRsFuso = Server.CreateObject("ADODB.Recordset")
    objRsFuso.Open strQueryFuso, objConn
    if (Not objRsFuso.EOF) then
      intFusoGMT = CInt(objRsFuso("fuso"))
    else
      intFusoGMT = CInt(0)
    end if
    objRsFuso.Close()
    Set objRsFuso = Nothing
  end if

  strSqlSelect = " SELECT "
  strSqlSelect = strSqlSelect & " DV.seqvoodia SeqVooDia, "
  strSqlSelect = strSqlSelect & " DT.seqtrecho SeqTrecho, "
  strSqlSelect = strSqlSelect & " DT.seqaeroporig SeqAeroporig, "
  strSqlSelect = strSqlSelect & " DV.nrvoo Numero_Voo, "
  strSqlSelect = strSqlSelect & " Fr.codfrota Codigo_Frota, "
  strSqlSelect = strSqlSelect & " DT.prefixoaeronave PrefixoAeronave, "
  strSqlSelect = strSqlSelect & " ApOrig.codiata Codigo_IATA_Origem, "
  strSqlSelect = strSqlSelect & " ApDest.codiata Codigo_IATA_Destino, "
  strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidaprev) partidaprev, "
  strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.chegadaprev) chegadaprev, "
  strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.partidamotor) partidamotor, "
  strSqlSelect = strSqlSelect & " DATEADD(hh, " & -intFusoGMT & ", DT.cortemotor) cortemotor "

  strSqlFrom = " FROM "
  strSqlFrom = strSqlFrom & " sig_diariotrecho DT, "
  strSqlFrom = strSqlFrom & " sig_diariovoo DV, "
  strSqlFrom = strSqlFrom & " sig_frota Fr, "
  strSqlFrom = strSqlFrom & " sig_aeroporto ApOrig, "
  strSqlFrom = strSqlFrom & " sig_aeroporto ApDest "

  strSqlWhere = " WHERE "
  strSqlWhere = strSqlWhere & "       ( DV.seqvoodia = DT.seqvoodia ) "
  strSqlWhere = strSqlWhere & " AND   ( ApOrig.seqaeroporto = DT.seqaeroporig ) "
  strSqlWhere = strSqlWhere & " AND   ( ApDest.seqaeroporto = DT.seqaeropdest ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.seqfrota = Fr.seqfrota ) "
  strSqlWhere = strSqlWhere & " AND   ( DV.statusvoo = 'N' ) "
  strSqlWhere = strSqlWhere & " AND   ( DT.flgcancelado = 'N' ) "
  if strDia <> "" and strMes <> "" and strAno <> "" then
    strSqlWhere = strSqlWhere & " AND   ( DV.dtoper = '" & strAno & "-" & strMes & "-" & strDia & "' ) "
    blnFazConsulta = True
  else
    blnFazConsulta = False
  end if
  if strVoo <> "" Then
    strSqlWhere = strSqlWhere & " AND   ( DV.nrvoo = '" & strVoo & "' ) "
  	 blnFazConsulta = True
  end if	 
  if strLocalidade <> "" Then
    strSqlWhere = strSqlWhere & " AND   ( ApOrig.codiata = '" & UCase( strLocalidade ) & "' OR ApDest.codiata = '" & UCase( strLocalidade ) & "' ) "
  	 blnFazConsulta = True
  end if	 

  strSqlOrder = " ORDER BY "
  strSqlOrder = strSqlOrder & " DT.partidaprev "

  strQuery = strSqlSelect & strSqlFrom & strSqlWhere & strSqlOrder

  If blnFazConsulta Then
    Set ObjRs = Server.CreateObject("ADODB.Recordset")
    objRs.Open strQuery, objConn
  End If

    %>
    <center>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
     <tr>
         <td class="corpo" align="left" valign="middle" width="35%">
            <img src="imagens/logo_empresa.gif" border="0"></a>
         </td>
         <td class="corpo" align="center" width="30%" rowspan="2">
            <font size="4"><b>&nbsp;Mensagens de Decolagem e Pouso [Hor�rio UTC]</b></font>
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
</center>
    <br>
    <center>
	<table width="98%" ID="Table2">
	<tr>
		<td>
			<form method="post" action="listagemmvt.asp" name="form1" id="form1" onSubmit="Javascript: return VerificarCampos();">
<%

    If f_permissao2( ll_menu_sequsuario, "I06", StringConexaoSqlServer ) = "" Then
    Response.Write("<h1>Acesso negado.</h1>")
    Response.End()
End IF
           ' Executa fun��o para gravar na sig_usuariolog
           If f_grava_usuariolog( "I06", objConn ) <> "" Then
              Response.End()
           End if
%>        
			<div id="default" class="tab_group1 container">
			      <label class="Corpo9">Data:</label>
               <input type="text" name="txt_Data" id="txt_Data" size="11" maxlength="10" class="Corpo9" Value="<%=Request.form("txt_Data")%>" />&nbsp;&nbsp;
               <button name="botaoCalendario" id="botaoCalendario" type="button" value=" " class="calendarECM" style="background:url(imagens/calendario.gif) ; width:24px; height:23px;" ></button>              
               <label class="Corpo9">Voo:</label>
               <input type="text" name="txt_Voo" id="txt_Voo" size="5" maxlength="4" class="Corpo9" onKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" Value="<%=Request.form("txt_Voo")%>" />&nbsp;&nbsp;
               <label class="Corpo9">Base:</label>
               <input type="text" name="txt_Localidade" id="txt_Localidade" size="5" maxlength="4" class="Corpo9" nKeyPress="ChecarTAB();" onKeyUp="SimulaTab(this);" onFocus="PararTAB(this);" style="text-transform:uppercase;" Value="<%=Request.form("txt_Localidade")%>" />&nbsp;
               <input type="submit" name="submit" value="Pesquisar" tabindex="10" />
          </div>  
			</form>
		</td>
	</tr>
	</table>
</center>
    <center>
  <table width="98%" border="1" cellpadding="0" cellspacing="0" class="tablesorter" ID="Table3">
   <thead> 
    <tr bgcolor="#AAAAAA" style='cursor:pointer;cursor:hand' class="Corpo8Bold">
      <th>Voo</th>
      <th>Frota</th>
      <th>Aeronave</th>
      <th>Origem</th>
      <th>Destino</th>
      <th>Part. Prev.</th>
      <th>Cheg. Prev.</th>
      <th>Partida Motor</th>
      <th>Corte Motor</th>
    </tr>
   </thead>
   <tbody> 
	
<%
  Dim intSeqVooDia, intSeqTrecho
  Dim ldt_partidamotor, ldt_cortemotor, ldt_partidaprev, ldt_chegadaprev
  Dim ls_partidaprev, ls_chegadaprev, ls_partidamotor, ls_cortemotor 
  Dim ldt_Numero_Voo, ls_Numero_Voo
  Dim ldt_Codigo_Frota, ls_Codigo_Frota
  Dim ldt_PrefixoAeronave, ls_PrefixoAeronave
  Dim ldt_Codigo_IATA_Origem, ls_Codigo_IATA_Origem
  Dim ldt_Codigo_IATA_Destino, ls_Codigo_IATA_Destino


  If blnFazConsulta Then
  	If (Not ObjRs.Eof) Then
		Do While Not ObjRs.Eof
			intSeqVooDia = objRs("SeqVooDia")
			intSeqTrecho = objRs("SeqTrecho")
			
			ldt_partidamotor = ObjRs("PartidaMotor")
			if Not IsNull(ldt_partidamotor) Then
				ls_partidamotor = Right("00"&Day(ldt_partidamotor),2) & "/" & Right("00"&Month(ldt_partidamotor),2) & "/" & Year(ldt_partidamotor)
				ls_partidamotor = ls_partidamotor & " " & FormatDateTime( ldt_partidamotor, 4 )
			Else
				ls_partidamotor = "&nbsp;"
			End If
			
			ldt_cortemotor = ObjRs("Cortemotor")
			if Not IsNull(ldt_cortemotor) Then
				ls_cortemotor = Right("00"&Day(ldt_cortemotor),2) & "/" & Right("00"&Month(ldt_cortemotor),2) & "/" & Year(ldt_cortemotor)
				ls_cortemotor = ls_cortemotor & " " & FormatDateTime( ldt_cortemotor, 4 )
			Else
				ls_cortemotor = "&nbsp;"
			End If
			
			ldt_partidaprev = ObjRs("PartidaPrev")
			if Not IsNull(ldt_partidaprev) Then
				ls_partidaprev = Right("00"&Day(ldt_partidaprev),2) & "/" & Right("00"&Month(ldt_partidaprev),2) & "/" & Year(ldt_partidaprev)
				ls_partidaprev = ls_partidaprev & " " & FormatDateTime( ldt_partidaprev, 4 )
			Else
				ls_partidaprev = "&nbsp;"
			End If
			
			ldt_chegadaprev = ObjRs("ChegadaPrev")
			if Not IsNull(ldt_chegadaprev) Then
				ls_chegadaprev = Right("00"&Day(ldt_chegadaprev),2) & "/" & Right("00"&Month(ldt_chegadaprev),2) & "/" & Year(ldt_chegadaprev)
				ls_chegadaprev = ls_chegadaprev & " " & FormatDateTime( ldt_chegadaprev, 4 )
			Else
				ls_chegadaprev = "&nbsp;"
			End If
			ldt_Numero_Voo = ObjRs("Numero_Voo")
			If Not IsNull(ldt_Numero_Voo) Then
			  ls_Numero_Voo = ldt_Numero_Voo
			Else
			  ls_Numero_Voo = "&nbsp;"
			End If
			ldt_Codigo_Frota = ObjRs("Codigo_Frota")    
			If Not IsNull(ldt_Codigo_Frota) Then
			  ls_Codigo_Frota = ldt_Codigo_Frota
			Else 
			  ls_Codigo_Frota = "&nbsp;"
			End If
			ldt_PrefixoAeronave = ObjRs("PrefixoAeronave")    
			If Not IsNull(ldt_PrefixoAeronave) Then
			  ls_PrefixoAeronave = ldt_PrefixoAeronave
			Else
			  ls_PrefixoAeronave = "&nbsp;"
			End IF
			ldt_Codigo_IATA_Origem = ObjRs("Codigo_IATA_Origem")    
			If Not IsNull(ldt_Codigo_IATA_Origem) Then
			   ls_Codigo_IATA_Origem = ldt_Codigo_IATA_Origem
			Else
			   ls_Codigo_IATA_Origem = "&nbsp;"
			End If
			ldt_Codigo_IATA_Destino = ObjRs("Codigo_IATA_Destino")	
			If Not IsNull(ldt_Codigo_IATA_Destino) Then
			   ls_Codigo_IATA_Destino = ldt_Codigo_IATA_Destino
			Else
			   ls_Codigo_IATA_Destino = "&nbsp;"
			End If	
%>
            <tr onClick="location.href ='relatoriomvt.asp?seqvoodia=<%=objRs("SeqVooDia")%>&seqtrecho=<%=objRs("SeqTrecho")%>&dataPrevista=<%=day(ls_partidaprev)%>-<%=month(ls_partidaprev)%>-<%=year(ls_partidaprev)%>&voo=<%=ls_Numero_Voo%>' " style='cursor:pointer;cursor:hand' >
            <a href='relatoriomvt.asp?seqvoodia=<%=objRs("SeqVooDia")%>&seqtrecho=<%=objRs("SeqTrecho")%>&dataPrevista=<%=day(ls_partidaprev)%>-<%=month(ls_partidaprev)%>-<%=year(ls_partidaprev)%>&voo=<%=ls_Numero_Voo%>'>
               <td class="corpo" align="center"> <%=ls_Numero_Voo%></td>
               <td class="corpo" align="center"><%=ls_Codigo_Frota%></td>
               <td class="corpo" align="center"><%=ls_PrefixoAeronave%></td>
               <td class="corpo" align="center"><%=ls_Codigo_IATA_Origem%></td>
               <td class="corpo" align="center"><%=ls_Codigo_IATA_Destino%></td>
               <td class="corpo" align="center"><%=ls_partidaprev%></td>
					<td class="corpo" align="center"><%=ls_chegadaprev%></td>
               <td class="corpo" align="center"><%=ls_partidamotor%></td>
               <td class="corpo" align="center"><%=ls_cortemotor%></td>
            </a>   
            </tr>
<%
			ObjRs.movenext
		loop
  	End If	
  	objRs.Close
  End If
%>
   </tbody> 

  </table>
</center>

    <%
  objConn.close
  Set objRs = Nothing
  Set objConn = Nothing
    %>


    <div id="calendarDiv"></div>
</body>

</html>
