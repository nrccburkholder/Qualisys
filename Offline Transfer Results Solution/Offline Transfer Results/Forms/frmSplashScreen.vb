Public Class frmSplashScreen
    Private Sub frmSplashScreen_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.lblCopyRight.Text = My.Application.Info.Copyright
        Me.lblEnvironment.Text = String.Format("Environment: {0}", Config.EnvironmentName)
        Me.lblVersion.Text = String.Format("Version: {0}", My.Application.Info.Version)
        Me.txtProductName.Text = My.Application.Info.ProductName
    End Sub
End Class