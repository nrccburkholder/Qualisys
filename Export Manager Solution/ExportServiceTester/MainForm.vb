Imports Nrc.DataMart.Library

Public Class MainForm

    Private WithEvents mExportService As ExportService

    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.OutputFolder.Text = Config.OutputFolderPath
        Me.ErroredFolder.Text = Config.ErroredFolderPath
        Me.CreateService()
    End Sub

    Private Sub StartButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles StartButton.LinkClicked
        Try
            OutputLog.Clear()
            mExportService.Start()
        Catch ex As Exception
            My.Application.Log.WriteException(ex, TraceEventType.Critical, "Service could not start." & vbCrLf & vbCrLf & ex.ToString)
            LogMessage(ex.ToString)
            'MessageBox.Show(ex.ToString, "Service Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StopButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles StopButton.LinkClicked
        mExportService.Stop()
    End Sub

    Private Sub PauseButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles PauseButton.LinkClicked
        mExportService.Pause()
    End Sub

    Private Sub ResumeButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ResumeButton.LinkClicked
        mExportService.Resume()
    End Sub

    Private Sub RestartButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RestartButton.LinkClicked
        mExportService.Stop()
        mExportService.Start()
    End Sub

    Private mEventNum As Integer = 0
    Private Sub mExportService_LogMessage(ByVal sender As Object, ByVal e As Library.ExportService.LogMessageEventArgs) Handles mExportService.LogMessage
        mEventNum += 1
        LogMessage(e.Message & " (" & mEventNum & ")")
    End Sub

    Private Delegate Sub LogMessageDelegate(ByVal message As String)

    Private Sub LogMessage(ByVal message As String)
        If Me.InvokeRequired Then
            Me.BeginInvoke(New LogMessageDelegate(AddressOf LogMessage), New Object() {message})
            Exit Sub
        End If

        Me.OutputLog.AppendText(message & Environment.NewLine)
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        Me.mExportService.Stop()
    End Sub

    Private Sub ResetButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ResetButton.LinkClicked
        Me.CreateService()
    End Sub

    Private Sub CreateService()
        mExportService = New ExportService(CInt(ServiceInterval.Value), OutputFolder.Text, ErroredFolder.Text, Config.FileExpirationDays, Config.ErroredFileExpirationDays)
    End Sub
End Class
