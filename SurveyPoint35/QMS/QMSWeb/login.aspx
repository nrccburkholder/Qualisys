<%@ Page Language="vb" AutoEventWireup="false" Codebehind="login.aspx.vb" Inherits="QMSWeb.frmLogin" smartNavigation="False" enableViewState="False"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body onload="document.login.tbEmail.focus();" style="background-color: #333333">
		<!-- BEGIN HEADER -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td rowspan="2" width="241">
					<table width="241" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td rowspan="3" bgcolor="#990000" width="1"><img src="images/clear.gif" width="1" height="1"></td>
							<td><img src="images/surveytracker_header.gif" width="241" height="39"></td>
						</tr>
						<tr>
							<td height="1" bgcolor="#990000"><img src="images/clear.gif" width="1" height="1"></td>
						</tr>
					</table>
				</td>
				<td bgcolor="#000099"><img src="images/clear.gif" width="1" height="18"></td>
			</tr>
			<tr>
				<td width="100%">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td width="100%" background="images/header-bg.gif"><img src="images/clear.gif" width="4" height="22"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<!-- END HEADER -->
		<form id="login" method="post" runat="server">
			<P>&nbsp;</P>
			<table width="350" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
						<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td rowspan="4" class="bordercolor" width="1"><img src="images/clear.gif" width="1" height="1"><img src="images/clear.gif" width="1" height="1"></td>
								<td colspan="3"><img src="images/clear.gif" width="1" height="1"></td>
								<td rowspan="4" width="1"><img src="images/clear.gif" width="1" height="1"><img src="images/clear.gif" width="1" height="1"></td>
							</tr>
							<tr>
								<td rowspan="2" bgcolor="#d7d7c3">
									<table border="0" cellspacing="0" cellpadding="1">
										<tr>
											<td NOWRAP class="pagetitle"><!-- PAGE TITLE --> &nbsp;Sign In <!-- END PAGE TITLE --></td>
										</tr>
									</table>
								</td>
								<td rowspan="2" width="22" valign="top"><img src="images/tableheader.gif" width="22" height="21"></td>
								<td width="100%"><img src="images/clear.gif" width="1" height="18"></td>
							</tr>
							<tr>
								<td bgcolor="#d7d7c3" width="100%"><img src="images/clear.gif" width="1" height="3"></td>
							</tr>
							<tr>
								<td colspan="3" class="bordercolor"><img src="images/clear.gif" width="1" height="1"></td>
							</tr>
						</table>
						<!-- END TITLE AND TABLE HEADING TABLE -->
						<table width="350" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td class="bordercolor" width="1"><img src="images/clear.gif" width="1" height="1"></td>
								<td width="349" bgcolor="#f0f0f0">
									<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
										<tr>
											<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
												<asp:ValidationSummary id="vsLogin" runat="server" Width="100%" EnableViewState="False"></asp:ValidationSummary>
												<table border="0" cellspacing="0" cellpadding="5">
													<tr>
														<td align="right" class="label" width="40%">Username:</td>
														<td width="60%">&nbsp;<asp:textbox id="tbEmail" runat="server" Font-Size="12pt" Width="150px" CssClass="sftextfield"></asp:textbox><asp:requiredfieldvalidator id="rfvEmail" runat="server" ControlToValidate="tbEmail" ErrorMessage="Username required">*</asp:requiredfieldvalidator>
														</td>
													</tr>
													<tr>
														<td align="right" class="label" height="40" width="40%">Password:</td>
														<td height="40" width="60%">&nbsp;<asp:textbox id="tbPassword" runat="server" Font-Size="12pt" Width="150px" TextMode="Password" CssClass="sftextfield"></asp:textbox><asp:requiredfieldvalidator id="rfvPassword" runat="server" ControlToValidate="tbPassword" ErrorMessage="Password required">*</asp:requiredfieldvalidator>
														</td>
													</tr>
													<tr>
														<td align="right" width="40%">&nbsp;</td>
														<td width="60%">&nbsp;<asp:button id="cmdSignin" runat="server" Text="Sign In" CssClass="button" EnableViewState="False"></asp:button>
														</td>
													</tr>
												</table>
												<asp:CustomValidator id="cuvValidateLogin" runat="server" OnServerValidate="ValidateLogin" ErrorMessage="Invalid username password combination" Display="None" EnableClientScript="false"></asp:CustomValidator>
												<!-- END SEARCH FORM AND FIELDS TABLE -->
											</td>
										</tr>
										<tr>
										    <td class="WritableBG" align="center">
										        <b>DAILY HOURS OF OPERATION</b>
										    </td>										    
										</tr>
										<tr><td class="WritableBG" align="center"><b>(All times are Central Time Zone)</b></td></tr>
										<tr>
										    <td class="WritableBG">
										        <table border="0" cellpadding="0" cellspacing="0" width="100%">
										            <tr>
										                <td align="left" style="padding:2px" width="50%"><b>Operating Hours:</b></td>
										                <td align="right" style="padding:2px" width="50%"><b>5:00 am to Midnight</b></td>
										            </tr>
										            <tr><td colspan="2">&nbsp;</td></tr>
										            <tr>
										                <td align="left" style="padding:2px" width="50%"><b>Maintenance:</b></td>
										                <td align="right" style="padding:2px" width="50%"><b>Midnight to 5:00 am</b></td>
										            </tr>
										        </table>
										    </td>
										</tr>
                                        <tr>
                                            <td class="WritableBG" align="center">
                                                <span style="text-align: center; font-weight: bold">This system should only be accessed by authorized users</span>
                                            </td>
                                        </tr>
									</table>
								</td>
								<td class="bordercolor" width="1"><img src="images/clear.gif" width="1" height="1"></td>
							</tr>
							<tr>
								<td colspan="3" class="bordercolor" width="600"><img src="images/clear.gif" width="1" height="1"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
