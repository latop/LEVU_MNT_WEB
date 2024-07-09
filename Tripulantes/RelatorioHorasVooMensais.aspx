<%@ Page Title="<%$Resources:Resources, RelatorioHorasVooMensais_Titulo %>" Language="C#" MasterPageFile="~/Tripulantes/Tripulantes.Master" AutoEventWireup="true" CodeBehind="RelatorioHorasVooMensais.aspx.cs" Inherits="SIGLA.Web.Tripulantes.RelatorioHorasVooMensais" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.RelatorioHorasVooMensais_Titulo %></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="InformacoesGerais">
		<div>
			<asp:Label ID="Label1" runat="server" Text="<%$Resources:Resources, RelatorioHorasVooMensais_Tripulante %>" CssClass="Rotulo"></asp:Label>
			<asp:Label ID="lblTripulante" runat="server"></asp:Label>
		</div>
	</div>
	<p class="btn">
		<asp:Label ID="Label2" runat="server" Text="<%$Resources:Resources, RelatorioHorasVooMensais_Ano %>" CssClass="Rotulo"></asp:Label>
		<asp:TextBox ID="txtAno" runat="server" MaxLength="4" CssClass="txtXXXPequeno"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvAno" runat="server" 
			ErrorMessage="<%$Resources:Resources, RelatorioHorasVooMensais_AnoObrigatorio %>" ControlToValidate="txtAno" 
			Display="None">*</asp:RequiredFieldValidator>
		<cc1:MaskedEditExtender ID="txtAno_MaskedEditExtender" runat="server" 
			AutoComplete="False" CultureAMPMPlaceholder="" 
			CultureCurrencySymbolPlaceholder="" CultureDateFormat="" 
			CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
			CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" Mask="9999" MaskType="Number" 
			TargetControlID="txtAno">
		</cc1:MaskedEditExtender>
		<asp:Button ID="btnPesquisar" runat="server" Text="<%$Resources:Resources, RelatorioHorasVooMensais_Pesquisar %>" 
			onclick="btnPesquisar_Click" CssClass="btnMedio" />
		<asp:Button ID="btnVoltarHome" runat="server" Text="<%$Resources:Resources, RelatorioHorasVooMensais_Voltar %>" 
			onclick="btnVoltarHome_Click" CssClass="btnPequeno" CausesValidation="False" />
	</p>
	<div class="Listagem">
		<div style="text-align:center; font-size:2.5em; width:90%;">
			<asp:Label ID="lblAno" runat="server"></asp:Label>
		</div>
		<asp:GridView ID="gvHorasVooMensais" runat="server" 
			AutoGenerateColumns="False" CellPadding="3" ForeColor="Black" 
			GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid" 
			BorderWidth="1px">
			<Columns>
				<asp:BoundField DataField="Tipo" HeaderText="">
					<HeaderStyle Width="7em" />
					<ItemStyle Font-Bold="True" HorizontalAlign="Left" />
				</asp:BoundField>
				<asp:BoundField DataField="Janeiro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Jan %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Fevereiro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Fev %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Marco" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Mar %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Abril" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Abr %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Maio" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Mai %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Junho" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Jun %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Julho" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Jul %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Agosto" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Ago %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Setembro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Set %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Outubro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Out %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Novembro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Nov %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Dezembro" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Dez %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="6em" />
					<ItemStyle HorizontalAlign="Right" />
				</asp:BoundField>
				<asp:BoundField DataField="Total" HeaderText="<%$Resources:Resources, RelatorioHorasVooMensais_Total %>" DataFormatString="{0:F2}">
					<HeaderStyle Width="7em" />
					<ItemStyle Font-Bold="True" HorizontalAlign="Right" />
				</asp:BoundField>
			</Columns>
			<FooterStyle BackColor="#CCCCCC" />
			<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
			<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
			<HeaderStyle BackColor="#AAAAAA" Font-Bold="True" ForeColor="#000000" />
			<AlternatingRowStyle BackColor="#EEEEEE" />
		</asp:GridView>
	</div>
<%--	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>--%>
    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
	<asp:ValidationSummary ID="vsHorasVooMensais" runat="server" ShowMessageBox="True" 
		ShowSummary="False" />
</asp:Content>
