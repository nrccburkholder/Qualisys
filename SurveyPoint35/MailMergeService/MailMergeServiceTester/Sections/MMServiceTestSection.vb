Imports MailMergeServiceLibrary

Public Class MMServiceTestSection
    Private mSubSection As Section
    Private WithEvents mService As New ServiceLibrary
    Friend WithEvents mNavigator As MMServiceTestNavigator
#Region "Baseclass Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, MMServiceTestNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

#End Region

    Private Sub cmdStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStart.Click
        mService.Start()
    End Sub

    Private Sub cmdStop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStop.Click
        mService.Stop()
    End Sub

    Private Sub cmdPause_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdPause.Click
        mService.Pause()
    End Sub

    Private Sub cmdResume_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdResume.Click
        mService.Resume()
    End Sub
    Private Sub LogMessage(ByVal sender As Object, ByVal e As MailMergeServiceLibrary.ServiceLibrary.EventLogArgs) Handles mService.LogMessage
        'Me.txtNotes.Text += e.Message & vbCrLf        
    End Sub
End Class
