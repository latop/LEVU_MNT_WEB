<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="TransitoAeropSec.aspx.cs" Inherits="SIGLA.Web.Aeroporto.TransitoAeropSec" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<style type="text/css">
		.txtConexaoStyle1
		{
			text-align: right;
			width: 4em;
			padding-left: 5px;
		}

		.ddlConexaoStyle1
		{
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
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="Listagem">
		<asp:GridView ID="gvTransito" runat="server" 
			AutoGenerateColumns="False" CellPadding="3"
			GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
			BorderWidth="1px" onrowcreated="gvTransito_RowCreated" 
			onrowdatabound="gvTransito_RowDataBound" DataKeyNames="SEQ_AEROP_DESTINO,NUMERO_VOO" 
			onrowcommand="gvTransito_RowCommand">
			<Columns>
				<asp:ButtonField DataTextField="COD_IATA_AEROP_DEST" HeaderText="Destino" CommandName="DESTINO">
				<HeaderStyle Width="5em" />
				</asp:ButtonField>
				<asp:BoundField HeaderText="Voo">
				<HeaderStyle Width="5em" />
				</asp:BoundField>
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
			</Columns>
			<FooterStyle BackColor="#CCCCCC" />
			<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
			<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
			<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
			<AlternatingRowStyle BackColor="#EEEEEE" />
		</asp:GridView>
	</div>
	<div class="InformacoesGerais" id="divConexao">
		<table>
			<tr>  
				<td colspan="2">
					<asp:Label ID="lblAeropDest" runat="server" Text="Aerop. Dest.:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
					<asp:DropDownList ID="ddlAeropDestino" runat="server" CssClass="ddlConexaoStyle1 tamanhoFonteStyle1">
					</asp:DropDownList>
					<asp:Label ID="lblVoo" runat="server" Text="Voo:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
					<asp:TextBox ID="txtVoo" runat="server" 
						CssClass="txtConexaoStyle1 tamanhoFonteStyle1" MaxLength="4"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtVoo_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="9999" MaskType="Number" 
						TargetControlID="txtVoo">
					</cc1:MaskedEditExtender>
				</td>
			</tr>
			<tr>  
				<td colspan="2" style="padding:10px 0 10px 0;">
					<cc1:TabContainer ID="tcPax" runat="server" ActiveTabIndex="0">
						<cc1:TabPanel runat="server" HeaderText="Setor A" ID="tpSecaoPax1">
							<HeaderTemplate>
								Setor A
							</HeaderTemplate>
						</cc1:TabPanel>
					</cc1:TabContainer>
				</td>
			</tr>
			<tr>  
				<td>
					<asp:Panel ID="pnlBagagem" runat="server" GroupingText="Bagagem" CssClass="tamanhoFonteStyle1">
						<table>
							<tr>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblBagLivrePeso" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblBagLivreVol" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblBagExcessoPeso" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblBagExcessoVol" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									<asp:Label ID="lblBagLivre" runat="server" Text="Livre:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivrePeso" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivrePeso_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivrePeso">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagLivreVol" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagLivreVol_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagLivreVol">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:Label ID="lblBagExcesso" runat="server" Text="Excesso:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoPeso" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoPeso_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoPeso">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtBagExcessoVol" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										MaxLength="5"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtBagExcessoVol_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
										TargetControlID="txtBagExcessoVol">
									</cc1:MaskedEditExtender>
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
								<td>
									<asp:Label ID="lblCargaPagaPeso" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblCargaPagaVol" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									<asp:Label ID="lblCargaGratisPeso" runat="server" Text="Peso" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:Label ID="lblCargaGratisVol" runat="server" Text="Vol." CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									<asp:Label ID="lblCargaPaga" runat="server" Text="Paga:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaPeso" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaPeso_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaPeso">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaPagaVol" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaPagaVol_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaPagaVol">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:Label ID="lblCargaGratis" runat="server" Text="Grátis:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisPeso" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisPeso_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisPeso">
									</cc1:MaskedEditExtender>
								</td>
								<td>
									<asp:TextBox ID="txtCargaGratisVol" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtCargaGratisVol_MaskedEditExtender" runat="server"
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtCargaGratisVol">
									</cc1:MaskedEditExtender>
								</td>
							</tr>
						</table>
					</asp:Panel>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<asp:Panel ID="pnlPorao" runat="server" GroupingText="Porão" 
						CssClass="tamanhoFonteStyle1" Visible="False">
						<table>
							<tr>
								<td>
									<asp:Label ID="lblPorao1" runat="server" Text="1:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao1" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Visible="False"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao1_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao1">
									</cc1:MaskedEditExtender>
									<asp:Label ID="lblPorao2" runat="server" Text="2:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao2" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Visible="False"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao2_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao2">
									</cc1:MaskedEditExtender>
									<asp:Label ID="lblPorao3" runat="server" Text="3:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao3" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Visible="False"></asp:TextBox>
									<cc1:MaskedEditExtender ID="txtPorao3_MaskedEditExtender" runat="server" 
										AutoComplete="False" CultureAMPMPlaceholder="" 
										CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
										CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
										CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
										InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
										TargetControlID="txtPorao3">
									</cc1:MaskedEditExtender>
									<asp:Label ID="lblPorao4" runat="server" Text="4:" 
										CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
									<asp:TextBox ID="txtPorao4" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
										Visible="False"></asp:TextBox>
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
						</table>
					</asp:Panel>
				</td>
			</tr>
		</table>
	</div>
	<p class="btn">
		<asp:Button ID="btnCancelar" runat="server" onclick="btnCancelar_Click" 
			Text="Cancelar" Visible="False" CausesValidation="False" />
		<asp:Button ID="btnGravar" runat="server" onclick="btnGravar_Click" 
			Text="Gravar" />
		<asp:Button ID="btnExcluir" runat="server" onclick="btnExcluir_Click" 
			Text="Excluir" Visible="False" CausesValidation="False" />
		<asp:Button ID="btnVoltar" runat="server" onclick="btnVoltar_Click" 
			Text="Voltar" CausesValidation="False" />
	</p>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsTransitoAeropSec" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
	<asp:RequiredFieldValidator ID="rfvAeropDestino" runat="server" 
		ControlToValidate="ddlAeropDestino" Display="None" 
		ErrorMessage="Selecione um aeroporto no campo Aerop. Dest, por favor!"></asp:RequiredFieldValidator>
	<asp:RequiredFieldValidator ID="rfvVoo" runat="server" 
		ControlToValidate="txtVoo" Display="None" 
		ErrorMessage="Preencha o campo voo, por favor!"></asp:RequiredFieldValidator>
	<asp:RangeValidator ID="rvVoo" runat="server" ControlToValidate="txtVoo" 
		Display="None" 
		ErrorMessage="O campo voo deve ser preenchido com um valor maior do que zero!" 
		MaximumValue="999999" MinimumValue="1" Type="Integer"></asp:RangeValidator>
	<asp:CustomValidator ID="custValBagLivrePeso" runat="server" 
		ClientValidationFunction="VerificarPesoBagCargaPoroes" 
		ControlToValidate="txtBagLivrePeso" Display="None" 
		ErrorMessage="O somatório do peso dos porões deve ser igual ao total dos pesos de bagagens e carga!"></asp:CustomValidator>
</asp:Content>
