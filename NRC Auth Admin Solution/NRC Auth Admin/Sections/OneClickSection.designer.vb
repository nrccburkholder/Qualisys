<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OneClickSection
    Inherits NrcAuthAdmin.Section

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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(OneClickSection))
        Me.OneClickSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.OneClickGrid = New DevExpress.XtraGrid.GridControl
        Me.OneClickBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.OneClickGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.OneClickOrderColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickOrderSpinEdit = New DevExpress.XtraEditors.Repository.RepositoryItemSpinEdit
        Me.OneClickReportIdColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickNameColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickDescriptionColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickCategoryColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickCategoryCombobox = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox
        Me.OneClickReportIDTextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
        Me.RepositoryItemPopupContainerEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemPopupContainerEdit
        Me.OneClickNavigator = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.OneClickNavigatorAddNewTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickNavigatorAddGroupTSDropDownButton = New System.Windows.Forms.ToolStripDropDownButton
        Me.OneClickNavigatorDeleteTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickNavigatorSaveTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickNavigatorEditStandardTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickSectionPanel.SuspendLayout()
        CType(Me.OneClickGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickOrderSpinEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickCategoryCombobox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickReportIDTextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemPopupContainerEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickNavigator, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.OneClickNavigator.SuspendLayout()
        Me.SuspendLayout()
        '
        'OneClickSectionPanel
        '
        Me.OneClickSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.OneClickSectionPanel.Caption = "One Click Reports"
        Me.OneClickSectionPanel.Controls.Add(Me.OneClickGrid)
        Me.OneClickSectionPanel.Controls.Add(Me.OneClickNavigator)
        Me.OneClickSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OneClickSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.OneClickSectionPanel.Name = "OneClickSectionPanel"
        Me.OneClickSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.OneClickSectionPanel.ShowCaption = True
        Me.OneClickSectionPanel.Size = New System.Drawing.Size(634, 423)
        Me.OneClickSectionPanel.TabIndex = 0
        '
        'OneClickGrid
        '
        Me.OneClickGrid.DataSource = Me.OneClickBindingSource
        Me.OneClickGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OneClickGrid.EmbeddedNavigator.Name = ""
        Me.OneClickGrid.Enabled = False
        Me.OneClickGrid.Location = New System.Drawing.Point(1, 52)
        Me.OneClickGrid.MainView = Me.OneClickGridView
        Me.OneClickGrid.Name = "OneClickGrid"
        Me.OneClickGrid.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.OneClickCategoryCombobox, Me.OneClickOrderSpinEdit, Me.OneClickReportIDTextEdit, Me.RepositoryItemPopupContainerEdit1})
        Me.OneClickGrid.Size = New System.Drawing.Size(632, 370)
        Me.OneClickGrid.TabIndex = 4
        Me.OneClickGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.OneClickGridView})
        '
        'OneClickBindingSource
        '
        Me.OneClickBindingSource.DataSource = GetType(Nrc.DataMart.MySolutions.Library.OneClickReport)
        '
        'OneClickGridView
        '
        Me.OneClickGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.OneClickOrderColumn, Me.OneClickReportIdColumn, Me.OneClickNameColumn, Me.OneClickDescriptionColumn, Me.OneClickCategoryColumn})
        Me.OneClickGridView.GridControl = Me.OneClickGrid
        Me.OneClickGridView.Name = "OneClickGridView"
        Me.OneClickGridView.OptionsCustomization.AllowGroup = False
        Me.OneClickGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.OneClickGridView.OptionsView.GroupDrawMode = DevExpress.XtraGrid.Views.Grid.GroupDrawMode.Office2003
        Me.OneClickGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Bottom
        Me.OneClickGridView.OptionsView.ShowAutoFilterRow = True
        Me.OneClickGridView.OptionsView.ShowGroupPanel = False
        Me.OneClickGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.OneClickOrderColumn, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'OneClickOrderColumn
        '
        Me.OneClickOrderColumn.Caption = "Display Order"
        Me.OneClickOrderColumn.ColumnEdit = Me.OneClickOrderSpinEdit
        Me.OneClickOrderColumn.FieldName = "Order"
        Me.OneClickOrderColumn.Name = "OneClickOrderColumn"
        Me.OneClickOrderColumn.Visible = True
        Me.OneClickOrderColumn.VisibleIndex = 0
        Me.OneClickOrderColumn.Width = 88
        '
        'OneClickOrderSpinEdit
        '
        Me.OneClickOrderSpinEdit.AutoHeight = False
        Me.OneClickOrderSpinEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Ellipsis, "", -1, True, True, True, DevExpress.Utils.HorzAlignment.Center, Nothing)})
        Me.OneClickOrderSpinEdit.ButtonsStyle = DevExpress.XtraEditors.Controls.BorderStyles.Office2003
        Me.OneClickOrderSpinEdit.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric
        Me.OneClickOrderSpinEdit.EditFormat.FormatType = DevExpress.Utils.FormatType.Numeric
        Me.OneClickOrderSpinEdit.IsFloatValue = False
        Me.OneClickOrderSpinEdit.Mask.EditMask = "N00"
        Me.OneClickOrderSpinEdit.MaxValue = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.OneClickOrderSpinEdit.MinValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.OneClickOrderSpinEdit.Name = "OneClickOrderSpinEdit"
        '
        'OneClickReportIdColumn
        '
        Me.OneClickReportIdColumn.Caption = "Report ID"
        Me.OneClickReportIdColumn.FieldName = "ReportId"
        Me.OneClickReportIdColumn.Name = "OneClickReportIdColumn"
        Me.OneClickReportIdColumn.Visible = True
        Me.OneClickReportIdColumn.VisibleIndex = 4
        Me.OneClickReportIdColumn.Width = 130
        '
        'OneClickNameColumn
        '
        Me.OneClickNameColumn.Caption = "Name"
        Me.OneClickNameColumn.FieldName = "Name"
        Me.OneClickNameColumn.Name = "OneClickNameColumn"
        Me.OneClickNameColumn.Visible = True
        Me.OneClickNameColumn.VisibleIndex = 2
        '
        'OneClickDescriptionColumn
        '
        Me.OneClickDescriptionColumn.Caption = "Description"
        Me.OneClickDescriptionColumn.FieldName = "Description"
        Me.OneClickDescriptionColumn.Name = "OneClickDescriptionColumn"
        Me.OneClickDescriptionColumn.Visible = True
        Me.OneClickDescriptionColumn.VisibleIndex = 3
        '
        'OneClickCategoryColumn
        '
        Me.OneClickCategoryColumn.Caption = "Category"
        Me.OneClickCategoryColumn.ColumnEdit = Me.OneClickCategoryCombobox
        Me.OneClickCategoryColumn.FieldName = "CategoryName"
        Me.OneClickCategoryColumn.Name = "OneClickCategoryColumn"
        Me.OneClickCategoryColumn.Visible = True
        Me.OneClickCategoryColumn.VisibleIndex = 1
        Me.OneClickCategoryColumn.Width = 133
        '
        'OneClickCategoryCombobox
        '
        Me.OneClickCategoryCombobox.AutoHeight = False
        Me.OneClickCategoryCombobox.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.OneClickCategoryCombobox.Items.AddRange(New Object() {"Advanced Reports", "Control Chart and Trend Reports", "Mean Score Reports", "Percentage Response Reports", "Positive Score Reports", "Problem Score Reports"})
        Me.OneClickCategoryCombobox.Name = "OneClickCategoryCombobox"
        '
        'OneClickReportIDTextEdit
        '
        Me.OneClickReportIDTextEdit.AutoHeight = False
        Me.OneClickReportIDTextEdit.DisplayFormat.FormatString = "00"
        Me.OneClickReportIDTextEdit.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Custom
        Me.OneClickReportIDTextEdit.EditFormat.FormatString = "00"
        Me.OneClickReportIDTextEdit.EditFormat.FormatType = DevExpress.Utils.FormatType.Custom
        Me.OneClickReportIDTextEdit.Mask.EditMask = "N00"
        Me.OneClickReportIDTextEdit.Name = "OneClickReportIDTextEdit"
        '
        'RepositoryItemPopupContainerEdit1
        '
        Me.RepositoryItemPopupContainerEdit1.AutoHeight = False
        Me.RepositoryItemPopupContainerEdit1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemPopupContainerEdit1.Name = "RepositoryItemPopupContainerEdit1"
        '
        'OneClickNavigator
        '
        Me.OneClickNavigator.AddNewItem = Nothing
        Me.OneClickNavigator.CountItem = Nothing
        Me.OneClickNavigator.DeleteItem = Nothing
        Me.OneClickNavigator.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.OneClickNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OneClickNavigatorAddNewTSButton, Me.OneClickNavigatorAddGroupTSDropDownButton, Me.OneClickNavigatorDeleteTSButton, Me.OneClickNavigatorSaveTSButton, Me.OneClickNavigatorEditStandardTSButton})
        Me.OneClickNavigator.Location = New System.Drawing.Point(1, 27)
        Me.OneClickNavigator.MoveFirstItem = Nothing
        Me.OneClickNavigator.MoveLastItem = Nothing
        Me.OneClickNavigator.MoveNextItem = Nothing
        Me.OneClickNavigator.MovePreviousItem = Nothing
        Me.OneClickNavigator.Name = "OneClickNavigator"
        Me.OneClickNavigator.PositionItem = Nothing
        Me.OneClickNavigator.Size = New System.Drawing.Size(632, 25)
        Me.OneClickNavigator.TabIndex = 3
        Me.OneClickNavigator.Text = "BindingNavigator1"
        '
        'OneClickNavigatorAddNewTSButton
        '
        Me.OneClickNavigatorAddNewTSButton.Enabled = False
        Me.OneClickNavigatorAddNewTSButton.Image = CType(resources.GetObject("OneClickNavigatorAddNewTSButton.Image"), System.Drawing.Image)
        Me.OneClickNavigatorAddNewTSButton.Name = "OneClickNavigatorAddNewTSButton"
        Me.OneClickNavigatorAddNewTSButton.RightToLeftAutoMirrorImage = True
        Me.OneClickNavigatorAddNewTSButton.Size = New System.Drawing.Size(46, 22)
        Me.OneClickNavigatorAddNewTSButton.Text = "Add"
        '
        'OneClickNavigatorAddGroupTSDropDownButton
        '
        Me.OneClickNavigatorAddGroupTSDropDownButton.Enabled = False
        Me.OneClickNavigatorAddGroupTSDropDownButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Copy16
        Me.OneClickNavigatorAddGroupTSDropDownButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.OneClickNavigatorAddGroupTSDropDownButton.Name = "OneClickNavigatorAddGroupTSDropDownButton"
        Me.OneClickNavigatorAddGroupTSDropDownButton.Size = New System.Drawing.Size(102, 22)
        Me.OneClickNavigatorAddGroupTSDropDownButton.Text = "Add Standard"
        '
        'OneClickNavigatorDeleteTSButton
        '
        Me.OneClickNavigatorDeleteTSButton.Enabled = False
        Me.OneClickNavigatorDeleteTSButton.Image = CType(resources.GetObject("OneClickNavigatorDeleteTSButton.Image"), System.Drawing.Image)
        Me.OneClickNavigatorDeleteTSButton.Name = "OneClickNavigatorDeleteTSButton"
        Me.OneClickNavigatorDeleteTSButton.RightToLeftAutoMirrorImage = True
        Me.OneClickNavigatorDeleteTSButton.Size = New System.Drawing.Size(58, 22)
        Me.OneClickNavigatorDeleteTSButton.Text = "Delete"
        '
        'OneClickNavigatorSaveTSButton
        '
        Me.OneClickNavigatorSaveTSButton.Enabled = False
        Me.OneClickNavigatorSaveTSButton.Image = CType(resources.GetObject("OneClickNavigatorSaveTSButton.Image"), System.Drawing.Image)
        Me.OneClickNavigatorSaveTSButton.Name = "OneClickNavigatorSaveTSButton"
        Me.OneClickNavigatorSaveTSButton.Size = New System.Drawing.Size(51, 22)
        Me.OneClickNavigatorSaveTSButton.Text = "Save"
        '
        'OneClickNavigatorEditStandardTSButton
        '
        Me.OneClickNavigatorEditStandardTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.OneClickNavigatorEditStandardTSButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Properties16
        Me.OneClickNavigatorEditStandardTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OneClickNavigatorEditStandardTSButton.Name = "OneClickNavigatorEditStandardTSButton"
        Me.OneClickNavigatorEditStandardTSButton.Size = New System.Drawing.Size(97, 22)
        Me.OneClickNavigatorEditStandardTSButton.Text = "Edit Standards"
        Me.OneClickNavigatorEditStandardTSButton.Visible = False
        '
        'OneClickSection
        '
        Me.Controls.Add(Me.OneClickSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "OneClickSection"
        Me.Padding = New System.Windows.Forms.Padding(0, 0, 3, 0)
        Me.Size = New System.Drawing.Size(637, 423)
        Me.OneClickSectionPanel.ResumeLayout(False)
        Me.OneClickSectionPanel.PerformLayout()
        CType(Me.OneClickGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickOrderSpinEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickCategoryCombobox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickReportIDTextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemPopupContainerEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickNavigator, System.ComponentModel.ISupportInitialize).EndInit()
        Me.OneClickNavigator.ResumeLayout(False)
        Me.OneClickNavigator.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OneClickSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents OneClickGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents OneClickGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents OneClickCategoryCombobox As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents OneClickNavigator As System.Windows.Forms.BindingNavigator
    Friend WithEvents OneClickNavigatorDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OneClickNavigatorSaveTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OneClickNavigatorAddGroupTSDropDownButton As System.Windows.Forms.ToolStripDropDownButton
    Friend WithEvents OneClickBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents OneClickOrderColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickReportIdColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickNameColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickDescriptionColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickCategoryColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickOrderSpinEdit As DevExpress.XtraEditors.Repository.RepositoryItemSpinEdit
    Friend WithEvents OneClickReportIDTextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents RepositoryItemPopupContainerEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemPopupContainerEdit
    Friend WithEvents OneClickNavigatorAddNewTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OneClickNavigatorEditStandardTSButton As System.Windows.Forms.ToolStripButton

End Class
