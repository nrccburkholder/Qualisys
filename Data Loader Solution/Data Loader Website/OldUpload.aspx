<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Upload.aspx.vb" Inherits="NRC.DataLoader.Upload" %>
<%@ Register TagPrefix ="uc" TagName = "PageLogo1" Src="~/UserControls/ucPageLogo.ascx" %>
<%@ Register TagPrefix ="uc" TagName ="PageHeader1" Src ="~/UserControls/ucHeader.ascx" %>
<%@ Register TagPrefix ="uc" TagName ="PageFooter1" Src="~/UserControls/ucFooter.ascx"%>
<%@ Register Src="~/UserControls/ucSecurity.ascx" TagName="SecurityControl1" TagPrefix="uc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>NRC Picker Data Loader</title>
    <link href="css/Styles.css" rel="stylesheet" type="text/css" />
	<link href="css/EReports.css" type="text/css" rel="stylesheet" />
	<link href="css/FileTypeInfo.css" type="text/css" rel="stylesheet" />
    <script src="_Scripts/Upload.js" type="text/javascript" />
    <script language="javascript" type="text/javascript">
    <!--//  

    //-->
    </script>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
    <table style="width: 762px">
    <tr>
    <td style="width: 763px">
        <uc:PageHeader1 ID="PageHeader" runat="server" />
        <br />
    </td>
    </tr>
    <tr>
    <td style="width: 763px">
        <br /><uc:PageLogo1 ID="PageLogo" runat ="server" /><br />
        Welcome to the NRC Picker Data Loader site. NRC Picker’s <a href="javascript: void newWin('/Pages/PrivacyPolicy.aspx', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=570,height=500,resizable=1')">privacy and security statement</a>
        guarantees that your data files will be transmitted safely. 
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
        in using this site, please refer to the <a href="img/Data Loader User Manual.pdf" target="_blank">Data Loader Instruction Manual</a> or contact
        your Measurement Services Manager at NRC Picker.
        <p />
        <font color="red">*</font> - denotes a required field.
        <br />
        <br />
    </td>
    </tr>

    </table>
    <input type="hidden" name="ServerFlag" value="" />
    <input type="hidden" name="AjaxServerFlag" value="" />
    <div id="pnlMainDisplay" class="Expander" style="width: 762px;text-align:left;" >
        
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td id="MainDisplay" style="width: 762px">
            <!--Main Form Display-->
            <table border=0 cellpadding='0' cellspacing='0' width='100%'><tr><td><div id="pnlFileInfoHeader" class="PanelTitle">File Information</div></td><td align='right'></td></tr></table>
        
                <table class="PropertyTable">
                    <tr>
                        <td valign='top' class="PropertyLabel"><font color="red">*</font>Source File: <input type="hidden" name="CurrentFileID" value="1" /></td>
                        <td class="PropertyValue" style="width: 560px">
                            <div id="FileControlContainer">
                                <div id="FileControlDiv1">
                                    <input type="file" name="FileControl1" style="width: 300px" class="PropertyValue" onkeydown="javascript:DisabledKeys(event);"  />
                                </div>
                            </div>
                        </td>
                    </tr>
                    <% GetPackages  %>
                    <!--File Types-->
                    <%= WriteFileTypesHTML() %>
                    <!--- Limited Access -->
                    <%= WriteLimitedAccess() %>
                    <!--Packages-->
                    <%  Dim PKWriters As String = WritePackageHTML()
                        If PKWriters = "" Then
                            Throw New Exception("~ Your session table was unable to be viewed. Please click ""refresh"" on your browser.  If you continue to experience difficulty please contact: MySolutionsExceptions@nationalresearch.com")
                        Else
                            Response.Write(PKWriters)
                        End If%>
                    <!--ProjectManagers-->
                    
                    <%  Dim PMWriters As String = WriteProjectManagerHTML()
                        If PMWriters = "" Then
                            Throw New Exception("~ Your session table was unable to be viewed. Please click ""refresh"" on your browser.  If you continue to experience difficulty please contact: MySolutionsExceptions@nationalresearch.com")
                        Else
                            Response.Write(PMWriters)
                        End If%>
                    <tr>
                        <td valign="top" class="PropertyLabel">
                            File Upload Notes: 
                        </td>
                        <td valign="top" class="PropertyValue" style="width: 560px">
                            <textarea name="SelectedNotes" rows="3" cols="40" style="width: 270px" class="PropertyValue" onkeyup="checkLimit(this)"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2" align="left"><br />
                            <input type="button" name="ClearFileOptions" value="Clear Options" onclick="javascript:ClearOptions(false)" />&nbsp;<input type="button" name="AddFileToQueue" value="Add File To Queue" onclick="javascript:AddToQueue()" /> <asp:Button ID = "btnHist" runat = "server" Text = "File History" PostBackUrl = "uploadfilehistory.aspx"/></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        <asp:Label ID="UploadStatus" runat="server" EnableViewState="False" />
                        </td>
                    </tr>                    
                </table>
            <!--End Main Form Display-->
            </td>
        </tr>
        <tr>
            <td id="UpdateQueueGrid" style="width: 762px">
            <!--Start Upload Queue Grid-->
            
            <!--End Upload Queue Grid-->
            </td>
        </tr>
        <tr>
            <td id="UploadSessionStatus" align="left" style="width: 100%">
            <%= WriteUploadStatus() %>
            </td>
        </tr>
        <tr align="left" >
            <td id="UpdateProgress" style="display:none;width: 100%; text-align:center;">
                <!--Start Upload Queue Progress bar-->
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr><td><br /></td></tr>
                    <tr>
                        <td align="center" width="100%"><br /><br />Updating Please Wait!<br /><br />
                        
                         <iframe  id="myFrame"  frameborder="0"  vspace="0" hspace="0"  marginwidth="0"  marginheight="0" width="100"  scrolling="yes"  height="100"></iframe>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" width="100%">
                          <!--<strong>To view progress of your upload please enable pop-ups.</strong>-->
                        </td>
                    </tr>
                </table>
                <!--End Upload Queue Progress Bar-->
            </td>
        </tr>
    </table>
        </div>
    <div>
    <table>
        <tr>
            <td width="100%" colspan="1">
            <uc:PageFooter1 ID="PageFooter1" runat="server"></uc:PageFooter1>
            </td>
        </tr>
    </table>
    </div>
            <uc:SecurityControl1 ID="SecurityControl1" runat="server"></uc:SecurityControl1>    
    </form>
</body>
</html>
