<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="QuestionManager.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_QuestionManager" ValidateRequest="false" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<script type="text/javascript">
    function ChangeCheckBoxState(id, checkState)
    {
        var cb = document.getElementById(id);
        if (cb != null && cb.disabled == false){
            cb.checked = checkState;
        }
    }

    function ChangeAllCheckBoxStates(arrayList, checkState)
    {
        // Toggles through all of the checkboxes defined in the CheckBoxIDs array
        // and updates their value to the checkState input parameter
        if (arrayList != null)
        {
            for (var i = 0; i < arrayList.length; i++)
                ChangeCheckBoxState(arrayList[i], checkState);
        }
    }
    function InitModalBackground(){
        var modalBack = GetDocElement("ModalBackground");      
        modalBack.style.height = document.body.clientHeight + 25 + 'px';
        modalBack.style.width = document.body.clientWidth + 'px';
        modalBack.style.top = '-106px';
        modalBack.style.left = '-5px';    
    }
    function ShowAddThemeDialog(){
        InitModalBackground();
        ToggleVisible('ModalBackground');
        ToggleVisible('ModelTreeDiv');
    }
    function ShowRelateQuestionDialog(){
        var relateTxtBox = GetDocElement("ctl00_MainContentPlaceHolder_RelateQuestionId");
        if (relateTxtBox.value != null && relateTxtBox.value != ''){
            if(parseInt(relateTxtBox.value)== relateTxtBox.value-0){
                InitModalBackground();
                ToggleVisible('ModalBackground');
                ToggleVisible('RelateQuestionDiv');
                var useCurrentDiv = GetDocElement("UseRelatedDiv");

                var childElements = useCurrentDiv.childNodes;
                for (var i=0; i < childElements.length; i++){
                    if (childElements[i].tagName == "LABEL"){
                        childElements[i].innerHTML = "Use content from Question " + relateTxtBox.value;
                    }
                }            
            }
            else {
                alert('You must enter a valid question ID.');
            }            
        }
        else {
            alert('You must enter a Question ID to relate');
        }        
    }
</script>
<div style="float:left;"><uc3:BreadCrumbs id="BreadCrumbs1" runat="server" /></div>
<div style="float:right; font-size: 10px;"><asp:Panel ID="Panel1" runat="server" DefaultButton="LoadQuestionButton">Question ID:<asp:TextBox ID="QuestionId" runat="server" Width="75px" Font-Size="10px"></asp:TextBox><asp:Button ID="LoadQuestionButton" runat="server" Text="Load" Font-Size="10px" /></asp:Panel></div>
<div style="clear:both; font-size: 10px;">
    <hr />
    <asp:Label ID="PageTitle" runat="server" CssClass="PageTitle">Please select a question...</asp:Label><asp:Label ID="QuestionTextLabel" runat="server"></asp:Label>
    <hr />
