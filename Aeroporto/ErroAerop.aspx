<%@ Page Title="Erro Aeroporto" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="ErroAerop.aspx.cs" Inherits="SIGLA.Web.Aeroporto.ErroAerop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">Erro</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<h3>Ocorreu um erro no sistema!</h3>
	<div style="padding: 0 80px 0 80px;">
		<p style="font-size: 0.8em">
			<asp:Label ID="lblMensagemErro" runat="server"></asp:Label>
		</p>
	</div>
	<div style="padding: 0 80px 0 80px; text-align: center;">
		<p style="font-size: 0.6em">
			<asp:Label ID="lblStackTrace" runat="server"></asp:Label>
		</p>
	</div>
    <div style="padding: 0 80px 0 80px; text-align: center;">
		<p style="font-size: 0.6em">
			<asp:Label ID="lblErroComplemento" runat="server"></asp:Label>
		</p>
	</div>
</asp:Content>
