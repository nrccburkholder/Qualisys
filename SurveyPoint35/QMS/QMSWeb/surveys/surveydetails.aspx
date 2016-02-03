<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="surveydetails.aspx.vb" Inherits="QMSWeb.frmSurveyDetails" smartNavigation="True"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<link href="../Styles.css" type="text/css" rel="stylesheet" />
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<p>
				<TABLE class="main" align="center" boder="0" cellpadding="0" cellspacing="0">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Survey Details</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsSurveyDetails" runat="server" Width="100%"></asp:validationsummary>
																<TABLE cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<TR vAlign="top">
																		<TD class="label" align="right" width="100">Survey ID</TD>
																		<TD width="100"><asp:label id="lblSurveyID" runat="server"></asp:label></TD>
																		<TD align="right" colSpan="2"><asp:checkbox id="cbActive" runat="server" CssClass="detcheckbox" Text="Active" Font-Bold="True"></asp:checkbox></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Survey Name</TD>
																		<TD colSpan="3"><asp:textbox id="tbName" runat="server" Width="350px" CssClass="dettextfield" MaxLength="100"></asp:textbox><asp:requiredfieldvalidator id="rfvName" runat="server" ControlToValidate="tbName" ErrorMessage="Please provide a survey name">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Description</TD>
																		<TD colSpan="3"><asp:textbox id="tbDescription" runat="server" Width="350px" CssClass="dettextfield" MaxLength="1000"
																				TextMode="MultiLine" Rows="5"></asp:textbox>
																			<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Please provide a description"
																				ControlToValidate="tbDescription" EnableViewState="False">*</asp:RequiredFieldValidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Created By</TD>
																		<TD><asp:label id="lblCreatedBy" runat="server"></asp:label></TD>
																		<TD class="label" align="right">Created On</TD>
																		<TD><asp:label id="lblCreatedOnDate" runat="server"></asp:label></TD>
																	</TR>
																	<TR>
																		<TD></TD>
																		<TD colSpan="3"><asp:hyperlink id="hlViewSurveyInstances" runat="server" ToolTip="View survey instances for this survey"
																				NavigateUrl="../surveyinstances/surveyinstances.aspx">View Survey Instances</asp:hyperlink>&nbsp;
																			<asp:hyperlink id="hlViewScripts" runat="server" ToolTip="View scripts for this survey" NavigateUrl="../scripts/scripts.aspx">View Survey Scripts</asp:hyperlink>&nbsp;
																			<!--<asp:HyperLink id="hlPrint" runat="server" ToolTip="View printable version of survey" Target="_NEW">Printable</asp:HyperLink>--></TD>
																	</TR>
																	<TR>
																		<TD></TD>
																		<td colSpan="3">
																			<p><asp:imagebutton id="ibSave" runat="server" ToolTip="Save changes" EnableViewState="False" ImageUrl="../images/qms_save_btn.gif"></asp:imagebutton><asp:hyperlink id="hlCancel" runat="server" NavigateUrl="surveys.aspx" EnableViewState="False"
																					ImageUrl="../images/qms_done_btn.gif">Exit without saving changes</asp:hyperlink></p>
																		</td>
																	</TR>
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
						<td class="writablebg"><asp:literal id="ltResultsFound" Runat="server"></asp:literal></td>
					</tr>
					<tr>
					    <td class="Writablebg">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:datagrid id="dgSurveyQuestions" runat="server" Width="100%" AutoGenerateColumns="False">
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
									<asp:BoundColumn DataField="QuestionID" SortExpression="QuestionID" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn HeaderText="Question">
										<ItemTemplate>
											<asp:Literal id="ltQuestionText" runat="server" EnableViewState="False"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id=hlDGIDetails runat="server" Text="Details" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.QuestionID", "../questionbank/questiondetails.aspx?id={0}&amp;refer=1") %>' ImageUrl="../images/qms_view1_sym.gif" EnableViewState="False">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:datagrid>
							</div>
						</td>
					</tr>
					<tr>
					    <td class="WritableBG">
					        <asp:panel id="pnlSurveyQuestionLinks" runat="server">
								<asp:HyperLink id="hlAddSurveyQuestion" runat="server" NavigateUrl="copyquestions.aspx" ImageUrl="../images/qms_add_btn.gif">Add Survey Question</asp:HyperLink>
								<asp:ImageButton id="ibUpdateOrder" runat="server" ToolTip="Update question order" ImageUrl="../images/qms_reorder_btn.gif"></asp:ImageButton>
								<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected questions" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
							</asp:panel>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
