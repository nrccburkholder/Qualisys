
Public NotInheritable Class Globals
    Public Const gkstrMsgBoxTitle As String = "Offline Transfer Results Wizard"

    Public Const gkintSampleUnitMissing As Integer = -1
    Public Const gkintSampleUnitMultiple As Integer = -2

    Public Shared gobjPopMaps As New ArrayList
    Public Shared gobjMetaFields As Collection

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
            Dim rpt As New Nrc.Framework.WinForms.ExceptionReport(ex)
            rpt.ReportSender = CurrentUser.Email
            rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
            rpt.SMTPServer = Config.SMTPServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Public Shared Function ReplaceQuotes(ByVal strOriginal As String) As String
        Try
            ' Replace all single quotes with fancy quote
            strOriginal = strOriginal.Replace(Chr(39), "`"c)

            ' Replace all double quotes with fancy quote
            strOriginal = strOriginal.Replace(Chr(34), "`"c)
        Catch
            strOriginal = ""
        End Try

        Return strOriginal
    End Function
End Class
