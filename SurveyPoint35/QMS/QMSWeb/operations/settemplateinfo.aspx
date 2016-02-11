<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="settemplateinfo.aspx.vb" Inherits="QMSWeb.settemplateinfo"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<p></p>
				<TABLE class="main" align="center" border="0" cellpadding="0" cellspacing="0">
					<TBODY>
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
																<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Set Template Info</td>
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
													<td width="100%" bgColor="#cccccc">
														<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<tr>
																<td class="WritableBG">
																	<asp:ValidationSummary id="vsSummary" runat="server" Width="100%"></asp:ValidationSummary>
																	<table width="100%" border="0" cellpadding="2" cellspacing="0">
																		<tr>
																			<td class="label" align="right" width="20%">Survey Instance</td>
																			<td width="80%"><asp:DropDownList id="ddlSurveyInstanceID" runat="server" CssClass="detselect"></asp:DropDownList>
																				<asp:RequiredFieldValidator id="rfvSurveyInstanceID" runat="server" ErrorMessage="Please select a survey instance"
																					ControlToValidate="ddlSurveyInstanceID" EnableViewState="False">*</asp:RequiredFieldValidator></td>
																		</tr>
																		<tr>
																			<td class="label" align="right">Project ID</td>
																			<td>
																				<asp:TextBox id="tbProjectID" runat="server" CssClass="dettextfield" MaxLength="5"></asp:TextBox>
																				<asp:RequiredFieldValidator id="rfvProjectID" runat="server" ErrorMessage="Please provide a project id" ControlToValidate="tbProjectID"
																					EnableViewState="False">*</asp:RequiredFieldValidator>
																				<asp:RegularExpressionValidator id="rxvProjectID" runat="server" ErrorMessage="Project ID must be 5-digits (00000)"
																					ControlToValidate="tbProjectID" ValidationExpression="\d{5}" EnableViewState="False">*</asp:RegularExpressionValidator></td>
																		</tr>
																		<tr>
																			<td class="label" align="right">FAQSS Template ID</td>
																			<td>
																				<asp:TextBox id="tbFAQSSTemplateID" runat="server" CssClass="dettextfield" MaxLength="8"></asp:TextBox>
																				<asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ErrorMessage="Please provide FAQSS Template ID"
																					ControlToValidate="tbFAQSSTemplateID" EnableViewState="False">*</asp:RequiredFieldValidator>
																				<asp:RegularExpressionValidator id="RegularExpressionValidator2" runat="server" ErrorMessage="FAQSS Template ID must be 8-digits (00000000)"
																					ControlToValidate="tbFAQSSTemplateID" ValidationExpression="[\d\w]{8}" EnableViewState="False">*</asp:RegularExpressionValidator></td>
																		</tr>
																		<tr>
																			<td class="label" align="right">Template ID</td>
																			<td>
																				<asp:TextBox id="tbTemplateID" runat="server" CssClass="dettextfield" MaxLength="5"></asp:TextBox>
																				<asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ErrorMessage="Please provide Template ID"
																					ControlToValidate="tbTemplateID" EnableViewState="False">*</asp:RequiredFieldValidator>
																				<asp:RegularExpressionValidator id="RegularExpressionValidator3" runat="server" ErrorMessage="Template ID must be 5-digits (00000)"
																					ControlToValidate="tbTemplateID" ValidationExpression="[\w\d]{5}" EnableViewState="False">*</asp:RegularExpressionValidator></td>
																		</tr>
																		<tr>
																			<td>&nbsp;</td>
																			<td>
																				<asp:ImageButton id="ibExecute" runat="server" ImageUrl="../images/qms_execute_btn.gif" EnableViewState="False"></asp:ImageButton></td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</TABLE>
							</td>
						</tr>
					</TBODY>
				</TABLE>			
		</form>		
	</body>
</HTML>
