Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorProvider
    Private Const mProviderName As String = "VendorProvider"

    Public Shared ReadOnly Property Instance() As VendorProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()

    End Sub

	Public MustOverride Function SelectVendor(ByVal vendorId As Integer) As Vendor
    Public MustOverride Function SelectVendorByVendorCode(ByVal vendorCode As String) As Vendor
    Public MustOverride Function SelectAllVendors() As VendorCollection
    Public MustOverride Function InsertVendor(ByVal instance As Vendor) As Integer
    Public MustOverride Sub UpdateVendor(ByVal instance As Vendor)
    Public MustOverride Sub DeleteVendor(ByVal Vendor As Vendor)
    Public MustOverride Function IsUniqueVendorCode(ByVal vendorId As Integer, ByVal vendorCode As String) As Boolean

End Class

