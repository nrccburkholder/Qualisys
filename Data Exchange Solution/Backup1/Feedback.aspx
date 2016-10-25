<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Feedback.aspx.vb" Inherits="DataExchange.Feedback"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Picker Data Exchange Feedback</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
	</HEAD>
	<body MS_POSITIONING="FlowLayout" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0"
		marginheight="0" marginwidth="0">
		<form id="Form1" method="post" runat="server">
			<uc1:ucHeader id="UcHeader1" runat="server"></uc1:ucHeader>
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
									<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
										<TR>
											<TD colSpan="2"><IMG alt="" src="img/ghost.gif" width="15"></TD>
										</TR>
										<TR>
											<TD colSpan="2"><FONT size="2">NRC welcomes your comments and questions.&nbsp; Please 
													write your message below and click <STRONG>send</STRONG> when you are done.</FONT></TD>
										</TR>
										<TR>
											<TD colSpan="2"><IMG alt="" src="img/ghost.gif" width="15"></TD>
										</TR>
										<TR>
											<TD valign="top" colspan="2"><STRONG><FONT size="2">Comment/Question:</FONT></STRONG><br>
												<asp:TextBox id="txtComment" runat="server" TextMode="MultiLine" Width="500" Height="150px"></asp:TextBox></TD>
										</TR>
										<TR>
											<TD colspan="2">
												<asp:Button id="btnSend" runat="server" Text="Send"></asp:Button></TD>
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
			<uc1:ucFooter id="UcFooter1" runat="server"></uc1:ucFooter>
		</form>
	</body>
</HTML>
