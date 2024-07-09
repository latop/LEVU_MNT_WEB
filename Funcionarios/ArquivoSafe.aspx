<%@ Page Title="" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="ArquivoSafe.aspx.cs" Inherits="SIGLA.Web.Funcionarios.ArquivoSafe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <asp:GridView ID="GridViewTeste" runat="server" HeaderStyle-BackColor="#3AC0F2" HeaderStyle-ForeColor="White"
        Font-Names="Arial" Font-Size="10" RowStyle-BackColor="#A1DCF2" AlternatingRowStyle-BackColor="White"
        AlternatingRowStyle-ForeColor="#000" AutoGenerateColumns="false"
        AllowPaging="true" OnPageIndexChanging="OnPageIndexChanging">
        <Columns>
            <asp:BoundField DataField="codpais" HeaderText="Código País" ItemStyle-Width="150px"/>
            <asp:BoundField DataField="nomepais" HeaderText="Nome" ItemStyle-Width="100px"/>
            <asp:BoundField DataField="codpaisicao" HeaderText="ICAO" ItemStyle-Width="100px"/>
        </Columns>
    </asp:GridView>
    <br/>
    <asp:Button ID="btnExcel" runat="server" Text="Export To Excel" OnClick="ExportToExcel" Width="120"/>
    <asp:Button ID="btnWord" runat="server" Text="Export To Word" OnClick="ExportToWord" Width="120"/>
    <br/><br/>
    <asp:Button ID="btnCSV" runat="server" Text="Export To CSV" OnClick="ExportToCSV" Width="120"/>
    <asp:Button ID="btnPDF" runat="server" Text="Export To PDF" OnClick="ExportToPDF" Width="120"/>
</asp:Content>
