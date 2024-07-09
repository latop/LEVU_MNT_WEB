
<%@ Page Title="SIGLA - Voos CPA"
    Language="C#"
    MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true"
    CodeBehind="VoosCPA.aspx.cs"
    Inherits="SIGLA.Web.Funcionarios.VoosCPA"
    ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <style type="text/css">
        .txtFiltroStyle1 {
            width: 4em;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .lblFiltroStyle1 {
            margin-left: 20px;
        }

        div.FiltroPesquisa {
            width: 65em;
            margin: 10px 0 0 150px;
            text-align: left;
            white-space: nowrap;
            font-size: 0.8em;
        }

        .ajax__calendar_title {
            width: 140px;
            margin: auto;
        }

        .btnConversaoLibraKg {
            background: url(../Images/operac.bmp) no-repeat right;
            background-color: #DDDDDD;
            padding-right: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <asp:Label ID="lblSubtitulo" runat="server" Text="<%$Resources:Resources, VoosCPA_Titulo %>" CssClass="Rotulo"></asp:Label>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <div class="InformacoesGerais">
        <asp:Label ID="Label2" runat="server" Text="<%$Resources:Resources, Controle_Inicio %>"></asp:Label>
        <asp:TextBox ID="txtDataInicio" runat="server" CssClass="txtXXPequeno" MaxLength="10"
            TabIndex="1"></asp:TextBox>
        <cc1:MaskedEditExtender ID="txtDataInicio_MaskedEditExtender" runat="server"
            CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder=""
            CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True"
            Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataInicio">
        </cc1:MaskedEditExtender>
        <cc1:CalendarExtender ID="txtPeriodoDe_CalendarExtender" runat="server" 
             Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtDataInicio">
        </cc1:CalendarExtender>
        <asp:CompareValidator ID="cvData" runat="server"
            ControlToValidate="txtDataInicio"
            ErrorMessage="<%$Resources:Resources, Controle_Inicio_DataInvalida %>"
            Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
        <asp:RequiredFieldValidator ID="rfvData" runat="server"
            ControlToValidate="txtDataInicio" Display="Dynamic"
            ErrorMessage="<%$Resources:Resources, Controle_Inicio_DataInvalida %>">*</asp:RequiredFieldValidator>

        <asp:Label ID="Label3" runat="server" Text="<%$Resources:Resources, Controle_Fim %>"></asp:Label>
        <asp:TextBox ID="txtDataFim" runat="server" CssClass="txtXXPequeno" MaxLength="10"
            TabIndex="2"></asp:TextBox>
        <cc1:MaskedEditExtender ID="txtDataFim_MaskedEditExtender" runat="server"
            CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder=""
            CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True"
            Mask="99/99/9999" MaskType="Date" TargetControlID="txtDataFim">
        </cc1:MaskedEditExtender>
        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" 
             Enabled="True" Format="dd/MM/yyyy" TargetControlID="txtDataFim">
        </cc1:CalendarExtender>
        <asp:CompareValidator ID="CompareValidator1" runat="server"
            ControlToValidate="txtDataFim"
            ErrorMessage="<%$Resources:Resources, Controle_Fim_DataInvalida %>"
            Operator="DataTypeCheck" Type="Date" Display="None">*</asp:CompareValidator>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
            ControlToValidate="txtDataFim" Display="Dynamic"
            ErrorMessage="">*</asp:RequiredFieldValidator>

        <asp:Button ID="btnPesquisar" runat="server" Text="<%$Resources:Resources, Controle_Pesquisar %>"
            OnClick="btnPesquisar_Click" CssClass="btnMedio lblFiltroStyle1" TabIndex="3" />
    </div>
    <div class="Listagem">
        <asp:Repeater ID="rptVoos" runat="server">
            <HeaderTemplate>
                <table align="left" border="1" width="97%" cellpadding="0" cellspacing="0" id="Table1">
                    <tr bgcolor='#AAAAAA'>
                        <td class="CORPO9"><%=Resources.Resources.VoosCPA_FlightNumber %></td>
                        <td class="CORPO9"><%=Resources.Resources.VoosCPA_Situation %></td>
                        <td class="CORPO9"><%=Resources.Resources.VoosCPA_DateBSB %></td>
                        <td class="CORPO9"><%=Resources.Resources.VoosCPA_Month %></td>
                        <td class="CORPO9">SchedDepApt</td>
                        <td class="CORPO9">SchedArrApt</td>
                        <td class="CORPO9">DepApt</td>
                        <td class="CORPO9">ArrApt</td>
                        <td class="CORPO9">SchedDepDate</td>
                        <td class="CORPO9">SchedDepTime</td>
                        <td class="CORPO9">DepDate</td>
                        <td class="CORPO9">OutGate</td>
                        <td class="CORPO9">InAir</td>
                        <td class="CORPO9">DepDelay</td>
                        <td class="CORPO9">DepDelayStatus</td>
                        <td class="CORPO9">SchedArrDate</td>
                        <td class="CORPO9">SchedArrTime</td>
                        <td class="CORPO9">ArrDate</td>
                        <td class="CORPO9">Landed</td>
                        <td class="CORPO9">InGate</td>
                        <td class="CORPO9">ArrDelay</td>
                        <td class="CORPO9">ArrDelayStatus</td>
                        <td class="CORPO9">FlightTime</td>
                        <td class="CORPO9">BlockTime</td>
                        <td class="CORPO9">Equipment</td>
                        <td class="CORPO9">TailNumber</td>
                        <td class="CORPO9">Capacity</td>
                        <td class="CORPO9">Pax</td>
                        <td class="CORPO9">LoadFactor</td>
                        <td class="CORPO9">LateDepCode1</td>
                        <td class="CORPO9">MinLateDep1</td>
                        <td class="CORPO9">LateDepCode2</td>
                        <td class="CORPO9">MinLateDep2</td>
                        <td class="CORPO9">LateDepCode3</td>
                        <td class="CORPO9">MinLateDep3</td>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"FlightNumber") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Situation") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DateBSB") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Month") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedDepApt") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedArrApt") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DepApt") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"ArrApt") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedDepDate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedDepTime") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DepDate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"OutGate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"InAir") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DepDelay") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"DepDelayStatus") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedArrDate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"SchedArrTime") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"ArrDate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Landed") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"InGate") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"ArrDelay") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"ArrDelayStatus") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"FlightTime") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"BlockTime") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Equipment") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"TailNumber") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Capacity") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"Pax") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"LoadFactor") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"LateDepCode1") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"MinLateDep1") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"LateDepCode2") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"MinLateDep2") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"LateDepCode3") %></td>
                    <td class="CORPO8" nowrap align="center"><%# DataBinder.Eval(Container.DataItem,"MinLateDep3") %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <br />
    <br />
    <asp:Button ID="Button2" runat="server" Text="Exportar Excel" OnClick="btnExcel_Click" CssClass="btnMedio" TabIndex="4" />    

    <cc1:ToolkitScriptManager runat="server" ID="ToolKitScriptManager" EnablePartialRendering="true">
    </cc1:ToolkitScriptManager>
    <asp:ValidationSummary ID="vsDiarioBordo" runat="server" ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
