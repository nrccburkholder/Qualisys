<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OUHEditor
    Inherits System.Windows.Forms.UserControl

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
        Me.FlowLayoutPanel1 = New System.Windows.Forms.FlowLayoutPanel()
        Me.OUHSelectorGroup = New System.Windows.Forms.GroupBox()
        Me.DatabaseLabel = New System.Windows.Forms.Label()
        Me.ClientLabel = New System.Windows.Forms.Label()
        Me.CategoryLabel = New System.Windows.Forms.Label()
        Me.OUHLabel = New System.Windows.Forms.Label()
        Me.DatabaseSelector = New System.Windows.Forms.ComboBox()
        Me.ClientFilter = New System.Windows.Forms.ComboBox()
        Me.CategoryFilter = New System.Windows.Forms.ComboBox()
        Me.OUHSelector = New System.Windows.Forms.ComboBox()
        Me.OUSelectorGroup = New System.Windows.Forms.GroupBox()
        Me.CheckAllBox = New System.Windows.Forms.CheckBox()
        Me.OUSelector = New System.Windows.Forms.TreeView()
        Me.FlowLayoutPanel1.SuspendLayout()
        Me.OUHSelectorGroup.SuspendLayout()
        Me.OUSelectorGroup.SuspendLayout()
        Me.SuspendLayout()
        '
        'FlowLayoutPanel1
        '
        Me.FlowLayoutPanel1.AutoSize = True
        Me.FlowLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.FlowLayoutPanel1.Controls.Add(Me.OUHSelectorGroup)
        Me.FlowLayoutPanel1.Controls.Add(Me.OUSelectorGroup)
        Me.FlowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FlowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown
        Me.FlowLayoutPanel1.Location = New System.Drawing.Point(0, 0)
        Me.FlowLayoutPanel1.Name = "FlowLayoutPanel1"
        Me.FlowLayoutPanel1.Size = New System.Drawing.Size(439, 604)
        Me.FlowLayoutPanel1.TabIndex = 0
        '
        'OUHSelectorGroup
        '
        Me.OUHSelectorGroup.AutoSize = True
        Me.OUHSelectorGroup.Controls.Add(Me.DatabaseLabel)
        Me.OUHSelectorGroup.Controls.Add(Me.ClientLabel)
        Me.OUHSelectorGroup.Controls.Add(Me.CategoryLabel)
        Me.OUHSelectorGroup.Controls.Add(Me.OUHLabel)
        Me.OUHSelectorGroup.Controls.Add(Me.DatabaseSelector)
        Me.OUHSelectorGroup.Controls.Add(Me.ClientFilter)
        Me.OUHSelectorGroup.Controls.Add(Me.CategoryFilter)
        Me.OUHSelectorGroup.Controls.Add(Me.OUHSelector)
        Me.OUHSelectorGroup.Location = New System.Drawing.Point(3, 3)
        Me.OUHSelectorGroup.Name = "OUHSelectorGroup"
        Me.OUHSelectorGroup.Size = New System.Drawing.Size(431, 153)
        Me.OUHSelectorGroup.TabIndex = 1
        Me.OUHSelectorGroup.TabStop = False
        Me.OUHSelectorGroup.Text = "Org Unit Hierarchy"
        '
        'DatabaseLabel
        '
        Me.DatabaseLabel.AutoSize = True
        Me.DatabaseLabel.Location = New System.Drawing.Point(6, 29)
        Me.DatabaseLabel.Name = "DatabaseLabel"
        Me.DatabaseLabel.Size = New System.Drawing.Size(86, 13)
        Me.DatabaseLabel.TabIndex = 7
        Me.DatabaseLabel.Text = "Select Database"
        '
        'ClientLabel
        '
        Me.ClientLabel.AutoSize = True
        Me.ClientLabel.Location = New System.Drawing.Point(6, 58)
        Me.ClientLabel.Name = "ClientLabel"
        Me.ClientLabel.Size = New System.Drawing.Size(73, 13)
        Me.ClientLabel.TabIndex = 2
        Me.ClientLabel.Text = "Filter By Client"
        '
        'CategoryLabel
        '
        Me.CategoryLabel.AutoSize = True
        Me.CategoryLabel.Location = New System.Drawing.Point(6, 88)
        Me.CategoryLabel.Name = "CategoryLabel"
        Me.CategoryLabel.Size = New System.Drawing.Size(89, 13)
        Me.CategoryLabel.TabIndex = 4
        Me.CategoryLabel.Text = "Filter By Category"
        '
        'OUHLabel
        '
        Me.OUHLabel.AutoSize = True
        Me.OUHLabel.Location = New System.Drawing.Point(6, 118)
        Me.OUHLabel.Name = "OUHLabel"
        Me.OUHLabel.Size = New System.Drawing.Size(79, 13)
        Me.OUHLabel.TabIndex = 3
        Me.OUHLabel.Text = "Select an OUH"
        '
        'DatabaseSelector
        '
        Me.DatabaseSelector.FormattingEnabled = True
        Me.DatabaseSelector.Location = New System.Drawing.Point(100, 24)
        Me.DatabaseSelector.Name = "DatabaseSelector"
        Me.DatabaseSelector.Size = New System.Drawing.Size(325, 21)
        Me.DatabaseSelector.TabIndex = 6
        '
        'ClientFilter
        '
        Me.ClientFilter.FormattingEnabled = True
        Me.ClientFilter.Location = New System.Drawing.Point(100, 53)
        Me.ClientFilter.Name = "ClientFilter"
        Me.ClientFilter.Size = New System.Drawing.Size(325, 21)
        Me.ClientFilter.TabIndex = 1
        '
        'CategoryFilter
        '
        Me.CategoryFilter.FormattingEnabled = True
        Me.CategoryFilter.Location = New System.Drawing.Point(100, 83)
        Me.CategoryFilter.Name = "CategoryFilter"
        Me.CategoryFilter.Size = New System.Drawing.Size(325, 21)
        Me.CategoryFilter.TabIndex = 5
        '
        'OUHSelector
        '
        Me.OUHSelector.FormattingEnabled = True
        Me.OUHSelector.Location = New System.Drawing.Point(100, 113)
        Me.OUHSelector.Name = "OUHSelector"
        Me.OUHSelector.Size = New System.Drawing.Size(325, 21)
        Me.OUHSelector.TabIndex = 0
        '
        'OUSelectorGroup
        '
        Me.OUSelectorGroup.AutoSize = True
        Me.OUSelectorGroup.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.OUSelectorGroup.Controls.Add(Me.CheckAllBox)
        Me.OUSelectorGroup.Controls.Add(Me.OUSelector)
        Me.OUSelectorGroup.Location = New System.Drawing.Point(3, 162)
        Me.OUSelectorGroup.Name = "OUSelectorGroup"
        Me.OUSelectorGroup.Size = New System.Drawing.Size(433, 439)
        Me.OUSelectorGroup.TabIndex = 1
        Me.OUSelectorGroup.TabStop = False
        Me.OUSelectorGroup.Text = "Org Units"
        '
        'CheckAllBox
        '
        Me.CheckAllBox.AutoSize = True
        Me.CheckAllBox.Location = New System.Drawing.Point(10, 19)
        Me.CheckAllBox.Name = "CheckAllBox"
        Me.CheckAllBox.Size = New System.Drawing.Size(120, 17)
        Me.CheckAllBox.TabIndex = 3
        Me.CheckAllBox.Text = "Check/Uncheck All"
        Me.CheckAllBox.UseVisualStyleBackColor = True
        '
        'OUSelector
        '
        Me.OUSelector.CheckBoxes = True
        Me.OUSelector.Location = New System.Drawing.Point(6, 40)
        Me.OUSelector.MinimumSize = New System.Drawing.Size(300, 200)
        Me.OUSelector.Name = "OUSelector"
        Me.OUSelector.Size = New System.Drawing.Size(421, 380)
        Me.OUSelector.TabIndex = 2
        '
        'OUHEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Controls.Add(Me.FlowLayoutPanel1)
        Me.Name = "OUHEditor"
        Me.Size = New System.Drawing.Size(439, 604)
        Me.FlowLayoutPanel1.ResumeLayout(False)
        Me.FlowLayoutPanel1.PerformLayout()
        Me.OUHSelectorGroup.ResumeLayout(False)
        Me.OUHSelectorGroup.PerformLayout()
        Me.OUSelectorGroup.ResumeLayout(False)
        Me.OUSelectorGroup.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents FlowLayoutPanel1 As System.Windows.Forms.FlowLayoutPanel
    Friend WithEvents OUHSelectorGroup As System.Windows.Forms.GroupBox
    Friend WithEvents OUHSelector As System.Windows.Forms.ComboBox
    Friend WithEvents OUSelectorGroup As System.Windows.Forms.GroupBox
    Friend WithEvents OUSelector As System.Windows.Forms.TreeView
    Friend WithEvents ClientFilter As System.Windows.Forms.ComboBox
    Friend WithEvents OUHLabel As System.Windows.Forms.Label
    Friend WithEvents ClientLabel As System.Windows.Forms.Label
    Friend WithEvents CategoryFilter As System.Windows.Forms.ComboBox
    Friend WithEvents CategoryLabel As System.Windows.Forms.Label
    Friend WithEvents CheckAllBox As System.Windows.Forms.CheckBox
    Friend WithEvents DatabaseSelector As System.Windows.Forms.ComboBox
    Private WithEvents DatabaseLabel As System.Windows.Forms.Label

End Class
