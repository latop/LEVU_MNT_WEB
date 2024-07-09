<%@ Page Title="<%$Resources:Resources, PedidoFolga_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master"
    AutoEventWireup="true" CodeBehind="PedidoFolga.aspx.cs" Inherits="SIGLA.Web.Tripulantes.PedidoFolga" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <script type="text/javascript" src="../JS/core.js"></script>
    <style type="text/css">
        .txtFiltroStyle1
        {
            width: 4em;
        }
        
        .lblFiltroStyle1
        {
            margin-left: 20px;
        }
        
        div.FiltroPesquisa
        {
            width: 65em;
            margin: 10px 0 0 150px;
            text-align: left;
            white-space: nowrap;
            font-size: 0.8em;
        }
        
        .ajax__calendar_title
        {
            width: 140px;
            margin: auto;
        }
        
        .WrapStyle1
        {
            white-space: normal;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblTituloPagina" Text="<%$Resources:Resources, PedidoFolga_Titulo %>" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwPedidos" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="Listagem">
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" CellPadding="3"
                    ForeColor="Black" GridLines="Vertical" BackColor="White" BorderColor="#999999"
                    BorderStyle="Solid" BorderWidth="1px" OnRowCommand="gvPedidos_RowCommand" DataKeyNames="SeqPedido"
                    EmptyDataText="<%$Resources:Resources, PedidoFolga_ListaVazia %>" AllowSorting="True" OnSorting="gvPedidos_Sorting"
                    TabIndex="80" OnRowCreated="gvPedidos_RowCreated" OnRowDataBound="gvPedidos_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="DataFormatada" HeaderText="<%$Resources:Resources, PedidoFolga_ListaData %>" SortExpression="DataFormatada">
                            <HeaderStyle Width="6em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Observacao" HeaderText="<%$Resources:Resources, PedidoFolga_ListaObservacao %>" SortExpression="Observacao">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnVisualizarPedido" runat="server" Text="Visualizar" CommandName="Select"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"></asp:Button>
                                <asp:Button ID="btnExcluirPedido" runat="server" Text="Excluir" CommandName="Excluir"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>">
                                </asp:Button>
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
                <div style="float: left">
                    <asp:Button ID="btnNovoRegistro" runat="server" Text="<%$Resources:Resources, PedidoFolga_NovoRegistro %>" OnClick="btnNovoRegistro_Click"
                        TabIndex="60" CausesValidation="False" />
                </div>
            </div>
        </asp:View>
        <asp:View ID="vwDetalheRegistro" runat="server">
            <asp:Panel ID="pnlPermanenciaAeronave" runat="server" GroupingText="<%$Resources:Resources, PedidoFolga_NovoPedido %>" CssClass="Ficha">
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        <%=Resources.Resources.PedidoFolga_Data %>:</label>
                    <asp:TextBox ID="txtData" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtData_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtData">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="rfvData" runat="server" ControlToValidate="txtData"
                        ErrorMessage="<%$Resources:Resources, PedidoFolga_DataObrigatoria %>" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                </div>
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        <%=Resources.Resources.PedidoFolga_Observacao %>:</label>
                    <asp:TextBox ID="txtObservacao" runat="server" CssClass="ConteudoEditavel txtXXGrande"
                        TabIndex="260" TextMode="SingleLine" MaxLength="100"></asp:TextBox>
                </div>
                <asp:Button ID="btnGravar" runat="server" Text="<%$Resources:Resources, PedidoFolga_Gravar %>" TabIndex="270" CssClass="btnPequeno"
                    OnClick="btnGravar_Click" />
                <asp:Button ID="btnVoltar" runat="server" Text="<%$Resources:Resources, PedidoFolga_Voltar %>" TabIndex="280" CssClass="btnPequeno"
                    OnClick="btnVoltar_Click" CausesValidation="False" />
            </asp:Panel>
        </asp:View>
        <asp:View ID="vwParticipantes" runat="server">
            <table>
                <tr>
                    <td align="center" valign="top">
                        <asp:Panel ID="pnlPermanenciaAeronaveEdit" runat="server" GroupingText="Pedido de folga" CssClass="Ficha">
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    <%=Resources.Resources.PedidoFolga_Data %>:</label>
                                <asp:TextBox ID="txtDataEdit" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="txtDataEdit_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                                    CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                                    CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                                    Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataEdit">
                                </cc1:MaskedEditExtender>
                                <asp:RequiredFieldValidator ID="rfvInicioEdit" runat="server" ControlToValidate="txtDataEdit"
                                    ErrorMessage="<%$Resources:Resources, PedidoFolga_DataObrigatoria %>" SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    <%=Resources.Resources.PedidoFolga_Observacao %>:</label>
                                <asp:TextBox ID="txtObservacaoEdit" runat="server" CssClass="ConteudoEditavel txtXXGrande"
                                    TabIndex="260" Width="350px" TextMode="SingleLine" MaxLength="100"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnEditar" runat="server" Text="<%$Resources:Resources, PedidoFolga_Alterar %>" TabIndex="270" CssClass="btnPequeno"
                                OnClick="btnEditar_Click" ValidationGroup="Edicao" />
                            <asp:Button ID="Button5" runat="server" Text="<%$Resources:Resources, PedidoFolga_Voltar %>" TabIndex="410" CssClass="btnPequeno"
                                OnClick="btnVoltarListaPedidos_Click" CausesValidation="False" ValidationGroup="ExclusaoParticipante" />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </asp:View>
    </asp:MultiView>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsPedidos" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
