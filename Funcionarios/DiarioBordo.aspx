<%@ Page Title="SIGLA - Diário de Bordo" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="DiarioBordo.aspx.cs" Inherits="SIGLA.Web.Funcionarios.DiarioBordo" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<style type="text/css">
		.txtFiltroStyle1
		{
			width: 4em;
			margin-top: 10px;
			margin-bottom: 10px;
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

		.btnConversaoLibraKg
		{
			background:url(../Images/operac.bmp) no-repeat right;
			background-color:#DDDDDD;
			padding-right: 20px;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom">
		<asp:Label ID="lblTituloPagina" Text="Diário&nbsp;de&nbsp;Bordo" runat="server"></asp:Label>
		<br /><label style="font-size: 0.8em;">[Horário&nbsp;UTC]</label>
	</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<asp:MultiView ID="mvwDiarioBordo" runat="server">
		<asp:View ID="vwConsulta" runat="server">
			<div class="FiltroPesquisa">
				<asp:Label ID="Label1" runat="server" Text="Data: "></asp:Label>
				<asp:TextBox ID="txtData" runat="server" CssClass="txtXXPequeno" MaxLength="10" 
					TabIndex="1"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtData_MaskedEditExtender" runat="server" 
					CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
					CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					Mask="99/99/9999" MaskType="Date" TargetControlID="txtData">
				</cc1:MaskedEditExtender>
				<cc1:CalendarExtender ID="txtData_CalendarExtender" runat="server" 
					Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtData">
				</cc1:CalendarExtender>
				<asp:CompareValidator ID="cvData" runat="server" 
					ControlToValidate="txtData" 
					ErrorMessage="O campo data só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)." 
					Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
				<asp:RequiredFieldValidator ID="rfvData" runat="server" 
					ControlToValidate="txtData" Display="Dynamic" 
					ErrorMessage="Preencha o campo data, por favor.">*</asp:RequiredFieldValidator>
				<asp:Label ID="Label5" runat="server" Text="Voo: " CssClass="lblFiltroStyle1"></asp:Label>
				<asp:TextBox ID="txtVoo" runat="server" CssClass="txtFiltroStyle1" 
					MaxLength="4" TabIndex="2"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtVoo_MaskedEditExtender" runat="server" 
					CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
					CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					Mask="9999" MaskType="Number" TargetControlID="txtVoo">
				</cc1:MaskedEditExtender>
				<asp:Label ID="Label3" runat="server" Text="Base: " CssClass="lblFiltroStyle1"></asp:Label>
				<asp:TextBox ID="txtBase" runat="server" CssClass="txtUpperCase txtFiltroStyle1" 
					MaxLength="3" TabIndex="3"></asp:TextBox>
				<asp:Button ID="btnPesquisar" runat="server" Text="Pesquisar" 
					onclick="btnPesquisar_Click" CssClass="btnMedio lblFiltroStyle1" TabIndex="4" />
				<asp:Button ID="btnVoltarHome" runat="server" Text="Voltar" 
					onclick="btnVoltarHome_Click" CssClass="btnPequeno" CausesValidation="False" 
					TabIndex="5" />
			</div>
			<div class="Listagem">
				<asp:GridView ID="gvDiarioBordo" runat="server" 
					AutoGenerateColumns="False" CellPadding="3" ForeColor="Black" 
					GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
					BorderWidth="1px" 
					onrowcommand="gvDiarioBordo_RowCommand" DataKeyNames="SeqVooDia,SeqTrecho" 
					EmptyDataText="Nenhum registro encontrado." AllowSorting="True" 
					onsorting="gvDiarioBordo_Sorting" TabIndex="6" onrowcreated="gvDiarioBordo_RowCreated">
					<Columns>
						<asp:BoundField DataField="NumeroVoo" HeaderText="Voo" 
							SortExpression="NumeroVoo">
							<HeaderStyle Width="6em" />
						</asp:BoundField>
						<asp:BoundField DataField="CodigoFrota" HeaderText="Frota" 
							SortExpression="CodigoFrota">
							<HeaderStyle Width="6em" />
						</asp:BoundField>
						<asp:BoundField DataField="Aeronave" HeaderText="Aeronave" 
							SortExpression="Aeronave">
							<HeaderStyle Width="7em" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeroportoOrigem" HeaderText="Origem" 
							SortExpression="CodIataAeroportoOrigem">
							<HeaderStyle Width="6em" />
						</asp:BoundField>
						<asp:BoundField DataField="CodIataAeroportoDestino" HeaderText="Destino" 
							SortExpression="CodIataAeroportoDestino">
							<HeaderStyle Width="6em" />
						</asp:BoundField>
						<asp:BoundField DataField="PartidaPrevista" HeaderText="Part. Prev."
							SortExpression="PartidaPrevista" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
						<asp:BoundField DataField="ChegadaPrevista" HeaderText="Cheg. Prev."
							SortExpression="ChegadaPrevista" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
						<asp:BoundField DataField="PartidaMotor" HeaderText="Partida Motor"
							SortExpression="PartidaMotor" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
						<asp:BoundField DataField="CorteMotor" HeaderText="Corte Motor"
							SortExpression="CorteMotor" DataFormatString="{0:dd/MM/yyyy HH:mm}">
							<HeaderStyle Width="11em" />
						</asp:BoundField>
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
			<div class="Ficha">
				<fieldset>
					<div>
						<label class="ColunaRotuloPequeno txtBold">Voo:</label>
						<asp:Label ID="lblVoo" CssClass="ColunaTextoXPequeno" runat="server"></asp:Label>
						<label class="ColunaRotuloPequeno txtBold">Aeronave:</label>
						<asp:Label ID="lblAeronave" CssClass="ColunaTextoXPequeno" runat="server"></asp:Label>
						<label class="ColunaRotuloXPequeno txtBold">Origem:</label>
						<asp:Label ID="lblOrigem" CssClass="ColunaTextoXPequeno" runat="server"></asp:Label>
						<label class="ColunaRotuloXPequeno txtBold">Destino:</label>
						<asp:Label ID="lblDestino" CssClass="ColunaTextoXPequeno" runat="server"></asp:Label>
					</div>
					<div>
						<label class="ColunaRotuloPequeno txtBold">Partida Prev.:</label>
						<asp:Label ID="lblPartidaPrev" CssClass="ColunaTextoGrande" runat="server"></asp:Label>
						<label class="ColunaRotuloPequeno txtBold">Chegada Prev.:</label>
						<asp:Label ID="lblChegadaPrev" CssClass="ColunaTextoGrande" runat="server"></asp:Label>
					</div>
					<div>
						<label class="ColunaRotuloPequeno txtBold">Partida:</label>
						<asp:Label ID="lblPartida" CssClass="ColunaTextoGrande" runat="server"></asp:Label>
						<label class="ColunaRotuloPequeno txtBold">Chegada:</label>
						<asp:Label ID="lblChegada" CssClass="ColunaTextoGrande" runat="server"></asp:Label>
					</div>
				</fieldset>
			</div>
			<asp:Panel ID="pnlDiarioDeBordo" runat="server" GroupingText="Diário de Bordo" CssClass="Ficha">
				<div>
					<label class="ColunaRotuloPequeno txtBold">Diário de Bordo:</label>
					<asp:TextBox ID="txtDiarioBordo" runat="server" 
						CssClass="ConteudoEditavel txtPequeno" TabIndex="100" MaxLength="20"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvDiarioBordo" runat="server" 
						ControlToValidate="txtDiarioBordo" 
						ErrorMessage="Preencha o campo Diário de Bordo, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
				</div>
			</asp:Panel>
			<asp:Panel ID="pnlHorarios" runat="server" GroupingText="Horários" CssClass="Ficha">
				<div>
					<label class="ColunaRotuloPequeno txtBold">Partida motor:</label>
					<asp:TextBox ID="txtDataPartidaMotor" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="200"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtDataPartidaMotor_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtDataPartidaMotor">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvDataPartidaMotor" runat="server" 
						ControlToValidate="txtDataPartidaMotor" 
						ErrorMessage="Preencha o campo Horários -&gt; Partida Motor, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
					<label class="ColunaRotuloPequeno txtBold">Pouso:</label>
					<asp:TextBox ID="txtDataPouso" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="202"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtDataPouso_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtDataPouso">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvDataPouso" runat="server" 
						ControlToValidate="txtDataPouso" 
						ErrorMessage="Preencha o campo Horários -&gt; Pouso, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold">Decolagem:</label>
					<asp:TextBox ID="txtDataDecolagem" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="201"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtDataDecolagem_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtDataDecolagem">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvDataDecolagem" runat="server" 
						ControlToValidate="txtDataDecolagem" 
						ErrorMessage="Preencha o campo Horários -&gt; Decolagem, por favor.">*</asp:RequiredFieldValidator>
					<label class="ColunaRotuloPequeno txtBold">Corte motor:</label>
					<asp:TextBox ID="txtDataCorteMotor" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
						MaxLength="16" TabIndex="203"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtDataCorteMotor_MaskedEditExtender" runat="server" 
						CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
						CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						Mask="99/99/9999 99:99" MaskType="DateTime" TargetControlID="txtDataCorteMotor">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvDataCorteMotor" runat="server" 
						ControlToValidate="txtDataCorteMotor" 
						ErrorMessage="Preencha o campo Horários -&gt; Corte Motor, por favor." 
						SetFocusOnError="True">*</asp:RequiredFieldValidator>
				</div>
			</asp:Panel>
			<asp:Panel ID="pnlCombustivel" runat="server" GroupingText="Combustível (Kg)" CssClass="Ficha">
				<div>
					<label class="ColunaRotuloPequeno txtBold">Partida Motor:</label>
					<asp:TextBox ID="txtCombPartidaMotor" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno txtAlignRight" TabIndex="300" MaxLength="5"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtCombPartidaMotor_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
						TargetControlID="txtCombPartidaMotor">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvCombPartidaMotor" runat="server" 
						ControlToValidate="txtCombPartidaMotor" 
						ErrorMessage="Preencha o campo Combustível -&gt; Partida Motor, por favor." 
						Display="Dynamic">*</asp:RequiredFieldValidator>
					<label class="ColunaRotuloMedio txtBold">Pouso:</label>
					<asp:TextBox ID="txtCombPouso" runat="server" 
						CssClass="ConteudoFixo txtXXPequeno txtAlignRight" MaxLength="5" 
						ReadOnly="True"></asp:TextBox>
					<label class="ColunaRotuloMedio txtBold">Fuel Used:</label>
					<asp:TextBox ID="txtCombTotal" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno txtAlignRight" MaxLength="5" TabIndex="302"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtCombTotal_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
						TargetControlID="txtCombTotal">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvCombTotal" runat="server" 
						ControlToValidate="txtCombTotal" 
						ErrorMessage="Preencha o campo Combustível -&gt; Fuel Used, por favor." 
						Display="Dynamic">*</asp:RequiredFieldValidator>
				</div>
				<div>
					<label class="ColunaRotuloPequeno txtBold">Decolagem:</label>
					<asp:TextBox ID="txtCombDecolagem" runat="server" 
						CssClass="ConteudoFixo txtXXPequeno txtAlignRight" MaxLength="5" 
						ReadOnly="True"></asp:TextBox>
					<label class="ColunaRotuloMedio txtBold">Corte Motor:</label>
					<asp:TextBox ID="txtCombCorteMotor" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno txtAlignRight" TabIndex="301" MaxLength="5"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtCombCorteMotor_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="99999" MaskType="Number" 
						TargetControlID="txtCombCorteMotor">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvCombCorteMotor" runat="server" 
						ControlToValidate="txtCombCorteMotor" 
						ErrorMessage="Preencha o campo Combustível -&gt; Corte Motor, por favor.">*</asp:RequiredFieldValidator>
				</div>
			</asp:Panel>
			<asp:Panel ID="pnlPeso" runat="server" GroupingText="Peso (Kg)" CssClass="Ficha">
				<div>
					<label class="ColunaRotuloGrande txtBold">Peso de Decolagem:</label>
					<asp:TextBox ID="txtPesoDecolagem" runat="server" 
						CssClass="ConteudoEditavel txtXXPequeno txtAlignRight" TabIndex="350" MaxLength="5"></asp:TextBox>
					<cc1:MaskedEditExtender ID="txtPesoDecolagem_MaskedEditExtender" runat="server" 
						AutoComplete="False" CultureAMPMPlaceholder="" 
						CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
						CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
						CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
						InputDirection="RightToLeft" Mask="999999" MaskType="Number" 
						TargetControlID="txtPesoDecolagem">
					</cc1:MaskedEditExtender>
					<asp:RequiredFieldValidator ID="rfvPesoDecolagem" runat="server" 
						ControlToValidate="txtPesoDecolagem" 
						ErrorMessage="Preencha o campo Peso -&gt; Peso de Decolagem, por favor." 
						Display="Dynamic">*</asp:RequiredFieldValidator>
				</div>
			</asp:Panel>
			<asp:Panel ID="pnlTripulantes" runat="server" GroupingText="Tripulantes" CssClass="Ficha">
					<asp:Repeater ID="repTripulantes" runat="server">
						<ItemTemplate>
							<div>
									<label class="ColunaRotuloXPequeno">&nbsp;</label>
									<label class="ColunaTextoXPequeno"><%# Eval("CodCargo")%></label>
									<label class="ColunaTextoGrande"><%# Eval("NomeGuerra")%></label>
									<label class="ColunaTextoXPequeno"><%# ((Eval("CodFuncaoBordo") != null) && (!string.IsNullOrEmpty(Eval("CodFuncaoBordo").ToString()))) ? "[" + Eval("CodFuncaoBordo") + "]" : string.Empty%></label>
							</div>
						</ItemTemplate>
					</asp:Repeater>
			</asp:Panel>
			<p class="btn">
				<asp:Button ID="btnGravar" runat="server" Text="Gravar" TabIndex="400" 
					CssClass="btnPequeno" onclick="btnGravar_Click" />
				<asp:Button ID="btnVoltar" runat="server" Text="Voltar" TabIndex="401" 
					CssClass="btnPequeno" onclick="btnVoltar_Click" CausesValidation="False" />
				<asp:Button ID="btnConversaoLibraKg" runat="server" Text="Converter para Kg" TabIndex="402" 
					CssClass="btnConversaoLibraKg" CausesValidation="False" Visible="False"
					ToolTip="Converter de Libra para Kg" onclick="btnConversaoLibraKg_Click" />
			</p>
		</asp:View>
	</asp:MultiView>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsDiarioBordo" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
