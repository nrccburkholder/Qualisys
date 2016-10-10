<%@ Control Language="vb" AutoEventWireup="false" Codebehind="ucFooter.ascx.vb" Inherits="DataExchange.ucFooter" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<table border="0" cellpadding="0" cellspacing="0" width="760">
	<tr>
		<td><img alt="" src="img/ghost.gif" border="0" height="10"></td>
	</tr>
	<tr>
		<td class="nrcDarkGreen" align="right"><img alt="" src="img/ghost.gif" border="0" height="8"></td>
	</tr>
	<tr>
		<td><img alt="" src="img/ghost.gif" border="0" height="5"></td>
	</tr>
	<tr>
		<td width="100%">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td><img src="img/ghost.gif" width="3" hspace="0" vspace="0">
					</td>
					<td align="left" valign="top" class="nrcFooterText"><A href="javascript: void newWin('<%=PrivacyLocale()%>', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=590,height=500,resizable=1')">PRIVACY 
							POLICY</A>&nbsp;</td>
					<!--<td align="right" class="nrcFooterText" nowrap valign="top"><img alt="Arrow" src="img/footer_arrow.gif" border="0">
						<a href="javascript: void newWin('terms.aspx', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=590,height=500,resizable=1')">
							TERMS &amp; CONDITIONS</a>
					</td>-->
					<td class="nrcFooterText" align="right" nowrap valign="top">&nbsp;&nbsp;&nbsp;©
						<asp:Label id="datCopyRight" runat="server"></asp:Label>
						<%=BrandName()%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
