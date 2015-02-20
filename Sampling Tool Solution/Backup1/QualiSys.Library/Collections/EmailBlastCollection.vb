Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class EmailBlastCollection
    Inherits BusinessListBase(Of EmailBlastCollection, EmailBlast)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As EmailBlast = EmailBlast.NewEmailBlast
        Me.Add(newObj)
        Return newObj

    End Function

End Class

