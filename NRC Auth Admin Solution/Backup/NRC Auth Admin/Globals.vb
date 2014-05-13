Imports Nrc.Framework.WinForms

Class Globals
    Public Const maxDisplayNameLength As Integer = 42
    Public Const maxFormulaLength As Integer = 5000
    Public Const maxColumnNameLength As Integer = 20
    Public Const maxColumnDescriptionLength As Integer = 80

    Public Shared Event MainFormClosing As EventHandler

    Public Shared Sub OnMainFormClosing(ByVal sender As Object, ByVal e As EventArgs)
        RaiseEvent MainFormClosing(sender, e)
    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception)
        ReportException(ex, "Unhandled Error")
    End Sub

    Public Shared Sub ReportException(ByVal ex As Exception, ByVal titleText As String)
        'Validate the exception parameter
        If ex Is Nothing Then
            'Invalid exception parameter so throw error
            Throw New ArgumentNullException("ex", "The 'exception' argument cannot be NULL")
        End If
        Try
            'Display the error for the user
            Dim rpt As New ExceptionReport(ex)
            rpt.ReportSender = CurrentUser.Email
            rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
            rpt.SMTPServer = Config.SmtpServer
            rpt.ShowException(titleText, True, False)

        Catch inner As Exception
            'An exception occured while trying to display and exception to the user ???
            MessageBox.Show(inner.ToString, "Exception durring exception report", MessageBoxButtons.OK, MessageBoxIcon.Error)
            MessageBox.Show(ex.ToString(), "Original exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

End Class


