<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportNavigator
    Inherits Service_Alert_Emails.Navigator

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
        Me.HeaderStrip2 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.Categories = New System.Windows.Forms.ListBox
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.Reports = New System.Windows.Forms.ListBox
        Me.HeaderStrip2.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.HeaderStrip1.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip2
        '
        Me.HeaderStrip2.AutoSize = False
        Me.HeaderStrip2.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip2.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip2.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel2})
        Me.HeaderStrip2.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip2.Name = "HeaderStrip2"
        Me.HeaderStrip2.Size = New System.Drawing.Size(218, 19)
        Me.HeaderStrip2.TabIndex = 3
        Me.HeaderStrip2.Text = "HeaderStrip2"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(45, 16)
        Me.ToolStripLabel2.Text = "Reports"
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.Categories)
        Me.Panel1.Controls.Add(Me.HeaderStrip1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Margin = New System.Windows.Forms.Padding(0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(218, 150)
        Me.Panel1.TabIndex = 4
        '
        'Categories
        '
        Me.Categories.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Categories.FormattingEnabled = True
        Me.Categories.IntegralHeight = False
        Me.Categories.Items.AddRange(New Object() {"Entertainment", "Business", "Software Development", "Weather"})
        Me.Categories.Location = New System.Drawing.Point(0, 19)
        Me.Categories.Name = "Categories"
        Me.Categories.Size = New System.Drawing.Size(218, 131)
        Me.Categories.TabIndex = 4
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(218, 19)
        Me.HeaderStrip1.TabIndex = 3
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(95, 16)
        Me.ToolStripLabel1.Text = "Report Categories"
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.Reports)
        Me.Panel2.Controls.Add(Me.HeaderStrip2)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel2.Location = New System.Drawing.Point(0, 150)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(218, 306)
        Me.Panel2.TabIndex = 5
        '
        'Reports
        '
        Me.Reports.DisplayMember = "Key"
        Me.Reports.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Reports.FormattingEnabled = True
        Me.Reports.IntegralHeight = False
        Me.Reports.Location = New System.Drawing.Point(0, 19)
        Me.Reports.Name = "Reports"
        Me.Reports.Size = New System.Drawing.Size(218, 287)
        Me.Reports.TabIndex = 4
        '
        'ReportNavigator
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.Panel2)
        Me.Controls.Add(Me.Panel1)
        Me.Name = "ReportNavigator"
        Me.Size = New System.Drawing.Size(218, 456)
        Me.HeaderStrip2.ResumeLayout(False)
        Me.HeaderStrip2.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.Panel2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip2 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Categories As System.Windows.Forms.ListBox
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents Reports As System.Windows.Forms.ListBox

End Class
