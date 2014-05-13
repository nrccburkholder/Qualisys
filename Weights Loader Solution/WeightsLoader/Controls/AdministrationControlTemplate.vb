Public Class AdministrationControlTemplate

    Private mTitle As String
    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal value As String)
            mTitle = value
        End Set
    End Property

End Class
