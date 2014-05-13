<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ClientStudySurveyNavigator
    Inherits Qualisys.SamplingTool.Navigator

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ClientStudySurveyNavigator))
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.RefreshButton = New System.Windows.Forms.ToolStripButton
        Me.SurveyTree = New Nrc.Qualisys.SamplingTool.MultiSelectTreeView
        Me.ClientStudySurveyNavigatorImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.HeaderStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.Black
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Small
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1, Me.RefreshButton})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(187, 19)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(81, 16)
        Me.ToolStripLabel1.Text = "Select surveys."
        '
        'RefreshButton
        '
        Me.RefreshButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.RefreshButton.Image = Global.Nrc.Qualisys.SamplingTool.My.Resources.Resources.Refresh32
        Me.RefreshButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.RefreshButton.Name = "RefreshButton"
        Me.RefreshButton.Size = New System.Drawing.Size(65, 16)
        Me.RefreshButton.Text = "Refresh"
        Me.RefreshButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextBeforeImage
        Me.RefreshButton.ToolTipText = "Refresh"
        '
        'SurveyTree
        '
        Me.SurveyTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SurveyTree.HideSelection = False
        Me.SurveyTree.ImageIndex = 0
        Me.SurveyTree.ImageList = Me.ClientStudySurveyNavigatorImageList
        Me.SurveyTree.Location = New System.Drawing.Point(0, 19)
        Me.SurveyTree.Name = "SurveyTree"
        Me.SurveyTree.SelectedImageIndex = 1
        Me.SurveyTree.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.SurveyTree.Size = New System.Drawing.Size(187, 329)
        Me.SurveyTree.TabIndex = 1
        '
        'ClientStudySurveyNavigatorImageList
        '
        Me.ClientStudySurveyNavigatorImageList.ImageStream = CType(resources.GetObject("ClientStudySurveyNavigatorImageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ClientStudySurveyNavigatorImageList.TransparentColor = System.Drawing.Color.Empty
        Me.ClientStudySurveyNavigatorImageList.Images.SetKeyName(0, "NoWay.png")
        Me.ClientStudySurveyNavigatorImageList.Images.SetKeyName(1, "Check16.png")
        Me.ClientStudySurveyNavigatorImageList.Images.SetKeyName(2, "Document16.png")
        Me.ClientStudySurveyNavigatorImageList.Images.SetKeyName(3, "Member32.png")
        '
        'ClientStudySurveyNavigator
        '
        Me.Controls.Add(Me.SurveyTree)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "ClientStudySurveyNavigator"
        Me.Size = New System.Drawing.Size(187, 348)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents SurveyTree As MultiSelectTreeView
    Protected WithEvents ClientStudySurveyNavigatorImageList As System.Windows.Forms.ImageList
    Friend WithEvents RefreshButton As System.Windows.Forms.ToolStripButton

End Class
