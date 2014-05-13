Public Class CreateUserAccountException
    Inherits Exception

    Sub New()
        MyBase.New("User account could not be created.")
    End Sub

    Sub New(ByVal message As String)
        MyBase.New(message)
    End Sub

    Sub New(ByVal message As String, ByVal innerException As Exception)
        MyBase.New(message, innerException)
    End Sub

End Class
