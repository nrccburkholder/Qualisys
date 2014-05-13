
Public MustInherit Class UploadFilePackageProvider

#Region " Singleton Implementation "
    Private Shared mInstance As UploadFilePackageProvider
    Private Const mProviderName As String = "UploadFilePackageProvider"
    Public Shared ReadOnly Property Instance() As UploadFilePackageProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of UploadFilePackageProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    'Public MustOverride Function SelectUploadFilePackage(ByVal id As Integer) As UploadFilePackage
    Public MustOverride Function InsertUploadFilePackage(ByVal instance As UploadFilePackage) As Integer
    Public MustOverride Sub UpdateUploadFilePackage(ByVal instance As UploadFilePackage)
    Public MustOverride Sub DeleteByUploadFile(ByVal uploadFileID As Integer)
    Public MustOverride Sub DeleteUploadFilePackage(ByVal id As Integer)

    Public MustOverride Function SelectUploadFilePackagesByUploadFile(ByVal UploadFile As UploadFile) As UploadFilePackageCollection
End Class
