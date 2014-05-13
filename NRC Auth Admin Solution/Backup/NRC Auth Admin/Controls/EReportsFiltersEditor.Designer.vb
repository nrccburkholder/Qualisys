<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class EReportsFiltersEditor
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
        Me.EReportsFiltersTools = New System.Windows.Forms.ToolStrip
        Me.ExportButton = New System.Windows.Forms.ToolStripButton
        Me.SaveButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.AddCalculatedColumnButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.CancelChangesButton = New System.Windows.Forms.ToolStripButton
        Me.StudyTableColumnBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.EReportsFiltersGridControl = New DevExpress.XtraGrid.GridControl
        Me.EReportsFiltersGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsAvailableOnEReports = New DevExpress.XtraGrid.Columns.GridColumn
        Me.CheckEditRepositoryItem = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDisplayName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemTextEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
        Me.colFormula = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsCalculated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FileDialog = New System.Windows.Forms.SaveFileDialog
        Me.EReportsFiltersTools.SuspendLayout()
        CType(Me.StudyTableColumnBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EReportsFiltersGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EReportsFiltersGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CheckEditRepositoryItem, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemTextEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'EReportsFiltersTools
        '
        Me.EReportsFiltersTools.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.EReportsFiltersTools.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportButton, Me.SaveButton, Me.ToolStripSeparator1, Me.CancelChangesButton, Me.AddCalculatedColumnButton, Me.ToolStripSeparator2})
        Me.EReportsFiltersTools.Location = New System.Drawing.Point(0, 0)
        Me.EReportsFiltersTools.Name = "EReportsFiltersTools"
        Me.EReportsFiltersTools.Size = New System.Drawing.Size(889, 25)
        Me.EReportsFiltersTools.TabIndex = 5
        Me.EReportsFiltersTools.Text = "ToolStrip1"
        '
        'ExportButton
        '
        Me.ExportButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ExportButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ExportButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Excel16
        Me.ExportButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(23, 22)
        Me.ExportButton.Text = "Export List"
        '
        'SaveButton
        '
        Me.SaveButton.Enabled = False
        Me.SaveButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Save16
        Me.SaveButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(51, 22)
        Me.SaveButton.Text = "Save"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'AddCalculatedColumnButton
        '
        Me.AddCalculatedColumnButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Epsilon16
        Me.AddCalculatedColumnButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AddCalculatedColumnButton.Name = "AddCalculatedColumnButton"
        Me.AddCalculatedColumnButton.Size = New System.Drawing.Size(137, 22)
        Me.AddCalculatedColumnButton.Text = "Add Calculated Column"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'CancelChangesButton
        '
        Me.CancelChangesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Undo16
        Me.CancelChangesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.CancelChangesButton.Name = "CancelChangesButton"
        Me.CancelChangesButton.Size = New System.Drawing.Size(104, 22)
        Me.CancelChangesButton.Text = "Cancel Changes"
        '
        'StudyTableColumnBindingSource
        '
        Me.StudyTableColumnBindingSource.DataSource = GetType(Nrc.DataMart.MySolutions.Library.StudyTableColumn)
        '
        'EReportsFiltersGridControl
        '
        Me.EReportsFiltersGridControl.DataSource = Me.StudyTableColumnBindingSource
        Me.EReportsFiltersGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.EReportsFiltersGridControl.EmbeddedNavigator.Name = ""
        Me.EReportsFiltersGridControl.Location = New System.Drawing.Point(0, 25)
        Me.EReportsFiltersGridControl.MainView = Me.EReportsFiltersGridView
        Me.EReportsFiltersGridControl.Name = "EReportsFiltersGridControl"
        Me.EReportsFiltersGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.CheckEditRepositoryItem, Me.RepositoryItemTextEdit1})
        Me.EReportsFiltersGridControl.Size = New System.Drawing.Size(889, 415)
        Me.EReportsFiltersGridControl.TabIndex = 6
        Me.EReportsFiltersGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.EReportsFiltersGridView})
        '
        'EReportsFiltersGridView
        '
        Me.EReportsFiltersGridView.Appearance.Empty.BackColor = System.Drawing.SystemColors.Control
        Me.EReportsFiltersGridView.Appearance.Empty.Options.UseBackColor = True
        Me.EReportsFiltersGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colName, Me.colIsAvailableOnEReports, Me.colDescription, Me.colDisplayName, Me.colFormula, Me.colIsCalculated})
        Me.EReportsFiltersGridView.GridControl = Me.EReportsFiltersGridControl
        Me.EReportsFiltersGridView.Name = "EReportsFiltersGridView"
        Me.EReportsFiltersGridView.OptionsView.ColumnAutoWidth = False
        Me.EReportsFiltersGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.EReportsFiltersGridView.OptionsView.ShowAutoFilterRow = True
        Me.EReportsFiltersGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colName, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.OptionsColumn.ReadOnly = True
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        Me.colName.Width = 93
        '
        'colIsAvailableOnEReports
        '
        Me.colIsAvailableOnEReports.AppearanceHeader.Options.UseTextOptions = True
        Me.colIsAvailableOnEReports.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center
        Me.colIsAvailableOnEReports.Caption = "Filter on eReports"
        Me.colIsAvailableOnEReports.ColumnEdit = Me.CheckEditRepositoryItem
        Me.colIsAvailableOnEReports.FieldName = "IsAvailableOnEReports"
        Me.colIsAvailableOnEReports.Name = "colIsAvailableOnEReports"
        Me.colIsAvailableOnEReports.Visible = True
        Me.colIsAvailableOnEReports.VisibleIndex = 0
        Me.colIsAvailableOnEReports.Width = 116
        '
        'CheckEditRepositoryItem
        '
        Me.CheckEditRepositoryItem.AutoHeight = False
        Me.CheckEditRepositoryItem.Name = "CheckEditRepositoryItem"
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        Me.colDescription.OptionsColumn.ReadOnly = True
        Me.colDescription.Visible = True
        Me.colDescription.VisibleIndex = 2
        Me.colDescription.Width = 134
        '
        'colDisplayName
        '
        Me.colDisplayName.Caption = "Display Name"
        Me.colDisplayName.ColumnEdit = Me.RepositoryItemTextEdit1
        Me.colDisplayName.FieldName = "DisplayName"
        Me.colDisplayName.Name = "colDisplayName"
        Me.colDisplayName.Visible = True
        Me.colDisplayName.VisibleIndex = 3
        Me.colDisplayName.Width = 149
        '
        'RepositoryItemTextEdit1
        '
        Me.RepositoryItemTextEdit1.AutoHeight = False
        Me.RepositoryItemTextEdit1.Name = "RepositoryItemTextEdit1"
        '
        'colFormula
        '
        Me.colFormula.Caption = "Formula"
        Me.colFormula.FieldName = "Formula"
        Me.colFormula.Name = "colFormula"
        Me.colFormula.OptionsColumn.ReadOnly = True
        Me.colFormula.Visible = True
        Me.colFormula.VisibleIndex = 5
        Me.colFormula.Width = 414
        '
        'colIsCalculated
        '
        Me.colIsCalculated.Caption = "IsCalculated"
        Me.colIsCalculated.FieldName = "IsCalculated"
        Me.colIsCalculated.Name = "colIsCalculated"
        Me.colIsCalculated.Visible = True
        Me.colIsCalculated.VisibleIndex = 4
        Me.colIsCalculated.Width = 81
        '
        'FileDialog
        '
        Me.FileDialog.Filter = "Excel Files|*.xls|HTML Files|*.html|Text Files|*.txt"
        Me.FileDialog.Title = "Export Data to File"
        '
        'EReportsFiltersEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.EReportsFiltersGridControl)
        Me.Controls.Add(Me.EReportsFiltersTools)
        Me.Name = "EReportsFiltersEditor"
        Me.Size = New System.Drawing.Size(889, 440)
        Me.EReportsFiltersTools.ResumeLayout(False)
        Me.EReportsFiltersTools.PerformLayout()
        CType(Me.StudyTableColumnBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EReportsFiltersGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EReportsFiltersGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CheckEditRepositoryItem, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemTextEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents EReportsFiltersTools As System.Windows.Forms.ToolStrip
    Friend WithEvents ExportButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents StudyTableColumnBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents EReportsFiltersGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents EReportsFiltersGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsAvailableOnEReports As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDisplayName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SaveButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents colFormula As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents FileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents colIsCalculated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents AddCalculatedColumnButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents CancelChangesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents CheckEditRepositoryItem As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents RepositoryItemTextEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit

End Class
