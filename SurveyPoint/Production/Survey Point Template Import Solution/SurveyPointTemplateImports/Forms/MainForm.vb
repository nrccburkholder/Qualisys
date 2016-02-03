Imports Nrc.Framework.WinForms
Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mFileTemplateNavigator As FileTemplateNavigator
    Private mFileTemplateSection As FileTemplateSection

    Private mImportExportNavigator As ImportExportNavigator
    Private mImportExportSection As ImportExportSection

    Private mExportDefLogNavigator As ExportDefinitionLogNavigator
    Private mExportDefLogSection As ExportDefinitionLogSection
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
        Me.Location = My.Settings.MainFormLocation
        Me.Size = My.Settings.MainFormSize
        Me.WindowState = My.Settings.MainFormWindowState
        Me.MainPanel.SplitterDistance = My.Settings.MainFormSplitterLocation
    End Sub

    ''' <summary>Base init stuff here including NRC Auth checks.</summary>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Sub InitializeUI()
        Me.Text = My.Application.Info.Title
        Me.EnvironmentLabel.Text = Config.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString        
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        If CurrentUser.FileTemplateAccess Then
            mFileTemplateNavigator = New FileTemplateNavigator
            mFileTemplateSection = New FileTemplateSection
            mUIRelations.Add(Me.tabFileTemplates, New UIRelation(mFileTemplateNavigator, mFileTemplateSection))
        Else
            MultiPane.Tabs.Remove(tabFileTemplates)
        End If
        If CurrentUser.ImportExportAccess Then
            Me.mImportExportNavigator = New ImportExportNavigator
            Me.mImportExportSection = New ImportExportSection
            mUIRelations.Add(Me.tabImportExport, New UIRelation(mImportExportNavigator, mImportExportSection))
        Else
            MultiPane.Tabs.Remove(Me.tabImportExport)
        End If
        Me.mExportDefLogNavigator = New ExportDefinitionLogNavigator
        Me.mExportDefLogSection = New ExportDefinitionLogSection
        mUIRelations.Add(Me.tabExportDefinitionLog, New UIRelation(mExportDefLogNavigator, mExportDefLogSection))

        If Me.MultiPane.Tabs.Count > 0 Then
            Me.ActivateTab(Nothing, Me.MultiPane.Tabs(0))
        Else
            'TODO: Add Exception Dialog
            Me.Close()
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
            Me.ActivateTab(e.OldTab, e.NewTab)
        Else
            Me.MultiPane.LoadNavigationControl(Nothing)
            Me.MainPanel.Panel2.Controls.Clear()
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
        My.Settings.MainFormWindowState = Me.WindowState
        Me.WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Me.Location
        My.Settings.MainFormSize = Me.Size

        'Save the location of the splitter
        My.Settings.MainFormSplitterLocation = Me.MainPanel.SplitterDistance
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
        Me.Close()
    End Sub
End Class

