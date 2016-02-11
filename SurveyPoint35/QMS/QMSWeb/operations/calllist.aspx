<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="calllist.aspx.vb" Inherits="QMSWeb.frmCallList" %>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:label id="lblTitle" runat="server"></asp:label></td>
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
												<td width="100%" class="writablebg">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsCallList" runat="server" Width="100%"></asp:validationsummary>
																<table class="formline" width="100%">
																	<tr vAlign="top">
																		<td width="100"><span class="label">Protocol Step</span><br>
																			<asp:dropdownlist id="ddlProtocolSteps" runat="server" CssClass="sfselect" AutoPostBack="True"></asp:dropdownlist></td>
																		<td width="150"><span class="label">Advanced</span><br>
																			<asp:imagebutton id="ibAdvanced" runat="server" ImageUrl="../images/qms_arrowdown_sym.gif" CausesValidation="False"></asp:imagebutton></td>
																		<td vAlign="bottom" align="right"><asp:button id="btnGetNext" runat="server" Width="75px" CssClass="button" ToolTip="Click to select next respondent from call list"
																				Text="Get Next"></asp:button></td>
																	</tr>
																</table>
																<asp:panel id="pnlAdvanced" Runat="server" Visible="False">
																	<TABLE class="formline" width="100%">
																		<TR vAlign="top">
																			<TD width="300"><SPAN class="label">Survey Instance</SPAN><BR>
																				<asp:dropdownlist id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD width="100"><SPAN class="label">Call Attempts</SPAN><BR>
																				<asp:textbox id="tbCallAttempts" runat="server" CssClass="sfnumberfield" ToolTip="Filter by number call attempts made to respondents"></asp:textbox>
																				<asp:requiredfieldvalidator id="rfvCallAttempts" runat="server" ErrorMessage="Call Attempts is required" Display="Dynamic"
																					ControlToValidate="tbCallAttempts">*</asp:requiredfieldvalidator>
																				<asp:CompareValidator id="cvCallAttempts" runat="server" ErrorMessage="Call attempts must be a value 0 or higher"
																					Display="Dynamic" ControlToValidate="tbCallAttempts" Operator="GreaterThanEqual" ValueToCompare="0"
																					Type="Integer">*</asp:CompareValidator></TD>
																			<TD vAlign="bottom" align="right">
																				<asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to generate call list"
																					Text="Search"></asp:button></TD>
																		</TR>
																	</TABLE>
																	<TABLE class="formline">
																		<TR>
																			<TD vAlign="bottom" noWrap><SPAN class="label">Survey</SPAN><BR>
																				<asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD vAlign="bottom" noWrap><SPAN class="label">Client</SPAN><BR>
																				<asp:dropdownlist id="ddlClientID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD vAlign="bottom" noWrap><SPAN class="label"></SPAN><STRONG>Filter</STRONG><BR>
																				<asp:dropdownlist id="ddlFileDefFilterID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		</TR>
																	</TABLE>
																	<TABLE class="formline">
																		<TR>
																			<TD vAlign="bottom"><SPAN class="label">State</SPAN><BR>
																				<asp:dropdownlist id="ddlState" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD vAlign="bottom"><SPAN class="label">Time Zone</SPAN><BR>
																				<asp:dropdownlist id="ddlTimeZone" runat="server" CssClass="sfselect">
																					<asp:ListItem Value="-99">Select Time Zone</asp:ListItem>
																					<asp:ListItem Value="-4">Altantic Time (GMT-4:00)</asp:ListItem>
																					<asp:ListItem Value="-5">Eastern Time (GMT-5:00)</asp:ListItem>
																					<asp:ListItem Value="-6">Central Time (GMT-6:00)</asp:ListItem>
																					<asp:ListItem Value="-7">Mountain Time (GMT-7:00)</asp:ListItem>
																					<asp:ListItem Value="-8">Pacific Time (GMT-8:00)</asp:ListItem>
																					<asp:ListItem Value="-9">Alaska Time (GMT-9:00)</asp:ListItem>
																					<asp:ListItem Value="-10">Hawaii Time (GMT-10:00)</asp:ListItem>
																				</asp:dropdownlist></TD>
																			<TD vAlign="bottom"><SPAN class="label">Earliest Local Time</SPAN><BR>
																				<asp:textbox id="tbEarliestTime" runat="server" CssClass="sfdatefield" ToolTip="Filter by respondent's local time or later"
																					MaxLength="10"></asp:textbox>
																				<asp:regularexpressionvalidator id="revEarliestTime" runat="server" ErrorMessage="Earliest Time must be in hh:mm AM/PM format"
																					Display="Dynamic" ControlToValidate="tbEarliestTime" ValidationExpression="^(1[012]|[1-9]):[0-5][0-9]\s?[aApP][mM]$">*</asp:regularexpressionvalidator></TD>
																			<TD vAlign="bottom"><SPAN class="label">Latest Local Time</SPAN><BR>
																				<asp:textbox id="tbLatestTime" runat="server" CssClass="sfdatefield" ToolTip="Filter by respondent's local time or earlier"
																					MaxLength="10"></asp:textbox>
																				<asp:regularexpressionvalidator id="revLatestTime" runat="server" ErrorMessage="Latest Time must be in hh:mm AM/PM format"
																					Display="Dynamic" ControlToValidate="tbLatestTime" ValidationExpression="^(1[012]|[1-9]):[0-5][0-9]\s?[aApP][mM]$">*</asp:regularexpressionvalidator></TD>
																		</TR>
																	</TABLE>
																</asp:panel>
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
						<td class="writablebg">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:linkbutton id="lbSearchResults" runat="server" CssClass="resultscount" ToolTip="Click for total respondents on call list"></asp:linkbutton>
							<asp:datagrid id="dgCallList" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True" PageSize="200">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:BoundColumn DataField="RespondentID" SortExpression="RespondentID" HeaderText="Respondent ID"></asp:BoundColumn>
										<asp:TemplateColumn HeaderText="Name">
											<ItemTemplate>
												<%# String.Format("{0} {1}",Container.DataItem("FirstName"), Container.DataItem("LastName")) %>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Location">
											<ItemTemplate>
												<%# String.Format("{0}, {1}", Container.DataItem("City"), Container.DataItem("State")) %>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Survey Instance">
											<ItemTemplate>
												<%# String.Format("{0} : {1} : {2}", Container.DataItem("SurveyName"), Container.DataItem("ClientName"), Container.DataItem("SurveyInstanceName")) %>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="StateTime" HeaderText="Local Time" DataFormatString="{0:t}"></asp:BoundColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:datagrid>
							<!-- END DATAGRID --></div></td>
					</tr>
				</TABLE>
			</p>
			<asp:customvalidator id="cuvValidateCallList" Runat="server" Display="None" EnableClientScript="False"
				OnServerValidate="ValidateCallList"></asp:customvalidator></form>
	</body>
</HTML>
