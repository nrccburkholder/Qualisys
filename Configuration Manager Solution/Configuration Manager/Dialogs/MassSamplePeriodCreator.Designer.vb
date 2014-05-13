<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MassSamplePeriodCreator
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
        Me.PeriodTimeSpanComboBoxEdit = New DevExpress.XtraEditors.ComboBoxEdit
        Me.LabelControl1 = New DevExpress.XtraEditors.LabelControl
        Me.FirstEncounterStartDateEdit = New DevExpress.XtraEditors.DateEdit
        Me.LabelControl2 = New DevExpress.XtraEditors.LabelControl
        Me.SamplingMethodComboBoxEdit = New DevExpress.XtraEditors.ComboBoxEdit
        Me.LabelControl3 = New DevExpress.XtraEditors.LabelControl
        Me.SectionPanel1 = New Nrc.WinForms.SectionPanel
        Me.LabelControl4 = New DevExpress.XtraEditors.LabelControl
        Me.YearComboBoxEdit = New DevExpress.XtraEditors.ComboBoxEdit
        Me.MonthEdit1 = New DevExpress.XtraScheduler.UI.MonthEdit
        Me.PeriodsOccurenceSpinEdit = New DevExpress.XtraEditors.SpinEdit
        Me.SectionPanel2 = New Nrc.WinForms.SectionPanel
        Me.SchedulingWizard = New Nrc.Qualisys.ConfigurationManager.SchedulingWizard
        Me.OKButton = New System.Windows.Forms.Button
        Me.Cancel_Button = New System.Windows.Forms.Button
        CType(Me.PeriodTimeSpanComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FirstEncounterStartDateEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SamplingMethodComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SectionPanel1.SuspendLayout()
        CType(Me.YearComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MonthEdit1.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PeriodsOccurenceSpinEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SectionPanel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Sample Periods Mass Creator"
        Me.mPaneCaption.Size = New System.Drawing.Size(526, 26)
        Me.mPaneCaption.Text = "Sample Periods Mass Creator"
        '
        'PeriodTimeSpanComboBoxEdit
        '
        Me.PeriodTimeSpanComboBoxEdit.Location = New System.Drawing.Point(151, 42)
        Me.PeriodTimeSpanComboBoxEdit.Name = "PeriodTimeSpanComboBoxEdit"
        Me.PeriodTimeSpanComboBoxEdit.Properties.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.PeriodTimeSpanComboBoxEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.PeriodTimeSpanComboBoxEdit.Properties.Items.AddRange(New Object() {"Weekly", "Monthly", "Quarterly"})
        Me.PeriodTimeSpanComboBoxEdit.Properties.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        Me.PeriodTimeSpanComboBoxEdit.Size = New System.Drawing.Size(100, 20)
        Me.PeriodTimeSpanComboBoxEdit.TabIndex = 2
        '
        'LabelControl1
        '
        Me.LabelControl1.Location = New System.Drawing.Point(84, 45)
        Me.LabelControl1.Name = "LabelControl1"
        Me.LabelControl1.Size = New System.Drawing.Size(61, 13)
        Me.LabelControl1.TabIndex = 3
        Me.LabelControl1.Text = "Period Type:"
        '
        'FirstEncounterStartDateEdit
        '
        Me.FirstEncounterStartDateEdit.EditValue = Nothing
        Me.FirstEncounterStartDateEdit.Location = New System.Drawing.Point(151, 80)
        Me.FirstEncounterStartDateEdit.Name = "FirstEncounterStartDateEdit"
        Me.FirstEncounterStartDateEdit.Properties.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.FirstEncounterStartDateEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.FirstEncounterStartDateEdit.Size = New System.Drawing.Size(100, 20)
        Me.FirstEncounterStartDateEdit.TabIndex = 4
        '
        'LabelControl2
        '
        Me.LabelControl2.Location = New System.Drawing.Point(15, 83)
        Me.LabelControl2.Name = "LabelControl2"
        Me.LabelControl2.Size = New System.Drawing.Size(130, 13)
        Me.LabelControl2.TabIndex = 5
        Me.LabelControl2.Text = "First Encounter Start Date:"
        '
        'SamplingMethodComboBoxEdit
        '
        Me.SamplingMethodComboBoxEdit.Location = New System.Drawing.Point(151, 119)
        Me.SamplingMethodComboBoxEdit.Name = "SamplingMethodComboBoxEdit"
        Me.SamplingMethodComboBoxEdit.Properties.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.SamplingMethodComboBoxEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.SamplingMethodComboBoxEdit.Properties.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        Me.SamplingMethodComboBoxEdit.Size = New System.Drawing.Size(100, 20)
        Me.SamplingMethodComboBoxEdit.TabIndex = 6
        '
        'LabelControl3
        '
        Me.LabelControl3.Location = New System.Drawing.Point(60, 122)
        Me.LabelControl3.Name = "LabelControl3"
        Me.LabelControl3.Size = New System.Drawing.Size(85, 13)
        Me.LabelControl3.TabIndex = 7
        Me.LabelControl3.Text = "Sampling Method:"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Period Properties"
        Me.SectionPanel1.Controls.Add(Me.LabelControl4)
        Me.SectionPanel1.Controls.Add(Me.YearComboBoxEdit)
        Me.SectionPanel1.Controls.Add(Me.MonthEdit1)
        Me.SectionPanel1.Controls.Add(Me.PeriodsOccurenceSpinEdit)
        Me.SectionPanel1.Controls.Add(Me.LabelControl2)
        Me.SectionPanel1.Controls.Add(Me.LabelControl1)
        Me.SectionPanel1.Controls.Add(Me.LabelControl3)
        Me.SectionPanel1.Controls.Add(Me.PeriodTimeSpanComboBoxEdit)
        Me.SectionPanel1.Controls.Add(Me.SamplingMethodComboBoxEdit)
        Me.SectionPanel1.Controls.Add(Me.FirstEncounterStartDateEdit)
        Me.SectionPanel1.Location = New System.Drawing.Point(1, 33)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(526, 194)
        Me.SectionPanel1.TabIndex = 8
        '
        'LabelControl4
        '
        Me.LabelControl4.Location = New System.Drawing.Point(53, 159)
        Me.LabelControl4.Name = "LabelControl4"
        Me.LabelControl4.Size = New System.Drawing.Size(92, 13)
        Me.LabelControl4.TabIndex = 10
        Me.LabelControl4.Text = "Number of Periods:"
        '
        'YearComboBoxEdit
        '
        Me.YearComboBoxEdit.Location = New System.Drawing.Point(257, 80)
        Me.YearComboBoxEdit.Name = "YearComboBoxEdit"
        Me.YearComboBoxEdit.Properties.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.YearComboBoxEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.YearComboBoxEdit.Properties.Items.AddRange(New Object() {"2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"})
        Me.YearComboBoxEdit.Properties.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        Me.YearComboBoxEdit.Size = New System.Drawing.Size(100, 20)
        Me.YearComboBoxEdit.TabIndex = 13
        '
        'MonthEdit1
        '
        Me.MonthEdit1.Location = New System.Drawing.Point(151, 80)
        Me.MonthEdit1.Name = "MonthEdit1"
        Me.MonthEdit1.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.MonthEdit1.Size = New System.Drawing.Size(100, 20)
        Me.MonthEdit1.TabIndex = 12
        '
        'PeriodsOccurenceSpinEdit
        '
        Me.PeriodsOccurenceSpinEdit.EditValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.PeriodsOccurenceSpinEdit.Location = New System.Drawing.Point(151, 156)
        Me.PeriodsOccurenceSpinEdit.Name = "PeriodsOccurenceSpinEdit"
        Me.PeriodsOccurenceSpinEdit.Properties.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.PeriodsOccurenceSpinEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton})
        Me.PeriodsOccurenceSpinEdit.Properties.IsFloatValue = False
        Me.PeriodsOccurenceSpinEdit.Properties.Mask.EditMask = "N00"
        Me.PeriodsOccurenceSpinEdit.Properties.MaxValue = New Decimal(New Integer() {100, 0, 0, 0})
        Me.PeriodsOccurenceSpinEdit.Properties.MinValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.PeriodsOccurenceSpinEdit.Size = New System.Drawing.Size(100, 20)
        Me.PeriodsOccurenceSpinEdit.TabIndex = 9
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Projected Samples Properties"
        Me.SectionPanel2.Controls.Add(Me.SchedulingWizard)
        Me.SectionPanel2.Location = New System.Drawing.Point(1, 233)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(526, 294)
        Me.SectionPanel2.TabIndex = 9
        '
        'SchedulingWizard
        '
        Me.SchedulingWizard.BaseLineDateIncrementLabel = "Minimum Days after encounter start date (or today if no start date exists) for fi" & _
            "rst sample to occur:"
        Me.SchedulingWizard.Location = New System.Drawing.Point(0, 42)
        Me.SchedulingWizard.Name = "SchedulingWizard"
        Me.SchedulingWizard.OccurrenceNumberLabel = "Number of Samples:"
        Me.SchedulingWizard.SamplingSchedule = Nrc.Qualisys.Library.SamplePeriod.SamplingSchedule.Weekly
        Me.SchedulingWizard.Size = New System.Drawing.Size(526, 248)
        Me.SchedulingWizard.TabIndex = 1
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(364, 538)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 10
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(445, 538)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 11
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'MassSamplePeriodCreator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Caption = "Sample Periods Mass Creator"
        Me.ClientSize = New System.Drawing.Size(528, 565)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.Cancel_Button)
        Me.Controls.Add(Me.SectionPanel1)
        Me.Controls.Add(Me.SectionPanel2)
        Me.Name = "MassSamplePeriodCreator"
        Me.Text = "MassSamplePeriodCreator"
        Me.Controls.SetChildIndex(Me.SectionPanel2, 0)
        Me.Controls.SetChildIndex(Me.SectionPanel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.Cancel_Button, 0)
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        CType(Me.PeriodTimeSpanComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FirstEncounterStartDateEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SamplingMethodComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.YearComboBoxEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MonthEdit1.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PeriodsOccurenceSpinEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SectionPanel2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SchedulingWizard As Nrc.Qualisys.ConfigurationManager.SchedulingWizard
    Friend WithEvents PeriodTimeSpanComboBoxEdit As DevExpress.XtraEditors.ComboBoxEdit
    Friend WithEvents LabelControl1 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents FirstEncounterStartDateEdit As DevExpress.XtraEditors.DateEdit
    Friend WithEvents LabelControl2 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents SamplingMethodComboBoxEdit As DevExpress.XtraEditors.ComboBoxEdit
    Friend WithEvents LabelControl3 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As Nrc.WinForms.SectionPanel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents LabelControl4 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents PeriodsOccurenceSpinEdit As DevExpress.XtraEditors.SpinEdit
    Friend WithEvents YearComboBoxEdit As DevExpress.XtraEditors.ComboBoxEdit
    Friend WithEvents MonthEdit1 As DevExpress.XtraScheduler.UI.MonthEdit
End Class
