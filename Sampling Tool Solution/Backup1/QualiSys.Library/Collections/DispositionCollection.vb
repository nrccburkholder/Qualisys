Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class DispositionCollection
    Inherits BusinessListBase(Of DispositionCollection, Disposition)

    Protected Overrides Function AddNewCore() As Object
        Dim dispo As Disposition = Disposition.NewDisposition
        Me.Add(dispo)
        Return dispo
    End Function
End Class

