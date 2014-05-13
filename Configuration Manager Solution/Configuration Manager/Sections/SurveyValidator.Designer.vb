<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SurveyValidator
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
        Me.CancelButton = New System.Windows.Forms.Button
        Me.OKButton = New System.Windows.Forms.Button
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.EditorPanel = New System.Windows.Forms.Panel
        Me.CopyToClipboardButton = New System.Windows.Forms.LinkLabel
        Me.CurrentStatusLabel = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.NotValidatedRadioButton = New System.Windows.Forms.RadioButton
        Me.ValidatedFormGenReleasedRadioButton = New System.Windows.Forms.RadioButton
        Me.ValidatedNotFormGenReleasedRadioButton = New System.Windows.Forms.RadioButton
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.PassedGrid = New System.Windows.Forms.DataGridView
        Me.DataGridViewImageColumn1 = New System.Windows.Forms.DataGridViewImageColumn
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Label2 = New System.Windows.Forms.Label
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.WarningsGrid = New System.Windows.Forms.DataGridView
        Me.ImageColumn = New System.Windows.Forms.DataGridViewImageColumn
        Me.ResultColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.RuleColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.AcceptedColumn = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.Label3 = New System.Windows.Forms.Label
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.FailuresGrid = New System.Windows.Forms.DataGridView
        Me.DataGridViewImageColumn2 = New System.Windows.Forms.DataGridViewImageColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Label4 = New System.Windows.Forms.Label
        Me.LastValidationLabel = New System.Windows.Forms.Label
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.InformationBar1 = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.Label1 = New System.Windows.Forms.Label
        Me.BottomPanel.SuspendLayout()
        Me.EditorPanel.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.TableLayoutPanel1.SuspendLayout()
        Me.Panel1.SuspendLayout()
        CType(Me.PassedGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel2.SuspendLayout()
        CType(Me.WarningsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel3.SuspendLayout()
        CType(Me.FailuresGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(605, 7)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(524, 7)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'BottomPanel
        '
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 664)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(685, 35)
        Me.BottomPanel.TabIndex = 6
        '
        'EditorPanel
        '
        Me.EditorPanel.Controls.Add(Me.GroupBox2)
        Me.EditorPanel.Controls.Add(Me.GroupBox1)
        Me.EditorPanel.Controls.Add(Me.TableLayoutPanel1)
        Me.EditorPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.EditorPanel.Location = New System.Drawing.Point(0, 20)
        Me.EditorPanel.Name = "EditorPanel"
        Me.EditorPanel.Size = New System.Drawing.Size(685, 644)
        Me.EditorPanel.TabIndex = 7
        '
        'CopyToClipboardButton
        '
        Me.CopyToClipboardButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CopyToClipboardButton.AutoSize = True
        Me.CopyToClipboardButton.Location = New System.Drawing.Point(575, 4)
        Me.CopyToClipboardButton.Name = "CopyToClipboardButton"
        Me.CopyToClipboardButton.Size = New System.Drawing.Size(90, 13)
        Me.CopyToClipboardButton.TabIndex = 13
        Me.CopyToClipboardButton.TabStop = True
        Me.CopyToClipboardButton.Text = "Copy to Clipboard"
        '
        'CurrentStatusLabel
        '
        Me.CurrentStatusLabel.AutoSize = True
        Me.CurrentStatusLabel.Location = New System.Drawing.Point(6, 16)
        Me.CurrentStatusLabel.Name = "CurrentStatusLabel"
        Me.CurrentStatusLabel.Size = New System.Drawing.Size(40, 13)
        Me.CurrentStatusLabel.TabIndex = 12
        Me.CurrentStatusLabel.Text = "Status:"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.NotValidatedRadioButton)
        Me.GroupBox1.Controls.Add(Me.ValidatedFormGenReleasedRadioButton)
        Me.GroupBox1.Controls.Add(Me.ValidatedNotFormGenReleasedRadioButton)
        Me.GroupBox1.Location = New System.Drawing.Point(244, 3)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(229, 77)
        Me.GroupBox1.TabIndex = 11
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Change Status to:"
        '
        'NotValidatedRadioButton
        '
        Me.NotValidatedRadioButton.AutoSize = True
        Me.NotValidatedRadioButton.Location = New System.Drawing.Point(6, 12)
        Me.NotValidatedRadioButton.Name = "NotValidatedRadioButton"
        Me.NotValidatedRadioButton.Size = New System.Drawing.Size(89, 17)
        Me.NotValidatedRadioButton.TabIndex = 3
        Me.NotValidatedRadioButton.TabStop = True
        Me.NotValidatedRadioButton.Text = "Not Validated"
        Me.NotValidatedRadioButton.UseVisualStyleBackColor = True
        '
        'ValidatedFormGenReleasedRadioButton
        '
        Me.ValidatedFormGenReleasedRadioButton.AutoSize = True
        Me.ValidatedFormGenReleasedRadioButton.Location = New System.Drawing.Point(6, 56)
        Me.ValidatedFormGenReleasedRadioButton.Name = "ValidatedFormGenReleasedRadioButton"
        Me.ValidatedFormGenReleasedRadioButton.Size = New System.Drawing.Size(187, 17)
        Me.ValidatedFormGenReleasedRadioButton.TabIndex = 2
        Me.ValidatedFormGenReleasedRadioButton.TabStop = True
        Me.ValidatedFormGenReleasedRadioButton.Text = "Validated and Form Gen Released"
        Me.ValidatedFormGenReleasedRadioButton.UseVisualStyleBackColor = True
        '
        'ValidatedNotFormGenReleasedRadioButton
        '
        Me.ValidatedNotFormGenReleasedRadioButton.AutoSize = True
        Me.ValidatedNotFormGenReleasedRadioButton.Location = New System.Drawing.Point(6, 34)
        Me.ValidatedNotFormGenReleasedRadioButton.Name = "ValidatedNotFormGenReleasedRadioButton"
        Me.ValidatedNotFormGenReleasedRadioButton.Size = New System.Drawing.Size(213, 17)
        Me.ValidatedNotFormGenReleasedRadioButton.TabIndex = 1
        Me.ValidatedNotFormGenReleasedRadioButton.TabStop = True
        Me.ValidatedNotFormGenReleasedRadioButton.Text = "Validated and NOT Form Gen Released"
        Me.ValidatedNotFormGenReleasedRadioButton.UseVisualStyleBackColor = True
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 1
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.TableLayoutPanel1.Controls.Add(Me.Panel1, 0, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.Panel2, 0, 1)
        Me.TableLayoutPanel1.Controls.Add(Me.Panel3, 0, 2)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(6, 83)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 3
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(674, 555)
        Me.TableLayoutPanel1.TabIndex = 10
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.PassedGrid)
        Me.Panel1.Controls.Add(Me.CopyToClipboardButton)
        Me.Panel1.Controls.Add(Me.Label2)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(3, 3)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(668, 179)
        Me.Panel1.TabIndex = 6
        '
        'PassedGrid
        '
        Me.PassedGrid.AllowUserToAddRows = False
        Me.PassedGrid.AllowUserToDeleteRows = False
        Me.PassedGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PassedGrid.BackgroundColor = System.Drawing.Color.White
        Me.PassedGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.PassedGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DataGridViewImageColumn1, Me.DataGridViewTextBoxColumn1, Me.DataGridViewTextBoxColumn2})
        Me.PassedGrid.Location = New System.Drawing.Point(3, 20)
        Me.PassedGrid.Name = "PassedGrid"
        Me.PassedGrid.ReadOnly = True
        Me.PassedGrid.RowHeadersVisible = False
        Me.PassedGrid.Size = New System.Drawing.Size(662, 155)
        Me.PassedGrid.TabIndex = 4
        '
        'DataGridViewImageColumn1
        '
        Me.DataGridViewImageColumn1.HeaderText = ""
        Me.DataGridViewImageColumn1.Name = "DataGridViewImageColumn1"
        Me.DataGridViewImageColumn1.ReadOnly = True
        Me.DataGridViewImageColumn1.Width = 48
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.HeaderText = "Result"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.DataGridViewTextBoxColumn2.HeaderText = "Rule"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(3, 4)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(48, 13)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "Passed"
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.WarningsGrid)
        Me.Panel2.Controls.Add(Me.Label3)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel2.Location = New System.Drawing.Point(3, 188)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(668, 179)
        Me.Panel2.TabIndex = 7
        '
        'WarningsGrid
        '
        Me.WarningsGrid.AllowUserToAddRows = False
        Me.WarningsGrid.AllowUserToDeleteRows = False
        Me.WarningsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WarningsGrid.BackgroundColor = System.Drawing.Color.White
        Me.WarningsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.WarningsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.ImageColumn, Me.ResultColumn, Me.RuleColumn, Me.AcceptedColumn})
        Me.WarningsGrid.Location = New System.Drawing.Point(0, 22)
        Me.WarningsGrid.Name = "WarningsGrid"
        Me.WarningsGrid.RowHeadersVisible = False
        Me.WarningsGrid.Size = New System.Drawing.Size(668, 157)
        Me.WarningsGrid.TabIndex = 3
        '
        'ImageColumn
        '
        Me.ImageColumn.HeaderText = ""
        Me.ImageColumn.Name = "ImageColumn"
        Me.ImageColumn.Width = 48
        '
        'ResultColumn
        '
        Me.ResultColumn.HeaderText = "Result"
        Me.ResultColumn.Name = "ResultColumn"
        Me.ResultColumn.ReadOnly = True
        '
        'RuleColumn
        '
        Me.RuleColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.RuleColumn.HeaderText = "Rule"
        Me.RuleColumn.Name = "RuleColumn"
        Me.RuleColumn.ReadOnly = True
        '
        'AcceptedColumn
        '
        Me.AcceptedColumn.HeaderText = "Accepted"
        Me.AcceptedColumn.Name = "AcceptedColumn"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(0, 4)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(60, 13)
        Me.Label3.TabIndex = 7
        Me.Label3.Text = "Warnings"
        '
        'Panel3
        '
        Me.Panel3.Controls.Add(Me.FailuresGrid)
        Me.Panel3.Controls.Add(Me.Label4)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel3.Location = New System.Drawing.Point(3, 373)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(668, 179)
        Me.Panel3.TabIndex = 8
        '
        'FailuresGrid
        '
        Me.FailuresGrid.AllowUserToAddRows = False
        Me.FailuresGrid.AllowUserToDeleteRows = False
        Me.FailuresGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FailuresGrid.BackgroundColor = System.Drawing.Color.White
        Me.FailuresGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.FailuresGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DataGridViewImageColumn2, Me.DataGridViewTextBoxColumn3, Me.DataGridViewTextBoxColumn4})
        Me.FailuresGrid.Location = New System.Drawing.Point(3, 24)
        Me.FailuresGrid.Name = "FailuresGrid"
        Me.FailuresGrid.ReadOnly = True
        Me.FailuresGrid.RowHeadersVisible = False
        Me.FailuresGrid.Size = New System.Drawing.Size(668, 160)
        Me.FailuresGrid.TabIndex = 5
        '
        'DataGridViewImageColumn2
        '
        Me.DataGridViewImageColumn2.HeaderText = ""
        Me.DataGridViewImageColumn2.Name = "DataGridViewImageColumn2"
        Me.DataGridViewImageColumn2.ReadOnly = True
        Me.DataGridViewImageColumn2.Width = 48
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.HeaderText = "Result"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.DataGridViewTextBoxColumn4.HeaderText = "Rule"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.Location = New System.Drawing.Point(3, 8)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(51, 13)
        Me.Label4.TabIndex = 8
        Me.Label4.Text = "Failures"
        '
        'LastValidationLabel
        '
        Me.LastValidationLabel.Location = New System.Drawing.Point(85, 35)
        Me.LastValidationLabel.Name = "LastValidationLabel"
        Me.LastValidationLabel.Size = New System.Drawing.Size(138, 38)
        Me.LastValidationLabel.TabIndex = 2
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.CurrentStatusLabel)
        Me.GroupBox2.Controls.Add(Me.Label1)
        Me.GroupBox2.Controls.Add(Me.LastValidationLabel)
        Me.GroupBox2.Location = New System.Drawing.Point(9, 3)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(229, 77)
        Me.GroupBox2.TabIndex = 14
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Current Status:"
        '
        'InformationBar1
        '
        Me.InformationBar1.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar1.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar1.Information = "Information Bar"
        Me.InformationBar1.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar1.Name = "InformationBar1"
        Me.InformationBar1.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar1.Size = New System.Drawing.Size(685, 20)
        Me.InformationBar1.TabIndex = 5
        Me.InformationBar1.Visible = False
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 36)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(79, 13)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Last Validation:"
        '
        'SurveyValidator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.EditorPanel)
        Me.Controls.Add(Me.InformationBar1)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "SurveyValidator"
        Me.Size = New System.Drawing.Size(685, 699)
        Me.BottomPanel.ResumeLayout(False)
        Me.EditorPanel.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        CType(Me.PassedGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        CType(Me.WarningsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel3.ResumeLayout(False)
        Me.Panel3.PerformLayout()
        CType(Me.FailuresGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar1 As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents EditorPanel As System.Windows.Forms.Panel
    Friend WithEvents LastValidationLabel As System.Windows.Forms.Label
    Friend WithEvents WarningsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents FailuresGrid As System.Windows.Forms.DataGridView
    Friend WithEvents PassedGrid As System.Windows.Forms.DataGridView
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents DataGridViewImageColumn2 As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewImageColumn1 As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ImageColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents ResultColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents RuleColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents AcceptedColumn As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents NotValidatedRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents ValidatedFormGenReleasedRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents ValidatedNotFormGenReleasedRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents CurrentStatusLabel As System.Windows.Forms.Label
    Friend WithEvents CopyToClipboardButton As System.Windows.Forms.LinkLabel
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label1 As System.Windows.Forms.Label

End Class
