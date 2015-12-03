Imports NLog

Public Class Logs
    Private Shared myLogger As Logger = LogManager.GetCurrentClassLogger()

    Public Shared Function FormatMessage(ByVal msg As String) As String
        Return String.Format("{0} : {1}", DateTime.Now.ToString(), msg)
    End Function


    Public Shared Sub Info(ByVal info As String)
        myLogger.Log(NLog.LogLevel.Info, info)
    End Sub


    Public Shared Sub LogException(ByVal ex As Exception, ByVal info As String)
        Dim message As String = String.Format("{0} {1}", info, ex.Message)
        myLogger.Fatal(ex, message)
    End Sub

End Class
