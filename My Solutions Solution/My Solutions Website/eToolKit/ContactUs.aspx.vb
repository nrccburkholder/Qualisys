Imports System.Net.Mail

Partial Public Class eToolKit_ContactUs
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub SubmitFeedbackButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SubmitFeedbackButton.Click
        If Me.IsValid Then
            Me.FeedbackDiv.Visible = False
            Me.ThanksDiv.Visible = True
            Me.SendFeedback()
        End If
    End Sub

    Private Sub SendFeedback()
        'Sniff the users machine
        Dim strSniff As String = ""
        With Request.Browser
            strSniff &= "<b>Browser Capabilities</b><br>" & vbCrLf
            strSniff &= "Type = " & .Type & "<br>" & vbCrLf
            strSniff &= "Name = " & .Browser & "<br>" & vbCrLf
            strSniff &= "Version = " & .Version & "<br>" & vbCrLf
            strSniff &= "Major Version = " & .MajorVersion & "<br>" & vbCrLf
            strSniff &= "Minor Version = " & .MinorVersion & "<br>" & vbCrLf
            strSniff &= "Platform = " & .Platform & "<br>" & vbCrLf
            strSniff &= "Is Beta = " & .Beta & "<br>" & vbCrLf
            strSniff &= "Is Crawler = " & .Crawler & "<br>" & vbCrLf
            strSniff &= "Is AOL = " & .AOL & "<br>" & vbCrLf
            strSniff &= "Is Win16 = " & .Win16 & "<br>" & vbCrLf
            strSniff &= "Is Win32 = " & .Win32 & "<br>" & vbCrLf
            strSniff &= "Supports Frames = " & .Frames & "<br>" & vbCrLf
            strSniff &= "Supports Tables = " & .Tables & "<br>" & vbCrLf
            strSniff &= "Supports Cookies = " & .Cookies & "<br>" & vbCrLf
            strSniff &= "Supports VB Script = " & .VBScript & "<br>" & vbCrLf
            strSniff &= "Supports JavaScript = " & (.EcmaScriptVersion.Major >= 1).ToString & "<br>" & vbCrLf
            strSniff &= "Supports Java Applets = " & .JavaApplets & "<br>" & vbCrLf
            strSniff &= "Supports ActiveX Controls = " & .ActiveXControls & "<br>" & vbCrLf
        End With

        'Create an instance of the MailMessage class
        Dim msg As New MailMessage

        'Set the properties to send to
        msg.To.Add(New MailAddress(Config.ContactToAddress))
        msg.From = New MailAddress(txtEmail.Text)

        'Send the email in text format
        msg.IsBodyHtml = True

        'Set the priority - options are High, Low, and Normal
        msg.Priority = MailPriority.High

        'Set the subject
        msg.Subject = "eToolKit Website - Feedback"

        'Set the body
        'Get the user
        Dim strUser As String = "Unknown"
        If CurrentUser.IsAuthenticated Then
            strUser = CurrentUser.Member.FullName & " (" & CurrentUser.Member.Name & ")"
        End If
        Dim strHTML As String = ""

        strHTML += "<TABLE border=""0"" cellPadding=""3"" cellSpacing=""2"" width=""100%"">" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>DateTime: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & DateTime.Now & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>User ID: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & strUser & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Session ID: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & Session.SessionID & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>E-Mail: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & txtEmail.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Sent by: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & txtName.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Organization: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & txtOrganization.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Feature: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & ddlFeature.SelectedItem.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Type: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & ddlType.SelectedItem.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "<TR><TD noWrap bgcolor=""#cccccc""><font face=""verdana,arial"" size=""2""><strong>Description: </strong></font></TD><TD width=""100%"" bgcolor=""#f1f1f1""><font face=""verdana,arial"" size=""2"">" & txtDescription.Text & "</font></TD></TR>" & vbCrLf
        strHTML += "</TABLE><HR size=""1"" width=""100%"">" & vbCrLf
        strHTML += "<font face=""verdana,arial"" size=""2"">" & strSniff & "</font>" & vbCrLf

        msg.Body = strHTML

        'Specify the SMTP Server
        Dim smtp As New SmtpClient(Config.SmtpServer)

        'Now, to send the message, use the Send method of the SmtpMail class
        smtp.Send(msg)
    End Sub
End Class