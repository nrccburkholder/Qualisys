Imports Nrc.Framework.WinForms
Public Class MainForm

    Private mUIRelations As New Dictionary(Of MultiPaneTab, UIRelation)
    Private mActiveTab As MultiPaneTab

    'Private mSplitFileNavigator As SplitFileNavigator
    'Private mSplitFileSection As SplitFileSection

    'Private mWellpointNavigator As WellpointNavigator
    'Private mWellpointSection As WellpointSection

    Private mWebCSVNavigator As WebCSVNavigator
    Private mWebCSVSection As WebCSVSection

    Private mLifeStylesExportNavigator As LifeStylesExportNavigator
    Private mLifeStylesExportSection As LifeStylesExportSection

    'Private mImportUpdateNavigator As ImportUpdateNavigator
    'Private mImportUpdateSection As ImportUpdateSection

    Private mVRTFileExpandNavigator As VRTFileExpandNavigator
    Private mVRTFileExpandSection As VRTFileExpandSection

    Private mRespImportValidatorNavigator As RespondentImportValidatorNavigator
    Private mRespImportValidatorSection As RespondentImportValidatorSection

    Private mVoviciUnpivotNavigator As VoviciUnpivotNavigator
    Private mVoviciUnpivotSection As VoviciUnpivotSection

    Private mVRTDispositionNavigator As VRTDispositionsNavigator
    Private mVRTDispositionSection As VRTDispositionSection

    Private mWebFileConvertNavigator As WebFileConvertNavigator
    Private mWebFileConvertSection As WebFileConvertSection

    Private mTVXVRTDispositionNavigator As TVXVRTDispositionNavigator
    Private mTVXVRTDispositionSection As TVXVRTDispositionSection

    Private mWestVRTDispositionNavigator As WestVRTDispositionNavigator
    Private mWestVRTDispositionSection As WestVRTDispositionSection

    Private mPivotFileSection As PivotFileSection


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
        'TP Removed tabs no longer used.  If noone missed them, then will remove the code.
        'If CurrentUser.HasCoventrySplitAccess Then
        '    mSplitFileSection = New SplitFileSection
        '    mSplitFileNavigator = New SplitFileNavigator
        '    mUIRelations.Add(Me.tabSplitFile, New UIRelation(mSplitFileNavigator, mSplitFileSection))
        'Else
        '    MultiPane.Tabs.Remove(tabSplitFile)
        'End If
        'If CurrentUser.HasWellpointSplitAccess Then
        '    Me.mWellpointSection = New WellpointSection
        '    Me.mWellpointNavigator = New WellpointNavigator
        '    mUIRelations.Add(Me.tabWellpoint, New UIRelation(mWellpointNavigator, mWellpointSection))
        'Else
        '    MultiPane.Tabs.Remove(tabWellpoint)
        'End If
        If CurrentUser.HasWebCSVAccess Then
            Me.mWebCSVSection = New WebCSVSection
            Me.mWebCSVNavigator = New WebCSVNavigator
            mUIRelations.Add(Me.tabWebCSV, New UIRelation(mWebCSVNavigator, mWebCSVSection))
        Else
            MultiPane.Tabs.Remove(tabWebCSV)
        End If
        If CurrentUser.HasLifestylesExportAccess Then
            Me.mLifeStylesExportSection = New LifeStylesExportSection
            Me.mLifeStylesExportNavigator = New LifeStylesExportNavigator
            mUIRelations.Add(Me.tabLifeStylesExport, New UIRelation(mLifeStylesExportNavigator, mLifeStylesExportSection))
        Else
            MultiPane.Tabs.Remove(tabWebCSV)
        End If
        'If CurrentUser.HasImportUpdateAccess Then
        '    Me.mImportUpdateSection = New ImportUpdateSection
        '    Me.mImportUpdateNavigator = New ImportUpdateNavigator
        '    mUIRelations.Add(Me.tabImportUpdate, New UIRelation(mImportUpdateNavigator, mImportUpdateSection))
        'Else
        '    MultiPane.Tabs.Remove(tabImportUpdate)
        'End If
        Me.mVRTFileExpandSection = New VRTFileExpandSection
        Me.mVRTFileExpandNavigator = New VRTFileExpandNavigator
        mUIRelations.Add(Me.tabVRTFileExpand, New UIRelation(mVRTFileExpandNavigator, mVRTFileExpandSection))

        'Respondent Import Validator - No Security Required.
        Me.mRespImportValidatorNavigator = New RespondentImportValidatorNavigator
        Me.mRespImportValidatorSection = New RespondentImportValidatorSection
        mUIRelations.Add(Me.tabRespImportValidator, New UIRelation(mRespImportValidatorNavigator, mRespImportValidatorSection))

        'Vovici Unpivot - No Security Required.
        Me.mVoviciUnpivotNavigator = New VoviciUnpivotNavigator
        Me.mVoviciUnpivotSection = New VoviciUnpivotSection
        mUIRelations.Add(Me.tabVoviciUnpivot, New UIRelation(mVoviciUnpivotNavigator, mVoviciUnpivotSection))

        'VRT Dispositions
        Me.mVRTDispositionNavigator = New VRTDispositionsNavigator
        Me.mVRTDispositionSection = New VRTDispositionSection
        mUIRelations.Add(Me.tabVRTDisp, New UIRelation(mVRTDispositionNavigator, mVRTDispositionSection))

        'Web File Convert
        Me.mWebFileConvertNavigator = New WebFileConvertNavigator
        Me.mWebFileConvertSection = New WebFileConvertSection
        mUIRelations.Add(Me.tabWebFileConvert, New UIRelation(mWebFileConvertNavigator, mWebFileConvertSection))

        'Tuvox
        Me.mTVXVRTDispositionNavigator = New TVXVRTDispositionNavigator
        Me.mTVXVRTDispositionSection = New TVXVRTDispositionSection
        mUIRelations.Add(Me.tabTVXDisposition, New UIRelation(mTVXVRTDispositionNavigator, mTVXVRTDispositionSection))

        'West
        Me.mWestVRTDispositionNavigator = New WestVRTDispositionNavigator
        Me.mWestVRTDispositionSection = New WestVRTDispositionSection
        mUIRelations.Add(Me.tabWestDisposition, New UIRelation(mWestVRTDispositionNavigator, mWestVRTDispositionSection))

        'File Pivot
        Me.mPivotFileSection = New PivotFileSection()
        mUIRelations.Add(tabPivot, New UIRelation(Nothing, mPivotFileSection))

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

