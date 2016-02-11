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

        ''' <summary>Access NRC Auth to determine if the user has rights to use this application.</summary>
        ''' <param name="sender"></param>
        ''' <param name="e"></param>
        ''' <Creator>Jeff Fleming</Creator>
        ''' <DateCreated>11/8/2007</DateCreated>
        ''' <DateModified>11/8/2007</DateModified>
        ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
        Private Sub MyApplication_Startup(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.StartupEventArgs) Handles Me.Startup
            Try
                'Set the NRCAuth settings
                SetupNrcAuthSettings()

                If Not CurrentUser.HasApplicationAccess Then
                    Throw New AccessDeniedException(CurrentUser.UserName, My.Application.Info.Title)
                End If
            Catch ex As AccessDeniedException
                Globals.ReportException(ex, "Access Denied Error")
                e.Cancel = True
            Catch ex As Exception
                Globals.ReportException(ex)
                e.Cancel = True
            End Try
        End Sub

        ''' <summary>Any unhandled error in the application fall into this block.</summary>
        ''' <param name="sender"></param>
        ''' <param name="e"></param>
        ''' <Creator>Jeff Fleming</Creator>
        ''' <DateCreated>11/8/2007</DateCreated>
        ''' <DateModified>11/8/2007</DateModified>
        ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException
            Globals.ReportException(e.Exception)
            e.ExitApplication = False
        End Sub

        ''' <summary>Retrieves the Environement settings and configuration info need to authenticate with NRC Auth</summary>
        ''' <Creator>Jeff Fleming</Creator>
        ''' <DateCreated>11/8/2007</DateCreated>
        ''' <DateModified>11/8/2007</DateModified>
        ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
        Private Sub SetupNrcAuthSettings()

            Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = Config.NrcAuthConnection
            Select Case Config.EnvironmentType
                Case Framework.Configuration.EnvironmentType.Development
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Development
                Case Framework.Configuration.EnvironmentType.Testing
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
                Case Framework.Configuration.EnvironmentType.Production
                    Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
            End Select

        End Sub
    End Class

End Namespace

