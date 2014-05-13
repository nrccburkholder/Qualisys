Public Class QuestionGroupCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As QuestionGroup
        Get
            Return DirectCast(MyBase.List(index), QuestionGroup)
        End Get
    End Property

    Public Function Add(ByVal item As QuestionGroup) As Integer
        Return MyBase.List.Add(item)
    End Function

End Class
