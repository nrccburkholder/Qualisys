Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorCollection
    Inherits BusinessListBase(Of VendorCollection, Vendor)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Vendor = Vendor.NewVendor
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

End Class

