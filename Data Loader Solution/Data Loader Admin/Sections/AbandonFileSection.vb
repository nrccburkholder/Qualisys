Imports Nrc.DataLoader.Library
Imports System.Text
Public Class AbandonFileSection
    ''' <summary>Retrieves upload record information for displaying in confirmation dialog.</summary>
    ''' <param name="UploadFileToRestore"></param>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Shared Function GetConfirmQuestion(ByVal UploadFileToRestore As UploadFile) As String
        Dim ConfirmQuestion As New StringBuilder()
        Dim memberName As String = Nrc.NRCAuthLib.Member.GetMember(UploadFileToRestore.MemberId).FullName
        ConfirmQuestion.AppendLine("UploadFile_id: " & UploadFileToRestore.Id)
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("Original File Name: " & System.IO.Path.GetFileName(UploadFileToRestore.OrigFileName))
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("Uploaded By: " & memberName)
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("Upload Status: " & UploadFileToRestore.UploadFileState.StateOfUpload.UploadStateName)
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("Associated packages: ")
        Dim packageList As New StringBuilder
        For Each pkg As UploadFilePackage In UploadFileToRestore.UploadFilePackages
            ConfirmQuestion.AppendLine(vbTab & pkg.Package.PackageFriendlyName & " (" & pkg.Package.PackageID & ")")
        Next
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("Status last modified date: " & UploadFileToRestore.UploadFileState.datOccurred.ToString)
        ConfirmQuestion.AppendLine()
        ConfirmQuestion.AppendLine("User Notes: " & UploadFileToRestore.UserNotes)
        Return ConfirmQuestion.ToString
    End Function

    ''' <summary>Before actually abandoning the users must confirm the abandon operation 
    ''' ConfirmAndSave() provides all the information needed to confirm. If the user clicks OK on 
    ''' the confirmation dialog then ConfirmAndSave() abandons the file and notifies the user about it.</summary>
    ''' <param name="UploadFileToAbandon"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ConfirmAndSave(ByVal UploadFileToAbandon As UploadFile)
        Dim ConfirmQuestion As String = GetConfirmQuestion(UploadFileToAbandon)

        Dim dlgConfirm As New ConfirmationDialog("You are about to abandon file " & UploadFileToAbandon.FileName, ConfirmQuestion)
        If dlgConfirm.ShowDialog() = DialogResult.OK Then
            Try
                UploadFileToAbandon.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.UploadAbandoned)
                UploadFileToAbandon.UploadFileState.StateParameter = "Abandoned by " & CurrentUser.DisplayName
                UploadFileToAbandon.UploadFileState.datOccurred = Now()
                UploadFileToAbandon.Save()
            Catch ex As Exception
                Message = "Failed to abandon the uploaded file record with provided id (" & UploadFileToAbandon.Id & ")."
                Me.pbStatus.Image = My.Resources.Redlight
                Message = Message & vbCrLf & ex.Message
            End Try

            Message = "File " & UploadFileToAbandon.FileName & " is successfuly abandoned."
            Me.pbStatus.Image = My.Resources.Greenlight
        End If
    End Sub

    ''' <summary>Abandons the uploaded file with the provided id. If the UploadFile_id is not provided
    ''' the user gets notified about it via the status message.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub Abandon()
        If String.IsNullOrEmpty(Me.txtUploadFileID.Text) Then
            Message = "Please enter an UploadFile_id to abandon"
            Me.pbStatus.Image = My.Resources.Yellowlight
            Exit Sub
        End If
        Dim id As Integer = CInt(Me.txtUploadFileID.Text)
        Dim UploadFileToAbandon As UploadFile = UploadFile.Get(id)
        If UploadFileToAbandon Is Nothing Then
            Message = "Could not find an uploaded file record with provided id (" & id & ")."
            Me.pbStatus.Image = My.Resources.Redlight
            Exit Sub
        Else
            If UploadFileToAbandon.UploadFileState.StateOfUpload.UploadStateName = UploadState.AvailableStates.UploadAbandoned.ToString Then
                Message = "The uploaded file record with provided id (" & id & ") is already abandoned."
                Me.pbStatus.Image = My.Resources.Redlight
                Exit Sub
            End If
            ConfirmAndSave(UploadFileToAbandon)
        End If
    End Sub
    ''' <summary>Handles Abandon button Click event. 
    ''' Resets the status message and tries to abandon the uploaded file.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub btnAbandon_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAbandon.Click
        Me.pbStatus.Visible = False
        Message = ""
        Abandon()
        Me.lblMessage.Visible = Not String.IsNullOrEmpty(Message)
        Me.pbStatus.Visible = Me.lblMessage.Visible
        Me.lblMessage.Refresh()
    End Sub
    ''' <summary>Keeps the status message for Abandon</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Message() As String
        Get
            Return Me.lblMessage.Text
        End Get
        Set(ByVal value As String)
            Me.lblMessage.Text = value
        End Set
    End Property

    ''' <summary>Event handler for Restore button.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub btnRestore_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRestore.Click
        Me.pbStatus.Visible = False
        Message = ""
        Restore()
        Me.lblMessage.Visible = Not String.IsNullOrEmpty(Message)
        Me.pbStatus.Visible = Me.lblMessage.Visible
        Me.lblMessage.Refresh()
    End Sub

    Private Sub ConfirmAndRestore(ByVal UploadFileToRestore As UploadFile)
        Dim ConfirmQuestion As String = GetConfirmQuestion(UploadFileToRestore)

        Dim dlgConfirm As New ConfirmationDialog("You are about to restore file " & UploadFileToRestore.FileName, ConfirmQuestion)
        If dlgConfirm.ShowDialog() = DialogResult.OK Then
            Try
                UploadFileToRestore.UploadFileState.StateOfUpload = UploadState.GetByName(UploadState.AvailableStates.Uploaded)
                UploadFileToRestore.UploadFileState.StateParameter = "Restored by " & CurrentUser.DisplayName
                UploadFileToRestore.UploadFileState.datOccurred = Now()
                UploadFileToRestore.Save()
            Catch ex As Exception
                Message = "Failed to restore the abandoned file record with provided id (" & UploadFileToRestore.Id & ")."
                Me.pbStatus.Image = My.Resources.Redlight
                Message = Message & vbCrLf & ex.Message
            End Try

            Message = "File " & UploadFileToRestore.FileName & " is successfuly restored."
            Me.pbStatus.Image = My.Resources.Greenlight
        End If
    End Sub
    ''' <summary>Builds an error message if restoring an upload encounters an error</summary>
    ''' <param name="UploadToRestore"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub NotifyError(ByVal UploadToRestore As UploadFile)
        If UploadToRestore.UploadFileState.StateOfUpload.UploadStateName = UploadState.AvailableStates.Uploaded Then
            Message = "The uploaded file record with provided id (" & UploadToRestore.Id & ") is in ''uploaded'' state." & vbCrLf & _
            "Nothing to restore since the file is not currently abandoned."
            Me.pbStatus.Image = My.Resources.Yellowlight
            Exit Sub
        End If
        Me.pbStatus.Image = My.Resources.Redlight
        Select Case UploadToRestore.CanRestore
            Case UploadFile.RestoreRequestReturned.FileIsNotUploaded
                Message = "The uploaded file record with provided id (" & UploadToRestore.Id & ") has never been uploaded."
            Case UploadFile.RestoreRequestReturned.FileIsNotAbandoned
                Message = "The uploaded file record with provided id (" & UploadToRestore.Id & ") has never been abandoned."
        End Select
    End Sub
    ''' <summary>Restores an upload</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub Restore()
        'MsgBox("Restore functionality will be implemented in the near future.")
        If String.IsNullOrEmpty(Me.txtUploadFileID.Text) Then
            Message = "Please enter an UploadFile_id to restore"
            Me.pbStatus.Image = My.Resources.Yellowlight
            Exit Sub
        End If
        Dim id As Integer = CInt(Me.txtUploadFileID.Text)
        Dim UploadFileToRestore As UploadFile = UploadFile.Get(id)
        If UploadFileToRestore Is Nothing Then
            Message = "Could not find an uploaded file record with provided id (" & id & ")."
            Me.pbStatus.Image = My.Resources.Redlight
            Exit Sub
        Else
            If UploadFileToRestore.CanRestore = UploadFile.RestoreRequestReturned.CanRestore Then
                ConfirmAndRestore(UploadFileToRestore)
            Else
                NotifyError(UploadFileToRestore)
            End If
        End If
    End Sub
End Class
