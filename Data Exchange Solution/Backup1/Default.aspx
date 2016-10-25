<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Default.aspx.vb" Inherits="DataExchange._Default"%>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Picker Data Exchange</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
		<script language="javascript">
			function initPage(){
				document.forms[0].txtUserName.focus();
				CookiesEnabled();
			}
			function UserNameChanged(userName) {
				if (userName.toLowerCase() == 'anonymous'){
					document.forms[0].txtPassword.style.display = 'none';
					document.forms[0].txtEMail.style.display = '';
					document.forms[0].txtEMail.value = '';
					document.forms[0].txtEMail.focus();
				}
				else {
					document.forms[0].txtPassword.style.display = '';
					document.forms[0].txtEMail.style.display = 'none';
					document.forms[0].txtPassword.value = '';
					document.forms[0].txtPassword.focus();
				}
			}
		</script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginheight="0" marginwidth="0"
		MS_POSITIONING="FlowLayout" onload="initPage();">
		<form id="Form1" method="post" runat="server">
			<uc1:ucHeader id="UcHeader1" loginpage="true" runat="server"></uc1:ucHeader>
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
						<TABLE id="tblBody" cellSpacing="1" cellPadding="5" width="756" border="0">
							<TR>
								<TD align="left"><table cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td valign="bottom"><IMG runat="server" id="imgDataExchange" alt="Data Exchange Logo" src="Img/TOCDataExchangeUS.jpg"
													border="0">
											</td>
										</tr>
										<tr>
											<td valign="top"><IMG height="1" alt="Horizontal Rule" hspace="0" src="IMG/hRule_Red.gif" width="400"
													align="top"></td>
										</tr>
									</table>
								</TD>
							</TR>
							<tr>
								<td align="center"><br>
									<div id="LoginControl" style="BORDER-BOTTOM:#e6e2d8 1px solid; BORDER-LEFT:#e6e2d8 1px solid; BACKGROUND-COLOR:#f7f6f3; WIDTH:250px; COLOR:#333333; BORDER-TOP:#e6e2d8 1px solid; BORDER-RIGHT:#e6e2d8 1px solid">
										<table id="tblLoginControl" cellspacing="0" border="0" style="WIDTH:100%;BORDER-COLLAPSE:collapse">
											<tr>
												<td align="center" colspan="2" style="BACKGROUND-COLOR:#318991;COLOR:white;FONT-WEIGHT:bold">Data 
													Exchange&nbsp;Sign In</td>
											</tr>
											<tr>
												<td align="center" colspan="2" style="FONT-STYLE:italic;FONT-SIZE:xx-small"><span id="LoginControl2_lblInstructions">Please 
														enter your user name and password.</span></td>
											</tr>
											<tr>
												<td align="center" colspan="2"><asp:Label id="lblMessage" runat="server" ForeColor="Red"></asp:Label>
													<asp:RegularExpressionValidator id="vldEmail" runat="server" Display="Dynamic" ControlToValidate="txtEMail" ErrorMessage="You must enter a valid email address!"
														EnableClientScript="False" ValidationExpression="^([0-9a-zA-Z]+['-._+&amp;amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$"></asp:RegularExpressionValidator></td>
											</tr>
											<tr>
												<td align="right">User:</td>
												<td>
													<asp:TextBox id="txtUserName" runat="server" Columns="20" Width="175px"></asp:TextBox>
													<asp:RequiredFieldValidator id="vldUserName" runat="server" ErrorMessage="*" ToolTip="You must enter a user name!"
														ControlToValidate="txtUserName" Display="Dynamic"></asp:RequiredFieldValidator></td>
											</tr>
											<tr>
												<td align="right">Password:</td>
												<td>
													<asp:TextBox id="txtEMail" runat="server" Columns="20" Width="175px"></asp:TextBox>
													<asp:TextBox id="txtPassword" runat="server" Columns="22" TextMode="Password" Width="175px"></asp:TextBox></td>
											</tr>
											<tr>
												<td align="right" colspan="2">
													<asp:Button id="btnLogin" runat="server" Text="Sign In"></asp:Button></td>
											</tr>
										</table>
									</div>
									<br>
									<!---
									<asp:Literal id="ltlVerisign" runat="server"></asp:Literal><br>
									<asp:Literal id="ltlScanAlert" runat="server"></asp:Literal><br>
									--->
									<br>
								</td>
							</tr>
						</TABLE>
						<!-- border table -->
					</td>
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
			<uc1:ucFooter id="UcFooter1" runat="server" showlogoff="false"></uc1:ucFooter>
		</form>
	</body>
</HTML>
