Imports System.Net.Mail
Module SendEmail

    Public newWebSiteName As String

    Public Class ExceptionManager
        Inherits PublicMemberLibrary

        Public Shared newWebSitename As String

        Public Shared Function StartEmail(ByVal ex As Exception) As String
            Dim Status As String = ""
            Dim ExceptionCheck As New Exception
            Try
                Publish(ex)
            Catch exc As Exception
                ExceptionCheck = exc
            End Try
            If Len(ExceptionCheck.ToString) > 0 Then
                Status = ExceptionCheck.ToString
            Else
                Status = "Emailed"
            End If
            Return Status
        End Function


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

        Private Shared Sub Publish(ByVal exception As System.Exception)
            Dim strSubject As String = mSiteFriendlyNames & " Exception Report"
            Dim objMail As New MailMessage
            Dim strKey As String
            Dim sbHTML As New StringBuilder
            Dim additionalinfo As New NameValueCollection
            Dim request As HttpRequest = HttpContext.Current.Request
            additionalinfo.Add("Time Stamp", DateTime.Now.ToString)
            additionalinfo.Add("Server Name", mServerNames)
            additionalinfo.Add("Site", mSiteNames)
            additionalinfo.Add("URL", mURL)
            additionalinfo.Add("Page Name", mPageName)
            additionalinfo.Add("User Name", mUserName)
            additionalinfo.Add("IP Address", mIPAddress)
            additionalinfo.Add("Broswer", mBrowser)
            additionalinfo.Add("Session ID", mSessionID)
            'If the exception was handled but still should be published then bolHandled = true
            additionalinfo.Add("Handled", mHandled.ToString)
            'If an additional warning was passed in then add it
            If mAdditionalWarning.Length > 0 Then
                additionalinfo.Add("Warning", mAdditionalWarning)
            End If
            BeginHTML(sbHTML)
            WriteHTMLTitle(sbHTML, strSubject)
            If Not additionalinfo Is Nothing Then
                For Each strKey In additionalinfo.Keys
                    If Not strKey.StartsWith("ExceptionManager.") Then
                        WriteHTMLRow(sbHTML, strKey, additionalinfo(strKey))
                    End If
                Next
            End If
            WriteHTMLRow(sbHTML, "Stack Trace", exception.GetType.ToString & ":" & exception.Message & exception.StackTrace.Replace("at ", "<br>&nbsp;&nbsp;at "))
            EndHTML(sbHTML)


            Try
                objMail = New MailMessage(ExceptionFromAddress, ExceptionToAddress, strSubject, sbHTML.ToString)
                objMail.IsBodyHtml = True

                SmtpServer.Send(objMail)
            Catch ex As Exception
                Throw ex
            End Try

        End Sub

    End Class

End Module

