Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorFileCreationQueueCollection
	Inherits BusinessListBase(Of VendorFileCreationQueueCollection , VendorFileCreationQueue)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorFileCreationQueue = VendorFileCreationQueue.NewVendorFileCreationQueue
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