</div>
<div id="QuestionEditorDiv" runat="server" visible="false" style="clear:both;width:730px; font-size: 10px;">
    <h5>Theme Assignments</h5>
    <div style="float:left;"><asp:Button ID="UnassignButton" runat="server" Text="Unassign" Font-Size="10px" /></div>
    <div style="float:right;"><asp:Button ID="AddTheme" runat="server" Text="Add Theme" Font-Size="10px" OnClientClick="ShowAddThemeDialog(); return false;" /></div>
    <asp:GridView ID="ThemeGrid" runat="server" AutoGenerateColumns="False" CellPadding="3" AllowSorting="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" Width="100%" DataKeyNames="ThemeId">
        <FooterStyle BackColor="White" ForeColor="#000066" />
        <Columns>
            <asp:TemplateField>
                <HeaderTemplate>
                    <input type="checkbox" onclick="ChangeAllCheckBoxStates(ThemeCheckBoxIDs,this.checked);" />
                </HeaderTemplate>
                <ItemTemplate>
                    <div style="text-align:center;"><asp:CheckBox ID="SelectThemeCheckBox" runat="server" Enabled='<%# IsThemeCheckable(Eval("Status")) %>' /></div>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ServiceTypeName" HeaderText="Service Type" ReadOnly="True" />
            <asp:BoundField DataField="ViewName" HeaderText="View" ReadOnly="True" />
            <asp:BoundField DataField="ThemeName" HeaderText="Theme" ReadOnly="True" />
            <asp:BoundField DataField="StatusLabel" HeaderText="Status" ReadOnly="True" />
        </Columns>
        <RowStyle ForeColor="#000066" />
        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
        <HeaderStyle BackColor="#636563" Font-Bold="True" ForeColor="White" CssClass="ModelManagerGridHeader" />
        <EmptyDataRowStyle BorderStyle="None" />
        <EmptyDataTemplate>
            <div style="padding: 30px; text-align: center; background-color: #F9F9F9;">This question is not mapped to any ToolKit themes.</div>
        </EmptyDataTemplate>
    </asp:GridView> 
    <asp:Label ID="ThemeGridErrorLabel" runat="server" ForeColor="Red"></asp:Label>
    <h5>Related Questions</h5>
    <div style="float:left;"><asp:Button ID="UnrelateButton" runat="server" Text="Unrelate" Font-Size="10px" /></div>
    <div style="float:right;"><asp:Panel ID="Panel2" runat="server" DefaultButton="RelateButton">Question ID:<asp:TextBox ID="RelateQuestionId" runat="server" Width="75px" Font-Size="10px"></asp:TextBox><asp:Button ID="RelateButton" runat="server" Text="Relate" Font-Size="10px" OnClientClick="ShowRelateQuestionDialog();return false;" /></asp:Panel></div>
    <asp:GridView ID="RelatedQuestionsGrid" runat="server" AutoGenerateColumns="False" CellPadding="3" AllowSorting="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" Width="100%" DataKeyNames="QstnCore">
        <FooterStyle BackColor="White" ForeColor="#000066" />
        <Columns>
            <asp:TemplateField>
                <HeaderTemplate>
                    <input type="checkbox" onclick="ChangeAllCheckBoxStates(QuestionsCheckBoxIDs,this.checked);" />
                </HeaderTemplate>
                <ItemTemplate>
                    <div style="text-align:center;"><asp:CheckBox ID="SelectQuestionCheckBox" runat="server" /></div>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="QstnCore" HeaderText="ID" ReadOnly="True" />
            <asp:TemplateField HeaderText="Question" >
                <ItemTemplate>
                    <a href="QuestionManager.aspx?QuestionID=<%# Eval("QstnCore") %>">
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("QuestionText") %>'></asp:Label>
                    </a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ServiceType" HeaderText="Service Type" ReadOnly="True" />
        </Columns>
        <RowStyle ForeColor="#000066" />
        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
        <HeaderStyle BackColor="#636563" Font-Bold="True" ForeColor="White" CssClass="ModelManagerGridHeader" />
        <EmptyDataRowStyle BorderStyle="None" />
        <EmptyDataTemplate>
            <div style="padding: 30px; text-align: center; background-color: #F9F9F9;">There are no related questions.</div>
        </EmptyDataTemplate>        
    </asp:GridView>
    <asp:Label ID="RelatedGridErrorLabel" runat="server" Text="" ForeColor="Red"></asp:Label>
    <h5>Question Content</h5>    
