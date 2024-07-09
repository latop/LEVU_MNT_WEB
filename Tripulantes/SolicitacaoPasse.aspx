<%@ Page Title="<%$Resources:Resources, SolicitacaoPasse_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true" CodeBehind="SolicitacaoPasse.aspx.cs" Inherits="SIGLA.Web.Tripulantes.SolicitacaoPasse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<style type="text/css">
		.WrapStyle1
		{
			white-space: normal;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.SolicitacaoPasse_Titulo %></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<asp:MultiView ID="mvwSolicitacaoPasse" runat="server">
		<asp:View ID="vwConsulta" runat="server">
			<div class="InformacoesGerais">
				<div>
					<asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Tripulante %>" CssClass="Rotulo"></asp:Label>:
					<asp:Label ID="lblTripulante" runat="server"></asp:Label>
				</div>
				<div>
					<asp:Label ID="Label3" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_ListagemDescricao %>"></asp:Label>
					<asp:Label ID="lblDataInicioConsulta" runat="server"></asp:Label>
				</div>
			</div>
			<p class="btn">
				<asp:Button ID="btnNovoPasse" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_NovoPasse %>" 
					onclick="btnNovoPasse_Click" CssClass="btnMedio" />
				<asp:Button ID="btnVoltarHome" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Voltar %>" 
					onclick="btnVoltarHome_Click" CssClass="btnPequeno" />
			</p>
			<div class="Listagem">
				<asp:GridView ID="gvPassesSolicitados" runat="server" 
					AutoGenerateColumns="False" CellPadding="3" ForeColor="Black" 
					GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
					BorderWidth="1px" onrowdatabound="gvPassesSolicitados_RowDataBound">
					<Columns>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:ImageButton ID="ibtnCancelarPasse" OnClick="ibtnCancelarPasse_Click" runat="server" ImageUrl="~/Images/cancel.png" Visible="False" />
							</ItemTemplate>
							<HeaderStyle Width="2em" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="<%$Resources:Resources, SolicitacaoPasse_Data %>">
							<ItemTemplate>
								<asp:Label id="lblDataVoo" Text='<%# Eval("dtoper", "{0:dd/MM/yyyy}") %>' runat="server"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="8em" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="<%$Resources:Resources, SolicitacaoPasse_Cancelamento %>">
							<ItemTemplate>
								<asp:Label id="lblDataCancelamentoPasse" Text='<%# Eval("dtcancelado", "{0:dd/MM/yyyy HH:mm}") %>' runat="server"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="10em" />
						</asp:TemplateField>
						<asp:BoundField DataField="nrvoo" HeaderText="<%$Resources:Resources, SolicitacaoPasse_Voo %>">
							<HeaderStyle Width="7em" />
						</asp:BoundField>
						<asp:TemplateField HeaderText="<%$Resources:Resources, SolicitacaoPasse_Origem %>">
							<ItemTemplate>
								<asp:Label id="lblAeropOrigem" Text='<%# Eval("sig_aeroportoOrigem.codiata") %>' runat="server"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="7em" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="<%$Resources:Resources, SolicitacaoPasse_Destino %>">
							<ItemTemplate>
								<asp:Label id="lblAeropDestino" Text='<%# Eval("sig_aeroportoDestino.codiata") %>' runat="server"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="7em" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="<%$Resources:Resources, SolicitacaoPasse_Observacao %>">
							<ItemTemplate>
								<asp:Label id="lblObservacao" runat="server" CssClass="WrapStyle1"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="35em" />
							<ItemStyle HorizontalAlign="Left" />
						</asp:TemplateField>
					</Columns>
					<FooterStyle BackColor="#CCCCCC" />
					<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
					<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
					<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
					<AlternatingRowStyle BackColor="#EEEEEE" />
				</asp:GridView>
			</div>
		</asp:View>
		<asp:View ID="vwInsere" runat="server">
			<asp:Panel ID="pnlPasseTripulanteExtra" runat="server" 
				GroupingText="Passe Tripulante Extra" CssClass="Ficha">
				<div>
					<asp:Label ID="Label4" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Cargo %>"
						AssociatedControlID="lblCargo" CssClass="PrimeiraColuna"></asp:Label>:
					<asp:Label ID="lblCargo" runat="server"></asp:Label>
				</div>
				<div>
					<asp:Label ID="Label6" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_NomeGuerra %>" 
						AssociatedControlID="lblNomeGuerra" CssClass="PrimeiraColuna"></asp:Label>
					<asp:Label ID="lblNomeGuerra" runat="server"></asp:Label>
				</div>
				<div>
					<asp:Label ID="Label8" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_NumeroVoo %>" 
						AssociatedControlID="txtNumeroVoo" CssClass="PrimeiraColuna"></asp:Label>:
					<asp:TextBox ID="txtNumeroVoo" runat="server" MaxLength="4" 
						CssClass="ConteudoEditavel txtXXPequeno"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvNumeroVoo" runat="server" 
						ErrorMessage="<%$Resources:Resources, SolicitacaoPasse_VooObrigatorio %>" ControlToValidate="txtNumeroVoo" 
						Display="Dynamic">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvNumeroVoo" runat="server" 
						ControlToValidate="txtNumeroVoo" Display="Dynamic" 
						ErrorMessage="<%$Resources:Resources, SolicitacaoPasse_VooNumerico %>" 
						Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
				</div>
				<div>
					<asp:Label ID="Label9" runat="server" Text="Trecho: " CssClass="PrimeiraColuna"></asp:Label>
					<asp:Label ID="Label10" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_De %>"></asp:Label>:
					<asp:DropDownList ID="ddlAeropOrigem" runat="server" 
						CssClass="ConteudoEditavel">
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="rfvAeropOrigem" runat="server" 
						ErrorMessage="" ControlToValidate="ddlAeropOrigem" 
						Display="Dynamic">*</asp:RequiredFieldValidator>
					<asp:Label ID="Label11" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Para %>"></asp:Label>
					<asp:DropDownList ID="ddlAeropDestino" runat="server" 
						CssClass="ConteudoEditavel">
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="rfvAeropDestino" runat="server" 
						ErrorMessage="<%$Resources:Resources, SolicitacaoPasse_ParaObrigatorio %>" 
						ControlToValidate="ddlAeropDestino" Display="Dynamic">*</asp:RequiredFieldValidator>
				</div>
				<div>
					<asp:Label ID="Label12" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_DataVoo %>" 
						AssociatedControlID="txtDataVoo" CssClass="PrimeiraColuna"></asp:Label>
					<asp:TextBox ID="txtDataVoo" runat="server" MaxLength="10" 
						CssClass="ConteudoEditavel txtXXPequeno"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvDataVoo" runat="server" 
						ErrorMessage="<%$Resources:Resources, SolicitacaoPasse_DataVooObrigatorio %>" ControlToValidate="txtDataVoo" 
						Display="Dynamic">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvDataVoo" runat="server" 
						ControlToValidate="txtDataVoo" Display="Dynamic" 
						ErrorMessage="<%$Resources:Resources, SolicitacaoPasse_DataVooInvalida %>" 
						Operator="GreaterThanEqual" Type="Date">*</asp:CompareValidator>
				</div>
				<div>
					<asp:Label ID="Label13" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Observacao %>" 
						AssociatedControlID="txtObservacao" CssClass="PrimeiraColuna"></asp:Label>
					<asp:TextBox ID="txtObservacao" runat="server" MaxLength="200" 
						CssClass="ConteudoEditavel txtXGrande"></asp:TextBox>
				</div>
				<div>
					<asp:Label ID="Label14" runat="server" 
						Text="<%$Resources:Resources, SolicitacaoPasse_ObsEmbarque %>" CssClass="Rotulo"></asp:Label>
				</div>
			</asp:Panel>
			<p class="btn">
					<asp:Button ID="btnEnviar" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Enviar %>" 
						onclick="btnEnviar_Click" CssClass="btnPequeno" />
					<asp:Button ID="btnLimpar" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Limpar %>" 
						CausesValidation="False" onclick="btnLimpar_Click" CssClass="btnPequeno" />
					<asp:Button ID="btnVoltarConsultaPasse" runat="server" Text="<%$Resources:Resources, SolicitacaoPasse_Voltar %>" 
						onclick="btnVoltarConsultaPasse_Click" CausesValidation="False" CssClass="btnPequeno" />
			</p>
			<asp:ValidationSummary ID="vsPasseTripulanteExtra" runat="server" ShowMessageBox="True" ShowSummary="False" />
		</asp:View>
	</asp:MultiView>
</asp:Content>
