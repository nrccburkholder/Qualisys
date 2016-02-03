<%@ Page Language="vb" AutoEventWireup="false" Codebehind="clients.aspx.vb" Inherits="QMSWeb.frmClients" smartNavigation="True"%>
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
			<p>
				<TABLE class="main" align="center">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Clients</td>
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
															<td><span class="resultscount"><asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span></td>
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
								    <td class="writablebg">
								        <div style="height:500px;overflow:scroll">
										<asp:datagrid id="dgClients" runat="server" AllowPaging="True" PageSize="500" AutoGenerateColumns="False" AllowSorting="True" Width="100%">
											<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
											<ItemStyle VerticalAlign="Top"></ItemStyle>
											<Columns>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="ClientID" SortExpression="ClientID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
												<asp:BoundColumn DataField="Name" SortExpression="Name" ReadOnly="True" HeaderText="Name"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="Address1" HeaderText="Address">
													<ItemTemplate>
														<%# DMI.clsUtil.FormatHTMLAddress(Container.DataItem("Address1"), Container.DataItem("Address2"), Container.DataItem("City"), Container.DataItem("State"), Container.DataItem("PostalCode")) %>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn SortExpression="Active" HeaderText="Active">
													<ItemTemplate>
														<%# IIf(Container.DataItem("Active")=1, "Yes", "No") %>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:HyperLink id=HyperLink1 runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ClientID", "clientdetails.aspx?id={0}") %>' ImageUrl="../images/qms_view1_sym.gif" Text="Details">Details</asp:HyperLink>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
											<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
										</asp:datagrid>
										</div>
									</td>
								</tr>
								<tr>
								    <td class="WritableBG">
										<asp:hyperlink id="hlAddClient" runat="server" NavigateUrl="clientdetails.aspx" ImageUrl="../images/qms_add_btn.gif">Add Client</asp:hyperlink>
										<asp:ImageButton id="ibDelete" runat="server" ImageUrl="../images/qms_delete_btn.gif" ToolTip="Delete selected clients"></asp:ImageButton>
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
