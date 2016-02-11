<%@ Page Language="vb" AutoEventWireup="false" Codebehind="questiondetails.aspx.vb" Inherits="QMSWeb.frmQuestionDetails" smartNavigation="False"%>
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
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
			<p>
				<TABLE class="main" align="center" cellpadding="0" cellspacing="0" border="0">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Question Details</td>
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
																<asp:ValidationSummary id="vsQuestion" Runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" border="0">
																	<TR valign="top">
																		<TD class="label" align="right" width="150">Question Folder</TD>
																		<TD><asp:label id="lblQuestionFolderID" runat="server"></asp:label>&nbsp;-&nbsp;<asp:label id="lblQuestionFolderName" runat="server"></asp:label></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Question ID</TD>
																		<TD><asp:label id="lblQuestionID" runat="server">NEW</asp:label></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Question Text</TD>
																		<TD><asp:textbox id="tbText" runat="server" MaxLength="3000" Rows="5" TextMode="MultiLine" Width="350px"
																				CssClass="dettextfield"></asp:textbox>
																			<asp:requiredfieldvalidator id="rfvQuestionText" runat="server" ControlToValidate="tbText" ErrorMessage="Question text cannot be blank."
																				Display="Dynamic">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Description</TD>
																		<TD vAlign="top"><asp:textbox id="tbShortDesc" runat="server" MaxLength="100" Rows="3" Width="350px" CssClass="dettextfield"></asp:textbox>
																			<asp:RequiredFieldValidator id="rfvShortDesc" runat="server" ErrorMessage="Description cannot be blank." ControlToValidate="tbShortDesc">*</asp:RequiredFieldValidator></TD>
																	</TR>
																	<TR valign="top">
																		<TD class="label" align="right">Type</TD>
																		<TD vAlign="top"><asp:dropdownlist id="ddlQuestionTypeID" runat="server" DataValueField="QuestionTypeID" DataTextField="Name"
																				CssClass="detselect"></asp:dropdownlist></TD>
																	</TR>
																	<tr valign="top">
																		<td>&nbsp;</td>
																		<td>
																			<P>
																				<asp:ImageButton id="ibSave" runat="server" ImageUrl="../images/qms_save_btn.gif" ToolTip="Save changes"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:ImageButton id="ibSaveNew" runat="server" ToolTip="Save changes and start new question" ImageUrl="../images/qms_save_new_btn.gif"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:hyperlink id="hlCancel" runat="server" NavigateUrl="questionfolderdetails.aspx?qfid={0}" ImageUrl="../images/qms_done_btn.gif">Exit without saving changes</asp:hyperlink></P>
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
							<asp:datagrid id="dgAnswerCategories" runat="server" Width="100%" AutoGenerateColumns="False">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="AnswerCategoryTypeID" HeaderText="Type">
										<ItemTemplate>
											<asp:Label id="lblCategoryTypeName" runat="server"></asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:DropDownList id="ddlAnswerCategoryTypeID" runat="server" DataTextField="AnswerCategoryTypeName"
												DataValueField="AnswerCategoryTypeID" CssClass="gridselect"></asp:DropDownList>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="AnswerValue" HeaderText="Value">
										<ItemTemplate>
											<asp:Label id=Label2 runat="server" Text='<%# Container.DataItem("AnswerValue") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbAnswerValue runat="server" MaxLength="10" ToolTip="Numeric value and order of answer category" CssClass="gridnumberfield" Text='<%# Container.DataItem("AnswerValue") %>'>
											</asp:TextBox>
											<asp:RegularExpressionValidator id="revAnswerValue" runat="server" Display="Dynamic" ErrorMessage="Answer value must be numeric."
												ControlToValidate="tbAnswerValue" ValidationExpression="-?[\d]*">*</asp:RegularExpressionValidator>
											<asp:RequiredFieldValidator id="rfvAnswerValue" runat="server" Display="Dynamic" ErrorMessage="Answer value is required"
												ControlToValidate="tbAnswerValue">*</asp:RequiredFieldValidator>
											<asp:CompareValidator id="cvAnswerValue" runat="server" Display="Dynamic" ErrorMessage="Answer value must be zero or greater"
												ControlToValidate="tbAnswerValue" Type="Integer" ValueToCompare="-1" Operator="GreaterThan">*</asp:CompareValidator>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="AnswerText" HeaderText="Text">
										<ItemTemplate>
											<asp:Label id=Label3 runat="server" Text='<%# Container.DataItem("AnswerText") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbAnswerText runat="server" Width="200px" MaxLength="1000" ToolTip="Text description for answer category" CssClass="gridtextfield" Text='<%# Container.DataItem("AnswerText") %>'>
											</asp:TextBox>
											<asp:RequiredFieldValidator id="rfvAnswerText" runat="server" ErrorMessage="Answer text is required" ControlToValidate="tbAnswerText">*</asp:RequiredFieldValidator>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:ImageButton id="ibDGIEdit" runat="server" EnableViewState="False" ImageUrl="../images/qms_dataentry1_sym.gif"
												CausesValidation="False" CommandName="Edit"></asp:ImageButton>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:LinkButton id="lbDGISave" runat="server" EnableViewState="False" CommandName="Update">
												<asp:Image runat="server" AlternateText="Save" ID="imgDGISave" ImageUrl="../images/qms_save_sym.gif"></asp:Image>
											</asp:LinkButton>
											<asp:LinkButton id="lbDGIClose" runat="server" EnableViewState="False" CausesValidation="false"
												CommandName="Cancel">
												<asp:Image runat="server" AlternateText="Close" ID="imgDGIClose" ImageUrl="../images/qms_close_delete2_sym.gif"></asp:Image>
											</asp:LinkButton>
										</EditItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:datagrid>
						</td>
					</tr>
					<tr>
					    <td class="writablebg">
							<asp:Panel id="pnlAnswerCategoryLinks" runat="server">
								<asp:ImageButton id="ibAdd" runat="server" EnableViewState="False" ToolTip="Add answer category"
									ImageUrl="../images/qms_add_btn.gif"></asp:ImageButton>
								<asp:ImageButton id="ibDelete" runat="server" EnableViewState="False" ToolTip="Delete selected answer categories"
									ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
							</asp:Panel>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
