Imports System.Web.UI
Imports System.Web.Mail

Public Class EmailFormatter

    Private Const PRIVACY_NOTICE As String = "This email may contain confidential health information that is legally privileged.  This information is intended for the use of the named recipient(s). The authorized recipient of this information is prohibited from disclosing this information to any party unless required to do so by law or regulation and is required to destroy the information after its stated need has been fulfilled.  If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or action taken in reliance on the contents of this email is strictly prohibited.  If you receive this e-mail message in error, please notify the sender immediately to arrange disposition of the information."

    Public Shared Function GetResetPasswordEmail(ByVal userName As String, ByVal password As String, ByVal url As String) As String
        Dim sb As New System.Text.StringBuilder
        Dim writer As New System.IO.StringWriter(sb)
        Dim html As New System.Web.UI.HtmlTextWriter(writer)

        html.Write("Your National Research Corporation password has been reset.  Below is your user name and temporary password. ")
        html.Write("Please try to <a href='{0}'>sign in</a>&nbsp;again.  Just follow the provided link, select the appropriate area, and enter your user name and password provided below.", url)
        html.Write("<BR><BR>User name: {0}<BR>Password: {1}", userName, password)
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("Please do not reply to this email. If you continue to have problems logging in, please call Log On Support at (US) 1-800-388-4264 | (CANADA) 1-866-771-8231.")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("<Font Size='2'>")
        html.Write("<STRONG>CONFIDENTIALITY NOTICE:</STRONG>")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("{0}", PRIVACY_NOTICE)
        html.Write("</Font>")

        Return sb.ToString
    End Function
    Public Shared Function GetUserListEmail(ByVal usernamelist As Collections.ArrayList) As String
        Dim sb As New System.Text.StringBuilder
        Dim writer As New System.IO.StringWriter(sb)
        Dim html As New System.Web.UI.HtmlTextWriter(writer)

        html.Write("Below is the list of all of your National Research Corporation accounts. ")
        html.Write("If you have forgotten the password to an account, you can click on the corresponding ""reset password"" link next to the account name.  An email containing your new logon information will be sent.  <p/><p/>")

        html.Write("<table cellpadding=7>")

        For Each item As String In usernamelist
            html.Write("<tr><td>")
            html.Write(item.ToString)
            html.Write("</td><td>")
            html.Write("<a href='" & AppConfig.Instance.SiteUrl & "PasswordRecover.aspx?username=" & item.ToString & "&rstpwd=" & "'>")
            html.Write("Reset Password</a>")
            html.Write("</td></tr>")
        Next

        html.Write("</table>")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("Please do not reply to this email. If you continue to have problems logging in, please call Log On Support at (US) 1-800-388-4264 | (CANADA) 1-866-771-8231.")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("<Font Size='2'>")
        html.Write("<STRONG>CONFIDENTIALITY NOTICE:</STRONG>")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("{0}", PRIVACY_NOTICE)
        html.Write("</Font>")

        Return sb.ToString
    End Function

    Public Shared Function GetNewAccountEmail(ByVal userName As String, ByVal password As String, ByVal url As String) As String
        Dim sb As New System.Text.StringBuilder
        Dim writer As New System.IO.StringWriter(sb)
        Dim html As New System.Web.UI.HtmlTextWriter(writer)

        html.Write("Congratulations. You have successfully established your Individual Account and it is ready for use. To activate your account click the link below and when prompted enter the user name and password provided in this email.")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("When you access your site for the first time you will be asked to create your own unique password. To do this copy the temporary password from this email and then create your own unique password.")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("User name: {0}<BR>Password: {2}<BR>Web site: <a href='{1}'>National Research Corporation Home</a>", userName, url, password)
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("Please do not reply to this email. If you continue to have problems logging in, please call Log On Support at (US) 1-800-388-4264 | (CANADA) 1-866-771-8231.")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("<Font Size='2'>")
        html.Write("<STRONG>CONFIDENTIALITY NOTICE:</STRONG>")
        html.Write("<BR>")
        html.Write("<BR>")
        html.Write("{0}", PRIVACY_NOTICE)
        html.Write("</Font>")

        Return sb.ToString

    End Function


    Public Shared Function GetExceptionEmailBody(ByVal ex As Exception, ByVal title As String, ByVal info As System.Collections.Specialized.NameValueCollection) As String
        Dim exType As String = ""
        Dim exMessage As String = ""
        Dim strStackTrace As String = ""

        Dim sb As New System.Text.StringBuilder
        Dim writer As New HtmlTextWriter(New System.IO.StringWriter(sb))
        BeginExceptionHTML(writer)

        WriteExceptionTitle(writer, title)
        If Not info Is Nothing Then
            For Each key As String In info.Keys
                If Not key.StartsWith("ExceptionManager.") Then
                    WriteExceptionRow(writer, key, info(key))
                End If
            Next
        End If
        Try
            exType = ex.GetType.ToString
        Catch
            exType = "Unknown"
        End Try
        WriteExceptionRow(writer, "Exception Type", exType)
        Try
            exMessage = ex.Message
        Catch
            exMessage = "Unknown"
        End Try
        WriteExceptionRow(writer, "Message", exMessage)
        Try
            strStackTrace = ex.StackTrace.Replace("at ", "<br>&nbsp;&nbsp;at ")
        Catch
            strStackTrace = "Stack Trace Unavailable."
        End Try
        WriteExceptionRow(writer, "Stack Trace", strStackTrace)
        If Not ex.InnerException Is Nothing Then
            Try
                strStackTrace = ex.InnerException.GetType.ToString & ":" & ex.InnerException.Message & ex.InnerException.StackTrace.Replace("at ", "<br>&nbsp;&nbsp;at ")
            Catch
                strStackTrace = "Inner Exception Stack Trace Unavailable"
            End Try
            WriteExceptionRow(writer, "Inner Stack Trace", strStackTrace)
        End If
        EndExceptionHTML(writer)

        Return sb.ToString
    End Function

    Private Shared Sub BeginExceptionHTML(ByVal writer As System.Web.UI.HtmlTextWriter)
        Dim strTableStyle As String = "{border: Solid 1px #7BADAD;font-size: x-small;background-color: Whitesmoke;font-family: Verdana;}"
        Dim strTitleStyle As String = "{background-color: #7BADAD;color: White;font-weight: bold;font-size: x-small;font-family: Verdana;padding: 5px;}"
        Dim strLabelStyle As String = "{font-weight: bold;}"

        writer.RenderBeginTag(HtmlTextWriterTag.Html)
        writer.RenderBeginTag(HtmlTextWriterTag.Head)
        writer.RenderBeginTag(HtmlTextWriterTag.Style)
        writer.WriteLine(String.Format(".ExTable{0}", strTableStyle))
        writer.WriteLine(String.Format(".ExTitle{0}", strTitleStyle))
        writer.WriteLine(String.Format(".ExLabel{0}", strLabelStyle))
        writer.RenderEndTag()
        writer.RenderEndTag()

        writer.RenderBeginTag(HtmlTextWriterTag.Body)
        writer.AddAttribute(HtmlTextWriterAttribute.Class, "ExTable")
        writer.AddAttribute(HtmlTextWriterAttribute.Border, "0")
        writer.AddAttribute(HtmlTextWriterAttribute.Cellspacing, "0")
        writer.AddAttribute(HtmlTextWriterAttribute.Cellpadding, "3")
        writer.AddAttribute(HtmlTextWriterAttribute.Width, "100%")
        writer.RenderBeginTag(HtmlTextWriterTag.Table)
    End Sub
    Private Shared Sub EndExceptionHTML(ByVal writer As System.Web.UI.HtmlTextWriter)
        writer.RenderEndTag()   '</TABLE>
        writer.RenderEndTag()   '</BODY>
        writer.RenderEndTag()   '</HTML>
    End Sub
    Private Shared Sub WriteExceptionTitle(ByVal writer As HtmlTextWriter, ByVal title As String)
        writer.RenderBeginTag(HtmlTextWriterTag.Tr)
        writer.AddAttribute(HtmlTextWriterAttribute.Colspan, "2")
        writer.AddAttribute(HtmlTextWriterAttribute.Class, "ExTitle")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.Write(title)
        writer.RenderEndTag()   '</TD>
        writer.RenderEndTag()   '</TR>
    End Sub
    Private Shared Sub WriteExceptionRow(ByVal writer As HtmlTextWriter, ByVal label As String, ByVal value As String)
        writer.RenderBeginTag(HtmlTextWriterTag.Tr)
        writer.AddAttribute(HtmlTextWriterAttribute.Nowrap, "true")
        writer.AddAttribute(HtmlTextWriterAttribute.Valign, "top")
        writer.AddAttribute(HtmlTextWriterAttribute.Class, "ExLabel")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.Write(label & ": ")
        writer.RenderEndTag()   '</TD>
        writer.AddAttribute(HtmlTextWriterAttribute.Width, "100%")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)

        If label.ToUpper = "WARNING" Then
            writer.AddAttribute("color", "red")
            writer.RenderBeginTag(HtmlTextWriterTag.Font)
        End If

        writer.Write(value)

        If label.ToUpper = "WARNING" Then
            writer.RenderEndTag()
        End If

        writer.RenderEndTag()   '</TD>
        writer.RenderEndTag()   '</TR>
    End Sub

End Class
