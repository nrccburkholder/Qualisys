Public Class DocumentCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Document
        Get
            Return DirectCast(MyBase.List(index), Document)
        End Get
    End Property

    Public Function Add(ByVal doc As Document) As Integer
        Return MyBase.List.Add(doc)
    End Function

End Class
