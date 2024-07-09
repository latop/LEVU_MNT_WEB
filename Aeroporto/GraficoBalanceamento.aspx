<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GraficoBalanceamento.aspx.cs" Inherits="SIGLA.Web.Aeroporto.GraficoBalanceamento" %>

<%@ Register assembly="System.Web.DataVisualization, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
		<asp:Chart ID="ChartBalanceamento" runat="server" Height="250px" Width="500px">
			<chartareas>
				<asp:ChartArea Name="ChartAreaEnvelopes">
					<AxisY Title="Weight (kgf)">
					</AxisY>
					<AxisX Title="CG (%)">
					</AxisX>
				</asp:ChartArea>
			</chartareas>
		</asp:Chart>
    </div>
    </form>
</body>
</html>
