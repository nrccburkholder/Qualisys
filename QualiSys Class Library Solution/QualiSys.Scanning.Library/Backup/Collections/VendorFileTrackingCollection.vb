Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class VendorFileTrackingCollection
	Inherits BusinessListBase(Of VendorFileTrackingCollection , VendorFileTracking)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorFileTracking = VendorFileTracking.NewVendorFileTracking
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

