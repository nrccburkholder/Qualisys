Imports Nrc.Framework.WinForms
Imports Nrc.Qualisys.QualisysDataEntry.Library

Public Class frmMain
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.Text = AppName
    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents PaneCaption1 As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents lblEnvironment As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblUserName As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblVersion As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblStatus As System.Windows.Forms.StatusBarPanel
    Friend WithEvents mnuMainMenu As System.Windows.Forms.MainMenu
    Friend WithEvents tbrToolBar As System.Windows.Forms.ToolBar
    Friend WithEvents sbStatusBar As System.Windows.Forms.StatusBar
    Friend WithEvents pnlNavigation As System.Windows.Forms.Panel
    Friend WithEvents tabKeying As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabKeyVerification As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabCoding As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabCodeVerification As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabHandwritten As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabHandwrittenVerification As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents tabAdmin As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents mtpNavigation As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents pnlMainContent As System.Windows.Forms.Panel
    Friend WithEvents btnRefreshQueue As System.Windows.Forms.ToolBarButton
    Friend WithEvents imgToolBar As System.Windows.Forms.ImageList
    Friend WithEvents mnuFile As System.Windows.Forms.MenuItem
    Friend WithEvents mnuHelp As System.Windows.Forms.MenuItem
    Friend WithEvents mnuAbout As System.Windows.Forms.MenuItem
    Friend WithEvents btnSettings As System.Windows.Forms.ToolBarButton
    Friend WithEvents btnStats As System.Windows.Forms.ToolBarButton
    Friend WithEvents mnuExit As System.Windows.Forms.MenuItem
    Friend WithEvents lblLoggingStatus As System.Windows.Forms.StatusBarPanel
    Friend WithEvents btnLithoStatus As System.Windows.Forms.ToolBarButton
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmMain))
        Me.mnuMainMenu = New System.Windows.Forms.MainMenu(Me.components)
        Me.mnuFile = New System.Windows.Forms.MenuItem
        Me.mnuExit = New System.Windows.Forms.MenuItem
        Me.mnuHelp = New System.Windows.Forms.MenuItem
        Me.mnuAbout = New System.Windows.Forms.MenuItem
        Me.tbrToolBar = New System.Windows.Forms.ToolBar
        Me.btnRefreshQueue = New System.Windows.Forms.ToolBarButton
        Me.btnSettings = New System.Windows.Forms.ToolBarButton
        Me.btnStats = New System.Windows.Forms.ToolBarButton
        Me.btnLithoStatus = New System.Windows.Forms.ToolBarButton
        Me.imgToolBar = New System.Windows.Forms.ImageList(Me.components)
        Me.sbStatusBar = New System.Windows.Forms.StatusBar
        Me.lblStatus = New System.Windows.Forms.StatusBarPanel
        Me.lblEnvironment = New System.Windows.Forms.StatusBarPanel
        Me.lblUserName = New System.Windows.Forms.StatusBarPanel
        Me.lblVersion = New System.Windows.Forms.StatusBarPanel
        Me.pnlNavigation = New System.Windows.Forms.Panel
        Me.mtpNavigation = New Nrc.Framework.WinForms.MultiPane
        Me.tabKeying = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabKeyVerification = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabCoding = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabCodeVerification = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabHandwritten = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabHandwrittenVerification = New Nrc.Framework.WinForms.MultiPaneTab
        Me.tabAdmin = New Nrc.Framework.WinForms.MultiPaneTab
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.pnlMainContent = New System.Windows.Forms.Panel
        Me.lblLoggingStatus = New System.Windows.Forms.StatusBarPanel
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlNavigation.SuspendLayout()
        CType(Me.lblLoggingStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mnuMainMenu
        '
        Me.mnuMainMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFile, Me.mnuHelp})
        '
        'mnuFile
        '
        Me.mnuFile.Index = 0
        Me.mnuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuExit})
        Me.mnuFile.Text = "File"
        '
        'mnuExit
        '
        Me.mnuExit.Index = 0
        Me.mnuExit.Text = "Exit"
        '
        'mnuHelp
        '
        Me.mnuHelp.Index = 1
        Me.mnuHelp.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuAbout})
        Me.mnuHelp.Text = "Help"
        '
        'mnuAbout
        '
        Me.mnuAbout.Index = 0
        Me.mnuAbout.Text = "About..."
        '
        'tbrToolBar
        '
        Me.tbrToolBar.Appearance = System.Windows.Forms.ToolBarAppearance.Flat
        Me.tbrToolBar.Buttons.AddRange(New System.Windows.Forms.ToolBarButton() {Me.btnRefreshQueue, Me.btnSettings, Me.btnStats, Me.btnLithoStatus})
        Me.tbrToolBar.ButtonSize = New System.Drawing.Size(100, 32)
        Me.tbrToolBar.DropDownArrows = True
        Me.tbrToolBar.ImageList = Me.imgToolBar
        Me.tbrToolBar.Location = New System.Drawing.Point(0, 0)
        Me.tbrToolBar.Name = "tbrToolBar"
        Me.tbrToolBar.ShowToolTips = True
        Me.tbrToolBar.Size = New System.Drawing.Size(772, 44)
        Me.tbrToolBar.TabIndex = 2
        Me.tbrToolBar.TextAlign = System.Windows.Forms.ToolBarTextAlign.Right
        Me.tbrToolBar.Wrappable = False
        '
        'btnRefreshQueue
        '
        Me.btnRefreshQueue.ImageIndex = 0
        Me.btnRefreshQueue.Name = "btnRefreshQueue"
        Me.btnRefreshQueue.Text = "Refresh"
        Me.btnRefreshQueue.ToolTipText = "Refresh Queue"
        '
        'btnSettings
        '
        Me.btnSettings.ImageIndex = 1
        Me.btnSettings.Name = "btnSettings"
        Me.btnSettings.Text = "Settings"
        Me.btnSettings.ToolTipText = "User Settings"
        '
        'btnStats
        '
        Me.btnStats.ImageIndex = 2
        Me.btnStats.Name = "btnStats"
        Me.btnStats.Text = "Stats"
        Me.btnStats.ToolTipText = "System Statistics"
        '
        'btnLithoStatus
        '
        Me.btnLithoStatus.ImageIndex = 3
        Me.btnLithoStatus.Name = "btnLithoStatus"
        Me.btnLithoStatus.Text = "Litho Status"
        Me.btnLithoStatus.ToolTipText = "Check the status of a certain litho code."
        '
        'imgToolBar
        '
        Me.imgToolBar.ImageStream = CType(resources.GetObject("imgToolBar.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgToolBar.TransparentColor = System.Drawing.Color.Transparent
        Me.imgToolBar.Images.SetKeyName(0, "")
        Me.imgToolBar.Images.SetKeyName(1, "")
        Me.imgToolBar.Images.SetKeyName(2, "")
        Me.imgToolBar.Images.SetKeyName(3, "")
        '
        'sbStatusBar
        '
        Me.sbStatusBar.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.sbStatusBar.Location = New System.Drawing.Point(0, 491)
        Me.sbStatusBar.Name = "sbStatusBar"
        Me.sbStatusBar.Panels.AddRange(New System.Windows.Forms.StatusBarPanel() {Me.lblStatus, Me.lblEnvironment, Me.lblLoggingStatus, Me.lblUserName, Me.lblVersion})
        Me.sbStatusBar.ShowPanels = True
        Me.sbStatusBar.Size = New System.Drawing.Size(772, 22)
        Me.sbStatusBar.TabIndex = 3
        Me.sbStatusBar.Text = "StatusBar1"
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Spring
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Text = "Ready."
        Me.lblStatus.Width = 414
        '
        'lblEnvironment
        '
        Me.lblEnvironment.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Text = "Production (NRC10)"
        Me.lblEnvironment.Width = 113
        '
        'lblUserName
        '
        Me.lblUserName.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblUserName.Name = "lblUserName"
        Me.lblUserName.Text = "JFleming"
        Me.lblUserName.Width = 58
        '
        'lblVersion
        '
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Text = "v1.0.0.5"
        Me.lblVersion.Width = 70
        '
        'pnlNavigation
        '
        Me.pnlNavigation.BackColor = System.Drawing.SystemColors.Control
        Me.pnlNavigation.Controls.Add(Me.mtpNavigation)
        Me.pnlNavigation.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlNavigation.Location = New System.Drawing.Point(0, 44)
        Me.pnlNavigation.Name = "pnlNavigation"
        Me.pnlNavigation.Padding = New System.Windows.Forms.Padding(3)
        Me.pnlNavigation.Size = New System.Drawing.Size(176, 447)
        Me.pnlNavigation.TabIndex = 4
        '
        'mtpNavigation
        '
        Me.mtpNavigation.BackColor = System.Drawing.Color.White
        Me.mtpNavigation.Dock = System.Windows.Forms.DockStyle.Fill
        Me.mtpNavigation.Location = New System.Drawing.Point(3, 3)
        Me.mtpNavigation.MaxShownTabs = 5
        Me.mtpNavigation.Name = "mtpNavigation"
        Me.mtpNavigation.Size = New System.Drawing.Size(170, 441)
        Me.mtpNavigation.TabIndex = 0
        Me.mtpNavigation.Tabs.Add(Me.tabKeying)
        Me.mtpNavigation.Tabs.Add(Me.tabKeyVerification)
        Me.mtpNavigation.Tabs.Add(Me.tabCoding)
        Me.mtpNavigation.Tabs.Add(Me.tabCodeVerification)
        Me.mtpNavigation.Tabs.Add(Me.tabHandwritten)
        Me.mtpNavigation.Tabs.Add(Me.tabHandwrittenVerification)
        Me.mtpNavigation.Tabs.Add(Me.tabAdmin)
        '
        'tabKeying
        '
        Me.tabKeying.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabKeying.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabKeying.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabKeying.Icon = Nothing
        Me.tabKeying.Image = Nothing
        Me.tabKeying.IsActive = True
        Me.tabKeying.Location = New System.Drawing.Point(0, 0)
        Me.tabKeying.Name = "tabKeying"
        Me.tabKeying.NavControlId = Nothing
        Me.tabKeying.NavControlType = Nothing
        Me.tabKeying.Size = New System.Drawing.Size(170, 32)
        Me.tabKeying.TabIndex = 0
        Me.tabKeying.Text = "Keying"
        '
        'tabKeyVerification
        '
        Me.tabKeyVerification.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabKeyVerification.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabKeyVerification.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabKeyVerification.Icon = Nothing
        Me.tabKeyVerification.Image = Nothing
        Me.tabKeyVerification.IsActive = False
        Me.tabKeyVerification.Location = New System.Drawing.Point(0, 32)
        Me.tabKeyVerification.Name = "tabKeyVerification"
        Me.tabKeyVerification.NavControlId = Nothing
        Me.tabKeyVerification.NavControlType = Nothing
        Me.tabKeyVerification.Size = New System.Drawing.Size(170, 32)
        Me.tabKeyVerification.TabIndex = 0
        Me.tabKeyVerification.Text = "Key Verification"
        '
        'tabCoding
        '
        Me.tabCoding.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabCoding.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabCoding.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabCoding.Icon = Nothing
        Me.tabCoding.Image = Nothing
        Me.tabCoding.IsActive = False
        Me.tabCoding.Location = New System.Drawing.Point(0, 64)
        Me.tabCoding.Name = "tabCoding"
        Me.tabCoding.NavControlId = Nothing
        Me.tabCoding.NavControlType = Nothing
        Me.tabCoding.Size = New System.Drawing.Size(170, 32)
        Me.tabCoding.TabIndex = 0
        Me.tabCoding.Text = "Coding"
        '
        'tabCodeVerification
        '
        Me.tabCodeVerification.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabCodeVerification.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabCodeVerification.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabCodeVerification.Icon = Nothing
        Me.tabCodeVerification.Image = Nothing
        Me.tabCodeVerification.IsActive = False
        Me.tabCodeVerification.Location = New System.Drawing.Point(0, 96)
        Me.tabCodeVerification.Name = "tabCodeVerification"
        Me.tabCodeVerification.NavControlId = Nothing
        Me.tabCodeVerification.NavControlType = Nothing
        Me.tabCodeVerification.Size = New System.Drawing.Size(170, 32)
        Me.tabCodeVerification.TabIndex = 0
        Me.tabCodeVerification.Text = "Code Verification"
        '
        'tabHandwritten
        '
        Me.tabHandwritten.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabHandwritten.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabHandwritten.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabHandwritten.Icon = Nothing
        Me.tabHandwritten.Image = Nothing
        Me.tabHandwritten.IsActive = False
        Me.tabHandwritten.Location = New System.Drawing.Point(0, 128)
        Me.tabHandwritten.Name = "tabHandwritten"
        Me.tabHandwritten.NavControlId = Nothing
        Me.tabHandwritten.NavControlType = Nothing
        Me.tabHandwritten.Size = New System.Drawing.Size(170, 32)
        Me.tabHandwritten.TabIndex = 0
        Me.tabHandwritten.Text = "Handwritten"
        '
        'tabHandwrittenVerification
        '
        Me.tabHandwrittenVerification.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.tabHandwrittenVerification.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabHandwrittenVerification.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabHandwrittenVerification.Icon = Nothing
        Me.tabHandwrittenVerification.Image = Nothing
        Me.tabHandwrittenVerification.IsActive = False
        Me.tabHandwrittenVerification.Location = New System.Drawing.Point(95, 1)
        Me.tabHandwrittenVerification.Name = "tabHandwrittenVerification"
        Me.tabHandwrittenVerification.NavControlId = Nothing
        Me.tabHandwrittenVerification.NavControlType = Nothing
        Me.tabHandwrittenVerification.Size = New System.Drawing.Size(32, 32)
        Me.tabHandwrittenVerification.TabIndex = 0
        Me.tabHandwrittenVerification.Text = "Handwritten Verification"
        '
        'tabAdmin
        '
        Me.tabAdmin.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.tabAdmin.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabAdmin.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabAdmin.Icon = Nothing
        Me.tabAdmin.Image = Nothing
        Me.tabAdmin.IsActive = False
        Me.tabAdmin.Location = New System.Drawing.Point(130, 1)
        Me.tabAdmin.Name = "tabAdmin"
        Me.tabAdmin.NavControlId = Nothing
        Me.tabAdmin.NavControlType = Nothing
        Me.tabAdmin.Size = New System.Drawing.Size(32, 32)
        Me.tabAdmin.TabIndex = 0
        Me.tabAdmin.Text = "Administration"
        '
        'Splitter1
        '
        Me.Splitter1.BackColor = System.Drawing.SystemColors.Control
        Me.Splitter1.Location = New System.Drawing.Point(176, 44)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(3, 447)
        Me.Splitter1.TabIndex = 5
        Me.Splitter1.TabStop = False
        '
        'pnlMainContent
        '
        Me.pnlMainContent.BackColor = System.Drawing.SystemColors.Control
        Me.pnlMainContent.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMainContent.Location = New System.Drawing.Point(179, 44)
        Me.pnlMainContent.Name = "pnlMainContent"
        Me.pnlMainContent.Padding = New System.Windows.Forms.Padding(3)
        Me.pnlMainContent.Size = New System.Drawing.Size(593, 447)
        Me.pnlMainContent.TabIndex = 6
        '
        'lblLoggingStatus
        '
        Me.lblLoggingStatus.Name = "lblLoggingStatus"
        Me.lblLoggingStatus.Text = "Logging Is On/Off"
        '
        'frmMain
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.ClientSize = New System.Drawing.Size(772, 513)
        Me.Controls.Add(Me.pnlMainContent)
        Me.Controls.Add(Me.Splitter1)
        Me.Controls.Add(Me.pnlNavigation)
        Me.Controls.Add(Me.tbrToolBar)
        Me.Controls.Add(Me.sbStatusBar)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.KeyPreview = True
        Me.Menu = Me.mnuMainMenu
        Me.MinimumSize = New System.Drawing.Size(780, 540)
        Me.Name = "frmMain"
        Me.Text = "frmMain"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlNavigation.ResumeLayout(False)
        CType(Me.lblLoggingStatus, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

#Region " Private Members "
    'Work Sections
    Private WithEvents mCurrentSection As IWorkSection
    Private WithEvents ctrlKeying As ucKeying
    Private WithEvents ctrlCoding As ucCoding
    Private WithEvents ctrlHandEntry As ucHandEntry

    'Admin Sections
    Private WithEvents ctrlFileImport As ucFileImport
    Private WithEvents ctrlFinalize As ucFinalize
    Private WithEvents ctrlModifyComment As ucModifyComment

    'NavControls
    Private WithEvents treBatchList As New BatchWorkTree
    Private WithEvents ctrlAdminNav As New ucAdminNavigation
#End Region

#Region " Event Handlers "

    'Form LOAD - Initialize everything on the form
    Private Sub frmMain_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Load up all features for this user
        SetupUserRights()

        'Default to the first tab  -->  This will trigger the PaneChanged event to load the main content panel
        'mtpNavigation.SelectedIndex = 0
        NavPaneChanged(mtpNavigation.Tabs(0))

        'Set the form caption to be the application name
        Me.Text = AppName
        'Set the status bar label texts
        Me.lblEnvironment.Text = Config.EnvironmentName
        Me.lblUserName.Text = CurrentUser.LoginName
        Me.lblVersion.Text = Application.ProductVersion & "   "
        'SK 10-02-2008 If Logging is turned on/off, adjust status label for visual reference
        Me.lblLoggingStatus.Text = "Logging Is " & IIf(Config.IsLoggingOn, "On", "Off").ToString
    End Sub

    'Navigation BEFORE PANE CHANGE - Make sure they are not currently working on a batch
    'If they are they should be prompted and have the option to cancel then pane change
    Private Sub mtpNavigation_BeforePaneChange(ByVal sender As Object, ByVal e As SelectedTabChangingEventArgs) Handles mtpNavigation.SelectedTabChanging
        'If the loaded section is a WorkSection and it is "Working" then call its EndWork method
        If Not mCurrentSection Is Nothing AndAlso mCurrentSection.IsWorking Then
            If Not mCurrentSection.EndWork Then
                e.Cancel = True     'User wants to cancel
            End If
        End If
    End Sub

    'Navigation PANE CHANGED - Change the Nav. Control and Main Content Section
    Private Sub mtpNavigation_PaneChanged(ByVal sender As Object, ByVal e As SelectedTabChangedEventArgs) Handles mtpNavigation.SelectedTabChanged
        'Get the new tab that is now selected
        NavPaneChanged(e.NewTab)
    End Sub

    Private Sub NavPaneChanged(ByVal tab As Nrc.Framework.WinForms.MultiPaneTab)

        'Determine the action to take based on which tab is now selected
        If tab Is tabKeying Then
            LoadSection(ctrlKeying, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeKeyed, mCurrentSection)
        ElseIf tab Is tabKeyVerification Then
            LoadSection(ctrlKeying, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeKeyVerified, mCurrentSection)
        ElseIf tab Is tabCoding Then
            LoadSection(ctrlCoding, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeCoded, mCurrentSection)
        ElseIf tab Is tabCodeVerification Then
            LoadSection(ctrlCoding, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeCodeVerified, mCurrentSection)
        ElseIf tab Is tabHandwritten Then
            LoadSection(ctrlHandEntry, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeHandEntered, mCurrentSection)
        ElseIf tab Is tabHandwrittenVerification Then
            LoadSection(ctrlHandEntry, True)
            'mtpNavigation.SubCaption = "Available Work"
            mtpNavigation.LoadNavigationControl(treBatchList)
            treBatchList.PopulateList(QDEForm.WorkStage.ToBeHandEntryVerified, mCurrentSection)
        ElseIf tab Is tabAdmin Then
            LoadSection(Nothing, False)
            'mtpNavigation.SubCaption = "Administrative Functions"
            mtpNavigation.LoadNavigationControl(ctrlAdminNav)
        End If

        'Display only the appropriate toolbar buttons
        DisplayToolBarButtons()

    End Sub

    'AdminNav FUNCTION SELECTED - Loads the main content based on the Admin Sub option selected
    Private Sub ctrlAdminNav_FunctionSelected(ByVal sender As Object, ByVal e As ucAdminNavigation.FunctionSelectedEventArgs) Handles ctrlAdminNav.FunctionSelected
        Select Case e.FunctionSelected
            Case ucAdminNavigation.FunctionType.ImportFile
                LoadSection(ctrlFileImport, False)
            Case ucAdminNavigation.FunctionType.Finalize
                LoadSection(ctrlFinalize, False)
            Case ucAdminNavigation.FunctionType.ModifyComment
                LoadSection(ctrlModifyComment, False)
        End Select
    End Sub


    'WorkList BEGIN WORK - When the user clicks to begin work in the work list we need to notify
    'the appropriate control and pass in the template name to work on
    Private Sub treBatchList_BeginWork(ByVal sender As Object, ByVal e As BatchWorkTree.BeginWorkEventArgs) Handles treBatchList.BeginWork
        'Determine which control to notify based on the WorkStage that the user was using
        Select Case e.WorkStage
            Case QDEForm.WorkStage.ToBeKeyed
                ctrlKeying.BeginWork(e.BatchID, e.TemplateName, False)
            Case QDEForm.WorkStage.ToBeKeyVerified
                ctrlKeying.BeginWork(e.BatchID, e.TemplateName, True)
            Case QDEForm.WorkStage.ToBeCoded
                ctrlCoding.BeginWork(e.BatchID, e.TemplateName, False)
            Case QDEForm.WorkStage.ToBeCodeVerified
                ctrlCoding.BeginWork(e.BatchID, e.TemplateName, True)
            Case QDEForm.WorkStage.ToBeHandEntered
            Case QDEForm.WorkStage.ToBeHandEntryVerified
        End Select
    End Sub

    'WorkList WORK ENDING - When work is finished on a WorkSection then we should 
    'update the WorkList to show updated lists and counts
    Private Sub mCurrentSection_WorkEnding(ByVal sender As Object, ByVal e As WorkEndingEventArgs) Handles mCurrentSection.WorkEnding
        treBatchList.RefreshList()
    End Sub

    'ToolBar BUTTON CLICK - I have no idea why it is so difficult to handle a toolbar button click
    Private Sub tbrToolBar_ButtonClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ToolBarButtonClickEventArgs) Handles tbrToolBar.ButtonClick
        'Determine which button was clicked and do something
        If e.Button Is btnRefreshQueue Then
            treBatchList.RefreshList()
        ElseIf e.Button Is btnSettings Then
            Dim frmSettings As New frmUserSettings
            frmSettings.ShowDialog()
        ElseIf e.Button Is btnStats Then
            ShowSystemStats()
        ElseIf e.Button Is btnLithoStatus Then
            Dim frmLitho As New frmLithoStatus
            frmLitho.ShowDialog()
        End If
    End Sub

    'When the user tries to close the form we need to notify them if work is in process
    Private Sub frmMain_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        'If the loaded section is a WorkSection and it is "Working" then call its EndWork method
        If Not mCurrentSection Is Nothing AndAlso mCurrentSection.IsWorking Then
            If Not mCurrentSection.EndWork Then
                e.Cancel = True     'User wants to cancel
            End If
        End If
    End Sub

    'When user clicks the "File --> Exit" button then just try to close the form
    Private Sub mnuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuExit.Click
        Me.Close()
    End Sub

    Private Sub mnuAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuAbout.Click
        MessageBox.Show(My.Application.Info.ProductName & vbCrLf & My.Application.Info.Version.ToString, "About", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

#End Region


#Region " Private Methods "
    'This method removes any navigation tabs from the application if the user
    'does not have the correct privileges to use them
    Private Sub SetupUserRights()
        If CurrentUser.IsKeyer OrElse CurrentUser.IsKeyVerifier Then
            ctrlKeying = New ucKeying
        End If
        If Not CurrentUser.IsKeyer Then mtpNavigation.Tabs.Remove(tabKeying)
        If Not CurrentUser.IsKeyVerifier Then mtpNavigation.Tabs.Remove(tabKeyVerification)

        If CurrentUser.IsCoder OrElse CurrentUser.IsCodeVerifier Then
            ctrlCoding = New ucCoding
        End If
        If Not CurrentUser.IsCoder Then mtpNavigation.Tabs.Remove(tabCoding)
        If Not CurrentUser.IsCodeVerifier Then mtpNavigation.Tabs.Remove(tabCodeVerification)

        'TODO:  Add Handwritten tabs back in
        'If CurrentUser.IsHandwrittenOperator OrElse CurrentUser.IsHandwrittenVerifier Then
        '    ctrlHandEntry = New ucHandEntry
        'End If
        'If Not CurrentUser.IsHandwrittenOperator Then mtpNavigation.Tabs.Remove(tabHandwritten)
        'If Not CurrentUser.IsHandwrittenVerifier Then mtpNavigation.Tabs.Remove(tabHandwrittenVerification)
        mtpNavigation.Tabs.Remove(tabHandwritten)
        mtpNavigation.Tabs.Remove(tabHandwrittenVerification)

        If CurrentUser.IsAdministrator Then
            If CurrentUser.IsFileImporter Then ctrlFileImport = New ucFileImport
            If CurrentUser.IsFinalizer Then ctrlFinalize = New ucFinalize
            If CurrentUser.IsCommentModifier Then ctrlModifyComment = New ucModifyComment
        Else
            mtpNavigation.Tabs.Remove(tabAdmin)
        End If

        'Now that we have removed tabs, for some reason we need this call to Reload
        'mtpNavigation.ReloadTabs()
    End Sub

    'Loads a Main Content Section into the MainContentPanel
    Private Sub LoadSection(ByVal sectionControl As Control, ByVal isWorkSection As Boolean)
        'Clear out whatever is in there
        pnlMainContent.Controls.Clear()

        'If we are adding a WorkSection then store it for later
        If isWorkSection Then
            mCurrentSection = CType(sectionControl, IWorkSection)
        Else
            mCurrentSection = Nothing
        End If

        If Not sectionControl Is Nothing Then
            'Dock the control to the panel
            sectionControl.Dock = DockStyle.Fill

            'Add new control to panel
            pnlMainContent.Controls.Add(sectionControl)
        End If
    End Sub

    'Determine which toolbar buttons to display
    Private Sub DisplayToolBarButtons()
        'Show refresh queue if this is a work section
        btnRefreshQueue.Visible = (Not mCurrentSection Is Nothing)

        'Always show user settings
        btnSettings.Visible = True

        'Always show system stats
        btnStats.Visible = True
        'Dim tab As NRC.WinForms.MultiPaneTab = mtpNavigation.SelectedTab

        'If tab Is Me.tabKeying Then

        'End If

    End Sub

    Private Sub ShowSystemStats()
        Dim stats As New frmStats
        stats.ShowDialog()
    End Sub
#End Region

End Class
