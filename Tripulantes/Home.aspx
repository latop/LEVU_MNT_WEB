<%@ Page Title="<%$Resources:Resources, Home_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master"
    AutoEventWireup="true"
    CodeBehind="Home.aspx.cs"
    Inherits="SIGLA.Web.Tripulantes.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.Home_Titulo %></span>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <br />
    <br />
    <div>
        <asp:Repeater ID="rptHome" runat="server">
            <HeaderTemplate>
                <table width='98%' border='1' cellpadding='0' cellspacing='0' id='TableTitulo'>
                    <tr bgcolor='#AAAAAA'>
                        <td class='corpo' align='middle'>
                            <font size='5' color='BLACK'><%=Resources.Resources.Home_SubTitulo %><br>
                            </font>
                        </td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td align="left">
                            <font size='4' color='RED'><%# DataBinder.Eval(Container.DataItem,"Titulo") %><br></font>
                            <font size='2'><%# DataBinder.Eval(Container.DataItem,"Mensagem") %></font>
                        </td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
                <asp:Label ID="defaultItem" runat="server"
                    Visible='<%# rptHome.Items.Count == 0 %>' Text="<%$Resources:Resources, Home_ListaVazia %>" />
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