</div>
<div id="ContentEditorDiv" runat="server" visible="false">
    <div class="TabMenuContainer">
        <asp:Menu ID="ContentTypeMenu" runat="server" Orientation="Horizontal">
            <Items>
                <asp:MenuItem Text="Importance" Value="Importance" Selected="true" />
                <asp:MenuItem Text="Quick Check" Value="QuickCheck" />
                <asp:MenuItem Text="Recommendations" Value="Recommendations" />
                <asp:MenuItem Text="Resources" Value="Resources" />
            </Items>
            <StaticMenuItemStyle CssClass="TabMenuItem" />
            <StaticSelectedStyle CssClass="TabMenuItemSelected" />
            <StaticHoverStyle CssClass="TabMenuItemHover" />
        </asp:Menu>
    </div>
    <br />
    <div style="text-align:right;"><asp:Button ID="EditButton" runat="server" Text="Edit" /><asp:Button ID="PreviewButton" runat="server" Text="Preview" Enabled="false" /><asp:Button ID="PublishButton" runat="server" Text="Publish" Enabled="false" /><asp:Button ID="CancelContentButton" runat="server" Text="Cancel" Enabled="false" /></div>
    <div id="PreviewDiv" runat="server">
        <div style="float:left;width:165px;margin-right:5px;"><img src="../../img/LeftNavPreview.gif" alt=""/></div>
        <div style="float:left;width:560px;">
            <uc1:PageLogo ID="PageLogo2" runat="server" />
            <div id="PreviewContents">
                <div id="QuestionContentDiv" style="float:left;width:325px;">
                <asp:image id="NewContentImage" runat="server" Width="32px" Height="36px" AlternateText="Indicates new or updated content within last 90 days." ImageUrl="~/img/NewContent.gif" Visible="False"></asp:image><strong>Question Text:&nbsp;&nbsp;</strong>
                <asp:Label ID="QuestionTextPreviewLabel" runat="server" Text=""></asp:Label>
                <p style="font-weight:bold;"><asp:Label ID="ContentTitle" runat="server" Text=""></asp:Label></p>
                <p><asp:Literal ID="ContentLiteral" runat="server"></asp:Literal></p>
                </div>
                <div id="QuestionChartDiv" style="float:right;">
                    <div id="BackNavDiv"><asp:Image runat="server" ID="BackImage" ImageUrl="~/img/BackNav.gif" ImageAlign="AbsMiddle" /><a href="#" onclick="return false;" onkeypress="return false;">Return to Question Results</a></div>
                    <div runat="server" id="TrendLinkDiv"><asp:Image runat="server" ID="TrendChartImage" ImageUrl="~/img/TrendChart.gif" ImageAlign="AbsMiddle" /><a href="#" onclick="return false;" onkeypress="return false;">View Trend Chart</a></div>
                    <div runat="server" id="ControlLinkDiv"><asp:Image runat="server" ID="ControlChartImage" ImageUrl="~/img/TrendChart.gif" ImageAlign="AbsMiddle" /><a href="#" onclick="return false;" onkeypress="return false;">View Control Chart</a></div>
                    <img src="../../img/ScoreChartPreview.gif" alt=""/>
                </div>
            
            </div>
        </div>
    </div>
    <div id="EditDiv" runat="server" visible="false">
        <div style="text-align:right;"><asp:CheckBox ID="IsNewContent" runat="server" Text="New/Updated Content" /></div>
        <FTB:FreeTextBox id="ContentEditor" runat="server" ButtonSet="Office2003" ImageGalleryPath="~/img/Gallery" SupportFolder="~/js/FreeTextBox/" ToolbarLayout="ParagraphMenu,FontFacesMenu,FontSizesMenu,FontForeColorsMenu|Bold,Italic,Underline,Strikethrough;Superscript,Subscript,RemoveFormat|JustifyLeft,JustifyRight,JustifyCenter,JustifyFull;BulletedList,NumberedList,Indent,Outdent;CreateLink,Unlink,InsertImageFromGallery,InsertRule|Cut,Copy,Paste;Undo,Redo,Print," AllowHtmlMode="False" AssemblyResourceHandlerPath="" AutoConfigure="" AutoGenerateToolbarsFromString="True" AutoHideToolbar="True" AutoParseStyles="True" BackColor="158, 190, 245" BaseUrl="" BreakMode="Paragraph" ButtonDownImage="False" ButtonFileExtention="gif" ButtonFolder="Images" ButtonHeight="20" ButtonImagesLocation="InternalResource" ButtonOverImage="False" ButtonPath="" ButtonWidth="21" ClientSideTextChanged="" ConvertHtmlSymbolsToHtmlCodes="False" DesignModeBodyTagCssClass="" DesignModeCss="" DisableIEBackButton="False" DownLevelCols="50" DownLevelMessage="" DownLevelMode="TextArea" DownLevelRows="10" EditorBorderColorDark="Gray" EditorBorderColorLight="Gray" EnableHtmlMode="True" EnableSsl="False" EnableToolbars="True" Focus="False" FormatHtmlTagsToXhtml="True" GutterBackColor="129, 169, 226" GutterBorderColorDark="Gray" GutterBorderColorLight="White" Height="350px" HelperFilesParameters="" HelperFilesPath="" HtmlModeCss="" HtmlModeDefaultsToMonoSpaceFont="True" ImageGalleryUrl="ftb.imagegallery.aspx?rif={0}&cif={0}" InstallationErrorMessage="InlineMessage" JavaScriptLocation="InternalResource" Language="en-US" PasteMode="Default" ReadOnly="False" RemoveScriptNameFromBookmarks="True" RemoveServerNameFromUrls="True" RenderMode="NotSet" ScriptMode="External" ShowTagPath="False" SslUrl="/." StartMode="DesignMode" StripAllScripting="False" TabIndex="-1" TabMode="InsertSpaces" Text="" TextDirection="LeftToRight" ToolbarBackColor="Transparent" ToolbarBackgroundImage="True" ToolbarImagesLocation="InternalResource" ToolbarStyleConfiguration="OfficeXP" UpdateToolbar="True" UseToolbarBackGroundImage="True" Width="734" />
    </div>
