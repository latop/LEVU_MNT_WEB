<!--#include file="header.asp"-->
<!--#include file="verificalogintripulante.asp"-->
<html>
<TITLE>Relatorio Diária de Tripulantes</TITLE>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<span style="font-family: arial ; sans-serif"  >
<script src="javascript.js"></script>

</head><body bgcolor="white" link="blue">

<STYLE type="text/css">
 TABLE { empty-cells: show; }

 body {	margin-left: 0px;}

 
 
</style>
<%
Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Dim RSNome
Dim sqlNome
Dim Nome
Dim intMesAtual
Dim intAnoAtual
Dim intMes
Dim intAno
Dim sSql
Dim Conn
Dim RS
Dim intSeqTripulante
Dim ls_codiataorig
Dim ls_codicaoorig
Dim ls_codiatadest
Dim ls_codicaodest
Dim intValor
Dim intTotal
Dim strNomeAeroporto, strCodAeroporto, intSeqAeroporto
Dim strSqlSelectAeroporto
Dim RSAeroporto
Dim strFlgEstado

intAnoAtual = Year(Now())
intMesAtual = Month(Now())
intMes = CInt(Request.Form ("ddl_Mes"))
intAno = CInt(Request.Form ("ddl_Ano"))

'response.write( "<BR>" & intMesAtual & "<BR>" & intMes )

intSeqTripulante = Session("member")
strFlgEstado = Request.QueryString("flgestado")

Dim intEmpresa
intEmpresa = Session("Empresa")
if ((strFlgEstado = "P") and (intEmpresa <> "1") and (intEmpresa <> "2") and (intEmpresa <> "12") and (intEmpresa <> "13") and (intEmpresa <> "10") and (intEmpresa <> "5") and (intEmpresa <> "14")) then
	Response.Redirect "Default.asp"
end if

%>
<form method= "post"  ACTION="RelatorioTripDiaria.asp?flgestado=<%=strFlgEstado%>" Name="Ordena_data" class='CORPO9'>
   <table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	   <tr>
		   <td class="corpo" align="left" valign="top" width="35%" rowspan="2">
			   <img src="imagens/logo_empresa.gif" border="0"></a>
         </td>
		   <td class="corpo" align="center" width="30%" rowspan="2">
		      <font size='4'><b>Diária de Tripulantes
<%
if strFlgEstado = "P" then
	Response.Write("[Publicado]")
else
	Response.Write("[Executado]")
end if
%>
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
   <br>
   <table width="98%" border='0' cellpadding='0' cellspacing='0' ID='Table1'>
      <tr>
         <td class='CORPO10' align='left' valign='bottom' width='100%' colspan='3'>
	         <b>Tripulante: </b><%=Session("login")%>
         </td>
      </tr>
      <tr>
         <td class='CORPO10'>
            <div>
            <label><b>Mês:&nbsp;</b></label>
