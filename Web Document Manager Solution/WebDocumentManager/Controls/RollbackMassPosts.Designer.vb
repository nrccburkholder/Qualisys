<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RollbackMassPosts
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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RollbackMassPosts))
        Me.DocumentBatchBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.DocumentBatchGridControl = New DevExpress.XtraGrid.GridControl
        Me.BatchesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colCreationDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAuthorName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.BatchesToolStrip = New System.Windows.Forms.ToolStrip
        Me.FilterButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.ShowDocumentsButton = New System.Windows.Forms.ToolStripButton
        Me.RollBackButton = New System.Windows.Forms.Button
        Me.MassPostDocumentsSection = New NRC.Framework.WinForms.SectionPanel
        Me.MassPostDocumentGridControl = New DevExpress.XtraGrid.GridControl
        Me.MassPostDocumentBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.DocumentsGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colTreeGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOrgUnitName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNodePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colWebLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.NoBatchesLabel = New System.Windows.Forms.Label
        CType(Me.DocumentBatchBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DocumentBatchGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BatchesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BatchesToolStrip.SuspendLayout()
        Me.MassPostDocumentsSection.SuspendLayout()
        CType(Me.MassPostDocumentGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MassPostDocumentBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DocumentsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'DocumentBatchBindingSource
        '
        Me.DocumentBatchBindingSource.DataSource = GetType(NRC.DataMart.WebDocumentManager.Library.DocumentBatch)
        '
        'DocumentBatchGridControl
        '
        Me.DocumentBatchGridControl.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DocumentBatchGridControl.DataSource = Me.DocumentBatchBindingSource
        Me.DocumentBatchGridControl.EmbeddedNavigator.Name = ""
        Me.DocumentBatchGridControl.Location = New System.Drawing.Point(0, 28)
        Me.DocumentBatchGridControl.MainView = Me.BatchesGridView
        Me.DocumentBatchGridControl.Name = "DocumentBatchGridControl"
        Me.DocumentBatchGridControl.Size = New System.Drawing.Size(690, 212)
        Me.DocumentBatchGridControl.TabIndex = 0
        Me.DocumentBatchGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.BatchesGridView})
        '
        'BatchesGridView
        '
        Me.BatchesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colCreationDate, Me.colName, Me.colAuthorName})
        Me.BatchesGridView.GridControl = Me.DocumentBatchGridControl
        Me.BatchesGridView.Name = "BatchesGridView"
        Me.BatchesGridView.OptionsBehavior.Editable = False
        Me.BatchesGridView.OptionsCustomization.AllowGroup = False
        Me.BatchesGridView.OptionsView.ShowGroupPanel = False
        '
        'colCreationDate
        '
        Me.colCreationDate.Caption = "Creation Date"
        Me.colCreationDate.DisplayFormat.FormatString = "g"
        Me.colCreationDate.DisplayFormat.FormatType = DevExpress.Utils.FormatType.DateTime
        Me.colCreationDate.FieldName = "CreationDate"
        Me.colCreationDate.Name = "colCreationDate"
        Me.colCreationDate.OptionsColumn.ReadOnly = True
        Me.colCreationDate.Visible = True
        Me.colCreationDate.VisibleIndex = 1
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        '
        'colAuthorName
        '
        Me.colAuthorName.Caption = "Associate"
        Me.colAuthorName.FieldName = "AuthorName"
        Me.colAuthorName.Name = "colAuthorName"
        Me.colAuthorName.OptionsColumn.ReadOnly = True
        Me.colAuthorName.Visible = True
        Me.colAuthorName.VisibleIndex = 2
        '
        'BatchesToolStrip
        '
        Me.BatchesToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FilterButton, Me.ToolStripSeparator1, Me.ShowDocumentsButton})
        Me.BatchesToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.BatchesToolStrip.Name = "BatchesToolStrip"
        Me.BatchesToolStrip.Size = New System.Drawing.Size(701, 25)
        Me.BatchesToolStrip.TabIndex = 1
        Me.BatchesToolStrip.Text = "ToolStrip1"
        '
        'FilterButton
        '
        Me.FilterButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterButton.Image = Global.NRCWebDocumentManager.My.Resources.Resources.GoLtr
        Me.FilterButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterButton.Name = "FilterButton"
        Me.FilterButton.Size = New System.Drawing.Size(23, 22)
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'ShowDocumentsButton
        '
        Me.ShowDocumentsButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ShowDocumentsButton.Image = CType(resources.GetObject("ShowDocumentsButton.Image"), System.Drawing.Image)
        Me.ShowDocumentsButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ShowDocumentsButton.Name = "ShowDocumentsButton"
        Me.ShowDocumentsButton.Size = New System.Drawing.Size(93, 22)
        Me.ShowDocumentsButton.Text = "Show Documents"
        '
        'RollBackButton
        '
        Me.RollBackButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.RollBackButton.Enabled = False
        Me.RollBackButton.Location = New System.Drawing.Point(313, 569)
        Me.RollBackButton.Name = "RollBackButton"
        Me.RollBackButton.Size = New System.Drawing.Size(75, 23)
        Me.RollBackButton.TabIndex = 3
        Me.RollBackButton.Text = "RollBack"
        Me.RollBackButton.UseVisualStyleBackColor = True
        '
        'MassPostDocumentsSection
        '
        Me.MassPostDocumentsSection.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MassPostDocumentsSection.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MassPostDocumentsSection.Caption = "Documents"
        Me.MassPostDocumentsSection.Controls.Add(Me.MassPostDocumentGridControl)
        Me.MassPostDocumentsSection.Location = New System.Drawing.Point(3, 245)
        Me.MassPostDocumentsSection.Name = "MassPostDocumentsSection"
        Me.MassPostDocumentsSection.Padding = New System.Windows.Forms.Padding(1)
        Me.MassPostDocumentsSection.ShowCaption = True
        Me.MassPostDocumentsSection.Size = New System.Drawing.Size(686, 316)
        Me.MassPostDocumentsSection.TabIndex = 5
        '
        'MassPostDocumentGridControl
        '
        Me.MassPostDocumentGridControl.DataSource = Me.MassPostDocumentBindingSource
        Me.MassPostDocumentGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MassPostDocumentGridControl.EmbeddedNavigator.Name = ""
        Me.MassPostDocumentGridControl.Location = New System.Drawing.Point(1, 27)
        Me.MassPostDocumentGridControl.MainView = Me.DocumentsGridView
        Me.MassPostDocumentGridControl.Name = "MassPostDocumentGridControl"
        Me.MassPostDocumentGridControl.Size = New System.Drawing.Size(684, 288)
        Me.MassPostDocumentGridControl.TabIndex = 3
        Me.MassPostDocumentGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.DocumentsGridView})
        '
        'MassPostDocumentBindingSource
        '
        Me.MassPostDocumentBindingSource.DataSource = GetType(NRC.DataMart.WebDocumentManager.Library.MassPostDocument)
        '
        'DocumentsGridView
        '
        Me.DocumentsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colTreeGroupName, Me.colGroupName, Me.colOrgUnitName, Me.colFileName, Me.colNodePath, Me.colWebLabel})
        Me.DocumentsGridView.GridControl = Me.MassPostDocumentGridControl
        Me.DocumentsGridView.Name = "DocumentsGridView"
        Me.DocumentsGridView.OptionsBehavior.Editable = False
        Me.DocumentsGridView.OptionsCustomization.AllowGroup = False
        Me.DocumentsGridView.OptionsSelection.MultiSelect = True
        Me.DocumentsGridView.OptionsView.ShowGroupPanel = False
        '
        'colTreeGroupName
        '
        Me.colTreeGroupName.Caption = "Tree Group Name"
        Me.colTreeGroupName.FieldName = "TreeGroupName"
        Me.colTreeGroupName.Name = "colTreeGroupName"
        Me.colTreeGroupName.OptionsColumn.ReadOnly = True
        Me.colTreeGroupName.Visible = True
        Me.colTreeGroupName.VisibleIndex = 5
        '
        'colGroupName
        '
        Me.colGroupName.Caption = "Group Name"
        Me.colGroupName.FieldName = "GroupName"
        Me.colGroupName.Name = "colGroupName"
        Me.colGroupName.OptionsColumn.ReadOnly = True
        Me.colGroupName.Visible = True
        Me.colGroupName.VisibleIndex = 1
        '
        'colOrgUnitName
        '
        Me.colOrgUnitName.Caption = "Org Unit Name"
        Me.colOrgUnitName.FieldName = "OrgUnitName"
        Me.colOrgUnitName.Name = "colOrgUnitName"
        Me.colOrgUnitName.OptionsColumn.ReadOnly = True
        Me.colOrgUnitName.Visible = True
        Me.colOrgUnitName.VisibleIndex = 0
        '
        'colFileName
        '
        Me.colFileName.Caption = "File Name"
        Me.colFileName.FieldName = "FileName"
        Me.colFileName.Name = "colFileName"
        Me.colFileName.OptionsColumn.ReadOnly = True
        Me.colFileName.Visible = True
        Me.colFileName.VisibleIndex = 3
        '
        'colNodePath
        '
        Me.colNodePath.Caption = "Node Path"
        Me.colNodePath.FieldName = "NodePath"
        Me.colNodePath.Name = "colNodePath"
        Me.colNodePath.OptionsColumn.ReadOnly = True
        Me.colNodePath.Visible = True
        Me.colNodePath.VisibleIndex = 2
        '
        'colWebLabel
        '
        Me.colWebLabel.Caption = "Web Label"
        Me.colWebLabel.FieldName = "WebLabel"
        Me.colWebLabel.Name = "colWebLabel"
        Me.colWebLabel.OptionsColumn.ReadOnly = True
        Me.colWebLabel.Visible = True
        Me.colWebLabel.VisibleIndex = 4
        '
        'NoBatchesLabel
        '
        Me.NoBatchesLabel.AutoSize = True
        Me.NoBatchesLabel.Location = New System.Drawing.Point(26, 60)
        Me.NoBatchesLabel.Name = "NoBatchesLabel"
        Me.NoBatchesLabel.Size = New System.Drawing.Size(221, 13)
        Me.NoBatchesLabel.TabIndex = 6
        Me.NoBatchesLabel.Text = "No batches exist for the specified date range."
        Me.NoBatchesLabel.Visible = False
        '
        'RollbackMassPosts
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.NoBatchesLabel)
        Me.Controls.Add(Me.MassPostDocumentsSection)
        Me.Controls.Add(Me.RollBackButton)
        Me.Controls.Add(Me.BatchesToolStrip)
        Me.Controls.Add(Me.DocumentBatchGridControl)
        Me.Name = "RollbackMassPosts"
        Me.Size = New System.Drawing.Size(701, 595)
        CType(Me.DocumentBatchBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DocumentBatchGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BatchesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BatchesToolStrip.ResumeLayout(False)
        Me.BatchesToolStrip.PerformLayout()
        Me.MassPostDocumentsSection.ResumeLayout(False)
        CType(Me.MassPostDocumentGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MassPostDocumentBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DocumentsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DocumentBatchBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents DocumentBatchGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents BatchesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colCreationDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAuthorName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents BatchesToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents FilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RollBackButton As System.Windows.Forms.Button
    Friend WithEvents MassPostDocumentsSection As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents MassPostDocumentBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents MassPostDocumentGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents DocumentsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colTreeGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOrgUnitName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNodePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colWebLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ShowDocumentsButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents NoBatchesLabel As System.Windows.Forms.Label

End Class
