Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorFileStatusCollection
    Inherits BusinessListBase(Of VendorFileStatusCollection, VendorFileStatus)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As VendorFileStatus = VendorFileStatus.NewVendorFileStatus
        Me.Add(newObj)
        Return newObj

    End Function

End Class

