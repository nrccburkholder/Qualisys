Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorFile_VoviciDetailCollection
	Inherits BusinessListBase(Of VendorFile_VoviciDetailCollection , VendorFile_VoviciDetail)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VendorFile_VoviciDetail = VendorFile_VoviciDetail.NewVendorFile_VoviciDetail
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

