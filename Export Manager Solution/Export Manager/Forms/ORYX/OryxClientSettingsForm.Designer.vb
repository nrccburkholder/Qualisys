

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OryxClientSettingsForm
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
        Me.cbClient = New System.Windows.Forms.ComboBox
        Me.gbMeasures = New System.Windows.Forms.GroupBox
        Me.btnAddMeasure = New System.Windows.Forms.Button
        Me.btnRemoveMeasure = New System.Windows.Forms.Button
        Me.lbSelectedMeasures = New System.Windows.Forms.ListBox
        Me.lbAllMeasures = New System.Windows.Forms.ListBox
        Me.btnAddClient = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnApply = New System.Windows.Forms.Button
        Me.lblHCOID = New System.Windows.Forms.Label
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.gbMeasures.SuspendLayout()
        Me.SuspendLayout()
        '
        'cbClient
        '
        Me.cbClient.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cbClient.FormattingEnabled = True
        Me.cbClient.Location = New System.Drawing.Point(12, 12)
        Me.cbClient.Name = "cbClient"
        Me.cbClient.Size = New System.Drawing.Size(215, 21)
        Me.cbClient.TabIndex = 0
        '
        'gbMeasures
        '
        Me.gbMeasures.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.gbMeasures.Controls.Add(Me.btnAddMeasure)
        Me.gbMeasures.Controls.Add(Me.btnRemoveMeasure)
        Me.gbMeasures.Controls.Add(Me.lbSelectedMeasures)
        Me.gbMeasures.Controls.Add(Me.lbAllMeasures)
        Me.gbMeasures.Location = New System.Drawing.Point(12, 55)
        Me.gbMeasures.Name = "gbMeasures"
        Me.gbMeasures.Size = New System.Drawing.Size(296, 230)
        Me.gbMeasures.TabIndex = 1
        Me.gbMeasures.TabStop = False
        Me.gbMeasures.Text = "Measurements"
        '
        'btnAddMeasure
        '
        Me.btnAddMeasure.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnAddMeasure.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnAddMeasure.Location = New System.Drawing.Point(137, 32)
        Me.btnAddMeasure.Name = "btnAddMeasure"
        Me.btnAddMeasure.Size = New System.Drawing.Size(18, 30)
        Me.btnAddMeasure.TabIndex = 4
        Me.btnAddMeasure.Text = ">"
        Me.ToolTip1.SetToolTip(Me.btnAddMeasure, "Add Measure")
        Me.btnAddMeasure.UseVisualStyleBackColor = True
        '
        'btnRemoveMeasure
        '
        Me.btnRemoveMeasure.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnRemoveMeasure.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnRemoveMeasure.Location = New System.Drawing.Point(137, 70)
        Me.btnRemoveMeasure.Name = "btnRemoveMeasure"
        Me.btnRemoveMeasure.Size = New System.Drawing.Size(18, 30)
        Me.btnRemoveMeasure.TabIndex = 3
        Me.btnRemoveMeasure.Text = "<"
        Me.ToolTip1.SetToolTip(Me.btnRemoveMeasure, "Remove Measure")
        Me.btnRemoveMeasure.UseVisualStyleBackColor = True
        '
        'lbSelectedMeasures
        '
        Me.lbSelectedMeasures.FormattingEnabled = True
        Me.lbSelectedMeasures.Location = New System.Drawing.Point(159, 20)
        Me.lbSelectedMeasures.Name = "lbSelectedMeasures"
        Me.lbSelectedMeasures.Size = New System.Drawing.Size(122, 199)
        Me.lbSelectedMeasures.TabIndex = 1
        Me.ToolTip1.SetToolTip(Me.lbSelectedMeasures, "Selected Measures")
        '
        'lbAllMeasures
        '
        Me.lbAllMeasures.FormattingEnabled = True
        Me.lbAllMeasures.Location = New System.Drawing.Point(11, 20)
        Me.lbAllMeasures.Name = "lbAllMeasures"
        Me.lbAllMeasures.Size = New System.Drawing.Size(122, 199)
        Me.lbAllMeasures.TabIndex = 0
        Me.ToolTip1.SetToolTip(Me.lbAllMeasures, "Available Measures")
        '
        'btnAddClient
        '
        Me.btnAddClient.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnAddClient.Location = New System.Drawing.Point(231, 11)
        Me.btnAddClient.Name = "btnAddClient"
        Me.btnAddClient.Size = New System.Drawing.Size(77, 21)
        Me.btnAddClient.TabIndex = 2
        Me.btnAddClient.Text = "Add Client"
        Me.btnAddClient.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(192, 294)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(56, 21)
        Me.btnCancel.TabIndex = 4
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Location = New System.Drawing.Point(124, 294)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(64, 21)
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'btnApply
        '
        Me.btnApply.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnApply.Location = New System.Drawing.Point(252, 294)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(56, 21)
        Me.btnApply.TabIndex = 6
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'lblHCOID
        '
        Me.lblHCOID.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblHCOID.AutoSize = True
        Me.lblHCOID.Location = New System.Drawing.Point(12, 38)
        Me.lblHCOID.Name = "lblHCOID"
        Me.lblHCOID.Size = New System.Drawing.Size(44, 13)
        Me.lblHCOID.TabIndex = 7
        Me.lblHCOID.Text = "HCOID:"
        '
        'OryxClientSettingsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(316, 321)
        Me.ControlBox = False
        Me.Controls.Add(Me.lblHCOID)
        Me.Controls.Add(Me.btnApply)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnAddClient)
        Me.Controls.Add(Me.gbMeasures)
        Me.Controls.Add(Me.cbClient)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "OryxClientSettingsForm"
        Me.Text = "ORYX Client Settings"
        Me.gbMeasures.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cbClient As System.Windows.Forms.ComboBox
    Friend WithEvents gbMeasures As System.Windows.Forms.GroupBox
    Friend WithEvents btnAddMeasure As System.Windows.Forms.Button
    Friend WithEvents btnRemoveMeasure As System.Windows.Forms.Button
    Friend WithEvents lbSelectedMeasures As System.Windows.Forms.ListBox
    Friend WithEvents lbAllMeasures As System.Windows.Forms.ListBox
    Friend WithEvents btnAddClient As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents lblHCOID As System.Windows.Forms.Label
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
End Class