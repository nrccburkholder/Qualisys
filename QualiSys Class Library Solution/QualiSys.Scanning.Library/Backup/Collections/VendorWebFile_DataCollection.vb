Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorWebFile_DataCollection
	Inherits BusinessListBase(Of VendorWebFile_DataCollection , VendorWebFile_Data)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorWebFile_Data = VendorWebFile_Data.NewVendorWebFile_Data
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

