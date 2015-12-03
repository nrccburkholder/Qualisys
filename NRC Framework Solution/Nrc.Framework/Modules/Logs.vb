Imports NLog

Public Module Logs
    Private myLogger As Logger = LogManager.GetCurrentClassLogger()


    Public Function FormatMessage(ByVal msg As String) As String
        Return String.Format("{0} : {1}", DateTime.Now.ToString(), msg)
    End Function


    Public Sub Info(ByVal info As String)
        myLogger.Log(NLog.LogLevel.Info, info)
    End Sub


    Public Sub LogException(ByVal ex As Exception, ByVal info As String)
        Dim message As String = String.Format("{0} {1}", info, ex.Message)
        myLogger.Fatal(ex, message)
    End Sub

End Module
