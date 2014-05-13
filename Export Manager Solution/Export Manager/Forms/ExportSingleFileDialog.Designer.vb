<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportSingleFileDialog
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
        Me.IncludeOnlyDirects = New System.Windows.Forms.CheckBox
        Me.IncludeOnlyReturns = New System.Windows.Forms.CheckBox
        Me.FileBrowser = New System.Windows.Forms.SaveFileDialog
        Me.OutputFileLabel = New System.Windows.Forms.Label
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.OutputPath = New System.Windows.Forms.TextBox
        Me.ExportButton = New System.Windows.Forms.Button
        Me.CancelDialogButton = New System.Windows.Forms.Button
        Me.FileTypeList = New System.Windows.Forms.ComboBox
        Me.FileTypeLabel = New System.Windows.Forms.Label
        Me.FlowLayoutPanel1 = New System.Windows.Forms.FlowLayoutPanel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.TeamPanel = New System.Windows.Forms.Panel
        Me.cboTeam = New System.Windows.Forms.ComboBox
        Me.lblTeam = New System.Windows.Forms.Label
        Me.FileNamePanel = New System.Windows.Forms.Panel
        Me.FileNameTextBox = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.FilePathPanel = New System.Windows.Forms.Panel
        Me.FileTypePanel = New System.Windows.Forms.Panel
        Me.DatePanel = New System.Windows.Forms.Panel
        Me.RunDate = New System.Windows.Forms.DateTimePicker
        Me.RunDateLabel = New System.Windows.Forms.Label
        Me.ButtonPanel = New System.Windows.Forms.Panel
        Me.FolderBrowserDialog = New System.Windows.Forms.FolderBrowserDialog
        Me.IncludePhoneFields = New System.Windows.Forms.CheckBox
        Me.FlowLayoutPanel1.SuspendLayout()
        Me.TeamPanel.SuspendLayout()
        Me.FileNamePanel.SuspendLayout()
        Me.FilePathPanel.SuspendLayout()
        Me.FileTypePanel.SuspendLayout()
        Me.DatePanel.SuspendLayout()
        Me.ButtonPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Export To File"
        Me.mPaneCaption.Size = New System.Drawing.Size(529, 26)
        Me.mPaneCaption.Text = "Export To File"
        '
        'IncludeOnlyDirects
        '
        Me.IncludeOnlyDirects.AutoSize = True
        Me.IncludeOnlyDirects.Checked = True
        Me.IncludeOnlyDirects.CheckState = System.Windows.Forms.CheckState.Checked
        Me.IncludeOnlyDirects.Location = New System.Drawing.Point(3, 195)
        Me.IncludeOnlyDirects.Name = "IncludeOnlyDirects"
        Me.IncludeOnlyDirects.Size = New System.Drawing.Size(154, 17)
        Me.IncludeOnlyDirects.TabIndex = 13
        Me.IncludeOnlyDirects.Text = "Only Include Direct Sample"
        Me.IncludeOnlyDirects.UseVisualStyleBackColor = True
        '
        'IncludeOnlyReturns
        '
        Me.IncludeOnlyReturns.AutoSize = True
        Me.IncludeOnlyReturns.Checked = True
        Me.IncludeOnlyReturns.CheckState = System.Windows.Forms.CheckState.Checked
        Me.IncludeOnlyReturns.Location = New System.Drawing.Point(3, 172)
        Me.IncludeOnlyReturns.Name = "IncludeOnlyReturns"
        Me.IncludeOnlyReturns.Size = New System.Drawing.Size(125, 17)
        Me.IncludeOnlyReturns.TabIndex = 12
        Me.IncludeOnlyReturns.Text = "Only Include Returns"
        Me.IncludeOnlyReturns.UseVisualStyleBackColor = True
        '
        'FileBrowser
        '
        Me.FileBrowser.Title = "Export to file"
        '
        'OutputFileLabel
        '
        Me.OutputFileLabel.AutoSize = True
        Me.OutputFileLabel.Location = New System.Drawing.Point(2, 8)
        Me.OutputFileLabel.Name = "OutputFileLabel"
        Me.OutputFileLabel.Size = New System.Drawing.Size(58, 13)
        Me.OutputFileLabel.TabIndex = 22
        Me.OutputFileLabel.Text = "Output file:"
        Me.OutputFileLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'BrowseButton
        '
        Me.BrowseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BrowseButton.Location = New System.Drawing.Point(443, 3)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(75, 23)
        Me.BrowseButton.TabIndex = 7
        Me.BrowseButton.Text = "Browse..."
        Me.BrowseButton.UseVisualStyleBackColor = True
        '
        'OutputPath
        '
        Me.OutputPath.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OutputPath.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.OutputPath.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystem
        Me.OutputPath.Location = New System.Drawing.Point(66, 4)
        Me.OutputPath.Name = "OutputPath"
        Me.OutputPath.Size = New System.Drawing.Size(371, 20)
        Me.OutputPath.TabIndex = 6
        Me.OutputPath.TabStop = False
        '
        'ExportButton
        '
        Me.ExportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportButton.Location = New System.Drawing.Point(362, 3)
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(75, 23)
        Me.ExportButton.TabIndex = 15
        Me.ExportButton.Text = "Export"
        Me.ExportButton.UseVisualStyleBackColor = True
        '
        'CancelDialogButton
        '
        Me.CancelDialogButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelDialogButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelDialogButton.Location = New System.Drawing.Point(443, 3)
        Me.CancelDialogButton.Name = "CancelDialogButton"
        Me.CancelDialogButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelDialogButton.TabIndex = 16
        Me.CancelDialogButton.Text = "Cancel"
        Me.CancelDialogButton.UseVisualStyleBackColor = True
        '
        'FileTypeList
        '
        Me.FileTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.FileTypeList.FormattingEnabled = True
        Me.FileTypeList.Location = New System.Drawing.Point(66, 3)
        Me.FileTypeList.Name = "FileTypeList"
        Me.FileTypeList.Size = New System.Drawing.Size(200, 21)
        Me.FileTypeList.TabIndex = 9
        '
        'FileTypeLabel
        '
        Me.FileTypeLabel.AutoSize = True
        Me.FileTypeLabel.Location = New System.Drawing.Point(2, 7)
        Me.FileTypeLabel.Name = "FileTypeLabel"
        Me.FileTypeLabel.Size = New System.Drawing.Size(53, 13)
        Me.FileTypeLabel.TabIndex = 29
        Me.FileTypeLabel.Text = "File Type:"
        Me.FileTypeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FlowLayoutPanel1
        '
        Me.FlowLayoutPanel1.AutoSize = True
        Me.FlowLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.FlowLayoutPanel1.Controls.Add(Me.Panel1)
        Me.FlowLayoutPanel1.Controls.Add(Me.TeamPanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.FileNamePanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.FilePathPanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.FileTypePanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.DatePanel)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludeOnlyReturns)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludeOnlyDirects)
        Me.FlowLayoutPanel1.Controls.Add(Me.IncludePhoneFields)
        Me.FlowLayoutPanel1.Controls.Add(Me.ButtonPanel)
        Me.FlowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FlowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown
        Me.FlowLayoutPanel1.Location = New System.Drawing.Point(1, 1)
        Me.FlowLayoutPanel1.Name = "FlowLayoutPanel1"
        Me.FlowLayoutPanel1.Size = New System.Drawing.Size(529, 279)
        Me.FlowLayoutPanel1.TabIndex = 30
        Me.FlowLayoutPanel1.WrapContents = False
        '
        'Panel1
        '
        Me.Panel1.Location = New System.Drawing.Point(3, 3)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(180, 19)
        Me.Panel1.TabIndex = 26
        '
        'TeamPanel
        '
        Me.TeamPanel.Controls.Add(Me.cboTeam)
        Me.TeamPanel.Controls.Add(Me.lblTeam)
        Me.TeamPanel.Location = New System.Drawing.Point(1, 26)
        Me.TeamPanel.Margin = New System.Windows.Forms.Padding(1)
        Me.TeamPanel.Name = "TeamPanel"
        Me.TeamPanel.Size = New System.Drawing.Size(521, 27)
        Me.TeamPanel.TabIndex = 1
        Me.TeamPanel.Visible = False
        '
        'cboTeam
        '
        Me.cboTeam.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTeam.FormattingEnabled = True
        Me.cboTeam.Location = New System.Drawing.Point(66, 3)
        Me.cboTeam.Name = "cboTeam"
        Me.cboTeam.Size = New System.Drawing.Size(121, 21)
        Me.cboTeam.TabIndex = 2
        '
        'lblTeam
        '
        Me.lblTeam.AutoSize = True
        Me.lblTeam.Location = New System.Drawing.Point(3, 6)
        Me.lblTeam.Name = "lblTeam"
        Me.lblTeam.Size = New System.Drawing.Size(37, 13)
        Me.lblTeam.TabIndex = 0
        Me.lblTeam.Text = "Team:"
        Me.lblTeam.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FileNamePanel
        '
        Me.FileNamePanel.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.FileNamePanel.Controls.Add(Me.FileNameTextBox)
        Me.FileNamePanel.Controls.Add(Me.Label1)
        Me.FileNamePanel.Location = New System.Drawing.Point(1, 55)
        Me.FileNamePanel.Margin = New System.Windows.Forms.Padding(1)
        Me.FileNamePanel.Name = "FileNamePanel"
        Me.FileNamePanel.Size = New System.Drawing.Size(521, 27)
        Me.FileNamePanel.TabIndex = 3
        '
        'FileNameTextBox
        '
        Me.FileNameTextBox.Location = New System.Drawing.Point(66, 4)
        Me.FileNameTextBox.Name = "FileNameTextBox"
        Me.FileNameTextBox.Size = New System.Drawing.Size(200, 20)
        Me.FileNameTextBox.TabIndex = 4
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(2, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(57, 13)
        Me.Label1.TabIndex = 23
        Me.Label1.Text = "File Name:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FilePathPanel
        '
        Me.FilePathPanel.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.FilePathPanel.Controls.Add(Me.OutputPath)
        Me.FilePathPanel.Controls.Add(Me.OutputFileLabel)
        Me.FilePathPanel.Controls.Add(Me.BrowseButton)
        Me.FilePathPanel.Location = New System.Drawing.Point(1, 84)
        Me.FilePathPanel.Margin = New System.Windows.Forms.Padding(1)
        Me.FilePathPanel.Name = "FilePathPanel"
        Me.FilePathPanel.Size = New System.Drawing.Size(521, 27)
        Me.FilePathPanel.TabIndex = 5
        '
        'FileTypePanel
        '
        Me.FileTypePanel.Controls.Add(Me.FileTypeList)
        Me.FileTypePanel.Controls.Add(Me.FileTypeLabel)
        Me.FileTypePanel.Location = New System.Drawing.Point(1, 113)
        Me.FileTypePanel.Margin = New System.Windows.Forms.Padding(1)
        Me.FileTypePanel.Name = "FileTypePanel"
        Me.FileTypePanel.Size = New System.Drawing.Size(457, 26)
        Me.FileTypePanel.TabIndex = 8
        '
        'DatePanel
        '
        Me.DatePanel.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.DatePanel.Controls.Add(Me.RunDate)
        Me.DatePanel.Controls.Add(Me.RunDateLabel)
        Me.DatePanel.Location = New System.Drawing.Point(1, 141)
        Me.DatePanel.Margin = New System.Windows.Forms.Padding(1)
        Me.DatePanel.Name = "DatePanel"
        Me.DatePanel.Size = New System.Drawing.Size(521, 27)
        Me.DatePanel.TabIndex = 10
        '
        'RunDate
        '
        Me.RunDate.Location = New System.Drawing.Point(66, 4)
        Me.RunDate.Name = "RunDate"
        Me.RunDate.Size = New System.Drawing.Size(200, 20)
        Me.RunDate.TabIndex = 11
        '
        'RunDateLabel
        '
        Me.RunDateLabel.AutoSize = True
        Me.RunDateLabel.Location = New System.Drawing.Point(2, 8)
        Me.RunDateLabel.Name = "RunDateLabel"
        Me.RunDateLabel.Size = New System.Drawing.Size(47, 13)
        Me.RunDateLabel.TabIndex = 23
        Me.RunDateLabel.Text = "Run On:"
        Me.RunDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ButtonPanel
        '
        Me.ButtonPanel.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.ButtonPanel.Controls.Add(Me.CancelDialogButton)
        Me.ButtonPanel.Controls.Add(Me.ExportButton)
        Me.ButtonPanel.Location = New System.Drawing.Point(1, 239)
        Me.ButtonPanel.Margin = New System.Windows.Forms.Padding(1)
        Me.ButtonPanel.Name = "ButtonPanel"
        Me.ButtonPanel.Size = New System.Drawing.Size(521, 32)
        Me.ButtonPanel.TabIndex = 14
        '
        'IncludePhoneFields
        '
        Me.IncludePhoneFields.AutoSize = True
        Me.IncludePhoneFields.Location = New System.Drawing.Point(3, 218)
        Me.IncludePhoneFields.Name = "IncludePhoneFields"
        Me.IncludePhoneFields.Size = New System.Drawing.Size(125, 17)
        Me.IncludePhoneFields.TabIndex = 27
        Me.IncludePhoneFields.Text = "Include Phone Fields"
        Me.IncludePhoneFields.UseVisualStyleBackColor = True
        '
        'ExportSingleFileDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Caption = "Export To File"
        Me.ClientSize = New System.Drawing.Size(531, 281)
        Me.ControlBox = False
        Me.Controls.Add(Me.FlowLayoutPanel1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "ExportSingleFileDialog"
        Me.Controls.SetChildIndex(Me.FlowLayoutPanel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.FlowLayoutPanel1.ResumeLayout(False)
        Me.FlowLayoutPanel1.PerformLayout()
        Me.TeamPanel.ResumeLayout(False)
        Me.TeamPanel.PerformLayout()
        Me.FileNamePanel.ResumeLayout(False)
        Me.FileNamePanel.PerformLayout()
        Me.FilePathPanel.ResumeLayout(False)
        Me.FilePathPanel.PerformLayout()
        Me.FileTypePanel.ResumeLayout(False)
        Me.FileTypePanel.PerformLayout()
        Me.DatePanel.ResumeLayout(False)
        Me.DatePanel.PerformLayout()
        Me.ButtonPanel.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents IncludeOnlyDirects As System.Windows.Forms.CheckBox
    Friend WithEvents IncludeOnlyReturns As System.Windows.Forms.CheckBox
    Friend WithEvents FileBrowser As System.Windows.Forms.SaveFileDialog
    Friend WithEvents OutputFileLabel As System.Windows.Forms.Label
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents OutputPath As System.Windows.Forms.TextBox
    Friend WithEvents ExportButton As System.Windows.Forms.Button
    Friend WithEvents CancelDialogButton As System.Windows.Forms.Button
    Friend WithEvents FileTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents FileTypeLabel As System.Windows.Forms.Label
    Friend WithEvents FlowLayoutPanel1 As System.Windows.Forms.FlowLayoutPanel
    Friend WithEvents FileTypePanel As System.Windows.Forms.Panel
    Friend WithEvents FilePathPanel As System.Windows.Forms.Panel
    Friend WithEvents DatePanel As System.Windows.Forms.Panel
    Friend WithEvents RunDateLabel As System.Windows.Forms.Label
    Friend WithEvents ButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents RunDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents FileNamePanel As System.Windows.Forms.Panel
    Friend WithEvents FileNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents FolderBrowserDialog As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents TeamPanel As System.Windows.Forms.Panel
    Friend WithEvents cboTeam As System.Windows.Forms.ComboBox
    Friend WithEvents lblTeam As System.Windows.Forms.Label
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents IncludePhoneFields As System.Windows.Forms.CheckBox
End Class
