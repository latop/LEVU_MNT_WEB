<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlterarSenha.aspx.cs" Inherits="SIGLA.Web.AlterarSenha" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table width="98%" border="0" cellpadding="0" cellspacing="0" id="Table1" align="center">
            <tr>
                <td class="corpo" align="left" valign="middle" width="30%">
                    <img src="asp/imagens/logo_empresa.gif" border="0"></a>
                </td>
                <td class="corpo" align="center" width='40%' valign="bottom">
                    <font size="4"><b><%=Resources.Resources.AlterarSenha_Titulo%></b></font>
                </td>
                <td width="30%">
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td align="center" colspan="3">
                    <form method="post" id="form2" name="form1">
                    <table id="Table2">
                        <tr>
                            <td class="fieldlabel" align="right" width="50%">
                                <%=Resources.Resources.AlterarSenha_SenhaAtual%>
                            </td>
                            <td width="50%">
                                <asp:TextBox runat="server" TextMode="Password" ID="txtSenhaAtual" CssClass="defaultsmall"
                                    MaxLength="20"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="fieldlabel" align="right" width="50%">
                                <%=Resources.Resources.AlterarSenha_NovaSenha%>
                            </td>
                            <td width="50%">
                                <asp:TextBox runat="server" TextMode="Password" ID="txtSenhaNova" CssClass="defaultsmall"
                                    MaxLength="20"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="fieldlabel" align="right" width="50%">
                                <%=Resources.Resources.AlterarSenha_ConfirmacaoSenha%>
                            </td>
                            <td width="50%">
                                <asp:TextBox runat="server" TextMode="Password" ID="txtSenhaConfirmacao" CssClass="defaultsmall"
                                    MaxLength="20"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" colspan="2" align="center">
                                <asp:Button runat="server" ID="btnEnviar" Text="<%$Resources:Resources, AlterarSenha_Confirmar %>" OnClick="btnEnviar_Click"
                                    OnClientClick="return confirm('<%=Resources.Resources.AlterarSenha_ConfirmacaoAlteracao%>');" />
                                <asp:Button runat="server" ID="btnCancelar" Text="<%$Resources:Resources, AlterarSenha_Cancelar %>" 
                                    onclick="btnCancelar_Click" />
                            </td>
                        </tr>
                    </table>
                    </form>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
