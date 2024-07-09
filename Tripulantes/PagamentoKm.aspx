<%@ Page Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master"
    AutoEventWireup="true"
    CodeBehind="PagamentoKm.aspx.cs"
    Inherits="SIGLA.Web.Tripulantes.PagamentoKm" %>

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
    <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, ControleKm_Titulo %>" CssClass="Rotulo"></asp:Label>
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
                        <td colspan="7"></td>
                        <td colspan="5"><strong><%=Resources.Resources.Controle_Quilometragem %></strong></td>
                        <td colspan="6"><strong><%=Resources.Resources.Controle_HorasVooOperadas %></strong></td>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Data %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Prog %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Funcao %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Etapa %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Part %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Cheg %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_DiarioBordo %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Diu %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Not %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_ED %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_EN %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Total %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Diu %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Not %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_ED %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_EN %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Total %></td>
                        <td class="CORPO9"><%=Resources.Resources.Controle_Extra %></td>
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
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"KmDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"KmNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"KmEspDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"KmEspNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"KmTotal") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrEspDiurna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrEspNoturna") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrTotal") %></td>
                    <td class="CORPO8" nowrap align="right"><%# DataBinder.Eval(Container.DataItem,"HrExtra") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                <tr bgcolor='#AAAAAA'>
                    <td class="CORPO8" colspan="6"></td>
                    <td class="CORPO8" nowrap align="right">
                        <strong>Total</strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalKmDiurno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalKmNoturno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalKmEspDiurno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalKmEspNoturno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalKmGeral()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrDiurno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrNoturno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrEspDiurno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrEspNoturno()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrGeral()%></strong>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <strong><%# ObterTotalHrExtra()%></strong>
                    </td>
                </tr>
                </table>
                <table border="0" width="100%">
                    <tr></tr>
                    <tr></tr>
                </table>
                <br />
                <table border="1" width="50%" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr bgcolor='#AAAAAA'>
                        <td></td>
                        <td><strong><%=Resources.Resources.Controle_Diu %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_Not %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_ED %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_EN %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_Total %></strong></td>
                    </tr>
                    <tr>
                        <td align="left"><strong><%=Resources.Resources.Controle_KmVoo %></strong></td>
                        <td align="right"><%# ObterKmVooDiurna()%></td>
                        <td align="right"><%# ObterKmVooNoturna()%></td>
                        <td align="right"><%# ObterKmVooEspDiurna()%></td>
                        <td align="right"><%# ObterKmVooEspNoturna()%></td>
                        <td align="right" bgcolor='#AAAAAA'><strong><%# ObterKmVooTotal()%></strong></td>
                    </tr>
                    <tr>
                        <td align="left"><strong><%=Resources.Resources.Controle_KmReserva %></strong></td>
                        <td align="right"><%# ObterKmReservaDiurna()%></td>
                        <td align="right"><%# ObterKmReservaNoturna()%></td>
                        <td align="right"><%# ObterKmReservaEspDiurna()%></td>
                        <td align="right"><%# ObterKmReservaEspNoturna()%></td>
                        <td align="right" bgcolor='#AAAAAA'><strong><%# ObterKmReservaTotal()%></strong></td>
                    </tr>
                    <tr>
                        <td align="left"><strong><%=Resources.Resources.Controle_KmSobreAviso %></strong></td>
                        <td align="right"><%# ObterKmSobreAvisoDiurna()%></td>
                        <td align="right"><%# ObterKmSobreAvisoNoturna()%></td>
                        <td align="right"><%# ObterKmSobreAvisoEspDiurna()%></td>
                        <td align="right"><%# ObterKmSobreAvisoEspNoturna()%></td>
                        <td align="right" bgcolor='#AAAAAA'><strong><%# ObterKmSobreAvisoTotal()%></strong></td>
                    </tr>
                    <tr>
                        <td align="left"><strong><%=Resources.Resources.Controle_KmAtividades %></strong></td>
                        <td align="right"><%# ObterKmAtividadesDiurna()%></td>
                        <td align="right"><%# ObterKmAtividadesNoturna()%></td>
                        <td align="right"><%# ObterKmAtividadesEspDiurna()%></td>
                        <td align="right"><%# ObterKmAtividadesEspNoturna()%></td>
                        <td align="right" bgcolor='#AAAAAA'><strong><%# ObterKmAtividadesTotal()%></strong></td>
                    </tr>
                </table>
                <table border="0" width="100%">
                    <tr></tr>
                </table>
                <table border="1" width="50%" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr bgcolor='#AAAAAA'>
                        <td><strong><%=Resources.Resources.Controle_Atividades %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_Horas %></strong></td>
                        <td><strong><%=Resources.Resources.Controle_Voo %></strong></td>
                    </tr>
                    <tr>
                        <td align="left"><strong>Instrução em Rota</strong></td>
                        <td align="right"><%# ObterHrInstRota()%></td>
                        <td align="right"><%# ObterKmInstRota()%></td>
                    </tr>
                    <tr>
                        <td align="left"><strong>Cheque em Rota</strong></td>
                        <td align="right"><%# ObterHrCheqRota()%></td>
                        <td align="right"><%# ObterKmCheqRota()%></td>
                    </tr>
                    <tr>
                        <td align="left"><strong>Instrução em Curso</strong></td>
                        <td align="right"><%# ObterHrInstCurso()%></td>
                        <td align="right"><%# ObterKmInstCurso()%></td>
                    </tr>
                </table>
                <%--<span style="vertical-align: bottom" runat="server"><strong>Texto Avianca .......</strong></span>--%>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <br />
    <br />
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsDiarioBordo" runat="server"
        ShowMessageBox="True" ShowSummary="False" />
</asp:Content>

