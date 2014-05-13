Public Class SurveysCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Survey
        Get
            Return DirectCast(MyBase.List(index), Survey)
        End Get
    End Property

    Public Function Add(ByVal srvy As Survey) As Integer
        Return MyBase.List.Add(srvy)
    End Function

    Public Function Remove(ByVal srvy As Survey) As Integer
        For Each item As Object In Me
            If DirectCast(item, Survey) Is srvy Then MyBase.List.Remove(item)
        Next
    End Function
End Class
