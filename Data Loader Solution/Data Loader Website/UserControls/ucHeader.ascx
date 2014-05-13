<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ucHeader.ascx.vb" Inherits="NRC.DataLoader.ucHeader" %>
<table cellpadding="0" cellspacing="0" border="0" style="WIDTH: 760px">
	<tr>
		<td><A id="lnkNRCPicker" href="" runat="server"><IMG id="imgHeaderLeft" src="../Img/NRCPicker/HeaderLeft.gif" border="0" runat="server"></A></td>
		<td WIDTH="282">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td class="HeaderLinks" style="height: 19px"><SPAN class="nrcLanguagePicker"><A id="lnkHome" href="" runat="server">home</A>&nbsp;|&nbsp;<A id="lnkSiteMap" href="" runat="server">site 
								map</A></SPAN></td>
				</tr>
				<tr>
					<td class="HeaderUser"><asp:label id="lblUserName" runat="server" Font-Size="8" Font-Names="Verdana,Arial,Geneva,Helvetica,sans-serif"></asp:label></td>
				</tr>
			</table>
		</td>
		<td></td>
	</tr>
	<TR>
		<TD class="nrcDarkGreen" colSpan="4">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD noWrap width="620">&nbsp;&nbsp; <SPAN id="spnMySolutions" style="CURSOR: hand" runat="server">
							<A id="lnkMySolutions" href="" runat="server"><IMG id="imgMySolutions" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="My Solutions"
									src="../Img/NRCPicker/my_solutions_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="spneReports" style="CURSOR: hand" runat="server">
						<IMG id="Img2" height="23" src="../Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;
						<A id="lnkeReports" href="" runat="server">
						<IMG id="Img3" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="eReports"
									src="../Img/NRCPicker/ereports_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="spneComments" style="CURSOR: hand" runat="server"><IMG id="Img4" height="23" src="../Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkeComments" href="" runat="server"><IMG id="Img5" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="eComments"
									src="../Img/NRCPicker/ecomments_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="spneToolKit" style="CURSOR: hand" runat="server"><IMG id="Img6" height="23" src="../Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkeToolKit" href="" runat="server"><IMG id="Img7" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="eToolKit"
									src="../Img/NRCPicker/etoolkit_off.gif" border="0" runat="server"></A></SPAN>
						<SPAN id="SpnPCCLN" style="CURSOR: hand" runat="server"><IMG id="Img9" height="23" src="../Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkPCCLN" href="" runat="server"><IMG id="Img10" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="Patient-Centered Care Institute"
									src="../Img/NRCPicker/LN_off.gif" border="0" runat="server"></A></SPAN>&nbsp;
						<SPAN id="spnGroups" style="CURSOR: hand" runat="server"><IMG id="Img1" height="23" src="../Img/NRCPicker/header_menu_spacer.gif" width="1" runat="server">&nbsp;<A id="lnkGroups" href="" runat="server"><IMG id="Img8" onmouseover="swapImg(this);" onmouseout="swapImg(this);" alt="My Accounts"
									src="../Img/NRCPicker/my_accounts_off.gif" border="0" runat="server"></A></SPAN>
					</TD>
					<TD class="nrcDarkGreen" vAlign="bottom" align="right" width="140">
						<asp:imagebutton id="btnDummy" runat="server" Height="1px" Width="1px" ImageUrl="../Img/NRCPicker/ghost.gif"
							BorderStyle="None" CausesValidation="False" EnableViewState="False"></asp:imagebutton>
						<asp:imagebutton id="btnSignOut" runat="server" Height="24" ImageUrl="../Img/NRCPicker/signout_off.gif" 
						onmouseover="swapImg(this);" onmouseout="swapImg(this);"
							CausesValidation="False" ></asp:imagebutton>
				    </TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</table>