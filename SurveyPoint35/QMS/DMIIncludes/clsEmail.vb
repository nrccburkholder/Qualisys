Imports System.Web.Mail

Public Class clsEmail

    Public Shared Sub Send(ByVal sFrom As String, ByVal sTo As String, ByVal sSubject As String, ByVal sBody As String, ByVal sSMTPServer As String)
        Dim oMsg As New MailMessage()

        oMsg.From = ""
        oMsg.To = ""
        oMsg.Subject = ""
        oMsg.Body = ""

        Send(oMsg, sSMTPServer)

    End Sub

    Public Shared Sub Send(ByVal oMsg As MailMessage, ByVal sSMTPServer As String)
        SmtpMail.SmtpServer = sSMTPServer
        SmtpMail.Send(oMsg)

    End Sub

End Class
