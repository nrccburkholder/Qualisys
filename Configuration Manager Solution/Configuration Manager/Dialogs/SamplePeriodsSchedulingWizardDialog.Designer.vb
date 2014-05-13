<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SamplePeriodsSchedulingWizardDialog
    Inherits Nrc.WinForms.DialogForm

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
        Me.OKButton = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.SchedulingWizardControl = New Nrc.Qualisys.ConfigurationManager.SchedulingWizard
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Sample Periods Scheduling Wizard"
        Me.mPaneCaption.Size = New System.Drawing.Size(528, 26)
        Me.mPaneCaption.Text = "Sample Periods Scheduling Wizard"
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(349, 285)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 32
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(443, 285)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 33
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'SchedulingWizardControl
        '
        Me.SchedulingWizardControl.BaseLineDateIncrementLabel = "BaseLine Date Increment Number Label:"
        Me.SchedulingWizardControl.Location = New System.Drawing.Point(1, 24)
        Me.SchedulingWizardControl.Name = "SchedulingWizardControl"
        Me.SchedulingWizardControl.OccurrenceNumberLabel = "Occurence Label:"
        Me.SchedulingWizardControl.SamplingSchedule = Nrc.Qualisys.Library.SamplePeriod.SamplingSchedule.Weekly
        Me.SchedulingWizardControl.Size = New System.Drawing.Size(529, 262)
        Me.SchedulingWizardControl.TabIndex = 36
        '
        'SamplePeriodsSchedulingWizardDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Caption = "Sample Periods Scheduling Wizard"
        Me.ClientSize = New System.Drawing.Size(530, 320)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.Cancel_Button)
        Me.Controls.Add(Me.SchedulingWizardControl)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "SamplePeriodsSchedulingWizardDialog"
        Me.ShowIcon = False
        Me.Text = "Sample Periods Scheduling Wizard"
        Me.Controls.SetChildIndex(Me.SchedulingWizardControl, 0)
        Me.Controls.SetChildIndex(Me.Cancel_Button, 0)
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents SchedulingWizardControl As Nrc.Qualisys.ConfigurationManager.SchedulingWizard
End Class
