Public Class QueuedVendorFileCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As QueuedVendorFile
        Get
            Return DirectCast(MyBase.List(index), QueuedVendorFile)
        End Get
        Set(ByVal value As QueuedVendorFile)
            MyBase.List(index) = value
        End Set
    End Property

    Public Function Add(ByVal file As QueuedVendorFile) As Integer

        Return MyBase.List.Add(file)

    End Function

End Class
