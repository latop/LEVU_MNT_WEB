<%@ Page Title="<%$Resources:Resources, DocumentosTripulantes_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true" CodeBehind="DocumentosTripulantes.aspx.cs" Inherits="SIGLA.Web.Tripulantes.DocumentosTripulantes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.DocumentosTripulantes_Titulo %></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<p class="btn">
        <asp:DropDownList runat="server" ID="ddlFiltros"></asp:DropDownList>
		<asp:Button ID="btnAtualizarLista" runat="server" 
			Text="<%$Resources:Resources, DocumentosTripulantes_AtualizarLista %>" onclick="btnAtualizarLista_Click" />
	</p>
    <div class="Listagem">
		<asp:GridView ID="gvDocTrip" runat="server" 
			AutoGenerateColumns="False" CellPadding="3"
			GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
			BorderWidth="1px" Caption="<%$Resources:Resources, DocumentosTripulantes_Documentos %>" CaptionAlign="Top" 
			onrowcommand="gvDocTrip_RowCommand" DataKeyNames="NomeArquivo,SeqArquivoGrupo,CodigoCargo,SeqCidade,SeqFrota,CodFuncaoTrip" 
			EmptyDataText="<%$Resources:Resources, DocumentosTripulantes_ListaVazia %>" 
			onrowdatabound="gvDocTrip_RowDataBound" AllowSorting="True" 
			onrowcreated="gvDocTrip_RowCreated" onsorting="gvDocTrip_Sorting">
			<Columns>
				<asp:TemplateField HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaNome %>" SortExpression="NomeArquivo">
					<ItemTemplate>
						<asp:LinkButton ID="lkbNomeArquivo" CommandName="Download" runat="server" CausesValidation="false"></asp:LinkButton>
					</ItemTemplate>
					<HeaderStyle Width="24.3em" />
					<ItemStyle HorizontalAlign="Left" />
				</asp:TemplateField>
				<asp:BoundField DataField="TamanhoArquivoKB" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaTamanho %>" SortExpression="TamanhoArquivoBytes">
					<HeaderStyle Width="8.2em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="TipoArquivo" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaTipo %>" SortExpression="TipoArquivo">
					<HeaderStyle Width="13.8em" />
					<ItemStyle HorizontalAlign="Left" />
				</asp:BoundField>
				<asp:BoundField DataField="DataArquivo" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaData %>" 
					DataFormatString="{0:dd/MM/yyyy HH:mm}" SortExpression="DataArquivo">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
                <asp:BoundField DataField="NomeGrupo" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaNomeGrupo %>" SortExpression="NomeGrupo">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
                <asp:BoundField DataField="DescricaoComplementarGrupo" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaAgrupamento %>" SortExpression="DescricaoComplementarGrupo">
					<HeaderStyle Width="12.1em" />
					<ItemStyle HorizontalAlign="Center" />
				</asp:BoundField>
               <asp:BoundField DataField="QtdAcessos" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaAcessos %>" SortExpression="QtdAcessos">
					<HeaderStyle Width="8.2em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="DocObrigatorio" HeaderText="<%$Resources:Resources, DocumentosTripulantes_ListaObrigatorio %>" SortExpression="DocObrigatorio">
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
		<asp:Button ID="btnVoltar" runat="server" onclick="btnVoltar_Click" 
			Text="<%$Resources:Resources, DocumentosTripulantes_Voltar %>" />
	</p>
</asp:Content>
