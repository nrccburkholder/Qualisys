<%@ Page Language="vb" AutoEventWireup="false" Codebehind="respondents.aspx.vb" Inherits="QMSWeb.frmRespondents" smartNavigation="False"%>
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
	<body style="background-color: #333333">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Respondent Search</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsRespondentSearch" runat="server" Width="100%"></asp:validationsummary><asp:customvalidator id="cuvRespondentSearch" runat="server" Display="None" ErrorMessage="Please set at least one of the following fields: Survey, Client, Batch ID, Respondent ID, Client Respondent ID, Survey Instance, Last Name, or Telephone"
																	EnableClientScript="False" OnServerValidate="ValidateSearch"></asp:customvalidator>
																<TABLE class="formline" width="100%">
																	<TR vAlign="top">
																		<TD width="100"><span class="label">Survey</span><br>
																			<asp:dropdownlist id="ddlSurveyID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		<TD width="100"><span class="label">Client</span><br>
																			<asp:dropdownlist id="ddlClientID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																		<TD noWrap width="70"><span class="label">Batch ID</span><br>
																			<asp:textbox id="tbBatchID" runat="server" CssClass="sfnumberfield" ToolTip="Find by batch number"
																				MaxLength="10"></asp:textbox><asp:regularexpressionvalidator id="revBatchID" runat="server" Display="Dynamic" ErrorMessage="Batch ID must be numeric"
																				ControlToValidate="tbBatchID" ValidationExpression="^\d*$">*</asp:regularexpressionvalidator></TD>
																		<TD noWrap width="120"><span class="label">Respondent ID</span><br>
																			<asp:textbox id="tbRespondentID" runat="server" CssClass="sfnumberfield" ToolTip="Find by respondent id"
																				MaxLength="10"></asp:textbox><asp:regularexpressionvalidator id="revRespondentID" runat="server" Display="Dynamic" ErrorMessage="Respondent ID must be numeric"
																				ControlToValidate="tbRespondentID" ValidationExpression="^\d*$">*</asp:regularexpressionvalidator></TD>
																		<TD noWrap width="120"><span class="label">CRID</span><br>
																			<asp:textbox id="tbClientRespondentID" runat="server" CssClass="sfnumberfield" ToolTip="Find by Client Respondent ID"
																				MaxLength="50"></asp:textbox></TD>
																		<TD vAlign="bottom" align="right"><asp:button id="btnSearch" runat="server" CssClass="button" ToolTip="Clicked to initiate respondent search"
																				Text="Search"></asp:button></TD>
																	</TR>
																	<tr vAlign="top">
																		<td colSpan="2"><span class="label">Survey Instance</span><br>
																			<asp:dropdownlist id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:dropdownlist></td>
																		<TD><SPAN class="label">Last Name</SPAN><BR>
																			<asp:textbox id="tbLastName" runat="server" CssClass="sftextfield" ToolTip="Find by respondent's last or portion of last name"
																				MaxLength="100"></asp:textbox></TD>
																		<TD><SPAN class="label">First Name</SPAN><BR>
																			<asp:textbox id="tbFirstName" runat="server" CssClass="sftextfield" ToolTip="Find by respondent's first or portion of first name"
																				MaxLength="100"></asp:textbox></TD>
																		<td align="right"><br>
																			<asp:checkbox id="cbActive" runat="server" CssClass="sfcheckbox" ToolTip="Search for respondents in active survey instances"
																				Text="Active" Checked="True" Font-Bold="True"></asp:checkbox></td>
																		<td align="right"><span class="label">Advanced</span><br>
																			<asp:imagebutton id="ibAdvanced" runat="server" ToolTip="Show or hide advanced search form" ImageUrl="../images/qms_arrowdown_sym.gif"
																				CausesValidation="False"></asp:imagebutton></td>
																	</tr>
																</TABLE>
																<asp:panel id="pnlAdvanced" Visible="False" Runat="server">
																	<TABLE class="formline" width="100%">
																		<TR>
																			<TD><SPAN class="label">City</SPAN><BR>
																				<asp:textbox id="tbCity" runat="server" CssClass="sftextfield" MaxLength="100" ToolTip="Find by city or portion of city name"></asp:textbox></TD>
																			<TD><SPAN class="label">State</SPAN><BR>
																				<asp:dropdownlist id="ddlState" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																			<TD><SPAN class="label">Zip</SPAN><BR>
																				<asp:textbox id="tbPostalCode" runat="server" CssClass="sftextfield" MaxLength="50" ToolTip="Find by zip code or portion of zip code"></asp:textbox>
																				<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Zip code must be numeric"
																					Display="Dynamic" ValidationExpression="\d{5}(-\d{4})?" ControlToValidate="tbPostalCode">*</asp:RegularExpressionValidator></TD>
																			<TD><SPAN class="label">Telephone</SPAN><BR>
																				<asp:textbox id="tbTelephone" runat="server" CssClass="sftextfield" MaxLength="50" ToolTip="Find by day or evening telephone number"></asp:textbox></TD>
																			<TD><SPAN class="label">Gender</SPAN><BR>
																				<asp:DropDownList id="ddlGender" runat="server" CssClass="sfselect">
																					<asp:ListItem>Select</asp:ListItem>
																					<asp:ListItem Value="F">Female</asp:ListItem>
																					<asp:ListItem Value="M">Male</asp:ListItem>
																				</asp:DropDownList></TD>
																		</TR>
																	</TABLE>
																	<TABLE class="formline" width="100%">
																		<TR>
																			<TD><SPAN class="label">Filter<BR>
																					<asp:DropDownList id="ddlFileDefFilterID" runat="server" CssClass="sfselect"></asp:DropDownList></SPAN></TD>
																			<TD vAlign="bottom"><SPAN class="label">Property Name</SPAN><BR>
																				<asp:TextBox id="tbPropertyName" runat="server" CssClass="sftextfield" MaxLength="100" ToolTip="Find by property name"></asp:TextBox></TD>
																			<TD vAlign="bottom"><SPAN class="label">Property Value</SPAN><BR>
																				<asp:TextBox id="tbPropertyValue" runat="server" CssClass="sftextfield" MaxLength="100" ToolTip="Find by property value"></asp:TextBox></TD>
																			<TD vAlign="bottom"><SPAN class="label">DOB After</SPAN><BR>
																				<asp:TextBox id="tbDOBAfter" runat="server" CssClass="sfdatefield" MaxLength="10" ToolTip="Find by date of birth or later"></asp:TextBox>
																				<asp:CompareValidator id="cvDOBAfter" runat="server" ErrorMessage="DOB After must be in mm/dd/yyyy date format"
																					ControlToValidate="tbDOBAfter" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																			<TD vAlign="bottom"><SPAN class="label">DOB Before</SPAN><BR>
																				<asp:TextBox id="tbDOBBefore" runat="server" CssClass="sfdatefield" MaxLength="10" ToolTip="Find by date of birth or earlier"></asp:TextBox>
																				<asp:CompareValidator id="CompareValidator3" runat="server" ErrorMessage="DOB Before must be in mm/dd/yyyy date format"
																					ControlToValidate="tbDOBBefore" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																		</TR>
																	</TABLE>
																	<TABLE class="formline" width="100%">
																		<TR>
																			<TD><SPAN class="label">Event</SPAN><BR>
																				<asp:DropDownList id="ddlEventID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																			<TD noWrap><SPAN class="label">Event After</SPAN><BR>
																				<asp:TextBox id="tbEventLogAfter" runat="server" CssClass="sfdatefield" MaxLength="10" ToolTip="Find by events date or later"></asp:TextBox>
																				<asp:CompareValidator id="cvEventLogAfter" runat="server" ErrorMessage="Event After must be in mm/dd/yyyy date format"
																					ControlToValidate="tbEventLogAfter" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																			<TD noWrap><SPAN class="label">Event Before</SPAN><BR>
																				<asp:TextBox id="tbEventLogBefore" runat="server" CssClass="sfdatefield" MaxLength="10" ToolTip="Find by event date or earlier"></asp:TextBox>
																				<asp:CompareValidator id="cvEventLogBefore" runat="server" ErrorMessage="Event Before must be in mm/dd/yyyy date format"
																					ControlToValidate="tbEventLogBefore" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator></TD>
																		</TR>
																	</TABLE>
																</asp:panel>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
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
							</TABLE>
						</td>
					</tr>
					<tr>
						<td class="writablebg">
							<!-- THIS TABLE IS THE DATAGRID -->
							<asp:label id="lblSearchResults" runat="server" cssclass="resultscount"></asp:label>
						</td>					
					</tr>
					<tr>
						<td class="WritableBG">
						    <div style="height:500px;overflow:scroll">
							<asp:datagrid id="dgRespondents" runat="server" Width="100%" AllowPaging="True" PageSize="500" AutoGenerateColumns="False"
									AllowSorting="True">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="RespondentID" SortExpression="RespondentID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
										<asp:TemplateColumn SortExpression="LastName, FirstName" HeaderText="Name">
											<ItemTemplate>
												<asp:Literal id="ltRespondentName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn SortExpression="State, City" HeaderText="Address">
											<ItemTemplate>
												<asp:Literal id="ltAddress" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:BoundColumn DataField="Gender" SortExpression="Gender" ReadOnly="True" HeaderText="Sex"></asp:BoundColumn>
										<asp:BoundColumn DataField="DOB" SortExpression="DOB" ReadOnly="True" HeaderText="DOB" DataFormatString="{0:d}"></asp:BoundColumn>
										<asp:TemplateColumn SortExpression="SurveyName, ClientName, SurveyInstanceName" HeaderText="Survey Instance">
											<ItemTemplate>
												<asp:Literal id="ltSurveyInstanceName" runat="server"></asp:Literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemStyle Wrap="False"></ItemStyle>
											<ItemTemplate>
												<asp:HyperLink id="hlDetails" runat="server" ToolTip="View Respondent" Text="Details" ImageUrl="../images/qms_view1_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}") %>' BorderWidth="0px">Details</asp:HyperLink>
												<asp:HyperLink id="hlDataEntry" runat="server" ToolTip="Data Entry" Text="Details" ImageUrl="../images/qms_dataentry2_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=1") %>' BorderWidth="0px">Data Entry</asp:HyperLink>
												<asp:HyperLink id="hlVerify" runat="server" ToolTip="Verification" Text="Details" ImageUrl="../images/qms_verify_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=2") %>' BorderWidth="0px">Verify</asp:HyperLink>
												<asp:HyperLink id="hlCATI" runat="server" ToolTip="CATI" Text="Details" ImageUrl="../images/qms_cati_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=3") %>' BorderWidth="0px">CATI</asp:HyperLink>
												<!--<asp:HyperLink id="hlReminder" runat="server" ToolTip="Reminder" Text="Details" ImageUrl="../images/qms_reminder_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=4") %>' BorderWidth="0px">Reminder</asp:HyperLink> -->
												<asp:HyperLink id="hlIncoming" runat="server" ToolTip="Incoming" Text="Details" ImageUrl="../images/qms_incoming.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=8") %>' BorderWidth="0px">Incoming</asp:HyperLink>
												<!--<asp:HyperLink id="hlReadOnly" runat="server" ImageUrl="../images/qms_close_delete3_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=9") %>' BorderWidth="0px">Read-Only</asp:HyperLink> -->
											</ItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle ForeColor="White" Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
								</asp:datagrid>
								</div>
								</td>
					</tr>
					<tr>
								<td>
								<asp:panel id="pnlActions" Visible="False" Runat="server">
								    <table border="0" cellpadding="0" cellspacing="0">
								        <tr><td><p>&nbsp;</p></td></tr>
								        <tr>
								            <td>
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
															        <td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Respondent Actions</td>
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
									            <TABLE cellSpacing="0" cellPadding="0" border="0" style="background-color:#ffffff">
										            <TR bgColor="#f0f0f0">
											            <TD>
												            <asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected respondents" CausesValidation="False"
													            ImageUrl="../images/qms_delete_btn.gif" EnableViewState="False"></asp:ImageButton></TD>
											            <TD>
												            <asp:CheckBox id="cbDeleteAll" runat="server" CssClass="label" ToolTip="Check to delete all in search"
													            Text="Delete All" EnableViewState="False"></asp:CheckBox></TD>
										            </TR>
										            <TR bgColor="#f0f0f0">
											            <TD>
												            <asp:ImageButton id="ibMove" runat="server" ToolTip="Moved selected respondents to survey instance"
													            CausesValidation="False" ImageUrl="../images/qms_move_btn.gif" EnableViewState="False"></asp:ImageButton></TD>
											            <TD>
												            <asp:DropDownList id="ddlMoveToSurveyInstanceID" runat="server" CssClass="detselect"></asp:DropDownList>
												            <asp:CheckBox id="cbMoveAll" runat="server" CssClass="label" ToolTip="Check to move all in search"
													            Text="Move All" EnableViewState="False"></asp:CheckBox></TD>
										            </TR>
										            <TR bgColor="#f0f0f0">
											            <TD>
												            <asp:ImageButton id="ibLog" runat="server" ToolTip="Log event for selected respondents" CausesValidation="False"
													            ImageUrl="../images/qms_log_btn.gif" EnableViewState="False"></asp:ImageButton></TD>
											            <TD>
												            <asp:DropDownList id="ddlLogEventID" runat="server" CssClass="detselect"></asp:DropDownList>&nbsp;<SPAN class="label">Event 
													            Date</SPAN>
												            <asp:TextBox id="tbEventDate" runat="server" CssClass="detdatefield" MaxLength="10"></asp:TextBox>
												            <asp:CheckBox id="cbLogAll" runat="server" CssClass="label" ToolTip="Check to log event for all in search"
													            Text="Log All" EnableViewState="False"></asp:CheckBox></TD>
										            </TR>
										            <!--Hide these options for now, we may put them back in later TP 20090910-->
										            <TR bgColor="#f0f0f0">
											            <TD style="display: none">
												            <asp:ImageButton id="ibScore" runat="server" CausesValidation="False" ImageUrl="../images/qms_score_btn.gif"
													            EnableViewState="False"></asp:ImageButton></TD>
											            <TD style="display: none"><SPAN class="label">Script ID</SPAN>
												            <asp:TextBox id="tbScoreScriptID" runat="server" CssClass="detnumberfield" MaxLength="10"></asp:TextBox>
												            <asp:CheckBox id="cbScoreAll" runat="server" CssClass="label" ToolTip="Check to score all in search"
													            Text="Score All" EnableViewState="False"></asp:CheckBox></TD>
										            </TR>
										            <TR bgColor="#f0f0f0">
											            <TD style="display: none">
												            <asp:ImageButton id="ibProcess" runat="server" ToolTip="Click to process selected respondents with specified processor"
													            ImageUrl="../images/qms_submit_btn.gif"></asp:ImageButton></TD>
											            <TD style="display: none">
												            <asp:DropDownList id="ddlProcessorID" runat="server" CssClass="detselect"></asp:DropDownList>
												            <asp:CheckBox id="cbProcessAll" runat="server" CssClass="label" ToolTip="Check to process all in search"
													            Text="Process All" EnableViewState="False"></asp:CheckBox></TD>
										            </TR>
										            <TR bgColor="#f0f0f0">
											            <TD style="display: none">
												            <asp:ImageButton id="ibExecuteTrigger" runat="server" ImageUrl="../images/qms_execute_btn.gif"></asp:ImageButton></TD>
											            <TD style="display: none">
												            <asp:DropDownList id="ddlTriggers" runat="server" CssClass="detselect"></asp:DropDownList>
												            <asp:CheckBox id="cbExecuteTriggerAll" runat="server" CssClass="label" Text="Execute Trigger on All"></asp:CheckBox></TD>
										            </TR>
									            </TABLE>
									           </td>
									        </tr>
						            </table>
								</asp:panel>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
