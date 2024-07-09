<!--#include file="header.asp"-->
<!--#include file="verificalogintripulante.asp"-->
<html>
<head>
	<title>Programação do Tripulante</title>
	<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	<script type="text/javascript" src="javascript.js"></script>
	<style type="text/css">
		table { empty-cells: show; }
	</style>
</head>

<body bgcolor="white" link="blue">

<%
Set Conn = CreateObject("ADODB.CONNECTION")
Conn.Open (StringConexaoSqlServer)
Conn.Execute "SET DATEFORMAT ymd"

Dim sSql
Dim Conn
Dim RS
Dim intSeqTripulante
Dim ls_codiataorig
Dim ls_codicaoorig
Dim ls_codiatadest
Dim ls_codicaodest
Dim ls_codiataloc
Dim ls_codicaoloc
Dim strSqlSelectAeroporto
Dim Jornada
Dim Voo
Dim Trecho
Dim Data
Dim EdvVoo

Jornada= Request.QueryString("ll_jornada")
intSeqTripulante = Session("member")
Data= Request.QueryString("Data")
%>
   <table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	   <tr>
		   <td class="corpo" align="left" valign="top" width="35%" rowspan="2">
			   <img src="imagens/logo_empresa.gif" border="0"></a>
         </td>
		   <td class="corpo12" align="center" width="30%" rowspan="2">
			   <b>Programação de Tripulantes<br>Em <%=Data%></b></font>

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
	<label class="CORPO10" style="margin-left:15px;"><b>Tripulante: </b><%=Session("login")%></label>
<%
      sSql=        " SELECT PROG.flgtipo, PROG.funcao, PROG.dthrinicio , "
      sSql= sSql & " PROG.dthrfim , ATV.codatividade, PROG.seqjornada , "
      sSql= sSql & " PROG.dthrinicio , PROG.dthrfim , PROG.seqvoodiaesc , PROG.seqtrecho , "
      sSql= sSql & " AO.codiata as codiataorig ,  AO.codicao as codicaoorig , "
      sSql= sSql & " AD.codiata as codiatadest ,  AD.codicao as codicaodest , "
      sSql= sSql & " AL.codiata as codiataloc , AL.codicao as codicaoloc , EDV.nrvoo , EDV.seqvoodiaesc , EDV.siglaempresa, "
      sSql= sSql & " DT.prefixoaeronave, DT.partidaest "
      sSql= sSql & " FROM sig_programacao as PROG "
      sSql= sSql & " LEFT OUTER JOIN sig_escdiariovoo as EDV on PROG.seqvoodiaesc = EDV.seqvoodiaesc "
      sSql= sSql & " LEFT OUTER JOIN sig_aeroporto as AO on PROG.seqaeroporig = AO.seqaeroporto"
      sSql= sSql & " LEFT OUTER JOIN sig_aeroporto as AD on PROG.seqaeropdest = AD.seqaeroporto "
      sSql= sSql & " LEFT OUTER JOIN sig_aeroporto as AL on PROG.seqaeropatividade = AL.seqaeroporto "
      sSql= sSql & " LEFT OUTER JOIN sig_atividade as ATV on PROG.seqatividade = ATV.seqatividade "
      sSql= sSql & " LEFT OUTER JOIN sig_diariovoo as DV on EDV.nrvoo = DV.nrvoo and EDV.dtoper = DV.dtoper "
      sSql= sSql & " LEFT OUTER JOIN sig_diariotrecho as DT on DV.seqvoodia = DT.seqvoodia "
      sSql= sSql & "    and PROG.seqaeroporig = DT.seqaeroporig and PROG.seqaeropdest = DT.seqaeropdest "
      sSql= sSql & " WHERE PROG.seqjornada = '" & Jornada & "' "
      sSql= sSql & " ORDER BY PROG.seqprogramacao "

      set RS = conn.execute(sSql)

%>

<form method= "post" name = "ConsultaTripDiaria">
   <table align="center" border=1 width="98%" cellpadding="0" cellspacing="0" ID="Table1">

      <tr bgcolor='#AAAAAA'>

         <th class="CORPO9">Tipo de Programação</th>
         <th class="CORPO9">Empresa</th>
         <th class="CORPO9">Origem</th>
         <th class="CORPO9">Destino</th>
         <th class="CORPO9">Aeronave</th>
         <th class="CORPO9">Part.&nbsp;Est.</th>
         <th class="CORPO9">Função</th>
         <th class="CORPO9">atividade</th>
         <th class="CORPO9">Localidade</th>
         <th class="CORPO9">Início</th>
         <th class="CORPO9">Fim</th>
      </tr>


 <%
     Dim Cor1, Cor2, Cor, intContador

      intContador = CInt(0)
      Cor1 = "#FFFFFF"
      Cor2 = "#EEEEEE"

      Do While Not Rs.Eof
       	if ((intContador MOD 2) = 0) then
      			Cor = Cor1
      		else
      			Cor = Cor2
         end if

