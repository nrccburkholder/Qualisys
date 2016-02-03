<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportExportSection
    Inherits Section

    'UserControl overrides dispose to clean up the component list.
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
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.cmdOK = New System.Windows.Forms.Button
        Me.cmdRun = New System.Windows.Forms.Button
        Me.TabControl1 = New System.Windows.Forms.TabControl
        Me.TabPage1 = New System.Windows.Forms.TabPage
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.cmdDeleteExportFile = New System.Windows.Forms.Button
        Me.cmdEditExportFile = New System.Windows.Forms.Button
        Me.cmdExportPath = New System.Windows.Forms.Button
        Me.txtExportFilePath = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.txtExportFileName = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.grdExportFiles = New DevExpress.XtraGrid.GridControl
        Me.bsExportFiles = New System.Windows.Forms.BindingSource(Me.components)
        Me.grdExportFilesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportDefinitionID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPathandFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSourceFile = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colReferenceGuid = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSplitRule = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDeDupRule = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDBDeDupRule1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridView2 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.cboExportTemplates = New System.Windows.Forms.ComboBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.cmdAddExportFile = New System.Windows.Forms.Button
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.chkHasHeader = New System.Windows.Forms.CheckBox
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.txtExportDefinitionName = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtSourceFileName = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.cmdSourceFile = New System.Windows.Forms.Button
        Me.cboSourceTemplates = New System.Windows.Forms.ComboBox
        Me.txtSourceFile = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.TabPage2 = New System.Windows.Forms.TabPage
        Me.GroupBox4 = New System.Windows.Forms.GroupBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.grdExportFileWithRules = New DevExpress.XtraGrid.GridControl
        Me.grdExportFileWithRulesView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportDefinitionID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPathandFileName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSourceFile1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colReferenceGuid1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSplitRule1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDeDupRule1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDBDeDupRule2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridView3 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.Label10 = New System.Windows.Forms.Label
        Me.txtSplitRule = New System.Windows.Forms.TextBox
        Me.cmdClearRule = New System.Windows.Forms.Button
        Me.cmdAddRule = New System.Windows.Forms.Button
        Me.TabPage3 = New System.Windows.Forms.TabPage
        Me.GroupBox5 = New System.Windows.Forms.GroupBox
        Me.GroupBox6 = New System.Windows.Forms.GroupBox
        Me.cboSIStartDate = New System.Windows.Forms.ComboBox
        Me.Label13 = New System.Windows.Forms.Label
        Me.txtSearchCriteria = New System.Windows.Forms.TextBox
        Me.lblClientIDs = New System.Windows.Forms.Label
        Me.Label19 = New System.Windows.Forms.Label
        Me.lblRuleName = New System.Windows.Forms.Label
        Me.Label17 = New System.Windows.Forms.Label
        Me.Label15 = New System.Windows.Forms.Label
        Me.chkRuleSIActive = New System.Windows.Forms.CheckBox
        Me.grdExportFileWithDeDupRules = New DevExpress.XtraGrid.GridControl
        Me.grdExportFileWithDeDupRulesView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileID2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportDefinitionID2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPathandFileName2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsSourceFile2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colReferenceGuid2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSplitRule2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDeDupRule2 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDBDeDupRule = New DevExpress.XtraGrid.Columns.GridColumn
        Me.lstSourceTemplateColsForFileDeDup = New System.Windows.Forms.ListBox
        Me.Label14 = New System.Windows.Forms.Label
        Me.cmdClearDeDupRule = New System.Windows.Forms.Button
        Me.cmdAddDeDupRule = New System.Windows.Forms.Button
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.SectionPanel1.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        CType(Me.grdExportFiles, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsExportFiles, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdExportFilesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        CType(Me.grdExportFileWithRules, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdExportFileWithRulesView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage3.SuspendLayout()
        Me.GroupBox5.SuspendLayout()
        Me.GroupBox6.SuspendLayout()
        CType(Me.grdExportFileWithDeDupRules, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdExportFileWithDeDupRulesView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Import - Export"
        Me.SectionPanel1.Controls.Add(Me.cmdCancel)
        Me.SectionPanel1.Controls.Add(Me.cmdOK)
        Me.SectionPanel1.Controls.Add(Me.cmdRun)
        Me.SectionPanel1.Controls.Add(Me.TabControl1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(726, 688)
        Me.SectionPanel1.TabIndex = 0
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.Location = New System.Drawing.Point(638, 643)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 17
        Me.cmdCancel.Text = "&Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'cmdOK
        '
        Me.cmdOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdOK.Location = New System.Drawing.Point(557, 643)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(75, 23)
        Me.cmdOK.TabIndex = 16
        Me.cmdOK.Text = "&OK"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'cmdRun
        '
        Me.cmdRun.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdRun.Location = New System.Drawing.Point(470, 643)
        Me.cmdRun.Name = "cmdRun"
        Me.cmdRun.Size = New System.Drawing.Size(75, 23)
        Me.cmdRun.TabIndex = 15
        Me.cmdRun.Text = "&Run"
        Me.cmdRun.UseVisualStyleBackColor = True
        '
        'TabControl1
        '
        Me.TabControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TabControl1.Controls.Add(Me.TabPage1)
        Me.TabControl1.Controls.Add(Me.TabPage2)
        Me.TabControl1.Controls.Add(Me.TabPage3)
        Me.TabControl1.Location = New System.Drawing.Point(15, 36)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(696, 601)
        Me.TabControl1.TabIndex = 1
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.GroupBox3)
        Me.TabPage1.Controls.Add(Me.GroupBox2)
        Me.TabPage1.Controls.Add(Me.GroupBox1)
        Me.TabPage1.Location = New System.Drawing.Point(4, 22)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(688, 575)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Import - Export Definition"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'GroupBox3
        '
        Me.GroupBox3.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox3.Controls.Add(Me.cmdDeleteExportFile)
        Me.GroupBox3.Controls.Add(Me.cmdEditExportFile)
        Me.GroupBox3.Controls.Add(Me.cmdExportPath)
        Me.GroupBox3.Controls.Add(Me.txtExportFilePath)
        Me.GroupBox3.Controls.Add(Me.Label8)
        Me.GroupBox3.Controls.Add(Me.Label7)
        Me.GroupBox3.Controls.Add(Me.txtExportFileName)
        Me.GroupBox3.Controls.Add(Me.Label5)
        Me.GroupBox3.Controls.Add(Me.grdExportFiles)
        Me.GroupBox3.Controls.Add(Me.cboExportTemplates)
        Me.GroupBox3.Controls.Add(Me.Label4)
        Me.GroupBox3.Controls.Add(Me.cmdAddExportFile)
        Me.GroupBox3.Location = New System.Drawing.Point(6, 218)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(673, 351)
        Me.GroupBox3.TabIndex = 2
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Export Data"
        '
        'cmdDeleteExportFile
        '
        Me.cmdDeleteExportFile.Location = New System.Drawing.Point(533, 70)
        Me.cmdDeleteExportFile.Name = "cmdDeleteExportFile"
        Me.cmdDeleteExportFile.Size = New System.Drawing.Size(97, 23)
        Me.cmdDeleteExportFile.TabIndex = 13
        Me.cmdDeleteExportFile.Text = "Delete Export File"
        Me.cmdDeleteExportFile.UseVisualStyleBackColor = True
        '
        'cmdEditExportFile
        '
        Me.cmdEditExportFile.Location = New System.Drawing.Point(533, 42)
        Me.cmdEditExportFile.Name = "cmdEditExportFile"
        Me.cmdEditExportFile.Size = New System.Drawing.Size(97, 23)
        Me.cmdEditExportFile.TabIndex = 12
        Me.cmdEditExportFile.Text = "Edit Export File"
        Me.cmdEditExportFile.UseVisualStyleBackColor = True
        '
        'cmdExportPath
        '
        Me.cmdExportPath.Location = New System.Drawing.Point(483, 42)
        Me.cmdExportPath.Name = "cmdExportPath"
        Me.cmdExportPath.Size = New System.Drawing.Size(31, 20)
        Me.cmdExportPath.TabIndex = 9
        Me.cmdExportPath.Text = "..."
        Me.cmdExportPath.UseVisualStyleBackColor = True
        '
        'txtExportFilePath
        '
        Me.txtExportFilePath.Location = New System.Drawing.Point(149, 42)
        Me.txtExportFilePath.Name = "txtExportFilePath"
        Me.txtExportFilePath.ReadOnly = True
        Me.txtExportFilePath.Size = New System.Drawing.Size(328, 20)
        Me.txtExportFilePath.TabIndex = 8
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(10, 41)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(84, 13)
        Me.Label8.TabIndex = 7
        Me.Label8.Text = "Export File Path:"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(10, 16)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(129, 13)
        Me.Label7.TabIndex = 6
        Me.Label7.Text = "Export File Friendly Name:"
        '
        'txtExportFileName
        '
        Me.txtExportFileName.Location = New System.Drawing.Point(149, 16)
        Me.txtExportFileName.Name = "txtExportFileName"
        Me.txtExportFileName.Size = New System.Drawing.Size(328, 20)
        Me.txtExportFileName.TabIndex = 7
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(10, 96)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(64, 13)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "Export Files:"
        '
        'grdExportFiles
        '
        Me.grdExportFiles.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdExportFiles.DataSource = Me.bsExportFiles
        Me.grdExportFiles.EmbeddedNavigator.Name = ""
        Me.grdExportFiles.Location = New System.Drawing.Point(9, 112)
        Me.grdExportFiles.MainView = Me.grdExportFilesGridView
        Me.grdExportFiles.Name = "grdExportFiles"
        Me.grdExportFiles.Size = New System.Drawing.Size(658, 233)
        Me.grdExportFiles.TabIndex = 14
        Me.grdExportFiles.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdExportFilesGridView, Me.GridView2})
        '
        'bsExportFiles
        '
        Me.bsExportFiles.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_ExportDefintionFile)
        '
        'grdExportFilesGridView
        '
        Me.grdExportFilesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileID, Me.colExportDefinitionID, Me.colName, Me.colPathandFileName, Me.colIsSourceFile, Me.colReferenceGuid, Me.colSplitRule, Me.colDeDupRule, Me.colDBDeDupRule1})
        Me.grdExportFilesGridView.GridControl = Me.grdExportFiles
        Me.grdExportFilesGridView.Name = "grdExportFilesGridView"
        Me.grdExportFilesGridView.OptionsBehavior.Editable = False
        Me.grdExportFilesGridView.OptionsCustomization.AllowFilter = False
        Me.grdExportFilesGridView.OptionsCustomization.AllowGroup = False
        Me.grdExportFilesGridView.OptionsFilter.AllowFilterEditor = False
        Me.grdExportFilesGridView.OptionsView.ShowGroupPanel = False
        '
        'colFileID
        '
        Me.colFileID.Caption = "FileID"
        Me.colFileID.FieldName = "FileID"
        Me.colFileID.Name = "colFileID"
        Me.colFileID.OptionsColumn.ReadOnly = True
        Me.colFileID.Visible = True
        Me.colFileID.VisibleIndex = 0
        Me.colFileID.Width = 58
        '
        'colExportDefinitionID
        '
        Me.colExportDefinitionID.Caption = "ExportDefinitionID"
        Me.colExportDefinitionID.FieldName = "ExportDefinitionID"
        Me.colExportDefinitionID.Name = "colExportDefinitionID"
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        Me.colName.Width = 179
        '
        'colPathandFileName
        '
        Me.colPathandFileName.Caption = "PathandFileName"
        Me.colPathandFileName.FieldName = "PathandFileName"
        Me.colPathandFileName.Name = "colPathandFileName"
        Me.colPathandFileName.Visible = True
        Me.colPathandFileName.VisibleIndex = 2
        Me.colPathandFileName.Width = 400
        '
        'colIsSourceFile
        '
        Me.colIsSourceFile.Caption = "IsSourceFile"
        Me.colIsSourceFile.FieldName = "IsSourceFile"
        Me.colIsSourceFile.Name = "colIsSourceFile"
        '
        'colReferenceGuid
        '
        Me.colReferenceGuid.Caption = "ReferenceGuid"
        Me.colReferenceGuid.FieldName = "ReferenceGuid"
        Me.colReferenceGuid.Name = "colReferenceGuid"
        Me.colReferenceGuid.OptionsColumn.ReadOnly = True
        '
        'colSplitRule
        '
        Me.colSplitRule.Caption = "SplitRule"
        Me.colSplitRule.FieldName = "SplitRule"
        Me.colSplitRule.Name = "colSplitRule"
        '
        'colDeDupRule
        '
        Me.colDeDupRule.Caption = "DeDupRule"
        Me.colDeDupRule.FieldName = "DeDupRule"
        Me.colDeDupRule.Name = "colDeDupRule"
        Me.colDeDupRule.OptionsColumn.ReadOnly = True
        '
        'colDBDeDupRule1
        '
        Me.colDBDeDupRule1.Caption = "DBDeDupRule"
        Me.colDBDeDupRule1.FieldName = "DBDeDupRule"
        Me.colDBDeDupRule1.Name = "colDBDeDupRule1"
        '
        'GridView2
        '
        Me.GridView2.GridControl = Me.grdExportFiles
        Me.GridView2.Name = "GridView2"
        '
        'cboExportTemplates
        '
        Me.cboExportTemplates.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboExportTemplates.FormattingEnabled = True
        Me.cboExportTemplates.Location = New System.Drawing.Point(149, 70)
        Me.cboExportTemplates.Name = "cboExportTemplates"
        Me.cboExportTemplates.Size = New System.Drawing.Size(328, 21)
        Me.cboExportTemplates.TabIndex = 10
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(10, 70)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(87, 13)
        Me.Label4.TabIndex = 1
        Me.Label4.Text = "Export Template:"
        '
        'cmdAddExportFile
        '
        Me.cmdAddExportFile.Location = New System.Drawing.Point(533, 14)
        Me.cmdAddExportFile.Name = "cmdAddExportFile"
        Me.cmdAddExportFile.Size = New System.Drawing.Size(97, 23)
        Me.cmdAddExportFile.TabIndex = 11
        Me.cmdAddExportFile.Text = "Add Export File"
        Me.cmdAddExportFile.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.chkHasHeader)
        Me.GroupBox2.Controls.Add(Me.txtDescription)
        Me.GroupBox2.Controls.Add(Me.Label9)
        Me.GroupBox2.Controls.Add(Me.txtExportDefinitionName)
        Me.GroupBox2.Controls.Add(Me.Label3)
        Me.GroupBox2.Location = New System.Drawing.Point(6, 6)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(676, 102)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Import Export Data"
        '
        'chkHasHeader
        '
        Me.chkHasHeader.AutoSize = True
        Me.chkHasHeader.Location = New System.Drawing.Point(493, 20)
        Me.chkHasHeader.Name = "chkHasHeader"
        Me.chkHasHeader.Size = New System.Drawing.Size(83, 17)
        Me.chkHasHeader.TabIndex = 3
        Me.chkHasHeader.Text = "Has Header"
        Me.chkHasHeader.UseVisualStyleBackColor = True
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(9, 58)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtDescription.Size = New System.Drawing.Size(468, 38)
        Me.txtDescription.TabIndex = 2
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(7, 42)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(63, 13)
        Me.Label9.TabIndex = 2
        Me.Label9.Text = "Description:"
        '
        'txtExportDefinitionName
        '
        Me.txtExportDefinitionName.Location = New System.Drawing.Point(146, 17)
        Me.txtExportDefinitionName.Name = "txtExportDefinitionName"
        Me.txtExportDefinitionName.Size = New System.Drawing.Size(328, 20)
        Me.txtExportDefinitionName.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(7, 20)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(103, 13)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Import Export Name:"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.txtSourceFileName)
        Me.GroupBox1.Controls.Add(Me.Label6)
        Me.GroupBox1.Controls.Add(Me.cmdSourceFile)
        Me.GroupBox1.Controls.Add(Me.cboSourceTemplates)
        Me.GroupBox1.Controls.Add(Me.txtSourceFile)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(6, 114)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(676, 98)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Import Data"
        '
        'txtSourceFileName
        '
        Me.txtSourceFileName.Location = New System.Drawing.Point(146, 13)
        Me.txtSourceFileName.Name = "txtSourceFileName"
        Me.txtSourceFileName.Size = New System.Drawing.Size(328, 20)
        Me.txtSourceFileName.TabIndex = 3
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(7, 16)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(133, 13)
        Me.Label6.TabIndex = 5
        Me.Label6.Text = "Source File Friendly Name:"
        '
        'cmdSourceFile
        '
        Me.cmdSourceFile.Location = New System.Drawing.Point(480, 43)
        Me.cmdSourceFile.Name = "cmdSourceFile"
        Me.cmdSourceFile.Size = New System.Drawing.Size(28, 19)
        Me.cmdSourceFile.TabIndex = 5
        Me.cmdSourceFile.Text = "..."
        Me.cmdSourceFile.UseVisualStyleBackColor = True
        '
        'cboSourceTemplates
        '
        Me.cboSourceTemplates.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSourceTemplates.FormattingEnabled = True
        Me.cboSourceTemplates.Location = New System.Drawing.Point(146, 66)
        Me.cboSourceTemplates.Name = "cboSourceTemplates"
        Me.cboSourceTemplates.Size = New System.Drawing.Size(328, 21)
        Me.cboSourceTemplates.TabIndex = 6
        '
        'txtSourceFile
        '
        Me.txtSourceFile.Location = New System.Drawing.Point(146, 42)
        Me.txtSourceFile.Name = "txtSourceFile"
        Me.txtSourceFile.ReadOnly = True
        Me.txtSourceFile.Size = New System.Drawing.Size(328, 20)
        Me.txtSourceFile.TabIndex = 4
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 68)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(91, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Source Template:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 45)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(88, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Source File Path:"
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.GroupBox4)
        Me.TabPage2.Location = New System.Drawing.Point(4, 22)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(688, 575)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Split Criteria"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'GroupBox4
        '
        Me.GroupBox4.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox4.Controls.Add(Me.Label11)
        Me.GroupBox4.Controls.Add(Me.grdExportFileWithRules)
        Me.GroupBox4.Controls.Add(Me.Label10)
        Me.GroupBox4.Controls.Add(Me.txtSplitRule)
        Me.GroupBox4.Controls.Add(Me.cmdClearRule)
        Me.GroupBox4.Controls.Add(Me.cmdAddRule)
        Me.GroupBox4.Location = New System.Drawing.Point(6, 6)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(676, 563)
        Me.GroupBox4.TabIndex = 0
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Split Rules:"
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(6, 228)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(116, 13)
        Me.Label11.TabIndex = 5
        Me.Label11.Text = "Export Files with Rules:"
        '
        'grdExportFileWithRules
        '
        Me.grdExportFileWithRules.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdExportFileWithRules.DataSource = Me.bsExportFiles
        Me.grdExportFileWithRules.EmbeddedNavigator.Name = ""
        Me.grdExportFileWithRules.Location = New System.Drawing.Point(9, 244)
        Me.grdExportFileWithRules.MainView = Me.grdExportFileWithRulesView
        Me.grdExportFileWithRules.Name = "grdExportFileWithRules"
        Me.grdExportFileWithRules.Size = New System.Drawing.Size(661, 313)
        Me.grdExportFileWithRules.TabIndex = 3
        Me.grdExportFileWithRules.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdExportFileWithRulesView, Me.GridView3})
        '
        'grdExportFileWithRulesView
        '
        Me.grdExportFileWithRulesView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileID1, Me.colExportDefinitionID1, Me.colName1, Me.colPathandFileName1, Me.colIsSourceFile1, Me.colReferenceGuid1, Me.colSplitRule1, Me.colDeDupRule1, Me.colDBDeDupRule2})
        Me.grdExportFileWithRulesView.GridControl = Me.grdExportFileWithRules
        Me.grdExportFileWithRulesView.Name = "grdExportFileWithRulesView"
        Me.grdExportFileWithRulesView.OptionsBehavior.Editable = False
        Me.grdExportFileWithRulesView.OptionsCustomization.AllowFilter = False
        Me.grdExportFileWithRulesView.OptionsCustomization.AllowGroup = False
        Me.grdExportFileWithRulesView.OptionsCustomization.AllowSort = False
        Me.grdExportFileWithRulesView.OptionsFilter.AllowFilterEditor = False
        Me.grdExportFileWithRulesView.OptionsView.ShowGroupPanel = False
        '
        'colFileID1
        '
        Me.colFileID1.Caption = "FileID"
        Me.colFileID1.FieldName = "FileID"
        Me.colFileID1.Name = "colFileID1"
        Me.colFileID1.OptionsColumn.ReadOnly = True
        Me.colFileID1.Visible = True
        Me.colFileID1.VisibleIndex = 0
        Me.colFileID1.Width = 51
        '
        'colExportDefinitionID1
        '
        Me.colExportDefinitionID1.Caption = "ExportDefinitionID"
        Me.colExportDefinitionID1.FieldName = "ExportDefinitionID"
        Me.colExportDefinitionID1.Name = "colExportDefinitionID1"
        '
        'colName1
        '
        Me.colName1.Caption = "Name"
        Me.colName1.FieldName = "Name"
        Me.colName1.Name = "colName1"
        Me.colName1.Visible = True
        Me.colName1.VisibleIndex = 1
        Me.colName1.Width = 136
        '
        'colPathandFileName1
        '
        Me.colPathandFileName1.Caption = "PathandFileName"
        Me.colPathandFileName1.FieldName = "PathandFileName"
        Me.colPathandFileName1.Name = "colPathandFileName1"
        '
        'colIsSourceFile1
        '
        Me.colIsSourceFile1.Caption = "IsSourceFile"
        Me.colIsSourceFile1.FieldName = "IsSourceFile"
        Me.colIsSourceFile1.Name = "colIsSourceFile1"
        '
        'colReferenceGuid1
        '
        Me.colReferenceGuid1.Caption = "ReferenceGuid"
        Me.colReferenceGuid1.FieldName = "ReferenceGuid"
        Me.colReferenceGuid1.Name = "colReferenceGuid1"
        Me.colReferenceGuid1.OptionsColumn.ReadOnly = True
        '
        'colSplitRule1
        '
        Me.colSplitRule1.Caption = "SplitRule"
        Me.colSplitRule1.FieldName = "SplitRule"
        Me.colSplitRule1.Name = "colSplitRule1"
        Me.colSplitRule1.Visible = True
        Me.colSplitRule1.VisibleIndex = 2
        Me.colSplitRule1.Width = 453
        '
        'colDeDupRule1
        '
        Me.colDeDupRule1.Caption = "DeDupRule"
        Me.colDeDupRule1.FieldName = "DeDupRule"
        Me.colDeDupRule1.Name = "colDeDupRule1"
        Me.colDeDupRule1.OptionsColumn.ReadOnly = True
        '
        'colDBDeDupRule2
        '
        Me.colDBDeDupRule2.Caption = "DBDeDupRule"
        Me.colDBDeDupRule2.FieldName = "DBDeDupRule"
        Me.colDBDeDupRule2.Name = "colDBDeDupRule2"
        '
        'GridView3
        '
        Me.GridView3.GridControl = Me.grdExportFileWithRules
        Me.GridView3.Name = "GridView3"
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(6, 27)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(107, 13)
        Me.Label10.TabIndex = 3
        Me.Label10.Text = "Export File Split Rule:"
        '
        'txtSplitRule
        '
        Me.txtSplitRule.Location = New System.Drawing.Point(9, 43)
        Me.txtSplitRule.Multiline = True
        Me.txtSplitRule.Name = "txtSplitRule"
        Me.txtSplitRule.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtSplitRule.Size = New System.Drawing.Size(661, 182)
        Me.txtSplitRule.TabIndex = 2
        '
        'cmdClearRule
        '
        Me.cmdClearRule.Location = New System.Drawing.Point(595, 17)
        Me.cmdClearRule.Name = "cmdClearRule"
        Me.cmdClearRule.Size = New System.Drawing.Size(75, 23)
        Me.cmdClearRule.TabIndex = 1
        Me.cmdClearRule.Text = "Clear Rule"
        Me.cmdClearRule.UseVisualStyleBackColor = True
        '
        'cmdAddRule
        '
        Me.cmdAddRule.Location = New System.Drawing.Point(514, 17)
        Me.cmdAddRule.Name = "cmdAddRule"
        Me.cmdAddRule.Size = New System.Drawing.Size(75, 23)
        Me.cmdAddRule.TabIndex = 0
        Me.cmdAddRule.Text = "Add Rule"
        Me.cmdAddRule.UseVisualStyleBackColor = True
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.GroupBox5)
        Me.TabPage3.Location = New System.Drawing.Point(4, 22)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Size = New System.Drawing.Size(688, 575)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "De-Dup Criteria"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'GroupBox5
        '
        Me.GroupBox5.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox5.Controls.Add(Me.GroupBox6)
        Me.GroupBox5.Controls.Add(Me.lstSourceTemplateColsForFileDeDup)
        Me.GroupBox5.Controls.Add(Me.Label14)
        Me.GroupBox5.Controls.Add(Me.cmdClearDeDupRule)
        Me.GroupBox5.Controls.Add(Me.cmdAddDeDupRule)
        Me.GroupBox5.Location = New System.Drawing.Point(3, 3)
        Me.GroupBox5.Name = "GroupBox5"
        Me.GroupBox5.Size = New System.Drawing.Size(682, 569)
        Me.GroupBox5.TabIndex = 0
        Me.GroupBox5.TabStop = False
        Me.GroupBox5.Text = "DeDup Rules"
        '
        'GroupBox6
        '
        Me.GroupBox6.Controls.Add(Me.cboSIStartDate)
        Me.GroupBox6.Controls.Add(Me.Label13)
        Me.GroupBox6.Controls.Add(Me.txtSearchCriteria)
        Me.GroupBox6.Controls.Add(Me.lblClientIDs)
        Me.GroupBox6.Controls.Add(Me.Label19)
        Me.GroupBox6.Controls.Add(Me.lblRuleName)
        Me.GroupBox6.Controls.Add(Me.Label17)
        Me.GroupBox6.Controls.Add(Me.Label15)
        Me.GroupBox6.Controls.Add(Me.chkRuleSIActive)
        Me.GroupBox6.Controls.Add(Me.grdExportFileWithDeDupRules)
        Me.GroupBox6.Location = New System.Drawing.Point(9, 185)
        Me.GroupBox6.Name = "GroupBox6"
        Me.GroupBox6.Size = New System.Drawing.Size(667, 378)
        Me.GroupBox6.TabIndex = 7
        Me.GroupBox6.TabStop = False
        Me.GroupBox6.Text = "Export File DeDup Rules"
        '
        'cboSIStartDate
        '
        Me.cboSIStartDate.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSIStartDate.FormattingEnabled = True
        Me.cboSIStartDate.Location = New System.Drawing.Point(198, 25)
        Me.cboSIStartDate.Name = "cboSIStartDate"
        Me.cboSIStartDate.Size = New System.Drawing.Size(121, 21)
        Me.cboSIStartDate.TabIndex = 15
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.Location = New System.Drawing.Point(6, 28)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(186, 13)
        Me.Label13.TabIndex = 14
        Me.Label13.Text = "# Mo's SI Start Date DeDeup Search:"
        '
        'txtSearchCriteria
        '
        Me.txtSearchCriteria.Location = New System.Drawing.Point(9, 296)
        Me.txtSearchCriteria.Multiline = True
        Me.txtSearchCriteria.Name = "txtSearchCriteria"
        Me.txtSearchCriteria.ReadOnly = True
        Me.txtSearchCriteria.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtSearchCriteria.Size = New System.Drawing.Size(655, 75)
        Me.txtSearchCriteria.TabIndex = 13
        '
        'lblClientIDs
        '
        Me.lblClientIDs.AutoSize = True
        Me.lblClientIDs.Location = New System.Drawing.Point(67, 256)
        Me.lblClientIDs.Name = "lblClientIDs"
        Me.lblClientIDs.Size = New System.Drawing.Size(45, 13)
        Me.lblClientIDs.TabIndex = 12
        Me.lblClientIDs.Text = "Label13"
        '
        'Label19
        '
        Me.Label19.AutoSize = True
        Me.Label19.Location = New System.Drawing.Point(6, 280)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(79, 13)
        Me.Label19.TabIndex = 11
        Me.Label19.Text = "Search Criteria:"
        '
        'lblRuleName
        '
        Me.lblRuleName.AutoSize = True
        Me.lblRuleName.Location = New System.Drawing.Point(89, 203)
        Me.lblRuleName.Name = "lblRuleName"
        Me.lblRuleName.Size = New System.Drawing.Size(45, 13)
        Me.lblRuleName.TabIndex = 10
        Me.lblRuleName.Text = "Label18"
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.Location = New System.Drawing.Point(6, 203)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(63, 13)
        Me.Label17.TabIndex = 9
        Me.Label17.Text = "Rule Name:"
        '
        'Label15
        '
        Me.Label15.AutoSize = True
        Me.Label15.Location = New System.Drawing.Point(6, 256)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(55, 13)
        Me.Label15.TabIndex = 7
        Me.Label15.Text = "Client IDs:"
        '
        'chkRuleSIActive
        '
        Me.chkRuleSIActive.AutoSize = True
        Me.chkRuleSIActive.Enabled = False
        Me.chkRuleSIActive.Location = New System.Drawing.Point(9, 226)
        Me.chkRuleSIActive.Name = "chkRuleSIActive"
        Me.chkRuleSIActive.Size = New System.Drawing.Size(202, 17)
        Me.chkRuleSIActive.TabIndex = 6
        Me.chkRuleSIActive.Text = "Search Active Survey Instances Only"
        Me.chkRuleSIActive.UseVisualStyleBackColor = True
        '
        'grdExportFileWithDeDupRules
        '
        Me.grdExportFileWithDeDupRules.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdExportFileWithDeDupRules.DataSource = Me.bsExportFiles
        Me.grdExportFileWithDeDupRules.EmbeddedNavigator.Name = ""
        Me.grdExportFileWithDeDupRules.Location = New System.Drawing.Point(6, 56)
        Me.grdExportFileWithDeDupRules.MainView = Me.grdExportFileWithDeDupRulesView
        Me.grdExportFileWithDeDupRules.Name = "grdExportFileWithDeDupRules"
        Me.grdExportFileWithDeDupRules.Size = New System.Drawing.Size(655, 135)
        Me.grdExportFileWithDeDupRules.TabIndex = 3
        Me.grdExportFileWithDeDupRules.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdExportFileWithDeDupRulesView})
        '
        'grdExportFileWithDeDupRulesView
        '
        Me.grdExportFileWithDeDupRulesView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileID2, Me.colExportDefinitionID2, Me.colName2, Me.colPathandFileName2, Me.colIsSourceFile2, Me.colReferenceGuid2, Me.colSplitRule2, Me.colDeDupRule2, Me.colDBDeDupRule})
        Me.grdExportFileWithDeDupRulesView.GridControl = Me.grdExportFileWithDeDupRules
        Me.grdExportFileWithDeDupRulesView.Name = "grdExportFileWithDeDupRulesView"
        Me.grdExportFileWithDeDupRulesView.OptionsBehavior.Editable = False
        Me.grdExportFileWithDeDupRulesView.OptionsCustomization.AllowFilter = False
        Me.grdExportFileWithDeDupRulesView.OptionsCustomization.AllowGroup = False
        Me.grdExportFileWithDeDupRulesView.OptionsCustomization.AllowSort = False
        Me.grdExportFileWithDeDupRulesView.OptionsView.ShowGroupPanel = False
        '
        'colFileID2
        '
        Me.colFileID2.Caption = "FileID"
        Me.colFileID2.FieldName = "FileID"
        Me.colFileID2.Name = "colFileID2"
        Me.colFileID2.OptionsColumn.ReadOnly = True
        Me.colFileID2.Visible = True
        Me.colFileID2.VisibleIndex = 0
        Me.colFileID2.Width = 51
        '
        'colExportDefinitionID2
        '
        Me.colExportDefinitionID2.Caption = "ExportDefinitionID"
        Me.colExportDefinitionID2.FieldName = "ExportDefinitionID"
        Me.colExportDefinitionID2.Name = "colExportDefinitionID2"
        '
        'colName2
        '
        Me.colName2.Caption = "Name"
        Me.colName2.FieldName = "Name"
        Me.colName2.Name = "colName2"
        Me.colName2.Visible = True
        Me.colName2.VisibleIndex = 1
        Me.colName2.Width = 153
        '
        'colPathandFileName2
        '
        Me.colPathandFileName2.Caption = "PathandFileName"
        Me.colPathandFileName2.FieldName = "PathandFileName"
        Me.colPathandFileName2.Name = "colPathandFileName2"
        Me.colPathandFileName2.Width = 401
        '
        'colIsSourceFile2
        '
        Me.colIsSourceFile2.Caption = "IsSourceFile"
        Me.colIsSourceFile2.FieldName = "IsSourceFile"
        Me.colIsSourceFile2.Name = "colIsSourceFile2"
        '
        'colReferenceGuid2
        '
        Me.colReferenceGuid2.Caption = "ReferenceGuid"
        Me.colReferenceGuid2.FieldName = "ReferenceGuid"
        Me.colReferenceGuid2.Name = "colReferenceGuid2"
        Me.colReferenceGuid2.OptionsColumn.ReadOnly = True
        '
        'colSplitRule2
        '
        Me.colSplitRule2.Caption = "SplitRule"
        Me.colSplitRule2.FieldName = "SplitRule"
        Me.colSplitRule2.Name = "colSplitRule2"
        '
        'colDeDupRule2
        '
        Me.colDeDupRule2.Caption = "DeDupRule"
        Me.colDeDupRule2.FieldName = "DeDupRule"
        Me.colDeDupRule2.Name = "colDeDupRule2"
        Me.colDeDupRule2.OptionsColumn.ReadOnly = True
        Me.colDeDupRule2.Visible = True
        Me.colDeDupRule2.VisibleIndex = 2
        Me.colDeDupRule2.Width = 445
        '
        'colDBDeDupRule
        '
        Me.colDBDeDupRule.Caption = "DBDeDupRule"
        Me.colDBDeDupRule.FieldName = "DBDeDupRule"
        Me.colDBDeDupRule.Name = "colDBDeDupRule"
        '
        'lstSourceTemplateColsForFileDeDup
        '
        Me.lstSourceTemplateColsForFileDeDup.FormattingEnabled = True
        Me.lstSourceTemplateColsForFileDeDup.Location = New System.Drawing.Point(6, 29)
        Me.lstSourceTemplateColsForFileDeDup.Name = "lstSourceTemplateColsForFileDeDup"
        Me.lstSourceTemplateColsForFileDeDup.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.lstSourceTemplateColsForFileDeDup.Size = New System.Drawing.Size(667, 121)
        Me.lstSourceTemplateColsForFileDeDup.TabIndex = 6
        '
        'Label14
        '
        Me.Label14.AutoSize = True
        Me.Label14.Location = New System.Drawing.Point(6, 13)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(257, 13)
        Me.Label14.TabIndex = 4
        Me.Label14.Text = "Select the columns that define a duplicate file record."
        '
        'cmdClearDeDupRule
        '
        Me.cmdClearDeDupRule.Location = New System.Drawing.Point(601, 156)
        Me.cmdClearDeDupRule.Name = "cmdClearDeDupRule"
        Me.cmdClearDeDupRule.Size = New System.Drawing.Size(75, 23)
        Me.cmdClearDeDupRule.TabIndex = 1
        Me.cmdClearDeDupRule.Text = "Clear Rule"
        Me.cmdClearDeDupRule.UseVisualStyleBackColor = True
        '
        'cmdAddDeDupRule
        '
        Me.cmdAddDeDupRule.Location = New System.Drawing.Point(520, 157)
        Me.cmdAddDeDupRule.Name = "cmdAddDeDupRule"
        Me.cmdAddDeDupRule.Size = New System.Drawing.Size(75, 23)
        Me.cmdAddDeDupRule.TabIndex = 0
        Me.cmdAddDeDupRule.Text = "Add Rule"
        Me.cmdAddDeDupRule.UseVisualStyleBackColor = True
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "Text Files|*.txt|CSV Files|*.csv"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        Me.OpenFileDialog1.Filter = "Text Files|*.txt|CSV Files|*.csv"
        '
        'ImportExportSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ImportExportSection"
        Me.Size = New System.Drawing.Size(726, 688)
        Me.SectionPanel1.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        CType(Me.grdExportFiles, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsExportFiles, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdExportFilesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.TabPage2.ResumeLayout(False)
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        CType(Me.grdExportFileWithRules, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdExportFileWithRulesView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage3.ResumeLayout(False)
        Me.GroupBox5.ResumeLayout(False)
        Me.GroupBox5.PerformLayout()
        Me.GroupBox6.ResumeLayout(False)
        Me.GroupBox6.PerformLayout()
        CType(Me.grdExportFileWithDeDupRules, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdExportFileWithDeDupRulesView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents cmdSourceFile As System.Windows.Forms.Button
    Friend WithEvents cboSourceTemplates As System.Windows.Forms.ComboBox
    Friend WithEvents txtSourceFile As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtExportDefinitionName As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents cmdAddExportFile As System.Windows.Forms.Button
    Friend WithEvents cboExportTemplates As System.Windows.Forms.ComboBox
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents cmdOK As System.Windows.Forms.Button
    Friend WithEvents cmdRun As System.Windows.Forms.Button
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents grdExportFiles As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdExportFilesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridView2 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents txtSourceFileName As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents cmdExportPath As System.Windows.Forms.Button
    Friend WithEvents txtExportFilePath As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents txtExportFileName As System.Windows.Forms.TextBox
    Friend WithEvents bsExportFiles As System.Windows.Forms.BindingSource
    Friend WithEvents cmdDeleteExportFile As System.Windows.Forms.Button
    Friend WithEvents cmdEditExportFile As System.Windows.Forms.Button
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents grdExportFileWithRules As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdExportFileWithRulesView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridView3 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents txtSplitRule As System.Windows.Forms.TextBox
    Friend WithEvents cmdClearRule As System.Windows.Forms.Button
    Friend WithEvents cmdAddRule As System.Windows.Forms.Button
    Friend WithEvents GroupBox5 As System.Windows.Forms.GroupBox
    Friend WithEvents grdExportFileWithDeDupRules As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdExportFileWithDeDupRulesView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents cmdClearDeDupRule As System.Windows.Forms.Button
    Friend WithEvents cmdAddDeDupRule As System.Windows.Forms.Button
    Friend WithEvents chkHasHeader As System.Windows.Forms.CheckBox
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents lstSourceTemplateColsForFileDeDup As System.Windows.Forms.ListBox
    Friend WithEvents colFileID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportDefinitionID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPathandFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSourceFile As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colReferenceGuid As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSplitRule As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDeDupRule As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDBDeDupRule1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportDefinitionID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPathandFileName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSourceFile1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colReferenceGuid1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSplitRule1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDeDupRule1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDBDeDupRule2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileID2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportDefinitionID2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPathandFileName2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsSourceFile2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colReferenceGuid2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSplitRule2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDeDupRule2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDBDeDupRule As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GroupBox6 As System.Windows.Forms.GroupBox
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents lblRuleName As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents chkRuleSIActive As System.Windows.Forms.CheckBox
    Friend WithEvents txtSearchCriteria As System.Windows.Forms.TextBox
    Friend WithEvents lblClientIDs As System.Windows.Forms.Label
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents cboSIStartDate As System.Windows.Forms.ComboBox
    Friend WithEvents Label13 As System.Windows.Forms.Label

End Class
