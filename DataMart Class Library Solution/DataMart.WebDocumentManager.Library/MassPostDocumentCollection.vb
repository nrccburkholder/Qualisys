Public Class MassPostDocumentCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As MassPostDocument
        Get
            Return DirectCast(MyBase.List(index), MassPostDocument)
        End Get
    End Property

    Public Function Add(ByVal doc As MassPostDocument) As Integer
        Return MyBase.List.Add(doc)
    End Function

    Public Function Copy() As MassPostDocumentCollection
        Dim newCollection As New MassPostDocumentCollection
        For Each mpd As MassPostDocument In Me
            newCollection.Add(mpd)
        Next
        Return newCollection
    End Function

End Class
