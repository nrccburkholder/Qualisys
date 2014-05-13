<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FacilitySection
    Inherits Qualisys.ConfigurationManager.Section

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(FacilitySection))
        Me.MainPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.FacilitySplitContainer = New System.Windows.Forms.SplitContainer
        Me.AllFacilityTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.AddRemovePanel = New System.Windows.Forms.Panel
        Me.RemoveClientFacilityButton = New System.Windows.Forms.Button
        Me.AddClientFacilityButton = New System.Windows.Forms.Button
        Me.AvailableFieldsPanel = New System.Windows.Forms.Panel
        Me.AllFacilityGrid = New Nrc.Qualisys.ConfigurationManager.FacilityGrid
        Me.AllFacilityToolStrip = New System.Windows.Forms.ToolStrip
        Me.AllFacilityCaptionTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.AllFacilityDeleteTSButton = New System.Windows.Forms.ToolStripButton
        Me.AllFacilityTSSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.ClientFacilityPanel = New System.Windows.Forms.Panel
        Me.ClientFacilityGrid = New Nrc.Qualisys.ConfigurationManager.FacilityGrid
        Me.ClientFacilityToolStrip = New System.Windows.Forms.ToolStrip
        Me.ClientFacilityCaptionTSLabel = New System.Windows.Forms.ToolStripLabel
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.ButtonPanel = New System.Windows.Forms.Panel
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.ApplyButton = New System.Windows.Forms.Button
        Me.MainPanel.SuspendLayout()
        Me.FacilitySplitContainer.Panel1.SuspendLayout()
        Me.FacilitySplitContainer.Panel2.SuspendLayout()
        Me.FacilitySplitContainer.SuspendLayout()
        Me.AllFacilityTableLayoutPanel.SuspendLayout()
        Me.AddRemovePanel.SuspendLayout()
        Me.AvailableFieldsPanel.SuspendLayout()
        Me.AllFacilityToolStrip.SuspendLayout()
        Me.ClientFacilityPanel.SuspendLayout()
        Me.ClientFacilityToolStrip.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.ButtonPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MainPanel
        '
        Me.MainPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MainPanel.Caption = "Facility Administration"
        Me.MainPanel.Controls.Add(Me.FacilitySplitContainer)
        Me.MainPanel.Controls.Add(Me.BottomPanel)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MainPanel.ShowCaption = True
        Me.MainPanel.Size = New System.Drawing.Size(800, 380)
        Me.MainPanel.TabIndex = 3
        '
        'FacilitySplitContainer
        '
        Me.FacilitySplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FacilitySplitContainer.Location = New System.Drawing.Point(1, 27)
        Me.FacilitySplitContainer.Name = "FacilitySplitContainer"
        '
        'FacilitySplitContainer.Panel1
        '
        Me.FacilitySplitContainer.Panel1.Controls.Add(Me.AllFacilityTableLayoutPanel)
        Me.FacilitySplitContainer.Panel1.Controls.Add(Me.AllFacilityToolStrip)
        '
        'FacilitySplitContainer.Panel2
        '
        Me.FacilitySplitContainer.Panel2.Controls.Add(Me.ClientFacilityPanel)
        Me.FacilitySplitContainer.Panel2.Controls.Add(Me.ClientFacilityToolStrip)
        Me.FacilitySplitContainer.Size = New System.Drawing.Size(798, 317)
        Me.FacilitySplitContainer.SplitterDistance = 435
        Me.FacilitySplitContainer.TabIndex = 8
        '
        'AllFacilityTableLayoutPanel
        '
        Me.AllFacilityTableLayoutPanel.ColumnCount = 2
        Me.AllFacilityTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.AllFacilityTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 62.0!))
        Me.AllFacilityTableLayoutPanel.Controls.Add(Me.AddRemovePanel, 1, 0)
        Me.AllFacilityTableLayoutPanel.Controls.Add(Me.AvailableFieldsPanel, 0, 0)
        Me.AllFacilityTableLayoutPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AllFacilityTableLayoutPanel.Location = New System.Drawing.Point(0, 25)
        Me.AllFacilityTableLayoutPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.AllFacilityTableLayoutPanel.Name = "AllFacilityTableLayoutPanel"
        Me.AllFacilityTableLayoutPanel.RowCount = 1
        Me.AllFacilityTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.AllFacilityTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.AllFacilityTableLayoutPanel.Size = New System.Drawing.Size(435, 292)
        Me.AllFacilityTableLayoutPanel.TabIndex = 8
        '
        'AddRemovePanel
        '
        Me.AddRemovePanel.Controls.Add(Me.RemoveClientFacilityButton)
        Me.AddRemovePanel.Controls.Add(Me.AddClientFacilityButton)
        Me.AddRemovePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AddRemovePanel.Location = New System.Drawing.Point(376, 3)
        Me.AddRemovePanel.Name = "AddRemovePanel"
        Me.AddRemovePanel.Size = New System.Drawing.Size(56, 286)
        Me.AddRemovePanel.TabIndex = 0
        '
        'RemoveClientFacilityButton
        '
        Me.RemoveClientFacilityButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.RemoveClientFacilityButton.Image = CType(resources.GetObject("RemoveClientFacilityButton.Image"), System.Drawing.Image)
        Me.RemoveClientFacilityButton.Location = New System.Drawing.Point(13, 158)
        Me.RemoveClientFacilityButton.Name = "RemoveClientFacilityButton"
        Me.RemoveClientFacilityButton.Size = New System.Drawing.Size(37, 33)
        Me.RemoveClientFacilityButton.TabIndex = 1
        Me.RemoveClientFacilityButton.UseVisualStyleBackColor = True
        '
        'AddClientFacilityButton
        '
        Me.AddClientFacilityButton.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.AddClientFacilityButton.Image = CType(resources.GetObject("AddClientFacilityButton.Image"), System.Drawing.Image)
        Me.AddClientFacilityButton.Location = New System.Drawing.Point(13, 116)
        Me.AddClientFacilityButton.Name = "AddClientFacilityButton"
        Me.AddClientFacilityButton.Size = New System.Drawing.Size(37, 36)
        Me.AddClientFacilityButton.TabIndex = 0
        Me.AddClientFacilityButton.UseVisualStyleBackColor = True
        '
        'AvailableFieldsPanel
        '
        Me.AvailableFieldsPanel.AutoScroll = True
        Me.AvailableFieldsPanel.Controls.Add(Me.AllFacilityGrid)
        Me.AvailableFieldsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AvailableFieldsPanel.Location = New System.Drawing.Point(3, 3)
        Me.AvailableFieldsPanel.Name = "AvailableFieldsPanel"
        Me.AvailableFieldsPanel.Size = New System.Drawing.Size(367, 286)
        Me.AvailableFieldsPanel.TabIndex = 3
        '
        'AllFacilityGrid
        '
        Me.AllFacilityGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AllFacilityGrid.Location = New System.Drawing.Point(0, 0)
        Me.AllFacilityGrid.Name = "AllFacilityGrid"
        Me.AllFacilityGrid.ShowIdentifierColumnsOnly = False
        Me.AllFacilityGrid.Size = New System.Drawing.Size(367, 286)
        Me.AllFacilityGrid.TabIndex = 1
        '
        'AllFacilityToolStrip
        '
        Me.AllFacilityToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.AllFacilityToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AllFacilityCaptionTSLabel, Me.AllFacilityDeleteTSButton, Me.AllFacilityTSSeparator1})
        Me.AllFacilityToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.AllFacilityToolStrip.Name = "AllFacilityToolStrip"
        Me.AllFacilityToolStrip.Size = New System.Drawing.Size(435, 25)
        Me.AllFacilityToolStrip.TabIndex = 2
        Me.AllFacilityToolStrip.Text = "ToolStrip1"
        '
        'AllFacilityCaptionTSLabel
        '
        Me.AllFacilityCaptionTSLabel.Name = "AllFacilityCaptionTSLabel"
        Me.AllFacilityCaptionTSLabel.Size = New System.Drawing.Size(100, 22)
        Me.AllFacilityCaptionTSLabel.Text = " Available Facilities:"
        '
        'AllFacilityDeleteTSButton
        '
        Me.AllFacilityDeleteTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.AllFacilityDeleteTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AllFacilityDeleteTSButton.Name = "AllFacilityDeleteTSButton"
        Me.AllFacilityDeleteTSButton.Size = New System.Drawing.Size(94, 22)
        Me.AllFacilityDeleteTSButton.Text = "Delete Facility"
        '
        'AllFacilityTSSeparator1
        '
        Me.AllFacilityTSSeparator1.Name = "AllFacilityTSSeparator1"
        Me.AllFacilityTSSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'ClientFacilityPanel
        '
        Me.ClientFacilityPanel.AutoScroll = True
        Me.ClientFacilityPanel.Controls.Add(Me.ClientFacilityGrid)
        Me.ClientFacilityPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientFacilityPanel.Location = New System.Drawing.Point(0, 25)
        Me.ClientFacilityPanel.Name = "ClientFacilityPanel"
        Me.ClientFacilityPanel.Size = New System.Drawing.Size(359, 292)
        Me.ClientFacilityPanel.TabIndex = 3
        '
        'ClientFacilityGrid
        '
        Me.ClientFacilityGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ClientFacilityGrid.Location = New System.Drawing.Point(0, 0)
        Me.ClientFacilityGrid.Name = "ClientFacilityGrid"
        Me.ClientFacilityGrid.ShowIdentifierColumnsOnly = False
        Me.ClientFacilityGrid.Size = New System.Drawing.Size(359, 292)
        Me.ClientFacilityGrid.TabIndex = 0
        '
        'ClientFacilityToolStrip
        '
        Me.ClientFacilityToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ClientFacilityToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ClientFacilityCaptionTSLabel})
        Me.ClientFacilityToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.ClientFacilityToolStrip.Name = "ClientFacilityToolStrip"
        Me.ClientFacilityToolStrip.Size = New System.Drawing.Size(359, 25)
        Me.ClientFacilityToolStrip.TabIndex = 0
        Me.ClientFacilityToolStrip.Text = "ToolStrip1"
        '
        'ClientFacilityCaptionTSLabel
        '
        Me.ClientFacilityCaptionTSLabel.Name = "ClientFacilityCaptionTSLabel"
        Me.ClientFacilityCaptionTSLabel.Size = New System.Drawing.Size(84, 22)
        Me.ClientFacilityCaptionTSLabel.Text = " Client Facilities:"
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ButtonPanel)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(1, 344)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(798, 35)
        Me.BottomPanel.TabIndex = 4
        '
        'ButtonPanel
        '
        Me.ButtonPanel.Controls.Add(Me.Cancel_Button)
        Me.ButtonPanel.Controls.Add(Me.ApplyButton)
        Me.ButtonPanel.Dock = System.Windows.Forms.DockStyle.Right
        Me.ButtonPanel.Location = New System.Drawing.Point(596, 0)
        Me.ButtonPanel.Name = "ButtonPanel"
        Me.ButtonPanel.Size = New System.Drawing.Size(200, 33)
        Me.ButtonPanel.TabIndex = 3
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Cancel_Button.Location = New System.Drawing.Point(119, 5)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(75, 23)
        Me.Cancel_Button.TabIndex = 3
        Me.Cancel_Button.Text = "Cancel"
        Me.Cancel_Button.UseVisualStyleBackColor = True
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.Location = New System.Drawing.Point(38, 5)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 2
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'FacilitySection
        '
        Me.Controls.Add(Me.MainPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "FacilitySection"
        Me.Size = New System.Drawing.Size(800, 380)
        Me.MainPanel.ResumeLayout(False)
        Me.FacilitySplitContainer.Panel1.ResumeLayout(False)
        Me.FacilitySplitContainer.Panel1.PerformLayout()
        Me.FacilitySplitContainer.Panel2.ResumeLayout(False)
        Me.FacilitySplitContainer.Panel2.PerformLayout()
        Me.FacilitySplitContainer.ResumeLayout(False)
        Me.AllFacilityTableLayoutPanel.ResumeLayout(False)
        Me.AddRemovePanel.ResumeLayout(False)
        Me.AvailableFieldsPanel.ResumeLayout(False)
        Me.AllFacilityToolStrip.ResumeLayout(False)
        Me.AllFacilityToolStrip.PerformLayout()
        Me.ClientFacilityPanel.ResumeLayout(False)
        Me.ClientFacilityToolStrip.ResumeLayout(False)
        Me.ClientFacilityToolStrip.PerformLayout()
        Me.BottomPanel.ResumeLayout(False)
        Me.ButtonPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents RegionIdDataGridViewTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MainPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents ButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents FacilitySplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents AllFacilityTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents AddRemovePanel As System.Windows.Forms.Panel
    Friend WithEvents RemoveClientFacilityButton As System.Windows.Forms.Button
    Friend WithEvents AddClientFacilityButton As System.Windows.Forms.Button
    Friend WithEvents AvailableFieldsPanel As System.Windows.Forms.Panel
    Friend WithEvents AllFacilityGrid As Nrc.Qualisys.ConfigurationManager.FacilityGrid
    Friend WithEvents AllFacilityToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents AllFacilityCaptionTSLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents AllFacilityDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents AllFacilityTSSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ClientFacilityPanel As System.Windows.Forms.Panel
    Friend WithEvents ClientFacilityGrid As Nrc.Qualisys.ConfigurationManager.FacilityGrid
    Friend WithEvents ClientFacilityToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ClientFacilityCaptionTSLabel As System.Windows.Forms.ToolStripLabel

End Class
