<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FolderSection
    Inherits Section

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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FolderSection))
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.PathLabel = New System.Windows.Forms.Label
        Me.CreationDateLabel = New System.Windows.Forms.Label
        Me.FileCountLabel = New System.Windows.Forms.Label
        Me.ContentsListView = New System.Windows.Forms.ListView
        Me.FolderImages = New System.Windows.Forms.ImageList(Me.components)
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.FolderCountLabel = New System.Windows.Forms.Label
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Folder Details"
        Me.SectionPanel1.Controls.Add(Me.PathLabel)
        Me.SectionPanel1.Controls.Add(Me.CreationDateLabel)
        Me.SectionPanel1.Controls.Add(Me.FolderCountLabel)
        Me.SectionPanel1.Controls.Add(Me.FileCountLabel)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(433, 106)
        Me.SectionPanel1.TabIndex = 0
        '
        'PathLabel
        '
        Me.PathLabel.AutoSize = True
        Me.PathLabel.Location = New System.Drawing.Point(4, 32)
        Me.PathLabel.Name = "PathLabel"
        Me.PathLabel.Size = New System.Drawing.Size(51, 13)
        Me.PathLabel.TabIndex = 3
        Me.PathLabel.Text = "Full Path:"
        '
        'CreationDateLabel
        '
        Me.CreationDateLabel.AutoSize = True
        Me.CreationDateLabel.Location = New System.Drawing.Point(4, 50)
        Me.CreationDateLabel.Name = "CreationDateLabel"
        Me.CreationDateLabel.Size = New System.Drawing.Size(75, 13)
        Me.CreationDateLabel.TabIndex = 3
        Me.CreationDateLabel.Text = "Creation Date:"
        '
        'FileCountLabel
        '
        Me.FileCountLabel.AutoSize = True
        Me.FileCountLabel.Location = New System.Drawing.Point(4, 85)
        Me.FileCountLabel.Name = "FileCountLabel"
        Me.FileCountLabel.Size = New System.Drawing.Size(57, 13)
        Me.FileCountLabel.TabIndex = 3
        Me.FileCountLabel.Text = "File Count:"
        '
        'ContentsListView
        '
        Me.ContentsListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ContentsListView.LargeImageList = Me.FolderImages
        Me.ContentsListView.Location = New System.Drawing.Point(4, 31)
        Me.ContentsListView.Name = "ContentsListView"
        Me.ContentsListView.Size = New System.Drawing.Size(425, 212)
        Me.ContentsListView.SmallImageList = Me.FolderImages
        Me.ContentsListView.TabIndex = 1
        Me.ContentsListView.UseCompatibleStateImageBehavior = False
        Me.ContentsListView.View = System.Windows.Forms.View.List
        '
        'FolderImages
        '
        Me.FolderImages.ImageStream = CType(resources.GetObject("FolderImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.FolderImages.TransparentColor = System.Drawing.Color.Transparent
        Me.FolderImages.Images.SetKeyName(0, "File")
        Me.FolderImages.Images.SetKeyName(1, "Folder")
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel2.Caption = "Folder Contents"
        Me.SectionPanel2.Controls.Add(Me.ContentsListView)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(433, 247)
        Me.SectionPanel2.TabIndex = 1
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
        Me.SplitContainer1.Panel1.Controls.Add(Me.SectionPanel1)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.SectionPanel2)
        Me.SplitContainer1.Size = New System.Drawing.Size(433, 357)
        Me.SplitContainer1.SplitterDistance = 106
        Me.SplitContainer1.TabIndex = 2
        '
        'FolderCountLabel
        '
        Me.FolderCountLabel.AutoSize = True
        Me.FolderCountLabel.Location = New System.Drawing.Point(4, 68)
        Me.FolderCountLabel.Name = "FolderCountLabel"
        Me.FolderCountLabel.Size = New System.Drawing.Size(70, 13)
        Me.FolderCountLabel.TabIndex = 3
        Me.FolderCountLabel.Text = "Folder Count:"
        '
        'FolderSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitContainer1)
        Me.Name = "FolderSection"
        Me.Size = New System.Drawing.Size(433, 357)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        Me.SectionPanel2.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ContentsListView As System.Windows.Forms.ListView
    Friend WithEvents FolderImages As System.Windows.Forms.ImageList
    Friend WithEvents PathLabel As System.Windows.Forms.Label
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents CreationDateLabel As System.Windows.Forms.Label
    Friend WithEvents FileCountLabel As System.Windows.Forms.Label
    Friend WithEvents FolderCountLabel As System.Windows.Forms.Label

End Class
