<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="protocols.aspx.vb" Inherits="QMSWeb.frmProtocols" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Protocols</td>
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
																<asp:ValidationSummary id="vsProtocols" runat="server" Width="100%"></asp:ValidationSummary>
																<table class="form" width="100%">
																	<TR>
																		<TD style="WIDTH: 84px">
																			<span class="label">Protocol ID</span><br>
																			<asp:TextBox id="tbProtocolID" runat="server" MaxLength="10" ToolTip="Find by protocol id" CssClass="sfnumberfield"></asp:TextBox>
																			<asp:CompareValidator id="cvProtocolID" runat="server" ErrorMessage="Protocol ID must be numeric" Display="Dynamic" ControlToValidate="tbProtocolID" Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator></TD>
																		<TD style="WIDTH: 315px">
																			<span class="label">Keyword</span><br>
																			<asp:TextBox id="tbKeyword" runat="server" MaxLength="100" ToolTip="Find by keyword in protocol name or description" CssClass="sftextfield"></asp:TextBox></TD>
																		<TD align="right">
																			<asp:Button id="btSearch" runat="server" Text="Search" ToolTip="Click to initiate search" CssClass="button"></asp:Button></TD>
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
							<span class="resultscount">
								<asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span>
						</td>
					</tr>
					<tr>
					    <td>
					    <div style="height:500px;overflow:scroll">
							<asp:DataGrid id="dgProtocols" runat="server" Width="100%" AllowSorting="True" PageSize="500" AutoGenerateColumns="False" AllowPaging="True">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:BoundColumn DataField="ProtocolID" SortExpression="ProtocolID" HeaderText="ID"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="Name" HeaderText="Protocol Name">
										<ItemTemplate>
											<asp:Literal id="ltProtocolName" runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="CreatedByUserID" HeaderText="Author">
										<ItemTemplate>
											<asp:Literal id="ltAuthorName" runat="server"></asp:Literal>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id=HyperLink1 runat="server" Text="Details" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ProtocolID", "protocoldetails.aspx?id={0}") %>' ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
							</asp:DataGrid>
						</div>
						</td>
					</tr>
					<tr>
					    <td class="writablebg">
							<asp:HyperLink id="hlAdd" runat="server" NavigateUrl="protocoldetails.aspx" ImageUrl="../images/qms_add_btn.gif">Add protocol</asp:HyperLink>
							<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected protocols" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
							<!-- END DATAGRID -->
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
