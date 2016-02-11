<%@ Page Language="vb" AutoEventWireup="false" Codebehind="printscript.aspx.vb" Inherits="QMSWeb.frmPrintScript" EnableSessionState="ReadOnly" enableViewState="False"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body style="background-color: #FFFFFF; filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#FFFFFF',startColorstr='#FFFFFF' gradientType='0');">
		<form id="Form1" method="post" runat="server">
			<table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolor="#000000" bordercolordark="#000000"
				bordercolorlight="#000000">
				<tr>
					<td class="label" align="right" width="15%">Survey ID:</td>
					<td width="5%">
						<asp:Literal id="ltSurveyID" runat="server" EnableViewState="False"></asp:Literal></td>
					<td class="label" align="right" width="15%" nowrap>Survey Name:</td>
					<td width="65%">
						<asp:Literal id="ltSurveyName" runat="server" EnableViewState="False"></asp:Literal></td>
				</tr>
				<tr>
					<td class="label" align="right">Script ID:</td>
					<td>
						<asp:Literal id="ltScriptID" runat="server" EnableViewState="False"></asp:Literal></td>
					<td class="label" align="right" nowrap>Script Name:</td>
					<td>
						<asp:Literal id="ltScriptName" runat="server" EnableViewState="False"></asp:Literal></td>
				</tr>
				<tr>
					<td class="label" align="right">
						Description:</td>
					<td colspan="3">
						<asp:Literal id="ltScriptDesc" runat="server"></asp:Literal></td>
				</tr>
				<TR>
					<TD class="label" align="right">Completeness:</TD>
					<TD>
						<asp:Literal id="ltCompleteness" runat="server"></asp:Literal></TD>
					<TD class="label" align="right">Type:</TD>
					<TD>
						<asp:Literal id="ltScriptType" runat="server"></asp:Literal></TD>
				</TR>
				<TR valign="top">
					<TD class="label" align="right">Options:</TD>
					<TD colSpan="3">
						<asp:CheckBox id="cbDefaultScript" runat="server" Text="Default Script" CssClass="sfcheckbox"></asp:CheckBox><br>
						<asp:CheckBox id="cbCalculate" runat="server" Text="Calculate Completeness" CssClass="sfcheckbox"></asp:CheckBox><br>
						<asp:CheckBox id="cbFollowSkips" runat="server" Text="Follow Skips" CssClass="sfcheckbox"></asp:CheckBox>
					</TD>
				</TR>
			</table>
			<asp:Repeater id="rptScriptScreens" runat="server" EnableViewState="False">
				<SeparatorTemplate>
					<HR width="95%" size="1">
				</SeparatorTemplate>
				<ItemTemplate>
					<table width="100%" border="0" cellpadding="5" cellspacing="0">
						<tr>
							<td class="label">Screen:</td>
							<td class="label"><%# Container.DataItem("ItemOrder")%>.
								<%# Container.DataItem("Title") %>
							</td>
							<td class="label" align="right" width="10%">Calculation:</td>
							<td width="20%">
								<%# Container.DataItem("CalculationTypeName")%></asp:Literal></td>
						</tr>
						<tr valign="top">
							<td class="label" width="1%" nowrap>Survey Question:</td>
							<td width="55%">
								<%# Container.DataItem("SurveyQuestionDesc")%></asp:Literal></td>
							<td class="label" align="right" width="10%" nowrap>Question Type:</td>
							<td width="20%">
								<%# Container.DataItem("QuestionTypeName")%></asp:Literal></td>
						</tr>
						<tr valign="top">
							<td class="label">Screen Text:</td>
							<td colspan="3"><%# Container.DataItem("Text")%></td>
						</tr>
						<tr valign="top">
							<td class="label">Categories:</td>
							<td colspan="3">
								<asp:DataGrid ID="dgScriptCategories" Runat="server" Width="100%" AutoGenerateColumns="False"
									BorderWidth="1px" BorderColor="#000000" CellPadding="3" CellSpacing="0">
									<HeaderStyle Font-Bold="True"></HeaderStyle>
									<Columns>
										<asp:BoundColumn DataField="AnswerValue" HeaderText="Value">
											<HeaderStyle Width="5%"></HeaderStyle>
										</asp:BoundColumn>
										<asp:BoundColumn DataField="Text" HeaderText="Text">
											<HeaderStyle Width="35%"></HeaderStyle>
										</asp:BoundColumn>
										<asp:BoundColumn DataField="CategoryTypeName" HeaderText="Type">
											<HeaderStyle Width="20%"></HeaderStyle>
										</asp:BoundColumn>
										<asp:BoundColumn DataField="Jump" HeaderText="Jump">
											<HeaderStyle Width="40%"></HeaderStyle>
										</asp:BoundColumn>
									</Columns>
								</asp:DataGrid>
							</td>
						</tr>
					</table>
				</ItemTemplate>
				<FooterTemplate>
					<HR width="95%" size="1">
					<p align="center" class="label">END SCRIPT</span>
				</FooterTemplate>
			</asp:Repeater>
		</form>
	</body>
</HTML>
