
Public MustInherit Class UploadStatesProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadStatesProvider
    Private Const mProviderName As String = "UploadStatesProvider"
    Public Shared ReadOnly Property Instance() As UploadStatesProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadStatesProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub


    Public MustOverride Function SelectUploadStateByName(ByVal name As String) As UploadState
    Public MustOverride Function SelectUploadState(ByVal uploadStateId As Integer) As UploadState
    Public MustOverride Function SelectAllUploadStates() As UploadStateCollection
    'Public MustOverride Function InsertUploadState(ByVal instance As UploadState) As Integer
    'Public MustOverride Sub UpdateUploadState(ByVal instance As UploadState)
    'Public MustOverride Sub DeleteUploadState(ByVal uploadStateId As Integer)
End Class

