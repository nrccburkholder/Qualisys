Public Class ResponseImportService
    Private WithEvents mService As New ServiceLibrary.ServiceLibrary
    Protected Overrides Sub OnStart(ByVal args() As String)
        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.
        mService.Start()
    End Sub

    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.
        mService.Stop()
    End Sub
    Protected Overrides Sub OnContinue()
        mService.Resume()
    End Sub
    Protected Overrides Sub OnPause()
        mService.Pause()
    End Sub
    Private Sub LogMessage(ByVal sender As Object, ByVal e As ServiceLibrary.ServiceLibrary.EventLogArgs) Handles mService.LogMessage
        System.Diagnostics.EventLog.WriteEntry("Payer Solutions Service", e.Message)
    End Sub
End Class
