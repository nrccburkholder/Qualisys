<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="filedefinitiondetails.aspx.vb" Inherits="QMSWeb.frmFileDefinitionDetails" smartNavigation="False"%>
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
			<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;File Definition Details</td>
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
																<asp:ValidationSummary id="vsFileDefs" runat="server" Width="100%"></asp:ValidationSummary>
																<table cellpadding="5" cellspacing="0" border="0" width="100%">
																	<tr>
																		<td class="label" align="right" width="100">Name</td>
																		<td>
																			<asp:TextBox id="tbFileDefName" runat="server" Width="300" CssClass="dettextfield"></asp:TextBox>
																			<asp:RequiredFieldValidator id="rfvFileDefName" runat="server" ErrorMessage="Please provide a name." ControlToValidate="tbFileDefName">*</asp:RequiredFieldValidator>
																		</td>
																		<td class="label" align="right" width="100">ID</td>
																		<td>
																			<asp:Literal id="ltFileDefID" runat="server"></asp:Literal></td>
																	</tr>
																	<tr>
																		<td class="label" align="right" width="100">Description</td>
																		<td colspan="3">
																			<asp:TextBox id="tbFileDefDescription" runat="server" CssClass="dettextfield" Width="300px"></asp:TextBox>
																			<asp:RequiredFieldValidator id="rfvFileDefDescription" runat="server" ErrorMessage="Please provide a description."
																				ControlToValidate="tbFileDefDescription">*</asp:RequiredFieldValidator>
																		</td>
																	</tr>
																	<tr>
																		<td class="label" align="right" width="100">Type</td>
																		<td>
																			<asp:Literal id="ltTypeName" runat="server"></asp:Literal>
																			<asp:DropDownList id="ddlFileDefTypeID" runat="server" CssClass="detselect" AutoPostBack="True"></asp:DropDownList>
																			<asp:RequiredFieldValidator id="rfvFileDefTypeID" runat="server" ControlToValidate="ddlFileDefTypeID" ErrorMessage="Please select import or export"
																				Display="Dynamic">*</asp:RequiredFieldValidator></td>
																		<td class="label" align="right" width="100">File Format</td>
																		<td>
																			<asp:Literal id="ltFileFormatName" runat="server"></asp:Literal>
																			<asp:DropDownList id="ddlFileTypeID" runat="server" CssClass="detselect"></asp:DropDownList>
																			<asp:RequiredFieldValidator id="rfvFileTypeID" runat="server" ControlToValidate="ddlFileTypeID" ErrorMessage="Please select file format"
																				Display="Dynamic">*</asp:RequiredFieldValidator></td>
																	</tr>
																	<tr>
																		<td class="label" align="right" width="100">Survey</td>
																		<td>
																			<asp:Literal id="ltSurveyName" runat="server"></asp:Literal>
																			<asp:DropDownList id="ddlSurveyID" runat="server" CssClass="detselect"></asp:DropDownList>
																			<asp:RequiredFieldValidator id="rfvSurveyId" runat="server" ControlToValidate="ddlSurveyID" ErrorMessage="Please select a survey"
																				Display="Dynamic" EnableViewState="False" Enabled="False">*</asp:RequiredFieldValidator></td>
																		<td class="label" align="right" width="100">Client</td>
																		<td>
																			<asp:DropDownList id="ddlClientID" runat="server" CssClass="detselect"></asp:DropDownList></td>
																	</tr>
																	<tr>
																		<td class="label" align="right" width="100">Delimiter</td>
																		<td colspan="3">
																			<asp:TextBox id="tbFileDefDelimiter" runat="server" MaxLength="1" CssClass="detnumberfield"></asp:TextBox>
																			<asp:RequiredFieldValidator ID="rfvFileDefDelimiter" Runat="server" ControlToValidate="tbFileDefDelimiter" ErrorMessage="Please provide a delimiter."
																				Display="Static">*</asp:RequiredFieldValidator>
																		</td>
																	</tr>
																	<tr>
																		<td align="right" width="100"></td>
																		<td colspan="3">
																			<asp:ImageButton ID="ibSave" Runat="server" ImageUrl="../images/qms_save_btn.gif" tooltip="Save changes"
																				EnableViewState="False"></asp:ImageButton>
																			<asp:hyperlink id="hlCancel" runat="server" ImageUrl="../images/qms_done_btn.gif" NavigateUrl="filedefinitions.aspx"
																				ToolTip="Exit without saving changes">Done</asp:hyperlink>
																			<asp:HyperLink id="hlExecute" runat="server" ImageUrl="../images/qms_execute_btn.gif" tooltip="Go to execution page for this file definition">Execute</asp:HyperLink>
																		</td>
																	</tr>
																</table>
																<!-- END SEARCH FORM AND FIELDS TABLE -->
															</td>
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
						<td class="WritableBG">
							<!-- THIS TABLE IS THE DATAGRID -->
							<asp:panel id="pnlFileDefColumns" Runat="server">
							<div style="height:500px;overflow:scroll">
								<asp:datagrid id="dgFileDefColumns" runat="server" Width="100%" PageSize="15" AutoGenerateColumns="False">
									<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
									<ItemStyle VerticalAlign="Top"></ItemStyle>
									<Columns>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:CheckBox id="cbSelected" runat="server" CssClass="gridcheckbox"></asp:CheckBox>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Order">
											<ItemTemplate>
												<asp:DropDownList id="ddlSortIndex" runat="server" CssClass="gridselect"></asp:DropDownList>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:Label id=lblDisplayOrder runat="server" Text='<%# Container.DataItem("DisplayOrder") %>'>
												</asp:Label>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Position">
											<ItemTemplate>
												<asp:literal id="ltPosition" runat="server"></asp:literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Width">
											<ItemTemplate>
												<asp:literal id="ltWidth" runat="server"></asp:literal>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox id=tbWidth runat="server" CssClass="gridnumberfield" MaxLength="4" Text='<%# Container.DataItem("Width") %>'>
												</asp:TextBox>
												<asp:RequiredFieldValidator id="rfvWidth" runat="server" ControlToValidate="tbWidth" ErrorMessage="Please provide a column width"
													Display="Dynamic">*</asp:RequiredFieldValidator>
												<asp:CompareValidator id="cvWidth" runat="server" ControlToValidate="tbWidth" ErrorMessage="Width must be greater than zero."
													Display="Dynamic" Operator="GreaterThan" ValueToCompare="0" Type="Integer">*</asp:CompareValidator>
											</EditItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn HeaderText="Field Name">
											<ItemTemplate>
												<asp:literal id=ltColumnName runat="server" Text='<%# Container.DataItem("ColumnName") %>'>
												</asp:literal>
											</ItemTemplate>
										</asp:TemplateColumn>
										<asp:TemplateColumn>
											<ItemTemplate>
												<asp:ImageButton id="ibDGIEdit" runat="server" CausesValidation="False" AlternateText="Edit" ImageUrl="../images/qms_dataentry1_sym.gif"
													CommandName="Edit"></asp:ImageButton>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:LinkButton id="lbDGISave" runat="server" CommandName="Update">
													<asp:Image id="imbDGISave" runat="server" ImageUrl="../images/qms_save_sym.gif" AlternateText="Save"></asp:Image>
												</asp:LinkButton>
												<asp:LinkButton id="lbDGIClose" runat="server" CausesValidation="false" CommandName="Cancel">
													<asp:Image id="imgDGIClose" runat="server" ImageUrl="../images/qms_close_delete2_sym.gif" AlternateText="Close"></asp:Image>
												</asp:LinkButton>
											</EditItemTemplate>
										</asp:TemplateColumn>
									</Columns>
									<PagerStyle Position="TopAndBottom"></PagerStyle>
								</asp:datagrid>
							</div>
								<asp:Table id="tblColumnControls" Runat="server" CellPadding="0" CellSpacing="0" BorderWidth="0">
									<asp:TableRow VerticalAlign="Bottom">
										<asp:TableCell CssClass="label">Field Columns:</asp:TableCell>
										<asp:TableCell CssClass="label">New Property Name:</asp:TableCell>
										<asp:TableCell ColumnSpan="3"></asp:TableCell>
									</asp:TableRow>
									<asp:TableRow VerticalAlign="Top">
										<asp:TableCell>
											<asp:DropDownList id="ddlColumnName" runat="server" CssClass="sfselect"></asp:DropDownList>
										</asp:TableCell>
										<asp:TableCell>
											<asp:TextBox id="tbPropertyName" runat="server" Width="150px" CssClass="sftextfield" MaxLength="50"
												ToolTip="Provide property name for a new property"></asp:TextBox>
											<asp:RegularExpressionValidator id="revPropertyName" runat="server" ControlToValidate="tbPropertyName" ErrorMessage="No white space in property name."
												ValidationExpression="^\w*$">*</asp:RegularExpressionValidator>
										</asp:TableCell>
										<asp:TableCell>
											<asp:ImageButton id="ibAdd" runat="server" ToolTip="Add file column" ImageUrl="../images/qms_add_btn.gif"></asp:ImageButton>
										</asp:TableCell>
										<asp:TableCell>
											<asp:ImageButton id="ibUpdateOrder" runat="server" ToolTip="Update column order" ImageUrl="../images/qms_reorder_btn.gif"></asp:ImageButton>
										</asp:TableCell>
										<asp:TableCell>
											<asp:ImageButton id="ibDelete" runat="server" ToolTip="Delete selected columns" ImageUrl="../images/qms_delete_btn.gif"></asp:ImageButton>
										</asp:TableCell>
									</asp:TableRow>
								</asp:Table>
							</asp:panel>
							<!-- END DATAGRID -->
						</td>
					</tr>
					<tr>
						<td class="WritableBG">
							<uc1:ucTemplates id="uctTemplates" runat="server"></uc1:ucTemplates>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
	</body>
</HTML>
