Imports PS.Framework.WinForms
Public Class MainForm
    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab
    Private mMailMergeNavigator As MailMergeNavigator
    Private mMailMergeSection As MailMergeSection
    Private mReportingNavigator As ReportNavigator
    Private mReportingSection As ReportSection
    Private mXMLViewerNavigator As XMLViewerNavigator
    Private mXMLViewerSection As XMLViewerSection

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()
    End Sub
    Private Sub InitializeUI()
        Me.WindowState = My.Settings.MainFormWindowState
        Me.Location = My.Settings.MainFormLocation
        Me.Size = My.Settings.MainFormSize
        Me.splitMainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

        Me.Text = CurrentUser.AppName
        Me.lblEnvironment.Text = Config.EnvironmentName
        Me.lblVersion.Text = "v" & My.Application.Info.Version.ToString
        Me.lblUser.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        'If CurrentUser.IsUpdateEventCodes Then
        mMailMergeNavigator = New MailMergeNavigator
        mMailMergeSection = New MailMergeSection
        mUIRelations.Add(Me.tabMailMerge, New UIRelation(mMailMergeNavigator, mMailMergeSection))
        mReportingNavigator = New ReportNavigator
        mReportingSection = New ReportSection
        mUIRelations.Add(Me.tabReporting, New UIRelation(mReportingNavigator, mReportingSection))
        mXMLViewerNavigator = New XMLViewerNavigator
        mXMLViewerSection = New XMLViewerSection
        mUIRelations.Add(Me.tabXMLViewer, New UIRelation(mXMLViewerNavigator, mXMLViewerSection))
        'Else
        'MultiPane.Tabs.Remove(DemoTab)
        'End If

        If Me.MultiPane.Tabs.Count > 0 Then
            Me.ActivateTab(Nothing, Me.MultiPane.Tabs(0))
        Else
            Me.Close()
        End If

    End Sub
    Private Sub ActivateTab(ByVal oldTab As PS.Framework.WinForms.MultiPaneTab, ByVal newTab As PS.Framework.WinForms.MultiPaneTab)

        Try
            Me.Cursor = Cursors.WaitCursor

            Me.splitMainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(newTab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(newTab).SectionControl

            Me.MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            Me.splitMainPanel.Panel2.Controls.Add(sectionCtrl)
            Me.mActiveTab = newTab

            If oldTab IsNot Nothing AndAlso mUIRelations(oldTab).SectionControl IsNot Nothing Then
                mUIRelations(oldTab).SectionControl.InactivateSection()
            End If
            sectionCtrl.ActivateSection()
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try
    End Sub
    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        'Check the active tab to see if we can leave
        If mActiveTab IsNot Nothing Then
            Dim sectionCtrl As Section = mUIRelations(mActiveTab).SectionControl
            If Not sectionCtrl.AllowInactivate Then
                'For some reason we are not allowed to leave the active control
                e.Cancel = True
                Exit Sub
            End If
        End If

        'Save the window state and then set it to normal so we can get the size and location
        My.Settings.MainFormWindowState = Me.WindowState
        Me.WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Me.Location
        My.Settings.MainFormSize = Me.Size

        'Save the location of the splitter
        My.Settings.MainFormSplitterLocation = Me.splitMainPanel.SplitterDistance
    End Sub
    Private Sub MainForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As PS.Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowInactivate
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As PS.Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged
        If e.NewTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.NewTab) Then
            Me.ActivateTab(e.OldTab, e.NewTab)
        Else
            Me.MultiPane.LoadNavigationControl(Nothing)
            Me.splitMainPanel.Panel2.Controls.Clear()
        End If
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Application.Exit()
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Dim pgDepth As Integer = pgBar.Value
        pgDepth += 10
        If pgDepth > 100 Then
            pgDepth = 0
        End If
        pgBar.Value = pgDepth
    End Sub
End Class
