<%@ Page Language="vb" AutoEventWireup="false" Codebehind="events.aspx.vb" Inherits="QMSWeb.frmEvents" smartNavigation="False"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Events</td>
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
																<asp:ValidationSummary id="vsEvents" runat="server" Width="100%"></asp:ValidationSummary>
																<table class="formline" width="100%">
																	<TR>
																		<TD width="100"><span class="label">Type</span><br>
																			<asp:dropdownlist id="ddlEventTypeIDSearch" runat="server" DataTextField="Name" DataValueField="EventTypeID"
																				CssClass="sfselect">
																				<asp:ListItem Value="All Types">All Types</asp:ListItem>
																				<asp:ListItem Value="System">System</asp:ListItem>
																				<asp:ListItem Value="User Actions">User Actions</asp:ListItem>
																				<asp:ListItem Value="Mailing">Mailing</asp:ListItem>
																				<asp:ListItem Value="Data Entry">Data Entry</asp:ListItem>
																				<asp:ListItem Value="Calling">Calling</asp:ListItem>
																			</asp:dropdownlist></TD>
																		<TD width="100"><span class="label">Keyword</span><br>
																			<asp:textbox id="tbNameSearch" runat="server" MaxLength="100" CssClass="sftextfield"></asp:textbox></TD>
																		<TD width="100"><span class="label">ID</span><br>
																			<asp:textbox id="tbEventIDSearch" runat="server" MaxLength="10" CssClass="sfnumberfield"></asp:textbox>
																			<asp:CompareValidator id="cvEventIDSearch" runat="server" ErrorMessage="Event ID must be numeric" ControlToValidate="tbEventIDSearch"
																				Display="Dynamic" Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																		<TD align="right" valign="bottom">
																			<asp:button id="btnSearch" runat="server" Text="Search" CssClass="button"></asp:button></TD>
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
						<td class="WritableBG">
							<!-- THIS TABLE IS THE DATAGRID -->
							<span class="resultscount"><asp:Literal id="ltResultsFound" runat="server"></asp:Literal></span>
						</td>
					</tr>
					<tr>
					    <td>
					           <div style="height:500px;overflow:scroll">
								<asp:datagrid id="dgEvents" runat="server" Width="100%" AllowPaging="True" PageSize="500" AllowSorting="True"
									AutoGenerateColumns="False">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="EventID" HeaderText="ID">
											<ItemTemplate>
												<asp:Label id=lblEventID runat="server" Text='<%# Container.DataItem("EventID") %>'>
												</asp:Label>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbEventID runat="server" CssClass="gridnumberfield" Text='<%# Container.DataItem("EventID") %>'>
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvEventID" Display="Static" ControlToValidate="tbEventID" ErrorMessage="Please provide an event ID"
													Runat="server">*</asp:RequiredFieldValidator>
												<asp:CompareValidator id="cvEventID" runat="server" Operator="GreaterThan" Type="Integer" Display="Dynamic"
													ControlToValidate="tbEventID" ErrorMessage="Event ID must be greater than zero" ValueToCompare="0">*</asp:CompareValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="Name" HeaderText="Event">
											<ItemTemplate>
												<asp:Label id=lblName runat="server" Text='<%# Container.DataItem("Name") %>' Font-Bold="True">
												</asp:Label><BR>
												<asp:Label id=lblDescription runat="server" Text='<%# Container.DataItem("Description") %>' Font-Size="10pt" Font-Italic="True">
												</asp:Label>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbName runat="server" Width="300px" MaxLength="100" CssClass="gridtextfield" Text='<%# Container.DataItem("Name") %>'>
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvName" runat="server" Display="static" ControlToValidate="tbName" ErrorMessage="Please provide an event name">*</asp:RequiredFieldValidator><BR>
												<asp:TextBox id=tbDescription runat="server" Width="300px" MaxLength="1000" CssClass="gridtextfield" Text='<%# Container.DataItem("Description") %>' Rows="3" TextMode="MultiLine">
												</asp:TextBox><BR>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="EventTypeID" HeaderText="Type">
											<ItemTemplate>
												<asp:Label id=lbEventTypeName runat="server" Text='<%# Container.DataItem("EventTypeName") %>'>
												</asp:Label>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:DropDownList id="ddlEventTypeID" runat="server" DataValueField="EventTypeID" DataTextField="Name"
													CssClass="gridselect"></asp:DropDownList>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="DefaultNonContact" HeaderText="Non-Contact Hours">
											<ItemTemplate>
												<asp:Label id=Label1 runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.DefaultNonContact") %>'>
												</asp:Label>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbDefaultNonContact runat="server" MaxLength="2" CssClass="gridnumberfield" Text='<%# DataBinder.Eval(Container, "DataItem.DefaultNonContact") %>'>
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvDefaultNonContact" runat="server" Display="Dynamic" ControlToValidate="tbDefaultNonContact"
													ErrorMessage="Required">*</asp:RequiredFieldValidator>
												<asp:CompareValidator id="cvDefaultNonContact" runat="server" Operator="GreaterThanEqual" Type="Integer"
													Display="Dynamic" ControlToValidate="tbDefaultNonContact" ErrorMessage="Non-contact hours must be zero or greater"
													ValueToCompare="0">*</asp:CompareValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="FinalCode" HeaderText="Final">
											<ItemTemplate>
												<asp:Label id="Label2" runat="server"></asp:Label>
												<asp:CheckBox id=cbFinalCodeDisplay runat="server" checked='<%# Container.DataItem("FinalCode") %>' Enabled="False">
												</asp:CheckBox>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:CheckBox id=cbFinalCode runat="server" CssClass="gridcheckbox" checked='<%# Container.DataItem("FinalCode") %>'>
												</asp:CheckBox>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:ImageButton id="ibDGIEdit" runat="server" CausesValidation="False" CommandName="Edit" ImageUrl="../images/qms_dataentry1_sym.gif"
													ToolTip="Edit"></asp:ImageButton>
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
								</asp:datagrid>
								</div>
							</td>
						</tr>
						<tr>
						    <td class="writablebg">
								<asp:Panel id="pnlEventLinks" runat="server">
									<asp:ImageButton id="ibAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" ToolTip="Add event code"></asp:ImageButton>
									<asp:ImageButton id="ibDelete" runat="server" ImageUrl="../images/qms_delete_btn.gif" ToolTip="Delete selected event code"></asp:ImageButton>
								</asp:Panel>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
