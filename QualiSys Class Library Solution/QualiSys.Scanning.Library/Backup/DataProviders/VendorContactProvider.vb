Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorContactProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorContactProvider
	Private Const mProviderName As String = "VendorContactProvider"
	Public Shared ReadOnly Property Instance() As VendorContactProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of VendorContactProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectVendorContact(ByVal vendorContactId As Integer) As VendorContact
	Public MustOverride Function SelectAllVendorContacts() As VendorContactCollection
    Public MustOverride Function SelectAllVendorContactsByVendor(ByVal vendorId As Integer) As VendorContactCollection
    Public MustOverride Function InsertVendorContact(ByVal instance As VendorContact) As Integer
	Public MustOverride Sub UpdateVendorContact(ByVal instance As VendorContact)
	Public MustOverride Sub DeleteVendorContact(ByVal VendorContact As VendorContact)
End Class

