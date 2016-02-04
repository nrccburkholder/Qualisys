<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportNavigator
    Inherits SurveyPointUtilities.Navigator

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
        Dim ToolStripSeparator As System.Windows.Forms.ToolStripSeparator
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExportNavigator))
        Me.ExportGroupsGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.ExportGroupIDColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ExportGroupNameColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ExportGroupGrid = New DevExpress.XtraGrid.GridControl
        Me.ExportGroupBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.ClientExportToolStrip = New System.Windows.Forms.ToolStrip
        Me.ConfigurationButton = New System.Windows.Forms.ToolStripButton
        Me.RunButton = New System.Windows.Forms.ToolStripButton
        Me.LogButton = New System.Windows.Forms.ToolStripButton
        Me.ClientExportGroups = New System.Windows.Forms.ToolStrip
        Me.NewExportGroupButton = New System.Windows.Forms.ToolStripButton
        Me.CopyExportGroupButton = New System.Windows.Forms.ToolStripButton
        Me.DeleteExportGroupButton = New System.Windows.Forms.ToolStripButton
        Me.btnShowSelected = New System.Windows.Forms.ToolStripButton
        Me.btnShowAll = New System.Windows.Forms.ToolStripButton
        Me.ConfigurationMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.NewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CopyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ConfigurationToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RunToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LogToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        ToolStripSeparator = New System.Windows.Forms.ToolStripSeparator
        CType(Me.ExportGroupsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExportGroupGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ExportGroupBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ClientExportToolStrip.SuspendLayout()
        Me.ClientExportGroups.SuspendLayout()
        Me.ConfigurationMenuStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStripSeparator
        '
        ToolStripSeparator.Name = "ToolStripSeparator"
        ToolStripSeparator.Size = New System.Drawing.Size(136, 6)
        '
        'ExportGroupsGridView
        '
        Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = System.Drawing.Color.CornflowerBlue
        Me.ExportGroupsGridView.Appearance.FocusedCell.BorderColor = System.Drawing.Color.Black
        Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = System.Drawing.Color.White
        Me.ExportGroupsGridView.Appearance.FocusedCell.GradientMode = System.Drawing.Drawing2D.LinearGradientMode.ForwardDiagonal
        Me.ExportGroupsGridView.Appearance.FocusedCell.Options.UseBackColor = True
        Me.ExportGroupsGridView.Appearance.FocusedCell.Options.UseBorderColor = True
        Me.ExportGroupsGridView.Appearance.FocusedCell.Options.UseForeColor = True
        Me.ExportGroupsGridView.Appearance.FocusedRow.BackColor = System.Drawing.Color.White
        Me.ExportGroupsGridView.Appearance.FocusedRow.Options.UseBackColor = True
        Me.ExportGroupsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.ExportGroupIDColumn, Me.ExportGroupNameColumn})
        Me.ExportGroupsGridView.GridControl = Me.ExportGroupGrid
        Me.ExportGroupsGridView.Name = "ExportGroupsGridView"
        Me.ExportGroupsGridView.OptionsBehavior.Editable = False
        Me.ExportGroupsGridView.OptionsView.ShowDetailButtons = False
        Me.ExportGroupsGridView.OptionsView.ShowGroupPanel = False
        Me.ExportGroupsGridView.OptionsView.ShowIndicator = False
        Me.ExportGroupsGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.ExportGroupNameColumn, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'ExportGroupIDColumn
        '
        Me.ExportGroupIDColumn.Caption = "ExportGroupID"
        Me.ExportGroupIDColumn.FieldName = "ExportGroupID"
        Me.ExportGroupIDColumn.Name = "ExportGroupIDColumn"
        Me.ExportGroupIDColumn.OptionsFilter.AllowFilter = False
        '
        'ExportGroupNameColumn
        '
        Me.ExportGroupNameColumn.Caption = "Export Groups"
        Me.ExportGroupNameColumn.FieldName = "Name"
        Me.ExportGroupNameColumn.Name = "ExportGroupNameColumn"
        Me.ExportGroupNameColumn.OptionsFilter.AllowFilter = False
        Me.ExportGroupNameColumn.Visible = True
        Me.ExportGroupNameColumn.VisibleIndex = 0
        '
        'ExportGroupGrid
        '
        Me.ExportGroupGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportGroupGrid.DataSource = Me.ExportGroupBindingSource
        Me.ExportGroupGrid.EmbeddedNavigator.Name = ""
        Me.ExportGroupGrid.Location = New System.Drawing.Point(0, 92)
        Me.ExportGroupGrid.MainView = Me.ExportGroupsGridView
        Me.ExportGroupGrid.Name = "ExportGroupGrid"
        Me.ExportGroupGrid.Size = New System.Drawing.Size(435, 351)
        Me.ExportGroupGrid.TabIndex = 6
        Me.ExportGroupGrid.TabStop = False
        Me.ExportGroupGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.ExportGroupsGridView})
        '
        'ExportGroupBindingSource
        '
        Me.ExportGroupBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.ExportGroup)
        '
        'ClientExportToolStrip
        '
        Me.ClientExportToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ClientExportToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ConfigurationButton, Me.RunButton, Me.LogButton})
        Me.ClientExportToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.ClientExportToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.ClientExportToolStrip.Name = "ClientExportToolStrip"
        Me.ClientExportToolStrip.Size = New System.Drawing.Size(435, 71)
        Me.ClientExportToolStrip.TabIndex = 7
        Me.ClientExportToolStrip.Text = "ToolStrip1"
        '
        'ConfigurationButton
        '
        Me.ConfigurationButton.Enabled = False
        Me.ConfigurationButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.configuration
        Me.ConfigurationButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.ConfigurationButton.ImageTransparentColor = System.Drawing.Color.Black
        Me.ConfigurationButton.Name = "ConfigurationButton"
        Me.ConfigurationButton.Size = New System.Drawing.Size(433, 20)
        Me.ConfigurationButton.Text = "Configuration"
        '
        'RunButton
        '
        Me.RunButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.icon_arrow_16x16
        Me.RunButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.RunButton.ImageTransparentColor = System.Drawing.Color.White
        Me.RunButton.Name = "RunButton"
        Me.RunButton.Size = New System.Drawing.Size(433, 20)
        Me.RunButton.Text = "Run"
        '
        'LogButton
        '
        Me.LogButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.viewlogTransparent
        Me.LogButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.LogButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LogButton.Name = "LogButton"
        Me.LogButton.Size = New System.Drawing.Size(433, 20)
        Me.LogButton.Text = "Log"
        '
        'ClientExportGroups
        '
        Me.ClientExportGroups.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClientExportGroups.AutoSize = False
        Me.ClientExportGroups.Dock = System.Windows.Forms.DockStyle.None
        Me.ClientExportGroups.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewExportGroupButton, Me.CopyExportGroupButton, Me.DeleteExportGroupButton, Me.btnShowSelected, Me.btnShowAll})
        Me.ClientExportGroups.Location = New System.Drawing.Point(0, 71)
        Me.ClientExportGroups.Name = "ClientExportGroups"
        Me.ClientExportGroups.Size = New System.Drawing.Size(435, 25)
        Me.ClientExportGroups.TabIndex = 8
        Me.ClientExportGroups.Text = "Client Export Groups"
        '
        'NewExportGroupButton
        '
        Me.NewExportGroupButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.New16
        Me.NewExportGroupButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewExportGroupButton.Name = "NewExportGroupButton"
        Me.NewExportGroupButton.Size = New System.Drawing.Size(48, 22)
        Me.NewExportGroupButton.Text = "New"
        Me.NewExportGroupButton.ToolTipText = "New Export Group"
        '
        'CopyExportGroupButton
        '
        Me.CopyExportGroupButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Copy16
        Me.CopyExportGroupButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.CopyExportGroupButton.Name = "CopyExportGroupButton"
        Me.CopyExportGroupButton.Size = New System.Drawing.Size(52, 22)
        Me.CopyExportGroupButton.Text = "Copy"
        '
        'DeleteExportGroupButton
        '
        Me.DeleteExportGroupButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.DeleteRed16
        Me.DeleteExportGroupButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteExportGroupButton.Name = "DeleteExportGroupButton"
        Me.DeleteExportGroupButton.Size = New System.Drawing.Size(58, 22)
        Me.DeleteExportGroupButton.Text = "Delete"
        '
        'btnShowSelected
        '
        Me.btnShowSelected.Checked = True
        Me.btnShowSelected.CheckOnClick = True
        Me.btnShowSelected.CheckState = System.Windows.Forms.CheckState.Checked
        Me.btnShowSelected.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnShowSelected.Image = CType(resources.GetObject("btnShowSelected.Image"), System.Drawing.Image)
        Me.btnShowSelected.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnShowSelected.Name = "btnShowSelected"
        Me.btnShowSelected.Size = New System.Drawing.Size(81, 22)
        Me.btnShowSelected.Text = "Show Selected"
        Me.btnShowSelected.Visible = False
        '
        'btnShowAll
        '
        Me.btnShowAll.CheckOnClick = True
        Me.btnShowAll.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnShowAll.Image = CType(resources.GetObject("btnShowAll.Image"), System.Drawing.Image)
        Me.btnShowAll.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnShowAll.Name = "btnShowAll"
        Me.btnShowAll.Size = New System.Drawing.Size(51, 22)
        Me.btnShowAll.Text = "Show All"
        Me.btnShowAll.Visible = False
        '
        'ConfigurationMenuStrip
        '
        Me.ConfigurationMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewToolStripMenuItem, Me.CopyToolStripMenuItem, Me.DeleteToolStripMenuItem, ToolStripSeparator, Me.ConfigurationToolStripMenuItem, Me.RunToolStripMenuItem, Me.LogToolStripMenuItem})
        Me.ConfigurationMenuStrip.Name = "ConfigurationMenuStrip"
        Me.ConfigurationMenuStrip.Size = New System.Drawing.Size(140, 142)
        '
        'NewToolStripMenuItem
        '
        Me.NewToolStripMenuItem.Name = "NewToolStripMenuItem"
        Me.NewToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.NewToolStripMenuItem.Text = "New"
        '
        'CopyToolStripMenuItem
        '
        Me.CopyToolStripMenuItem.Name = "CopyToolStripMenuItem"
        Me.CopyToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.CopyToolStripMenuItem.Text = "Copy"
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'ConfigurationToolStripMenuItem
        '
        Me.ConfigurationToolStripMenuItem.Name = "ConfigurationToolStripMenuItem"
        Me.ConfigurationToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.ConfigurationToolStripMenuItem.Text = "Configuration"
        '
        'RunToolStripMenuItem
        '
        Me.RunToolStripMenuItem.Name = "RunToolStripMenuItem"
        Me.RunToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.RunToolStripMenuItem.Text = "Run"
        '
        'LogToolStripMenuItem
        '
        Me.LogToolStripMenuItem.Name = "LogToolStripMenuItem"
        Me.LogToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.LogToolStripMenuItem.Text = "Log"
        '
        'ExportNavigator
        '
        Me.Controls.Add(Me.ClientExportGroups)
        Me.Controls.Add(Me.ClientExportToolStrip)
        Me.Controls.Add(Me.ExportGroupGrid)
        Me.Name = "ExportNavigator"
        Me.Size = New System.Drawing.Size(435, 446)
        CType(Me.ExportGroupsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExportGroupGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ExportGroupBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ClientExportToolStrip.ResumeLayout(False)
        Me.ClientExportToolStrip.PerformLayout()
        Me.ClientExportGroups.ResumeLayout(False)
        Me.ClientExportGroups.PerformLayout()
        Me.ConfigurationMenuStrip.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents ExportGroupsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents ExportGroupGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents ClientExportToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ConfigurationButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RunButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents LogButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ClientExportGroups As System.Windows.Forms.ToolStrip
    Friend WithEvents NewExportGroupButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExportGroupIDColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ExportGroupNameColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ExportGroupBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents CopyExportGroupButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeleteExportGroupButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnShowAll As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnShowSelected As System.Windows.Forms.ToolStripButton
    Friend WithEvents ConfigurationMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents NewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CopyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RunToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LogToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ConfigurationToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
