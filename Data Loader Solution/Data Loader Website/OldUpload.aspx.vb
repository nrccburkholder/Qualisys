Imports NRC.DataLoader.Library
Imports System.Text
Imports System.Net.Mail
Imports System.Collections.Generic
Imports WebSupergoo.ABCUpload6
Imports NRC.NRCAuthLib
Imports NRC.Qualisys.QLoader.Library
Imports NRC.Framework.Configuration
Imports NRC.DataLoader.ParseBackSlashAndSpace
Imports System.Reflection
Imports System.IO

Partial Public Class Upload
    Inherits WebErrorTrappingBaseClass
    Private studyIDs As List(Of Integer) = New List(Of Integer)
    

#Region " HTML Display Methods "
    ''' <summary>Builds a string of html representing the packages available to the client.</summary>
    ''' <returns>html as string</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function WritePackageHTML() As String
        Dim sb As StringBuilder = New StringBuilder
        Dim packageIDs As String = ""
        sb.AppendLine("<tr id='Packages' style='display:none'>")
        sb.AppendLine("<td valign='top' class='PropertyLabel'><font color='red'>*</font>Select your Packages: </td>")
        sb.AppendLine("<td class='PropertyValue'>")
        Dim packages As List(Of NRC.Qualisys.QLoader.Library.DTSPackage) = TryCast(Context.Session("DTSPackages"), List(Of NRC.Qualisys.QLoader.Library.DTSPackage))
        If Not packages Is Nothing AndAlso packages.Count > 0 Then
            Dim newset As DataSet = SortAnyListReturnNativeDataSet.GetDataSetNative(packages, "PackageFriendlyName")
            Dim Displaycolumn As String = "PackageFriendlyName"
            Dim IdColumn As String = "PackageID"
            Dim PIds As String = String.Empty
            Dim PNames As String = String.Empty
            Dim addFlag As Boolean = True
            'If Not packages Is Nothing AndAlso packages.Count > 0 Then
            'For Each package As NRC.Qualisys.QLoader.Library.DTSPackage In packages
            For Each row As DataRow In newset.Tables(0).Rows
                For Each column As DataColumn In row.Table.Columns
                    Dim adflag As Boolean = True
                    If column.ColumnName = IdColumn Then
                        addFlag = True
                        If Not DTSPackage.GetPackageByID(CInt(row.Item(column.Ordinal))).BitActive Then
                            addFlag = False
                            Exit For
                        End If
                    End If
                    'If package.BitActive Then
                    If column.ColumnName = Displaycolumn Then
                        PNames = row.Item(column.Ordinal).ToString
                    End If
                    If column.ColumnName = IdColumn Then
                        PIds = row.Item(column.Ordinal).ToString
                    End If
                Next
                If addFlag Then
                    'sb.Append("<label><input type='checkbox' id='Package" & package.PackageID & "' name='Package" & package.PackageID & "' value='" & package.PackageID & "' />" & package.PackageFriendlyName & "</label><br />")
                    sb.Append("<label><input type='checkbox' id='Package" & PIds & "' name='Package" & PIds & "' value='" & PIds & "' />" & PNames & "</label><br />")
                    'packageIDs += package.PackageID.ToString & ","
                    packageIDs += PIds & ","
                    'End If
                End If
            Next
            'Next
            If packageIDs.Length > 0 Then
                packageIDs = packageIDs.Substring(0, packageIDs.Length - 1)
            End If
            sb.AppendLine("<input type='hidden' id='SelectedPackageIDs' name='SelectedPackageIDs' value='" & packageIDs & "' />")
            'End If
        End If
        sb.AppendLine("</td>")
        sb.AppendLine("</tr>")

        Return sb.ToString
    End Function
    ''' <summary>Writes the file type html for the upload page.</summary>
    ''' <returns>file type html string</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term>2008/04/06 - Steve Kennedy</term><description>Wired UploadAction Business Object in place of TempUpload</description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function WriteFileTypesHTML() As String

        Dim sb As StringBuilder = New StringBuilder
        Dim fileTypes As UploadActionCollection = UploadAction.GetAll
        sb.AppendLine("<tr>")
        sb.AppendLine("    <td valign='top' class='PropertyLabel'><font color='red'>*</font>Select a File Type:&nbsp;</td>")
        sb.AppendLine("    <td valign='middle' class='PropertyValue'>")
        sb.AppendLine("    <select id='SelectedFileType' name='SelectedFileType' OnChange=""toggleContentDiv(this.name);"">")
        sb.AppendLine("    <option value = '0'></option>")
        For Each fileType As UploadAction In fileTypes
            If Not ((Context.Session("DTSPackages").count < 1) AndAlso (fileType.UploadFileTypeAction.Name = "Packages")) Then
                sb.AppendLine("    <option  value='" & fileType.UploadActionId & "'>" & fileType.UploadActionName & "</option>")
            Else
                sb.AppendLine("    <option  disabled = 'True' style='color:silver;background-color:gainsboro;' value='" & fileType.UploadActionId & "'>" & fileType.UploadActionName & "</option>")
            End If
        Next
        sb.AppendLine("    </select>")

        ' Steve Kennedy 6/23 - Add hidden input types that correlate the filetypeid with the fileuploadactionanme.
        For Each fileType As UploadAction In fileTypes
            sb.AppendLine("    <input type='hidden' name='" & fileType.UploadActionId & "' id='" & fileType.UploadActionId & "' value='" & fileType.UploadFileTypeAction.Name & "'>")
        Next
        ' Steve Kennedy 6/23 - Add hidden input types that correlate the filetypeid with the fileuploadactionanme.

        'Steve Kennedy 6/18 - Task for adding icon
        sb.Append("<img src='img/icon_question.gif' alt='What is this?' border=0 style='cursor:hand' onclick='javascript:showFileTypeInfoDiv()' >")
        sb.Append("<div id='FileTypeInfo'><table>")
        sb.Append("<tr><td><b>Production</b>: Any file that you are sending to NRC Picker that contains records for patients to be surveyed.<p/></td>")
        sb.Append("<td valign='top' align = 'right'><a href=""javascript:showFileTypeInfoDiv()""><img src='img/closebutton.jpg' align=right border=0 style='padding-left:8px;padding-bottom:2px;'></a></td></tr>")
        sb.Append("<tr><td colspan = '2'><b>DRG Updates</b>: Any file you are sending to update your DRG codes for a previously sent file.<p/></td></tr>")
        sb.Append("<tr><td colspan = '2'><b>Non-DRG updates</b>: Any file that you are sending to update previously sent information, other than DRGs, that NRC Picker uses to survey.<p/></td></tr>")
        sb.Append("<tr><td colspan = '2'><b>Setup Files</b>: Any file you send to NRC Picker in order to set up your project.  This includes test files, file layouts, data dictionaries, etc.  Typically these files are sent before you begin sending us your production files.<p/></td></tr>")
        sb.Append("<tr><td colspan = '2'><b>Maintenance Files:</b> Files that you send to NRC Picker that include  information that is not directly used for surveying.  These include lists of deceased patients, Take Off Call List patients, or updates that are not patient-specific, such as a list of new doctor names to use for survey personalization.<p/></td></tr>")
        sb.Append("</table></div>")
        'Steve Kennedy 6/19 - Taks for adding icon

        sb.AppendLine("    </td>")
        sb.AppendLine("</tr>")
        Return sb.ToString()
    End Function
    ''' <summary>Writes an html upload status table for upload objects in the
    ''' session.</summary>
    ''' <returns>HTML Table.</returns>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>05/28/2008 - Arman Mnatsakanyan</term>
    ''' <description>Changed the displayed file name to be the original file full
    ''' path.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Function WriteUploadStatus() As String
        Dim sb As StringBuilder = New StringBuilder()
        Try
            Dim uploads As UploadFileCollection
            uploads = TryCast(Context.Session("SessionUploads"), UploadFileCollection)
            If Not uploads Is Nothing AndAlso uploads.Count > 0 Then
                sb.AppendLine(" <br/><div id='pnlFileInfoHeader' class='PanelTitle'>Uploads for this Session</div> ")
                sb.AppendLine("<table class='PropertyTable' width='100%'>")
                sb.AppendLine("<tr>")
                sb.AppendLine("     <td class='RedPropertyLabel' align='left'>File Name</td>")
                sb.AppendLine("     <td class='RedPropertyLabel' align='left'>File Type</td>")
                sb.AppendLine("     <td class='RedPropertyLabel' align='left'>Selected Package(s) or Measurement Services Manager</td>")
                sb.AppendLine("     <td class='RedPropertyLabel' align='left'>Status</td>")
                sb.AppendLine("</tr>")
                For Each upload As UploadFile In uploads
                    upload.UploadFileState.StateOfUpload.ToString()
                    Dim NewFileNameField As String = ParseBackSlashAndSpace.ParseText(upload.OrigFileName)
                    sb.AppendLine("<tr>")
                    sb.AppendLine("<td valign='top'>" & NewFileNameField & "</td>")
                    sb.AppendLine("<td valign='top'>" & upload.UploadAction.UploadActionName & "</td>")
                    sb.AppendLine("<td valign='top'>")
                    sb.AppendLine(upload.GetFileTypeActionDisplayString("<br/>"))
                    sb.AppendLine("</td>")
                    'GetStateDisplayName(upload.UploadFileState.UploadStateId)

                    If upload.UploadFileState.StateOfUpload.UploadStateName = "UploadAbandoned" Then
                        'If upload.UploadFileState.StateOfUpload.UploadStateName = UploadState.GetByName(UploadState.States.UploadAbandoned) Then

                        sb.AppendLine("<td valign='top'><img align='left' src='img/icon_failure.png' alt='Upload Failed'>Upload Failed</td>")
                    Else
                        sb.AppendLine("<td valign='top'><img align='left' src='img/icon_accept.png' alt='Upload Succeeded'>Upload Succeeded</td>")
                    End If

                    sb.AppendLine("</tr>")
                Next
                sb.AppendLine("</table>")
            End If


        Catch 'sk 06-03-2008 if session upload grid doesn't get written right, return nice msg to user

            sb.AppendLine()
            sb.AppendLine(" <br/><div id='pnlFileInfoHeader' class='PanelTitle'>Uploads for this Session</div> ")
            sb.AppendLine("<table class='PropertyTable' width='100%'><tr><td><font color='red'>An Error has occurred while creating this table.</font></td></tr></table>")




        End Try

        Return sb.ToString
    End Function
    Public Function WriteLimitedAccess() As String
        Dim sb As StringBuilder = New StringBuilder()
        If Context.Session("DTSPackages").count < 1 Then
            sb.AppendLine("<tr id='Limited Access'>")
            sb.AppendLine("<td valign='top' class='PropertyLabel'>&nbsp;</td>")
            sb.AppendLine("<td valign='middle' class='PropertyValue'>    ")
            sb.AppendLine("<strong>You currently only have access to upload setup and maintenance files.")
            sb.AppendLine("When your project setup is complete, you will be able to upload production files. ")
            sb.AppendLine("Until that time, please use setup or maintenance files as your file type and specify your Measurement Services Manager.")
            sb.AppendLine("If you need further clarification, please contact your Measurement Services Manager.</strong>  ")
            sb.AppendLine("</td>")
            sb.AppendLine("</tr>")
        End If
        Return sb.ToString
    End Function
    ''' <summary>Builds a string of html representing the project managers available to the client.</summary>
    ''' <returns>html as string</returns>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function WriteProjectManagerHTML() As String
        GetProjectManagers()
        Dim sb As StringBuilder = New StringBuilder
        Dim memberIDs As String = ""
        sb.AppendLine("<tr id='Project Managers' style='display:none;'>")
        sb.AppendLine("<td valign='top' class='PropertyLabel'><font color='red'>*</font>Select the Measurement Services Manager: </td>")
        sb.AppendLine("<td class='PropertyValue'>")
        Dim ProjectManagers As Library.ProjectManagerCollection = CType(Context.Session("ProjectManagers"), Library.ProjectManagerCollection)
        If Not ProjectManagers Is Nothing AndAlso ProjectManagers.Count > 0 Then
            For Each ProjectManager As Library.ProjectManager In ProjectManagers
                sb.Append("<label><input type='radio' id='SelectedProjectManagerID' name='SelectedProjectManagerID' value='" & ProjectManager.MemberID & "' />" & ProjectManager.FullName & "</label><br />")
            Next
        End If
        sb.AppendLine("</td></tr>")
        Return sb.ToString
    End Function
#End Region


#Region " Package Methods "
    ''' <summary>This method retrives the project managers</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term>2008-04-07 - Steve Kennedy</term><description>commented out thrown exception, and replaced with response.redirect if no valid packages were selected</description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub GetProjectManagers()
        If Context.Session("ProjectManagers") Is Nothing Then
            Context.Session("ProjectManagers") = Library.ProjectManager.GetAll
        End If
        Dim ProjectManagers As Library.ProjectManagerCollection = CType(Context.Session("ProjectManagers"), Library.ProjectManagerCollection)
    End Sub
