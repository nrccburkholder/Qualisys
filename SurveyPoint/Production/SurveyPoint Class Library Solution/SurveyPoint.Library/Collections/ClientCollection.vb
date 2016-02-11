Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ClientCollection
    Inherits BusinessListBase(Of ClientCollection, Client)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As Client = Client.NewClient
        Me.Add(newObj)
        Return newObj
    End Function
End Class

