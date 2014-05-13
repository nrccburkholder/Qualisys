Public Class PackageLockException
    Inherits System.Exception

    Private mPackageID As Integer

    Public ReadOnly Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
    End Property

    Sub New(ByVal message As String)

        MyBase.New(message)

    End Sub

    Sub New(ByVal message As String, ByVal innerException As System.Exception)

        MyBase.New(message, innerException)

    End Sub

    Sub New(ByVal message As String, ByVal innerException As System.Exception, ByVal packageID As Integer)

        MyBase.New(message, innerException)
        mPackageID = packageID

    End Sub

End Class