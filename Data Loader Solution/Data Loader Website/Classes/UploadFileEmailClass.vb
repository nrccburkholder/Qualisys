Imports NRC.Framework.Notification
Imports NRC.DataLoader.Library
Imports NRC.NRCAuthLib.OrgUnit
Imports NRC.NRCAuthLib
Imports NRC.Framework.BusinessLogic.Configuration

Public Class UploadFileEmailClass

    Private Shared newmess As Boolean = False

    Public Shared ReadOnly Property Status(ByVal Fstatus As Boolean) As String
        Get
            Dim RetStatusString As String = ""
            If Fstatus = True Then
                RetStatusString = "Successful"
            Else
                RetStatusString = "Failed"
            End If
            Return RetStatusString
        End Get
    End Property


    Public Shared Function makeclientsemail()
        newmess = SendClientsEmail()
        Return newmess
    End Function

    Public Shared Function makeemail(ByVal tempUpload As NRC.DataLoader.Library.UploadFile, ByVal eMailType As UploadNotificationMailType)
        newmess = SendEmail(tempUpload, eMailType)
        Return newmess
    End Function

    Public Shared Function makeTeamemail(ByVal exc As Exception, ByVal tempUpload As NRC.DataLoader.Library.UploadFile, ByVal eMailType As UploadNotificationMailType)
        newmess = SendTeamEmail(exc, tempUpload, eMailType)
        Return newmess
    End Function

    Private Shared Function CreateDatatable(ByVal DTType As Integer, ByVal DTName As String) As DataTable
        Dim CreatedDatatable As New DataTable
        If DTType = 0 Then
            CreatedDatatable.TableName = (DTName)
            CreatedDatatable.Columns.Add(New DataColumn("PackagePM"))
            CreatedDatatable.Columns.Add(New DataColumn("StudyID"))
            CreatedDatatable.Columns.Add(New DataColumn("StudyName"))
        ElseIf DTType = 1 Then
            CreatedDatatable.TableName = (DTName)
            CreatedDatatable.Columns.Add(New DataColumn("UploadFile"))
            CreatedDatatable.Columns.Add(New DataColumn("SavedAs"))
            CreatedDatatable.Columns.Add(New DataColumn("FileType"))
            CreatedDatatable.Columns.Add(New DataColumn("PackagePM"))
            CreatedDatatable.Columns.Add(New DataColumn("Notes"))
            CreatedDatatable.Columns.Add(New DataColumn("Status"))
        End If
        Return CreatedDatatable
        CreatedDatatable.Dispose()
    End Function


    Private Shared Function SendEmail(ByVal tempupload As NRC.DataLoader.Library.UploadFile, _
         ByVal eMailType As UploadNotificationMailType) As Boolean
        Dim infos As New EmailInfoCollection(tempupload, eMailType)
        If tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
            infos = New EmailInfoCollection(tempupload, eMailType, UploadFileTypeAction.AvailableActions.Packages)
        ElseIf tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
            infos = New EmailInfoCollection(tempupload, eMailType, UploadFileTypeAction.AvailableActions.ProjectManagers)
        End If
        Dim dt As New DataTable
        dt = CreateDatatable(0, "PMPACKAGES")
        For Each info As eMailInfo In infos
            Dim row As DataRow = dt.NewRow
            If info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                row.Item("PackagePM") = info.UsedDTSPackage.PackageName & " (" & info.UsedDTSPackage.PackageID & ")"
                row.Item("StudyName") = info.StudyName()
                row.Item("StudyID") = info.Study.StudyID()
            ElseIf info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                row.Item("PackagePM") = info.ProjectManager()
                row.Item("StudyName") = "N/A"
                row.Item("StudyID") = "N/A"
            End If
            dt.Rows.Add(row)
        Next
        Dim EMessage As New Framework.Notification.Message("InternalUploadFile", Config.SmtpServer)
        EMessage.ReplacementTables.Add("Packages_Text", dt)
        EMessage.ReplacementTables.Add("Packages_Html", dt)
        EMessage.ReplacementValues.Add("ClientID", CurrentUser.SelectedGroup.OrgUnitId)
        EMessage.ReplacementValues.Add("ClientName", CurrentUser.SelectedGroup.OrgUnit.Name)
        EMessage.ReplacementValues.Add("UserName", infos(0).UserName)
        EMessage.ReplacementValues.Add("UploadDate", infos(0).UploadDate)
        EMessage.ReplacementValues.Add("UploadFile", infos(0).UploadedFile.FileName)
        EMessage.ReplacementValues.Add("Folder", infos(0).UploadedFile.UploadAction.FolderName)
        EMessage.ReplacementValues.Add("FileType", infos(0).UploadedFile.UploadAction.UploadActionName)
        EMessage.ReplacementValues.Add("Status", Status(tempupload.FileStatusSaved))

        Dim enviro As String = ""
        If Config.EnvironmentType = EnvironmentTypes.Production Then
            enviro = ""
            If infos(0).UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                EMessage.ReplacementValues.Add("EmailTo", infos(0).OwnerEmail)
                EMessage.To.Add(New NRC.Framework.Notification.Address(infos(0).OwnerEmail))
            ElseIf infos(0).UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                EMessage.To.Add(New NRC.Framework.Notification.Address(Member.GetMember(infos(0).UploadedFile.ProjectManager.MemberID).EmailAddress))
                EMessage.ReplacementValues.Add("EmailTo", Member.GetMember(infos(0).UploadedFile.ProjectManager.MemberID).EmailAddress)
            End If
            EMessage.ReplacementValues.Add("Notes", tempupload.UserNotes)
            EMessage.ReplacementValues.Add("Environment", "")
        Else
            enviro = Config.EnvironmentName
            If infos(0).UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                EMessage.ReplacementValues.Add("EmailTo", Config.LoadingTeamTestEmailAddress)
                EMessage.To.Add(New NRC.Framework.Notification.Address(Config.LoadingTeamTestEmailAddress))
                Dim emailto As String = String.Empty
                Try
                    emailto = infos(0).OwnerEmail
                Catch ex As Exception
                Finally
                    emailto = Config.LoadingTeamTestEmailAddress
                End Try
                EMessage.ReplacementValues.Add("Notes", tempupload.UserNotes & _
                            "<Br /> EmailTo: " & emailto)
            ElseIf infos(0).UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                EMessage.To.Add(New NRC.Framework.Notification.Address(Config.LoadingTeamTestEmailAddress))
                EMessage.ReplacementValues.Add("EmailTo", Config.LoadingTeamTestEmailAddress)
                EMessage.ReplacementValues.Add("Notes", tempupload.UserNotes & _
                             "<Br /> EmailTo: " & Member.GetMember(infos(0).UploadedFile.ProjectManager.MemberID).EmailAddress)
            End If
            EMessage.ReplacementValues.Add("Environment", enviro)
            EMessage.Bcc.Add(New NRC.Framework.Notification.Address(Config.LoadingTeamTestEmailAddress))
        End If

        EMessage.From = New NRC.Framework.Notification.Address(Config.ClientSupportEmailAddress)

        newmess = EMessage.Send()

        EMessage = Nothing
        infos = Nothing
        dt.Clear()
        dt.Dispose()
        Return newmess
    End Function


    Private Shared Function SendTeamEmail(ByVal exc As Exception, ByVal tempupload As NRC.DataLoader.Library.UploadFile, _
 ByVal eMailType As UploadNotificationMailType) As Boolean
        Dim infos As New EmailInfoCollection(tempupload, eMailType)
        If tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
            infos = New EmailInfoCollection(tempupload, eMailType, UploadFileTypeAction.AvailableActions.Packages)
        ElseIf tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
            infos = New EmailInfoCollection(tempupload, eMailType, UploadFileTypeAction.AvailableActions.ProjectManagers)
        End If
        Dim dt As New DataTable
        dt = CreateDatatable(1, "PMPACKAGES")
        For Each info As eMailInfo In infos
            Dim EMessage As New Framework.Notification.Message("ExternalUploadFile", Config.SmtpServer)
            Dim row As DataRow = dt.NewRow
            If info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                row.Item("PackagePM") = info.UsedDTSPackage.PackageName
            ElseIf info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                row.Item("PackagePM") = info.ProjectManager()
            End If
            row.Item("UploadFile") = info.UploadedFile.OrigFileName
            row.Item("SavedAs") = info.UploadedFile.FileName
            row.Item("FileType") = info.UploadedFile.UploadAction.UploadActionName
            row.Item("Notes") = exc.Message & vbCrLf & exc.StackTrace
            row.Item("Status") = Status(tempupload.FileStatusSaved)
            dt.Rows.Add(row)
            EMessage.ReplacementTables.Add("Uploads_Text", dt)
            EMessage.ReplacementTables.Add("Uploads_Html", dt)
            EMessage.ReplacementValues.Add("ClientID", CurrentUser.SelectedGroup.OrgUnitId)
            EMessage.ReplacementValues.Add("ClientName", CurrentUser.SelectedGroup.OrgUnit.Name)
            EMessage.ReplacementValues.Add("UserName", infos(0).UserName)
            EMessage.ReplacementValues.Add("UploadDate", info.UploadDate)
            Dim enviro As String = ""
            If Config.EnvironmentName <> "Production" Then enviro = Config.EnvironmentName Else enviro = "Production"
            EMessage.ReplacementValues.Add("Environment", enviro)
            EMessage.From = New NRC.Framework.Notification.Address(Config.MySolutionsEmailAddress)
            EMessage.To.Add(New NRC.Framework.Notification.Address(Config.LoadingTeamTestEmailAddress))

            newmess = EMessage.Send()

            If newmess = False Then
                Exit For
            End If
            EMessage = Nothing
            dt.Rows(0).Delete()
        Next
        dt.Dispose()
        infos = Nothing
        Return newmess
    End Function

    Private Shared Function SendClientsEmail() As Boolean
        Dim newlist As New List(Of UploadFile)
        Dim EMessage As New Framework.Notification.Message("ExternalUploadFile", Config.SmtpServer)
        newlist = Library.UploadedFiles.UploadedFileCollection.GetList
        Dim dt As New DataTable
        Dim MemberEmail As New NRC.NRCAuthLib.Member
        dt = CreateDatatable(1, "PMPACKAGES")
        For x As Integer = 0 To newlist.Count - 1
            Dim tempupload As UploadFile = newlist(x)
            Dim UpFileState As UploadNotificationMailType = tempupload.UploadFileState.StateOfUpload.UploadStateId
            Try
                Dim infos As New EmailInfoCollection(tempupload, UpFileState)
                If tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                    infos = New EmailInfoCollection(tempupload, UpFileState, UploadFileTypeAction.AvailableActions.Packages)
                ElseIf tempupload.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                    infos = New EmailInfoCollection(tempupload, UpFileState, UploadFileTypeAction.AvailableActions.ProjectManagers)
                End If
                For Each info As eMailInfo In infos
                    Dim row As DataRow = dt.NewRow
                    If info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
                        row.Item("PackagePM") = info.UsedDTSPackage.PackageFriendlyName()
                    ElseIf info.UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
                        row.Item("PackagePM") = info.ProjectManager()
                    End If
                    row.Item("UploadFile") = info.UploadedFile.OrigFileName
                    row.Item("SavedAs") = info.UploadedFile.FileName
                    row.Item("FileType") = info.UploadedFile.UploadAction.UploadActionName
                    row.Item("Notes") = tempupload.UserNotes
                    row.Item("Status") = Status(tempupload.FileStatusSaved)
                    dt.Rows.Add(row)
                Next

                If x = newlist.Count - 1 Then
                    EMessage.ReplacementValues.Add("UploadDate", infos(0).UploadDate)
                    MemberEmail = NRC.NRCAuthLib.Member.GetMember(infos(0).UploadedFile.MemberId)
                End If
            Catch excs As Exception
            End Try
        Next
        Dim TheUpload As UploadFile = newlist(0)
        EMessage.ReplacementTables.Add("Uploads_Text", dt)
        EMessage.ReplacementTables.Add("Uploads_Html", dt)
        EMessage.ReplacementValues.Add("ClientID", CurrentUser.SelectedGroup.OrgUnitId)
        EMessage.ReplacementValues.Add("ClientName", CurrentUser.SelectedGroup.OrgUnit.Name)
        EMessage.ReplacementValues.Add("UserName", CurrentUser.Name)
        Dim enviro As String = ""
        If Config.EnvironmentName <> "Production" Then enviro = Config.EnvironmentName Else enviro = ""
        EMessage.ReplacementValues.Add("Environment", enviro)
        EMessage.From = New NRC.Framework.Notification.Address(Config.ClientSupportEmailAddress)
        EMessage.To.Add(New NRC.Framework.Notification.Address(MemberEmail.EmailAddress))
        'EMessage.Bcc.Add(New NRC.Framework.Notification.Address(Config.LoadingTeamTestEmailAddress))

        newmess = EMessage.Send()

        newlist = Nothing
        EMessage = Nothing
        dt.Rows(0).Delete()
        Return newmess
    End Function











End Class
