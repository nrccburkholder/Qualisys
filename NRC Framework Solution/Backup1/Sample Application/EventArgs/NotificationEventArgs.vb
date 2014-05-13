Public Class NotificationEventArgs
    Inherits EventArgs
    Private mTemplateName As String

    Public Sub New(ByVal templateName As String)
        Me.TemplateName = templateName
    End Sub
    Public Property TemplateName() As String
        Get
            Return Me.mTemplateName
        End Get
        Set(ByVal value As String)
            Me.mTemplateName = value
        End Set
    End Property
End Class
