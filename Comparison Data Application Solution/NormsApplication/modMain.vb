Imports NRC.Configuration.AppConfigWrapper
Imports NormsApplicationBusinessObjectsLibrary
Module modMain

    Private mCurrentUser As CurrentUser

    'Public ReadOnly Property Config() As AppConfig
    '    Get
    '        Return AppConfig.Instance
    '    End Get
    'End Property
    Public ReadOnly Property AppName() As String
        Get
            Return Application.ProductName
        End Get
    End Property
    Public ReadOnly Property CurrentUser() As CurrentUser
        Get
            Return mCurrentUser
        End Get
    End Property

    <STAThread()> _
    Public Sub Main(ByVal args() As String)

        'Add an eventhandler to catch any unhandled exceptions in the application
        AddHandler AppDomain.CurrentDomain.UnhandledException, AddressOf UnhandledExceptionCatch
        AddHandler Application.ThreadException, AddressOf ThreadExceptionCatch

        'Enable the XP Theme Styles
        Application.EnableVisualStyles()
        Application.DoEvents()      'Call do events to fix image list bug with VisualStyles

        'Authenticate the user
        'mCurrentUser = CurrentUser.getUser(Environment.UserName)

        Select Case CurrentUser.Authenticate()
            Case CurrentUser.AuthResult.ErrorOccurred
                MessageBox.Show("An error has occurred in authentication")
                Exit Sub
            Case CurrentUser.AuthResult.AccessDenied
                Dim ex As New Exception("Access to " & AppName & " has been denied for user " & Environment.UserName & ".  Please contact the Helpdesk for further assistance.")
                ReportException(ex, "Authentication Error")
                Exit Sub
            Case Else
                'Start the application at the main form
                Try
                    Application.Run(New frmMain)
                Catch ex As Exception
                    UnhandledExceptionCatch(Nothing, New UnhandledExceptionEventArgs(ex, True))
                End Try
        End Select

        'Temporary Code until member level privileges exist
        'Try
        '    Application.Run(New frmMain)
        'Catch ex As Exception
        '    UnhandledExceptionCatch(Nothing, New UnhandledExceptionEventArgs(ex, True))
        'End Try

    End Sub

    'I guess we should just show a message...
    Private Sub UnhandledExceptionCatch(ByVal sender As Object, ByVal args As UnhandledExceptionEventArgs)
        Dim ex As Exception = args.ExceptionObject

        Try
            If ex.GetType Is GetType(Threading.ThreadAbortException) Then
                Exit Sub
            End If
            ReportException(ex)
        Catch exc As Exception
            EventLog.WriteEntry(AppName & " Handler", exc.Message, EventLogEntryType.Warning)
        End Try
    End Sub
    Private Sub ThreadExceptionCatch(ByVal sender As Object, ByVal args As System.Threading.ThreadExceptionEventArgs)
        ReportException(args.Exception)
    End Sub

    Public Sub EnableThemes(ByVal control As Control)
        Dim x As Integer
        Dim skip As Boolean = False
        For x = 0 To control.Controls.Count - 1
            skip = False
            ' If the control derives from ButtonBase, 
            ' set its FlatStyle property to FlatStyle.System.
            skip = (control.Controls(x).GetType.BaseType Is GetType(NRC.WinForms.SortableListView))

            If Not skip AndAlso control.Controls(x).GetType().BaseType Is GetType(ButtonBase) Then
                CType(control.Controls(x), ButtonBase).FlatStyle = FlatStyle.System
            End If

            ' If the control holds other controls, iterate through them also.
            If Not skip AndAlso control.Controls.Count > 0 Then
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
            Dim rpt As New NRC.WinForms.ExceptionReport(ex)
            rpt.ReportSender = Environment.UserName & "@NationalResearch.com"
            rpt.ReportSubject = AppName & " Exception Report"
            rpt.SMTPServer = Config.SMTPServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled/Unreported Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Module
