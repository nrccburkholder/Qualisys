<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="default.aspx.vb" Inherits="QMSWeb.frmMain" smartNavigation="True"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
			<p>
				<TABLE class="main" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table cellspacing="0" cellpadding="0" width="100%" border="0">
								<tr>
									<td>
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="images/clear.gif" width="1"><IMG height="1" src="images/clear.gif" width="1"></td>
												<td colSpan="3"><IMG height="1" src="images/clear.gif" width="1"></td>
												<td width="1" rowSpan="2"><IMG height="1" src="images/clear.gif" width="1"><IMG height="1" src="images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Survey Tasks</td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" rowSpan="2"><IMG height="21" src="images/tableheader.gif" width="22"></td>
												<td width="100%"><IMG height="18" src="images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" width="100%" colspan="2"><IMG height="3" src="images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" colSpan="4"><IMG height="1" src="images/clear.gif" width="1"></td>
											</tr>
										</table>
										<!-- END TITLE AND TABLE HEADING TABLE -->									
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#f0f0f0">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<asp:ValidationSummary id="vsSearchProtocolSteps" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="0" border="0">
																	<tr>
																		<td>
																			<TABLE cellSpacing="0" cellPadding="5" border="0" width="100%">
																				<tr valign="top">
																					<td><span class="label">Survey Instance</span><br>
																						<asp:DropDownList id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:DropDownList></td>
																					<td><span class="label">Protocol Step</span><br>
																						<asp:DropDownList id="ddlProtocolStepTypeID" runat="server" CssClass="sfselect"></asp:DropDownList></td>
																					<td><span class="label">Start Date</span><br>
																						<asp:TextBox id="tbBeginDate" runat="server" ToolTip="Find by protocol step date or later" CssClass="sfdatefield"></asp:TextBox>
																						<asp:RegularExpressionValidator id="revBeginDate" runat="server" ErrorMessage="Begin Date must be in mm/dd/yyyy format date format"
																							Display="None" ControlToValidate="tbBeginDate" ValidationExpression="^(((0?[13578]|1[02])(\/|-|\.)31)\4|((0?[1,3-9]|1[0-2])(\/|-|\.)(29|30)\7))((1[6-9]|[2-9]\d)?\d{2})$|^(0?2(\/|-|\.)29\12(((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$|^((0?[1-9])|(1[0-2]))(\/|-|\.)(0?[1-9]|1\d|2[0-8])\22((1[6-9]|[2-9]\d)?\d{2})$">*</asp:RegularExpressionValidator></td>
																					<td><span class="label">End Date</span><br>
																						<asp:TextBox id="tbEndDate" runat="server" ToolTip="Find by protocol step date or earlier" DESIGNTIMEDRAGDROP="541"
																							CssClass="sfdatefield"></asp:TextBox>
																						<asp:RegularExpressionValidator id="revEndDate" runat="server" ValidationExpression="^(((0?[13578]|1[02])(\/|-|\.)31)\4|((0?[1,3-9]|1[0-2])(\/|-|\.)(29|30)\7))((1[6-9]|[2-9]\d)?\d{2})$|^(0?2(\/|-|\.)29\12(((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$|^((0?[1-9])|(1[0-2]))(\/|-|\.)(0?[1-9]|1\d|2[0-8])\22((1[6-9]|[2-9]\d)?\d{2})$"
																							ControlToValidate="tbEndDate" Display="None" ErrorMessage="End Date must be in mm/dd/yyyy format date format"
																							DESIGNTIMEDRAGDROP="542">*</asp:RegularExpressionValidator></td>
																					<td align="right" valign="bottom">
																						<asp:Button id="btnSearch" runat="server" ToolTip="Click to initiate search " Text="Search"
																							DESIGNTIMEDRAGDROP="546" CssClass="button"></asp:Button></td>
																				</tr>
																			</TABLE>
																		</td>
																	</tr>
																</TABLE>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
														</tr>
													</table>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="images/clear.gif" width="1"></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="WritableBG">
						    <div style="height:500px;overflow:scroll">
							<!-- THIS TABLE IS THE DATAGRID -->							
								<asp:DataGrid id="dgSurveyTasks" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True" PageSize="500"
									AllowSorting="True">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox" Checked='<%# Container.DataItem("Cleared") %>'>
												</asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="ProtocolStepDate" SortExpression="ProtocolStepDate" HeaderText="Date"
											DataFormatString="{0:d}"></asp:BoundColumn>
										<asp:BoundColumn DataField="SurveyName" SortExpression="SurveyName" HeaderText="Survey"></asp:BoundColumn>
										<asp:BoundColumn DataField="ClientName" SortExpression="ClientName" HeaderText="Client"></asp:BoundColumn>
										<asp:BoundColumn DataField="InstanceName" SortExpression="InstanceName" HeaderText="Survey Instance"></asp:BoundColumn>
										<asp:BoundColumn DataField="ProtocolStepTypeName" SortExpression="ProtocolStepTypeName" HeaderText="Step"></asp:BoundColumn>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:HyperLink id="hlGo" runat="server" Text="Go" NavigateUrl='<%# String.Format(Container.DataItem("URL"),Container.DataItem("SurveyInstanceID"),Container.DataItem("ProtocolStepID")) %>' ImageUrl="images/qms_arrowright_sym.gif">Go</asp:HyperLink>
											</ItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Wrap="False" Mode="NumericPages"></PagerStyle>
								</asp:DataGrid>
								</div>
								<asp:ImageButton id="ibClear" runat="server" ImageUrl="images/qms_clear_btn.gif"></asp:ImageButton>
							<p><a href="TaskCalendar.aspx">View Calendar</a></p>
							<!-- END DATAGRID -->						
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
