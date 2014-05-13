<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BiMonthlyRecurrenceControl
    Inherits DevExpress.XtraScheduler.UI.RecurrenceControlBase

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
        Me.FirstDaySpinEdit = New DevExpress.XtraEditors.SpinEdit
        Me.LabelControl1 = New DevExpress.XtraEditors.LabelControl
        Me.SecondDaySpinEdit = New DevExpress.XtraEditors.SpinEdit
        Me.LabelControl2 = New DevExpress.XtraEditors.LabelControl
        Me.LabelControl3 = New DevExpress.XtraEditors.LabelControl
        CType(Me.FirstDaySpinEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SecondDaySpinEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'FirstDaySpinEdit
        '
        Me.FirstDaySpinEdit.EditValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.FirstDaySpinEdit.Location = New System.Drawing.Point(51, 38)
        Me.FirstDaySpinEdit.Name = "FirstDaySpinEdit"
        Me.FirstDaySpinEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton})
        Me.FirstDaySpinEdit.Properties.IsFloatValue = False
        Me.FirstDaySpinEdit.Properties.Mask.EditMask = "N00"
        Me.FirstDaySpinEdit.Properties.MaxValue = New Decimal(New Integer() {31, 0, 0, 0})
        Me.FirstDaySpinEdit.Properties.MinValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.FirstDaySpinEdit.Size = New System.Drawing.Size(45, 20)
        Me.FirstDaySpinEdit.TabIndex = 1
        '
        'LabelControl1
        '
        Me.LabelControl1.Location = New System.Drawing.Point(105, 41)
        Me.LabelControl1.Name = "LabelControl1"
        Me.LabelControl1.Size = New System.Drawing.Size(18, 13)
        Me.LabelControl1.TabIndex = 2
        Me.LabelControl1.Text = "and"
        '
        'SecondDaySpinEdit
        '
        Me.SecondDaySpinEdit.EditValue = New Decimal(New Integer() {15, 0, 0, 0})
        Me.SecondDaySpinEdit.Location = New System.Drawing.Point(132, 38)
        Me.SecondDaySpinEdit.Name = "SecondDaySpinEdit"
        Me.SecondDaySpinEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton})
        Me.SecondDaySpinEdit.Properties.IsFloatValue = False
        Me.SecondDaySpinEdit.Properties.Mask.EditMask = "N00"
        Me.SecondDaySpinEdit.Properties.MaxValue = New Decimal(New Integer() {31, 0, 0, 0})
        Me.SecondDaySpinEdit.Properties.MinValue = New Decimal(New Integer() {1, 0, 0, 0})
        Me.SecondDaySpinEdit.Size = New System.Drawing.Size(45, 20)
        Me.SecondDaySpinEdit.TabIndex = 3
        '
        'LabelControl2
        '
        Me.LabelControl2.Location = New System.Drawing.Point(16, 41)
        Me.LabelControl2.Name = "LabelControl2"
        Me.LabelControl2.Size = New System.Drawing.Size(24, 13)
        Me.LabelControl2.TabIndex = 4
        Me.LabelControl2.Text = "Days"
        '
        'LabelControl3
        '
        Me.LabelControl3.Location = New System.Drawing.Point(188, 41)
        Me.LabelControl3.Name = "LabelControl3"
        Me.LabelControl3.Size = New System.Drawing.Size(69, 13)
        Me.LabelControl3.TabIndex = 5
        Me.LabelControl3.Text = "of each month"
        '
        'BiMonthlyRecurrenceControl
        '
        Me.Appearance.BackColor = System.Drawing.Color.Transparent
        Me.Appearance.Options.UseBackColor = True
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.LabelControl3)
        Me.Controls.Add(Me.LabelControl2)
        Me.Controls.Add(Me.SecondDaySpinEdit)
        Me.Controls.Add(Me.LabelControl1)
        Me.Controls.Add(Me.FirstDaySpinEdit)
        Me.Name = "BiMonthlyRecurrenceControl"
        CType(Me.FirstDaySpinEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SecondDaySpinEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents FirstDaySpinEdit As DevExpress.XtraEditors.SpinEdit
    Friend WithEvents LabelControl1 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents SecondDaySpinEdit As DevExpress.XtraEditors.SpinEdit
    Friend WithEvents LabelControl2 As DevExpress.XtraEditors.LabelControl
    Friend WithEvents LabelControl3 As DevExpress.XtraEditors.LabelControl

End Class
