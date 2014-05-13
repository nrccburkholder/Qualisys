
Public MustInherit Class UploadFilePackageNoteProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFilePackageNoteProvider
    Private Const mProviderName As String = "UploadFilePackageNoteProvider"
    Public Shared ReadOnly Property Instance() As UploadFilePackageNoteProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFilePackageNoteProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadFilePackageNote(ByVal id As Integer) As UploadFilePackageNote
    Public MustOverride Function InsertUploadFilePackageNote(ByVal instance As UploadFilePackageNote) As Integer
    Public MustOverride Sub UpdateUploadFilePackageNote(ByVal instance As UploadFilePackageNote)
    Public MustOverride Sub DeleteUploadFilePackageNote(ByVal id As Integer)
    Public MustOverride Function SelectUploadFilePackageNotesByUploadFilePackageIDs(ByVal UploadFilePackageIDs As String) As UploadFilePackageNoteCollection

End Class
