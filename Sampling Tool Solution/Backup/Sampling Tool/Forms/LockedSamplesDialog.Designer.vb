<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LockedSamplesDialog
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
        Me.dgvLockedSamples = New System.Windows.Forms.DataGridView
        Me.btnOK = New System.Windows.Forms.Button
        Me.lblInfo = New System.Windows.Forms.Label
        Me.DataGridViewTextBoxColumn1 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn2 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn3 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.DataGridViewTextBoxColumn4 = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.strSurvey_nm = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Survey_ID = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.MedicareNumber = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.MedicareName = New System.Windows.Forms.DataGridViewTextBoxColumn
        CType(Me.dgvLockedSamples, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Locked Samples"
        Me.mPaneCaption.Size = New System.Drawing.Size(676, 26)
        Me.mPaneCaption.Text = "Locked Samples"
        '
        'dgvLockedSamples
        '
        Me.dgvLockedSamples.AllowUserToAddRows = False
        Me.dgvLockedSamples.AllowUserToDeleteRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.dgvLockedSamples.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.dgvLockedSamples.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvLockedSamples.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLockedSamples.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.strSurvey_nm, Me.Survey_ID, Me.MedicareNumber, Me.MedicareName})
        Me.dgvLockedSamples.Location = New System.Drawing.Point(15, 62)
        Me.dgvLockedSamples.Name = "dgvLockedSamples"
        Me.dgvLockedSamples.ReadOnly = True
        Me.dgvLockedSamples.Size = New System.Drawing.Size(633, 161)
        Me.dgvLockedSamples.TabIndex = 6
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Location = New System.Drawing.Point(536, 238)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(112, 23)
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'lblInfo
        '
        Me.lblInfo.AutoSize = True
        Me.lblInfo.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(204, Byte))
        Me.lblInfo.Location = New System.Drawing.Point(15, 34)
        Me.lblInfo.Name = "lblInfo"
        Me.lblInfo.Size = New System.Drawing.Size(494, 13)
        Me.lblInfo.TabIndex = 7
        Me.lblInfo.Text = "The Following Surveys Can Not Be Sampled Untill The Medicare Number Is Unlocked."
        '
        'DataGridViewTextBoxColumn1
        '
        Me.DataGridViewTextBoxColumn1.DataPropertyName = "Survey_nm"
        Me.DataGridViewTextBoxColumn1.HeaderText = "Survey Name"
        Me.DataGridViewTextBoxColumn1.Name = "DataGridViewTextBoxColumn1"
        Me.DataGridViewTextBoxColumn1.ReadOnly = True
        '
        'DataGridViewTextBoxColumn2
        '
        Me.DataGridViewTextBoxColumn2.DataPropertyName = "Survey_ID"
        Me.DataGridViewTextBoxColumn2.HeaderText = "Survey ID"
        Me.DataGridViewTextBoxColumn2.Name = "DataGridViewTextBoxColumn2"
        Me.DataGridViewTextBoxColumn2.ReadOnly = True
        '
        'DataGridViewTextBoxColumn3
        '
        Me.DataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn3.DataPropertyName = "MedicareNumber"
        Me.DataGridViewTextBoxColumn3.HeaderText = "Medicare Number"
        Me.DataGridViewTextBoxColumn3.Name = "DataGridViewTextBoxColumn3"
        Me.DataGridViewTextBoxColumn3.ReadOnly = True
        Me.DataGridViewTextBoxColumn3.Width = 106
        '
        'DataGridViewTextBoxColumn4
        '
        Me.DataGridViewTextBoxColumn4.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.DataGridViewTextBoxColumn4.DataPropertyName = "MedicareName"
        Me.DataGridViewTextBoxColumn4.HeaderText = "Medicare Name"
        Me.DataGridViewTextBoxColumn4.Name = "DataGridViewTextBoxColumn4"
        Me.DataGridViewTextBoxColumn4.ReadOnly = True
        Me.DataGridViewTextBoxColumn4.Width = 98
        '
        'strSurvey_nm
        '
        Me.strSurvey_nm.DataPropertyName = "strSurvey_nm"
        Me.strSurvey_nm.HeaderText = "Survey Name"
        Me.strSurvey_nm.Name = "strSurvey_nm"
        Me.strSurvey_nm.ReadOnly = True
        Me.strSurvey_nm.Width = 150
        '
        'Survey_ID
        '
        Me.Survey_ID.DataPropertyName = "Survey_ID"
        Me.Survey_ID.HeaderText = "Survey ID"
        Me.Survey_ID.Name = "Survey_ID"
        Me.Survey_ID.ReadOnly = True
        '
        'MedicareNumber
        '
        Me.MedicareNumber.DataPropertyName = "MedicareNumber"
        Me.MedicareNumber.HeaderText = "Medicare Number"
        Me.MedicareNumber.Name = "MedicareNumber"
        Me.MedicareNumber.ReadOnly = True
        Me.MedicareNumber.Width = 120
        '
        'MedicareName
        '
        Me.MedicareName.DataPropertyName = "MedicareName"
        Me.MedicareName.HeaderText = "Medicare Name"
        Me.MedicareName.Name = "MedicareName"
        Me.MedicareName.ReadOnly = True
        Me.MedicareName.Width = 150
        '
        'LockedSamplesDialog
        '
        Me.Caption = "Locked Samples"
        Me.ClientSize = New System.Drawing.Size(678, 277)
        Me.Controls.Add(Me.lblInfo)
        Me.Controls.Add(Me.dgvLockedSamples)
        Me.Controls.Add(Me.btnOK)
        Me.Name = "LockedSamplesDialog"
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.dgvLockedSamples, 0)
        Me.Controls.SetChildIndex(Me.lblInfo, 0)
        CType(Me.dgvLockedSamples, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents dgvLockedSamples As System.Windows.Forms.DataGridView
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents lblInfo As System.Windows.Forms.Label
    Friend WithEvents DataGridViewTextBoxColumn1 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn2 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn3 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents DataGridViewTextBoxColumn4 As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents strSurvey_nm As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Survey_ID As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MedicareNumber As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MedicareName As System.Windows.Forms.DataGridViewTextBoxColumn

End Class
