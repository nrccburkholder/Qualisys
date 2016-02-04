<%@ Page Language="vb" AutoEventWireup="false" Codebehind="surveyinstanceevents.aspx.vb" Inherits="QMSWeb.frmSurveyInstanceEvents" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Survey Instance Events</td>
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
																<asp:ValidationSummary id="vsSurveyInstanceEvents" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<TR valign="top">
																		<TD class="label" align="right" width="120">Survey Instance</TD>
																		<TD><asp:HyperLink id="hlSurveyInstance" runat="server"></asp:HyperLink></TD>
																	</TR>
																</TABLE> <!-- END SEARCH FORM AND FIELDS TABLE --></td>
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
							<asp:DataGrid id="dgSurveyInstanceEvents" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False" AllowPaging="True" PageSize="200">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn SortExpression="UseEvent" HeaderText="Use">
										<ItemTemplate>
											<asp:CheckBox id=cbUseEventDisplay runat="server" Enabled="False" Checked='<%# Container.DataItem("UseEvent") %>' CssClass="gridcheckbox">
											</asp:CheckBox>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:CheckBox id="cbUseEvent" runat="server" Checked="True" ToolTip="Check to use event in survey instance" CssClass="gridcheckbox"></asp:CheckBox>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="EventID" SortExpression="EventID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
									<asp:BoundColumn DataField="EventName" SortExpression="EventName" ReadOnly="True" HeaderText="Event Name"></asp:BoundColumn>
									<asp:BoundColumn DataField="EventTypeName" SortExpression="EventTypeName" ReadOnly="True" HeaderText="Type"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="NonContactHours" HeaderText="Hours">
										<ItemTemplate>
											<asp:Label id=Label1 runat="server" Text='<%# Container.DataItem("NonContactHours") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbNonContactHours runat="server" ToolTip="Number of hours after event time before respondent can be contacted again" CssClass="gridnumberfield" Text='<%# Container.DataItem("NonContactHours") %>' MaxLength="3">
											</asp:TextBox>
											<asp:RequiredFieldValidator id="rfvNonContactHours" runat="server" ControlToValidate="tbNonContactHours" Display="Dynamic" ErrorMessage="Please provide non-contact hours value">*</asp:RequiredFieldValidator>
											<asp:CompareValidator id="cvNonContactHours" runat="server" ControlToValidate="tbNonContactHours" ErrorMessage="Non-contact hours must be greater than or equal to zero" Operator="GreaterThanEqual" ValueToCompare="0" Type="Integer">*</asp:CompareValidator>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="TranslationValue" HeaderText="Translation">
										<ItemTemplate>
											<asp:Label id=Label2 runat="server" Text='<%# Container.DataItem("TranslationValue") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbTranslationValue runat="server" ToolTip="Translated event code for exporting" CssClass="gridtextfield" Text='<%# Container.DataItem("TranslationValue") %>' MaxLength="50">
											</asp:TextBox>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="Final" HeaderText="Final">
										<ItemTemplate>
											<asp:CheckBox id=cbFinalDisplay runat="server" Enabled="False" Checked='<%# Container.DataItem("Final") %>' CssClass="gridcheckbox">
											</asp:CheckBox>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:CheckBox id=cbFinal runat="server" Checked='<%# Container.DataItem("Final") %>' ToolTip="Check to indicate code is final" CssClass="gridcheckbox">
											</asp:CheckBox>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:ImageButton id="ibDGIEdit" runat="server" CausesValidation="False" CommandName="Edit" ImageUrl="../images/qms_dataentry1_sym.gif" ToolTip="Edit"></asp:ImageButton>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:LinkButton id="lbDGIUpdate" runat="server" CommandName="Update">
												<asp:Image id="Image1" runat="server" ImageUrl="../images/qms_save_sym.gif" AlternateText="Save"></asp:Image>
											</asp:LinkButton>
											<asp:LinkButton id="lbDGICancel" runat="server" CausesValidation="false" CommandName="Cancel">
												<asp:Image id="Image2" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif" AlternateText="Close"></asp:Image>
											</asp:LinkButton>
										</EditItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
							</asp:DataGrid>
							</div>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
