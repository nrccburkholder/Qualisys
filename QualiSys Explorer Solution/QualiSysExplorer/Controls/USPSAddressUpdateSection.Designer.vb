<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class USPSAddressUpdateSection
    Inherits QualiSys.QualiSysExplorer.ContentControlBase

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim GridLevelNode1 As DevExpress.XtraGrid.GridLevelNode = New DevExpress.XtraGrid.GridLevelNode()
        Me.gvOldAddresses = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridColumn21 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn13 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn14 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn15 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn16 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn17 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn18 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn19 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn20 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.gcPartialMatches = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.GridControlOverride()
        Me.gvPartialMatches = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridView()
        Me.colStatusImage = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.RepositoryItemPictureEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemPictureEdit()
        Me.colPartialMatchId = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colPartialMatchDateReceived = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colPartialMatchStudyId = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colPartialMatchPopId = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colPartialMatchLithocode = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colPartialMatchUpdate = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.RepositoryItemCheckEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit()
        Me.colPartialMatchIgnore = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.colRightFill = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.FillGridColumn1 = New Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn()
        Me.gvNewAddresses = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.btnUpdate = New System.Windows.Forms.Button()
        Me.USPSSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.ActionPanel = New System.Windows.Forms.Panel()
        Me.TopPanel = New System.Windows.Forms.Panel()
        Me.btnExportToExcel = New System.Windows.Forms.Button()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.chkIgnoreAll = New DevExpress.XtraEditors.CheckEdit()
        Me.chkUpdateAll = New DevExpress.XtraEditors.CheckEdit()
        Me.btnExpandAll = New System.Windows.Forms.Button()
        Me.ToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripMenuItem2 = New System.Windows.Forms.ToolStripMenuItem()
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog()
        CType(Me.gvOldAddresses, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gcPartialMatches, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvPartialMatches, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemPictureEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvNewAddresses, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BottomPanel.SuspendLayout()
        Me.USPSSectionPanel.SuspendLayout()
        Me.ActionPanel.SuspendLayout()
        Me.TopPanel.SuspendLayout()
        CType(Me.chkIgnoreAll.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.chkUpdateAll.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'gvOldAddresses
        '
        Me.gvOldAddresses.Appearance.Row.BackColor = System.Drawing.Color.White
        Me.gvOldAddresses.Appearance.Row.BorderColor = System.Drawing.SystemColors.ActiveBorder
        Me.gvOldAddresses.Appearance.Row.Options.UseBackColor = True
        Me.gvOldAddresses.Appearance.Row.Options.UseBorderColor = True
        Me.gvOldAddresses.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.GridColumn21, Me.GridColumn13, Me.GridColumn14, Me.GridColumn15, Me.GridColumn16, Me.GridColumn17, Me.GridColumn18, Me.GridColumn19, Me.GridColumn20})
        Me.gvOldAddresses.GridControl = Me.gcPartialMatches
        Me.gvOldAddresses.Name = "gvOldAddresses"
        Me.gvOldAddresses.OptionsBehavior.Editable = False
        Me.gvOldAddresses.OptionsFilter.AllowFilterEditor = False
        Me.gvOldAddresses.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.gvOldAddresses.OptionsView.EnableAppearanceEvenRow = True
        Me.gvOldAddresses.OptionsView.EnableAppearanceOddRow = True
        Me.gvOldAddresses.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.gvOldAddresses.OptionsView.ShowGroupPanel = False
        Me.gvOldAddresses.OptionsView.ShowIndicator = False
        '
        'GridColumn21
        '
        Me.GridColumn21.Caption = "GridColumn21"
        Me.GridColumn21.FieldName = "AddressType"
        Me.GridColumn21.Name = "GridColumn21"
        Me.GridColumn21.OptionsColumn.AllowEdit = False
        Me.GridColumn21.OptionsColumn.ShowCaption = False
        Me.GridColumn21.Visible = True
        Me.GridColumn21.VisibleIndex = 0
        Me.GridColumn21.Width = 50
        '
        'GridColumn13
        '
        Me.GridColumn13.Caption = "First Name"
        Me.GridColumn13.FieldName = "FName"
        Me.GridColumn13.Name = "GridColumn13"
        Me.GridColumn13.OptionsColumn.AllowEdit = False
        Me.GridColumn13.Visible = True
        Me.GridColumn13.VisibleIndex = 1
        '
        'GridColumn14
        '
        Me.GridColumn14.Caption = "Last Name"
        Me.GridColumn14.FieldName = "LName"
        Me.GridColumn14.Name = "GridColumn14"
        Me.GridColumn14.OptionsColumn.AllowEdit = False
        Me.GridColumn14.Visible = True
        Me.GridColumn14.VisibleIndex = 2
        '
        'GridColumn15
        '
        Me.GridColumn15.Caption = "Address"
        Me.GridColumn15.FieldName = "Addr"
        Me.GridColumn15.Name = "GridColumn15"
        Me.GridColumn15.OptionsColumn.AllowEdit = False
        Me.GridColumn15.Visible = True
        Me.GridColumn15.VisibleIndex = 3
        '
        'GridColumn16
        '
        Me.GridColumn16.Caption = "Address 2"
        Me.GridColumn16.FieldName = "Addr2"
        Me.GridColumn16.Name = "GridColumn16"
        Me.GridColumn16.OptionsColumn.AllowEdit = False
        Me.GridColumn16.Visible = True
        Me.GridColumn16.VisibleIndex = 4
        '
        'GridColumn17
        '
        Me.GridColumn17.Caption = "City"
        Me.GridColumn17.FieldName = "City"
        Me.GridColumn17.Name = "GridColumn17"
        Me.GridColumn17.OptionsColumn.AllowEdit = False
        Me.GridColumn17.Visible = True
        Me.GridColumn17.VisibleIndex = 5
        '
        'GridColumn18
        '
        Me.GridColumn18.Caption = "State"
        Me.GridColumn18.FieldName = "State"
        Me.GridColumn18.Name = "GridColumn18"
        Me.GridColumn18.OptionsColumn.AllowEdit = False
        Me.GridColumn18.Visible = True
        Me.GridColumn18.VisibleIndex = 6
        '
        'GridColumn19
        '
        Me.GridColumn19.Caption = "Zip5"
        Me.GridColumn19.FieldName = "Zip5"
        Me.GridColumn19.Name = "GridColumn19"
        Me.GridColumn19.OptionsColumn.AllowEdit = False
        Me.GridColumn19.Visible = True
        Me.GridColumn19.VisibleIndex = 7
        '
        'GridColumn20
        '
        Me.GridColumn20.Caption = "Plus 4 Zip"
        Me.GridColumn20.FieldName = "Plus4Zip"
        Me.GridColumn20.Name = "GridColumn20"
        Me.GridColumn20.OptionsColumn.AllowEdit = False
        Me.GridColumn20.Visible = True
        Me.GridColumn20.VisibleIndex = 8
        '
        'gcPartialMatches
        '
        Me.gcPartialMatches.Dock = System.Windows.Forms.DockStyle.Fill
        GridLevelNode1.LevelTemplate = Me.gvOldAddresses
        GridLevelNode1.RelationName = "FK_Master_Detail"
        Me.gcPartialMatches.LevelTree.Nodes.AddRange(New DevExpress.XtraGrid.GridLevelNode() {GridLevelNode1})
        Me.gcPartialMatches.Location = New System.Drawing.Point(0, 44)
        Me.gcPartialMatches.MainView = Me.gvPartialMatches
        Me.gcPartialMatches.Name = "gcPartialMatches"
        Me.gcPartialMatches.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemPictureEdit1, Me.RepositoryItemCheckEdit1})
        Me.gcPartialMatches.Size = New System.Drawing.Size(975, 575)
        Me.gcPartialMatches.TabIndex = 5
        Me.gcPartialMatches.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.gvPartialMatches, Me.gvNewAddresses, Me.GridView1, Me.gvOldAddresses})
        '
        'gvPartialMatches
        '
        Me.gvPartialMatches.Appearance.EvenRow.BackColor = System.Drawing.Color.Khaki
        Me.gvPartialMatches.Appearance.EvenRow.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.OddRow.BackColor = System.Drawing.Color.LightBlue
        Me.gvPartialMatches.Appearance.OddRow.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.Row.BackColor = System.Drawing.Color.White
        Me.gvPartialMatches.Appearance.Row.BorderColor = System.Drawing.Color.FromArgb(CType(CType(64, Byte), Integer), CType(CType(64, Byte), Integer), CType(CType(64, Byte), Integer))
        Me.gvPartialMatches.Appearance.Row.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.Row.Options.UseBorderColor = True
        Me.gvPartialMatches.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colStatusImage, Me.colPartialMatchId, Me.colPartialMatchDateReceived, Me.colPartialMatchStudyId, Me.colPartialMatchPopId, Me.colPartialMatchLithocode, Me.colPartialMatchUpdate, Me.colPartialMatchIgnore, Me.colRightFill, Me.FillGridColumn1})
        Me.gvPartialMatches.DetailHeight = 550
        Me.gvPartialMatches.DetailTabHeaderLocation = DevExpress.XtraTab.TabHeaderLocation.Left
        Me.gvPartialMatches.GridControl = Me.gcPartialMatches
        Me.gvPartialMatches.Name = "gvPartialMatches"
        Me.gvPartialMatches.OptionsDetail.ShowDetailTabs = False
        Me.gvPartialMatches.OptionsPrint.PrintDetails = True
        Me.gvPartialMatches.OptionsView.ColumnAutoWidth = False
        Me.gvPartialMatches.OptionsView.ShowAutoFilterRow = True
        Me.gvPartialMatches.OptionsView.ShowFooter = True
        Me.gvPartialMatches.RowHeight = 24
        '
        'colStatusImage
        '
        Me.colStatusImage.AppearanceHeader.Options.UseTextOptions = True
        Me.colStatusImage.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colStatusImage.Caption = "Status"
        Me.colStatusImage.ColumnEdit = Me.RepositoryItemPictureEdit1
        Me.colStatusImage.FieldName = "Image"
        Me.colStatusImage.FillEmptySpace = False
        Me.colStatusImage.Name = "colStatusImage"
        Me.colStatusImage.OptionsColumn.AllowEdit = False
        Me.colStatusImage.UnboundType = DevExpress.Data.UnboundColumnType.[Object]
        Me.colStatusImage.Visible = True
        Me.colStatusImage.VisibleIndex = 0
        Me.colStatusImage.Width = 49
        '
        'RepositoryItemPictureEdit1
        '
        Me.RepositoryItemPictureEdit1.Name = "RepositoryItemPictureEdit1"
        '
        'colPartialMatchId
        '
        Me.colPartialMatchId.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchId.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchId.Caption = "Id"
        Me.colPartialMatchId.FieldName = "Id"
        Me.colPartialMatchId.FillEmptySpace = False
        Me.colPartialMatchId.Name = "colPartialMatchId"
        Me.colPartialMatchId.OptionsColumn.AllowEdit = False
        Me.colPartialMatchId.OptionsFilter.AllowAutoFilter = False
        Me.colPartialMatchId.OptionsFilter.AllowFilter = False
        Me.colPartialMatchId.Visible = True
        Me.colPartialMatchId.VisibleIndex = 1
        Me.colPartialMatchId.Width = 55
        '
        'colPartialMatchDateReceived
        '
        Me.colPartialMatchDateReceived.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchDateReceived.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchDateReceived.Caption = "Date Received"
        Me.colPartialMatchDateReceived.FieldName = "DateCreated"
        Me.colPartialMatchDateReceived.FillEmptySpace = False
        Me.colPartialMatchDateReceived.Name = "colPartialMatchDateReceived"
        Me.colPartialMatchDateReceived.OptionsColumn.AllowEdit = False
        Me.colPartialMatchDateReceived.OptionsFilter.ShowEmptyDateFilter = True
        Me.colPartialMatchDateReceived.Visible = True
        Me.colPartialMatchDateReceived.VisibleIndex = 2
        Me.colPartialMatchDateReceived.Width = 100
        '
        'colPartialMatchStudyId
        '
        Me.colPartialMatchStudyId.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchStudyId.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchStudyId.Caption = "Study Id"
        Me.colPartialMatchStudyId.FieldName = "Study_id"
        Me.colPartialMatchStudyId.FillEmptySpace = False
        Me.colPartialMatchStudyId.Name = "colPartialMatchStudyId"
        Me.colPartialMatchStudyId.OptionsColumn.AllowEdit = False
        Me.colPartialMatchStudyId.Visible = True
        Me.colPartialMatchStudyId.VisibleIndex = 3
        Me.colPartialMatchStudyId.Width = 67
        '
        'colPartialMatchPopId
        '
        Me.colPartialMatchPopId.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchPopId.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchPopId.Caption = "Pop Id"
        Me.colPartialMatchPopId.FieldName = "Pop_id"
        Me.colPartialMatchPopId.FillEmptySpace = False
        Me.colPartialMatchPopId.Name = "colPartialMatchPopId"
        Me.colPartialMatchPopId.OptionsColumn.AllowEdit = False
        Me.colPartialMatchPopId.Visible = True
        Me.colPartialMatchPopId.VisibleIndex = 4
        Me.colPartialMatchPopId.Width = 69
        '
        'colPartialMatchLithocode
        '
        Me.colPartialMatchLithocode.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchLithocode.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchLithocode.Caption = "Lithocode"
        Me.colPartialMatchLithocode.FieldName = "Lithocode"
        Me.colPartialMatchLithocode.FillEmptySpace = False
        Me.colPartialMatchLithocode.Name = "colPartialMatchLithocode"
        Me.colPartialMatchLithocode.OptionsColumn.AllowEdit = False
        Me.colPartialMatchLithocode.Visible = True
        Me.colPartialMatchLithocode.VisibleIndex = 5
        Me.colPartialMatchLithocode.Width = 102
        '
        'colPartialMatchUpdate
        '
        Me.colPartialMatchUpdate.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchUpdate.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchUpdate.Caption = "Update"
        Me.colPartialMatchUpdate.ColumnEdit = Me.RepositoryItemCheckEdit1
        Me.colPartialMatchUpdate.FieldName = "Updated"
        Me.colPartialMatchUpdate.FillEmptySpace = False
        Me.colPartialMatchUpdate.Name = "colPartialMatchUpdate"
        Me.colPartialMatchUpdate.Visible = True
        Me.colPartialMatchUpdate.VisibleIndex = 6
        Me.colPartialMatchUpdate.Width = 87
        '
        'RepositoryItemCheckEdit1
        '
        Me.RepositoryItemCheckEdit1.AutoHeight = False
        Me.RepositoryItemCheckEdit1.Name = "RepositoryItemCheckEdit1"
        Me.RepositoryItemCheckEdit1.ValueChecked = "1"
        Me.RepositoryItemCheckEdit1.ValueUnchecked = "0"
        '
        'colPartialMatchIgnore
        '
        Me.colPartialMatchIgnore.AppearanceHeader.Options.UseTextOptions = True
        Me.colPartialMatchIgnore.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colPartialMatchIgnore.Caption = "Ignore"
        Me.colPartialMatchIgnore.ColumnEdit = Me.RepositoryItemCheckEdit1
        Me.colPartialMatchIgnore.FieldName = "Ignored"
        Me.colPartialMatchIgnore.FillEmptySpace = False
        Me.colPartialMatchIgnore.Name = "colPartialMatchIgnore"
        Me.colPartialMatchIgnore.Visible = True
        Me.colPartialMatchIgnore.VisibleIndex = 7
        Me.colPartialMatchIgnore.Width = 89
        '
        'colRightFill
        '
        Me.colRightFill.AppearanceCell.BorderColor = System.Drawing.Color.White
        Me.colRightFill.AppearanceCell.Options.UseBorderColor = True
        Me.colRightFill.Caption = "GridColumn6"
        Me.colRightFill.FillEmptySpace = True
        Me.colRightFill.Name = "colRightFill"
        Me.colRightFill.OptionsColumn.AllowEdit = False
        Me.colRightFill.OptionsColumn.ShowCaption = False
        Me.colRightFill.SummaryItem.DisplayFormat = "Record Count = {0:n0}"
        Me.colRightFill.SummaryItem.FieldName = "Id"
        Me.colRightFill.SummaryItem.SummaryType = DevExpress.Data.SummaryItemType.Count
        Me.colRightFill.Visible = True
        Me.colRightFill.VisibleIndex = 8
        Me.colRightFill.Width = 319
        '
        'FillGridColumn1
        '
        Me.FillGridColumn1.Caption = "FillGridColumn1"
        Me.FillGridColumn1.FieldName = "UpdateStatus"
        Me.FillGridColumn1.FillEmptySpace = False
        Me.FillGridColumn1.Name = "FillGridColumn1"
        '
        'gvNewAddresses
        '
        Me.gvNewAddresses.GridControl = Me.gcPartialMatches
        Me.gvNewAddresses.Name = "gvNewAddresses"
        Me.gvNewAddresses.OptionsFilter.AllowFilterEditor = False
        Me.gvNewAddresses.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.gvNewAddresses.OptionsView.ShowGroupPanel = False
        '
        'GridView1
        '
        Me.GridView1.GridControl = Me.gcPartialMatches
        Me.GridView1.Name = "GridView1"
        '
        'BottomPanel
        '
        Me.BottomPanel.Controls.Add(Me.btnUpdate)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 647)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(977, 49)
        Me.BottomPanel.TabIndex = 1
        '
        'btnUpdate
        '
        Me.btnUpdate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnUpdate.Location = New System.Drawing.Point(878, 12)
        Me.btnUpdate.Name = "btnUpdate"
        Me.btnUpdate.Size = New System.Drawing.Size(75, 23)
        Me.btnUpdate.TabIndex = 0
        Me.btnUpdate.Text = "Update"
        Me.btnUpdate.UseVisualStyleBackColor = True
        '
        'USPSSectionPanel
        '
        Me.USPSSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.USPSSectionPanel.Caption = "Update Addresses"
        Me.USPSSectionPanel.Controls.Add(Me.ActionPanel)
        Me.USPSSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.USPSSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.USPSSectionPanel.Name = "USPSSectionPanel"
        Me.USPSSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.USPSSectionPanel.ShowCaption = True
        Me.USPSSectionPanel.Size = New System.Drawing.Size(977, 647)
        Me.USPSSectionPanel.TabIndex = 4
        '
        'ActionPanel
        '
        Me.ActionPanel.Controls.Add(Me.gcPartialMatches)
        Me.ActionPanel.Controls.Add(Me.TopPanel)
        Me.ActionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ActionPanel.Location = New System.Drawing.Point(1, 27)
        Me.ActionPanel.Name = "ActionPanel"
        Me.ActionPanel.Size = New System.Drawing.Size(975, 619)
        Me.ActionPanel.TabIndex = 1
        '
        'TopPanel
        '
        Me.TopPanel.Controls.Add(Me.btnExportToExcel)
        Me.TopPanel.Controls.Add(Me.Label2)
        Me.TopPanel.Controls.Add(Me.Label1)
        Me.TopPanel.Controls.Add(Me.chkIgnoreAll)
        Me.TopPanel.Controls.Add(Me.chkUpdateAll)
        Me.TopPanel.Controls.Add(Me.btnExpandAll)
        Me.TopPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.TopPanel.Location = New System.Drawing.Point(0, 0)
        Me.TopPanel.Name = "TopPanel"
        Me.TopPanel.Size = New System.Drawing.Size(975, 44)
        Me.TopPanel.TabIndex = 4
        '
        'btnExportToExcel
        '
        Me.btnExportToExcel.Image = Global.Nrc.QualiSys.QualiSysExplorer.My.Resources.Resources.Excel16
        Me.btnExportToExcel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btnExportToExcel.Location = New System.Drawing.Point(111, 15)
        Me.btnExportToExcel.Name = "btnExportToExcel"
        Me.btnExportToExcel.Size = New System.Drawing.Size(101, 23)
        Me.btnExportToExcel.TabIndex = 7
        Me.btnExportToExcel.Text = "Export to Excel"
        Me.btnExportToExcel.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.btnExportToExcel.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(567, 6)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(51, 13)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "Ignore All"
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(473, 6)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(56, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Update All"
        '
        'chkIgnoreAll
        '
        Me.chkIgnoreAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.chkIgnoreAll.Location = New System.Drawing.Point(556, 22)
        Me.chkIgnoreAll.Name = "chkIgnoreAll"
        Me.chkIgnoreAll.Properties.Caption = "CheckEdit2"
        Me.chkIgnoreAll.Properties.GlyphAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.chkIgnoreAll.Size = New System.Drawing.Size(75, 19)
        Me.chkIgnoreAll.TabIndex = 4
        '
        'chkUpdateAll
        '
        Me.chkUpdateAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.chkUpdateAll.Location = New System.Drawing.Point(465, 22)
        Me.chkUpdateAll.Name = "chkUpdateAll"
        Me.chkUpdateAll.Properties.Caption = "CheckEdit1"
        Me.chkUpdateAll.Properties.GlyphAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.chkUpdateAll.Size = New System.Drawing.Size(75, 19)
        Me.chkUpdateAll.TabIndex = 3
        '
        'btnExpandAll
        '
        Me.btnExpandAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnExpandAll.Location = New System.Drawing.Point(19, 15)
        Me.btnExpandAll.Name = "btnExpandAll"
        Me.btnExpandAll.Size = New System.Drawing.Size(75, 23)
        Me.btnExpandAll.TabIndex = 0
        Me.btnExpandAll.Text = "Expand All"
        Me.btnExpandAll.UseVisualStyleBackColor = True
        '
        'ToolStripMenuItem1
        '
        Me.ToolStripMenuItem1.Name = "ToolStripMenuItem1"
        Me.ToolStripMenuItem1.Size = New System.Drawing.Size(183, 22)
        Me.ToolStripMenuItem1.Text = "ToolStripMenuItem1"
        '
        'ToolStripMenuItem2
        '
        Me.ToolStripMenuItem2.Name = "ToolStripMenuItem2"
        Me.ToolStripMenuItem2.Size = New System.Drawing.Size(183, 22)
        Me.ToolStripMenuItem2.Text = "ToolStripMenuItem2"
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripMenuItem1, Me.ToolStripMenuItem2})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(184, 48)
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "Excel 97-2003 (*.xls)|*.xls|Excel Files (*.xlsx)|*.xlsx"
        '
        'USPSAddressUpdateSection
        '
        Me.Controls.Add(Me.USPSSectionPanel)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "USPSAddressUpdateSection"
        Me.Size = New System.Drawing.Size(977, 696)
        CType(Me.gvOldAddresses, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gcPartialMatches, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvPartialMatches, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemPictureEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvNewAddresses, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BottomPanel.ResumeLayout(False)
        Me.USPSSectionPanel.ResumeLayout(False)
        Me.ActionPanel.ResumeLayout(False)
        Me.TopPanel.ResumeLayout(False)
        Me.TopPanel.PerformLayout()
        CType(Me.chkIgnoreAll.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.chkUpdateAll.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents USPSSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnUpdate As System.Windows.Forms.Button
    Friend WithEvents ActionPanel As System.Windows.Forms.Panel
    Friend WithEvents gvOldAddresses As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridColumn21 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn13 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn14 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn15 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn16 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn17 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn18 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn19 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn20 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents gvNewAddresses As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents TopPanel As System.Windows.Forms.Panel
    Friend WithEvents btnExpandAll As System.Windows.Forms.Button
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents RepositoryItemPictureEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemPictureEdit
    Friend WithEvents colRightFill As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchId As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchDateReceived As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchStudyId As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchPopId As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchLithocode As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colStatusImage As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents gcPartialMatches As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.GridControlOverride
    Friend WithEvents gvPartialMatches As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridView
    Friend WithEvents RepositoryItemCheckEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents colPartialMatchUpdate As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents colPartialMatchIgnore As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents ToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripMenuItem2 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents chkIgnoreAll As DevExpress.XtraEditors.CheckEdit
    Friend WithEvents chkUpdateAll As DevExpress.XtraEditors.CheckEdit
    Friend WithEvents FillGridColumn1 As Nrc.QualiSys.QualiSysExplorer.FillEmptySpaceGridColumn.FillGridColumn
    Friend WithEvents btnExportToExcel As System.Windows.Forms.Button
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog

End Class
