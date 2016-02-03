<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="filedefinitions.aspx.vb" Inherits="QMSWeb.frmFileDefinitions" smartNavigation="False"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Import/Export</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsFileDefinitions" runat="server" Width="100%"></asp:validationsummary>
																<table class="formline" width="100%">
																	<TR vAlign="top">
																		<TD width="100"><span class="label">Type</span><br>
																			<asp:dropdownlist id="ddlSearchFileDefTypeID" runat="server" CssClass="sfselect" DataTextField="FileDefTypeName"
																				DataValueField="FileDefTypeID"></asp:dropdownlist></TD>
																		<TD width="100"><span class="label">Format</span><br>
																			<asp:dropdownlist id="ddlSearchFileTypeID" runat="server" CssClass="sfselect" DataTextField="FileTypeName"
																				DataValueField="FileTypeID"></asp:dropdownlist></TD>
																		<TD width="70"><span class="label">File ID</span><br>
																			<asp:textbox id="tbSearchFileDefID" runat="server" CssClass="sfnumberfield" ToolTip="Find file definition by id number"></asp:textbox><asp:comparevalidator id="cvSearchFileDefID" runat="server" Type="Integer" Operator="DataTypeCheck" ControlToValidate="tbSearchFileDefID"
																				Display="Dynamic" ErrorMessage="File ID must be numeric">*</asp:comparevalidator></TD>
																		<TD width="155"><span class="label">Keyword</span><br>
																			<asp:textbox id="tbSearchKeyword" runat="server" CssClass="sftextfield" ToolTip="Find by keyword in name"></asp:textbox></TD>
																		<td vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to initiate search"
																				Text="Search"></asp:button></td>
																	</TR>
																</table>
																<table class="formline">
																	<tr>
																		<TD><span class="label">Survey</span><br>
																			<asp:dropdownlist id="ddlSearchSurveyID" runat="server" CssClass="sfselect" DataTextField="Name" DataValueField="SurveyID"></asp:dropdownlist></TD>
																		<TD><span class="label">Client</span><br>
																			<asp:dropdownlist id="ddlSearchClientID" runat="server" CssClass="sfselect" DataTextField="Name" DataValueField="ClientID"></asp:dropdownlist></TD>
																	</tr>
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
						<td class="writablebg">
							<span class="resultscount"><asp:literal id="ltResultsFound" Runat="server"></asp:literal></span>
						</td>
					</tr>
					<tr>
					    <td class="writablebg">
					            <div style="height:500px;overflow:scroll">
								<!-- THIS TABLE IS THE DATAGRID --><asp:datagrid id="dgFileDefs" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False"
									AllowPaging="True" PageSize="500">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="FileDefID" SortExpression="FileDefID" HeaderText="ID"></asp:BoundColumn>
										<asp:BoundColumn DataField="FileDefName" SortExpression="FileDefName" HeaderText="Name"></asp:BoundColumn>
										<asp:TemplateColumn SortExpression="SurveyID" HeaderText="Survey">
											<ItemTemplate>
												<asp:Literal id="ltSurveyName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="ClientID" HeaderText="Client">
											<ItemTemplate>
												<asp:Literal id="ltClientName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="FileDefTypeID" HeaderText="Type">
											<ItemTemplate>
												<asp:Literal id="ltTypeName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="FileTypeID" HeaderText="Format">
											<ItemTemplate>
												<asp:Literal id="ltFormatName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<asp:HyperLink id=hlExecute runat="server" ToolTip="Execute Import/Export" Text="Execute" NavigateUrl='<%# String.Format("ExecuteFileDef.aspx?id={0}&amp;psid={1}", Container.DataItem("FileDefID"), m_iProtocolStepID) %>' ImageUrl="../images/qms_arrowright_sym.gif">Execute</asp:HyperLink>
												<asp:HyperLink id=hlCopy runat="server" ToolTip="Copy" Text="Copy" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.FileDefID", "FileDefinitionDetails.aspx?copy={0}") %>' ImageUrl="../images/qms_copy_sym.gif">Copy</asp:HyperLink>
												<asp:HyperLink id=hlDetails runat="server" Text="Details" NavigateUrl='<%# String.Format("FileDefinitionDetails.aspx?id={0}&amp;psid={1}", Container.DataItem("FileDefID"), m_iProtocolStepID) %>' ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
											</ItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:datagrid>
								</div>
							</td>
						</tr>
						<tr>
						    <td class="writablebg">
						        <asp:hyperlink id="hlAdd" runat="server" NavigateUrl="filedefinitiondetails.aspx" ImageUrl="../images/qms_add_btn.gif">Create new file definition</asp:hyperlink><asp:imagebutton id="ibDelete" runat="server" ToolTip="Delete selected file definitions" ImageUrl="../images/qms_delete_btn.gif"></asp:imagebutton></p>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
