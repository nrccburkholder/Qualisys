<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SideNav.ascx.vb" Inherits="Nrc.MySolutions.eToolKit_UserControls_SideNav" %>
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>

<div class="InputField">

    <nrc:MenuBox ID="SelectionTreeMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" LeftImageUrl="~/img/MenuBox/left.gif" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" ContentCssClass="MenuBox" MenuItemCssClass="MenuBoxItem" Width="165px" style="margin-bottom: 10px">
        <nrc:MenuBoxTitle ID="SelectionTreeTitle" runat="server" Text="Selection Tree" style="float: left;" />
        <asp:Image ID="SelectionTreeImage" runat="server" style="cursor: pointer; float: right; clear:right;" />
        <ajaxToolkit:CollapsiblePanelExtender ID="SelectionTreeMenuExtender" runat="server"
            TargetControlID="SelectionTreeMenuBody" CollapseControlID="SelectionTreeImage" ExpandControlID="SelectionTreeImage" 
            ImageControlID="SelectionTreeImage" CollapsedImage="~/img/MenuBox/collapsed.png" ExpandedImage="~/img/MenuBox/expanded.png" />
        <asp:Panel ID="SelectionTreeMenuBody" runat="server" style="clear:both;" >
            <asp:Literal ID="ltlSelectionTreeMenu" runat="server"></asp:Literal>
        </asp:Panel>
    </nrc:MenuBox>

    <nrc:MenuBox ID="ToolBoxMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" LeftImageUrl="~/img/MenuBox/left.gif" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" ContentCssClass="MenuBox" MenuItemCssClass="MenuBoxItem" Width="165px">
        <nrc:MenuBoxTitle ID="ToolBoxTitle" runat="server" Text="Toolbox" style="float: left;" />
        <asp:Image ID="ToolBoxImage" runat="server" style="cursor: pointer; float: right; clear:right;" />
        <ajaxToolkit:CollapsiblePanelExtender ID="ToolBoxMenuExtender" runat="server"
            TargetControlID="ToolBoxMenuBody" CollapseControlID="ToolBoxImage" ExpandControlID="ToolBoxImage" 
            ImageControlID="ToolBoxImage" CollapsedImage="~/img/MenuBox/collapsed.png" ExpandedImage="~/img/MenuBox/expanded.png" />
        <asp:Panel ID="ToolBoxMenuBody" runat="server" style="clear:both;" >
            <nrc:MenuBoxLink ID="QuestionImportanceLink" runat="server" Text="Question Importance" NavigateUrl="~/eToolKit/QuestionContent.aspx?aux=qi" />
            <nrc:MenuBoxLink ID="QuickCheckLink" runat="server" Text="Quick Check" NavigateUrl="~/eToolKit/QuestionContent.aspx?aux=qc" />
            <nrc:MenuBoxLink ID="RecommendationsLink" runat="server" Text="What is recommended?" NavigateUrl="~/eToolKit/QuestionContent.aspx?aux=wr" />
            <nrc:MenuBoxLink ID="ResourcesLink" runat="server" Text="Resources" NavigateUrl="~/eToolKit/QuestionContent.aspx?aux=r" />
            <nrc:MenuBoxLink ID="QuestionResultsLink" runat="server" Text="Question Results" NavigateUrl="" />
            <nrc:MenuBoxLink ID="CommentsLink" runat="server" Text="Survey Comments" NavigateUrl="~/eToolKit/eCommentsBridge.ashx" OpenInNewWindow="true" />
            <nrc:MenuBoxLink ID="ResearchInquiry" runat="server" Text="Research Inquiry" NavigateUrl="" />
            <nrc:MenuBoxLink ID="LnForumsLink" runat="server" Text="Learning Network Forums" NavigateUrl="" />
            <nrc:MenuBoxLink ID="LnArchiveLink" runat="server" Text="Learning Network Archive" NavigateUrl="" />
            <nrc:MenuBoxLink ID="PatientEyesLink" runat="server" Text="Through the Patient's Eyes Video Clip" NavigateUrl="" />
        </asp:Panel>
    </nrc:MenuBox>

    <nrc:MenuBox ID="MemberResourcesMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" ContentCssClass="MenuBox" LeftImageUrl="~/img/MenuBox/left.gif" MenuItemCssClass="MenuBoxItem" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" Width="165px">
        <nrc:MenuBoxTitle ID="MemberResourcesTitle" runat="server" Text="Member Resources" style="float: left;" />
        <asp:Image ID="MemberResourcesImage" runat="server" Style="cursor: pointer; float: right; clear:right;" />
        <ajaxToolkit:CollapsiblePanelExtender ID="MemberResourcesExtender" runat="server"
            TargetControlID="MemberResourcesBody" CollapseControlID="MemberResourcesImage" ExpandControlID="MemberResourcesImage" 
            ImageControlID="MemberResourcesImage" CollapsedImage="~/img/MenuBox/collapsed.png" ExpandedImage="~/img/MenuBox/expanded.png" />
        <asp:Panel ID="MemberResourcesBody" runat="server" style="clear:both;" >
            <asp:Repeater ID="MemberResourcesList" runat="server">
                <ItemTemplate>
                    <nrc:MenuBoxLink ID="MemberResourceLink" runat="server" Text='<%# Eval("Title") %>' NavigateUrl='<%# ResourceManager.GetMemberResourcePath(Me, Eval("id")) %>' OpenInNewWindow="true" ToolTip='<%# NormalizeSpace(Eval("AbstractPlainText")) %>' Enabled='<%# CurrentUser.HasEToolkitAccess %>' />
                </ItemTemplate>
            </asp:Repeater>
            <nrc:MenuBoxLink ID="MemberResourcesMoreLink" runat="server" Text="More" NavigateUrl="~/eToolKit/ResourceSearch.aspx" CssClass="More" Style="text-align: right" />
        </asp:Panel>
    </nrc:MenuBox>

    <nrc:MenuBox ID="ActionPlansMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" ContentCssClass="MenuBox" LeftImageUrl="~/img/MenuBox/left.gif" MenuItemCssClass="MenuBoxItem" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" Width="165px">
        <nrc:MenuBoxTitle ID="ActionPlansTitle" runat="server" Text="Action Plans" style="float: left;"/>
        <asp:Image ID="ActionPlansImage" runat="server" style="cursor: pointer; float: right; clear:right;" />
        <ajaxToolkit:CollapsiblePanelExtender ID="ActionPlansMenuExtender" runat="server" 
            TargetControlID="ActionPlansBody" CollapseControlID="ActionPlansImage" ExpandControlID="ActionPlansImage" 
            ImageControlID="ActionPlansImage" CollapsedImage="~/img/MenuBox/collapsed.png" ExpandedImage="~/img/MenuBox/expanded.png" />
        <asp:Panel ID="ActionPlansBody" runat="server" Width="144px" Height="100%" style="overflow:hidden; clear:both;" >
            <!-- 
            Rick Christenham (09/05/2007):  NRC eToolkit Enhancement II:
                                            Modified text displayed in the "Action Plans" box when no action
                                            plans are available from "No Action Plans Yet Available" to
                                            "No Action Plans Available".
            -->
            <asp:Label ID="ActionPlansNotAvailable" runat="server" Text="Label">No Action Plans Available</asp:Label>
            <asp:TreeView ID="ActionPlansTree" runat="server" ExpandDepth="0" >
            </asp:TreeView>
        </asp:Panel>
    </nrc:MenuBox>

    <nrc:MenuBox ID="SupportMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" LeftImageUrl="~/img/MenuBox/left.gif" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" ContentCssClass="MenuBox" MenuItemCssClass="MenuBoxItem" Width="165px">
        <nrc:MenuBoxTitle ID="SupportTitle" runat="server" Text="Support" style="float: left;" />
        <asp:Image ID="SupportImage" runat="server" style="cursor: pointer; float: right; clear:right;" />
        <ajaxToolkit:CollapsiblePanelExtender ID="SupportMenuExtender" runat="server"
            TargetControlID="SupportMenuBody" CollapseControlID="SupportImage" ExpandControlID="SupportImage" 
            ImageControlID="SupportImage" CollapsedImage="~/img/MenuBox/collapsed.png" ExpandedImage="~/img/MenuBox/expanded.png" />
        <asp:Panel ID="SupportMenuBody" runat="server" style="clear:both;" >
            <nrc:MenuBoxLink ID="PreferencesLink" runat="server" Text="Preferences" NavigateUrl="~/eToolKit/Preferences.aspx" />
            <nrc:MenuBoxLink ID="HelpLink" runat="server" Text="Help Index" NavigateUrl="~/eToolKit/Help/Default.aspx" />
            <nrc:MenuBoxLink ID="ContactLink" runat="server" Text="Contact Us" NavigateUrl="~/eToolKit/ContactUs.aspx" />
            <nrc:MenuBoxLink ID="SiteRequirementsLink" runat="server" Text="Site Requirements" NavigateUrl="~/eToolKit/Help/SiteRequirements.aspx" />
            <nrc:MenuBoxLink ID="ControlChartLink" runat="server" Text="Control Chart Guide" NavigateUrl="~/eToolKit/Help/ControlChartTutorial.doc" OpenInNewWindow="true" Visible="false" />
        </asp:Panel>
    </nrc:MenuBox>

</div>
