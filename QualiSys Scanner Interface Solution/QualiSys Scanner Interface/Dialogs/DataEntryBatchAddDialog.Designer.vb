<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DataEntryBatchAddDialog
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
        Me.LithoCodesGroupBox = New System.Windows.Forms.GroupBox
        Me.LithoCodesListView = New System.Windows.Forms.ListView
        Me.LithoCodeColumnHeader = New System.Windows.Forms.ColumnHeader
        Me.BarcodeColumnHeader = New System.Windows.Forms.ColumnHeader
        Me.InputOptionsGroupBox = New System.Windows.Forms.GroupBox
        Me.InputBarcodeRadioButton = New System.Windows.Forms.RadioButton
        Me.InputLithoCodeRadioButton = New System.Windows.Forms.RadioButton
        Me.InputGroupBox = New System.Windows.Forms.GroupBox
        Me.VerifyLabel = New System.Windows.Forms.Label
        Me.VerifyTextBox = New System.Windows.Forms.TextBox
        Me.InputLabel = New System.Windows.Forms.Label
        Me.AddButton = New System.Windows.Forms.Button
        Me.InputTextBox = New System.Windows.Forms.TextBox
        Me.OK_Button = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.LithoCodesGroupBox.SuspendLayout()
        Me.InputOptionsGroupBox.SuspendLayout()
        Me.InputGroupBox.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Create Batch"
        Me.mPaneCaption.Size = New System.Drawing.Size(483, 26)
        Me.mPaneCaption.TabIndex = 3
        Me.mPaneCaption.Text = "Create Batch"
        '
        'LithoCodesGroupBox
        '
        Me.LithoCodesGroupBox.Controls.Add(Me.LithoCodesListView)
        Me.LithoCodesGroupBox.Location = New System.Drawing.Point(6, 36)
        Me.LithoCodesGroupBox.Name = "LithoCodesGroupBox"
        Me.LithoCodesGroupBox.Size = New System.Drawing.Size(248, 274)
        Me.LithoCodesGroupBox.TabIndex = 4
        Me.LithoCodesGroupBox.TabStop = False
        Me.LithoCodesGroupBox.Text = "LithoCodes To Be Added"
        '
        'LithoCodesListView
        '
        Me.LithoCodesListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LithoCodesListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.LithoCodeColumnHeader, Me.BarcodeColumnHeader})
        Me.LithoCodesListView.FullRowSelect = True
        Me.LithoCodesListView.GridLines = True
        Me.LithoCodesListView.Location = New System.Drawing.Point(10, 20)
        Me.LithoCodesListView.MultiSelect = False
        Me.LithoCodesListView.Name = "LithoCodesListView"
        Me.LithoCodesListView.Size = New System.Drawing.Size(228, 243)
        Me.LithoCodesListView.TabIndex = 0
        Me.LithoCodesListView.TabStop = False
        Me.LithoCodesListView.UseCompatibleStateImageBehavior = False
        Me.LithoCodesListView.View = System.Windows.Forms.View.Details
        '
        'LithoCodeColumnHeader
        '
        Me.LithoCodeColumnHeader.Text = "LithoCode"
        Me.LithoCodeColumnHeader.Width = 100
        '
        'BarcodeColumnHeader
        '
        Me.BarcodeColumnHeader.Text = "Barcode"
        Me.BarcodeColumnHeader.Width = 100
        '
        'InputOptionsGroupBox
        '
        Me.InputOptionsGroupBox.Controls.Add(Me.InputBarcodeRadioButton)
        Me.InputOptionsGroupBox.Controls.Add(Me.InputLithoCodeRadioButton)
        Me.InputOptionsGroupBox.Location = New System.Drawing.Point(266, 36)
        Me.InputOptionsGroupBox.Name = "InputOptionsGroupBox"
        Me.InputOptionsGroupBox.Size = New System.Drawing.Size(212, 67)
        Me.InputOptionsGroupBox.TabIndex = 5
        Me.InputOptionsGroupBox.TabStop = False
        Me.InputOptionsGroupBox.Text = "Input Options"
        '
        'InputBarcodeRadioButton
        '
        Me.InputBarcodeRadioButton.AutoSize = True
        Me.InputBarcodeRadioButton.Location = New System.Drawing.Point(10, 41)
        Me.InputBarcodeRadioButton.Name = "InputBarcodeRadioButton"
        Me.InputBarcodeRadioButton.Size = New System.Drawing.Size(112, 17)
        Me.InputBarcodeRadioButton.TabIndex = 1
        Me.InputBarcodeRadioButton.Text = "Input as Barcodes"
        Me.InputBarcodeRadioButton.UseVisualStyleBackColor = True
        '
        'InputLithoCodeRadioButton
        '
        Me.InputLithoCodeRadioButton.AutoSize = True
        Me.InputLithoCodeRadioButton.Location = New System.Drawing.Point(10, 18)
        Me.InputLithoCodeRadioButton.Name = "InputLithoCodeRadioButton"
        Me.InputLithoCodeRadioButton.Size = New System.Drawing.Size(121, 17)
        Me.InputLithoCodeRadioButton.TabIndex = 0
        Me.InputLithoCodeRadioButton.Text = "Input as LithoCodes"
        Me.InputLithoCodeRadioButton.UseVisualStyleBackColor = True
        '
        'InputGroupBox
        '
        Me.InputGroupBox.Controls.Add(Me.VerifyLabel)
        Me.InputGroupBox.Controls.Add(Me.VerifyTextBox)
        Me.InputGroupBox.Controls.Add(Me.InputLabel)
        Me.InputGroupBox.Controls.Add(Me.AddButton)
        Me.InputGroupBox.Controls.Add(Me.InputTextBox)
        Me.InputGroupBox.Location = New System.Drawing.Point(266, 109)
        Me.InputGroupBox.Name = "InputGroupBox"
        Me.InputGroupBox.Size = New System.Drawing.Size(212, 201)
        Me.InputGroupBox.TabIndex = 0
        Me.InputGroupBox.TabStop = False
        Me.InputGroupBox.Text = "Input LithoCodes"
        '
        'VerifyLabel
        '
        Me.VerifyLabel.AutoSize = True
        Me.VerifyLabel.Location = New System.Drawing.Point(7, 50)
        Me.VerifyLabel.Name = "VerifyLabel"
        Me.VerifyLabel.Size = New System.Drawing.Size(90, 13)
        Me.VerifyLabel.TabIndex = 2
        Me.VerifyLabel.Text = "Verify LithoCode:"
        '
        'VerifyTextBox
        '
        Me.VerifyTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.VerifyTextBox.Location = New System.Drawing.Point(103, 47)
        Me.VerifyTextBox.Name = "VerifyTextBox"
        Me.VerifyTextBox.Size = New System.Drawing.Size(99, 21)
        Me.VerifyTextBox.TabIndex = 3
        '
        'InputLabel
        '
        Me.InputLabel.AutoSize = True
        Me.InputLabel.Location = New System.Drawing.Point(7, 23)
        Me.InputLabel.Name = "InputLabel"
        Me.InputLabel.Size = New System.Drawing.Size(88, 13)
        Me.InputLabel.TabIndex = 0
        Me.InputLabel.Text = "Enter LithoCode:"
        '
        'AddButton
        '
        Me.AddButton.Location = New System.Drawing.Point(103, 78)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(99, 28)
        Me.AddButton.TabIndex = 4
        Me.AddButton.Text = "Add To List"
        Me.AddButton.UseVisualStyleBackColor = True
        '
        'InputTextBox
        '
        Me.InputTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.InputTextBox.Location = New System.Drawing.Point(103, 20)
        Me.InputTextBox.Name = "InputTextBox"
        Me.InputTextBox.Size = New System.Drawing.Size(99, 21)
        Me.InputTextBox.TabIndex = 1
        '
        'OK_Button
        '
        Me.OK_Button.Location = New System.Drawing.Point(313, 320)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(80, 28)
        Me.OK_Button.TabIndex = 1
        Me.OK_Button.Text = "OK"
        Me.OK_Button.UseVisualStyleBackColor = True
        '
        'Cancel_Button
        '
        Me.Cancel_Button.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Cancel_Button.Location = New System.Drawing.Point(399, 320)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(80, 28)
        Me.Cancel_Button.TabIndex = 2
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'DataEntryBatchAddDialog
        '
        Me.AcceptButton = Me.AddButton
        Me.CancelButton = Me.Cancel_Button
        Me.Caption = "Create Batch"
        Me.ClientSize = New System.Drawing.Size(485, 354)
        Me.ControlBox = False
        Me.Controls.Add(Me.Cancel_Button)
        Me.Controls.Add(Me.OK_Button)
        Me.Controls.Add(Me.LithoCodesGroupBox)
        Me.Controls.Add(Me.InputGroupBox)
        Me.Controls.Add(Me.InputOptionsGroupBox)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "DataEntryBatchAddDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.InputOptionsGroupBox, 0)
        Me.Controls.SetChildIndex(Me.InputGroupBox, 0)
        Me.Controls.SetChildIndex(Me.LithoCodesGroupBox, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.OK_Button, 0)
        Me.Controls.SetChildIndex(Me.Cancel_Button, 0)
        Me.LithoCodesGroupBox.ResumeLayout(False)
        Me.InputOptionsGroupBox.ResumeLayout(False)
        Me.InputOptionsGroupBox.PerformLayout()
        Me.InputGroupBox.ResumeLayout(False)
        Me.InputGroupBox.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents LithoCodesGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents LithoCodesListView As System.Windows.Forms.ListView
    Friend WithEvents LithoCodeColumnHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents BarcodeColumnHeader As System.Windows.Forms.ColumnHeader
    Friend WithEvents InputOptionsGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents InputBarcodeRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents InputLithoCodeRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents InputGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents InputTextBox As System.Windows.Forms.TextBox
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents VerifyLabel As System.Windows.Forms.Label
    Friend WithEvents VerifyTextBox As System.Windows.Forms.TextBox
    Friend WithEvents InputLabel As System.Windows.Forms.Label
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button

End Class
