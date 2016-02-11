Public Class AccessDeniedException
    Inherits Exception


    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal message As String)
        MyBase.New(message)
    End Sub

    Public Sub New(ByVal message As String, ByVal innerException As Exception)
        MyBase.New(message, innerException)
    End Sub

    Public Sub New(ByVal userName As String, ByVal applicationName As String)
        MyBase.New(String.Format("The user {0} does not have access to {1}.", userName, applicationName))
    End Sub


End Class
