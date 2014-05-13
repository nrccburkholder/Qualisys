<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class EReportsFiltersSection
    Inherits NrcAuthAdmin.Section

    'UserControl overrides dispose to clean up the component list.
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
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.EReportsFiltersEditor = New Nrc.NrcAuthAdmin.EReportsFiltersEditor
        Me.WebBrowser1 = New System.Windows.Forms.WebBrowser
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "eReports Filters"
        Me.SectionPanel1.Controls.Add(Me.EReportsFiltersEditor)
        Me.SectionPanel1.Controls.Add(Me.WebBrowser1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(570, 505)
        Me.SectionPanel1.TabIndex = 2
        '
        'EReportsFiltersEditor
        '
        Me.EReportsFiltersEditor.Dock = System.Windows.Forms.DockStyle.Fill
        Me.EReportsFiltersEditor.Location = New System.Drawing.Point(1, 27)
        Me.EReportsFiltersEditor.Name = "EReportsFiltersEditor"
        Me.EReportsFiltersEditor.Size = New System.Drawing.Size(568, 477)
        Me.EReportsFiltersEditor.TabIndex = 2
        '
        'WebBrowser1
        '
        Me.WebBrowser1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WebBrowser1.Location = New System.Drawing.Point(1, 27)
        Me.WebBrowser1.MinimumSize = New System.Drawing.Size(20, 20)
        Me.WebBrowser1.Name = "WebBrowser1"
        Me.WebBrowser1.Size = New System.Drawing.Size(568, 477)
        Me.WebBrowser1.TabIndex = 0
        '
        'EReportsFiltersSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "EReportsFiltersSection"
        Me.Size = New System.Drawing.Size(570, 505)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents WebBrowser1 As System.Windows.Forms.WebBrowser
    Friend WithEvents EReportsFiltersEditor As Nrc.NrcAuthAdmin.EReportsFiltersEditor

End Class
