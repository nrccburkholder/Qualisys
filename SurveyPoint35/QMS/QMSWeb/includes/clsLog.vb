Imports System.Text
Imports log4net

Public Class clsLog
    Public Shared Sub LogError(ByVal type As System.Type, ByVal msg As String, ByVal ex As Exception)
        Dim sb As StringBuilder = New StringBuilder

        sb.AppendFormat("{0}: ", msg)
        sb.AppendFormat("{0}, ", HttpContext.Current.Request.RawUrl())
        If IsNumeric(HttpContext.Current.User.Identity.Name) Then
            sb.AppendFormat("User {0}, ", HttpContext.Current.User.Identity.Name)
        End If
        Dim log As ILog = LogManager.GetLogger(type)
        log.Error(sb.ToString(), ex)
    End Sub
End Class
