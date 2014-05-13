<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AdministrationNavigator
    Inherits DataMart.WeightsLoader.Navigator

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
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ManageCategoriesLinkLabel = New System.Windows.Forms.LinkLabel
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(172, 25)
        Me.ToolStrip1.TabIndex = 2
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(151, 22)
        Me.ToolStripLabel1.Text = "Select Administration Function"
        '
        'ManageCategoriesLinkLabel
        '
        Me.ManageCategoriesLinkLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ManageCategoriesLinkLabel.AutoSize = True
        Me.ManageCategoriesLinkLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.ManageCategoriesLinkLabel.Location = New System.Drawing.Point(29, 64)
        Me.ManageCategoriesLinkLabel.Name = "ManageCategoriesLinkLabel"
        Me.ManageCategoriesLinkLabel.Size = New System.Drawing.Size(115, 13)
        Me.ManageCategoriesLinkLabel.TabIndex = 1
        Me.ManageCategoriesLinkLabel.TabStop = True
        Me.ManageCategoriesLinkLabel.Text = "Manage Weight Types"
        Me.ManageCategoriesLinkLabel.TextAlign = System.Drawing.ContentAlignment.TopCenter
        '
        'AdministrationNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.ManageCategoriesLinkLabel)
        Me.Name = "AdministrationNavigator"
        Me.Size = New System.Drawing.Size(172, 305)
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ManageCategoriesLinkLabel As System.Windows.Forms.LinkLabel
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel

End Class
