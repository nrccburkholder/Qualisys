Imports NormsApplicationBusinessObjectsLibrary
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
    Friend WithEvents MultiPane As NRC.WinForms.MultiPane
    Friend WithEvents pnlLeft As System.Windows.Forms.Panel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents pnlRight As System.Windows.Forms.Panel
    Friend WithEvents tabComparisons As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabUSNorms As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabCanadianNorms As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabAdministration As NRC.WinForms.MultiPaneTab
    Friend WithEvents tabUserOptions As NRC.WinForms.MultiPaneTab
    Friend WithEvents mnuMain As System.Windows.Forms.MainMenu
    Friend WithEvents mnuFile As System.Windows.Forms.MenuItem
    Friend WithEvents mnuOpen As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmMain))
        Me.MultiPane = New NRC.WinForms.MultiPane
        Me.tabComparisons = New NRC.WinForms.MultiPaneTab
        Me.tabUserOptions = New NRC.WinForms.MultiPaneTab
        Me.tabUSNorms = New NRC.WinForms.MultiPaneTab
        Me.tabCanadianNorms = New NRC.WinForms.MultiPaneTab
        Me.tabAdministration = New NRC.WinForms.MultiPaneTab
        Me.sbStatus = New System.Windows.Forms.StatusBar
        Me.lblStatus = New System.Windows.Forms.StatusBarPanel
        Me.lblUserName = New System.Windows.Forms.StatusBarPanel
        Me.lblVersion = New System.Windows.Forms.StatusBarPanel
        Me.lblEnvironment = New System.Windows.Forms.StatusBarPanel
        Me.pnlLeft = New System.Windows.Forms.Panel
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.pnlRight = New System.Windows.Forms.Panel
        Me.mnuMain = New System.Windows.Forms.MainMenu
        Me.mnuFile = New System.Windows.Forms.MenuItem
        Me.mnuOpen = New System.Windows.Forms.MenuItem
        Me.MultiPane.SuspendLayout()
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlLeft.SuspendLayout()
        Me.SuspendLayout()
        '
        'MultiPane
        '
        Me.MultiPane.BackColor = System.Drawing.Color.White
        Me.MultiPane.Controls.Add(Me.tabComparisons)
        Me.MultiPane.Controls.Add(Me.tabUserOptions)
        Me.MultiPane.Controls.Add(Me.tabUSNorms)
        Me.MultiPane.Controls.Add(Me.tabCanadianNorms)
        Me.MultiPane.Controls.Add(Me.tabAdministration)
        Me.MultiPane.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MultiPane.Location = New System.Drawing.Point(3, 3)
        Me.MultiPane.Name = "MultiPane"
        Me.MultiPane.PaneControl = Nothing
        Me.MultiPane.Size = New System.Drawing.Size(178, 578)
        Me.MultiPane.SubCaption = ""
        Me.MultiPane.TabIndex = 0
        Me.MultiPane.Tabs.Add(Me.tabComparisons)
        Me.MultiPane.Tabs.Add(Me.tabUserOptions)
        Me.MultiPane.Tabs.Add(Me.tabUSNorms)
        Me.MultiPane.Tabs.Add(Me.tabCanadianNorms)
        Me.MultiPane.Tabs.Add(Me.tabAdministration)
        '
        'tabComparisons
        '
        Me.tabComparisons.Active = True
        Me.tabComparisons.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(251, Byte), CType(230, Byte), CType(148, Byte))
        Me.tabComparisons.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(238, Byte), CType(149, Byte), CType(21, Byte))
        Me.tabComparisons.Caption = "Comparisons"
        Me.tabComparisons.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabComparisons.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabComparisons.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabComparisons.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabComparisons.Icon = Nothing
        Me.tabComparisons.IconHeight = 32
        Me.tabComparisons.IconWidth = 32
        Me.tabComparisons.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabComparisons.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabComparisons.InactiveTextColor = System.Drawing.Color.Black
        Me.tabComparisons.Location = New System.Drawing.Point(1, 417)
        Me.tabComparisons.Name = "tabComparisons"
        Me.tabComparisons.Size = New System.Drawing.Size(176, 32)
        Me.tabComparisons.TabIndex = 0
        '
        'tabUserOptions
        '
        Me.tabUserOptions.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(251, Byte), CType(230, Byte), CType(148, Byte))
        Me.tabUserOptions.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(238, Byte), CType(149, Byte), CType(21, Byte))
        Me.tabUserOptions.Caption = "User Dimensions"
        Me.tabUserOptions.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabUserOptions.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabUserOptions.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabUserOptions.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabUserOptions.Icon = Nothing
        Me.tabUserOptions.IconHeight = 32
        Me.tabUserOptions.IconWidth = 32
        Me.tabUserOptions.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabUserOptions.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabUserOptions.InactiveTextColor = System.Drawing.Color.Black
        Me.tabUserOptions.Location = New System.Drawing.Point(1, 449)
        Me.tabUserOptions.Name = "tabUserOptions"
        Me.tabUserOptions.Size = New System.Drawing.Size(176, 32)
        Me.tabUserOptions.TabIndex = 0
        '
        'tabUSNorms
        '
        Me.tabUSNorms.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(251, Byte), CType(230, Byte), CType(148, Byte))
        Me.tabUSNorms.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(238, Byte), CType(149, Byte), CType(21, Byte))
        Me.tabUSNorms.Caption = "US Norms"
        Me.tabUSNorms.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabUSNorms.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabUSNorms.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabUSNorms.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabUSNorms.Icon = Nothing
        Me.tabUSNorms.IconHeight = 32
        Me.tabUSNorms.IconWidth = 32
        Me.tabUSNorms.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabUSNorms.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabUSNorms.InactiveTextColor = System.Drawing.Color.Black
        Me.tabUSNorms.Location = New System.Drawing.Point(1, 481)
        Me.tabUSNorms.Name = "tabUSNorms"
        Me.tabUSNorms.Size = New System.Drawing.Size(176, 32)
        Me.tabUSNorms.TabIndex = 0
        '
        'tabCanadianNorms
        '
        Me.tabCanadianNorms.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(251, Byte), CType(230, Byte), CType(148, Byte))
        Me.tabCanadianNorms.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(238, Byte), CType(149, Byte), CType(21, Byte))
        Me.tabCanadianNorms.Caption = "Canadian Norms"
        Me.tabCanadianNorms.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabCanadianNorms.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabCanadianNorms.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabCanadianNorms.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabCanadianNorms.Icon = Nothing
        Me.tabCanadianNorms.IconHeight = 32
        Me.tabCanadianNorms.IconWidth = 32
        Me.tabCanadianNorms.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabCanadianNorms.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabCanadianNorms.InactiveTextColor = System.Drawing.Color.Black
        Me.tabCanadianNorms.Location = New System.Drawing.Point(1, 513)
        Me.tabCanadianNorms.Name = "tabCanadianNorms"
        Me.tabCanadianNorms.Size = New System.Drawing.Size(176, 32)
        Me.tabCanadianNorms.TabIndex = 0
        '
        'tabAdministration
        '
        Me.tabAdministration.ActiveGradientHighColor = System.Drawing.Color.FromArgb(CType(251, Byte), CType(230, Byte), CType(148, Byte))
        Me.tabAdministration.ActiveGradientLowColor = System.Drawing.Color.FromArgb(CType(238, Byte), CType(149, Byte), CType(21, Byte))
        Me.tabAdministration.Caption = "Administrative"
        Me.tabAdministration.Cursor = System.Windows.Forms.Cursors.Hand
        Me.tabAdministration.Font = New System.Drawing.Font("Tahoma", 10.0!)
        Me.tabAdministration.HoverGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabAdministration.HoverGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabAdministration.Icon = Nothing
        Me.tabAdministration.IconHeight = 32
        Me.tabAdministration.IconWidth = 32
        Me.tabAdministration.InactiveGradientHighColor = System.Drawing.Color.FromArgb(CType(203, Byte), CType(225, Byte), CType(252, Byte))
        Me.tabAdministration.InactiveGradientLowColor = System.Drawing.Color.FromArgb(CType(125, Byte), CType(165, Byte), CType(224, Byte))
        Me.tabAdministration.InactiveTextColor = System.Drawing.Color.Black
        Me.tabAdministration.Location = New System.Drawing.Point(1, 545)
        Me.tabAdministration.Name = "tabAdministration"
        Me.tabAdministration.Size = New System.Drawing.Size(176, 32)
        Me.tabAdministration.TabIndex = 0
        '
        'sbStatus
        '
        Me.sbStatus.Location = New System.Drawing.Point(0, 584)
        Me.sbStatus.Name = "sbStatus"
        Me.sbStatus.Panels.AddRange(New System.Windows.Forms.StatusBarPanel() {Me.lblStatus, Me.lblUserName, Me.lblVersion, Me.lblEnvironment})
        Me.sbStatus.ShowPanels = True
        Me.sbStatus.Size = New System.Drawing.Size(608, 22)
        Me.sbStatus.TabIndex = 1
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Spring
        Me.lblStatus.Text = "Ready"
        Me.lblStatus.Width = 376
        '
        'lblUserName
        '
        Me.lblUserName.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblUserName.Text = "BJones"
        Me.lblUserName.Width = 52
        '
        'lblVersion
        '
        Me.lblVersion.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblVersion.Text = "v1.0.0.0"
        Me.lblVersion.Width = 54
        '
        'lblEnvironment
        '
        Me.lblEnvironment.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Contents
        Me.lblEnvironment.MinWidth = 110
        Me.lblEnvironment.Text = "Production (Mars)  "
        Me.lblEnvironment.Width = 110
        '
        'pnlLeft
        '
        Me.pnlLeft.Controls.Add(Me.MultiPane)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.DockPadding.All = 3
        Me.pnlLeft.Location = New System.Drawing.Point(0, 0)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(184, 584)
        Me.pnlLeft.TabIndex = 3
        '
        'Splitter1
        '
        Me.Splitter1.Location = New System.Drawing.Point(184, 0)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(4, 584)
        Me.Splitter1.TabIndex = 4
        Me.Splitter1.TabStop = False
        '
        'pnlRight
        '
        Me.pnlRight.AutoScroll = True
        Me.pnlRight.BackColor = System.Drawing.SystemColors.Control
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.DockPadding.All = 3
        Me.pnlRight.Location = New System.Drawing.Point(188, 0)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(420, 584)
        Me.pnlRight.TabIndex = 5
        '
        'mnuMain
        '
        Me.mnuMain.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFile})
        '
        'mnuFile
        '
        Me.mnuFile.Index = 0
        Me.mnuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuOpen})
        Me.mnuFile.Text = "File"
        '
        'mnuOpen
        '
        Me.mnuOpen.Enabled = False
        Me.mnuOpen.Index = 0
        Me.mnuOpen.Text = "Open Query"
        '
        'frmMain
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.AutoScroll = True
        Me.ClientSize = New System.Drawing.Size(608, 606)
        Me.Controls.Add(Me.pnlRight)
        Me.Controls.Add(Me.Splitter1)
        Me.Controls.Add(Me.pnlLeft)
        Me.Controls.Add(Me.sbStatus)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Menu = Me.mnuMain
        Me.Name = "frmMain"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Comparison Data Application"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MultiPane.ResumeLayout(False)
        CType(Me.lblStatus, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblUserName, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblVersion, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.lblEnvironment, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlLeft.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    'Sections
    Private WithEvents DemographicCounts As New ctlDemographicCounts
    Private WithEvents QuestionCounts As New ctlQuestionCounts
    Private WithEvents QuestionUsers As New ctlQuestionUsers
    Private WithEvents navComparisons As New ComparisonReports
    Private WithEvents navUSNorms As New USNorms
    Private WithEvents navCanadaNorms As New CanadaNorms
    Private WithEvents navAdministration As New Administration
    Private WithEvents navUserOptions As New UserOptions
    Private WithEvents AverageScores As New ctlAverageScores
    Private WithEvents CanadaNormSettingWizard As New CanadaNormSettingWizard
    Private WithEvents CanadaNormSchedule As New CanadaNormSchedule
    Private WithEvents CanadaNormQueue As New CanadaNormQueue
    Private WithEvents CanadaRollup As New CanadaRollup
    Private WithEvents CanadaBenchmarkPerformer As New CanadaBenchmarkPerformer
    Private WithEvents Frequencies As New ctlFrequencies
    Private WithEvents ScoresAndRanks As New ScoresAndRank
    Private WithEvents Percentiles1to100 As New Percentiles1to100
    Private WithEvents CreateNewStandardDimension As CreateDimension
    Private WithEvents CreateNewUserDimension As CreateDimension
    Private WithEvents EditUserDimension As EditDimension
    Private WithEvents EditStandardDimension As EditDimension
    Private WithEvents EquivalentQuestionsControl As EquivalentQuestions
    Private WithEvents SurveyTypesControl As SurveyTypesEditor
    Private WithEvents CountriesControl As CountriesEditor
    Private WithEvents UsNormEditorControl As USNormEditor
    Private WithEvents QuestionsbySurveyControl As QuestionsbySurvey
    Private WithEvents ChangeSurveyCountryControl As ChangeSurveyCountry
    Private WithEvents PopulateNormsControl As PopulateNorms
    Private WithEvents PromoteNormsControl As PromoteNorms
    Private WithEvents LookupandDataUpdateControl As LookupandDataUpdate
    Private WithEvents ctrlBackupNorms As BackupNorms
    Private reportType As ComparisonDataQuery.enuReportType

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.Text = AppName
        EnableThemes(Me)

        'Check Permissions
        Select Case CurrentUser.Authenticate
            Case CurrentUser.AuthResult.AdministrativeAccess
                'Do Nothing
            Case CurrentUser.AuthResult.CanadianAccess
                MultiPane.Tabs.Remove(tabUSNorms)
                MultiPane.Tabs.Remove(tabAdministration)
            Case CurrentUser.AuthResult.GeneralAccess
                MultiPane.Tabs.Remove(tabUSNorms)
                MultiPane.Tabs.Remove(tabCanadianNorms)
                MultiPane.Tabs.Remove(tabAdministration)
        End Select

        'Temporary Code until member level privileges exist
        'MultiPane.Tabs.Remove(tabUSNorms)
        'MultiPane.Tabs.Remove(tabCanadianNorms)
        'MultiPane.Tabs.Remove(tabAdministration)

        MultiPane.ReloadTabs()

        'Current User
        sbStatus.Panels(1).Text = CurrentUser.DisplayName

        'Version Number
        sbStatus.Panels(2).Text = Application.ProductVersion

        'Current Environment
        sbStatus.Panels(3).Text = Config.EnvironmentName

        MultiPane.SelectedIndex = 0

        'Show the awsome splash screen
        Dim frmSplash As New frmSplashScreen(True)
        frmSplash.ShowDialog()

    End Sub

    Private Sub MultiPane_PaneChanged(ByVal sender As Object, ByVal e As NRC.WinForms.MultiPane.PaneChangedEventArgs) Handles MultiPane.PaneChanged
        Dim tree As New TreeView
        Dim tab As NRC.WinForms.MultiPaneTab = e.NewTab

        pnlRight.Controls.Clear()
        If tab Is tabComparisons Then
            EnableThemes(navComparisons)
            MultiPane.LoadControl(navComparisons)
            If pnlRight.Controls.Count = 0 Then mnuOpen.Enabled = False
        ElseIf tab Is tabUSNorms Then
            EnableThemes(navUSNorms)
            MultiPane.LoadControl(navUSNorms)
            mnuOpen.Enabled = False
        ElseIf tab Is tabCanadianNorms Then
            EnableThemes(navCanadaNorms)
            MultiPane.LoadControl(navCanadaNorms)
            mnuOpen.Enabled = False
        ElseIf tab Is tabAdministration Then
            EnableThemes(navAdministration)
            MultiPane.LoadControl(navAdministration)
            mnuOpen.Enabled = False
        ElseIf tab Is tabUserOptions Then
            EnableThemes(navUserOptions)
            MultiPane.LoadControl(navUserOptions)
            mnuOpen.Enabled = False
        End If
    End Sub

    Private Sub MultiPaneSection_ComparisonsSelection(ByVal SelectedButton As ComparisonReports.ComparisonButtons) Handles navComparisons.btnPressed
        mnuOpen.Enabled = True
        If SelectedButton = ComparisonReports.ComparisonButtons.btnDemoCounts Then
            reportType = ComparisonDataQuery.enuReportType.DemographicCounts
            EnableThemes(DemographicCounts)
            LoadSection(DemographicCounts)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnquestioncounts Then
            reportType = ComparisonDataQuery.enuReportType.QuestionCounts
            EnableThemes(QuestionCounts)
            LoadSection(QuestionCounts)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnFrequencies Then
            reportType = ComparisonDataQuery.enuReportType.Frequencies
            EnableThemes(Frequencies)
            LoadSection(Frequencies)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnAverage Then
            reportType = ComparisonDataQuery.enuReportType.AverageScores
            EnableThemes(AverageScores)
            LoadSection(AverageScores)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnScoresandRanks Then
            reportType = ComparisonDataQuery.enuReportType.GroupRanksAndScores
            EnableThemes(ScoresAndRanks)
            LoadSection(ScoresAndRanks)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnPercentiles Then
            reportType = ComparisonDataQuery.enuReportType.Percentiles1to100
            EnableThemes(Percentiles1to100)
            LoadSection(Percentiles1to100)
        ElseIf SelectedButton = ComparisonReports.ComparisonButtons.btnQuestionUsers Then
            reportType = ComparisonDataQuery.enuReportType.QuestionUsers
            EnableThemes(QuestionUsers)
            LoadSection(QuestionUsers)
        End If
    End Sub

    Private Sub MultiPaneSection_UserOptionsSelection(ByVal SelectedButton As UserOptions.AdministrationButtons) Handles navUserOptions.btnPressed
        If SelectedButton = UserOptions.AdministrationButtons.btnCreateDimension Then
            If CreateNewUserDimension Is Nothing Then CreateNewUserDimension = New CreateDimension
            CreateNewUserDimension.isStandard = False
            EnableThemes(CreateNewUserDimension)
            LoadSection(CreateNewUserDimension)
        ElseIf SelectedButton = UserOptions.AdministrationButtons.btnEditDimension Then
            If EditUserDimension Is Nothing Then EditUserDimension = New EditDimension
            EnableThemes(EditUserDimension)
            LoadSection(EditUserDimension)
        End If
    End Sub

    Private Sub MultiPaneSection_USNormsSelection(ByVal SelectedButton As USNorms.USNormButtons) Handles navUSNorms.btnPressed
        If SelectedButton = USNorms.USNormButtons.btnCreateEditNorm Then
            If UsNormEditorControl Is Nothing Then UsNormEditorControl = New USNormEditor
            EnableThemes(UsNormEditorControl)
            LoadSection(UsNormEditorControl)
        ElseIf SelectedButton = USNorms.USNormButtons.btnPopulate Then
            If PopulateNormsControl Is Nothing Then PopulateNormsControl = New PopulateNorms
            EnableThemes(PopulateNormsControl)
            LoadSection(PopulateNormsControl)
        ElseIf SelectedButton = USNorms.USNormButtons.btnUpdate Then
            If LookupandDataUpdateControl Is Nothing Then LookupandDataUpdateControl = New LookupandDataUpdate
            EnableThemes(LookupandDataUpdateControl)
            LoadSection(LookupandDataUpdateControl)
        ElseIf SelectedButton = USNorms.USNormButtons.btnPromote Then
            If PromoteNormsControl Is Nothing Then PromoteNormsControl = New PromoteNorms
            EnableThemes(PromoteNormsControl)
            LoadSection(PromoteNormsControl)
        ElseIf SelectedButton = USNorms.USNormButtons.btnBackup Then
            If ctrlBackupNorms Is Nothing Then ctrlBackupNorms = New BackupNorms
            EnableThemes(ctrlBackupNorms)
            LoadSection(ctrlBackupNorms)
        End If
    End Sub

    Private Sub MultiPaneSection_CanadaNormsSelection(ByVal SelectedButton As CanadaNorms.CanadaNormButtons) Handles navCanadaNorms.btnPressed
        If SelectedButton = CanadaNorms.CanadaNormButtons.SetupNorm Then
            EnableThemes(CanadaNormSettingWizard)
            LoadSection(CanadaNormSettingWizard)
            CanadaNormSettingWizard.Start()
        ElseIf SelectedButton = CanadaNorms.CanadaNormButtons.ScheduleNorm Then
            EnableThemes(CanadaNormSchedule)
            LoadSection(CanadaNormSchedule)
            CanadaNormSchedule.Start()
        ElseIf SelectedButton = CanadaNorms.CanadaNormButtons.NormQueue Then
            EnableThemes(CanadaNormQueue)
            LoadSection(CanadaNormQueue)
            CanadaNormQueue.Start()
            CanadaNormQueue.lvwList.Focus()
        ElseIf SelectedButton = CanadaNorms.CanadaNormButtons.SetupRollup Then
            EnableThemes(CanadaRollup)
            LoadSection(CanadaRollup)
            CanadaRollup.Start()
        ElseIf SelectedButton = CanadaNorms.CanadaNormButtons.BenchmarkPerformer Then
            EnableThemes(CanadaBenchmarkPerformer)
            LoadSection(CanadaBenchmarkPerformer)
            CanadaBenchmarkPerformer.Start()
        End If
    End Sub

    Private Sub MultiPaneSection_AdministationSelection(ByVal SelectedButton As Administration.AdministrationButtons) Handles navAdministration.btnPressed
        If SelectedButton = Administration.AdministrationButtons.btnCreateDimension Then
            If CreateNewStandardDimension Is Nothing Then CreateNewStandardDimension = New CreateDimension
            CreateNewStandardDimension.isStandard = True
            LoadSection(CreateNewStandardDimension)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnEditDimension Then
            If EditStandardDimension Is Nothing Then EditStandardDimension = New EditDimension
            EditStandardDimension.isStandard = True
            LoadSection(EditStandardDimension)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnEquivalentQuestions Then
            If EquivalentQuestionsControl Is Nothing Then EquivalentQuestionsControl = New EquivalentQuestions
            LoadSection(EquivalentQuestionsControl)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnSurveyTypes Then
            If SurveyTypesControl Is Nothing Then SurveyTypesControl = New SurveyTypesEditor
            LoadSection(SurveyTypesControl)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnCountries Then
            If CountriesControl Is Nothing Then CountriesControl = New CountriesEditor
            LoadSection(CountriesControl)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnSurveyQuestions Then
            If QuestionsbySurveyControl Is Nothing Then QuestionsbySurveyControl = New QuestionsbySurvey
            LoadSection(QuestionsbySurveyControl)
        ElseIf SelectedButton = Administration.AdministrationButtons.btnChangeCountry Then
            If ChangeSurveyCountryControl Is Nothing Then ChangeSurveyCountryControl = New ChangeSurveyCountry
            LoadSection(ChangeSurveyCountryControl)
        End If
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

    Private Sub mnuOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuOpen.Click
        Try
            Dim queryList As ComparisonDataQueryLightCollection = ComparisonDataQueryLightCollection.GetAvailableQueries(CurrentUser.Member.MemberId, reportType)
            If queryList.Count > 0 Then
                Dim openQuery As New OpenSavedQuery(queryList)
                openQuery.ShowDialog()
                If openQuery.DialogResult = DialogResult.OK Then
                    Dim activeControl As ctlBaseComparisonControl
                    activeControl = pnlRight.Controls.Item(0)
                    activeControl.ActiveQuery = openQuery.SelectedQuery
                End If
            Else
                MessageBox.Show("There are no saved Queries for this report type", "No Queries Available", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            ReportException(ex, "Error Getting Queries List")
        End Try
    End Sub
End Class
