<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class TransferResultsVendorSection
    Inherits QualiSys_Scanner_Interface.Section

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
        Me.VendorSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.VendorNotImplementedLabel = New System.Windows.Forms.Label
        Me.VendorSectionPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'VendorSectionPanel
        '
        Me.VendorSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.VendorSectionPanel.Caption = "Vendor Information"
        Me.VendorSectionPanel.Controls.Add(Me.VendorNotImplementedLabel)
        Me.VendorSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.VendorSectionPanel.Name = "VendorSectionPanel"
        Me.VendorSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.VendorSectionPanel.ShowCaption = True
        Me.VendorSectionPanel.Size = New System.Drawing.Size(532, 454)
        Me.VendorSectionPanel.TabIndex = 0
        '
        'VendorNotImplementedLabel
        '
        Me.VendorNotImplementedLabel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorNotImplementedLabel.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.VendorNotImplementedLabel.Location = New System.Drawing.Point(1, 1)
        Me.VendorNotImplementedLabel.Name = "VendorNotImplementedLabel"
        Me.VendorNotImplementedLabel.Size = New System.Drawing.Size(530, 452)
        Me.VendorNotImplementedLabel.TabIndex = 1
        Me.VendorNotImplementedLabel.Text = "Not Yet Implemented"
        Me.VendorNotImplementedLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'TransferResultsVendorSection
        '
        Me.Controls.Add(Me.VendorSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "TransferResultsVendorSection"
        Me.Size = New System.Drawing.Size(532, 454)
        Me.VendorSectionPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents VendorSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents VendorNotImplementedLabel As System.Windows.Forms.Label

End Class
