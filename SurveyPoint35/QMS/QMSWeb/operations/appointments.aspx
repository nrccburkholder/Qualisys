<%@ Page Language="vb" AutoEventWireup="false" Codebehind="appointments.aspx.vb" Inherits="QMSWeb.appointments"%>
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
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<p>
				<TABLE class="main" align="center" border="0" cellpadding="0" cellspacing="0">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Appointments</td>
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
																<asp:ValidationSummary id="vsAppointments" runat="server" Width="100%"></asp:ValidationSummary>
																<table cellSpacing="3" cellPadding="0" width="100%" border="0">
																	<TR>
																		<TD noWrap width="200"><span class="label"></span><STRONG>Start Date</STRONG><br>
																			<asp:textbox id="tbStartDate" runat="server" ToolTip="Find appointments by date" CssClass="sfdatefield"></asp:textbox><asp:comparevalidator id="cvStartDate" runat="server" ControlToValidate="tbStartDate" Display="Dynamic"
																				Operator="DataTypeCheck" Type="Date" ErrorMessage="Start Date value is not a valid date format">*</asp:comparevalidator><asp:requiredfieldvalidator id="rfvStartDate" runat="server" ControlToValidate="tbStartDate" Display="Dynamic"
																				ErrorMessage="Please provide a start date">*</asp:requiredfieldvalidator></TD>
																		<TD width="120" noWrap><span class="label">End Date</span><br>
																			<asp:textbox id="tbEndDate" runat="server" CssClass="sfdatefield" ToolTip="Find appointments by date"></asp:textbox>
																			<asp:CompareValidator id="cvEndDate" runat="server" ErrorMessage="End date must be in date format" Display="Dynamic"
																				ControlToValidate="tbEndDate" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																		<TD vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" ToolTip="Click to generate appointments report by date and survey instance"
																				Text="Search" CssClass="button"></asp:button></TD>
																	</TR>
																</table>
																<table cellSpacing="3" cellPadding="0" width="100%" border="0">
																	<TR>
																		<TD noWrap><span class="label">Survey Instance</span><br>
																			<asp:dropdownlist id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																	</TR>
																</table>
																<table cellSpacing="3" cellPadding="0" width="100%" border="0">
																	<TR>
																		<TD noWrap>
																			<span class="label">Survey</span><br>
																			<asp:DropDownList id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:DropDownList>
																		</TD>
																		<TD noWrap>
																			<span class="label">Client</span><br>
																			<asp:DropDownList id="ddlClientID" runat="server" CssClass="sfselect"></asp:DropDownList>
																		</TD>
																		<TD width="50%"></TD>
																	</TR>
																</table>
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
						<td class="WritableBG">
							<span class="resultscount"><asp:literal id="ltResultsFound" Runat="server"></asp:literal></span>
						</td>
					</tr>
					<tr>
					    <td>
								<!-- THIS TABLE IS THE DATAGRID -->
								<asp:datagrid id="dgAppointments" runat="server" Width="100%" AutoGenerateColumns="False" AllowSorting="True">
									<AlternatingItemStyle Font-Size="10pt" VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle Font-Size="10pt" VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:BoundColumn DataField="AppointmentDate" SortExpression="AppointmentDate" HeaderText="Date" DataFormatString="{0:d}"></asp:BoundColumn>
										<asp:BoundColumn DataField="AppointmentTime" SortExpression="AppointmentTime" HeaderText="Time"></asp:BoundColumn>
										<asp:BoundColumn DataField="RespondentID" SortExpression="RespondentID" HeaderText="Respondent ID"></asp:BoundColumn>
										<asp:TemplateColumn HeaderText="Name">
											<ItemTemplate>
												<%# String.Format("{0}, {1}", Container.DataItem("LastName"), Container.DataItem("FirstName")) %>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Location">
											<ItemTemplate>
												<%# String.Format("{0}, {1}", Container.DataItem("City"), Container.DataItem("State")) %>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:HyperLink id=hlCATI runat="server" ToolTip="CATI Call" Text="Make Call" ImageUrl="../images/qms_cati_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "../respondents/selectrespondent.aspx?rid={0}&amp;input=3") %>'>CATI Call</asp:HyperLink>
												<asp:HyperLink id=hlReminder runat="server" ToolTip="Reminder Call" ImageUrl="../images/qms_reminder_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "../respondents/selectrespondent.aspx?rid={0}&amp;input=4") %>'>Reminder Call</asp:HyperLink>
											</ItemTemplate>
										</asp:TemplateColumn>
									</Columns>
								</asp:datagrid></p>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>			
		</form>
	</body>
</HTML>