#End Region




#Region " Package Methods (Requiring NRC Auth)"
    ''' <summary>This method retrives the study IDs associates with the users group session to retrieve a list of DTS Packages available for them to view.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term>2008-04-07 - Steve Kennedy</term><description>commented out thrown exception, and replaced with response.redirect if no valid packages were selected</description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub GetPackages()
        If Context.Session("DTSPackages") Is Nothing Then
            Dim mem As NRC.NRCAuthLib.Member = CurrentUser.Member
            'For Each myGroup As NRC.NRCAuthLib.Group In CurrentUser.Member.Groups
            'For Each myGroup As NRC.NRCAuthLib.Group In CurrentUser.SelectedGroup  
            Dim myGroup As NRC.NRCAuthLib.Group = CurrentUser.SelectedGroup
            Dim dmTree As NRC.NRCAuthLib.DataMartPrivilegeTree
            dmTree = NRC.NRCAuthLib.DataMartPrivilegeTree.GetGroupTree(myGroup)
            'Client search
            For Each clientNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In dmTree.Nodes
                For Each studyNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In clientNode.Nodes
                    Dim studyID As Integer = ConvertNodeIDValue(studyNode)
                    If ((clientNode.IsGranted) Or (studyNode.IsGranted)) Then
                        If Not StudyExists(studyID) Then
                            studyIDs.Add(studyID)
                        End If
                    Else
                        RecurseTree(studyNode, studyID)
                    End If
                Next
            Next
            'Next            
            Context.Session("DTSPackages") = DTSPackage.CreatePackageCollectionByStudyIds(studyIDs)
        End If
        Dim DTSPackages As List(Of DTSPackage) = Nothing
        DTSPackages = TryCast(Context.Session("DTSPackages"), List(Of DTSPackage))
    End Sub
    ''' <summary>Helper method that removes the alpha values from a node id. </summary>
    ''' <param name="node"></param>
    ''' <returns>node id as an int value.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ConvertNodeIDValue(ByVal node As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode) As Integer
        Dim retVal As Integer = 0
        Select Case node.PrivilegeLevel
            Case NRC.NRCAuthLib.DataMartPrivilegeTree.PrivilegeLevelEnum.Client
                'TODO:  Implement
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Study
                retVal = Val(Replace(node.NodeId, "ST", ""))
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Survey
                'TODO:  Implement
            Case DataMartPrivilegeTree.PrivilegeLevelEnum.Unit
                'TODO:  Implement
        End Select
        Return retVal
    End Function
    ''' <summary>Helper method to make sure we are not recording duplicate study ids.  This is used when gathering info to get DTS Packages.</summary>
    ''' <param name="id"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function StudyExists(ByVal id As Integer) As Boolean
        For Each studyID As Integer In studyIDs
            If studyID = id Then
                Return True
            End If
        Next
        Return False
    End Function
    ''' <summary>Helper method used in retrieving study IDs from a users selected group.</summary>
    ''' <param name="node"></param>
    ''' <param name="studyID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub RecurseTree(ByVal node As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode, ByVal studyID As Integer)
        If Not node.Nodes Is Nothing Then
            For Each childNode As NRC.NRCAuthLib.DataMartPrivilegeTree.DataMartPrivilegeNode In node.Nodes
                If childNode.IsGranted Then
                    If Not StudyExists(studyID) Then
                        studyIDs.Add(studyID)
                        Exit For
                    End If
                Else
                    RecurseTree(childNode, studyID)
                End If
            Next
        End If
    End Sub
#End Region
    ''' <summary>This function finds the matching UploadFile business object with given UploadFileControl name.</summary>
    ''' <param name="htmlFileUploadControlName"></param>
    ''' <returns>Matching UploadFile object from MyUploads collection or nothing if not found.</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function FindUploadFile(ByVal htmlFileUploadControlName As String) As UploadFile
        Dim MyUploads As UploadFileCollection = CType(Context.Session("MyUploads"), UploadFileCollection)
        For Each upload As UploadFile In MyUploads
            If htmlFileUploadControlName = "FileControl" & upload.ClientFileId.ToString Then
                Return upload
            End If
        Next
        'TODO: Add error handling.
        'This function should never get here.
        Return Nothing
    End Function


