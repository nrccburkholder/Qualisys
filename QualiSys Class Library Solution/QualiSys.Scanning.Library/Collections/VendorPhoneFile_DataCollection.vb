Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorPhoneFile_DataCollection
	Inherits BusinessListBase(Of VendorPhoneFile_DataCollection , VendorPhoneFile_Data)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorPhoneFile_Data = VendorPhoneFile_Data.NewVendorPhoneFile_Data
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

