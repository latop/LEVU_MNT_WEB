<%@ Page Title="<%$Resources:Resources, EscalaTripulantes_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true"
    CodeBehind="EscalaTripulante.aspx.cs" Inherits="SIGLA.Web.Tripulantes.EscalaTripulante" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, EscalaTripulantes_Titulo %>" CssClass="Rotulo"></asp:Label>
    </span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <div>
            <asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, EscalaTripulantes_Voo %>" CssClass="Rotulo"></asp:Label>
            <asp:Label ID="lblVoo" runat="server"></asp:Label>
        </div>
    </div>

    <div class="Listagem">
        <asp:Repeater ID="rptProgramacao" runat="server">
            <HeaderTemplate>
                <table width='98%' border='1' cellpadding='0' cellspacing='0' id='Table2'>
                    <tr bgcolor='#AAAAAA'>
                        <th class="CORPO9"><%=Resources.Resources.EscalaTripulantes_ListagemCargo %></th>
                        <th class="CORPO9"><%=Resources.Resources.EscalaTripulantes_ListagemTripulante %></th>
                        <th class="CORPO9"><%=Resources.Resources.EscalaTripulantes_ListagemJornada %></th>
                        <th class="CORPO9"><%=Resources.Resources.EscalaTripulantes_ListagemHorario %></th>
                        <th class="CORPO9"><%=Resources.Resources.EscalaTripulantes_ListagemFuncao %></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"CodCargo") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Tripulante") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Jornada") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Horario") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Funcao") %>&nbsp;</td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr bgcolor="#EEEEEE">
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"CodCargo") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Tripulante") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Jornada") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Horario") %>&nbsp;</td>
                    <td class="CORPO8">&nbsp;<%# DataBinder.Eval(Container.DataItem,"Funcao") %>&nbsp;</td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <input type="button" value="<%=Resources.Resources.EscalaTripulantes_Voltar %>" onclick="javascript:history.go(-1)" style="margin-left: 15px;" />
    </div>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
</asp:Content>

