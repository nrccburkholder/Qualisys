<%@ Page Language="vb" AutoEventWireup="false" Codebehind="protocoldetails.aspx.vb" Inherits="QMSWeb.frmProtocolDetails" smartNavigation="True"%>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Protocol Details</td>
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
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE--><asp:validationsummary id="vsProtocolDetails" runat="server" Width="100%"></asp:validationsummary>
																<TABLE class="form" cellSpacing="0" cellPadding="5">
																	<TR vAlign="top">
																		<TD class="label" align="right" width="100">Protocol ID</TD>
																		<TD><asp:label id="lblProtocolID" runat="server"></asp:label></TD>
																		<TD class="label" align="right"><STRONG>Created By</STRONG></TD>
																		<TD><asp:label id="lblCreatedBy" runat="server"></asp:label></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right">Protocol Name</TD>
																		<TD colSpan="3"><asp:textbox id="tbName" runat="server" Width="250px" MaxLength="100"></asp:textbox><asp:requiredfieldvalidator id="rfvName" runat="server" ErrorMessage="Please provide a protocol name" ControlToValidate="tbName">*</asp:requiredfieldvalidator></TD>
																	</TR>
																	<TR vAlign="top">
																		<TD class="label" align="right"><STRONG>Description</STRONG></TD>
																		<TD colSpan="3"><asp:textbox id="tbDescription" runat="server" Width="250px" MaxLength="1000" TextMode="MultiLine" Rows="5"></asp:textbox></TD>
																	</TR>
																	<tr vAlign="top">
																		<td>&nbsp;</td>
																		<td><asp:imagebutton id="ibSave" runat="server" EnableViewState="False" ToolTip="Save changes" ImageUrl="../images/qms_save_btn.gif"></asp:imagebutton><asp:hyperlink id="hlCancel" runat="server" EnableViewState="False" ImageUrl="../images/qms_done_btn.gif" NavigateUrl="protocols.aspx">Exit without saving changes</asp:hyperlink></td>
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
						<td class="writablebg">
							<!-- THIS TABLE IS THE DATAGRID -->
							<div style="height:500px;overflow:scroll">
							<asp:datagrid id="dgProtocolSteps" runat="server" Width="100%" AutoGenerateColumns="False">
								<EditItemStyle VerticalAlign="Top"></EditItemStyle>
								<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
								<ItemStyle VerticalAlign="Top"></ItemStyle>
								<Columns>
									<asp:BoundColumn Visible="False" DataField="ProtocolStepTypeID" ReadOnly="True" HeaderText="ProtocolStepTypeID"></asp:BoundColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox" ToolTip="Check to select step for deletion"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn HeaderText="Start Day">
										<ItemTemplate>
											<asp:Label id=lbStartDay runat="server" Text='<%# Container.DataItem("StartDay") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbStartDay runat="server" MaxLength="3" ToolTip="Number of days from survey instance start date" CssClass="gridnumberfield" Text='<%# Container.DataItem("StartDay") %>'>
											</asp:TextBox>
											<asp:RequiredFieldValidator id="rfvProtocolStartDay" runat="server" ControlToValidate="tbStartDay" ErrorMessage="Please provide a protocol step start day" Display="Dynamic" EnableViewState="False">*</asp:RequiredFieldValidator>
											<asp:RegularExpressionValidator id="revProtocolStartDay" runat="server" ControlToValidate="tbStartDay" ErrorMessage="Protocol step start day must be numeric" ValidationExpression="^\d+" Display="Dynamic" EnableViewState="False">*</asp:RegularExpressionValidator>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn SortExpression="ProtocolStepTypeID" HeaderText="Type">
										<ItemTemplate>
											<asp:Literal id="ltProtocolStepTypeName" runat="server"></asp:Literal>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:Literal id="ltProtocolStepTypeName2" runat="server"></asp:Literal>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn HeaderText="Name">
										<ItemTemplate>
											<asp:Label id=lbProtocolStepName runat="server" Text='<%# Container.DataItem("Name") %>'>
											</asp:Label>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox id=tbProtocolStepName runat="server" Width="150px" MaxLength="100" ToolTip="Name or description of step" CssClass="gridtextfield" Text='<%# Container.DataItem("Name") %>'>
											</asp:TextBox>
											<asp:RequiredFieldValidator id="rfvProtocolStepName" runat="server" ControlToValidate="tbProtocolStepName" ErrorMessage="Please provide a step name" EnableViewState="False">*</asp:RequiredFieldValidator>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn HeaderText="Parameters">
										<ItemStyle Wrap="False"></ItemStyle>
										<ItemTemplate>
											<asp:Literal id="ltParameters" runat="server"></asp:Literal>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:Literal id="ltEditParameters" runat="server"></asp:Literal>
										</EditItemTemplate>
									</asp:TemplateColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<asp:ImageButton id="ibDGIEdit" runat="server" CausesValidation="False" CommandName="Edit" ImageUrl="../images/qms_dataentry1_sym.gif" ToolTip="Edit"></asp:ImageButton>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:LinkButton id="lbDGIUpdate" runat="server" CommandName="Update">
												<asp:Image id="Image1" runat="server" ImageUrl="../images/qms_save_sym.gif" AlternateText="Save"></asp:Image>
											</asp:LinkButton>
											<asp:LinkButton id="lbDGICancel" runat="server" CausesValidation="false" CommandName="Cancel">
												<asp:Image id="Image2" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif" AlternateText="Close"></asp:Image>
											</asp:LinkButton>
										</EditItemTemplate>
									</asp:TemplateColumn>
								</Columns>
							</asp:datagrid>
						</div>
						</td>
					</tr>
					<tr>
					    <td class="WritableBG">
							<asp:panel id="pnlProtocolStepLinks" runat="server">
								<TABLE cellSpacing="0" cellPadding="3" border="0">
									<TR>
										<TD class="label">Step Type</TD>
										<TD colSpan="2"></TD>
									</TR>
									<TR>
										<TD>
											<asp:DropDownList id="ddlProtocolStepTypeID" runat="server" CssClass="sfselect" DataValueField="ProtocolStepTypeID" DataTextField="Name"></asp:DropDownList></TD>
										<TD>
											<asp:ImageButton id="ibAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" ToolTip="Add protocol step" DESIGNTIMEDRAGDROP="299"></asp:ImageButton></TD>
										<TD>
											<asp:ImageButton id="ibDelete" runat="server" ImageUrl="../images/qms_delete_btn.gif" ToolTip="Delete selected protocol steps"></asp:ImageButton></TD>
									</TR>
								</TABLE>
							</asp:panel>
							<!-- END DATAGRID --></td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
