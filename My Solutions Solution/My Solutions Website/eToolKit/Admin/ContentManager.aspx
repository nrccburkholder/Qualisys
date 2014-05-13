<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ContentManager.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_ContentManager" ValidateRequest="false" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<script type="text/javascript">
    function TabClick(tab){
        if (tab.className == "TabButtonInactive"){
            ToggleSelectedTab();
        }
    }
    function ToggleSelectedTab(){
        var teaser = GetDocElement("TeaserTabDiv");
        var content = GetDocElement("ContentTabDiv");
        var teaserEditor = GetDocElement("TeaserEditorDiv");
        var contentEditor = GetDocElement("ContentEditorDiv");
        
        if (teaser.className == "TabButtonActive") {
            teaser.className = "TabButtonInactive";
            content.className = "TabButtonActive";
            teaserEditor.style.display = "none";
            contentEditor.style.display = "block";
        }
        else {
            teaser.className = "TabButtonActive";
            content.className = "TabButtonInactive";       
            teaserEditor.style.display = "block";
            contentEditor.style.display = "none";
        }
    }
</script>
<div style="float:left;width:730px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Content Manager" />
    <table id="FormTable" cellspacing="5" cellpadding="0">
        <tr id="trCategoryDDL" runat="server">
            <td class="InputPrompt">Categories:</td>
            <td class="InputField"><asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="True"></asp:DropDownList>&nbsp;<asp:LinkButton ID="btnNewCategory" runat="server">New Category and Key</asp:LinkButton></td>
        </tr>
        <tr id="trKeyDDL" runat="server">
            <td class="InputPrompt">Keys:</td>
            <td class="InputField"><asp:DropDownList ID="ddlKey" runat="server" AutoPostBack="True"></asp:DropDownList>&nbsp;<asp:LinkButton ID="btnNewKey" runat="server">New Key</asp:LinkButton></td>
        </tr>
        <tr id="trCategoryTXT" runat="server">
            <td class="InputPrompt">Category:</td>
            <td class="InputField"><asp:TextBox ID="txtCategory" runat="server"></asp:TextBox></td>
        </tr>
        <tr id="trKeyTXT" runat="server">
            <td class="InputPrompt">Key:</td>
            <td class="InputField"><asp:TextBox ID="txtKey" runat="server"></asp:TextBox></td>
        </tr>
        <tr id="trActive" runat="server">
            <td class="InputPrompt">Active:</td>
            <td class="InputField"><asp:CheckBox ID="IsActive" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td colspan="2"><asp:Button ID="btnSave" runat="server" Text="Save"></asp:Button>&nbsp;&nbsp;<asp:Button ID="btnDelete" runat="server" Text="Delete"></asp:Button>&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server" Text="Cancel"></asp:Button></td>
        </tr>
    </table>
    <div id="TeaserTabDiv" class="TabButtonActive" onclick="TabClick(this);">Teaser</div>
    <div class="TabButtonSpacer">&nbsp;</div>
    <div id="ContentTabDiv" class="TabButtonInactive" onclick="TabClick(this);">Content</div>
    <div class="TabButtonFiller"></div>               
    <div class="TabContent">
        <div id="TeaserEditorDiv"><FTB:FreeTextBox id="Teaser" runat="server" ButtonSet="Office2003" ImageGalleryPath="~/img/Gallery" SupportFolder="~/js/FreeTextBox/" ToolbarLayout="ParagraphMenu,FontFacesMenu,FontSizesMenu,FontForeColorsMenu|Bold,Italic,Underline,Strikethrough;Superscript,Subscript,RemoveFormat|JustifyLeft,JustifyRight,JustifyCenter,JustifyFull;BulletedList,NumberedList,Indent,Outdent;CreateLink,Unlink,InsertImage,InsertImageFromGallery,InsertRule|Cut,Copy,Paste;Undo,Redo,Print," AllowHtmlMode="False" AssemblyResourceHandlerPath="" AutoConfigure="" AutoGenerateToolbarsFromString="True" AutoHideToolbar="True" AutoParseStyles="True" BackColor="158, 190, 245" BaseUrl="" BreakMode="Paragraph" ButtonDownImage="False" ButtonFileExtention="gif" ButtonFolder="Images" ButtonHeight="20" ButtonImagesLocation="InternalResource" ButtonOverImage="False" ButtonPath="" ButtonWidth="21" ClientSideTextChanged="" ConvertHtmlSymbolsToHtmlCodes="False" DesignModeBodyTagCssClass="" DesignModeCss="" DisableIEBackButton="False" DownLevelCols="50" DownLevelMessage="" DownLevelMode="TextArea" DownLevelRows="10" EditorBorderColorDark="Gray" EditorBorderColorLight="Gray" EnableHtmlMode="True" EnableSsl="False" EnableToolbars="True" Focus="False" FormatHtmlTagsToXhtml="True" GutterBackColor="129, 169, 226" GutterBorderColorDark="Gray" GutterBorderColorLight="White" Height="350px" HelperFilesParameters="" HelperFilesPath="" HtmlModeCss="" HtmlModeDefaultsToMonoSpaceFont="True" ImageGalleryUrl="ftb.imagegallery.aspx?rif={0}&cif={0}" InstallationErrorMessage="InlineMessage" JavaScriptLocation="InternalResource" Language="en-US" PasteMode="Default" ReadOnly="False" RemoveScriptNameFromBookmarks="True" RemoveServerNameFromUrls="True" RenderMode="NotSet" ScriptMode="External" ShowTagPath="False" SslUrl="/." StartMode="DesignMode" StripAllScripting="False" TabIndex="-1" TabMode="InsertSpaces" Text="" TextDirection="LeftToRight" ToolbarBackColor="Transparent" ToolbarBackgroundImage="True" ToolbarImagesLocation="InternalResource" ToolbarStyleConfiguration="OfficeXP" UpdateToolbar="True" UseToolbarBackGroundImage="True" Width="722px" /></div>
        <div id="ContentEditorDiv" style="display:none;"><FTB:FreeTextBox id="Content" runat="server" ButtonSet="Office2003" ImageGalleryPath="~/img/Gallery" SupportFolder="~/js/FreeTextBox/" ToolbarLayout="ParagraphMenu,FontFacesMenu,FontSizesMenu,FontForeColorsMenu|Bold,Italic,Underline,Strikethrough;Superscript,Subscript,RemoveFormat|JustifyLeft,JustifyRight,JustifyCenter,JustifyFull;BulletedList,NumberedList,Indent,Outdent;CreateLink,Unlink,InsertImage,InsertImageFromGallery,InsertRule|Cut,Copy,Paste;Undo,Redo,Print" AllowHtmlMode="False" AssemblyResourceHandlerPath="" AutoConfigure="" AutoGenerateToolbarsFromString="True" AutoHideToolbar="True" AutoParseStyles="True" BackColor="158, 190, 245" BaseUrl="" BreakMode="Paragraph" ButtonDownImage="False" ButtonFileExtention="gif" ButtonFolder="Images" ButtonHeight="20" ButtonImagesLocation="InternalResource" ButtonOverImage="False" ButtonPath="" ButtonWidth="21" ClientSideTextChanged="" ConvertHtmlSymbolsToHtmlCodes="False" DesignModeBodyTagCssClass="" DesignModeCss="" DisableIEBackButton="False" DownLevelCols="50" DownLevelMessage="" DownLevelMode="TextArea" DownLevelRows="10" EditorBorderColorDark="Gray" EditorBorderColorLight="Gray" EnableHtmlMode="True" EnableSsl="False" EnableToolbars="True" Focus="False" FormatHtmlTagsToXhtml="True" GutterBackColor="129, 169, 226" GutterBorderColorDark="Gray" GutterBorderColorLight="White" Height="350px" HelperFilesParameters="" HelperFilesPath="" HtmlModeCss="" HtmlModeDefaultsToMonoSpaceFont="True" ImageGalleryUrl="ftb.imagegallery.aspx?rif={0}&cif={0}" InstallationErrorMessage="InlineMessage" JavaScriptLocation="InternalResource" Language="en-US" PasteMode="Default" ReadOnly="False" RemoveScriptNameFromBookmarks="True" RemoveServerNameFromUrls="True" RenderMode="NotSet" ScriptMode="External" ShowTagPath="False" SslUrl="/." StartMode="DesignMode" StripAllScripting="False" TabIndex="-1" TabMode="InsertSpaces" Text="" TextDirection="LeftToRight" ToolbarBackColor="Transparent" ToolbarBackgroundImage="True" ToolbarImagesLocation="InternalResource" ToolbarStyleConfiguration="OfficeXP" UpdateToolbar="True" UseToolbarBackGroundImage="True" Width="722px" /></div>
    </div>
</div>
</asp:Content>
