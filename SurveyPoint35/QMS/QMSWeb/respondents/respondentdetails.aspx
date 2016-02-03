<%@ Page Language="vb" AutoEventWireup="false" Codebehind="respondentdetails.aspx.vb" Inherits="QMSWeb.frmRespondentDetails" smartNavigation="True"%>
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
			<!-- BEGIN HEADER -->
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>			
			<!-- END HEADER -->
			<p>
				<TABLE class="main" align="center">
					<tr>
						<td>
							<table cellspacing="0" cellpadding="0" width="100%" border="0">
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Respondent Details</td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" rowSpan="2"><IMG src="../images/tableheader.gif" 
                                                        width="22" style="height: 24px"></td>
												<td width="100%" vAlign="top" align="right"><IMG height="18" src="../images/clear.gif" width="1">
													<asp:Label id="lblIsFinal" runat="server" ForeColor="Red" Font-Bold="True" Visible="False">RESPONDENT IS FINAL</asp:Label></td>
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
																<asp:ValidationSummary id="vsRespondent" runat="server" Width="100%"></asp:ValidationSummary>
																<table class="formline" width="100%">
																	<tr valign="top">
																		<TD class="label" align="right" width="100">Respondent ID</TD>
																		<TD>
																			<asp:Literal id="ltRespondentID" runat="server"></asp:Literal></TD>
																		<TD class="label" align="right">Survey Instance</TD>
																		<TD>
																			<asp:Literal id="ltSurveyInstanceName" runat="server"></asp:Literal>
																			<asp:DropDownList id="ddlSurveyInstanceID" runat="server" CssClass="sfselect"></asp:DropDownList></TD>
																		<TD class="label" align="right" width="100">Batch ID</TD>
																		<TD width="100"><asp:textbox id="tbBatchID" runat="server" MaxLength="10" CssClass="detnumberfield"></asp:textbox>
																			<asp:RegularExpressionValidator id="revBatchID" runat="server" ValidationExpression="^\d+$" ControlToValidate="tbBatchID"
																				ErrorMessage="Batch ID must be integer value" Display="Dynamic">*</asp:RegularExpressionValidator>&nbsp;</TD>
																	</tr>
																</table>
																<table class="formline" style="WIDTH: 700px">
																	<tr valign="top">
																		<TD class="label" align="right" width="100">
																			Name</TD>
																		<td nowrap><asp:textbox id="tbFirstName" runat="server" MaxLength="100" CssClass="dettextfield" Width="150px"></asp:textbox>&nbsp;
																			<asp:textbox id="tbMiddleInitial" runat="server" Width="25px" MaxLength="10" CssClass="dettextfield"></asp:textbox>&nbsp;
																			<asp:textbox id="tbLastName" runat="server" MaxLength="75" CssClass="dettextfield" Width="150px"></asp:textbox>
																			<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Please provide last name"
																				ControlToValidate="tbLastName">*</asp:RequiredFieldValidator></td>
																		<td class="label" align="right">DOB</td>
																		<td><asp:TextBox id="tbDOB" runat="server" CssClass="detdatefield"></asp:TextBox>																		
																			<asp:CompareValidator id="cvDOB" runat="server" Display="Dynamic" ErrorMessage="DOB must be in mm/dd/yyyy date format"
																				ControlToValidate="tbDOB" Type="Date" Operator="DataTypeCheck">*</asp:CompareValidator>																		
																				</td>
																	</tr>
																</table>
																<table class="formline" style="WIDTH: 700px">
																	<tr valign="top">
																		<TD class="label" align="right" width="100">Address</TD>
																		<TD colspan="5" vAlign="top"><asp:textbox id="tbAddress1" runat="server" Width="560px" MaxLength="250" CssClass="dettextfield"></asp:textbox><br>
																			<asp:textbox id="tbAddress2" runat="server" Width="560px" MaxLength="250" CssClass="dettextfield"></asp:textbox></TD>
																	</tr>
																	<tr vAlign="top">
																		<TD class="label" align="right" width="100">City</TD>
																		<TD><asp:textbox id="tbCity" runat="server" Width="200px" MaxLength="100" CssClass="dettextfield"></asp:textbox></TD>
																		<TD class="label" align="right">State</TD>
																		<TD><asp:dropdownlist id="ddlState" runat="server" CssClass="detselect"></asp:dropdownlist></TD>
																		<TD class="label" align="right" style="WIDTH: 50px">Zip</TD>
																		<TD nowrap><asp:textbox id="tbPostalCode" runat="server" MaxLength="50" Width="100px" CssClass="dettextfield"></asp:textbox>																		    
																			<asp:TextBox id="tbPostalCodeExt" runat="server" Width="50px" CssClass="dettextfield" MaxLength="4"></asp:TextBox><asp:RegularExpressionValidator id="revPostalCode" runat="server" ErrorMessage="Invalid zip code. Please correct zip code."
																				ControlToValidate="tbPostalCode" ValidationExpression="\d{5}(-\d{4})?">*</asp:RegularExpressionValidator>																				
																				</TD>
																	</tr>
																</table>
																<table class="formline" style="WIDTH: 700px">
																	<tr vAlign="top">
																		<TD class="label" align="right" width="100">Day Phone</TD>
																		<TD><asp:textbox id="tbTelephoneDay" runat="server" MaxLength="50" Width="100px" CssClass="dettextfield"></asp:textbox></TD>
																		<TD class="label" align="right">Evening Phone</TD>
																		<TD><asp:textbox id="tbTelephoneEvening" runat="server" MaxLength="50" Width="100px" CssClass="dettextfield"></asp:textbox></TD>
																		<TD class="label" align="right">Email</TD>
																		<TD><asp:textbox id="tbEmail" runat="server" MaxLength="50" Width="150px" CssClass="dettextfield"></asp:textbox>
																			<asp:RegularExpressionValidator id="revEmail" runat="server" ErrorMessage="Incorrect email format (ex. user@domain.com)"
																				ControlToValidate="tbEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator></TD>
																	</tr>
																</table>
																<table class="formline" style="WIDTH: 700px">
																	<tr vAlign="top">
																		<TD class="label" align="right" width="100">Gender</TD>
																		<TD><asp:dropdownlist id="ddlGender" runat="server" CssClass="detselect">
																				<asp:ListItem>Select a Gender</asp:ListItem>
																				<asp:ListItem Value="F">Female</asp:ListItem>
																				<asp:ListItem Value="M">Male</asp:ListItem>
																			</asp:dropdownlist></TD>
																		<TD class="label" align="right">SSN</TD>
																		<TD vAlign="top"><asp:textbox id="tbSSN" runat="server" MaxLength="50" CssClass="dettextfield"></asp:textbox></TD>
																		<TD class="label" align="right">Client Respondent ID</TD>
																		<TD vAlign="top"><asp:textbox id="tbClientRespondentID" runat="server" MaxLength="50" CssClass="detnumberfield"
																				Width="100px"></asp:textbox></TD>
																	</tr>
																</table>
																<table class="formline">
																	<tr vAlign="top">
																		<TD class="label" align="right" width="100" noWrap>Next Contact</TD>
																		<TD>
																			<asp:Literal id="ltNextContact" runat="server"></asp:Literal></TD>
																		<td>&nbsp;</td>
																		<TD class="label" align="right">Calls Made</TD>
																		<TD vAlign="top">
																			<asp:Literal id="ltCallsMade" runat="server"></asp:Literal></TD>
																	</tr>
																</table>
																<table class="formline" width="100%">
																	<tr>
																		<td width="100">&nbsp;</td>
																		<td nowrap>
																			<asp:ImageButton id="ibUpdateResp" runat="server" ToolTip="Update respondent information" ImageUrl="../images/qms_updaterspndnt_btn.gif"></asp:ImageButton>
																			<asp:ImageButton id="ibUpdateHousehold" runat="server" ToolTip="Update address and telephone for entire household"
																				ImageUrl="../images/qms_updatehsehld_btn.gif"></asp:ImageButton>
																			<asp:HyperLink id="hlDone" runat="server" ImageUrl="../images/qms_done_btn.gif">Done. Finished with respondent</asp:HyperLink>
																		</td>
																		<td align="right">
																			<asp:Hyperlink id="hlResponseHistory" runat="server" ImageUrl="../images/qms_viewresponses_btn.gif" ToolTip="View Response History"
																				Target="_new">View Responses</asp:Hyperlink>&nbsp;
																			<asp:ImageButton id="ibClearResponses" runat="server" ImageUrl="../images/qms_clearresponses_btn.gif"
																				onclientclick="return confirm('Are you sure you wish to clear responses.');"></asp:ImageButton>
																		</td>
																	</tr>
																</table>
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
							</table>
						</td>
					</tr>
					<tr>
					    <td>
							<asp:Panel ID="pnlDetails" Runat="server">
								<br />
								<table cellSpacing="0" cellPadding="0" width="100%" border="0">
									<tr>
										<td><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4">
                                                        <img height="1" src="../images/clear.gif" width="1"><img height="1" 
                                                    src="../images/clear.gif" width="1"></img></img></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Respondent Properties</TD>
															</TR>
														</TABLE>
													</TD>
													<TD vAlign="top" width="22" rowSpan="2">
                                                        <IMG height="21" src="../images/tableheader.gif" width="22"></TD>
													<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
										</td>
									</tr>
									<tr>
									    <td class="WritableBG">
											<div style="height:300px;overflow:scroll">
											<asp:DataGrid id="dgRespondentProperties" runat="server" Width="100%" AllowPaging="True" PageSize="50"
												DESIGNTIMEDRAGDROP="521" AutoGenerateColumns="False">
												<Columns>
													<asp:TemplateColumn>
														<ItemTemplate>
															<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
														</ItemTemplate>
													</asp:TemplateColumn>
													<asp:TemplateColumn HeaderText="Property Name">
														<ItemTemplate>
															<asp:Label id=Label1 runat="server" Text='<%# Container.DataItem("PropertyName") %>'>
															</asp:Label>
														</ItemTemplate>
														<EditItemTemplate>
															<asp:TextBox id=tbPropertyName runat="server" Width="150px" MaxLength="100" CssClass="gridtextfield" Text='<%# Container.DataItem("PropertyName") %>'>
															</asp:TextBox>
															<asp:RequiredFieldValidator id="rfvPropertyName" runat="server" ErrorMessage="Please provide a property name"
																ControlToValidate="tbPropertyName">*</asp:RequiredFieldValidator>
														</EditItemTemplate>
													</asp:TemplateColumn>
													<asp:TemplateColumn HeaderText="Value">
														<ItemTemplate>
															<asp:Label id=Label2 runat="server" Text='<%# Container.DataItem("PropertyValue") %>'>
															</asp:Label>
														</ItemTemplate>
														<EditItemTemplate>
															<asp:TextBox id=tbPropertyValue runat="server" Width="150px" MaxLength="100" CssClass="gridtextfield" Text='<%# Container.DataItem("PropertyValue") %>'>
															</asp:TextBox>
														</EditItemTemplate>
													</asp:TemplateColumn>
													<asp:TemplateColumn>
														<ItemTemplate>
															<asp:ImageButton id="ibDGIEdit" runat="server" CausesValidation="False" CommandName="Edit" ImageUrl="../images/qms_dataentry1_sym.gif"></asp:ImageButton>
														</ItemTemplate>
														<EditItemTemplate>
															<asp:LinkButton id="lbDGISave" runat="server" CommandName="Update">
																<asp:Image id="imgDGISave" runat="server" ImageUrl="../images/qms_save_sym.gif" AlternateText="Save"></asp:Image>
															</asp:LinkButton>
															<asp:LinkButton id="lbDGIClose" runat="server" CausesValidation="false" CommandName="Cancel">
																<asp:Image id="imgDGIClose" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif" AlternateText="Close"></asp:Image>
															</asp:LinkButton>
														</EditItemTemplate>
													</asp:TemplateColumn>
												</Columns>
												<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
											</asp:DataGrid>
											</div>
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD>
																	<P>
																		<asp:ImageButton id="ibAddProperty" runat="server" ImageUrl="../images/qms_add_btn.gif" ToolTip="Add property"
																			CausesValidation="False"></asp:ImageButton>
																		<asp:ImageButton id="ibDeleteProperty" runat="server" ImageUrl="../images/qms_delete_btn.gif" ToolTip="Delete selected property"
																			CausesValidation="False"></asp:ImageButton></P> <!-- END SEARCH FORM AND FIELDS TABLE --></TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3">
                                                        <IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</TABLE>
								<asp:Panel id="pnlHousehold" Runat="server">
									<BR>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TR>
											<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
												<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
													<TR>
														<TD class="bordercolor" width="1" rowSpan="4">
                                                            <img height="1" src="../images/clear.gif" width="1"><img 
                                        height="1" src="../images/clear.gif" width="1"></img></img></TD>
														<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
														<TD class="bordercolor" width="1" rowSpan="4">
                                                            <img height="1" src="../images/clear.gif" width="1"><img 
                                        height="1" src="../images/clear.gif" width="1"></img></img></TD>
													</TR>
													<TR>
														<TD bgColor="#d7d7c3" rowSpan="2">
															<TABLE cellSpacing="0" cellPadding="1" border="0">
																<TR>
																	<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Household</TD>
																</TR>
															</TABLE>
														</TD>
														<TD vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2">
                                                            <IMG height="21" src="../images/tableheader.gif" width="22"></TD>
														<TD class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
												</TABLE>
												<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
													<TR>
														<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
														<TD width="100%" bgColor="#f0f0f0">
															<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
																<TR>
																	<TD>
																		<asp:Literal id="ltResultsFoundHousehold" runat="server"></asp:Literal></TD>
																</TR>
															</TABLE>
														</TD>
														<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
													<TR>
														<TD class="bordercolor" width="100%" colSpan="3">
                                                            <IMG height="1" src="../images/clear.gif" width="1"></TD>
													</TR>
												</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
												<div style="height:300px;overflow:scroll">
												<asp:DataGrid id="dgHousehold" runat="server" Width="100%" AutoGenerateColumns="False">
													<Columns>
														<asp:BoundColumn DataField="RespondentID" SortExpression="RespondentID" HeaderText="ID"></asp:BoundColumn>
														<asp:TemplateColumn HeaderText="Name">
															<ItemTemplate>
																<asp:Label runat="server" Text='<%# String.Format("{0}, {1}", Container.DataItem("LastName"), Container.DataItem("FirstName"))%>' ID="Label3">
																</asp:Label>
															</ItemTemplate>
														</asp:TemplateColumn>
														<asp:BoundColumn DataField="SurveyName" SortExpression="SurveyName" HeaderText="Survey"></asp:BoundColumn>
														<asp:BoundColumn DataField="SurveyInstanceName" SortExpression="SurveyInstanceName" HeaderText="Instance"></asp:BoundColumn>
														<asp:TemplateColumn>
															<ItemStyle Wrap="False"></ItemStyle>
															<ItemTemplate>
																<asp:HyperLink id=hlDetails runat="server" ToolTip="View Respondent" BorderWidth="0px" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}") %>' Text="Details" ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
																<asp:HyperLink id=hlDataEntry runat="server" ToolTip="Data Entry" BorderWidth="0px" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=1") %>' Text="Details" ImageUrl="../images/qms_dataentry2_sym.gif">Data Entry</asp:HyperLink>
																<asp:HyperLink id=hlVerify runat="server" ToolTip="Verification" BorderWidth="0px" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=2") %>' Text="Details" ImageUrl="../images/qms_verify_sym.gif">Verify</asp:HyperLink>
																<asp:HyperLink id=hlCATI runat="server" ToolTip="CATI" BorderWidth="0px" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=3") %>' Text="Details" ImageUrl="../images/qms_cati_sym.gif">CATI</asp:HyperLink>
																<asp:HyperLink id=hlReminder runat="server" ToolTip="Reminder" BorderWidth="0px" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=4") %>' Text="Details" ImageUrl="../images/qms_reminder_sym.gif">Reminder</asp:HyperLink>
															</ItemTemplate>
														</asp:TemplateColumn>
													</Columns>
												    </asp:DataGrid>
											    </div>
											</TD>
										</TR>
									</TABLE>
								</asp:Panel>
								<BR>
								<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
									<TR>
										<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4">
                                                        <img height="1" src="../images/clear.gif" width="1"><img 
                                    height="1" src="../images/clear.gif" width="1"></img></img></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Event Log</TD>
															</TR>
														</TABLE>
													</TD>
													<TD vAlign="top" width="22" rowSpan="2">
                                                        <IMG height="21" src="../images/tableheader.gif" width="22"></TD>
													<TD width="100%"><IMG height="18" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD>
																	<asp:Literal id="ltResultsFoundEvents" runat="server"></asp:Literal></TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3">
                                                        <IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE> <!-- END TITLE AND TABLE HEADING TABLE -->
											<asp:datagrid id="dgRespondentEvents" runat="server" Width="100%" AllowPaging="True" AutoGenerateColumns="False"
												AllowSorting="True" PageSize="50">
												<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
												<ItemStyle VerticalAlign="Top"></ItemStyle>
												<Columns>
													<asp:TemplateColumn>
														<ItemTemplate>
															<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
														</ItemTemplate>
													</asp:TemplateColumn>
													<asp:BoundColumn DataField="EventDate" SortExpression="EventDate" HeaderText="Date"></asp:BoundColumn>
													<asp:TemplateColumn SortExpression="EventID" HeaderText="Event">
														<ItemTemplate>
															<asp:Literal id="ltEvent" runat="server"></asp:Literal>
														</ItemTemplate>
													</asp:TemplateColumn>
													<asp:TemplateColumn HeaderText="Value">
														<ItemTemplate>
															<asp:Literal id="ltEventParameters" runat="server"></asp:Literal>
														</ItemTemplate>
													</asp:TemplateColumn>
													<asp:TemplateColumn SortExpression="UserID" HeaderText="User">
														<ItemTemplate>
															<asp:Literal id="ltUsername" runat="server"></asp:Literal>
														</ItemTemplate>
													</asp:TemplateColumn>
												</Columns>
												<PagerStyle ForeColor="White" Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
											</asp:datagrid>
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="100%" bgColor="#f0f0f0">
														<TABLE cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
															<TR>
																<TD>
																	<P>
																		<asp:ImageButton id="ibDeleteEvent" runat="server" ImageUrl="../images/qms_delete_btn.gif" ToolTip="Delete selected events"
																			CausesValidation="False"></asp:ImageButton>
																		<asp:ImageButton id="ibOverride" runat="server" ImageUrl="../images/qms_close_delete3_sym.gif" ToolTip="Override survey audit"
																			CausesValidation="False"></asp:ImageButton></P>
																</TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3">
                                                        <IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</TABLE>
								<BR>
								<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
									<TR>
										<TD><!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<TR>
													<TD class="bordercolor" width="1" rowSpan="4">
                                                        <img height="1" src="../images/clear.gif" width="1"><img 
                                    height="1" src="../images/clear.gif" width="1"></img></img></TD>
													<TD colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></TD>
													<TD width="1" rowSpan="4">
                                                        <img height="1" src="../images/clear.gif" width="1"><img 
                                    height="1" src="../images/clear.gif" width="1"></img></img></TD>
												</TR>
												<TR>
													<TD bgColor="#d7d7c3" rowSpan="2">
														<TABLE cellSpacing="0" cellPadding="1" border="0">
															<TR>
																<TD class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Actions</TD>
															</TR>
														</TABLE>
													</TD>
													<TD vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></TD>
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
																	<TABLE cellSpacing="0" cellPadding="5" border="0">
																		<TR vAlign="top">
																			<TD noWrap align="right" width="10%"><SPAN class="label">Script:</SPAN></TD>
																			<TD width="10%">
																				<asp:dropdownlist id="ddlScriptID" runat="server" CssClass="sfselect" AutoPostBack="True"></asp:dropdownlist></TD>
																			<TD vAlign="top" width="80%">
																				<asp:hyperlink id="hlStartScript" runat="server" ImageUrl="../images/qms_start_btn.gif" ToolTip="Start selected script">Start Script</asp:hyperlink>
																				<asp:HyperLink id="hlStartScriptReadOnly" runat="server" ImageUrl="../images/qms_close_delete3_sym.gif">View in Read-Only </asp:HyperLink>&nbsp;
																			</TD>
																		</TR>
																		<asp:Panel id="pnlActions" Runat="server">
																			<TR vAlign="top">
																				<TD noWrap align="right">
																					<asp:Label id="lblInputOutcome" runat="server" CssClass="label"></asp:Label></TD>
																				<TD>
																					<asp:dropdownlist id="ddlEventID" runat="server" CssClass="sfselect"></asp:dropdownlist></TD>
																				<TD>
																					<asp:ImageButton id="ibSubmitResp" runat="server" ImageUrl="../images/qms_submitrspndnt_btn.gif"
																						ToolTip="Submit outcome for respondent" CausesValidation="False"></asp:ImageButton>
																					<asp:ImageButton id="ibSubmitHousehold" runat="server" ImageUrl="../images/qms_submithsehld_btn.gif"
																						ToolTip="Submit selected outcome for entire household" CausesValidation="False"></asp:ImageButton></TD>
																			</TR>
																			<TR vAlign="top">
																				<TD noWrap align="right"><SPAN class="label">Appointment:</SPAN></TD>
																				<TD noWrap>Date:
																					<asp:textbox id="tbAppointmentDate" runat="server" CssClass="sfdatefield" ToolTip="Date of appointment"></asp:textbox>&nbsp;Time:
																					<asp:textbox id="tbAppointmentTime" runat="server" CssClass="sfdatefield" ToolTip="Time of appointment"></asp:textbox></TD>
																				<TD>
																					<asp:ImageButton id="ibSchedule" runat="server" ImageUrl="../images/qms_schedule_btn.gif" ToolTip="Schedule appointment"
																						CausesValidation="False"></asp:ImageButton></TD>
																			</TR>
																			<TR vAlign="top">
																				<TD noWrap align="right"><SPAN class="label">Note:</SPAN></TD>
																				<TD vAlign="top">
																					<asp:TextBox id="tbNotes" runat="server" Width="300px" CssClass="sftextfield" ToolTip="Enter note about respondent and click submit"
																						Rows="5" TextMode="MultiLine"></asp:TextBox></TD>
																				<TD>
																					<asp:ImageButton id="ibSubmitNote" runat="server" ImageUrl="../images/qms_submit_btn.gif" ToolTip="Submit Note"></asp:ImageButton></TD>
																			</TR>
																		</asp:Panel>
																		<asp:Panel id="pnlChangeInputMode" Visible="False" Runat="server">
																			<TR vAlign="top">
																				<TD noWrap align="right"><SPAN class="label">Change Input Mode:</SPAN></TD>
																				<TD vAlign="top" colSpan="2">
																					<asp:HyperLink id="hlChangeView" runat="server" ImageUrl="../images/qms_view1_sym.gif" ToolTip="View Respondent"
																						Text="Details" BorderWidth="0px">Details</asp:HyperLink>
																					<asp:HyperLink id=hlChangeDE runat="server" ImageUrl="../images/qms_dataentry2_sym.gif" ToolTip="Data Entry" Text="Details" BorderWidth="0px">Data Entry</asp:HyperLink>
																					<asp:HyperLink id=hlChangeVerfication runat="server" ImageUrl="../images/qms_verify_sym.gif" ToolTip="Verification" Text="Details" BorderWidth="0px">Verify</asp:HyperLink>
																					<asp:HyperLink id=hlChangeCati runat="server" ImageUrl="../images/qms_cati_sym.gif" ToolTip="CATI" Text="Details" BorderWidth="0px">CATI</asp:HyperLink>
																					<asp:HyperLink id=hlChangeReminder runat="server" ImageUrl="../images/qms_reminder_sym.gif" ToolTip="Reminder" Text="Details" BorderWidth="0px">Reminder</asp:HyperLink>
																					<asp:HyperLink id=hlChangeIncoming runat="server" ImageUrl="../images/qms_incoming.gif" ToolTip="Incoming" Text="Details" BorderWidth="0px">Incoming</asp:HyperLink>
																					<asp:HyperLink id=hlChangeReadOnly runat="server" ImageUrl="../images/qms_close_delete3_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.RespondentID", "selectrespondent.aspx?rid={0}&amp;input=9") %>' BorderWidth="0px">Read-Only</asp:HyperLink></TD>
																			</TR>
																		</asp:Panel></TABLE> <!-- END SEARCH FORM AND FIELDS TABLE --></TD>
															</TR>
														</TABLE>
													</TD>
													<TD class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
												<TR>
													<TD class="bordercolor" width="100%" colSpan="3">
                                                        <IMG height="1" src="../images/clear.gif" width="1"></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</TABLE>
							</asp:Panel>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
