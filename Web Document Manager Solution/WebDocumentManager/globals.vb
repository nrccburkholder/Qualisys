Imports NRC.Configuration.AppConfigWrapper
Imports System.IO
Class Globals

    Public Shared ReadOnly Property AppName() As String
        Get
            Return System.Windows.Forms.Application.ProductName
        End Get
    End Property

    'I guess we should just show a message...
    Private Shared Sub UnhandledExceptionCatch(ByVal sender As Object, ByVal args As UnhandledExceptionEventArgs)
        Dim ex As Exception = DirectCast(args.ExceptionObject, Exception)

        Try
            If ex.GetType Is GetType(Threading.ThreadAbortException) Then
                Exit Sub
            End If
            ReportException(ex)
        Catch exc As Exception
            EventLog.WriteEntry(AppName & " Handler", exc.Message, EventLogEntryType.Warning)
        End Try
    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception)
        ReportException(ex, "Unhandled Exception")
    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception, ByVal titleText As String)
        If ex Is Nothing Then
            Throw New ArgumentNullException("ex", "The 'exception' argument cannot be NULL")
        End If

        Try
            Dim rpt As New Nrc.WinForms.ExceptionReport(ex)
            rpt.ReportSender = Environment.UserName & "@NationalResearch.com"
            rpt.ReportSubject = AppName & " Exception Report"
            rpt.SMTPServer = Config.SMTPServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled/Unreported Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class
