<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatusSistema.aspx.cs" Inherits="SIGLA.Web.StatusSistema" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <section class="featured">
                <div class="content-wrapper">
                    <hgroup class="title">
                        <asp:Image ID="imgSigla" AlternateText="SIGLA" runat="server"
                            ImageUrl="~/Images/sigla.gif" />
                        <h1>Status do sistema Sigla Web.</h1>
                    </hgroup>
                    <p>
                        Versão atual: <b><%=Session["VERSAO"].ToString() %></b>
                        <br />
                        Empresa (sigla ICAO): <b><%=Session["SIGLA_EMPRESA"].ToString() %></b><br />
                        Horário do servidor: <b><%=DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") %></b>
                        <br />
                        Versão BD: <b><%=Session["VERSAO_BD"].ToString() %></b>
                        <br />
                        Versão SIGLA WEB API: <b><%=Session["VERSAO_WEBAPI"].ToString() %></b>
                    </p>
                </div>
            </section>
            <section class="content-wrapper main-content clear-fix">
                <h3>&nbsp;</h3>
                <ol class="round">
                    <li class="one">
                        <h5>Banco de dados</h5>
                        <%= Session["STATUS_BD"].ToString() %>
                    </li>
                    <li class="one">
                        <h5>Permissão de escrita em diretório</h5>
                        <%= Session["STATUS_DIRETORIOS"].ToString() %>
                    </li>
                    <li class="one">
                        <h5>Conexão com o sistema SIGLA WEB API</h5>
                        <%= Session["STATUS_ACESSOWEBAPI"].ToString() %>
                    </li>
                </ol>
            </section>
        </div>
    </form>
</body>
</html>
