<%@ Page Language="vb" AutoEventWireup="false" Codebehind="eventlog.aspx.vb" Inherits="QMSWeb.frmEventLog" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Search Event Log</td>
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
																<P><asp:customvalidator id="cuvEventLog" runat="server" ErrorMessage="Please set at least one of the following fields: Respondent ID, Survey, Client, Survey Instance, Event, Event Type or User" Display="None" OnServerValidate="ValidateSearch"></asp:customvalidator><asp:validationsummary id="vsEventLog" runat="server" Width="100%"></asp:validationsummary>
																	<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
																		<tr>
																			<td>
																				<TABLE cellSpacing="0" cellPadding="2" width="100%" border="0">
																					<tr vAlign="top">
																						<TD width="100"><span class="label">Respondent ID</span><br>
																							<asp:textbox id="tbRespondentID" runat="server" CssClass="sfnumberfield" ToolTip="Search by respondent id number"></asp:textbox><asp:comparevalidator id="cvRespondentID" runat="server" ErrorMessage="Respondent ID must be numeric" ControlToValidate="tbRespondentID" Operator="DataTypeCheck" Type="Integer">*</asp:comparevalidator></TD>
																						<TD style="WIDTH: 104px" width="104"><span class="label">Start Date</span><br>
																							<asp:textbox id="tbEventDateBegin" runat="server" CssClass="sfdatefield" ToolTip="Search events on or after this date"></asp:textbox><asp:comparevalidator id="cvEventDateBegin" runat="server" ErrorMessage="Start Date must be in mm/dd/yyyy date format" ControlToValidate="tbEventDateBegin" Operator="DataTypeCheck" Type="Date">*</asp:comparevalidator></TD>
																						<TD style="WIDTH: 103px" width="103"><span class="label">End Date</span><br>
																							<asp:textbox id="tbEventDateEnd" runat="server" CssClass="sfdatefield" ToolTip="Search for event on or before this date"></asp:textbox><asp:comparevalidator id="cvEventDateEnd" runat="server" ErrorMessage="End Date must be in mm/dd/yyyy date format" ControlToValidate="tbEventDateEnd" Operator="DataTypeCheck" Type="Date">*</asp:comparevalidator></TD>
																						<TD><span class="label">Max Rows</span><br>
																							<asp:textbox id="tbMaxRows" runat="server" CssClass="sfnumberfield" ToolTip="Returns only set number of rows. Leave blank to return all rows or to access Delete All function.">1000</asp:textbox><asp:comparevalidator id="cvMaxRows" runat="server" ErrorMessage="Maximus rows must be numeric" ControlToValidate="tbMaxRows" Operator="DataTypeCheck" Type="Integer" Display="Dynamic">*</asp:comparevalidator></TD>
																						<TD vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" Text="Search"></asp:button></TD>
																					</tr>
																				</TABLE>
																			</td>
																		</tr>
																		<tr>
																			<td>
																				<TABLE cellSpacing="0" cellPadding="2" border="0">
																					<TR vAlign="top">
																						<TD><span class="label">Survey</span><br>
																							<asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																						<TD><span class="label">Client</span><br>
																							<asp:dropdownlist id="ddlClientID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																					</TR>
																				</TABLE>
																			</td>
																		</tr>
																		<tr>
																			<td>
																				<TABLE cellSpacing="0" cellPadding="2" border="0">
																					<TR vAlign="top">
																						<TD><span class="label">Survey Instance</span><br>
																							<asp:dropdownlist id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																						<td><br>
																							<asp:checkbox id="cbActive" runat="server" CssClass="sfcheckbox" ToolTip="Search for respondents in active survey instances" Text="Active" Checked="True" Font-Bold="True"></asp:checkbox></td>
																					</TR>
																				</TABLE>
																			</td>
																		</tr>
																		<tr>
																			<td>
																				<TABLE cellSpacing="0" cellPadding="2" border="0">
																					<TR vAlign="top">
																						<TD><span class="label">Event</span><br>
																							<asp:dropdownlist id="ddlEventID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																						<TD><span class="label">Event Type</span><br>
																							<asp:dropdownlist id="ddlEventTypeID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																						<TD><span class="label">User</span><br>
																							<asp:dropdownlist id="ddlUserID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																					</TR>
																				</TABLE>
																			</td>
																		</tr>
																	</TABLE>
																</P>
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
							<asp:label id="lblSearchResults" runat="server" cssclass="resultscount"></asp:label>
						</td>
					</tr>
					<tr>
					    <td class="WritableBG">
								<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">	
							<asp:datagrid id="dgEventLog" runat="server" Width="100%" AllowPaging="True" PageSize="500" AllowSorting="True" AutoGenerateColumns="False">
							<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
							<ItemStyle VerticalAlign="Top"></ItemStyle>
							<Columns>
								<asp:TemplateColumn>
									<ItemTemplate>
										<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:BoundColumn DataField="EventDate" SortExpression="EventDate" ReadOnly="True" HeaderText="Date" DataFormatString="{0:d} {0:t}"></asp:BoundColumn>
								<asp:BoundColumn DataField="EventName" SortExpression="EventName" HeaderText="Event"></asp:BoundColumn>
								<asp:BoundColumn DataField="RespondentName" SortExpression="RespondentName" HeaderText="Respondent"></asp:BoundColumn>
								<asp:BoundColumn DataField="Username" SortExpression="Username" HeaderText="User"></asp:BoundColumn>
								<asp:BoundColumn DataField="SurveyInstanceName" SortExpression="SurveyInstanceName" HeaderText="Survey Instance"></asp:BoundColumn>
							</Columns>
							<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
						</asp:datagrid>
						</div>
						 </td>
				    </tr>
				    <tr>
				        <td class="WritableBG">
		                    <asp:panel id="pnlEventLogActions" runat="server" Visible="False">
							<TABLE cellSpacing="0" cellPadding="3" border="0">
								<TR>
									<TD>
										<asp:imagebutton id="ibDelete" runat="server" ToolTip="Delete selected log events" ImageUrl="../images/qms_delete_btn.gif"></asp:imagebutton></TD>
									<TD>
										<asp:checkbox id="cbDeleteAll" runat="server" CssClass="detcheckbox" Text="Delete All" Font-Bold="True"></asp:checkbox></TD>
								</TR>
							</TABLE>
						</asp:panel>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
