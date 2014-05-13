<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class HCAHPSMngrSection
    Inherits Qualisys.ConfigurationManager.Section

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
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.cmdApply = New System.Windows.Forms.Button
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.cboPropCalcMonth = New System.Windows.Forms.ComboBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.lstRecalcDates = New System.Windows.Forms.ListBox
        Me.cmdRemovePropCalcDate = New System.Windows.Forms.Button
        Me.cmdAddReCalcDate = New System.Windows.Forms.Button
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.txtInEligibleRate = New System.Windows.Forms.TextBox
        Me.txtFocusCensus = New System.Windows.Forms.TextBox
        Me.txtResponseRate = New System.Windows.Forms.TextBox
        Me.txtAnnualReturnRate = New System.Windows.Forms.TextBox
        Me.txtPropCalcThreshold = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.ErrorProvider1 = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.SectionPanel1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        CType(Me.ErrorProvider1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "HCAHPS Manager"
        Me.SectionPanel1.Controls.Add(Me.cmdCancel)
        Me.SectionPanel1.Controls.Add(Me.cmdApply)
        Me.SectionPanel1.Controls.Add(Me.GroupBox2)
        Me.SectionPanel1.Controls.Add(Me.GroupBox1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(639, 545)
        Me.SectionPanel1.TabIndex = 0
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.Location = New System.Drawing.Point(551, 513)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 11
        Me.cmdCancel.Text = "&Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'cmdApply
        '
        Me.cmdApply.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdApply.Location = New System.Drawing.Point(470, 513)
        Me.cmdApply.Name = "cmdApply"
        Me.cmdApply.Size = New System.Drawing.Size(75, 23)
        Me.cmdApply.TabIndex = 10
        Me.cmdApply.Text = "&Apply"
        Me.cmdApply.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.cboPropCalcMonth)
        Me.GroupBox2.Controls.Add(Me.Label3)
        Me.GroupBox2.Controls.Add(Me.lstRecalcDates)
        Me.GroupBox2.Controls.Add(Me.cmdRemovePropCalcDate)
        Me.GroupBox2.Controls.Add(Me.cmdAddReCalcDate)
        Me.GroupBox2.Location = New System.Drawing.Point(10, 239)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(619, 250)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Proportion ReCalc Dates"
        '
        'cboPropCalcMonth
        '
        Me.cboPropCalcMonth.FormattingEnabled = True
        Me.cboPropCalcMonth.Location = New System.Drawing.Point(13, 18)
        Me.cboPropCalcMonth.Name = "cboPropCalcMonth"
        Me.cboPropCalcMonth.Size = New System.Drawing.Size(193, 21)
        Me.cboPropCalcMonth.TabIndex = 10
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(7, 51)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(127, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Selected ReCalc Date(s):"
        '
        'lstRecalcDates
        '
        Me.lstRecalcDates.FormattingEnabled = True
        Me.lstRecalcDates.Location = New System.Drawing.Point(10, 67)
        Me.lstRecalcDates.Name = "lstRecalcDates"
        Me.lstRecalcDates.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.lstRecalcDates.Size = New System.Drawing.Size(196, 173)
        Me.lstRecalcDates.TabIndex = 9
        '
        'cmdRemovePropCalcDate
        '
        Me.cmdRemovePropCalcDate.Location = New System.Drawing.Point(377, 16)
        Me.cmdRemovePropCalcDate.Name = "cmdRemovePropCalcDate"
        Me.cmdRemovePropCalcDate.Size = New System.Drawing.Size(158, 23)
        Me.cmdRemovePropCalcDate.TabIndex = 8
        Me.cmdRemovePropCalcDate.Text = "Remove Selected Date(s)"
        Me.cmdRemovePropCalcDate.UseVisualStyleBackColor = True
        '
        'cmdAddReCalcDate
        '
        Me.cmdAddReCalcDate.Location = New System.Drawing.Point(224, 16)
        Me.cmdAddReCalcDate.Name = "cmdAddReCalcDate"
        Me.cmdAddReCalcDate.Size = New System.Drawing.Size(147, 23)
        Me.cmdAddReCalcDate.TabIndex = 7
        Me.cmdAddReCalcDate.Text = "Add ReCalc Date"
        Me.cmdAddReCalcDate.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.txtInEligibleRate)
        Me.GroupBox1.Controls.Add(Me.txtFocusCensus)
        Me.GroupBox1.Controls.Add(Me.txtResponseRate)
        Me.GroupBox1.Controls.Add(Me.txtAnnualReturnRate)
        Me.GroupBox1.Controls.Add(Me.txtPropCalcThreshold)
        Me.GroupBox1.Controls.Add(Me.Label6)
        Me.GroupBox1.Controls.Add(Me.Label5)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(10, 38)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(619, 195)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Global Proportion Default"
        '
        'txtInEligibleRate
        '
        Me.txtInEligibleRate.Location = New System.Drawing.Point(156, 42)
        Me.txtInEligibleRate.Name = "txtInEligibleRate"
        Me.txtInEligibleRate.Size = New System.Drawing.Size(100, 21)
        Me.txtInEligibleRate.TabIndex = 2
        '
        'txtFocusCensus
        '
        Me.txtFocusCensus.Location = New System.Drawing.Point(156, 120)
        Me.txtFocusCensus.Name = "txtFocusCensus"
        Me.txtFocusCensus.Size = New System.Drawing.Size(100, 21)
        Me.txtFocusCensus.TabIndex = 5
        '
        'txtResponseRate
        '
        Me.txtResponseRate.Location = New System.Drawing.Point(156, 16)
        Me.txtResponseRate.Name = "txtResponseRate"
        Me.txtResponseRate.Size = New System.Drawing.Size(100, 21)
        Me.txtResponseRate.TabIndex = 1
        '
        'txtAnnualReturnRate
        '
        Me.txtAnnualReturnRate.Location = New System.Drawing.Point(156, 68)
        Me.txtAnnualReturnRate.Name = "txtAnnualReturnRate"
        Me.txtAnnualReturnRate.Size = New System.Drawing.Size(100, 21)
        Me.txtAnnualReturnRate.TabIndex = 3
        '
        'txtPropCalcThreshold
        '
        Me.txtPropCalcThreshold.Location = New System.Drawing.Point(156, 94)
        Me.txtPropCalcThreshold.Name = "txtPropCalcThreshold"
        Me.txtPropCalcThreshold.Size = New System.Drawing.Size(100, 21)
        Me.txtPropCalcThreshold.TabIndex = 4
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(6, 71)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(106, 13)
        Me.Label6.TabIndex = 5
        Me.Label6.Text = "Annual Return Rate:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(6, 97)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(151, 13)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "Proportion Change Threshold:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(6, 123)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(135, 13)
        Me.Label4.TabIndex = 3
        Me.Label4.Text = "Force Census Sampling At:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 45)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(79, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Ineligible Rate:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 19)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(84, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Response Rate:"
        '
        'ErrorProvider1
        '
        Me.ErrorProvider1.ContainerControl = Me
        '
        'HCAHPSMngrSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "HCAHPSMngrSection"
        Me.Size = New System.Drawing.Size(639, 545)
        Me.SectionPanel1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        CType(Me.ErrorProvider1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtInEligibleRate As System.Windows.Forms.TextBox
    Friend WithEvents txtFocusCensus As System.Windows.Forms.TextBox
    Friend WithEvents txtResponseRate As System.Windows.Forms.TextBox
    Friend WithEvents txtAnnualReturnRate As System.Windows.Forms.TextBox
    Friend WithEvents txtPropCalcThreshold As System.Windows.Forms.TextBox
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents cmdApply As System.Windows.Forms.Button
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lstRecalcDates As System.Windows.Forms.ListBox
    Friend WithEvents cmdRemovePropCalcDate As System.Windows.Forms.Button
    Friend WithEvents cmdAddReCalcDate As System.Windows.Forms.Button
    Friend WithEvents ErrorProvider1 As System.Windows.Forms.ErrorProvider
    Friend WithEvents cboPropCalcMonth As System.Windows.Forms.ComboBox

End Class
