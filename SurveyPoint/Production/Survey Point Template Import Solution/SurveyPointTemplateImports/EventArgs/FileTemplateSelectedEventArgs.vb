Public Class FileTemplateSelectedEventArgs
    Inherits EventArgs

    Private mFileTemplateID As Integer
    Private mFileTemplateAction As FileTemplateActions
    Public ReadOnly Property FileTemplateID() As Integer
        Get
            Return Me.mFileTemplateID
        End Get
    End Property
    Public ReadOnly Property FileTemplateAction() As FileTemplateActions
        Get
            Return Me.mFileTemplateAction
        End Get
    End Property
    Public Sub New(ByVal fileTemplateID As Integer, ByVal fileTemplateAction As FileTemplateActions)
        Me.mFileTemplateID = fileTemplateID
        Me.mFileTemplateAction = fileTemplateAction
    End Sub
End Class
