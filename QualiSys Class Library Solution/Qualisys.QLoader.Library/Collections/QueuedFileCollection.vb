Public Class QueuedFileCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As QueuedFile
        Get
            Return DirectCast(MyBase.List(index), QueuedFile)
        End Get
        Set(ByVal Value As QueuedFile)
            MyBase.List(index) = Value
        End Set
    End Property

    Public Function Add(ByVal file As QueuedFile) As Integer

        Return MyBase.List.Add(file)

    End Function

End Class
