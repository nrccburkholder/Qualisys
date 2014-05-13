<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GroupGrid
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
        Me.GroupMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.EditPropertiesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditPrivilegesMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditSurveyAccessToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteGroupToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.GroupTools = New System.Windows.Forms.ToolStrip
        Me.CreateGroupButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.GroupPropertiesButton = New System.Windows.Forms.ToolStripButton
        Me.GroupPrivilegesButton = New System.Windows.Forms.ToolStripButton
        Me.SurveyAccessButton = New System.Windows.Forms.ToolStripButton
        Me.ExportButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteGroupButton = New System.Windows.Forms.ToolStripButton
        Me.GroupBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.GroupGridControl = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEmail = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.FileDialog = New System.Windows.Forms.SaveFileDialog
        Me.GroupMenu.SuspendLayout()
        Me.GroupTools.SuspendLayout()
        CType(Me.GroupBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GroupGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'GroupMenu
        '
        Me.GroupMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.EditPropertiesToolStripMenuItem, Me.EditPrivilegesMenuItem, Me.EditSurveyAccessToolStripMenuItem, Me.ToolStripSeparator3, Me.DeleteGroupToolStripMenuItem})
        Me.GroupMenu.Name = "GroupMenu"
        Me.GroupMenu.Size = New System.Drawing.Size(178, 120)
        '
        'EditPropertiesToolStripMenuItem
        '
        Me.EditPropertiesToolStripMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Properties16
        Me.EditPropertiesToolStripMenuItem.Name = "EditPropertiesToolStripMenuItem"
        Me.EditPropertiesToolStripMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditPropertiesToolStripMenuItem.Text = "Edit Properties..."
        '
        'EditPrivilegesMenuItem
        '
        Me.EditPrivilegesMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.EditPrivilegesMenuItem.Name = "EditPrivilegesMenuItem"
        Me.EditPrivilegesMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditPrivilegesMenuItem.Text = "Edit Privileges..."
        '
        'EditSurveyAccessToolStripMenuItem
        '
        Me.EditSurveyAccessToolStripMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.SurveyAccess16
        Me.EditSurveyAccessToolStripMenuItem.Name = "EditSurveyAccessToolStripMenuItem"
        Me.EditSurveyAccessToolStripMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.EditSurveyAccessToolStripMenuItem.Text = "Edit Survey Access..."
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(174, 6)
        '
        'DeleteGroupToolStripMenuItem
        '
        Me.DeleteGroupToolStripMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteGroupToolStripMenuItem.Name = "DeleteGroupToolStripMenuItem"
        Me.DeleteGroupToolStripMenuItem.Size = New System.Drawing.Size(177, 22)
        Me.DeleteGroupToolStripMenuItem.Text = "Delete Group"
        '
        'GroupTools
        '
        Me.GroupTools.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.GroupTools.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateGroupButton, Me.ToolStripSeparator1, Me.GroupPropertiesButton, Me.GroupPrivilegesButton, Me.SurveyAccessButton, Me.ExportButton, Me.ToolStripSeparator2, Me.DeleteGroupButton})
        Me.GroupTools.Location = New System.Drawing.Point(0, 0)
        Me.GroupTools.Name = "GroupTools"
        Me.GroupTools.Size = New System.Drawing.Size(672, 25)
        Me.GroupTools.TabIndex = 5
        Me.GroupTools.Text = "ToolStrip1"
        '
        'CreateGroupButton
        '
        Me.CreateGroupButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.NewGroup16
        Me.CreateGroupButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.CreateGroupButton.Name = "CreateGroupButton"
        Me.CreateGroupButton.Size = New System.Drawing.Size(80, 22)
        Me.CreateGroupButton.Text = "New Group"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'GroupPropertiesButton
        '
        Me.GroupPropertiesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Properties16
        Me.GroupPropertiesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.GroupPropertiesButton.Name = "GroupPropertiesButton"
        Me.GroupPropertiesButton.Size = New System.Drawing.Size(76, 22)
        Me.GroupPropertiesButton.Text = "Properties"
        '
        'GroupPrivilegesButton
        '
        Me.GroupPrivilegesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.GroupPrivilegesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.GroupPrivilegesButton.Name = "GroupPrivilegesButton"
        Me.GroupPrivilegesButton.Size = New System.Drawing.Size(72, 22)
        Me.GroupPrivilegesButton.Text = "Privileges"
        '
        'SurveyAccessButton
        '
        Me.SurveyAccessButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.SurveyAccess16
        Me.SurveyAccessButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SurveyAccessButton.Name = "SurveyAccessButton"
        Me.SurveyAccessButton.Size = New System.Drawing.Size(97, 22)
        Me.SurveyAccessButton.Text = "Survey Access"
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
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteGroupButton
        '
        Me.DeleteGroupButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteGroupButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteGroupButton.Name = "DeleteGroupButton"
        Me.DeleteGroupButton.Size = New System.Drawing.Size(58, 22)
        Me.DeleteGroupButton.Text = "Delete"
        '
        'GroupBindingSource
        '
        Me.GroupBindingSource.DataSource = GetType(Nrc.NRCAuthLib.Group)
        '
        'GroupGridControl
        '
        Me.GroupGridControl.DataSource = Me.GroupBindingSource
        Me.GroupGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        '
        '
        '
        Me.GroupGridControl.EmbeddedNavigator.Name = ""
        Me.GroupGridControl.Location = New System.Drawing.Point(0, 25)
        Me.GroupGridControl.MainView = Me.GridView1
        Me.GroupGridControl.Name = "GroupGridControl"
        Me.GroupGridControl.Size = New System.Drawing.Size(672, 102)
        Me.GroupGridControl.TabIndex = 8
        Me.GroupGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Appearance.Empty.BackColor = System.Drawing.SystemColors.Control
        Me.GridView1.Appearance.Empty.Options.UseBackColor = True
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colName, Me.colEmail, Me.colDateCreated, Me.colDescription})
        Me.GridView1.GridControl = Me.GroupGridControl
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsDetail.EnableMasterViewMode = False
        Me.GridView1.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.GridView1.OptionsView.EnableAppearanceEvenRow = True
        Me.GridView1.OptionsView.ShowAutoFilterRow = True
        Me.GridView1.OptionsView.ShowGroupPanel = False
        Me.GridView1.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colName, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        '
        'colEmail
        '
        Me.colEmail.Caption = "Email"
        Me.colEmail.FieldName = "Email"
        Me.colEmail.Name = "colEmail"
        Me.colEmail.Visible = True
        Me.colEmail.VisibleIndex = 1
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "DateCreated"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.OptionsColumn.ReadOnly = True
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 2
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        Me.colDescription.Visible = True
        Me.colDescription.VisibleIndex = 3
        '
        'FileDialog
        '
        Me.FileDialog.Filter = "Excel Files|*.xls|HTML Files|*.html|Text Files|*.txt"
        Me.FileDialog.Title = "Export Data to File"
        '
        'GroupGrid
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupGridControl)
        Me.Controls.Add(Me.GroupTools)
        Me.Name = "GroupGrid"
        Me.Size = New System.Drawing.Size(672, 127)
        Me.GroupMenu.ResumeLayout(False)
        Me.GroupTools.ResumeLayout(False)
        Me.GroupTools.PerformLayout()
        CType(Me.GroupBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GroupGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents GroupMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents EditPrivilegesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents GroupTools As System.Windows.Forms.ToolStrip
    Friend WithEvents CreateGroupButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents GroupPropertiesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents GroupPrivilegesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SurveyAccessButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents GroupBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents GroupGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEmail As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents EditPropertiesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditSurveyAccessToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExportButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteGroupButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteGroupToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
