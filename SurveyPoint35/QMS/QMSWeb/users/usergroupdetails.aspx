<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="usergroupdetails.aspx.vb" Inherits="QMSWeb.frmUserGroupDetails" smartNavigation="True"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<style type="text/css">
			.privledge_name { FONT-WEIGHT: bold }
			.privledge_desc { FONT-SIZE: 10pt; FONT-STYLE: italic }
		</style>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;User Group Details</td>
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
																<asp:ValidationSummary id="vsUserGroupDetails" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0">
																	<TR valign="top">
																		<TD class="label" align="right" width="100">ID</TD>
																		<TD><asp:label id="lblUserGroupID" runat="server"></asp:label></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Name</TD>
																		<TD><asp:textbox id="tbGroupName" runat="server" Width="350px" MaxLength="100" CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvGroupName" runat="server" ErrorMessage="Please provide user group name" ControlToValidate="tbGroupName">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Description</TD>
																		<TD><asp:textbox id="tbGroupDesc" runat="server" Width="350px" Rows="5" TextMode="MultiLine" MaxLength="100"
																				CssClass="dettextfield"></asp:textbox></TD>
																	</TR>
																	<TR>
																		<TD class="label" align="right">Verification Rate</TD>
																		<TD>
																			<asp:TextBox id="tbVerificationRate" runat="server" CssClass="detnumberfield" MaxLength="10"></asp:TextBox>
																			<asp:RequiredFieldValidator id="rfvVerificationRate" runat="server" ControlToValidate="tbVerificationRate" ErrorMessage="Please provide verification rate"
																				EnableViewState="False" Display="Dynamic">*</asp:RequiredFieldValidator>
																			<asp:RangeValidator id="rngvVerificationRate" runat="server" ControlToValidate="tbVerificationRate"
																				ErrorMessage="Verification rate must be between 0 and 100" EnableViewState="False" Type="Integer"
																				MaximumValue="100" MinimumValue="0">*</asp:RangeValidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Privledges</TD>
																		<TD><asp:checkboxlist id="cblGroupPrivledges" runat="server" DataTextField="Name" DataValueField="EventID"
																				ToolTip="Check to give user group privledge" CssClass="detcheckbox"></asp:checkboxlist></TD>
																	</TR>
																	<tr valign="top">
																		<td>&nbsp;</td>
																		<td>
																			<P>
																				<asp:ImageButton id="ibSave" runat="server" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:HyperLink id="hlDone" runat="server" ImageUrl="../images/qms_done_btn.gif" EnableViewState="False"
																					NavigateUrl="usergroups.aspx">Exit without saving changes</asp:HyperLink></P>
																		</td>
																	</tr>
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
