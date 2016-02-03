<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="batchlogging.aspx.vb" Inherits="QMSWeb.frmBatchLogging" smartNavigation="False" enableViewState="True"%>
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
	<body onload="document.Form1.tbRespondentID.focus();">
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<P>&nbsp;</P>
			<P align="center">
				<asp:Literal id="ltSoundTag" runat="server" EnableViewState="False"></asp:Literal><asp:label id="lblVerify" runat="server" ForeColor="Blue" EnableViewState="False"></asp:label></P>
			<TABLE cellSpacing="0" cellPadding="0" width="300" align="center" border="0">
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
											<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Batch Surveys</td>
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
						<table cellSpacing="0" cellPadding="0" width="300" align="center" border="0">
							<tr>
								<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
								<td width="299" class="writablebg">
									<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
										<tr>
											<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsBatchLogging" runat="server" Width="100%" EnableViewState="False"></asp:validationsummary>
												<table cellSpacing="0" cellPadding="5" width="100%" border="0">
													<tr>
														<td class="label" noWrap align="right" width="50%">Respondent ID:</td>
														<td noWrap width="50%"><asp:textbox id="tbRespondentID" runat="server" Width="75px" ToolTip="Mailed back survey from respondent"
																MaxLength="10" CssClass="sfnumberfield" EnableViewState="False"></asp:textbox>
															<asp:requiredfieldvalidator id="rfvRespondentID" runat="server" EnableClientScript="False" Display="Dynamic"
																ErrorMessage="Please provide a respondent ID" ControlToValidate="tbRespondentID" EnableViewState="False">*</asp:requiredfieldvalidator>
															<asp:customvalidator id="cuvBatchLogging" runat="server" EnableClientScript="False" OnServerValidate="ValidateRespondentID"
																Display="Dynamic" ErrorMessage="Respondent ID not found. Please correct and re-submit." ControlToValidate="tbRespondentID">*</asp:customvalidator>
															<input style="VISIBILITY: hidden; WIDTH: 1px; HEIGHT: 22px" type="text" size="1">
														</td>
													</tr>
													<TR>
														<TD class="label" align="right" width="50%">Return Date:</TD>
														<TD width="50%">
															<asp:TextBox id="tbReturnDate" runat="server" Width="75px" CssClass="sfnumberfield" ToolTip="Return date of survey being batched"></asp:TextBox>
															<asp:RequiredFieldValidator id="rfvReturnDate" runat="server" ControlToValidate="tbReturnDate" ErrorMessage="Please provide return date "
																Display="Dynamic">*</asp:RequiredFieldValidator>
															<asp:CompareValidator id="cvReturnDate" runat="server" ControlToValidate="tbReturnDate" ErrorMessage="Return date has invalid date format (mm/dd/yyyy)"
																Display="Dynamic" Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator></TD>
													</TR>
													<TR>
														<td align="right" width="50%">&nbsp;</td>
														<td width="50%"><asp:button id="btnBatch" runat="server" ToolTip="Batch respondent" Text="Batch" CssClass="button"
																EnableViewState="False"></asp:button></td>
													</TR>
													<TR>
														<TD align="right" width="50%"></TD>
														<TD width="50%">
															<asp:HyperLink id="hlByCRID" runat="server" NavigateUrl="batchlogging_byCRID.aspx">By CRID</asp:HyperLink></TD>
													</TR>
												</table>
												<!-- END SEARCH FORM AND FIELDS TABLE --></td>
										</tr>
									</table>
								</td>
								<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
							</tr>
							<tr>
								<td class="bordercolor" width="600" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
							</tr>
						</table>
					</td>
				</tr>
			</TABLE>
		</form>
	</body>
</HTML>
