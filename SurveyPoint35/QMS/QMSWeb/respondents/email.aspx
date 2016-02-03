<%@ Register TagPrefix="uc1" TagName="HTMLEditor" Src="../HTMLEdit/HTMLEditor.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="email.aspx.vb" Inherits="QMSWeb.frmEmail" %>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
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
		<form id="Form1" method="post" encType="multipart/form-data" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
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
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Email Respondents&nbsp;</td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsExecuteImportExport" runat="server" Width="100%"></asp:validationsummary>
																<TABLE cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<TR vAlign="top">
																		<TD class="label" align="right" width="100">Protocol Step</TD>
																		<TD><asp:dropdownlist id="ddlProtocolStepID" runat="server" CssClass="sfselect" AutoPostBack="True"></asp:dropdownlist></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right" width="100">Email Message</TD>
																		<TD><uc1:htmleditor id="htmlEmailBody" runat="server"></uc1:htmleditor></TD>
																	</TR>
																	<TR>
																		<TD class="label" align="right" width="100">Email Server</TD>
																		<TD><asp:textbox id="tbSMTPServer" runat="server" Width="216px" CssClass="sftextfield"></asp:textbox><asp:requiredfieldvalidator id="rfvSmtpServer" runat="server" ErrorMessage="Please provide an email server"
																				ControlToValidate="tbSMTPServer" Display="Dynamic">*</asp:requiredfieldvalidator><asp:regularexpressionvalidator id="revSmtpServer" runat="server" ErrorMessage="Invalid email server value" ControlToValidate="tbSMTPServer"
																				ValidationExpression="\w+([-+.]\w+)*\.\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic">*</asp:regularexpressionvalidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" align="right" width="100">Test Email</TD>
																		<TD><asp:textbox id="tbTestEmailAddress" runat="server" Width="216px" CssClass="sftextfield"></asp:textbox><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid test email address"
																				ControlToValidate="tbTestEmailAddress" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic">*</asp:regularexpressionvalidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" align="right" width="100"></TD>
																		<TD>
																			<asp:ImageButton id="ibExecute" runat="server" ImageUrl="../images/qms_execute_btn.gif" ToolTip="Send emails to all respondents"></asp:ImageButton>
																			<asp:ImageButton id="ibTest" runat="server" ImageUrl="../images/qms_test_btn.gif" ToolTip="Send test email to test email address"></asp:ImageButton>
																			<asp:HyperLink id="hlDone" runat="server" ImageUrl="../images/qms_done_btn.gif" NavigateUrl="../default.aspx">HyperLink</asp:HyperLink></TD>
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
					<tr>
						<td>
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<TR>
												<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
											</TR>
											<TR>
												<TD bgColor="#d7d7c3" rowSpan="2">
													<TABLE cellSpacing="0" cellPadding="1" border="0">
														<TR>
															<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Email Filters</TD>
														</TR>
													</TABLE>
												</TD>
												<TD vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
												<TD class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
											</TR>
											<TR>
												<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
											</TR>
											<TR>
												<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
											</TR>
										</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
										<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<TR>
												<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												<TD width="100%" bgColor="#cccccc">
													<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<TR>
															<TD><!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<TABLE cellSpacing="0" cellPadding="0" border="0">
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR>
																					<TD class="label" align="right" width="170">Survey Instance</TD>
																					<TD>
																						<asp:DropDownList id="ddlSurveyInstanceIDExport" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																					<TD>
																						<asp:CheckBox id="cbActive" runat="server" CssClass="sfcheckbox" Font-Bold="True" Text="Active"
																							Checked="True"></asp:CheckBox></TD>
																					<TD align="right">
																						<asp:Button id="btnGetCount" runat="server" CssClass="button" Text="Get Count" ToolTip="Returns respondent count for selected filters without executing export"></asp:Button></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR vAlign="top">
																					<TD class="label" align="right" width="170">Survey Instance Date</TD>
																					<TD><SPAN style="FONT-SIZE: 10px">After</SPAN>
																						<BR>
																						<asp:TextBox id="tbSurveyInstanceDateAfter" runat="server" CssClass="sfdatefield" ToolTip="Filter by survey instance specific date or later"
																							MaxLength="10"></asp:TextBox>
																						<asp:CompareValidator id="cvSurveyInstanceDateAfter" runat="server" ErrorMessage="Survey instance after date must be in mm/dd/yyyy format"
																							ControlToValidate="tbSurveyInstanceDateAfter" Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator></TD>
																					<TD><SPAN style="FONT-SIZE: 10px">Before</SPAN>
																						<BR>
																						<asp:TextBox id="tbSurveyInstanceDateBefore" runat="server" CssClass="sfdatefield" ToolTip="Filter by survey instance date or earlier"
																							MaxLength="10"></asp:TextBox>
																						<asp:CompareValidator id="cvSurveyInstanceDateBefore" runat="server" ErrorMessage="Survey instance before date must be in mm/dd/yyyy format"
																							ControlToValidate="tbSurveyInstanceDateBefore" Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator></TD>
																					<TD>
																						<asp:CheckBox id="cbIncludeMailingSeeds" runat="server" CssClass="sfcheckbox" Font-Bold="True"
																							Text="Include Mailing Seeds" ToolTip="Check to include survey instance mailing seeds in export"></asp:CheckBox></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR>
																					<TD class="label" align="right" width="170">Survey</TD>
																					<TD>
																						<asp:DropDownList id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:DropDownList>
																						<asp:CompareValidator id="cvSurveyID" runat="server" ErrorMessage="Please select a survey" ControlToValidate="ddlSurveyID"
																							Operator="GreaterThan" Type="Integer" ValueToCompare="0">*</asp:CompareValidator></TD>
																					<TD class="label" align="right">Client</TD>
																					<TD>
																						<asp:DropDownList id="ddlClientID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR vAlign="top">
																					<TD class="label" align="right" width="170">Event</TD>
																					<TD>
																						<asp:DropDownList id="ddlEventIDFilter" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																					<TD class="label" align="right">Event Date</TD>
																					<TD><SPAN style="FONT-SIZE: 10px">After</SPAN>
																						<BR>
																						<asp:TextBox id="tbEventDateAfter" runat="server" CssClass="sfdatefield" ToolTip="Filter by event date date or later"
																							MaxLength="10"></asp:TextBox>
																						<asp:CompareValidator id="cvEventDateAfter" runat="server" ErrorMessage="Event after date must be in mm/dd/yyyy format"
																							ControlToValidate="tbEventDateAfter" Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator></TD>
																					<TD><SPAN style="FONT-SIZE: 10px">Before</SPAN>
																						<BR>
																						<asp:TextBox id="tbEventDateBefore" runat="server" CssClass="sfdatefield" ToolTip="Filter by event date or earlier"
																							MaxLength="10"></asp:TextBox>
																						<asp:CompareValidator id="cvEventDateBefore" runat="server" ErrorMessage="Event before date must be in mm/dd/yyyy format"
																							ControlToValidate="tbEventDateBefore" Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR vAlign="top">
																					<TD class="label" align="right" width="170">Batch Numbers</TD>
																					<TD>
																						<asp:TextBox id="tbBatchIDs" runat="server" Width="404px" CssClass="sftextfield" ToolTip="Filter by comma delimited list of batch ids"></asp:TextBox>
																						<asp:RegularExpressionValidator id="revBatchIDs" runat="server" ErrorMessage="Batch numbers must be numeric values separated by commas"
																							ControlToValidate="tbBatchIDs" ValidationExpression="^(\d+, ?)*\d+$">*</asp:RegularExpressionValidator></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR vAlign="top">
																					<TD class="label" align="right" width="170">Other Filters</TD>
																					<TD>
																						<asp:DropDownList id="ddlFileDefFilterID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																	<TR>
																		<TD>
																			<TABLE cellSpacing="0" cellPadding="5" border="0">
																				<TR vAlign="top">
																					<TD class="label" align="right" width="170">Finals</TD>
																					<TD>
																						<asp:DropDownList id="ddlFinal" runat="server" CssClass="sfselect">
																							<asp:ListItem Value="">None</asp:ListItem>
																							<asp:ListItem Value="0">Exclude Finals</asp:ListItem>
																							<asp:ListItem Value="1">Only Finals</asp:ListItem>
																						</asp:DropDownList></TD>
																				</TR>
																			</TABLE>
																		</TD>
																	</TR>
																</TABLE> <!-- END SEARCH FORM AND FIELDS TABLE --></TD>
														</TR>
													</TABLE>
												</TD>
												<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
											</TR>
											<TR>
												<TD class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</td>
					</tr>
				</TABLE>
			</p>
			<p>&nbsp;</p>
		</form>
	</body>
</HTML>
