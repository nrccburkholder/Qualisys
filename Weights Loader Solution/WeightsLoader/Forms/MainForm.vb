Imports Nrc.Framework.WinForms
Imports NRC.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)

    Private mClientStudySurveyNavigator As New ClientStudySurveyNavigator
    Private mWeightsLoaderSection As New WeightsLoaderSection
    Private mAdministrationNavigator As New AdministrationNavigator
    Private mAdministrationSection As New AdministrationSection

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()
    End Sub

    Private Sub InitializeUI()
        Me.Text = My.Application.Info.Title
        Me.EnvironmentLabel.Text = AppConfig.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        mUIRelations.Add(Me.loadWeightsTab, New UIRelation(mClientStudySurveyNavigator, mWeightsLoaderSection))

        If CurrentUser.IsWeightTypesManager Then
            mUIRelations.Add(Me.loadAdministrationTab, New UIRelation(mAdministrationNavigator, mAdministrationSection))
        Else
            Me.MultiPane.Tabs.Remove(Me.loadAdministrationTab)
        End If

        Me.ActivateTab(Me.MultiPane.Tabs(0))
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

    Private Sub ActivateTab(ByVal tab As NRC.Framework.WinForms.MultiPaneTab)
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

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.Close()
    End Sub
End Class

