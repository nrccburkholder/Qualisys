Public Class NormUserCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As NormUser
        Get
            Return DirectCast(MyBase.List(index), NormUser)
        End Get
    End Property

    Public Function Add(ByVal item As NormUser) As Integer
        Return MyBase.List.Add(item)
    End Function

End Class