#Region " ASP Events "

    ''' 
    Private Sub writelog(ByVal txt As String)
        Dim sWrite As StreamWriter = File.AppendText(Server.MapPath("~/Logs.txt"))
        sWrite.WriteLine(txt)
        sWrite.Close()
    End Sub

    ''' <summary>If postback, this upload the files selected on the upload
    ''' page.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>2008-04-07 - Steve Kennedy</term>
    ''' <description>Changed Folder Save Path from hard coded to config file
    ''' value</description></item>
    ''' <item>
    ''' <term>2008-04-16 - Arman Mnatsakanyan</term>
    ''' <description>Added sending notification emails to
    ''' teams.</description></item>
    '''<item>
    ''' <term>2008-06-03 - Steve Kennedy</term>
    ''' <description>Threw New BadFileStreamException if file size less 0.</description>
    ''' </item>
    '''</list></RevisionList>
    <System.ComponentModel.Description("If postback, this upload the files selected on the upload page.")> _
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Context.Response.Cache.SetCacheability(HttpCacheability.NoCache)
        'NRC.NRCAuthLib.FormsAuth.SignOut()
        'TP 20080407  Init the session upload objects.
        If Not Me.IsPostBack() Then
            Context.Session("MyUploads") = Nothing 'Pre-Init
            Context.Session("DTSPackages") = Nothing 'Re-Init when comming back to this page.
        End If
        If Context.Session("MyUploads") Is Nothing Then Context.Session("MyUploads") = New UploadFileCollection()
        If Context.Session("SessionUploads") Is Nothing Then Context.Session("SessionUploads") = New UploadFileCollection
        If Context.Session("UploadStates") Is Nothing Then Context.Session("UploadStates") = UploadState.GetAll()
        If Me.IsPostBack() Then
            If Request.Form("ServerFlag") = "UploadFiles" Then
                Dim myUploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
                Try
                    Dim upload As WebSupergoo.ABCUpload6.Upload = New WebSupergoo.ABCUpload6.Upload()
                    If upload.Files.Count <> myUploads.Count Then
                        'SK 06-03-2008 - If they don't count match, throw a uploadqueueoutofsync exception with friendly name
                        Throw New UploadQueueOutOfSyncException("The server queue and client queue is out of sync.")
                    End If
                    For iCnt As Integer = 0 To upload.Files.Count - 1
                        Dim UploadedFile As UploadedFile
                        UploadedFile = upload.Files(iCnt)
                        Dim HtmlFileUploadControlName As String = upload.Files.AllKeys(iCnt)
                        Dim tempUpload As UploadFile '= myUploads(iCnt)
                        tempUpload = FindUploadFile(HtmlFileUploadControlName)
                        Try
                            If tempUpload IsNot Nothing Then
                                tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.Uploading)
                                tempUpload.FileSize = UploadedFile.ContentLength
                                tempUpload.FileName = tempUpload.Id & "_" & UploadedFile.WinSafeFileName()
                                tempUpload.Save()
                                'TODO:  How do we update status.                                    
                                If UploadedFile.ContentLength <= 0 Then
                                    tempUpload.UploadFileState.StateParameter = "Reached point where file size was 0 or less"
                                    tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                                    tempUpload.Save()
                                    tempUpload.FileStatusSaved = False
                                    UploadFileEmailClass.makeemail(tempUpload, UploadNotificationMailType.UploadFailed)
                                    tempUpload.FileNotificationHandled = True
                                Else
                                    Dim FinalDirectory As String = System.IO.Path.Combine(Config.DataLoaderSaveFolder, tempUpload.UploadAction.FolderName)
                                    If Not System.IO.Directory.Exists(FinalDirectory) Then System.IO.Directory.CreateDirectory(FinalDirectory)
                                    UploadedFile.SaveAs(FinalDirectory & "\" & tempUpload.FileName)
                                    tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.Uploaded)
                                    tempUpload.Save()
                                    tempUpload.FileStatusSaved = True
                                    UploadFileEmailClass.makeemail(tempUpload, UploadNotificationMailType.UploadSuccessful)
                                    tempUpload.FileNotificationHandled = True
                                    'TODO:  Remove from myUploads collection and add to session collection.
                                End If
                            End If
                        Catch ex As Exception
                            writelog("Before" & Config.EnvironmentName & ex.Message & vbCrLf & ex.StackTrace)
                            tempUpload.UploadFileState.StateParameter = ex.Message & vbCrLf & ex.StackTrace
                            tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                            tempUpload.Save()
                            tempUpload.FileStatusSaved = True
                            UploadFileEmailClass.makeTeamemail(ex, tempUpload, UploadNotificationMailType.UploadFailed)
                            tempUpload.FileNotificationHandled = True
                        End Try
                        Library.UploadedFiles.UploadedFileCollection.AddToList(tempUpload)
                    Next
                    UploadFileEmailClass.makeclientsemail()
                    Library.UploadedFiles.DisposeUploadFilesCollection()
                Catch ex As Exception
                    Try
                        If Not myUploads Is Nothing Then
                            For Each tempUpload As UploadFile In myUploads
                                If Not tempUpload.FileStatusSaved Then
                                    tempUpload.UploadFileState.StateParameter = ex.Message & vbCrLf & ex.StackTrace
                                    tempUpload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                                    tempUpload.Save()
                                End If
                                If Not tempUpload.FileNotificationHandled Then
                                    UploadFileEmailClass.makeTeamemail(ex, tempUpload, UploadNotificationMailType.UploadFailed)
                                End If

                            Next
                        End If
                        Throw ex
                    Catch innerEx As Exception
                        'TODO: Log error
                        Throw innerEx
                    End Try
                Finally
                    Dim currentUploads As UploadFileCollection = Nothing
                    Dim sessionUploads As UploadFileCollection = TryCast(Context.Session("SessionUploads"), UploadFileCollection)
                    currentUploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
                    If Not currentUploads Is Nothing AndAlso Not sessionUploads Is Nothing Then
                        For Each myUpload As UploadFile In currentUploads
                            sessionUploads.Add(myUpload)
                        Next
                    End If
                    Context.Session("SessionUploads") = sessionUploads
                    Context.Session("MyUploads") = Nothing
                    Context.Session("MyUploads") = New UploadFileCollection()
                    Response.Redirect("upload.aspx")
                End Try
            End If
        End If
    End Sub
#End Region
#Region " Helper Methods "
    ''' <summary>Helper method to resolve uploadstateid to a display name.</summary>
    ''' <param name="id"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetStateDisplayName(ByVal id As Integer) As String
        Dim retVal As String = ""
        Dim uploadStates As UploadStateCollection
        uploadStates = TryCast(Context.Session("UploadStates"), UploadStateCollection)
        For Each state As UploadState In uploadStates
            If state.UploadStateId = id Then
                retVal = state.UploadStateName
                Exit For
            End If
        Next
        Return retVal
    End Function
#End Region

End Class
