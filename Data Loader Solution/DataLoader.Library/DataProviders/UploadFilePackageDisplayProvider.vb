
Public MustInherit Class UploadFilePackageDisplayProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFilePackageDisplayProvider
    Private Const mProviderName As String = "UploadFilePackageDisplayProvider"
    Public Shared ReadOnly Property Instance() As UploadFilePackageDisplayProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFilePackageDisplayProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function GetByStudiesAndDateRange(ByVal StudyList As String, ByVal StartDate As Date, ByVal EndDate As Date) As UploadFilePackageDisplayCollection
End Class
