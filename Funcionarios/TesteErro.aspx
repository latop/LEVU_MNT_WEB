<%@ Page Title="Teste de Tratamento de Erro" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="TesteErro.aspx.cs" Inherits="SIGLA.Web.Funcionarios.TesteErro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">Teste de Tratamento de Erro</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<p>
		<asp:Button ID="btnGerarErro" runat="server" onclick="btnGerarErro_Click" Text="Gerar Erro" />
	</p>
</asp:Content>
