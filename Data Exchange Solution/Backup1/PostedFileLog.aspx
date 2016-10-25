<%@ Page Language="vb" AutoEventWireup="false" Codebehind="PostedFileLog.aspx.vb" Inherits="DataExchange.PostedFileLog"%>
<%@ Register TagPrefix="ew" Assembly="eWorld.UI, Version=1.9.0.0, Culture=neutral, PublicKeyToken=24d65337282035f2" Namespace="eWorld.UI" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>PostedFileLog</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD>
						<FONT size="2"><STRONG><FONT size="3">Posted File Log</FONT></STRONG>
							<asp:imagebutton id="btnExport" runat="server" ToolTip="Export to Excel" ImageUrl="Img/ExcelDoc.gif"></asp:imagebutton>
						</FONT>
					</TD>
				</TR>
				<tr id="trDateSelection" runat="server">
					<td><FONT face="Verdana" size="1">Start Date:</FONT>
						<ew:calendarpopup id="StartDate" runat="server" Text="Change Date" ImageUrl="img/DownArrow.gif" Font-Names="Verdana"
							Font-Size="XX-Small" ControlDisplay="LabelImage">
							<TextboxLabelStyle Font-Size="XX-Small" Font-Names="Verdana"></TextboxLabelStyle>
							<WeekdayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></WeekdayStyle>
							<MonthHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" Font-Bold="True" ForeColor="White" BackColor="#318991"></MonthHeaderStyle>
							<OffMonthStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Gray" BackColor="White"></OffMonthStyle>
							<GoToTodayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></GoToTodayStyle>
							<TodayDayStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="#FFC0C0"></TodayDayStyle>
							<DayHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="White" BackColor="#318991"></DayHeaderStyle>
							<WeekendStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="#E0E0E0"></WeekendStyle>
							<SelectedDateStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="LightSteelBlue"></SelectedDateStyle>
							<ClearDateStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></ClearDateStyle>
							<HolidayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></HolidayStyle>
						</ew:calendarpopup>&nbsp;&nbsp;<FONT face="Verdana" size="1">End Date</FONT>&nbsp;
						<ew:calendarpopup id="EndDate" runat="server" Text="Change Date" ImageUrl="img/DownArrow.gif" Font-Names="Verdana"
							Font-Size="XX-Small" ControlDisplay="LabelImage">
							<TextboxLabelStyle Font-Size="XX-Small" Font-Names="Verdana"></TextboxLabelStyle>
							<WeekdayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></WeekdayStyle>
							<MonthHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" Font-Bold="True" ForeColor="White" BackColor="#318991"></MonthHeaderStyle>
							<OffMonthStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Gray" BackColor="White"></OffMonthStyle>
							<GoToTodayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></GoToTodayStyle>
							<TodayDayStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="#FFC0C0"></TodayDayStyle>
							<DayHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="White" BackColor="#318991"></DayHeaderStyle>
							<WeekendStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="#E0E0E0"></WeekendStyle>
							<SelectedDateStyle Font-Size="XX-Small" Font-Names="Verdana" ForeColor="Black" BackColor="LightSteelBlue"></SelectedDateStyle>
							<ClearDateStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></ClearDateStyle>
							<HolidayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></HolidayStyle>
						</ew:calendarpopup>&nbsp;
						<asp:imagebutton id="btnGo" runat="server" ImageUrl="img/Go.gif" ToolTip="Go!"></asp:imagebutton></td>
				</tr>
				<TR>
					<TD>
						<asp:DataGrid id="PostedFileGrid" runat="server" Font-Size="XX-Small" Font-Names="Verdana" AllowPaging="True"
							PageSize="25" AutoGenerateColumns="False">
							<AlternatingItemStyle Font-Size="XX-Small" Font-Names="Verdana" Wrap="False" BackColor="Beige"></AlternatingItemStyle>
							<ItemStyle Font-Size="XX-Small" Font-Names="Verdana" Wrap="False"></ItemStyle>
							<HeaderStyle Font-Bold="True" Wrap="False" BackColor="DarkSeaGreen"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="File ID" HeaderText="File ID">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="File Poster" HeaderText="File Poster">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Download User" HeaderText="Download User">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Old File Name" HeaderText="Old File Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="New File Name" HeaderText="New File Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Description" HeaderText="Description">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Date Posted" HeaderText="Date Posted">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Last Downloaded" HeaderText="Last Downloaded">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Number of Downloads" HeaderText="Number of Downloads">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Deleted" HeaderText="Deleted">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="Notes" HeaderText="Notes">
									<HeaderStyle Wrap="False" Width="600px"></HeaderStyle>
								</asp:BoundColumn>
							</Columns>
							<PagerStyle Font-Size="X-Small" Font-Names="Verdana" PageButtonCount="20" Mode="NumericPages"></PagerStyle>
						</asp:DataGrid></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>
