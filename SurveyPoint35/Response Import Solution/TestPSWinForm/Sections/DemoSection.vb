Imports PS.ResponseImport.ServiceLibrary
Public Class DemoSection
    Private mSubSection As Section
    Private WithEvents mService As New ServiceLibrary.ServiceLibrary
    Friend WithEvents mNavigator As DemoNavigator

#Region "Baseclass Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, DemoNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

#End Region    
    Private Sub DemoSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        
    End Sub

    Private Sub cmdStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStart.Click
        mService.Start()
    End Sub

    Private Sub LogMessage(ByVal sender As Object, ByVal e As ServiceLibrary.ServiceLibrary.EventLogArgs) Handles mService.LogMessage
        'Me.txtNotes.Text += e.Message & vbCrLf        
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
End Class
