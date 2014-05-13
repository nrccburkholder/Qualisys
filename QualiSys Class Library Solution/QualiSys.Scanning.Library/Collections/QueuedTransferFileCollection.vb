Public Class QueuedTransferFileCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As QueuedTransferFile
        Get
            Return DirectCast(MyBase.List(index), QueuedTransferFile)
        End Get
        Set(ByVal value As QueuedTransferFile)
            MyBase.List(index) = value
        End Set
    End Property

    Public Function Add(ByVal file As QueuedTransferFile) As Integer

        Return MyBase.List.Add(file)

    End Function

End Class
