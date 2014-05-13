Imports Nrc.Framework.BusinessLogic.Configuration

Module Globals

    Public ReadOnly Property CurrentUser() As User
        Get
            Return My.Application.CurrentUser
        End Get
    End Property

    Public Function GetDBServer() As String

        Using dbConn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
            Dim serverName As String = dbConn.DataSource
            If String.IsNullOrEmpty(serverName) Then
                serverName = "Unknown"
            End If
            Return serverName
        End Using

    End Function

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
            rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
            rpt.SMTPServer = AppConfig.SMTPServer
            rpt.ShowException(titleText, True, False)

        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled/Unreported Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

End Module
