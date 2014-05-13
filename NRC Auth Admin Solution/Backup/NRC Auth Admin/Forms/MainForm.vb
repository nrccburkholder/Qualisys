Imports Nrc.Framework.WinForms

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mOrgUnitNavigator As New OrgUnitNavigator
    Private mUserManagementSection As New UserManagementSection
    Private mMassEmailSection As New MassEmailSection

    Private mApplicationNavigator As ApplicationNavigator
    Private mApplicationManagementSection As ApplicationManagementSection

    Private mReportNavigator As New ReportNavigator
    Private mReportSection As New ReportSection

    Private mOneClickSection As New OneClickSection

    Private mClientStudyNavigator As New ClientStudyNavigator
    Private mEReportsFiltersSection As New EReportsFiltersSection

    Private mECommentsFiltersSection As New CommentFilterSection

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Location = My.Settings.MainFormLocation
        Me.Size = My.Settings.MainFormSize
        Me.WindowState = My.Settings.MainFormWindowState
        Me.MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

        InitializeUI()

    End Sub

    Private Sub InitializeUI()
        Me.Text = My.Application.Info.Title
        Me.EnvironmentLabel.Text = Config.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)


        'mUIRelations.Add(Me.UserManagementTab, New UIRelation(mOrgTreeNavigator, mUserManagementSection))
        mUIRelations.Add(Me.UserManagementTab, New UIRelation(mOrgUnitNavigator, mUserManagementSection))


        'Add Application Managment
        If CurrentUser.AllowApplicationManagment Then
            mApplicationNavigator = New ApplicationNavigator
            mApplicationManagementSection = New ApplicationManagementSection
            mUIRelations.Add(Me.ApplicationsTab, New UIRelation(mApplicationNavigator, mApplicationManagementSection))
        Else
            Me.MultiPane.Tabs.Remove(Me.ApplicationsTab)
        End If
        If CurrentUser.AllowMassEmail Then
            mUIRelations.Add(MassEmailTab, New UIRelation(mOrgUnitNavigator, mMassEmailSection))
        Else
            MultiPane.Tabs.Remove(MassEmailTab)
        End If

        mUIRelations.Add(Me.ReportsTab, New UIRelation(mReportNavigator, mReportSection))
        mUIRelations.Add(Me.OneClickTab, New UIRelation(mOrgUnitNavigator, mOneClickSection))
        mUIRelations.Add(Me.EReportsFiltersTab, New UIRelation(mClientStudyNavigator, mEReportsFiltersSection))
        mUIRelations.Add(Me.CommentFilterTab, New UIRelation(mOrgUnitNavigator, mECommentsFiltersSection))


        Me.ActivateTab(Nothing, Me.MultiPane.Tabs(0))
    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Nrc.Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged
        If mUIRelations.ContainsKey(e.NewTab) Then
            Me.ActivateTab(e.OldTab, e.NewTab)
        Else
            Me.MultiPane.LoadNavigationControl(Nothing)
            Me.MainPanel.Panel2.Controls.Clear()
        End If
    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Nrc.Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging
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

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        If mActiveTab IsNot Nothing Then
            If Not Me.mUIRelations(mActiveTab).SectionControl.AllowInactivate Then
                e.Cancel = True
            Else
                Globals.OnMainFormClosing(Me, EventArgs.Empty)
            End If
        End If

        If Not e.Cancel Then
            'Save the form location information
            If Me.WindowState = FormWindowState.Normal Then
                My.Settings.MainFormLocation = Me.Location
                My.Settings.MainFormSize = Me.Size
            End If
            My.Settings.MainFormWindowState = Me.WindowState
            My.Settings.MainFormSplitterLocation = Me.MainPanel.SplitterDistance
        End If

    End Sub
End Class

