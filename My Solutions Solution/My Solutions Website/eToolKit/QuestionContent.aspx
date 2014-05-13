<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="QustionContent.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_QuestionContent" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<%@ Register Assembly="ChartFX.Internet" Namespace="SoftwareFX.ChartFX.Internet.Server" TagPrefix="chartfx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="true" ShowToolbox="true" ShowSupportMenu="true" ShowViewSelection="true" ShowDimensionSelection="true" ShowQuestionResultsLink="true" ShowImprovementContentTypes="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Question Results" />
    <div id="PageContents">
        <div id="QuestionContentDiv" style="float:left;width:325px;">
        <asp:image id="NewContentImage" runat="server" Width="32px" Height="36px" AlternateText="Indicates new or updated content within last 90 days." ImageUrl="~/img/NewContent.gif" Visible="False"></asp:image><strong>Question Text:&nbsp;&nbsp;</strong>
        <asp:Label ID="QuestionTextLabel" runat="server" Text=""></asp:Label>
        <p style="font-weight:bold;"><asp:Label ID="ContentTitle" runat="server" Text=""></asp:Label></p>
        <p><asp:Literal ID="ContentLiteral" runat="server"></asp:Literal></p>
        <div><div style="float:left;"><img alt="Indicates new or updated content within last 90 days." src="../img/NewContent.gif" style="vertical-align:middle;" /></div><div style="float:left;">Indicates new or updated content within the last 90 days.</div></div>
        </div>
        <div id="QuestionChartDiv" style="float:right;">
            <div id="BackNavDiv"><asp:Image runat="server" ID="BackImage" ImageUrl="~/img/BackNav.gif" ImageAlign="AbsMiddle" /><asp:HyperLink ID="BackLink" runat="server" CssClass="QuestionLink">Return to Question Results</asp:HyperLink></div>
            <div runat="server" id="TrendLinkDiv"><asp:Image runat="server" ID="TrendChartImage" ImageUrl="~/img/TrendChart.gif" ImageAlign="AbsMiddle" /><a href="eReportsBridge.ashx?Type=Trend" class="QuestionLink" onclick="window.open(this.href);return false;" onkeypress="window.open(this.href);return false;">View Trend Chart</a></div>
            <div runat="server" id="ControlLinkDiv"><asp:Image runat="server" ID="ControlChartImage" ImageUrl="~/img/ControlChart.gif" ImageAlign="AbsMiddle" /><a href="eReportsBridge.ashx?Type=Control" class="QuestionLink" onclick="window.open(this.href);return false;" onkeypress="window.open(this.href);return false;">View Control Chart</a></div>
            <chartfx:Chart id="ScoreChart" runat="server"></chartfx:Chart>
        </div>
    </div>
</div>
</asp:Content>
