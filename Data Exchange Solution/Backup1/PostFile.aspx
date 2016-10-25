<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="PostFile.aspx.vb" Inherits="DataExchange.PostFile" validateRequest="False"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC+Picker Data Exchange Feedback</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginheight="0" marginwidth="0"
		MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" encType="multipart/form-data" runat="server">
			<uc1:ucheader id="UcHeader1" showPassword="true" runat="server"></uc1:ucheader>
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
						<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD>
									<TABLE id="tblContent" cellSpacing="3" cellPadding="3" width="100%" border="0">
										<TR>
											<TD>To send a file to a client please enter the client's name, email address and a 
												description of the file.&nbsp; Then click on the <STRONG>Browse</STRONG> button 
												to select the file you want to send.&nbsp; When you are ready to&nbsp;upload 
												the file click the <STRONG>Upload File</STRONG> button. See the <a href="uploadguide.aspx" target="_blank">
													User Manual</a> for assistance.
											</TD>
										</TR>
										<TR>
											<TD>
												<TABLE class="Login" id="tblForm" cellSpacing="1" cellPadding="1" width="100%" border="0">
													<TR>
														<TD noWrap>Client First Name:</TD>
														<TD width="100%"><asp:textbox id="txtFName" runat="server"></asp:textbox></TD>
													</TR>
													<TR>
														<TD noWrap>Client Last Name:</TD>
														<TD><asp:textbox id="txtLName" runat="server"></asp:textbox></TD>
													</TR>
													<TR>
														<TD noWrap>Client Email Address:</TD>
														<TD><asp:textbox id="txtEmail" runat="server"></asp:textbox>&nbsp;<STRONG>* Be sure to 
																enter the email address correctly!</STRONG></TD>
													</TR>
													<TR>
														<TD noWrap>File Description:</TD>
														<TD><asp:textbox id="txtDescription" runat="server"></asp:textbox></TD>
													</TR>
													<tr>
														<td>Notes:</td>
														<td>
															<asp:TextBox TextMode="MultiLine" ID="txtNotes" Columns="50" Rows="3" Runat="server"></asp:TextBox>
														</td>
													</tr>
													<TR>
														<TD noWrap>File:</TD>
														<TD><INPUT id="inpFile" type="file" name="File1" runat="server"></TD>
													</TR>
													<TR>
														<TD noWrap></TD>
														<TD><asp:button id="btnUpload" runat="server" Text="Upload File"></asp:button>&nbsp;
															<asp:Label id="lblMessage" runat="server"></asp:Label></TD>
													</TR>
												</TABLE>
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
