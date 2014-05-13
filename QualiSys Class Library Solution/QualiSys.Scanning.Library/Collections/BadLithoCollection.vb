Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class BadLithoCollection
    Inherits BusinessListBase(Of BadLithoCollection, BadLitho)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As BadLitho = BadLitho.NewBadLitho
        Add(newObj)
        Return newObj

    End Function

#End Region

End Class

