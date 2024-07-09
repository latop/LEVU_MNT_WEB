<%@ Language=VBScript %>
<!--#include file="header.asp"-->
<%	Response.Expires = 0 %>
<%	Response.Buffer = true %>
<!--#include file="verify_login.asp"-->
<!--#include file="libgeral.asp"-->
<html>
	<head>
		<title>Altera Senha</title>
		<script language="javascript">
		    function CarregaPagina() {
		        window.form1.SenhaAtual.focus();
		    }
		    function VerificaCampos() {
		        if (window.form1.SenhaAtual.value == '') {
		            alert('Preencha o campo senha atual, por favor!');
		            window.form1.SenhaAtual.focus();
		            return false;
		        }
		        else if (window.form1.NovaSenha.value == '') {
		            alert('Preencha o campo nova senha, por favor!');
		            window.form1.NovaSenha.focus();
		            return false;
		        }
		        else if (window.form1.ConfirmacaoSenha.value == '') {
		            alert('Preencha o campo confirmação de senha, por favor!');
		            window.form1.ConfirmacaoSenha.focus();
		            return false;
		        }
		        else if (window.form1.ConfirmacaoSenha.value != window.form1.NovaSenha.value) {
		            alert('Os campos nova senha e confirmação de senha devem ser preenchidos com o mesmo valor!');
		            window.form1.NovaSenha.focus();
		            return false;
		        }
		        else {
		            return confirm('Corfirma a alteração de senha?');
		        }
		    }
		</script>
	</head>
	<body onload="CarregaPagina()">
		<table width="98%" border="0" cellpadding="0" cellspacing="0" ID="Table1" align="center">
			<tr>
				<td class="corpo" align="left" valign="middle" width="30%">
					<img src="imagens/logo_empresa.gif" border="0"></a>
				</td>
				<td class="corpo" align="center" width='40%' valign="bottom">
					<font size="4"><b>Alteração de Senha</b></font>
				</td>
				<td width="30%"></td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td align="center" colspan="3">
					<form action="alterasenhadespacho.asp" method="post" id="form1" name="form1">
						<table ID="Table2">
							<tr>
								<td class="fieldlabel" align="right" width="50%">Senha Atual:</td>
								<td width="50%">
									<input type="password" id="SenhaAtual" name="SenhaAtual" class="defaultsmall" size="20"
										maxlength="20">
								</td>
							</tr>
							<tr>
								<td class="fieldlabel" align="right" width="50%">Nova Senha:</td>
								<td width="50%">
									<input type="password" id="NovaSenha" name="NovaSenha" class="defaultsmall" size="20" maxlength="20">
								</td>
							</tr>
							<tr>
								<td class="fieldlabel" align="right" width="50%">Confirmação de Senha:</td>
								<td width="50%">
									<input type="password" id="ConfirmacaoSenha" name="ConfirmacaoSenha" class="defaultsmall"
										size="20" maxlength="20">
								</td>
							</tr>
							<tr>
								<td width="100%" colspan="2" align="center">
									<input type="submit" onclick="return VerificaCampos()" value="Confirmar" name="btnConfirmar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnConfirmar" />
									<input type="submit" value="Cancelar" name="btnCancelar" class="botao1" style="WIDTH: 80px; HEIGHT: 25px" ID="btnCancelar" />
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>

<%
	Dim strConfirmar, strCancelar
	strConfirmar = Request.Form("btnConfirmar")
	strCancelar = Request.Form("btnCancelar")
	if (strCancelar <> "") then
		Response.Redirect("homedespacho.asp")
	elseif (strConfirmar <> "") then
		Dim strSenhaAtual, strNovaSenha, strCorfirmacaoDeSenha
		Dim strSenhaAtualEncriptada, strNovaSenhaEncriptada
		Dim intDominio, intMemberId, strUsuario, strUsuarioBD, intMemberIdBD
		Dim objConexaoSqlServer, objRecordSetSqlServer, objConexaoSqlServerUpdate, objRecordSetSqlServerUpdate
		Dim strQuery, strSqlSelect, strSqlFrom, strSqlWhere, strQueryUpdate, strSqlUpdate, strSqlSet, strSqlWhereUpdate
		strSenhaAtual = Request.Form("SenhaAtual")
		strNovaSenha = Request.Form("NovaSenha")
		strCorfirmacaoDeSenha = Request.Form("ConfirmacaoSenha")
		
		if ((strSenhaAtual <> "") and (strNovaSenha <> "") and (strCorfirmacaoDeSenha <> "")) then
			strSenhaAtualEncriptada = fnEncriptaSenha(strSenhaAtual)
			intMemberId = CInt(Session("member"))
			strUsuario = Session("login")
			intDominio = CInt(Session("dominio"))
			set objConexaoSqlServer = Server.CreateObject ("ADODB.Connection")
			objConexaoSqlServer.Open (StringConexaoSqlServerEncriptado)
			if intDominio = 4 then
				strSqlSelect = " SELECT SUS.sequsuario AS Id,  UPPER(SUS.usuario) AS Usuario, SUS.flgaltera "
				strSqlFrom = " FROM sig_usuario SUS "
				strSqlWhere = " WHERE UPPER(SUS.usuario)=" & Plic(strUsuario) & " AND LEFT(UPPER(SUS.usuario), 3)='DO.' AND SUS.senha=" & Plic(strSenhaAtualEncriptada) & " AND SUS.flgativo='S'"
				strQuery = strSqlSelect & strSqlFrom & strSqlWhere
				set objRecordSetSqlServer = objConexaoSqlServer.Execute (strQuery)
				if (objRecordSetSqlServer.eof) then
					Response.Write "<p class='errmsg' align='center'>Senha inválida.<br>Verifique e tente novamente, por favor!</p>"
				else
					strUsuarioBD = objRecordSetSqlServer("Usuario")
					intMemberIdBD = CInt(objRecordSetSqlServer("Id"))
					if ((strUsuario = strUsuarioBD) and (intMemberId = intMemberIdBD)) then
						strNovaSenhaEncriptada = fnEncriptaSenha(strNovaSenha)
						
						set objConexaoSqlServerUpdate = Server.CreateObject ("ADODB.Connection")
						objConexaoSqlServerUpdate.Open (StringConexaoSqlServerUpdateEncriptado)
						strSqlUpdate = " UPDATE sig_usuario "
						strSqlSet = " SET flgaltera='N', senha=" & Plic(strNovaSenhaEncriptada)
						strSqlWhereUpdate = " WHERE sequsuario=" & intMemberId
						strQueryUpdate = strSqlUpdate & strSqlSet & strSqlWhereUpdate
						response.write("strQueryUpdate: " & strQueryUpdate)
						set objRecordSetSqlServerUpdate = objConexaoSqlServerUpdate.Execute(strQueryUpdate)
						objConexaoSqlServerUpdate.Close
						set objRecordSetSqlServerUpdate = nothing
						set objConexaoSqlServerUpdate = nothing
						Response.Redirect("homedespacho.asp?msg=s")
					else
						Response.Write "<p class='errmsg' align='center'>Senha inválida.<br>Verifique e tente novamente, por favor!</p>"
					end if 'if strUsuario = strUsuarioBD then
				end if 'if (objRecordSetSqlServer.eof) then
			end if
			objRecordSetSqlServer.close
			set objRecordSetSqlServer= nothing
			objConexaoSqlServer.Close
			set objConexaoSqlServer = nothing
		end if 'if ((strSenhaAtual <> "") and (strNovaSenha <> "") and (strCorfirmacaoDeSenha <> "")) then
	end if 'if (strCancelar <> "") then
%>

	</body>
</html>