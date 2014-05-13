Public Class ExportService

    Private WithEvents mExportService As New Nrc.DataMart.Library.ExportService(Config.ExportIntervalSeconds, Config.OutputFolderPath, Config.ErroredFolderPath, Config.FileExpirationDays, Config.ErroredFileExpirationDays)

    Protected Overrides Sub OnStart(ByVal args() As String)
        Try
            mExportService.Start()
        Catch ex As Exception
            My.Application.Log.WriteException(ex, TraceEventType.Critical, "Service could not start." & vbCrLf & vbCrLf & ex.ToString)
            Throw
        End Try
    End Sub

    Protected Overrides Sub OnStop()
        mExportService.Stop()
    End Sub

    Protected Overrides Sub OnContinue()
        mExportService.Resume()
    End Sub

    Protected Overrides Sub OnPause()
        mExportService.Pause()
    End Sub

    Private Sub mExportService_LogMessage(ByVal sender As Object, ByVal e As Library.ExportService.LogMessageEventArgs) Handles mExportService.LogMessage
        If e.Severity = Library.ExportService.LogMessageSeverity.Error Then
            My.Application.Log.WriteEntry(e.Message, TraceEventType.Error)
        End If
    End Sub
End Class
