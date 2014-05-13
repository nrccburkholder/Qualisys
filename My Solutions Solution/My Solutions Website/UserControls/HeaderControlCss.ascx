<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HeaderControlCss.ascx.vb" Inherits="Nrc.MySolutions.HeaderControlCss" %>
<%@ Register Src="TopNavGeneral.ascx" TagName="TopNavGeneral" TagPrefix="uc2" %>
<%@ Register Src="CurrentUser.ascx" TagName="CurrentUser" TagPrefix="uc1" %>
<div id="HeaderDiv">
<div id="HeaderLogoDiv"><asp:HyperLink ID="LogoLink" runat="server"><asp:Image ID="LogoImage" runat="server" ImageUrl="~/img/logo_left.gif" AlternateText="NRC+Picker" /></asp:HyperLink></div>
<div id="HeaderLinksDiv"><asp:HyperLink ID="HomeLink" runat="server" Text="Home" />&nbsp;|&nbsp;<asp:HyperLink ID="ContactLink" runat="server" Text="Contact Us" />&nbsp;|&nbsp;<asp:HyperLink ID="SiteMapLink" runat="server" Text="Site Map" /></div>
<div id="HeaderCurrentUserDiv"><uc1:CurrentUser id="CurrentUser1" runat="server" /></div>
<uc2:TopNavGeneral id="TopNavGeneral1" runat="server" ShowAboutUs="false" ShowEComments="true" ShowEReports="true" ShowEToolKit="true" ShowHcahps="false" ShowLearningNetwork="false" ShowMyAccount="true" ShowMySolutions="true" ShowProducts="false"/>
</div>