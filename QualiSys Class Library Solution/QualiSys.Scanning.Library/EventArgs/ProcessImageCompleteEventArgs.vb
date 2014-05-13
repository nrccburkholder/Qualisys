Public Class ProcessImageCompleteEventArgs
    Inherits EventArgs

    Private mNewImage As Image
    Private mCancel As Boolean = False

    Public ReadOnly Property NewImage() As Image
        Get
            Return mNewImage
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

    Public Sub New(ByVal newImage As Image)

        mNewImage = newImage

    End Sub

End Class
