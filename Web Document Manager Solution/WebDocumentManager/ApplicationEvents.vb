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

            'Authenticate the user
            Select Case NRCWebDocumentManager.CurrentUser.Authenticate()
                Case NRCWebDocumentManager.CurrentUser.AuthResult.ErrorOccurred
                    MessageBox.Show("An error has occurred in authentication")
                    Exit Sub
                Case NRCWebDocumentManager.CurrentUser.AuthResult.AccessDenied
                    Dim ex As New Exception("Access to " & Globals.AppName & " has been denied for user " & Environment.UserName & ".  Please contact the Helpdesk for further assistance.")
                    Globals.ReportException(ex, "Authentication Error")
                    Exit Sub
            End Select
        End Sub

        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException
            Globals.ReportException(e.Exception, "Unhandled Application Error")
            e.ExitApplication = False
        End Sub

        Private Sub SetupNrcAuthSettings()
            NRC.NRCAuthLib.StaticConfig.NRCAuthConnection = AppConfig.NrcAuthConnection
            Select Case AppConfig.EnvironmentType
                Case EnvironmentTypes.Testing, EnvironmentTypes.Staging
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = Nrc.NRCAuthLib.StaticConfig.Environment.Testing
                Case EnvironmentTypes.Production
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = Nrc.NRCAuthLib.StaticConfig.Environment.Production
            End Select
        End Sub
    End Class
End Namespace

