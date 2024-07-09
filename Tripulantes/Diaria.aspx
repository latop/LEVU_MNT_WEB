<%@ Page Title="<%$Resources:Resources, Diaria_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true"
    CodeBehind="Diaria.aspx.cs" Inherits="SIGLA.Web.Tripulantes.Diaria" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">
        <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, Diaria_Titulo %>" CssClass="Rotulo"></asp:Label>
    </span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <div>
            <asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, Diaria_Tripulante %>" CssClass="Rotulo"></asp:Label>
            <asp:Label ID="lblTripulante" runat="server"></asp:Label>
        </div>
    </div>
    <p class="btn" style="text-align: left">
        <asp:Label ID="lblMes" runat="server" Text="Mes" CssClass="Rotulo"></asp:Label>
        <asp:DropDownList runat="server" ID="ddlMeses"></asp:DropDownList>
        <asp:Label ID="lblAno" runat="server" Text="Ano" CssClass="Rotulo"></asp:Label>
        <asp:DropDownList runat="server" ID="ddlAnos"></asp:DropDownList>
        <asp:Button ID="btnPesquisar" runat="server" Text="<%$Resources:Resources, Diaria_Pesquisar %>" CssClass="btnMedio" OnClick="btnPesquisar_Click1" />
    </p>
    <div class="Listagem">
        <asp:Repeater ID="rptEscala" runat="server">
            <HeaderTemplate>
                <table align="left" border="1" width="97%" cellpadding="0" cellspacing="0" id="Table1">
                    <tr bgcolor='#AAAAAA'>

                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemData %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemProgramacao %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemApresentacao %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemFimRealiz %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemOrigem %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemDestino %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemAeronave %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemTipoDiaria %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemDiaria %></th>
                        <th class="CORPO9"><%=Resources.Resources.Diaria_ListagemObservacao %></th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"DataFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="left">
                        <left><%# DataBinder.Eval(Container.DataItem,"Programacao") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"ApresentacaoFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"FimRealizacaoFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"OrigemFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"DestinoFormatado") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"AeronaveFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="left">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"TipoDiariaFormatado") %>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <right><%# DataBinder.Eval(Container.DataItem,"ValorDiariaFormatado") %>
                    </td>
                    <td class="CORPO8" width="300" align="LEFT">
                        <center><%# DataBinder.Eval(Container.DataItem,"ObservacaoFormatada") %></center>
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr bgcolor="#EEEEEE">
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"DataFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="left">
                        <left><%# DataBinder.Eval(Container.DataItem,"Programacao") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"ApresentacaoFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"FimRealizacaoFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"OrigemFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"DestinoFormatado") %>
                    </td>
                    <td class="CORPO8" nowrap align="center">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"AeronaveFormatada") %>
                    </td>
                    <td class="CORPO8" nowrap align="left">
                        <center>
                            <%# DataBinder.Eval(Container.DataItem,"TipoDiariaFormatado") %>
                    </td>
                    <td class="CORPO8" nowrap align="right">
                        <right><%# DataBinder.Eval(Container.DataItem,"ValorDiariaFormatado") %>
                    </td>
                    <td class="CORPO8" width="300" align="LEFT">
                        <center><%# DataBinder.Eval(Container.DataItem,"ObservacaoFormatada") %></center>
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                <tr height="17" style='height: 12.75pt' bgcolor='#AAAAAA'>
                    <td height="17" colspan="7" style='height: 12.75pt; mso-ignore: colspan'></td>
                    <td class="CORPO9"><b><%=Resources.Resources.Diaria_ListagemTotal %></b></td>
                    <td class="CORPO8" align="right">
                        <right><%# ObterTotalGeral()%>
                    </td>
                    <td class="CORPO8">&nbsp;</td>
                </tr>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsHorasVooMensais" runat="server" ShowMessageBox="True"
        ShowSummary="False" />
</asp:Content>
