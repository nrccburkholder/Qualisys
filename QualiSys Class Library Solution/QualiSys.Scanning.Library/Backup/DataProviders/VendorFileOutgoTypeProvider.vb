Imports NRC.Framework.BusinessLogic

Public MustInherit Class VendorFileOutgoTypeProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorFileOutgoTypeProvider
    Private Const mProviderName As String = "VendorFileOutgoTypeProvider"

    Public Shared ReadOnly Property Instance() As VendorFileOutgoTypeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileOutgoTypeProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public MustOverride Methods "

    Public MustOverride Function SelectVendorFileOutgoType(ByVal vendorFileOutgoTypeId As Integer) As VendorFileOutgoType
    Public MustOverride Function SelectAllVendorFileOutgoTypes() As VendorFileOutgoTypeCollection
    Public MustOverride Function InsertVendorFileOutgoType(ByVal instance As VendorFileOutgoType) As Integer
    Public MustOverride Sub UpdateVendorFileOutgoType(ByVal instance As VendorFileOutgoType)
    Public MustOverride Sub DeleteVendorFileOutgoType(ByVal VendorFileOutgoType As VendorFileOutgoType)

#End Region

End Class

