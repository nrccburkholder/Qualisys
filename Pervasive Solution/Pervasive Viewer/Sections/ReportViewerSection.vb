Imports Nrc.QualiSys.Pervasive.Library

Public Class ReportViewerSection

    Private WithEvents mNavigator As ClientStudySurveyNavigator
    Private mDataFile As DataFile


#Region " Base Class Overrides"
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, ClientStudySurveyNavigator)

    End Sub
#End Region

#Region " Navigator Events "
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As ClientStudySurveySelectionChangedEventArgs) Handles mNavigator.SelectionChanged

        Select Case e.SelectionType
            Case Navigation.NavigationNodeType.DataFile
                mDataFile = DataFile.Get(mNavigator.SelectedDataFile.Id)
                LoadReport()

        End Select

    End Sub
#End Region

#Region " Private Methods "
    Private Sub LoadReport()
        Dim URL As String
        Cursor = Cursors.WaitCursor

        Try
            PaneCaption.Caption = String.Format("Report Viewer - {0} ({1})", mDataFile.FileName, mDataFile.Id)
            'Set the URL to the Reporting Services web server
            URL = mDataFile.ReportURL
            ReportWebBrowser.Navigate(URL)

        Catch ex As Exception
            Globals.ReportException(ex, "Report Exception")
            MessageBox.Show(ex.Message, "Report Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Cursor = Cursors.Default
        End Try
    End Sub
#End Region

#Region " Private Events "
    Private Sub AbandonButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AbandonButton.Click

        If MessageBox.Show(String.Format("Are you sure you want to abandon file {0}?", mDataFile.FileName), "Abandon File", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
            Dim dfStates As DataFileStateCollection = DataFileState.GetByDataFileId(mDataFile.Id)

            'Looping through states although there should only be 1
            For Each dfstate As DataFileState In dfStates
                dfstate.datOccurred = Now
                dfstate.StateId = DataFileStates.Abandoned
            Next

            dfStates.Save()
            ReportWebBrowser.Navigate("about:blank")
            mNavigator.PopulateTree()
        End If

    End Sub

    Private Sub ApproveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ApproveButton.Click

        If MessageBox.Show(String.Format("Are you sure you want to approve file {0}?", mDataFile.FileName), "Approve File", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
            Dim dfStates As DataFileStateCollection = DataFileState.GetByDataFileId(mDataFile.Id)

            'Looping through states although there should only be 1
            For Each dfstate As DataFileState In dfStates
                dfstate.datOccurred = Now
                dfstate.StateId = DataFileStates.AwaitingApply
            Next

            dfStates.Save()
            ReportWebBrowser.Navigate("about:blank")
            mNavigator.PopulateTree()
        End If

    End Sub

    Private Sub ReportWebBrowser_DocumentCompleted(ByVal sender As Object, ByVal e As System.Windows.Forms.WebBrowserDocumentCompletedEventArgs) Handles ReportWebBrowser.DocumentCompleted

        AbandonButton.Enabled = False
        ApproveButton.Enabled = False

        If ReportWebBrowser.Document IsNot Nothing Then
            If Not ReportWebBrowser.DocumentText.Contains("Reporting Services Error") AndAlso ReportWebBrowser.Url.ToString <> "about:blank" Then
                AbandonButton.Enabled = True
                ApproveButton.Enabled = True
            End If
        End If

    End Sub
#End Region
End Class
