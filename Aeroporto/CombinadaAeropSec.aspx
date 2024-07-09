<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="CombinadaAeropSec.aspx.cs" Inherits="SIGLA.Web.Aeroporto.CombinadaAeropSec" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<style type="text/css">
		.lblStyle2
		{
			text-align: right;
			display: inline-block;
			width: 7em;
		}

		.lblPequenoStyle1
		{
			text-align: right;
			display: inline-block;
			width: 4em;
		}

		.tdStyle2
		{
			text-align: right;
		}

		.headerStyle2
		{
			text-align: center;
		}

		.txtEmbarqueStyle1
		{
			text-align: right;
			width: 4em;
		}

		.txtConexaoStyle1
		{
			text-align: right;
			width: 4em;
			padding-left: 5px;
		}

		.lblConexaoStyle1
		{
			padding-left: 20px;
		}

		.tamanhoFonteStyle1, .tamanhoFonteStyle1 legend
		{
			font-size: 8pt;
		}

		.txtInfAdStyle1
		{
			text-align: left;
			padding-left: 5px;
		}

		.lblInfAdStyle1
		{
			padding-left: 20px;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="Listagem">
		<asp:GridView ID="gvEtapasCombinadas" runat="server" 
			AutoGenerateColumns="False" CellPadding="3"
			GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
			BorderWidth="1px" onrowcreated="gvEtapasCombinadas_RowCreated" 
			onrowdatabound="gvEtapasCombinadas_RowDataBound" DataKeyNames="SEQ_COMBINADA" 
			onrowcommand="gvEtapasCombinadas_RowCommand">
			<Columns>
				<asp:ButtonField DataTextField="COD_IATA_AEROP_DEST" HeaderText="Destino" CommandName="DESTINO">
				<HeaderStyle Width="5em" />
				</asp:ButtonField>
				<asp:BoundField HeaderText="ADT">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="CHD">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="INF">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="PAGO">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="PAD">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="DHC">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="Cnx. In">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="Livre">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="Excesso">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="Paga">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:BoundField HeaderText="Grátis">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
				<asp:ButtonField DataTextField="COD_IATA_AEROP_DEST" HeaderText="Cnx. Out" CommandName="CNX_OUT">
				<HeaderStyle Width="5em" />
				</asp:ButtonField>
			</Columns>
			<FooterStyle BackColor="#CCCCCC" />
			<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
			<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
			<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
			<AlternatingRowStyle BackColor="#EEEEEE" />
		</asp:GridView>
	</div>
	<div class="InformacoesGerais" runat="server" id="divEmbarque" visible="false" style="padding-bottom: 0;">
		<h4 align='center' style='margin:0 0 0 0;'><asp:Label ID="lblTituloEmbarque" 
				runat="server"></asp:Label></h4>
		<cc1:TabContainer ID="tcPax" runat="server" ActiveTabIndex="0">
			<cc1:TabPanel runat="server" HeaderText="Setor A" ID="tpSecaoPax1">
				<HeaderTemplate>
					Setor A
				</HeaderTemplate>
			</cc1:TabPanel>
		</cc1:TabContainer>
		<table>
			<tr>
				<td style="padding-left: 10px;">
					<asp:Panel ID="pnlBagagem" runat="server" GroupingText="Bagagem" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td>
									&nbsp;
								</td>
								<td class="headerStyle2" colspan="2">
									<asp:Label ID="lblBagLivre" runat="server" Text="Livre" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2" colspan="2">
									<asp:Label ID="lblBagExcesso" runat="server" Text="Excesso" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblBagLivrePeso" runat="server" Text="Peso" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblBagLivreVol" runat="server" Text="Vol." CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblBagExcessoPeso" runat="server" Text="Peso" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblBagExcessoVol" runat="server" Text="Vol." CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblBagLocal" runat="server" Text="Local:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivrePesoLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivrePesoLocal_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivrePesoLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivreVolLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivreVolLocal_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivreVolLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoPesoLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoPesoLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoPesoLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoVolLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoVolLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoVolLocal">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblBagCnxIn" runat="server" Text="Cnx. In:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivrePesoCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivrePesoCnxIn_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivrePesoCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivreVolCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivreVolCnxIn_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivreVolCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoPesoCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoPesoCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoPesoCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoVolCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoVolCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoVolCnxIn">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblBagTotal" runat="server" Text="Total:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivrePesoTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivreVolTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoPesoTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoVolTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
				<td>
					<asp:Panel ID="pnlCarga" runat="server" GroupingText="Carga" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td>
									&nbsp;
								</td>
								<td class="headerStyle2" colspan="2">
									<asp:Label ID="lblCargaPaga" runat="server" Text="Paga" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2" colspan="2">
									<asp:Label ID="lblCargaGratis" runat="server" Text="Grátis" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblCargaPagaPeso" runat="server" Text="Peso" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblCargaPagaVol" runat="server" Text="Vol." CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblCargaGratisPeso" runat="server" Text="Peso" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td class="headerStyle2">
									<asp:Label ID="lblCargaGratisVol" runat="server" Text="Vol." CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblCargaLocal" runat="server" Text="Local:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaPesoLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaPesoLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaPesoLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaVolLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaVolLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaVolLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisPesoLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisPesoLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisPesoLocal">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisVolLocal" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisVolLocal_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisVolLocal">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblCargaCnxIn" runat="server" Text="Cnx. In:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaPesoCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaPesoCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaPesoCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaVolCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaVolCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaVolCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisPesoCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisPesoCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisPesoCnxIn">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisVolCnxIn" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisVolCnxIn_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisVolCnxIn">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
							<tr>
								<td class="tdStyle2">
									<asp:Label ID="lblCargaTotal" runat="server" Text="Total:" CssClass="tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaPesoTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="6"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaVolTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="6"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisPesoTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="6"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisVolTotal" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="6"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
				<td style="vertical-align: top;">
					<asp:Panel ID="pnlPorao" runat="server" GroupingText="Porão" 
						CssClass="tamanhoFonteStyle1" Visible="False">
						<table>
							<tr>
								<td>
									<asp:Label ID="lblPorao1" runat="server" Text="1:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao1" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao1_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao1">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:Label ID="lblPorao2" runat="server" Text="2:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao2" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao2_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao2">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
							<tr>
								<td>
									<asp:Label ID="lblPorao3" runat="server" Text="3:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao3" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao3_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao3">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:Label ID="lblPorao4" runat="server" Text="4:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao4" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao4_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao4">
									</cc1:MaskedEditExtender>
								</td>
							</tr>

                            <tr>
								<td>
									<asp:Label ID="lblPorao5" runat="server" Text="5:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao5" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao5_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao5">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:Label ID="lblPorao6" runat="server" Text="6:" 
										CssClass="tamanhoFonteStyle1 lblPequenoStyle1" Visible="False"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtPorao6" runat="server" 
										CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" Visible="False" MaxLength="6"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao6_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao6">
									</cc1:MaskedEditExtender>
								</td>
							</tr>

						</table>
					</asp:Panel>
				</td>
			</tr>
			<tr>
				<td colspan="3" style="padding-left: 10px;">
					<asp:Label ID="lblObs1" runat="server" 
						Text="Local: Passageiros que realizaram check-in no aeroporto." 
						Font-Size="7pt"></asp:Label>
					<br />
					<asp:Label ID="lblObs2" runat="server" 
						Text="Cnx. In: Passageiros que não realizaram novo check-in no aeroporto." 
						Font-Size="7pt"></asp:Label>
				</td>
			</tr>
		</table>
	</div>
	<div class="InformacoesGerais" runat="server" id="divConexao" visible="false">
		<h4 align='center' style='margin:0 0 0 0;'>
			<asp:Label ID="lblTituloConexao" 
				runat="server" Text="Conexão (Total embarcado para outras bases)"></asp:Label></h4>
		<table align="center">
			<tr>
				<td colspan="2">
					<asp:Panel ID="pnlPaxTran" runat="server" GroupingText="Passageiros" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td style="padding-left: 50px;">
									<asp:Label ID="lblPaxAdtTran" runat="server" Text="ADT:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
									<asp:TextBox ID="txtPaxAdtTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="3"></asp:TextBox>
									<asp:Label ID="lblPaxChdTran" runat="server" Text="CHD:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
									<asp:TextBox ID="txtPaxChdTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="3"></asp:TextBox>
									<asp:Label ID="lblPaxInfTran" runat="server" Text="INF:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
									<asp:TextBox ID="txtPaxInfTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="3"></asp:TextBox>
									<asp:Label ID="lblPaxEconomicaTran" runat="server" Text="PAGO:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
									<asp:TextBox ID="txtPaxEconomicaTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="3"></asp:TextBox>
									<asp:Label ID="lblPaxGratisTran" runat="server" Text="PAD:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
									<asp:TextBox ID="txtPaxGratisTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="3"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
			</tr>
			<tr>  
				<td>
					<asp:Panel ID="pnlBagagemTran" runat="server" GroupingText="Bagagem" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblBagLivrePesoTran" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblBagLivreVolTran" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblBagExcessoPesoTran" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblBagExcessoVolTran" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									<asp:Label ID="lblBagLivreTran" runat="server" Text="Livre:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivrePesoTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivreVolTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:Label ID="lblBagExcessoTran" runat="server" Text="Excesso:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoPesoTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoVolTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" MaxLength="5"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
				<td>
					<asp:Panel ID="pnlCargaTran" runat="server" GroupingText="Carga" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblCargaPagaPesoTran" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblCargaPagaVolTran" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblCargaGratisPesoTran" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblCargaGratisVolTran" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									<asp:Label ID="lblCargaPagaTran" runat="server" Text="Paga:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaPesoTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaVolTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False"></asp:TextBox>
								</td>
								<td>
									<asp:Label ID="lblCargaGratisTran" runat="server" Text="Grátis:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisPesoTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False"></asp:TextBox>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisVolTran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<asp:Panel ID="pnlPoraoTran" runat="server" GroupingText="Porão" 
						CssClass="tamanhoFonteStyle1" Visible="False">
						<table>
							<tr>
								<td style="padding-left: 50px;">
									<asp:Label ID="lblPorao1Tran" runat="server" Text="1:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao1Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
									<asp:Label ID="lblPorao2Tran" runat="server" Text="2:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao2Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
									<asp:Label ID="lblPorao3Tran" runat="server" Text="3:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao3Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
									<asp:Label ID="lblPorao4Tran" runat="server" Text="4:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao4Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
                                    <asp:Label ID="lblPorao5Tran" runat="server" Text="5:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao5Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
                                    <asp:Label ID="lblPorao6Tran" runat="server" Text="6:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao6Tran" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Enabled="False" Visible="False"></asp:TextBox>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
			</tr>
		</table>
	</div>
	<div class="InformacoesGerais" runat="server" id="divInformacoesAdicionais" visible="false">
		<h4 align='center' style='margin:0 0 0 0;'>
			<asp:Label ID="lblInformacoesAdicionais" 
				runat="server" Text="Informações Adicionais"></asp:Label></h4>
		<table align="center">
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblAtdEspeciais" runat="server" Text="Atd. Especiais:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtAtdEspeciais" runat="server" CssClass="txtInfAdStyle1 tamanhoFonteStyle1 txtXXGrande" MaxLength="200"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblMalotes" runat="server" Text="Malotes:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtMalotes" runat="server" CssClass="txtInfAdStyle1 tamanhoFonteStyle1 txtXXGrande" MaxLength="200"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblAgente" runat="server" Text="Agente:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtAgente" runat="server" CssClass="txtInfAdStyle1 tamanhoFonteStyle1 txtXXGrande" MaxLength="200"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblSupervisor" runat="server" Text="Supervisor:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtSupervisor" runat="server" CssClass="txtInfAdStyle1 tamanhoFonteStyle1 txtXXGrande" MaxLength="200"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblObservacao" runat="server" Text="Observação:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtObservacao" runat="server" CssClass="txtInfAdStyle1 tamanhoFonteStyle1 txtXXGrande" MaxLength="200"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td class="tdStyle2">
					<asp:Label ID="lblCombustivel" runat="server" Text="Combustível:" CssClass="lblInfAdStyle1 tamanhoFonteStyle1"></asp:Label>
				</td>
				<td>
					<asp:TextBox ID="txtCombustivel" runat="server" CssClass="txtEmbarqueStyle1 tamanhoFonteStyle1" MaxLength="6"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtCombustivel_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
						TargetControlID="txtCombustivel">
					</cc1:MaskedEditExtender>
				</td>
			</tr>
		</table>
	</div>
	<p class="btn">
		<asp:Button ID="btnCancelar" runat="server" onclick="btnCancelar_Click" 
			Text="Cancelar" Visible="False" CausesValidation="False"/>
		<asp:Button ID="btnGravar" runat="server" onclick="btnGravar_Click" 
			Text="Gravar" Visible="False" />
		<asp:Button ID="btnServicosAeroportuarios" runat="server" onclick="btnServicosAeroportuarios_Click" 
			Text="Serv. Aerop." CausesValidation="False" />
		<asp:Button ID="btnVoltar" runat="server" onclick="btnVoltar_Click" 
			Text="Voltar" CausesValidation="False" />
	</p>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsCombinadaAeropSec" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
	<asp:CustomValidator ID="custValBagLivreLocal" runat="server" 
		ClientValidationFunction="VerificarPesoBagCargaPoroes" 
		ControlToValidate="txtBagLivrePesoLocal" Display="None" 
		ErrorMessage="O somatório do peso dos porões deve ser igual ao total dos pesos de bagagens e carga!"></asp:CustomValidator>
</asp:Content>
