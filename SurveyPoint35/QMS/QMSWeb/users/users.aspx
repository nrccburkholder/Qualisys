<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="users.aspx.vb" Inherits="QMSWeb.frmUsers" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Users</td>
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
								    <td style="background-color:#f0f0f0">
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#f0f0f0">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td><span class="resultscount"><asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span></td>
														</tr>
														<tr>
														    <td>
														        <table border="0" cellpadding="0" cellspacing="0" width="100%">
														        <tr>
														            <td><span class="label">Active Only: <asp:checkbox id="cbActive" runat="server" ToolTip="Check to find only active" CssClass="sfcheckbox" Checked="True"></asp:checkbox>
                                                                        </span></td>
														            <td align="right"><asp:button id="btnSearch" runat="server" Text="Search" ToolTip="Click to initiate search" CssClass="button"></asp:button></td>
														        </tr>
														        </table>
														    </td>
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
										<!-- END TITLE AND TABLE HEADING TABLE -->
										<div style="height:500px;overflow:scroll">
										<asp:DataGrid id="dgUsers" runat="server" Width="100%" AutoGenerateColumns="False" AllowPaging="True" PageSize="500"
											AllowSorting="True">
											<Columns>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:CheckBox id="cbSelected" runat="server"></asp:CheckBox>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:BoundColumn DataField="UserID" SortExpression="UserID" HeaderText="User ID"></asp:BoundColumn>
												<asp:BoundColumn DataField="Username" SortExpression="Username" HeaderText="Username"></asp:BoundColumn>
												<asp:TemplateColumn SortExpression="LastName" HeaderText="Name">
													<ItemTemplate>
														<asp:Label runat="server" Text='<%# String.Format("{0} {1}", Container.DataItem("LastName"), Iif(Container.DataItem("FirstName").ToString = "", "", ", " & Container.DataItem("FirstName"))) %>' ID="Label1">
														</asp:Label>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn SortExpression="Active" HeaderText="Active">
													<ItemTemplate>
														<asp:Label runat="server" Text='<%# IIf(Container.DataItem("Active") = 1, "Yes", "No")%>' ID="Label2">
														</asp:Label>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn>
													<ItemTemplate>
														<asp:HyperLink id=hlDGIDetails runat="server" ImageUrl="../images/qms_view1_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.UserID", "userdetails.aspx?id={0}") %>' Text="Details">Details</asp:HyperLink>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
											<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
										</asp:DataGrid>
										</div>
									</td>
								</tr>
								<tr>
								    <td style="background-color:#f0f0f0">
										<asp:HyperLink id="hlAddUser" runat="server" NavigateUrl="userdetails.aspx" ToolTip="Click to create new user account"
											ImageUrl="../images/qms_add_btn.gif" EnableViewState="False">Add User</asp:HyperLink>
										<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected users" ImageUrl="../images/qms_delete_btn.gif"
											CausesValidation="False" EnableViewState="False"></asp:ImageButton>
									</td>
								</tr>
								<tr>
								    <td style="background-color:#f0f0f0">
							            <a href="usersessions.aspx">User Sessions</a>	    
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
