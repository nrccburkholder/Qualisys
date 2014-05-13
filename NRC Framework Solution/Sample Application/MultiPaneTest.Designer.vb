<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MultiPaneTest
    Inherits System.Windows.Forms.Form

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MultiPaneTest))
        Me.MultiPane1 = New Nrc.Framework.WinForms.MultiPane
        Me.MultiPaneTab1 = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MultiPaneTab2 = New Nrc.Framework.WinForms.MultiPaneTab
        Me.MultiPaneTab3 = New Nrc.Framework.WinForms.MultiPaneTab
        Me.SuspendLayout()
        '
        'MultiPane1
        '
        Me.MultiPane1.Dock = System.Windows.Forms.DockStyle.Left
        Me.MultiPane1.Location = New System.Drawing.Point(0, 0)
        Me.MultiPane1.MaxShownTabs = 2
        Me.MultiPane1.Name = "MultiPane1"
        Me.MultiPane1.Size = New System.Drawing.Size(200, 456)
        Me.MultiPane1.TabIndex = 0
        Me.MultiPane1.Tabs.Add(Me.MultiPaneTab1)
        Me.MultiPane1.Tabs.Add(Me.MultiPaneTab2)
        Me.MultiPane1.Tabs.Add(Me.MultiPaneTab3)
        Me.MultiPane1.Text = "MultiPane1"
        '
        'MultiPaneTab1
        '
        Me.MultiPaneTab1.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MultiPaneTab1.Cursor = System.Windows.Forms.Cursors.Hand
        Me.MultiPaneTab1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.MultiPaneTab1.Icon = CType(resources.GetObject("MultiPaneTab1.Icon"), System.Drawing.Icon)
        Me.MultiPaneTab1.Image = CType(resources.GetObject("MultiPaneTab1.Image"), System.Drawing.Image)
        Me.MultiPaneTab1.IsActive = True
        Me.MultiPaneTab1.Location = New System.Drawing.Point(0, 0)
        Me.MultiPaneTab1.Name = "MultiPaneTab1"
        Me.MultiPaneTab1.NavControlId = Nothing
        Me.MultiPaneTab1.NavControlType = Nothing
        Me.MultiPaneTab1.Padding = New System.Windows.Forms.Padding(4)
        Me.MultiPaneTab1.Size = New System.Drawing.Size(200, 32)
        Me.MultiPaneTab1.TabIndex = 0
        Me.MultiPaneTab1.Text = "MultiPaneTab1"
        '
        'MultiPaneTab2
        '
        Me.MultiPaneTab2.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MultiPaneTab2.Cursor = System.Windows.Forms.Cursors.Hand
        Me.MultiPaneTab2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.MultiPaneTab2.Icon = Nothing
        Me.MultiPaneTab2.Image = Global.Nrc.Framework.SampleApplication.My.Resources.Resources.Caution32
        Me.MultiPaneTab2.IsActive = False
        Me.MultiPaneTab2.Location = New System.Drawing.Point(0, 32)
        Me.MultiPaneTab2.Name = "MultiPaneTab2"
        Me.MultiPaneTab2.NavControlId = Nothing
        Me.MultiPaneTab2.NavControlType = Nothing
        Me.MultiPaneTab2.Padding = New System.Windows.Forms.Padding(3)
        Me.MultiPaneTab2.Size = New System.Drawing.Size(200, 32)
        Me.MultiPaneTab2.TabIndex = 1
        Me.MultiPaneTab2.Text = "MultiPaneTab2"
        '
        'MultiPaneTab3
        '
        Me.MultiPaneTab3.Anchor = System.Windows.Forms.AnchorStyles.Right
        Me.MultiPaneTab3.Cursor = System.Windows.Forms.Cursors.Hand
        Me.MultiPaneTab3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.MultiPaneTab3.Icon = CType(resources.GetObject("MultiPaneTab3.Icon"), System.Drawing.Icon)
        Me.MultiPaneTab3.Image = CType(resources.GetObject("MultiPaneTab3.Image"), System.Drawing.Image)
        Me.MultiPaneTab3.IsActive = False
        Me.MultiPaneTab3.Location = New System.Drawing.Point(160, 1)
        Me.MultiPaneTab3.Name = "MultiPaneTab3"
        Me.MultiPaneTab3.NavControlId = Nothing
        Me.MultiPaneTab3.NavControlType = Nothing
        Me.MultiPaneTab3.Padding = New System.Windows.Forms.Padding(4)
        Me.MultiPaneTab3.Size = New System.Drawing.Size(32, 32)
        Me.MultiPaneTab3.TabIndex = 2
        Me.MultiPaneTab3.Text = "MultiPaneTab3"
        '
        'MultiPaneTest
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(453, 456)
        Me.Controls.Add(Me.MultiPane1)
        Me.Name = "MultiPaneTest"
        Me.Text = "MultiPaneTest"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MultiPane1 As Nrc.Framework.WinForms.MultiPane
    Friend WithEvents MultiPaneTab1 As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents MultiPaneTab2 As Nrc.Framework.WinForms.MultiPaneTab
    Friend WithEvents MultiPaneTab3 As Nrc.Framework.WinForms.MultiPaneTab
End Class
