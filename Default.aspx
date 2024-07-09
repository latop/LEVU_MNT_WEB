<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SIGLA.Web.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <div class="row">
                <div class="col-md-3">
                    <img class="img" src="asp/imagens/logo_empresa.gif" alt="" />
                </div>

                <div class="col-md-6">
                </div>

                <div class="col-md-3">
                    <img class="img" src="asp/imagens/sigla.jpg" alt="" />
                </div>

            </div>

            <div align="center" class="container jumbotron" style="width: 35%; background-color: lightgray">
                <div class="card-header-pills bg-primary text-white">
                    <h2>SIGLA</h2>
                </div>
                <div class="form-group" style="width: 80%">
                    <label class="text-dark mt-4" for="usuarioLabel"><%=Resources.Resources.Login_Usuario%></label>
                    <div class="input-group mb-4">
                        <div class="input-group-text"><i class="bi bi-person-circle"></i></div>
                        <asp:TextBox ID="txtUsuario" runat="server" class="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group" style="width: 80%">
                    <label class="text-dark" for="passwordLabel"><%=Resources.Resources.Login_Senha%></label>
                    <div class="input-group mb-4">
                        <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                        <asp:TextBox ID="txtSenha" runat="server" type="password" class="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group" style="width: 80%">
                    <label class="text-dark" for="perfilLabel"><%=Resources.Resources.Login_Dominio%></label>
                    <div class="input-group mb-5">
                        <div class="input-group-text"><i class="bi bi-globe"></i></div>
                        <asp:DropDownList runat="server" class="form-select" ID="ddlPerfil"
                            AutoPostBack="True" OnSelectedIndexChanged="ddlPerfil_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group" style="width: 40%">
                    <asp:Button runat="server" class="w-100 btn btn-lg btn-primary mb-4" ID="btnEntrar" Text="<%$Resources:Resources, Btn_Entrar %>" OnClick="btnEntrar_click" />
                    <a id="reenvioSenha" runat="server" href="../ReenvioSenha.aspx" class="btn btn-link" style="display: inline" title="Reenvio de senha para tripulantes" role="button"><%=Resources.Resources.Login_Esqueci%></a>
                </div>
                
                <div style="visibility: hidden;" id="div_erro" class="alert alert-danger" role="alert" runat="server">
                    <%=Resources.Resources.Login_Erro%>
                </div>
            </div>

            <div class="row mt-5">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                    <a href="http://www.latop.com.br">
                        <img class="img" src="asp/imagens/latop.jpg" alt="" />
                    </a>
                </div>
                <div class="col-md-5"></div>
            </div>

        </div>
    </form>

    <script src="Scripts/bootstrap.min.js"></script>
</body>
</html>
