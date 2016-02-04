<%@ Page Language="vb" AutoEventWireup="false" Codebehind="scripts.aspx.vb" Inherits="QMSWeb.frmScripts" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Scripts</td>
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
																<asp:validationsummary id="vsScripts" runat="server" Width="100%"></asp:validationsummary>
																<table class="form" width="100%">
																	<TR vAlign="top">
																		<TD width="100"><span class="label">Survey</span><br>
																			<asp:dropdownlist id="ddlSurveyIDSearch" runat="server" CssClass="sfselect" DataValueField="SurveyID" DataTextField="Name">
																				<asp:ListItem Value="All Surveys">All Surveys</asp:ListItem>
																			</asp:dropdownlist></TD>
																		<TD width="100"><span class="label">Script Type</span><br>
																			<asp:dropdownlist id="ddlScriptTypeIDSearch" runat="server" CssClass="sfselect" DataValueField="ScriptTypeID" DataTextField="Name">
																				<asp:ListItem Value="All">All</asp:ListItem>
																				<asp:ListItem Value="Data Entry">Data Entry</asp:ListItem>
																				<asp:ListItem Value="Reminder Call">Reminder Call</asp:ListItem>
																				<asp:ListItem Value="CATI">CATI</asp:ListItem>
																			</asp:dropdownlist></TD>
																		<TD noWrap width="75"><span class="label">Script ID</span><br>
																			<asp:textbox id="tbScriptIDSearch" runat="server" CssClass="sfnumberfield" ToolTip="Find by script id" MaxLength="10"></asp:textbox><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ControlToValidate="tbScriptIDSearch" ErrorMessage="Script ID must be numeric" ValidationExpression="\d+">*</asp:regularexpressionvalidator></TD>
																		<TD width="100"><span class="label">Keyword</span><br>
																			<asp:textbox id="tbKeywordSearch" runat="server" CssClass="sftextfield" ToolTip="Find by keyword in script name or description" MaxLength="100"></asp:textbox></TD>
																		<TD vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to initiate search" Text="Search" EnableViewState="False"></asp:button></TD>
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
						<td class="writablebg"><span class="resultscount"><asp:literal id="ltResultsFound" Runat="server"></asp:literal></span>
						</td>
					</tr>
					<tr>
					    <td class="writablebg">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:datagrid id="dgScripts" runat="server" Width="100%" AllowPaging="True" PageSize="500" AllowSorting="True" AutoGenerateColumns="False">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="ScriptID" SortExpression="ScriptID" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="SurveyID" HeaderText="Survey">
										<ItemTemplate>
											<asp:Literal id="ltSurveyName" runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="Name" SortExpression="Name" HeaderText="Script"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="ScriptTypeID" HeaderText="Script Type">
										<ItemTemplate>
											<asp:Literal id="ltScriptTypeName" runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id="hlCopy" runat="server" Text="Copy" ImageUrl="../images/qms_copy_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ScriptID", "scriptdetails.aspx?copy={0}") %>' EnableViewState="False">Copy</asp:HyperLink>
											<asp:HyperLink id="hlDetails" runat="server" Text="Details" ImageUrl="../images/qms_view1_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ScriptID", "scriptdetails.aspx?id={0}") %>' EnableViewState="False">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle ForeColor="White" Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
							</asp:datagrid>
						</div>
						</td>
					</tr>
					<tr>
					    <td class="writablebg">
							<table cellSpacing="0" cellPadding="0" border="0">
								<tr>
									<td colSpan="2"></td>
									<td class="label" colSpan="2">Survey</td>
								</tr>
								<tr>
									<td><asp:hyperlink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" EnableViewState="False" NavigateUrl="scriptdetails.aspx">Add Script</asp:hyperlink></td>
									<td><asp:imagebutton id="ibDelete" runat="server" ToolTip="Delete selected scripts" ImageUrl="../images/qms_delete_btn.gif" EnableViewState="False"></asp:imagebutton></td>
									<td><asp:dropdownlist id="ddlSurveyIDAction" runat="server" CssClass="sfselect" DataValueField="SurveyID" DataTextField="Name" AutoPostBack="True"></asp:dropdownlist></td>
									<td>
										<asp:HyperLink id="hlAutoScript" runat="server" ImageUrl="../images/qms_autoscript_btn.gif">Generate script from selected survey.</asp:HyperLink></td>
								</tr>
							</table>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
