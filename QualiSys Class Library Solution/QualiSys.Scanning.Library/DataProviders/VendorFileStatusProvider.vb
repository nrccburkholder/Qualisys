Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorFileStatusProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorFileStatusProvider
    Private Const mProviderName As String = "VendorFileStatusProvider"
    Public Shared ReadOnly Property Instance() As VendorFileStatusProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileStatusProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectVendorFileStatus(ByVal id As Integer) As VendorFileStatus
    Public MustOverride Function SelectAllVendorFileStatus() As VendorFileStatusCollection
    Public MustOverride Function SelectVendorFileStatusById(ByVal id As Integer) As VendorFileStatusCollection
    Public MustOverride Function InsertVendorFileStatus(ByVal instance As VendorFileStatus) As Integer
    Public MustOverride Sub UpdateVendorFileStatus(ByVal instance As VendorFileStatus)
    Public MustOverride Sub DeleteVendorFileStatus(ByVal VendorFileStatus As VendorFileStatus)
End Class

