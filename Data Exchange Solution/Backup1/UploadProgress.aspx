<%@ Page Language="vb" AutoEventWireup="false" Codebehind="UploadProgress.aspx.vb" Inherits="DataExchange.UploadProgress"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Progress...</title>
		<meta http-equiv="expires" content="Tue, 01 Jan 1981 01:00:00 GMT">
		<asp:literal id="ltlMeta" runat="server"></asp:literal><asp:literal id="ltlScript" runat="server"></asp:literal>
	</HEAD>
	<body bgColor="#cccccc">
		<table width="100%" border="0">
			<tr>
				<td><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>Uploading:</b></font></td>
			</tr>
			<tr bgColor="#999999">
				<td>
					<table id="tdProgress" cellSpacing="1" bgColor="#0033ff" border="0" runat="server">
						<tr>
							<td><font size="1">&nbsp;</font></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0">
						<tr>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Estimated time left:</font></td>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><asp:literal id="ltlMin" runat="server"></asp:literal>min
									<asp:literal id="ltlSec" runat="server"></asp:literal>secs (<asp:literal id="ltlTheKbDone" runat="server"></asp:literal>
									KB of
									<asp:literal id="ltlKbTotal" runat="server"></asp:literal>KB uploaded) </font>
							</td>
						</tr>
						<tr>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Transfer Rate:</font></td>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><asp:literal id="ltlTheKbps" runat="server"></asp:literal>KB/sec</font></td>
						</tr>
						<tr>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Information:</font></td>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><asp:literal id="ltlNote" runat="server"></asp:literal></font></td>
						</tr>
						<tr>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Uploading File:</font></td>
							<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><asp:literal id="ltlFileName" runat="server"></asp:literal></font></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
			</tr>
		</table>
	</body>
</HTML>
