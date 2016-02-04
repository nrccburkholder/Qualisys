<%@ Page Language="vb" AutoEventWireup="false" Codebehind="copyquestions.aspx.vb" Inherits="QMSWeb.frmCopyQuestions" smartNavigation="True"%>
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
			<!-- BEGIN HEADER -->			
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
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:literal id="ltSurveyName" runat="server"></asp:literal></td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsCopyQuestions" runat="server" Width="100%"></asp:validationsummary>
																<table cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<TR>
																		<TD class="label" width="10">ID</TD>
																		<TD class="label" width="300">Question Folder</TD>
																		<TD class="label" width="100">Keyword</TD>
																		<TD width="70%">&nbsp;</TD>
																	</TR>
																	<TR>
																		<TD><asp:textbox id="tbQuestionID" runat="server" CssClass="sfnumberfield" ToolTip="Find by question id"
																				MaxLength="10"></asp:textbox><asp:regularexpressionvalidator id="revQuestionID" runat="server" ControlToValidate="tbQuestionID" ValidationExpression="^\d*$"
																				ErrorMessage="Question ID must be numeric">*</asp:regularexpressionvalidator></TD>
																		<TD><asp:dropdownlist id="ddlQuestionFolderID" runat="server" CssClass="sfselect" DataValueField="QuestionFolderID"
																				DataTextField="Name"></asp:dropdownlist></TD>
																		<TD><asp:textbox id="tbKeyword" runat="server" CssClass="sftextfield" ToolTip="Find by words in question"
																				MaxLength="100"></asp:textbox></TD>
																		<TD align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to initiate search"
																				Text="Search" EnableViewState="False"></asp:button></TD>
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
					    <td>
							<!-- THIS TABLE IS THE DATAGRID --><asp:datagrid id="dgQuestions" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox" EnableViewState="False"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="QuestionID" SortExpression="QuestionID" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="QuestionFolderID" HeaderText="Folder">
										<ItemTemplate>
											<asp:Label id="lblQuestionFolderName" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="ItemOrder" SortExpression="ItemOrder" HeaderText="Number"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="Text" HeaderText="Question">
										<ItemTemplate>
											<asp:Label id="lblQuestionText" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="QuestionTypeID" HeaderText="Type">
										<ItemTemplate>
											<asp:Label id="lblQuestionTypeName" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id=hlDGIDetails runat="server" Text="Details" ImageUrl="../images/qms_view1_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.QuestionID", "../questionbank/questiondetails.aspx?id={0}") %>' EnableViewState="False">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:datagrid>
						</td>
					</tr>
					<tr>
					    <td class="writablebg"><asp:imagebutton id="ibAdd" runat="server" ToolTip="Add selected questions" ImageUrl="../images/qms_add_btn.gif"></asp:imagebutton><asp:hyperlink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif" NavigateUrl="surveydetails.aspx">Exit back to survey</asp:hyperlink>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
