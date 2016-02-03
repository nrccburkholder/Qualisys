<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FileTemplateNavigator
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
        Me.hsFileTemplateNavigator = New Nrc.Framework.WinForms.HeaderStrip
        Me.cmdFileTemplateAdd = New System.Windows.Forms.ToolStripButton
        Me.cmdFileTemplateDelete = New System.Windows.Forms.ToolStripButton
        Me.cmdFileTemplateCopy = New System.Windows.Forms.ToolStripButton
        Me.bsFileTemplates = New System.Windows.Forms.BindingSource(Me.components)
        Me.grdFileTemplates = New DevExpress.XtraGrid.GridControl
        Me.grdFileTemplatesView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileTemplateID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsFixedLength = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEncodingType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colImportAsString = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colTrimStrings = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colArchive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.hsFileTemplateNavigator.SuspendLayout()
        CType(Me.bsFileTemplates, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdFileTemplates, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdFileTemplatesView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'hsFileTemplateNavigator
        '
        Me.hsFileTemplateNavigator.AutoSize = False
        Me.hsFileTemplateNavigator.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.hsFileTemplateNavigator.ForeColor = System.Drawing.Color.White
        Me.hsFileTemplateNavigator.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.hsFileTemplateNavigator.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.hsFileTemplateNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.cmdFileTemplateAdd, Me.cmdFileTemplateDelete, Me.cmdFileTemplateCopy})
        Me.hsFileTemplateNavigator.Location = New System.Drawing.Point(0, 0)
        Me.hsFileTemplateNavigator.Name = "hsFileTemplateNavigator"
        Me.hsFileTemplateNavigator.Size = New System.Drawing.Size(294, 25)
        Me.hsFileTemplateNavigator.TabIndex = 0
        Me.hsFileTemplateNavigator.Text = "HeaderStrip1"
        '
        'cmdFileTemplateAdd
        '
        Me.cmdFileTemplateAdd.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdFileTemplateAdd.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources._New
        Me.cmdFileTemplateAdd.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdFileTemplateAdd.Name = "cmdFileTemplateAdd"
        Me.cmdFileTemplateAdd.Size = New System.Drawing.Size(23, 22)
        Me.cmdFileTemplateAdd.Text = "Add"
        '
        'cmdFileTemplateDelete
        '
        Me.cmdFileTemplateDelete.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdFileTemplateDelete.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.Delete
        Me.cmdFileTemplateDelete.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdFileTemplateDelete.Name = "cmdFileTemplateDelete"
        Me.cmdFileTemplateDelete.Size = New System.Drawing.Size(23, 22)
        Me.cmdFileTemplateDelete.Text = "Delete"
        '
        'cmdFileTemplateCopy
        '
        Me.cmdFileTemplateCopy.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.cmdFileTemplateCopy.Image = Global.Nrc.SurveyPointTemplateImports.My.Resources.Resources.Copy
        Me.cmdFileTemplateCopy.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.cmdFileTemplateCopy.Name = "cmdFileTemplateCopy"
        Me.cmdFileTemplateCopy.Size = New System.Drawing.Size(23, 22)
        Me.cmdFileTemplateCopy.Text = "Copy"
        '
        'bsFileTemplates
        '
        Me.bsFileTemplates.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_FileTemplate)
        '
        'grdFileTemplates
        '
        Me.grdFileTemplates.DataSource = Me.bsFileTemplates
        Me.grdFileTemplates.Dock = System.Windows.Forms.DockStyle.Fill
        Me.grdFileTemplates.EmbeddedNavigator.Name = ""
        Me.grdFileTemplates.Location = New System.Drawing.Point(0, 25)
        Me.grdFileTemplates.MainView = Me.grdFileTemplatesView
        Me.grdFileTemplates.Name = "grdFileTemplates"
        Me.grdFileTemplates.Size = New System.Drawing.Size(294, 529)
        Me.grdFileTemplates.TabIndex = 1
        Me.grdFileTemplates.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdFileTemplatesView})
        '
        'grdFileTemplatesView
        '
        Me.grdFileTemplatesView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileTemplateID, Me.colName, Me.colDescription, Me.colIsFixedLength, Me.colEncodingType, Me.colImportAsString, Me.colTrimStrings, Me.colDateCreated, Me.colActive, Me.colArchive})
        Me.grdFileTemplatesView.GridControl = Me.grdFileTemplates
        Me.grdFileTemplatesView.Name = "grdFileTemplatesView"
        Me.grdFileTemplatesView.OptionsBehavior.Editable = False
        Me.grdFileTemplatesView.OptionsFilter.AllowFilterEditor = False
        Me.grdFileTemplatesView.OptionsView.ShowGroupPanel = False
        '
        'colFileTemplateID
        '
        Me.colFileTemplateID.Caption = "ID"
        Me.colFileTemplateID.FieldName = "FileTemplateID"
        Me.colFileTemplateID.Name = "colFileTemplateID"
        Me.colFileTemplateID.OptionsColumn.ReadOnly = True
        Me.colFileTemplateID.Visible = True
        Me.colFileTemplateID.VisibleIndex = 0
        Me.colFileTemplateID.Width = 46
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        Me.colName.Width = 227
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        '
        'colIsFixedLength
        '
        Me.colIsFixedLength.Caption = "IsFixedLength"
        Me.colIsFixedLength.FieldName = "IsFixedLength"
        Me.colIsFixedLength.Name = "colIsFixedLength"
        '
        'colEncodingType
        '
        Me.colEncodingType.Caption = "EncodingType"
        Me.colEncodingType.FieldName = "EncodingType"
        Me.colEncodingType.Name = "colEncodingType"
        '
        'colImportAsString
        '
        Me.colImportAsString.Caption = "ImportAsString"
        Me.colImportAsString.FieldName = "ImportAsString"
        Me.colImportAsString.Name = "colImportAsString"
        '
        'colTrimStrings
        '
        Me.colTrimStrings.Caption = "TrimStrings"
        Me.colTrimStrings.FieldName = "TrimStrings"
        Me.colTrimStrings.Name = "colTrimStrings"
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "DateCreated"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        '
        'colActive
        '
        Me.colActive.Caption = "Active"
        Me.colActive.FieldName = "Active"
        Me.colActive.Name = "colActive"
        '
        'colArchive
        '
        Me.colArchive.Caption = "Archive"
        Me.colArchive.FieldName = "Archive"
        Me.colArchive.Name = "colArchive"
        '
        'FileTemplateNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.grdFileTemplates)
        Me.Controls.Add(Me.hsFileTemplateNavigator)
        Me.Name = "FileTemplateNavigator"
        Me.Size = New System.Drawing.Size(294, 554)
        Me.hsFileTemplateNavigator.ResumeLayout(False)
        Me.hsFileTemplateNavigator.PerformLayout()
        CType(Me.bsFileTemplates, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdFileTemplates, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdFileTemplatesView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents hsFileTemplateNavigator As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents cmdFileTemplateAdd As System.Windows.Forms.ToolStripButton
    Friend WithEvents cmdFileTemplateDelete As System.Windows.Forms.ToolStripButton
    Friend WithEvents cmdFileTemplateCopy As System.Windows.Forms.ToolStripButton
    Friend WithEvents bsFileTemplates As System.Windows.Forms.BindingSource
    Friend WithEvents grdFileTemplates As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdFileTemplatesView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colFileTemplateID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsFixedLength As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEncodingType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colImportAsString As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colTrimStrings As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colArchive As DevExpress.XtraGrid.Columns.GridColumn

End Class
