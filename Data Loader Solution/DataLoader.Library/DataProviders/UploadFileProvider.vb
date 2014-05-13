
Public MustInherit Class UploadFileProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFileProvider
    Private Const mProviderName As String = "UploadFileProvider"
    Public Shared ReadOnly Property Instance() As UploadFileProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFileProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadFile(ByVal id As Integer) As UploadFile
    Public MustOverride Function SelectAllUploadFiles() As UploadFileCollection
    Public MustOverride Function InsertUploadFile(ByVal instance As UploadFile) As Integer
    Public MustOverride Sub UpdateUploadFile(ByVal instance As UploadFile)
    Public MustOverride Sub DeleteUploadFile(ByVal id As Integer)
    Public MustOverride Function CanRestoreUbandonedFile(ByVal id As Integer) As UploadFile.RestoreRequestReturned
End Class
