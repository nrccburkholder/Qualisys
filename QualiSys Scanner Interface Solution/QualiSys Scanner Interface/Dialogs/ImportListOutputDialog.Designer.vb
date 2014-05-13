<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportListOutputDialog
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
        Me.OutputListTextBox = New System.Windows.Forms.TextBox
        Me.OutputTypeGroupBox = New System.Windows.Forms.GroupBox
        Me.RefreshListButton = New System.Windows.Forms.Button
        Me.LithoSeparatorCrLfCheckBox = New System.Windows.Forms.CheckBox
        Me.LithoDelimiterTextBox = New System.Windows.Forms.TextBox
        Me.LithoSeparatorTextBox = New System.Windows.Forms.TextBox
        Me.LithoDelimiterLabel = New System.Windows.Forms.Label
        Me.LithoSeparatorLabel = New System.Windows.Forms.Label
        Me.BarcodeSeparatorCrLfCheckBox = New System.Windows.Forms.CheckBox
        Me.BarcodeDelimiterTextBox = New System.Windows.Forms.TextBox
        Me.BarcodeSeparatorTextBox = New System.Windows.Forms.TextBox
        Me.BarcodeDelimiterLabel = New System.Windows.Forms.Label
        Me.BarcodeSeparatorLabel = New System.Windows.Forms.Label
        Me.OutputTypeLithocodeRadioButton = New System.Windows.Forms.RadioButton
        Me.OutputTypeBarcodeRadioButton = New System.Windows.Forms.RadioButton
        Me.FinishedButton = New System.Windows.Forms.Button
        Me.CreateDLVButton = New System.Windows.Forms.Button
        Me.OutputTypeGroupBox.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Import List Output"
        Me.mPaneCaption.Size = New System.Drawing.Size(383, 26)
        Me.mPaneCaption.Text = "Import List Output"
        '
        'OutputListTextBox
        '
        Me.OutputListTextBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OutputListTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.OutputListTextBox.Location = New System.Drawing.Point(16, 40)
        Me.OutputListTextBox.Multiline = True
        Me.OutputListTextBox.Name = "OutputListTextBox"
        Me.OutputListTextBox.ReadOnly = True
        Me.OutputListTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.OutputListTextBox.Size = New System.Drawing.Size(160, 208)
        Me.OutputListTextBox.TabIndex = 0
        '
        'OutputTypeGroupBox
        '
        Me.OutputTypeGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OutputTypeGroupBox.Controls.Add(Me.RefreshListButton)
        Me.OutputTypeGroupBox.Controls.Add(Me.LithoSeparatorCrLfCheckBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.LithoDelimiterTextBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.LithoSeparatorTextBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.LithoDelimiterLabel)
        Me.OutputTypeGroupBox.Controls.Add(Me.LithoSeparatorLabel)
        Me.OutputTypeGroupBox.Controls.Add(Me.BarcodeSeparatorCrLfCheckBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.BarcodeDelimiterTextBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.BarcodeSeparatorTextBox)
        Me.OutputTypeGroupBox.Controls.Add(Me.BarcodeDelimiterLabel)
        Me.OutputTypeGroupBox.Controls.Add(Me.BarcodeSeparatorLabel)
        Me.OutputTypeGroupBox.Controls.Add(Me.OutputTypeLithocodeRadioButton)
        Me.OutputTypeGroupBox.Controls.Add(Me.OutputTypeBarcodeRadioButton)
        Me.OutputTypeGroupBox.Location = New System.Drawing.Point(188, 36)
        Me.OutputTypeGroupBox.Name = "OutputTypeGroupBox"
        Me.OutputTypeGroupBox.Size = New System.Drawing.Size(184, 212)
        Me.OutputTypeGroupBox.TabIndex = 1
        Me.OutputTypeGroupBox.TabStop = False
        Me.OutputTypeGroupBox.Text = " Output Type "
        '
        'RefreshListButton
        '
        Me.RefreshListButton.Location = New System.Drawing.Point(16, 168)
        Me.RefreshListButton.Name = "RefreshListButton"
        Me.RefreshListButton.Size = New System.Drawing.Size(152, 28)
        Me.RefreshListButton.TabIndex = 12
        Me.RefreshListButton.Text = "Refresh List"
        Me.RefreshListButton.UseVisualStyleBackColor = True
        '
        'LithoSeparatorCrLfCheckBox
        '
        Me.LithoSeparatorCrLfCheckBox.AutoSize = True
        Me.LithoSeparatorCrLfCheckBox.Checked = True
        Me.LithoSeparatorCrLfCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.LithoSeparatorCrLfCheckBox.Location = New System.Drawing.Point(128, 112)
        Me.LithoSeparatorCrLfCheckBox.Name = "LithoSeparatorCrLfCheckBox"
        Me.LithoSeparatorCrLfCheckBox.Size = New System.Drawing.Size(46, 17)
        Me.LithoSeparatorCrLfCheckBox.TabIndex = 9
        Me.LithoSeparatorCrLfCheckBox.Text = "CrLf"
        Me.LithoSeparatorCrLfCheckBox.UseVisualStyleBackColor = True
        '
        'LithoDelimiterTextBox
        '
        Me.LithoDelimiterTextBox.Location = New System.Drawing.Point(92, 132)
        Me.LithoDelimiterTextBox.Name = "LithoDelimiterTextBox"
        Me.LithoDelimiterTextBox.Size = New System.Drawing.Size(28, 21)
        Me.LithoDelimiterTextBox.TabIndex = 11
        Me.LithoDelimiterTextBox.Text = "'"
        Me.LithoDelimiterTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'LithoSeparatorTextBox
        '
        Me.LithoSeparatorTextBox.Location = New System.Drawing.Point(92, 108)
        Me.LithoSeparatorTextBox.Name = "LithoSeparatorTextBox"
        Me.LithoSeparatorTextBox.Size = New System.Drawing.Size(28, 21)
        Me.LithoSeparatorTextBox.TabIndex = 8
        Me.LithoSeparatorTextBox.Text = ","
        Me.LithoSeparatorTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'LithoDelimiterLabel
        '
        Me.LithoDelimiterLabel.AutoSize = True
        Me.LithoDelimiterLabel.Location = New System.Drawing.Point(28, 136)
        Me.LithoDelimiterLabel.Name = "LithoDelimiterLabel"
        Me.LithoDelimiterLabel.Size = New System.Drawing.Size(52, 13)
        Me.LithoDelimiterLabel.TabIndex = 10
        Me.LithoDelimiterLabel.Text = "Delimiter:"
        '
        'LithoSeparatorLabel
        '
        Me.LithoSeparatorLabel.AutoSize = True
        Me.LithoSeparatorLabel.Location = New System.Drawing.Point(28, 112)
        Me.LithoSeparatorLabel.Name = "LithoSeparatorLabel"
        Me.LithoSeparatorLabel.Size = New System.Drawing.Size(59, 13)
        Me.LithoSeparatorLabel.TabIndex = 7
        Me.LithoSeparatorLabel.Text = "Separator:"
        '
        'BarcodeSeparatorCrLfCheckBox
        '
        Me.BarcodeSeparatorCrLfCheckBox.AutoSize = True
        Me.BarcodeSeparatorCrLfCheckBox.Checked = True
        Me.BarcodeSeparatorCrLfCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.BarcodeSeparatorCrLfCheckBox.Location = New System.Drawing.Point(128, 40)
        Me.BarcodeSeparatorCrLfCheckBox.Name = "BarcodeSeparatorCrLfCheckBox"
        Me.BarcodeSeparatorCrLfCheckBox.Size = New System.Drawing.Size(46, 17)
        Me.BarcodeSeparatorCrLfCheckBox.TabIndex = 3
        Me.BarcodeSeparatorCrLfCheckBox.Text = "CrLf"
        Me.BarcodeSeparatorCrLfCheckBox.UseVisualStyleBackColor = True
        '
        'BarcodeDelimiterTextBox
        '
        Me.BarcodeDelimiterTextBox.Location = New System.Drawing.Point(92, 60)
        Me.BarcodeDelimiterTextBox.Name = "BarcodeDelimiterTextBox"
        Me.BarcodeDelimiterTextBox.Size = New System.Drawing.Size(28, 21)
        Me.BarcodeDelimiterTextBox.TabIndex = 5
        Me.BarcodeDelimiterTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'BarcodeSeparatorTextBox
        '
        Me.BarcodeSeparatorTextBox.Location = New System.Drawing.Point(92, 36)
        Me.BarcodeSeparatorTextBox.Name = "BarcodeSeparatorTextBox"
        Me.BarcodeSeparatorTextBox.Size = New System.Drawing.Size(28, 21)
        Me.BarcodeSeparatorTextBox.TabIndex = 2
        Me.BarcodeSeparatorTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'BarcodeDelimiterLabel
        '
        Me.BarcodeDelimiterLabel.AutoSize = True
        Me.BarcodeDelimiterLabel.Location = New System.Drawing.Point(28, 64)
        Me.BarcodeDelimiterLabel.Name = "BarcodeDelimiterLabel"
        Me.BarcodeDelimiterLabel.Size = New System.Drawing.Size(52, 13)
        Me.BarcodeDelimiterLabel.TabIndex = 4
        Me.BarcodeDelimiterLabel.Text = "Delimiter:"
        '
        'BarcodeSeparatorLabel
        '
        Me.BarcodeSeparatorLabel.AutoSize = True
        Me.BarcodeSeparatorLabel.Location = New System.Drawing.Point(28, 40)
        Me.BarcodeSeparatorLabel.Name = "BarcodeSeparatorLabel"
        Me.BarcodeSeparatorLabel.Size = New System.Drawing.Size(59, 13)
        Me.BarcodeSeparatorLabel.TabIndex = 1
        Me.BarcodeSeparatorLabel.Text = "Separator:"
        '
        'OutputTypeLithocodeRadioButton
        '
        Me.OutputTypeLithocodeRadioButton.AutoSize = True
        Me.OutputTypeLithocodeRadioButton.Location = New System.Drawing.Point(12, 92)
        Me.OutputTypeLithocodeRadioButton.Name = "OutputTypeLithocodeRadioButton"
        Me.OutputTypeLithocodeRadioButton.Size = New System.Drawing.Size(78, 17)
        Me.OutputTypeLithocodeRadioButton.TabIndex = 6
        Me.OutputTypeLithocodeRadioButton.TabStop = True
        Me.OutputTypeLithocodeRadioButton.Text = "LithoCodes"
        Me.OutputTypeLithocodeRadioButton.UseVisualStyleBackColor = True
        '
        'OutputTypeBarcodeRadioButton
        '
        Me.OutputTypeBarcodeRadioButton.AutoSize = True
        Me.OutputTypeBarcodeRadioButton.Location = New System.Drawing.Point(12, 20)
        Me.OutputTypeBarcodeRadioButton.Name = "OutputTypeBarcodeRadioButton"
        Me.OutputTypeBarcodeRadioButton.Size = New System.Drawing.Size(69, 17)
        Me.OutputTypeBarcodeRadioButton.TabIndex = 0
        Me.OutputTypeBarcodeRadioButton.TabStop = True
        Me.OutputTypeBarcodeRadioButton.Text = "Barcodes"
        Me.OutputTypeBarcodeRadioButton.UseVisualStyleBackColor = True
        '
        'FinishedButton
        '
        Me.FinishedButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FinishedButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.FinishedButton.Location = New System.Drawing.Point(300, 259)
        Me.FinishedButton.Name = "FinishedButton"
        Me.FinishedButton.Size = New System.Drawing.Size(72, 28)
        Me.FinishedButton.TabIndex = 3
        Me.FinishedButton.Text = "Finished"
        Me.FinishedButton.UseVisualStyleBackColor = True
        '
        'CreateDLVButton
        '
        Me.CreateDLVButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CreateDLVButton.Location = New System.Drawing.Point(188, 259)
        Me.CreateDLVButton.Name = "CreateDLVButton"
        Me.CreateDLVButton.Size = New System.Drawing.Size(100, 28)
        Me.CreateDLVButton.TabIndex = 2
        Me.CreateDLVButton.Text = "Create DLV File"
        Me.CreateDLVButton.UseVisualStyleBackColor = True
        '
        'ImportListOutputDialog
        '
        Me.AcceptButton = Me.FinishedButton
        Me.CancelButton = Me.FinishedButton
        Me.Caption = "Import List Output"
        Me.ClientSize = New System.Drawing.Size(385, 298)
        Me.ControlBox = False
        Me.Controls.Add(Me.FinishedButton)
        Me.Controls.Add(Me.CreateDLVButton)
        Me.Controls.Add(Me.OutputTypeGroupBox)
        Me.Controls.Add(Me.OutputListTextBox)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.MinimumSize = New System.Drawing.Size(393, 306)
        Me.Name = "ImportListOutputDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.OutputListTextBox, 0)
        Me.Controls.SetChildIndex(Me.OutputTypeGroupBox, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.CreateDLVButton, 0)
        Me.Controls.SetChildIndex(Me.FinishedButton, 0)
        Me.OutputTypeGroupBox.ResumeLayout(False)
        Me.OutputTypeGroupBox.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents OutputListTextBox As System.Windows.Forms.TextBox
    Friend WithEvents OutputTypeGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents OutputTypeLithocodeRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents OutputTypeBarcodeRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents BarcodeDelimiterLabel As System.Windows.Forms.Label
    Friend WithEvents BarcodeSeparatorLabel As System.Windows.Forms.Label
    Friend WithEvents BarcodeSeparatorTextBox As System.Windows.Forms.TextBox
    Friend WithEvents LithoSeparatorCrLfCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents LithoDelimiterTextBox As System.Windows.Forms.TextBox
    Friend WithEvents LithoSeparatorTextBox As System.Windows.Forms.TextBox
    Friend WithEvents LithoDelimiterLabel As System.Windows.Forms.Label
    Friend WithEvents LithoSeparatorLabel As System.Windows.Forms.Label
    Friend WithEvents BarcodeSeparatorCrLfCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents BarcodeDelimiterTextBox As System.Windows.Forms.TextBox
    Friend WithEvents RefreshListButton As System.Windows.Forms.Button
    Friend WithEvents FinishedButton As System.Windows.Forms.Button
    Friend WithEvents CreateDLVButton As System.Windows.Forms.Button

End Class
