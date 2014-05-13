Imports System.Text
Imports System.Collections.Generic
Imports NRC.Qualisys.QLoader.Library
Imports NRC.DataLoader.Library
Imports NRC.DataLoader.ParseBackSlashAndSpace

Partial Public Class UploadQueueAjax
    Inherits WebErrorTrappingBaseClass
    Private SaveState As String = ""

    ''' <summary>Load event Check the AjaxServerFlag request variable to determine which logic to execute.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim serverFlag As String = ""
        Dim returnHTML As StringBuilder = New StringBuilder()
        Dim errors As List(Of String) = New List(Of String)
        If Not Context.Request("AjaxServerFlag") Is Nothing Then
            serverFlag = Context.Request("AjaxServerFlag").ToUpper
        End If

        Try
            Dim UseErrorMessage As Boolean = IsPackageQueued()
            Select Case serverFlag
                Case "ADDUPLOAD"
                    If Not UseErrorMessage Then
                        UpdateQueue()
                    End If
                Case "DELETEQUEUE"
                    DeleteAll()
                Case "DELETEQUEUEITEM"
                    DeleteQueue()
                Case "PRESAVEQUEUE"
                    errors = Presavequeuedfiles()
            End Select
            returnHTML = WriteQueueTable(errors)
            If Not UseErrorMessage Then
                Response.Write(returnHTML.ToString)
            Else
                Response.Write("~~" & returnHTML.ToString)
            End If
        Catch ex As System.Exception
            'TODO:  Implement error handling.
            SessionInformation.LastException = ex
            Response.Write("~ We were unable to add/delete/clear the files.  Please attempt to reload your file.  If you continue to experience difficulty please contact: MySolutionsExceptions@nationalresearch.com")
        End Try
    End Sub


    ''' <summary>This method will Check To see if the package file and file type combination is already in the update grid.</summary>
    ''' <returns>A Boolean Value.</returns>
    ''' <CreatedBy>Brock Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function IsPackageQueued() As Boolean
        Dim UseErrorMessage As Boolean = False
        Dim uploads As New UploadFileCollection
        Dim packageIDs As String() = Split(Context.Request.Form("selectedPackageIDs"), ",")
        Dim currentFileID As Integer = Integer.Parse(Request.Form("CurrentFileID"))
        Dim fileName As String = Server.HtmlDecode(Context.Request.Form("FileControl" & currentFileID))
        Dim fileTypeID As Integer = Integer.Parse(Context.Request.Form("SelectedFileType"))
        uploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
        Dim x As Integer = 0
        If Not uploads Is Nothing Then
            For Each upload As UploadFile In uploads
                If upload.OrigFileName = fileName And upload.UploadAction.UploadActionId = CInt(fileTypeID) Then
                    For Each id As String In packageIDs
                        If (Context.Request.Form("Package" & id) = "on") Then
                            Dim PackageCollect As New UploadFilePackageCollection
                            PackageCollect = upload.UploadFilePackages
                            Dim Item As UploadFilePackage
                            For Each Item In PackageCollect
                                If id.ToString = Item.Package.PackageID.ToString Then
                                    'there is a match 
                                    UseErrorMessage = True
                                    Exit For
                                End If
                            Next
                        End If
                        If UseErrorMessage Then
                            Exit For
                        End If
                    Next
                End If

                If UseErrorMessage Then
                    Exit For
                End If
            Next
        End If
        Return UseErrorMessage
    End Function
    ''' <summary>This method will save each upload (prior to uploading any files) stored in the 'MyUploads' session variable.</summary>
    ''' <returns>A list of any errors that may have occurred.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function Presavequeuedfiles() As List(Of String)
        Dim uploads As UploadFileCollection
        Dim saveErrors As List(Of String) = New List(Of String)
        Dim errorCount As Integer = 0
        uploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
        If uploads Is Nothing Then
            'This is an error at least one file should be included in the queue.
            saveErrors.Add("There are no files in the queue to save.")
            SaveState = "FALSE"
        Else
            Try
                For Each upload As UploadFile In uploads
                    Try
                        upload.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadQueued)
                        upload.Save()
                        'TODO:  How do statuses now update.                    
                    Catch ex As Exception
                        'TODO:  Remove upload from collection.
                        errorCount += 1
                        saveErrors.Add("File: " & upload.FileName & " encountered the following error:<br />" & ex.Message)
                    End Try
                Next
                If errorCount = 0 Then
                    Me.SaveState = "TRUE"
                ElseIf errorCount = uploads.Count Then
                    Me.SaveState = "FALSE"
                Else
                    Me.SaveState = "CONFIRM"
                End If
            Catch ex As Exception
                Context.Session("MyUploads") = Nothing
            End Try
        End If
        Return saveErrors
    End Function
    ''' <summary>Takes the variable passed into the request object to create a new upload object and add it to the session collection.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UpdateQueue()
        Dim uploads As UploadFileCollection
        Dim currentFileID As Integer = Integer.Parse(Request.Form("CurrentFileID"))
        Dim fileName As String = Server.HtmlDecode(Context.Request.Form("FileControl" & currentFileID))
        Dim notes As String = Server.HtmlDecode(Context.Request.Form("SelectedNotes"))
        Dim fileTypeID As Integer = Integer.Parse(Context.Request.Form("SelectedFileType"))
        Dim projectManagerID As Integer = Val(Context.Request.Form("SelectedProjectManagerID"))
        Dim packageIDs As String() = Split(Context.Request.Form("selectedPackageIDs"), ",")
        'TP 20080407 Add in the real business objects.
        If CurrentUser.SelectedGroup Is Nothing Then
            Throw New Exception("A Group Account MUST be selected to upload a file.")
        End If

        uploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
        If uploads Is Nothing Then
            uploads = New UploadFileCollection
        End If
        Dim upload As UploadFile = UploadFile.NewUploadFile
        upload.ClientFileId = currentFileID
        upload.OrigFileName = fileName
        upload.UserNotes = notes
        upload.UploadAction = UploadAction.Get(fileTypeID)
        upload.UploadFileState = UploadFileState.NewUploadFileState
        upload.GroupID = CurrentUser.SelectedGroup.GroupId
        upload.MemberId = CurrentUser.Member.MemberId
        If upload.UploadFilePackages Is Nothing Then upload.UploadFilePackages = New UploadFilePackageCollection()

        If upload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then

            'Existing Code; Go thru list of packages and determine if they were selected; if so, add them to uploadfilepackages
            For Each id As String In packageIDs
                If (Context.Request.Form("Package" & id) = "on") Then
                    Dim uploadPackage As UploadFilePackage = UploadFilePackage.NewUploadFilePackage
                    Dim dtsPackage As NRC.Qualisys.QLoader.Library.DTSPackage = NRC.Qualisys.QLoader.Library.DTSPackage.GetPackageByID(id)
                    uploadPackage.Package = dtsPackage
                    upload.UploadFilePackages.Add(uploadPackage)
                End If
            Next

        ElseIf upload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
            upload.ProjectManager = Library.ProjectManager.GetByMemberID(projectManagerID)
        End If

        uploads.Add(upload)
        Context.Session("MyUploads") = uploads
    End Sub
    ''' <summary>Deletes the 'MyUploads' upload object collection from the session.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DeleteAll()
        Context.Session("MyUploads") = Nothing
    End Sub
    ''' <summary>Takes the passed in file ID and removes it from the 'MyUploads' session collection.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DeleteQueue()
        Dim currentFileID As Integer = Val(Context.Request("CurrentFileID"))
        Dim uploads As UploadFileCollection
        uploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
        For i As Integer = 0 To uploads.Count - 1
            If uploads(i).ClientFileId = currentFileID Then
                uploads.RemoveAt(i)
                Exit For
            End If
        Next
    End Sub
    ''' <summary>This method defines the HTML response for all ajax calls to this page.</summary>
    ''' <param name="errors">If any error message exist in this collection, it will be displayed in the return table.</param>
    ''' <returns>The string representing the return HTML of the page.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function WriteQueueTable(ByVal errors As List(Of String)) As StringBuilder
        Dim sb As StringBuilder = New StringBuilder
        Dim uploads As UploadFileCollection
        uploads = TryCast(Context.Session("MyUploads"), UploadFileCollection)
        'Return values get pipped to the beginning of the return string.
        If Me.SaveState <> "" Then
            sb.AppendLine(Me.SaveState & "|")
        End If
        sb.AppendLine(" <br/><div id='pnlFileInfoHeader' class='PanelTitle'>File Queue</div> ")
        sb.AppendLine("<table class='PropertyTable'>")
        'write out any errors that were encountered.
        If errors.Count > 0 Then
            sb.AppendLine("<tr>")
            sb.AppendLine("     <td colspan='5' style='font-color: #ff0000' align='center'>")
            sb.Append("The following errors have occurred.")
            sb.Append("         </td>")
            sb.AppendLine("</tr>")
            For Each err As String In errors
                sb.AppendLine("<tr>")
                sb.AppendLine("     <td colspan='5' style='font-color: #ff0000'>")
                sb.Append(err)
                sb.Append("</td>")
                sb.AppendLine("</tr>")
            Next
        End If
        If Not uploads Is Nothing AndAlso uploads.Count > 0 Then
            sb.AppendLine("<tr>")
            sb.AppendLine("    <td class='PropertyLabel1'>")
            sb.AppendLine("    File Name</td>")
            sb.AppendLine("    <td  class='PropertyLabel1'>")
            sb.AppendLine("    File Type</td>")
            sb.AppendLine("    <td class='PropertyLabel1'>")
            sb.AppendLine("    Selected Package(s) or <br />Measurement Services Manager</td>")
            sb.AppendLine("    <td class='PropertyLabel1'>")
            sb.AppendLine("    Notes</td>")
            sb.AppendLine("    <td class='PropertyLabel1'>")
            sb.AppendLine("    Remove</td>")
            sb.AppendLine("</tr>")
            Dim uploadIDs As String = ""
            For Each upload As UploadFile In uploads
                uploadIDs += upload.ClientFileId & ","
                Dim newparse As New ParseBackSlashAndSpace
                Dim NewFileNameField As String = newparse.ParseBackSlash(upload.OrigFileName)
                sb.AppendLine("<tr>")
                sb.AppendLine("    <td class='PropertyValue' align='left' width = '325'>" & NewFileNameField & "</td>")
                sb.AppendLine("    <td class='PropertyValue' width = '150' >" & upload.UploadAction.UploadActionName & "</td>")
                sb.AppendLine("    <td class='PropertyValue' align='left' width = '350'>")
                sb.AppendLine(upload.GetFileTypeActionDisplayString("<br/>"))
                sb.AppendLine("    </td>")
                sb.AppendLine("    <td class='PropertyValue' align='left'>")
                sb.AppendLine("        <textarea name='Notes" & upload.ClientFileId & "' size='2' style='width: 248px'>" & upload.UserNotes & "</textarea>")
                sb.AppendLine("    </td>")
                sb.AppendLine("    <td class='PropertyValue' align='center' width = '15'>")
                'sb.AppendLine("        <input type='submit' alt='Delete This Queued Item' width='21' height='21' vspace='5' hspace='5' src='img/icon_trash.gif' name='DeleteQueue" & upload.ClientFileId & "' value='X' onclick='DeleteQueueItem(" & upload.ClientFileId & ")' />")
                sb.AppendLine("        <a href = 'javascript:DeleteQueueItem(" & upload.ClientFileId & ")' name='DeleteQueue" & upload.ClientFileId & "' onkeyup='checkLimit(this)'><img alt='Delete This Queued Item' width='21' height='21' vspace='5' hspace='5' src='img/icon_trash.gif'  value='X'  border = '0' /></a>")
                sb.AppendLine("    </td>")
                sb.AppendLine("</tr>")
            Next
            If uploadIDs.Length > 0 Then
                uploadIDs = uploadIDs.Substring(0, uploadIDs.Length - 1)
            End If
            sb.AppendLine("<tr>")
            sb.AppendLine("    <td align='left' colspan='5' style='height: 21px'>")
            sb.Append("<input type='hidden' name='CurrentUploadIDs' value='" & uploadIDs & "' />")
            sb.AppendLine("        <input type='button' name='ClearQueue' value='Clear All Queued Files' onclick='javascript:DeleteQueue()'/>&nbsp;<input type='button' name='UploadQueue' value='Upload All Queued Files' onclick='javascript:UploadQueuedFiles()'/>")

            sb.AppendLine("    </td>")
            sb.AppendLine("</tr>")
        Else
            sb.AppendLine("<tr><td align='center'><br />No files have been selected<br/>")
        End If
        sb.AppendLine("</table>")
        Return sb
    End Function
End Class
