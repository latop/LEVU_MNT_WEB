<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%Response.Expires = 0%>
<%Response.Buffer = true%>
<!--#include file="verificaloginaeroporto.asp"-->
<!--#include file="libgeral.asp"-->
<!--#include file="conexoesinbound_asp.asp"-->

<html>

	<head>
		<title>Conexões Inbound</title>
		<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
		<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)" />
		<script type="text/javascript" src="javascript.js"></script>
		<script type="text/javascript" src="jquery-1.1.4.js"></script>
	</head>

	<body>
		<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0" id="TableTitulo">
			<tr>
				<td class="corpo" align="left" valign="middle" width="35%">
					<img src="imagens/logo_empresa.gif" border="0" />
				</td>
				<td class="corpo" align="center">
					<% call PreencherTitulo() %>
				</td>
				<td class="corpo" align="right" valign="bottom" width="35%">&nbsp;
					<a href="http://www.latop.com.br"><img src="imagens/sigla.gif" border="0" /></a>
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
		<br />
		<br />
		<table border="1" cellpadding="0" align="center" cellspacing="0" ID="Table2">
			<thead>	
				<tr style="background-color:#AAAAAA">
					<th class="CORPO9" rowspan="2" style="width:70px" >Voo</th>
					<th class="CORPO9" rowspan="2" style="width:80px" >Data</th>
					<th class="CORPO9" rowspan="2" style="width:65px" >Origem</th>
					<th class="CORPO9" rowspan="2" style="width:65px" >Conexão</th>
					<th class="CORPO9" rowspan="2" style="width:65px" >Destino</th>
					<th class="CORPO9" colspan="5" style="width:300px" >Passageiros</th>
					<th class="CORPO9" colspan="2" style="width:120px" >Bagagem</th>
					<th class="CORPO9" colspan="2" style="width:120px" >Carga</th> 
				</tr>
				<tr style="background-color:#AAAAAA">
					<th class="CORPO9" style="width:60px" >ADT</th>
					<th class="CORPO9" style="width:60px" >CHD</th>
					<th class="CORPO9" style="width:60px" >INF</th>
					<th class="CORPO9" style="width:60px" >PAGO</th>
					<th class="CORPO9" style="width:60px" >PAD</th>
					<th class="CORPO9" style="width:60px" >Livre</th>
					<th class="CORPO9" style="width:60px" >Excesso</th>
					<th class="CORPO9" style="width:60px" >Paga</th>
					<th class="CORPO9" style="width:60px" >Grátis</th>
				</tr>
			</thead>
			<tbody>
				<% call PreencherTabelaConexoesInbound() %>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="14"></th>
				</tr>
			</tfoot>
		</table>
		<br />
		<form method="post" action="conexoesinbound.asp">
			<table style="border:0px; padding:0px; text-align:center; border-spacing:0px; width:100%" id="Table1">
				<tr style="padding-top: 20px;">
					<td style="text-align:center; width:100%;">
						<input type="submit" value="Voltar" name="btnVoltar" class="botao1" style="width:80px; height:25px;" id="btnVoltar" tabindex="1" />
						<input type="hidden" name="hidSeqVooDia" id="hidSeqVooDia" value="<%=intSeqVooDia%>" />
						<input type="hidden" name="hidSeqTrecho" id="hidSeqTrecho" value="<%=intSeqTrecho%>" />
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
