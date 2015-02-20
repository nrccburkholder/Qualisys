Public Class MainForm

    Private Sub SeededMailingServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SeededMailingServiceButton.Click

        Dim seededMailingForm As New SeededMailingServiceTest
        seededMailingForm.Show(Me)

    End Sub

    Private Sub MainForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

End Class
