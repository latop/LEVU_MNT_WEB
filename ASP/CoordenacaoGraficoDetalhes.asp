<!--#include file="header.asp"-->
<!--#include file="verify_login.asp"-->

<html><head>
<TITLE>Sigla - Coordanação de Voo - Detalhes do Voo</TITLE>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<span style="font-family: arial ; sans-serif"  >
<script src="javascript.js"></script>

</head><body bgcolor="white" link="blue">

<STYLE type="text/css">
 TABLE { empty-cells: show; }
</style>

<%
    Dim VooDia
    Dim Trecho
    Dim RS
    Dim sSql
    Dim Conn
    Dim origem_vet
    Dim destino_vet
    Dim partidaprev_vet
    Dim chegadaprev_vet
	 Dim partidaplanej_vet
    Dim chegadaplanej_vet	 
    Dim Cont 
    Dim Atividade
	 Dim SeqAtividade


    Set Conn = CreateObject("ADODB.CONNECTION")
    Conn.Open (StringConexaoSqlServer)
    Conn.Execute "SET DATEFORMAT ymd"


    VooDia = Request.QueryString("VooDia")
    Trecho = Request.QueryString("Trecho")
    SeqAtividade = Request.QueryString("SeqAtividade")

    If SeqAtividade = "0" Then
        origem_vet = ""
        destino_vet = ""
        partidaprev_vet = ""
        chegadaprev_vet = ""
    
        sSql =        " SELECT sig_diariovoo.seqvoodia, "
        sSql = sSql & "        sig_diariovoo.nrvoo,"
        sSql = sSql & "        sig_diariovoo.tipovoo,"
        sSql = sSql & "        sig_diariovoo.dtoper,"
        sSql = sSql & "        sig_diariovoo.codhotran,"
        sSql = sSql & "        sig_diariotrecho.seqtrecho,"
        sSql = sSql & "        sig_frota.codfrota,"
        sSql = sSql & "        sig_diariotrecho.prefixoaeronave,"
        sSql = sSql & "        aeroporig.codiata origem,"
        sSql = sSql & "        aeropdest.codiata destino,"
        sSql = sSql & "        sig_diariotrecho.partidamotor,"
        sSql = sSql & "        sig_diariotrecho.decolagem,"
        sSql = sSql & "        sig_diariotrecho.pouso,"
        sSql = sSql & "        sig_diariotrecho.cortemotor,"
        sSql = sSql & "        sig_diariotrecho.atzdec,"
        sSql = sSql & "        sig_diariotrecho.atzpou,"
        sSql = sSql & "        sig_diariotrecho.partidaprev,"
        sSql = sSql & "        sig_diariotrecho.chegadaprev,"
		  sSql = sSql & "        sig_diariotrecho.partidaplanej,"
        sSql = sSql & "        sig_diariotrecho.chegadaplanej,"
		  sSql = sSql & "        sig_diariotrecho.idjustifinterna,"
		  sSql = sSql & "        sig_diariotrecho.flghotran,"		  
        sSql = sSql & "        sig_tipovoo.desctipovoo"
        sSql = sSql & "  FROM  sig_diariovoo,"
        sSql = sSql & "        sig_diariotrecho,"
        sSql = sSql & "        sig_aeroporto aeroporig,"
        sSql = sSql & "        sig_aeroporto aeropdest,"
        sSql = sSql & "        sig_frota,"
        sSql = sSql & "        sig_tipovoo"
        sSql = sSql & "  WHERE ( sig_diariovoo.seqvoodia = sig_diariotrecho.seqvoodia )"
        sSql = sSql & "    AND ( sig_diariotrecho.seqaeroporig = aeroporig.seqaeroporto )"
        sSql = sSql & "    AND ( sig_diariotrecho.seqaeropdest = aeropdest.seqaeroporto )"
        sSql = sSql & "    AND ( sig_diariotrecho.seqfrota = sig_frota.seqfrota )"
        sSql = sSql & "    AND ( sig_diariotrecho.flgcancelado = 'N' )"
        sSql = sSql & "    AND ( sig_diariovoo.tipovoo = sig_tipovoo.idtipovoo  )"
        sSql = sSql & "    AND ( sig_diariovoo.seqvoodia = '" & VooDia & "' )"
        'sSql = sSql & "    AND ( sig_diariotrecho.seqtrecho = '" & Trecho & "' )"
    
          Set RS = Conn.Execute(sSql)

          'Response.Write(RS("partidamotor"))
          'Response.End()
    
    
     Response.Write("<br>")
     Response.Write("<br>")
     Response.Write("<table border='1' bordercolor='black' cellspacing='0' >")
     Response.Write(   "<tr bgcolor='#AAAAAA'>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Nº Voo</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Tipo Voo</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Operação</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Hotran</b></td>")
     Response.Write(   "</tr>")
     Response.Write(   "<tr>")
     Response.Write(     "<td width='500' class='CORPO8' align='center'>")
     Response.Write(RS("nrvoo"))
     Response.Write(     "</td>")
     Response.Write(     "<td width='500' class='CORPO8' align='center'>(")
     Response.Write(RS("tipovoo") &") -"&RS("desctipovoo"))
     Response.Write(     "</td>")
     Response.Write(     "<td width='500' class='CORPO8' align='center'>")
     Response.Write(RS("dtoper"))
     Response.Write(     "</td>")
     Response.Write(     "<td width='500' class='CORPO8' align='center'>")
     If ISNULL(RS("codhotran")) Then
       Response.Write("-")
     Else
       Response.Write(RS("codhotran"))
     End IF
     Response.Write(     "</td>")
     Response.Write(     "</tr>")
     Response.Write("</TABLE>")
     Response.Write("<br>")
     Response.Write("<br>")
     Response.Write("<br>")
     Response.Write("<br>")
     Response.Write("<table border='1' cellspacing='0' >")
     Response.Write(   "<tr bgcolor='#AAAAAA'>")	  
	  Response.Write(     "<td width='3000' colspan='12' class='CORPO9' align='center'><b>Realizado</b></td>")
     Response.Write(   "<tr>")	  
     Response.Write(   "<tr bgcolor='#AAAAAA'>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Origem</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Destino</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Partida</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Decolagem</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Pouso</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Corte</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Dec.</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Pou.</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Prefixo</b></td>")
     Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Frota</b></td>")
	  Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Justificativa</b></td>")
     Response.Write(   "</tr>")

     Dim Cor1, Cor2, Cor, intContador
    intContador = CInt(0)
    Cor1 = "#FFFFFF"
    Cor2 = "#EEEEEE"
    
       DO WHILE NOT RS.EOF
    
       	if ((intContador MOD 2) = 0) then
    			Cor = Cor1
    		else
    			Cor = Cor2
       end if
    
         Response.Write(   "<tr bgcolor=")
         Response.Write(cor &">")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         Response.Write(RS("origem"))
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         Response.Write(RS("destino"))
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
			If ISNull(RS("partidamotor")) Then
			    Response.Write("-")
			Else	 
             Response.Write(FormatDateTime(RS("partidamotor"),4))
			End If	 
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
			If ISNull(RS("decolagem")) Then
             Response.Write("-")
			Else    
				 Response.Write(FormatDateTime(RS("decolagem"),4))
			End If	 
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         If ISNull(RS("pouso")) Then
			    Response.Write("-")
			Else	  
				 Response.Write(FormatDateTime(RS("pouso"),4))
			End If	 
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
			If ISNull(RS("cortemotor")) Then
			    Response.Write("-")
			Else	 
         	 Response.Write(FormatDateTime(RS("cortemotor"),4))
			End If	 
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         If ISNull(RS("atzdec")) Then
			     Response.Write("-")
			Else	  
			     Response.Write(RS("atzdec"))
			End If	  
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         If ISNull(RS("atzpou")) Then
			     Response.Write("-")
			Else
				  Response.Write(RS("atzpou"))
         End If
			Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         If ISNull(RS("prefixoaeronave")) Then
			     Response.Write("-")
			Else
			     Response.Write(RS("prefixoaeronave"))
			End If	  
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         If ISNull(RS("codfrota")) Then
			     Response.Write("-")
			Else
			     Response.Write(RS("codfrota"))
			End If	  
         Response.Write(     "</td>")
			Response.Write(     "<td width='500' class='CORPO8' align='center'>")
			If NOT ISNULL(RS("idjustifinterna"))  Then
			   Response.Write(RS("idjustifinterna"))
			Else
            Response.Write("&nbsp;")
			End If	
         Response.Write(     "</td>")
    
         origem_vet = origem_vet + RS("origem") + ","
         destino_vet = destino_vet + RS("destino") + ","
			
			If IsNull(RS("partidaplanej")) OR IsNull(RS("chegadaplanej")) and RS("flghotran") <> "S" Then
			  partidaprev_vet = partidaprev_vet & RS("partidaprev") & ","
           chegadaprev_vet = chegadaprev_vet & RS("chegadaprev") & ","
			Else
			  partidaprev_vet = partidaprev_vet & RS("partidaplanej") & ","
           chegadaprev_vet = chegadaprev_vet & RS("chegadaplanej") & ","  
    		End If
		
        intContador = intContador + 1
        RS.MOVENEXT
       Loop
    
         Response.Write("</TABLE>")
       Response.Write("<br>")
       Response.Write("<br>")
       Response.Write("<br>")
       Response.Write("<br>")
       Response.Write("<table border='1' cellspacing='0' >")
       Response.Write(   "<tr bgcolor='#AAAAAA'>")
		 'If IsNull(RS("partidaplanej")) OR IsNull(RS("chegadaplanej")) Then
       '  Response.Write(     "<td width='3000' colspan='10' class='CORPO9' align='center'><b>Previsto</b></td>")
		 'else
		   Response.Write(     "<td width='3000' colspan='10' class='CORPO9' align='center'><b>Planejado</b></td>")	
		 'End If	
       Response.Write(   "</tr>")
       Response.Write(   "<tr bgcolor='#AAAAAA'>")
       Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Origem</b></td>")
       Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Destino</b></td>")
		 'If IsNull(RS("partidaplanej")) OR IsNull(RS("chegadaplanej")) Then
		 '	Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Partida Prevista</b></td>")
       '  Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Chegada Prevista</b></td>")
		 'Else
		   Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Partida Planejada</b></td>")
         Response.Write(     "<td width='500' class='CORPO9' align='center'><b>Chegada Planejada</b></td>")
		 'End IF
		 	
       Response.Write(   "</tr>")
    
        origem_vet =      Split(left(origem_vet,Len(origem_vet)-1), ",")
        destino_vet =     Split(left(destino_vet,Len(destino_vet)-1), ",")
        partidaprev_vet = Split(left(partidaprev_vet,Len(partidaprev_vet)-1), ",")
        chegadaprev_vet = Split(left(chegadaprev_vet,Len(chegadaprev_vet)-1), ",")

       For Cont=0 to UBound(origem_vet)
    
           if ((intContador MOD 2) = 0) then
        			Cor = Cor1
        		else
        			Cor = Cor2
           end if
    
          Response.Write(   "<tr bgcolor=")
         Response.Write(cor &">")
         Response.Write(     "<td width='500' class='CORPO8' align='center' >")
         Response.Write(origem_vet(Cont))
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         Response.Write(destino_vet(Cont))
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         Response.Write(FormatDateTime(partidaprev_vet(Cont),4))
         Response.Write(     "</td>")
         Response.Write(     "<td width='500' class='CORPO8' align='center'>")
         Response.Write(FormatDateTime(chegadaprev_vet(Cont),4))
         Response.Write(     "</td>")
         Response.Write(   "</tr>")
    
         intContador = intContador + 1
       NEXT
         Response.Write("</TABLE>")
         Response.Write("<br>")
         Response.Write("<br>")
    Else
        sSql =        " Select sig_diarioatividade.seqatividade, "
        sSql = sSql & "        sig_diarioatividade.prefixoaeronave, "
        sSql = sSql & "        sig_diarioatividade.dtinicio, "
        sSql = sSql & "        sig_diarioatividade.dtfim, "
        sSql = sSql & "        sig_diarioatividade.codatividade, "
        sSql = sSql & "        sig_diarioatividade.seqaeroporto, "
        sSql = sSql & "        sig_diarioatividade.descricao, "
        sSql = sSql & "        sig_diarioatividade.dtiniciorealiz, "
        sSql = sSql & "        sig_diarioatividade.dtfimrealiz, "
        sSql = sSql & "        sig_aeroporto.codiata codiata, "
        sSql = sSql & "        sig_aeroporto.codicao codicao "
        sSql = sSql & " From sig_diarioatividade "
        sSql = sSql & "        LEFT OUTER JOIN sig_aeroporto ON sig_aeroporto.seqaeroporto = sig_diarioatividade.seqaeroporto "
        sSql = sSql & " Where SeqAtividade = '" & SeqAtividade & "' "

          Set RS = Conn.Execute(sSql)

          Response.Write("<br>")
          Response.Write("<br>")
          Response.Write("<br>")
          Response.Write("<br>")
          Response.Write("<Fieldset style='width: 465PX;'>")
          Response.Write(  "<table border='0'>")
          Response.Write(     "<tr>")
          Response.Write(         "<td class='CORPO8' Align='right' ><b>Aeronave: </b></td>")
          Response.Write(         "<td class='CORPO8' Align='left'  ><input type=text class='CORPO8' Value=")
          Response.Write(  RS("prefixoaeronave"))
          Response.Write(         " READONLY></td>")
          Response.Write(     "</tr>")
          Response.Write(  "</table>")
          Response.Write("</Fieldset>")
          Response.Write("<br>")
          Response.Write("<br>")
          Response.Write("<table width='100' >")
          Response.Write(   "<tr>")
          Response.Write(       "<td width='100'>")
          Response.Write(         "<Fieldset style='width: 225px;'>")
          response.Write(          "<LEGEND class='CORPO9'>Previsto</LEGEND>")
          Response.Write(           "<table border='0'>")
          Response.Write(              "<tr Align='right' >")
          Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Início: </b></Label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Day(RS("dtinicio")),2) &"    READONLY><Label>/</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Month(RS("dtinicio")),2)  &"    READONLY><Label>/</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value="& Year(RS("dtinicio"))  &"    READONLY></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&hour(RS("dtinicio")),2)  &"    READONLY><Label>:</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Minute(RS("dtinicio")),2)  &"    READONLY></td>")
          Response.Write(              "</tr>")
          If RS("dtfim") > "" Then
          Response.Write(              "<tr Align='right' >")
          Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Fim: </b></Label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Day(RS("dtfim")),2) &"    READONLY><Label>/</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Month(RS("dtfim")),2)  &"    READONLY><Label>/</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value="& Year(RS("dtfim"))  &"    READONLY></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&hour(RS("dtfim")),2)  &"    READONLY><Label>:</label></td>")
          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Minute(RS("dtfim")),2)  &"    READONLY></td>")
          Response.Write(              "</tr>")
          Response.Write(           "</table>")
          Else
             Response.Write(              "<tr>")
              Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Fim: </b></Label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value=' '    READONLY></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>:</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY></td>")
              Response.Write(              "</tr>")
              Response.Write(           "</table>")
          End If
          Response.Write(         "</Fieldset>")
          Response.Write(       "</td>")
          Response.Write(       "<td width='100'>")
          Response.Write(         "<Fieldset style='width: 233px;'>")
          response.Write(          "<LEGEND class='CORPO9'>Realizado</LEGEND>")
          Response.Write(           "<table border='0'>")
			 If RS("dtiniciorealiz") > "" Then
					 Response.Write(              "<tr Align='right'>")
					 Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Início: </b></Label></td>")
					 Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Day(RS("dtiniciorealiz")),2) &"    READONLY><Label>/</label></td>")
		          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Month(RS("dtiniciorealiz")),2)  &"    READONLY><Label>/</label></td>")
      		    Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value="& Year(RS("dtiniciorealiz"))  &"    READONLY></td>")
       		   Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&hour(RS("dtiniciorealiz")),2)  &"    READONLY><Label>:</label></td>")
		          Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Minute(RS("dtiniciorealiz")),2)  &"    READONLY></td>")
      		    Response.Write(              "</tr>")
			 Else
			     Response.Write(              "<tr>")
              Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Início: </b></Label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value=' '    READONLY></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>:</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY></td>")
              Response.Write(              "</tr>")
			 End If	  
          If RS("dtfimrealiz") > "" Then
              Response.Write(              "<tr>")
              Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Fim: </b></Label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Day(RS("dtfimrealiz")),2) &"    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Month(RS("dtfimrealiz")),2)  &"    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value="& Year(RS("dtfimrealiz"))  &"    READONLY></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&hour(RS("dtfimrealiz")),2)  &"    READONLY><Label>:</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value="& Right("00"&Minute(RS("dtfimrealiz")),2)  &"    READONLY></td>")
              Response.Write(              "</tr>")
              Response.Write(           "</table>")
          Else
              Response.Write(              "<tr>")
              Response.Write(                 "<td class='CORPO8' Align='right'><Label Align='right' class='CORPO8'><b>Fim: </b></Label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>/</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='3' Value=' '    READONLY></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY><Label>:</label></td>")
              Response.Write(                 "<td class='CORPO8' Align='left' ><input Align='right' type=text class='CORPO8' Size='1' Value=' '    READONLY></td>")
              Response.Write(              "</tr>")
              Response.Write(           "</table>")
          End If
          Response.Write(         "</Fieldset>")
          Response.Write("</table>")
          Response.Write("<br>")
          Response.Write("<Fieldset style='width: 465PX;'>")
          Response.Write("<table border='0'>")
          Response.Write(   "<tr>")
          Response.Write(       "<td class='CORPO8' Align='right' ><b>Atividade: </b></td>")
          Response.Write(       "<td class='CORPO8' Align='left'  ><input type=text class='CORPO8' Value=")

          Atividade = RS("codatividade")
          Select Case Atividade
          Case "MNT"
          Response.Write("Manutenção")
          Case "REV"
          Response.Write("Revisão")
          Case "RSV"
          Response.Write("Reserva")
          Case "AOG"
          Response.Write("Ground")
          Case "ATV"
          Response.Write("Atividade")
          End Select
          Response.Write(       " READONLY></td>")
          Response.Write(   "</tr>")
          Response.Write("</table>")
          Response.Write("<table border='0'>")
          Response.Write(   "<tr>")
          Response.Write(       "<td class='CORPO8' Align='right' ><b>Aeroporto: </b></td>")
          Response.Write(       "<td class='CORPO8' Align='left'  ><input type=text class='CORPO8' Value=")
          If  RS("codiata") > "" Then
             Response.Write(RS("codiata"))
          Else
             Response.Write(RS("codicao"))
          End If
          Response.Write(       " READONLY> </td>")
          Response.Write(   "</tr>")
          Response.Write("</table>")
          Response.Write("<table border='0'>")
          Response.Write(   "<tr>")
          Response.Write(       "<td class='CORPO8'  Align='right' VAlign='top'><b>Descrição: </b></td>")
          Response.Write(       "<td class='CORPO8'  Align='left'><TEXTAREA class='CORPO8' COLS='60' ROWS='4' READONLY>")
          IF ISNULL(RS("descricao")) then
              Response.Write("' '")
          Else
              Response.Write(RS("descricao"))
          End If
			 Response.Write(       "</textarea></td>")
          Response.Write(   "</tr>")
          Response.Write("</table>")
          Response.Write("</Fieldset>")
          Response.Write("<br>")
          Response.Write("<br>")
          
    End if



'Fechamos o sistema de conexão
Conn.Close
%>
</body>
</Html>