<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OryxMeasurementSettingsForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Me.btnApply = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnAddMeasurement = New System.Windows.Forms.Button
        Me.gbQuestions = New System.Windows.Forms.GroupBox
        Me.gbScale = New System.Windows.Forms.GroupBox
        Me.grdMapping = New System.Windows.Forms.DataGridView
        Me.lbQuestionText = New System.Windows.Forms.ListBox
        Me.btnRemoveQuestion = New System.Windows.Forms.Button
        Me.lbSelectedQuestions = New System.Windows.Forms.ListBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtQstnCore = New System.Windows.Forms.TextBox
        Me.btnAddQuestion = New System.Windows.Forms.Button
        Me.cbMeasurements = New System.Windows.Forms.ComboBox
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.NRCValue = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ORYXValue = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.ScaleText = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.gbQuestions.SuspendLayout()
        Me.gbScale.SuspendLayout()
        CType(Me.grdMapping, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'btnApply
        '
        Me.btnApply.Location = New System.Drawing.Point(519, 342)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(54, 21)
        Me.btnApply.TabIndex = 12
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'btnOK
        '
        Me.btnOK.Location = New System.Drawing.Point(391, 342)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(62, 21)
        Me.btnOK.TabIndex = 11
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Location = New System.Drawing.Point(459, 342)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(54, 21)
        Me.btnCancel.TabIndex = 10
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'btnAddMeasurement
        '
        Me.btnAddMeasurement.Location = New System.Drawing.Point(223, 7)
        Me.btnAddMeasurement.Name = "btnAddMeasurement"
        Me.btnAddMeasurement.Size = New System.Drawing.Size(75, 21)
        Me.btnAddMeasurement.TabIndex = 9
        Me.btnAddMeasurement.Text = "New"
        Me.btnAddMeasurement.UseVisualStyleBackColor = True
        '
        'gbQuestions
        '
        Me.gbQuestions.Controls.Add(Me.gbScale)
        Me.gbQuestions.Controls.Add(Me.lbQuestionText)
        Me.gbQuestions.Controls.Add(Me.btnRemoveQuestion)
        Me.gbQuestions.Controls.Add(Me.lbSelectedQuestions)
        Me.gbQuestions.Controls.Add(Me.Label1)
        Me.gbQuestions.Controls.Add(Me.txtQstnCore)
        Me.gbQuestions.Controls.Add(Me.btnAddQuestion)
        Me.gbQuestions.Location = New System.Drawing.Point(4, 35)
        Me.gbQuestions.Name = "gbQuestions"
        Me.gbQuestions.Size = New System.Drawing.Size(569, 301)
        Me.gbQuestions.TabIndex = 8
        Me.gbQuestions.TabStop = False
        Me.gbQuestions.Text = "Questions"
        '
        'gbScale
        '
        Me.gbScale.Controls.Add(Me.grdMapping)
        Me.gbScale.Location = New System.Drawing.Point(116, 114)
        Me.gbScale.Name = "gbScale"
        Me.gbScale.Size = New System.Drawing.Size(438, 173)
        Me.gbScale.TabIndex = 19
        Me.gbScale.TabStop = False
        Me.gbScale.Text = "Scale Mapping"
        '
        'grdMapping
        '
        Me.grdMapping.AllowUserToAddRows = False
        Me.grdMapping.AllowUserToDeleteRows = False
        Me.grdMapping.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells
        Me.grdMapping.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.grdMapping.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.NRCValue, Me.ORYXValue, Me.ScaleText})
        Me.grdMapping.Dock = System.Windows.Forms.DockStyle.Fill
        Me.grdMapping.Location = New System.Drawing.Point(3, 16)
        Me.grdMapping.MultiSelect = False
        Me.grdMapping.Name = "grdMapping"
        Me.grdMapping.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect
        Me.grdMapping.Size = New System.Drawing.Size(432, 154)
        Me.grdMapping.TabIndex = 14
        '
        'lbQuestionText
        '
        Me.lbQuestionText.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.lbQuestionText.FormattingEnabled = True
        Me.lbQuestionText.HorizontalScrollbar = True
        Me.lbQuestionText.Location = New System.Drawing.Point(115, 39)
        Me.lbQuestionText.Name = "lbQuestionText"
        Me.lbQuestionText.SelectionMode = System.Windows.Forms.SelectionMode.None
        Me.lbQuestionText.Size = New System.Drawing.Size(438, 69)
        Me.lbQuestionText.TabIndex = 18
        '
        'btnRemoveQuestion
        '
        Me.btnRemoveQuestion.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.btnRemoveQuestion.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnRemoveQuestion.Location = New System.Drawing.Point(6, 267)
        Me.btnRemoveQuestion.Name = "btnRemoveQuestion"
        Me.btnRemoveQuestion.Size = New System.Drawing.Size(104, 21)
        Me.btnRemoveQuestion.TabIndex = 17
        Me.btnRemoveQuestion.Text = "Remove Question"
        Me.btnRemoveQuestion.UseVisualStyleBackColor = True
        '
        'lbSelectedQuestions
        '
        Me.lbSelectedQuestions.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.lbSelectedQuestions.FormattingEnabled = True
        Me.lbSelectedQuestions.Location = New System.Drawing.Point(6, 16)
        Me.lbSelectedQuestions.Name = "lbSelectedQuestions"
        Me.lbSelectedQuestions.Size = New System.Drawing.Size(104, 238)
        Me.lbSelectedQuestions.TabIndex = 16
        Me.ToolTip1.SetToolTip(Me.lbSelectedQuestions, "Selected Questions")
        '
        'Label1
        '
        Me.Label1.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(112, 16)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(39, 13)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "Core #"
        '
        'txtQstnCore
        '
        Me.txtQstnCore.AcceptsReturn = True
        Me.txtQstnCore.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.txtQstnCore.Location = New System.Drawing.Point(159, 13)
        Me.txtQstnCore.Name = "txtQstnCore"
        Me.txtQstnCore.Size = New System.Drawing.Size(66, 20)
        Me.txtQstnCore.TabIndex = 5
        '
        'btnAddQuestion
        '
        Me.btnAddQuestion.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.btnAddQuestion.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnAddQuestion.Location = New System.Drawing.Point(231, 13)
        Me.btnAddQuestion.Name = "btnAddQuestion"
        Me.btnAddQuestion.Size = New System.Drawing.Size(81, 20)
        Me.btnAddQuestion.TabIndex = 4
        Me.btnAddQuestion.Text = "Add Question"
        Me.btnAddQuestion.UseVisualStyleBackColor = True
        '
        'cbMeasurements
        '
        Me.cbMeasurements.FormattingEnabled = True
        Me.cbMeasurements.Location = New System.Drawing.Point(4, 8)
        Me.cbMeasurements.Name = "cbMeasurements"
        Me.cbMeasurements.Size = New System.Drawing.Size(213, 21)
        Me.cbMeasurements.TabIndex = 7
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.DataPropertyName = "Value"
        Me.DataGridViewTextBoxColumn1.HeaderText = "NRC Value"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        Me.DataGridViewTextBoxColumn1.Width = 85
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.DataPropertyName = "Mapping"
        Me.DataGridViewTextBoxColumn2.HeaderText = "ORYX Value"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.Width = 92
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.DataPropertyName = "Label"
        Me.DataGridViewTextBoxColumn3.HeaderText = "Value Text"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        Me.DataGridViewTextBoxColumn3.Width = 53
        '
        'NRCValue
        '
        Me.NRCValue.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.NRCValue.DataPropertyName = "Value"
        Me.NRCValue.HeaderText = "NRC Value"
        Me.NRCValue.Name = "NRCValue"
        Me.NRCValue.ReadOnly = True
        '
        'ORYXValue
        '
        Me.ORYXValue.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.ORYXValue.DataPropertyName = "Mapping"
        Me.ORYXValue.HeaderText = "ORYX Value"
        Me.ORYXValue.Name = "ORYXValue"
        '
        'ScaleText
        '
        Me.ScaleText.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.ScaleText.DataPropertyName = "Label"
        Me.ScaleText.HeaderText = "Text"
        Me.ScaleText.Name = "ScaleText"
        Me.ScaleText.ReadOnly = True
        '
        'OryxMeasurementSettingsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(576, 368)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnApply)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnAddMeasurement)
        Me.Controls.Add(Me.gbQuestions)
        Me.Controls.Add(Me.cbMeasurements)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "OryxMeasurementSettingsForm"
        Me.ShowInTaskbar = False
        Me.Text = "ORYX Measurement Settings"
        Me.gbQuestions.ResumeLayout(False)
        Me.gbQuestions.PerformLayout()
        Me.gbScale.ResumeLayout(False)
        CType(Me.grdMapping, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnAddMeasurement As System.Windows.Forms.Button
    Friend WithEvents gbQuestions As System.Windows.Forms.GroupBox
    Friend WithEvents cbMeasurements As System.Windows.Forms.ComboBox
    Friend WithEvents txtQstnCore As System.Windows.Forms.TextBox
    Friend WithEvents btnAddQuestion As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnRemoveQuestion As System.Windows.Forms.Button
    Friend WithEvents lbSelectedQuestions As System.Windows.Forms.ListBox
    Friend WithEvents lbQuestionText As System.Windows.Forms.ListBox
    Friend WithEvents gbScale As System.Windows.Forms.GroupBox
    Friend WithEvents grdMapping As System.Windows.Forms.DataGridView
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents NRCValue As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ORYXValue As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ScaleText As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
End Class
