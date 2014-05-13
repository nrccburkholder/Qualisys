Imports NRC.Qualisys.QualisysDataEntry.Library
Module MainModule

    Private mCurrentUser As User
    Private mSettings As UserSettings

    Public ReadOnly Property AppName() As String
        Get
            Return Application.ProductName
        End Get
    End Property
    Public Property CurrentUser() As User
        Get
            Return mCurrentUser
        End Get
        Friend Set(ByVal value As User)
            mCurrentUser = value
        End Set
    End Property
    Public Property Settings() As UserSettings
        Get
            Return mSettings
        End Get
        Friend Set(ByVal value As UserSettings)
            mSettings = value
        End Set
    End Property

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
            rpt.SMTPServer = Config.SMTPServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled/Unreported Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Module
