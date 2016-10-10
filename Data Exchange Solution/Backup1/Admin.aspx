<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Admin.aspx.vb" Inherits="DataExchange.Admin"%>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Picker Data Exchange</title>
		<script language="javascript">
	<!--
		// displays the username
		function buildusername() {
			var initial, lname, stropentext, strdisplay;
			var form = document.Form1;
			stropentext = "User name: ";
			initial = form.txtFName.value.charAt(0);
			lname = form.txtLName.value;
			strdisplay = initial + lname;
			
			if ( strdisplay.length ) {
				strdisplay = stropentext.concat(strdisplay);
			} else {
				strdisplay = "";
			}
			document.getElementById('username').innerHTML = strdisplay;	
		}
		
		function pageinit() {
			buildusername();
			document.Form1.txtFName.focus();
		}
		
		// confirms with the user they want to use the default password if none was entered
		function fillpassword() {
			var form = document.Form1;
			var defpass = document.getElementById("lblDefaultPassword").innerText;		// the default password is contained in this dynamically generated span tag
			var msgbox;
			if ( lrtrim(form.txtPassword.value, " ") == "" ) {
				msgbox = confirm("You have not entered a password.\r\r\nClick \"OK\" to use the default password of \"" + defpass + ".\" \r\r\nClick \"Cancel\" to enter a password.")
				if ( msgbox ) {
					form.txtPassword.value = defpass
					form.txtPasswordConfirm.value = defpass;
				} else {
					form.txtPassword.focus();
					return false;
				}
			}
		}
	// -->
		</script>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script src="globalfunctions.js" language="javascript" type="text/javascript"></script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" onload="pageinit()" rightMargin="0"
		MS_POSITIONING="FlowLayout" marginwidth="0" marginheight="0">
		<form id="Form1" method="post" encType="multipart/form-data" runat="server" onsubmit="return fillpassword();">
		<uc1:ucheader id="UcHeader1" showPassword="true" runat="server"></uc1:ucheader>
		
		<!-- start border -->
<table width="760" cellpadding=0 cellspacing=0 border=0>
<tr>
<td colspan="3"><img src="img/ghost.gif" height="2"></td>
</tr>
<tr>
<td class=nrcBorder colspan="3"><img src="img/ghost.gif" height="2"></td>
</tr>
<tr>
<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
<td>
<!-- start content-->
			<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD>
						<TABLE id="tblContent" cellSpacing="3" cellPadding="3" width="100%" border="0">
							<TR>
								<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
							</TR>
							<TR>
								<TD><STRONG><FONT size="4">NRC Data Transfer Administration Page</FONT></STRONG>&nbsp;
									<HR width="100%" SIZE="1">
								</TD>
							</TR>
							<TR>
								<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
							</TR>
							<tr>
								<td>
									<TABLE class="Login" id="tblLinks" cellSpacing="1" cellPadding="1" width="100%" border="0">
										<tr>
											<td align="center"><FONT size="3"><STRONG>Menu</STRONG></FONT>
											</td>
										</tr>
										<TR>
											<TD><A href="Upload.aspx">Data Upload</A></TD>
										</TR>
										<TR>
											<TD><A href="UploadLog.aspx" target="_Blank">Data Upload Log</A></TD>
										</TR>
										<TR>
											<TD><A href="PostFile.aspx">Post File</A></TD>
										</TR>
										<TR>
											<TD><A href="PostedFileLog.aspx" target="_blank">Posted File Log</A></TD>
										</TR>										
										<TR>
											<TD></TD>
										</TR>
									</TABLE>
								</td>
							</tr>
							<TR>
								<TD>
									<TABLE class="Login" id="tblForm" cellSpacing="1" cellPadding="1" width="100%" border="0">
										<TR>
											<TD noWrap align="center" colSpan="2"><FONT size="3"><STRONG>Create New User</STRONG></FONT></TD>
										</TR>
										<TR>
											<TD noWrap>First Name:</TD>
											<TD width="100%"><asp:textbox id="txtFName" runat="server" onchange="buildusername()"></asp:textbox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="username" style="COLOR: blue"></span>
											</TD>
										</TR>
										<TR>
											<TD noWrap>Last Name:</TD>
											<TD><asp:textbox id="txtLName" runat="server" onchange="buildusername()"></asp:textbox></TD>
										</TR>
										<TR>
											<TD noWrap>Email Address:</TD>
											<TD><asp:textbox id="txtEmail" runat="server"></asp:textbox></TD>
										</TR>
										<TR>
											<TD noWrap>Password:</TD>
											<TD><asp:textbox id="txtPassword" runat="server" TextMode="Password"></asp:textbox>&nbsp;Default:
												<asp:Label id="lblDefaultPassword" runat="server" EnableViewState="False"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD noWrap>Confirm Password:</TD>
											<TD><asp:textbox id="txtPasswordConfirm" runat="server" TextMode="Password"></asp:textbox></TD>
										</TR>
										<TR>
											<TD noWrap>User Type:</TD>
											<TD><asp:radiobuttonlist id="rbUserType" runat="server" RepeatDirection="Horizontal">
													<asp:ListItem Value="Post User" Selected="True">Post User</asp:ListItem>
													<asp:ListItem Value="Admin User">Admin User</asp:ListItem>
												</asp:radiobuttonlist></TD>
										</TR>
										<TR>
											<TD noWrap></TD>
											<TD><asp:button id="btnSubmit" runat="server" Text="Add User"></asp:button><asp:label id="lblNewUserMessage" runat="server" EnableViewState="False"></asp:label></TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			
			<!-- border table -->		
 </td>
<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
</tr>
<tr>
<td class=nrcBorder colspan=3><img src="img/ghost.gif" height="2"></td>
</tr>			
<tr>
<td colspan="3"><img src="img/ghost.gif" height="2"></td>
</tr>					
</table>
<!-- border table -->	

			
			<uc1:ucfooter id="UcFooter1" runat="server"></uc1:ucfooter>
		</form>
	</body>
</HTML>
