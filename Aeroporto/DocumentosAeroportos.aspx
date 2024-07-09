<%@ Page Title="Documentos para os Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="DocumentosAeroportos.aspx.cs" Inherits="SIGLA.Web.Aeroporto.DocumentosAeroportos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">Documentos para os Aeroportos</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="Listagem">
		<asp:GridView ID="gvDocAerop" runat="server" 
			AutoGenerateColumns="False" CellPadding="3"
			GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
			BorderWidth="1px" Caption="Documentos" CaptionAlign="Top" 
			onrowcommand="gvDocAerop_RowCommand" DataKeyNames="NomeArquivo,SeqArquivoGrupo,CodigoCargo,SeqCidade,SeqFrota,SeqAeroporto,SeqUsuarioAerop,NomeAeroporto,NomeUsuarioAerop" 
			EmptyDataText="Não há documentos nesse momento." 
			onrowdatabound="gvDocAerop_RowDataBound" AllowSorting="True" 
			onrowcreated="gvDocAerop_RowCreated" onsorting="gvDocAerop_Sorting">
			<Columns>
				<asp:TemplateField HeaderText="Nome" SortExpression="NomeArquivo">
					<ItemTemplate>
						<asp:LinkButton ID="lkbNomeArquivo" CommandName="Download" runat="server" CausesValidation="false"></asp:LinkButton>
					</ItemTemplate>
					<HeaderStyle Width="24.3em" />
					<ItemStyle HorizontalAlign="Left" />
				</asp:TemplateField>
				<asp:BoundField DataField="TamanhoArquivoKB" HeaderText="Tamanho" SortExpression="TamanhoArquivoBytes">
					<HeaderStyle Width="8.2em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="TipoArquivo" HeaderText="Tipo" SortExpression="TipoArquivo">
					<HeaderStyle Width="13.8em" />
					<ItemStyle HorizontalAlign="Left" />
				</asp:BoundField>
				<asp:BoundField DataField="DataArquivo" HeaderText="Data" 
					DataFormatString="{0:dd/MM/yyyy HH:mm}" SortExpression="DataArquivo">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
				<asp:BoundField DataField="DescricaoComplementarGrupo" HeaderText="Grupo" SortExpression="DescricaoComplementarGrupo">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
				<asp:BoundField DataField="QtdAcessos" HeaderText="Qtd. Acessos" SortExpression="QtdAcessos">
					<HeaderStyle Width="8.2em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
				<asp:BoundField DataField="DocObrigatorio" HeaderText="Obrigatório" SortExpression="DocObrigatorio">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
			</Columns>
			<FooterStyle BackColor="#CCCCCC" />
			<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
			<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
			<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
			<AlternatingRowStyle BackColor="#EEEEEE" />
		</asp:GridView>
	</div>
	<p class="btn">
		<asp:Button ID="btnAtualizarLista" runat="server" 
			Text="Atualizar Lista" onclick="btnAtualizarLista_Click" 
			ToolTip="Atualiza a lista de documentos" />
		<asp:Button ID="btnVoltar" runat="server" onclick="btnVoltar_Click" 
			Text="Voltar" />
	</p>
</asp:Content>
