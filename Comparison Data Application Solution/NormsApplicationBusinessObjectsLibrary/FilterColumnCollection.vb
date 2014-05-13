Public Class FilterColumnCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As FilterColumn
        Get
            Return DirectCast(MyBase.List(index), FilterColumn)
        End Get
    End Property

    Public Function Add(ByVal item As FilterColumn) As Integer
        Return MyBase.List.Add(item)
    End Function

End Class
