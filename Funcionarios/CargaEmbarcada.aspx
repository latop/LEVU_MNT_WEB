<%@ Page Title="Carga Embarcada" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master" AutoEventWireup="true" CodeBehind="CargaEmbarcada.aspx.cs" Inherits="SIGLA.Web.Funcionarios.CargaEmbarcada" %>

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
			padding-left: 20px;
		}

		.rdoFiltroStyle1
		{
			margin-left: 120px;
		}

		div.FiltroPesquisa
		{
			width: 65em;
			margin: 20px 0 0 220px;
			text-align: left;
			white-space: nowrap;
			font-size: 0.8em;
		}

		div.FiltroPesquisa .PrimeiraColuna
		{
			display: inline-block;
			text-align: right;
			width: 9em;
		}

		.ajax__calendar_title
		{
			width: 140px;
			margin: auto;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" Text="Carga Embarcada" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<asp:MultiView ID="mvwCargaEmbarcada" runat="server">
		<asp:View ID="vwConsulta" runat="server">
			<div class="FiltroPesquisa">
				<asp:Label ID="Label1" runat="server" Text="Período: " CssClass="PrimeiraColuna"></asp:Label>
				<asp:TextBox ID="txtPeriodoDe" runat="server" CssClass="txtXXPequeno" MaxLength="10"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPeriodoDe_MaskedEditExtender" runat="server" 
					CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
					CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					Mask="99/99/9999" MaskType="Date" TargetControlID="txtPeriodoDe">
				</cc1:MaskedEditExtender>
				<cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server" 
					Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtPeriodoDe">
				</cc1:CalendarExtender>
				<asp:CompareValidator ID="cvPeriodoDe" runat="server" 
					ControlToValidate="txtPeriodoDe" 
					ErrorMessage="O campo período só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)." 
					Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
				<asp:RequiredFieldValidator ID="rfvPeriodoDe" runat="server" 
					ControlToValidate="txtPeriodoDe" Display="Dynamic" 
					ErrorMessage="Preencha o campo período, por favor.">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvPeriodo" runat="server" 
					ControlToCompare="txtPeriodoAte" ControlToValidate="txtPeriodoDe" 
					Display="Dynamic" 
					ErrorMessage="A data inicial do período deve ser menor ou igual à data final do período." 
					Operator="LessThanEqual" Type="Date">*</asp:CompareValidator>
				<asp:Label ID="Label2" runat="server" Text="Até: "></asp:Label>
				<asp:TextBox ID="txtPeriodoAte" runat="server" CssClass="txtXXPequeno" 
					MaxLength="10"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtPeriodoAte_MaskedEditExtender" runat="server" 
					CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
					CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					TargetControlID="txtPeriodoAte" Mask="99/99/9999" MaskType="Date">
				</cc1:MaskedEditExtender>
				<cc1:CalendarExtender ID="txtPeriodoAte_CalendarExtender" runat="server" 
					Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtPeriodoAte">
				</cc1:CalendarExtender>
				<asp:CompareValidator ID="cvPeriodoAte" runat="server" 
					ControlToValidate="txtPeriodoAte" Display="Dynamic" 
					ErrorMessage="O campo até só pode ser preenchido com datas válidas no formato (dd/mm/aaaa)." 
					Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
				<asp:RequiredFieldValidator ID="rfvPeriodoAte" runat="server" 
					ControlToValidate="txtPeriodoAte" Display="Dynamic" 
					ErrorMessage="Preencha o campo até, por favor.">*</asp:RequiredFieldValidator>
				<br />
				<asp:Label ID="Label3" runat="server" Text="Origem: " CssClass="PrimeiraColuna"></asp:Label>
				<asp:TextBox ID="txtOrigem" runat="server" CssClass="txtUpperCase txtFiltroStyle1" 
					MaxLength="3"></asp:TextBox>
				<asp:Label ID="Label5" runat="server" Text="Voo: " CssClass="lblFiltroStyle1"></asp:Label>
				<asp:TextBox ID="txtVoo" runat="server" CssClass="txtFiltroStyle1" MaxLength="4"></asp:TextBox>
				<cc1:MaskedEditExtender ID="txtVoo_MaskedEditExtender" runat="server" 
					CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
					CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
					CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
					Mask="9999" MaskType="Number" TargetControlID="txtVoo">
				</cc1:MaskedEditExtender>
				<br />
				<asp:RadioButton ID="rdoAnalitico" Text="Analítico" runat="server" 
					Checked="True" GroupName="TipoRelatorio" CssClass="rdoFiltroStyle1" />
				<asp:RadioButton ID="rdoSintetico" runat="server" GroupName="TipoRelatorio" 
					Text="Sintético" />
			</div>
			<p class="btn">
				<asp:Button ID="btnPesquisar" runat="server" Text="Pesquisar" 
					onclick="btnPesquisar_Click" CssClass="btnMedio" />
				<asp:Button ID="btnVoltarHome" runat="server" Text="Voltar" 
					onclick="btnVoltarHome_Click" CssClass="btnPequeno" CausesValidation="False" />
			</p>
		</asp:View>
		<asp:View ID="vwRelatorio" runat="server">
			<div>&nbsp;</div>
			<p class="btn" style="display:inline;">
				<asp:Button ID="btnNovaPesquisa" runat="server" Text="Nova Pesquisa" 
					CssClass="btnMedio" onclick="btnNovaPesquisa_Click" CausesValidation="False" />
				<asp:Button ID="btnVoltarHome2" runat="server" Text="Voltar" 
					CssClass="btnPequeno" onclick="btnVoltarHome2_Click" CausesValidation="False" />
			</p>
			<div style="float:right; margin-right:50px; border: solid 1px #000000; text-align:left; font-size: 0.7em; width:20em; padding:0.5em;">
				Período:&nbsp;<asp:Label ID="lblPeriodoDe" runat="server"></asp:Label>&nbsp;até&nbsp;<asp:Label ID="lblPeriodoAte" runat="server"></asp:Label>
				<br />
				Origem:&nbsp;<asp:Label ID="lblOrigem" runat="server" Width="7em"></asp:Label>&nbsp;Voo:&nbsp;<asp:Label ID="lblVoo" runat="server"></asp:Label>
			</div>
			<div class="Listagem">
				<asp:Repeater ID="repRelatorioSintetico" runat="server" 
					onitemdatabound="repRelatorioSintetico_ItemDataBound">
					<ItemTemplate>
						<table style='width:80%;'>
							<tr>
								<td colspan='13' style='font-weight:bold; text-align:left;'>Data: <%# Eval("DataOperacao", "{0:dd/MM/yyyy}") %></td>
							</tr>
							<tr>
								<td rowspan='2' style='width:7.5%; padding-left:5px; padding-right:5px;'>Voo</td>
								<td rowspan='2' style='width:7.5%; padding-left:5px; padding-right:5px;'>Aeronave</td>
								<td rowspan='2' style='width:7.5%; padding-left:5px; padding-right:5px;'>Orig.</td>
								<td rowspan='2' style='width:7.5%; padding-left:5px; padding-right:5px;'>Dest.</td>
								<td rowspan='2' style='width:14%;'></td>
								<td colspan='4'>Carga</td>
								<td rowspan='2' style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>RPN</td>
								<td colspan='3'>Total</td>
							</tr>
							<tr>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Std.</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Exp.</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Comat/ULD</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>VAC</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Peso</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>ULD</td>
								<td style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Peso&nbsp;Bruto</td>
							</tr>
							<tr>
								<td colspan='13' style='border-top:solid 1px #000000;'></td>
							</tr>
							<asp:Repeater ID="repRelatorioSinteticoVoos" runat="server">
								<ItemTemplate>
									<tr>
										<td><%# Eval("NumeroVoo")%></td>
										<td><%# Eval("PrefixoAeronave")%></td>
										<td><%# Eval("CodIataAeroportoOrigem")%></td>
										<td><%# Eval("CodIataAeroportoDestino")%></td>
										<td></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaStd")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaExp")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaComat")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaVac")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("Rpn")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("TotalPeso")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("TotalUld")%></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("TotalPesoBruto")%></td>
									</tr>
								</ItemTemplate>
							</asp:Repeater>
							<tr>
								<td colspan='4'></td>
								<td colspan='9' style='border-top:solid 1px #000000;'></td>
							</tr>
							<tr style='font-weight:bold; padding-bottom:10px;'>
								<td colspan='4'></td>
								<td>Total do Dia:</td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaStd") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaExp") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaComat") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaVac") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("Rpn") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("TotalPeso") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("TotalUld") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("TotalPesoBruto") %></td>
							</tr>
						</table>
					</ItemTemplate>
				</asp:Repeater>
				<asp:Repeater ID="repRelatorioAnalitico" runat="server" 
					onitemdatabound="repRelatorioAnalitico_ItemDataBound">
					<ItemTemplate>
						<table style='width:95%; white-space:normal;'>
							<tr>
								<td colspan='15' style='font-weight:bold; text-align:left;'>Data: <%# Eval("DataOperacao", "{0:dd/MM/yyyy}") %></td>
							</tr>
							<asp:Repeater ID="repRelatorioAnaliticoEtapas" runat="server" 
								onitemdatabound="repRelatorioAnaliticoEtapas_ItemDataBound">
								<ItemTemplate>
									<tr>
										<td rowspan='2' style='width:4%; padding-left:5px; padding-right:5px;'>Voo</td>
										<td rowspan='2' style='width:6%; padding-left:5px; padding-right:5px;'>Aeronave</td>
										<td rowspan='2' style='width:4%; padding-left:5px; padding-right:5px;'>Orig.</td>
										<td rowspan='2' style='width:4%; padding-left:5px; padding-right:5px;'>Dest.</td>
										<td rowspan='2' style='width:11%; padding-left:5px; padding-right:5px;'>Código</td>
										<td rowspan='2' style='width:7%; padding-left:5px; padding-right:5px;'>ULD</td>
										<td colspan='4'>Carga</td>
										<td rowspan='2' style='width:4%; text-align:right; padding-left:5px; padding-right:5px;'>RPN</td>
										<td rowspan='2' style='width:5%; padding-left:5px; padding-right:5px;'>Peso Bruto</td>
										<td rowspan='2' style='width:7%; text-align:right; padding-left:5px; padding-right:5px;'>Cubagem</td>
										<td rowspan='2' style='width:11%; padding-left:5px; padding-right:5px;'>SPL</td>
										<td rowspan='2' style='width:20%; text-align:left; padding-left:15px; padding-right:5px;'>Observação</td>
									</tr>
									<tr>
										<td style='width:4%; text-align:right; padding-left:5px; padding-right:5px;'>Std.</td>
										<td style='width:4%; text-align:right; padding-left:5px; padding-right:5px;'>Exp.</td>
										<td style='width:5%; text-align:right; padding-left:5px; padding-right:5px;'>Comat/ULD</td>
										<td style='width:4%; text-align:right; padding-left:5px; padding-right:5px;'>VAC</td>
									</tr>
									<tr>
										<td colspan='15' style='border-top:solid 1px #000000;'></td>
									</tr>
									<asp:Repeater ID="repRelatorioAnaliticoDetalheEtapa" runat="server" 
										onitemdatabound="repRelatorioAnaliticoDetalheEtapa_ItemDataBound">
										<ItemTemplate>
											<tr>
												<td style='vertical-align:top;'><%# Eval("NumeroVoo")%></td>
												<td style='vertical-align:top;'><%# Eval("PrefixoAeronave")%></td>
												<td style='vertical-align:top;'><%# Eval("CodIataAeroportoOrigem")%></td>
												<td style='vertical-align:top;'><%# Eval("CodIataAeroportoDestino")%></td>
												<td style='vertical-align:top;'><%# Eval("CodigoUld")%></td>
												<td style='vertical-align:top;'><asp:CheckBox ID="chkFlgUld" runat="server" Checked="false" /></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("CargaStd")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("CargaExp")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("CargaComat")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("CargaVac")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("Rpn")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><%# Eval("PesoBruto")%></td>
												<td style='vertical-align:top; text-align:right; padding-right:10px;'><asp:Label ID="lblCubagem" runat="server"></asp:Label></td>
												<td style='vertical-align:top; text-align:left; padding-left:5px;'><%# Eval("Spl")%></td>
												<td style='vertical-align:top; text-align:left; padding-left:5px;'><asp:Label ID="lblObservacao" runat="server"></asp:Label></td>
											</tr>
										</ItemTemplate>
									</asp:Repeater>
									<tr>
										<td colspan='5'></td>
										<td colspan='10' style='border-top:solid 1px #000000;'></td>
									</tr>
									<tr>
										<td colspan='5'></td>
										<td style="text-align:right; padding-right:10px; padding-left:5px; white-space:nowrap;">Total da Etapa:</td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaStd") %></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaExp") %></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaComat") %></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("CargaVac") %></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("Rpn") %></td>
										<td style='text-align:right; padding-right:10px;'><%# Eval("PesoBruto") %></td>
										<td colspan='3'></td>
									</tr>
								</ItemTemplate>
							</asp:Repeater>
							<tr>
								<td colspan='5'></td>
								<td colspan='10' style='border-top:solid 1px #000000;'></td>
							</tr>
							<tr style='font-weight:bold;'>
								<td colspan='5'></td>
								<td style="text-align:right; padding-right:10px; padding-left:5px; white-space:nowrap;">Total do Dia:</td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaStd") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaExp") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaComat") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("CargaVac") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("Rpn") %></td>
								<td style='text-align:right; padding-right:10px;'><%# Eval("PesoBruto") %></td>
								<td colspan='3'></td>
							</tr>
						</table>
					</ItemTemplate>
				</asp:Repeater>
			</div>
		</asp:View>
	</asp:MultiView>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsCargaEmbarcada" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
