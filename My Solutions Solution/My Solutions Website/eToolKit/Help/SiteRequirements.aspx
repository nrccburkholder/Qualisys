<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="SiteRequirements.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_SiteRequirements" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Site Requirements" />
    <div style="padding-left:10px;">
        <div>
            <div id="CautionDiv" runat="server">
                <img src="../../img/Caution.gif" alt="" style="vertical-align:middle;" />
                <span class="PageTitle">Caution</span>
                <br />
                <span>Your browser does not meet the minimum requirements of this site.  Some features of this web site may not function or display as expected.</span>
                <h5>Problems Detected:</h5>
                <div id="JavascriptDiv" runat="server" style="margin-bottom: 5px;">
                    <img src="../../img/ExpandRight.gif" alt="" style="vertical-align:middle;" />
                    <span style="color:#cc0000;">Javascript is disabled.</span>
                </div>
                <div id="CookiesDiv" runat="server">
                    <img src="../../img/ExpandRight.gif" alt="" style="vertical-align:middle;" />
                    <span style="color:#cc0000;">Cookies are disabled.</span>
                    <div style="margin-left:20px;">To enable cookies in Internet Explorer 6.0:
                        <ul>
                            <li>Select "Internet Options" from the "Tools" menu.</li>
                            <li>On the privacy tab, set your privacy level to "medim"</li>
                            <li>Click OK and then try to access this site again.</li>
                        </ul>
                        To enable cookies in Netscape 7.0:
                        <ul>
                            <li>Select "Preferences" from the "Edit" menu.</li>
                            <li>Expand the "Privacy and Security" section of the Category tree</li>
                            <li>Select "cookies"</li>
                            <li>Choose the appropriate settings to allow cookies.</li>
                            <li>Click OK and then try to access this site again.</li>
                        </ul>
                    </div>                
                </div>
            </div>
            <div>
                <div>
                    <h5>Minimum Requirements:</h5>
                    <ul>
                        <li>233 Mhz Pentium</li>
                        <li>64 MB RAM</li>
                        <li>Windows 98 with Service Pack 2</li>
                        <li>IE 5.5 or higher</li>
                        <li>Netscape Navigator 6.2.2 or higher</li>
                    </ul>
                </div>
                <br />
                <div>
                    <h5>Recommended Requirements:</h5>
                    <ul>
                        <li>Pentium III</li>
                        <li>128 MB RAM</li>
                        <li>Windows XP Service Pack 2</li>
                        <li>IE 6.0 or higher</li>
                    </ul>
                </div>
                <br />
                <div>
                    <h5>Additional Software:</h5>
                    <ul>
                        <li>Adobe Acrobat Reader</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>