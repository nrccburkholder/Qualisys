Public Class USComparisonTypeCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As USComparisonType
        Get
            Return DirectCast(MyBase.List(index), USComparisonType)
        End Get
    End Property

    Public Function Add(ByVal comparison As USComparisonType) As Integer
        Return MyBase.List.Add(comparison)
    End Function

    Public Sub Remove(ByVal comparison As USComparisonType)
        MyBase.List.Remove(comparison)
    End Sub

    Public Function Contains(ByVal comparison As USComparisonType) As Boolean
        Return MyBase.List.Contains(comparison)
    End Function
End Class
