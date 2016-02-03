<%@ Page Language="vb" AutoEventWireup="false" Codebehind="scriptdetails.aspx.vb" Inherits="QMSWeb.frmScriptDetails" smartNavigation="True"%>
<%@ Register TagPrefix="uc1" TagName="ucTemplates" Src="../includes/ucTemplates.ascx" %>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Script Details</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsScript" runat="server" Width="100%"></asp:validationsummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0">
																	<TR vAlign="top">
																		<TD class="label" align="right">Script ID</TD>
																		<TD><asp:label id="lblScriptID" runat="server"></asp:label></TD>
																		<TD class="label" align="right">Survey</TD>
																		<TD><asp:label id="lblSurveyName" runat="server"></asp:label><asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="detselect"></asp:dropdownlist><asp:requiredfieldvalidator id="rfvSurveyID" runat="server" Display="Dynamic" ControlToValidate="ddlSurveyID"
																				ErrorMessage="Please select a survey">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Script Name</TD>
																		<TD colSpan="3"><asp:textbox id="tbName" runat="server" Width="350px" CssClass="dettextfield" MaxLength="100"></asp:textbox><asp:requiredfieldvalidator id="rfvName" runat="server" ControlToValidate="tbName" ErrorMessage="Script name is required">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Description</TD>
																		<TD colSpan="3"><asp:textbox id="tbDescription" runat="server" Width="350px" CssClass="dettextfield" MaxLength="1000"
																				Rows="5" TextMode="MultiLine"></asp:textbox><asp:requiredfieldvalidator id="rfvDescription" runat="server" ControlToValidate="tbDescription" ErrorMessage="Please provide a script description">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Type</TD>
																		<TD><asp:dropdownlist id="ddlScriptTypeID" runat="server" CssClass="detselect" DataTextField="Name" DataValueField="ScriptTypeID"></asp:dropdownlist></TD>
																		<TD class="label" align="right">Completeness</TD>
																		<TD><asp:textbox id="tbCompletenessLevel" runat="server" CssClass="detnumberfield" MaxLength="3"
																				ToolTip="Percentage of questions answered for survey to be complete"></asp:textbox>%
																			<asp:requiredfieldvalidator id="rfvCompletenessLevel" runat="server" Display="Dynamic" ControlToValidate="tbCompletenessLevel"
																				ErrorMessage="Please provide a completeness level.">*</asp:requiredfieldvalidator><asp:rangevalidator id="rvCompletenessLevel" runat="server" ControlToValidate="tbCompletenessLevel"
																				ErrorMessage="Completeness level must be between 0 and 100" MaximumValue="100" MinimumValue="0" Type="Integer">*</asp:rangevalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD vAlign="top" align="right">&nbsp;</TD>
																		<TD><asp:checkbox id="cbDefaultScript" runat="server" CssClass="detcheckbox" ToolTip="Script is default for survey and input type"
																				Text="Default Script For Survey" Font-Bold="True"></asp:checkbox></TD>
																		<TD><asp:checkbox id="cbCalcCompleteness" runat="server" CssClass="detcheckbox" ToolTip="Check to calculate survey completeness at end of survey or when exiting script"
																				Text="Calculate Completeness" Font-Bold="True"></asp:checkbox></TD>
																		<TD><asp:checkbox id="cbFollowSkips" runat="server" CssClass="detcheckbox" ToolTip="Check to follow skip patterns specified in script"
																				Text="Follow Jumps" Font-Bold="True"></asp:checkbox></TD>
																	</TR>
																	<TR>
																		<TD></TD>
																		<TD colSpan="3">
																			<asp:HyperLink id="hlScriptTriggers" runat="server">Script Triggers</asp:HyperLink>&nbsp;
																			<asp:HyperLink id="hlPrint" runat="server" ToolTip="View a print version of script" Target="_NEW">Printable</asp:HyperLink></TD>
																	</TR>
																	<tr vAlign="top">
																		<td>&nbsp;</td>
																		<td colSpan="3">
																			<P><asp:imagebutton id="ibSave" runat="server" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"
																					EnableViewState="False"></asp:imagebutton><asp:hyperlink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif" EnableViewState="False"
																					NavigateUrl="scripts.aspx">Exit without saving changes</asp:hyperlink><asp:hyperlink id="hlTestScript" runat="server" ToolTip="Runs script in test mode" ImageUrl="../images/qms_test_btn.gif">Test Script</asp:hyperlink></P>
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
					<tr>
						<td>
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:datagrid id="dgScriptScreens" runat="server" Width="100%" AutoGenerateColumns="False">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox" EnableViewState="False"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="ItemOrder" HeaderText="Order">
										<ItemTemplate>
											<asp:DropDownList id="ddlItemOrder" runat="server" CssClass="gridselect"></asp:DropDownList>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="ScriptScreenID" SortExpression="ScriptScreenID" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn HeaderText="Title">
										<ItemTemplate>
											<asp:Literal id="ltScreenTitle" runat="server" EnableViewState="False"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="CalculationTypeID" HeaderText="Calculation">
										<ItemTemplate>
											<asp:Literal id="ltCalculationTypeName" runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id="hlNavigateDetails" runat="server" Text="Details" ImageUrl="../images/qms_view1_sym.gif"
												EnableViewState="False">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:datagrid>
						</div>
						</td>
					</tr>
					<tr>
					    <td class="writablebg"><asp:panel id="pnlScriptScreenActions" runat="server">
								<asp:HyperLink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif">Add script screen</asp:HyperLink>
								<asp:ImageButton id="ibUpdateOrder" runat="server" ToolTip="Update script screen order" EnableViewState="False"
									ImageUrl="../images/qms_reorder_btn.gif" CausesValidation="False"></asp:ImageButton>
								<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected script screens" EnableViewState="False"
									ImageUrl="../images/qms_delete_btn.gif" CausesValidation="False"></asp:ImageButton>
							</asp:panel>
							<!-- END DATAGRID --></td>
					</tr>
					<tr>
						<td class="writablebg">
							<uc1:ucTemplates id="uctTemplates" runat="server"></uc1:ucTemplates></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
