<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="executefiledef.aspx.vb" Inherits="QMSWeb.frmExecuteFileDef" %>
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
		<form id="Form1" method="post" encType="multipart/form-data" runat="server">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:literal id="ltFormTitle" runat="server"></asp:literal></td>
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
															<asp:validationsummary id="vsExecuteImportExport" runat="server" Width="100%"></asp:validationsummary>
                                                                <asp:Table ID="tblExecuteForm" runat="server" BackColor="#f0f0f0" BorderWidth="0"
                                                                    CellSpacing="0" CellPadding="5">
                                                                    <asp:TableRow>
                                                                        <asp:TableCell CssClass="label" HorizontalAlign="Right">Definition</asp:TableCell>
                                                                        <asp:TableCell >
                                                                            <asp:Label ID="lblFileDefName" runat="server" />
                                                                        </asp:TableCell><asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Description
                                                                        </asp:TableCell><asp:TableCell >
                                                                            <asp:Label ID="lblFileDefDescription" runat="server" />
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow>
                                                                        <asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Type
                                                                        </asp:TableCell><asp:TableCell>
                                                                            <asp:Label ID="lblFileDefTypeName" runat="server" />
                                                                        </asp:TableCell><asp:TableCell CssClass="label" HorizontalAlign="Right">
																			File Format
                                                                        </asp:TableCell><asp:TableCell>
                                                                            <asp:Label ID="lblFileTypeName" runat="server" />
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow><asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Survey
                                                                        </asp:TableCell><asp:TableCell>
                                                                            <asp:Label ID="lblSurveyName" runat="server" />
                                                                        </asp:TableCell><asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Client
                                                                        </asp:TableCell><asp:TableCell>
                                                                            <asp:Label ID="lblClientName" runat="server" />
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow>
                                                                        <asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Log Event Code
                                                                        </asp:TableCell><asp:TableCell >
                                                                            <asp:DropDownList ID="ddlEventID" runat="server" CssClass="sfselect" />
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow runat="server" ID="ImportFileRow">
                                                                        <asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Select Import File
                                                                        </asp:TableCell><asp:TableCell ColumnSpan="3">
                                                                            <input name="fileImport" id="fileImport" type="file" runat="server" class="sftextfield"
                                                                                style="width: 300px" />
                                                                            <asp:CustomValidator ID="cuvFileImport" runat="server" OnServerValidate="ValidateFileImport"
                                                                                ErrorMessage="Please select a file to import">*</asp:CustomValidator>
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow runat="server" ID="SurveyInstanceRow">
                                                                        <asp:TableCell CssClass="label" HorizontalAlign="Right">
																			Import Into Survey Instance
                                                                        </asp:TableCell><asp:TableCell ColumnSpan="3">
                                                                            <asp:DropDownList ID="ddlSurveyInstanceIDImport" DataValueField="SurveyInstanceID"
                                                                                DataTextField="FormattedSurveyInstanceName" runat="server" CssClass="sfselect" />
                                                                            <asp:CompareValidator ID="cvSurveyInstanceIDImport" runat="server" ControlToValidate="ddlSurveyInstanceIDImport"
                                                                                ValueToCompare="0" Operator="GreaterThan" ErrorMessage="Please select a survey instance">*</asp:CompareValidator>
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow runat="server" ID="ExportHeaderRow">
                                                                        <asp:TableCell>&nbsp;</asp:TableCell><asp:TableCell CssClass="label">
                                                                            <asp:CheckBox ID="cbExportHeader" CssClass="detcheckbox" runat="server" Text="Export Header Row">
                                                                            </asp:CheckBox>
                                                                        </asp:TableCell></asp:TableRow><asp:TableRow>
                                                                        <asp:TableCell>&nbsp;</asp:TableCell><asp:TableCell ColumnSpan="3">
                                                                            <asp:ImageButton ID="ibExecute" runat="server" ToolTip="Executes import/export" ImageUrl="../images/qms_execute_btn.gif">
                                                                            </asp:ImageButton>
                                                                            <asp:HyperLink ID="hlCancel" runat="server" NavigateUrl="filedefinitions.aspx" ImageUrl="../images/qms_done_btn.gif">Exit without saving changes</asp:HyperLink>
                                                                        </asp:TableCell></asp:TableRow></asp:Table><!-- END SEARCH FORM AND FIELDS TABLE --></td></tr></table></td><td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td></tr><tr>
												<td class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td></tr></table></td></tr></TABLE></td></tr><tr>
						<td><asp:panel id="pnlExportFilters" runat="server">
								<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
									<TR>
										<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Export Filters</TD></TR></TABLE></TD><TD vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
													<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD><!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																	<TABLE cellSpacing="0" cellPadding="0" border="0">
																		<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR>
																						<TD class="label" align="right" width="170">Survey Instance<br /><asp:LinkButton 
                                                                                                runat="server" ID="ClearInstanceSelection" Text="Clear" Font-Size="Smaller" /></TD><TD>
																						    <div style="width:700px;height:225px;overflow:scroll; border-style: solid; border-color: #CCCCCC; border-width: 2px;">
																							<asp:DropDownList id="ddlSurveyInstanceIDExport" runat="server" CssClass="sfselect"></asp:DropDownList>
                                                                                            <asp:CheckBoxList ID="ddlSurveyInstanceIDsExport" runat="server" CssClass="sfselect">
                                                                                            </asp:CheckBoxList>
                                                                                            </div>
																						</TD>
																						<TD>
																							<asp:CheckBox id="cbActive" runat="server" CssClass="sfcheckbox" Checked="True" Text="Active"
																								Font-Bold="True"></asp:CheckBox></TD>
																						<TD align="right">
																							<asp:Button id="btnGetCount" runat="server" CssClass="button" Text="Get Count" ToolTip="Returns respondent count for selected filters without executing export"></asp:Button></TD>
																					</TR>
																				</TABLE>
																			</TD>
																		</TR>
																		<%--<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR vAlign="top">
																						<TD class="label" align="right" width="170">Survey Instance Date</TD><TD><SPAN style="FONT-SIZE: 10px">After</SPAN><BR>
																							<asp:TextBox id="tbSurveyInstanceDateAfter" runat="server" CssClass="sfdatefield" ToolTip="Filter by survey instance specific date or later"
																								MaxLength="10"></asp:TextBox><asp:CompareValidator id="cvSurveyInstanceDateAfter" runat="server" Type="Date" Operator="DataTypeCheck"
																								ControlToValidate="tbSurveyInstanceDateAfter" ErrorMessage="Survey instance after date must be in mm/dd/yyyy format">*</asp:CompareValidator></TD><TD><SPAN style="FONT-SIZE: 10px">Before</SPAN><BR>
																							<asp:TextBox id="tbSurveyInstanceDateBefore" runat="server" CssClass="sfdatefield" ToolTip="Filter by survey instance date or earlier"
																								MaxLength="10"></asp:TextBox><asp:CompareValidator id="cvSurveyInstanceDateBefore" runat="server" Type="Date" Operator="DataTypeCheck"
																								ControlToValidate="tbSurveyInstanceDateBefore" ErrorMessage="Survey instance before date must be in mm/dd/yyyy format">*</asp:CompareValidator></TD><TD>
																							<asp:CheckBox id="cbIncludeMailingSeeds" runat="server" CssClass="sfcheckbox" Text="Include Mailing Seeds"
																								Font-Bold="True" ToolTip="Check to include survey instance mailing seeds in export"></asp:CheckBox></TD>
																					</TR>
																				</TABLE>
																			</TD>
																		</TR>--%> <TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR>
																						<TD class="label" align="right" width="170">Survey</TD><TD>
																							<asp:DropDownList id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:DropDownList>
																							<asp:CompareValidator id="cvSurveyID" runat="server" Type="Integer" Operator="GreaterThan" ControlToValidate="ddlSurveyID"
																								ErrorMessage="Please select a survey" ValueToCompare="0">*</asp:CompareValidator></TD><TD class="label" align="right">Client</TD><TD>
																							<asp:DropDownList id="ddlClientID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																					</TR>
																				</TABLE>
																			</TD>
																		</TR>
																		<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR vAlign="top">
																						<TD class="label" align="right" width="170">Event</TD><TD>
																							<asp:DropDownList id="ddlEventIDFilter" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																						<TD class="label" align="right">Event Date</TD><TD><SPAN style="FONT-SIZE: 10px; vertical-align:middle">After</SPAN>
																							<asp:TextBox id="tbEventDateAfter" runat="server" CssClass="sfdatefield" ToolTip="Filter by event date date or later"
																								MaxLength="10"></asp:TextBox><asp:CompareValidator id="cvEventDateAfter" runat="server" Type="Date" Operator="DataTypeCheck" ControlToValidate="tbEventDateAfter"
																								ErrorMessage="Event after date must be in mm/dd/yyyy format">*</asp:CompareValidator></TD><TD><SPAN style="FONT-SIZE: 10px; vertical-align:middle">Before</SPAN>
																							<asp:TextBox id="tbEventDateBefore" runat="server" CssClass="sfdatefield" ToolTip="Filter by event date or earlier"
																								MaxLength="10"></asp:TextBox><asp:CompareValidator id="cvEventDateBefore" runat="server" Type="Date" Operator="DataTypeCheck" ControlToValidate="tbEventDateBefore"
																								ErrorMessage="Event before date must be in mm/dd/yyyy format">*</asp:CompareValidator>
																								</TD>
																								</TR>
																				</TABLE></TD></TR><%--<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR vAlign="top">
																						<TD class="label" align="right" width="170">Batch Numbers</TD><TD>
																							<asp:TextBox id="tbBatchIDs" runat="server" Width="404px" CssClass="sftextfield" ToolTip="Filter by comma delimited list of batch ids"></asp:TextBox><asp:RegularExpressionValidator id="revBatchIDs" runat="server" ControlToValidate="tbBatchIDs" ErrorMessage="Batch numbers must be numeric values separated by commas"
																								ValidationExpression="^(\d+, ?)*\d+$">*</asp:RegularExpressionValidator></TD></TR></TABLE></TD></TR>--%>
																		<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR vAlign="top">
																						<TD class="label" align="right" width="170">Other Filters</TD><TD>
																							<asp:DropDownList id="ddlFileDefFilterID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																					</TR>
																				</TABLE>
																			</TD>
																		</TR>
																		<TR>
																			<TD>
																				<TABLE cellSpacing="0" cellPadding="5" border="0">
																					<TR vAlign="top">
																						<TD class="label" align="right" width="170">Finals</TD><TD>
																							<asp:DropDownList id="ddlFinal" runat="server" CssClass="sfselect">
																								<asp:ListItem Value="">None</asp:ListItem><asp:ListItem Value="0">Exclude Finals</asp:ListItem><asp:ListItem Value="1">Only Finals</asp:ListItem></asp:DropDownList></TD><td  class="label" >Respondent ID</td><td><asp:TextBox runat="server" ID="txtRespID"></asp:TextBox></td></TR></TABLE></TD></TR></TABLE><!-- END SEARCH FORM AND FIELDS TABLE --></TD></TR></TABLE></TD><TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</TABLE>
							</asp:panel></td>
					</tr>
				</TABLE>
			</p>
			<p>&nbsp;</p></form></body></HTML>