<%@ Page Language="vb" AutoEventWireup="false" Codebehind="questionbank.aspx.vb" Inherits="QMSWeb.frmQuestionBank" smartNavigation="True"%>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Question Bank</td>
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
									</td>
								<tr>
								    <td class="WritableBG">
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#f0f0f0">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td>
																<span class="resultscount">
																	<asp:Literal id="ltResultsFound" runat="server"></asp:Literal></span></td>
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
								    <td class="WritableBG">
								        <div style="height:500px;overflow:scroll">
										<asp:DataGrid id="dgQuestionFolders" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False" AllowPaging="True" PageSize="500">
											<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
											<ItemStyle VerticalAlign="Top"></ItemStyle>
											<Columns>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="QuestionFolderID" SortExpression="QuestionFolderID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="Name" HeaderText="Question Folder">
													<ItemTemplate>
														<asp:Literal id="ltFolderName" runat="server"></asp:Literal>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn SortExpression="Active" HeaderText="Active">
													<ItemTemplate>
														<asp:Literal id="ltActive" runat="server"></asp:Literal>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:HyperLink id=hlDGIDetails runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.QuestionFolderID", "questionfolderdetails.aspx?id={0}") %>' Text="Details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
											<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
										</asp:DataGrid>
										</div>
									</td>
								</tr>
								<tr>
								    <td class="WritableBG">
										<asp:HyperLink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" NavigateUrl="questionfolderdetails.aspx">Add question folder</asp:HyperLink>
										<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected question folders" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
										<!-- END TITLE AND TABLE HEADING TABLE -->
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
