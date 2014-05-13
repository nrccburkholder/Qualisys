<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CommentFilterSection
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(CommentFilterSection))
        Me.colStudyTableColumnId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FieldColumnLookupEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.CommentFilterGridControl = New DevExpress.XtraGrid.GridControl
        Me.CommentFilterBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.CommentFilterGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAllowGroupBy = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CheckEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.colIsDisplayed = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsExported = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsDisplayedOnServiceAlert = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsExportedOnServiceAlert = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CommentFilterBindingNavigator = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.AddFilterLabel = New System.Windows.Forms.ToolStripLabel
        Me.AvailableFieldList = New System.Windows.Forms.ToolStripComboBox
        Me.AddFilterButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteFilterButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.SaveChangesButton = New System.Windows.Forms.ToolStripButton
        Me.CancelChangesButton = New System.Windows.Forms.ToolStripButton
        CType(Me.FieldColumnLookupEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SectionPanel1.SuspendLayout()
        CType(Me.CommentFilterGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CommentFilterBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CommentFilterGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CheckEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CommentFilterBindingNavigator, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CommentFilterBindingNavigator.SuspendLayout()
        Me.SuspendLayout()
        '
        'colStudyTableColumnId
        '
        Me.colStudyTableColumnId.Caption = "Field"
        Me.colStudyTableColumnId.ColumnEdit = Me.FieldColumnLookupEdit
        Me.colStudyTableColumnId.FieldName = "StudyTableColumnId"
        Me.colStudyTableColumnId.Name = "colStudyTableColumnId"
        Me.colStudyTableColumnId.Visible = True
        Me.colStudyTableColumnId.VisibleIndex = 0
        Me.colStudyTableColumnId.Width = 80
        '
        'FieldColumnLookupEdit
        '
        Me.FieldColumnLookupEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.FieldColumnLookupEdit.AutoHeight = False
        Me.FieldColumnLookupEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Name", "Name", 40, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.[Default], DevExpress.Data.ColumnSortOrder.Ascending)})
        Me.FieldColumnLookupEdit.DisplayMember = "Name"
        Me.FieldColumnLookupEdit.Name = "FieldColumnLookupEdit"
        Me.FieldColumnLookupEdit.ReadOnly = True
        Me.FieldColumnLookupEdit.ShowDropDown = DevExpress.XtraEditors.Controls.ShowDropDown.Never
        Me.FieldColumnLookupEdit.ThrowExceptionOnInvalidLookUpEditValueType = True
        Me.FieldColumnLookupEdit.ValueMember = "FieldId"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "eComments Filters"
        Me.SectionPanel1.Controls.Add(Me.CommentFilterGridControl)
        Me.SectionPanel1.Controls.Add(Me.CommentFilterBindingNavigator)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(663, 466)
        Me.SectionPanel1.TabIndex = 1
        '
        'CommentFilterGridControl
        '
        Me.CommentFilterGridControl.DataSource = Me.CommentFilterBindingSource
        Me.CommentFilterGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CommentFilterGridControl.EmbeddedNavigator.Name = ""
        Me.CommentFilterGridControl.Location = New System.Drawing.Point(1, 52)
        Me.CommentFilterGridControl.MainView = Me.CommentFilterGridView
        Me.CommentFilterGridControl.Name = "CommentFilterGridControl"
        Me.CommentFilterGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.FieldColumnLookupEdit, Me.CheckEdit1})
        Me.CommentFilterGridControl.Size = New System.Drawing.Size(661, 413)
        Me.CommentFilterGridControl.TabIndex = 1
        Me.CommentFilterGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.CommentFilterGridView})
        '
        'CommentFilterBindingSource
        '
        Me.CommentFilterBindingSource.AllowNew = True
        Me.CommentFilterBindingSource.DataSource = GetType(Nrc.DataMart.MySolutions.Library.CommentFilter)
        '
        'CommentFilterGridView
        '
        Me.CommentFilterGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colStudyTableColumnId, Me.colName, Me.colAllowGroupBy, Me.colIsDisplayed, Me.colIsExported, Me.colIsDisplayedOnServiceAlert, Me.colIsExportedOnServiceAlert})
        Me.CommentFilterGridView.GridControl = Me.CommentFilterGridControl
        Me.CommentFilterGridView.Name = "CommentFilterGridView"
        Me.CommentFilterGridView.OptionsCustomization.AllowFilter = False
        Me.CommentFilterGridView.OptionsCustomization.AllowGroup = False
        Me.CommentFilterGridView.OptionsDetail.AllowZoomDetail = False
        Me.CommentFilterGridView.OptionsDetail.EnableMasterViewMode = False
        Me.CommentFilterGridView.OptionsDetail.ShowDetailTabs = False
        Me.CommentFilterGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.CommentFilterGridView.OptionsView.ShowDetailButtons = False
        Me.CommentFilterGridView.OptionsView.ShowGroupPanel = False
        Me.CommentFilterGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colStudyTableColumnId, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colName
        '
        Me.colName.Caption = "Display Label"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        '
        'colAllowGroupBy
        '
        Me.colAllowGroupBy.Caption = "Allow Group By"
        Me.colAllowGroupBy.ColumnEdit = Me.CheckEdit1
        Me.colAllowGroupBy.FieldName = "AllowGroupBy"
        Me.colAllowGroupBy.Name = "colAllowGroupBy"
        Me.colAllowGroupBy.Visible = True
        Me.colAllowGroupBy.VisibleIndex = 2
        Me.colAllowGroupBy.Width = 94
        '
        'CheckEdit1
        '
        Me.CheckEdit1.AutoHeight = False
        Me.CheckEdit1.Name = "CheckEdit1"
        '
        'colIsDisplayed
        '
        Me.colIsDisplayed.Caption = "Displayed"
        Me.colIsDisplayed.ColumnEdit = Me.CheckEdit1
        Me.colIsDisplayed.FieldName = "IsDisplayed"
        Me.colIsDisplayed.Name = "colIsDisplayed"
        Me.colIsDisplayed.Visible = True
        Me.colIsDisplayed.VisibleIndex = 3
        Me.colIsDisplayed.Width = 91
        '
        'colIsExported
        '
        Me.colIsExported.Caption = "Exported"
        Me.colIsExported.ColumnEdit = Me.CheckEdit1
        Me.colIsExported.FieldName = "IsExported"
        Me.colIsExported.Name = "colIsExported"
        Me.colIsExported.Visible = True
        Me.colIsExported.VisibleIndex = 4
        Me.colIsExported.Width = 80
        '
        'colIsDisplayedOnServiceAlert
        '
        Me.colIsDisplayedOnServiceAlert.Caption = "Service Alert Displayed"
        Me.colIsDisplayedOnServiceAlert.ColumnEdit = Me.CheckEdit1
        Me.colIsDisplayedOnServiceAlert.FieldName = "IsDisplayedOnServiceAlert"
        Me.colIsDisplayedOnServiceAlert.Name = "colIsDisplayedOnServiceAlert"
        Me.colIsDisplayedOnServiceAlert.Visible = True
        Me.colIsDisplayedOnServiceAlert.VisibleIndex = 5
        Me.colIsDisplayedOnServiceAlert.Width = 80
        '
        'colIsExportedOnServiceAlert
        '
        Me.colIsExportedOnServiceAlert.Caption = "Service Alert Exported"
        Me.colIsExportedOnServiceAlert.ColumnEdit = Me.CheckEdit1
        Me.colIsExportedOnServiceAlert.FieldName = "IsExportedOnServiceAlert"
        Me.colIsExportedOnServiceAlert.Name = "colIsExportedOnServiceAlert"
        Me.colIsExportedOnServiceAlert.Visible = True
        Me.colIsExportedOnServiceAlert.VisibleIndex = 6
        Me.colIsExportedOnServiceAlert.Width = 80
        '
        'CommentFilterBindingNavigator
        '
        Me.CommentFilterBindingNavigator.AddNewItem = Nothing
        Me.CommentFilterBindingNavigator.BindingSource = Me.CommentFilterBindingSource
        Me.CommentFilterBindingNavigator.CountItem = Nothing
        Me.CommentFilterBindingNavigator.DeleteItem = Nothing
        Me.CommentFilterBindingNavigator.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.CommentFilterBindingNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddFilterLabel, Me.AvailableFieldList, Me.AddFilterButton, Me.ToolStripSeparator1, Me.DeleteFilterButton, Me.ToolStripSeparator2, Me.SaveChangesButton, Me.CancelChangesButton})
        Me.CommentFilterBindingNavigator.Location = New System.Drawing.Point(1, 27)
        Me.CommentFilterBindingNavigator.MoveFirstItem = Nothing
        Me.CommentFilterBindingNavigator.MoveLastItem = Nothing
        Me.CommentFilterBindingNavigator.MoveNextItem = Nothing
        Me.CommentFilterBindingNavigator.MovePreviousItem = Nothing
        Me.CommentFilterBindingNavigator.Name = "CommentFilterBindingNavigator"
        Me.CommentFilterBindingNavigator.PositionItem = Nothing
        Me.CommentFilterBindingNavigator.Size = New System.Drawing.Size(661, 25)
        Me.CommentFilterBindingNavigator.TabIndex = 2
        Me.CommentFilterBindingNavigator.Text = "BindingNavigator1"
        '
        'AddFilterLabel
        '
        Me.AddFilterLabel.Enabled = False
        Me.AddFilterLabel.Name = "AddFilterLabel"
        Me.AddFilterLabel.Size = New System.Drawing.Size(86, 22)
        Me.AddFilterLabel.Text = "Available Filters:"
        '
        'AvailableFieldList
        '
        Me.AvailableFieldList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.AvailableFieldList.Enabled = False
        Me.AvailableFieldList.Name = "AvailableFieldList"
        Me.AvailableFieldList.Size = New System.Drawing.Size(121, 25)
        Me.AvailableFieldList.Sorted = True
        '
        'AddFilterButton
        '
        Me.AddFilterButton.Enabled = False
        Me.AddFilterButton.Image = CType(resources.GetObject("AddFilterButton.Image"), System.Drawing.Image)
        Me.AddFilterButton.Name = "AddFilterButton"
        Me.AddFilterButton.RightToLeftAutoMirrorImage = True
        Me.AddFilterButton.Size = New System.Drawing.Size(73, 22)
        Me.AddFilterButton.Text = "Add Filter"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteFilterButton
        '
        Me.DeleteFilterButton.Enabled = False
        Me.DeleteFilterButton.Image = CType(resources.GetObject("DeleteFilterButton.Image"), System.Drawing.Image)
        Me.DeleteFilterButton.Name = "DeleteFilterButton"
        Me.DeleteFilterButton.RightToLeftAutoMirrorImage = True
        Me.DeleteFilterButton.Size = New System.Drawing.Size(85, 22)
        Me.DeleteFilterButton.Text = "Delete Filter"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'SaveChangesButton
        '
        Me.SaveChangesButton.Enabled = False
        Me.SaveChangesButton.Image = CType(resources.GetObject("SaveChangesButton.Image"), System.Drawing.Image)
        Me.SaveChangesButton.Name = "SaveChangesButton"
        Me.SaveChangesButton.Size = New System.Drawing.Size(96, 22)
        Me.SaveChangesButton.Text = "Save Changes"
        '
        'CancelChangesButton
        '
        Me.CancelChangesButton.Enabled = False
        Me.CancelChangesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Undo16
        Me.CancelChangesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.CancelChangesButton.Name = "CancelChangesButton"
        Me.CancelChangesButton.Size = New System.Drawing.Size(104, 22)
        Me.CancelChangesButton.Text = "Cancel Changes"
        '
        'CommentFilterSection
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "CommentFilterSection"
        Me.Size = New System.Drawing.Size(663, 466)
        CType(Me.FieldColumnLookupEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.CommentFilterGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CommentFilterBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CommentFilterGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CheckEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CommentFilterBindingNavigator, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CommentFilterBindingNavigator.ResumeLayout(False)
        Me.CommentFilterBindingNavigator.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents CommentFilterGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents CommentFilterBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents CommentFilterGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colAllowGroupBy As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsDisplayedOnServiceAlert As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStudyTableColumnId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsExportedOnServiceAlert As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsExported As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsDisplayed As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents CommentFilterBindingNavigator As System.Windows.Forms.BindingNavigator
    Friend WithEvents AddFilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeleteFilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveChangesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FieldColumnLookupEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents AddFilterLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents AvailableFieldList As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents CancelChangesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents CheckEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit

End Class
