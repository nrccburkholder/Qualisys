<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Download.aspx.vb" Inherits="DataExchange.Download"%>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Download</title>
		<script language="javascript">
		<!--
		function incrementdl() {
			var curval = Number(document.getElementById("fcounter").innerHTML);
			var nextval = curval + 1;
			document.getElementById("fcounter").innerHTML = nextval;
		}
		
		function pageinit() {
			<asp:Literal id="litJScript" runat="server" Visible="False"></asp:Literal>	
		}

		
		// -->
		</script>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="globalfunctions.js"></script>
	</HEAD>
	<body onload="pageinit()" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<TABLE id="tblBody" cellSpacing="1" cellPadding="1" width="100%" border="0">
			<TR>
				<TD><uc1:ucheader id="UcHeader1" runat="server"></uc1:ucheader>
				</TD>
			</TR>
			<TR>
				<TD>
					<asp:Table id="tblFileInfo" runat="server" CellPadding="2" CellSpacing="0">
						<asp:TableRow>
							<asp:TableCell Text="&lt;IMG alt=&quot;&quot; src=&quot;img/ghost.gif&quot; width=&quot;15&quot;&gt;"></asp:TableCell>
						</asp:TableRow>
					</asp:Table>
				</TD>
			</TR>
			<TR>
				<TD><uc1:ucfooter id="UcFooter1" runat="server"></uc1:ucfooter></TD>
			</TR>
		</TABLE>
	</body>
</HTML>
