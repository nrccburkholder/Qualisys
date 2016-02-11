<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="templatedetails.aspx.vb" Inherits="QMSWeb.templatedetails"%>
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
																<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Template Details</td>
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
																<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsTemplateDetails" Width="100%" Runat="server"></asp:validationsummary>
																	<table cellSpacing="0" cellPadding="3" width="100%" border="0">
																		<tr>
																			<td class="label" align="right" width="20%" nowrap>Template Id:</td>
																			<td width="30%"><asp:literal id="ltTemplateId" runat="server"></asp:literal></td>
																			<td class="label" align="right" width="20%" nowrap>Survey:</td>
																			<td width="30%"><asp:literal id="ltSurveyName" runat="server"></asp:literal></td>
																		</tr>
																		<tr>
																			<td class="label" align="right" width="20%" nowrap>Client:</td>
																			<td colspan="3"><asp:dropdownlist id="ddlClientID" runat="server" CssClass="detselect"></asp:dropdownlist>
																				<asp:ImageButton id="ibClient" runat="server" ImageUrl="../images/qms_view1_sym.gif"></asp:ImageButton><asp:requiredfieldvalidator id="rfvClientID" runat="server" ErrorMessage="Please select a client" EnableViewState="False"
																					ControlToValidate="ddlClientID">*</asp:requiredfieldvalidator>
																				<asp:CustomValidator id="cuvClientScript" runat="server" ControlToValidate="ddlClientID" EnableViewState="False"
																					ErrorMessage="There is already a template with the same client and script" OnServerValidate="validateClientScriptTemplate">*</asp:CustomValidator></td>
																		</tr>
																		<tr>
																			<td class="label" align="right" nowrap>Script:</td>
																			<td colspan="3"><asp:dropdownlist id="ddlScriptID" runat="server" CssClass="detselect"></asp:dropdownlist>
																				<asp:ImageButton id="ibScript" runat="server" ImageUrl="../images/qms_view1_sym.gif"></asp:ImageButton><asp:requiredfieldvalidator id="rfvScriptID" runat="server" ErrorMessage="Please select a script" EnableViewState="False"
																					ControlToValidate="ddlScriptID">*</asp:requiredfieldvalidator></td>
																		</tr>
																		<tr>
																			<td class="label" align="right" nowrap>File Defintion:</td>
																			<td colspan="3"><asp:dropdownlist id="ddlFileDefID" runat="server" CssClass="detselect"></asp:dropdownlist>
																				<asp:ImageButton id="ibFileDef" runat="server" ImageUrl="../images/qms_view1_sym.gif"></asp:ImageButton></td>
																		</tr>
																		<tr>
																			<td class="label" vAlign="top" align="right" width="20%" nowrap>Notes:</td>
																			<td colspan="3"><asp:textbox id="tbName" runat="server" Width="552px" CssClass="dettextfield" TextMode="MultiLine"></asp:textbox></td>
																		</tr>
																		<tr>
																			<td class="label" vAlign="top" align="right" nowrap>Description:</td>
																			<td colSpan="3"><asp:textbox id="tbDecription" runat="server" Width="552px" TextMode="MultiLine" CssClass="dettextfield"></asp:textbox></td>
																		</tr>
																		<tr>
																		</tr>
																		<tr>
																			<td>&nbsp;</td>
																			<td colSpan="3"><asp:imagebutton id="ibSave" Runat="server" EnableViewState="False" ImageUrl="../images/qms_save_btn.gif"
																					tooltip="Save changes"></asp:imagebutton><asp:hyperlink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif" NavigateUrl="filedefinitions.aspx"
																					ToolTip="Exit without saving changes">Done</asp:hyperlink></td>
																		</tr>
																	</table>
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
			<P></P>
		</form>
		</TR></TBODY>
		<P></P>
	</body>
</HTML>
