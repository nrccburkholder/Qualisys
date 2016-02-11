<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="userdetails.aspx.vb" Inherits="QMSWeb.frmUserDetails" smartNavigation="True"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
			<p>
				<TABLE class="main" align="center">
					<tr>
						<td>
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<tr>
									<td>
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;User Details</td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
										<!-- END TITLE AND TABLE HEADING TABLE -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#f0f0f0">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<asp:ValidationSummary id="vsUserDetails" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0">
																	<TR valign="top">
																		<TD class="label" align="right" width="100">ID</TD>
																		<TD><asp:label id="lblUserID" runat="server">Label</asp:label></TD>
																		<TD align="right" colspan="2"><asp:checkbox id="cbActive" runat="server" ToolTip="Check to allow user to access system" Font-Bold="True"
																				Text="Active User"></asp:checkbox></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">First Name</TD>
																		<TD><asp:textbox id="tbFirstName" runat="server" MaxLength="100" Width="150px" CssClass="dettextfield"></asp:textbox>&nbsp;</TD>
																		<TD class="label" align="right">Last Name</TD>
																		<TD><asp:textbox id="tbLastName" runat="server" MaxLength="100" Width="150px" CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvLastName" runat="server" ControlToValidate="tbLastName" ErrorMessage="Please provide last name">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Username</TD>
																		<TD colspan="3"><asp:textbox id="tbUsername" runat="server" ToolTip="Account sign-in name" MaxLength="100" Width="150px"
																				CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvUsername" runat="server" ControlToValidate="tbUsername" ErrorMessage="Please provide an username">*</asp:requiredfieldvalidator>
																		</TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">New Password</TD>
																		<TD colspan="3"><asp:textbox id="tbPassword" runat="server" Width="150px" ToolTip="Changes sign-in password"
																				MaxLength="20" TextMode="Password" CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvPassword" runat="server" ControlToValidate="tbPassword" ErrorMessage="Please provide a password"
																				Enabled="False">*</asp:requiredfieldvalidator><BR>
																			<asp:textbox id="tbVerify" runat="server" Width="150px" ToolTip="Confirm password change" MaxLength="20"
																				TextMode="Password" CssClass="dettextfield"></asp:textbox>
																			<asp:comparevalidator id="cvVerifyPassword" runat="server" ControlToValidate="tbPassword" ErrorMessage="Confirm password must match. Please correct passwords"
																				ControlToCompare="tbVerify">*</asp:comparevalidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Email</TD>
																		<TD colspan="3"><asp:textbox id="tbEmail" runat="server" MaxLength="100" Width="150px" CssClass="dettextfield"></asp:textbox></TD>
																	</TR>
																	<TR>
																		<TD class="label" align="right">Verification Rate</TD>
																		<TD colSpan="3">
																			<asp:textbox id="tbVerificationRate" runat="server" CssClass="detnumberfield" MaxLength="10"></asp:textbox>
																			<asp:RangeValidator id="rngVerificationRate" runat="server" ErrorMessage="Verification Rate must between 0 and 100"
																				ControlToValidate="tbVerificationRate" MaximumValue="100" MinimumValue="0" Type="Integer">*</asp:RangeValidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Group</TD>
																		<TD colspan="3"><asp:dropdownlist id="ddlUserGroups" runat="server" DataValueField="GroupID" DataTextField="Name"
																				CssClass="detselect"></asp:dropdownlist>
																			<asp:comparevalidator id="cvGroupID" runat="server" ControlToValidate="ddlUserGroups" ErrorMessage="Please select a group"
																				ValueToCompare="0" Operator="GreaterThan">*</asp:comparevalidator></TD>
																	</TR>
																	<TR>
																		<td>&nbsp;</td>
																		<td colspan="3">
																			<P>
																				<asp:ImageButton id="ibSave" runat="server" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:HyperLink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif" EnableViewState="False"
																					NavigateUrl="users.aspx">Exit without saving changes</asp:HyperLink></P>
																		</td>
																	</TR>
																</TABLE>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
														</tr>
													</table>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
