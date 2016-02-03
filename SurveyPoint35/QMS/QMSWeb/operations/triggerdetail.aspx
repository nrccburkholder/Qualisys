<%@ Page Language="vb" AutoEventWireup="false" Codebehind="triggerdetail.aspx.vb" Inherits="QMSWeb.triggerdetail"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Trigger Details</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsTriggerDetails" Width="100%" Runat="server"></asp:validationsummary>
																<TABLE cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Trigger ID
																		</TD>
																		<TD width="80%"><asp:literal id="ltTriggerID" runat="server"></asp:literal></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Type</TD>
																		<TD><asp:dropdownlist id="ddlTriggerType" runat="server" CssClass="detselect"></asp:dropdownlist><asp:requiredfieldvalidator id="rfvType" runat="server" ErrorMessage="Trigger Type is required" ControlToValidate="ddlTriggerType"
																				EnableViewState="False">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Survey</TD>
																		<TD><asp:dropdownlist id="ddlSurvey" runat="server" CssClass="detselect"></asp:dropdownlist>
																			<asp:Literal id="ltSurveyName" runat="server"></asp:Literal></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Invocation</TD>
																		<TD><asp:dropdownlist id="ddlInvocation" runat="server" CssClass="detselect"></asp:dropdownlist></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Name
																		</TD>
																		<TD><asp:textbox id="tbTriggerName" runat="server" Width="700px" CssClass="dettextfield"></asp:textbox><asp:requiredfieldvalidator id="rfvTriggerName" runat="server" ErrorMessage="Trigger name is required. Please provide a trigger name"
																				ControlToValidate="tbTriggerName" EnableViewState="False">*</asp:requiredfieldvalidator>
																			<asp:CustomValidator id="cuvTriggerNameUnique" runat="server" ControlToValidate="tbTriggerName" ErrorMessage="Trigger name already exists for this survey">*</asp:CustomValidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Perodicy Date
																		</TD>
																		<TD><asp:textbox id="tbPerodicyDate" runat="server" CssClass="detdatefield"></asp:textbox><asp:comparevalidator id="cvPerodicyDate" runat="server" ErrorMessage="Invalid Perodicy Date format" ControlToValidate="tbPerodicyDate"
																				EnableViewState="False" Operator="DataTypeCheck" Type="Date">*</asp:comparevalidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right">Perodicy Date Next
																		</TD>
																		<TD><asp:textbox id="tbPerodicyDateNext" runat="server" CssClass="detdatefield"></asp:textbox><asp:comparevalidator id="cvPerodicyDateNext" runat="server" ErrorMessage="Invalid Perodicy Date Next format"
																				ControlToValidate="tbPerodicyDateNext" EnableViewState="False" Operator="DataTypeCheck" Type="Date">*</asp:comparevalidator></TD>
																	</TR>
																	<TR>
																		<TD class="label" style="WIDTH: 250px; TEXT-ALIGN: right" vAlign="top">Trigger Code
																			<asp:hyperlink id="hlTriggerCodeHelp" runat="server" EnableViewState="False" NavigateUrl="../scripts/TriggerHelp.htm"
																				Target="_NEW">?</asp:hyperlink>&nbsp;
																		</TD>
																		<TD colSpan="3"><asp:textbox id="tbTriggerCode" runat="server" Width="700px" Rows="15" TextMode="MultiLine"></asp:textbox><asp:requiredfieldvalidator id="rfvTriggerCode" runat="server" ErrorMessage="Trigger code is required. Please provide trigger code"
																				ControlToValidate="tbTriggerCode" EnableViewState="False">*</asp:requiredfieldvalidator><asp:customvalidator id="cuvTriggerCode" runat="server" ErrorMessage="Code Error!" ControlToValidate="tbTriggerCode"
																				EnableViewState="False" OnServerValidate="ValidateTriggerCode">*</asp:customvalidator></TD>
																	</TR>
																	<tr vAlign="top">
																		<td>&nbsp;
																			<P></P>
																		</td>
																		<td>
																			<P><asp:imagebutton id="ibSave" runat="server" EnableViewState="False" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"></asp:imagebutton><asp:hyperlink id="hlDone" runat="server" NavigateUrl="triggers.aspx" ImageUrl="../images/qms_done_btn.gif">Exit without saving changes</asp:hyperlink></P>
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
								<asp:panel id="pnlSubInfo" runat="server" Visible="False">
									<TR>
										<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<asp:Panel id="pnlCriteria" Runat="server" Visible="False">
												<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
													<TR>
														<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
														<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
														<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD bgColor="#d7d7c3" rowSpan="2">
															<TABLE cellSpacing="0" cellPadding="1" border="0">
																<TR>
																	<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Trigger Criteria</TD>
																</TR>
															</TABLE>
														</TD>
														<TD vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
														<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
												</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
												<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
													<TR>
														<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
														<TD width="100%" bgColor="#f0f0f0">
															<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
																<TR>
																	<TD><!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																		<asp:literal id="ltCriteriaResults" runat="server"></asp:literal>
																		<asp:datagrid id="dgCriteria" runat="server" Width="100%" AutoGenerateColumns="False">
																			<Columns>
																				<asp:TemplateColumn>
																					<ItemTemplate>
																						<asp:CheckBox id="cbSelected" runat="server"></asp:CheckBox>
																					</ItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn HeaderText="Lvl">
																					<ItemTemplate>
																						<asp:Literal id="ltLvl" runat="server"></asp:Literal>
																					</ItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn HeaderText="Type">
																					<ItemTemplate>
																						<asp:Literal id="ltCriteriaTypeName" runat="server"></asp:Literal>
																					</ItemTemplate>
																					<EditItemTemplate>
																						<asp:Literal id="ltCriteriaTypeName2" runat="server" Visible="False"></asp:Literal>
																					</EditItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn HeaderText="Not">
																					<ItemTemplate>
																						<asp:Literal id="ltCriteriaNot" runat="server"></asp:Literal>
																					</ItemTemplate>
																					<EditItemTemplate>
																						<asp:CheckBox id="cbCriteriaNot" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
																					</EditItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn HeaderText="Setting">
																					<ItemTemplate>
																						<asp:Literal id="ltSettingText" runat="server"></asp:Literal>
																					</ItemTemplate>
																					<EditItemTemplate>
																						<asp:DropDownList id="ddlAnswerCategoryID" runat="server" CssClass="gridselect" Visible="False"></asp:DropDownList>
																						<asp:CompareValidator id="cvAnswerCategoryID" runat="server" CssClass="gridlabel" ErrorMessage="Please select an answer category"
																							ControlToValidate="ddlAnswerCategoryID" ValueToCompare="0" Enabled="False" Operator="GreaterThan"
																							Type="Integer" Display="Dynamic">*</asp:CompareValidator>
																						<asp:DropDownList id="ddlCriteriaDataTypeID" runat="server" CssClass="gridselect" Visible="False"></asp:DropDownList>
																						<asp:TextBox id="tbParameterTextValue" runat="server" CssClass="gridtextfield" ToolTip="Enter parameter name"
																							Visible="False"></asp:TextBox>
																						<asp:RequiredFieldValidator id="rfvParameterTextValue" runat="server" CssClass="gridlabel" ErrorMessage="Please provide a parameter name"
																							ControlToValidate="tbParameterTextValue" Enabled="False" Display="Dynamic">*</asp:RequiredFieldValidator>
																						<asp:TextBox id="tbAnswerTextValue" runat="server" CssClass="gridtextfield" ToolTip="Enter criteria value to compare open answer or parameter text against"
																							Visible="False"></asp:TextBox>
																						<asp:CustomValidator id="cuvAnswerTextValue" runat="server" CssClass="gridlabel" ErrorMessage="Value does not match selected data type"
																							ControlToValidate="ddlCriteriaDataTypeID" OnServerValidate="ValidateCriteriaDataType" Display="Dynamic">*</asp:CustomValidator>
																					</EditItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn>
																					<ItemTemplate>
																						<TABLE cellSpacing="0" cellPadding="0" border="0">
																							<TR>
																								<TD>
																									<asp:Imagebutton id="ibCriteriaMoveUp" runat="server" ImageUrl="../images/qms_arrowup_sym.gif" CommandName="Up"></asp:Imagebutton>
																									<asp:Imagebutton id="ibCriteriaMoveDn" runat="server" ImageUrl="../images/qms_arrowdown_sym.gif"
																										CommandName="Down"></asp:Imagebutton></TD>
																								<TD></TD>
																							</TR>
																						</TABLE>
																					</ItemTemplate>
																					<EditItemTemplate>
																						&nbsp;
																					</EditItemTemplate>
																				</asp:TemplateColumn>
																				<asp:TemplateColumn>
																					<ItemTemplate>
																						<asp:ImageButton id="ibCriteriaEdit" runat="server" ImageUrl="../images/qms_dataentry1_sym.gif" CommandName="Edit"
																							CausesValidation="false"></asp:ImageButton>
																					</ItemTemplate>
																					<EditItemTemplate>
																						<asp:Imagebutton id="ibCriteriaSave" runat="server" ImageUrl="../images/qms_save_sym.gif" CommandName="Update"></asp:Imagebutton>
																						<asp:Imagebutton id="ibCriteriaCancel" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif"
																							CommandName="Cancel" CausesValidation="False"></asp:Imagebutton>
																					</EditItemTemplate>
																				</asp:TemplateColumn>
																			</Columns>
																		</asp:datagrid><!-- END DATAGRID -->
																		<TABLE cellSpacing="0" cellPadding="0" border="0">
																			<TR>
																				<TD></TD>
																				<TD>
																					<asp:dropdownlist id="ddlCriteriaTypeID" runat="server" CssClass="detselect"></asp:dropdownlist>
																					<asp:imagebutton id="ibAddCriteria" runat="server" ImageUrl="../images/qms_add_btn.gif" CausesValidation="False"></asp:imagebutton></TD>
																				<TD>&nbsp;
																					<asp:imagebutton id="ibDeleteCriteria" runat="server" ImageUrl="../images/qms_delete_btn.gif" CausesValidation="False"></asp:imagebutton></TD>
																			</TR>
																		</TABLE> <!-- END SEARCH FORM AND FIELDS TABLE --></TD>
																</TR>
															</TABLE>
														</TD>
														<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
												</TABLE>
											</asp:Panel></TD>
									</TR>
									<TR>
										<TD>
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Depending on Triggers</TD>
															</TR>
														</TABLE>
													</TD>
													<TD vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
													<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD><!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																	<asp:literal id="ltParentsResults" Runat="server"></asp:literal><!-- THIS TABLE IS THE DATAGRID -->
																	<asp:datagrid id="dgParentTriggers" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True"
																		AllowSorting="True">
																		<Columns>
																			<asp:TemplateColumn>
																				<ItemTemplate>
																					<asp:CheckBox id="cbSelectParent" runat="server"></asp:CheckBox>
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
																	</asp:datagrid><!-- END DATAGRID -->
																	<asp:DropDownList id="ddlAddParentTriggerID" runat="server" CssClass="detselect"></asp:DropDownList>
																	<asp:ImageButton id="ibAddParent" runat="server" ImageUrl="../images/qms_add_btn.gif" CausesValidation="False"></asp:ImageButton>&nbsp;
																	<asp:ImageButton id="ibDeleteParent" runat="server" ImageUrl="../images/qms_delete_btn.gif" CausesValidation="False"></asp:ImageButton><!-- END SEARCH FORM AND FIELDS TABLE --></TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
									<TR>
										<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Depending Triggers</TD>
															</TR>
														</TABLE>
													</TD>
													<TD vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
													<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD><!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																	<asp:literal id="ltChildResults" Runat="server"></asp:literal><!-- THIS TABLE IS THE DATAGRID -->
																	<asp:datagrid id="dgChildTriggers" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True"
																		AllowSorting="True">
																		<Columns>
																			<asp:TemplateColumn>
																				<ItemTemplate>
																					<asp:CheckBox id="cbSelectChild" runat="server"></asp:CheckBox>
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
																	</asp:datagrid><!-- END DATAGRID -->
																	<asp:DropDownList id="ddlAddChildTriggerID" runat="server" CssClass="detselect"></asp:DropDownList>
																	<asp:ImageButton id="ibAddChild" runat="server" ImageUrl="../images/qms_add_btn.gif" CausesValidation="False"></asp:ImageButton>&nbsp;
																	<asp:ImageButton id="ibDeleteChild" runat="server" ImageUrl="../images/qms_delete_btn.gif" CausesValidation="False"></asp:ImageButton><!-- END SEARCH FORM AND FIELDS TABLE --></TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</asp:panel></TABLE>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
