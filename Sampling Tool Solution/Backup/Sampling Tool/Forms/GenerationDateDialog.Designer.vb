<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GenerationDateDialog
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
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.OK_Button = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.GenerationDate = New System.Windows.Forms.DateTimePicker
        Me.WarningLabel = New System.Windows.Forms.Label
        Me.WarningImage = New System.Windows.Forms.PictureBox
        Me.TableLayoutPanel1.SuspendLayout()
        CType(Me.WarningImage, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Select a generation date"
        Me.mPaneCaption.Size = New System.Drawing.Size(251, 26)
        Me.mPaneCaption.Text = "Select a generation date"
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.Controls.Add(Me.OK_Button, 0, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.Cancel_Button, 1, 0)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(95, 95)
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
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(4, 42)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(90, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Generation Date:"
        '
        'GenerationDate
        '
        Me.GenerationDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.GenerationDate.Location = New System.Drawing.Point(98, 38)
        Me.GenerationDate.Name = "GenerationDate"
        Me.GenerationDate.Size = New System.Drawing.Size(98, 21)
        Me.GenerationDate.TabIndex = 2
        '
        'WarningLabel
        '
        Me.WarningLabel.AutoSize = True
        Me.WarningLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.WarningLabel.Location = New System.Drawing.Point(29, 70)
        Me.WarningLabel.Name = "WarningLabel"
        Me.WarningLabel.Size = New System.Drawing.Size(75, 13)
        Me.WarningLabel.TabIndex = 3
        Me.WarningLabel.Text = "Warning Label"
        Me.WarningLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'WarningImage
        '
        Me.WarningImage.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Caution16
        Me.WarningImage.Location = New System.Drawing.Point(7, 67)
        Me.WarningImage.Name = "WarningImage"
        Me.WarningImage.Size = New System.Drawing.Size(16, 16)
        Me.WarningImage.TabIndex = 4
        Me.WarningImage.TabStop = False
        '
        'GenerationDateDialog
        '
        Me.AcceptButton = Me.OK_Button
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.Cancel_Button
        Me.Caption = "Select a generation date"
        Me.ClientSize = New System.Drawing.Size(253, 136)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.Controls.Add(Me.WarningImage)
        Me.Controls.Add(Me.WarningLabel)
        Me.Controls.Add(Me.GenerationDate)
        Me.Controls.Add(Me.Label1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "GenerationDateDialog"
        Me.Text = "GenerationDateDialog"
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.GenerationDate, 0)
        Me.Controls.SetChildIndex(Me.WarningLabel, 0)
        Me.Controls.SetChildIndex(Me.WarningImage, 0)
        Me.Controls.SetChildIndex(Me.TableLayoutPanel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.TableLayoutPanel1.ResumeLayout(False)
        CType(Me.WarningImage, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GenerationDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents WarningLabel As System.Windows.Forms.Label
    Friend WithEvents WarningImage As System.Windows.Forms.PictureBox

End Class
