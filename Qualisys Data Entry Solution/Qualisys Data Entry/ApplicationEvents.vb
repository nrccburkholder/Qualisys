Imports Nrc.Qualisys.QualisysDataEntry.Library
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
            'Get user settings
            Nrc.Qualisys.QualisysDataEntry.Settings = UserSettings.Deserialize

            'Set the NRCAuth settings
            SetupNrcAuthSettings()

            'Authenticate the user
            CurrentUser = New Library.User(Environment.UserName)
            Select Case CurrentUser.Authenticate()
                Case Library.User.AuthResult.ErrorOccurred
                    MessageBox.Show("An error has occurred in authentication")
                    e.Cancel = True
                Case Library.User.AuthResult.AccessDenied
                    Dim ex As New Exception("Access to " & AppName & " has been denied for user " & Environment.UserName & ".  Please contact the Helpdesk for further assistance.")
                    ReportException(ex, "Authentication Error")
                    e.Cancel = True
                Case Library.User.AuthResult.Success
                    'Start the application at the main form
            End Select

        End Sub

        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException
            Dim ex As Exception = e.Exception

            Try
                'If ex.GetType Is GetType(Threading.ThreadAbortException) Then
                '    Exit Sub
                'End If
                ReportException(ex)
            Catch exc As Exception
                EventLog.WriteEntry(AppName & " Handler", exc.Message, EventLogEntryType.Warning)
            End Try
        End Sub

        Private Sub SetupNrcAuthSettings()
            Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = AppConfig.NrcAuthConnection
            Select Case AppConfig.EnvironmentType
                Case EnvironmentTypes.Testing, EnvironmentTypes.Staging
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
                Case EnvironmentTypes.Production
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
            End Select
        End Sub
    End Class

End Namespace

