<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PageLogo.ascx.vb" Inherits="Nrc.MySolutions.eToolKit_UserControls_PageLogo" %>
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td valign="bottom"><asp:Image ID="LogoImage" runat="server" AlternateText="eToolKit Logo" ImageUrl="~/img/TOC_etoolkit.gif" BorderStyle="None" ImageAlign="Bottom" Height="21" Width="89" />
			</td>
			<td valign="top" style="width:100%;"><span class="PageTitle"><asp:Literal id="TitleText" runat="server" Text="- Page Title"></asp:Literal></span></td>
	</tr>
	<tr>
		<td valign="top" colspan="2"><asp:Image id="LineImage" runat="server" Height="1" AlternateText="Horizontal Rule" ImageUrl="~/img/hRule_Red.gif" Width="400" ImageAlign="Top" /></td>
	</tr>
</table>
<br />