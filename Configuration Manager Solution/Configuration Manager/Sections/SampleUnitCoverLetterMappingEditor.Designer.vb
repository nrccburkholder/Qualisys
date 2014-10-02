<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SampleUnitCoverLetterMappingEditor
    Inherits System.Windows.Forms.UserControl

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
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SampleUnitCoverLetterMappingEditor))
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.ApplyButton = New System.Windows.Forms.Button()
        Me.OKButton = New System.Windows.Forms.Button()
        Me.CancelButton = New System.Windows.Forms.Button()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.SampleUnitTreeView = New DevExpress.XtraTreeList.TreeList()
        Me.TreeListColumn1 = New DevExpress.XtraTreeList.Columns.TreeListColumn()
        Me.TreeListColumn2 = New DevExpress.XtraTreeList.Columns.TreeListColumn()
        Me.HeaderStrip2 = New Nrc.Framework.WinForms.HeaderStrip()
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel()
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnSampleUnitsClearSelections = New System.Windows.Forms.ToolStripButton()
        Me.SplitContainer2 = New System.Windows.Forms.SplitContainer()
        Me.SplitContainer3 = New System.Windows.Forms.SplitContainer()
        Me.gcCoverLetters = New DevExpress.XtraGrid.GridControl()
        Me.CoverLetterBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.gvCoverLetters = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridColumn3 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn4 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn10 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn11 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.AvailableSectionLabelLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip()
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel()
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnCoverLettersClearnSelections = New System.Windows.Forms.ToolStripButton()
        Me.gcArtifacts = New DevExpress.XtraGrid.GridControl()
        Me.ArtifactBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.gvArtifacts = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridColumn1 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn5 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn12 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn13 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.RepositoryItemLookUpEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.HeaderStrip3 = New Nrc.Framework.WinForms.HeaderStrip()
        Me.ToolStripLabel3 = New System.Windows.Forms.ToolStripLabel()
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnArtifactsClearSelections = New System.Windows.Forms.ToolStripButton()
        Me.gcMappings = New DevExpress.XtraGrid.GridControl()
        Me.UnMapContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.UnMapToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.gvMappings = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.colStatusImage = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.RepositoryItemPictureEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemPictureEdit()
        Me.SampleUnit_name = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.CoverLetter_name = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.CoverLetterItem_label = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.Artifact_name = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.Artifact_label = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.SampleUnit_Id = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.SEL_Cover_CoverID = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.CoverLetterItem_id = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.SEL_Cover_CoverID_Artifact = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.SEL_TextBox_QPC_ID_Artifact = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.CoverLetterItemType_id = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.Survey_Id = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.CoverLetterItemArtifactUnitMapping_id = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.NeedDelete = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.UniqueID = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.HeaderStrip4 = New Nrc.Framework.WinForms.HeaderStrip()
        Me.ToolStripLabel4 = New System.Windows.Forms.ToolStripLabel()
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnSelectAllMappings = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator5 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnUnselectAllMappings = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator6 = New System.Windows.Forms.ToolStripSeparator()
        Me.btnShowAllMappings = New System.Windows.Forms.ToolStripButton()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.btnUnmap = New System.Windows.Forms.Button()
        Me.btnMap = New System.Windows.Forms.Button()
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar()
        Me.statusStripMappings = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.BottomPanel.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        CType(Me.SampleUnitTreeView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip2.SuspendLayout()
        Me.SplitContainer2.Panel1.SuspendLayout()
        Me.SplitContainer2.Panel2.SuspendLayout()
        Me.SplitContainer2.SuspendLayout()
        Me.SplitContainer3.Panel1.SuspendLayout()
        Me.SplitContainer3.Panel2.SuspendLayout()
        Me.SplitContainer3.SuspendLayout()
        CType(Me.gcCoverLetters, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CoverLetterBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvCoverLetters, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.AvailableSectionLabelLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip1.SuspendLayout()
        CType(Me.gcArtifacts, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ArtifactBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvArtifacts, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemLookUpEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip3.SuspendLayout()
        CType(Me.gcMappings, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UnMapContextMenu.SuspendLayout()
        CType(Me.gvMappings, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemPictureEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip4.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.statusStripMappings.SuspendLayout()
        Me.SuspendLayout()
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ApplyButton)
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 500)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(686, 35)
        Me.BottomPanel.TabIndex = 2
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.Location = New System.Drawing.Point(378, 5)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 2
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(524, 4)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(605, 4)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'SplitContainer1
        '
        Me.SplitContainer1.BackColor = System.Drawing.SystemColors.Control
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 20)
        Me.SplitContainer1.Name = "SplitContainer1"
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.SampleUnitTreeView)
        Me.SplitContainer1.Panel1.Controls.Add(Me.HeaderStrip2)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.SplitContainer2)
        Me.SplitContainer1.Size = New System.Drawing.Size(686, 480)
        Me.SplitContainer1.SplitterDistance = 121
        Me.SplitContainer1.TabIndex = 38
        '
        'SampleUnitTreeView
        '
        Me.SampleUnitTreeView.Columns.AddRange(New DevExpress.XtraTreeList.Columns.TreeListColumn() {Me.TreeListColumn1, Me.TreeListColumn2})
        Me.SampleUnitTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleUnitTreeView.Location = New System.Drawing.Point(0, 21)
        Me.SampleUnitTreeView.Name = "SampleUnitTreeView"
        Me.SampleUnitTreeView.OptionsBehavior.Editable = False
        Me.SampleUnitTreeView.OptionsBehavior.EnableFiltering = True
        Me.SampleUnitTreeView.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.SampleUnitTreeView.OptionsSelection.MultiSelect = True
        Me.SampleUnitTreeView.OptionsSelection.UseIndicatorForSelection = True
        Me.SampleUnitTreeView.OptionsView.ShowHorzLines = False
        Me.SampleUnitTreeView.OptionsView.ShowRoot = False
        Me.SampleUnitTreeView.OptionsView.ShowVertLines = False
        Me.SampleUnitTreeView.Size = New System.Drawing.Size(121, 459)
        Me.SampleUnitTreeView.TabIndex = 4
        Me.SampleUnitTreeView.TreeLineStyle = DevExpress.XtraTreeList.LineStyle.Dark
        '
        'TreeListColumn1
        '
        Me.TreeListColumn1.Caption = "Sample Unit"
        Me.TreeListColumn1.FieldName = "SampleUnitName"
        Me.TreeListColumn1.Name = "TreeListColumn1"
        Me.TreeListColumn1.Visible = True
        Me.TreeListColumn1.VisibleIndex = 0
        '
        'TreeListColumn2
        '
        Me.TreeListColumn2.Caption = "CAHPS Type"
        Me.TreeListColumn2.FieldName = "CAHPSType"
        Me.TreeListColumn2.Name = "TreeListColumn2"
        Me.TreeListColumn2.Visible = True
        Me.TreeListColumn2.VisibleIndex = 1
        '
        'HeaderStrip2
        '
        Me.HeaderStrip2.AutoSize = False
        Me.HeaderStrip2.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.HeaderStrip2.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip2.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2, Me.ToolStripSeparator2, Me.btnSampleUnitsClearSelections})
        Me.HeaderStrip2.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip2.Name = "HeaderStrip2"
        Me.HeaderStrip2.Size = New System.Drawing.Size(121, 21)
        Me.HeaderStrip2.TabIndex = 3
        Me.HeaderStrip2.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(76, 18)
        Me.ToolStripLabel2.Text = "Sample Units"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 21)
        '
        'btnSampleUnitsClearSelections
        '
        Me.btnSampleUnitsClearSelections.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnSampleUnitsClearSelections.Image = CType(resources.GetObject("btnSampleUnitsClearSelections.Image"), System.Drawing.Image)
        Me.btnSampleUnitsClearSelections.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnSampleUnitsClearSelections.Name = "btnSampleUnitsClearSelections"
        Me.btnSampleUnitsClearSelections.Size = New System.Drawing.Size(94, 19)
        Me.btnSampleUnitsClearSelections.Text = "Clear Selections"
        '
        'SplitContainer2
        '
        Me.SplitContainer2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer2.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer2.Name = "SplitContainer2"
        Me.SplitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer2.Panel1
        '
        Me.SplitContainer2.Panel1.Controls.Add(Me.SplitContainer3)
        '
        'SplitContainer2.Panel2
        '
        Me.SplitContainer2.Panel2.Controls.Add(Me.statusStripMappings)
        Me.SplitContainer2.Panel2.Controls.Add(Me.gcMappings)
        Me.SplitContainer2.Panel2.Controls.Add(Me.HeaderStrip4)
        Me.SplitContainer2.Panel2.Controls.Add(Me.Panel1)
        Me.SplitContainer2.Size = New System.Drawing.Size(561, 480)
        Me.SplitContainer2.SplitterDistance = 241
        Me.SplitContainer2.TabIndex = 0
        '
        'SplitContainer3
        '
        Me.SplitContainer3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer3.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer3.Name = "SplitContainer3"
        '
        'SplitContainer3.Panel1
        '
        Me.SplitContainer3.Panel1.Controls.Add(Me.gcCoverLetters)
        Me.SplitContainer3.Panel1.Controls.Add(Me.HeaderStrip1)
        '
        'SplitContainer3.Panel2
        '
        Me.SplitContainer3.Panel2.Controls.Add(Me.gcArtifacts)
        Me.SplitContainer3.Panel2.Controls.Add(Me.HeaderStrip3)
        Me.SplitContainer3.Size = New System.Drawing.Size(561, 241)
        Me.SplitContainer3.SplitterDistance = 266
        Me.SplitContainer3.TabIndex = 0
        '
        'gcCoverLetters
        '
        Me.gcCoverLetters.DataSource = Me.CoverLetterBindingSource
        Me.gcCoverLetters.Dock = System.Windows.Forms.DockStyle.Fill
        Me.gcCoverLetters.Location = New System.Drawing.Point(0, 21)
        Me.gcCoverLetters.MainView = Me.gvCoverLetters
        Me.gcCoverLetters.Name = "gcCoverLetters"
        Me.gcCoverLetters.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.AvailableSectionLabelLookUpEdit})
        Me.gcCoverLetters.Size = New System.Drawing.Size(266, 220)
        Me.gcCoverLetters.TabIndex = 4
        Me.gcCoverLetters.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.gvCoverLetters})
        '
        'gvCoverLetters
        '
        Me.gvCoverLetters.Appearance.FocusedCell.BackColor = System.Drawing.SystemColors.MenuHighlight
        Me.gvCoverLetters.Appearance.FocusedCell.Options.UseBackColor = True
        Me.gvCoverLetters.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.GridColumn3, Me.GridColumn4, Me.GridColumn10, Me.GridColumn11})
        Me.gvCoverLetters.GridControl = Me.gcCoverLetters
        Me.gvCoverLetters.Name = "gvCoverLetters"
        Me.gvCoverLetters.OptionsBehavior.Editable = False
        Me.gvCoverLetters.OptionsBehavior.ReadOnly = True
        Me.gvCoverLetters.OptionsCustomization.AllowFilter = False
        Me.gvCoverLetters.OptionsDetail.ShowDetailTabs = False
        Me.gvCoverLetters.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.gvCoverLetters.OptionsSelection.EnableAppearanceHideSelection = False
        Me.gvCoverLetters.OptionsSelection.MultiSelect = True
        Me.gvCoverLetters.OptionsView.EnableAppearanceEvenRow = True
        Me.gvCoverLetters.OptionsView.ShowAutoFilterRow = True
        '
        'GridColumn3
        '
        Me.GridColumn3.Caption = "Cover Letter Name"
        Me.GridColumn3.FieldName = "CoverLetterName"
        Me.GridColumn3.Name = "GridColumn3"
        Me.GridColumn3.Visible = True
        Me.GridColumn3.VisibleIndex = 0
        '
        'GridColumn4
        '
        Me.GridColumn4.Caption = "Cover Letter Item"
        Me.GridColumn4.FieldName = "Label"
        Me.GridColumn4.Name = "GridColumn4"
        Me.GridColumn4.Visible = True
        Me.GridColumn4.VisibleIndex = 1
        '
        'GridColumn10
        '
        Me.GridColumn10.Caption = "GridColumn10"
        Me.GridColumn10.FieldName = "CoverID"
        Me.GridColumn10.Name = "GridColumn10"
        '
        'GridColumn11
        '
        Me.GridColumn11.Caption = "GridColumn11"
        Me.GridColumn11.FieldName = "ItemID"
        Me.GridColumn11.Name = "GridColumn11"
        '
        'AvailableSectionLabelLookUpEdit
        '
        Me.AvailableSectionLabelLookUpEdit.AutoHeight = False
        Me.AvailableSectionLabelLookUpEdit.DisplayMember = "Label"
        Me.AvailableSectionLabelLookUpEdit.Name = "AvailableSectionLabelLookUpEdit"
        Me.AvailableSectionLabelLookUpEdit.ReadOnly = True
        Me.AvailableSectionLabelLookUpEdit.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.AvailableSectionLabelLookUpEdit.ValueMember = "Id"
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.ToolStripSeparator3, Me.btnCoverLettersClearnSelections})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(266, 21)
        Me.HeaderStrip1.TabIndex = 3
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(76, 18)
        Me.ToolStripLabel1.Text = "Cover Letters"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 21)
        '
        'btnCoverLettersClearnSelections
        '
        Me.btnCoverLettersClearnSelections.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnCoverLettersClearnSelections.Image = CType(resources.GetObject("btnCoverLettersClearnSelections.Image"), System.Drawing.Image)
        Me.btnCoverLettersClearnSelections.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnCoverLettersClearnSelections.Name = "btnCoverLettersClearnSelections"
        Me.btnCoverLettersClearnSelections.Size = New System.Drawing.Size(94, 18)
        Me.btnCoverLettersClearnSelections.Text = "Clear Selections"
        '
        'gcArtifacts
        '
        Me.gcArtifacts.DataSource = Me.ArtifactBindingSource
        Me.gcArtifacts.Dock = System.Windows.Forms.DockStyle.Fill
        Me.gcArtifacts.Location = New System.Drawing.Point(0, 21)
        Me.gcArtifacts.MainView = Me.gvArtifacts
        Me.gcArtifacts.Name = "gcArtifacts"
        Me.gcArtifacts.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemLookUpEdit1})
        Me.gcArtifacts.Size = New System.Drawing.Size(291, 220)
        Me.gcArtifacts.TabIndex = 5
        Me.gcArtifacts.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.gvArtifacts})
        '
        'gvArtifacts
        '
        Me.gvArtifacts.Appearance.FocusedCell.BackColor = System.Drawing.SystemColors.MenuHighlight
        Me.gvArtifacts.Appearance.FocusedCell.Options.UseBackColor = True
        Me.gvArtifacts.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.GridColumn1, Me.GridColumn5, Me.GridColumn12, Me.GridColumn13})
        Me.gvArtifacts.GridControl = Me.gcArtifacts
        Me.gvArtifacts.Name = "gvArtifacts"
        Me.gvArtifacts.OptionsBehavior.Editable = False
        Me.gvArtifacts.OptionsBehavior.ReadOnly = True
        Me.gvArtifacts.OptionsCustomization.AllowFilter = False
        Me.gvArtifacts.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.gvArtifacts.OptionsSelection.EnableAppearanceHideSelection = False
        Me.gvArtifacts.OptionsView.EnableAppearanceEvenRow = True
        Me.gvArtifacts.OptionsView.ShowAutoFilterRow = True
        Me.gvArtifacts.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.GridColumn1, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'GridColumn1
        '
        Me.GridColumn1.Caption = "Artifact Name"
        Me.GridColumn1.FieldName = "CoverLetterName"
        Me.GridColumn1.Name = "GridColumn1"
        Me.GridColumn1.Visible = True
        Me.GridColumn1.VisibleIndex = 0
        '
        'GridColumn5
        '
        Me.GridColumn5.Caption = "Artifact Item"
        Me.GridColumn5.FieldName = "Label"
        Me.GridColumn5.Name = "GridColumn5"
        Me.GridColumn5.Visible = True
        Me.GridColumn5.VisibleIndex = 1
        '
        'GridColumn12
        '
        Me.GridColumn12.Caption = "GridColumn12"
        Me.GridColumn12.FieldName = "CoverID"
        Me.GridColumn12.Name = "GridColumn12"
        '
        'GridColumn13
        '
        Me.GridColumn13.Caption = "GridColumn13"
        Me.GridColumn13.FieldName = "ItemID"
        Me.GridColumn13.Name = "GridColumn13"
        '
        'RepositoryItemLookUpEdit1
        '
        Me.RepositoryItemLookUpEdit1.AutoHeight = False
        Me.RepositoryItemLookUpEdit1.DisplayMember = "Label"
        Me.RepositoryItemLookUpEdit1.Name = "RepositoryItemLookUpEdit1"
        Me.RepositoryItemLookUpEdit1.ReadOnly = True
        Me.RepositoryItemLookUpEdit1.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.RepositoryItemLookUpEdit1.ValueMember = "Id"
        '
        'HeaderStrip3
        '
        Me.HeaderStrip3.AutoSize = False
        Me.HeaderStrip3.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.HeaderStrip3.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip3.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip3.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip3.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel3, Me.ToolStripSeparator4, Me.btnArtifactsClearSelections})
        Me.HeaderStrip3.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip3.Name = "HeaderStrip3"
        Me.HeaderStrip3.Size = New System.Drawing.Size(291, 21)
        Me.HeaderStrip3.TabIndex = 3
        Me.HeaderStrip3.Text = "HeaderStrip3"
        '
        'ToolStripLabel3
        '
        Me.ToolStripLabel3.Name = "ToolStripLabel3"
        Me.ToolStripLabel3.Size = New System.Drawing.Size(51, 18)
        Me.ToolStripLabel3.Text = "Artifacts"
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(6, 21)
        '
        'btnArtifactsClearSelections
        '
        Me.btnArtifactsClearSelections.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnArtifactsClearSelections.Image = CType(resources.GetObject("btnArtifactsClearSelections.Image"), System.Drawing.Image)
        Me.btnArtifactsClearSelections.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnArtifactsClearSelections.Name = "btnArtifactsClearSelections"
        Me.btnArtifactsClearSelections.Size = New System.Drawing.Size(94, 18)
        Me.btnArtifactsClearSelections.Text = "Clear Selections"
        '
        'gcMappings
        '
        Me.gcMappings.ContextMenuStrip = Me.UnMapContextMenu
        Me.gcMappings.Dock = System.Windows.Forms.DockStyle.Fill
        Me.gcMappings.Location = New System.Drawing.Point(0, 55)
        Me.gcMappings.MainView = Me.gvMappings
        Me.gcMappings.Name = "gcMappings"
        Me.gcMappings.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemPictureEdit1})
        Me.gcMappings.Size = New System.Drawing.Size(561, 180)
        Me.gcMappings.TabIndex = 5
        Me.gcMappings.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.gvMappings})
        '
        'UnMapContextMenu
        '
        Me.UnMapContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UnMapToolStripMenuItem})
        Me.UnMapContextMenu.Name = "UnMapContextMenu"
        Me.UnMapContextMenu.Size = New System.Drawing.Size(114, 26)
        '
        'UnMapToolStripMenuItem
        '
        Me.UnMapToolStripMenuItem.Name = "UnMapToolStripMenuItem"
        Me.UnMapToolStripMenuItem.Size = New System.Drawing.Size(113, 22)
        Me.UnMapToolStripMenuItem.Text = "UnMap"
        '
        'gvMappings
        '
        Me.gvMappings.Appearance.FocusedCell.BackColor = System.Drawing.SystemColors.MenuHighlight
        Me.gvMappings.Appearance.FocusedCell.Options.UseBackColor = True
        Me.gvMappings.Appearance.FocusedRow.ForeColor = System.Drawing.Color.White
        Me.gvMappings.Appearance.FocusedRow.Options.UseForeColor = True
        Me.gvMappings.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colStatusImage, Me.SampleUnit_name, Me.CoverLetter_name, Me.CoverLetterItem_label, Me.Artifact_name, Me.Artifact_label, Me.SampleUnit_Id, Me.SEL_Cover_CoverID, Me.CoverLetterItem_id, Me.SEL_Cover_CoverID_Artifact, Me.SEL_TextBox_QPC_ID_Artifact, Me.CoverLetterItemType_id, Me.Survey_Id, Me.CoverLetterItemArtifactUnitMapping_id, Me.NeedDelete, Me.UniqueID})
        Me.gvMappings.GridControl = Me.gcMappings
        Me.gvMappings.Name = "gvMappings"
        Me.gvMappings.OptionsBehavior.Editable = False
        Me.gvMappings.OptionsCustomization.AllowFilter = False
        Me.gvMappings.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.gvMappings.OptionsSelection.EnableAppearanceHideSelection = False
        Me.gvMappings.OptionsSelection.MultiSelect = True
        Me.gvMappings.OptionsView.EnableAppearanceEvenRow = True
        Me.gvMappings.OptionsView.ShowAutoFilterRow = True
        Me.gvMappings.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.gvMappings.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.SampleUnit_name, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colStatusImage
        '
        Me.colStatusImage.ColumnEdit = Me.RepositoryItemPictureEdit1
        Me.colStatusImage.FieldName = "Image"
        Me.colStatusImage.Name = "colStatusImage"
        Me.colStatusImage.OptionsColumn.AllowEdit = False
        Me.colStatusImage.OptionsColumn.ReadOnly = True
        Me.colStatusImage.OptionsColumn.ShowCaption = False
        Me.colStatusImage.OptionsFilter.AllowAutoFilter = False
        Me.colStatusImage.OptionsFilter.AllowFilter = False
        Me.colStatusImage.OptionsFilter.ImmediateUpdateAutoFilter = False
        Me.colStatusImage.UnboundType = DevExpress.Data.UnboundColumnType.[Object]
        Me.colStatusImage.Visible = True
        Me.colStatusImage.VisibleIndex = 0
        Me.colStatusImage.Width = 20
        '
        'RepositoryItemPictureEdit1
        '
        Me.RepositoryItemPictureEdit1.Name = "RepositoryItemPictureEdit1"
        Me.RepositoryItemPictureEdit1.ReadOnly = True
        '
        'SampleUnit_name
        '
        Me.SampleUnit_name.Caption = "Sample Unit"
        Me.SampleUnit_name.FieldName = "SampleUnitDisplayName"
        Me.SampleUnit_name.Name = "SampleUnit_name"
        Me.SampleUnit_name.Visible = True
        Me.SampleUnit_name.VisibleIndex = 1
        Me.SampleUnit_name.Width = 101
        '
        'CoverLetter_name
        '
        Me.CoverLetter_name.Caption = "Cover Letter"
        Me.CoverLetter_name.FieldName = "CoverLetter_name"
        Me.CoverLetter_name.Name = "CoverLetter_name"
        Me.CoverLetter_name.Visible = True
        Me.CoverLetter_name.VisibleIndex = 2
        Me.CoverLetter_name.Width = 101
        '
        'CoverLetterItem_label
        '
        Me.CoverLetterItem_label.Caption = "Cover Letter Item"
        Me.CoverLetterItem_label.FieldName = "CoverLetterItem_label"
        Me.CoverLetterItem_label.Name = "CoverLetterItem_label"
        Me.CoverLetterItem_label.Visible = True
        Me.CoverLetterItem_label.VisibleIndex = 3
        Me.CoverLetterItem_label.Width = 101
        '
        'Artifact_name
        '
        Me.Artifact_name.Caption = "Artifact Page"
        Me.Artifact_name.FieldName = "Artifact_name"
        Me.Artifact_name.Name = "Artifact_name"
        Me.Artifact_name.Visible = True
        Me.Artifact_name.VisibleIndex = 4
        Me.Artifact_name.Width = 101
        '
        'Artifact_label
        '
        Me.Artifact_label.Caption = "Artifact Item"
        Me.Artifact_label.FieldName = "Artifact_label"
        Me.Artifact_label.Name = "Artifact_label"
        Me.Artifact_label.Visible = True
        Me.Artifact_label.VisibleIndex = 5
        Me.Artifact_label.Width = 116
        '
        'SampleUnit_Id
        '
        Me.SampleUnit_Id.Caption = "Sample Unit ID"
        Me.SampleUnit_Id.FieldName = "SampleUnit_Id"
        Me.SampleUnit_Id.Name = "SampleUnit_Id"
        '
        'SEL_Cover_CoverID
        '
        Me.SEL_Cover_CoverID.Caption = "Cover ID"
        Me.SEL_Cover_CoverID.FieldName = "CoverId"
        Me.SEL_Cover_CoverID.Name = "SEL_Cover_CoverID"
        '
        'CoverLetterItem_id
        '
        Me.CoverLetterItem_id.Caption = "Cover Letter Item ID"
        Me.CoverLetterItem_id.FieldName = "CoverLetterItem_Id"
        Me.CoverLetterItem_id.Name = "CoverLetterItem_id"
        '
        'SEL_Cover_CoverID_Artifact
        '
        Me.SEL_Cover_CoverID_Artifact.Caption = "Artifact Page Id"
        Me.SEL_Cover_CoverID_Artifact.FieldName = "ArtifactPage_Id"
        Me.SEL_Cover_CoverID_Artifact.Name = "SEL_Cover_CoverID_Artifact"
        '
        'SEL_TextBox_QPC_ID_Artifact
        '
        Me.SEL_TextBox_QPC_ID_Artifact.Caption = "GridColumn18"
        Me.SEL_TextBox_QPC_ID_Artifact.FieldName = "Artifact_Id"
        Me.SEL_TextBox_QPC_ID_Artifact.Name = "SEL_TextBox_QPC_ID_Artifact"
        '
        'CoverLetterItemType_id
        '
        Me.CoverLetterItemType_id.Caption = "GridColumn17"
        Me.CoverLetterItemType_id.FieldName = "CoverLetterItemType_Id"
        Me.CoverLetterItemType_id.Name = "CoverLetterItemType_id"
        '
        'Survey_Id
        '
        Me.Survey_Id.Caption = "GridColumn18"
        Me.Survey_Id.FieldName = "Survey_Id"
        Me.Survey_Id.Name = "Survey_Id"
        '
        'CoverLetterItemArtifactUnitMapping_id
        '
        Me.CoverLetterItemArtifactUnitMapping_id.Caption = "GridColumn19"
        Me.CoverLetterItemArtifactUnitMapping_id.FieldName = "Id"
        Me.CoverLetterItemArtifactUnitMapping_id.Name = "CoverLetterItemArtifactUnitMapping_id"
        '
        'NeedDelete
        '
        Me.NeedDelete.Caption = "GridColumn2"
        Me.NeedDelete.FieldName = "NeedsDelete"
        Me.NeedDelete.Name = "NeedDelete"
        '
        'UniqueID
        '
        Me.UniqueID.Caption = "Unique ID"
        Me.UniqueID.FieldName = "UniqueID"
        Me.UniqueID.Name = "UniqueID"
        '
        'HeaderStrip4
        '
        Me.HeaderStrip4.AutoSize = False
        Me.HeaderStrip4.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.HeaderStrip4.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip4.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip4.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip4.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel4, Me.ToolStripSeparator1, Me.btnSelectAllMappings, Me.ToolStripSeparator5, Me.btnUnselectAllMappings, Me.ToolStripSeparator6, Me.btnShowAllMappings})
        Me.HeaderStrip4.Location = New System.Drawing.Point(0, 34)
        Me.HeaderStrip4.Name = "HeaderStrip4"
        Me.HeaderStrip4.Size = New System.Drawing.Size(561, 21)
        Me.HeaderStrip4.TabIndex = 3
        Me.HeaderStrip4.Text = "HeaderStrip4"
        '
        'ToolStripLabel4
        '
        Me.ToolStripLabel4.Name = "ToolStripLabel4"
        Me.ToolStripLabel4.Size = New System.Drawing.Size(172, 18)
        Me.ToolStripLabel4.Text = "Mapped Sample Units/Artifacts"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 21)
        '
        'btnSelectAllMappings
        '
        Me.btnSelectAllMappings.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnSelectAllMappings.Image = CType(resources.GetObject("btnSelectAllMappings.Image"), System.Drawing.Image)
        Me.btnSelectAllMappings.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnSelectAllMappings.Name = "btnSelectAllMappings"
        Me.btnSelectAllMappings.Size = New System.Drawing.Size(59, 18)
        Me.btnSelectAllMappings.Text = "Select All"
        '
        'ToolStripSeparator5
        '
        Me.ToolStripSeparator5.Name = "ToolStripSeparator5"
        Me.ToolStripSeparator5.Size = New System.Drawing.Size(6, 21)
        '
        'btnUnselectAllMappings
        '
        Me.btnUnselectAllMappings.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnUnselectAllMappings.Image = CType(resources.GetObject("btnUnselectAllMappings.Image"), System.Drawing.Image)
        Me.btnUnselectAllMappings.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnUnselectAllMappings.Name = "btnUnselectAllMappings"
        Me.btnUnselectAllMappings.Size = New System.Drawing.Size(73, 18)
        Me.btnUnselectAllMappings.Text = "Unselect All"
        '
        'ToolStripSeparator6
        '
        Me.ToolStripSeparator6.Name = "ToolStripSeparator6"
        Me.ToolStripSeparator6.Size = New System.Drawing.Size(6, 21)
        '
        'btnShowAllMappings
        '
        Me.btnShowAllMappings.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnShowAllMappings.Image = CType(resources.GetObject("btnShowAllMappings.Image"), System.Drawing.Image)
        Me.btnShowAllMappings.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnShowAllMappings.Name = "btnShowAllMappings"
        Me.btnShowAllMappings.Size = New System.Drawing.Size(60, 18)
        Me.btnShowAllMappings.Text = "Show All "
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.btnUnmap)
        Me.Panel1.Controls.Add(Me.btnMap)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(561, 34)
        Me.Panel1.TabIndex = 0
        '
        'btnUnmap
        '
        Me.btnUnmap.Location = New System.Drawing.Point(86, 4)
        Me.btnUnmap.Name = "btnUnmap"
        Me.btnUnmap.Size = New System.Drawing.Size(75, 23)
        Me.btnUnmap.TabIndex = 1
        Me.btnUnmap.Text = "UnMap"
        Me.btnUnmap.UseVisualStyleBackColor = True
        '
        'btnMap
        '
        Me.btnMap.Location = New System.Drawing.Point(4, 4)
        Me.btnMap.Name = "btnMap"
        Me.btnMap.Size = New System.Drawing.Size(75, 23)
        Me.btnMap.TabIndex = 0
        Me.btnMap.Text = "Map"
        Me.btnMap.UseVisualStyleBackColor = True
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = " Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(686, 20)
        Me.InformationBar.TabIndex = 1
        Me.InformationBar.TabStop = False
        '
        'statusStripMappings
        '
        Me.statusStripMappings.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.statusStripMappings.Location = New System.Drawing.Point(0, 213)
        Me.statusStripMappings.Name = "statusStripMappings"
        Me.statusStripMappings.Size = New System.Drawing.Size(561, 22)
        Me.statusStripMappings.TabIndex = 6
        Me.statusStripMappings.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(16, 17)
        Me.ToolStripStatusLabel1.Text = "..."
        '
        'SampleUnitCoverLetterMappingEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "SampleUnitCoverLetterMappingEditor"
        Me.Size = New System.Drawing.Size(686, 535)
        Me.BottomPanel.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        CType(Me.SampleUnitTreeView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip2.ResumeLayout(False)
        Me.HeaderStrip2.PerformLayout()
        Me.SplitContainer2.Panel1.ResumeLayout(False)
        Me.SplitContainer2.Panel2.ResumeLayout(False)
        Me.SplitContainer2.Panel2.PerformLayout()
        Me.SplitContainer2.ResumeLayout(False)
        Me.SplitContainer3.Panel1.ResumeLayout(False)
        Me.SplitContainer3.Panel2.ResumeLayout(False)
        Me.SplitContainer3.ResumeLayout(False)
        CType(Me.gcCoverLetters, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CoverLetterBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvCoverLetters, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.AvailableSectionLabelLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        CType(Me.gcArtifacts, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ArtifactBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvArtifacts, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemLookUpEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip3.ResumeLayout(False)
        Me.HeaderStrip3.PerformLayout()
        CType(Me.gcMappings, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UnMapContextMenu.ResumeLayout(False)
        CType(Me.gvMappings, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemPictureEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip4.ResumeLayout(False)
        Me.HeaderStrip4.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        Me.statusStripMappings.ResumeLayout(False)
        Me.statusStripMappings.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents HeaderStrip2 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents SplitContainer2 As System.Windows.Forms.SplitContainer
    Friend WithEvents SplitContainer3 As System.Windows.Forms.SplitContainer
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents HeaderStrip3 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel3 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents HeaderStrip4 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel4 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnUnmap As System.Windows.Forms.Button
    Friend WithEvents btnMap As System.Windows.Forms.Button
    Friend WithEvents gcCoverLetters As DevExpress.XtraGrid.GridControl
    Friend WithEvents gvCoverLetters As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents AvailableSectionLabelLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents gcArtifacts As DevExpress.XtraGrid.GridControl
    Friend WithEvents gvArtifacts As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridColumn1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents RepositoryItemLookUpEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents gcMappings As DevExpress.XtraGrid.GridControl
    Friend WithEvents gvMappings As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents SampleUnit_name As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SampleUnitTreeView As DevExpress.XtraTreeList.TreeList
    Friend WithEvents TreeListColumn1 As DevExpress.XtraTreeList.Columns.TreeListColumn
    Friend WithEvents TreeListColumn2 As DevExpress.XtraTreeList.Columns.TreeListColumn
    Friend WithEvents CoverLetterBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents ArtifactBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents btnSelectAllMappings As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator5 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents btnUnselectAllMappings As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator6 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents btnShowAllMappings As System.Windows.Forms.ToolStripButton
    Friend WithEvents GridColumn3 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn4 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn5 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CoverLetter_name As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CoverLetterItem_label As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Artifact_name As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Artifact_label As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn10 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn11 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn12 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn13 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SampleUnit_Id As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SEL_Cover_CoverID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CoverLetterItem_id As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SEL_Cover_CoverID_Artifact As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SEL_TextBox_QPC_ID_Artifact As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CoverLetterItemType_id As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Survey_Id As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CoverLetterItemArtifactUnitMapping_id As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents NeedDelete As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents btnSampleUnitsClearSelections As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnCoverLettersClearnSelections As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnArtifactsClearSelections As System.Windows.Forms.ToolStripButton
    Friend WithEvents colStatusImage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents RepositoryItemPictureEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemPictureEdit
    Friend WithEvents UniqueID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents UnMapContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents UnMapToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents statusStripMappings As System.Windows.Forms.StatusStrip
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel

End Class
