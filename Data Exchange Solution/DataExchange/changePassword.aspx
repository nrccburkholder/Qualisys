<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="changePassword.aspx.vb" Inherits="DataExchange.changePassword"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Picker Data Exchange</title>
		<script src="globalfunctions.js" language="javascript" type="text/javascript"></script>
		<script language="javascript">
		<!-- 
		// validates form before submitting
		function validateform ( form ) {
			// settings
			var minlength = 6;
			// fields to validate
			var pword = form.txtPassword;
			var pcword = form.txtConfirmPassword;
			// make sure passwords match
			if ( pword.value.toLowerCase() != pcword.value.toLowerCase() ) {
				window.alert( "The passwords do not match." );
				pcword.value = "";
				pcword.focus();
				return false;
			} 
			
			if ( pword.value.length < minlength ) {
				// make sure password is the minimum length
				window.alert("Your new password is too short.\r\r\n Please enter a password of at least " + minlength + " characters.");
				pword.value = "";
				pcword.value = "";
				return false;
			}
			
			if ( pword.value.toLowerCase() == <asp:Literal id="defaultpword" runat="server" Visible="true"></asp:literal> ) {
				window.alert("The password you have is invalid and/or contains special characters.");
				return false;
			}
			return true;
		}
		// -->
		</script>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginheight="0" marginwidth="0"
		MS_POSITIONING="FlowLayout" runat="server">
		<form id="frmpassword" method="post" runat="server" onsubmit="return validateform( this );">
			<uc1:ucHeader id="UcHeader1" loginpage="false" runat="server"></uc1:ucHeader>
			<!-- start border -->
			<table width="760" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
					<td>
						<!-- start content-->
						<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD>
									<asp:Label id="lblMessage" runat="server" ForeColor="Red" Visible="False"></asp:Label></TD>
							</TR>
							<TR>
								<TD align="center">
									<TABLE id="tblLogin" cellSpacing="4" cellPadding="1" border="0">
										<TR>
											<TD colSpan="2" align="right">
												<TABLE class="Login" id="Table1" cellSpacing="1" cellPadding="1" border="0">
													<TR>
														<TD colSpan="2">
															<P><FONT size="2"> Enter your new password.<br>
																	Passwords must be at least 6 characters.</FONT></P>
														</TD>
													</TR>
													<TR>
														<TD colSpan="2"><hr>
														</TD>
													</TR>
													<TR>
														<TD><STRONG><FONT size="2">New Password:</FONT></STRONG></TD>
														<TD>
															<asp:TextBox id="txtPassword" onchange="autotrim(this, ' ')" runat="server" Width="100px" TextMode="Password"></asp:TextBox></TD>
													</TR>
													<TR>
														<TD><STRONG><FONT size="2">Confirm Password:</FONT></STRONG></TD>
														<TD>
															<asp:TextBox id="txtConfirmPassword" onchange="autotrim(this, ' ')" runat="server" TextMode="Password"
																Width="100px"></asp:TextBox></TD>
													</TR>
													<TR>
														<TD align="right" colSpan="2">
															<asp:Button id="btnChangePassword" runat="server" Text="Change Password"></asp:Button></TD>
													</TR>
												</TABLE>
											</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
						</TABLE>
						<!-- border table --></td>
					<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
			</table>
			<!-- border table -->
			<uc1:ucFooter id="UcFooter1" runat="server" showlogoff="true"></uc1:ucFooter>
		</form>
		<asp:Literal id="litJScript" runat="server" Visible="false">
			<SCRIPT language="javascript">
		window.alert("Your password has been changed.\r\r\nUse your new password the next time you log onto the system.");
		document.location = "postfile.aspx";
			</SCRIPT>
		</asp:Literal>
	</body>
</HTML>
