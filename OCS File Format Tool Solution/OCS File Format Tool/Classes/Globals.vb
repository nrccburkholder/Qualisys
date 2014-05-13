Imports Nrc.Framework.WinForms
Imports Nrc.Framework.BusinessLogic.Configuration

Public NotInheritable Class Globals

    Private Sub New()

    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception)

        ReportException(ex, "Unhandled Error")

    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception, ByVal titleText As String)

        If ex Is Nothing Then
            Throw New ArgumentNullException("ex", "The 'exception' argument cannot be NULL")
        End If

        Try
            Dim rpt As New ExceptionReport(ex)
            rpt.ReportSender = CurrentUser.Email
            rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
            rpt.SMTPServer = AppConfig.SMTPServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

End Class


