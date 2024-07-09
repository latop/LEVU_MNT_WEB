<%@ Page Title="SIGLA - Apis MCL" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="ApisMclManual.aspx.cs" Inherits="SIGLA.Web.Funcionarios.ApisMclManual" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <script type="text/javascript" src="../JS/core.js"></script>
    <script>
        function copiar(id) {
            var copyText = document.getElementById(id);
            copyText.select();
            document.execCommand("copy");
            alert("XML copiado com sucesso!");
            return;
        }
    </script>
    <style type="text/css">
        .lblFiltroStyle1 {
            margin-left: 20px;
        }

        div.FiltroPesquisa .PrimeiraColuna {
            display: inline-block;
            text-align: right;
            width: 20em;
        }

        div.FiltroPesquisa {
            width: 65em;
            margin: 10px 0 0 150px;
            text-align: left;
            white-space: nowrap;
            font-size: 0.8em;
        }

        .ajax__calendar_title {
            width: 140px;
            margin: auto;
        }

        .WrapStyle1 {
            white-space: normal;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblTituloPagina" Text="Apis - Geração manual de MCL" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwPedidos" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="Listagem">
                <table>
                    <tr>
                        <td>Tripulante:</td>
                        <td align="left">
                            <asp:TextBox ID="txtNomeGuerra" runat="server" CssClass="txtUpperCase" Width="20em" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Dt. Ref.:</td>
                        <td align="left">
                            <asp:TextBox ID="txtDataReferencia" runat="server" CssClass="txtXXPequeno" MaxLength="10" TabIndex="2"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>País:</td>
                        <td align="left">
                            <asp:DropDownList ID="ddlPais" runat="server" TabIndex="3"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Tipo:</td>
                        <td align="left">
                            <asp:DropDownList ID="ddlTipo" runat="server" TabIndex="4"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="btnGerarMcl" runat="server" Text="Gerar MCL" ToolTip="Gerar MCL manual" OnClick="btnGerarMcl_Click" TabIndex="5" />
                        </td>
                    </tr>
                </table>

                <cc1:MaskedEditExtender ID="txtPeriodoDe_MaskedEditExtender" runat="server"
                    CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder=""
                    CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="False"
                    Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataReferencia">
                </cc1:MaskedEditExtender>
                <cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server"
                    Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtDataReferencia">
                </cc1:CalendarExtender>
                <asp:CompareValidator ID="cvPeriodoDe" runat="server"
                    ControlToValidate="txtDataReferencia" ErrorMessage="O campo data só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)."
                    Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
                <asp:RequiredFieldValidator ID="rfvPeriodoDe" runat="server"
                    ControlToValidate="txtDataReferencia" Display="Dynamic"
                    ErrorMessage="Preencha o campo data, por favor.">*</asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ID="rfvPais" runat="server"
                    ControlToValidate="ddlPais" ErrorMessage="Informe o país!">*</asp:RequiredFieldValidator>
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                    ControlToValidate="ddlTipo" ErrorMessage="Informe o tipo de arquivo a ser gerado!">*</asp:RequiredFieldValidator>
                <br />
                <table>
                    <tr>
                        <td align="center" valign="top">
                            <asp:Panel ID="Panel1" runat="server" GroupingText="MCL" CssClass="Ficha">
                                <div>
                                    <label class="ColunaRotuloPequeno txtBold">
                                        Texto MCL:</label>
                                    <asp:TextBox runat="server" CssClass="ConteudoEditavel txtXPequeno" ID="txtXml" Width="80%" Height="200px" CausesValidation="false" TextMode="MultiLine" Wrap="true" ReadOnly="true"></asp:TextBox>
                                </div>

                                <button onclick="copiar('<%= ViewState["XML_FILED_ID"] %>')">Copiar texto</button>

                            </asp:Panel>
                        </td>
                    </tr>
                </table>
                <br />
            </div>
        </asp:View>
    </asp:MultiView>
    <asp:ValidationSummary ID="vsPedidos" runat="server" ShowMessageBox="True" ShowSummary="False" />

    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
</asp:Content>
