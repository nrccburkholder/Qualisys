<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FooterControlCss.ascx.vb" Inherits="Nrc.MySolutions.UserControls_FooterControlCss" %>
<%@ OutputCache Duration="600" VaryByParam="none" %>
<div id="FooterDiv">
<hr />
<div style="float:left;">
    <asp:HyperLink ID="PrivacyLink" runat="server">Privacy Policy</asp:HyperLink>
</div>
<div style="float:right;">
    <asp:Label ID="CopyrightLabel" runat="server" Text="© 2006 NRC+Picker, a Division of National Research Corporation"></asp:Label>
</div>
<div id="FooterVersionDiv" style="clear:both">
<div style="float:left">
    <asp:Label ID="DateTimeLabel" runat="server" Text="DateTime"></asp:Label>
</div>
<div style="float:right">
    <asp:Label ID="VersionLabel" runat="server" Text="v1.0.0.0"></asp:Label>
</div>
</div>
</div>