<%
            Response.Write("<select class='CORPO10' name='ddl_Mes' id='ddl_Mes' tabindex='1'>")
            if intMes = 1 OR ( intMesAtual = 1 AND intMes = 0 ) then
	            Response.Write("<option value='1' selected>Janeiro</option>")
            else
	            Response.Write("<option value='1'>Janeiro</option>")
            end if
            if intMes = 2 OR ( intMesAtual = 2 AND intMes = 0 ) then
	            Response.Write("<option value='2' selected>Fevereiro</option>")
            else
	            Response.Write("<option value='2'>Fevereiro</option>")
            end if
            if intMes = 3 OR ( intMesAtual = 3 AND intMes = 0 ) then
	            Response.Write("<option value='3' selected>Março</option>")
            else
	            Response.Write("<option value='3'>Março</option>")
            end if
            if intMes = 4 OR ( intMesAtual = 4 AND intMes = 0 ) then
	            Response.Write("<option value='4' selected>Abril</option>")
            else
	            Response.Write("<option value='4'>Abril</option>")
            end if
            if intMes = 5 OR ( intMesAtual = 5 AND intMes = 0 ) then
               Response.Write("<option value='5' selected>Maio</option>")
            else
               Response.Write("<option value='5'>Maio</option>")
            end if
            if intMes = 6 OR ( intMesAtual = 6 AND intMes = 0 ) then
	            Response.Write("<option value='6' selected>Junho</option>")
            else
	            Response.Write("<option value='6'>Junho</option>")
            end if
            if intMes = 7 OR ( intMesAtual = 7 AND intMes = 0 ) then
	            Response.Write("<option value='7' selected>Julho</option>")
            else
	            Response.Write("<option value='7'>Julho</option>")
            end if
            if intMes = 8 OR ( intMesAtual = 8 AND intMes = 0 ) then
	            Response.Write("<option value='8' selected>Agosto</option>")
            else
	            Response.Write("<option value='8'>Agosto</option>")
            end if
            if intMes = 9 OR ( intMesAtual = 9 AND intMes = 0 ) then
	            Response.Write("<option value='9' selected>Setembro</option>")
            else
	            Response.Write("<option value='9'>Setembro</option>")
            end if
            if intMes = 10 OR ( intMesAtual = 10 AND intMes = 0 ) then
	            Response.Write("<option value='10' selected>Outubro</option>")
            else
	            Response.Write("<option value='10'>Outubro</option>")
            end if
            if intMes = 11 OR ( intMesAtual = 11 AND intMes = 0 ) then
	            Response.Write("<option value='11' selected>Novembro</option>")
            else
	            Response.Write("<option value='11'>Novembro</option>")
            end if
            if intMes = 12 OR ( intMesAtual = 12 AND intMes = 0 ) then
	            Response.Write("<option value='12' selected>Dezembro</option>")
            else
	            Response.Write("<option value='12'>Dezembro</option>")
            end if
            Response.Write("</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
            Response.Write("<label><b>Ano:&nbsp;</b></label>")
            Response.Write("<select class='CORPO10' name='ddl_Ano' id='ddl_Ano' tabindex='2'>")

            for intContador = 2005 To intAnoAtual + 1
               if intAno = intContador OR ( intAnoAtual = intContador AND intAno = 0 ) then
		            Response.Write("					<option value='" & intContador & "' selected>" & intContador & "</option>")
               else
		            Response.Write("					<option value='" & intContador & "'>" & intContador & "</option>")
               end if
            next
            Response.Write("             </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
%>
            <input type= "submit" value="Pesquisar" tabindex='3'>
            </div>
         </td>
      </tr>
	</table>
   </center>
</form>

<form method= "post" name = "ConsultaTripDiaria">
   <table align="center" border=1 width="100%" width="98%" cellpadding="0" cellspacing="0" ID="Table1">

      <tr bgcolor='#AAAAAA'>

         <th class="CORPO9">Data</th>
         <th class="CORPO9">Programação</th>
         <th class="CORPO9">Apresentação</th>
         <th class="CORPO9">Fim Realiz.</th>
         <th class="CORPO9">Orig.</th>
         <th class="CORPO9">Dest</th>
         <th class="CORPO9">Aeronave</th>
         <th class="CORPO9">Tipo Diária</th>
         <th class="CORPO9">Diária</th>
         <th class="CORPO9">Observação</th>
      </tr>

<%
      Dim Cor1, Cor2, Cor, intContador

      intContador = CInt(0)
      Cor1 = "#FFFFFF"
      Cor2 = "#EEEEEE"

      IF IsNull( intMes ) OR intMes = 0 OR IsNull( intAno ) OR intAno = 0 THEN
         Response.End()
      END IF

      intTotal = 0

      sSql=        " SELECT TD.dtdiaria , TD.textojornada , TD.dthrinicio , "
      sSql= sSql & " TD.dthrfim , TD.dthrinirealiz , TD.dthrfimrealiz , "
      sSql= sSql & " TD.seqaeroporig , TD.seqaeropdest , TD.aeronave , "
      sSql= sSql & " TD.tipodiaria , TD.valordiaria , TD.observacao , "
      sSql= sSql & " AO.codiata as codiataorig ,  AO.codicao as codicaoorig , "
      sSql= sSql & " AD.codiata as codiatadest ,  AD.codicao as codicaodest "
      sSql= sSql & " FROM sig_tripdiaria as TD"
      sSql= sSql & " LEFT OUTER JOIN sig_aeroporto as AO on TD.seqaeroporig = AO.seqaeroporto"
      sSql= sSql & " LEFT OUTER JOIN sig_aeroporto as AD on TD.seqaeropdest = AD.seqaeroporto "
      sSql= sSql & " WHERE year(dtdiaria) = '" & intAno & "' and month(dtdiaria) = '" & intMes & "' "
      sSql= sSql & " and TD.seqtripulante = '" & intSeqTripulante & "' "
      sSql= sSql & " and TD.flgestado = '" & strFlgEstado & "' "
      sSql= sSql & " and TD.flgdivulgado = 'S' "

'	Response.Write(sSql)
'	Response.End()

      set RS = conn.execute(sSql)

      Do While Not Rs.Eof
       	if ((intContador MOD 2) = 0) then
      			Cor = Cor1
      		else
      			Cor = Cor2
         end if

%>
         <tr bgcolor=<%=Cor%> >
            <td class="CORPO8" nowrap align="center"><center><%=Right("00" & Day(RS("dtdiaria")),2) & "/" & Right("00" & Month(RS("dtdiaria")),2) & "/" & Year(RS("dtdiaria")) %></td>
            <td class="CORPO8" nowrap align="left"><left><%=RS("textojornada")%></td>
            <td class="CORPO8" nowrap align="center"><center>
                <%If IsDate(RS("dthrinicio")) then Response.Write(FormatDateTime(RS("dthrinicio"),4)) ELSE Response.Write(":") end if%>
            </td>
            <td class="CORPO8" nowrap align="center"><center>
               <%If IsDate(RS("dthrfimrealiz")) then Response.Write(FormatDateTime(RS("dthrfimrealiz"),4)) ELSE Response.Write(":") end if%>
            </td>
            <td class="CORPO8" nowrap align="center"><center>

<%
               ls_codiataorig = RS("codiataorig")
               ls_codicaoorig = RS("codicaoorig")
               ls_codiatadest = RS("codiatadest")
               ls_codicaodest = RS("codicaodest")
               
              IF IsNull(ls_codiataorig) OR IsNull(ls_codicaoorig) THEN
                  Response.Write("-")                  
              ELSE IF ls_codiataorig > "" THEN
                       Response.Write( ls_codiataorig )
                      ELSE
                        Response.Write( ls_codicaoorig )
                   END IF
              END IF

%>
            </td>
            <td class="CORPO8" nowrap align="center"><center>
<%
               IF IsNull(ls_codiatadest) OR IsNull(ls_codicaodest) THEN
                  Response.Write("-")
               ELSE IF ls_codiatadest > "" THEN
                      Response.Write( ls_codiatadest )
                    ELSE
                      Response.Write( ls_codicaodest )
                    END IF
               END IF

               intValor = CCur(RS("Valordiaria"))
               intTotal = intTotal + intValor

%>

            </td>
            <td class="CORPO8" nowrap align="center"><center>
               <%If RS("aeronave") > "" THEN Response.Write(RS("aeronave")) ELSE Response.Write("-") %></td>
            <td class="CORPO8" nowrap align="left">
            <%If RS("tipodiaria") > "" THEN Response.Write("<left>" & RS("tipodiaria")) ELSE Response.Write("<CENTER>" & "-") %></td>
            <td class="CORPO8" nowrap align="right" ><right><%=FormatNumber(intValor)%></td>
            <td class="CORPO8" width="300" align="LEFT">
              <%If RS("observacao") > "" THEN Response.Write("<LEFT>" & RS("observacao")) ELSE Response.Write("<center>" & "-") %></td>
         </tr>

<%
         intContador = intContador + 1
         RS.MoveNext
      LOOP

%>

      <tr height=17 style='height:12.75pt' bgcolor='#AAAAAA'>
         <td height=17 colspan=7 style='height:12.75pt;mso-ignore:colspan'></td>
         <td class="CORPO9"><b>Total</b></td>
         <td class="CORPO8" align="right"><right><%=FormatNumber(intTotal)%></td>
         <td class="CORPO8">&nbsp;</td>
      </tr>
   </table>
</form>

<%
'Fechamos o sistema de conexão
Conn.Close
%>

</font>
</BODY></span>

</HTML>
