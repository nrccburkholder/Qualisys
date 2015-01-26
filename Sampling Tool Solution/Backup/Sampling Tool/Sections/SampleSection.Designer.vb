<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SampleSection
    Inherits Qualisys.SamplingTool.Section

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
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.SampleDefinition = New Nrc.Qualisys.SamplingTool.NewSampleDefinition
        Me.ExistingSamples = New Nrc.Qualisys.SamplingTool.ExistingSampleSetViewer
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel1
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.SampleDefinition)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.ExistingSamples)
        Me.SplitContainer1.Size = New System.Drawing.Size(645, 640)
        Me.SplitContainer1.SplitterDistance = 453
        Me.SplitContainer1.TabIndex = 2
        '
        'SampleDefinition
        '
        Me.SampleDefinition.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleDefinition.Location = New System.Drawing.Point(0, 0)
        Me.SampleDefinition.Name = "SampleDefinition"
        Me.SampleDefinition.Size = New System.Drawing.Size(645, 453)
        Me.SampleDefinition.TabIndex = 0
        '
        'ExistingSamples
        '
        Me.ExistingSamples.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ExistingSamples.Location = New System.Drawing.Point(0, 0)
        Me.ExistingSamples.Name = "ExistingSamples"
        Me.ExistingSamples.Size = New System.Drawing.Size(645, 183)
        Me.ExistingSamples.TabIndex = 0
        '
        'SampleSection
        '
        Me.Controls.Add(Me.SplitContainer1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MinimumSize = New System.Drawing.Size(0, 550)
        Me.Name = "SampleSection"
        Me.Size = New System.Drawing.Size(645, 640)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents SampleDefinition As Nrc.Qualisys.SamplingTool.NewSampleDefinition
    Friend WithEvents ExistingSamples As Nrc.Qualisys.SamplingTool.ExistingSampleSetViewer

End Class
