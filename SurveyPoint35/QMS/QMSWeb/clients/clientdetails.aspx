<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="clientdetails.aspx.vb" Inherits="QMSWeb.frmClientDetails" smartNavigation="True"%>
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
	</HEAD>
	<body>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Client Details</td>
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
																<asp:validationsummary id="vsClientDetails" runat="server" Width="100%"></asp:validationsummary>
																	<TABLE cellSpacing="0" cellPadding="3" bgColor="#f0f0f0" border="0">
																		<tr vAlign="top">
																			<td class="label" align="right">Client ID</td>
																			<td colSpan="3"><asp:label id="lblClientID" runat="server"></asp:label></td>
																			<td align="right" colSpan="2"><asp:checkbox id="cbActive" runat="server" Font-Bold="True" Text="Active" CssClass="detcheckbox"></asp:checkbox></td>
																		</tr>
																		<TR vAlign="top">
																			<TD class="label" align="right">Name</TD>
																			<TD colSpan="5"><asp:textbox id="tbName" runat="server" Width="300px" MaxLength="100" CssClass="dettextfield"></asp:textbox><asp:requiredfieldvalidator id="rfvName" runat="server" ControlToValidate="tbName" ErrorMessage="Please provide a name">*</asp:requiredfieldvalidator></TD>
																		</TR>
																		<TR vAlign="top">
																			<TD class="label" align="right">Address</TD>
																			<TD colSpan="5"><asp:textbox id="tbAddress1" runat="server" Width="300px" MaxLength="250" CssClass="dettextfield"></asp:textbox><BR>
																				<asp:TextBox id="tbAddress2" runat="server" Width="300px" MaxLength="250" CssClass="dettextfield"></asp:TextBox></TD>
																		</TR>
																		<TR vAlign="top">
																			<TD align="right" class="label">City</TD>
																			<TD><asp:TextBox id="tbCity" runat="server" Width="150px" CssClass="dettextfield"></asp:TextBox></TD>
																			<TD align="right" class="label">State</TD>
																			<td><asp:DropDownList id="ddlState" runat="server" CssClass="detselect">
																					<asp:ListItem Value="Select a State">Select a State</asp:ListItem>
																					<asp:ListItem Value="California">California</asp:ListItem>
																				</asp:DropDownList></td>
																			<TD align="right"><STRONG>Zip</STRONG>&nbsp;</TD>
																			<TD><asp:TextBox id="tbPostalCode" runat="server" MaxLength="50" Width="100px" CssClass="dettextfield"></asp:TextBox>
																				<asp:RegularExpressionValidator id="revPostalCode" runat="server" ErrorMessage="Please provide a valid zip code"
																					ControlToValidate="tbPostalCode" ValidationExpression="\d{5}(-\d{4})?">*</asp:RegularExpressionValidator></TD>
																		</TR>
																		<TR vAlign="top">
																			<TD align="right" class="label">Telephone</TD>
																			<TD><asp:TextBox id="tbTelephone" runat="server" MaxLength="50" Width="150px" CssClass="dettextfield"></asp:TextBox>
																				<asp:RegularExpressionValidator id="revTelephone" runat="server" ErrorMessage="Please provide a valid telephone number"
																					ControlToValidate="tbTelephone" ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}">*</asp:RegularExpressionValidator></TD>
																			<TD align="right" class="label">Fax</TD>
																			<TD colspan="3"><asp:TextBox id="tbFax" runat="server" MaxLength="50" Width="150px" CssClass="dettextfield"></asp:TextBox>
																				<asp:RegularExpressionValidator id="revFax" runat="server" ErrorMessage="Please provide a valid fax number" ControlToValidate="tbFax"
																					ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}">*</asp:RegularExpressionValidator></TD>
																		</TR>
																		<tr>
																			<td>&nbsp;</td>
																			<td colspan="5">
																				<asp:ImageButton id="ibSubmit" runat="server" ImageUrl="../images/qms_save_btn.gif" ToolTip="Save changes"
																					EnableViewState="False"></asp:ImageButton>
																				<asp:HyperLink id="hlCancel" runat="server" NavigateUrl="clients.aspx" ImageUrl="../images/qms_done_btn.gif"
																					EnableViewState="False">Exit without saving changes</asp:HyperLink>
																			</td>
																		</tr>
																	</TABLE>																
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
						<td style="background-color:#f0f0f0">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:DataGrid id="dgSurveyInstances" runat="server" Width="100%" AllowSorting="True" PageSize="500" AutoGenerateColumns="False"
								AllowPaging="True">
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:BoundColumn DataField="InstanceDate" SortExpression="InstanceDate" HeaderText="Date" DataFormatString="{0:d}"></asp:BoundColumn>
									<asp:BoundColumn DataField="SurveyName" SortExpression="SurveyName" HeaderText="Survey Name"></asp:BoundColumn>
									<asp:BoundColumn DataField="Name" SortExpression="Name" HeaderText="Survey Instance Name"></asp:BoundColumn>
									<asp:TemplateColumn SortExpression="Active" HeaderText="Active">
										<ItemTemplate>
											<%# IIf(Container.DataItem("Active") = 1, "Yes", "No") %>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:HyperLink id=HyperLink1 runat="server" Text="Details" ImageUrl="../images/qms_view1_sym.gif" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.SurveyInstanceID", "../surveyinstances/surveyinstancedetails.aspx?id={0}") %>'>Details</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
							</asp:DataGrid>
							</div>
							<!-- END DATAGRID -->
							<asp:HyperLink id="hlAddSurveyInstance" runat="server" ImageUrl="../images/qms_add_btn.gif">Add Survey Instance</asp:HyperLink>
						</td>
					</tr>
					<tr>
						<td>
							<uc1:ucTemplates id="uctTemplates" runat="server"></uc1:ucTemplates>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
