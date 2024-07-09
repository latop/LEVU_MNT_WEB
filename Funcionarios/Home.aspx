<%@ Page Title="<%$Resources:Resources, Home_Titulo %>" Language="C#" MasterPageFile="~/Funcionarios/Funcionarios.Master"
    AutoEventWireup="true"
    CodeBehind="Home.aspx.cs"
    Inherits="SIGLA.Web.Funcionarios.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
    <span id="TituloPagina" style="vertical-align: bottom"><%=Resources.Resources.Home_Titulo %></span>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
    <br />
</asp:Content>
