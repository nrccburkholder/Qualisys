<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="scripttriggers.aspx.vb" Inherits="QMSWeb.frmScriptTriggers"%>
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
		<form id="Form2" method="post" runat="server">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Script Triggers</td>
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
													<blockquote style="POSITION: relative; TOP: 10px"><asp:HyperLink id="hlScriptName" runat="server"></asp:HyperLink></blockquote>
													<SPAN class="resultscount">
														<asp:literal id="ltResultsFound" Runat="server"></asp:literal>
														<asp:DataGrid id="dgScriptTriggers" runat="server" Width="100%" AutoGenerateColumns="False">
															<Columns>
																<asp:TemplateColumn>
																	<ItemTemplate>
																		<asp:CheckBox id="cbSelected" runat="server"></asp:CheckBox>
																	</ItemTemplate>
																</asp:TemplateColumn>
																<asp:TemplateColumn SortExpression="TriggerName" HeaderText="Trigger">
																	<ItemTemplate>
																		<asp:Literal id="ltTriggerName" runat="server"></asp:Literal>
																	</ItemTemplate>
																</asp:TemplateColumn>
																<asp:TemplateColumn SortExpression="ItemOrder" HeaderText="Script Screen">
																	<ItemTemplate>
																		<asp:Literal id="ltScreenTitle" runat="server"></asp:Literal>
																	</ItemTemplate>
																</asp:TemplateColumn>
																<asp:TemplateColumn SortExpression="TriggerIDValue4" HeaderText="Pre/Post">
																	<ItemTemplate>
																		<asp:Literal id="ltPrePost" runat="server"></asp:Literal>
																	</ItemTemplate>
																</asp:TemplateColumn>
																<asp:TemplateColumn>
																	<ItemTemplate>
																		<asp:HyperLink id="hlDetails" runat="server" ImageUrl="../images/qms_view1_sym.gif"></asp:HyperLink>
																	</ItemTemplate>
																</asp:TemplateColumn>
															</Columns>
														</asp:DataGrid></SPAN><asp:hyperlink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" EnableViewState="False"
														NavigateUrl="scriptdetails.aspx">Add Script</asp:hyperlink><asp:imagebutton id="ibDelete" runat="server" ToolTip="Delete selected scripts" ImageUrl="../images/qms_delete_btn.gif"
														EnableViewState="False"></asp:imagebutton>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
					<tr>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
