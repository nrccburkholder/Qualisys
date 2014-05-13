Public Class UserSettingsDialog

    Private Sub UserSettingsDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        My.Settings.Save()
        Me.SettingsPropertyGrid.SelectedObject = My.Settings

    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        My.Settings.Save()
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        My.Settings.Reload()
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

End Class
