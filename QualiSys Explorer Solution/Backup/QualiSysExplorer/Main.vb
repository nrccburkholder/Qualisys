Imports Nrc.Framework.BusinessLogic.Configuration

Public Module Main

#Region " Global Properties "

    Private mCurrentUser As User

    Public ReadOnly Property AppName() As String
        Get
            Return Application.ProductName
        End Get
    End Property

    Public ReadOnly Property CurrentUser() As User
        Get
            Return mCurrentUser
        End Get
    End Property

#End Region

    <STAThread()> _
    Public Sub Main(ByVal args() As String)

        'Add an eventhandler to catch any unhandled exceptions in the application
        AddHandler AppDomain.CurrentDomain.UnhandledException, AddressOf UnhandledExceptionHandler
        AddHandler Application.ThreadException, AddressOf ThreadExceptionHandler

        'Enable the XP Theme Styles
        Application.EnableVisualStyles()
        Application.DoEvents()      'Call do events to fix image list bug with VisualStyles

        'Authenticate the user
        Try
            mCurrentUser = New User(Environment.UserName)
        Catch ex As Exception
            ReportException(ex, "Authentication Error")
            Exit Sub
        End Try

        If mCurrentUser.HasAccess Then
            'Start the application at the main form
            Try
                Application.Run(New MainForm)
            Catch ex As Exception
                UnhandledExceptionHandler(Nothing, New UnhandledExceptionEventArgs(ex, True))
            End Try
        Else
            Dim ex As New Exception(String.Format("Access to {0} has been denied for user {1}.  Please contact the Helpdesk for further assistance.", AppName, Environment.UserName))
            ReportException(ex, "Access Denied")
            Exit Sub
        End If

    End Sub

    'I guess we should just show a message...
    Private Sub UnhandledExceptionHandler(ByVal sender As Object, ByVal args As UnhandledExceptionEventArgs)

        Dim ex As Exception = DirectCast(args.ExceptionObject, Exception)

        Try
            If ex.GetType Is GetType(Threading.ThreadAbortException) Then
                Exit Sub
            End If
            ReportException(ex)

        Catch exc As Exception
            'Dim evntLog As New EventLog("Application")
            EventLog.WriteEntry(AppName & " Handler", exc.Message, EventLogEntryType.Warning)

        End Try

    End Sub

    Private Sub ThreadExceptionHandler(ByVal sender As Object, ByVal args As System.Threading.ThreadExceptionEventArgs)

        ReportException(args.Exception)

    End Sub

    Public Sub EnableThemes(ByVal control As Control)

        Dim x As Integer

        For x = 0 To control.Controls.Count - 1
            ' If the control derives from ButtonBase, 
            ' set its FlatStyle property to FlatStyle.System.
            If control.Controls(x).GetType().BaseType Is GetType(ButtonBase) Then
                CType(control.Controls(x), ButtonBase).FlatStyle = FlatStyle.System
            End If

            ' If the control holds other controls, iterate through them also.
            If control.Controls.Count > 0 Then
                EnableThemes(control.Controls(x))
            End If
        Next x

    End Sub

    Public Sub ReportException(ByVal ex As Exception)

        ReportException(ex, "Unhandled Exception")

    End Sub

    Public Sub ReportException(ByVal ex As Exception, ByVal titleText As String)

        If ex Is Nothing Then
            Throw New ArgumentNullException("ex", "The 'exception' argument cannot be NULL")
        End If

        Try
            Dim rpt As New Nrc.Framework.WinForms.ExceptionReport(ex)
            rpt.ReportSender = Environment.UserName & "@NationalResearch.com"
            rpt.ReportSubject = AppName & " Exception Report"
            rpt.SMTPServer = AppConfig.SMTPServer
            rpt.ShowException(titleText, True, False)

        Catch inner As Exception
            MessageBox.Show(inner.ToString, "Unhandled/Unreported Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub


End Module
