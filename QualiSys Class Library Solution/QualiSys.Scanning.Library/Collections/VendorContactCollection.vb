Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorContactCollection
    Inherits BusinessListBase(Of VendorContactCollection, VendorContact)

    Protected Overrides Function AddNewCore() As Object
        Dim contact As VendorContact = VendorContact.NewVendorContact
        Me.Add(contact)
        Return contact
    End Function
End Class