%>
         <tr bgcolor=<%=Cor%>>
            <td class="CORPO8" nowrap align="center"><center>
<%
	If RS("flgtipo") = "V" then
      Voo= RS("seqvoodiaesc")
		Trecho= RS("seqtrecho")
		EdvVoo= RS("nrvoo")
		Response.write("<a href='relatoriotripescala.asp?seqvoodiaesc= " & Voo & "&seqtrecho= " & Trecho & "' >"& EdvVoo)
   Else
      Response.Write("Atividade")
	End If
%>
            </td>
            <td class="CORPO8" nowrap align="center">
<%
    IF IsNULL(RS("siglaempresa")) Then
        Response.Write("-")
    Else
        Response.Write(RS("siglaempresa"))
    End If
%>
            </td>

            <td class="CORPO8" nowrap align="center"><center>

<%
               ls_codiataorig = RS("codiataorig")
               ls_codicaoorig = RS("codicaoorig")
               ls_codiatadest = RS("codiatadest")
               ls_codicaodest = RS("codicaodest")
               ls_codiataloc  = RS("codiataloc")
               ls_codicaoloc  = RS("codicaoloc")

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

               Dim intEmpresa
               intEmpresa = Session("Empresa")

               Dim ls_Aeronave
               ls_Aeronave = RS("prefixoaeronave")
               if (IsVazio(ls_Aeronave)) then
                  ls_Aeronave = "-"
               elseif (intEmpresa = 2) then
                  ls_Aeronave = "<a href=""#"" onclick=""window.open('progtripulantedetalhesaeronave.asp?prefixo=" + ls_Aeronave + "','popup','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=900,height=525');return false;"">" + ls_Aeronave + "</a>"
               end if

               Dim ldt_PartEst, ls_PartEst
               ldt_PartEst = RS("partidaest")
               If (IsVazio(ldt_PartEst)) Then
                  ls_PartEst = "-"
               Else
                  ls_PartEst = Right("00"&Day(ldt_PartEst),2) & "/" & Right("00"&Month(ldt_PartEst),2) & "/" & Year(ldt_PartEst)
                  ls_PartEst = ls_PartEst & " " & FormatDateTime( ldt_PartEst, 4 )
               End If

%>
            </td>
            <td class="CORPO8" nowrap align="center"><%=ls_Aeronave%></td>
            <td class="CORPO8" nowrap align="center"><%=ls_PartEst%></td>
            <td class="CORPO8" nowrap align="center">
<%
            If IsNull(RS("funcao")) OR RS("funcao") = " " Then
               Response.Write("-")
            Else
               Response.Write(RS("funcao"))
            end If
%>
            </td>
            <td class="CORPO8" nowrap align="center">
<%
            If IsNull(RS("codatividade")) Then
               Response.Write("-")
            Else
               Response.Write(RS("codatividade"))
            end If
%>
            </td>
            <td class="CORPO8" nowrap align="center">
<%
            IF IsNull(ls_codiataloc) OR IsNull( ls_codicaoloc) THEN
                  Response.Write("-")
            ELSE IF ls_codiataorig > "" THEN
                       Response.Write( ls_codiataloc )
                      ELSE
                        Response.Write(  ls_codicaoloc )
                   END IF
              END IF
%>

            </td>
            <td class="CORPO8" nowrap align="center">
<%
            If RS("dthrinicio")> "" Then
                Response.Write(FormatDateTime(RS("dthrinicio"),4))
            Else
                Response.Write("-")
            end If
%>            

            </td>
            <td class="CORPO8" nowrap align="center">
<%
            If RS("dthrinicio")> "" Then
                Response.Write(FormatDateTime(RS("dthrfim"),4))
            Else
                Response.Write("-")
            end If
%>
            </td>
            </tr>

<%
         RS.MoveNext
      LOOP

%>
   </table>
   <br />
   <input type="button" Value="Voltar" onClick="history.go(-1)" style="margin-left:15px;" />
</form>

<%
'Fechamos o sistema de conexão
Conn.Close
%>

</body>

</html>


<%

Function IsVazio(var)

	if (IsEmpty(var) or IsNull(var) or (Trim(var) = "")) then
		IsVazio = true
	else
		IsVazio = false
	end if

end Function

%>
