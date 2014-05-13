Public Class NotificationNavigatorChangedEventArgs
    Inherits EventArgs

    Private mTemplateName As String
    Private mTemplateID As Integer

    Public ReadOnly Property TemplateName() As String
        Get
            Return mTemplateName
        End Get
    End Property
    Public ReadOnly Property TemplateID() As Integer
        Get
            Return mTemplateID
        End Get
    End Property

    Public Sub New(ByVal templateName As String, ByVal templateID As Integer)
        Me.mTemplateID = templateID
        Me.mTemplateName = templateName
    End Sub
End Class
