Public Class MassEmailConfirmation

    Public Sub New(ByVal EmailsToSend As Int32)
        InitializeComponent()
        Label1.Text = "The e-mail will be sent to the " + EmailsToSend.ToString() + " selected users."
    End Sub
    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If txtConfirmation.Text.ToLower() = "send" Then
            DialogResult = Windows.Forms.DialogResult.OK
            Close()
        Else
            txtError.Visible = True
            txtConfirmation.Clear()
        End If
    End Sub
End Class