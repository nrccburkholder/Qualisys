
Public MustInherit Class UploadFilePackageNoteDisplayProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFilePackageNoteDisplayProvider
    Private Const mProviderName As String = "UploadFilePackageNoteDisplayProvider"
    Public Shared ReadOnly Property Instance() As UploadFilePackageNoteDisplayProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFilePackageNoteDisplayProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    
    Public MustOverride Function SelectUploadFilePackageNotesByUploadFilePackageIDs(ByVal UploadFilePackageIDs As String) As UploadFilePackageNoteDisplayCollection

End Class
