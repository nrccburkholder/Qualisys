<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AdministrationSection
    Inherits DataMart.WeightsLoader.Section

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
        Me.MainPanel = New NRC.Framework.WinForms.SectionPanel
        Me.AdminPanel = New System.Windows.Forms.Panel
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainPanel
        '
        Me.MainPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainPanel.Caption = ""
        Me.MainPanel.Controls.Add(Me.AdminPanel)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainPanel.ShowCaption = True
        Me.MainPanel.Size = New System.Drawing.Size(382, 366)
        Me.MainPanel.TabIndex = 0
        '
        'AdminPanel
        '
        Me.AdminPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AdminPanel.Location = New System.Drawing.Point(1, 27)
        Me.AdminPanel.Name = "AdminPanel"
        Me.AdminPanel.Size = New System.Drawing.Size(380, 338)
        Me.AdminPanel.TabIndex = 1
        '
        'AdministrationSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.MainPanel)
        Me.Name = "AdministrationSection"
        Me.Size = New System.Drawing.Size(382, 366)
        Me.MainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MainPanel As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents AdminPanel As System.Windows.Forms.Panel

End Class
