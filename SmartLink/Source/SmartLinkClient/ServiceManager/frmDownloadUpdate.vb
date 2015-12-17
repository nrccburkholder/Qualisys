Public Class frmDownloadUpdate
    Private WithEvents webClient As New WebClient()

    Sub New(ByVal downloadAddress As Uri, ByVal saveFileName As String)
        InitializeComponent()

        Try
            webClient.DownloadFileAsync(downloadAddress, saveFileName)
        Catch webEx As WebException
            'The URI formed by combining BaseAddress and address is invalid.
            '   -or-
            'An error occurred while downloading the resource.
        Catch invEx As InvalidOperationException
            'The local file specified by fileName is in use by another thread.
        Catch ex As Exception
            'Everything else!
        End Try
    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        If webClient.IsBusy Then
            webClient.CancelAsync()
        End If
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub webClient_DownloadFileCompleted(ByVal sender As System.Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs) Handles webClient.DownloadFileCompleted
        cmdCancel.Enabled = False
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub webClient_DownloadProgressChanged(ByVal sender As System.Object, ByVal e As System.Net.DownloadProgressChangedEventArgs) Handles webClient.DownloadProgressChanged
        ProgressBar1.Value = e.ProgressPercentage
    End Sub

End Class