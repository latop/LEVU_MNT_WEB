<%@ Page Title="" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="ImportaViagens.aspx.cs" Inherits="SIGLA.Web.Funcionarios.ImportaViagens" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <p>Importação das Viagens - Control Tower</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:Label ID="Label1" runat="server" Text="Escolha o arquivo a ser importado:"></asp:Label>
    <br />
    <asp:FileUpload ID="FileUpload1" runat="server" />
    <asp:Button ID="btnImport" runat="server" Text="Importar Viagens" OnClick="ImportExcel" />
    <br />
    <br />
    <hr />
    <asp:GridView ID="GridViagens" runat="server"
        CellPadding="3" HeaderStyle-BackColor="Gray" Font-Size="Small"
        GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
    >
    </asp:GridView>
</asp:Content>
