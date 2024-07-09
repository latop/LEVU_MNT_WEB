<%@ Page Title="Liberação para Apresentação de Tripulantes" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="LiberaApresentTrip.aspx.cs" Inherits="SIGLA.Web.Funcionarios.LiberaApresentTrip" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">Liberação para Apresentação de Tripulantes</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="InformacoesGerais">
		<div style="padding:10px 0 10px 0;">
			<asp:Label ID="lblSituacao" runat="server"></asp:Label>
		</div>
		<div style="white-space:normal; padding:10px 0 10px 0;">
			<asp:Label ID="lblMensagemPaginaBloqueada" runat="server" Visible="False">Selecione um aeroporto e clique no botão &quot;Liberar Página&quot; para desbloquear o acesso à página de apresentação de tripulantes, nesse computador, para o aeroporto selecionado.</asp:Label>
			<asp:Label ID="lblMensagemPaginaLiberada" runat="server" Visible="False">Clique no botão &quot;Bloquear Página&quot; para bloquear o acesso à página de apresentação de tripulantes ou <br />selecione um aeroporto e clique no botão &quot;Liberar Página&quot; para alterar o aeroporto para o qual o acesso à página de apresentação de tripulantes será liberado, nesse computador.</asp:Label>
		</div>
		<div style="padding:10px 0 10px 0;">
			<asp:HyperLink ID="lnkApresentacaoTrip" runat="server" 
				NavigateUrl="~/ASP/relatorioescalaapresentacaoc.asp" Target="_blank" 
				Visible="False" 
				ToolTip="Abre a página de apresentação de tripulantes em uma nova janela">Apresentação de Tripulantes</asp:HyperLink>
		</div>
		<div style="padding:10px 0 10px 150px;">
			Aeroporto: <asp:DropDownList ID="ddlAeroporto" runat="server"></asp:DropDownList>
		</div>
	</div>
	<p class="btn">
		<asp:Button ID="btnLiberarPagina" runat="server" Text="Liberar Página" 
			onclick="btnLiberarPagina_Click" CssClass="btnMedio" />
		<asp:Button ID="btnBloquearPagina" runat="server" Text="Bloquear Página" 
			onclick="btnBloquearPagina_Click" CssClass="btnMedio" />
		<asp:Button ID="btnVoltarHome" runat="server" Text="Voltar" 
			onclick="btnVoltarHome_Click" CssClass="btnPequeno" />
	</p>
</asp:Content>
