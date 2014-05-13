Public Class SelectInitialEnvironmentForm
    Dim mEnvironmentController As EnvironmentController


    Private Sub cboCurrentEnvironment_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboCurrentEnvironment.SelectedIndexChanged
        OKButton.Enabled = Not String.IsNullOrEmpty(cboCurrentEnvironment.Text)
    End Sub

    Public Sub New(ByVal controller As EnvironmentController)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mEnvironmentController = controller
        PopulateEnvironmentList()
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        EnvironmentController.SetEnvironmentTo(cboCurrentEnvironment.Text)
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub CancelButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton1.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
    Private Sub PopulateEnvironmentList()
        Me.cboCurrentEnvironment.Items.Clear()
        For Each key As String In Config.EnvironmentSettings.Environments.Keys
            Me.cboCurrentEnvironment.Items.Add(key)
        Next
    End Sub
End Class