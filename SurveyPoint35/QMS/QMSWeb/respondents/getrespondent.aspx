<%@ Page Language="vb" AutoEventWireup="false" Codebehind="getrespondent.aspx.vb" Inherits="QMSWeb.frmGetRespondent" smartNavigation="False"%>
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
	<body onload="document.Form1.tbRespondentID.focus();" style="background-color: #333333">
		<form id="Form1" method="post" runat="server">
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
			<P>&nbsp;</P>
			<TABLE cellSpacing="0" cellPadding="0" width="300" align="center" border="0">
				<tr>
					<td>
						<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td rowspan="4" class="bordercolor" width="1"><img src="../images/clear.gif" width="1" height="1"><img src="../images/clear.gif" width="1" height="1"></td>
								<td colspan="3" ><img src="../images/clear.gif" width="1" height="1"></td>
								<td rowspan="4" width="1"><img src="../images/clear.gif" width="1" height="1"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
							<tr>
								<td rowspan="2" bgcolor="#d7d7c3">
									<table border="0" cellspacing="0" cellpadding="1">
										<tr>
											<td NOWRAP class="pagetitle"><!-- PAGE TITLE --> &nbsp;
												<asp:Label id="lblFormTitle" runat="server"></asp:Label></td>
										</tr>
									</table>
								</td>
								<td rowspan="2" width="22" valign="top"><img src="../images/tableheader.gif" width="22" height="21"></td>
								<td width="100%"><img src="../images/clear.gif" width="1" height="18"></td>
							</tr>
							<tr>
								<td bgcolor="#d7d7c3" width="100%"><img src="../images/clear.gif" width="1" height="3"></td>
							</tr>
							<tr>
								<td colspan="3" class="bordercolor"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
						</table>
						<!-- END TITLE AND TABLE HEADING TABLE -->
						<table width="300" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td class="bordercolor" width="1"><img src="../images/clear.gif" width="1" height="1"></td>
								<td width="299" bgcolor="#f0f0f0">
									<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center">
										<tr>
											<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
												<asp:ValidationSummary id="vsGetRespondent" runat="server" Width="100%"></asp:ValidationSummary>
												<table border="0" cellspacing="0" cellpadding="5" width="100%">
													<tr>
														<td align="right" class="label" width="50%" nowrap>Respondent ID:</td>
														<td width="50%" nowrap><asp:textbox id="tbRespondentID" runat="server" MaxLength="10" ToolTip="Respondent id number to select"
																CssClass="sfnumberfield" Width="75px"></asp:textbox>
															<asp:RequiredFieldValidator id="rfvRespondentID" runat="server" ErrorMessage="Please provide a respondent ID"
																Display="Dynamic" ControlToValidate="tbRespondentID">*</asp:RequiredFieldValidator>
															<asp:RegularExpressionValidator id="rxRespondentID" runat="server" ControlToValidate="tbRespondentID" Display="Dynamic"
																ErrorMessage="Respondent ID must be numeric" EnableViewState="False" ValidationExpression="\d+!?">*</asp:RegularExpressionValidator>
															<asp:CustomValidator id="cuvRespondentID" runat="server" ControlToValidate="tbRespondentID" Display="Dynamic"
																ErrorMessage="" OnServerValidate="ValidateRespondentID" EnableClientScript="False">*</asp:CustomValidator>
															<input type="text" style="VISIBILITY:hidden; WIDTH:1px; HEIGHT:22px" size="1">
														</td>
													</tr>
													<TR>
														<td align="right" width="50%">&nbsp;</td>
														<td width="50%"><asp:button id="btnSubmit" runat="server" Text="Get" ToolTip="Click to view respondent details"
																CssClass="button"></asp:button>
														</td>
													</TR>
													<TR>
														<TD align="right" width="50%"></TD>
														<TD width="50%">
															<asp:HyperLink id="hlByCRID" runat="server" CssClass="minus">By CRID</asp:HyperLink></TD>
													</TR>
												</table>
												<!-- END SEARCH FORM AND FIELDS TABLE -->
											</td>
										</tr>
									</table>
								</td>
								<td class="bordercolor" width="1"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
							<tr>
								<td colspan="3" class="bordercolor" width="600"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
						</table>
					</td>
				</tr>
			</TABLE>
		</form>
	</body>
</HTML>
