<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FilterDialog
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
        Me.components = New System.ComponentModel.Container
        Me.OKCancelTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.OK_Button = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.OperatorLabel = New System.Windows.Forms.Label
        Me.ValueLabel = New System.Windows.Forms.Label
        Me.OperatorComboBox = New System.Windows.Forms.ComboBox
        Me.FilterTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.ColumnComboBox = New System.Windows.Forms.ComboBox
        Me.ColumnLabel = New System.Windows.Forms.Label
        Me.ValuePanel = New System.Windows.Forms.Panel
        Me.ValueTextBox = New System.Windows.Forms.TextBox
        Me.ValueComboBox = New System.Windows.Forms.ComboBox
        Me.ErrorControl = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.OKCancelTableLayoutPanel.SuspendLayout()
        Me.FilterTableLayoutPanel.SuspendLayout()
        Me.ValuePanel.SuspendLayout()
        CType(Me.ErrorControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Filter"
        Me.mPaneCaption.Size = New System.Drawing.Size(450, 26)
        Me.mPaneCaption.Text = "Filter"
        '
        'OKCancelTableLayoutPanel
        '
        Me.OKCancelTableLayoutPanel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKCancelTableLayoutPanel.ColumnCount = 2
        Me.OKCancelTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.OKCancelTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.OKCancelTableLayoutPanel.Controls.Add(Me.OK_Button, 0, 0)
        Me.OKCancelTableLayoutPanel.Controls.Add(Me.Cancel_Button, 1, 0)
        Me.OKCancelTableLayoutPanel.Location = New System.Drawing.Point(294, 110)
        Me.OKCancelTableLayoutPanel.Name = "OKCancelTableLayoutPanel"
        Me.OKCancelTableLayoutPanel.RowCount = 1
        Me.OKCancelTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.OKCancelTableLayoutPanel.Size = New System.Drawing.Size(146, 29)
        Me.OKCancelTableLayoutPanel.TabIndex = 6
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
        Me.Cancel_Button.Location = New System.Drawing.Point(76, 3)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(67, 23)
        Me.Cancel_Button.TabIndex = 1
        Me.Cancel_Button.Text = "Cancel"
        '
        'OperatorLabel
        '
        Me.OperatorLabel.AutoSize = True
        Me.OperatorLabel.Location = New System.Drawing.Point(179, 0)
        Me.OperatorLabel.Name = "OperatorLabel"
        Me.OperatorLabel.Size = New System.Drawing.Size(55, 13)
        Me.OperatorLabel.TabIndex = 8
        Me.OperatorLabel.Text = "Operator:"
        '
        'ValueLabel
        '
        Me.ValueLabel.AutoSize = True
        Me.ValueLabel.Location = New System.Drawing.Point(254, 0)
        Me.ValueLabel.Name = "ValueLabel"
        Me.ValueLabel.Size = New System.Drawing.Size(37, 13)
        Me.ValueLabel.TabIndex = 9
        Me.ValueLabel.Text = "Value:"
        '
        'OperatorComboBox
        '
        Me.OperatorComboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest
        Me.OperatorComboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.OperatorComboBox.Dock = System.Windows.Forms.DockStyle.Top
        Me.OperatorComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.OperatorComboBox.FormattingEnabled = True
        Me.OperatorComboBox.Location = New System.Drawing.Point(179, 16)
        Me.OperatorComboBox.Name = "OperatorComboBox"
        Me.OperatorComboBox.Size = New System.Drawing.Size(69, 21)
        Me.OperatorComboBox.TabIndex = 11
        '
        'FilterTableLayoutPanel
        '
        Me.FilterTableLayoutPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterTableLayoutPanel.ColumnCount = 3
        Me.FilterTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FilterTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 75.0!))
        Me.FilterTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FilterTableLayoutPanel.Controls.Add(Me.ColumnComboBox, 0, 1)
        Me.FilterTableLayoutPanel.Controls.Add(Me.ColumnLabel, 0, 0)
        Me.FilterTableLayoutPanel.Controls.Add(Me.OperatorComboBox, 1, 1)
        Me.FilterTableLayoutPanel.Controls.Add(Me.OperatorLabel, 1, 0)
        Me.FilterTableLayoutPanel.Controls.Add(Me.ValueLabel, 2, 0)
        Me.FilterTableLayoutPanel.Controls.Add(Me.ValuePanel, 2, 1)
        Me.FilterTableLayoutPanel.Location = New System.Drawing.Point(13, 42)
        Me.FilterTableLayoutPanel.Name = "FilterTableLayoutPanel"
        Me.FilterTableLayoutPanel.RowCount = 2
        Me.FilterTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.FilterTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.FilterTableLayoutPanel.Size = New System.Drawing.Size(427, 41)
        Me.FilterTableLayoutPanel.TabIndex = 13
        '
        'ColumnComboBox
        '
        Me.ColumnComboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest
        Me.ColumnComboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.ColumnComboBox.Dock = System.Windows.Forms.DockStyle.Top
        Me.ColumnComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ColumnComboBox.FormattingEnabled = True
        Me.ColumnComboBox.Location = New System.Drawing.Point(3, 16)
        Me.ColumnComboBox.Name = "ColumnComboBox"
        Me.ColumnComboBox.Size = New System.Drawing.Size(170, 21)
        Me.ColumnComboBox.TabIndex = 12
        '
        'ColumnLabel
        '
        Me.ColumnLabel.AutoSize = True
        Me.ColumnLabel.Location = New System.Drawing.Point(3, 0)
        Me.ColumnLabel.Name = "ColumnLabel"
        Me.ColumnLabel.Size = New System.Drawing.Size(46, 13)
        Me.ColumnLabel.TabIndex = 11
        Me.ColumnLabel.Text = "Column:"
        '
        'ValuePanel
        '
        Me.ValuePanel.AutoSize = True
        Me.ValuePanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.ValuePanel.Controls.Add(Me.ValueTextBox)
        Me.ValuePanel.Controls.Add(Me.ValueComboBox)
        Me.ValuePanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.ValuePanel.Location = New System.Drawing.Point(254, 16)
        Me.ValuePanel.Name = "ValuePanel"
        Me.ValuePanel.Size = New System.Drawing.Size(170, 42)
        Me.ValuePanel.TabIndex = 13
        '
        'ValueTextBox
        '
        Me.ValueTextBox.Dock = System.Windows.Forms.DockStyle.Top
        Me.ValueTextBox.Location = New System.Drawing.Point(0, 21)
        Me.ValueTextBox.Name = "ValueTextBox"
        Me.ValueTextBox.Size = New System.Drawing.Size(170, 21)
        Me.ValueTextBox.TabIndex = 1
        '
        'ValueComboBox
        '
        Me.ValueComboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest
        Me.ValueComboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.ValueComboBox.Dock = System.Windows.Forms.DockStyle.Top
        Me.ValueComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ValueComboBox.FormattingEnabled = True
        Me.ValueComboBox.Location = New System.Drawing.Point(0, 0)
        Me.ValueComboBox.Name = "ValueComboBox"
        Me.ValueComboBox.Size = New System.Drawing.Size(170, 21)
        Me.ValueComboBox.TabIndex = 0
        '
        'ErrorControl
        '
        Me.ErrorControl.ContainerControl = Me
        '
        'FilterDialog
        '
        Me.AcceptButton = Me.OK_Button
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.Cancel_Button
        Me.Caption = "Filter"
        Me.ClientSize = New System.Drawing.Size(452, 151)
        Me.ControlBox = False
        Me.Controls.Add(Me.FilterTableLayoutPanel)
        Me.Controls.Add(Me.OKCancelTableLayoutPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "FilterDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.OKCancelTableLayoutPanel, 0)
        Me.Controls.SetChildIndex(Me.FilterTableLayoutPanel, 0)
        Me.OKCancelTableLayoutPanel.ResumeLayout(False)
        Me.FilterTableLayoutPanel.ResumeLayout(False)
        Me.FilterTableLayoutPanel.PerformLayout()
        Me.ValuePanel.ResumeLayout(False)
        Me.ValuePanel.PerformLayout()
        CType(Me.ErrorControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OKCancelTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents OperatorLabel As System.Windows.Forms.Label
    Friend WithEvents ValueLabel As System.Windows.Forms.Label
    Friend WithEvents OperatorComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents FilterTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents ColumnComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents ColumnLabel As System.Windows.Forms.Label
    Friend WithEvents ValuePanel As System.Windows.Forms.Panel
    Friend WithEvents ValueTextBox As System.Windows.Forms.TextBox
    Friend WithEvents ValueComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents ErrorControl As System.Windows.Forms.ErrorProvider
End Class
