<%@ Page Title="Movimento de Trânsito" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="RelatorioTransito.aspx.cs" Inherits="SIGLA.Web.Aeroporto.RelatorioTransito" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<style type="text/css">
		.lblStyle1
		{
			font-size:10pt;
			font-weight:bold;
		}

		.lblStyle2
		{
			font-size:9pt;
			white-space:normal;
		}

		.lblStyle3
		{
			white-space:nowrap;
		}

		.lblStyle4
		{
			font-size:10pt;
			font-weight:bold;
		}

		.lblStyle5
		{
			font-weight:bold;
			font-size:9pt;
			white-space:normal;
		}

		.lblAlignRight
		{
			text-align: right;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">Movimento&nbsp;de&nbsp;Trânsito<br />[Horário&nbsp;UTC]</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<asp:MultiView ID="mvwMovimentoTransito" runat="server">
		<asp:View ID="vwRelatorioSemSetores" runat="server">
			<div class="Relatorio">
			<center>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:22.5%;">V&#212;O:&nbsp;<asp:Label ID="lblNumeroVoo" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:34.1%;">PREFIXO:&nbsp;<asp:Label ID="lblPrefixoAeronave" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:43.4%;">LOCAL/DATA:&nbsp;&nbsp;<asp:Label ID="lblLocalData" runat="server" CssClass="lblStyle1"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt;"><asp:Label ID="lblTripulantes" runat="server" CssClass="lblStyle2"></asp:Label></td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt;"><asp:Label ID="lblTripulantesExtJmpObs" runat="server" CssClass="lblStyle2"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;">ORIG:&nbsp;<asp:Label ID="lblCodigoIataOrigem" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:20%;">DEST:&nbsp;<asp:Label ID="lblCodigoIataDestino" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:28%;">POUSO:&nbsp;<asp:Label ID="lblPouso" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:32%;">DECOLAGEM:&nbsp;real&nbsp;<asp:Label ID="lblDecolagem" runat="server" CssClass="lblStyle1"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tbody>
					<tr style="font-size:9pt; text-align:center;">
						<td style="width:8.9%;" rowspan="2">Destino</td>
						<td style="width:2%;" rowspan="2">&nbsp;</td>
						<td style="width:40.5%;" colspan="5">PAX</td>
						<td style="width:16.2%;" colspan="2">BAG</td>
						<td style="width:16.2%;" colspan="2">CGA PAGA</td>
						<td style="width:16.2%;" colspan="2">CGA Grátis</td>
					</tr>
					<tr style="font-size:9pt; text-align:center;">
						<td style="width:8.1%;">ADT</td>
						<td style="width:8.1%;">CHD</td>
						<td style="width:8.1%;">INF</td>
						<td style="width:8.1%;">DHC</td>
						<td style="width:8.1%;">PAD</td>
						<td style="width:8.1%;">VOL</td>
						<td style="width:8.1%;">PESO</td>
						<td style="width:8.1%;">VOL</td>
						<td style="width:8.1%;">PESO</td>
						<td style="width:8.1%;">VOL</td>
						<td style="width:8.1%;">PESO</td>
					</tr>
					<asp:Repeater ID="repCombinada" runat="server" 
						onitemdatabound="repCombinada_ItemDataBound">
						<ItemTemplate>
							<tr style='text-align:right; font-size:10pt; font-weight:bold;'>
								<td style='text-align:center;' rowspan='2'><%# Eval("Destino")%></td>
								<td style='text-align:center; font-size:9pt; font-weight:normal;'>T</td>
								<td style='padding-right:10px;'><%# Eval("PaxAdtTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxChdTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxInfTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxDhcTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxPadTran")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeBagagemTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoBagagemTran")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeCargaPagaTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoCargaPagaTran")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeCargaGratisTran")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoCargaGratisTran")%></td>
							</tr>
							<tr style='text-align:right; font-size:10pt; font-weight:bold;'>
								<td style='text-align:center; font-size:9pt; font-weight:normal;'>L</td>
								<td style='padding-right:10px;'><%# Eval("PaxAdtLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxChdLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxInfLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxDhcLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxPadLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeBagagemLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoBagagemLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeCargaPagaLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoCargaPagaLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("VolumeCargaGratisLocal")%></td>
								<td style='padding-right:10px;'><%# Eval("PesoCargaGratisLocal")%></td>
							</tr>
							<asp:Repeater ID="repCombinadaTran" runat="server">
								<ItemTemplate>
									<tr style='text-align:right; font-size:8pt;'>
										<td style='padding-right:10px;' colspan='2'><%# Eval("CodIataAeropDest")%>&nbsp;(<%# Eval("NumeroVoo")%>)</td>
										<td style='padding-right:10px;'><%# Eval("PaxAdt")%></td>
										<td style='padding-right:10px;'><%# Eval("PaxChd")%></td>
										<td style='padding-right:10px;'><%# Eval("PaxInf")%></td>
										<td style='padding-right:10px;'>0</td>
										<td style='padding-right:10px;'><%# Eval("PaxPad")%></td>
										<td style='padding-right:10px;'><%# Eval("VolumeBagagem")%></td>
										<td style='padding-right:10px;'><%# Eval("PesoBagagem")%></td>
										<td style='padding-right:10px;'><%# Eval("VolumeCargaPaga")%></td>
										<td style='padding-right:10px;'><%# Eval("PesoCargaPaga")%></td>
										<td style='padding-right:10px;'><%# Eval("VolumeCargaGratis")%></td>
										<td style='padding-right:10px;'><%# Eval("PesoCargaGratis")%></td>
									</tr>
								</ItemTemplate>
							</asp:Repeater>
						</ItemTemplate>
					</asp:Repeater>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;Local</td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalLocal" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;Trânsito</td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalTransito" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;A&nbsp;BORDO</td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalBordo" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="13"></th>
					</tr>
				</tfoot>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;" colspan="1">
						<asp:Label ID="lblRotuloPob" runat="server" Text="POB:" Width="40px"></asp:Label>
						<asp:Label ID="lblPob" runat="server" CssClass="lblStyle1 lblAlignRight" Width="60px"></asp:Label>
					</td>
					<td style="padding-left:5px; font-size:9pt; width:80%;" colspan="1">OBS.:&nbsp;<asp:Label ID="lblObservacao" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;" colspan="1">
						<asp:Label ID="lblRotuloFuel" runat="server" Text="FUEL:" Width="40px"></asp:Label>
						<asp:Label ID="lblFuel" runat="server" CssClass="lblStyle1 lblAlignRight" Width="60px"></asp:Label>
					</td>
					<td style="padding-left:5px; font-size:9pt; width:80%;" colspan="1">ATD. ESPECIAIS:&nbsp;<asp:Label ID="lblAtdEspeciais" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="vertical-align:top; padding-left:5px; font-size:9pt; width:70%;" rowspan="2">MALOTES:&nbsp;<asp:Label ID="lblMalotes" runat="server" CssClass="lblStyle5"></asp:Label></td>
					<td style="padding-left:15px; font-size:9pt; width:30%;">
						<asp:Label ID="lblRotuloTtlVol" runat="server" Text="TTL VOL:" Width="70px"></asp:Label>
						<asp:Label ID="lblVolumeTotalGeral" runat="server" CssClass="lblStyle1 lblAlignRight" Width="70px"></asp:Label>
					</td>
				</tr>
				<tr>
					<td style="padding-left:15px; font-size:9pt; width:30%;">
						<asp:Label ID="lblRotuloTtlPeso" runat="server" Text="TTL PESO:" Width="70px"></asp:Label>
						<asp:Label ID="lblPesoTotalGeral" runat="server" CssClass="lblStyle1 lblAlignRight" Width="70px"></asp:Label>
					</td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:100%;" colspan="2">ASSINATURA CMRA.:&nbsp;</td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:50%;">AGENTE:&nbsp;<asp:Label ID="lblAgente" runat="server" CssClass="lblStyle5"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:50%;">SUPERVISOR:&nbsp;<asp:Label ID="lblSupervisor" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
			</table>
			</center>
			</div>
		</asp:View>
		<asp:View ID="vwRelatorioComSetores" runat="server">
			<div class="Relatorio">
			<center>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:22.5%;">V&#212;O:&nbsp;<asp:Label ID="lblNumeroVooSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:34.1%;">PREFIXO:&nbsp;<asp:Label ID="lblPrefixoAeronaveSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:43.4%;">LOCAL/DATA:&nbsp;&nbsp;<asp:Label ID="lblLocalDataSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt;"><asp:Label ID="lblTripulantesSetores" runat="server" CssClass="lblStyle2"></asp:Label></td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt;"><asp:Label ID="lblTripulantesSetoresExtJmpObs" runat="server" CssClass="lblStyle2"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;">ORIG:&nbsp;<asp:Label ID="lblCodigoIataOrigemSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:20%;">DEST:&nbsp;<asp:Label ID="lblCodigoIataDestinoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:28%;">POUSO:&nbsp;<asp:Label ID="lblPousoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:32%;">DECOLAGEM:&nbsp;real&nbsp;<asp:Label ID="lblDecolagemSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:center; font-family:Verdana,Arial,Sans-Serif;">
				<tbody>
					<tr style="font-size:9pt; text-align:center;">
						<td rowspan="3">Destino</td>
						<td rowspan="3">&nbsp;</td>
						<asp:Literal ID="litHeaderPaxSetores" runat="server"></asp:Literal>
						<td rowspan="2" colspan="2">BAG</td>
						<td rowspan="2" colspan="2">CGA PAGA</td>
						<td rowspan="2" colspan="2">CGA Grátis</td>
					</tr>
					<tr style="font-size:9pt; text-align:center;">
						<asp:Repeater ID="repHeaderSetores" runat="server">
							<ItemTemplate>
								<td colspan="5">SETOR <%# Eval("Setor")%></td>
							</ItemTemplate>
						</asp:Repeater>
						<td colspan="5">TOTAL</td>
					</tr>
					<tr style="font-size:9pt; text-align:center;">
						<asp:Repeater ID="repHeaderDetalheSetores" runat="server">
							<ItemTemplate>
								<td>ADT</td>
								<td>CHD</td>
								<td>INF</td>
								<td>DHC</td>
								<td>PAD</td>
							</ItemTemplate>
						</asp:Repeater>
						<td>ADT</td>
						<td>CHD</td>
						<td>INF</td>
						<td>DHC</td>
						<td>PAD</td>
						<td>VOL</td>
						<td>PESO</td>
						<td>VOL</td>
						<td>PESO</td>
						<td>VOL</td>
						<td>PESO</td>
					</tr>
					<asp:Repeater ID="repCombinadaSetores" runat="server" 
						onitemdatabound="repCombinadaSetores_ItemDataBound">
						<ItemTemplate>
							<tr style='text-align:right; font-size:10pt; font-weight:bold;'>
								<td style='text-align:center;' rowspan='2'><%# Eval("Destino")%></td>
								<td style='text-align:center; font-size:9pt; font-weight:normal;'>T</td>
								<asp:Repeater ID="repPaxTranSetores" runat="server">
									<ItemTemplate>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdtTran")) == 0) ? "&nbsp;" : Eval("PaxAdtTran")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChdTran")) == 0) ? "&nbsp;" : Eval("PaxChdTran")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInfTran")) == 0) ? "&nbsp;" : Eval("PaxInfTran")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxDhcTran")) == 0) ? "&nbsp;" : Eval("PaxDhcTran")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPadTran")) == 0) ? "&nbsp;" : Eval("PaxPadTran")%></td>
									</ItemTemplate>
								</asp:Repeater>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdtTran")) == 0) ? "&nbsp;" : Eval("PaxAdtTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChdTran")) == 0) ? "&nbsp;" : Eval("PaxChdTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInfTran")) == 0) ? "&nbsp;" : Eval("PaxInfTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxDhcTran")) == 0) ? "&nbsp;" : Eval("PaxDhcTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPadTran")) == 0) ? "&nbsp;" : Eval("PaxPadTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeBagagemTran")) == 0) ? "&nbsp;" : Eval("VolumeBagagemTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoBagagemTran")) == 0) ? "&nbsp;" : Eval("PesoBagagemTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaPagaTran")) == 0) ? "&nbsp;" : Eval("VolumeCargaPagaTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaPagaTran")) == 0) ? "&nbsp;" : Eval("PesoCargaPagaTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaGratisTran")) == 0) ? "&nbsp;" : Eval("VolumeCargaGratisTran")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaGratisTran")) == 0) ? "&nbsp;" : Eval("PesoCargaGratisTran")%></td>
							</tr>
							<tr style='text-align:right; font-size:10pt; font-weight:bold;'>
								<td style='text-align:center; font-size:9pt; font-weight:normal;'>L</td>
								<asp:Repeater ID="repPaxLocalSetores" runat="server">
									<ItemTemplate>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdtLocal")) == 0) ? "&nbsp;" : Eval("PaxAdtLocal")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChdLocal")) == 0) ? "&nbsp;" : Eval("PaxChdLocal")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInfLocal")) == 0) ? "&nbsp;" : Eval("PaxInfLocal")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxDhcLocal")) == 0) ? "&nbsp;" : Eval("PaxDhcLocal")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPadLocal")) == 0) ? "&nbsp;" : Eval("PaxPadLocal")%></td>
									</ItemTemplate>
								</asp:Repeater>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdtLocal")) == 0) ? "&nbsp;" : Eval("PaxAdtLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChdLocal")) == 0) ? "&nbsp;" : Eval("PaxChdLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInfLocal")) == 0) ? "&nbsp;" : Eval("PaxInfLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxDhcLocal")) == 0) ? "&nbsp;" : Eval("PaxDhcLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPadLocal")) == 0) ? "&nbsp;" : Eval("PaxPadLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeBagagemLocal")) == 0) ? "&nbsp;" : Eval("VolumeBagagemLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoBagagemLocal")) == 0) ? "&nbsp;" : Eval("PesoBagagemLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaPagaLocal")) == 0) ? "&nbsp;" : Eval("VolumeCargaPagaLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaPagaLocal")) == 0) ? "&nbsp;" : Eval("PesoCargaPagaLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaGratisLocal")) == 0) ? "&nbsp;" : Eval("VolumeCargaGratisLocal")%></td>
								<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaGratisLocal")) == 0) ? "&nbsp;" : Eval("PesoCargaGratisLocal")%></td>
							</tr>
							<asp:Repeater ID="repCombinadaTranSetores" runat="server" 
								onitemdatabound="repCombinadaTranSetores_ItemDataBound">
								<ItemTemplate>
									<tr style='text-align:right; font-size:8pt;'>
										<td style='padding-right:10px;' colspan='2'><%# Eval("CodIataAeropDest")%>&nbsp;(<%# Eval("NumeroVoo")%>)</td>
										<asp:Repeater ID="repCombTranPaxSetores" runat="server">
											<ItemTemplate>
												<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdt")) == 0) ? "&nbsp;" : Eval("PaxAdt")%></td>
												<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChd")) == 0) ? "&nbsp;" : Eval("PaxChd")%></td>
												<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInf")) == 0) ? "&nbsp;" : Eval("PaxInf")%></td>
												<td style='padding-right:10px;'>&nbsp;</td>
												<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPad")) == 0) ? "&nbsp;" : Eval("PaxPad")%></td>
											</ItemTemplate>
										</asp:Repeater>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxAdt")) == 0) ? "&nbsp;" : Eval("PaxAdt")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxChd")) == 0) ? "&nbsp;" : Eval("PaxChd")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxInf")) == 0) ? "&nbsp;" : Eval("PaxInf")%></td>
										<td style='padding-right:10px;'>&nbsp;</td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PaxPad")) == 0) ? "&nbsp;" : Eval("PaxPad")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeBagagem")) == 0) ? "&nbsp;" : Eval("VolumeBagagem")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoBagagem")) == 0) ? "&nbsp;" : Eval("PesoBagagem")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaPaga")) == 0) ? "&nbsp;" : Eval("VolumeCargaPaga")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaPaga")) == 0) ? "&nbsp;" : Eval("PesoCargaPaga")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("VolumeCargaGratis")) == 0) ? "&nbsp;" : Eval("VolumeCargaGratis")%></td>
										<td style='padding-right:10px;'><%# (Convert.ToInt32(Eval("PesoCargaGratis")) == 0) ? "&nbsp;" : Eval("PesoCargaGratis")%></td>
									</tr>
								</ItemTemplate>
							</asp:Repeater>
						</ItemTemplate>
					</asp:Repeater>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;Local</td>
						<asp:Repeater ID="repPaxLocalSetoresTotal" runat="server">
							<ItemTemplate>
								<td style='padding-right:10px;'><%# Eval("PaxAdtLocalTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxChdLocalTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxInfLocalTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxDhcLocalTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxPadLocalTotal")%></td>
							</ItemTemplate>
						</asp:Repeater>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalLocalSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;Trânsito</td>
						<asp:Repeater ID="repPaxTransitoSetoresTotal" runat="server">
							<ItemTemplate>
								<td style='padding-right:10px;'><%# Eval("PaxAdtTranTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxChdTranTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxInfTranTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxDhcTranTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxPadTranTotal")%></td>
							</ItemTemplate>
						</asp:Repeater>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalTransitoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
					<tr style='text-align:right; font-size:10pt; font-weight:bold; background-color:#E1E1E1;'>
						<td style='text-align:center; font-size:9pt; font-weight:normal;' colspan='2'>TTL&nbsp;A&nbsp;BORDO</td>
						<asp:Repeater ID="repPaxBordoSetoresTotal" runat="server">
							<ItemTemplate>
								<td style='padding-right:10px;'><%# Eval("PaxAdtBordoTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxChdBordoTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxInfBordoTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxDhcBordoTotal")%></td>
								<td style='padding-right:10px;'><%# Eval("PaxPadBordoTotal")%></td>
							</ItemTemplate>
						</asp:Repeater>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxAdtTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxChdTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxInfTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxDhcTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPaxPadTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeBagagemTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoBagagemTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaPagaTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaPagaTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblVolumeCargaGratisTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
						<td style='padding-right:10px;'><asp:Label ID="lblPesoCargaGratisTotalBordoSetores" runat="server" CssClass="lblStyle1"></asp:Label></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<asp:Literal ID="litFooterTabelaSetores" runat="server"></asp:Literal>
					</tr>
				</tfoot>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;" colspan="1">
						<asp:Label ID="lblRotuloPobSetores" runat="server" Text="POB:" Width="40px"></asp:Label>
						<asp:Label ID="lblPobSetores" runat="server" CssClass="lblStyle1 lblAlignRight" Width="60px"></asp:Label>
					</td>
					<td style="padding-left:5px; font-size:9pt; width:80%;" colspan="1">OBS.:&nbsp;<asp:Label ID="lblObservacaoSetores" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:20%;" colspan="1">
						<asp:Label ID="lblRotuloFuelSetores" runat="server" Text="FUEL:" Width="40px"></asp:Label>
						<asp:Label ID="lblFuelSetores" runat="server" CssClass="lblStyle1 lblAlignRight" Width="60px"></asp:Label>
					</td>
					<td style="padding-left:5px; font-size:9pt; width:80%;" colspan="1">ATD. ESPECIAIS:&nbsp;<asp:Label ID="lblAtdEspeciaisSetores" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="vertical-align:top; padding-left:5px; font-size:9pt; width:70%;" rowspan="2">MALOTES:&nbsp;<asp:Label ID="lblMalotesSetores" runat="server" CssClass="lblStyle5"></asp:Label></td>
					<td style="padding-left:15px; font-size:9pt; width:30%;">
						<asp:Label ID="lblRotuloTtlVolSetores" runat="server" Text="TTL VOL:" Width="70px"></asp:Label>
						<asp:Label ID="lblVolumeTotalGeralSetores" runat="server" CssClass="lblStyle1 lblAlignRight" Width="70px"></asp:Label>
					</td>
				</tr>
				<tr>
					<td style="padding-left:15px; font-size:9pt; width:30%;">
						<asp:Label ID="lblRotuloTtlPesoSetores" runat="server" Text="TTL PESO:" Width="70px"></asp:Label>
						<asp:Label ID="lblPesoTotalGeralSetores" runat="server" CssClass="lblStyle1 lblAlignRight" Width="70px"></asp:Label>
					</td>
				</tr>
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:100%;" colspan="2">ASSINATURA CMRA.:&nbsp;</td>
				</tr>
			</table>
			<table width="98%" border="1" cellpadding="0" cellspacing="0" style="text-align:left; font-family:Verdana,Arial,Sans-Serif;">
				<tr>
					<td style="padding-left:5px; font-size:9pt; width:50%;">AGENTE:&nbsp;<asp:Label ID="lblAgenteSetores" runat="server" CssClass="lblStyle5"></asp:Label></td>
					<td style="padding-left:5px; font-size:9pt; width:50%;">SUPERVISOR:&nbsp;<asp:Label ID="lblSupervisorSetores" runat="server" CssClass="lblStyle5"></asp:Label></td>
				</tr>
			</table>
			</center>
			</div>
		</asp:View>
	</asp:MultiView>
	<p class="btn">
		<asp:Button ID="btnVoltar" runat="server" onclick="btnVoltar_Click" 
			Text="Voltar" CausesValidation="False" />
	</p>
</asp:Content>
