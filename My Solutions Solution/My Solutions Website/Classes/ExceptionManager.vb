Imports System.Net.Mail

Public Class ExceptionManager

    Private Shared mSmtpServer As SmtpClient
    Private Shared ReadOnly Property SmtpServer() As SmtpClient
        Get
            If mSmtpServer Is Nothing Then
                mSmtpServer = New SmtpClient(Config.SmtpServer)
            End If
            Return mSmtpServer
        End Get
    End Property

    Private Shared Sub BeginHTML(ByVal sbHTML As StringBuilder)
        Dim strTableStyle As String = "{border: Solid 1px #7BADAD;font-size: x-small;background-color: Whitesmoke;font-family: Verdana;}"
        Dim strTitleStyle As String = "{background-color: #7BADAD;color: White;font-weight: bold;font-size: x-small;font-family: Verdana;padding: 5px;}"
        Dim strLabelStyle As String = "{font-weight: bold;}"

        sbHTML.Append("<HTML>")
        sbHTML.Append("<HEAD>")
        sbHTML.Append("<STYLE>")
        sbHTML.Append(String.Format(".ExTable{0}", strTableStyle))
        sbHTML.Append(String.Format(".ExTitle{0}", strTitleStyle))
        sbHTML.Append(String.Format(".ExLabel{0}", strLabelStyle))
        sbHTML.Append("</STYLE>")
        sbHTML.Append("</HEAD>")
        sbHTML.Append("<BODY>")
        sbHTML.Append("<Table class=""ExTable"" border=""0"" cellspacing=""0"" cellpadding=""3"" width=""100%"">")
    End Sub
    Private Shared Sub EndHTML(ByVal sbHTML As StringBuilder)
        sbHTML.Append("</Table>")
        sbHTML.Append("</BODY>")
        sbHTML.Append("</HTML>")
    End Sub
    Private Shared Sub WriteHTMLTitle(ByVal sbHTML As StringBuilder, ByVal strTitle As String)
        sbHTML.Append("<TR>")
        sbHTML.Append(String.Format("<TD colspan=""2"" class=""ExTitle"">{0}</TD>", strTitle))
        sbHTML.Append("</TR>")
    End Sub
    Private Shared Sub WriteHTMLRow(ByVal sbHTML As StringBuilder, ByVal strLabel As String, ByVal strValue As String)
        sbHTML.Append("<TR>")
        sbHTML.Append("<TD nowrap valign=""top"" class=""ExLabel"">")
        sbHTML.Append(strLabel & ": ")
        sbHTML.Append("</TD>")
        sbHTML.Append("<TD width=""100%"">")
        If strLabel = "Session ID" Then
            Dim strSite As String = HttpContext.Current.Request.Url.Scheme & "://" & HttpContext.Current.Request.Url.Host & HttpContext.Current.Request.ApplicationPath
            'This line makes the session ID a hyperlink to the EventLog.aspx page with the sessionid querytstring variable
            'sbHTML.Append("<a href=""" & strSite & "/EventLog.aspx?sessionid=" & strValue & """ target=""_blank"">" & strValue & "</a")
            'removed for now
            sbHTML.Append(strValue)
        ElseIf strLabel = "Warning" Then
            sbHTML.Append("<font color=""red"">" & strValue & "</font>")
        Else
            sbHTML.Append(strValue)
        End If
        sbHTML.Append("</TD>")
        sbHTML.Append("</TR>")
    End Sub

    Public Shared Sub Publish(ByVal exception As System.Exception, ByVal additionalInfo As NameValueCollection)
        Dim strSubject As String = "eToolKit Exception Report"
        Dim objMail As New MailMessage
        Dim strKey As String
        Dim sbHTML As New StringBuilder

        BeginHTML(sbHTML)
        WriteHTMLTitle(sbHTML, "eToolKit Exception Report")
        If Not additionalInfo Is Nothing Then
            For Each strKey In additionalInfo.Keys
                If Not strKey.StartsWith("ExceptionManager.") Then
                    WriteHTMLRow(sbHTML, strKey, additionalInfo(strKey))
                End If
            Next
        End If
        WriteHTMLRow(sbHTML, "Stack Trace", exception.GetType.ToString & ":" & exception.Message & exception.StackTrace.Replace("at ", "<br>&nbsp;&nbsp;at "))
        EndHTML(sbHTML)


        Try
            objMail = New MailMessage(Config.ExceptionFromAddress, Config.ExceptionToAddress, strSubject, sbHTML.ToString)
            objMail.IsBodyHtml = True

            SmtpServer.Send(objMail)
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

End Class
