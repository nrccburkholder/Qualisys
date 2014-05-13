<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master"
    Codebehind="ResourceManager.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_ResourceManager"
    ValidateRequest="false" %>

<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <!-- 
    Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
                                    1) Assigned 10px font size to whole page.
                                    2) Divided content into sections for easier code readability.
                                    3) Resized "Save" and "Cancel" buttons for aesthetic reasons.
    -->
    
    <!-- Header Section -->
    <div style="float: left; width: 730px; font-size: 10px; background-color: window;">
        <uc3:BreadCrumbs ID="BreadCrumbs1" runat="server" />
        <uc1:PageLogo ID="PageLogo1" runat="server" Title="Member Resource Manager" />
    </div>

    <!-- Tabbed Content Section -->
    <div style="float: left; width: 730px; font-size: 10px; background-color: #d4d0c8;">
        <asp:Button ID="ButtonResource" runat="server" Text="Resource" CausesValidation="False" style="background-color: transparent" />
        <asp:Button ID="ButtonMapQuestions" runat="server" Text="Map Questions" CausesValidation="False" style="background-color: transparent" />
        <asp:Button ID="ButtonMapClients" runat="server" Text="Map Clients" CausesValidation="False" style="background-color: transparent" />
        <br />
        <br />
        
        <!-- 
        Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
                                        1) Divided existing page content across two different Views
                                           in a MultiView control for easier data entry and to reduce clutter.
                                        2) Added third view to contain new TreeView control for mapping 
                                           the resource to client organization units.
        -->
        <asp:MultiView ID="MultiViewContent" runat="server">
        
            <asp:View ID="ViewResource" runat="server">
                <table id="TableResource" width="728px" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 332px; vertical-align: top;">
                            <asp:Panel ID="PanelTitle" runat="server" Height="64px" Width="330px">
                                <asp:Label ID="lblTitleTextBox" runat="server" AssociatedControlID="TitleTextBox" Text="Title" Font-Bold="True"></asp:Label><br />
                                <asp:TextBox ID="TitleTextBox" runat="server" MaxLength="100" Width="300px" Wrap="False"></asp:TextBox><br />
                                <asp:RequiredFieldValidator ID="TitleFVal" runat="server" ControlToValidate="TitleTextBox"
                                    ErrorMessage="Title is Required" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="TitleCustomValidator" runat="server" ControlToValidate="TitleTextBox"
                                    ErrorMessage="Duplicate title" Display="Dynamic" SetFocusOnError="True"></asp:CustomValidator>
                            </asp:Panel>
                            <asp:Panel ID="PanelAuthor" runat="server" Height="64px" Width="330px">
                                <asp:Label ID="lblAuthorTextBox" runat="server" AssociatedControlID="AuthorTextBox" Text="Author" Font-Bold="True"></asp:Label><br />
                                <asp:TextBox ID="AuthorTextBox" runat="server" MaxLength="100" Width="90%"></asp:TextBox><br />
                                <asp:RequiredFieldValidator ID="AuthorFVal" runat="server" ControlToValidate="AuthorTextBox"
                                    ErrorMessage="Author is Required" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </asp:Panel>
                            <asp:Panel ID="PanelDatePosted" runat="server" Height="44px" Width="330px">
                                <asp:Label ID="DatePostedLabel" runat="server" Text="Date Posted" Font-Bold="True"></asp:Label><br />
                                <asp:Label ID="DatePostedTextBox" runat="server"></asp:Label>
                            </asp:Panel>
                            <asp:Panel ID="PanelDateUpdated" runat="server" Height="44px" Width="330px">
                                <asp:Label ID="DateUpdatedLabel" runat="server" Text="Date Updated" Font-Bold="True"></asp:Label><br />
                                <asp:Label ID="DateUpdatedTextBox" runat="server"></asp:Label>
                            </asp:Panel>  
                        </td>
                        <td style="vertical-align: top; width: 398px;">
                            <table>
                                <tr>
                                    <td valign="top">
                                        <asp:Label ID="lblTypeRadioButtonList" runat="server" AssociatedControlID="TypeRadioButtonList" Font-Bold="True" Text="Type (Required)"></asp:Label>
                                        <asp:LinkButton ID="NewTypeLinkButton" runat="server" CausesValidation="False" ToolTip="New Resource Type">New</asp:LinkButton>
                                    </td>
                                    <td valign="top" style="width: 211px">
                                        <asp:Label ID="lblOtherCheckBoxList" runat="server" AssociatedControlID="OtherCheckBoxList" Font-Bold="True" Text="Other"></asp:Label>&nbsp;
                                        <asp:LinkButton ID="NewOtherLinkButton" runat="server" CausesValidation="False" ToolTip="New Other Type">New</asp:LinkButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:RadioButtonList ID="TypeRadioButtonList" runat="server" Width="180px" CellPadding="0"
                                            CellSpacing="1" DataTextField="Description" DataValueField="Id">
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="TypeFVal" runat="server" ControlToValidate="TypeRadioButtonList"
                                            ErrorMessage="Type Must Be Selected" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </td>
                                    <td valign="top" style="width: 211px">
                                        <asp:CheckBoxList ID="OtherCheckBoxList" runat="server" DataTextField="Description"
                                            DataValueField="Id" Width="180px">
                                        </asp:CheckBoxList>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:Label ID="lblNewTypeTextBox" runat="server" AssociatedControlID="NewTypeTextBox" Text="Name"></asp:Label>
                                    </td>
                                    <td valign="top" style="width: 211px">
                                        <asp:Label ID="lblNewOtherTextBox" runat="server" Text="Name"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:TextBox ID="NewTypeTextBox" runat="server" MaxLength="100" Width="90%"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="TypeNameFVal" runat="server" ControlToValidate="NewTypeTextBox"
                                            ErrorMessage="Name is Required" Display="Dynamic" SetFocusOnError="True" ValidationGroup="ResourceType"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cvNewTypeTextBox" runat="server" ControlToValidate="NewTypeTextBox"
                                            Display="Dynamic" ErrorMessage="Duplicate resource type" SetFocusOnError="True" ValidationGroup="ResourceType"></asp:CustomValidator>
                                    </td>
                                    <td valign="top" style="width: 211px">
                                        <asp:TextBox ID="NewOtherTextBox" runat="server" MaxLength="100" Width="90%"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="OtherFVal" runat="server" ControlToValidate="NewOtherTextBox"
                                            ErrorMessage="Name is Required" Display="Dynamic" SetFocusOnError="True" ValidationGroup="OtherType" ></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cvNewOtherTextBox" runat="server" ControlToValidate="NewOtherTextBox"
                                            Display="Dynamic" ErrorMessage="Duplicate other type" SetFocusOnError="True" ValidationGroup="OtherType"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:CheckBox ID="ASCheckBox" runat="server" Text="Always Show" />
                                    </td>
                                    <td valign="top" style="width: 211px">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:Button ID="TypeButton" runat="server" Text="Save" ValidationGroup="ResourceType" Width="64px" />&nbsp;
                                        <asp:Button ID="CancelNewResourceBtn" runat="server" CausesValidation="False" Text="Cancel" Width="64px" />
                                    </td>
                                    <td valign="top" style="width: 211px">
                                        <asp:Button ID="OtherButton" runat="server" Text="Save" ValidationGroup="OtherType" Width="64px" />&nbsp;
                                        <asp:Button ID="CancelOtherButton" runat="server" CausesValidation="False" Text="Cancel" Width="64px" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Panel ID="ThePanel" runat="server">
                                <div id="TeaserEditorDiv">
                                    <FTB:FreeTextBox ID="Teaser" runat="server" ButtonSet="Office2003" ImageGalleryPath="~/img/Gallery"
                                        SupportFolder="~/js/FreeTextBox/" ToolbarLayout="ParagraphMenu,FontFacesMenu,FontSizesMenu,FontForeColorsMenu|Bold,Italic,Underline,Strikethrough;Superscript,Subscript,RemoveFormat|JustifyLeft,JustifyRight,JustifyCenter,JustifyFull;BulletedList,NumberedList,Indent,Outdent;CreateLink,Unlink,InsertImage,InsertImageFromGallery,InsertRule|Cut,Copy,Paste;Undo,Redo,Print,"
                                        AllowHtmlMode="False" AssemblyResourceHandlerPath="" AutoConfigure="" AutoGenerateToolbarsFromString="True"
                                        AutoHideToolbar="True" AutoParseStyles="True" BackColor="158, 190, 245" BaseUrl=""
                                        BreakMode="Paragraph" ButtonDownImage="False" ButtonFileExtention="gif" ButtonFolder="Images"
                                        ButtonHeight="20" ButtonImagesLocation="InternalResource" ButtonOverImage="False"
                                        ButtonPath="" ButtonWidth="21" ClientSideTextChanged="" ConvertHtmlSymbolsToHtmlCodes="False"
                                        DesignModeBodyTagCssClass="" DesignModeCss="" DisableIEBackButton="False" DownLevelCols="50"
                                        DownLevelMessage="" DownLevelMode="TextArea" DownLevelRows="10" EditorBorderColorDark="Gray"
                                        EditorBorderColorLight="Gray" EnableHtmlMode="True" EnableSsl="False" EnableToolbars="True"
                                        Focus="False" FormatHtmlTagsToXhtml="True" GutterBackColor="129, 169, 226" GutterBorderColorDark="Gray"
                                        GutterBorderColorLight="White" Height="200px" HelperFilesParameters="" HelperFilesPath=""
                                        HtmlModeCss="" HtmlModeDefaultsToMonoSpaceFont="True" ImageGalleryUrl="ftb.imagegallery.aspx?rif={0}&cif={0}"
                                        InstallationErrorMessage="InlineMessage" JavaScriptLocation="InternalResource"
                                        Language="en-US" PasteMode="Default" ReadOnly="False" RemoveScriptNameFromBookmarks="True"
                                        RemoveServerNameFromUrls="True" RenderMode="NotSet" ScriptMode="External" ShowTagPath="False"
                                        SslUrl="/." StartMode="DesignMode" StripAllScripting="False" TabIndex="-1" TabMode="InsertSpaces"
                                        Text="" TextDirection="LeftToRight" ToolbarBackColor="Gainsboro" ToolbarBackgroundImage="True"
                                        ToolbarImagesLocation="InternalResource" ToolbarStyleConfiguration="OfficeXP"
                                        UpdateToolbar="True" UseToolbarBackGroundImage="True" Width="722px" />
                                </div>
                            </asp:Panel>
                            <asp:RequiredFieldValidator ID="TeaserRequired" runat="server" ErrorMessage="Abstract is Required"
                                ControlToValidate="Teaser" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator></td>
                    </tr>
                </table>
            </asp:View>
            
            <!-- 
            Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
                                            1) Modified TreeView to show checkboxes on all nodes.
                                            2) Added panel for scrollbar capability.
            -->
            <asp:View ID="ViewMapQuestions" runat="server">
                <table id="TableMapQuestions" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 3px;">&nbsp;</td>
                        <td style="width: 732px">
                            <table id="Table2" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 72px; height: 20px;">&nbsp;<asp:Label ID="TagsTreeViewLabel" runat="server" AssociatedControlID="TagsTreeView" Font-Bold="True"
                                        Text="Questions"></asp:Label></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center; height: 20px;">
                                        <asp:ImageButton ID="ImageButtonCollapseQuestions" runat="server" ImageUrl="~/img/ExpandCollapse.gif" ToolTip="Collapse All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center; height: 20px;">
                                        <asp:ImageButton ID="ImageButtonExpandQuestions" runat="server" ImageUrl="~/img/ExpandExpand.gif" ToolTip="Expand All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center; height: 20px;">
                                        <asp:ImageButton ID="ImageButtonUncheckQuestions" runat="server" ImageUrl="~/img/TreeNodeUnchecked.gif" ToolTip="Deselect All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center; height: 20px;">
                                        <asp:ImageButton ID="ImageButtonCheckQuestions" runat="server" CausesValidation="False"
                                            Enabled="False" ImageAlign="Middle" ImageUrl="~/img/TreeNodeChecked.gif" ToolTip="Select All" Height="16" Width="16" /></td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 3px;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 3px;">&nbsp;</td>
                        <td style="width: 732px">                        
                            <asp:Panel ID="PanelMapQuestions" runat="server" Height="400px" ScrollBars="Auto" Width="700px" BackColor="White" BorderStyle="Inset">
                                <asp:TreeView ID="TagsTreeView" runat="server"
                                    Width="96%" NodeWrap="False" PopulateNodesFromClient="False"
                                    ShowLines="True" NodeIndent="10" LeafNodeStyle-Width="620px" EnableClientScript="False">
                                    <SelectedNodeStyle BackColor="Yellow" />
                                    <LeafNodeStyle Width="620px" />
                                </asp:TreeView>
                            </asp:Panel>
                        </td>
                        <td style="width: 3px;">&nbsp;</td>
                    </tr>
                </table>
            </asp:View>
            
            <!-- 
            Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
                                            Added new TreeView section for mapping the resource to 
                                            specified client organization units.
            -->
            <asp:View ID="ViewMapClients" runat="server">
                <table id="TableMapClients" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 3px;">&nbsp;</td>
                        <td style="width: 718px">
                            <table id="TableMapClientsToolbar" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 72px;">&nbsp;<asp:Label ID="LabelClients" runat="server" AssociatedControlID="TagsTreeView" Font-Bold="True"
                                        Text="Clients *"></asp:Label></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center;">
                                        <asp:ImageButton ID="ImageButtonCollapseClients" runat="server" ImageUrl="~/img/ExpandCollapse.gif" ToolTip="Collapse All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center;">
                                        <asp:ImageButton ID="ImageButtonExpandClients" runat="server" ImageUrl="~/img/ExpandExpand.gif" ToolTip="Expand All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center;">
                                        <asp:ImageButton ID="ImageButtonUncheckClients" runat="server" ImageUrl="~/img/TreeNodeUnchecked.gif" ToolTip="Deselect All" Height="16" Width="16" Enabled="False" CausesValidation="False" /></td>
                                    <td style="border-right: thin outset; border-top: thin outset; vertical-align: middle; border-left: thin outset; border-bottom: thin outset; text-align: center;">
                                        <asp:ImageButton ID="ImageButtonCheckClients" runat="server" CausesValidation="False"
                                            Enabled="False" ImageAlign="Middle" ImageUrl="~/img/TreeNodeChecked.gif" ToolTip="Select All" Height="16" Width="16" /></td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 3px;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 3px;">&nbsp;</td>
                        <td style="width: 718px">
                            <asp:Panel ID="PanelMapClients" runat="server" Height="400px" ScrollBars="Auto" Width="700px" BackColor="White" BorderStyle="Inset">
                                <asp:TreeView ID="TreeViewOrgUnits" runat="server"
                                    Width="96%" NodeWrap="True" PopulateNodesFromClient="False"
                                    ShowLines="True" LeafNodeStyle-Width="620px" EnableClientScript="False">
                                    <SelectedNodeStyle BackColor="Yellow" />
                                    <LeafNodeStyle Width="620px" />
                                </asp:TreeView>
                            </asp:Panel>
                            <asp:Label ID="LabelNote" runat="server" AssociatedControlID="TagsTreeView"
                                Text="* OrgUnits are shown with icons; Groups are shown with checkboxes."></asp:Label>
                        </td>
                        <td style="width: 3px;">&nbsp;</td>
                    </tr>
                </table>
            </asp:View>
        </asp:MultiView>
        <br />
    </div>
    
    <!-- Footer Section -->
    <div style="float: left; width: 730px; font-size: 10px; background-color: window;">
        <table id="FormTable" cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <td valign="top" style="width: 330px">
                    <asp:Label ID="lblFileUpload" runat="server" Text="Upload File" Font-Bold="True" Height="16px"></asp:Label>
                </td>
                <td valign="top" style="width: 90px">
                    <asp:Label ID="lblUploadedFrom" runat="server" Text="Uploaded from" Font-Bold="True"></asp:Label>
                </td>
                <td valign="top" style="width: 280px">
                    <asp:Label ID="lblOriginalFile" runat="server" BorderStyle="None"></asp:Label>
                </td>
                <td valign="top">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:FileUpload ID="FileUpload" runat="server" Width="318px" Height="20px" /><br />
                    <asp:RequiredFieldValidator ID="FileUploadRequired" runat="server" ErrorMessage="Upload file required"
                        ControlToValidate="FileUpload" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
                <td valign="middle">
                    <asp:Label ID="lblSavedAs" runat="server" Text="Saved as" Font-Bold="True"></asp:Label></td>
                <td valign="middle">
                    <asp:Label ID="lblCurrentFile" runat="server" BorderStyle="None"></asp:Label>
                </td>
                <td valign="middle" align="center">
                     <asp:HyperLink ID="ViewCurrentFile" runat="server" ToolTip="View Current File" Target="_self" Width="26px" >View</asp:HyperLink>
                </td>
           </tr>
           <tr>
                <td valign="top">
                    <asp:CheckBox ID="EmailNotify" runat="server" Text="Send Email Notification" />
                </td>
                <td colspan="3">&nbsp;</td>
           </tr>
        </table>
        <!-- 
        Rick Christenham (09/06/2007):  NRC eToolkit Enhancement II:
                                        1) Modified layout and size for aesthetic reasons.
                                        2) Modified "Cancel" button text to read "Previous Screen".
        -->
        <table id="TableRecord" cellspacing="5" cellpadding="0" width="100%">
            <tr>
                <td style="width: 329px; height: 24px;" align="center" valign="middle">
                </td>
                <td  style="width: 52px; height: 24px; text-align: left;" align="center" valign="middle">
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure?');" Width="64px"></asp:Button>
                </td>
                <td style="width: 52px" valign="middle">
                    <asp:Button ID="btnSave" runat="server" Text="Save" Width="64px"></asp:Button>
                </td>
                <td style="width: 90px" valign="middle">
                    <asp:Button ID="btnCancel" runat="server" CausesValidation="False" Text="Previous Screen" Width="114px" />
                </td>
                <td valign="middle">
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
</asp:Content>