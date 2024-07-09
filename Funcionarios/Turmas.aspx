<%@ Page Title="SIGLA - Cadastro de Eventos" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="Turmas.aspx.cs" Inherits="SIGLA.Web.Funcionarios.Turmas" %>

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
        <asp:Label ID="lblTituloPagina" Text="Cadastro de turmas" runat="server"></asp:Label>
    </span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:MultiView ID="mvwTurmas" runat="server">
        <asp:View ID="vwConsulta" runat="server">
            <div class="FiltroPesquisa">
                <div>
                    <asp:Label ID="Label2" runat="server" Text="Período: " CssClass="PrimeiraColuna"></asp:Label>
                    <asp:TextBox ID="txtPeriodoDe" runat="server" CssClass="txtXXPequeno" MaxLength="10"
                        TabIndex="10"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtPeriodoDe_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtPeriodoDe">
                    </cc1:MaskedEditExtender>
                    <cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server" Enabled="True"
                        Format="dd/MM/yyyy" TargetControlID="txtPeriodoDe">
                    </cc1:CalendarExtender>
                    <asp:CompareValidator ID="cvPeriodoDe" runat="server" ControlToValidate="txtPeriodoDe"
                        ErrorMessage="O campo inicial do período só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)."
                        Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="rfvPeriodoDe" runat="server" ControlToValidate="txtPeriodoDe"
                        Display="Dynamic" ErrorMessage="Preencha o campo inicial do período, por favor.">*</asp:RequiredFieldValidator>
                    <asp:Label ID="Label4" runat="server" Text="Até: "></asp:Label>
                    <asp:TextBox ID="txtPeriodoAte" runat="server" CssClass="txtXXPequeno" MaxLength="10"
                        TabIndex="20"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtPeriodoAte_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" TargetControlID="txtPeriodoAte" Mask="99/99/9999" MaskType="Date">
                    </cc1:MaskedEditExtender>
                    <cc1:CalendarExtender ID="txtPeriodoAte_CalendarExtender" runat="server" Enabled="True"
                        Format="dd/MM/yyyy" TargetControlID="txtPeriodoAte">
                    </cc1:CalendarExtender>
                    <asp:CompareValidator ID="cvPeriodoAte" runat="server" ControlToValidate="txtPeriodoAte"
                        Display="Dynamic" ErrorMessage="O campo final do período só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)."
                        Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="rfvPeriodoAte" runat="server" ControlToValidate="txtPeriodoAte"
                        Display="Dynamic" ErrorMessage="Preencha o campo final do período, por favor.">*</asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPeriodo" runat="server" ControlToCompare="txtPeriodoAte"
                        ControlToValidate="txtPeriodoDe" Display="Dynamic" ErrorMessage="A data inicial do período deve ser menor ou igual à data final do período."
                        Operator="LessThanEqual" Type="Date">*</asp:CompareValidator>
                    <asp:Label ID="Label1" runat="server" Text="Nome guerra: " CssClass="lblFiltroStyle1"></asp:Label>
                    <asp:TextBox ID="txtNomeGuerra" runat="server" CssClass="txtUpperCase txtFiltroStyle1"
                        Width="150px" MaxLength="20" TabIndex="30"></asp:TextBox>
                    <asp:Label ID="Label3" runat="server" Text="Aeroporto: " CssClass="lblFiltroStyle1"></asp:Label>
                    <asp:DropDownList ID="ddlAeroportoFiltro" runat="server" TabIndex="45">
                    </asp:DropDownList>
                    <asp:Label ID="Label6" runat="server" Text="Cargo: " CssClass="lblFiltroStyle1"></asp:Label>
                    <asp:DropDownList ID="ddlCargo" runat="server" TabIndex="45">
                    </asp:DropDownList>
                    <asp:Label ID="Label7" runat="server" Text="Base: " CssClass="lblFiltroStyle1"></asp:Label>
                    <asp:DropDownList ID="ddlBase" runat="server" TabIndex="45">
                    </asp:DropDownList>
                </div>
                <div style="margin-top: 10px;">
                    <asp:Label ID="Label5" runat="server" Text="Atividade: " CssClass="lblFiltroStyle1"></asp:Label>
                    <asp:DropDownList ID="ddlAtividadeFiltro" runat="server" TabIndex="45">
                    </asp:DropDownList>
                    <asp:Button ID="btnPesquisar" runat="server" Text="Pesquisar" OnClick="btnPesquisar_Click"
                        CssClass="btnMedio lblFiltroStyle1" TabIndex="50" />
                    <asp:Button ID="btnNovoRegistro" runat="server" Text="Novo Registro" OnClick="btnNovoRegistro_Click"
                        CssClass="btnMedio" TabIndex="60" CausesValidation="False" />
                    <asp:Button ID="btnVoltarHome" runat="server" Text="Voltar" OnClick="btnVoltarHome_Click"
                        CssClass="btnPequeno" CausesValidation="False" TabIndex="70" />
                </div>
            </div>
            <div class="Listagem">
                <asp:GridView ID="gvTurmas" runat="server" AutoGenerateColumns="False" CellPadding="3"
                    ForeColor="Black" GridLines="Vertical" BackColor="White" BorderColor="#999999"
                    BorderStyle="Solid" BorderWidth="1px" OnRowCommand="gvTurmas_RowCommand" DataKeyNames="SeqTurma"
                    EmptyDataText="Nenhum registro encontrado." AllowSorting="True" OnSorting="gvTurmas_Sorting"
                    TabIndex="80" OnRowCreated="gvTurmas_RowCreated" OnRowDataBound="gvTurmas_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="InicioDataFormatada" HeaderText="Dia Início" SortExpression="InicioDataFormatada">
                            <HeaderStyle Width="6em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="InicioHoraFormatada" HeaderText="Hora Início" SortExpression="InicioHoraFormatada">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FimDataFormatada" HeaderText="Dia Fim" SortExpression="FimDataFormatada">
                            <HeaderStyle Width="11em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FimHoraFormatada" HeaderText="Hora Fim" SortExpression="FimHoraFormatada">
                            <HeaderStyle Width="11em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Aeroporto" HeaderText="Aeroporto" SortExpression="Aeroporto">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Atividade" HeaderText="Atividade" SortExpression="Atividade">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="QuantidadesParticipantes" HeaderText="Qtd Participantes"
                            SortExpression="QuantidadesParticipantes">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Observacao" HeaderText="Observação" SortExpression="Observacao">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnVisualizarTurma" runat="server" Text="Visualizar" CommandName="Select"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"></asp:Button>
                                <asp:Button ID="btnExcluitTurma" runat="server" Text="Excluir" CommandName="Excluir"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" OnClientClick="javascript:if (!confirm('Confirma a exclusão dessa turma?')) return false;">
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
            </div>
        </asp:View>
        <!-- CADASTRO DE TURMAS -->
        <asp:View ID="vwDetalheRegistro" runat="server">
            <asp:Panel ID="pnlPermanenciaAeronave" runat="server" GroupingText="Nova turma" CssClass="Ficha">
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        Atividade:</label>
                    <asp:DropDownList ID="ddlAtividade" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                        Width="200px" TabIndex="200" OnSelectedIndexChanged="ddlAtividade_SelectedIndexChanged"
                        AutoPostBack="true">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvAtividade" runat="server" ControlToValidate="ddlAtividade"
                        ErrorMessage="Selecione uma Atividade, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    <label class="txtBold">
                        Aeroporto:</label>
                    <asp:DropDownList ID="ddlAeroporto" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                        TabIndex="210">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvAeroporto" runat="server" ControlToValidate="ddlAeroporto"
                        ErrorMessage="Selecione um Aeroporto, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                </div>
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        Dia Início:</label>
                    <asp:TextBox ID="txtInicio" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="16" TabIndex="220"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtInicio_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtInicio">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="rfvInicio" runat="server" ControlToValidate="txtInicio"
                        ErrorMessage="Preencha o campo Início, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    <asp:TextBox ID="txtInicioHora" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="5" Width="35px" TabIndex="240"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99:99" MaskType="Time" TargetControlID="txtInicioHora">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtInicioHora"
                        ErrorMessage="Preencha o campo Hora Início, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                </div>
                <div>
                    <label class="ColunaRotuloPequeno txtBold">
                        Fim:</label>
                    <asp:TextBox ID="txtFim" runat="server" CssClass="ConteudoEditavel txtXPequeno" MaxLength="16"
                        TabIndex="230"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="txtFim_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFim">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="rfvFim" runat="server" ControlToValidate="txtFim"
                        ErrorMessage="Preencha o campo Fim, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    <asp:TextBox ID="txtFimHora" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                        MaxLength="5" Width="35px" TabIndex="250"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" CultureAMPMPlaceholder=""
                        CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                        CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                        Enabled="True" Mask="99:99" MaskType="Time" TargetControlID="txtFimHora">
                    </cc1:MaskedEditExtender>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtFimHora"
                        ErrorMessage="Preencha o campo Hora Fim, por favor." SetFocusOnError="True">*</asp:RequiredFieldValidator>
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
        <!-- CADASTRO DE PARTICIPANTES E ALTERACAO DE TURMAS-->
        <asp:View ID="vwParticipantes" runat="server">
            <table>
                <tr>
                    <td align="center" valign="top">
                        <asp:Panel ID="pnlPermanenciaAeronaveEdit" runat="server" GroupingText="Turma" CssClass="Ficha">
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Atividade:</label>
                                <asp:DropDownList ID="ddlAtividadeEdit" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                                    Width="200px" TabIndex="200" OnSelectedIndexChanged="ddlAtividadeEdit_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvAtividadeEdit" runat="server" ControlToValidate="ddlAtividadeEdit"
                                    ErrorMessage="Selecione uma Atividade, por favor." SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                                <label class="txtBold">
                                    Aeroporto:</label>
                                <asp:DropDownList ID="ddlAeroportoEdit" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                                    TabIndex="210">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvAeroportoEdit" runat="server" ControlToValidate="ddlAeroportoEdit"
                                    ErrorMessage="Selecione um Aeroporto, por favor." SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Dia Início:</label>
                                <asp:TextBox ID="txtInicioEdit" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="220"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="txtInicioEdit_MaskedEditExtender" runat="server" CultureAMPMPlaceholder=""
                                    CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                                    CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                                    Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtInicioEdit">
                                </cc1:MaskedEditExtender>
                                <asp:RequiredFieldValidator ID="rfvInicioEdit" runat="server" ControlToValidate="txtInicioEdit"
                                    ErrorMessage="Preencha o campo Início, por favor." SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtInicioHoraEdit" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="5" Width="35px" TabIndex="240"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" CultureAMPMPlaceholder=""
                                    CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                                    CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                                    Enabled="True" Mask="99:99" MaskType="Time" TargetControlID="txtInicioHoraEdit">
                                </cc1:MaskedEditExtender>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtInicioHoraEdit"
                                    ErrorMessage="Preencha o campo Hora Início, por favor." SetFocusOnError="True"
                                    ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Fim:</label>
                                <asp:TextBox ID="txtFimEdit" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="16" TabIndex="230"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="txtFim_MaskedEditExtenderEdit" runat="server" CultureAMPMPlaceholder=""
                                    CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                                    CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                                    Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFimEdit">
                                </cc1:MaskedEditExtender>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtFimEdit"
                                    ErrorMessage="Preencha o campo Fim, por favor." SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtFimHoraEdit" runat="server" CssClass="ConteudoEditavel txtXPequeno"
                                    MaxLength="5" Width="35px" TabIndex="250"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" CultureAMPMPlaceholder=""
                                    CultureCurrencySymbolPlaceholder="" CultureDateFormat="" CultureDatePlaceholder=""
                                    CultureDecimalPlaceholder="" CultureThousandsPlaceholder="" CultureTimePlaceholder=""
                                    Enabled="True" Mask="99:99" MaskType="Time" TargetControlID="txtFimHoraEdit">
                                </cc1:MaskedEditExtender>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtFimHoraEdit"
                                    ErrorMessage="Preencha o campo Hora Fim, por favor." SetFocusOnError="True" ValidationGroup="Edicao">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Observação:</label>
                                <asp:TextBox ID="txtObservacaoEdit" runat="server" CssClass="ConteudoEditavel txtXXGrande"
                                    TabIndex="260" Width="350px" TextMode="SingleLine" MaxLength="100"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnEditar" runat="server" Text="Alterar" TabIndex="270" CssClass="btnPequeno"
                                OnClick="btnEditar_Click" ValidationGroup="Edicao" />
                        </asp:Panel>
                    </td>
                    <td align="center" valign="top">
                        <asp:Panel ID="Panel2" runat="server" GroupingText="Novo Participante" CssClass="Ficha">
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Tripulantes:</label>
                                <asp:DropDownList ID="ddlTripulante" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                                    Width="200px" TabIndex="220">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddlTripulante"
                                    ErrorMessage="Selecione um Tripulante, por favor." SetFocusOnError="True" ValidationGroup="InclusaoParticipante">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Função:</label>
                                <asp:DropDownList ID="ddlFuncao" runat="server" CssClass="ConteudoEditavel txtXXPequeno"
                                    TabIndex="210">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddlFuncao"
                                    ErrorMessage="Selecione uma Função, por favor." SetFocusOnError="True" ValidationGroup="InclusaoParticipante">*</asp:RequiredFieldValidator>
                            </div>
                            <div>
                                <label class="ColunaRotuloPequeno txtBold">
                                    Observação:</label>
                                <asp:TextBox ID="txtObervacaoParticipante" runat="server" CssClass="ConteudoEditavel txtXXGrande"
                                    TabIndex="250" MaxLength="100" TextMode="SingleLine" ValidationGroup="InclusaoParticipante"></asp:TextBox>
                            </div>
                            <asp:Button ID="Button1" runat="server" Text="Incluir" TabIndex="400" CssClass="btnPequeno"
                                OnClick="btnGravarParticipante_Click" ValidationGroup="InclusaoParticipante" />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <div class="Listagem">
                <asp:GridView ID="gvParticipantes" runat="server" AutoGenerateColumns="False" CellPadding="3"
                    ForeColor="Black" GridLines="Vertical" BackColor="White" BorderColor="#999999"
                    BorderStyle="Solid" BorderWidth="1px" DataKeyNames="seqturma, seqtripulante, codfuncaobordo"
                    EmptyDataText="Nenhum registro encontrado." AllowSorting="True" TabIndex="80"
                    OnRowDataBound="gvParticipantes_RowDataBound" Width="80%" OnRowCommand="gvTripulante_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Nome" HeaderText="Nome" SortExpression="Nome">
                            <HeaderStyle Width="6em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Funcao" HeaderText="Funcao" SortExpression="Funcao">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Observacao" HeaderText="Observação" SortExpression="Observacao">
                            <HeaderStyle Width="7em" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnExcluitTripulante" runat="server" Text="Excluir" CommandName="Excluir"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" OnClientClick="javascript:if (!confirm('Confirma a exclusão desse tripulante?')) return false;">
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
            </div>
            <asp:Button ID="Button5" runat="server" Text="Voltar" TabIndex="410" CssClass="btnPequeno"
                OnClick="btnVoltarListaTurmas_Click" CausesValidation="False" ValidationGroup="ExclusaoParticipante" />
        </asp:View>
    </asp:MultiView>
    <%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsTurmas" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
