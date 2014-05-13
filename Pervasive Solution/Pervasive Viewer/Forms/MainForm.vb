Imports Nrc.Framework.WinForms
Imports Nrc.QualiSys.Pervasive.Library

Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mClientStudySurveyTree As Navigation.NavigationTree
    Private mClientStudySurveyNavigator As ClientStudySurveyNavigator
    Private mReportSection As New ReportViewerSection

    ''' <summary>Most user init requirements should go in the InitializeUI() method</summary>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()
        Location = My.Settings.MainFormLocation
        Size = My.Settings.MainFormSize
        WindowState = My.Settings.MainFormWindowState
        MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation
    End Sub

    ''' <summary>Base init stuff here including NRC Auth checks.</summary>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Sub InitializeUI()
        Text = My.Application.Info.Title
        EnvironmentLabel.Text = Config.EnvironmentName
        VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        mClientStudySurveyNavigator = New ClientStudySurveyNavigator(DataFileStates.AwaitingFirstApproval)
        mUIRelations.Add(ReportsTab, New UIRelation(mClientStudySurveyNavigator, mReportSection))

        If MultiPane.Tabs.Count > 0 Then
            ActivateTab(Nothing, MultiPane.Tabs(0))
        Else
            'TODO: Add Exception Dialog
            Close()
        End If
    End Sub

    ''' <summary>Sets the current navigation for when a tab is clicked.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Sub MultiPane_SelectedTabChanged(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangedEventArgs) Handles MultiPane.SelectedTabChanged
        If e.NewTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.NewTab) Then
            ActivateTab(e.OldTab, e.NewTab)
        Else
            MultiPane.LoadNavigationControl(Nothing)
            MainPanel.Panel2.Controls.Clear()
        End If
    End Sub

    ''' <summary>Sets the current section when a tab is clicked.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Sub MultiPane_SelectedTabChanging(ByVal sender As Object, ByVal e As Framework.WinForms.SelectedTabChangingEventArgs) Handles MultiPane.SelectedTabChanging
        If e.OldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(e.OldTab) Then
            Dim sectionCtrl As Section = mUIRelations(e.OldTab).SectionControl
            e.Cancel = Not sectionCtrl.AllowInactivate
        End If
    End Sub

    ''' <summary>Loads the navigation controls and section control into the appropriate panels when a tab is clicked.</summary>
    ''' <param name="oldTab"></param>
    ''' <param name="newTab"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
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

    ''' <summary>Close the form only if you are allowed to leave the active section.  Also, save form state to config file.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
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

    ''' <summary>Exit the application</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        'Close the application
        Close()
    End Sub

    Private Sub MainMenu_ItemClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles MainMenu.ItemClicked

    End Sub
End Class

