<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="DadosAeropDecolSec.aspx.cs" Inherits="SIGLA.Web.Aeroporto.DadosAeropDecolSec" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <style type="text/css">
        .txtConexaoStyle1 {
            text-align: right;
            width: 4em;
            padding-left: 5px;
        }

        .ddlConexaoStyle1 {
            padding-left: 5px;
        }

        .lblConexaoStyle1 {
            padding-left: 20px;
        }

        .tamanhoFonteStyle1, .tamanhoFonteStyle1 legend {
            font-size: 8pt;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblTituloPagina" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais" id="divConexao">
        <table>
            <tr>
                <td>
                    <fieldset>
                        <table class="tamanhoFonteStyle1">
                            <tr style="padding-top: 5px; padding-bottom: 5px">
                                <td style="padding-left: 20px; font-weight: bold" align="right">Voo:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblVoo" runat="server" Text=""></asp:Label>
                                </td>
                                <td style="padding-left: 30px; font-weight: bold" align="right">Aeronave:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblAeronave" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr style="padding-top: 5px; padding-bottom: 5px">
                                <td style="padding-left: 20px; font-weight: bold" align="right">Origem:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblAeropOrig" runat="server" Text=""></asp:Label>
                                </td>
                                <td style="padding-left: 30px; font-weight: bold" align="right">Destino:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblAeropDest" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr style="padding-top: 5px; padding-bottom: 5px">
                                <td style="padding-left: 20px; font-weight: bold" align="right">Part. Prev.:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblPartPrev" runat="server" Text=""></asp:Label>
                                </td>
                                <td style="padding-left: 30px; font-weight: bold" align="right">Part. Est.:
                                </td>
                                <td style="padding-left: 5px">
                                    <asp:Label ID="lblPartEst" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
            <tr>
                <td style="padding: 10px 0 10px 0;">
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
                                    <asp:Label ID="lblPorao5" runat="server" Text="5:"
                                        CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
                                    <asp:TextBox ID="txtPorao5" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"
                                        Visible="False"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="txtPorao5_MaskedEditExtender" runat="server"
                                        AutoComplete="False" CultureAMPMPlaceholder=""
                                        CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                        CultureDatePlaceholder="" CultureDecimalPlaceholder=""
                                        CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True"
                                        InputDirection="RightToLeft" Mask="999999" MaskType="Number"
                                        TargetControlID="txtPorao5">
                                    </cc1:MaskedEditExtender>
                                    <asp:Label ID="lblPorao6" runat="server" Text="6:"
                                        CssClass="lblConexaoStyle1 tamanhoFonteStyle1" Visible="False"></asp:Label>
                                    <asp:TextBox ID="txtPorao6" runat="server" CssClass="txtConexaoStyle1 tamanhoFonteStyle1"
                                        Visible="False"></asp:TextBox>
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
        </table>
    </div>
    <p class="btn">
        <asp:Button ID="btnGravar" runat="server" OnClick="btnGravar_Click"
            Text="Gravar" />
        <asp:Button ID="btnVoltar" runat="server" OnClick="btnVoltar_Click"
            Text="Voltar" CausesValidation="False" />
    </p>
    <%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsTransitoAeropSec" runat="server"
        ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
