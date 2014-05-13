<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DataEntryVerifyQuestionControl
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.SingleResponseControl = New DevExpress.XtraEditors.RadioGroup
        Me.QuestionLabel = New DevExpress.XtraEditors.LabelControl
        Me.MultipleResponseControl = New DevExpress.XtraEditors.CheckedListBoxControl
        Me.DataEntryVerifyErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.OverrideEntryButton = New System.Windows.Forms.Button
        CType(Me.SingleResponseControl.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MultipleResponseControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DataEntryVerifyErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SingleResponseControl
        '
        Me.SingleResponseControl.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SingleResponseControl.Location = New System.Drawing.Point(3, 23)
        Me.SingleResponseControl.Name = "SingleResponseControl"
        Me.SingleResponseControl.Properties.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.SingleResponseControl.Properties.Appearance.Options.UseBackColor = True
        Me.SingleResponseControl.Properties.BorderStyle = DevExpress.XtraEditors.Controls.BorderStyles.NoBorder
        Me.SingleResponseControl.Properties.Columns = 1
        Me.SingleResponseControl.Properties.Items.AddRange(New DevExpress.XtraEditors.Controls.RadioGroupItem() {New DevExpress.XtraEditors.Controls.RadioGroupItem(1, "Option 1"), New DevExpress.XtraEditors.Controls.RadioGroupItem(2, "Option 2")})
        Me.SingleResponseControl.Size = New System.Drawing.Size(309, 40)
        Me.SingleResponseControl.TabIndex = 0
        '
        'QuestionLabel
        '
        Me.QuestionLabel.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.QuestionLabel.Appearance.Options.UseBackColor = True
        Me.DataEntryVerifyErrorProvider.SetIconPadding(Me.QuestionLabel, 3)
        Me.QuestionLabel.Location = New System.Drawing.Point(3, 4)
        Me.QuestionLabel.Name = "QuestionLabel"
        Me.QuestionLabel.Size = New System.Drawing.Size(157, 13)
        Me.QuestionLabel.TabIndex = 1
        Me.QuestionLabel.Text = "This is the question being asked?"
        '
        'MultipleResponseControl
        '
        Me.MultipleResponseControl.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MultipleResponseControl.Appearance.BackColor = System.Drawing.SystemColors.Control
        Me.MultipleResponseControl.Appearance.Options.UseBackColor = True
        Me.MultipleResponseControl.BorderStyle = DevExpress.XtraEditors.Controls.BorderStyles.NoBorder
        Me.MultipleResponseControl.CheckOnClick = True
        Me.MultipleResponseControl.Items.AddRange(New DevExpress.XtraEditors.Controls.CheckedListBoxItem() {New DevExpress.XtraEditors.Controls.CheckedListBoxItem("Option 1"), New DevExpress.XtraEditors.Controls.CheckedListBoxItem("Option 2")})
        Me.MultipleResponseControl.Location = New System.Drawing.Point(5, 69)
        Me.MultipleResponseControl.Name = "MultipleResponseControl"
        Me.MultipleResponseControl.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.MultipleResponseControl.Size = New System.Drawing.Size(307, 34)
        Me.MultipleResponseControl.TabIndex = 2
        '
        'DataEntryVerifyErrorProvider
        '
        Me.DataEntryVerifyErrorProvider.BlinkRate = 0
        Me.DataEntryVerifyErrorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink
        Me.DataEntryVerifyErrorProvider.ContainerControl = Me
        '
        'OverrideEntryButton
        '
        Me.OverrideEntryButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OverrideEntryButton.Location = New System.Drawing.Point(251, 3)
        Me.OverrideEntryButton.Name = "OverrideEntryButton"
        Me.OverrideEntryButton.Size = New System.Drawing.Size(59, 38)
        Me.OverrideEntryButton.TabIndex = 3
        Me.OverrideEntryButton.Text = "Override Entry"
        Me.OverrideEntryButton.UseVisualStyleBackColor = True
        Me.OverrideEntryButton.Visible = False
        '
        'DataEntryVerifyQuestionControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Controls.Add(Me.OverrideEntryButton)
        Me.Controls.Add(Me.MultipleResponseControl)
        Me.Controls.Add(Me.QuestionLabel)
        Me.Controls.Add(Me.SingleResponseControl)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "DataEntryVerifyQuestionControl"
        Me.Size = New System.Drawing.Size(315, 107)
        CType(Me.SingleResponseControl.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MultipleResponseControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DataEntryVerifyErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents SingleResponseControl As DevExpress.XtraEditors.RadioGroup
    Friend WithEvents QuestionLabel As DevExpress.XtraEditors.LabelControl
    Friend WithEvents MultipleResponseControl As DevExpress.XtraEditors.CheckedListBoxControl
    Friend WithEvents DataEntryVerifyErrorProvider As System.Windows.Forms.ErrorProvider
    Friend WithEvents OverrideEntryButton As System.Windows.Forms.Button

End Class
