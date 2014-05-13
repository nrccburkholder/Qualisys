Public Class BarcodeFileSearchCompleteEventArgs
    Inherits EventArgs

    Private mCancel As Boolean = False

    Public Property Cancel() As Boolean
        Get
            Return mCancel
        End Get
        Set(ByVal value As Boolean)
            mCancel = value
        End Set
    End Property

    Public Sub New()

    End Sub

End Class
