<%@ Register TagPrefix="cc1" Namespace="DMI.Data" Assembly="DMI.Data" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="usersessions.aspx.vb" Inherits="QMSWeb.frmUserSessions"%>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;User Sessions</td>
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
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#f0f0f0">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td><span class="resultscount"><asp:Literal ID="ltResultsFound" Runat="server"></asp:Literal></span></td>
														</tr>
													</table>
													<cc1:DbDataGrid id="dbdgUserSessions" runat="server" Width="100%" AutoGenerateColumns="False" CellPadding="3">
														<AlternatingItemStyle CssClass="altcell"></AlternatingItemStyle>
														<ItemStyle CssClass="itemcell"></ItemStyle>
														<HeaderStyle CssClass="headingcell"></HeaderStyle>
														<Columns>
															<asp:BoundColumn DataField="Username" HeaderText="User"></asp:BoundColumn>
															<asp:BoundColumn DataField="Name" HeaderText="Action"></asp:BoundColumn>
															<asp:BoundColumn DataField="EventDate" HeaderText="Time" DataFormatString="{0:t}"></asp:BoundColumn>
														</Columns>
														<PagerStyle CssClass="gridborder"></PagerStyle>
													</cc1:DbDataGrid>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
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
