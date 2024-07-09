<%@ Page Title="SIGLA - Amos" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="EnvioAmosDiarioBordo.aspx.cs" Inherits="SIGLA.Web.Funcionarios.EnvioAmosDiarioBordo" ValidateRequest="false" %>

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
        <asp:Label ID="lblTituloPagina" Text="Amos - Diário de bordo" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwPedidos" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="Listagem">
                <p class="btn">
                    <label class="ColunaRotuloPequeno txtBold">
                        Prefixo aeronave:</label>
                    <asp:TextBox runat="server" ID="txtFiltroPrefixoAeronave"></asp:TextBox>

                    <label class="ColunaRotuloPequeno txtBold">
                        Data Trilho:</label>
                    <asp:TextBox ID="txtFiltroDataTrilho" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFiltroDataTrilho">
                    </cc1:MaskedEditExtender>

                    <%--<cc1:MaskedEditExtender ID="txtPeriodoDe_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtPeriodoDe">
                    </cc1:MaskedEditExtender>--%>
                    <cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server" Enabled="True"
                        Format="dd/MM/yyyy" TargetControlID="txtFiltroDataTrilho">
                    </cc1:CalendarExtender>

                    <br />
                    <label class="ColunaRotuloPequeno txtBold">
                        Data Envio (início):</label>
                    <asp:TextBox ID="txtFiltroDataEnvioInicio" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFiltroDataEnvioInicio">
                    </cc1:MaskedEditExtender>

                    <label class="ColunaRotuloPequeno txtBold">
                        Data Envio (fim):</label>
                    <asp:TextBox ID="txtFiltroDataEnvioFim" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFiltroDataEnvioFim">
                    </cc1:MaskedEditExtender>

                    <br />
                    <asp:Button ID="btnAtualizarLista" runat="server"
                        Text="Atualizar Lista"
                        ToolTip="Atualiza a lista de envio de Amos" OnClick="btnAtualizarLista_Click" />
                    <asp:Button ID="Button1" runat="server" Text="Enviar arquivos Amos" OnClick="btnNovoRegistro_Click"
                        TabIndex="60" CausesValidation="False" BackColor="Red" />
                </p>
                <br />
                <br />
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" CellPadding="3"
                    ForeColor="Black" GridLines="Vertical" BackColor="White" BorderColor="#999999"
                    BorderStyle="Solid" BorderWidth="1px" OnRowCommand="gvPedidos_RowCommand" DataKeyNames="SeqAmos"
                    EmptyDataText="Nenhum registro encontrado." AllowSorting="True" OnSorting="gvPedidos_Sorting"
                    TabIndex="80" OnRowCreated="gvPedidos_RowCreated" OnRowDataBound="gvPedidos_RowDataBound">
                    <Columns>
                        <asp:BoundField HeaderText="Dt. Envio" DataField="DataHoraEnvioFormatada">
                            <HeaderStyle Width="6em" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Aeronave" DataField="PrefixoAeronave">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Dt. Trilho" DataField="DataTrilhoFormatada">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Status" DataField="RetornoFormatado">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnVisualizarPedido" runat="server" Text="Visualizar" CommandName="Select"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"></asp:Button>
                            </ItemTemplate>
                            <HeaderStyle Width="35em" />
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCCCC" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle ForeColor="CadetBlue" />
                    <HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
                    <AlternatingRowStyle BackColor="#EEEEEE" />
                </asp:GridView>
                <br />
            </div>
        </asp:View>
        <!-- CADASTRO -->
        <asp:View ID="vwDetalheRegistro" runat="server">
            <asp:Panel ID="pnlPermanenciaAeronave" runat="server" GroupingText="Novo pedido" CssClass="Ficha">
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        Data:</label>
                    <asp:TextBox ID="txtData" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtData_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtData">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="rfvData" runat="server" ControlToValidate="txtData"
                        ErrorMessage="Preencha o campo Data, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                </div>
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        Observação:</label>
                    <asp:TextBox ID="txtObservacao" runat="server" CssClass="ConteudoEditavel txtXXGrande"
                        TabIndex="260" TextMode="SingleLine" MaxLength="100"></asp:TextBox>
                </div>
                <asp:Button ID="btnGravar" runat="server" Text="Gravar" TabIndex="270" CssClass="btnPequeno"
                    OnClick="btnGravar_Click" />
                <asp:Button ID="btnVoltar" runat="server" Text="Voltar" TabIndex="280" CssClass="btnPequeno"
                    OnClick="btnVoltar_Click" CausesValidation="False" />
            </asp:Panel>
        </asp:View>
        <!-- VISUALIZACAO-->
        <asp:View ID="vwParticipantes" runat="server">
            <table>
                <tr>
                    <td align="center" valign="top">
                        <asp:Panel ID="pnlPermanenciaAeronaveEdit" runat="server" GroupingText="Envio AMOS" CssClass="Ficha">
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Data envio:</label>
                                <asp:TextBox Width="80%" ID="txtDataEnvio" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Aeronave:</label>
                                <asp:TextBox Width="80%" ID="txtPrefixoAeronave" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Data Trilho:</label>
                                <asp:TextBox Width="80%" ID="txtDataTrilho" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Status:</label>
                                <asp:TextBox Width="80%" ID="txtStatus" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Retorno AMOS:</label>
                                <asp:TextBox Width="80%" ID="txtRetornoAmos" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    TabIndex="220"
                                    Height="80px" CausesValidation="false" TextMode="MultiLine" Wrap="true" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Erro interno:</label>
                                <asp:TextBox Width="80%" ID="txtErroInterno" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true" CausesValidation="false"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Xml:</label>
                                <asp:TextBox runat="server" CssClass="ConteudoEditavel txtXPequeno" ID="txtXml" Width="80%" Height="200px" CausesValidation="false" TextMode="MultiLine" Wrap="true" ReadOnly="true"></asp:TextBox>
                            </div>

                            <button onclick="copiar('<%= ViewState["XML_FILED_ID"] %>')">Copiar Xml</button>
                            <asp:Button ID="btnVoltarAmosLista" runat="server" Text="Voltar" TabIndex="410" CssClass="btnPequeno" OnClick="btnVoltarAmosLista_Click1" />

                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </asp:View>
    </asp:MultiView>
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>--%>
    <asp:ValidationSummary ID="vsPedidos" runat="server" ShowMessageBox="True" ShowSummary="False" />

    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
</asp:Content>
