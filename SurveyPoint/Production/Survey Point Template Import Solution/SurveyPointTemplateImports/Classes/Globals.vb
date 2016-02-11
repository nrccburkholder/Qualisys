Imports Nrc.Framework.WinForms

''' <summary>Class used to contain global static methods.</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public NotInheritable Class Globals
    Private Sub New()
    End Sub

    ''' <summary>Overload that will pass to ReportException method with logic in it.</summary>
    ''' <param name="ex"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared Sub ReportException(ByVal ex As Exception)
        ReportException(ex, "Unhandled Error")
    End Sub

    ''' <summary>Generates and exception dialog, and provides some inherit and optional logging logic such
    '''  as emailing a list of users, recording a screen scrape at the time of error, etc.</summary>
    ''' <param name="ex"></param>
    ''' <param name="titleText"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared Sub ReportException(ByVal ex As Exception, ByVal titleText As String)
        If ex Is Nothing Then
            Throw New ArgumentNullException("ex", "The 'exception' argument cannot be NULL")
        End If

        Try
            Dim rpt As New ExceptionReport(ex)
            rpt.ReportSender = CurrentUser.Email
            rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
            rpt.SMTPServer = Config.SmtpServer
            rpt.ShowException(titleText, True, False)
        Catch inner As Exception
            MessageBox.Show(inner.Message, "Unhandled Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class