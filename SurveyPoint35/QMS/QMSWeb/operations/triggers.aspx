<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="triggers.aspx.vb" Inherits="QMSWeb.triggers"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Triggers</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsAppointments" runat="server" Width="100%"></asp:validationsummary>
																<table cellSpacing="3" cellPadding="0" width="100%" border="0">
																	<TR>
																		<TD noWrap><span class="label">Type</span><br>
																			<asp:dropdownlist id="ddlType" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		<TD noWrap><span class="label">Survey</span><br>
																			<asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		<TD noWrap><span class="label">Invocation</span><br>
																			<asp:dropdownlist id="ddlInvocationPoint" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		<TD noWrap width="200"><span class="label">Name</span><br>
																			<asp:textbox id="tbTriggerName" runat="server" CssClass="sftextfield" ToolTip="Find triggers by name"></asp:textbox></TD>
																		<TD width="50%"></TD>
																		<TD vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to generate appointments report by date and survey instance"
																				Text="Search"></asp:button></TD>
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
					    <td class="WritableBG">
					        <div style="height:500px;overflow:scroll">
								<!-- THIS TABLE IS THE DATAGRID -->
								<asp:datagrid id="dgTriggers" runat="server" Width="100%" AutoGenerateColumns="False" AllowSorting="True"
									AllowPaging="True" PageSize="500">
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelect" runat="server"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:HyperLinkColumn DataNavigateUrlField="TriggerID" DataNavigateUrlFormatString="triggerdetail.aspx?id={0}"
											DataTextField="TriggerID" SortExpression="TriggerID" HeaderText="ID"></asp:HyperLinkColumn>
										<asp:HyperLinkColumn DataNavigateUrlField="TriggerID" DataNavigateUrlFormatString="triggerdetail.aspx?id={0}"
											DataTextField="TriggerName" SortExpression="TriggerName" HeaderText="Name"></asp:HyperLinkColumn>
										<asp:BoundColumn DataField="TriggerTypeName" SortExpression="TriggerTypeName" ReadOnly="True" HeaderText="Type"></asp:BoundColumn>
										<asp:BoundColumn DataField="SurveyName" SortExpression="SurveyName" ReadOnly="True" HeaderText="Survey"></asp:BoundColumn>
										<asp:BoundColumn DataField="InvocationPointName" SortExpression="InvocationPointName" ReadOnly="True"
											HeaderText="Invocation"></asp:BoundColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:datagrid>
							<!-- END DATAGRID -->
						    </div>
						   </td>
						</tr>
					<tr>
					    <td class="WritableBG">
							<asp:HyperLink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" NavigateUrl="triggerdetail.aspx">HyperLink</asp:HyperLink>
							<asp:ImageButton id="ibDelete" runat="server" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
