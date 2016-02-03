Public Class ReportSection
#Region " Event Handlers "
    Private Sub cmdViewBundlingReport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdViewBundlingReport.Click
        Dim queueID As Integer
        If txtMergeQueueID.Text.Length > 0 AndAlso IsNumeric(txtMergeQueueID.Text) Then
            queueID = CInt(txtMergeQueueID.Text)
            Try
                ViewBundlingReport(queueID)
            Catch ex As Exception
                MessageBox.Show(ex.Message, "Reporting", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        Else
            MessageBox.Show("You must enter a valid Merge Queue id.", "Reporting", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.txtMergeQueueID.Focus()
        End If
    End Sub
#End Region
#Region " Private Methods "
    Private Sub ViewBundlingReport(ByVal queueID As Integer)
        Dim url As String = String.Empty
        Cursor.Current = Cursors.WaitCursor
        Try
            tsReportLabel.Text = String.Format("Report Viewer - {0} ({1})", "Bundling Report", queueID)
            url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&QueueID={2}", _
                                Config.ReportServer, Config.BundlingReport, queueID)
            Me.WebBrowser1.Navigate(url)
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            Cursor.Current = Cursors.Default
        End Try
    End Sub
#End Region

    Private Sub cmdQueStatusReport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdQueStatusReport.Click
        Dim dteStart As DateTime = dteStartDate.Value
        Dim dteEnd As DateTime = dteEndDate.Value
        dteEnd = dteEnd.AddDays(1)
        ViewQueueStatusReport(dteStart, dteEnd)
    End Sub
    Private Sub ViewQueueStatusReport(ByVal dteStart As DateTime, ByVal dteEnd As DateTime)
        Dim url As String = String.Empty
        Cursor.Current = Cursors.WaitCursor
        Try
            url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&StartDate={2}&EndDate={3}", _
                                Config.ReportServer, Config.MergeQueueStatus, dteStart.ToShortDateString, dteEnd.ToShortDateString)
            Me.WebBrowser2.Navigate(url)
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            Cursor.Current = Cursors.Default
        End Try
    End Sub

    Private Sub ReportSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        dteStartDate.Value = Now
        dteEndDate.Value = Now
    End Sub

End Class
