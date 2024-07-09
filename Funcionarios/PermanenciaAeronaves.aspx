<%@ Page Title="SIGLA - Registro de Permanência de Aeronaves" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="PermanenciaAeronaves.aspx.cs" Inherits="SIGLA.Web.Funcionarios.PermanenciaAeronaves" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<script type="text/javascript" src="../JS/core.js"></script>
	<style type="text/css">
		.txtFiltroStyle1
		{
			width: 4em;
		}

		.lblFiltroStyle1
		{
			margin-left: 20px;
		}

		div.FiltroPesquisa
		{
			width: 65em;
			margin: 10px 0 0 150px;
			text-align: left;
			white-space: nowrap;
			font-size: 0.8em;
		}

		.ajax__calendar_title
		{
			width: 140px;
			margin: auto;
		}

		.WrapStyle1
		{
			white-space: normal;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">
		<asp:Label ID="lblTituloPagina" Text="Registro de Permanência de Aeronaves" runat="server"></asp:Label>
	</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<asp:MultiView ID="mvwPermanenciaAeronaves" runat="server">
		<asp:View ID="vwConsulta" runat="server">
			<div class="FiltroPesquisa">
				<div>
					<asp:Label ID="Label2" runat="server" Text="Período: " CssClass="PrimeiraColuna"></asp:Label>
					<asp:TextBox ID="txtPeriodoDe" runat="server" CssClass="txtXXPequeno" 
						MaxLength="10" TabIndex="10"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtPeriodoDe_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999" MaskType="Date" TargetControlID="txtPeriodoDe"></cc1:MaskedEditExtender>
					<cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server" 
						Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtPeriodoDe"></cc1:CalendarExtender>
					<asp:CompareValidator ID="cvPeriodoDe" runat="server" 
						ControlToValidate="txtPeriodoDe" 
						ErrorMessage="O campo inicial do período só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)." 
						Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
					<asp:RequiredFieldValidator ID="rfvPeriodoDe" runat="server" 
						ControlToValidate="txtPeriodoDe" Display="Dynamic" 
						ErrorMessage="Preencha o campo inicial do período, por favor.">*</asp:RequiredFieldValidator>
					<asp:Label ID="Label4" runat="server" Text="Até: "></asp:Label>
					<asp:TextBox ID="txtPeriodoAte" runat="server" CssClass="txtXXPequeno" 
						MaxLength="10" TabIndex="20"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtPeriodoAte_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						TargetControlID="txtPeriodoAte" Mask="99/99/9999" MaskType="Date"></cc1:MaskedEditExtender>
					<cc1:CalendarExtender ID="txtPeriodoAte_CalendarExtender" runat="server" 
						Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtPeriodoAte"></cc1:CalendarExtender>
					<asp:CompareValidator ID="cvPeriodoAte" runat="server" 
						ControlToValidate="txtPeriodoAte" Display="Dynamic" 
						ErrorMessage="O campo final do período só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)." 
						Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
					<asp:RequiredFieldValidator ID="rfvPeriodoAte" runat="server" 
						ControlToValidate="txtPeriodoAte" Display="Dynamic" 
						ErrorMessage="Preencha o campo final do período, por favor.">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvPeriodo" runat="server" 
						ControlToCompare="txtPeriodoAte" ControlToValidate="txtPeriodoDe" 
						Display="Dynamic" 
						ErrorMessage="A data inicial do período deve ser menor ou igual à data final do período." 
						Operator="LessThanEqual" Type="Date">*</asp:CompareValidator>
					<asp:Label ID="Label1" runat="server" Text="Aeronave: " CssClass="lblFiltroStyle1"></asp:Label>
					<asp:TextBox ID="txtAeronave" runat="server" CssClass="txtUpperCase txtFiltroStyle1" 
						MaxLength="3" TabIndex="30"></asp:TextBox>
					<asp:Label ID="Label3" runat="server" Text="Base: " CssClass="lblFiltroStyle1"></asp:Label>
					<asp:TextBox ID="txtBase" runat="server" CssClass="txtUpperCase txtFiltroStyle1" 
						MaxLength="3" TabIndex="40"></asp:TextBox>
				</div>
				<div style="margin-top: 10px;">
					<asp:Label ID="Label5" runat="server" Text="Tipo: " CssClass="lblFiltroStyle1"></asp:Label>
					<asp:DropDownList ID="ddlTipoPermanencia" runat="server" TabIndex="45">
						<asp:ListItem></asp:ListItem>
						<asp:ListItem Value="P">Pátio</asp:ListItem>
						<asp:ListItem Value="M">Manobra</asp:ListItem>
					</asp:DropDownList>
					<asp:Button ID="btnPesquisar" runat="server" Text="Pesquisar" 
						onclick="btnPesquisar_Click" CssClass="btnMedio lblFiltroStyle1" TabIndex="50" />
					<asp:Button ID="btnNovoRegistro" runat="server" Text="Novo Registro" 
						onclick="btnNovoRegistro_Click" CssClass="btnMedio" TabIndex="60" 
						CausesValidation="False" />
					<asp:Button ID="btnVoltarHome" runat="server" Text="Voltar" 
						onclick="btnVoltarHome_Click" CssClass="btnPequeno" CausesValidation="False" 
						TabIndex="70" />
				</div>
			</div>
			<div class="Listagem">
				<asp:GridView ID="gvPermanenciaAeronaves" runat="server" 
					AutoGenerateColumns="False" CellPadding="3" ForeColor="Black" 
					GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
					BorderWidth="1px" 
					onrowcommand="gvPermanenciaAeronaves_RowCommand" DataKeyNames="SeqAeroporto,AeronavePrefixo,DataInicio" 
					EmptyDataText="Nenhum registro encontrado." AllowSorting="True" 
					onsorting="gvPermanenciaAeronaves_Sorting" TabIndex="80" 
					onrowcreated="gvPermanenciaAeronaves_RowCreated" 
					onrowdatabound="gvPermanenciaAeronaves_RowDataBound">
					<Columns>
						<asp:BoundField DataField="CodIataAerop" HeaderText="Base" 
							SortExpression="CodIataAerop">
							<HeaderStyle Width="6em" />
						</asp:BoundField>
						<asp:BoundField DataField="AeronavePrefixoRed" HeaderText="Aeronave" 
							SortExpression="AeronavePrefixoRed">
							<HeaderStyle Width="7em" />
						</asp:BoundField>
						<asp:BoundField DataField="DataInicio" HeaderText="Início"
							SortExpression="DataInicio" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
						<asp:BoundField DataField="DataFim" HeaderText="Fim"
							SortExpression="DataFim" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
						<asp:BoundField DataField="TipoPermanenciaExtenso" HeaderText="Tipo" 
							SortExpression="TipoPermanenciaExtenso">
							<HeaderStyle Width="7em" />
						</asp:BoundField>
						<asp:TemplateField HeaderText="Observação" SortExpression="Observacao">
							<ItemTemplate>
								<asp:Label id="lblObservacao" runat="server" CssClass="WrapStyle1"></asp:Label>
							</ItemTemplate>
							<HeaderStyle Width="35em" />
							<ItemStyle HorizontalAlign="Left" />
						</asp:TemplateField>
					</Columns>
					<FooterStyle BackColor="#CCCCCC" />
					<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
					<SelectedRowStyle ForeColor="CadetBlue" />
					<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
					<AlternatingRowStyle BackColor="#EEEEEE" />
				</asp:GridView>
			</div>
		</asp:View>
		<asp:View ID="vwDetalheRegistro" runat="server">
			<asp:Panel ID="pnlPermanenciaAeronave" runat="server" GroupingText="Permanência da Aeronave" CssClass="Ficha">
				<div>
					<label class="ColunaRotuloPequeno txtBold">Base:</label>
					<asp:DropDownList ID="ddlAeroporto" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno" TabIndex="210">
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="rfvAeroporto" runat="server" 
						ControlToValidate="ddlAeroporto" 
						ErrorMessage="Selecione um Aeroporto, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
					<label class="txtBold">Aeronave:</label>
					<asp:DropDownList ID="ddlAeronave" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno" TabIndex="220">
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="rfvAeronave" runat="server" 
						ControlToValidate="ddlAeronave" 
						ErrorMessage="Selecione uma Aeronave, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
					<label class="txtBold">Data do voo:</label>
					<asp:TextBox ID="txtDataVoo" runat="server" CssClass="ConteudoEditavel txtXXPequeno" 
						MaxLength="10" TabIndex="221"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtDataVoo_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataVoo"></cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvDataVoo" runat="server" 
						ControlToValidate="txtDataVoo" 
						ErrorMessage="Preencha o campo Data do Voo, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
					<label class="txtBold">Voo:</label>
					<asp:TextBox ID="txtVoo" runat="server" CssClass="ConteudoEditavel txtXXXPequeno txtAlignRight" 
						MaxLength="4" TabIndex="222"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtVoo_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="9999" MaskType="Number" 
						TargetControlID="txtVoo">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvVoo2" runat="server" 
						ControlToValidate="txtVoo" 
						ErrorMessage="Preencha o campo Voo, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold"></label>
					<asp:Button ID="btnCarregarDatasPermanencia" runat="server" 
						Text="Carregar Datas da Permanência" CssClass="btnPequeno" TabIndex="223" 
						CausesValidation="False" onclick="btnCarregarDatasPermanencia_Click" ToolTip="Carrega as datas de início e fim da permanência da aeronave em função dos dados acima" />
					<span id="AjaxCarregando" class="Invisivel">
						<asp:Image ID="imgCarregando" runat="server" 
							ImageUrl="~/Images/indicatortrans.gif" />
						Carregando...
					</span>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold">Início:</label>
					<asp:TextBox ID="txtInicio" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="230"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtInicio_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtInicio"></cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvInicio" runat="server" 
						ControlToValidate="txtInicio" 
						ErrorMessage="Preencha o campo Início, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
					<label class="txtBold">Fim:</label>
					<asp:TextBox ID="txtFim" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="240"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtFim_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtFim"></cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvFim" runat="server" 
						ControlToValidate="txtFim" 
						ErrorMessage="Preencha o campo Fim, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold">Observação:</label>
					<asp:TextBox ID="txtObservacao" runat="server" 
						CssClass="ConteudoEditavel txtXXGrande" TabIndex="250" MaxLength="200"></asp:TextBox>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold">Tipo:</label>
					<asp:RadioButton ID="rdoPatio" runat="server" Checked="True" 
						GroupName="TipoPermanencia" TabIndex="260" Text="Pátio" />
					<asp:RadioButton ID="rdoManobra" runat="server" GroupName="TipoPermanencia" 
						TabIndex="270" Text="Manobra" />
				</div>
			</asp:Panel>
			<p class="btn">
				<asp:Button ID="btnGravar" runat="server" Text="Gravar" TabIndex="400" 
					CssClass="btnPequeno" onclick="btnGravar_Click" />
				<asp:Button ID="btnVoltar" runat="server" Text="Voltar" TabIndex="410" 
					CssClass="btnPequeno" onclick="btnVoltar_Click" CausesValidation="False" />
				<asp:Button ID="btnExcluir" runat="server" Text="Excluir" TabIndex="420" 
					CssClass="btnPequeno" onclick="btnExcluir_Click" CausesValidation="False" 
					Visible="False" />
			</p>
		</asp:View>
	</asp:MultiView>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsPermanenciaAeronaves" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
