Imports System.Web.Mail
Imports System.Web

Public Class SecurityLog

    Public Shared Sub LogWebEvent(ByVal userName As String, ByVal sessionId As String, ByVal application As String, ByVal pageName As String, ByVal eventType As String, ByVal eventData As String)
        DAL.LogWebEvent(userName, sessionId, application, pageName, eventType, eventData)
    End Sub

    Public Shared Sub LogSignInSuccess(ByVal userName As String, ByVal sessionId As String, ByVal ipAddress As String, ByVal browserType As String, ByVal browserVersion As String, ByVal userAgent As String, ByVal applicationName As String, ByVal host As String, ByVal machineName As String, ByVal urlPath As String)
        DAL.LogSignInSuccess(userName, sessionId, ipAddress, browserType, browserVersion, userAgent, applicationName, host, machineName, urlPath)
    End Sub

    Public Shared Sub LogSignInFailure(ByVal userName As String, ByVal sessionid As String, ByVal ipAddress As String, ByVal browserType As String, ByVal browserVersion As String, ByVal userAgent As String, ByVal applicationName As String, ByVal host As String, ByVal machineName As String, ByVal urlPath As String)
        DAL.LogSignInFailure(userName, sessionid, ipAddress, browserType, browserVersion, userAgent, applicationName, host, machineName, urlPath)
    End Sub

    Public Shared Sub LogWebException(ByVal userName As String, ByVal sessionId As String, ByVal applicationName As String, ByVal urlPath As String, ByVal pageName As String, ByVal isHandled As Boolean, ByVal message As String, ByVal exceptionType As String, ByVal stackTrace As String)
        DAL.LogWebException(userName, sessionId, applicationName, urlPath, pageName, isHandled, message, exceptionType, stackTrace)
    End Sub

    Public Shared Sub LogDocumentDownload(ByVal memberId As Integer, ByVal documentId As Integer, ByVal documentNodeId As Integer)
        DAL.LogDocumentDownload(memberId, documentId, documentNodeId)
    End Sub


#Region " Web Exception Email "
    Public Shared Sub PublishWebExceptionSQL(ByVal ex As Exception, ByVal applicationName As String)
        Dim userName As String = ""
        Dim sessionId As String = ""
        Dim url As String = ""
        Dim pageName As String = ""

        Try
            If Not HttpContext.Current Is Nothing AndAlso HttpContext.Current.User.Identity.IsAuthenticated Then
                userName = HttpContext.Current.User.Identity.Name
            End If
        Catch
        End Try
        Try
            If Not HttpContext.Current Is Nothing AndAlso Not HttpContext.Current.Session Is Nothing Then
                sessionId = HttpContext.Current.Session.SessionID
            End If
        Catch
        End Try
        Try
            url = HttpContext.Current.Request.Url.ToString
        Catch
        End Try
        Try
            pageName = FormsAuth.PageName
        Catch
        End Try

        LogWebException(userName, sessionId, applicationName, url, pageName, False, ex.Message, ex.GetType.ToString, ex.StackTrace)
    End Sub

    Public Shared Sub PublishWebExceptionEmail(ByVal ex As Exception, ByVal warning As String, ByVal fromAddress As String, ByVal toAddress As String, ByVal subject As String)
        Dim msg As New MailMessage
        msg.From = fromAddress
        msg.To = toAddress
        msg.Subject = subject
        Dim info As Specialized.NameValueCollection = GetExceptionInfo(ex, warning)
        msg.Body = EmailFormatter.GetExceptionEmailBody(ex, subject, info)
        msg.BodyFormat = MailFormat.Html

        SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
        SmtpMail.Send(msg)
    End Sub

    Private Shared Function GetExceptionInfo(ByVal ex As Exception, ByVal warning As String) As System.Collections.Specialized.NameValueCollection
        Dim info As New System.Collections.Specialized.NameValueCollection
        Dim message As String
        Dim exceptionType As String
        Dim stackTrace As String
        Dim pageName As String
        Dim serverName As String
        Dim siteName As String
        Dim userName As String
        Dim url As String
        Dim ipAddress As String
        Dim browser As String
        Dim sessionID As String

        If ex Is Nothing Then
            ex = New Exception("Unknown exception was published.")
        End If

        Try
            message = ex.Message
        Catch
            message = "Unknown"
        End Try
        Try
            exceptionType = ex.GetType.ToString
        Catch
            exceptionType = "Unknown"
        End Try
        Try
            stackTrace = ex.StackTrace
            If Not ex.InnerException Is Nothing Then
                stackTrace &= Environment.NewLine & "Inner Exception:" & Environment.NewLine & ex.InnerException.Message
            End If
            If stackTrace Is Nothing Then
                stackTrace = ""
            End If
        Catch
            stackTrace = "Unknown"
        End Try
        Try
            serverName = HttpContext.Current.Request.ServerVariables("SERVER_NAME")
        Catch
            serverName = "Unknown"
        End Try
        Try
            url = HttpContext.Current.Request.Url.ToString
        Catch
            url = "Unknown"
        End Try
        Try
            pageName = FormsAuth.PageName
        Catch
            pageName = "Unknown"
        End Try
        Try
            ipAddress = HttpContext.Current.Request.ServerVariables("Remote_ADDR")
        Catch except As Exception
            ipAddress = "Unknown"
        End Try
        Try
            browser = HttpContext.Current.Request.Browser.Browser & " " & HttpContext.Current.Request.Browser.Version
        Catch except As Exception
            browser = "Unknown"
        End Try
        Try
            sessionID = HttpContext.Current.Session.SessionID
        Catch except As Exception
            sessionID = "Unknown"
        End Try
        Try
            userName = HttpContext.Current.User.Identity.Name
        Catch
            userName = "Unknown"
        End Try
        Try
            siteName = HttpContext.Current.Request.Url.Scheme & "://" & HttpContext.Current.Request.Url.Host & HttpContext.Current.Request.ApplicationPath
        Catch
            siteName = "Unknown"
        End Try


        Try
            info.Add("Time Stamp", DateTime.Now.ToString)
            info.Add("Server Name", serverName)
            info.Add("Site", siteName)
            info.Add("URL", url)
            info.Add("Page Name", pageName)
            info.Add("User Name", userName)
            info.Add("IP Address", ipAddress)
            info.Add("Broswer", browser)
            info.Add("Session ID", sessionID)

            'If an additional warning was passed in then add it
            If warning.Length > 0 Then
                info.Add("Warning", warning)
            End If
        Catch
        End Try

        Return info
    End Function

#End Region


End Class
