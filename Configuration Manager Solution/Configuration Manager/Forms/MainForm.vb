Imports Nrc.Framework.WinForms
Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mClientStudySurveyTree As Navigation.NavigationTree
    Private mClientStudySurveyNavigator As ClientStudySurveyNavigator
    Private mConfigSection As New ConfigSection

    Private mClientTree As Navigation.NavigationTree
    Private mClientNavigator As ClientNavigator
    Private mFacilitySection As New FacilitySection

    Private mHCAHPSMngrNavigator As HCAHPSMngrNavigator
    Private mHCAHPSMngrSection As New HCAHPSMngrSection

    Private mMedicareMngrNavigator As New MedicareMngrNavigator
    Private mMedicareMngrSection As New MedicareMngrSection

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()

        ' Locate and size the form
        Location = My.Settings.MainFormLocation
        Size = My.Settings.MainFormSize
        WindowState = My.Settings.MainFormWindowState
        MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation

    End Sub

    Private Sub InitializeUI()

        Text = My.Application.Info.Title
        EnvironmentLabel.Text = AppConfig.EnvironmentName
        VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        mClientStudySurveyTree = Navigation.NavigationTree.GetByUser(CurrentUser.UserName, Navigation.InitialPopulationDepth.Survey, My.Settings.ClientStudySurveyNavigatorIncludeGroups)
        mClientStudySurveyNavigator = New ClientStudySurveyNavigator(mClientStudySurveyTree)

        mClientTree = Navigation.NavigationTree.GetByUser(CurrentUser.UserName, Navigation.InitialPopulationDepth.Client, False)
        mClientNavigator = New ClientNavigator(mClientTree)

        mHCAHPSMngrNavigator = New HCAHPSMngrNavigator()

        mUIRelations.Add(ConfigurationTab, New UIRelation(mClientStudySurveyNavigator, mConfigSection))

        If CurrentUser.IsFacilityManager Then
            mUIRelations.Add(FacilityAdminTab, New UIRelation(mClientNavigator, mFacilitySection))
        Else
            MultiPane.Tabs.Remove(FacilityAdminTab)
        End If

        If CurrentUser.IsHCAHPSManager Then
            mUIRelations.Add(HCAHPSMngrTab, New UIRelation(mHCAHPSMngrNavigator, mHCAHPSMngrSection))
        Else
            MultiPane.Tabs.Remove(HCAHPSMngrTab)
        End If

        If CurrentUser.IsMedicareManager Then
            mUIRelations.Add(MedicareMngrTab, New UIRelation(mMedicareMngrNavigator, mMedicareMngrSection))
        Else
            MultiPane.Tabs.Remove(MedicareMngrTab)
        End If

        ActivateTab(Nothing, MultiPane.Tabs(0))

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If mUIRelations.ContainsKey(e.NewTab) Then
            ActivateTab(e.OldTab, e.NewTab)
        Else
            MultiPane.LoadNavigationControl(Nothing)
            MainPanel.Panel2.Controls.Clear()
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

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
            mActiveTab = newTab

            If oldTab IsNot Nothing AndAlso mUIRelations(oldTab).SectionControl IsNot Nothing Then
                mUIRelations(oldTab).SectionControl.InactivateSection()
            End If
            sectionCtrl.ActivateSection()

        Finally
            Cursor = DefaultCursor

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
        My.Settings.MainFormWindowState = WindowState
        WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Location
        My.Settings.MainFormSize = Size

        'Save the location of the splitter
        My.Settings.MainFormSplitterLocation = MainPanel.SplitterDistance

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click

        'Close the application
        Close()

    End Sub

End Class

