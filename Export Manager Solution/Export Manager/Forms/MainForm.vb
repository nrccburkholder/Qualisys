Imports Nrc.Framework.WinForms
Imports Nrc.DataMart.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)

    Private mClientStudySurveyNavigator As New ClientStudySurveyNavigator
    Private mHcahpsNavigator As New ClientStudySurveyNavigator(ExportSetType.CmsHcahps, True)
    Private mChartNavigator As New ClientStudySurveyNavigator(ExportSetType.CmsChart, True)
    Private mScheduledFilesClientStudySurveyNavigator As New ClientStudySurveyNavigator(True, False, True)
    Private mCAHPSDefinitionNavigator As New CAHPSNavigator

    Private mStandardDefinitionSection As New StandardDefinitionSection(Library.ExportSetType.Standard)
    Private mCmsDefinitionSection As New StandardDefinitionSection(Library.ExportSetType.CmsHcahps)
    Private mChartDefinitionSection As New StandardDefinitionSection(Library.ExportSetType.CmsChart)
    Private mScheduledExportSection As New ScheduledExportSection
    Private mSpecialUpdatesSection As New SpecialUpdatesSection
    Private mCAHPSDefinitionSection As New CAHPSDefinitionSection
    Private mCAHPSFileHistorySection As New CAHPSFileHistorySection

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Location = My.Settings.MainFormLocation
        Size = My.Settings.MainFormSize
        WindowState = My.Settings.MainFormWindowState
        MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

        InitializeUI()

    End Sub

    Private Sub InitializeUI()

        Text = My.Application.Info.Title
        EnvironmentLabel.Text = AppConfig.EnvironmentName
        VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        mUIRelations.Add(StandardDefinitionTab, New UIRelation(mClientStudySurveyNavigator, mStandardDefinitionSection))
        mUIRelations.Add(CmsDefinitionTab, New UIRelation(mHcahpsNavigator, mCmsDefinitionSection))
        mUIRelations.Add(CHARTExportsTab, New UIRelation(mChartNavigator, mChartDefinitionSection))
        mUIRelations.Add(CAHPSExportsTab, New UIRelation(mCAHPSDefinitionNavigator, mCAHPSDefinitionSection))
        mUIRelations.Add(CAHPSFileHistoryTab, New UIRelation(mCAHPSDefinitionNavigator, mCAHPSFileHistorySection))
        mUIRelations.Add(ScheduledExportsTab, New UIRelation(mScheduledFilesClientStudySurveyNavigator, mScheduledExportSection))

        'SK 10/08/2008 Does User Have Access To Special Updates
        If CurrentUser.IsSpecialUpdates Then
            mUIRelations.Add(SpecialUpdatesTab, New UIRelation(mClientStudySurveyNavigator, mSpecialUpdatesSection))
        Else
            MultiPane.Tabs.Remove(SpecialUpdatesTab)
        End If

        ActivateTab(Nothing, MultiPane.Tabs(0))

        ORYXToolStripMenuItem.Visible = CurrentUser.IsOryxUser

        OptionsToolStripMenuItem.Visible = OptionsToolStripMenuItem.HasDropDownItems

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If mUIRelations.ContainsKey(e.NewTab) Then
            ActivateTab(e.OldTab, e.NewTab)
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

    Private Sub ActivateTab(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)

        Try
            Cursor = Cursors.WaitCursor

            MainPanel.Panel2.Controls.Clear()
            Dim navCtrl As Navigator = mUIRelations(newTab).NavigationControl
            Dim sectionCtrl As Section = mUIRelations(newTab).SectionControl

            MultiPane.LoadNavigationControl(navCtrl)
            sectionCtrl.Dock = DockStyle.Fill
            MainPanel.Panel2.Controls.Add(sectionCtrl)

            If oldTab IsNot Nothing AndAlso mUIRelations(oldTab).SectionControl IsNot Nothing Then
                mUIRelations(oldTab).SectionControl.InactivateSection()
            End If
            sectionCtrl.ActivateSection()

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click

        Close()

    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        'Save the form location information
        If WindowState = FormWindowState.Normal Then
            My.Settings.MainFormLocation = Location
            My.Settings.MainFormSize = Size
        End If
        My.Settings.MainFormWindowState = WindowState
        My.Settings.MainFormSplitterLocation = MainPanel.SplitterDistance

    End Sub

    Private Sub ManageClientsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ManageClientsToolStripMenuItem.Click

        Dim settings As New OryxClientSettingsForm()
        settings.ShowDialog()

    End Sub

    Private Sub MeasurementsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MeasurementsToolStripMenuItem.Click

        Dim measures As New OryxMeasurementSettingsForm()
        measures.ShowDialog()

    End Sub

End Class

