
Public MustInherit Class UploadFileStateProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFileStateProvider
    Private Const mProviderName As String = "UploadFileStateProvider"
    Public Shared ReadOnly Property Instance() As UploadFileStateProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFileStateProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadFileStateByUploadFileID(ByVal id As Integer) As UploadFileState
    Public MustOverride Function SelectUploadFileState(ByVal id As Integer) As UploadFileState
    'Public MustOverride Function SelectAllUploadFileStates() As UploadFileStateCollection
    Public MustOverride Function InsertUploadFileState(ByVal instance As UploadFileState) As Integer
    Public MustOverride Sub UpdateUploadFileState(ByVal instance As UploadFileState)
    Public MustOverride Sub DeleteUploadFileState(ByVal id As Integer)
End Class

