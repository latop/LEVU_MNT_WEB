<%@ Page Title="SIGLA - Amos" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="Notam.aspx.cs" Inherits="SIGLA.Web.Funcionarios.Notam" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <script type="text/javascript" src="../JS/core.js"></script>
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
        <asp:Label ID="lblTituloPagina" Text="Notam" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwPedidos" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="Listagem">
                <p class="btn">
                    <label class="ColunaRotuloPequeno txtBold">
                        Aeroporto (código ICAO):</label>
                    <asp:TextBox runat="server" ID="txtCodigoIcao"></asp:TextBox>
                    &nbsp;
                    <asp:Button ID="btnAtualizarLista" runat="server"
                        Text="Atualizar Lista"
                        ToolTip="Atualiza a lista de Notam" OnClick="btnAtualizarLista_Click" />
                </p>
                <br />
                <br />
                <asp:GridView ID="gvPedidos" runat="server" AutoGenerateColumns="False" CellPadding="3"
                    ForeColor="Black" GridLines="Vertical" BackColor="White" BorderColor="#999999"
                    BorderStyle="Solid" BorderWidth="1px" OnRowCommand="gvPedidos_RowCommand" DataKeyNames="SeqNotam"
                    EmptyDataText="Nenhum registro encontrado." AllowSorting="True" OnSorting="gvPedidos_Sorting"
                    TabIndex="80" OnRowCreated="gvPedidos_RowCreated" OnRowDataBound="gvPedidos_RowDataBound">
                    <Columns>
                        <asp:BoundField HeaderText="Aeroporto" DataField="CodigoIcao">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Data" DataField="DataAtualizacaoFormatada">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Resumo">
                            <ItemTemplate>
                                <div style="word-wrap: break-word; width: 450px;">
                                    <asp:Label ID="lblTermName" runat="server" Text='<%# Eval("ResumoFormatado") %>' ToolTip='<%# Eval("Resumo") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnDisponibilizar" runat="server" Text="Disponibilizar" CommandName="Disponibilizar"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Visible='<%# Eval("Indisponivel") %>'></asp:Button>
                                <asp:Button ID="Button1" runat="server" Text="Ocultar" CommandName="Ocultar"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Visible='<%# Eval("Disponivel") %>'></asp:Button>
                            </ItemTemplate>
                            <HeaderStyle Width="150px" />
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
                                <asp:TextBox ID="txtDataEnvio" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Número voo:</label>
                                <asp:TextBox ID="txtNumeroVoo" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Data Operação:</label>
                                <asp:TextBox ID="txtDataOperacao" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Status:</label>
                                <asp:TextBox ID="txtStatus" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Retorno AMOS:</label>
                                <asp:TextBox ID="txtRetornoAmos" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Erro interno:</label>
                                <asp:TextBox ID="txtErroInterno" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Xml:</label>
                                <asp:Xml TextMode="MultiLine" ID="txtXml"
                                    TabIndex="220" ReadOnly="true" Width="80%" Height="200px"></asp:Xml>
                                <textarea width="80%" height="200px"><%= ViewState["XML_AMOS"] %></textarea>
                            </div>
                            <asp:Button ID="btnVoltarAmosLista" runat="server" Text="Voltar" TabIndex="410" CssClass="btnPequeno" OnClick="btnVoltarAmosLista_Click1" />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </asp:View>

    </asp:MultiView>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <%--<cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
        &nbsp;&nbsp;&nbsp;
    </cc1:ToolkitScriptManager>--%>
    <asp:ValidationSummary ID="vsPedidos" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
