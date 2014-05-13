<%@ Page Language="vb" AutoEventWireup="false" Codebehind="Default.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Default" %>

<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc4" %>
<%@ Register Src="../UserControls/HeaderControlCss.ascx" TagName="HeaderControlCss" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/FooterControlCss.ascx" TagName="FooterControlCss" TagPrefix="uc2" %>
<%@ Register Src="UserControls/FeaturedExpert.ascx" TagName="FeaturedExpert" TagPrefix="uc3" %>
<%@ Register TagPrefix="NrcAuth" Namespace="NRC.NRCAuthLib" Assembly="NRC.NRCAuthLib" %>
<%--<%@ Register TagPrefix="rcm" Namespace="NRC.Web" Assembly="NRC" %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>NRC+Picker</title>
    <link href="../css/Styles.css" rel="stylesheet" type="text/css" />
    <script src="<%= ResolveClientUrl("~/js/Scripts.js") %>" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <uc1:headercontrolcss id="HeaderControlCss1" runat="server" />
            <div style="background-position: right; background-repeat: repeat-y; background-image: url(../img/eToolKitBackground.gif);
                width: 760px;">
                <div style="float: left; margin-top: 30px;"><img src="../img/eToolKitLogo.gif" alt="" /></div>
                <div style="float: right; margin-right: 20px;">
                    <asp:LoginView ID="LoginView1" runat="server">
                        <AnonymousTemplate>
                            <NrcAuth:LoginControl ID="LoginControl" runat="server" PasswordRecoveryText=" I forgot my password..."
                                CreateUserText=" " ForeColor="#333333" BorderWidth="1px" BorderStyle="None" BorderColor="#E6E2D8"
                                BackColor="Transparent" Width="250px" InstructionText="Please enter your user name and password."
                                PasswordRecoveryUrl="/MyAccount/PasswordRecover.aspx" DestinationPageUrl="~/eToolKit/DefaultSelection.aspx"
                                NotificationPageUrl="/MyAccount/LoginNotification.aspx" ApplicationName="eToolKit"
                                FailureText="Your sign in attempt was not successful. Please try again." SubmitButtonText="Sign In"
                                TitleText="Members Area" SubmitButtonPosition="Right" SubmitButtonImageUrl="~/img/SignIn.gif"
                                SubmitButtonType="Image" LoginHelpUrl="/MyAccount/Public/SignInHelp.aspx">
                                <TitleTextStyle Font-Bold="True" ForeColor="#017663" BackColor="Transparent"></TitleTextStyle>
                                <SubmitButtonStyle BorderStyle="Solid" BorderWidth="1px" ForeColor="#284775" BorderColor="#CCCCCC"
                                    BackColor="#FFFBFF"></SubmitButtonStyle>
                                <FailureTextStyle ForeColor="Red"></FailureTextStyle>
                                <LabelStyle Font-Size="XX-Small" Font-Names="Verdana" Font-Bold="True"></LabelStyle>
                                <HyperLinkStyle Font-Size="XX-Small" ForeColor="#017663"></HyperLinkStyle>
                                <InstructionTextStyle Font-Size="XX-Small" Font-Italic="True"></InstructionTextStyle>
                            </NrcAuth:LoginControl>
                        </AnonymousTemplate>
                        <RoleGroups>
                            <asp:RoleGroup Roles="eToolkitUser">
                                <ContentTemplate>
                                    <br />
                                    <br />
                                    <asp:HyperLink ID="ViewDataButton" runat="server" ImageUrl="../img/ViewDataButton.gif" NavigateUrl="~/eToolKit/DataSelection.aspx">View My Data</asp:HyperLink>
                                </ContentTemplate>
                            </asp:RoleGroup>
                        </RoleGroups>
                        <LoggedInTemplate>
                            <br />
                            <br />
                            <a href="http://nrcpicker.com/Default.aspx?DN=232,227,3,1,Documents">Click to learn more about eToolKit</a>
                        </LoggedInTemplate>
                    </asp:LoginView>
                </div>
                <div style="clear: both; height: 5px;">&nbsp;</div>
            </div>
            <div id="PageContentBorder">
                <div style="float:left;">
                    <div id="FeaturedPublicationDiv" class="HomePagePanel" style="clear:both" >
                        <h1>Featured Publication</h1>
                        <hr />
                        <nrc:ManagedContentTeaser ID="SuccessTeaser" runat="server" ContentCategory="Success" DetailLinkText="Learn More" DetailPageUrl="Public/SuccessStories.aspx?Key={1}" SelectionMode="MostRecentlyCreated" />
                    </div>
                    <div id="MemberResourcesDiv" class="HomePagePanel" style="clear: both">
                        <%--<uc4:SideNav ID="SideNav1" runat="server" ShowActionPlans="false" ShowSelectionTree="false" ShowSupportMenu="false" ShowToolbox="false" />--%>
                        <h1>Member Resources</h1>
                        <hr />
                        <asp:DataList ID="MemberResourcesList" runat="server">
                            <ItemTemplate>
                                <nrc:MenuBoxLink ID="MemberResourceLink" runat="server" Text='<%# Eval("Title") %>' NavigateUrl='<%# ResourceManager.GetMemberResourcePath(Me, Eval("id")) %>' OpenInNewWindow="true" 
                                    ToolTip='<%# NormalizeSpace(Eval("AbstractPlainText")) %>' Enabled='<%# CurrentUser.HasEToolkitAccess %>' CssClass="MenuBoxItem" />
                            </ItemTemplate>
                        </asp:DataList>
                        <nrc:MenuBoxLink ID="MemberResourceMoreLink" runat="server" Text='More' NavigateUrl="~/eToolKit/ResourceSearch.aspx" CssClass="More" style="text-align: right" />
                    </div>
                </div>
                <div class="HomePagePanel" style="float: left;">
                    <div id="FeaturedExpertDiv" class="HomePagePanel">
                        <h1>Featured Expert</h1>
                        <hr />
                            <uc3:FeaturedExpert ID="ExpertsTeaser" runat="server" />
                    </div>
                    <div id="WhatsNewDiv" class="HomePagePanel">
                        <h1>What's New?</h1>
                        <hr />
                       <nrc:ManagedContentTeaser ID="NewsTeaser" runat="server" ContentCategory="News" DetailLinkText="Learn More" DetailPageUrl="Public/WhatsNew.aspx?Key={1}" SelectionMode="MostRecentlyCreated" />
                    </div>                
                </div>
                <div id="AdvertisementDiv">
                    <a href="http://nrcpicker.com/Default.aspx?DN=232,227,3,1,Documents"><img alt="eToolkit Ad" src="../img/eToolKitAd.gif" style="border:none;" /></a>
                    <br />
                    <asp:literal id="ltlVeriSign" EnableViewState="False" Runat="server"></asp:literal>
                    <br />
                    <asp:literal id="ltlScanAlert" EnableViewState="False" Runat="server"></asp:literal>
                </div>
                <div style="clear:both;height:2px">&nbsp;</div>
            </div>
            <uc2:footercontrolcss id="FooterControlCss1" runat="server" />
        </div>        
    </form>
</body>
</html>
