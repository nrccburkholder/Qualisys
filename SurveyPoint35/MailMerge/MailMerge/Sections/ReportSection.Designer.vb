<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportSection
    Inherits Section

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
        Me.HeaderStrip1 = New PS.Framework.WinForms.HeaderStrip
        Me.tsReportLabel = New System.Windows.Forms.ToolStripLabel
        Me.tabReports = New System.Windows.Forms.TabControl
        Me.tabMergeQueue = New System.Windows.Forms.TabPage
        Me.WebBrowser2 = New System.Windows.Forms.WebBrowser
        Me.cmdQueStatusReport = New System.Windows.Forms.Button
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.dteEndDate = New System.Windows.Forms.DateTimePicker
        Me.dteStartDate = New System.Windows.Forms.DateTimePicker
        Me.tabBundlingReport = New System.Windows.Forms.TabPage
        Me.txtMergeQueueID = New System.Windows.Forms.TextBox
        Me.WebBrowser1 = New System.Windows.Forms.WebBrowser
        Me.cmdViewBundlingReport = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.HeaderStrip1.SuspendLayout()
        Me.tabReports.SuspendLayout()
        Me.tabMergeQueue.SuspendLayout()
        Me.tabBundlingReport.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = PS.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsReportLabel})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(742, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'tsReportLabel
        '
        Me.tsReportLabel.Name = "tsReportLabel"
        Me.tsReportLabel.Size = New System.Drawing.Size(90, 22)
        Me.tsReportLabel.Text = "Reporting"
        '
        'tabReports
        '
        Me.tabReports.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabReports.Controls.Add(Me.tabMergeQueue)
        Me.tabReports.Controls.Add(Me.tabBundlingReport)
        Me.tabReports.Location = New System.Drawing.Point(3, 28)
        Me.tabReports.Name = "tabReports"
        Me.tabReports.SelectedIndex = 0
        Me.tabReports.Size = New System.Drawing.Size(736, 593)
        Me.tabReports.TabIndex = 1
        '
        'tabMergeQueue
        '
        Me.tabMergeQueue.Controls.Add(Me.WebBrowser2)
        Me.tabMergeQueue.Controls.Add(Me.cmdQueStatusReport)
        Me.tabMergeQueue.Controls.Add(Me.Label3)
        Me.tabMergeQueue.Controls.Add(Me.Label2)
        Me.tabMergeQueue.Controls.Add(Me.dteEndDate)
        Me.tabMergeQueue.Controls.Add(Me.dteStartDate)
        Me.tabMergeQueue.Location = New System.Drawing.Point(4, 22)
        Me.tabMergeQueue.Name = "tabMergeQueue"
        Me.tabMergeQueue.Size = New System.Drawing.Size(728, 567)
        Me.tabMergeQueue.TabIndex = 1
        Me.tabMergeQueue.Text = "Survey Merge Queue"
        Me.tabMergeQueue.UseVisualStyleBackColor = True
        '
        'WebBrowser2
        '
        Me.WebBrowser2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebBrowser2.Location = New System.Drawing.Point(0, 33)
        Me.WebBrowser2.MinimumSize = New System.Drawing.Size(20, 20)
        Me.WebBrowser2.Name = "WebBrowser2"
        Me.WebBrowser2.Size = New System.Drawing.Size(722, 531)
        Me.WebBrowser2.TabIndex = 5
        '
        'cmdQueStatusReport
        '
        Me.cmdQueStatusReport.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdQueStatusReport.Location = New System.Drawing.Point(612, 3)
        Me.cmdQueStatusReport.Name = "cmdQueStatusReport"
        Me.cmdQueStatusReport.Size = New System.Drawing.Size(110, 23)
        Me.cmdQueStatusReport.TabIndex = 4
        Me.cmdQueStatusReport.Text = "View Report"
        Me.cmdQueStatusReport.UseVisualStyleBackColor = True
        '
        'Label3
        '
        Me.Label3.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(398, 8)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(113, 13)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Queue Item End Date:"
        '
        'Label2
        '
        Me.Label2.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(178, 8)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(116, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Queue Item Start Date:"
        '
        'dteEndDate
        '
        Me.dteEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dteEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dteEndDate.Location = New System.Drawing.Point(517, 4)
        Me.dteEndDate.Name = "dteEndDate"
        Me.dteEndDate.Size = New System.Drawing.Size(89, 20)
        Me.dteEndDate.TabIndex = 1
        '
        'dteStartDate
        '
        Me.dteStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dteStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dteStartDate.Location = New System.Drawing.Point(300, 4)
        Me.dteStartDate.Name = "dteStartDate"
        Me.dteStartDate.Size = New System.Drawing.Size(92, 20)
        Me.dteStartDate.TabIndex = 0
        '
        'tabBundlingReport
        '
        Me.tabBundlingReport.Controls.Add(Me.txtMergeQueueID)
        Me.tabBundlingReport.Controls.Add(Me.WebBrowser1)
        Me.tabBundlingReport.Controls.Add(Me.cmdViewBundlingReport)
        Me.tabBundlingReport.Controls.Add(Me.Label1)
        Me.tabBundlingReport.Location = New System.Drawing.Point(4, 22)
        Me.tabBundlingReport.Name = "tabBundlingReport"
        Me.tabBundlingReport.Padding = New System.Windows.Forms.Padding(3)
        Me.tabBundlingReport.Size = New System.Drawing.Size(728, 567)
        Me.tabBundlingReport.TabIndex = 0
        Me.tabBundlingReport.Text = "Bundling Report"
        Me.tabBundlingReport.UseVisualStyleBackColor = True
        '
        'txtMergeQueueID
        '
        Me.txtMergeQueueID.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtMergeQueueID.Location = New System.Drawing.Point(583, 10)
        Me.txtMergeQueueID.Name = "txtMergeQueueID"
        Me.txtMergeQueueID.Size = New System.Drawing.Size(58, 20)
        Me.txtMergeQueueID.TabIndex = 4
        '
        'WebBrowser1
        '
        Me.WebBrowser1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebBrowser1.Location = New System.Drawing.Point(6, 33)
        Me.WebBrowser1.MinimumSize = New System.Drawing.Size(20, 20)
        Me.WebBrowser1.Name = "WebBrowser1"
        Me.WebBrowser1.Size = New System.Drawing.Size(716, 528)
        Me.WebBrowser1.TabIndex = 3
        '
        'cmdViewBundlingReport
        '
        Me.cmdViewBundlingReport.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdViewBundlingReport.Location = New System.Drawing.Point(647, 8)
        Me.cmdViewBundlingReport.Name = "cmdViewBundlingReport"
        Me.cmdViewBundlingReport.Size = New System.Drawing.Size(75, 23)
        Me.cmdViewBundlingReport.TabIndex = 1
        Me.cmdViewBundlingReport.Text = "View Report"
        Me.cmdViewBundlingReport.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(488, 13)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(89, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Merge Queue ID:"
        '
        'ReportSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.tabReports)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "ReportSection"
        Me.Size = New System.Drawing.Size(742, 624)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.tabReports.ResumeLayout(False)
        Me.tabMergeQueue.ResumeLayout(False)
        Me.tabMergeQueue.PerformLayout()
        Me.tabBundlingReport.ResumeLayout(False)
        Me.tabBundlingReport.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As PS.Framework.WinForms.HeaderStrip
    Friend WithEvents tsReportLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents tabReports As System.Windows.Forms.TabControl
    Friend WithEvents tabBundlingReport As System.Windows.Forms.TabPage
    Friend WithEvents WebBrowser1 As System.Windows.Forms.WebBrowser
    Friend WithEvents cmdViewBundlingReport As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents tabMergeQueue As System.Windows.Forms.TabPage
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents dteEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents dteStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents WebBrowser2 As System.Windows.Forms.WebBrowser
    Friend WithEvents cmdQueStatusReport As System.Windows.Forms.Button
    Friend WithEvents txtMergeQueueID As System.Windows.Forms.TextBox

End Class
