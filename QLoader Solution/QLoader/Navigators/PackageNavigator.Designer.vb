<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PackageNavigator
    Inherits QLoader.Navigator

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
        Me.tlpNavigator = New System.Windows.Forms.TableLayoutPanel
        Me.tsPackageFilter = New System.Windows.Forms.ToolStrip
        Me.cboPackageFilter = New System.Windows.Forms.ToolStripComboBox
        Me.tlpNavigator.SuspendLayout()
        Me.tsPackageFilter.SuspendLayout()
        Me.SuspendLayout()
        '
        'tlpNavigator
        '
        Me.tlpNavigator.ColumnCount = 1
        Me.tlpNavigator.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.tlpNavigator.Controls.Add(Me.tsPackageFilter, 0, 0)
        Me.tlpNavigator.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tlpNavigator.Location = New System.Drawing.Point(0, 0)
        Me.tlpNavigator.Name = "tlpNavigator"
        Me.tlpNavigator.RowCount = 2
        Me.tlpNavigator.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22.0!))
        Me.tlpNavigator.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.tlpNavigator.Size = New System.Drawing.Size(150, 356)
        Me.tlpNavigator.TabIndex = 0
        '
        'tsPackageFilter
        '
        Me.tsPackageFilter.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tsPackageFilter.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.tsPackageFilter.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.cboPackageFilter})
        Me.tsPackageFilter.Location = New System.Drawing.Point(0, 0)
        Me.tsPackageFilter.Name = "tsPackageFilter"
        Me.tsPackageFilter.Size = New System.Drawing.Size(150, 22)
        Me.tsPackageFilter.TabIndex = 1
        Me.tsPackageFilter.Text = "ToolStrip1"
        '
        'cboPackageFilter
        '
        Me.cboPackageFilter.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.cboPackageFilter.Items.AddRange(New Object() {"Active", "Inactive", "Active\Inactive"})
        Me.cboPackageFilter.Name = "cboPackageFilter"
        Me.cboPackageFilter.Size = New System.Drawing.Size(121, 22)
        '
        'PackageNavigator
        '
        Me.Controls.Add(Me.tlpNavigator)
        Me.Name = "PackageNavigator"
        Me.Size = New System.Drawing.Size(150, 356)
        Me.tlpNavigator.ResumeLayout(False)
        Me.tlpNavigator.PerformLayout()
        Me.tsPackageFilter.ResumeLayout(False)
        Me.tsPackageFilter.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents tlpNavigator As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents tsPackageFilter As System.Windows.Forms.ToolStrip
    Friend WithEvents cboPackageFilter As System.Windows.Forms.ToolStripComboBox

End Class
