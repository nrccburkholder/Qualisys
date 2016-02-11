<%@ Page Language="vb" AutoEventWireup="false" Codebehind="TriggerDemo.aspx.vb" Inherits="QMSWeb.TriggerDemo"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>TriggerDemo</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
		<meta name="CODE_LANGUAGE" content="Visual Basic 7.0">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<TABLE id="Table1" cellSpacing="1" cellPadding="1" width="100%" border="1">
				<TR>
					<TD>
						<P align="right"><STRONG>Trigger</STRONG></P>
					</TD>
					<TD>
						<asp:DropDownList id="ddlTriggerID" runat="server"></asp:DropDownList></TD>
				</TR>
				<TR>
					<TD>
						<P align="right"><STRONG>Respondent ID</STRONG></P>
					</TD>
					<TD>
						<asp:TextBox id="tbRespondentID" runat="server"></asp:TextBox>
						<asp:CompareValidator id="CompareValidator1" runat="server" ErrorMessage="Must be a integer" ControlToValidate="tbRespondentID" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator></TD>
				</TR>
				<TR>
					<TD>
						<P align="right"><STRONG>Script Screen ID</STRONG></P>
					</TD>
					<TD>
						<asp:TextBox id="tbScriptScreenID" runat="server"></asp:TextBox>
						<asp:CompareValidator id="CompareValidator2" runat="server" ErrorMessage="Must be a integer" ControlToValidate="tbScriptScreenID" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator></TD>
				</TR>
				<TR>
					<TD><STRONG>
							<P align="right">&nbsp;</P>
						</STRONG>
					</TD>
					<TD>
						<asp:CheckBox id="cbRunCriteria" runat="server" Text="Check Trigger Criteria" Font-Bold="True"></asp:CheckBox></TD>
				</TR>
				<TR>
					<TD colSpan="2"><STRONG>
							<P align="center">
								<asp:Button id="btnExecute" runat="server" Text="Execute"></asp:Button></P>
						</STRONG>
					</TD>
				</TR>
			</TABLE>
			<asp:DataGrid id="dgResults" runat="server" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" BackColor="White" CellPadding="4">
				<SelectedItemStyle Font-Bold="True" ForeColor="#663399" BackColor="#FFCC66"></SelectedItemStyle>
				<ItemStyle ForeColor="#330099" BackColor="White"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#FFFFCC" BackColor="#990000"></HeaderStyle>
				<FooterStyle ForeColor="#330099" BackColor="#FFFFCC"></FooterStyle>
				<PagerStyle HorizontalAlign="Center" ForeColor="#330099" BackColor="#FFFFCC"></PagerStyle>
			</asp:DataGrid>
		</form>
	</body>
</HTML>
