<%@ Page Title="Aeroportos" Language="C#" MasterPageFile="~/Aeroporto/Aeroportos.Master" AutoEventWireup="true" CodeBehind="EntraDadosAeropPouso.aspx.cs" Inherits="SIGLA.Web.Aeroporto.EntraDadosAeropPouso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<script type="text/javascript" src="../ASP/javascript.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphTituloPagina" runat="server">
	<span id="TituloPagina" style="vertical-align: bottom"><asp:Label ID="lblTituloPagina" Text="<font size='4'><b>Pouso</b></font> <font size='3'><b>(???)</b></font><br /><font size='2'><b>[Horário UTC]</b></font>" runat="server"></asp:Label></span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cphConteudoPagina" runat="server">
	<div class="InformacoesGerais" runat="server" id="divPouso" style="width:90%;">
		<table width="98%" border='0' cellpadding='0' align="center" cellspacing='0'>
			<tr>
				<td style="padding-left: 50px; padding-right: 50px">
					<fieldset style="width: 98%;">
						<table>
							<tr>
								<td>
									<table border='0' cellpadding='0' align="left" cellspacing='0'>
										<tr style="padding-top: 5px; padding-bottom: 5px">
											<td style="padding-left: 88px; font-weight: bold" align="right">
												Voo:
											</td>
											<td style="padding-left: 5px">
												<asp:Label ID="lblNrVoo" runat="server"></asp:Label>
											</td>
											<td style="padding-left: 129px; font-weight: bold" align="right">
												Aeronave:
											</td>
											<td style="padding-left: 5px">
												<asp:Label ID="lblPrefixoAeronave" runat="server"></asp:Label>
											</td>
											<td style="padding-left: 129px; font-weight: bold" align="right">
												Origem:
											</td>
											<td style="padding-left: 5px">
												<asp:Label ID="lblOrigem" runat="server"></asp:Label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table style="white-space:nowrap;" border='0' cellpadding='0' align="left" cellspacing='0'>
										<tr style="padding-top: 5px; padding-bottom: 5px">
											<td style="padding-left: 20px; font-weight: bold" align="right">
												Partida Motor:
											</td>
											<td style="padding-left: 5px">
												<div runat="server" id="divPartidaMotorLabel" style="display:block;">
													<label id="lblDataHoraPartidaMotor">
														<asp:Label ID="lblPartidaMotor" runat="server"></asp:Label>
													</label>
												</div>
												<div runat="server" id="divPartidaMotorText" style="display:none;">
													<asp:TextBox ID="txtDiaPartidaMotor" runat="server" MaxLength="2" TabIndex="1" Width="2em"></asp:TextBox>&nbsp;/
													<asp:TextBox ID="txtMesPartidaMotor" runat="server" MaxLength="2" TabIndex="2" Width="2em"></asp:TextBox>&nbsp;/
													<asp:TextBox ID="txtAnoPartidaMotor" runat="server" MaxLength="4" TabIndex="3" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													<asp:TextBox ID="txtHoraPartidaMotor" runat="server" MaxLength="2" TabIndex="4" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
													<asp:TextBox ID="txtMinutoPartidaMotor" runat="server" MaxLength="2" TabIndex="5" Width="2em"></asp:TextBox>&nbsp;m
												</div>
											</td>
											<td style="padding-left: 40px; font-weight: bold" align="right">
												Decolagem:
											</td>
											<td style="padding-left: 5px">
												<div id="divDecolagemLabel" style="display:block;">
													<label id="lblDataHoraDecolagem">
														<asp:Label ID="lblDecolagem" runat="server"></asp:Label>
													</label>
												</div>
												<div runat="server" id="divDecolagemText" style="display:none;">
													<asp:TextBox ID="txtDiaDecolagem" runat="server" MaxLength="2" TabIndex="6" Width="2em"></asp:TextBox>&nbsp;/
													<asp:TextBox ID="txtMesDecolagem" runat="server" MaxLength="2" TabIndex="7" Width="2em"></asp:TextBox>&nbsp;/
													<asp:TextBox ID="txtAnoDecolagem" runat="server" MaxLength="4" TabIndex="8" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													<asp:TextBox ID="txtHoraDecolagem" runat="server" MaxLength="2" TabIndex="9" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
													<asp:TextBox ID="txtMinutoDecolagem" runat="server" MaxLength="2" TabIndex="10" Width="2em"></asp:TextBox>&nbsp;m
												</div>
											</td>
											<td runat="server" id="tdBotaoCorrecaoDecolagem" style="padding-left: 10px">
												<button id="btnCorrecaoDecolagem" style="height:23px; width:30px;" title="Corre&#231;&#227;o de Decolagem" onclick="javascript:return CorrecaoDecolagem()">
													<img id="imgBtnCorrecaoDecolagem" src="../ASP/imagens/tick.png" alt="Corre&#231;&#227;o de Decolagem" title="Corre&#231;&#227;o de Decolagem" />
												</button>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table border='0' cellpadding='0' align="left" cellspacing='0'>
										<tr style="padding-top: 5px; padding-bottom: 5px">
											<td style="padding-left: 37px; font-weight: bold" align="right">
												Cheg. Prev.:
											</td>
											<td style="padding-left: 5px">
												<asp:Label ID="lblChegPrev" runat="server"></asp:Label>
											</td>
											<td style="padding-left: 46px; font-weight: bold" align="right">
												Cheg. Est.:
											</td>
											<td style="padding-left: 5px">
												<asp:Label ID="lblChegEst" runat="server"></asp:Label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td style="padding-left: 50px; padding-right: 50px">
					<fieldset style="width: 98%">
						<table border='0' cellpadding='0' align="left" cellspacing='0'>
							<tr>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
									Pouso:
								</td>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
									<asp:TextBox ID="txtDiaPouso" runat="server" MaxLength="2" TabIndex="11" Width="2em"></asp:TextBox>&nbsp;/
									<asp:TextBox ID="txtMesPouso" runat="server" MaxLength="2" TabIndex="12" Width="2em"></asp:TextBox>&nbsp;/
									<asp:TextBox ID="txtAnoPouso" runat="server" MaxLength="4" TabIndex="13" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<asp:TextBox ID="txtHoraPouso" runat="server" MaxLength="2" TabIndex="14" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
									<asp:TextBox ID="txtMinutoPouso" runat="server" MaxLength="2" TabIndex="15" Width="2em"></asp:TextBox>&nbsp;m
								</td>
							</tr>
							<tr>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
									Corte motor:
								</td>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
									<asp:TextBox ID="txtDiaCorteMotor" runat="server" MaxLength="2" TabIndex="16" Width="2em"></asp:TextBox>&nbsp;/
									<asp:TextBox ID="txtMesCorteMotor" runat="server" MaxLength="2" TabIndex="17" Width="2em"></asp:TextBox>&nbsp;/
									<asp:TextBox ID="txtAnoCorteMotor" runat="server" MaxLength="4" TabIndex="18" Width="3em"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<asp:TextBox ID="txtHoraCorteMotor" runat="server" MaxLength="2" TabIndex="19" Width="2em"></asp:TextBox>&nbsp;h&nbsp;:&nbsp;
									<asp:TextBox ID="txtMinutoCorteMotor" runat="server" MaxLength="2" TabIndex="20" Width="2em"></asp:TextBox>&nbsp;m
								</td>
							</tr>
                            <tr style="padding-top: 5px; padding-bottom: 5px">
								<td style="padding-left: 50px; font-weight: bold" align="right">
									Combustível de pouso:
								</td>
								<td style="padding-left: 5px">
									<asp:TextBox ID="txtCombustivelPouso" runat="server" MaxLength="6" TabIndex="16" Width="6em"></asp:TextBox>
                                    <asp:CompareValidator Operator="DataTypeCheck" ControlToValidate="txtCombustivelPouso"  runat="server"
                                        Type="Integer" Display="None" ErrorMessage="O campo combustível de pouso deve ser num�rico!">
                                    </asp:CompareValidator>
								</td>
							</tr>
							<tr>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right">
									Justificativa:
								</td>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
									<asp:DropDownList ID="ddlJustificativa" runat="server" CssClass="txtXGrande" Enabled="False">
									</asp:DropDownList>
								</td>
							</tr>
							<tr>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 50px; font-weight: bold" align="right" valign="top">
									Observa&#231;&#227;o:
								</td>
								<td style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px">
									<asp:TextBox ID="txtObservacao" runat="server" MaxLength="200" CssClass="txtXGrande" Enabled="False"></asp:TextBox>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td width="100%" align="center" style="padding-top: 20px">
					<asp:Button ID="btnGravar" runat="server" Text="Gravar" TabIndex="21" 
						onclick="btnGravar_Click" />
					<asp:Button ID="btnVoltar" runat="server" Text="Voltar" TabIndex="22" 
						onclick="btnVoltar_Click" CausesValidation="False" />
					<asp:HiddenField ID="hidPartidaMotor" runat="server" />
					<asp:HiddenField ID="hidDecolagem" runat="server" />
					<asp:HiddenField ID="hidCorrigirDecolagem" runat="server" Value="false" />
				</td>
			</tr>
		</table>
	</div>
</asp:Content>
