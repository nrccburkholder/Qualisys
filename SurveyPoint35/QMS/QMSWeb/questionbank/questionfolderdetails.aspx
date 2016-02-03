<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="questionfolderdetails.aspx.vb" Inherits="QMSWeb.frmQuestionFolderDetails" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Folder Details</td>
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
																<asp:ValidationSummary id="vsQuestionFolderDetails" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE class="form" cellSpacing="0" cellPadding="5" border="0">
																	<TR valign="top">
																		<TD class="label" align="right" width="100">ID</TD>
																		<TD width="100"><asp:label id="lblQuestionFolderID" runat="server">NEW</asp:label></TD>
																		<TD align="right"><asp:checkbox id="cbActive" runat="server" Font-Bold="True" Text="Active" CssClass="detcheckbox"></asp:checkbox></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Name</TD>
																		<TD colspan="2"><asp:textbox id="tbName" runat="server" MaxLength="100" Width="350px" CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvQuestionFolderName" runat="server" ControlToValidate="tbName" ErrorMessage="Please provide a question folder name">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Description</TD>
																		<TD colspan="2"><asp:textbox id="tbDescription" runat="server" Columns="40" Rows="5" TextMode="MultiLine" Width="350px" CssClass="dettextfield"></asp:textbox></TD>
																	</TR>
																	<tr>
																		<td>&nbsp;</td>
																		<td colspan="2">
																			<asp:ImageButton id="ibSave" runat="server" ImageUrl="../images/qms_save_btn.gif" ToolTip="Save changes" EnableViewState="False"></asp:ImageButton>
																			<asp:hyperlink id="hlCancel" runat="server" NavigateUrl="questionbank.aspx" ImageUrl="../images/qms_done_btn.gif" EnableViewState="False">Exit without saving changes</asp:hyperlink>
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
						<td class="WritableBG">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:DataGrid id="dgQuestions" runat="server" Width="100%" AutoGenerateColumns="False">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="QuestionID" SortExpression="QuestionID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="Text" HeaderText="Question Text">
										<ItemTemplate>
											<asp:Label id="lblQuestionText" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="QuestionTypeID" HeaderText="Type">
										<ItemTemplate>
											<asp:Label id="lblTypeName" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="ItemOrder" HeaderText="Order">
										<ItemTemplate>
											<asp:DropDownList id="ddlSortIndex" runat="server" CssClass="gridselect"></asp:DropDownList>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id=HyperLink1 runat="server" Text="Details" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.QuestionID", "questiondetails.aspx?id={0}") %>' ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle Position="TopAndBottom"></PagerStyle>
							</asp:DataGrid>
							</div>
						</td>
					</tr>
					<tr>
					    <td class="writablebg"
							<asp:panel id="pnlQuestions" runat="server">
								<TABLE cellSpacing="0" cellPadding="3" border="0">
									<TR>
										<TD colSpan="4"></TD>
										<TD class="label">Question Folder</TD>
									</TR>
									<TR>
										<TD>
											<asp:HyperLink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" NavigateUrl="questiondetails.aspx">Add question</asp:HyperLink></TD>
										<TD>
											<asp:ImageButton id="ibUpdateOrder" runat="server" ToolTip="Update question order" ImageUrl="../images/qms_reorder_btn.gif"></asp:ImageButton></TD>
										<TD>
											<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected questions" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton></TD>
										<TD>
											<asp:ImageButton id="ibCopyTo" runat="server" ToolTip="Copy selected question to selected question folder" ImageUrl="../images/qms_copyto_btn.gif"></asp:ImageButton></TD>
										<TD>
											<asp:DropDownList id="ddlCopyToQuestionFolderID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
									</TR>
								</TABLE>
							</asp:panel>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
