<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VendorMaintenanceNavigator
    Inherits QualiSys_Scanner_Interface.Navigator

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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(VendorMaintenanceNavigator))
        Me.MainToolStrip = New System.Windows.Forms.ToolStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.btnNewVendor = New System.Windows.Forms.ToolStripButton
        Me.VendorTreeView = New System.Windows.Forms.TreeView
        Me.VendorTreeImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.MainToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainToolStrip
        '
        Me.MainToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.MainToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.btnNewVendor})
        Me.MainToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.MainToolStrip.Name = "MainToolStrip"
        Me.MainToolStrip.Size = New System.Drawing.Size(167, 25)
        Me.MainToolStrip.TabIndex = 1
        Me.MainToolStrip.Text = "ToolStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(73, 22)
        Me.ToolStripLabel1.Text = "Select Vendor"
        '
        'btnNewVendor
        '
        Me.btnNewVendor.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.btnNewVendor.Image = CType(resources.GetObject("btnNewVendor.Image"), System.Drawing.Image)
        Me.btnNewVendor.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnNewVendor.Name = "btnNewVendor"
        Me.btnNewVendor.Size = New System.Drawing.Size(48, 22)
        Me.btnNewVendor.Text = "&New"
        Me.btnNewVendor.ToolTipText = "Add New Vendor"
        '
        'VendorTreeView
        '
        Me.VendorTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorTreeView.ImageIndex = 0
        Me.VendorTreeView.ImageList = Me.VendorTreeImageList
        Me.VendorTreeView.Location = New System.Drawing.Point(0, 25)
        Me.VendorTreeView.Name = "VendorTreeView"
        Me.VendorTreeView.SelectedImageIndex = 0
        Me.VendorTreeView.Size = New System.Drawing.Size(167, 326)
        Me.VendorTreeView.TabIndex = 2
        '
        'VendorTreeImageList
        '
        Me.VendorTreeImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.VendorTreeImageList.ImageSize = New System.Drawing.Size(16, 16)
        Me.VendorTreeImageList.TransparentColor = System.Drawing.Color.Transparent
        '
        'VendorMaintenanceNavigator
        '
        Me.Controls.Add(Me.VendorTreeView)
        Me.Controls.Add(Me.MainToolStrip)
        Me.Name = "VendorMaintenanceNavigator"
        Me.Size = New System.Drawing.Size(167, 351)
        Me.MainToolStrip.ResumeLayout(False)
        Me.MainToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MainToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents VendorTreeView As System.Windows.Forms.TreeView
    Friend WithEvents VendorTreeImageList As System.Windows.Forms.ImageList
    Friend WithEvents btnNewVendor As System.Windows.Forms.ToolStripButton

End Class
