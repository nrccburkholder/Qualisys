''' <summary>Exception to be thrown when NRC Auth does not allow user acces to application.</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
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
