<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CopyDataStructureDialog
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
        Me.StudySelector = New Nrc.Qualisys.ConfigurationManager.ClientStudySelector
        Me.OKButton = New System.Windows.Forms.Button
        Me.UseDefaultButton = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Copy Study Data Structure"
        Me.mPaneCaption.Size = New System.Drawing.Size(334, 26)
        Me.mPaneCaption.Text = "Copy Study Data Structure"
        '
        'StudySelector
        '
        Me.StudySelector.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.StudySelector.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.StudySelector.Location = New System.Drawing.Point(5, 34)
        Me.StudySelector.Name = "StudySelector"
        Me.StudySelector.Size = New System.Drawing.Size(325, 364)
        Me.StudySelector.TabIndex = 1
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(174, 408)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 3
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'UseDefaultButton
        '
        Me.UseDefaultButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.UseDefaultButton.Location = New System.Drawing.Point(6, 408)
        Me.UseDefaultButton.Name = "UseDefaultButton"
        Me.UseDefaultButton.Size = New System.Drawing.Size(152, 23)
        Me.UseDefaultButton.TabIndex = 2
        Me.UseDefaultButton.Text = "Use Default Data Structure"
        Me.UseDefaultButton.UseVisualStyleBackColor = True
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(255, 408)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 4
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'CopyDataStructureDialog
        '
        Me.Caption = "Copy Study Data Structure"
        Me.ClientSize = New System.Drawing.Size(336, 437)
        Me.ControlBox = False
        Me.Controls.Add(Me.Cancel_Button)
        Me.Controls.Add(Me.UseDefaultButton)
        Me.Controls.Add(Me.StudySelector)
        Me.Controls.Add(Me.OKButton)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CopyDataStructureDialog"
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        Me.Controls.SetChildIndex(Me.StudySelector, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.UseDefaultButton, 0)
        Me.Controls.SetChildIndex(Me.Cancel_Button, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents StudySelector As Nrc.Qualisys.ConfigurationManager.ClientStudySelector
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents UseDefaultButton As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button

End Class
