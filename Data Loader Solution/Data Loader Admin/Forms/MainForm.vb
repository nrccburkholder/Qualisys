Imports Nrc.Framework.WinForms
''' <summary></summary>
''' <CreateBy>Jeff Fleming - 11/8/2007</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>11/8/2007 - Tony Piccoly</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>4/28/2008 - Arman Mnatsakanyan</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    Private mAbandonNavigator As New AbandonFileNavigator
    Private mAbandonSection As New AbandonFileSection

    Private mNotesNavigator As New AdminNotesNavigator
    Private mNotesSection As New NotesSection

    Private mReportsNavigator As New ReportsNavigator
    Private mReportsSection As New ReportSection


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
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>4/28/2008 - Arman Mnatsakanyan</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub InitializeUI()
        Me.Text = "Data Loader Admin" 'My.Application.Info.Title
        Me.EnvironmentLabel.Text = Config.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

        If CurrentUser.hasAddFileNotes Then
            mUIRelations.Add(Me.NotesTab, New UIRelation(Me.mNotesNavigator, Me.mNotesSection))
        Else
            Me.MultiPane.Tabs.Remove(Me.NotesTab)
        End If

        If CurrentUser.hasAbandonUploadedFile Then
            mUIRelations.Add(Me.AbandonUploadTab, New UIRelation(Me.mAbandonNavigator, Me.mAbandonSection))
        Else
            Me.MultiPane.Tabs.Remove(Me.AbandonUploadTab)
        End If

        If CurrentUser.hasReports Then
            mUIRelations.Add(Me.ReportsTab, New UIRelation(Me.mReportsNavigator, Me.mReportsSection))
        Else
            Me.MultiPane.Tabs.Remove(Me.ReportsTab)
        End If

        If Me.MultiPane.Tabs.Count > 0 Then
            Me.ActivateTab(Nothing, Me.MultiPane.Tabs(0))
        Else
            Try
                Throw New AccessDeniedException(CurrentUser.UserName, My.Application.Info.Title)
            Catch ex As AccessDeniedException
                Globals.ReportException(ex, "Access Denied Error")
                End

            End Try
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
    ''' <item>
    ''' <DateModified>06/13/2008</DateModified>
    ''' <ModifiedBy>Steve Kennedy</ModifiedBy>
    ''' </item>
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

            If oldTab IsNot Nothing AndAlso mUIRelations.ContainsKey(oldTab) AndAlso mUIRelations(oldTab).SectionControl IsNot Nothing Then
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

