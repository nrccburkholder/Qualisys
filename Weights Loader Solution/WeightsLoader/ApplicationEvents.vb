Imports NRC.Framework.BusinessLogic.Configuration

Namespace My

    ' The following events are availble for MyApplication:
    ' 
    ' Startup: Raised when the application starts, before the startup form is created.
    ' Shutdown: Raised after all application forms are closed.  This event is not raised if the application terminates abnormally.
    ' UnhandledException: Raised if the application encounters an unhandled exception.
    ' StartupNextInstance: Raised when launching a single-instance application and the application is already active. 
    ' NetworkAvailabilityChanged: Raised when the network connection is connected or disconnected.
    Partial Friend Class MyApplication

        Private Sub MyApplication_Shutdown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shutdown

        End Sub

        Private Sub MyApplication_Startup(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.StartupEventArgs) Handles Me.Startup
            Try
                'Set the NRCAuth settings
                SetupNrcAuthSettings()

                If Not CurrentUser.HasWeightsLoaderAccess Then
                    Throw New AccessDeniedException(CurrentUser.UserName, "Weights Loader")
                End If
            Catch ex As AccessDeniedException
                ReportException(ex, "Access Denied Error")
                e.Cancel = True
            Catch ex As Exception
                ReportException(ex)
                e.Cancel = True
            End Try
        End Sub

        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException
            ReportException(e.Exception)
            e.ExitApplication = False
        End Sub

        Private Sub SetupNrcAuthSettings()
            NRC.NRCAuthLib.StaticConfig.NRCAuthConnection = AppConfig.NrcAuthConnection
            Select Case AppConfig.EnvironmentType
                'Case EnvironmentTypes.Development
                '    NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Development
                Case EnvironmentTypes.Testing
                    NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
                Case EnvironmentTypes.Production
                    NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
            End Select
        End Sub
    End Class

End Namespace

