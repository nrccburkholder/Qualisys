Imports NRC.DataLoader.Library
Imports NRC.Qualisys.QLoader.Library
Imports NRC.NRCAuthLib
Public Enum UploadNotificationMailType
    UploadSuccessful
    UploadFailed
End Enum
Public Class EmailInfoCollection
    Inherits List(Of eMailInfo)
    Public mUploadedFile As UploadFile
    Public Sub New(ByVal UploadedFile As UploadFile, ByVal eMailType As UploadNotificationMailType, ByVal PMorPack As String)
        mUploadedFile = UploadedFile
        If UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
            For Each pkg As UploadFilePackage In UploadedFile.UploadFilePackages
                Me.Add(New eMailInfo(pkg, eMailType, UploadedFile))
            Next
        ElseIf UploadedFile.UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
            Me.Add(New eMailInfo(UploadedFile.ProjectManager, eMailType, UploadedFile))
        End If

    End Sub
    Public Sub New(ByVal UploadedFile As UploadFile, ByVal eMailType As UploadNotificationMailType)

    End Sub
End Class
