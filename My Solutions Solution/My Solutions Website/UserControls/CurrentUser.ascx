<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CurrentUser.ascx.vb" Inherits="Nrc.MySolutions.UserControls_CurrentUser" %>
<%@ Register Src="QuickGroupSelector.ascx" TagName="QuickGroupSelector" TagPrefix="uc1" %>
<asp:LoginView ID="LoginView1" runat="server">
<LoggedInTemplate>
<div id="HeaderWelcomeBegin" style="float:left;"><asp:Label ID="UserNameLabel" runat="server" Text="John Doe"></asp:Label></div>
<%--<div id="HeaderQuickGroupSelector" style="float:left"><asp:HyperLink ID="GroupSelectionLink" runat="server"></asp:HyperLink></div>
<div id="HeaderWelcomeEnd" style="float:left;">)</div>--%>
</LoggedInTemplate>
</asp:LoginView>