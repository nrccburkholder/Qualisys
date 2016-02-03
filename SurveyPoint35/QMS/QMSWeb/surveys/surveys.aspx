<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="surveys.aspx.vb" Inherits="QMSWeb.frmSurveys" smartNavigation="True"%>
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
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Surveys</td>
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
															<td>
																<!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<asp:ValidationSummary id="vsSurveys" runat="server" Width="100%"></asp:ValidationSummary>
																<table class="form" width="100%">
																	<TR valign="top">
																		<TD width="100"><span class="label">Keyword</span><br>
																			<asp:textbox id="tbKeywordSearch" runat="server" MaxLength="100" ToolTip="Find by keyword in name or description" CssClass="sftextfield"></asp:textbox></TD>
																		<TD width="60"><span class="label">ID</span><br>
																			<asp:textbox id="tbSurveyID" runat="server" MaxLength="10" ToolTip="Find by survey id" CssClass="sfnumberfield"></asp:textbox>
																			<asp:CompareValidator id="cvSurveyID" runat="server" ErrorMessage="Survey ID must be numeric" Display="Dynamic" Type="Integer" Operator="DataTypeCheck" ControlToValidate="tbSurveyID">*</asp:CompareValidator></TD>
																		<TD width="100"><span class="label">Active</span><br>
																			<asp:checkbox id="cbActive" runat="server" ToolTip="Check to find only active" CssClass="sfcheckbox" Checked="True"></asp:checkbox></TD>
																		<TD align="right" valign="bottom"><asp:button id="btnSearch" runat="server" Text="Search" ToolTip="Click to initiate search" CssClass="button"></asp:button></TD>
																	</TR>
																</table>
																<!-- END SEARCH FORM AND FIELDS TABLE -->
															</td>
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
								<tr>
								    <td class="writablebg">
										<span class="resultscount">
											<asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span>
									</td>
								</tr>
								<tr>
								    <td class="writablebg">
								        <div style="height:500px;overflow:scroll">
										<asp:datagrid id="dgSurveys" runat="server" AllowPaging="True" PageSize="500" AutoGenerateColumns="False" AllowSorting="True" Width="100%">
											<Columns>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="SurveyID" SortExpression="SurveyID" HeaderText="ID"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="Name" HeaderText="Name">
													<ItemTemplate>
														<asp:Literal id="ltSurveyName" runat="server"></asp:Literal>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="CreatedOnDate" SortExpression="CreatedOnDate" HeaderText="Created On" DataFormatString="{0:d}"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="CreatedByUserID" HeaderText="Author">
													<ItemTemplate>
														<asp:Literal id="ltAuthorName" runat="server"></asp:Literal>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn SortExpression="Active" HeaderText="Active">
													<ItemTemplate>
														<%# IIf(Container.DataItem("Active") = 1, "Yes", "No") %>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:HyperLink id=hlDGICopy runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.SurveyID", "surveydetails.aspx?copyid={0}") %>' Text="Copy" ImageUrl="../images/qms_copy_sym.gif">Copy</asp:HyperLink>
														<asp:HyperLink id=hlDGIDetails runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.SurveyID", "surveydetails.aspx?id={0}") %>' Text="Details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
											<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
										</asp:datagrid>
										</div>
									</td>
								</tr>
								<tr>
								    <td class="WritableBG">
										<asp:HyperLink id="hlAdd" runat="server" NavigateUrl="surveydetails.aspx" ImageUrl="../images/qms_add_btn.gif">Add Survey</asp:HyperLink>
										<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected surveys" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
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
