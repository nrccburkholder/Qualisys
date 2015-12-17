Imports NLog
Imports NLog.Targets
Imports NLog.Config


Public Class Log
    Private Shared _logger As Logger = Nothing
    Private Shared _logTrace As Boolean = False

    Public Shared Sub WriteTrace(ByVal text As String)
        InitLogger()
        _logger.Trace(text)
    End Sub

    Public Shared Sub WriteInfo(ByVal text As String)
        InitLogger()
        _logger.Info(text)
    End Sub

    Public Shared Sub WriteInfo(ByVal text As String, ByVal ex As Exception)
        InitLogger()
        _logger.Info(text, ex)
    End Sub

    Public Shared Sub WriteError(ByVal text As String)
        InitLogger()
        _logger.Error(text)
    End Sub

    Public Shared Sub WriteError(ByVal text As String, ByVal ex As Exception)
        InitLogger()
        _logger.Error(text, ex)
    End Sub

    Public Shared Sub LogTrace(ByVal flag As Boolean)
        _logTrace = flag
    End Sub

    Public Shared Sub InitLogger(Optional ByVal filePath As String = Nothing)
        If _logger IsNot Nothing Then
            Return
        End If

        Dim config As LoggingConfiguration = New LoggingConfiguration()

        Dim fileTarget As FileTarget = New FileTarget()
        Dim fileName As String
        If filePath Is Nothing Then
            fileName = Settings.GetLogFilePath()
        Else
            fileName = filePath
        End If
        fileTarget.FileName = fileName
        ' The ### is a magic NLog thing for its log-rolling: # means keep 10 backups, ## means keep 100, etc
        fileTarget.ArchiveFileName = fileName.Replace(".log", "##.log")
        fileTarget.Layout = "[${longdate}] ${level}: ${message} ${exception:format=tostring}"
        fileTarget.ArchiveAboveSize = 1 * 1024 * 1024  ' Roll logs at 1 meg
        config.AddTarget("file", fileTarget)

        Dim lvl As LogLevel = LogLevel.Off
        If _logTrace Then
            lvl = LogLevel.Trace
        End If

        Dim fileRule As LoggingRule = New LoggingRule("*", lvl, fileTarget)
        config.LoggingRules.Add(fileRule)

        Dim eventTarget As EventLogTarget = New EventLogTarget()
        config.AddTarget("eventlog", eventTarget)

        Dim eventRule As LoggingRule = New LoggingRule("*", LogLevel.Info, eventTarget)
        config.LoggingRules.Add(eventRule)

        LogManager.Configuration = config

        _logger = LogManager.GetLogger("NRC Logger")
    End Sub
End Class
