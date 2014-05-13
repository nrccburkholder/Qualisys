<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AdminNotesNavigator
    Inherits DataLoaderAdmin.Navigator

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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(AdminNotesNavigator))
        Me.TreeViewClientStudy = New Nrc.DataLoaderAdmin.MultiSelectTreeView
        Me.imageListTree = New System.Windows.Forms.ImageList(Me.components)
        Me.SuspendLayout()
        '
        'TreeViewClientStudy
        '
        Me.TreeViewClientStudy.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TreeViewClientStudy.Location = New System.Drawing.Point(0, 0)
        Me.TreeViewClientStudy.Name = "TreeViewClientStudy"
        Me.TreeViewClientStudy.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.TreeViewClientStudy.Size = New System.Drawing.Size(224, 570)
        Me.TreeViewClientStudy.TabIndex = 1
        '
        'imageListTree
        '
        Me.imageListTree.ImageStream = CType(resources.GetObject("imageListTree.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imageListTree.TransparentColor = System.Drawing.Color.Transparent
        Me.imageListTree.Images.SetKeyName(0, "NoWay16.png")
        Me.imageListTree.Images.SetKeyName(1, "Check16.png")
        Me.imageListTree.Images.SetKeyName(2, "Study")
        Me.imageListTree.Images.SetKeyName(3, "Client")
        '
        'AdminNotesNavigator
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.TreeViewClientStudy)
        Me.Name = "AdminNotesNavigator"
        Me.Size = New System.Drawing.Size(224, 570)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents TreeViewClientStudy As Nrc.DataLoaderAdmin.MultiSelectTreeView
    Friend WithEvents imageListTree As System.Windows.Forms.ImageList

End Class
