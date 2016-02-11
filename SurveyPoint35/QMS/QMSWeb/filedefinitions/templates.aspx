<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="templates.aspx.vb" Inherits="QMSWeb.templates"%>
<%@ Register TagPrefix="uc1" TagName="ucTemplates" Src="../includes/ucTemplates.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<p>
				<TABLE class="main" align="center">
					<TBODY>
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
																<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Import Templates</td>
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
																	<asp:validationsummary id="vsTemplates" Width="100%" Runat="server"></asp:validationsummary>
																	<table class="formline" width="100%">
																		<TR vAlign="top">
																			<TD width="100"><span class="label">Survey</span><br>
																				<asp:dropdownlist id="ddlSearchSurveyID" runat="server" CssClass="sfselect" AutoPostBack="True"></asp:dropdownlist></TD>
																			<TD width="100"><span class="label">Client</span><br>
																				<asp:dropdownlist id="ddlSearchClientID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD width="100"><span class="label">Script</span><br>
																				<asp:dropdownlist id="ddlSearchScriptID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<td vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Click to initiate search"
																					Text="Search"></asp:button></td>
																		</TR>
																	</table>
																	<uc1:ucTemplates id="uctTemplates" runat="server"></uc1:ucTemplates>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</TABLE>
							</td>
						</tr>
					</TBODY>
				</TABLE>
			</P>
		</form>
		</TR></TBODY>
	</body>
</HTML>
