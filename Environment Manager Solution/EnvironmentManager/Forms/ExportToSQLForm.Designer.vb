<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportToSQLForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExportToSQLForm))
        Me.RichTextBox1 = New System.Windows.Forms.RichTextBox
        Me.GenerateSQLButton = New System.Windows.Forms.Button
        Me.PrintingSystem1 = New DevExpress.XtraPrinting.PrintingSystem(Me.components)
        Me.TSQLOutputLink = New DevExpress.XtraPrintingLinks.RichTextBoxLink
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.PrintToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.toolStripSeparator = New System.Windows.Forms.ToolStripSeparator
        Me.SaveToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.SaveAsToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.OpenToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.ExecuteToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.TestToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.PickTargetToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.IgnoreIdentityCheckBox = New System.Windows.Forms.CheckBox
        Me.UseSPCheckBox = New System.Windows.Forms.CheckBox
        Me.SPNameTextBox = New System.Windows.Forms.TextBox
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.CLBTargetDataBases = New DevExpress.XtraEditors.CheckedListBoxControl
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.txtCurrentConnection = New System.Windows.Forms.TextBox
        Me.GBGenerateSQL = New System.Windows.Forms.GroupBox
        Me.GBTargetEnvironment = New System.Windows.Forms.GroupBox
        CType(Me.PrintingSystem1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        CType(Me.CLBTargetDataBases, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TableLayoutPanel1.SuspendLayout()
        Me.GBGenerateSQL.SuspendLayout()
        Me.GBTargetEnvironment.SuspendLayout()
        Me.SuspendLayout()
        '
        'RichTextBox1
        '
        Me.RichTextBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.RichTextBox1.Location = New System.Drawing.Point(0, 0)
        Me.RichTextBox1.Name = "RichTextBox1"
        Me.RichTextBox1.Size = New System.Drawing.Size(768, 486)
        Me.RichTextBox1.TabIndex = 0
        Me.RichTextBox1.Text = ""
        '
        'GenerateSQLButton
        '
        Me.GenerateSQLButton.Location = New System.Drawing.Point(659, 14)
        Me.GenerateSQLButton.Name = "GenerateSQLButton"
        Me.GenerateSQLButton.Size = New System.Drawing.Size(110, 21)
        Me.GenerateSQLButton.TabIndex = 1
        Me.GenerateSQLButton.Text = "Generate SQL"
        Me.GenerateSQLButton.UseVisualStyleBackColor = True
        '
        'PrintingSystem1
        '
        Me.PrintingSystem1.Links.AddRange(New Object() {Me.TSQLOutputLink})
        '
        'TSQLOutputLink
        '
        Me.TSQLOutputLink.CustomPaperSize = New System.Drawing.Size(0, 0)
        Me.TSQLOutputLink.ImageStream = CType(resources.GetObject("TSQLOutputLink.ImageStream"), DevExpress.Utils.ImageCollectionStreamer)
        Me.TSQLOutputLink.PrintingSystem = Me.PrintingSystem1
        Me.TSQLOutputLink.RichTextBox = Me.RichTextBox1
        Me.TSQLOutputLink.VerticalContentSplitting = DevExpress.XtraPrinting.VerticalContentSplitting.Smart
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.PrintToolStripButton, Me.toolStripSeparator, Me.SaveToolStripButton, Me.SaveAsToolStripButton, Me.OpenToolStripButton, Me.ExecuteToolStripButton, Me.TestToolStripButton, Me.PickTargetToolStripButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(972, 25)
        Me.ToolStrip1.TabIndex = 5
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'PrintToolStripButton
        '
        Me.PrintToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.PrintToolStripButton.Image = CType(resources.GetObject("PrintToolStripButton.Image"), System.Drawing.Image)
        Me.PrintToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.PrintToolStripButton.Name = "PrintToolStripButton"
        Me.PrintToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.PrintToolStripButton.Text = "&Print"
        '
        'toolStripSeparator
        '
        Me.toolStripSeparator.Name = "toolStripSeparator"
        Me.toolStripSeparator.Size = New System.Drawing.Size(6, 25)
        '
        'SaveToolStripButton
        '
        Me.SaveToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SaveToolStripButton.Image = CType(resources.GetObject("SaveToolStripButton.Image"), System.Drawing.Image)
        Me.SaveToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SaveToolStripButton.Name = "SaveToolStripButton"
        Me.SaveToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.SaveToolStripButton.Text = "&Save"
        '
        'SaveAsToolStripButton
        '
        Me.SaveAsToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.SaveAsToolStripButton.Image = CType(resources.GetObject("SaveAsToolStripButton.Image"), System.Drawing.Image)
        Me.SaveAsToolStripButton.ImageTransparentColor = System.Drawing.Color.Black
        Me.SaveAsToolStripButton.Name = "SaveAsToolStripButton"
        Me.SaveAsToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.SaveAsToolStripButton.Text = "Save &As"
        '
        'OpenToolStripButton
        '
        Me.OpenToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.OpenToolStripButton.Image = CType(resources.GetObject("OpenToolStripButton.Image"), System.Drawing.Image)
        Me.OpenToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OpenToolStripButton.Name = "OpenToolStripButton"
        Me.OpenToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.OpenToolStripButton.Text = "&Open"
        '
        'ExecuteToolStripButton
        '
        Me.ExecuteToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ExecuteToolStripButton.Enabled = False
        Me.ExecuteToolStripButton.Image = Global.EnvironmentManager.My.Resources.Resources.PlayHS
        Me.ExecuteToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExecuteToolStripButton.Name = "ExecuteToolStripButton"
        Me.ExecuteToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.ExecuteToolStripButton.Text = "ToolStripButton1"
        Me.ExecuteToolStripButton.ToolTipText = "Execute..."
        '
        'TestToolStripButton
        '
        Me.TestToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.TestToolStripButton.Enabled = False
        Me.TestToolStripButton.Image = Global.EnvironmentManager.My.Resources.Resources.CheckSpellingHS
        Me.TestToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.TestToolStripButton.Name = "TestToolStripButton"
        Me.TestToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.TestToolStripButton.Text = "Test "
        Me.TestToolStripButton.ToolTipText = "Test the script"
        '
        'PickTargetToolStripButton
        '
        Me.PickTargetToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.PickTargetToolStripButton.Image = Global.EnvironmentManager.My.Resources.Resources.VSProject_database
        Me.PickTargetToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.PickTargetToolStripButton.Name = "PickTargetToolStripButton"
        Me.PickTargetToolStripButton.Size = New System.Drawing.Size(23, 22)
        Me.PickTargetToolStripButton.Text = "Pick Target Database..."
        Me.PickTargetToolStripButton.Visible = False
        '
        'IgnoreIdentityCheckBox
        '
        Me.IgnoreIdentityCheckBox.AutoSize = True
        Me.IgnoreIdentityCheckBox.Checked = True
        Me.IgnoreIdentityCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.IgnoreIdentityCheckBox.Location = New System.Drawing.Point(498, 18)
        Me.IgnoreIdentityCheckBox.Name = "IgnoreIdentityCheckBox"
        Me.IgnoreIdentityCheckBox.Size = New System.Drawing.Size(131, 17)
        Me.IgnoreIdentityCheckBox.TabIndex = 6
        Me.IgnoreIdentityCheckBox.Text = "Ignore Identity Column"
        Me.IgnoreIdentityCheckBox.UseVisualStyleBackColor = True
        '
        'UseSPCheckBox
        '
        Me.UseSPCheckBox.AutoSize = True
        Me.UseSPCheckBox.Checked = True
        Me.UseSPCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.UseSPCheckBox.Location = New System.Drawing.Point(12, 18)
        Me.UseSPCheckBox.Name = "UseSPCheckBox"
        Me.UseSPCheckBox.Size = New System.Drawing.Size(189, 17)
        Me.UseSPCheckBox.TabIndex = 6
        Me.UseSPCheckBox.Text = "Use Stored Procedure for INSERT"
        Me.UseSPCheckBox.UseVisualStyleBackColor = True
        '
        'SPNameTextBox
        '
        Me.SPNameTextBox.Location = New System.Drawing.Point(207, 15)
        Me.SPNameTextBox.Name = "SPNameTextBox"
        Me.SPNameTextBox.Size = New System.Drawing.Size(183, 20)
        Me.SPNameTextBox.TabIndex = 7
        Me.SPNameTextBox.Text = "[Temp_InsertUpdateQualProParams]"
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(3, 78)
        Me.SplitContainer1.Name = "SplitContainer1"
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.RichTextBox1)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.GBTargetEnvironment)
        Me.SplitContainer1.Size = New System.Drawing.Size(942, 486)
        Me.SplitContainer1.SplitterDistance = 768
        Me.SplitContainer1.TabIndex = 12
        '
        'CLBTargetDataBases
        '
        Me.CLBTargetDataBases.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CLBTargetDataBases.Location = New System.Drawing.Point(3, 16)
        Me.CLBTargetDataBases.Name = "CLBTargetDataBases"
        Me.CLBTargetDataBases.Size = New System.Drawing.Size(164, 467)
        Me.CLBTargetDataBases.TabIndex = 11
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 1
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.TableLayoutPanel1.Controls.Add(Me.txtCurrentConnection, 0, 2)
        Me.TableLayoutPanel1.Controls.Add(Me.GBGenerateSQL, 0, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.SplitContainer1, 0, 1)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(12, 28)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 3
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 75.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 75.0!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(948, 642)
        Me.TableLayoutPanel1.TabIndex = 13
        '
        'txtCurrentConnection
        '
        Me.txtCurrentConnection.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtCurrentConnection.Location = New System.Drawing.Point(3, 570)
        Me.txtCurrentConnection.Multiline = True
        Me.txtCurrentConnection.Name = "txtCurrentConnection"
        Me.txtCurrentConnection.ReadOnly = True
        Me.txtCurrentConnection.Size = New System.Drawing.Size(942, 69)
        Me.txtCurrentConnection.TabIndex = 15
        '
        'GBGenerateSQL
        '
        Me.GBGenerateSQL.Controls.Add(Me.SPNameTextBox)
        Me.GBGenerateSQL.Controls.Add(Me.GenerateSQLButton)
        Me.GBGenerateSQL.Controls.Add(Me.IgnoreIdentityCheckBox)
        Me.GBGenerateSQL.Controls.Add(Me.UseSPCheckBox)
        Me.GBGenerateSQL.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GBGenerateSQL.Location = New System.Drawing.Point(3, 3)
        Me.GBGenerateSQL.Name = "GBGenerateSQL"
        Me.GBGenerateSQL.Size = New System.Drawing.Size(942, 69)
        Me.GBGenerateSQL.TabIndex = 14
        Me.GBGenerateSQL.TabStop = False
        Me.GBGenerateSQL.Text = "Generate Script"
        '
        'GBTargetEnvironment
        '
        Me.GBTargetEnvironment.Controls.Add(Me.CLBTargetDataBases)
        Me.GBTargetEnvironment.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GBTargetEnvironment.Location = New System.Drawing.Point(0, 0)
        Me.GBTargetEnvironment.Name = "GBTargetEnvironment"
        Me.GBTargetEnvironment.Size = New System.Drawing.Size(170, 486)
        Me.GBTargetEnvironment.TabIndex = 14
        Me.GBTargetEnvironment.TabStop = False
        Me.GBTargetEnvironment.Text = "Select Target Environments"
        '
        'ExportToSQLForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(972, 682)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "ExportToSQLForm"
        Me.Text = "Export to SQL"
        CType(Me.PrintingSystem1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        CType(Me.CLBTargetDataBases, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.TableLayoutPanel1.PerformLayout()
        Me.GBGenerateSQL.ResumeLayout(False)
        Me.GBGenerateSQL.PerformLayout()
        Me.GBTargetEnvironment.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents RichTextBox1 As System.Windows.Forms.RichTextBox
    Friend WithEvents GenerateSQLButton As System.Windows.Forms.Button
    Friend WithEvents PrintingSystem1 As DevExpress.XtraPrinting.PrintingSystem
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents PrintToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents toolStripSeparator As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents TSQLOutputLink As DevExpress.XtraPrintingLinks.RichTextBoxLink
    Friend WithEvents SaveToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents IgnoreIdentityCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents UseSPCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents SPNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents SaveAsToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OpenToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExecuteToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents TestToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents PickTargetToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents GBGenerateSQL As System.Windows.Forms.GroupBox
    Friend WithEvents txtCurrentConnection As System.Windows.Forms.TextBox
    Friend WithEvents GBTargetEnvironment As System.Windows.Forms.GroupBox
    Friend WithEvents CLBTargetDataBases As DevExpress.XtraEditors.CheckedListBoxControl
End Class
