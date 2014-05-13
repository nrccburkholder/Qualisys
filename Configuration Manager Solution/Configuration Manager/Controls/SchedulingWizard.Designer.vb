<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SchedulingWizard
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
        Me.BaseLineDateIncrementNumberLabel = New System.Windows.Forms.Label
        Me.OccurrenceLabel = New System.Windows.Forms.Label
        Me.RecurrenceGroupBox = New System.Windows.Forms.GroupBox
        Me.BiMonthlyRadioButton = New System.Windows.Forms.RadioButton
        Me.MonthlyRadioButton = New System.Windows.Forms.RadioButton
        Me.WeeklyRadioButton = New System.Windows.Forms.RadioButton
        Me.DailyRadioButton = New System.Windows.Forms.RadioButton
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.SamplePeriodWeeklyRecurrenceControl = New DevExpress.XtraScheduler.UI.WeeklyRecurrenceControl
        Me.SamplePeriodDailyRecurrenceControl = New DevExpress.XtraScheduler.UI.DailyRecurrenceControl
        Me.BiMonthlyRecurrenceControl = New Nrc.Qualisys.ConfigurationManager.BiMonthlyRecurrenceControl
        Me.SamplePeriodMonthlyRecurrenceControl = New DevExpress.XtraScheduler.UI.MonthlyRecurrenceControl
        Me.OccurenceNumberNumericUpDown = New System.Windows.Forms.NumericUpDown
        Me.BaselineDateIncrementNumericUpDown = New System.Windows.Forms.NumericUpDown
        Me.RecurrenceGroupBox.SuspendLayout()
        Me.Panel1.SuspendLayout()
        CType(Me.OccurenceNumberNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BaselineDateIncrementNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'BaseLineDateIncrementNumberLabel
        '
        Me.BaseLineDateIncrementNumberLabel.Location = New System.Drawing.Point(30, 47)
        Me.BaseLineDateIncrementNumberLabel.Name = "BaseLineDateIncrementNumberLabel"
        Me.BaseLineDateIncrementNumberLabel.Size = New System.Drawing.Size(284, 33)
        Me.BaseLineDateIncrementNumberLabel.TabIndex = 38
        Me.BaseLineDateIncrementNumberLabel.Text = "BaseLine Date " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Increment Number Label:"
        Me.BaseLineDateIncrementNumberLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'OccurrenceLabel
        '
        Me.OccurrenceLabel.Location = New System.Drawing.Point(30, 11)
        Me.OccurrenceLabel.Name = "OccurrenceLabel"
        Me.OccurrenceLabel.Size = New System.Drawing.Size(284, 30)
        Me.OccurrenceLabel.TabIndex = 36
        Me.OccurrenceLabel.Text = "Occurence " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Label:"
        Me.OccurrenceLabel.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'RecurrenceGroupBox
        '
        Me.RecurrenceGroupBox.Controls.Add(Me.BiMonthlyRadioButton)
        Me.RecurrenceGroupBox.Controls.Add(Me.MonthlyRadioButton)
        Me.RecurrenceGroupBox.Controls.Add(Me.WeeklyRadioButton)
        Me.RecurrenceGroupBox.Controls.Add(Me.DailyRadioButton)
        Me.RecurrenceGroupBox.Location = New System.Drawing.Point(14, 82)
        Me.RecurrenceGroupBox.Name = "RecurrenceGroupBox"
        Me.RecurrenceGroupBox.Size = New System.Drawing.Size(102, 153)
        Me.RecurrenceGroupBox.TabIndex = 42
        Me.RecurrenceGroupBox.TabStop = False
        Me.RecurrenceGroupBox.Text = "Recurrence"
        '
        'BiMonthlyRadioButton
        '
        Me.BiMonthlyRadioButton.AutoSize = True
        Me.BiMonthlyRadioButton.Location = New System.Drawing.Point(23, 124)
        Me.BiMonthlyRadioButton.Name = "BiMonthlyRadioButton"
        Me.BiMonthlyRadioButton.Size = New System.Drawing.Size(71, 17)
        Me.BiMonthlyRadioButton.TabIndex = 3
        Me.BiMonthlyRadioButton.Text = "BiMonthly"
        Me.BiMonthlyRadioButton.UseVisualStyleBackColor = True
        '
        'MonthlyRadioButton
        '
        Me.MonthlyRadioButton.AutoSize = True
        Me.MonthlyRadioButton.Location = New System.Drawing.Point(23, 87)
        Me.MonthlyRadioButton.Name = "MonthlyRadioButton"
        Me.MonthlyRadioButton.Size = New System.Drawing.Size(62, 17)
        Me.MonthlyRadioButton.TabIndex = 2
        Me.MonthlyRadioButton.Text = "Monthly"
        Me.MonthlyRadioButton.UseVisualStyleBackColor = True
        '
        'WeeklyRadioButton
        '
        Me.WeeklyRadioButton.AutoSize = True
        Me.WeeklyRadioButton.Checked = True
        Me.WeeklyRadioButton.Location = New System.Drawing.Point(23, 54)
        Me.WeeklyRadioButton.Name = "WeeklyRadioButton"
        Me.WeeklyRadioButton.Size = New System.Drawing.Size(61, 17)
        Me.WeeklyRadioButton.TabIndex = 1
        Me.WeeklyRadioButton.TabStop = True
        Me.WeeklyRadioButton.Text = "Weekly"
        Me.WeeklyRadioButton.UseVisualStyleBackColor = True
        '
        'DailyRadioButton
        '
        Me.DailyRadioButton.AutoSize = True
        Me.DailyRadioButton.Location = New System.Drawing.Point(23, 19)
        Me.DailyRadioButton.Name = "DailyRadioButton"
        Me.DailyRadioButton.Size = New System.Drawing.Size(48, 17)
        Me.DailyRadioButton.TabIndex = 0
        Me.DailyRadioButton.Text = "Daily"
        Me.DailyRadioButton.UseVisualStyleBackColor = True
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.SamplePeriodWeeklyRecurrenceControl)
        Me.Panel1.Controls.Add(Me.SamplePeriodDailyRecurrenceControl)
        Me.Panel1.Controls.Add(Me.BiMonthlyRecurrenceControl)
        Me.Panel1.Controls.Add(Me.SamplePeriodMonthlyRecurrenceControl)
        Me.Panel1.Location = New System.Drawing.Point(140, 92)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(376, 131)
        Me.Panel1.TabIndex = 43
        '
        'SamplePeriodWeeklyRecurrenceControl
        '
        Me.SamplePeriodWeeklyRecurrenceControl.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.SamplePeriodWeeklyRecurrenceControl.Appearance.Options.UseBackColor = True
        Me.SamplePeriodWeeklyRecurrenceControl.Location = New System.Drawing.Point(3, 19)
        Me.SamplePeriodWeeklyRecurrenceControl.Name = "SamplePeriodWeeklyRecurrenceControl"
        Me.SamplePeriodWeeklyRecurrenceControl.Size = New System.Drawing.Size(368, 96)
        Me.SamplePeriodWeeklyRecurrenceControl.TabIndex = 0
        '
        'SamplePeriodDailyRecurrenceControl
        '
        Me.SamplePeriodDailyRecurrenceControl.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.SamplePeriodDailyRecurrenceControl.Appearance.Options.UseBackColor = True
        Me.SamplePeriodDailyRecurrenceControl.Location = New System.Drawing.Point(3, 19)
        Me.SamplePeriodDailyRecurrenceControl.Name = "SamplePeriodDailyRecurrenceControl"
        Me.SamplePeriodDailyRecurrenceControl.Size = New System.Drawing.Size(368, 96)
        Me.SamplePeriodDailyRecurrenceControl.TabIndex = 0
        Me.SamplePeriodDailyRecurrenceControl.Visible = False
        '
        'BiMonthlyRecurrenceControl
        '
        Me.BiMonthlyRecurrenceControl.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.BiMonthlyRecurrenceControl.Appearance.Options.UseBackColor = True
        Me.BiMonthlyRecurrenceControl.Location = New System.Drawing.Point(3, 19)
        Me.BiMonthlyRecurrenceControl.Name = "BiMonthlyRecurrenceControl"
        Me.BiMonthlyRecurrenceControl.Size = New System.Drawing.Size(368, 96)
        Me.BiMonthlyRecurrenceControl.TabIndex = 1
        Me.BiMonthlyRecurrenceControl.Visible = False
        '
        'SamplePeriodMonthlyRecurrenceControl
        '
        Me.SamplePeriodMonthlyRecurrenceControl.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.SamplePeriodMonthlyRecurrenceControl.Appearance.Options.UseBackColor = True
        Me.SamplePeriodMonthlyRecurrenceControl.Location = New System.Drawing.Point(3, 19)
        Me.SamplePeriodMonthlyRecurrenceControl.Name = "SamplePeriodMonthlyRecurrenceControl"
        Me.SamplePeriodMonthlyRecurrenceControl.Size = New System.Drawing.Size(368, 96)
        Me.SamplePeriodMonthlyRecurrenceControl.TabIndex = 0
        Me.SamplePeriodMonthlyRecurrenceControl.Visible = False
        '
        'OccurenceNumberNumericUpDown
        '
        Me.OccurenceNumberNumericUpDown.Location = New System.Drawing.Point(316, 14)
        Me.OccurenceNumberNumericUpDown.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.OccurenceNumberNumericUpDown.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.OccurenceNumberNumericUpDown.Name = "OccurenceNumberNumericUpDown"
        Me.OccurenceNumberNumericUpDown.Size = New System.Drawing.Size(74, 20)
        Me.OccurenceNumberNumericUpDown.TabIndex = 37
        Me.OccurenceNumberNumericUpDown.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'BaselineDateIncrementNumericUpDown
        '
        Me.BaselineDateIncrementNumericUpDown.Location = New System.Drawing.Point(316, 54)
        Me.BaselineDateIncrementNumericUpDown.Maximum = New Decimal(New Integer() {365, 0, 0, 0})
        Me.BaselineDateIncrementNumericUpDown.Name = "BaselineDateIncrementNumericUpDown"
        Me.BaselineDateIncrementNumericUpDown.Size = New System.Drawing.Size(74, 20)
        Me.BaselineDateIncrementNumericUpDown.TabIndex = 44
        '
        'SchedulingWizard
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.BaselineDateIncrementNumericUpDown)
        Me.Controls.Add(Me.RecurrenceGroupBox)
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.BaseLineDateIncrementNumberLabel)
        Me.Controls.Add(Me.OccurrenceLabel)
        Me.Controls.Add(Me.OccurenceNumberNumericUpDown)
        Me.Name = "SchedulingWizard"
        Me.Size = New System.Drawing.Size(533, 262)
        Me.RecurrenceGroupBox.ResumeLayout(False)
        Me.RecurrenceGroupBox.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        CType(Me.OccurenceNumberNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BaselineDateIncrementNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents RecurrenceGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents BiMonthlyRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents MonthlyRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents WeeklyRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents DailyRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents SamplePeriodWeeklyRecurrenceControl As DevExpress.XtraScheduler.UI.WeeklyRecurrenceControl
    Friend WithEvents SamplePeriodDailyRecurrenceControl As DevExpress.XtraScheduler.UI.DailyRecurrenceControl
    Friend WithEvents BiMonthlyRecurrenceControl As Nrc.Qualisys.ConfigurationManager.BiMonthlyRecurrenceControl
    Friend WithEvents SamplePeriodMonthlyRecurrenceControl As DevExpress.XtraScheduler.UI.MonthlyRecurrenceControl
    Friend WithEvents OccurenceNumberNumericUpDown As System.Windows.Forms.NumericUpDown
    Friend WithEvents BaselineDateIncrementNumericUpDown As System.Windows.Forms.NumericUpDown
    Friend WithEvents OccurrenceLabel As System.Windows.Forms.Label
    Friend WithEvents BaseLineDateIncrementNumberLabel As System.Windows.Forms.Label

End Class
