Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

#Region " Private Members "

    'Main Content User Controls
    Private WithEvents popManSect As SearchWizardSection
    Private WithEvents dispoSect As DispositionSection
    'Private WithEvents adminSect As AdminSection
    Private WithEvents uspsSect As USPSAddressUpdateSection

    'Navigational Controls
    Private WithEvents studyNav As StudyNavigator
    Private WithEvents dispoNav As DispositionNavigator
    Private WithEvents adminNav As AdminNavigator
    Private WithEvents uspsNav As USPSAddressUpdateNavigator

    '
    Private relations As New UIRelationCollection
    Private Delegate Sub InitializeUIDelegate()

#End Region

#Region " Constructors "

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        WindowState = My.Settings.WindowState
        Size = My.Settings.WindowSize
        If My.Settings.SplitterDistance > 0 Then
            SplitContainer.SplitterDistance = My.Settings.SplitterDistance
        End If
        Location = My.Settings.WindowLocation

        'Clear labels to begin
        UserNameLabel.Text = ""
        VersionLabel.Text = ""
        EnvironmentLabel.Text = ""

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub MainForm2_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Create a delegate to the initialization method
        'Dim init As New InitializeUIDelegate(AddressOf InitializeUI)

        'Now show the awsome splash screen and have it run the initialization method
        'Dim frmSplash As New frmSplashScreen(True, init)
        'frmSplash.ShowDialog(Me)
        InitializeUI()

    End Sub

    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged

        If Not e.OldTab Is e.NewTab Then
            Dim relation As UIRelation = relations(e.NewTab)
            If relation IsNot Nothing Then
                MultiPane.LoadNavigationControl(relation.NavControl)
                LoadSection(relation.MainControl)
            End If
        End If

    End Sub

    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging

        If Not e.OldTab Is e.NewTab Then
            Dim relation As UIRelation = relations(e.OldTab)
            e.Cancel = (Not relation.MainControl.AllowUnload)
        End If

    End Sub

    Private Sub MainForm_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing

        If WindowState = FormWindowState.Normal Then
            My.Settings.WindowLocation = Location
            My.Settings.WindowSize = Size
        End If

        My.Settings.WindowState = WindowState
        My.Settings.SplitterDistance = SplitContainer.SplitterDistance
        My.Settings.Save()

    End Sub

    Private Sub popManSect_MailingSelected(ByVal sender As Object, ByVal e As SearchWizardSection.MailingSelectedEventArgs) Handles popManSect.MailingSelected

        MultiPane.SelectedTab = Me.DispositionTab
        dispoNav.LoadMailing(e.Mailing)

    End Sub

    Private Sub ExitMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitMenuItem.Click

        Close()

    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitializeUI()
        Me.Text = AppName
        Me.UserNameLabel.Text = Environment.UserName
        Me.VersionLabel.Text = Application.ProductVersion
        Me.EnvironmentLabel.Text = AppConfig.EnvironmentName

        popManSect = New SearchWizardSection
        dispoSect = New DispositionSection
        'adminSect = New AdminSection
        uspsSect = New USPSAddressUpdateSection


        studyNav = New StudyNavigator
        dispoNav = New DispositionNavigator
        adminNav = New AdminNavigator
        uspsNav = New USPSAddressUpdateNavigator

        relations.Add(New UIRelation(DispositionTab, dispoNav, dispoSect))
        relations.Add(New UIRelation(SearchTab, studyNav, popManSect))
        relations.Add(New UIRelation(USPSAddressUpdatesTab, uspsNav, uspsSect))

        'Initialize the selected tab
        If Me.MultiPane.Tabs.Count > 0 Then
            Dim relation As UIRelation = relations(MultiPane.Tabs(0))
            MultiPane.LoadNavigationControl(relation.NavControl)
            LoadSection(relation.MainControl)
        End If

        'EnableThemes(Me)
    End Sub

    Private Sub LoadSection(ByVal sectionControl As Control)
        Me.SplitContainer.Panel2.Controls.Clear()

        If Not sectionControl Is Nothing Then
            'Dock the control to the panel
            sectionControl.Dock = DockStyle.Fill

            'Add new control to panel
            Me.SplitContainer.Panel2.Controls.Add(sectionControl)
        End If
    End Sub

#End Region

End Class