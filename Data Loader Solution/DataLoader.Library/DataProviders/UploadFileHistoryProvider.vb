'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************


Public MustInherit Class UploadFileHistoryProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFileHistoryProvider
    Private Const mProviderName As String = "UploadFilePackageProvider"
    Public Shared ReadOnly Property Instance() As UploadFileHistoryProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFileHistoryProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectUploadFilesByGroupId(ByVal groupid As Integer) As UploadFileHistoryCollection
End Class

