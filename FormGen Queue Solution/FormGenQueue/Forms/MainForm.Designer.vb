<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
    Inherits System.Windows.Forms.Form

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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
        Me.MainToolStrip = New System.Windows.Forms.ToolStrip
        Me.ScheduleNextStepsButton = New System.Windows.Forms.ToolStripButton
        Me.FilterButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ChangePriorityButton = New System.Windows.Forms.ToolStripButton
        Me.RescheduleButton = New System.Windows.Forms.ToolStripButton
        Me.FilterTypeList = New System.Windows.Forms.ToolStripComboBox
        Me.ReleaseFilterList = New System.Windows.Forms.ToolStripComboBox
        Me.FilterLabel = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripContainer1 = New System.Windows.Forms.ToolStripContainer
        Me.QueueGrid = New System.Windows.Forms.DataGridView
        Me.ReleasedColumn = New System.Windows.Forms.DataGridViewImageColumn
        Me.ClientColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StudyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SurveyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.MailStepColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.GenerationDateColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.PriorityColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.FormCountColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SurveyTypeColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.GridMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.ChangePriorityToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.RescheduleToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.StatusLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.UserNameLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.VersionLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.EnvironmentLabel = New System.Windows.Forms.ToolStripStatusLabel
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn5 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn6 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn7 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn8 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.MainToolStrip.SuspendLayout()
        Me.ToolStripContainer1.ContentPanel.SuspendLayout()
        Me.ToolStripContainer1.TopToolStripPanel.SuspendLayout()
        Me.ToolStripContainer1.SuspendLayout()
        CType(Me.QueueGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GridMenu.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainToolStrip
        '
        Me.MainToolStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.MainToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ScheduleNextStepsButton, Me.FilterButton, Me.ToolStripSeparator1, Me.ToolStripSeparator2, Me.ChangePriorityButton, Me.RescheduleButton, Me.FilterTypeList, Me.ReleaseFilterList, Me.FilterLabel})
        Me.MainToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.MainToolStrip.Name = "MainToolStrip"
        Me.MainToolStrip.Size = New System.Drawing.Size(822, 25)
        Me.MainToolStrip.Stretch = True
        Me.MainToolStrip.TabIndex = 0
        Me.MainToolStrip.Text = "ToolStrip1"
        '
        'ScheduleNextStepsButton
        '
        Me.ScheduleNextStepsButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ScheduleNextStepsButton.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.SendMail16
        Me.ScheduleNextStepsButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ScheduleNextStepsButton.Name = "ScheduleNextStepsButton"
        Me.ScheduleNextStepsButton.Size = New System.Drawing.Size(23, 22)
        Me.ScheduleNextStepsButton.Text = "Schedule Next Mail Steps"
        '
        'FilterButton
        '
        Me.FilterButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.FilterButton.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.Go16
        Me.FilterButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.FilterButton.Name = "FilterButton"
        Me.FilterButton.Size = New System.Drawing.Size(23, 22)
        Me.FilterButton.Text = "Filter"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'ChangePriorityButton
        '
        Me.ChangePriorityButton.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.Priority16
        Me.ChangePriorityButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ChangePriorityButton.Name = "ChangePriorityButton"
        Me.ChangePriorityButton.Size = New System.Drawing.Size(101, 22)
        Me.ChangePriorityButton.Text = "Change Priority"
        '
        'RescheduleButton
        '
        Me.RescheduleButton.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.Schedule16
        Me.RescheduleButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RescheduleButton.Name = "RescheduleButton"
        Me.RescheduleButton.Size = New System.Drawing.Size(82, 22)
        Me.RescheduleButton.Text = "Reschedule"
        '
        'FilterTypeList
        '
        Me.FilterTypeList.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.FilterTypeList.Items.AddRange(New Object() {"Today", "Custom"})
        Me.FilterTypeList.Name = "FilterTypeList"
        Me.FilterTypeList.Size = New System.Drawing.Size(75, 25)
        '
        'ReleaseFilterList
        '
        Me.ReleaseFilterList.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ReleaseFilterList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ReleaseFilterList.Items.AddRange(New Object() {"All", "Released", "Unreleased"})
        Me.ReleaseFilterList.Name = "ReleaseFilterList"
        Me.ReleaseFilterList.Size = New System.Drawing.Size(80, 25)
        '
        'FilterLabel
        '
        Me.FilterLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.FilterLabel.Name = "FilterLabel"
        Me.FilterLabel.Size = New System.Drawing.Size(40, 22)
        Me.FilterLabel.Text = "Filters:"
        '
        'ToolStripContainer1
        '
        '
        'ToolStripContainer1.ContentPanel
        '
        Me.ToolStripContainer1.ContentPanel.AutoScroll = True
        Me.ToolStripContainer1.ContentPanel.Controls.Add(Me.QueueGrid)
        Me.ToolStripContainer1.ContentPanel.Controls.Add(Me.StatusStrip1)
        Me.ToolStripContainer1.ContentPanel.Size = New System.Drawing.Size(822, 421)
        Me.ToolStripContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ToolStripContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStripContainer1.Name = "ToolStripContainer1"
        Me.ToolStripContainer1.Size = New System.Drawing.Size(822, 446)
        Me.ToolStripContainer1.TabIndex = 1
        Me.ToolStripContainer1.Text = "ToolStripContainer1"
        '
        'ToolStripContainer1.TopToolStripPanel
        '
        Me.ToolStripContainer1.TopToolStripPanel.Controls.Add(Me.MainToolStrip)
        '
        'QueueGrid
        '
        Me.QueueGrid.AllowUserToAddRows = False
        Me.QueueGrid.AllowUserToDeleteRows = False
        Me.QueueGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
        Me.QueueGrid.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.QueueGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
        Me.QueueGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.QueueGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ReleasedColumn, Me.ClientColumn, Me.StudyColumn, Me.SurveyColumn, Me.MailStepColumn, Me.GenerationDateColumn, Me.PriorityColumn, Me.FormCountColumn, Me.SurveyTypeColumn})
        Me.QueueGrid.ContextMenuStrip = Me.GridMenu
        Me.QueueGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.QueueGrid.Location = New System.Drawing.Point(0, 0)
        Me.QueueGrid.Name = "QueueGrid"
        Me.QueueGrid.ReadOnly = True
        Me.QueueGrid.RowHeadersVisible = False
        Me.QueueGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.QueueGrid.Size = New System.Drawing.Size(822, 399)
        Me.QueueGrid.TabIndex = 2
        '
        'ReleasedColumn
        '
        Me.ReleasedColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.ReleasedColumn.HeaderText = "Released"
        Me.ReleasedColumn.MinimumWidth = 65
        Me.ReleasedColumn.Name = "ReleasedColumn"
        Me.ReleasedColumn.ReadOnly = True
        Me.ReleasedColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ReleasedColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.ReleasedColumn.Width = 76
        '
        'ClientColumn
        '
        Me.ClientColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.ClientColumn.HeaderText = "Client"
        Me.ClientColumn.Name = "ClientColumn"
        Me.ClientColumn.ReadOnly = True
        Me.ClientColumn.Width = 59
        '
        'StudyColumn
        '
        Me.StudyColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.StudyColumn.HeaderText = "Study"
        Me.StudyColumn.Name = "StudyColumn"
        Me.StudyColumn.ReadOnly = True
        Me.StudyColumn.Width = 60
        '
        'SurveyColumn
        '
        Me.SurveyColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SurveyColumn.HeaderText = "Survey"
        Me.SurveyColumn.Name = "SurveyColumn"
        Me.SurveyColumn.ReadOnly = True
        Me.SurveyColumn.Width = 66
        '
        'MailStepColumn
        '
        Me.MailStepColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.MailStepColumn.HeaderText = "Mail Step"
        Me.MailStepColumn.Name = "MailStepColumn"
        Me.MailStepColumn.ReadOnly = True
        Me.MailStepColumn.Width = 75
        '
        'GenerationDateColumn
        '
        Me.GenerationDateColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.GenerationDateColumn.HeaderText = "Generation Date"
        Me.GenerationDateColumn.Name = "GenerationDateColumn"
        Me.GenerationDateColumn.ReadOnly = True
        Me.GenerationDateColumn.Width = 111
        '
        'PriorityColumn
        '
        Me.PriorityColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.PriorityColumn.HeaderText = "Priority"
        Me.PriorityColumn.Name = "PriorityColumn"
        Me.PriorityColumn.ReadOnly = True
        Me.PriorityColumn.Width = 66
        '
        'FormCountColumn
        '
        Me.FormCountColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.FormCountColumn.HeaderText = "Form Count"
        Me.FormCountColumn.MinimumWidth = 50
        Me.FormCountColumn.Name = "FormCountColumn"
        Me.FormCountColumn.ReadOnly = True
        Me.FormCountColumn.Width = 88
        '
        'SurveyTypeColumn
        '
        Me.SurveyTypeColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.SurveyTypeColumn.HeaderText = "Survey Type"
        Me.SurveyTypeColumn.MinimumWidth = 50
        Me.SurveyTypeColumn.Name = "SurveyTypeColumn"
        Me.SurveyTypeColumn.ReadOnly = True
        Me.SurveyTypeColumn.Width = 93
        '
        'GridMenu
        '
        Me.GridMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ChangePriorityToolStripMenuItem, Me.RescheduleToolStripMenuItem})
        Me.GridMenu.Name = "GridMenu"
        Me.GridMenu.Size = New System.Drawing.Size(149, 48)
        '
        'ChangePriorityToolStripMenuItem
        '
        Me.ChangePriorityToolStripMenuItem.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.Priority16
        Me.ChangePriorityToolStripMenuItem.Name = "ChangePriorityToolStripMenuItem"
        Me.ChangePriorityToolStripMenuItem.Size = New System.Drawing.Size(148, 22)
        Me.ChangePriorityToolStripMenuItem.Text = "Change Priority"
        '
        'RescheduleToolStripMenuItem
        '
        Me.RescheduleToolStripMenuItem.Image = Global.Nrc.Qualisys.FormGenQueue.My.Resources.Resources.Schedule16
        Me.RescheduleToolStripMenuItem.Name = "RescheduleToolStripMenuItem"
        Me.RescheduleToolStripMenuItem.Size = New System.Drawing.Size(148, 22)
        Me.RescheduleToolStripMenuItem.Text = "Reschedule"
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StatusLabel, Me.UserNameLabel, Me.VersionLabel, Me.EnvironmentLabel})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 399)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(822, 22)
        Me.StatusStrip1.TabIndex = 3
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'StatusLabel
        '
        Me.StatusLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.StatusLabel.Name = "StatusLabel"
        Me.StatusLabel.Size = New System.Drawing.Size(649, 17)
        Me.StatusLabel.Spring = True
        Me.StatusLabel.Text = "Ready."
        Me.StatusLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'UserNameLabel
        '
        Me.UserNameLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(35, 17)
        Me.UserNameLabel.Text = "JDoe"
        '
        'VersionLabel
        '
        Me.VersionLabel.BorderSides = System.Windows.Forms.ToolStripStatusLabelBorderSides.Right
        Me.VersionLabel.Name = "VersionLabel"
        Me.VersionLabel.Size = New System.Drawing.Size(53, 17)
        Me.VersionLabel.Text = "v1.0.0.0"
        '
        'EnvironmentLabel
        '
        Me.EnvironmentLabel.Name = "EnvironmentLabel"
        Me.EnvironmentLabel.Size = New System.Drawing.Size(70, 17)
        Me.EnvironmentLabel.Text = "Development"
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn1.HeaderText = "Client"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn2.HeaderText = "Study"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn3.HeaderText = "Survey"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn4.HeaderText = "Mail Step"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        '
        'DataGridViewTextBoxColumn5
        '
        Me.DataGridViewTextBoxColumn5.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn5.HeaderText = "Generation Date"
        Me.DataGridViewTextBoxColumn5.Name = "DataGridViewTextBoxColumn5"
        Me.DataGridViewTextBoxColumn5.ReadOnly = True
        '
        'DataGridViewTextBoxColumn6
        '
        Me.DataGridViewTextBoxColumn6.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn6.HeaderText = "Priority"
        Me.DataGridViewTextBoxColumn6.Name = "DataGridViewTextBoxColumn6"
        Me.DataGridViewTextBoxColumn6.ReadOnly = True
        '
        'DataGridViewTextBoxColumn7
        '
        Me.DataGridViewTextBoxColumn7.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.DataGridViewTextBoxColumn7.HeaderText = "Form Count"
        Me.DataGridViewTextBoxColumn7.Name = "DataGridViewTextBoxColumn7"
        Me.DataGridViewTextBoxColumn7.ReadOnly = True
        '
        'DataGridViewTextBoxColumn8
        '
        Me.DataGridViewTextBoxColumn8.HeaderText = "Released"
        Me.DataGridViewTextBoxColumn8.Name = "DataGridViewTextBoxColumn8"
        Me.DataGridViewTextBoxColumn8.ReadOnly = True
        Me.DataGridViewTextBoxColumn8.Width = 76
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(822, 446)
        Me.Controls.Add(Me.ToolStripContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(750, 350)
        Me.Name = "MainForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Form Generation Queue"
        Me.MainToolStrip.ResumeLayout(False)
        Me.MainToolStrip.PerformLayout()
        Me.ToolStripContainer1.ContentPanel.ResumeLayout(False)
        Me.ToolStripContainer1.ContentPanel.PerformLayout()
        Me.ToolStripContainer1.TopToolStripPanel.ResumeLayout(False)
        Me.ToolStripContainer1.TopToolStripPanel.PerformLayout()
        Me.ToolStripContainer1.ResumeLayout(False)
        Me.ToolStripContainer1.PerformLayout()
        CType(Me.QueueGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GridMenu.ResumeLayout(False)
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ToolStripContainer1 As System.Windows.Forms.ToolStripContainer
    Friend WithEvents ScheduleNextStepsButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents GridMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents ChangePriorityToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RescheduleToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents FilterButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents QueueGrid As System.Windows.Forms.DataGridView
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn5 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn6 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn7 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn8 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ChangePriorityButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents RescheduleButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FilterTypeList As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents FilterLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents StatusLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents EnvironmentLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents UserNameLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents VersionLabel As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ReleaseFilterList As System.Windows.Forms.ToolStripComboBox
    Friend WithEvents ReleasedColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents ClientColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StudyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SurveyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MailStepColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents GenerationDateColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents PriorityColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents FormCountColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SurveyTypeColumn As System.Windows.Forms.DataGridViewTextBoxColumn
End Class
