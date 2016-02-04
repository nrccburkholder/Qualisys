Public Class UpdateEventNavigator

    Public Event ButtonClicked As EventHandler(Of UpdateEventButtonClickedEventArgs)

    Private Sub UpdateEventNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Let's start off on the UpdateCodes screen
        RaiseEvent ButtonClicked(Me, New UpdateEventButtonClickedEventArgs(UpdateEventButtonsEnum.UpdateCodes))

    End Sub

    Private Sub UpdateEventCodesTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventCodesTSButton.Click

        RaiseEvent ButtonClicked(Me, New UpdateEventButtonClickedEventArgs(UpdateEventButtonsEnum.UpdateCodes))

    End Sub

    Private Sub UpdateEventLogTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogTSButton.Click

        RaiseEvent ButtonClicked(Me, New UpdateEventButtonClickedEventArgs(UpdateEventButtonsEnum.ViewLog))

    End Sub

End Class
