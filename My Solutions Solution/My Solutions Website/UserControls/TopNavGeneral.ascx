<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TopNavGeneral.ascx.vb" Inherits="Nrc.MySolutions.UserControls_TopNavGeneral" %>
<div id="TopNavDiv">
    <asp:HyperLink ID="AboutUsLink" runat="server">About Us</asp:HyperLink>
    <asp:Literal ID="ProductsSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="ProductsLink" runat="server">Products & Services</asp:HyperLink>
    <asp:Literal ID="MySolutionsSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="MySolutionsLink" runat="server">My Solutions</asp:HyperLink>
    <asp:Literal ID="HcahpsSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="HcahpsLink" runat="server">HCAHPS</asp:HyperLink>    
    <asp:Literal ID="EReportsSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="EReportsLink" runat="server" NavigateUrl="~/eReports">eReports</asp:HyperLink>
    <asp:Literal ID="ECommentsSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="ECommentsLink" runat="server" NavigateUrl="~/eComments">eComments</asp:HyperLink>
    <asp:Literal ID="EToolKitSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="EToolKitLink" runat="server" NavigateUrl="~/eToolKit">eToolKit</asp:HyperLink>
    <asp:Literal ID="LearningNetworkSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="LearningNetworkLink" runat="server">Learning Network</asp:HyperLink>
    <asp:Literal ID="MyAccountSpacer" runat="server">&nbsp;|&nbsp;</asp:Literal>
    <asp:HyperLink ID="MyAccountLink" runat="server" NavigateUrl="~/MyAccount">My Accounts</asp:HyperLink>    
    <div style="position:absolute;top:2px;right:20px;"><asp:LoginStatus ID="LoginStatus1" runat="server" LoginText="" LogoutText="Sign Out" /></div>   
    <div style="position:absolute;top:0px;right:0px"><asp:Image ID="TopNavCornerImage" runat="server" ImageUrl="~/img/header_menu_corner.gif" AlternateText=" " /></div>
</div>