Public Class TabCollection
    Inherits ObjectModel.Collection(Of Tab)

    Public Event TabAdded As EventHandler

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As Tab)
        MyBase.InsertItem(index, item)
        OnTabAdded(New EventArgs)
    End Sub

    Protected Sub OnTabAdded(ByVal e As EventArgs)
        RaiseEvent TabAdded(Me, e)
    End Sub

End Class
