Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class DataEntryNavigatorTreeCollection
    Inherits BusinessListBase(Of DataEntryNavigatorTreeCollection, DataEntryNavigatorTree)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As DataEntryNavigatorTree = DataEntryNavigatorTree.NewDataEntryNavigatorTree
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

#End Region

End Class

