<%@ Page Title="<%$Resources:Resources, Escala_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true"
    CodeBehind="Escala.aspx.cs" Inherits="SIGLA.Web.Tripulantes.Escala" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, Escala_Titulo %>" CssClass="Rotulo"></asp:Label>
    </span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <div>
            <asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, Escala_Tripulante %>" CssClass="Rotulo"></asp:Label>
            <asp:Label ID="lblTripulante" runat="server"></asp:Label>
        </div>
    </div>
    <p class="btn" style="text-align: left">
        <asp:Label ID="lblMes" runat="server" Text="Mes" CssClass="Rotulo"></asp:Label>
        <asp:DropDownList runat="server" ID="ddlMeses"></asp:DropDownList>
        <asp:Label ID="lblAno" runat="server" Text="Ano" CssClass="Rotulo"></asp:Label>
        <asp:DropDownList runat="server" ID="ddlAnos"></asp:DropDownList>
        <asp:DropDownList runat="server" ID="ddlModos" OnSelectedIndexChanged="ddlModos_SelectedIndexChanged"></asp:DropDownList>
        <asp:Button ID="btnPesquisar" runat="server" Text="<%$Resources:Resources, Escala_Pesquisar %>" CssClass="btnMedio" OnClick="btnPesquisar_Click1" />
    </p>

    <div class="Listagem">
        <asp:Repeater ID="rptEscala" runat="server">
            <HeaderTemplate>
                <table width='98%' border='1' cellpadding='0' cellspacing='0' id='Table2'>
                    <tr bgcolor='#AAAAAA'>
                        <th class='CORPO8' rowspan='3' width='80px'><%=Resources.Resources.Escala_ListagemDia %></th>
                        <th class='CORPO8' rowspan='3' width='60px'><%=Resources.Resources.Escala_ListagemSemana %></th>
                        <th class='CORPO8' rowspan='3' width='150px'><%=Resources.Resources.Escala_ListagemProgramacao %></th>
                        <th class='CORPO8' rowspan='3' width='70px'><%=Resources.Resources.Escala_ListagemApresentacao %></th>
                        <th class='CORPO8' rowspan='3' width='70px'><%=Resources.Resources.Escala_ListagemResumo %></th>
                        <th class='CORPO8' rowspan='3' width='85px'><%=Resources.Resources.Escala_ListagemCorte %></th>
                        <th class='CORPO8' rowspan='3' width='35%'><%=Resources.Resources.Escala_ListagemEtapas %></th>
                        <th class='CORPO8' colspan='5' width='250px'><%# ObterListagemAgrupamento()%></th>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <th class='CORPO8' rowspan='2' width='50px'><%=Resources.Resources.Escala_ListagemDiurna %></th>
                        <th class='CORPO8' rowspan='2' width='50px'><%=Resources.Resources.Escala_ListagemNoturna %></th>
                        <th class='CORPO8' colspan='2' width='100px'><%=Resources.Resources.Escala_ListagemEspecial%></th>
                        <th class='CORPO8' rowspan='2' width='50px'><%=Resources.Resources.Escala_ListagemTotal %></th>
                    </tr>
                    <tr bgcolor='#AAAAAA'>
                        <th class='CORPO8' width='50px'><%=Resources.Resources.Escala_ListagemDiurna %></th>
                        <th class='CORPO8' width='50px'><%=Resources.Resources.Escala_ListagemNoturna %></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? 
                            DataBinder.Eval(Container.DataItem,"DataFormatada") :
                            "<a href='ProgramacaoTripulante.aspx?jornada=" + DataBinder.Eval(Container.DataItem,"SeqJornada") + "&Ano=" + DataBinder.Eval(Container.DataItem,"DataAno") + "&Mes=" + DataBinder.Eval(Container.DataItem,"DataMes") + "&Dia=" + DataBinder.Eval(Container.DataItem,"DataDia") + "'>" + DataBinder.Eval(Container.DataItem,"DataFormatada").ToString() + "</a>"
                        ) %>
                        &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;<%# DataBinder.Eval(Container.DataItem,"DiaSemana") %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? 
                            "<a href='Escala.aspx?avisado=true&flgestado=" + DataBinder.Eval(Container.DataItem,"Estado") + "&jornada=" + DataBinder.Eval(Container.DataItem,"SeqJornada") + "&Ano=" + DataBinder.Eval(Container.DataItem,"DataAno").ToString() + "&Mes=" + DataBinder.Eval(Container.DataItem,"DataMes").ToString() + "&Dia=" + DataBinder.Eval(Container.DataItem,"DataDia").ToString() + "'>" + Resources.Resources.Escala_Alterada.ToString() + "</a>" :
                            DataBinder.Eval(Container.DataItem,"Programacao")
                        ) %>
                        &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Apresentacao")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"ProgramacaoAux")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Corte")) %>&nbsp;
                    </td>
                    <td class='CORPO6' align='left'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Etapas")) %> &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"DiurnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"NoturnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"EspecialDiurnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"EspecialNoturnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"TotalFormatado")) %>&nbsp;
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr bgcolor="#EEEEEE">
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? 
                            DataBinder.Eval(Container.DataItem,"DataFormatada") :
                            "<a href='ProgramacaoTripulante.aspx?jornada=" + DataBinder.Eval(Container.DataItem,"SeqJornada") + "&Ano=" + DataBinder.Eval(Container.DataItem,"DataAno") + "&Mes=" + DataBinder.Eval(Container.DataItem,"DataMes") + "&Dia=" + DataBinder.Eval(Container.DataItem,"DataDia") + "'>" + DataBinder.Eval(Container.DataItem,"DataFormatada").ToString() + "</a>"
                        ) %>
                        &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;<%# DataBinder.Eval(Container.DataItem,"DiaSemana") %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? 
                            "<a href='Escala.aspx?avisado=true&flgestado=" + DataBinder.Eval(Container.DataItem,"Estado") + "&jornada=" + DataBinder.Eval(Container.DataItem,"SeqJornada") + "&Ano=" + DataBinder.Eval(Container.DataItem,"DataAno").ToString() + "&Mes=" + DataBinder.Eval(Container.DataItem,"DataMes").ToString() + "&Dia=" + DataBinder.Eval(Container.DataItem,"DataDia").ToString() + "'>" + Resources.Resources.Escala_Alterada.ToString() + "</a>" :
                            DataBinder.Eval(Container.DataItem,"Programacao")
                        ) %>
                        &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Apresentacao")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"ProgramacaoAux")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='center'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Corte")) %>&nbsp;
                    </td>
                    <td class='CORPO6' align='left'>&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"Etapas")) %> &nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"DiurnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"NoturnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"EspecialDiurnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"EspecialNoturnaFormatada")) %>&nbsp;
                    </td>
                    <td class='CORPO7' nowrap align='right'>&nbsp;&nbsp;
                        <%# ((DataBinder.Eval(Container.DataItem,"Estado").ToString() == "A") ? "---" : DataBinder.Eval(Container.DataItem,"TotalFormatado")) %>&nbsp;
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                <%if (ddlModos.SelectedValue.ToString().ToUpper() == "KM" || ddlModos.SelectedValue.ToString().ToUpper() == "HR")
                    {%>
                <tr style="font-weight: bold">
                    <td class='CORPO7Bold' nowrap align='right' colspan='7'><%=Resources.Resources.Escala_ListagemTotal %>&nbsp;&nbsp;</td>
                    <td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;<%# ObterTotalDiurna()%>&nbsp;</td>
                    <td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;<%# ObterTotalNoturna()%>&nbsp;</td>
                    <td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;<%# ObterTotalEspecialDiurna()%>&nbsp;</td>
                    <td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;<%# ObterTotalEspecialNoturna()%>&nbsp;</td>
                    <td class='CORPO7Bold' nowrap align='right'>&nbsp;&nbsp;<%# ObterTotalGeral()%>&nbsp;</td>
                </tr>
                <%} %>
                <tr>
                    <td align='left' colspan='12'>As informações geradas por essa consulta são uma aproximação com objetivo demonstrativo. A geração do pagamento é realizada no mês subseqüênte com as correções necessárias.</td>
                </tr>
                <tr>
                    <td align='left' colspan='12'>Observa&#231;&#245;es:&nbsp;<%# ObterObservacao()%>&nbsp;</td>
                </tr>
                </table>
    </div>
            </FooterTemplate>
        </asp:Repeater>

        <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
        </cc1:ToolkitScriptManager>
        <asp:ValidationSummary ID="vsHorasVooMensais" runat="server" ShowMessageBox="True"
            ShowSummary="False" />
</asp:Content>

