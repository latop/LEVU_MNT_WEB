<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CadastroPessoal.aspx.cs" Inherits="SIGLA.Web.Tripulantes.CadastroPessoal" Title="<%$Resources:Resources, CadastroPessoal_Titulo %>" MasterPageFile="~/Tripulantes/Tripulantes.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" Runat="Server">
	<span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.CadastroPessoal_Titulo %></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" Runat="Server">
	<asp:Panel ID="pnlDadosPessoais" runat="server" GroupingText="<%$Resources:Resources, CadastroPessoal_Grupo %>" 
		CssClass="Ficha">
		<div>
			<asp:Label ID="lblNomeGuerra" runat="server" Text="<%$Resources:Resources, CadastroPessoal_NomeGuerra %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtNomeGuerra"></asp:Label>
			<asp:TextBox ID="txtNomeGuerra" runat="server" CssClass="ConteudoFixo txtPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblNome" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Nome %>" CssClass="Rotulo" 
				AssociatedControlID="txtNome"></asp:Label>
			<asp:TextBox ID="txtNome" runat="server" CssClass="ConteudoFixo txtGrande" 
				ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblMatricula" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Matricula %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtMatricula"></asp:Label>
			<asp:TextBox ID="txtMatricula" runat="server" CssClass="ConteudoFixo txtPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblSenioridade" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Senioridade %>" 
				CssClass="Rotulo" AssociatedControlID="txtSenioridade"></asp:Label>
			<asp:TextBox ID="txtSenioridade" runat="server" CssClass="ConteudoFixo txtXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblCPF" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Cpf %>" CssClass="Rotulo" 
				AssociatedControlID="txtCPF"></asp:Label>
			<asp:TextBox ID="txtCPF" runat="server" CssClass="ConteudoFixo txtXPequeno" ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblIdentidade" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Identidade %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtIdentidade"></asp:Label>
			<asp:TextBox ID="txtIdentidade" runat="server" CssClass="ConteudoEditavel txtXPequeno" TabIndex="1" MaxLength="50"></asp:TextBox>
			<asp:Label ID="lblSexo" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Sexo %>" 
				CssClass="Rotulo" AssociatedControlID="txtSexo"></asp:Label>
			<asp:TextBox ID="txtSexo" runat="server" CssClass="ConteudoFixo txtXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblNascimento" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Nascimento %>" 
				CssClass="Rotulo" AssociatedControlID="txtNascimento"></asp:Label>
			<asp:TextBox ID="txtNascimento" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblNacionalidade" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Nacionalidade %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtNacionalidade"></asp:Label>
			<asp:TextBox ID="txtNacionalidade" runat="server" CssClass="ConteudoFixo txtXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblAdmissao" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Admissao %>" CssClass="Rotulo" 
				AssociatedControlID="txtAdmissao"></asp:Label>
			<asp:TextBox ID="txtAdmissao" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblDesligamento" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Desligamento %>" 
				CssClass="Rotulo" AssociatedControlID="txtDesligamento"></asp:Label>
			<asp:TextBox ID="txtDesligamento" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblEndereco" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Endereco %>" 
				AssociatedControlID="txtEndereco" CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtEndereco" runat="server" CssClass="ConteudoEditavel txtXXGrande" 
				TabIndex="2" MaxLength="250"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblCEP" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Cep %>" AssociatedControlID="txtCEP" 
				CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtCEP" runat="server" CssClass="ConteudoEditavel txtXXPequeno" 
				TabIndex="3" MaxLength="10"></asp:TextBox>
			<asp:Label ID="lblBairro" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Bairro %>" 
				AssociatedControlID="txtBairro" CssClass="Rotulo"></asp:Label>
			<asp:TextBox ID="txtBairro" runat="server" CssClass="ConteudoEditavel txtPequeno" 
				TabIndex="4" MaxLength="30"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblPais" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Pais %>" 
				AssociatedControlID="ddlPais" CssClass="PrimeiraColuna"></asp:Label>
			<asp:DropDownList ID="ddlPais" runat="server" AutoPostBack="True" 
				CssClass="ConteudoEditavel" 
				onselectedindexchanged="ddlPais_SelectedIndexChanged" TabIndex="5">
			</asp:DropDownList>
			<asp:Label ID="lblUF" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Uf %>" AssociatedControlID="ddlUF" 
				CssClass="Rotulo"></asp:Label>
			<asp:DropDownList ID="ddlUF" runat="server" AutoPostBack="True" 
				CssClass="ConteudoEditavel" onselectedindexchanged="ddlUF_SelectedIndexChanged" 
				TabIndex="6">
			</asp:DropDownList>
			<asp:Label ID="lblCidade" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Cidade %>" 
				AssociatedControlID="ddlCidade" CssClass="Rotulo"></asp:Label>
			<asp:DropDownList ID="ddlCidade" runat="server" CssClass="ConteudoEditavel" 
				TabIndex="7">
			</asp:DropDownList>
		</div>
		<div>
			<asp:Label ID="lblEmail" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Email %>" 
				AssociatedControlID="txtEmail" CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtEmail" runat="server" CssClass="ConteudoFixo txtXXGrande" 
				TabIndex="8" MaxLength="250" ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblTelefone" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Telefone %>" 
				AssociatedControlID="txtTelefone" CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtTelefone" runat="server" CssClass="ConteudoEditavel txtMedio" 
				TabIndex="9" MaxLength="40"></asp:TextBox>
			<asp:Label ID="lblCelular" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Celular %>" 
				AssociatedControlID="txtCelular" CssClass="Rotulo"></asp:Label>
			<asp:TextBox ID="txtCelular" runat="server" CssClass="ConteudoEditavel txtMedio" 
				TabIndex="10" MaxLength="40"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblCodigoDAC" runat="server" Text="<%$Resources:Resources, CadastroPessoal_CodigoDac %>" 
				AssociatedControlID="txtCodigoDAC" CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtCodigoDAC" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
				TabIndex="11" MaxLength="10"></asp:TextBox>
			<asp:Label ID="lblCodigoLicenca" runat="server" Text="<%$Resources:Resources, CadastroPessoal_CodigoLicenca %>" 
				CssClass="Rotulo" AssociatedControlID="txtCodigoLicenca"></asp:Label>
			<asp:TextBox ID="txtCodigoLicenca" runat="server" CssClass="ConteudoFixo txtXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblLicenca" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Licenca %>" CssClass="Rotulo" 
				AssociatedControlID="txtLicenca"></asp:Label>
			<asp:TextBox ID="txtLicenca" runat="server" CssClass="ConteudoFixo txtXPequeno" 
				ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblPassaporte" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Passaporte %>" 
				AssociatedControlID="txtPassaporte" CssClass="PrimeiraColuna"></asp:Label>
			<asp:TextBox ID="txtPassaporte" runat="server" CssClass="ConteudoEditavel txtXPequeno" 
				TabIndex="12" MaxLength="40"></asp:TextBox>
			<asp:Label ID="lblPaisPassaporte" runat="server" Text="<%$Resources:Resources, CadastroPessoal_PaisPassaporte %>" 
				CssClass="Rotulo" AssociatedControlID="txtPaisPassaporte"></asp:Label>
			<asp:TextBox ID="txtPaisPassaporte" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblValidadePassaporte" runat="server" 
				Text="<%$Resources:Resources, CadastroPessoal_ValidadePassaporte %>" AssociatedControlID="txtValidadePassaporte" 
				CssClass="Rotulo"></asp:Label>
			<asp:TextBox ID="txtValidadePassaporte" runat="server" 
				CssClass="ConteudoEditavel txtXXPequeno" TabIndex="13" MaxLength="10"></asp:TextBox>
			<asp:CompareValidator ID="cvValidadePassaporte" runat="server" 
				ErrorMessage="<%$Resources:Resources, CadastroPessoal_ValidadePassaporteErro %>" 
				Operator="DataTypeCheck" Type="Date" Text="*" 
				ControlToValidate="txtValidadePassaporte"></asp:CompareValidator>
		</div>
		<div>
			<asp:Label ID="lblBanco" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Banco %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtBanco"></asp:Label>
			<asp:TextBox ID="txtBanco" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblAgencia" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Agencia %>" CssClass="Rotulo" 
				AssociatedControlID="txtAgencia"></asp:Label>
			<asp:TextBox ID="txtAgencia" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
			<asp:Label ID="lblContaCorrente" runat="server" Text="<%$Resources:Resources, CadastroPessoal_ContaCorrente %>" 
				CssClass="Rotulo" AssociatedControlID="txtContaCorrente"></asp:Label>
			<asp:TextBox ID="txtContaCorrente" runat="server" CssClass="ConteudoFixo txtXXPequeno" 
				ReadOnly="True"></asp:TextBox>
		</div>
		<div>
			<asp:Label ID="lblObservacao" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Observacao %>" 
				CssClass="PrimeiraColuna" AssociatedControlID="txtObservacao"></asp:Label>
			<asp:TextBox ID="txtObservacao" runat="server" 
				CssClass="ConteudoFixo txtXXGrande" ReadOnly="True" Rows="5" TextMode="MultiLine"></asp:TextBox>
		</div>
	</asp:Panel>
	<p class="btn">
		<asp:Button ID="btnVoltar" runat="server" Text="<%$Resources:Resources, CadastroPessoal_Voltar %>" TabIndex="101" 
			CssClass="btnPequeno" onclick="btnVoltar_Click" CausesValidation="False" />
	</p>
	<asp:ValidationSummary ID="vsCadastroPessoal" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
