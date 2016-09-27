<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Upload.aspx.vb" Inherits="NRC.DataLoader.Upload" 
  MasterPageFile = "~/MasterPage.Master" EnableEventValidation = "false"%>

<%@ Register Assembly="DevExpress.Web.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxTabControl" TagPrefix="dxtc" %>
<%@ Register Assembly="DevExpress.Web.ASPxGridView.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dxwgv" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxGrid.v6.3, Version=6.3.2.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.Web.ASPxGrid" TagPrefix="dxwg" %>
<%@ Register Assembly="DevExpress.Web.ASPxDataControls.v6.3, Version=6.3.2.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.Web.ASPxDataControls" TagPrefix="dxwdc" %>
<%@ Register Assembly="DevExpress.Web.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxClasses.ASPxDataWebControl" TagPrefix="dxwda" %>
<%@ Register Assembly="DevExpress.Data.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Data" TagPrefix="dxwdf" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering = "true" >
    </asp:ScriptManager>
    
    <asp:UpdatePanel runat = "server" UpdateMode = "conditional" ID = "fullPagePanel">
    <triggers>
    <asp:AsyncPostBackTrigger ControlID = "ASPxTabControl1"/>
    </triggers>
    <ContentTemplate>
    
        <dxtc:ASPxTabControl ID="ASPxTabControl1" runat="server" AutoPostBack = "true" 
        OnActiveTabChanged = "ChangeTabs" 
        ActiveTabIndex = "0" CssFilePath="~/App_Themes/Blue/{0}/styles.css" width = "760"
        CssPostfix="Blue" ImageFolder="~/App_Themes/Blue/{0}/" >
            <Tabs>
                <dxtc:Tab Text="Upload File" ToolTip="Upload File" >
                </dxtc:Tab>
                <dxtc:Tab Text="Upload History" ToolTip="Upload History">
                </dxtc:Tab>
            </Tabs>    
            <ContentStyle>
                <BorderBottom BorderWidth="0px" BorderColor = "black"/>
                <BorderLeft BorderWidth="0px" BorderColor = "black"/>
                <BorderRight BorderWidth="0px" BorderColor = "black"/>
                <BorderTop BorderWidth="1px" BorderColor = "black"/>
            </ContentStyle>
            <Paddings PaddingLeft="0px" PaddingRight="0px" />
            <TabStyle>
                <BorderLeft BorderWidth="1px" BorderColor = "black"/>
                <BorderRight BorderWidth="1px" BorderColor = "black"/>
                <BorderTop BorderWidth="1px" BorderColor = "black"/>
            </TabStyle>
        </dxtc:ASPxTabControl>
        
            <div runat = "server" id = "MaindisplayDiv" >
                        <table style="width: 760px"  cellpadding='0' cellspacing='6'>
                            <tr>
                                <td style="width: 725px">
                                    Welcome to the NRC Picker Data Loader site. NRC Picker’s <a href="javascript: void newWin('http://www.nrcpicker.com/Pages/PrivacyPolicy.aspx', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=570,height=500,resizable=1')">privacy and security statement</a>
                                    guarantees that your data files will be transmitted safely.
                                    <br /><br />
                                    <a href = "javascript:ViewInstructions(this)" id = "ViewInstr">Click Here To View Instructions</a>
                                    <a href = "javascript:ViewInstructions(this)" style ="display:none;" id = "CloseInstr">Close Instructions</a>
                                    <br /><br />
                                    <div id = "InstructionTable" style="display:none;">
                                    <ul>
                                    <li>Browse to find the file you wish to upload</li> 
                                    <li>Select your file type</li>
                                    <li>Click on the packages you wish to load this file into</li>
                                    <li>Add additional notes for our associates</li>
                                    <li>Click "<b>Add File to Queue</b>"</li>
                                    <li>Repeat these steps for each file you wish to upload</li>
                                    <li>Once you have added all the files you wish to upload, please click "<b>Upload
                                    All Queued Files</b>" to transmit the files to NRC Picker</li>
                                    <li>Large files may take a few minutes to upload</li>
                                    </ul>
                                    If you need any further assistance
                                    in using this site, please refer to the <a href="Help/Data Loader User Manual.pdf" target="_blank">Data Loader Instruction Manual</a> or contact
                                    your Measurement Services Manager at NRC Picker.
                                    <p />
                                    </div>
                                </td>
                             </tr>
                        </table><!--Instructions and header-->
                        <div id="pnlMainDisplay" class="Expander" style="width: 760px;text-align:left;overflow: auto;" >
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td id="MainDisplay" style="width: 760px">
                                    <table border="0" cellpadding='0' cellspacing='4' width='100%'>
                                        <tr>
                                            <td style = "background-color: #f5f5f5;">
                                                <div id="pnlFileInfoHeader" >
                                                    <table cellpadding = "0" cellspacing = "0" border = "0" width = "100%">
                                                        <tr>
                                                            <td align = "left" width = "50%" >
                                                                <span class="PanelTitle">File Information(<asp:Label ID = "client" runat = "server" Font-Size = "xx-small" ForeColor = "black" />)
                                                                </span>
                                                            </td>
                                                            <td align = "right"  width = "50%">
                                                                <span><font color="red">*</font> Required fields.</span>
                                                            </td>
                                                        </tr>
                                                    </table><!--main Form header Table -->
                                                </div>
                                            </td>
                                         </tr>
                                    </table> <!--Main Form Display-->  
                                </td>
                             </tr>
                        </table> 
                        </div> 
                        <asp:UpdateProgress id="UpdateProgress3" runat="server" 
                        AssociatedUpdatePanelID="fullPagePanel" DisplayAfter="150" DynamicLayout="true" >
                            <PROGRESSTEMPLATE>
                                    <div style="position:absolute;top:253px;left:5px;background-color:transparent; vertical-align: middle; width: 769px; height: 524px; text-align: center;">
                                        <table cellpadding = "0" cellspacing = "0" 
                                        style=" background-color:#c6d6ff;vertical-align: middle; width: 116px; 
                                        height: 31px; text-align: center; padding-right: 0px; border-top: lightskyblue thin solid; padding-left: 0px; left: 343px; padding-bottom: 0px; margin: 0px; padding-top: 0px; border-bottom: lightskyblue thin solid; position: absolute; top: 43px; border-right: lightskyblue thin solid; border-left: lightskyblue thin solid;">
                                            <tr>
                                                <td style="width: 193px; height: 46px; text-align: center">
                                                  <img src="img/loading.gif" border="0" alt = "loading"/></td>
                                                <td style="width: 100px; height: 46px; text-align: left">
                                                <strong>Loading......</strong></td>
                                            </tr>
                                        </table>
                                    </div>
                            </PROGRESSTEMPLATE>
                        </asp:UpdateProgress>  
                        <asp:UpdatePanel ID="mainFormPanel" runat = "server" UpdateMode = "Conditional">
                        <Triggers>
                        </Triggers>
                        <ContentTemplate>      
                        <table class="PropertyTable" width = "760" id = "FileInfotable">
                            <tr>
                                <td valign='top'  colspan = "2" >
                                    <table cellpadding = "0" cellspacing = "2" border = "0">
                                        <tr>
                                            <td valign='top' class="PropertyLabel" style ="width:135px">
                                                <font color="red">*</font>&nbsp;Source File: 
                                                <input type="hidden" name="CurrentFileID" value="1" />
                                            </td>
                                            <td class="PropertyValue" style="width: 590px" id = "CellForFileControls">
                                                <asp:label ID = "CurrentFileUploadID" Visible = "false" runat = "server" /> 
                                                <asp:Label ID = "UploadFileControlIdLabel" runat = "server" visible = "false"/>
                                                <asp:Label ID = "UploadFileControlValueLabel" runat = "server" visible = "false"/>
                                                <div id="FileControls" runat = "server" style =" font-size:xx-small;">
                                                </div>
                                            </td>
                                        </tr>
                                    </table><!--File Upload Table -->
                                </td>
                            </tr>
                            <tr>
                                <td valign='top'  colspan = "2" >
                                    <asp:UpdatePanel ID="FileTypePanel" runat = "server" UpdateMode = "Conditional">
                                        <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID = "SelectedFileType" />
                                        </Triggers>
                                            <ContentTemplate>
                                                <table cellpadding = "0"  border = "0">
                                                    <tr>
                                                        <td class='PropertyLabel' valign='top'   style="width:137px;">
                                                            <font color='red'>*
                                                            </font>Select a File Type:&nbsp;
                                                        </td>
                                                        <td valign='middle' class='PropertyValue'  style="width:588px;">
                                                            <div id = "dropDownList">
                                                                <asp:dropdownlist ID = "SelectedFileType" runat = "server" 
                                                                OnSelectedIndexChanged = "PackagePMDisplay" autopostback = "true"/>
                                                                <img src='img/icon_question.gif' alt='What is this?' border="0" style='cursor:hand' 
                                                                onclick='javascript:showFileTypeInfoDiv()' />
                                                            </div>
                                                            <div id='FileTypeInfo' style ="display:none">
                                                                <table>
                                                                  <tr>
                                                                      <td>
                                                                             <b>Production</b>: Any file that you are sending to 
                                                                             NRC Picker that contains records for patients to be 
                                                                             surveyed.
                                                                      </td>
                                                                      <td valign='top' align = 'right'>
                                                                            <a href="javascript:showFileTypeInfoDiv()">
                                                                            <img src='img/closebutton.jpg' align="right" border="0" 
                                                                            style='padding-left:8px;padding-bottom:2px;' alt = "Close"/></a>
                                                                      </td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td colspan = '2'>
                                                                            <b>DRG Updates</b>: Any file you are sending to update 
                                                                            your DRG codes for a previously sent file.
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td colspan = '2'>
                                                                            <b>Non-DRG updates</b>: Any file that you are sending to 
                                                                            update previously sent information, other than DRGs, that 
                                                                            NRC Picker uses to survey.
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td colspan = '2'>
                                                                            <b>Setup Files</b>: Any file you send to NRC Picker in 
                                                                            order to set up your project.  This includes test files, 
                                                                            file layouts, data dictionaries, etc.  Typically these files 
                                                                            are sent before you begin sending us your production files.
                                                                      </td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td colspan = '2'>
                                                                            <b>Maintenance Files:</b> Files that you send to NRC Picker 
                                                                            that include information that is not directly used for surveying.  
                                                                            These include lists of deceased patients, Take Off Call List 
                                                                            patients, or updates that are not patient-specific, such as a 
                                                                            list of new doctor names to use for survey personalization.
                                                                      </td>
                                                                  </tr>
                                                             </table><!-- file type definitions Display-->
                                                         </div><!-- file type definitions Display-->
                                                     </td>
                                                  </tr> <!-- File Types Note Display and drop down List -->
                                                  <tr id='Packages' >
                                                     <td valign='top' class='PropertyLabel'    style="width:137px;">
                                                         <div id = "labelContainer">
                                                         <asp:label ID = "lblPacks" runat = "server" text = "<font color='red'>*</font>Select your Packages:" Visible = "false" />
                                                         <asp:label ID = "lblPMs" runat = "server" text = "<font color='red'>*</font>Select the Measurement Services Manager:" Visible = "false" />
                                                       </div>
                                                     </td>
                                                     <td class='PropertyValue'   style="width:588px;vertical-align:top;">
                                                            <asp:PlaceHolder ID = "validationPlaceHolder" runat = "server" />
                                                            <asp:Checkboxlist ID = "cbPackageList" runat = "server" Visible = "false" CssClass = "theclass"
                                                            RepeatColumns = "2" RepeatDirection = "vertical" Font-Size = "1px" Width = "100%"/>
                                                            <asp:radiobuttonlist ID = "rbPMlist" runat = "server" Visible = "false" 
                                                            RepeatColumns = "2" RepeatDirection = "vertical" Font-Size = "1px" Width = "100%" />
                                                            <asp:Label runat = "Server"  Visible = "false" ID = "LimitedAccess" 
                                                            Font-Size = "XX-Small">
                                                            <strong>You currently 
                                                            only have access to upload setup and maintenance files.
                                                            When your project setup is complete, you will be able to upload production files. 
                                                            Until that time, please use setup or maintenance files as your file type and 
                                                            specify your Measurement Services Manager. If you need further 
                                                            clarification, please contact your Measurement Services Manager.</strong>
                                                            </asp:Label> 
                                                     </td>
                                                 </tr><!--Packages/Project Managers/Limited Access -->  
                                             </table><!--file type drop Down/file type definitions/Packages/Project Managers/Limited Access-->
                                         </ContentTemplate>
                                    </asp:UpdatePanel> <!-- Update Panel file type drop Down/file type definitions/Packages/Project Managers/Limited Access-->
                                </td>
                            </tr><!--file type Select/Packages/Pm's -->
                            <tr>
                                <td valign='top'  colspan = "2" >
                                    <table cellpadding = "0" cellspacing = "2" border = "0">
                                        <tr>
                                            <td valign='top' class="PropertyLabel" style ="width:137px">
                                                File Upload Notes: 
                                            </td>
                                            <td class="PropertyValue" style="width: 588px">
                                                <asp:TextBox TextMode = "MultiLine" ID = "SelectedNotes" Rows = "3" Columns = "40" 
                                                    CssClass = "PropertyValue" MaxLength = "500" runat = "server"  onblur = "javascript:checkLength(this);"/>
                                            </td>
                                        </tr>
                                    </table><!--Notes -->
                                </td>
                            </tr>
                            <tr>
                                <td colspan = "2" id = "QueueButtons">
                                   <%-- <asp:button runat = "server" id = "ClearFileOptions" text = "Clear Options" 
                                    style = "font-size:10px;" 
                                    onclientclick = "Javascript:if(confirm('Are you sure you would like to clear all file options?')) {PostPanel(this.id);} else { return false; }"/>
                                        &nbsp;--%>
                                       
                                    <input type="button" name="AddFileToQueue23" value="Add File To Queue" style="font-size:10px;"
                                        onclick="javascript:AddUploadFileControl()" /> 
                                </td>
                            </tr><!--Main display Buttons Clear Options and add file to Queue-->      
                        </table><!--Main form table -->
                        <hr  style ="width:100%;"/>
                        <br />
                        <asp:UpdatePanel ID = "BottomGridPanel" runat = "server" UpdateMode = "Conditional" >
                            <Triggers>
                            </Triggers>
                            <ContentTemplate>
                                <asp:PlaceHolder ID = "GenericContentPlaceholder" runat = "server" />
                                <div id = "QueueDataGrid">
                                <asp:DataGrid 
                                AutoGenerateColumns = "false" 
                                ID = "fgrid" 
                                runat = "server" 
                                Width = "760" 
                                borderwidth = "0"
                                Cellspacing = "2">
                                    <HeaderStyle  
                                    cssclass = "DataGridHeader" 
                                    Wrap = "false" 
                                    Width = "760"  
                                    Font-Size = "xx-small"
                                    borderwidth = "0"  
                                    HorizontalAlign = "Center" />
                                    <ItemStyle 
                                    CssClass = "DatagridClass" 
                                    BorderWidth = "1" 
                                    BorderStyle = "Solid"/>
                                    <AlternatingItemStyle 
                                    CssClass = "DatagridAltClass"/>
                                    <Columns>
                                        <asp:BoundColumn DataField = "ID" 
                                        HeaderText = "ID" 
                                        ItemStyle-BorderWidth = "1"
                                        ItemStyle-Width = "30" 
                                        ItemStyle-Font-Size = "XX-Small" />
                                        <asp:BoundColumn DataField = "OrigFileName" 
                                        HeaderText = "File Name"
                                        ItemStyle-BorderWidth = "1" 
                                        ItemStyle-Width = "181" 
                                        ItemStyle-Font-Size = "XX-Small" />
                                        <asp:BoundColumn DataField = "UploadAction" 
                                        HeaderText = "File Type" 
                                        ItemStyle-BorderWidth = "1"
                                        ItemStyle-Width = "108"  
                                        ItemStyle-Font-Size = "XX-Small" />
                                        <asp:BoundColumn DataField = "PackagePM"  
                                        ItemStyle-Width = "211" 
                                        HeaderText = "Packages/Measurement<br />Services Manager" 
                                        ItemStyle-BorderWidth = "1"
                                        ItemStyle-Font-Size = "XX-Small"  />
                                        <asp:TemplateColumn
                                        Headertext = "Upload File Notes" 
                                        ItemStyle-BorderWidth = "1" 
                                        ItemStyle-Width = "175" 
                                        ItemStyle-Font-Size = "XX-Small" 
                                        ItemStyle-HorizontalAlign = "Center" >
                                        <ItemTemplate>
                                        <asp:TextBox runat = "server" TextMode = "MultiLine" ID = "QueueNotes" Rows = "3" Columns = "40" 
                                        CssClass = "PropertyValue" MaxLength = "500" onblur = "javascript:checkLength(this);"/>
                                        </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField = "OrigFileName" 
                                        HeaderText = "Remove"  
                                        ItemStyle-BorderWidth = "1"
                                        ItemStyle-Width = "50" 
                                        ItemStyle-Font-Size = "XX-Small" 
                                        ItemStyle-HorizontalAlign = "Center"/>
                                        <asp:BoundColumn DataField = "UserNotes" 
                                        visible = "false" 
                                        ItemStyle-BorderWidth = "1"
                                        ItemStyle-Width = "50" 
                                        ItemStyle-Font-Size = "XX-Small" 
                                        ItemStyle-HorizontalAlign = "Center"/>
                                    </Columns>
                                </asp:DataGrid>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <table border="0" cellpadding="0" cellspacing="0" width="760" id = "UploadProgress" style ="display:none;">
                    <tr><td><br /></td></tr>
                    <tr>
                        <td align="center" width="760"><br /><br />Updating Please Wait!<br /><br />
                        
                         <iframe  id="myFrame"  frameborder="0"  vspace="0" hspace="0"  marginwidth="0"  marginheight="0" width="760"  scrolling="yes"  height="150"></iframe>
                        </td>
                    </tr>
                </table>
            <dxwgv:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" OnLoad = "GridViewLoad"
            CssFilePath="~/App_Themes/Glass/{0}/styles.css" CssPostfix="Glass" Width="755px" >
            <Settings ShowGroupPanel="True" />
            <Columns>
                <dxwgv:GridViewDataTextColumn FieldName="UploadFile_id" ReadOnly="True" VisibleIndex="0" Caption = "File ID">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataDateColumn FieldName="datOccurred" VisibleIndex="1" Caption = "Upload Date">
                </dxwgv:GridViewDataDateColumn>
                <dxwgv:GridViewDataTextColumn FieldName="Uploader" VisibleIndex="5" Caption = "Member Name">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UploadAction_nm" VisibleIndex="2" Caption = "File Type">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="OrigFile_Nm" VisibleIndex="3" Caption = "File Name">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="Packages" VisibleIndex="7" Caption = "Packages/&lt;br /&gt;Measurement &lt;br /&gt;Services  Manager">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UploadState_nm" VisibleIndex="6" Caption = "Upload Status">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UserNotes" VisibleIndex="4" Caption = "Notes" Width = "200px">
                    <CellStyle Wrap="True">
                    </CellStyle>
                </dxwgv:GridViewDataTextColumn>
            </Columns>
            <Images ImageFolder="~/App_Themes/Glass/{0}/">
                <CollapsedButton Height="12px"
                    Width="11px" />
                <DetailCollapsedButton Height="9px"
                    Width="9px" />
                <PopupEditFormWindowClose Height="17px" Width="17px" />
            </Images>
            <Styles CssFilePath="~/App_Themes/Glass/{0}/styles.css" CssPostfix="Glass">
                <Header ImageSpacing="5px" SortingImageSpacing="5px">
                </Header>
            </Styles>
            <SettingsPager NumericButtonCount="100" PageSize="100">
                <AllButton Visible="True">
                </AllButton>
            </SettingsPager>
            </dxwgv:ASPxGridView>
    </ContentTemplate>
    </asp:UpdatePanel>
    <div id = "UploadButtonDiv" style="display:none;">
        <center>
            <asp:Button ID = "ClearQ" runat = "server" Text = "Clear All Queued Files"  onclientclick = "Javascript:if(confirm('Are you sure you wish to delete all queued items?')) {PostPanel(this.id);} else { return false; }"/>
            <asp:Button ID = "UpAll" runat = "server" Text = "Upload All Queued Files"  onclientclick = "javascript:if(confirm('Are you sure you would like to upload the ' + getUploadsCount() + ' queued file(s)?')){PostFullForm(this.id,'UpAll');} else { return false; }"/>
        </center>
    </div>
    <div id = "uploadDisplay">
    <hr  style ="width:100%;"/>
    <asp:PlaceHolder ID = "GenericUploadsGridPLaceholder" runat = "server" />
    <asp:DataGrid 
    AutoGenerateColumns = "false" 
    ID = "uploadsgrid" 
    runat = "server" 
    BorderWidth="0" 
    Width = "760" 
    cellspacing = "2">
            <HeaderStyle  
            cssclass = "RedPropertyLabel" 
            Wrap = "false" 
            Width = "760"  
            Font-Size = "xx-small"
            borderwidth = "0"  
            HorizontalAlign = "Center" />
            <ItemStyle 
            CssClass = "DatagridClass" 
            BorderWidth = "1" 
            BorderStyle = "Solid"/>
            <AlternatingItemStyle CssClass = "DatagridAltClass"/>
            <Columns>
                <asp:BoundColumn DataField = "FileName" 
                HeaderText = "File Name" 
                ItemStyle-BorderWidth = "1"
                ItemStyle-Width = "175" 
                ItemStyle-Font-Size = "XX-Small" />
                <asp:BoundColumn DataField = "FileType" 
                HeaderText = "File Type" 
                ItemStyle-BorderWidth = "1"
                ItemStyle-Width = "175" 
                ItemStyle-Font-Size = "XX-Small" />
                <asp:BoundColumn DataField = "Packages" 
                HeaderText = "Selected Package(s) or<br /> Measurement Services Manager" 
                ItemStyle-Width = "235"  
                ItemStyle-BorderWidth = "1"
                ItemStyle-Font-Size = "XX-Small" />
                <asp:BoundColumn DataField = "Status" 
                ItemStyle-BorderWidth = "1" 
                ItemStyle-Width = "175" 
                HeaderText = "Status" 
                ItemStyle-Font-Size = "XX-Small" />
             </Columns>
             </asp:DataGrid>
             </div>
    <div id = "UploadFileControlHolder" style ="display:none"/>
    
</asp:content>


