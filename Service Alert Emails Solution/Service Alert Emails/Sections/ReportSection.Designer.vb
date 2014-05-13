<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportSection
    Inherits Service_Alert_Emails.Section

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
        Me.Label1 = New System.Windows.Forms.Label
        Me.WebAddress = New System.Windows.Forms.TextBox
        Me.WebBrowser = New System.Windows.Forms.WebBrowser
        Me.GoButton = New System.Windows.Forms.Button
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(1, 35)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(45, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Address"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'WebAddress
        '
        Me.WebAddress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebAddress.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append
        Me.WebAddress.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.AllUrl
        Me.WebAddress.Location = New System.Drawing.Point(52, 32)
        Me.WebAddress.Name = "WebAddress"
        Me.WebAddress.Size = New System.Drawing.Size(402, 20)
        Me.WebAddress.TabIndex = 1
        Me.WebAddress.Text = "http://www.google.com"
        '
        'WebBrowser
        '
        Me.WebBrowser.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebBrowser.Location = New System.Drawing.Point(4, 58)
        Me.WebBrowser.MinimumSize = New System.Drawing.Size(20, 20)
        Me.WebBrowser.Name = "WebBrowser"
        Me.WebBrowser.Size = New System.Drawing.Size(475, 276)
        Me.WebBrowser.TabIndex = 2
        '
        'GoButton
        '
        Me.GoButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GoButton.Image = Global.Nrc.Service_Alert_Emails.My.Resources.Resources.GoLtr
        Me.GoButton.Location = New System.Drawing.Point(460, 32)
        Me.GoButton.Name = "GoButton"
        Me.GoButton.Size = New System.Drawing.Size(19, 20)
        Me.GoButton.TabIndex = 3
        Me.GoButton.UseVisualStyleBackColor = True
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Reports"
        Me.SectionPanel1.Controls.Add(Me.WebBrowser)
        Me.SectionPanel1.Controls.Add(Me.GoButton)
        Me.SectionPanel1.Controls.Add(Me.Label1)
        Me.SectionPanel1.Controls.Add(Me.WebAddress)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(483, 338)
        Me.SectionPanel1.TabIndex = 4
        '
        'ReportSection
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ReportSection"
        Me.Size = New System.Drawing.Size(483, 338)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents WebAddress As System.Windows.Forms.TextBox
    Friend WithEvents WebBrowser As System.Windows.Forms.WebBrowser
    Friend WithEvents GoButton As System.Windows.Forms.Button
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel

End Class
