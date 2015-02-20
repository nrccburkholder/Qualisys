Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class EmailBlastOptionCollection
    Inherits BusinessListBase(Of EmailBlastOptionCollection, EmailBlastOption)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As EmailBlastOption = EmailBlastOption.NewEmailBlastOption
        Me.Add(newObj)
        Return newObj

    End Function

End Class

