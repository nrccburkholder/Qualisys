Public Class CreateDLVUpdateEventArgs
    Inherits EventArgs

    Private mCurrentImage As Integer

    Public ReadOnly Property CurrentImage() As Integer
        Get
            Return mCurrentImage
        End Get
    End Property

    Public Sub New(ByVal currentImage As Integer)

        mCurrentImage = currentImage

    End Sub

End Class
