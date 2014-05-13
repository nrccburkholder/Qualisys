<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportViewerSection
    Inherits PervasiveViewer.Section

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
        Me.ViewReportMenuItem = New System.Windows.Forms.MenuItem
        Me.ReportsContextMenu = New System.Windows.Forms.ContextMenu
        Me.CrossTabsMenuItem = New System.Windows.Forms.MenuItem
        Me.ReportWebBrowser = New System.Windows.Forms.WebBrowser
        Me.PaneCaption = New Nrc.Framework.WinForms.PaneCaption
        Me.ReportViewerSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.AbandonButton = New System.Windows.Forms.Button
        Me.ApproveButton = New System.Windows.Forms.Button
        Me.ReportViewerSectionPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'ViewReportMenuItem
        '
        Me.ViewReportMenuItem.Index = 0
        Me.ViewReportMenuItem.Text = "View Reports"
        '
        'ReportsContextMenu
        '
        Me.ReportsContextMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.ViewReportMenuItem, Me.CrossTabsMenuItem})
        '
        'CrossTabsMenuItem
        '
        Me.CrossTabsMenuItem.Index = 1
        Me.CrossTabsMenuItem.Text = "Cross Tabs"
        '
        'ReportWebBrowser
        '
        Me.ReportWebBrowser.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportWebBrowser.Location = New System.Drawing.Point(4, 33)
        Me.ReportWebBrowser.MinimumSize = New System.Drawing.Size(20, 20)
        Me.ReportWebBrowser.Name = "ReportWebBrowser"
        Me.ReportWebBrowser.Size = New System.Drawing.Size(622, 575)
        Me.ReportWebBrowser.TabIndex = 4
        '
        'PaneCaption
        '
        Me.PaneCaption.Caption = "Report Viewer"
        Me.PaneCaption.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption.Location = New System.Drawing.Point(1, 1)
        Me.PaneCaption.Name = "PaneCaption"
        Me.PaneCaption.Size = New System.Drawing.Size(628, 26)
        Me.PaneCaption.TabIndex = 3
        Me.PaneCaption.Text = "Report Viewer"
        '
        'ReportViewerSectionPanel
        '
        Me.ReportViewerSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.ReportViewerSectionPanel.Caption = ""
        Me.ReportViewerSectionPanel.Controls.Add(Me.AbandonButton)
        Me.ReportViewerSectionPanel.Controls.Add(Me.ReportWebBrowser)
        Me.ReportViewerSectionPanel.Controls.Add(Me.PaneCaption)
        Me.ReportViewerSectionPanel.Controls.Add(Me.ApproveButton)
        Me.ReportViewerSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ReportViewerSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.ReportViewerSectionPanel.Name = "ReportViewerSectionPanel"
        Me.ReportViewerSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.ReportViewerSectionPanel.ShowCaption = False
        Me.ReportViewerSectionPanel.Size = New System.Drawing.Size(630, 654)
        Me.ReportViewerSectionPanel.TabIndex = 4
        '
        'AbandonButton
        '
        Me.AbandonButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AbandonButton.Enabled = False
        Me.AbandonButton.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.AbandonButton.Location = New System.Drawing.Point(453, 614)
        Me.AbandonButton.Name = "AbandonButton"
        Me.AbandonButton.Size = New System.Drawing.Size(75, 23)
        Me.AbandonButton.TabIndex = 5
        Me.AbandonButton.Text = "Abandon"
        '
        'ApproveButton
        '
        Me.ApproveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApproveButton.Enabled = False
        Me.ApproveButton.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ApproveButton.Location = New System.Drawing.Point(534, 614)
        Me.ApproveButton.Name = "ApproveButton"
        Me.ApproveButton.Size = New System.Drawing.Size(75, 23)
        Me.ApproveButton.TabIndex = 1
        Me.ApproveButton.Text = "Approve"
        '
        'ReportViewerSection
        '
        Me.Controls.Add(Me.ReportViewerSectionPanel)
        Me.Name = "ReportViewerSection"
        Me.Size = New System.Drawing.Size(630, 654)
        Me.ReportViewerSectionPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ViewReportMenuItem As System.Windows.Forms.MenuItem
    Friend WithEvents ReportsContextMenu As System.Windows.Forms.ContextMenu
    Friend WithEvents CrossTabsMenuItem As System.Windows.Forms.MenuItem
    Friend WithEvents ReportWebBrowser As System.Windows.Forms.WebBrowser
    Friend WithEvents PaneCaption As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents ReportViewerSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ApproveButton As System.Windows.Forms.Button
    Friend WithEvents AbandonButton As System.Windows.Forms.Button

End Class
