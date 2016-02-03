<%@ Page Language="vb" AutoEventWireup="false" Codebehind="responses.aspx.vb" Inherits="QMSWeb.frmResponses"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<style type="text/css">.script_status_hl { FONT-SIZE: 8pt; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none }
		</style>
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body onkeypress="handleKeyPress()">
		<form id="Form1" method="post" runat="server">
		<!-- BEGIN HEADER -->
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
					<td>
						<table cellSpacing="0" cellPadding="0" border="0" width="100%">
							<tr>								
								<td rowspan="2" style="background-color:#cccccc"><img height="39" src="../images/surveytracker_header.gif" width="241" /></td>
								<td style="background-color:#000099" width="100%">
					                <img height="34px" src="../images/clear.gif" width="1" />
					            </td>
							</tr>
							<tr>
							    <td width="100%" style="background-color:#CCCCCC"><img height="4px" src="../images/clear.gif" width="1" /></td>
							</tr>							
						</table>
					</td>					
				</tr>				
			</table>
			<!-- END HEADER -->						
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Response History&nbsp;<SPAN class="plus"></SPAN></td>
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
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr bgColor="#f0f0f0">
												<td>
													<span class="label">Point In Time</span><br>
													<asp:DropDownList id="ddlPointInTime" runat="server" CssClass="sfselect" AutoPostBack="True"></asp:DropDownList>
												</td>
												<td align="right">
													<a href="javascript:window.close();"><img src="../images/qms_done_btn.gif" border="0"></a></td>
											</tr>
										</table>
										<!-- END TITLE AND TABLE HEADING TABLE -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="WritableBG" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
					<tr>
						<td class="writablebg">
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<tr>
									<td class="WritableBG">
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<asp:Label id="lblResults" runat="server" CssClass="resultscount"></asp:Label>
										&nbsp;
										<asp:DataGrid id="dgReport" runat="server" Width="100%"></asp:DataGrid>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</TABLE>			
		</form>
	</body>
</HTML>
