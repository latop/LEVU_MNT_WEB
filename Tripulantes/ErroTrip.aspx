<%@ Page Title="<%$Resources:Resources, Erro_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true" CodeBehind="ErroTrip.aspx.cs" Inherits="SIGLA.Web.Tripulantes.ErroTrip" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.Erro_Titulo %></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<h3><%=Resources.Resources.Erro_SubTitulo %></h3>
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
</asp:Content>
