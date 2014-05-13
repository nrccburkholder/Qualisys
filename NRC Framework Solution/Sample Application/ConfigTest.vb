Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ConfigTest

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        ConfigConnectionTextBox.Text = "Friend Property"
        SQLTimeoutTextBox.Text = AppConfig.SqlTimeout.ToString
        SMTPServerTextBox.Text = AppConfig.SMTPServer
        EnvironmentNameTextBox.Text = AppConfig.EnvironmentName
        EnvironmentTypeTextBox.Text = AppConfig.EnvironmentType.ToString
        CountryNameTextBox.Text = AppConfig.CountryName
        CountryIDTextBox.Text = AppConfig.CountryID.ToString
        QualiSysConnectionTextBox.Text = AppConfig.QualisysConnection
        QLoaderConnectionTextBox.Text = AppConfig.QLoaderConnection
        DatamartConnectionTextBox.Text = AppConfig.DataMartConnection
        NotificationConnectionTextBox.Text = AppConfig.NotificationConnection
        NRCAuthConnectionTextBox.Text = AppConfig.NrcAuthConnection
        ScanConnectionTextBox.Text = AppConfig.ScanConnection
        QueueConnectionTextBox.Text = AppConfig.QueueConnection
        WorkflowConnectionTextBox.Text = AppConfig.WorkflowConnection
        ParamBindingSource.DataSource = AppConfig.Params

    End Sub

    Private Sub ResetButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResetButton.Click

        'AppConfig.Reset()
        'Button1_Click(Me, Nothing)

    End Sub

End Class