<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Upload.aspx.vb" Inherits="DataExchange.Upload" validateRequest="False"%>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="NRC.Web" Assembly="NRC" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>
			<%=BrandName()%>
			Data Exchange</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
		<script language="javascript">
			function initPage(){
				var objItems = document.forms[0].elements;
				for (i=0; i< objItems.length; i++){
					//alert(objItems[i].name + ' = ' + objItems[i].type);
					if (objItems[i].type == 'text' || objItems[i].type == 'submit' || objItems[i].type == 'button' || objItems[i].type == 'radio'){
						try{
							objItems[i].focus();
							return;
						}
						catch (e){
						}
					}
				}
			}
			
			function showPrivacy(){
				window.open('Privacy.aspx','privacy_window','height=640,width=800,left=50,top=20,resizable=yes,scrollbars=yes');
			}
			function showInstructions(){
				window.open('instructions.pdf','privacy_window','height=640,width=800,left=250,top=200,resizable=yes,scrollbars=yes');
			}
			function DoUpload() {
				theFeats = "height=140,width=500,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no";
				theUniqueID = (new Date()).getTime() % 1000000000;
				//removed option to use normal .NET upload
				//if (document.forms[0].rbUpload_1.checked) {
				var myForm = document.forms[0];
				
				if (myForm.pnlUserInfo_txtFName.value != "" && myForm.pnlUserInfo_txtLName.value != "" && myForm.pnlFileInfo_txtBeginDate.value != "" && myForm.pnlFileInfo_txtEndDate.value != "" && myForm.pnlFileInfo_inpFile.value != "") {
					window.open("UploadProgress.aspx?ProgressID=" + theUniqueID, theUniqueID, theFeats);
					document.Form1.action = "Upload.aspx?UploadID=" + theUniqueID;
					//document.Form1.hdnUploaded.value = 1;
					//alert('submitting!')
					//document.Form1.submit();
				}
				//}
			}
		</script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" onload="initPage();" rightMargin="0"
		MS_POSITIONING="FlowLayout" marginwidth="0" marginheight="0">
		<form id="Form1" method="post" encType="multipart/form-data" runat="server">
			<uc1:ucheader id="UcHeader1" runat="server"></uc1:ucheader>
			<!-- start border -->
			<table width="760" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
					<td>
						<!-- start content-->
						<TABLE id="tblBody" cellSpacing="0" cellPadding="0" width="100%" border="0">
							<TR>
								<TD>
									<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
										<TR>
											<TD align="right">
												<asp:Label id="lblEmail" runat="server">Current User:</asp:Label></TD>
										</TR>
										<TR>
											<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
										</TR>
										<TR>
											<TD>
												<P><FONT size="2"> Welcome to the
														<%=BrandName()%>
														Secure Data Exchange site.&nbsp;</FONT></P>
												<P><FONT size="2" style="Z-INDEX: 0">Please provide your name, a description of the 
														file (refer to the naming convention noted in your organization’s 
														Implementation Manual), and the type of file being uploaded. Study ID field can 
														be left blank. Be sure to enter a date range as specified for patient/client 
														data. For employee/physician data files, simply enter today’s date in both 
														fields.</FONT></P>
												<P><FONT style="Z-INDEX: 0" size="2"> When you are ready to transmit the file, click on 
														the <STRONG>browse</STRONG> button and select the file you wish to upload. To 
														transmit the file, click the <STRONG>upload</STRONG> button.</FONT></P>
												<P><FONT size="2"><STRONG>Please remember to compress your files before uploading.</STRONG></FONT></P>
											</TD>
										</TR>
										<TR>
											<TD id="tdUploadMethod" runat="server"><IMG alt="" src="img/ghost.gif" width="15">
												<asp:radiobuttonlist id="rbUpload" runat="server" Font-Size="X-Small" Font-Names="Verdana" RepeatDirection="Horizontal">
													<asp:ListItem Value="1">.NET Upload</asp:ListItem>
													<asp:ListItem Value="2" Selected="True">ABCUpload</asp:ListItem>
												</asp:radiobuttonlist></TD>
										</TR>
										<TR>
											<TD>
												<cc1:CollapsePanel id="pnlUserInfo" runat="server" ContentCssClass="ExpanderContent" HeaderCssClass="ExpanderHeader"
													Collapsed="False" ButtonImageCollapsed="img/expand-open.gif" ButtonImage="img/expand-closed.gif"
													Text="User Information" TextAlign="Right" CssClass="Expander" AllowCollapse="False">
													<TABLE id="tblUserInfo" class="PropertyTable" border="0">
														<TR>
															<TD class="PropertyLabel"><STRONG>First Name:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtFName" runat="server"></asp:textbox>
																<asp:requiredfieldvalidator id="vldFName" runat="server" ErrorMessage="You must enter your first name." ControlToValidate="txtFName"></asp:requiredfieldvalidator></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>Last Name:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtLName" runat="server"></asp:textbox>
																<asp:requiredfieldvalidator id="vldLName" runat="server" ErrorMessage="You must enter your last name." ControlToValidate="txtLName"></asp:requiredfieldvalidator></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>Facility Name:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtFacility" runat="server"></asp:textbox></TD>
														</TR>
													</TABLE>
												</cc1:CollapsePanel><br>
												<cc1:CollapsePanel id="pnlFileInfo" runat="server" ContentCssClass="ExpanderContent" HeaderCssClass="ExpanderHeader"
													Collapsed="False" ButtonImageCollapsed="img/expand-open.gif" ButtonImage="img/expand-closed.gif"
													Text="File Information" TextAlign="Right" CssClass="Expander" AllowCollapse="False">
													<TABLE id="tblFileInfo" class="PropertyTable" border="0">
														<TR>
															<TD class="PropertyLabel"><STRONG>Study ID:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtStudyID" runat="server"></asp:textbox></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>File Description:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtDescription" runat="server"></asp:textbox></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>Beginning Service Date:</STRONG><BR>
																(as "mm/dd/yyyy")</TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtBeginDate" runat="server"></asp:textbox>
																<asp:RequiredFieldValidator id="vldBeginDate" runat="server" ErrorMessage='You must enter a date as "mm/dd/yy"'
																	ControlToValidate="txtBeginDate"></asp:RequiredFieldValidator></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>Ending Service Date:</STRONG><BR>
																(as "mm/dd/yyyy")</TD>
															<TD class="PropertyValue">
																<asp:textbox id="txtEndDate" runat="server"></asp:textbox>
																<asp:RequiredFieldValidator id="vldEndDate" runat="server" ErrorMessage='You must enter a date as "mm/dd/yy"'
																	ControlToValidate="txtEndDate"></asp:RequiredFieldValidator></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>File Type:</STRONG></TD>
															<TD class="PropertyValue">
																<asp:dropdownlist id="ddlFileType" runat="server" Width="154px">
																	<asp:ListItem Value="6">DBF</asp:ListItem>
																	<asp:ListItem Value="4">MS Access</asp:ListItem>
																	<asp:ListItem Value="3">MS Excel</asp:ListItem>
																	<asp:ListItem Value="1">Text (delimited)</asp:ListItem>
																	<asp:ListItem Value="2">Text (fixed width)</asp:ListItem>
																	<asp:ListItem Value="5">XML</asp:ListItem>
																</asp:dropdownlist></TD>
														</TR>
														<TR>
															<TD class="PropertyLabel"><STRONG>File to Upload:</STRONG></TD>
															<TD class="PropertyValue"><INPUT style="WIDTH: 386px; HEIGHT: 22px" id="inpFile" size="45" type="file" name="inpFile"
																	runat="server">
																<asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="<BR>You must select a file to upload"
																	ControlToValidate="inpFile"></asp:requiredfieldvalidator></TD>
														</TR>
														<TR>
															<TD colSpan="2"><INPUT id="btnUpload" onclick="DoUpload();" value="Upload my file" type="submit" name="btnUpload"
																	runat="server">&nbsp;&nbsp;<FONT size="2"><STRONG>Note:</STRONG>&nbsp; Large 
																	files may take a few minutes to upload.</FONT>
															</TD>
														</TR>
													</TABLE>
												</cc1:CollapsePanel>
											</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
						</TABLE>
						<!-- border table -->
					</td>
					<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
				</tr>
				<tr>
					<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
				<tr>
					<td colspan="3"><img src="img/ghost.gif" height="2"></td>
				</tr>
			</table>
			<!-- border table -->
			<uc1:ucfooter id="UcFooter1" runat="server"></uc1:ucfooter>
		</form>
	</body>
</HTML>
