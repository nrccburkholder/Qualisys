<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="surveyinstancedetails.aspx.vb" Inherits="QMSWeb.frmSurveyInstanceDetails" %>
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
												<td colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Survey Instance Details</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsSurveyInstanceDetails" runat="server" Width="100%"></asp:validationsummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0">
																	<TR vAlign="top">
																		<TD class="label" align="right">Survey Instance ID</TD>
																		<td><asp:label id="lblSurveyInstanceID" runat="server"></asp:label></td>
																		<TD class="label" noWrap align="right">Category</TD>
																		<td class="label"><asp:dropdownlist id="ddlSurveyInstanceCategoryID" runat="server" CssClass="sfselect" DataValueField="SurveyInstanceCategoryID"
																				DataTextField="SurveyInstanceCategoryName"></asp:dropdownlist></td>
																		<td class="label" align="right"><asp:checkbox id="cbActive" runat="server" CssClass="detcheckbox" Font-Bold="True" Text="Active"></asp:checkbox></td>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Survey Name</TD>
																		<TD><asp:hyperlink id="hlSurveyDetails" runat="server" ToolTip="View survey details" NavigateUrl="../surveys/surveydetails.aspx">Details</asp:hyperlink><asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:dropdownlist><asp:requiredfieldvalidator id="rfvSurveyID" runat="server" InitialValue="0" ControlToValidate="ddlSurveyID"
																				ErrorMessage="Please select a survey">*</asp:requiredfieldvalidator></TD>
																		<td class="label" align="right">Client Name</td>
																		<td colSpan="2"><asp:hyperlink id="hlClientDetails" runat="server" ToolTip="View client details" NavigateUrl="../clients/clientdetails.aspx">Details</asp:hyperlink><asp:dropdownlist id="ddlClientID" runat="server" CssClass="sfselect"></asp:dropdownlist><asp:requiredfieldvalidator id="rfvClientID" runat="server" InitialValue="0" ControlToValidate="ddlClientID"
																				ErrorMessage="Please select a client">*</asp:requiredfieldvalidator></td>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Survey Instance Name</TD>
																		<TD><asp:textbox id="tbName" runat="server" Width="150px" CssClass="dettextfield" MaxLength="100"></asp:textbox><asp:requiredfieldvalidator id="rfvName" runat="server" ControlToValidate="tbName" ErrorMessage="Please provide a survey instance name">*</asp:requiredfieldvalidator></TD>
																		<TD class="label" align="right">Protocol</TD>
																		<TD><asp:dropdownlist id="ddlProtocolID" runat="server" CssClass="detselect" AutoPostBack="True" DataValueField="ProtocolID"
																				DataTextField="Name"></asp:dropdownlist></TD>
																		<td><asp:hyperlink id="hlProtocolDetails" runat="server" ToolTip="View protocol details" NavigateUrl="../protocols/protocoldetails.aspx"
																				ImageUrl="../images/qms_view1_sym.gif" Font-Size="8pt">Details</asp:hyperlink><asp:comparevalidator id="cvProtocolID" runat="server" ControlToValidate="ddlProtocolID" ErrorMessage="Please select a protocol"
																				Operator="GreaterThan" ValueToCompare="0" Type="Integer">*</asp:comparevalidator></td>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Survey Instance Date</TD>
																		<TD><asp:calendar id="cdrInstanceDate" runat="server" ToolTip="Date associated with survey instances"
																				Font-Size="8px">
																				<SelectedDayStyle ForeColor="Black" BackColor="White"></SelectedDayStyle>
																			</asp:calendar></TD>
																		<TD class="label" noWrap align="right">Start Date</TD>
																		<TD colSpan="2"><asp:calendar id="cdrStartDate" runat="server" ToolTip="Date when protocol steps start for survey instance"
																				Font-Size="8px">
																				<SelectedDayStyle ForeColor="Black" BackColor="White"></SelectedDayStyle>
																			</asp:calendar></TD>
																	</TR>
																	<TR>
																		<TD class="label">
																			<P align="right">Quarter Ending</P>
																		</TD>
																		<TD colSpan="4">
																			<asp:TextBox id="tbQuarterEnding" runat="server" CssClass="detdatefield"></asp:TextBox>
																			<asp:CompareValidator id="cvQuarterEnding" runat="server" ErrorMessage="Quarter Ending value must be a date (mm/dd/yyyy)"
																				ControlToValidate="tbQuarterEnding" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label">
																			<P align="right">Default DE Script
																			</P>
																		</TD>
																		<TD colSpan="4"><asp:dropdownlist id="ddlDataEntryScriptID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label">
																			<P align="right">Default CATI Script</P>
																		</TD>
																		<TD colSpan="4"><asp:dropdownlist id="ddlCATIScriptID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label">
																			<P align="right">Default Reminder Script</P>
																		</TD>
																		<TD colSpan="4"><asp:dropdownlist id="ddlReminderScriptID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD>&nbsp;</TD>
																		<TD colSpan="1"><asp:checkbox id="cbGroupByHousehold" runat="server" CssClass="detcheckbox" Font-Bold="True" Text="Group by Household"
																				ToolTip="Check to group respondents by household for calling purposes. Respondents are grouped into the same household if they have the same day or evening telephone number, client, survey instance date, and belong to a survey instance with the household option turned on"></asp:checkbox></TD>
																		<TD colSpan="3"><asp:panel id="pnlOptions" runat="server">
<asp:HyperLink id="hlSurveyInstanceEvents" runat="server" ToolTip="View event settings for survey instance">Survey Instance Events</asp:HyperLink>&nbsp; 
<asp:HyperLink id="hlMailingSeeds" runat="server" ToolTip="View mailing seeds for survey instance">Mailing Seeds</asp:HyperLink></asp:panel></TD>
																	</TR>
																	<tr vAlign="top">
																		<td>&nbsp;</td>
																		<td colSpan="4">
																			<P><asp:imagebutton id="ibSave" runat="server" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"
																					EnableViewState="False"></asp:imagebutton>
																				<asp:HyperLink id="hlCancel" runat="server" NavigateUrl="surveyinstances.aspx" ImageUrl="../images/qms_done_btn.gif"
																					EnableViewState="False">Exit without saving changes</asp:HyperLink></P>
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
