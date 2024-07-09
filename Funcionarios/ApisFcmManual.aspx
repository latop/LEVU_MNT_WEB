<%@ Page Title="SIGLA - Apis FCM" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="ApisFcmManual.aspx.cs" Inherits="SIGLA.Web.Funcionarios.ApisFcmManual" ValidateRequest="false" %>

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
        .txtFiltroStyle1 {
            width: 4em;
        }

        .lblFiltroStyle1 {
            margin-left: 20px;
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
        <asp:Label ID="lblTituloPagina" Text="Apis - Geração manual de FCM" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwPedidos" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="Listagem">
                <table>
                    <tr>
                        <td align="right">Voo:</td>
                        <td align="left">
                            <asp:TextBox runat="server" ID="txtNumeroVoo" Width="4em" MaxLength="4" TabIndex="1"></asp:TextBox>
                        </td>
                        <td align="right">Data:</td>
                        <td align="left">
                            <asp:TextBox ID="txtDataReferencia" runat="server" CssClass="txtXXPequeno" MaxLength="10" TabIndex="2"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Origem:</td>
                        <td align="left">
                            <asp:TextBox runat="server" ID="txtOrigem" CssClass="txtUpperCase" Width="4em" MaxLength="4" TabIndex="3"></asp:TextBox>
                        </td>
                        <td align="right">Destino:</td>
                        <td align="left">
                            <asp:TextBox runat="server" ID="txtDestino" CssClass="txtUpperCase" Width="4em" MaxLength="4" TabIndex="4"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="4">
                            <asp:Button ID="btnGerarFcm" runat="server" Text="Gerar FCM" ToolTip="Gerar FCM manual" OnClick="btnGerarFcm_Click" />
                        </td>
                    </tr>

                    <tr align="left">
                        <asp:RequiredFieldValidator ID="rfvNumeroVoo" runat="server"
                            ControlToValidate="txtNumeroVoo" ErrorMessage="Informe o voo!">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ControlToValidate="txtNumeroVoo" ErrorMessage="Somente números são permitidos" ValidationExpression="\d+">
                        </asp:RegularExpressionValidator>

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


                        <%--<cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" CultureAMPMPlaceholder=""
                            CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                            CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                            Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataReferencia">
                        </cc1:MaskedEditExtender>
                        <asp:RequiredFieldValidator ID="rfvDataReferencia" runat="server"
                            ControlToValidate="txtDataReferencia" ErrorMessage="Informe a data!">*</asp:RequiredFieldValidator>--%>

                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtOrigem" ErrorMessage="Informe a origem!">*</asp:RequiredFieldValidator>

                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDestino"
                            ErrorMessage="Informe o destino!">*</asp:RequiredFieldValidator>

                    </tr>
                </table>
                <br />
                <table>
                    <tr>
                        <td align="center" valign="top">
                            <asp:Panel ID="Panel1" runat="server" GroupingText="FCM" CssClass="Ficha">
                                <div>
                                    <label class="ColunaRotuloPequeno txtBold">
                                        Texto FCM:</label>
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
