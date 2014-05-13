<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AddCalculatedColumnDialog
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
        Dim DescriptionLabel As System.Windows.Forms.Label
        Dim DisplayNameLabel As System.Windows.Forms.Label
        Dim FormulaLabel As System.Windows.Forms.Label
        Dim NameLabel As System.Windows.Forms.Label
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.OK_Button = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.NameTextBox = New System.Windows.Forms.TextBox
        Me.FormulaTextBox = New System.Windows.Forms.TextBox
        Me.DisplayNameTextBox = New System.Windows.Forms.TextBox
        Me.DescriptionTextBox = New System.Windows.Forms.TextBox
        DescriptionLabel = New System.Windows.Forms.Label
        DisplayNameLabel = New System.Windows.Forms.Label
        FormulaLabel = New System.Windows.Forms.Label
        NameLabel = New System.Windows.Forms.Label
        Me.TableLayoutPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Add Calculated Column"
        Me.mPaneCaption.Size = New System.Drawing.Size(600, 26)
        Me.mPaneCaption.Text = "Add Calculated Column"
        '
        'DescriptionLabel
        '
        DescriptionLabel.AutoSize = True
        DescriptionLabel.Location = New System.Drawing.Point(17, 68)
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = New System.Drawing.Size(63, 13)
        DescriptionLabel.TabIndex = 4
        DescriptionLabel.Text = "Description:"
        '
        'DisplayNameLabel
        '
        DisplayNameLabel.AutoSize = True
        DisplayNameLabel.Location = New System.Drawing.Point(17, 94)
        DisplayNameLabel.Name = "DisplayNameLabel"
        DisplayNameLabel.Size = New System.Drawing.Size(75, 13)
        DisplayNameLabel.TabIndex = 6
        DisplayNameLabel.Text = "Display Name:"
        '
        'FormulaLabel
        '
        FormulaLabel.AutoSize = True
        FormulaLabel.Location = New System.Drawing.Point(17, 120)
        FormulaLabel.Name = "FormulaLabel"
        FormulaLabel.Size = New System.Drawing.Size(47, 13)
        FormulaLabel.TabIndex = 8
        FormulaLabel.Text = "Formula:"
        '
        'NameLabel
        '
        NameLabel.AutoSize = True
        NameLabel.Location = New System.Drawing.Point(17, 41)
        NameLabel.Name = "NameLabel"
        NameLabel.Size = New System.Drawing.Size(38, 13)
        NameLabel.TabIndex = 22
        NameLabel.Text = "Name:"
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.Controls.Add(Me.OK_Button, 0, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.Cancel_Button, 1, 0)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(444, 233)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 1
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(146, 29)
        Me.TableLayoutPanel1.TabIndex = 0
        '
        'OK_Button
        '
        Me.OK_Button.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.OK_Button.Location = New System.Drawing.Point(3, 3)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(67, 23)
        Me.OK_Button.TabIndex = 0
        Me.OK_Button.Text = "OK"
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Cancel_Button.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Cancel_Button.Location = New System.Drawing.Point(76, 3)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(67, 23)
        Me.Cancel_Button.TabIndex = 1
        Me.Cancel_Button.Text = "Cancel"
        '
        'NameTextBox
        '
        Me.NameTextBox.Location = New System.Drawing.Point(92, 39)
        Me.NameTextBox.Name = "NameTextBox"
        Me.NameTextBox.Size = New System.Drawing.Size(495, 20)
        Me.NameTextBox.TabIndex = 23
        '
        'FormulaTextBox
        '
        Me.FormulaTextBox.Location = New System.Drawing.Point(92, 117)
        Me.FormulaTextBox.Multiline = True
        Me.FormulaTextBox.Name = "FormulaTextBox"
        Me.FormulaTextBox.Size = New System.Drawing.Size(495, 110)
        Me.FormulaTextBox.TabIndex = 28
        '
        'DisplayNameTextBox
        '
        Me.DisplayNameTextBox.Location = New System.Drawing.Point(92, 91)
        Me.DisplayNameTextBox.Name = "DisplayNameTextBox"
        Me.DisplayNameTextBox.Size = New System.Drawing.Size(495, 20)
        Me.DisplayNameTextBox.TabIndex = 27
        '
        'DescriptionTextBox
        '
        Me.DescriptionTextBox.Location = New System.Drawing.Point(92, 65)
        Me.DescriptionTextBox.Name = "DescriptionTextBox"
        Me.DescriptionTextBox.Size = New System.Drawing.Size(495, 20)
        Me.DescriptionTextBox.TabIndex = 26
        '
        'AddCalculatedColumnDialog
        '
        Me.AcceptButton = Me.OK_Button
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.Cancel_Button
        Me.Caption = "Add Calculated Column"
        Me.ClientSize = New System.Drawing.Size(602, 274)
        Me.Controls.Add(Me.DescriptionTextBox)
        Me.Controls.Add(Me.DisplayNameTextBox)
        Me.Controls.Add(Me.FormulaTextBox)
        Me.Controls.Add(Me.NameTextBox)
        Me.Controls.Add(DescriptionLabel)
        Me.Controls.Add(DisplayNameLabel)
        Me.Controls.Add(FormulaLabel)
        Me.Controls.Add(NameLabel)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "AddCalculatedColumnDialog"
        Me.Text = "AddCalculatedColumnDialog"
        Me.Controls.SetChildIndex(Me.TableLayoutPanel1, 0)
        Me.Controls.SetChildIndex(NameLabel, 0)
        Me.Controls.SetChildIndex(FormulaLabel, 0)
        Me.Controls.SetChildIndex(DisplayNameLabel, 0)
        Me.Controls.SetChildIndex(DescriptionLabel, 0)
        Me.Controls.SetChildIndex(Me.NameTextBox, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.FormulaTextBox, 0)
        Me.Controls.SetChildIndex(Me.DisplayNameTextBox, 0)
        Me.Controls.SetChildIndex(Me.DescriptionTextBox, 0)
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents NameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents FormulaTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DisplayNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DescriptionTextBox As System.Windows.Forms.TextBox

End Class
