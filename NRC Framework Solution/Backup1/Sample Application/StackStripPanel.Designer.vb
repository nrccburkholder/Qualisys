<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StackStripPanel
    Inherits System.Windows.Forms.UserControl

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(StackStripPanel))
        Me.StackStripSplitter = New System.Windows.Forms.SplitContainer
        Me.ControlPanel = New System.Windows.Forms.Panel
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.TitleLabel = New System.Windows.Forms.ToolStripLabel
        Me.StackStrip1 = New Nrc.Framework.SampleApplication.WinForms.StackStrip
        Me.OverFlowStrip = New Nrc.Framework.SampleApplication.WinForms.BaseStackStrip
        Me.OverflowDropDown = New System.Windows.Forms.ToolStripDropDownButton
        Me.ShowMoreButtonsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ShowFewerButtonsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StackStripSplitter.Panel1.SuspendLayout()
        Me.StackStripSplitter.Panel2.SuspendLayout()
        Me.StackStripSplitter.SuspendLayout()
        Me.HeaderStrip1.SuspendLayout()
        Me.OverFlowStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'StackStripSplitter
        '
        Me.StackStripSplitter.Dock = System.Windows.Forms.DockStyle.Fill
        Me.StackStripSplitter.Location = New System.Drawing.Point(0, 0)
        Me.StackStripSplitter.Name = "StackStripSplitter"
        Me.StackStripSplitter.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'StackStripSplitter.Panel1
        '
        Me.StackStripSplitter.Panel1.Controls.Add(Me.ControlPanel)
        Me.StackStripSplitter.Panel1.Controls.Add(Me.HeaderStrip1)
        '
        'StackStripSplitter.Panel2
        '
        Me.StackStripSplitter.Panel2.Controls.Add(Me.StackStrip1)
        Me.StackStripSplitter.Panel2.Controls.Add(Me.OverFlowStrip)
        Me.StackStripSplitter.Size = New System.Drawing.Size(240, 363)
        Me.StackStripSplitter.SplitterDistance = 195
        Me.StackStripSplitter.SplitterWidth = 7
        Me.StackStripSplitter.TabIndex = 6
        '
        'ControlPanel
        '
        Me.ControlPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ControlPanel.Location = New System.Drawing.Point(0, 25)
        Me.ControlPanel.Name = "ControlPanel"
        Me.ControlPanel.Size = New System.Drawing.Size(240, 170)
        Me.ControlPanel.TabIndex = 1
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TitleLabel})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(240, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'TitleLabel
        '
        Me.TitleLabel.Name = "TitleLabel"
        Me.TitleLabel.Size = New System.Drawing.Size(144, 22)
        Me.TitleLabel.Text = " StackStripPanel"
        '
        'StackStrip1
        '
        Me.StackStrip1.AutoSize = False
        Me.StackStrip1.CanOverflow = False
        Me.StackStrip1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.StackStrip1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.StackStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.StackStrip1.ImageScalingSize = New System.Drawing.Size(24, 24)
        Me.StackStrip1.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.VerticalStackWithOverflow
        Me.StackStrip1.Location = New System.Drawing.Point(0, 0)
        Me.StackStrip1.Name = "StackStrip1"
        Me.StackStrip1.Size = New System.Drawing.Size(240, 129)
        Me.StackStrip1.TabIndex = 8
        Me.StackStrip1.Text = "StackStrip1"
        '
        'OverFlowStrip
        '
        Me.OverFlowStrip.AutoSize = False
        Me.OverFlowStrip.CanOverflow = False
        Me.OverFlowStrip.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.OverFlowStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.OverFlowStrip.ImageScalingSize = New System.Drawing.Size(20, 20)
        Me.OverFlowStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OverflowDropDown})
        Me.OverFlowStrip.Location = New System.Drawing.Point(0, 129)
        Me.OverFlowStrip.Name = "OverFlowStrip"
        Me.OverFlowStrip.Size = New System.Drawing.Size(240, 32)
        Me.OverFlowStrip.TabIndex = 7
        Me.OverFlowStrip.Text = "overflowStrip"
        '
        'OverflowDropDown
        '
        Me.OverflowDropDown.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.OverflowDropDown.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.None
        Me.OverflowDropDown.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ShowMoreButtonsToolStripMenuItem, Me.ShowFewerButtonsToolStripMenuItem})
        Me.OverflowDropDown.Image = CType(resources.GetObject("OverflowDropDown.Image"), System.Drawing.Image)
        Me.OverflowDropDown.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OverflowDropDown.Margin = New System.Windows.Forms.Padding(0)
        Me.OverflowDropDown.Name = "OverflowDropDown"
        Me.OverflowDropDown.Padding = New System.Windows.Forms.Padding(3)
        Me.OverflowDropDown.Size = New System.Drawing.Size(19, 32)
        Me.OverflowDropDown.Text = "ToolStripDropDownButton1"
        '
        'ShowMoreButtonsToolStripMenuItem
        '
        Me.ShowMoreButtonsToolStripMenuItem.Name = "ShowMoreButtonsToolStripMenuItem"
        Me.ShowMoreButtonsToolStripMenuItem.Size = New System.Drawing.Size(173, 22)
        Me.ShowMoreButtonsToolStripMenuItem.Text = "Show More Buttons"
        '
        'ShowFewerButtonsToolStripMenuItem
        '
        Me.ShowFewerButtonsToolStripMenuItem.Name = "ShowFewerButtonsToolStripMenuItem"
        Me.ShowFewerButtonsToolStripMenuItem.Size = New System.Drawing.Size(173, 22)
        Me.ShowFewerButtonsToolStripMenuItem.Text = "Show Fewer Buttons"
        '
        'StackStripPanel
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.StackStripSplitter)
        Me.Name = "StackStripPanel"
        Me.Size = New System.Drawing.Size(240, 363)
        Me.StackStripSplitter.Panel1.ResumeLayout(False)
        Me.StackStripSplitter.Panel2.ResumeLayout(False)
        Me.StackStripSplitter.ResumeLayout(False)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.OverFlowStrip.ResumeLayout(False)
        Me.OverFlowStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents StackStripSplitter As System.Windows.Forms.SplitContainer
    Private WithEvents OverflowDropDown As System.Windows.Forms.ToolStripDropDownButton
    Private WithEvents OverFlowStrip As Nrc.Framework.SampleApplication.WinForms.BaseStackStrip
    Friend WithEvents StackStrip1 As Nrc.Framework.SampleApplication.WinForms.StackStrip
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents TitleLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ControlPanel As System.Windows.Forms.Panel
    Friend WithEvents ShowMoreButtonsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ShowFewerButtonsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
