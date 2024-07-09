<%@ Page Title="Documentos" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true" CodeBehind="Documentos.aspx.cs" Inherits="SIGLA.Web.Funcionarios.Documentos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom">Documentos</span>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <asp:Label ID="Label1" runat="server" Text="Escolha o arquivo a ser enviado:"></asp:Label>
        <br />
        <asp:FileUpload ID="fileUploadDocumentos" runat="server" CssClass="txtXGrande" ViewStateMode="Enabled" />
        <asp:RequiredFieldValidator ID="rfvFileUploadDoc" runat="server" ControlToValidate="fileUploadDocumentos"
            ErrorMessage="Escolha o arquivo a ser enviado!">*</asp:RequiredFieldValidator>
        <asp:Label ID="lblTamanhoMaximoArquivo" runat="server" Font-Size="XX-Small"></asp:Label>
        <br />
        <br />
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel runat="server" ID="UpdatePanel" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlArquivoGrupo" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlAeroporto" EventName="SelectedIndexChanged" />
            </Triggers>
            <ContentTemplate>
                <asp:Label ID="Label2" runat="server" Text="Grupo:"></asp:Label>
                <asp:DropDownList ID="ddlArquivoGrupo" runat="server" Font-Size="0.9em" runat="server"
                    OnSelectedIndexChanged="ddlArquivoGrupo_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblCargo" runat="server" Text="Cargo:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlCargo" runat="server" Font-Size="0.9em" Visible="false">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblBase" runat="server" Text="Base:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlBase" runat="server" Font-Size="0.9em" Visible="false">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblFrota" runat="server" Text="Frota:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlFrota" runat="server" Font-Size="0.9em" Visible="false">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblFuncao" runat="server" Text="Função:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlFuncao" runat="server" Font-Size="0.9em" Visible="false" runat="server"
                    AutoPostBack="true">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblAeroporto" runat="server" Text="Aeroporto:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlAeroporto" runat="server" Font-Size="0.9em" Visible="false" runat="server"
                    OnSelectedIndexChanged="ddlAeroporto_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                &nbsp;
                <asp:Label ID="lblLoginAeroporto" runat="server" Text="Login do aeroporto:" Visible="false"></asp:Label>
                <asp:DropDownList ID="ddlLoginAeroporto" runat="server" Font-Size="0.9em" Visible="false">
                </asp:DropDownList>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:CheckBox ID="chkDocObrigatorio" runat="server" Text="Documento Obrigatório" />
        <br />
        <br />
        <asp:Button ID="btnEnviarArquivo" runat="server" Text="Enviar o Arquivo" OnClick="btnEnviarArquivo_Click" />
        <input type="reset" id="rstLimpar" name="rstLimpar" value="Limpar" tabindex="2" onclick="javascript: ApagaToolTip();" />
    </div>
    <hr style="text-align: left; width: 50em; margin: 20px 0 0 40px;" />
    <div class="Listagem">
        <asp:GridView ID="gvDocumentos" runat="server" AutoGenerateColumns="False" CellPadding="3"
            GridLines="Vertical" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
            BorderWidth="1px" Caption="Documentos" CaptionAlign="Top" OnRowCommand="gvDocumentos_RowCommand"
            DataKeyNames="NomeArquivo,SeqArquivoGrupo,CodigoCargo,SeqCidade,SeqFrota,SeqAeroporto,CodFuncaoTrip,SeqUsuarioAerop" EmptyDataText="Não há documentos nesse momento."
            OnRowDataBound="gvDocumentos_RowDataBound" AllowSorting="True" OnSorting="gvDocumentos_Sorting"
            OnRowCreated="gvDocumentos_RowCreated">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:CheckBox ID="chkArquivo" runat="server" />
                    </ItemTemplate>
                    <HeaderStyle Width="2.5em" />
                </asp:TemplateField>
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
                <asp:BoundField DataField="DataArquivo" HeaderText="Data" DataFormatString="{0:dd/MM/yyyy HH:mm}"
                    SortExpression="DataArquivo">
                    <HeaderStyle Width="12.1em" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="DescricaoComplementarGrupo" HeaderText="Grupo" SortExpression="DescricaoComplementarGrupo">
                    <HeaderStyle Width="12.1em" />
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
        <asp:Button ID="btnExcluirArquivos" runat="server" Text="Excluir Arquivo(s) Selecionado(s)"
            CssClass="btnXXGrande" CausesValidation="False" OnClick="btnExcluirArquivos_Click"
            OnClientClick="javascript:return ConfirmaExclusaoDeArquivos();" />
    </p>
    <asp:ValidationSummary ID="vsUploadDoc" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
