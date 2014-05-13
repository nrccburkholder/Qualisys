Public Class ProcessImageBeginEventArgs
    Inherits EventArgs

    Private mCurrentImage As Integer
    Private mCancel As Boolean = False

    Public ReadOnly Property CurrentImage() As Integer
        Get
            Return mCurrentImage
        End Get
    End Property

    Public Property Cancel() As Boolean
        Get
            Return mCancel
        End Get
        Set(ByVal value As Boolean)
            mCancel = value
        End Set
    End Property

    Public Sub New(ByVal currentImage As Integer)

        mCurrentImage = currentImage

    End Sub

End Class
