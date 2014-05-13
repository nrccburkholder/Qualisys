Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class VendorFileOutgoTypeCollection
	Inherits BusinessListBase(Of VendorFileOutgoTypeCollection , VendorFileOutgoType)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorFileOutgoType = VendorFileOutgoType.NewVendorFileOutgoType
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

