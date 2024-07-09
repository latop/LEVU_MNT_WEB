<%@ Page Title="<%$Resources:Resources, ProgramacaoTripulante_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true"
    CodeBehind="ProgramacaoTripulante.aspx.cs" Inherits="SIGLA.Web.Tripulantes.ProgramacaoTripulante" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, ProgramacaoTripulante_Titulo %>" CssClass="Rotulo"></asp:Label>
    </span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <div>
            <asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, ProgramacaoTripulante_Tripulante %>" CssClass="Rotulo"></asp:Label>
            <asp:Label ID="lblTripulante" runat="server"></asp:Label>
        </div>
    </div>

    <div class="Listagem">
        <asp:Repeater ID="rptProgramacao" runat="server">
            <HeaderTemplate>
                <table width='98%' border='1' cellpadding='0' cellspacing='0' id='Table2'>
                    <tr bgcolor='#AAAAAA'>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemTipoProgramacao %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemEmpresa %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemOrigem %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemDestino %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemAeronave %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemPartida %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemFuncao %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemAtividade %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemLocalidade %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemInicio %></th>
                        <th class="CORPO9"><%=Resources.Resources.ProgramacaoTripulante_ListagemFim %></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="CORPO8">&nbsp;<a href='EscalaTripulante.aspx?seqvoodiaesc=<%# DataBinder.Eval(Container.DataItem,"seqvoodiaesc") %>&seqtrecho=<%# DataBinder.Eval(Container.DataItem,"seqtrecho") %>&voo=<%# DataBinder.Eval(Container.DataItem,"voo") %>&origem=<%# DataBinder.Eval(Container.DataItem,"origem") %>&destino=<%# DataBinder.Eval(Container.DataItem,"destino") %>'><%# DataBinder.Eval(Container.DataItem,"Voo") %></a>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Empresa") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Origem") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Destino") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Aeronave") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"PartidaEst") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Funcao") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Atividade") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Localidade") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Inicio") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Fim") %>&nbsp;</td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr bgcolor="#EEEEEE">
                    <td class="CORPO8">&nbsp;<a href='EscalaTripulante.aspx?seqvoodiaesc=<%# DataBinder.Eval(Container.DataItem,"seqvoodiaesc") %>&seqtrecho=<%# DataBinder.Eval(Container.DataItem,"seqtrecho") %>&voo=<%# DataBinder.Eval(Container.DataItem,"voo") %>&origem=<%# DataBinder.Eval(Container.DataItem,"origem") %>&destino=<%# DataBinder.Eval(Container.DataItem,"destino") %>'><%# DataBinder.Eval(Container.DataItem,"Voo") %></a>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Empresa") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Origem") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Destino") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Aeronave") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"PartidaEst") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Funcao") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Atividade") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Localidade") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Inicio") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Fim") %>&nbsp;</td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <input type="button" value="<%=Resources.Resources.ProgramacaoTripulante_Voltar %>" onclick="javascript:history.go(-1)" style="margin-left: 15px;" />
    </div>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
</asp:Content>

