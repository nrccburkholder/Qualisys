Public Class QuestionsCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Question
        Get
            Return DirectCast(MyBase.List(index), Question)
        End Get
    End Property

    Public Function Add(ByVal Qstn As Question) As Integer
        Return MyBase.List.Add(Qstn)
    End Function

    Public Function Remove(ByVal Qstn As Question) As Integer
        For Each item As Object In Me
            If DirectCast(item, Question) Is Qstn Then MyBase.List.Remove(item)
        Next
    End Function
End Class
