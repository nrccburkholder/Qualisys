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

        'Private members used in modMain
        'Any global variables should be declared as properties to be accessible on any form
        Private mCurrentUser As User

#Region " Global Properties "

        Public ReadOnly Property CurrentUser() As User
            Get
                Return mCurrentUser
            End Get
        End Property

#End Region

#Region " Private Methods "

        Private Sub MyApplication_Startup(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.StartupEventArgs) Handles Me.Startup

            'Set the NRCAuth settings
            SetupNrcAuthSettings()

            'Authenticate the user
            mCurrentUser = New User(Environment.UserName)
            Select Case mCurrentUser.Authenticate()
                Case Library.NRCAuthResult.ErrorOccurred
                    MessageBox.Show("An error has occurred in authentication")
                    e.Cancel = True

                Case Library.NRCAuthResult.AccessDenied
                    Dim ex As New Exception(String.Format("Access to {0} has been denied for user {1}.  Please contact the Helpdesk for further assistance.", My.Application.Info.ProductName, Environment.UserName))
                    ReportException(ex, "Authentication Error")
                    e.Cancel = True

            End Select

        End Sub

        Private Sub MyApplication_UnhandledException(ByVal sender As Object, ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs) Handles Me.UnhandledException

            ReportException(e.Exception, "Unhandled Error")
            e.ExitApplication = False

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

#End Region

    End Class

End Namespace

