<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class WeightsLoaderSection
    Inherits DataMart.WeightsLoader.Section


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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
        Me.LoadWeightPanel = New NRC.Framework.WinForms.SectionPanel
        Me.FootnoteLabel = New System.Windows.Forms.Label
        Me.PreviewGroupBox = New System.Windows.Forms.GroupBox
        Me.PreviewDataGrid = New System.Windows.Forms.DataGridView
        Me.LoadWeightsToolStrip = New System.Windows.Forms.ToolStrip
        Me.OpenButton = New System.Windows.Forms.ToolStripButton
        Me.LoadWeightsToolStripSeparator = New System.Windows.Forms.ToolStripSeparator
        Me.LoadToolStripSplitButton = New System.Windows.Forms.ToolStripSplitButton
        Me.LoadToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LoadAndReplaceToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.WeightTypeLabel = New System.Windows.Forms.Label
        Me.WeightTypeComboBox = New System.Windows.Forms.ComboBox
        Me.SamplePopColumnLabel = New System.Windows.Forms.Label
        Me.WeightColumnLabel = New System.Windows.Forms.Label
        Me.WeightColumnComboBox = New System.Windows.Forms.ComboBox
        Me.SamplePopColumnComboBox = New System.Windows.Forms.ComboBox
        Me.OpenWeightsFileDialog = New System.Windows.Forms.OpenFileDialog
        Me.LoadWeightPanel.SuspendLayout()
        Me.PreviewGroupBox.SuspendLayout()
        CType(Me.PreviewDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.LoadWeightsToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'LoadWeightPanel
        '
        Me.LoadWeightPanel.AutoScroll = True
        Me.LoadWeightPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.LoadWeightPanel.Caption = "Load Weights"
        Me.LoadWeightPanel.Controls.Add(Me.FootnoteLabel)
        Me.LoadWeightPanel.Controls.Add(Me.PreviewGroupBox)
        Me.LoadWeightPanel.Controls.Add(Me.LoadWeightsToolStrip)
        Me.LoadWeightPanel.Controls.Add(Me.WeightTypeLabel)
        Me.LoadWeightPanel.Controls.Add(Me.WeightTypeComboBox)
        Me.LoadWeightPanel.Controls.Add(Me.SamplePopColumnLabel)
        Me.LoadWeightPanel.Controls.Add(Me.WeightColumnLabel)
        Me.LoadWeightPanel.Controls.Add(Me.WeightColumnComboBox)
        Me.LoadWeightPanel.Controls.Add(Me.SamplePopColumnComboBox)
        Me.LoadWeightPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.LoadWeightPanel.Enabled = False
        Me.LoadWeightPanel.Location = New System.Drawing.Point(0, 0)
        Me.LoadWeightPanel.Name = "LoadWeightPanel"
        Me.LoadWeightPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.LoadWeightPanel.ShowCaption = True
        Me.LoadWeightPanel.Size = New System.Drawing.Size(842, 690)
        Me.LoadWeightPanel.TabIndex = 1
        '
        'FootnoteLabel
        '
        Me.FootnoteLabel.AutoSize = True
        Me.FootnoteLabel.Location = New System.Drawing.Point(26, 188)
        Me.FootnoteLabel.Name = "FootnoteLabel"
        Me.FootnoteLabel.Size = New System.Drawing.Size(246, 13)
        Me.FootnoteLabel.TabIndex = 19
        Me.FootnoteLabel.Text = "* Only Numeric Columns are Available for Selection"
        '
        'PreviewGroupBox
        '
        Me.PreviewGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PreviewGroupBox.Controls.Add(Me.PreviewDataGrid)
        Me.PreviewGroupBox.Location = New System.Drawing.Point(29, 233)
        Me.PreviewGroupBox.Name = "PreviewGroupBox"
        Me.PreviewGroupBox.Size = New System.Drawing.Size(783, 314)
        Me.PreviewGroupBox.TabIndex = 18
        Me.PreviewGroupBox.TabStop = False
        Me.PreviewGroupBox.Text = "File Preview"
        '
        'PreviewDataGrid
        '
        Me.PreviewDataGrid.AllowUserToAddRows = False
        Me.PreviewDataGrid.AllowUserToDeleteRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.Silver
        Me.PreviewDataGrid.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.PreviewDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PreviewDataGrid.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells
        Me.PreviewDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.PreviewDataGrid.Location = New System.Drawing.Point(6, 19)
        Me.PreviewDataGrid.Name = "PreviewDataGrid"
        Me.PreviewDataGrid.ReadOnly = True
        Me.PreviewDataGrid.RowHeadersVisible = False
        Me.PreviewDataGrid.Size = New System.Drawing.Size(771, 289)
        Me.PreviewDataGrid.TabIndex = 3
        '
        'LoadWeightsToolStrip
        '
        Me.LoadWeightsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenButton, Me.LoadWeightsToolStripSeparator, Me.LoadToolStripSplitButton})
        Me.LoadWeightsToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.LoadWeightsToolStrip.Name = "LoadWeightsToolStrip"
        Me.LoadWeightsToolStrip.Size = New System.Drawing.Size(840, 25)
        Me.LoadWeightsToolStrip.TabIndex = 1
        Me.LoadWeightsToolStrip.Text = "ToolStrip1"
        '
        'OpenButton
        '
        Me.OpenButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Open
        Me.OpenButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OpenButton.Name = "OpenButton"
        Me.OpenButton.Size = New System.Drawing.Size(53, 22)
        Me.OpenButton.Text = "Open"
        '
        'LoadWeightsToolStripSeparator
        '
        Me.LoadWeightsToolStripSeparator.Name = "LoadWeightsToolStripSeparator"
        Me.LoadWeightsToolStripSeparator.Size = New System.Drawing.Size(6, 25)
        '
        'LoadToolStripSplitButton
        '
        Me.LoadToolStripSplitButton.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LoadToolStripMenuItem, Me.LoadAndReplaceToolStripMenuItem})
        Me.LoadToolStripSplitButton.Image = Global.NRC.DataMart.WeightsLoader.My.Resources.Resources.Redo
        Me.LoadToolStripSplitButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.LoadToolStripSplitButton.Name = "LoadToolStripSplitButton"
        Me.LoadToolStripSplitButton.Size = New System.Drawing.Size(74, 22)
        Me.LoadToolStripSplitButton.Text = "Load..."
        '
        'LoadToolStripMenuItem
        '
        Me.LoadToolStripMenuItem.Name = "LoadToolStripMenuItem"
        Me.LoadToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.LoadToolStripMenuItem.Text = "Load"
        '
        'LoadAndReplaceToolStripMenuItem
        '
        Me.LoadAndReplaceToolStripMenuItem.Name = "LoadAndReplaceToolStripMenuItem"
        Me.LoadAndReplaceToolStripMenuItem.Size = New System.Drawing.Size(170, 22)
        Me.LoadAndReplaceToolStripMenuItem.Text = "Load and Replace"
        '
        'WeightTypeLabel
        '
        Me.WeightTypeLabel.AutoSize = True
        Me.WeightTypeLabel.Location = New System.Drawing.Point(26, 71)
        Me.WeightTypeLabel.Name = "WeightTypeLabel"
        Me.WeightTypeLabel.Size = New System.Drawing.Size(68, 13)
        Me.WeightTypeLabel.TabIndex = 13
        Me.WeightTypeLabel.Text = "Weight Type"
        '
        'WeightTypeComboBox
        '
        Me.WeightTypeComboBox.FormattingEnabled = True
        Me.WeightTypeComboBox.Location = New System.Drawing.Point(140, 68)
        Me.WeightTypeComboBox.Name = "WeightTypeComboBox"
        Me.WeightTypeComboBox.Size = New System.Drawing.Size(160, 21)
        Me.WeightTypeComboBox.TabIndex = 12
        '
        'SamplePopColumnLabel
        '
        Me.SamplePopColumnLabel.AutoSize = True
        Me.SamplePopColumnLabel.Location = New System.Drawing.Point(26, 113)
        Me.SamplePopColumnLabel.Name = "SamplePopColumnLabel"
        Me.SamplePopColumnLabel.Size = New System.Drawing.Size(106, 13)
        Me.SamplePopColumnLabel.TabIndex = 8
        Me.SamplePopColumnLabel.Text = "Sample Pop Column*"
        '
        'WeightColumnLabel
        '
        Me.WeightColumnLabel.AutoSize = True
        Me.WeightColumnLabel.Location = New System.Drawing.Point(27, 157)
        Me.WeightColumnLabel.Name = "WeightColumnLabel"
        Me.WeightColumnLabel.Size = New System.Drawing.Size(113, 13)
        Me.WeightColumnLabel.TabIndex = 10
        Me.WeightColumnLabel.Text = "Weight Value Column*"
        '
        'WeightColumnComboBox
        '
        Me.WeightColumnComboBox.FormattingEnabled = True
        Me.WeightColumnComboBox.Location = New System.Drawing.Point(140, 157)
        Me.WeightColumnComboBox.Name = "WeightColumnComboBox"
        Me.WeightColumnComboBox.Size = New System.Drawing.Size(160, 21)
        Me.WeightColumnComboBox.TabIndex = 9
        '
        'SamplePopColumnComboBox
        '
        Me.SamplePopColumnComboBox.FormattingEnabled = True
        Me.SamplePopColumnComboBox.Location = New System.Drawing.Point(140, 113)
        Me.SamplePopColumnComboBox.Name = "SamplePopColumnComboBox"
        Me.SamplePopColumnComboBox.Size = New System.Drawing.Size(160, 21)
        Me.SamplePopColumnComboBox.TabIndex = 7
        '
        'OpenWeightsFileDialog
        '
        Me.OpenWeightsFileDialog.DefaultExt = "dbf"
        Me.OpenWeightsFileDialog.Filter = "DBase (.dbf)| *.dbf"
        '
        'WeightsLoaderSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoScroll = True
        Me.AutoScrollMinSize = New System.Drawing.Size(800, 600)
        Me.Controls.Add(Me.LoadWeightPanel)
        Me.Name = "WeightsLoaderSection"
        Me.Size = New System.Drawing.Size(842, 690)
        Me.LoadWeightPanel.ResumeLayout(False)
        Me.LoadWeightPanel.PerformLayout()
        Me.PreviewGroupBox.ResumeLayout(False)
        CType(Me.PreviewDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.LoadWeightsToolStrip.ResumeLayout(False)
        Me.LoadWeightsToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents LoadWeightPanel As NRC.Framework.WinForms.SectionPanel
    Friend WithEvents LoadWeightsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents OpenButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OpenWeightsFileDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents PreviewDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents WeightColumnLabel As System.Windows.Forms.Label
    Friend WithEvents WeightColumnComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents SamplePopColumnLabel As System.Windows.Forms.Label
    Friend WithEvents SamplePopColumnComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents LoadWeightsToolStripSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents WeightTypeLabel As System.Windows.Forms.Label
    Friend WithEvents WeightTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents LoadToolStripSplitButton As System.Windows.Forms.ToolStripSplitButton
    Friend WithEvents LoadToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LoadAndReplaceToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents PreviewGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents FootnoteLabel As System.Windows.Forms.Label

End Class
