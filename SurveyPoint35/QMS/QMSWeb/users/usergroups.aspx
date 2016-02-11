<%@ Page Language="vb" AutoEventWireup="false" Codebehind="usergroups.aspx.vb" Inherits="QMSWeb.frmUserGroups" smartNavigation="True"%>
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
				<TABLE class="main" align="center">
					<tr>
						<td>
							<table cellSpacing="0" cellPadding="0" width="100%" border="0">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;User Groups</td>
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
								</tr>
								<tr>
								    <td>
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
								    <td>
										<asp:DataGrid id="dgUserGroups" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" AllowCustomPaging="True" DataKeyField="GroupID">
											<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
											<ItemStyle VerticalAlign="Top"></ItemStyle>
											<Columns>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="GroupID" SortExpression="GroupID" HeaderText="Group ID"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="Name" HeaderText="Name">
													<ItemTemplate>
														<asp:Label id=Label2 runat="server" Font-Bold="true" Text='<%# Container.DataItem("Name") %>'>
														</asp:Label><BR>
														<asp:Label id=Label1 runat="server" Text='<%# Container.DataItem("Description") %>' Font-Size="8pt">
														</asp:Label>
													</ItemTemplate>
													<EditItemTemplate>
														<asp:TextBox id=TextBox2 runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Name") %>'>
														</asp:TextBox>
													</EditItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:HyperLink id=hlDGIDetails runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.GroupID", "usergroupdetails.aspx?id={0}") %>' Text="Details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
											<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
										</asp:DataGrid>
									</td>
								</tr>
								<tr>
								    <td style="background-color:#f0f0f0">
										<asp:HyperLink id="hlAddUserGroup" runat="server" NavigateUrl="usergroupdetails.aspx" ImageUrl="../images/qms_add_btn.gif">Add User Group</asp:HyperLink>
										<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected user groups" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>									
									</td>
								</tr>
							</table>							
						</td>
					</tr>
					<tr>
						<td></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
