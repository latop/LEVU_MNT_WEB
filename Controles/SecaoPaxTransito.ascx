<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SecaoPaxTransito.ascx.cs" Inherits="SIGLA.Web.Controles.SecaoPaxTransito" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>
<style type="text/css">
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
</style>
<asp:Panel ID="pnlPax" runat="server" GroupingText="Passageiros" CssClass="tamanhoFonteStyle1">
	<table>
		<tr>
			<td>
				<asp:Label ID="lblPaxAdt" runat="server" Text="ADT:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
				<asp:TextBox ID="txtPaxAdt" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
					MaxLength="3"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPaxAdt_MaskedEditExtender" runat="server" 
					AutoComplete="False" CultureAMPMPlaceholder="" 
					CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
					CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					InputDirection="RightToLeft" Mask="999" MaskType="Number" 
					TargetControlID="txtPaxAdt">
				</cc1:MaskedEditExtender>
				<asp:Label ID="lblPaxChd" runat="server" Text="CHD:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
				<asp:TextBox ID="txtPaxChd" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
					MaxLength="3"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPaxChd_MaskedEditExtender" runat="server" 
					AutoComplete="False" CultureAMPMPlaceholder="" 
					CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
					CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					InputDirection="RightToLeft" Mask="999" MaskType="Number" 
					TargetControlID="txtPaxChd">
				</cc1:MaskedEditExtender>
				<asp:Label ID="lblPaxInf" runat="server" Text="INF:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
				<asp:TextBox ID="txtPaxInf" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
					MaxLength="3"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPaxInf_MaskedEditExtender" runat="server" 
					AutoComplete="False" CultureAMPMPlaceholder="" 
					CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
					CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					InputDirection="RightToLeft" Mask="999" MaskType="Number" 
					TargetControlID="txtPaxInf">
				</cc1:MaskedEditExtender>
				<asp:Label ID="lblPaxPago" runat="server" Text="PAGO:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
				<asp:TextBox ID="txtPaxPago" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
					Enabled="False" MaxLength="3"></asp:TextBox>
				<asp:Label ID="lblPaxPad" runat="server" Text="PAD:" CssClass="lblConexaoStyle1 tamanhoFonteStyle1"></asp:Label>
				<asp:TextBox ID="txtPaxPad" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1" 
					MaxLength="3"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPaxPad_MaskedEditExtender" runat="server" 
					AutoComplete="False" CultureAMPMPlaceholder="" 
					CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
					CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					InputDirection="RightToLeft" Mask="999" MaskType="Number" 
					TargetControlID="txtPaxPad">
				</cc1:MaskedEditExtender>
			</td>
		</tr>
	</table>
</asp:Panel>
