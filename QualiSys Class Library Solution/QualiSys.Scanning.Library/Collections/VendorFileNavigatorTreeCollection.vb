Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorFileNavigatorTreeCollection
    Inherits BusinessListBase(Of VendorFileNavigatorTreeCollection, VendorFileNavigatorTree)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As VendorFileNavigatorTree = VendorFileNavigatorTree.NewVendorFileNavigatorTree
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

End Class

