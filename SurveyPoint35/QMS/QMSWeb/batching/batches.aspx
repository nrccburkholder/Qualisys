<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="batches.aspx.vb" Inherits="QMSWeb.frmBatchDetails" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Batches</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<asp:validationsummary id="vsBatches" runat="server" Width="100%"></asp:validationsummary>
																<table class="formline" width="100%">
																	<tr valign="top">
																		<td><span class="label">Survey</span>
																			<br>
																			<asp:DropDownList id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:DropDownList></td>
																		<td><span class="label">Client</span>
																			<br>
																			<asp:DropDownList id="ddlClientID" runat="server" CssClass="sfselect"></asp:DropDownList></td>
																		<td nowrap><span class="label">Batch ID</span>
																			<br>
																			<asp:TextBox id="tbBatchID" runat="server" Width="62px" MaxLength="10" ToolTip="Find specific batch id"
																				CssClass="sfnumberfield"></asp:TextBox>
																			<asp:RegularExpressionValidator id="revBatchID" runat="server" ErrorMessage="Batch ID must be numeric" ControlToValidate="tbBatchID"
																				ValidationExpression="^\d*$">*</asp:RegularExpressionValidator></td>
																		<td align="right" valign="bottom">
																			<asp:Button id="btnSearch" runat="server" Text="Search" ToolTip="Click to initiate search" CssClass="button"
																				EnableViewState="False"></asp:Button></td>
																	</tr>
																	<tr>
																		<td colspan="4"><span class="label">Survey Instance</span>
																			<br>
																			<asp:DropDownList id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:DropDownList></td>
																	</tr>
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
						<td><p>
								<span class="resultscount">
									<asp:Literal id="ltResultsFound" runat="server"></asp:Literal></span>
								<asp:DataGrid id="dgBatches" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False"
									AllowPaging="True" PageSize="15">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:BoundColumn DataField="BatchID" SortExpression="BatchID" HeaderText="Batch ID"></asp:BoundColumn>
										<asp:BoundColumn DataField="SurveyName" SortExpression="SurveyName" HeaderText="Survey"></asp:BoundColumn>
										<asp:BoundColumn DataField="ClientName" SortExpression="ClientName" HeaderText="Client"></asp:BoundColumn>
										<asp:BoundColumn DataField="SurveyInstanceName" SortExpression="SurveyInstanceName" HeaderText="Survey Instance"></asp:BoundColumn>
										<asp:BoundColumn DataField="RespondentCount" SortExpression="RespondentCount" HeaderText="Count"></asp:BoundColumn>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:HyperLink id=hlAddTo runat="server" ToolTip="Add To Batch" Text="Add To" ImageUrl="../images/qms_add_expand_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.BatchID", "batchlogging.aspx?last={0}") %>'>Add To</asp:HyperLink>&nbsp;
												<asp:HyperLink id="hlDetails" runat="server" ToolTip="View Batch Details" Text="Details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
											</ItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:DataGrid></p>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
