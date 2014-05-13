<%@ Register TagPrefix="ew" Assembly="eWorld.UI, Version=1.9.0.0, Culture=neutral, PublicKeyToken=24d65337282035f2" Namespace="eWorld.UI" %>
<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="UploadLog.aspx.vb" Inherits="DataExchange.UploadLog"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>NRC Data Upload</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginwidth="0" marginheight="0"
		MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<TABLE id="tblContent" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD><FONT size="2"><STRONG><FONT face="Verdana" size="3">Data Upload Log</FONT></STRONG>&nbsp;&nbsp;<asp:imagebutton id="btnExport" runat="server" ImageUrl="Img/ExcelDoc.gif" ToolTip="Export to Excel"></asp:imagebutton>
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
					<TD><asp:datagrid id="dgLog" runat="server" AllowPaging="True" PageSize="25" Font-Names="Verdana"
							AutoGenerateColumns="False" Font-Size="XX-Small">
							<AlternatingItemStyle BackColor="Beige"></AlternatingItemStyle>
							<HeaderStyle Font-Bold="True" Wrap="False" BackColor="DarkSeaGreen"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="UploadLog_id" HeaderText="ID">
									<HeaderStyle Wrap="False"></HeaderStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="datUpload" HeaderText="Upload Date">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strUserFName" HeaderText="First Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strUserLName" HeaderText="Last Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strUserEmail" HeaderText="EMail">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFacilityName" HeaderText="Facility">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strStudy_id" HeaderText="Study">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFileDescription" HeaderText="File Description">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strBeginDate" HeaderText="Encounter Start">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strEndDate" HeaderText="Encounter End">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFileType" HeaderText="File Type">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn>
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFileSize" HeaderText="Size">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFileNameOld" HeaderText="Original Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
								<asp:BoundColumn DataField="strFileNameNew" HeaderText="New Name">
									<HeaderStyle Wrap="False"></HeaderStyle>
									<ItemStyle Wrap="False"></ItemStyle>
								</asp:BoundColumn>
							</Columns>
							<PagerStyle Font-Size="X-Small" HorizontalAlign="Left" PageButtonCount="20" Mode="NumericPages"></PagerStyle>
						</asp:datagrid></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>
