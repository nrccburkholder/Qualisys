Public Class frmSplashScreen

    Private Sub SplashScreenForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.lblCompany.Text = My.Application.Info.CompanyName
        Me.lblEnvironment.Text = IIf(Config.EnvironmentType = Nrc.Framework.BusinessLogic.Configuration.EnvironmentTypes.Production, "", Config.EnvironmentName)
    End Sub
End Class