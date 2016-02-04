<%@ Register TagPrefix="uc1" TagName="HTMLEditor" Src="../HTMLEdit/HTMLEditor.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="scriptscreendetails.aspx.vb" Inherits="QMSWeb.frmScriptScreenScreenDetails" smartNavigation="True"%>
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
	<BODY>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Script Screen Details</td>
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
																<asp:ValidationSummary id="vsScriptScreen" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0" width="100%">
																	<TR valign="top">
																		<TD class="label" align="right" width="100">Screen Number</TD>
																		<TD>
																			<asp:Literal id="ltItemOrder" runat="server"></asp:Literal></TD>
																		<TD class="label" align="right">Screen ID</TD>
																		<TD>
																			<asp:Literal id="ltScriptScreenID" runat="server"></asp:Literal></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Script Name</TD>
																		<TD>
																			<asp:Literal id="ltScriptName" runat="server"></asp:Literal></TD>
																		<TD class="label" align="right">Survey Name</TD>
																		<TD>
																			<asp:Literal id="ltSurveyName" runat="server"></asp:Literal></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Survey Question</TD>
																		<TD colspan="3"><asp:dropdownlist id="ddlSurveyQuestionID" runat="server" DataTextField="QuestionText" DataValueField="SurveyQuestionID"
																				AutoPostBack="True" CssClass="detselect"></asp:dropdownlist>&nbsp;
																			<asp:hyperlink id="hlSurveyQuestionDetails" runat="server" NavigateUrl="../questionbank/questiondetails.aspx"
																				ToolTip="View question details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:hyperlink></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Screen Title</TD>
																		<TD colspan="3">
																			<asp:TextBox id="tbTitle" runat="server" Width="350px" MaxLength="100" CssClass="dettextfield"></asp:TextBox>
																			<asp:RequiredFieldValidator id="rfvTitle" runat="server" ControlToValidate="tbTitle" ErrorMessage="Please provide a screen title.">*</asp:RequiredFieldValidator>
																		</TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right"><asp:CustomValidator id="cuvScreenText" runat="server" ErrorMessage="Screen text cannot be more than 2000 characters (including HTML tags)."
																				OnServerValidate="ValidateScreenText">*</asp:CustomValidator>Screen Text
																			<asp:HyperLink id="hlTextTokenHelp" runat="server" ToolTip="Click for list of text tokens" NavigateUrl="TextTokenHelp.htm"
																				Target="_NEW">?</asp:HyperLink></TD>
																		<TD colspan="3" nowrap>
																			<uc1:HTMLEditor id="ucDescription" runat="server" width="400"></uc1:HTMLEditor>
																			<asp:ImageButton id="ibResetQuestionText" runat="server" ImageUrl="../images/qms_reset_btn.gif" ToolTip="Reset to question text"></asp:ImageButton>
																		</TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Calculation Type</TD>
																		<TD colspan="3"><asp:dropdownlist id="ddlCalculationTypeID" runat="server" DataTextField="Name" DataValueField="CalculationTypeID"
																				CssClass="detselect"></asp:dropdownlist>
																			<asp:comparevalidator id="cvCalculationTypeID" runat="server" ErrorMessage="Please select a calculation type."
																				ControlToValidate="ddlCalculationTypeID" ValueToCompare="0" Operator="GreaterThan" Type="Integer">*</asp:comparevalidator></TD>
																	</TR>
																	<tr valign="top">
																		<td>&nbsp;</td>
																		<td colspan="2">
																			<p>
																				<asp:ImageButton id="ibSave" runat="server" ImageUrl="../images/qms_save_btn.gif" ToolTip="Save changes"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:ImageButton id="ibSaveNew" runat="server" ImageUrl="../images/qms_save_new_btn.gif" ToolTip="Save changes and start new script screen"></asp:ImageButton>
																				<asp:hyperlink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif">Exit without saving changes</asp:hyperlink></p>
																		</td>
																		<td align="right">
																			<asp:DropDownList id="ddlGoToScriptScreenID" runat="server" CssClass="detselect"></asp:DropDownList>
																			<asp:Button id="btnGoToScriptScreen" runat="server" CssClass="button" Text="Go"></asp:Button></td>
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
							<asp:DataGrid id="dgScriptScreenCategories" runat="server" Width="100%" AutoGenerateColumns="False">
								<Columns>
									<asp:BoundColumn Visible="False" DataField="AnswerCategoryID" HeaderText="AnswerCategoryID"></asp:BoundColumn>
									<asp:BoundColumn DataField="AnswerValue" SortExpression="AnswerValue" ReadOnly="True" HeaderText="Value"></asp:BoundColumn>
									<asp:BoundColumn DataField="AnswerText" SortExpression="AnswerText" HeaderText="Category Text"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="Text" HeaderText="Text">
										<ItemTemplate>
											<asp:TextBox id="tbCategoryText" runat="server" Width="150px" CssClass="gridtextfield" ToolTip="Alternate answer text for this screen" 
 MaxLength="1000"></asp:TextBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="AnswerCategoryTypeID" HeaderText="Type">
										<ItemTemplate>
											<asp:Literal ID="ltAnswerCategoryTypeName" Runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="Show" HeaderText="Show">
										<ItemTemplate>
											<asp:CheckBox id="cbShowCategory" runat="server" ToolTip="Check to display answer category for this screen" 
 CssClass="gridcheckbox"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="JumpToScriptScreenID" HeaderText="Jump">
										<ItemTemplate>
											<asp:DropDownList id="ddlJumpToScriptScreenID" runat="server" DataValueField="ScriptScreenID" DataTextField="ItemOrder" 
 CssClass="gridselect"></asp:DropDownList>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:DataGrid>
						</td>
					</tr>
					<tr>
					    <td class="WritableBG">
							<asp:ImageButton id="ibUpdateCategories" runat="server" ToolTip="Update Answer Categories" ImageUrl="../images/qms_update_btn.gif"></asp:ImageButton>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</BODY>
</HTML>
