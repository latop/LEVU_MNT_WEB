<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="ImportarDadosVoo.aspx.cs" Inherits="SIGLA.Web.Aeroporto.ImportarDadosVoo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="InformacoesGerais">
		<asp:Label ID="Label1" runat="server" Text="Escolha o arquivo com os dados a serem importados para o voo selecionado:"></asp:Label>
		<br />
		<asp:FileUpload ID="fileUploadDocumentos" runat="server" CssClass="txtXXGrande" />
		<asp:RequiredFieldValidator ID="rfvFileUploadDoc" runat="server" 
			ControlToValidate="fileUploadDocumentos" 
			ErrorMessage="Escolha o arquivo com os dados a serem importados para o voo selecionado!">*</asp:RequiredFieldValidator>
		<br />
		<br />
		<asp:Button ID="btnEnviarArquivo" runat="server" Text="Enviar o Arquivo" 
			onclick="btnEnviarArquivo_Click" />
		<input type="reset" id="rstLimpar" name="rstLimpar" value="Limpar" tabindex="2" onclick="javascript:ApagaToolTip();" />
	</div>
	<hr style="text-align:left; width:50em; margin:20px 0 0 40px;" />
	<asp:Panel ID="pnlDadosVoo" runat="server" Visible="False">
		<div class="Listagem">
			<asp:GridView ID="gvDadosVoo" runat="server" 
				AutoGenerateColumns="False" CellPadding="3"
				GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
				BorderWidth="1px" Caption="Dados a serem importados para o voo selecionado" CaptionAlign="Top" 
				EmptyDataText="O arquivo enviado não possui dados a serem importados para o voo selecionado." 
				onrowdatabound="gvDadosVoo_RowDataBound">
				<Columns>
					<asp:BoundField DataField="Ordem">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="DataFretamento" HeaderText="Data">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="NroVoo" HeaderText="Voo">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="AeroportoOrigem" HeaderText="Orig.">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="AeroportoDestino" HeaderText="Dest.">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="Transito" HeaderText="Trân.">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="Embarque" HeaderText="Embarq.">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="Gratis" HeaderText="Grátis">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="TotalPago" HeaderText="Ttl. Pago">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="AdtTotal" HeaderText="ADT">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="ChdTotal" HeaderText="CHD">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="InfTotal" HeaderText="INF">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="NroVooCnxIn" HeaderText="Cnx. In">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="NroVooCnxOut" HeaderText="Cnx. Out">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="AeroportoOrigemSub" HeaderText="Orig. Sub">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="AeroportoDestinoSub" HeaderText="Dest. Sub">
						<ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="NroReservadosTrechoVenda" HeaderText="Res. Venda">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="Bagagem" HeaderText="Bag.">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="ExcessoBagagem" HeaderText="Exce. Bag.">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="AdtComb" HeaderText="ADT">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="ChdComb" HeaderText="CHD">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
					<asp:BoundField DataField="InfComb" HeaderText="INF">
						<ItemStyle HorizontalAlign="Right" />
					</asp:BoundField>
				</Columns>
				<FooterStyle BackColor="#CCCCCC" />
				<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
				<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
				<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
				<AlternatingRowStyle BackColor="#EEEEEE" />
			</asp:GridView>
			<asp:Panel ID="pnlResumoDados" runat="server">
				<hr style="text-align:left; width:70em; margin:20px 0 0 0;" />
				<h3>Resumo dos dados a serem importados</h3>
				<asp:GridView ID="gvCombinadas" runat="server" CellPadding="3"
					GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
					BorderWidth="1px" Caption="Etapas Combinadas" CaptionAlign="Top" 
					onrowdatabound="gvCombinadas_RowDataBound" AutoGenerateColumns="False" 
					onrowcreated="gvCombinadas_RowCreated">
					<Columns>
						<asp:BoundField DataField="DataOperacao" HeaderText="Data" 
							DataFormatString="{0:dd/MM/yyyy}">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="NumeroVoo" HeaderText="Voo">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeropOrig" HeaderText="Orig.">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeropDest" HeaderText="Dest.">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxAdt" HeaderText="ADT">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxChd" HeaderText="CHD">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxInf" HeaderText="INF">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxAdtTrc" HeaderText="ADT">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxChdTrc" HeaderText="CHD">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxInfTrc" HeaderText="INF">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagLivre" HeaderText="Livre">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagExcesso" HeaderText="Excesso">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="Bagagem" HeaderText="Total">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagLivreTrc" HeaderText="Livre">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagExcessoTrc" HeaderText="Excesso">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagagemTrc" HeaderText="Total">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
					</Columns>
					<FooterStyle BackColor="#CCCCCC" />
					<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
					<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
					<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
					<AlternatingRowStyle BackColor="#EEEEEE" />
				</asp:GridView>
				<asp:GridView ID="gvCnxOut" runat="server" CellPadding="3"
					GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
					BorderWidth="1px" Caption="Cnx. Out" CaptionAlign="Top" 
					onrowdatabound="gvCnxOut_RowDataBound" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="DataOperacao" HeaderText="Data" 
							DataFormatString="{0:dd/MM/yyyy}">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="NumeroVooCombinada" HeaderText="Voo Comb.">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeropOrigCombinada" HeaderText="Orig. Comb.">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeropDestCombinada" HeaderText="Dest. Comb.">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="NumeroVooCnxOut" HeaderText="Voo Cnx. Out">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeropDestCnxOut" HeaderText="Dest. Cnx. Out">
							<ItemStyle HorizontalAlign="Center" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxAdt" HeaderText="ADT">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxChd" HeaderText="CHD">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="PaxInf" HeaderText="INF">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagLivre" HeaderText="Bag. Livre">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="BagExcesso" HeaderText="Bag. Exce.">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
						<asp:BoundField DataField="Bagagem" HeaderText="Bag. Tot.">
							<ItemStyle HorizontalAlign="Right" />
						</asp:BoundField>
					</Columns>
					<FooterStyle BackColor="#CCCCCC" />
					<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
					<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
					<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
					<AlternatingRowStyle BackColor="#EEEEEE" />
				</asp:GridView>
			</asp:Panel>
		</div>
	</asp:Panel>
	<p class="btn">
		<asp:Button ID="btnCancelarImportacao" runat="server" 
			Text="Cancelar Importação" Visible="False" CausesValidation="False" 
			onclick="btnCancelarImportacao_Click" 
			ToolTip="Cancelar Importação dos Dados Acima" />
		<asp:Button ID="btnConfirmarImportacao" runat="server" 
			Text="Confirmar Importação" Visible="False" CausesValidation="False" 
			onclick="btnConfirmarImportacao_Click" 
			ToolTip="Confirmar Importação dos Dados Acima" />
		<asp:Button ID="btnVoltar" runat="server" Text="Voltar" 
			CausesValidation="False" onclick="btnVoltar_Click" />
	</p>
	<asp:ValidationSummary ID="vsImportarDadosVoo" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
