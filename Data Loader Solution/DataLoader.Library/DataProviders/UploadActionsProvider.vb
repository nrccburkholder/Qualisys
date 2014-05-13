Public MustInherit Class UploadActionsProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadActionsProvider
    Private Const mProviderName As String = "UploadActionsProvider"
    Public Shared ReadOnly Property Instance() As UploadActionsProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadActionsProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadAction(ByVal uploadActionId As Integer) As UploadAction
    Public MustOverride Function SelectAllUploadActions() As UploadActionCollection
    'Public MustOverride Function InsertUploadAction(ByVal instance As UploadAction) As Integer
    'Public MustOverride Sub UpdateUploadAction(ByVal instance As UploadAction)
    'Public MustOverride Sub DeleteUploadAction(ByVal uploadActionId As Integer)
End Class

