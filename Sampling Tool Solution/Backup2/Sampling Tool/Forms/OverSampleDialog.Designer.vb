<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OverSampleDialog
    Inherits Nrc.Framework.WinForms.DialogForm
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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.dgvOverSample = New System.Windows.Forms.DataGridView
        Me.bsOverSampleData = New System.Windows.Forms.BindingSource(Me.components)
        Me.SurveyDisplayLabelDataGridViewTextBoxColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.PeriodDisplayLabelDataGridViewTextBoxColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.colOverSample = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.colHCAPSOverSample = New System.Windows.Forms.DataGridViewCheckBoxColumn
        CType(Me.dgvOverSample, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsOverSampleData, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Oversample Confirmation"
        Me.mPaneCaption.Size = New System.Drawing.Size(510, 26)
        Me.mPaneCaption.Text = "Oversample Confirmation"
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Location = New System.Drawing.Point(257, 150)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(112, 23)
        Me.btnOK.TabIndex = 3
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(389, 150)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(103, 23)
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'dgvOverSample
        '
        Me.dgvOverSample.AllowUserToAddRows = False
        Me.dgvOverSample.AllowUserToDeleteRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.dgvOverSample.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.dgvOverSample.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvOverSample.AutoGenerateColumns = False
        Me.dgvOverSample.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvOverSample.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.SurveyDisplayLabelDataGridViewTextBoxColumn, Me.PeriodDisplayLabelDataGridViewTextBoxColumn, Me.colOverSample, Me.colHCAPSOverSample})
        Me.dgvOverSample.DataSource = Me.bsOverSampleData
        Me.dgvOverSample.Location = New System.Drawing.Point(16, 49)
        Me.dgvOverSample.Name = "dgvOverSample"
        Me.dgvOverSample.Size = New System.Drawing.Size(476, 85)
        Me.dgvOverSample.TabIndex = 4
        '
        'bsOverSampleData
        '
        Me.bsOverSampleData.DataSource = GetType(Nrc.Qualisys.SamplingTool.SampleDefinition)
        '
        'SurveyDisplayLabelDataGridViewTextBoxColumn
        '
        Me.SurveyDisplayLabelDataGridViewTextBoxColumn.DataPropertyName = "SurveyDisplayLabel"
        Me.SurveyDisplayLabelDataGridViewTextBoxColumn.HeaderText = "Survey"
        Me.SurveyDisplayLabelDataGridViewTextBoxColumn.Name = "SurveyDisplayLabelDataGridViewTextBoxColumn"
        Me.SurveyDisplayLabelDataGridViewTextBoxColumn.ReadOnly = True
        '
        'PeriodDisplayLabelDataGridViewTextBoxColumn
        '
        Me.PeriodDisplayLabelDataGridViewTextBoxColumn.DataPropertyName = "PeriodDisplayLabel"
        Me.PeriodDisplayLabelDataGridViewTextBoxColumn.HeaderText = "Period"
        Me.PeriodDisplayLabelDataGridViewTextBoxColumn.Name = "PeriodDisplayLabelDataGridViewTextBoxColumn"
        Me.PeriodDisplayLabelDataGridViewTextBoxColumn.ReadOnly = True
        '
        'colOverSample
        '
        Me.colOverSample.DataPropertyName = "DoOverSample"
        Me.colOverSample.HeaderText = "Oversample"
        Me.colOverSample.Name = "colOverSample"
        '
        'colHCAPSOverSample
        '
        Me.colHCAPSOverSample.DataPropertyName = "DoHCAHPSOverSample"
        Me.colHCAPSOverSample.HeaderText = "HCAHPS OverSample"
        Me.colHCAPSOverSample.MinimumWidth = 110
        Me.colHCAPSOverSample.Name = "colHCAPSOverSample"
        Me.colHCAPSOverSample.ReadOnly = True
        Me.colHCAPSOverSample.Width = 120
        '
        'OverSampleDialog
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.Caption = "Oversample Confirmation"
        Me.ClientSize = New System.Drawing.Size(512, 192)
        Me.ControlBox = False
        Me.Controls.Add(Me.dgvOverSample)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.MinimumSize = New System.Drawing.Size(520, 200)
        Me.Name = "OverSampleDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.dgvOverSample, 0)
        CType(Me.dgvOverSample, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsOverSampleData, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents bsOverSampleData As System.Windows.Forms.BindingSource
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents dgvOverSample As System.Windows.Forms.DataGridView
    Friend WithEvents SurveyDisplayLabelDataGridViewTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents PeriodDisplayLabelDataGridViewTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents colOverSample As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents colHCAPSOverSample As System.Windows.Forms.DataGridViewCheckBoxColumn
End Class
