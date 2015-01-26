Imports Nrc.Framework.WinForms
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)

    Private mClientStudySurveyNavigator As New ClientStudySurveyNavigator
    Private mSampleSection As New SampleSection

    Private mReportNavigator As New ReportNavigator
    Private mReportSection As New ReportSection

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
        Me.Text = My.Application.Info.Title
        Me.EnvironmentLabel.Text = AppConfig.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        mUIRelations.Add(Me.SampleTab, New UIRelation(mClientStudySurveyNavigator, mSampleSection))
        mUIRelations.Add(Me.ReportsTab, New UIRelation(mReportNavigator, mReportSection))

        'Remove the reports tab cause we are cool enough to have this feature 
        Me.MultiPane.Tabs.Remove(Me.ReportsTab)

        Me.ActivateTab(Me.MultiPane.Tabs(0))

        'Dim initDbMethod As New InitDB(AddressOf InitializeDB)
        'initDbMethod.BeginInvoke(Nothing, Nothing)
    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged
        If mUIRelations.ContainsKey(e.NewTab) Then
            Me.ActivateTab(e.NewTab)
        Else
            Me.MultiPane.LoadNavigationControl(Nothing)
            Me.MainPanel.Panel2.Controls.Clear()
        End If
    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging
        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowUnload
        End If
    End Sub

    Private Sub ActivateTab(ByVal tab As Nrc.Framework.WinForms.MultiPaneTab)
        Try
            Me.Cursor = Cursors.WaitCursor

            Me.MainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(tab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(tab).SectionControl

            Me.MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            Me.MainPanel.Panel2.Controls.Add(sectionCtrl)
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try
    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        'Save the window state and then set it to normal so we can get the size and location
        My.Settings.MainFormWindowState = Me.WindowState
        Me.WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Me.Location
        My.Settings.MainFormSize = Me.Size

        'Save teh location of the splitter
        My.Settings.MainFormSplitterLocation = Me.MainPanel.SplitterDistance

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.Close()
    End Sub

End Class

