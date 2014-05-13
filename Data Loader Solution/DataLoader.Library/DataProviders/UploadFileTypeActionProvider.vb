
Public MustInherit Class UploadFileTypeActionProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFileTypeActionProvider
    Private Const mProviderName As String = "UploadFileTypeActionProvider"
    Public Shared ReadOnly Property Instance() As UploadFileTypeActionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFileTypeActionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadFileTypeAction(ByVal id As Integer) As UploadFileTypeAction
    Public MustOverride Function SelectAllUploadFileTypeActions() As UploadFileTypeActionCollection
    Public MustOverride Function InsertUploadFileTypeAction(ByVal instance As UploadFileTypeAction) As Integer
    Public MustOverride Sub UpdateUploadFileTypeAction(ByVal instance As UploadFileTypeAction)
    Public MustOverride Sub DeleteUploadFileTypeAction(ByVal id As Integer)
    Public MustOverride Function SelectUploadFileTypeActionByName(ByVal name As String) As UploadFileTypeAction

End Class

