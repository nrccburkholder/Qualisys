<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SampleUnitSectionMappingEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.components = New System.ComponentModel.Container
        Me.SampleUnitBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.ApplyButton = New System.Windows.Forms.Button
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.BodyPanel = New System.Windows.Forms.SplitContainer
        Me.SampleUnitTreeView = New Nrc.Qualisys.ConfigurationManager.MultiSelectTreeView
        Me.HeaderStrip2 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.SectionsPanel = New System.Windows.Forms.SplitContainer
        Me.AvailableSectionsGridControl = New DevExpress.XtraGrid.GridControl
        Me.MapContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.MapToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AvailableSectionsBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.AvailableGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colQuestionSectionId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.AvailableSectionLabelLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.QuestionSectionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.AddMappedSectionButton = New System.Windows.Forms.ToolStripButton
        Me.MappingSectionsGridControl = New DevExpress.XtraGrid.GridControl
        Me.UnMapContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.UnMapToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MappedSectionsBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MappedGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colSampleUnitId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.SampleUnitLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.colQuestionSectionId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.MappedSectionsLookupEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.HeaderStrip3 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel3 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteMappedSectionButton = New System.Windows.Forms.ToolStripButton
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        CType(Me.SampleUnitBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BottomPanel.SuspendLayout()
        Me.BodyPanel.Panel1.SuspendLayout()
        Me.BodyPanel.Panel2.SuspendLayout()
        Me.BodyPanel.SuspendLayout()
        Me.HeaderStrip2.SuspendLayout()
        Me.SectionsPanel.Panel1.SuspendLayout()
        Me.SectionsPanel.Panel2.SuspendLayout()
        Me.SectionsPanel.SuspendLayout()
        CType(Me.AvailableSectionsGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MapContextMenuStrip.SuspendLayout()
        CType(Me.AvailableSectionsBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.AvailableGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.AvailableSectionLabelLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.QuestionSectionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip1.SuspendLayout()
        CType(Me.MappingSectionsGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UnMapContextMenuStrip.SuspendLayout()
        CType(Me.MappedSectionsBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MappedGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SampleUnitLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MappedSectionsLookupEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.HeaderStrip3.SuspendLayout()
        Me.SuspendLayout()
        '
        'SampleUnitBindingSource
        '
        Me.SampleUnitBindingSource.DataSource = GetType(Nrc.Qualisys.Library.SampleUnit)
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
        Me.BottomPanel.TabIndex = 1
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
        'BodyPanel
        '
        Me.BodyPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BodyPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.BodyPanel.Location = New System.Drawing.Point(0, 20)
        Me.BodyPanel.Name = "BodyPanel"
        '
        'BodyPanel.Panel1
        '
        Me.BodyPanel.Panel1.Controls.Add(Me.SampleUnitTreeView)
        Me.BodyPanel.Panel1.Controls.Add(Me.HeaderStrip2)
        '
        'BodyPanel.Panel2
        '
        Me.BodyPanel.Panel2.Controls.Add(Me.SectionsPanel)
        Me.BodyPanel.Size = New System.Drawing.Size(686, 480)
        Me.BodyPanel.SplitterDistance = 211
        Me.BodyPanel.TabIndex = 37
        '
        'SampleUnitTreeView
        '
        Me.SampleUnitTreeView.BackColor = System.Drawing.SystemColors.Window
        Me.SampleUnitTreeView.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.SampleUnitTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleUnitTreeView.ForeColor = System.Drawing.SystemColors.ControlText
        Me.SampleUnitTreeView.HideSelection = False
        Me.SampleUnitTreeView.Location = New System.Drawing.Point(0, 19)
        Me.SampleUnitTreeView.Name = "SampleUnitTreeView"
        Me.SampleUnitTreeView.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.SampleUnitTreeView.Size = New System.Drawing.Size(209, 459)
        Me.SampleUnitTreeView.TabIndex = 3
        '
        'HeaderStrip2
        '
        Me.HeaderStrip2.AutoSize = False
        Me.HeaderStrip2.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip2.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip2.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2})
        Me.HeaderStrip2.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip2.Name = "HeaderStrip2"
        Me.HeaderStrip2.Size = New System.Drawing.Size(209, 19)
        Me.HeaderStrip2.TabIndex = 2
        Me.HeaderStrip2.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(88, 16)
        Me.ToolStripLabel2.Text = "Sample Unit Tree"
        '
        'SectionsPanel
        '
        Me.SectionsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionsPanel.Location = New System.Drawing.Point(0, 0)
        Me.SectionsPanel.Name = "SectionsPanel"
        Me.SectionsPanel.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SectionsPanel.Panel1
        '
        Me.SectionsPanel.Panel1.AutoScroll = True
        Me.SectionsPanel.Panel1.Controls.Add(Me.AvailableSectionsGridControl)
        Me.SectionsPanel.Panel1.Controls.Add(Me.HeaderStrip1)
        '
        'SectionsPanel.Panel2
        '
        Me.SectionsPanel.Panel2.AutoScroll = True
        Me.SectionsPanel.Panel2.Controls.Add(Me.MappingSectionsGridControl)
        Me.SectionsPanel.Panel2.Controls.Add(Me.HeaderStrip3)
        Me.SectionsPanel.Size = New System.Drawing.Size(469, 478)
        Me.SectionsPanel.SplitterDistance = 264
        Me.SectionsPanel.TabIndex = 0
        '
        'AvailableSectionsGridControl
        '
        Me.AvailableSectionsGridControl.ContextMenuStrip = Me.MapContextMenuStrip
        Me.AvailableSectionsGridControl.DataSource = Me.AvailableSectionsBindingSource
        Me.AvailableSectionsGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AvailableSectionsGridControl.EmbeddedNavigator.Name = ""
        Me.AvailableSectionsGridControl.Location = New System.Drawing.Point(0, 19)
        Me.AvailableSectionsGridControl.MainView = Me.AvailableGridView
        Me.AvailableSectionsGridControl.Name = "AvailableSectionsGridControl"
        Me.AvailableSectionsGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.AvailableSectionLabelLookUpEdit})
        Me.AvailableSectionsGridControl.Size = New System.Drawing.Size(469, 245)
        Me.AvailableSectionsGridControl.TabIndex = 3
        Me.AvailableSectionsGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.AvailableGridView})
        '
        'MapContextMenuStrip
        '
        Me.MapContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MapToolStripMenuItem})
        Me.MapContextMenuStrip.Name = "MapContextMenuStrip"
        Me.MapContextMenuStrip.Size = New System.Drawing.Size(106, 26)
        '
        'MapToolStripMenuItem
        '
        Me.MapToolStripMenuItem.Name = "MapToolStripMenuItem"
        Me.MapToolStripMenuItem.Size = New System.Drawing.Size(105, 22)
        Me.MapToolStripMenuItem.Text = "Map"
        '
        'AvailableSectionsBindingSource
        '
        Me.AvailableSectionsBindingSource.DataSource = GetType(Nrc.Qualisys.Library.SampleUnitSectionMapping)
        '
        'AvailableGridView
        '
        Me.AvailableGridView.Appearance.FocusedCell.BackColor = System.Drawing.SystemColors.MenuHighlight
        Me.AvailableGridView.Appearance.FocusedCell.Options.UseBackColor = True
        Me.AvailableGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colQuestionSectionId})
        Me.AvailableGridView.GridControl = Me.AvailableSectionsGridControl
        Me.AvailableGridView.Name = "AvailableGridView"
        Me.AvailableGridView.OptionsCustomization.AllowFilter = False
        Me.AvailableGridView.OptionsCustomization.AllowGroup = False
        Me.AvailableGridView.OptionsSelection.EnableAppearanceHideSelection = False
        Me.AvailableGridView.OptionsSelection.MultiSelect = True
        Me.AvailableGridView.OptionsView.ShowColumnHeaders = False
        Me.AvailableGridView.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        'Me.AvailableGridView.OptionsView.ShowFilterPanel = False
        Me.AvailableGridView.OptionsView.ShowGroupPanel = False
        Me.AvailableGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colQuestionSectionId, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colQuestionSectionId
        '
        Me.colQuestionSectionId.Caption = "Question Section"
        Me.colQuestionSectionId.ColumnEdit = Me.AvailableSectionLabelLookUpEdit
        Me.colQuestionSectionId.FieldName = "QuestionSectionId"
        Me.colQuestionSectionId.Name = "colQuestionSectionId"
        Me.colQuestionSectionId.Visible = True
        Me.colQuestionSectionId.VisibleIndex = 0
        '
        'AvailableSectionLabelLookUpEdit
        '
        Me.AvailableSectionLabelLookUpEdit.AutoHeight = False
        Me.AvailableSectionLabelLookUpEdit.DataSource = Me.QuestionSectionBindingSource
        Me.AvailableSectionLabelLookUpEdit.DisplayMember = "Label"
        Me.AvailableSectionLabelLookUpEdit.Name = "AvailableSectionLabelLookUpEdit"
        Me.AvailableSectionLabelLookUpEdit.ReadOnly = True
        Me.AvailableSectionLabelLookUpEdit.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.AvailableSectionLabelLookUpEdit.ValueMember = "Id"
        '
        'QuestionSectionBindingSource
        '
        Me.QuestionSectionBindingSource.DataSource = GetType(Nrc.Qualisys.Library.QuestionSection)
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.ToolStripSeparator2, Me.AddMappedSectionButton})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(469, 19)
        Me.HeaderStrip1.TabIndex = 3
        Me.HeaderStrip1.Text = "Available Sections"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(110, 16)
        Me.ToolStripLabel1.Text = "Available Sections"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 19)
        '
        'AddMappedSectionButton
        '
        Me.AddMappedSectionButton.BackColor = System.Drawing.SystemColors.Control
        Me.AddMappedSectionButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.AddMappedSectionButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AddMappedSectionButton.Name = "AddMappedSectionButton"
        Me.AddMappedSectionButton.Size = New System.Drawing.Size(31, 16)
        Me.AddMappedSectionButton.Text = "Map"
        Me.AddMappedSectionButton.ToolTipText = "Map Selected Sections to Selected Sample Units"
        '
        'MappingSectionsGridControl
        '
        Me.MappingSectionsGridControl.ContextMenuStrip = Me.UnMapContextMenuStrip
        Me.MappingSectionsGridControl.DataSource = Me.MappedSectionsBindingSource
        Me.MappingSectionsGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MappingSectionsGridControl.EmbeddedNavigator.Name = ""
        Me.MappingSectionsGridControl.Location = New System.Drawing.Point(0, 19)
        Me.MappingSectionsGridControl.MainView = Me.MappedGridView
        Me.MappingSectionsGridControl.Name = "MappingSectionsGridControl"
        Me.MappingSectionsGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.SampleUnitLookUpEdit, Me.MappedSectionsLookupEdit})
        Me.MappingSectionsGridControl.Size = New System.Drawing.Size(469, 191)
        Me.MappingSectionsGridControl.TabIndex = 3
        Me.MappingSectionsGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.MappedGridView})
        '
        'UnMapContextMenuStrip
        '
        Me.UnMapContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UnMapToolStripMenuItem})
        Me.UnMapContextMenuStrip.Name = "UnMapContextMenuStrip"
        Me.UnMapContextMenuStrip.Size = New System.Drawing.Size(119, 26)
        '
        'UnMapToolStripMenuItem
        '
        Me.UnMapToolStripMenuItem.Name = "UnMapToolStripMenuItem"
        Me.UnMapToolStripMenuItem.Size = New System.Drawing.Size(118, 22)
        Me.UnMapToolStripMenuItem.Text = "UnMap"
        '
        'MappedSectionsBindingSource
        '
        Me.MappedSectionsBindingSource.DataSource = GetType(Nrc.Qualisys.Library.SampleUnitSectionMapping)
        '
        'MappedGridView
        '
        Me.MappedGridView.Appearance.FocusedCell.BackColor = System.Drawing.SystemColors.MenuHighlight
        Me.MappedGridView.Appearance.FocusedCell.Options.UseBackColor = True
        Me.MappedGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colSampleUnitId, Me.colQuestionSectionId1})
        Me.MappedGridView.GridControl = Me.MappingSectionsGridControl
        Me.MappedGridView.Name = "MappedGridView"
        Me.MappedGridView.OptionsCustomization.AllowGroup = False
        Me.MappedGridView.OptionsFilter.ColumnFilterPopupRowCount = 4
        Me.MappedGridView.OptionsSelection.EnableAppearanceHideSelection = False
        Me.MappedGridView.OptionsSelection.MultiSelect = True
        Me.MappedGridView.OptionsView.ShowAutoFilterRow = True
        Me.MappedGridView.OptionsView.ShowGroupPanel = False
        Me.MappedGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colSampleUnitId, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colSampleUnitId
        '
        Me.colSampleUnitId.Caption = "Sample Unit"
        Me.colSampleUnitId.ColumnEdit = Me.SampleUnitLookUpEdit
        Me.colSampleUnitId.FieldName = "SampleUnitId"
        Me.colSampleUnitId.Name = "colSampleUnitId"
        Me.colSampleUnitId.Visible = True
        Me.colSampleUnitId.VisibleIndex = 0
        '
        'SampleUnitLookUpEdit
        '
        Me.SampleUnitLookUpEdit.AutoHeight = False
        Me.SampleUnitLookUpEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("DisplayLabel", "DisplayLabel", 65, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near)})
        Me.SampleUnitLookUpEdit.DataSource = Me.SampleUnitBindingSource
        Me.SampleUnitLookUpEdit.DisplayMember = "DisplayLabel"
        Me.SampleUnitLookUpEdit.Name = "SampleUnitLookUpEdit"
        Me.SampleUnitLookUpEdit.ReadOnly = True
        Me.SampleUnitLookUpEdit.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.SampleUnitLookUpEdit.ValueMember = "Id"
        '
        'colQuestionSectionId1
        '
        Me.colQuestionSectionId1.Caption = "Question Section"
        Me.colQuestionSectionId1.ColumnEdit = Me.MappedSectionsLookupEdit
        Me.colQuestionSectionId1.FieldName = "QuestionSectionId"
        Me.colQuestionSectionId1.Name = "colQuestionSectionId1"
        Me.colQuestionSectionId1.Visible = True
        Me.colQuestionSectionId1.VisibleIndex = 1
        '
        'MappedSectionsLookupEdit
        '
        Me.MappedSectionsLookupEdit.AutoHeight = False
        Me.MappedSectionsLookupEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Label", "Label", 31, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near)})
        Me.MappedSectionsLookupEdit.DataSource = Me.QuestionSectionBindingSource
        Me.MappedSectionsLookupEdit.DisplayMember = "Label"
        Me.MappedSectionsLookupEdit.Name = "MappedSectionsLookupEdit"
        Me.MappedSectionsLookupEdit.ReadOnly = True
        Me.MappedSectionsLookupEdit.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.MappedSectionsLookupEdit.ValueMember = "Id"
        '
        'HeaderStrip3
        '
        Me.HeaderStrip3.AutoSize = False
        Me.HeaderStrip3.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip3.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip3.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip3.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip3.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel3, Me.ToolStripSeparator1, Me.DeleteMappedSectionButton})
        Me.HeaderStrip3.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip3.Name = "HeaderStrip3"
        Me.HeaderStrip3.Size = New System.Drawing.Size(469, 19)
        Me.HeaderStrip3.TabIndex = 3
        Me.HeaderStrip3.Text = "HeaderStrip3"
        '
        'ToolStripLabel3
        '
        Me.ToolStripLabel3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ToolStripLabel3.Name = "ToolStripLabel3"
        Me.ToolStripLabel3.Size = New System.Drawing.Size(103, 16)
        Me.ToolStripLabel3.Text = "Mapped Sections"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 19)
        '
        'DeleteMappedSectionButton
        '
        Me.DeleteMappedSectionButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.DeleteMappedSectionButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteMappedSectionButton.Name = "DeleteMappedSectionButton"
        Me.DeleteMappedSectionButton.Size = New System.Drawing.Size(44, 16)
        Me.DeleteMappedSectionButton.Text = "UnMap"
        Me.DeleteMappedSectionButton.ToolTipText = "UnMap Selected Items"
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
        Me.InformationBar.TabIndex = 36
        Me.InformationBar.TabStop = False
        '
        'SampleUnitSectionMappingEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.BodyPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "SampleUnitSectionMappingEditor"
        Me.Size = New System.Drawing.Size(686, 535)
        CType(Me.SampleUnitBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BottomPanel.ResumeLayout(False)
        Me.BodyPanel.Panel1.ResumeLayout(False)
        Me.BodyPanel.Panel2.ResumeLayout(False)
        Me.BodyPanel.ResumeLayout(False)
        Me.HeaderStrip2.ResumeLayout(False)
        Me.HeaderStrip2.PerformLayout()
        Me.SectionsPanel.Panel1.ResumeLayout(False)
        Me.SectionsPanel.Panel2.ResumeLayout(False)
        Me.SectionsPanel.ResumeLayout(False)
        CType(Me.AvailableSectionsGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MapContextMenuStrip.ResumeLayout(False)
        CType(Me.AvailableSectionsBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.AvailableGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.AvailableSectionLabelLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.QuestionSectionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        CType(Me.MappingSectionsGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UnMapContextMenuStrip.ResumeLayout(False)
        CType(Me.MappedSectionsBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MappedGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SampleUnitLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MappedSectionsLookupEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.HeaderStrip3.ResumeLayout(False)
        Me.HeaderStrip3.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents BodyPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents SectionsPanel As System.Windows.Forms.SplitContainer
    Friend WithEvents SampleUnitTreeView As MultiSelectTreeView
    Friend WithEvents HeaderStrip2 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents HeaderStrip3 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel3 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents AvailableSectionsBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents MappedSectionsBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents QuestionSectionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents AvailableSectionsGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents AvailableGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colQuestionSectionId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents AvailableSectionLabelLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents SampleUnitBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents MappingSectionsGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents MappedGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colQuestionSectionId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSampleUnitId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SampleUnitLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents MappedSectionsLookupEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteMappedSectionButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents AddMappedSectionButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MapContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MapToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents UnMapContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents UnMapToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
