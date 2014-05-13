<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VendorMaintenenceImportDialog
    Inherits Nrc.Framework.WinForms.DialogForm

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
        Me.DispositionGridControl = New DevExpress.XtraGrid.GridControl
        Me.DispositionContextMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DeleteDispositionToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.VendorDispoBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.DispositionGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colVendorDispositionCode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorDispositionLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colVendorDispositionDesc = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNRCDispo = New DevExpress.XtraGrid.Columns.GridColumn
        Me.NRCDispoLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.DispositionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colHCHAPSDispos = New DevExpress.XtraGrid.Columns.GridColumn
        Me.HCHAPSDisposLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.ButtonPanel = New System.Windows.Forms.Panel
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.SubmitButton = New System.Windows.Forms.Button
        CType(Me.DispositionGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.DispositionContextMenuStrip.SuspendLayout()
        CType(Me.VendorDispoBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DispositionGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NRCDispoLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DispositionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HCHAPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BottomPanel.SuspendLayout()
        Me.ButtonPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Import Vendor Dispositions"
        Me.mPaneCaption.Size = New System.Drawing.Size(821, 26)
        Me.mPaneCaption.Text = "Import Vendor Dispositions"
        '
        'DispositionGridControl
        '
        Me.DispositionGridControl.ContextMenuStrip = Me.DispositionContextMenuStrip
        Me.DispositionGridControl.DataSource = Me.VendorDispoBindingSource
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.EndEdit.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.First.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.Last.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.Next.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.NextPage.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.Prev.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Buttons.PrevPage.Visible = False
        Me.DispositionGridControl.EmbeddedNavigator.Name = ""
        Me.DispositionGridControl.EmbeddedNavigator.TextStringFormat = ""
        Me.DispositionGridControl.Location = New System.Drawing.Point(4, 33)
        Me.DispositionGridControl.MainView = Me.DispositionGridView
        Me.DispositionGridControl.Name = "DispositionGridControl"
        Me.DispositionGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.NRCDispoLookUpEdit, Me.HCHAPSDisposLookUpEdit})
        Me.DispositionGridControl.Size = New System.Drawing.Size(815, 595)
        Me.DispositionGridControl.TabIndex = 1
        Me.DispositionGridControl.UseEmbeddedNavigator = True
        Me.DispositionGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.DispositionGridView})
        '
        'DispositionContextMenuStrip
        '
        Me.DispositionContextMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteDispositionToolStripMenuItem})
        Me.DispositionContextMenuStrip.Name = "DispositionContextMenuStrip"
        Me.DispositionContextMenuStrip.Size = New System.Drawing.Size(171, 26)
        '
        'DeleteDispositionToolStripMenuItem
        '
        Me.DeleteDispositionToolStripMenuItem.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DeleteRed16
        Me.DeleteDispositionToolStripMenuItem.Name = "DeleteDispositionToolStripMenuItem"
        Me.DeleteDispositionToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.DeleteDispositionToolStripMenuItem.Text = "Delete Disposition"
        '
        'VendorDispoBindingSource
        '
        Me.VendorDispoBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.VendorDisposition)
        '
        'DispositionGridView
        '
        Me.DispositionGridView.ActiveFilterEnabled = False
        Me.DispositionGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colVendorDispositionCode, Me.colVendorDispositionLabel, Me.colVendorDispositionDesc, Me.colNRCDispo, Me.colHCHAPSDispos})
        Me.DispositionGridView.GridControl = Me.DispositionGridControl
        Me.DispositionGridView.Name = "DispositionGridView"
        Me.DispositionGridView.NewItemRowText = "Click Here to Add a New Disposition"
        Me.DispositionGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.DispositionGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colVendorDispositionCode
        '
        Me.colVendorDispositionCode.Caption = "Vendor Dispo"
        Me.colVendorDispositionCode.FieldName = "VendorDispositionCode"
        Me.colVendorDispositionCode.Name = "colVendorDispositionCode"
        Me.colVendorDispositionCode.OptionsColumn.ReadOnly = True
        Me.colVendorDispositionCode.Visible = True
        Me.colVendorDispositionCode.VisibleIndex = 0
        '
        'colVendorDispositionLabel
        '
        Me.colVendorDispositionLabel.Caption = "Label"
        Me.colVendorDispositionLabel.FieldName = "VendorDispositionLabel"
        Me.colVendorDispositionLabel.Name = "colVendorDispositionLabel"
        Me.colVendorDispositionLabel.Visible = True
        Me.colVendorDispositionLabel.VisibleIndex = 1
        '
        'colVendorDispositionDesc
        '
        Me.colVendorDispositionDesc.Caption = "Description"
        Me.colVendorDispositionDesc.FieldName = "VendorDispositionDesc"
        Me.colVendorDispositionDesc.Name = "colVendorDispositionDesc"
        Me.colVendorDispositionDesc.Visible = True
        Me.colVendorDispositionDesc.VisibleIndex = 2
        '
        'colNRCDispo
        '
        Me.colNRCDispo.Caption = "NRC Dispo"
        Me.colNRCDispo.ColumnEdit = Me.NRCDispoLookUpEdit
        Me.colNRCDispo.FieldName = "DispositionId"
        Me.colNRCDispo.Name = "colNRCDispo"
        Me.colNRCDispo.Visible = True
        Me.colNRCDispo.VisibleIndex = 3
        '
        'NRCDispoLookUpEdit
        '
        Me.NRCDispoLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.NRCDispoLookUpEdit.AutoHeight = False
        Me.NRCDispoLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.NRCDispoLookUpEdit.Columns.AddRange(New DevExpress.XtraEditors.Controls.LookUpColumnInfo() {New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Id", "NRC Dispo", 29, DevExpress.Utils.FormatType.Numeric, "", True, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("DispositionLabel", "DispositionLabel", 82, DevExpress.Utils.FormatType.None, "", False, DevExpress.Utils.HorzAlignment.Near, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("ActionId", "ActionId", 46, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("ReportLabel", "Label", 64, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HCAHPSValue", "HCAHPS Dispos", 72, DevExpress.Utils.FormatType.None, "", True, DevExpress.Utils.HorzAlignment.Near), New DevExpress.XtraEditors.Controls.LookUpColumnInfo("HCAHPSHierarchy", "HCAHPSHierarchy", 92, DevExpress.Utils.FormatType.Numeric, "", False, DevExpress.Utils.HorzAlignment.Far, DevExpress.Data.ColumnSortOrder.None)})
        Me.NRCDispoLookUpEdit.DataSource = Me.DispositionBindingSource
        Me.NRCDispoLookUpEdit.DisplayMember = "DispositionLabel"
        Me.NRCDispoLookUpEdit.Name = "NRCDispoLookUpEdit"
        Me.NRCDispoLookUpEdit.ValueMember = "Id"
        '
        'DispositionBindingSource
        '
        Me.DispositionBindingSource.DataSource = GetType(Nrc.QualiSys.Library.Disposition)
        '
        'colHCHAPSDispos
        '
        Me.colHCHAPSDispos.Caption = "HCHAPS Dispos"
        Me.colHCHAPSDispos.ColumnEdit = Me.HCHAPSDisposLookUpEdit
        Me.colHCHAPSDispos.FieldName = "DispositionId"
        Me.colHCHAPSDispos.Name = "colHCHAPSDispos"
        Me.colHCHAPSDispos.OptionsColumn.AllowEdit = False
        Me.colHCHAPSDispos.OptionsColumn.ReadOnly = True
        Me.colHCHAPSDispos.Visible = True
        Me.colHCHAPSDispos.VisibleIndex = 4
        '
        'HCHAPSDisposLookUpEdit
        '
        Me.HCHAPSDisposLookUpEdit.AutoHeight = False
        Me.HCHAPSDisposLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.HCHAPSDisposLookUpEdit.DataSource = Me.DispositionBindingSource
        Me.HCHAPSDisposLookUpEdit.DisplayMember = "HCAHPSValue"
        Me.HCHAPSDisposLookUpEdit.Name = "HCHAPSDisposLookUpEdit"
        Me.HCHAPSDisposLookUpEdit.ValueMember = "Id"
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ButtonPanel)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(1, 634)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(821, 35)
        Me.BottomPanel.TabIndex = 6
        '
        'ButtonPanel
        '
        Me.ButtonPanel.Controls.Add(Me.Cancel_Button)
        Me.ButtonPanel.Controls.Add(Me.SubmitButton)
        Me.ButtonPanel.Dock = System.Windows.Forms.DockStyle.Right
        Me.ButtonPanel.Location = New System.Drawing.Point(619, 0)
        Me.ButtonPanel.Name = "ButtonPanel"
        Me.ButtonPanel.Size = New System.Drawing.Size(200, 33)
        Me.ButtonPanel.TabIndex = 3
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(119, 5)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 3
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'SubmitButton
        '
        Me.SubmitButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SubmitButton.Location = New System.Drawing.Point(38, 5)
        Me.SubmitButton.Name = "SubmitButton"
        Me.SubmitButton.Size = New System.Drawing.Size(75, 23)
        Me.SubmitButton.TabIndex = 2
        Me.SubmitButton.Text = "Submit"
        Me.SubmitButton.UseVisualStyleBackColor = True
        '
        'VendorMaintenenceImportDialog
        '
        Me.Caption = "Import Vendor Dispositions"
        Me.ClientSize = New System.Drawing.Size(823, 670)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.DispositionGridControl)
        Me.Name = "VendorMaintenenceImportDialog"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.DispositionGridControl, 0)
        Me.Controls.SetChildIndex(Me.BottomPanel, 0)
        CType(Me.DispositionGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.DispositionContextMenuStrip.ResumeLayout(False)
        CType(Me.VendorDispoBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DispositionGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NRCDispoLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DispositionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HCHAPSDisposLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BottomPanel.ResumeLayout(False)
        Me.ButtonPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents DispositionGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents DispositionGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colVendorDispositionCode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorDispositionLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colVendorDispositionDesc As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNRCDispo As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents NRCDispoLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents colHCHAPSDispos As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents HCHAPSDisposLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents SubmitButton As System.Windows.Forms.Button
    Friend WithEvents VendorDispoBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents DispositionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents DispositionContextMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents DeleteDispositionToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
