<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="ThankYou.aspx.vb" Inherits="DataExchange.ThankYou"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Data Upload</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
	</HEAD>
	<body MS_POSITIONING="FlowLayout" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginheight="0" marginwidth="0">
		<form id="Form1" method="post" runat="server">
			<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD>
						<uc1:ucHeader id="UcHeader1" runat="server"></uc1:ucHeader></TD>
				</TR>
				<TR>
					<TD>
						<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
							</TR>
							<TR>
								<TD>
									<P><FONT size="2"><STRONG><FONT size="3">Thank you.</FONT></STRONG>&nbsp; </FONT>
									</P>
									<P><FONT size="2">Your file has been received successfully.&nbsp; If you would like to 
											upload another file please click </FONT><a href="Upload.aspx"><FONT size="2">here.</FONT></a></P>
								</TD>
							</TR>
							<TR>
								<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<TR>
					<TD>
						<uc1:ucFooter id="UcFooter1" runat="server"></uc1:ucFooter></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>
