<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="EntraDadosAeropDecol.aspx.cs" Inherits="SIGLA.Web.Aeroporto.EntraDadosAeropDecol" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<script type="text/javascript" src="../ASP/javascript.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" Text="<font size='4'><b>Decolagem</b></font> <font size='3'><b>(???)</b></font><br /><font size='2'><b>[Horário UTC]</b></font>" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="InformacoesGerais" runat="server" id="divDecolagem" style="width:90%;">
		<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0' ID="Table1">
			<tr style="padding-top: 5px; padding-bottom: 5px">
				<td style="padding-left: 50px; padding-right: 50px">
					<fieldset style="width: 98%">
						<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table2">
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Voo:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblNrVoo" runat="server"></asp:Label>
								</td>
								<td colspan="2"></td>
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Aeronave:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblPrefixoAeronave" runat="server"></asp:Label>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Origem:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblOrigem" runat="server"></asp:Label>
								</td>
								<td colspan="2"></td>
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Destino:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblDestino" runat="server"></asp:Label>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Part. Prev.:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblPartPrev" runat="server"></asp:Label>
								</td>
								<td colspan="2"></td>
								<td style="padding-left: 20px; font-weight: bold" align="right">
									Part. Est.:
								</td>
								<td style="padding-left: 5px">
									<asp:Label ID="lblPartEst" runat="server"></asp:Label>
								</td>
								<td colspan="2"></td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr style="padding-top: 5px; padding-bottom: 5px">
				<td style="padding-left: 50px; padding-right: 50px">
					<fieldset style="width: 98%">
						<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table4">
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 20px; padding-right: 20px;" align="right">
									<fieldset>
										<legend style="color: #000000;"><font style="font-weight: bold">Passageiros:</font>&nbsp;</legend>
										<font style="padding-left: 10px; font-weight: bold">Pago:</font>
										<asp:Label ID="lblPaxPago" runat="server"></asp:Label>
										<font style="padding-left: 10px; font-weight: bold">PAD:</font>
										<asp:Label ID="lblPaxPad" runat="server"></asp:Label>
										<font style="padding-left: 10px; font-weight: bold">DHC:</font>
										<font style="padding-right: 10px;"><asp:Label ID="lblPaxDHC" runat="server"></asp:Label></font>
									</fieldset>
								</td>
								<td style="padding-left: 20px; padding-right: 20px;" align="right">
									<fieldset>
										<legend style="color: #000000;"><font style="font-weight: bold">Bagagem:</font>&nbsp;</legend>
										<font style="padding-left: 10px; font-weight: bold">Livre:</font>
										<asp:Label ID="lblBagLivre" runat="server"></asp:Label>
										<font style="padding-left: 10px; font-weight: bold">Excesso:</font>
										<font style="padding-right: 10px;"><asp:Label ID="lblBagExcesso" runat="server"></asp:Label></font>
									</fieldset>
								</td>
								<td style="padding-left: 20px; padding-right: 20px;" align="right" >
									<fieldset>
										<legend style="color: #000000;"><font style="font-weight: bold">Carga:</font>&nbsp;</legend>
										<font style="padding-left: 10px; font-weight: bold">Paga:</font>
										<asp:Label ID="lblCargaPaga" runat="server"></asp:Label>
										<font style="padding-left: 10px; font-weight: bold">Grátis:</font>
										<font style="padding-right: 10px;"><asp:Label ID="lblCargaGratis" runat="server"></asp:Label></font>
									</fieldset>
								</td>
						  </tr>
						  <tr>
                      		<td colspan="4">
								<table border="0">
									<tr runat="server" id="linhaCapacPax" visible="false">
										<td colspan="4">
        			           				 <font class="Corpo9" style="color:#FF0000"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aviso! Capacidade de passageiros excedida. Capacidade Máxima: <asp:Label ID="lblCapacPax" runat="server"></asp:Label>.</b></font>
                    					</td>
                    				</tr>
                    				<tr runat="server" id="linhaCapacCga" visible="false">
                    					<td>
										   <font class="Corpo9" style="color:#FF0000"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aviso! Capacidade de carga excedida. Capacidade Máxima: <asp:Label ID="lblCapacCga" runat="server"></asp:Label>.</b></font>
                    					</td>
                    				</tr>
								</table>
							</td>
						  </tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr style="padding-top: 5px; padding-bottom: 5px">
				<td style="padding-left: 50px; padding-right: 50px">
					<fieldset style="width: 98%">
						<table border='0' cellpadding='0' align="left" cellspacing='0' ID="Table3">
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Fechamento de Porta:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtDiaFechamPorta" runat="server" MaxLength="2" TabIndex="1" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvDiaFechamPorta" runat="server" 
										ControlToValidate="txtDiaFechamPorta" Display="None" 
										ErrorMessage="Preencha o campo dia do fechamento de porta, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMesFechamPorta" runat="server" MaxLength="2" TabIndex="2" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvMesFechamPorta" runat="server" 
										ControlToValidate="txtMesFechamPorta" Display="None" 
										ErrorMessage="Preencha o campo mês do fechamento de porta, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtAnoFechamPorta" runat="server" MaxLength="4" TabIndex="3" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<asp:RequiredFieldValidator ID="rfvAnoFechamPorta" runat="server" 
										ControlToValidate="txtAnoFechamPorta" Display="None" 
										ErrorMessage="Preencha o campo ano do fechamento de porta, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtHoraFechamPorta" runat="server" MaxLength="2" TabIndex="4" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
									<asp:RequiredFieldValidator ID="rfvHoraFechamPorta" runat="server" 
										ControlToValidate="txtHoraFechamPorta" Display="None" 
										ErrorMessage="Preencha o campo hora do fechamento de porta, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMinutoFechamPorta" runat="server" MaxLength="2" TabIndex="5" Width="2em"></asp:TextBox>&nbsp;m
									<asp:RequiredFieldValidator ID="rfvMinutoFechamPorta" runat="server" 
										ControlToValidate="txtMinutoFechamPorta" Display="None" 
										ErrorMessage="Preencha o campo minuto do fechamento de porta, por favor!">*</asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Partida motor:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtDiaPartidaMotor" runat="server" MaxLength="2" TabIndex="6" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvDiaPartidaMotor" runat="server" 
										ControlToValidate="txtDiaPartidaMotor" Display="None" 
										ErrorMessage="Preencha o campo dia da partida motor, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMesPartidaMotor" runat="server" MaxLength="2" TabIndex="7" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvMesPartidaMotor" runat="server" 
										ControlToValidate="txtMesPartidaMotor" Display="None" 
										ErrorMessage="Preencha o campo mês da partida motor, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtAnoPartidaMotor" runat="server" MaxLength="4" TabIndex="8" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<asp:RequiredFieldValidator ID="rfvAnoPartidaMotor" runat="server" 
										ControlToValidate="txtAnoPartidaMotor" Display="None" 
										ErrorMessage="Preencha o campo ano da partida motor, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtHoraPartidaMotor" runat="server" MaxLength="2" TabIndex="9" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
									<asp:RequiredFieldValidator ID="rfvHoraPartidaMotor" runat="server" 
										ControlToValidate="txtHoraPartidaMotor" Display="None" 
										ErrorMessage="Preencha o campo hora da partida motor, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMinutoPartidaMotor" runat="server" MaxLength="2" TabIndex="10" Width="2em"></asp:TextBox>&nbsp;m
									<asp:RequiredFieldValidator ID="rfvMinutoPartidaMotor" runat="server" 
										ControlToValidate="txtMinutoPartidaMotor" Display="None" 
										ErrorMessage="Preencha o campo minuto da partida motor, por favor!">*</asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Decolagem:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtDiaDecolagem" runat="server" MaxLength="2" TabIndex="11" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvDiaDecolagem" runat="server" 
										ControlToValidate="txtDiaDecolagem" Display="None" 
										ErrorMessage="Preencha o campo dia da decolagem, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMesDecolagem" runat="server" MaxLength="2" TabIndex="12" Width="2em"></asp:TextBox>&nbsp;/
									<asp:RequiredFieldValidator ID="rfvMesDecolagem" runat="server" 
										ControlToValidate="txtMesDecolagem" Display="None" 
										ErrorMessage="Preencha o campo mês da decolagem, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtAnoDecolagem" runat="server" MaxLength="4" TabIndex="13" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<asp:RequiredFieldValidator ID="rfvAnoDecolagem" runat="server" 
										ControlToValidate="txtAnoDecolagem" Display="None" 
										ErrorMessage="Preencha o campo ano da decolagem, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtHoraDecolagem" runat="server" MaxLength="2" TabIndex="14" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
									<asp:RequiredFieldValidator ID="rfvHoraDecolagem" runat="server" 
										ControlToValidate="txtHoraDecolagem" Display="None" 
										ErrorMessage="Preencha o campo hora da decolagem, por favor!">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="txtMinutoDecolagem" runat="server" MaxLength="2" TabIndex="15" Width="2em"></asp:TextBox>&nbsp;m
									<asp:RequiredFieldValidator ID="rfvMinutoDecolagem" runat="server" 
										ControlToValidate="txtMinutoDecolagem" Display="None" 
										ErrorMessage="Preencha o campo minuto da decolagem, por favor!">*</asp:RequiredFieldValidator>
								</td>
							</tr>
                            <tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Combustível de partida:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtCombustivelPartida" runat="server" MaxLength="6" TabIndex="16" Width="6em"></asp:TextBox>
                                    <asp:CompareValidator Operator="DataTypeCheck" ControlToValidate="txtCombustivelPartida"  runat="server"
                                        Type="Integer" Display="None" ErrorMessage="O campo combustível de partida deve ser numérico!">
                                    </asp:CompareValidator>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Justificativa:
								</td>
								<td style="padding-left: 5px">
									<asp:DropDownList ID="ddlJustificativa" runat="server" TabIndex="17" CssClass="txtXGrande">
									</asp:DropDownList>
								</td>
							</tr>
							<tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right" valign="top">
									Observação:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtObservacao" runat="server" MaxLength="200" TabIndex="18" CssClass="txtXGrande"></asp:TextBox>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td width="100%" align="center" style="padding-top: 20px">
					<asp:Button ID="btnCombinada" runat="server" Text="Combinada" TabIndex="19" 
						Visible="False" onclick="btnCombinada_Click" CausesValidation="False" />
					<asp:Button ID="btnGravar" runat="server" Text="Gravar" TabIndex="20" 
						onclick="btnGravar_Click" />
					<asp:Button ID="btnVoltar" runat="server" Text="Voltar" TabIndex="21" 
						onclick="btnVoltar_Click" CausesValidation="False" />
				</td>
			</tr>
		</table>
	</div>
	<asp:ValidationSummary ID="vsEntraDadosAeropDecol" runat="server" 
		ShowMessageBox="True" ShowSummary="False" />
</asp:Content>
