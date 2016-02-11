<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="mailingseeds.aspx.vb" Inherits="QMSWeb.frmMailingSeeds" smartNavigation="False"%>
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
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Mailing Seeds</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<asp:ValidationSummary id="vsMailingSeeds" runat="server" Width="100%"></asp:ValidationSummary>
																<TABLE cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<tr>
																		<td class="label" align="right" width="120">Survey Instance</td>
																		<td><asp:hyperlink id="hlSurveyInstance" runat="server" ToolTip="Click to go to survey instance details page"></asp:hyperlink></td>
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
						<td style="background-color:#f0f0f0">
							<span class="resultscount"><asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span>
								<!-- THIS TABLE IS THE DATAGRID -->
								<asp:datagrid id="dgMailingSeeds" runat="server" AutoGenerateColumns="False" AllowSorting="True" AllowPaging="True" Width="100%">
									<EditItemStyle Wrap="False" VerticalAlign="Top"></EditItemStyle>
									<AlternatingItemStyle Wrap="False" VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle Wrap="False" VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="RespondentID" SortExpression="RespondentID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
										<asp:TemplateColumn SortExpression="LastName" HeaderText="Name">
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<%# DMI.clsUtil.FormatFullName(Container.DataItem("FirstName"), Container.DataItem("MiddleInitial"), Container.DataItem("LastName"))%>
											</ItemTemplate>
											<EditItemTemplate>
												<TABLE cellSpacing="2" cellPadding="0" width="100%" border="0">
													<TR style="FONT-SIZE: 8pt">
														<TD>First</TD>
														<TD>MI</TD>
														<TD>Last</TD>
													</TR>
													<TR>
														<TD>
															<asp:TextBox id=tbFirstName runat="server" CssClass="gridtextfield" Text='<%# Container.DataItem("FirstName") %>' MaxLength="100">
															</asp:TextBox></TD>
														<TD>
															<asp:TextBox id=tbInitial runat="server" Width="20px" CssClass="gridtextfield" Text='<%# Container.DataItem("MiddleInitial") %>' MaxLength="10">
															</asp:TextBox></TD>
														<TD nowrap>
															<asp:TextBox id=tbLastName runat="server" CssClass="gridtextfield" Text='<%# Container.DataItem("LastName") %>' MaxLength="100">
															</asp:TextBox>
															<asp:RequiredFieldValidator id="rfvLastName" runat="server" ControlToValidate="tbLastName" ErrorMessage="Please provide last name">*</asp:RequiredFieldValidator></TD>
													</TR>
												</TABLE>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="Address1" HeaderText="Address">
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<%# Container.DataItem("Address1") %>
												<BR>
												<%# Container.DataItem("Address2") %>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbAddress1 runat="server" Width="200px" CssClass="gridtextfield" Text='<%# Container.DataItem("Address1") %>' MaxLength="250">
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvAddress1" runat="server" ControlToValidate="tbAddress1" ErrorMessage="Please provide an address">*</asp:RequiredFieldValidator><BR>
												<asp:TextBox id=tbAddress2 runat="server" Width="200px" CssClass="gridtextfield" Text='<%# Container.DataItem("Address2") %>' MaxLength="250">
												</asp:TextBox><BR>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="City" HeaderText="City">
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<%# Container.DataItem("City") %>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbCity runat="server" Width="100px" CssClass="gridtextfield" Text='<%# Container.DataItem("City") %>' MaxLength="100">
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvCity" runat="server" ControlToValidate="tbCity" ErrorMessage="Please provide a city">*</asp:RequiredFieldValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="State" HeaderText="State">
											<ItemTemplate>
												<%# Container.DataItem("State") %>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:DropDownList id="ddlState" runat="server" CssClass="gridselect"></asp:DropDownList>
												<asp:CompareValidator id="cvState" runat="server" ControlToValidate="ddlState" ErrorMessage="Please provide a state" ValueToCompare='""' Operator="NotEqual">*</asp:CompareValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="PostalCode" HeaderText="Zip">
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<%# Container.DataItem("PostalCode") %>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbPostalCode runat="server" MaxLength="10" Text='<%# Container.DataItem("PostalCode") %>' CssClass="gridtextfield">
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvPostalCode" runat="server" ErrorMessage="Please provide a zip code" ControlToValidate="tbPostalCode">*</asp:RequiredFieldValidator>
												<asp:RegularExpressionValidator id="revPostalCode" runat="server" ErrorMessage="Please provide a valid zip code" ControlToValidate="tbPostalCode" Display="Dynamic" ValidationExpression="\d{5}(-\d{4})?">*</asp:RegularExpressionValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<asp:ImageButton id="ibDGIEdit" runat="server" ImageUrl="../images/qms_dataentry1_sym.gif" CommandName="Edit" CausesValidation="False"></asp:ImageButton>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:LinkButton id="lbDGISave" runat="server" CommandName="Update">
													<asp:Image id="imgDGISave" runat="server" ImageUrl="../images/qms_save_sym.gif" AlternateText="Save"></asp:Image>
												</asp:LinkButton>
												<asp:LinkButton id="lbDGIClose" runat="server" CommandName="Cancel" CausesValidation="false">
													<asp:Image id="imgDGIClose" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif" AlternateText="Close"></asp:Image>
												</asp:LinkButton>
											</EditItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:datagrid>
								<asp:Panel id="pnlMailingSeedLinks" runat="server">
									<asp:ImageButton id="ibAdd" runat="server" ToolTip="Add mailing seed" ImageUrl="../images/qms_add_btn.gif" DESIGNTIMEDRAGDROP="111"></asp:ImageButton>
									<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected mailing seeds" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
								</asp:Panel>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
