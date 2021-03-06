Imports Nrc.Framework.BusinessLogic.Configuration

Namespace My

    ' The following events are availble for MyApplication:
    ' 
    ' Startup: Raised when the application starts, before the startup form is created.
    ' Shutdown: Raised after all application forms are closed.  This event is not raised if the application terminates abnormally.
    ' UnhandledException: Raised if the application encounters an unhandled exception.
    ' StartupNextInstance: Raised when launching a single-instance application and the application is already active. 
    ' NetworkAvailabilityChanged: Raised when the network connection is connected or disconnected.
    Partial Friend Class MyApplication

        Private Sub MyApplication_Startup(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.StartupEventArgs) Handles Me.Startup
            'Initialize legacy NRCAuth configuration info
            SetupNrcAuthSettings()

            Try
                If Not CurrentUser.HasNRCAuthAdminAccess Then
                    Throw New AccessDeniedException(CurrentUser.UserName, "Configuration Manager")
                End If
            Catch ex As AccessDeniedException
                Globals.ReportException(ex, "Access Denied Error")
                e.Cancel = True
            Catch ex As Exception
                Globals.ReportException(ex)
                e.Cancel = True
            End Try
        End Sub

        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException
            Globals.ReportException(e.Exception, "Unhandled Application Error")
            e.ExitApplication = False
        End Sub

        Private Sub SetupNrcAuthSettings()
            Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = Config.NRCAuthConnection
            Nrc.NRCAuthLib.StaticConfig.DataMartConnection = Config.DataMartConnection
            Nrc.NRCAuthLib.StaticConfig.SiteUrl = Config.SiteUrl
            Nrc.NRCAuthLib.StaticConfig.SMTPServer = Config.SmtpServer
            Nrc.NRCAuthLib.StaticConfig.NRCPickerUrl = Config.NRCPickerUrl
            Nrc.NRCAuthLib.StaticConfig.MailFromAccount = Config.MailFromAccount
            Select Case Config.EnvironmentType
                Case EnvironmentTypes.Testing, EnvironmentTypes.Staging
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
                Case EnvironmentTypes.Production
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
            End Select
        End Sub

    End Class

End Namespace

