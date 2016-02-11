Public Class UpdateEventButtonClickedEventArgs
    Inherits EventArgs

    Private mButtonClicked As UpdateEventButtonsEnum

    Public ReadOnly Property ButtonClicked() As UpdateEventButtonsEnum
        Get
            Return mButtonClicked
        End Get
    End Property

    Public Sub New(ByVal buttonClicked As UpdateEventButtonsEnum)

        mButtonClicked = buttonClicked

    End Sub

End Class
