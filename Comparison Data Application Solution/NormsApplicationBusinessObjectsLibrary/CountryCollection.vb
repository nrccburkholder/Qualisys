Public Class CountryCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Country
        Get
            Return DirectCast(MyBase.List(index), Country)
        End Get
    End Property

    Public Function Add(ByVal newCountry As Country) As Integer
        Return MyBase.List.Add(newCountry)
    End Function

End Class
