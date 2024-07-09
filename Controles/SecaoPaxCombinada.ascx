<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SecaoPaxCombinada.ascx.cs"
    Inherits="SIGLA.Web.Controles.SecaoPaxCombinada" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<style type="text/css">
    .lblStyleSecaoPaxComb1
    {
        text-align: right;
        display: inline-block;
        width: 8em;
    }
    
    .pnlStyleSecaoPaxComb1
    {
        padding-top: 5px;
    }
    
    .tamanhoFonteStyleSecaoPaxComb1, .tamanhoFonteStyleSecaoPaxComb1 legend
    {
        font-size: 8pt;
    }
    
    .tdStyleSecaoPaxComb1
    {
        text-align: right;
    }
    
    .headerStyleSecaoPaxComb1
    {
        text-align: center;
    }
    
    .txtStyleSecaoPaxComb1
    {
        text-align: right;
        width: 4em;
    }
</style>
<table>
    <tr>
        <td>
            <asp:Panel ID="pnlPaxPago" runat="server" GroupingText="Passageiros Pagos" CssClass="tamanhoFonteStyleSecaoPaxComb1">
                <table>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td class="headerStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxAdt" runat="server" Text="ADT" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td class="headerStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxChd" runat="server" Text="CHD" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td class="headerStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxInf" runat="server" Text="INF" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td class="headerStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxPago" runat="server" Text="Pago" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxLocal" runat="server" Text="Local:" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxAdtLocal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxAdtLocal_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxAdtLocal">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxChdLocal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxChdLocal_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxChdLocal">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxInfLocal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxInfLocal_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxInfLocal">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxPagoLocal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxCnxIn" runat="server" Text="Cnx. In:" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxAdtCnxIn" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxAdtCnxIn_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxAdtCnxIn">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxChdCnxIn" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxChdCnxIn_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxChdCnxIn">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxInfCnxIn" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                MaxLength="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="txtPaxInfCnxIn_MaskedEditExtender" runat="server" AutoComplete="False"
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                                MaskType="Number" TargetControlID="txtPaxInfCnxIn">
                            </cc1:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxPagoCnxIn" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdStyleSecaoPaxComb1">
                            <asp:Label ID="lblPaxTotal" runat="server" Text="Total:" CssClass="tamanhoFonteStyleSecaoPaxComb1"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxAdtTotal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxChdTotal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxInfTotal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPaxPagoTotal" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                                Enabled="False" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </td>
        <td style="padding-left: 20px; vertical-align: top;">
            <asp:Panel ID="pnlPaxNaoPago" runat="server" GroupingText="Passageiros Não Pagos"
                CssClass="tamanhoFonteStyleSecaoPaxComb1">
                <div style="padding: 5px 0 5px 0;">
                    <asp:Label ID="lblPaxPad" runat="server" Text="PAD:" CssClass="tamanhoFonteStyleSecaoPaxComb1 lblStyleSecaoPaxComb1"></asp:Label>
                    <asp:TextBox ID="txtPaxPad" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                        MaxLength="3"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtPaxPad_MaskedEditExtender" runat="server" AutoComplete="False"
                        CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                        CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                        CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                        MaskType="Number" TargetControlID="txtPaxPad">
                    </cc1:MaskedEditExtender>
                    <asp:Label ID="lblPaxDhc" runat="server" Text="DHC:" CssClass="tamanhoFonteStyleSecaoPaxComb1 lblStyleSecaoPaxComb1"></asp:Label>
                    <asp:TextBox ID="txtPaxDhc" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                        MaxLength="3"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtPaxDhc_MaskedEditExtender" runat="server" AutoComplete="False"
                        CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                        CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                        CultureTimePlaceholder="" Enabled="True" InputDirection="RightToLeft" Mask="999"
                        MaskType="Number" TargetControlID="txtPaxDhc">
                    </cc1:MaskedEditExtender>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlPaxCodeShared" runat="server" GroupingText="Passageiros Code-Shared"
                CssClass="pnlStyleSecaoPaxComb1 tamanhoFonteStyleSecaoPaxComb1">
                <div style="padding: 5px 0 5px 0;">
                    <asp:Label ID="lblPaxCsEmbarcados" runat="server" Text="Embarcados:" CssClass="tamanhoFonteStyleSecaoPaxComb1 lblStyleSecaoPaxComb1"></asp:Label>
                    <asp:TextBox ID="txtPaxCsEmbarcados" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                        MaxLength="3"></asp:TextBox>
                    <asp:Label ID="lblPaxCsReservados" runat="server" Text="Reservados:" CssClass="tamanhoFonteStyleSecaoPaxComb1 lblStyleSecaoPaxComb1"></asp:Label>
                    <asp:TextBox ID="txtPaxCsReservados" runat="server" CssClass="tamanhoFonteStyleSecaoPaxComb1 txtStyleSecaoPaxComb1"
                        MaxLength="3"></asp:TextBox>
                </div>
            </asp:Panel>
        </td>
    </tr>
</table>
<asp:CompareValidator Operator="DataTypeCheck" ControlToValidate="txtPaxCsEmbarcados"  runat="server"
    Type="Integer" Display="None" ErrorMessage="O campo passageiros code-shared embarcados inválido!">
</asp:CompareValidator>
<asp:CompareValidator Operator="DataTypeCheck" ControlToValidate="txtPaxCsReservados"  runat="server"
    Type="Integer" Display="None" ErrorMessage="O campo passageiros code-shared reservados inválido!">
</asp:CompareValidator>
<asp:CompareValidator ID="compValPaxCs" runat="server" ControlToCompare="txtPaxCsReservados"
    ControlToValidate="txtPaxCsEmbarcados" Display="None" ErrorMessage="O campo passageiros code-shared embarcados não pode ser maior do que o campo passageiros code-shared reservados!"
    Operator="LessThanEqual" Type="String"></asp:CompareValidator>
<asp:CustomValidator ID="custValPaxCs" runat="server" ClientValidationFunction="VerificarPaxCsPaxPago"
    ControlToValidate="txtPaxCsEmbarcados" Display="None" ErrorMessage="O campo passageiros code-shared embarcados não pode ser maior do que o total de passageiros pagos!"></asp:CustomValidator>
