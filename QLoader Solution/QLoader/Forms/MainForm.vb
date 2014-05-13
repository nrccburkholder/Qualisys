Imports NRC.Framework.WinForms
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private WithEvents mPackageNavigator As PackageNavigator

    Private WithEvents mSetupSection As PackageSetupSection
    Private WithEvents mLoadingQueueSection As LoadingQueueSection
    Private WithEvents mLoadReviewSection As LoadReviewSection
    Private WithEvents mRollbacksSection As RollbacksSection
    Private WithEvents mReportSection As ReportViewer

    Private Sub MainForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        InitializeUI()

    End Sub

    Public Sub QuickReview(ByVal clientId As Integer, ByVal studyId As Integer, ByVal packageId As Integer, ByVal dataFileId As Integer)

        'Dim pack As DTSPackage
        MultiPane.SelectedTab = LoadReviewTab
        mLoadReviewSection.QuickReview(clientId, studyId, packageId, dataFileId)

    End Sub

    Public Sub QuickReport(ByVal clientID As Integer, ByVal studyID As Integer, ByVal packageID As Integer, ByVal dataFileID As Integer)

        MultiPane.SelectedTab = ReportsTab
        mReportSection.QuickReport(clientID, studyID, packageID, dataFileID)

    End Sub

    Private Sub InitializeUI()

        'Set the username and environment labels in the status bar
        UserNameLabel.Text = CurrentUser.LoginName
        EnvironmentLabel.Text = String.Format("{0} ({1})", AppConfig.EnvironmentName, GetDBServer)
        VersionLabel.Text = "v" & Application.ProductVersion
        Text = Application.ProductName
        ServiceStatusLabel.Text = GetDtsServiceStatus()

        mPackageNavigator = New PackageNavigator

        'Only show package setup to those who have access
        If Not CurrentUser.IsPackageCreator Then
            MultiPane.Tabs.Remove(PackageSetupTab)
        Else
            mSetupSection = New PackageSetupSection
            mUIRelations.Add(PackageSetupTab, New UIRelation(mPackageNavigator, mSetupSection))
        End If

        'Only show loading queue to those who have access
        If Not CurrentUser.IsFileLoader Then
            MultiPane.Tabs.Remove(LoadingQueueTab)
            MultiPane.Tabs.Remove(RollbacksTab)
        Else
            mLoadingQueueSection = New LoadingQueueSection
            mUIRelations.Add(LoadingQueueTab, New UIRelation(mPackageNavigator, mLoadingQueueSection))

            mRollbacksSection = New RollbacksSection
            mUIRelations.Add(RollbacksTab, New UIRelation(mPackageNavigator, mRollbacksSection))
        End If

        'Initial Load Review and Report sections
        mLoadReviewSection = New LoadReviewSection
        mUIRelations.Add(LoadReviewTab, New UIRelation(mPackageNavigator, mLoadReviewSection))

        mReportSection = New ReportViewer
        mUIRelations.Add(ReportsTab, New UIRelation(mPackageNavigator, mReportSection))

        ActivateTab(MultiPane.Tabs(0))

        'TODO: Put splash screen back
        'Show the awsome splash screen
        'Dim splash As New frmSplash(True)
        'splash.ShowDialog()

    End Sub


    Private Sub ActivateTab(ByVal tab As NRC.Framework.WinForms.MultiPaneTab)

        Try
            Cursor = Cursors.WaitCursor

            MainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(tab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(tab).SectionControl

            MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            MainPanel.Panel2.Controls.Add(sectionCtrl)
            If mActiveTab IsNot Nothing Then
                mUIRelations(mActiveTab).SectionControl.InactivateSection()
            End If
            sectionCtrl.ActivateSection()

            ToolStrip1.Items.Clear()
            If sectionCtrl.ToolStripItems IsNot Nothing Then
                For Each item As ToolStripItem In sectionCtrl.ToolStripItems
                    ToolStrip1.Items.Add(item)
                Next
            End If

            mActiveTab = tab

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If mUIRelations.ContainsKey(e.NewTab) Then
            ActivateTab(e.NewTab)
        Else
            MultiPane.LoadNavigationControl(Nothing)
            MainPanel.Panel2.Controls.Clear()
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowInactivate
        End If

    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        If Not mUIRelations(mActiveTab).SectionControl.AllowInactivate Then
            e.Cancel = True
        End If

    End Sub

    Private Function GetDtsServiceStatus() As String

        'Set the correct computer name and service name
        svcController.MachineName = AppConfig.Params("QLDTSServiceMachine").StringValue
        svcController.ServiceName = AppConfig.Params("QLDTSServiceName").StringValue

        Try
            'Refresh the status
            svcController.Refresh()
            'Display on screen
            Return String.Format("QLoader Service: {0}", System.Enum.GetName(GetType(System.ServiceProcess.ServiceControllerStatus), svcController.Status))

        Catch ex As Exception
            Return String.Format("QLoader Service: {0}", "Unknown")

        End Try

    End Function

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click

        If mUIRelations(mActiveTab).SectionControl.AllowInactivate Then
            Close()
        End If

    End Sub

    Private Sub FunctionLibraryToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FunctionLibraryToolStripMenuItem.Click

        'The user can view, create and modify only Global level
        'if the permission is true.  Need to create/modify client
        'level function through package setup pane.
        Dim customFunctionForm As New frmCustomFunction(0)

        customFunctionForm.ShowDialog(Me)

    End Sub

   
End Class