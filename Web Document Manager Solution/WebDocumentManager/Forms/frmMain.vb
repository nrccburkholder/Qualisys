Public Class frmMain
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

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
    Friend WithEvents sbStatus As System.Windows.Forms.StatusBar
    Friend WithEvents lblUserName As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblVersion As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblEnvironment As System.Windows.Forms.StatusBarPanel
    Friend WithEvents lblStatus As System.Windows.Forms.StatusBarPanel
    Friend WithEvents PagePanel As System.Windows.Forms.Panel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents pnlRight As System.Windows.Forms.Panel
    Friend WithEvents pnlLeft As System.Windows.Forms.Panel
    Friend WithEvents MultiPane As NRC.WinForms.MultiPane
    Friend WithEvents tabDocumentManager As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabApb As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabMassPosting As Nrc.WinForms.MultiPaneTab
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents tabSection4 As Nrc.WinForms.MultiPaneTab
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmMain))
        Me.sbStatus = New System.Windows.Forms.StatusBar
        Me.lblStatus = New System.Windows.Forms.StatusBarPanel
        Me.lblUserName = New System.Windows.Forms.StatusBarPanel
        Me.lblVersion = New System.Windows.Forms.StatusBarPanel
        Me.lblEnvironment = New System.Windows.Forms.StatusBarPanel
        Me.tabSection4 = New Nrc.WinForms.MultiPaneTab
        Me.PagePanel = New System.Windows.Forms.Panel
        Me.pnlLeft = New System.Windows.Forms.Panel
        Me.MultiPane = New Nrc.WinForms.MultiPane
        Me.tabDocumentManager = New Nrc.WinForms.MultiPaneTab
        Me.tabApb = New Nrc.WinForms.MultiPaneTab
        Me.tabMassPosting = New Nrc.WinForms.MultiPaneTab
        Me.pnlRight = New System.Windows.Forms.Panel
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.FileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.PagePanel.SuspendLayout()
        Me.pnlLeft.SuspendLayout()
        Me.MultiPane.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'sbStatus
        '
        Me.sbStatus.Location = New System.Drawing.Point(0, 482)
        Me.sbStatus.Name = "sbStatus"
        Me.sbStatus.Panels.AddRange(New System.Windows.Forms.StatusBarPanel() {Me.lblStatus, Me.lblUserName, Me.lblVersion, Me.lblEnvironment})
        Me.sbStatus.ShowPanels = True
        Me.sbStatus.Size = New System.Drawing.Size(608, 22)
        Me.sbStatus.TabIndex = 1
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Spring
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Text = "Ready"
        Me.lblStatus.Width = 376
        '
        'lblUserName
        '
        Me.lblUserName.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblUserName.Name = "lblUserName"
        Me.lblUserName.Text = "BJones"
        Me.lblUserName.Width = 52
        '
        'lblVersion
        '
        Me.lblVersion.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Text = "v1.0.0.0"
        Me.lblVersion.Width = 54
        '
        'lblEnvironment
        '
        Me.lblEnvironment.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblEnvironment.MinWidth = 110
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Text = "Production (Mars)  "
        Me.lblEnvironment.Width = 110
        '
        'tabSection4
        '
        Me.tabSection4.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(251, Byte), Integer), CType(CType(230, Byte), Integer), CType(CType(148, Byte), Integer))
        Me.tabSection4.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(149, Byte), Integer), CType(CType(21, Byte), Integer))
        Me.tabSection4.BackColor = System.Drawing.Color.White
        Me.tabSection4.Caption = "Section 4"
        Me.tabSection4.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabSection4.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabSection4.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabSection4.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabSection4.Icon = CType(resources.GetObject("tabSection4.Icon"), System.Drawing.Icon)
        Me.tabSection4.IconHeight = 32
        Me.tabSection4.IconWidth = 32
        Me.tabSection4.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabSection4.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabSection4.InactiveTextColor = System.Drawing.Color.Black
        Me.tabSection4.Location = New System.Drawing.Point(1, 399)
        Me.tabSection4.Name = "tabSection4"
        Me.tabSection4.Size = New System.Drawing.Size(176, 32)
        Me.tabSection4.TabIndex = 0
        Me.tabSection4.Text = "Section 4"
        '
        'PagePanel
        '
        Me.PagePanel.Controls.Add(Me.Splitter1)
        Me.PagePanel.Controls.Add(Me.pnlRight)
        Me.PagePanel.Controls.Add(Me.pnlLeft)
        Me.PagePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PagePanel.Location = New System.Drawing.Point(0, 24)
        Me.PagePanel.Name = "PagePanel"
        Me.PagePanel.Size = New System.Drawing.Size(608, 458)
        Me.PagePanel.TabIndex = 6
        '
        'pnlLeft
        '
        Me.pnlLeft.Controls.Add(Me.MultiPane)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.Location = New System.Drawing.Point(0, 0)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Padding = New System.Windows.Forms.Padding(3)
        Me.pnlLeft.Size = New System.Drawing.Size(184, 458)
        Me.pnlLeft.TabIndex = 4
        '
        'MultiPane
        '
        Me.MultiPane.BackColor = System.Drawing.Color.White
        Me.MultiPane.Controls.Add(Me.tabDocumentManager)
        Me.MultiPane.Controls.Add(Me.tabApb)
        Me.MultiPane.Controls.Add(Me.tabMassPosting)
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(3, 3)
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.PaneControl = Nothing
        Me.MultiPane.Size = New System.Drawing.Size(178, 452)
        Me.MultiPane.SubCaption = ""
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabDocumentManager)
        Me.MultiPane.Tabs.Add(Me.tabApb)
        Me.MultiPane.Tabs.Add(Me.tabMassPosting)
        '
        'tabDocumentManager
        '
        Me.tabDocumentManager.Active = True
        Me.tabDocumentManager.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(251, Byte), Integer), CType(CType(230, Byte), Integer), CType(CType(148, Byte), Integer))
        Me.tabDocumentManager.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(149, Byte), Integer), CType(CType(21, Byte), Integer))
        Me.tabDocumentManager.Caption = "Document Manager"
        Me.tabDocumentManager.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabDocumentManager.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabDocumentManager.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabDocumentManager.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabDocumentManager.Icon = CType(resources.GetObject("tabDocumentManager.Icon"), System.Drawing.Icon)
        Me.tabDocumentManager.IconHeight = 30
        Me.tabDocumentManager.IconWidth = 30
        Me.tabDocumentManager.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabDocumentManager.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabDocumentManager.InactiveTextColor = System.Drawing.Color.Black
        Me.tabDocumentManager.Location = New System.Drawing.Point(1, 355)
        Me.tabDocumentManager.Name = "tabDocumentManager"
        Me.tabDocumentManager.Size = New System.Drawing.Size(176, 32)
        Me.tabDocumentManager.TabIndex = 0
        Me.tabDocumentManager.Text = "Document Manager"
        '
        'tabApb
        '
        Me.tabApb.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(251, Byte), Integer), CType(CType(230, Byte), Integer), CType(CType(148, Byte), Integer))
        Me.tabApb.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(149, Byte), Integer), CType(CType(21, Byte), Integer))
        Me.tabApb.Caption = "Action Plan Builder"
        Me.tabApb.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabApb.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabApb.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabApb.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabApb.Icon = CType(resources.GetObject("tabApb.Icon"), System.Drawing.Icon)
        Me.tabApb.IconHeight = 30
        Me.tabApb.IconWidth = 30
        Me.tabApb.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabApb.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabApb.InactiveTextColor = System.Drawing.Color.Black
        Me.tabApb.Location = New System.Drawing.Point(1, 387)
        Me.tabApb.Name = "tabApb"
        Me.tabApb.Size = New System.Drawing.Size(176, 32)
        Me.tabApb.TabIndex = 0
        Me.tabApb.Text = "Action Plan Builder"
        '
        'tabMassPosting
        '
        Me.tabMassPosting.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(251, Byte), Integer), CType(CType(230, Byte), Integer), CType(CType(148, Byte), Integer))
        Me.tabMassPosting.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(238, Byte), Integer), CType(CType(149, Byte), Integer), CType(CType(21, Byte), Integer))
        Me.tabMassPosting.Caption = "Mass Posting"
        Me.tabMassPosting.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabMassPosting.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabMassPosting.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabMassPosting.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabMassPosting.Icon = CType(resources.GetObject("tabMassPosting.Icon"), System.Drawing.Icon)
        Me.tabMassPosting.IconHeight = 32
        Me.tabMassPosting.IconWidth = 32
        Me.tabMassPosting.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(CType(203, Byte), Integer), CType(CType(225, Byte), Integer), CType(CType(252, Byte), Integer))
        Me.tabMassPosting.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(CType(125, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(224, Byte), Integer))
        Me.tabMassPosting.InactiveTextColor = System.Drawing.Color.Black
        Me.tabMassPosting.Location = New System.Drawing.Point(1, 419)
        Me.tabMassPosting.Name = "tabMassPosting"
        Me.tabMassPosting.Size = New System.Drawing.Size(176, 32)
        Me.tabMassPosting.TabIndex = 0
        Me.tabMassPosting.Text = "Mass Posting"
        '
        'pnlRight
        '
        Me.pnlRight.BackColor = System.Drawing.SystemColors.Control
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.Location = New System.Drawing.Point(184, 0)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Padding = New System.Windows.Forms.Padding(3)
        Me.pnlRight.Size = New System.Drawing.Size(424, 458)
        Me.pnlRight.TabIndex = 6
        '
        'Splitter1
        '
        Me.Splitter1.Location = New System.Drawing.Point(184, 0)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(4, 458)
        Me.Splitter1.TabIndex = 7
        Me.Splitter1.TabStop = False
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(608, 24)
        Me.MenuStrip1.TabIndex = 7
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileToolStripMenuItem
        '
        Me.FileToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExitToolStripMenuItem})
        Me.FileToolStripMenuItem.Name = "FileToolStripMenuItem"
        Me.FileToolStripMenuItem.Size = New System.Drawing.Size(35, 20)
        Me.FileToolStripMenuItem.Text = "File"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'frmMain
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.AutoScroll = True
        Me.ClientSize = New System.Drawing.Size(608, 504)
        Me.Controls.Add(Me.PagePanel)
        Me.Controls.Add(Me.sbStatus)
        Me.Controls.Add(Me.MenuStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "frmMain"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmMain"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).EndInit()
        Me.PagePanel.ResumeLayout(False)
        Me.pnlLeft.ResumeLayout(False)
        Me.MultiPane.ResumeLayout(False)
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    'Updater
    'Private WithEvents mUpdater As Microsoft.Samples.AppUpdater.AppUpdater = modMain.Updater
    Private WithEvents navApbSection As ApbSection
    Private WithEvents ctlApbPost As ApbPost
    Private WithEvents ctlApbRollback As ApbRollback
    Private WithEvents navOrgUnitSelector As OrgUnitSelector
    Private WithEvents ctlDocumentManager As DocumentManager
    Private WithEvents ctlMassPoster As MassPoster
    Private WithEvents ctLRollbackMassPosts As RollbackMassPosts
    Private WithEvents navMassPoster As MassPosterSection
    Private mLastAPBControl As Control

    'Sections
    'Private WithEvents ctrlSection1 As New Section1

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Text = Globals.AppName
        'EnableThemes(Me)
        lblUserName.Text = CurrentUser.LoginName
        lblEnvironment.Text = Config.EnvironmentName
        lblVersion.Text = Application.ProductVersion

        navApbSection = New ApbSection
        ctlApbPost = New ApbPost
        ctlApbRollback = New ApbRollback
        navOrgUnitSelector = New OrgUnitSelector(CurrentUser.LoginName)
        ctlDocumentManager = New DocumentManager
        ctlMassPoster = New MassPoster
        ctLRollbackMassPosts = New RollbackMassPosts
        navMassPoster = New MassPosterSection


        'Show the awsome splash screen
        'Dim frmSplash As New frmSplashScreen(True)
        'frmSplash.ShowDialog()

        Dim asm As System.Reflection.AssemblyCopyrightAttribute
        asm = DirectCast(Attribute.GetCustomAttribute(System.Reflection.Assembly.GetExecutingAssembly, GetType(System.Reflection.AssemblyCopyrightAttribute)), System.Reflection.AssemblyCopyrightAttribute)

        Dim str As String = asm.Copyright
        MultiPane.SelectedIndex = 0

    End Sub

    Private Sub MultiPane_PaneChanged(ByVal sender As System.Object, ByVal e As Nrc.WinForms.MultiPane.PaneChangedEventArgs) Handles MultiPane.PaneChanged
        If e.NewTab Is tabApb Then
            LoadSection(Nothing)
            'EnableThemes(navApbSection)
            MultiPane.SubCaption = "APB Posting Options"
            MultiPane.LoadControl(navApbSection)
            LoadSection(mLastAPBControl)
        ElseIf e.NewTab Is tabDocumentManager Then
            LoadSection(Nothing)
            MultiPane.SubCaption = "OrgUnit Tree"
            'EnableThemes(navOrgUnitSelector)
            MultiPane.LoadControl(navOrgUnitSelector)
            LoadSection(ctlDocumentManager)
        ElseIf e.NewTab Is tabMassPosting Then
            LoadSection(Nothing)
            MultiPane.SubCaption = "Mass Posting"
            'EnableThemes(navMassPoster)
            MultiPane.LoadControl(navMassPoster)
        End If
    End Sub

    Private Sub MultiPaneSection_OrgUnitSelection(ByVal pOrgUnit As Nrc.NRCAuthLib.OrgUnit) Handles navOrgUnitSelector.nodeSelected
        ctlDocumentManager.OrgUnitChange(pOrgUnit, CurrentUser.Member)
        'EnableThemes(ctlDocumentManager)
        LoadSection(ctlDocumentManager)
    End Sub

    Private Sub MultiPaneSection_MassPoster(ByVal button As MassPosterSection.PressedButton) Handles navMassPoster.btnPressed
        LoadSection(Nothing)
        If button = MassPosterSection.PressedButton.OpenSpreadsheet Then
            Dim dialog As New CreateBatch(CurrentUser.Member.MemberId)
            If dialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                ctlMassPoster.OpenNewSpreadsheet(CurrentUser.Member, dialog.Batch)
                'EnableThemes(ctlMassPoster)
                LoadSection(ctlMassPoster)
            End If
        Else
            LoadSection(Me.ctLRollbackMassPosts)
        End If
    End Sub

    Private Sub MultiPaneSection_ApbSelection(ByVal SelectedButton As ApbSection.ApbButtons) Handles navApbSection.btnPressed
        Select Case SelectedButton
            Case ApbSection.ApbButtons.Post
                'EnableThemes(ctlApbPost)
                LoadSection(ctlApbPost)
                ctlApbPost.Start()
                mLastAPBControl = ctlApbPost
            Case ApbSection.ApbButtons.Rollback
                'EnableThemes(ctlApbRollback)
                LoadSection(ctlApbRollback)
                ctlApbRollback.Start()
                mLastAPBControl = ctlApbRollback
        End Select
    End Sub

    Private Sub LoadSection(ByVal sectionControl As Control)
        pnlRight.Controls.Clear()

        If Not sectionControl Is Nothing Then
            'Dock the control to the panel
            sectionControl.Dock = DockStyle.Fill

            'Add new control to panel
            pnlRight.Controls.Add(sectionControl)
        End If
    End Sub

    Private Sub mnuSaveAs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim int As Integer
        int = Integer.Parse("hello")
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Application.Exit()
    End Sub
End Class
