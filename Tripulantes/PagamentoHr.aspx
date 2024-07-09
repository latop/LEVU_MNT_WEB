<%@ Page Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master"
    AutoEventWireup="true"
    CodeBehind="PagamentoHr.aspx.cs"
    Inherits="SIGLA.Web.Tripulantes.PagamentoHr" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <style type="text/css">
        .txtFiltroStyle1 {
            width: 4em;
            margin-top: 10px;
            margin-bottom: 10px;
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

        .btnConversaoLibraKg {
            background: url(../Images/operac.bmp) no-repeat right;
            background-color: #DDDDDD;
            padding-right: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, ControleHr_Titulo %>" CssClass="Rotulo"></asp:Label>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <div>
            <asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, Controle_Tripulante %>" CssClass="Rotulo"></asp:Label>
            :
			<asp:Label ID="lblTripulante" runat="server"></asp:Label>
        </div>
    </div>
    <div class="InformacoesGerais">
        <asp:Label ID="Label2" runat="server" Text="<%$Resources:Resources, Controle_Inicio %>"></asp:Label>
        <asp:TextBox ID="txtDataInicio" runat="server" CssClass="txtXXPequeno" MaxLength="10"
            TabIndex="1"></asp:TextBox>
        <cc1:MaskedEditExtender ID="txtDataInicio_MaskedEditExtender" runat="server"
            CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder=""
            CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True"
            Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataInicio">
        </cc1:MaskedEditExtender>
        <asp:CompareValidator ID="cvData" runat="server"
            ControlToValidate="txtDataInicio"
            ErrorMessage="<%$Resources:Resources, Controle_Inicio_DataInvalida %>"
            Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
        <asp:RequiredFieldValidator ID="rfvData" runat="server"
            ControlToValidate="txtDataInicio" Display="Dynamic"
            ErrorMessage="<%$Resources:Resources, Controle_Inicio_DataInvalida %>">*</asp:RequiredFieldValidator>

        <asp:Label ID="Label3" runat="server" Text="<%$Resources:Resources, Controle_Fim %>"></asp:Label>
        <asp:TextBox ID="txtDataFim" runat="server" CssClass="txtXXPequeno" MaxLength="10"
            TabIndex="2"></asp:TextBox>
        <cc1:MaskedEditExtender ID="txtDataFim_MaskedEditExtender" runat="server"
            CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder=""
            CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True"
            Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataFim">
        </cc1:MaskedEditExtender>
        <asp:CompareValidator ID="CompareValidator1" runat="server"
            ControlToValidate="txtDataFim"
            ErrorMessage="<%$Resources:Resources, Controle_Fim_DataInvalida %>"
            Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
            ControlToValidate="txtDataFim" Display="Dynamic"
            ErrorMessage="">*</asp:RequiredFieldValidator>

        <asp:Button ID="btnPesquisar" runat="server" Text="<%$Resources:Resources, Controle_Pesquisar %>"
            OnClick="btnPesquisar_Click" CssClass="btnMedio lblFiltroStyle1" TabIndex="3" />
    </div>
    <div class="Listagem">
        <asp:Repeater ID="rptPagamentos" runat="server">
            <HeaderTemplate>
                <table align="left" border="1" width="97%" cellpadding="0" cellspacing="0" id="Table1">
                    <tr bgcolor='#AAAAAA'>
                        <td colspan="8"></td>
                        <td colspan="4"><strong><%=Resources.Resources.Controle_HorasVoo %></strong></td>
                        <td colspan="4"><strong><%=Resources.Resources.Controle_HorasAtividades %></strong></td>
                        <td></td>
                    </tr>
                    <tr bgcolor='#AAAAAA'>

                        <td class="CORPO9"><%=Resources.Resources.Controle_Data %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Prog %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Funcao %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Etapa %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Part %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Cheg %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_DiarioBordo %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_TipoAtividade %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Diu %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Not %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_ED %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_EN %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Diu %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Not %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_ED %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_EN %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Total %></td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Data") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Programacao") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Funcao") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Etapa") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Partida") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Chegada") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DiarioBordo") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"TipoAtividade") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraAtividadeDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraAtividadeNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraAtividadeEspDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HoraAtividadeEspNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrTotal") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                <tr bgcolor='#AAAAAA'>
                    <td class="CORPO8" colspan="7"></td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%=Resources.Resources.Controle_Total %></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraVooDiurna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraVooNoturna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraVooEspDiurna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraVooEspNoturna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraAtividadeDiurna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraAtividadeNoturna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraAtividadeEspDiurna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHoraAtividadeEspNoturna()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrTotal()%></strong>
                    </td>
                </tr>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <div class="Listagem">
        <asp:Repeater ID="rptSumarioAtividade" runat="server">
            <HeaderTemplate>
                <br />
                <br />
                <table border="1" width="50%" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr bgcolor='#AAAAAA'>
                        <td align="center" colspan="5"><%=Resources.Resources.Controle_AtividadesComPagamento %>Atividades com Pagamento</td>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <td align="center"><%=Resources.Resources.Controle_TipoAtividade %></td>
                        <td align="center"><%=Resources.Resources.Controle_Diu %></td>
                        <td align="center"><%=Resources.Resources.Controle_Not %></td>
                        <td align="center"><%=Resources.Resources.Controle_ED %></td>
                        <td align="center"><%=Resources.Resources.Controle_EN %></td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td align="center"><%# DataBinder.Eval(Container.DataItem,"TipoAtividade") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooNoturna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspNoturna") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <div class="Listagem">
        <br />
        <br />
        <asp:Repeater ID="rptSolo" runat="server">
            <HeaderTemplate>
                <br />
                <br />
                <table border="1" width="50%" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr bgcolor='#AAAAAA'>
                        <td align="center" colspan="4"><%=Resources.Resources.Controle_TempoSolo %></td>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <td align="center"><%=Resources.Resources.Controle_Diu %></td>
                        <td align="center"><%=Resources.Resources.Controle_Not %></td>
                        <td align="center"><%=Resources.Resources.Controle_ED %></td>
                        <td align="center"><%=Resources.Resources.Controle_EN %></td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraTmpSoloDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraTmpSoloNoturna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraTmpSoloEspDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraTmpSoloEspNoturna") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>

    </div>
    <div class="Listagem">
        <asp:Repeater ID="rptSumarioAtividadeInstrucaoCheque" runat="server">
            <HeaderTemplate>
                <br />
                <br />
                <table border="1" width="50%" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr bgcolor='#AAAAAA'>
                        <td align="center" colspan="6"><%=Resources.Resources.Controle_AtividadesInstrucaoCheque %></td>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"TipoAtividade") %></td>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"Funcao") %></td>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"HoraVooDiurna") %></td>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"HoraVooNoturna") %></td>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspDiurna") %></td>
                        <td align="center"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspNoturna") %></td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td align="center"><%# DataBinder.Eval(Container.DataItem,"TipoAtividade") %></td>
                    <td align="center"><%# DataBinder.Eval(Container.DataItem,"Funcao") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooNoturna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspDiurna") %></td>
                    <td align="right"><%# DataBinder.Eval(Container.DataItem,"HoraVooEspNoturna") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <p></p>
        <table align="center" width="90%">
        </table>
    </div>

    <%--<span style="vertical-align: bottom" runat="server"><strong>Texto Avianca .......</strong></span>--%>

    <br />
    <br />
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsDiarioBordo" runat="server"
        ShowMessageBox="True" ShowSummary="False" />
</asp:Content>


