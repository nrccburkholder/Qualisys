<%@ Page Language="vb" AutoEventWireup="false" Codebehind="printsurvey.aspx.vb" Inherits="QMSWeb.frmPrintSurvey"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<asp:Repeater id="rptQuestions" runat="server">
				<HeaderTemplate>
					<asp:Literal ID="ltSurveyName" Runat="server"></asp:Literal><br>
					<asp:Literal ID="ltSurveyDesc" Runat="server"></asp:Literal><br>
					<asp:Literal ID="ltSurveyAuthor" Runat="server"></asp:Literal><br>
					<asp:Literal ID="ltSurveyDate" Runat="server"></asp:Literal>
				</HeaderTemplate>
				<ItemTemplate>
					<asp:Literal ID="ltQuestionDesc" Runat="server"></asp:Literal><br>
					<asp:literal ID="ltQuestionType" Runat="server"></asp:literal><br>
					<asp:literal ID="ltQuestionText" Runat="server"></asp:literal><br>
					<asp:DataGrid ID="dgAnswerCategories" Runat="server" ShowHeader="False" AutoGenerateColumns="False"
						CellPadding="3" GridLines="None">
						<Columns>
							<asp:BoundColumn DataField="AnswerCategoryValue" DataFormatString="{0} - "></asp:BoundColumn>
							<asp:BoundColumn DataField="AnswerCategoryText"></asp:BoundColumn>
							<asp:BoundColumn DataField="AnswerCategoryTypeName" DataFormatString="({0})"></asp:BoundColumn>
						</Columns>
					</asp:DataGrid>
				</ItemTemplate>
			</asp:Repeater>
		</form>
	</body>
</HTML>
