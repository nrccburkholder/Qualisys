<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="includes/ucQMSHeader.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="TaskCalendar.aspx.vb" Inherits="QMSWeb.TaskCalendar"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>TaskCalendar</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<P>
				<uc1:ucQMSHeader id="UcQMSHeader1" runat="server"></uc1:ucQMSHeader></P>
			<P>
				<asp:Calendar id="cdrSurveyTasks" runat="server" NextPrevFormat="FullMonth" BackColor="White"
					Width="100%" DayNameFormat="FirstLetter" ForeColor="Black" Height="600px" Font-Size="10pt"
					Font-Names="Times New Roman" BorderColor="Black" SelectionMode="None">
					<TodayDayStyle BackColor="#CCCC99"></TodayDayStyle>
					<SelectorStyle Font-Size="8pt" Font-Names="Verdana" Font-Bold="True" ForeColor="#333333" Width="1%"
						BackColor="#CCCCCC"></SelectorStyle>
					<DayStyle Font-Size="10px" HorizontalAlign="Left" BorderWidth="1px" BorderStyle="Solid" Width="14%"
						VerticalAlign="Top"></DayStyle>
					<NextPrevStyle Font-Size="8pt" ForeColor="White"></NextPrevStyle>
					<DayHeaderStyle Font-Size="7pt" Font-Names="Verdana" Font-Bold="True" Height="10px" ForeColor="#333333"
						BackColor="#CCCCCC"></DayHeaderStyle>
					<SelectedDayStyle ForeColor="White" BackColor="#CC3333"></SelectedDayStyle>
					<TitleStyle Font-Size="13pt" Font-Bold="True" Height="14pt" ForeColor="White" BackColor="Black"></TitleStyle>
					<OtherMonthDayStyle ForeColor="#999999"></OtherMonthDayStyle>
				</asp:Calendar></P>
		</form>
	</body>
</HTML>
