Imports Nrc.Framework.WinForms
Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mUpdateEventNavigator As UpdateEventNavigator
    Private mUpdateEventSection As UpdateEventSection

    Private mClientExportNavigator As ExportNavigator
    Private mExportGroupSection As ExportSection

    '? I do not think that we need a Navigator for this section
    Private mExportFileSection As ExportFileSection
    'Private mFolderNavigator As FolderNavigator
    'Private mFolderSection As FolderSection

    'Private mReportNavigator As ReportNavigator
    'Private mReportSection As ReportSection

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()

        ' Locate and size the form
        Me.Location = My.Settings.MainFormLocation
        Me.Size = My.Settings.MainFormSize
        Me.WindowState = My.Settings.MainFormWindowState
        Me.MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

    End Sub

    Private Sub InitializeUI()

        Me.Text = CurrentUser.AppName
        Me.EnvironmentLabel.Text = Config.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        If CurrentUser.IsUpdateEventCodes Then
            mUpdateEventNavigator = New UpdateEventNavigator
            mUpdateEventSection = New UpdateEventSection
            mUIRelations.Add(Me.UpdateEventCodesTab, New UIRelation(mUpdateEventNavigator, mUpdateEventSection))
        Else
            MultiPane.Tabs.Remove(UpdateEventCodesTab)
        End If

        'TODO: Comment This New Code, Steve!
        If CurrentUser.IsClientExports Then
            mClientExportNavigator = New ExportNavigator
            mExportGroupSection = New ExportSection
            mUIRelations.Add(Me.ClientExportTab, New UIRelation(mClientExportNavigator, mExportGroupSection))
        Else
            MultiPane.Tabs.Remove(ClientExportTab)
        End If

        'Adding new tab to mUIRelations dictionary
        'TODO: Comment This New Code, Steve!
        If CurrentUser.IsExportFile Then

            mExportFileSection = New ExportFileSection
            mUIRelations.Add(Me.ExportFileTab, New UIRelation(Nothing, mExportFileSection))
        Else
            MultiPane.Tabs.Remove(ExportFileTab)
        End If


        If Me.MultiPane.Tabs.Count > 0 Then
            Me.ActivateTab(Nothing, Me.MultiPane.Tabs(0))
        Else
            Me.Close()
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If e.NewTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.NewTab) Then
            Me.ActivateTab(e.OldTab, e.NewTab)
        Else
            Me.MultiPane.LoadNavigationControl(Nothing)
            Me.MainPanel.Panel2.Controls.Clear()
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowInactivate
        End If

    End Sub

    Private Sub ActivateTab(ByVal oldTab As Nrc.Framework.WinForms.MultiPaneTab, ByVal newTab As Nrc.Framework.WinForms.MultiPaneTab)

        Try
            Me.Cursor = Cursors.WaitCursor

            Me.MainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(newTab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(newTab).SectionControl

            Me.MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            Me.MainPanel.Panel2.Controls.Add(sectionCtrl)
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
        My.Settings.MainFormSplitterLocation = Me.MainPanel.SplitterDistance

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click

        'Close the application
        Me.Close()

    End Sub

    Private Sub AboutToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AboutToolStripMenuItem.Click

        Dim about As New AboutBox
        AboutBox.ShowDialog()

    End Sub


End Class

