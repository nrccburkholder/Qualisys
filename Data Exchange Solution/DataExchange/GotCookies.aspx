<%@ Page Language="vb" AutoEventWireup="false" Codebehind="GotCookies.aspx.vb" Inherits="DataExchange.GotCookies"%>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Data Upload</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout"
		marginwidth="0" marginheight="0">
		<form id="Form1" method="post" runat="server">
			<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD><uc1:ucheader id="UcHeader1" runat="server"></uc1:ucheader></TD>
				</TR>
				<TR>
					<TD>
						<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD><STRONG><FONT size="3">Browser Settings Requirements</FONT></STRONG></TD>
							</TR>
							<TR>
								<TD><IMG alt="" src="img/ghost.gif" width="15"></TD>
							</TR>
							<TR>
								<TD>
									<P>Your current browser settings do not permit you to access this site.&nbsp; This 
										site requires the use of "session cookies".&nbsp; Session cookies are small 
										strings of text stored within your browser memory.&nbsp; These text strings 
										remain on your computer only until you end your session on this site.</P>
									<P>To enable cookies on your browser you may want to contact your facility's system 
										administrator.</P>
									<P>To enable cookies in Internet Explorer 6.0:</P>
									<UL>
										<LI>
										Select "Internet Options" from the "Tools" menu.
										<LI>
										On the privacy tab, set your privacy level to "medium."
										<LI>
											Click OK.&nbsp; Close your browser then try to access this site again.</LI></UL>
									<P>To enable cookies in Netscape 7.0</P>
									<UL>
										<LI>
										Select "Preferences" from the "Edit" menu.
										<LI>
										Expand the "Privacy and Security" section of the Category tree.
										<LI>
										Select "cookies"
										<LI>
										Choose the appropriate settings to allow cookies.
										<LI>
											Close your browser then try to access this site again.</LI></UL>
									<P>For additional help contact the <a href="mailto:clientsupport@nationalresearch.com">Client 
											Support</a> team at NRC.</P>
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
