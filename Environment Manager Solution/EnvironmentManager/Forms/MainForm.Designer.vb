<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Dim GridLevelNode1 As DevExpress.XtraGrid.GridLevelNode = New DevExpress.XtraGrid.GridLevelNode
        Me.NotifyIcon1 = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.cmsEnvironments = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DevelopmentToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.TestingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StagingToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ProductionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ShowToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ResetToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.TabInfo = New System.Windows.Forms.TabPage
        Me.Label4 = New System.Windows.Forms.Label
        Me.TabEnvEditor = New System.Windows.Forms.TabPage
        Me.btnBuildNrcAuthConnection = New DevExpress.XtraEditors.SimpleButton
        Me.btnEditXML = New DevExpress.XtraEditors.SimpleButton
        Me.btnBuildQualisysConnection = New DevExpress.XtraEditors.SimpleButton
        Me.btnSave = New DevExpress.XtraEditors.SimpleButton
        Me.ToolTipController1 = New DevExpress.Utils.ToolTipController(Me.components)
        Me.chkSaveAsDefault = New System.Windows.Forms.CheckBox
        Me.btnReset = New System.Windows.Forms.Button
        Me.cboCurrentEnvironment = New System.Windows.Forms.ComboBox
        Me.btnNew = New System.Windows.Forms.Button
        Me.txtSQLTimeOut = New System.Windows.Forms.TextBox
        Me.txtSMTPServer = New System.Windows.Forms.TextBox
        Me.txtConnectionString = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.lblEnvironment = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.TabControlEnvManager = New System.Windows.Forms.TabControl
        Me.TabParams = New System.Windows.Forms.TabPage
        Me.ParamsGridControl = New DevExpress.XtraGrid.GridControl
        Me.bsSettingsRow = New System.Windows.Forms.BindingSource(Me.components)
        Me.ParamGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colParamId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colParamName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colParam_Type = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemComboBox1 = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.colParamGroup = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colstrParamValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumParamValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDatParamValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colComments = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ParamsBindingNavigator = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.BindingNavigatorAddNewItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorCountItem = New System.Windows.Forms.ToolStripLabel
        Me.BindingNavigatorDeleteItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorMoveFirstItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorMovePreviousItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorSeparator = New System.Windows.Forms.ToolStripSeparator
        Me.BindingNavigatorPositionItem = New System.Windows.Forms.ToolStripTextBox
        Me.BindingNavigatorSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.BindingNavigatorMoveNextItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorMoveLastItem = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ExportButton = New System.Windows.Forms.ToolStripButton
        Me.SaveToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.toolStripSeparator = New System.Windows.Forms.ToolStripSeparator
        Me.SaveAllToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.RefreshToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ExportToSQLToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.EnvironmentToolStripComboBox = New System.Windows.Forms.ToolStripComboBox
        Me.TabAdministration = New System.Windows.Forms.TabPage
        Me.bnAdmins = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.BindingNavigatorAddNewAdmin = New System.Windows.Forms.ToolStripButton
        Me.bsAdmins = New System.Windows.Forms.BindingSource(Me.components)
        Me.BindingNavigatorDeleteAdmin = New System.Windows.Forms.ToolStripButton
        Me.SaveAdminsToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.toolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.HelpToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.grdAdminUsers = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.txtNrcAuthConnectionString = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.BindingNavigatorMoveFirstItem1 = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorMovePreviousItem1 = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.BindingNavigatorPositionItem1 = New System.Windows.Forms.ToolStripTextBox
        Me.BindingNavigatorCountItem1 = New System.Windows.Forms.ToolStripLabel
        Me.BindingNavigatorSeparator4 = New System.Windows.Forms.ToolStripSeparator
        Me.BindingNavigatorMoveNextItem1 = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorMoveLastItem1 = New System.Windows.Forms.ToolStripButton
        Me.BindingNavigatorSeparator5 = New System.Windows.Forms.ToolStripSeparator
        Me.BindingNavigatorDeleteItem1 = New System.Windows.Forms.ToolStripButton
        Me.bsEnvironments = New System.Windows.Forms.BindingSource(Me.components)
        Me.cmsEnvironments.SuspendLayout()
        Me.TabInfo.SuspendLayout()
        Me.TabEnvEditor.SuspendLayout()
        Me.TabControlEnvManager.SuspendLayout()
        Me.TabParams.SuspendLayout()
        CType(Me.ParamsGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsSettingsRow, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ParamGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemComboBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ParamsBindingNavigator, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ParamsBindingNavigator.SuspendLayout()
        Me.TabAdministration.SuspendLayout()
        CType(Me.bnAdmins, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.bnAdmins.SuspendLayout()
        CType(Me.bsAdmins, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdAdminUsers, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsEnvironments, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'NotifyIcon1
        '
        Me.NotifyIcon1.ContextMenuStrip = Me.cmsEnvironments
        Me.NotifyIcon1.Icon = CType(resources.GetObject("NotifyIcon1.Icon"), System.Drawing.Icon)
        Me.NotifyIcon1.Text = "NotifyIcon1"
        Me.NotifyIcon1.Visible = True
        '
        'cmsEnvironments
        '
        Me.cmsEnvironments.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DevelopmentToolStripMenuItem, Me.TestingToolStripMenuItem, Me.StagingToolStripMenuItem, Me.ProductionToolStripMenuItem, Me.ShowToolStripMenuItem, Me.ResetToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.cmsEnvironments.Name = "cmsEnvironments"
        Me.cmsEnvironments.Size = New System.Drawing.Size(154, 158)
        Me.ToolTipController1.SetSuperTip(Me.cmsEnvironments, Nothing)
        '
        'DevelopmentToolStripMenuItem
        '
        Me.DevelopmentToolStripMenuItem.Name = "DevelopmentToolStripMenuItem"
        Me.DevelopmentToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.DevelopmentToolStripMenuItem.Text = "&Development"
        Me.DevelopmentToolStripMenuItem.ToolTipText = "Switch to Development Environment"
        '
        'TestingToolStripMenuItem
        '
        Me.TestingToolStripMenuItem.CheckOnClick = True
        Me.TestingToolStripMenuItem.Name = "TestingToolStripMenuItem"
        Me.TestingToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.TestingToolStripMenuItem.Text = "&Testing"
        '
        'StagingToolStripMenuItem
        '
        Me.StagingToolStripMenuItem.CheckOnClick = True
        Me.StagingToolStripMenuItem.Name = "StagingToolStripMenuItem"
        Me.StagingToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.StagingToolStripMenuItem.Text = "&Staging"
        '
        'ProductionToolStripMenuItem
        '
        Me.ProductionToolStripMenuItem.CheckOnClick = True
        Me.ProductionToolStripMenuItem.Name = "ProductionToolStripMenuItem"
        Me.ProductionToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.ProductionToolStripMenuItem.Text = "&Production"
        '
        'ShowToolStripMenuItem
        '
        Me.ShowToolStripMenuItem.Name = "ShowToolStripMenuItem"
        Me.ShowToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.ShowToolStripMenuItem.Text = "S&how..."
        '
        'ResetToolStripMenuItem
        '
        Me.ResetToolStripMenuItem.Name = "ResetToolStripMenuItem"
        Me.ResetToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.ResetToolStripMenuItem.Text = "&Reset to Default"
        Me.ResetToolStripMenuItem.Visible = False
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.ExitToolStripMenuItem.Text = "E&xit"
        '
        'TabInfo
        '
        Me.TabInfo.Controls.Add(Me.Label4)
        Me.TabInfo.Location = New System.Drawing.Point(4, 22)
        Me.TabInfo.Name = "TabInfo"
        Me.TabInfo.Padding = New System.Windows.Forms.Padding(3)
        Me.TabInfo.Size = New System.Drawing.Size(896, 567)
        Me.ToolTipController1.SetSuperTip(Me.TabInfo, Nothing)
        Me.TabInfo.TabIndex = 1
        Me.TabInfo.Text = "Info"
        Me.TabInfo.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(19, 21)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(640, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label4, Nothing)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "The connection string on Environment Editor tab always displays plain text (decry" & _
            "pted) and saves the encrypted version to the registry ."
        '
        'TabEnvEditor
        '
        Me.TabEnvEditor.Controls.Add(Me.btnBuildNrcAuthConnection)
        Me.TabEnvEditor.Controls.Add(Me.btnEditXML)
        Me.TabEnvEditor.Controls.Add(Me.btnBuildQualisysConnection)
        Me.TabEnvEditor.Controls.Add(Me.btnSave)
        Me.TabEnvEditor.Controls.Add(Me.chkSaveAsDefault)
        Me.TabEnvEditor.Controls.Add(Me.btnReset)
        Me.TabEnvEditor.Controls.Add(Me.cboCurrentEnvironment)
        Me.TabEnvEditor.Controls.Add(Me.btnNew)
        Me.TabEnvEditor.Controls.Add(Me.txtSQLTimeOut)
        Me.TabEnvEditor.Controls.Add(Me.txtSMTPServer)
        Me.TabEnvEditor.Controls.Add(Me.txtNrcAuthConnectionString)
        Me.TabEnvEditor.Controls.Add(Me.txtConnectionString)
        Me.TabEnvEditor.Controls.Add(Me.Label3)
        Me.TabEnvEditor.Controls.Add(Me.Label2)
        Me.TabEnvEditor.Controls.Add(Me.Label6)
        Me.TabEnvEditor.Controls.Add(Me.lblEnvironment)
        Me.TabEnvEditor.Controls.Add(Me.Label5)
        Me.TabEnvEditor.Controls.Add(Me.Label1)
        Me.TabEnvEditor.Location = New System.Drawing.Point(4, 22)
        Me.TabEnvEditor.Name = "TabEnvEditor"
        Me.TabEnvEditor.Padding = New System.Windows.Forms.Padding(3)
        Me.TabEnvEditor.Size = New System.Drawing.Size(896, 567)
        Me.ToolTipController1.SetSuperTip(Me.TabEnvEditor, Nothing)
        Me.TabEnvEditor.TabIndex = 0
        Me.TabEnvEditor.Text = "Environment Editor"
        Me.TabEnvEditor.ToolTipText = "Deletes from xml file"
        Me.TabEnvEditor.UseVisualStyleBackColor = True
        '
        'btnBuildNrcAuthConnection
        '
        Me.btnBuildNrcAuthConnection.Location = New System.Drawing.Point(633, 254)
        Me.btnBuildNrcAuthConnection.Name = "btnBuildNrcAuthConnection"
        Me.btnBuildNrcAuthConnection.Size = New System.Drawing.Size(119, 23)
        Me.btnBuildNrcAuthConnection.TabIndex = 9
        Me.btnBuildNrcAuthConnection.Text = "Build Connection..."
        Me.btnBuildNrcAuthConnection.ToolTip = "Opens a connection string builder form"
        '
        'btnEditXML
        '
        Me.btnEditXML.Location = New System.Drawing.Point(633, 40)
        Me.btnEditXML.Name = "btnEditXML"
        Me.btnEditXML.Size = New System.Drawing.Size(119, 23)
        Me.btnEditXML.TabIndex = 9
        Me.btnEditXML.Text = "Edit XML"
        Me.btnEditXML.ToolTip = "Opens a new window to edit the XML file"
        '
        'btnBuildQualisysConnection
        '
        Me.btnBuildQualisysConnection.Location = New System.Drawing.Point(633, 146)
        Me.btnBuildQualisysConnection.Name = "btnBuildQualisysConnection"
        Me.btnBuildQualisysConnection.Size = New System.Drawing.Size(119, 23)
        Me.btnBuildQualisysConnection.TabIndex = 9
        Me.btnBuildQualisysConnection.Text = "Build Connection..."
        Me.btnBuildQualisysConnection.ToolTip = "Opens a connection string builder form"
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(633, 335)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(119, 23)
        Me.btnSave.TabIndex = 9
        Me.btnSave.Text = "Save to Regisrty"
        Me.btnSave.ToolTip = "Saves to the Registry. The changes will be overrwritten next time the program loa" & _
            "ds the settings from the xml file."
        Me.btnSave.ToolTipController = Me.ToolTipController1
        '
        'ToolTipController1
        '
        Me.ToolTipController1.Appearance.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(192, Byte), Integer))
        Me.ToolTipController1.Appearance.Options.UseBackColor = True
        Me.ToolTipController1.Rounded = True
        Me.ToolTipController1.RoundRadius = 12
        Me.ToolTipController1.ToolTipType = DevExpress.Utils.ToolTipType.SuperTip
        '
        'chkSaveAsDefault
        '
        Me.chkSaveAsDefault.AutoSize = True
        Me.chkSaveAsDefault.Location = New System.Drawing.Point(588, 312)
        Me.chkSaveAsDefault.Name = "chkSaveAsDefault"
        Me.chkSaveAsDefault.Size = New System.Drawing.Size(164, 17)
        Me.ToolTipController1.SetSuperTip(Me.chkSaveAsDefault, Nothing)
        Me.chkSaveAsDefault.TabIndex = 8
        Me.chkSaveAsDefault.Text = "Save as Environment Default"
        Me.chkSaveAsDefault.UseVisualStyleBackColor = True
        '
        'btnReset
        '
        Me.btnReset.Location = New System.Drawing.Point(460, 335)
        Me.btnReset.Name = "btnReset"
        Me.btnReset.Size = New System.Drawing.Size(113, 23)
        Me.ToolTipController1.SetSuperTip(Me.btnReset, Nothing)
        Me.btnReset.TabIndex = 7
        Me.btnReset.Text = "Restore Defaults"
        Me.btnReset.UseVisualStyleBackColor = True
        '
        'cboCurrentEnvironment
        '
        Me.cboCurrentEnvironment.FormattingEnabled = True
        Me.cboCurrentEnvironment.Items.AddRange(New Object() {"Testing", "Staging", "Production", "Development", "Unknown"})
        Me.cboCurrentEnvironment.Location = New System.Drawing.Point(149, 40)
        Me.cboCurrentEnvironment.Name = "cboCurrentEnvironment"
        Me.cboCurrentEnvironment.Size = New System.Drawing.Size(285, 21)
        Me.ToolTipController1.SetSuperTip(Me.cboCurrentEnvironment, Nothing)
        Me.cboCurrentEnvironment.TabIndex = 6
        '
        'btnNew
        '
        Me.btnNew.Location = New System.Drawing.Point(454, 40)
        Me.btnNew.Name = "btnNew"
        Me.btnNew.Size = New System.Drawing.Size(119, 23)
        Me.ToolTipController1.SetSuperTip(Me.btnNew, Nothing)
        Me.btnNew.TabIndex = 4
        Me.btnNew.Text = "Save  As &New..."
        Me.btnNew.UseVisualStyleBackColor = True
        '
        'txtSQLTimeOut
        '
        Me.txtSQLTimeOut.Location = New System.Drawing.Point(149, 333)
        Me.txtSQLTimeOut.Name = "txtSQLTimeOut"
        Me.txtSQLTimeOut.Size = New System.Drawing.Size(75, 20)
        Me.ToolTipController1.SetSuperTip(Me.txtSQLTimeOut, Nothing)
        Me.txtSQLTimeOut.TabIndex = 2
        '
        'txtSMTPServer
        '
        Me.txtSMTPServer.Location = New System.Drawing.Point(149, 287)
        Me.txtSMTPServer.Name = "txtSMTPServer"
        Me.txtSMTPServer.Size = New System.Drawing.Size(285, 20)
        Me.ToolTipController1.SetSuperTip(Me.txtSMTPServer, Nothing)
        Me.txtSMTPServer.TabIndex = 2
        '
        'txtConnectionString
        '
        Me.txtConnectionString.Location = New System.Drawing.Point(149, 83)
        Me.txtConnectionString.Multiline = True
        Me.txtConnectionString.Name = "txtConnectionString"
        Me.txtConnectionString.Size = New System.Drawing.Size(603, 57)
        Me.ToolTipController1.SetSuperTip(Me.txtConnectionString, Nothing)
        Me.txtConnectionString.TabIndex = 0
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(27, 340)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(69, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label3, Nothing)
        Me.Label3.TabIndex = 1
        Me.Label3.Text = "SQL Timeout"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(27, 295)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(71, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label2, Nothing)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "SMTP Server"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(146, 24)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(442, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label6, Nothing)
        Me.Label6.TabIndex = 1
        Me.Label6.Text = "Selecting a different value will change the registry values to the selected envir" & _
            "onment values"
        '
        'lblEnvironment
        '
        Me.lblEnvironment.AutoSize = True
        Me.lblEnvironment.Location = New System.Drawing.Point(27, 43)
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Size = New System.Drawing.Size(103, 13)
        Me.ToolTipController1.SetSuperTip(Me.lblEnvironment, Nothing)
        Me.lblEnvironment.TabIndex = 1
        Me.lblEnvironment.Text = "Current Environment"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(27, 86)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(103, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label1, Nothing)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Qualisys Connection"
        '
        'TabControlEnvManager
        '
        Me.TabControlEnvManager.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TabControlEnvManager.Controls.Add(Me.TabParams)
        Me.TabControlEnvManager.Controls.Add(Me.TabEnvEditor)
        Me.TabControlEnvManager.Controls.Add(Me.TabAdministration)
        Me.TabControlEnvManager.Controls.Add(Me.TabInfo)
        Me.TabControlEnvManager.Location = New System.Drawing.Point(13, 5)
        Me.TabControlEnvManager.Name = "TabControlEnvManager"
        Me.TabControlEnvManager.SelectedIndex = 0
        Me.TabControlEnvManager.Size = New System.Drawing.Size(904, 593)
        Me.ToolTipController1.SetSuperTip(Me.TabControlEnvManager, Nothing)
        Me.TabControlEnvManager.TabIndex = 2
        '
        'TabParams
        '
        Me.TabParams.Controls.Add(Me.ParamsGridControl)
        Me.TabParams.Controls.Add(Me.ParamsBindingNavigator)
        Me.TabParams.Location = New System.Drawing.Point(4, 22)
        Me.TabParams.Name = "TabParams"
        Me.TabParams.Padding = New System.Windows.Forms.Padding(3)
        Me.TabParams.Size = New System.Drawing.Size(896, 567)
        Me.ToolTipController1.SetSuperTip(Me.TabParams, Nothing)
        Me.TabParams.TabIndex = 2
        Me.TabParams.Text = "NRC Settings"
        Me.TabParams.ToolTipText = "QUALPRO_PARAMS"
        Me.TabParams.UseVisualStyleBackColor = True
        '
        'ParamsGridControl
        '
        Me.ParamsGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ParamsGridControl.DataSource = Me.bsSettingsRow
        Me.ParamsGridControl.EmbeddedNavigator.Name = ""
        GridLevelNode1.RelationName = "Level1"
        Me.ParamsGridControl.LevelTree.Nodes.AddRange(New DevExpress.XtraGrid.GridLevelNode() {GridLevelNode1})
        Me.ParamsGridControl.Location = New System.Drawing.Point(6, 31)
        Me.ParamsGridControl.MainView = Me.ParamGridView
        Me.ParamsGridControl.Name = "ParamsGridControl"
        Me.ParamsGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemComboBox1})
        Me.ParamsGridControl.Size = New System.Drawing.Size(884, 530)
        Me.ParamsGridControl.TabIndex = 4
        Me.ParamsGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.ParamGridView})
        '
        'bsSettingsRow
        '
        Me.bsSettingsRow.AllowNew = True
        Me.bsSettingsRow.DataSource = GetType(EnvironmentManager.library.QualproParams)
        '
        'ParamGridView
        '
        Me.ParamGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colParamId, Me.colParamName, Me.colParam_Type, Me.colParamGroup, Me.colstrParamValue, Me.colNumParamValue, Me.colDatParamValue, Me.colComments})
        Me.ParamGridView.GridControl = Me.ParamsGridControl
        Me.ParamGridView.Name = "ParamGridView"
        Me.ParamGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colParamId
        '
        Me.colParamId.Caption = "ParamId"
        Me.colParamId.FieldName = "PARAM_ID"
        Me.colParamId.Name = "colParamId"
        Me.colParamId.OptionsColumn.AllowEdit = False
        Me.colParamId.OptionsColumn.AllowFocus = False
        Me.colParamId.OptionsColumn.ReadOnly = True
        Me.colParamId.Visible = True
        Me.colParamId.VisibleIndex = 0
        '
        'colParamName
        '
        Me.colParamName.Caption = "ParamName"
        Me.colParamName.FieldName = "STRPARAM_NM"
        Me.colParamName.Name = "colParamName"
        Me.colParamName.Visible = True
        Me.colParamName.VisibleIndex = 1
        '
        'colParam_Type
        '
        Me.colParam_Type.Caption = "Param_Type"
        Me.colParam_Type.ColumnEdit = Me.RepositoryItemComboBox1
        Me.colParam_Type.FieldName = "STRPARAM_TYPE"
        Me.colParam_Type.Name = "colParam_Type"
        Me.colParam_Type.Visible = True
        Me.colParam_Type.VisibleIndex = 2
        '
        'RepositoryItemComboBox1
        '
        Me.RepositoryItemComboBox1.AutoHeight = False
        Me.RepositoryItemComboBox1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemComboBox1.Items.AddRange(New Object() {"S", "N", "D"})
        Me.RepositoryItemComboBox1.Name = "RepositoryItemComboBox1"
        '
        'colParamGroup
        '
        Me.colParamGroup.Caption = "ParamGroup"
        Me.colParamGroup.FieldName = "STRPARAM_GRP"
        Me.colParamGroup.Name = "colParamGroup"
        Me.colParamGroup.Visible = True
        Me.colParamGroup.VisibleIndex = 3
        '
        'colstrParamValue
        '
        Me.colstrParamValue.Caption = "strParamValue"
        Me.colstrParamValue.FieldName = "STRPARAM_VALUE"
        Me.colstrParamValue.Name = "colstrParamValue"
        Me.colstrParamValue.Visible = True
        Me.colstrParamValue.VisibleIndex = 4
        '
        'colNumParamValue
        '
        Me.colNumParamValue.Caption = "NumParamValue"
        Me.colNumParamValue.FieldName = "NUMPARAM_VALUE"
        Me.colNumParamValue.Name = "colNumParamValue"
        Me.colNumParamValue.Visible = True
        Me.colNumParamValue.VisibleIndex = 5
        '
        'colDatParamValue
        '
        Me.colDatParamValue.Caption = "DatParamValue"
        Me.colDatParamValue.FieldName = "DATPARAM_VALUE"
        Me.colDatParamValue.Name = "colDatParamValue"
        Me.colDatParamValue.Visible = True
        Me.colDatParamValue.VisibleIndex = 6
        '
        'colComments
        '
        Me.colComments.Caption = "Comments"
        Me.colComments.FieldName = "COMMENTS"
        Me.colComments.Name = "colComments"
        Me.colComments.Visible = True
        Me.colComments.VisibleIndex = 7
        '
        'ParamsBindingNavigator
        '
        Me.ParamsBindingNavigator.AddNewItem = Me.BindingNavigatorAddNewItem
        Me.ParamsBindingNavigator.BindingSource = Me.bsSettingsRow
        Me.ParamsBindingNavigator.CountItem = Me.BindingNavigatorCountItem
        Me.ParamsBindingNavigator.DeleteItem = Nothing
        Me.ParamsBindingNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BindingNavigatorMoveFirstItem, Me.BindingNavigatorMovePreviousItem, Me.BindingNavigatorSeparator, Me.BindingNavigatorPositionItem, Me.BindingNavigatorCountItem, Me.BindingNavigatorSeparator1, Me.BindingNavigatorMoveNextItem, Me.BindingNavigatorMoveLastItem, Me.BindingNavigatorSeparator2, Me.BindingNavigatorAddNewItem, Me.BindingNavigatorDeleteItem, Me.ExportButton, Me.SaveToolStripButton, Me.toolStripSeparator, Me.SaveAllToolStripButton, Me.RefreshToolStripButton, Me.ExportToSQLToolStripButton, Me.EnvironmentToolStripComboBox})
        Me.ParamsBindingNavigator.Location = New System.Drawing.Point(3, 3)
        Me.ParamsBindingNavigator.MoveFirstItem = Me.BindingNavigatorMoveFirstItem
        Me.ParamsBindingNavigator.MoveLastItem = Me.BindingNavigatorMoveLastItem
        Me.ParamsBindingNavigator.MoveNextItem = Me.BindingNavigatorMoveNextItem
        Me.ParamsBindingNavigator.MovePreviousItem = Me.BindingNavigatorMovePreviousItem
        Me.ParamsBindingNavigator.Name = "ParamsBindingNavigator"
        Me.ParamsBindingNavigator.PositionItem = Me.BindingNavigatorPositionItem
        Me.ParamsBindingNavigator.Size = New System.Drawing.Size(890, 25)
        Me.ToolTipController1.SetSuperTip(Me.ParamsBindingNavigator, Nothing)
        Me.ParamsBindingNavigator.TabIndex = 8
        Me.ParamsBindingNavigator.Text = "BindingNavigator1"
        '
        'BindingNavigatorAddNewItem
        '
        Me.BindingNavigatorAddNewItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorAddNewItem.Image = CType(resources.GetObject("BindingNavigatorAddNewItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorAddNewItem.Name = "BindingNavigatorAddNewItem"
        Me.BindingNavigatorAddNewItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorAddNewItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorAddNewItem.Text = "Add new"
        '
        'BindingNavigatorCountItem
        '
        Me.BindingNavigatorCountItem.Name = "BindingNavigatorCountItem"
        Me.BindingNavigatorCountItem.Size = New System.Drawing.Size(36, 22)
        Me.BindingNavigatorCountItem.Text = "of {0}"
        Me.BindingNavigatorCountItem.ToolTipText = "Total number of items"
        '
        'BindingNavigatorDeleteItem
        '
        Me.BindingNavigatorDeleteItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorDeleteItem.Image = CType(resources.GetObject("BindingNavigatorDeleteItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorDeleteItem.Name = "BindingNavigatorDeleteItem"
        Me.BindingNavigatorDeleteItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorDeleteItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorDeleteItem.Text = "Delete"
        '
        'BindingNavigatorMoveFirstItem
        '
        Me.BindingNavigatorMoveFirstItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveFirstItem.Image = CType(resources.GetObject("BindingNavigatorMoveFirstItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveFirstItem.Name = "BindingNavigatorMoveFirstItem"
        Me.BindingNavigatorMoveFirstItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveFirstItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveFirstItem.Text = "Move first"
        '
        'BindingNavigatorMovePreviousItem
        '
        Me.BindingNavigatorMovePreviousItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMovePreviousItem.Image = CType(resources.GetObject("BindingNavigatorMovePreviousItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorMovePreviousItem.Name = "BindingNavigatorMovePreviousItem"
        Me.BindingNavigatorMovePreviousItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMovePreviousItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMovePreviousItem.Text = "Move previous"
        '
        'BindingNavigatorSeparator
        '
        Me.BindingNavigatorSeparator.Name = "BindingNavigatorSeparator"
        Me.BindingNavigatorSeparator.Size = New System.Drawing.Size(6, 25)
        '
        'BindingNavigatorPositionItem
        '
        Me.BindingNavigatorPositionItem.AccessibleName = "Position"
        Me.BindingNavigatorPositionItem.AutoSize = False
        Me.BindingNavigatorPositionItem.Name = "BindingNavigatorPositionItem"
        Me.BindingNavigatorPositionItem.Size = New System.Drawing.Size(50, 21)
        Me.BindingNavigatorPositionItem.Text = "0"
        Me.BindingNavigatorPositionItem.ToolTipText = "Current position"
        '
        'BindingNavigatorSeparator1
        '
        Me.BindingNavigatorSeparator1.Name = "BindingNavigatorSeparator1"
        Me.BindingNavigatorSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'BindingNavigatorMoveNextItem
        '
        Me.BindingNavigatorMoveNextItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveNextItem.Image = CType(resources.GetObject("BindingNavigatorMoveNextItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveNextItem.Name = "BindingNavigatorMoveNextItem"
        Me.BindingNavigatorMoveNextItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveNextItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveNextItem.Text = "Move next"
        '
        'BindingNavigatorMoveLastItem
        '
        Me.BindingNavigatorMoveLastItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveLastItem.Image = CType(resources.GetObject("BindingNavigatorMoveLastItem.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveLastItem.Name = "BindingNavigatorMoveLastItem"
        Me.BindingNavigatorMoveLastItem.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveLastItem.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveLastItem.Text = "Move last"
        '
        'BindingNavigatorSeparator2
        '
        Me.BindingNavigatorSeparator2.Name = "BindingNavigatorSeparator2"
        Me.BindingNavigatorSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'ExportButton
        '
        Me.ExportButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ExportButton.Image = Global.EnvironmentManager.My.Resources.Resources.Excel16
        Me.ExportButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(23, 22)
        Me.ExportButton.Text = "E&xport To Excell"
        Me.ExportButton.ToolTipText = "Export to Excell"
        '
        'SaveToolStripButton
        '
        Me.SaveToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SaveToolStripButton.Image = CType(resources.GetObject("SaveToolStripButton.Image"), System.Drawing.Image)
        Me.SaveToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SaveToolStripButton.Name = "SaveToolStripButton"
        Me.SaveToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.SaveToolStripButton.Text = "&Save"
        '
        'toolStripSeparator
        '
        Me.toolStripSeparator.Name = "toolStripSeparator"
        Me.toolStripSeparator.Size = New System.Drawing.Size(6, 25)
        '
        'SaveAllToolStripButton
        '
        Me.SaveAllToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SaveAllToolStripButton.Image = CType(resources.GetObject("SaveAllToolStripButton.Image"), System.Drawing.Image)
        Me.SaveAllToolStripButton.ImageTransparentColor = System.Drawing.Color.Black
        Me.SaveAllToolStripButton.Name = "SaveAllToolStripButton"
        Me.SaveAllToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.SaveAllToolStripButton.Text = "Save &All"
        '
        'RefreshToolStripButton
        '
        Me.RefreshToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.RefreshToolStripButton.Image = CType(resources.GetObject("RefreshToolStripButton.Image"), System.Drawing.Image)
        Me.RefreshToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RefreshToolStripButton.Name = "RefreshToolStripButton"
        Me.RefreshToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.RefreshToolStripButton.Text = "&Refresh"
        Me.RefreshToolStripButton.ToolTipText = "Gets all settings from QualPro_Params"
        '
        'ExportToSQLToolStripButton
        '
        Me.ExportToSQLToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ExportToSQLToolStripButton.Image = Global.EnvironmentManager.My.Resources.Resources.Webcontrol_Sqldatasrc
        Me.ExportToSQLToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportToSQLToolStripButton.Name = "ExportToSQLToolStripButton"
        Me.ExportToSQLToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.ExportToSQLToolStripButton.Text = "Export to SQL"
        '
        'EnvironmentToolStripComboBox
        '
        Me.EnvironmentToolStripComboBox.Items.AddRange(New Object() {"Testing", "Staging", "Production", "Development", "Unknown"})
        Me.EnvironmentToolStripComboBox.Name = "EnvironmentToolStripComboBox"
        Me.EnvironmentToolStripComboBox.Size = New System.Drawing.Size(121, 25)
        Me.EnvironmentToolStripComboBox.ToolTipText = "NRC Environment"
        '
        'TabAdministration
        '
        Me.TabAdministration.Controls.Add(Me.bnAdmins)
        Me.TabAdministration.Controls.Add(Me.grdAdminUsers)
        Me.TabAdministration.Location = New System.Drawing.Point(4, 22)
        Me.TabAdministration.Name = "TabAdministration"
        Me.TabAdministration.Size = New System.Drawing.Size(896, 567)
        Me.ToolTipController1.SetSuperTip(Me.TabAdministration, Nothing)
        Me.TabAdministration.TabIndex = 3
        Me.TabAdministration.Text = "Administration"
        Me.TabAdministration.UseVisualStyleBackColor = True
        '
        'bnAdmins
        '
        Me.bnAdmins.AddNewItem = Me.BindingNavigatorAddNewAdmin
        Me.bnAdmins.BindingSource = Me.bsAdmins
        Me.bnAdmins.CountItem = Nothing
        Me.bnAdmins.DeleteItem = Me.BindingNavigatorDeleteAdmin
        Me.bnAdmins.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BindingNavigatorAddNewAdmin, Me.BindingNavigatorDeleteAdmin, Me.SaveAdminsToolStripButton, Me.toolStripSeparator1, Me.HelpToolStripButton})
        Me.bnAdmins.Location = New System.Drawing.Point(0, 0)
        Me.bnAdmins.MoveFirstItem = Nothing
        Me.bnAdmins.MoveLastItem = Nothing
        Me.bnAdmins.MoveNextItem = Nothing
        Me.bnAdmins.MovePreviousItem = Nothing
        Me.bnAdmins.Name = "bnAdmins"
        Me.bnAdmins.PositionItem = Nothing
        Me.bnAdmins.Size = New System.Drawing.Size(896, 25)
        Me.ToolTipController1.SetSuperTip(Me.bnAdmins, Nothing)
        Me.bnAdmins.TabIndex = 1
        Me.bnAdmins.Text = "BindingNavigator1"
        '
        'BindingNavigatorAddNewAdmin
        '
        Me.BindingNavigatorAddNewAdmin.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorAddNewAdmin.Image = CType(resources.GetObject("BindingNavigatorAddNewAdmin.Image"), System.Drawing.Image)
        Me.BindingNavigatorAddNewAdmin.Name = "BindingNavigatorAddNewAdmin"
        Me.BindingNavigatorAddNewAdmin.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorAddNewAdmin.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorAddNewAdmin.Text = "Add new"
        '
        'BindingNavigatorDeleteAdmin
        '
        Me.BindingNavigatorDeleteAdmin.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorDeleteAdmin.Image = CType(resources.GetObject("BindingNavigatorDeleteAdmin.Image"), System.Drawing.Image)
        Me.BindingNavigatorDeleteAdmin.Name = "BindingNavigatorDeleteAdmin"
        Me.BindingNavigatorDeleteAdmin.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorDeleteAdmin.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorDeleteAdmin.Text = "Delete"
        '
        'SaveAdminsToolStripButton
        '
        Me.SaveAdminsToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SaveAdminsToolStripButton.Image = CType(resources.GetObject("SaveAdminsToolStripButton.Image"), System.Drawing.Image)
        Me.SaveAdminsToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SaveAdminsToolStripButton.Name = "SaveAdminsToolStripButton"
        Me.SaveAdminsToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.SaveAdminsToolStripButton.Text = "&Save"
        '
        'toolStripSeparator1
        '
        Me.toolStripSeparator1.Name = "toolStripSeparator1"
        Me.toolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'HelpToolStripButton
        '
        Me.HelpToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.HelpToolStripButton.Image = CType(resources.GetObject("HelpToolStripButton.Image"), System.Drawing.Image)
        Me.HelpToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.HelpToolStripButton.Name = "HelpToolStripButton"
        Me.HelpToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.HelpToolStripButton.Text = "He&lp"
        '
        'grdAdminUsers
        '
        Me.grdAdminUsers.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdAdminUsers.EmbeddedNavigator.Name = ""
        Me.grdAdminUsers.Location = New System.Drawing.Point(0, 28)
        Me.grdAdminUsers.MainView = Me.GridView1
        Me.grdAdminUsers.Name = "grdAdminUsers"
        Me.grdAdminUsers.Size = New System.Drawing.Size(896, 536)
        Me.grdAdminUsers.TabIndex = 0
        Me.grdAdminUsers.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Appearance.TopNewRow.BackColor = System.Drawing.Color.Honeydew
        Me.GridView1.Appearance.TopNewRow.Options.UseBackColor = True
        Me.GridView1.GridControl = Me.grdAdminUsers
        Me.GridView1.Name = "GridView1"
        Me.GridView1.NewItemRowText = "Click here to add a new user"
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'txtNrcAuthConnectionString
        '
        Me.txtNrcAuthConnectionString.Location = New System.Drawing.Point(149, 182)
        Me.txtNrcAuthConnectionString.Multiline = True
        Me.txtNrcAuthConnectionString.Name = "txtNrcAuthConnectionString"
        Me.txtNrcAuthConnectionString.Size = New System.Drawing.Size(603, 59)
        Me.ToolTipController1.SetSuperTip(Me.txtNrcAuthConnectionString, Nothing)
        Me.txtNrcAuthConnectionString.TabIndex = 0
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(27, 182)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(109, 13)
        Me.ToolTipController1.SetSuperTip(Me.Label5, Nothing)
        Me.Label5.TabIndex = 1
        Me.Label5.Text = "NRCAuth Connection"
        '
        'BindingNavigatorMoveFirstItem1
        '
        Me.BindingNavigatorMoveFirstItem1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveFirstItem1.Image = CType(resources.GetObject("BindingNavigatorMoveFirstItem1.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveFirstItem1.Name = "BindingNavigatorMoveFirstItem1"
        Me.BindingNavigatorMoveFirstItem1.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveFirstItem1.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveFirstItem1.Text = "Move first"
        '
        'BindingNavigatorMovePreviousItem1
        '
        Me.BindingNavigatorMovePreviousItem1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMovePreviousItem1.Image = CType(resources.GetObject("BindingNavigatorMovePreviousItem1.Image"), System.Drawing.Image)
        Me.BindingNavigatorMovePreviousItem1.Name = "BindingNavigatorMovePreviousItem1"
        Me.BindingNavigatorMovePreviousItem1.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMovePreviousItem1.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMovePreviousItem1.Text = "Move previous"
        '
        'BindingNavigatorSeparator3
        '
        Me.BindingNavigatorSeparator3.Name = "BindingNavigatorSeparator3"
        Me.BindingNavigatorSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'BindingNavigatorPositionItem1
        '
        Me.BindingNavigatorPositionItem1.AccessibleName = "Position"
        Me.BindingNavigatorPositionItem1.AutoSize = False
        Me.BindingNavigatorPositionItem1.Name = "BindingNavigatorPositionItem1"
        Me.BindingNavigatorPositionItem1.Size = New System.Drawing.Size(50, 21)
        Me.BindingNavigatorPositionItem1.Text = "0"
        Me.BindingNavigatorPositionItem1.ToolTipText = "Current position"
        '
        'BindingNavigatorCountItem1
        '
        Me.BindingNavigatorCountItem1.Name = "BindingNavigatorCountItem1"
        Me.BindingNavigatorCountItem1.Size = New System.Drawing.Size(36, 22)
        Me.BindingNavigatorCountItem1.Text = "of {0}"
        Me.BindingNavigatorCountItem1.ToolTipText = "Total number of items"
        '
        'BindingNavigatorSeparator4
        '
        Me.BindingNavigatorSeparator4.Name = "BindingNavigatorSeparator4"
        Me.BindingNavigatorSeparator4.Size = New System.Drawing.Size(6, 25)
        '
        'BindingNavigatorMoveNextItem1
        '
        Me.BindingNavigatorMoveNextItem1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveNextItem1.Image = CType(resources.GetObject("BindingNavigatorMoveNextItem1.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveNextItem1.Name = "BindingNavigatorMoveNextItem1"
        Me.BindingNavigatorMoveNextItem1.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveNextItem1.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveNextItem1.Text = "Move next"
        '
        'BindingNavigatorMoveLastItem1
        '
        Me.BindingNavigatorMoveLastItem1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorMoveLastItem1.Image = CType(resources.GetObject("BindingNavigatorMoveLastItem1.Image"), System.Drawing.Image)
        Me.BindingNavigatorMoveLastItem1.Name = "BindingNavigatorMoveLastItem1"
        Me.BindingNavigatorMoveLastItem1.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorMoveLastItem1.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorMoveLastItem1.Text = "Move last"
        '
        'BindingNavigatorSeparator5
        '
        Me.BindingNavigatorSeparator5.Name = "BindingNavigatorSeparator5"
        Me.BindingNavigatorSeparator5.Size = New System.Drawing.Size(6, 25)
        '
        'BindingNavigatorDeleteItem1
        '
        Me.BindingNavigatorDeleteItem1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.BindingNavigatorDeleteItem1.Image = CType(resources.GetObject("BindingNavigatorDeleteItem1.Image"), System.Drawing.Image)
        Me.BindingNavigatorDeleteItem1.Name = "BindingNavigatorDeleteItem1"
        Me.BindingNavigatorDeleteItem1.RightToLeftAutoMirrorImage = True
        Me.BindingNavigatorDeleteItem1.Size = New System.Drawing.Size(23, 22)
        Me.BindingNavigatorDeleteItem1.Text = "Delete"
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(926, 610)
        Me.Controls.Add(Me.TabControlEnvManager)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "MainForm"
        Me.ShowInTaskbar = False
        Me.ToolTipController1.SetSuperTip(Me, Nothing)
        Me.Text = "Manage Settings"
        Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
        Me.cmsEnvironments.ResumeLayout(False)
        Me.TabInfo.ResumeLayout(False)
        Me.TabInfo.PerformLayout()
        Me.TabEnvEditor.ResumeLayout(False)
        Me.TabEnvEditor.PerformLayout()
        Me.TabControlEnvManager.ResumeLayout(False)
        Me.TabParams.ResumeLayout(False)
        Me.TabParams.PerformLayout()
        CType(Me.ParamsGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsSettingsRow, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ParamGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemComboBox1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ParamsBindingNavigator, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ParamsBindingNavigator.ResumeLayout(False)
        Me.ParamsBindingNavigator.PerformLayout()
        Me.TabAdministration.ResumeLayout(False)
        Me.TabAdministration.PerformLayout()
        CType(Me.bnAdmins, System.ComponentModel.ISupportInitialize).EndInit()
        Me.bnAdmins.ResumeLayout(False)
        Me.bnAdmins.PerformLayout()
        CType(Me.bsAdmins, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdAdminUsers, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsEnvironments, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents NotifyIcon1 As System.Windows.Forms.NotifyIcon
    Friend WithEvents cmsEnvironments As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents TestingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StagingToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ProductionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DevelopmentToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ShowToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ResetToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TabInfo As System.Windows.Forms.TabPage
    Friend WithEvents TabEnvEditor As System.Windows.Forms.TabPage
    Friend WithEvents txtSQLTimeOut As System.Windows.Forms.TextBox
    Friend WithEvents txtSMTPServer As System.Windows.Forms.TextBox
    Friend WithEvents txtConnectionString As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents lblEnvironment As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents TabControlEnvManager As System.Windows.Forms.TabControl
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents TabParams As System.Windows.Forms.TabPage
    Friend WithEvents cboCurrentEnvironment As System.Windows.Forms.ComboBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents PARAMGRPDataGridViewTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents PARAMVALUEDataGridViewTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ParamsGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents bsSettingsRow As System.Windows.Forms.BindingSource
    Friend WithEvents btnReset As System.Windows.Forms.Button
    Friend WithEvents ParamGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colParamId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colParamName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colParam_Type As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colParamGroup As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colstrParamValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumParamValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDatParamValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colComments As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents BindingNavigatorCountItem1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents BindingNavigatorDeleteItem1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMoveFirstItem1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMovePreviousItem1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents BindingNavigatorPositionItem1 As System.Windows.Forms.ToolStripTextBox
    Friend WithEvents BindingNavigatorSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents BindingNavigatorMoveNextItem1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMoveLastItem1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorSeparator5 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ParamsBindingNavigator As System.Windows.Forms.BindingNavigator
    Friend WithEvents BindingNavigatorAddNewItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorCountItem As System.Windows.Forms.ToolStripLabel
    Friend WithEvents BindingNavigatorDeleteItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMoveFirstItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMovePreviousItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents BindingNavigatorPositionItem As System.Windows.Forms.ToolStripTextBox
    Friend WithEvents BindingNavigatorSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents BindingNavigatorMoveNextItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorMoveLastItem As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ExportButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RepositoryItemComboBox1 As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents SaveToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents toolStripSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SaveAllToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RefreshToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExportToSQLToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents EnvironmentToolStripComboBox As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents chkSaveAsDefault As System.Windows.Forms.CheckBox
    Friend WithEvents btnNew As System.Windows.Forms.Button
    Friend WithEvents bsEnvironments As System.Windows.Forms.BindingSource
    Friend WithEvents ToolTipController1 As DevExpress.Utils.ToolTipController
    Friend WithEvents btnSave As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents TabAdministration As System.Windows.Forms.TabPage
    Friend WithEvents bsAdmins As System.Windows.Forms.BindingSource
    Friend WithEvents grdAdminUsers As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents bnAdmins As System.Windows.Forms.BindingNavigator
    Friend WithEvents BindingNavigatorAddNewAdmin As System.Windows.Forms.ToolStripButton
    Friend WithEvents BindingNavigatorDeleteAdmin As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveAdminsToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents toolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents HelpToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents txtNrcAuthConnectionString As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents btnBuildQualisysConnection As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents btnBuildNrcAuthConnection As DevExpress.XtraEditors.SimpleButton
    Friend WithEvents btnEditXML As DevExpress.XtraEditors.SimpleButton

End Class