</div>
<div id="ModalBackground" style="display: none; background-color:#E7E7E7; filter:alpha(opacity=50); opacity: 0.5; position: absolute; top: 0px; left: 0px; height: 100%; width: 100%;"></div>
<div id="ModelTreeDiv" style="display: none; border: Solid 2px Gray; width: 300px; height: 375px; position: absolute; top: 100px; left: 220px; background-color: #E7E7E7;">
    <div style="overflow: auto; border-bottom: Solid 2px Gray; width:300px; height: 340px;">
        <asp:TreeView ID="ModelTreeView" runat="server" ExpandDepth="0" NodeIndent="10" Target="_self" ImageSet="Simple">
            <SelectedNodeStyle CssClass="ModelManagerNodeSelected" />
            <NodeStyle CssClass="ModelManagerNode" />
        </asp:TreeView>
    </div>
    <div style="position: absolute; right: 10px; bottom: 5px;">
        <asp:Button ID="SelectThemeButton" runat="server" Text="OK" Width="60px" OnClientClick="ToggleVisible('ModelTreeDiv');ToggleVisible('ModalBackground');" />
        <asp:Button ID="CancelButton" runat="server" Text="Cancel" Width="60px" OnClientClick="ToggleVisible('ModelTreeDiv');ToggleVisible('ModalBackground');return false;" />
    </div>
</div>
<div id="RelateQuestionDiv" style="display: none; border: Solid 2px Gray; width: 400px; height: 175px; position: absolute; top: 300px; left: 200px; background-color: #E7E7E7; font-size: 10px;">
    <div style="padding:25px;">
        Relating these questions will cause them to share content.  Please indicate which content should be used by all the related questions.
        <br /><br />
        <div id="UseCurrentDiv"><asp:RadioButton ID="UseCurrentContentRadioButton" runat="server" GroupName="RelateQuestionOption" Text="Keep content from current question" Checked="true" /></div>
        <div id="UseRelatedDiv"><asp:RadioButton ID="UseRelatedContentRadioButton" runat="server" GroupName="RelateQuestionOption" Text="Overwrite current content with related question's content" /></div>
    </div>        
    <div style="position: absolute; right: 10px; bottom: 5px;">
        <asp:Button ID="RelateOkButton" runat="server" Text="OK" Width="60px" OnClientClick="ToggleVisible('RelateQuestionDiv');ToggleVisible('ModalBackground');" />
        <asp:Button ID="RelateCancelButton" runat="server" Text="Cancel" Width="60px" OnClientClick="ToggleVisible('RelateQuestionDiv');ToggleVisible('ModalBackground');return false;" />
    </div>
</div>
</asp:Content>
