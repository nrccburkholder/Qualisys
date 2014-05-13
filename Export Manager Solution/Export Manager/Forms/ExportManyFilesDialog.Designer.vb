<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportManyFilesDialog
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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.FileTypeLabel = New System.Windows.Forms.Label
        Me.FileTypeList = New System.Windows.Forms.ComboBox
        Me.IncludeOnlyReturns = New System.Windows.Forms.CheckBox
        Me.IncludeOnlyDirects = New System.Windows.Forms.CheckBox
        Me.OutputPath = New System.Windows.Forms.TextBox
        Me.CancelDialogButton = New System.Windows.Forms.Button
        Me.OutputFolderLabel = New System.Windows.Forms.Label
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.FolderBrowser = New System.Windows.Forms.FolderBrowserDialog
        Me.ExportButton = New System.Windows.Forms.Button
        Me.ExportDataGrid = New System.Windows.Forms.DataGridView
        Me.ClientColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.StudyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SurveyColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ExportSetColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.FileNameColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Label1 = New System.Windows.Forms.Label
        Me.FlowLayoutPanel1 = New System.Windows.Forms.FlowLayoutPanel
        Me.TeamPanel = New System.Windows.Forms.Panel
        Me.cboTeam = New System.Windows.Forms.ComboBox
        Me.lblTeam = New System.Windows.Forms.Label
        Me.FolderPanel = New System.Windows.Forms.Panel
        Me.FileTypePanel = New System.Windows.Forms.Panel
        Me.DatePanel = New System.Windows.Forms.Panel
        Me.RunDate = New System.Windows.Forms.DateTimePicker
        Me.Label2 = New System.Windows.Forms.Label
        Me.IncludePhoneFields = New System.Windows.Forms.CheckBox
        Me.ButtonPanel = New System.Windows.Forms.Panel
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn5 = New System.Windows.Forms.DataGridViewTextBoxColumn
        CType(Me.ExportDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FlowLayoutPanel1.SuspendLayout()
        Me.TeamPanel.SuspendLayout()
        Me.FolderPanel.SuspendLayout()
        Me.FileTypePanel.SuspendLayout()
        Me.DatePanel.SuspendLayout()
        Me.ButtonPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Export To File"
        Me.mPaneCaption.Size = New System.Drawing.Size(586, 26)
        Me.mPaneCaption.Text = "Export To File"
        '
        'FileTypeLabel
        '
        Me.FileTypeLabel.AutoSize = True
        Me.FileTypeLabel.Location = New System.Drawing.Point(3, 7)
        Me.FileTypeLabel.Name = "FileTypeLabel"
        Me.FileTypeLabel.Size = New System.Drawing.Size(53, 13)
        Me.FileTypeLabel.TabIndex = 14
        Me.FileTypeLabel.Text = "File Type:"
        Me.FileTypeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FileTypeList
        '
        Me.FileTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.FileTypeList.FormattingEnabled = True
        Me.FileTypeList.Location = New System.Drawing.Point(80, 3)
        Me.FileTypeList.Name = "FileTypeList"
        Me.FileTypeList.Size = New System.Drawing.Size(200, 21)
        Me.FileTypeList.TabIndex = 7
        '
        'IncludeOnlyReturns
        '
        Me.IncludeOnlyReturns.AutoSize = True
        Me.IncludeOnlyReturns.Checked = True
        Me.IncludeOnlyReturns.CheckState = System.Windows.Forms.CheckState.Checked
        Me.IncludeOnlyReturns.Location = New System.Drawing.Point(3, 153)
        Me.IncludeOnlyReturns.Name = "IncludeOnlyReturns"
        Me.IncludeOnlyReturns.Size = New System.Drawing.Size(125, 17)
        Me.IncludeOnlyReturns.TabIndex = 10
        Me.IncludeOnlyReturns.Text = "Only Include Returns"
        Me.IncludeOnlyReturns.UseVisualStyleBackColor = True
        '
        'IncludeOnlyDirects
        '
        Me.IncludeOnlyDirects.AutoSize = True
        Me.IncludeOnlyDirects.Checked = True
        Me.IncludeOnlyDirects.CheckState = System.Windows.Forms.CheckState.Checked
        Me.IncludeOnlyDirects.Location = New System.Drawing.Point(3, 176)
        Me.IncludeOnlyDirects.Name = "IncludeOnlyDirects"
        Me.IncludeOnlyDirects.Size = New System.Drawing.Size(154, 17)
        Me.IncludeOnlyDirects.TabIndex = 11
        Me.IncludeOnlyDirects.Text = "Only Include Direct Sample"
        Me.IncludeOnlyDirects.UseVisualStyleBackColor = True
        '
        'OutputPath
        '
        Me.OutputPath.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.OutputPath.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories
        Me.OutputPath.Location = New System.Drawing.Point(80, 2)
        Me.OutputPath.Name = "OutputPath"
        Me.OutputPath.Size = New System.Drawing.Size(390, 20)
        Me.OutputPath.TabIndex = 4
        '
        'CancelDialogButton
        '
        Me.CancelDialogButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelDialogButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelDialogButton.Location = New System.Drawing.Point(494, 3)
        Me.CancelDialogButton.Name = "CancelDialogButton"
        Me.CancelDialogButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelDialogButton.TabIndex = 15
        Me.CancelDialogButton.Text = "Cancel"
        Me.CancelDialogButton.UseVisualStyleBackColor = True
        '
        'OutputFolderLabel
        '
        Me.OutputFolderLabel.AutoSize = True
        Me.OutputFolderLabel.Location = New System.Drawing.Point(3, 6)
        Me.OutputFolderLabel.Name = "OutputFolderLabel"
        Me.OutputFolderLabel.Size = New System.Drawing.Size(71, 13)
        Me.OutputFolderLabel.TabIndex = 21
        Me.OutputFolderLabel.Text = "Output folder:"
        Me.OutputFolderLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(476, 1)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(75, 23)
        Me.BrowseButton.TabIndex = 5
        Me.BrowseButton.Text = "Browse..."
        Me.BrowseButton.UseVisualStyleBackColor = True
        '
        'FolderBrowser
        '
        Me.FolderBrowser.Description = "Select a folder to output the export"
        '
        'ExportButton
        '
        Me.ExportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportButton.Location = New System.Drawing.Point(413, 3)
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(75, 23)
        Me.ExportButton.TabIndex = 14
        Me.ExportButton.Text = "Export"
        Me.ExportButton.UseVisualStyleBackColor = True
        '
        'ExportDataGrid
        '
        Me.ExportDataGrid.AllowUserToAddRows = False
        Me.ExportDataGrid.AllowUserToDeleteRows = False
        Me.ExportDataGrid.AllowUserToOrderColumns = True
        Me.ExportDataGrid.AllowUserToResizeRows = False
        Me.ExportDataGrid.BackgroundColor = System.Drawing.SystemColors.Control
        Me.ExportDataGrid.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        DataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ExportDataGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle1
        Me.ExportDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ExportDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ClientColumn, Me.StudyColumn, Me.SurveyColumn, Me.ExportSetColumn, Me.FileNameColumn})
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ExportDataGrid.DefaultCellStyle = DataGridViewCellStyle2
        Me.ExportDataGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExportDataGrid.Location = New System.Drawing.Point(3, 242)
        Me.ExportDataGrid.MultiSelect = False
        Me.ExportDataGrid.Name = "ExportDataGrid"
        DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ExportDataGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle3
        Me.ExportDataGrid.RowHeadersVisible = False
        Me.ExportDataGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect
        Me.ExportDataGrid.Size = New System.Drawing.Size(573, 201)
        Me.ExportDataGrid.TabIndex = 12
        '
        'ClientColumn
        '
        Me.ClientColumn.HeaderText = "Client"
        Me.ClientColumn.Name = "ClientColumn"
        Me.ClientColumn.ReadOnly = True
        Me.ClientColumn.Width = 114
        '
        'StudyColumn
        '
        Me.StudyColumn.HeaderText = "Study"
        Me.StudyColumn.Name = "StudyColumn"
        Me.StudyColumn.ReadOnly = True
        '
        'SurveyColumn
        '
        Me.SurveyColumn.HeaderText = "Survey"
        Me.SurveyColumn.Name = "SurveyColumn"
        Me.SurveyColumn.ReadOnly = True
        '
        'ExportSetColumn
        '
        Me.ExportSetColumn.HeaderText = "Definition Name"
        Me.ExportSetColumn.Name = "ExportSetColumn"
        Me.ExportSetColumn.ReadOnly = True
        Me.ExportSetColumn.Width = 200
        '
        'FileNameColumn
        '
        Me.FileNameColumn.HeaderText = "File Name"
        Me.FileNameColumn.Name = "FileNameColumn"
        Me.FileNameColumn.Width = 410
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(3, 219)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(71, 20)
        Me.Label1.TabIndex = 21
        Me.Label1.Text = "Output files"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FlowLayoutPanel1
        '
        Me.FlowLayoutPanel1.AutoSize = True
        Me.FlowLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.FlowLayoutPanel1.Controls.Add(Me.TeamPanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.FolderPanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.FileTypePanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.DatePanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludeOnlyReturns)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludeOnlyDirects)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludePhoneFields)
        Me.FlowLayoutPanel1.Controls.Add(Me.Label1)
        Me.FlowLayoutPanel1.Controls.Add(Me.ExportDataGrid)
        Me.FlowLayoutPanel1.Controls.Add(Me.ButtonPanel)
        Me.FlowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FlowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown
        Me.FlowLayoutPanel1.Location = New System.Drawing.Point(1, 1)
        Me.FlowLayoutPanel1.Name = "FlowLayoutPanel1"
        Me.FlowLayoutPanel1.Padding = New System.Windows.Forms.Padding(0, 26, 0, 0)
        Me.FlowLayoutPanel1.Size = New System.Drawing.Size(586, 493)
        Me.FlowLayoutPanel1.TabIndex = 28
        Me.FlowLayoutPanel1.WrapContents = False
        '
        'TeamPanel
        '
        Me.TeamPanel.Controls.Add(Me.cboTeam)
        Me.TeamPanel.Controls.Add(Me.lblTeam)
        Me.TeamPanel.Location = New System.Drawing.Point(1, 27)
        Me.TeamPanel.Margin = New System.Windows.Forms.Padding(1)
        Me.TeamPanel.Name = "TeamPanel"
        Me.TeamPanel.Size = New System.Drawing.Size(573, 32)
        Me.TeamPanel.TabIndex = 1
        Me.TeamPanel.Visible = False
        '
        'cboTeam
        '
        Me.cboTeam.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTeam.FormattingEnabled = True
        Me.cboTeam.Location = New System.Drawing.Point(80, 7)
        Me.cboTeam.Name = "cboTeam"
        Me.cboTeam.Size = New System.Drawing.Size(121, 21)
        Me.cboTeam.TabIndex = 2
        '
        'lblTeam
        '
        Me.lblTeam.AutoSize = True
        Me.lblTeam.Location = New System.Drawing.Point(3, 10)
        Me.lblTeam.Name = "lblTeam"
        Me.lblTeam.Size = New System.Drawing.Size(37, 13)
        Me.lblTeam.TabIndex = 25
        Me.lblTeam.Text = "Team:"
        Me.lblTeam.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FolderPanel
        '
        Me.FolderPanel.Controls.Add(Me.OutputFolderLabel)
        Me.FolderPanel.Controls.Add(Me.BrowseButton)
        Me.FolderPanel.Controls.Add(Me.OutputPath)
        Me.FolderPanel.Location = New System.Drawing.Point(1, 61)
        Me.FolderPanel.Margin = New System.Windows.Forms.Padding(1)
        Me.FolderPanel.Name = "FolderPanel"
        Me.FolderPanel.Size = New System.Drawing.Size(573, 24)
        Me.FolderPanel.TabIndex = 3
        '
        'FileTypePanel
        '
        Me.FileTypePanel.Controls.Add(Me.FileTypeList)
        Me.FileTypePanel.Controls.Add(Me.FileTypeLabel)
        Me.FileTypePanel.Location = New System.Drawing.Point(1, 87)
        Me.FileTypePanel.Margin = New System.Windows.Forms.Padding(1)
        Me.FileTypePanel.Name = "FileTypePanel"
        Me.FileTypePanel.Size = New System.Drawing.Size(573, 28)
        Me.FileTypePanel.TabIndex = 6
        '
        'DatePanel
        '
        Me.DatePanel.Controls.Add(Me.RunDate)
        Me.DatePanel.Controls.Add(Me.Label2)
        Me.DatePanel.Location = New System.Drawing.Point(1, 117)
        Me.DatePanel.Margin = New System.Windows.Forms.Padding(1)
        Me.DatePanel.Name = "DatePanel"
        Me.DatePanel.Size = New System.Drawing.Size(573, 32)
        Me.DatePanel.TabIndex = 8
        '
        'RunDate
        '
        Me.RunDate.Location = New System.Drawing.Point(80, 6)
        Me.RunDate.Name = "RunDate"
        Me.RunDate.Size = New System.Drawing.Size(200, 20)
        Me.RunDate.TabIndex = 9
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(3, 10)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(47, 13)
        Me.Label2.TabIndex = 25
        Me.Label2.Text = "Run On:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'IncludePhoneFields
        '
        Me.IncludePhoneFields.AutoSize = True
        Me.IncludePhoneFields.Location = New System.Drawing.Point(3, 199)
        Me.IncludePhoneFields.Name = "IncludePhoneFields"
        Me.IncludePhoneFields.Size = New System.Drawing.Size(125, 17)
        Me.IncludePhoneFields.TabIndex = 22
        Me.IncludePhoneFields.Text = "Include Phone Fields"
        Me.IncludePhoneFields.UseVisualStyleBackColor = True
        '
        'ButtonPanel
        '
        Me.ButtonPanel.Controls.Add(Me.CancelDialogButton)
        Me.ButtonPanel.Controls.Add(Me.ExportButton)
        Me.ButtonPanel.Location = New System.Drawing.Point(3, 449)
        Me.ButtonPanel.Name = "ButtonPanel"
        Me.ButtonPanel.Size = New System.Drawing.Size(573, 30)
        Me.ButtonPanel.TabIndex = 13
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.HeaderText = "Client"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        Me.DataGridViewTextBoxColumn1.Width = 75
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.HeaderText = "Study"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        Me.DataGridViewTextBoxColumn2.Width = 75
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.HeaderText = "Survey"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        Me.DataGridViewTextBoxColumn3.Width = 75
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.HeaderText = "Definition Name"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        Me.DataGridViewTextBoxColumn4.Width = 150
        '
        'DataGridViewTextBoxColumn5
        '
        Me.DataGridViewTextBoxColumn5.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.DataGridViewTextBoxColumn5.HeaderText = "File Name"
        Me.DataGridViewTextBoxColumn5.Name = "DataGridViewTextBoxColumn5"
        Me.DataGridViewTextBoxColumn5.ReadOnly = True
        '
        'ExportManyFilesDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Caption = "Export To File"
        Me.ClientSize = New System.Drawing.Size(588, 495)
        Me.ControlBox = False
        Me.Controls.Add(Me.FlowLayoutPanel1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "ExportManyFilesDialog"
        Me.Controls.SetChildIndex(Me.FlowLayoutPanel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.ExportDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FlowLayoutPanel1.ResumeLayout(False)
        Me.FlowLayoutPanel1.PerformLayout()
        Me.TeamPanel.ResumeLayout(False)
        Me.TeamPanel.PerformLayout()
        Me.FolderPanel.ResumeLayout(False)
        Me.FolderPanel.PerformLayout()
        Me.FileTypePanel.ResumeLayout(False)
        Me.FileTypePanel.PerformLayout()
        Me.DatePanel.ResumeLayout(False)
        Me.DatePanel.PerformLayout()
        Me.ButtonPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents FileTypeLabel As System.Windows.Forms.Label
    Friend WithEvents FileTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents IncludeOnlyReturns As System.Windows.Forms.CheckBox
    Friend WithEvents IncludeOnlyDirects As System.Windows.Forms.CheckBox
    Friend WithEvents OutputPath As System.Windows.Forms.TextBox
    Friend WithEvents CancelDialogButton As System.Windows.Forms.Button
    Friend WithEvents OutputFolderLabel As System.Windows.Forms.Label
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents FolderBrowser As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents ExportButton As System.Windows.Forms.Button
    Friend WithEvents ExportDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents FlowLayoutPanel1 As System.Windows.Forms.FlowLayoutPanel
    Friend WithEvents FolderPanel As System.Windows.Forms.Panel
    Friend WithEvents ButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents TeamPanel As System.Windows.Forms.Panel
    Friend WithEvents lblTeam As System.Windows.Forms.Label
    Friend WithEvents FileTypePanel As System.Windows.Forms.Panel
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn5 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ClientColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents StudyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents SurveyColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ExportSetColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents FileNameColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DatePanel As System.Windows.Forms.Panel
    Friend WithEvents RunDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents cboTeam As System.Windows.Forms.ComboBox
    Friend WithEvents IncludePhoneFields As System.Windows.Forms.CheckBox
End Class
