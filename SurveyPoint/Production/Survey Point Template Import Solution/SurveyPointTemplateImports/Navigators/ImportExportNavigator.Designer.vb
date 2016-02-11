<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportExportNavigator
    Inherits Navigator

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
        Me.hsImportExport = New Nrc.Framework.WinForms.HeaderStrip
        Me.cmdTSNewImportExport = New System.Windows.Forms.ToolStripButton
        Me.cmdTSDeleteImportExport = New System.Windows.Forms.ToolStripButton
        Me.cmdTSCopyImportExport = New System.Windows.Forms.ToolStripButton
        Me.grdImportExport = New DevExpress.XtraGrid.GridControl
        Me.grdViewImportExport = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.bsExportDefintions = New System.Windows.Forms.BindingSource(Me.components)
        Me.colExportDefinitionID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSourceFilePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSourceFileTemplateID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportFileTemplateID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSourceFileTemplate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportFileTemplate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.hsImportExport.SuspendLayout()
        CType(Me.grdImportExport, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdViewImportExport, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsExportDefintions, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'hsImportExport
        '
        Me.hsImportExport.AutoSize = False
        Me.hsImportExport.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.hsImportExport.ForeColor = System.Drawing.Color.White
        Me.hsImportExport.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.hsImportExport.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.hsImportExport.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.cmdTSNewImportExport, Me.cmdTSDeleteImportExport, Me.cmdTSCopyImportExport})
        Me.hsImportExport.Location = New System.Drawing.Point(0, 0)
        Me.hsImportExport.Name = "hsImportExport"
        Me.hsImportExport.Size = New System.Drawing.Size(433, 25)
        Me.hsImportExport.TabIndex = 0
        Me.hsImportExport.Text = "HeaderStrip1"
        '
        'cmdTSNewImportExport
        '
        Me.cmdTSNewImportExport.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdTSNewImportExport.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources._New
        Me.cmdTSNewImportExport.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdTSNewImportExport.Name = "cmdTSNewImportExport"
        Me.cmdTSNewImportExport.Size = New System.Drawing.Size(23, 22)
        Me.cmdTSNewImportExport.Text = "New Import Export"
        '
        'cmdTSDeleteImportExport
        '
        Me.cmdTSDeleteImportExport.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdTSDeleteImportExport.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.Delete
        Me.cmdTSDeleteImportExport.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdTSDeleteImportExport.Name = "cmdTSDeleteImportExport"
        Me.cmdTSDeleteImportExport.Size = New System.Drawing.Size(23, 22)
        Me.cmdTSDeleteImportExport.Text = "Delete Import Export"
        '
        'cmdTSCopyImportExport
        '
        Me.cmdTSCopyImportExport.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdTSCopyImportExport.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.Copy
        Me.cmdTSCopyImportExport.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdTSCopyImportExport.Name = "cmdTSCopyImportExport"
        Me.cmdTSCopyImportExport.Size = New System.Drawing.Size(23, 22)
        Me.cmdTSCopyImportExport.Text = "Copy Import Export"
        '
        'grdImportExport
        '
        Me.grdImportExport.DataSource = Me.bsExportDefintions
        Me.grdImportExport.Dock = System.Windows.Forms.DockStyle.Fill
        Me.grdImportExport.EmbeddedNavigator.Name = ""
        Me.grdImportExport.Location = New System.Drawing.Point(0, 25)
        Me.grdImportExport.MainView = Me.grdViewImportExport
        Me.grdImportExport.Name = "grdImportExport"
        Me.grdImportExport.Size = New System.Drawing.Size(433, 507)
        Me.grdImportExport.TabIndex = 1
        Me.grdImportExport.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdViewImportExport})
        '
        'grdViewImportExport
        '
        Me.grdViewImportExport.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colExportDefinitionID, Me.colName, Me.colDescription, Me.colSourceFilePath, Me.colSourceFileTemplateID, Me.colExportFileTemplateID, Me.colSourceFileTemplate, Me.colExportFileTemplate})
        Me.grdViewImportExport.GridControl = Me.grdImportExport
        Me.grdViewImportExport.Name = "grdViewImportExport"
        Me.grdViewImportExport.OptionsBehavior.Editable = False
        Me.grdViewImportExport.OptionsCustomization.AllowFilter = False
        Me.grdViewImportExport.OptionsCustomization.AllowGroup = False
        Me.grdViewImportExport.OptionsView.ShowGroupPanel = False
        '
        'bsExportDefintions
        '
        Me.bsExportDefintions.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_ExportDefinition)
        '
        'colExportDefinitionID
        '
        Me.colExportDefinitionID.Caption = "ExportDefinitionID"
        Me.colExportDefinitionID.FieldName = "ExportDefinitionID"
        Me.colExportDefinitionID.Name = "colExportDefinitionID"
        Me.colExportDefinitionID.OptionsColumn.ReadOnly = True
        Me.colExportDefinitionID.Visible = True
        Me.colExportDefinitionID.VisibleIndex = 0
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        '
        'colSourceFilePath
        '
        Me.colSourceFilePath.Caption = "SourceFilePath"
        Me.colSourceFilePath.FieldName = "SourceFilePath"
        Me.colSourceFilePath.Name = "colSourceFilePath"
        '
        'colSourceFileTemplateID
        '
        Me.colSourceFileTemplateID.Caption = "SourceFileTemplateID"
        Me.colSourceFileTemplateID.FieldName = "SourceFileTemplateID"
        Me.colSourceFileTemplateID.Name = "colSourceFileTemplateID"
        '
        'colExportFileTemplateID
        '
        Me.colExportFileTemplateID.Caption = "ExportFileTemplateID"
        Me.colExportFileTemplateID.FieldName = "ExportFileTemplateID"
        Me.colExportFileTemplateID.Name = "colExportFileTemplateID"
        '
        'colSourceFileTemplate
        '
        Me.colSourceFileTemplate.Caption = "SourceFileTemplate"
        Me.colSourceFileTemplate.FieldName = "SourceFileTemplate"
        Me.colSourceFileTemplate.Name = "colSourceFileTemplate"
        Me.colSourceFileTemplate.OptionsColumn.ReadOnly = True
        '
        'colExportFileTemplate
        '
        Me.colExportFileTemplate.Caption = "ExportFileTemplate"
        Me.colExportFileTemplate.FieldName = "ExportFileTemplate"
        Me.colExportFileTemplate.Name = "colExportFileTemplate"
        Me.colExportFileTemplate.OptionsColumn.ReadOnly = True
        '
        'ImportExportNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.grdImportExport)
        Me.Controls.Add(Me.hsImportExport)
        Me.Name = "ImportExportNavigator"
        Me.Size = New System.Drawing.Size(433, 532)
        Me.hsImportExport.ResumeLayout(False)
        Me.hsImportExport.PerformLayout()
        CType(Me.grdImportExport, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdViewImportExport, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsExportDefintions, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents hsImportExport As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents grdImportExport As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdViewImportExport As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents cmdTSNewImportExport As System.Windows.Forms.ToolStripButton
    Friend WithEvents cmdTSDeleteImportExport As System.Windows.Forms.ToolStripButton
    Friend WithEvents cmdTSCopyImportExport As System.Windows.Forms.ToolStripButton
    Friend WithEvents bsExportDefintions As System.Windows.Forms.BindingSource
    Friend WithEvents colExportDefinitionID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSourceFilePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSourceFileTemplateID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportFileTemplateID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSourceFileTemplate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportFileTemplate As DevExpress.XtraGrid.Columns.GridColumn

End Class
