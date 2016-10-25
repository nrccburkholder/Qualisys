<%@ Control Language="vb" AutoEventWireup="false" Codebehind="ucHeader.ascx.vb" Inherits="DataExchange.ucHeader" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<script language="javascript" src="header.js"></script>
<table cellpadding="0" cellspacing="0" border="0" style="WIDTH: 760px">
	<tr>
		<td><A id="lnkNRCPicker" href="" runat="server"><IMG runat="server" id="imgHeaderLeft" src="Img/NRCPicker/HeaderLeftUS.gif" border="0"></A></td>
		<td WIDTH="282">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td class="HeaderLinks">
						<span id="homeLink" runat="server" class="nrcLanguagePicker"><a href="" runat="server" id="lnkHome">
								home</a> | </span><span class="nrcLanguagePicker"><a href="feedback.aspx">feedback</a>
							| </span><span id="password" runat="server" class="nrcLanguagePicker"><a href="changePassword.aspx">
								password</a></span>
					</td>
				</tr>
				<tr>
					<td class="HeaderUser"></td>
				</tr>
			</table>
		</td>
		<td></td>
	</tr>
	<TR>
		<TD class="nrcDarkGreen" colSpan="4">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD noWrap width="570" style="WIDTH: 570px">&nbsp;&nbsp; <SPAN id="spnSolutions" style="CURSOR: hand" runat="server">
							<A id="lnkSolutions" href="" runat="server"><IMG id="imgSolutions" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="My Solutions"
									src="Img/NRCPicker/my_solutions_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="spneReports" style="CURSOR: hand" runat="server"><IMG id="Img2" height="23" src="Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkeReports" href="" runat="server"><IMG id="Img3" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="eReports"
									src="Img/NRCPicker/eReports_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="spneComments" style="CURSOR: hand" runat="server"><IMG id="Img4" height="23" src="Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkeComments" href="" runat="server"><IMG id="Img5" alt="eComments" src="Img/NRCPicker/eComments_off.gif" border="0" runat="server"></A></SPAN>
						<!---
						<SPAN id="spneToolKit" style="CURSOR: hand" runat="server"><IMG id="Img6" height="23" src="Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkeToolKit" href="" runat="server"><IMG id="Img7" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="eToolKit"
									src="Img/NRCPicker/eToolKit_off.gif" border="0" runat="server"></A></SPAN>
						--->
						<!---
						<SPAN id="spnLN" style="CURSOR: hand" runat="server"><IMG id="Img15" height="23" src="Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkLN" href="" runat="server"><IMG id="Img16" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="Patient-Centered Care Institute"
									src="Img/NRCPicker/LN_off.gif" border="0" runat="server"></A></SPAN>
						--->
						<SPAN id="spnAccount" style="CURSOR: hand" runat="server"><IMG id="Img1" height="23" src="Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkAccount" href="" runat="server"><IMG id="Img8" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="My Accounts"
									src="Img/NRCPicker/my_accounts_off.gif" border="0" runat="server"></A></SPAN>
					</TD>
					<TD class="nrcDarkGreen" vAlign="bottom" align="right" width="230">
						<table cellpadding="0" cellspacing="0" runat="server" id="tblLogout">
							<tr>
								<td><a href="logoff.aspx" onmouseover="swapImg(document.signout, 'signout_on');" onmouseout="swapImg(document.signout, 'signout_off');"><img src="img/signout_off.gif" height="24" border="0" name="signout"></a>
								</td>
							</tr>
						</table>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</table>
