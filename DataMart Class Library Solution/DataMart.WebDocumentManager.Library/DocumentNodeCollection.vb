Public Class DocumentNodeCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As DocumentNode
        Get
            Return DirectCast(MyBase.List(index), DocumentNode)
        End Get
    End Property

    Public Function Add(ByVal node As DocumentNode) As Integer
        Return MyBase.List.Add(node)
    End Function


End Class
