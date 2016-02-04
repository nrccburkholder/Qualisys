<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class XMLViewerSection
    Inherits Section

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
        Me.HeaderStrip1 = New PS.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.cmdGetData = New System.Windows.Forms.Button
        Me.txtXMLFilePath = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmdSelectFile = New System.Windows.Forms.Button
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.grpData = New System.Windows.Forms.GroupBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtSaveFile = New System.Windows.Forms.TextBox
        Me.cmdSaveFile = New System.Windows.Forms.Button
        Me.dgResults = New System.Windows.Forms.DataGridView
        Me.cmdExport = New System.Windows.Forms.Button
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.HeaderStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.grpData.SuspendLayout()
        CType(Me.dgResults, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = PS.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(790, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(174, 22)
        Me.ToolStripLabel1.Text = "XML Dataset Viewer"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.cmdGetData)
        Me.GroupBox1.Controls.Add(Me.txtXMLFilePath)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.cmdSelectFile)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(784, 64)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Selection"
        '
        'cmdGetData
        '
        Me.cmdGetData.Location = New System.Drawing.Point(698, 35)
        Me.cmdGetData.Name = "cmdGetData"
        Me.cmdGetData.Size = New System.Drawing.Size(75, 23)
        Me.cmdGetData.TabIndex = 3
        Me.cmdGetData.Text = "Get Data"
        Me.cmdGetData.UseVisualStyleBackColor = True
        '
        'txtXMLFilePath
        '
        Me.txtXMLFilePath.Enabled = False
        Me.txtXMLFilePath.Location = New System.Drawing.Point(71, 13)
        Me.txtXMLFilePath.Name = "txtXMLFilePath"
        Me.txtXMLFilePath.Size = New System.Drawing.Size(672, 20)
        Me.txtXMLFilePath.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 16)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(59, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Select File:"
        '
        'cmdSelectFile
        '
        Me.cmdSelectFile.Location = New System.Drawing.Point(749, 11)
        Me.cmdSelectFile.Name = "cmdSelectFile"
        Me.cmdSelectFile.Size = New System.Drawing.Size(24, 23)
        Me.cmdSelectFile.TabIndex = 0
        Me.cmdSelectFile.Text = "..."
        Me.cmdSelectFile.UseVisualStyleBackColor = True
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        Me.OpenFileDialog1.Filter = "XML Files|*.xml"
        '
        'grpData
        '
        Me.grpData.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpData.Controls.Add(Me.Label2)
        Me.grpData.Controls.Add(Me.txtSaveFile)
        Me.grpData.Controls.Add(Me.cmdSaveFile)
        Me.grpData.Controls.Add(Me.dgResults)
        Me.grpData.Controls.Add(Me.cmdExport)
        Me.grpData.Location = New System.Drawing.Point(3, 98)
        Me.grpData.Name = "grpData"
        Me.grpData.Size = New System.Drawing.Size(784, 509)
        Me.grpData.TabIndex = 2
        Me.grpData.TabStop = False
        Me.grpData.Text = "Data"
        Me.grpData.Visible = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 23)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(54, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Save File:"
        '
        'txtSaveFile
        '
        Me.txtSaveFile.Enabled = False
        Me.txtSaveFile.Location = New System.Drawing.Point(71, 19)
        Me.txtSaveFile.Name = "txtSaveFile"
        Me.txtSaveFile.Size = New System.Drawing.Size(564, 20)
        Me.txtSaveFile.TabIndex = 3
        '
        'cmdSaveFile
        '
        Me.cmdSaveFile.Location = New System.Drawing.Point(641, 17)
        Me.cmdSaveFile.Name = "cmdSaveFile"
        Me.cmdSaveFile.Size = New System.Drawing.Size(26, 23)
        Me.cmdSaveFile.TabIndex = 2
        Me.cmdSaveFile.Text = "..."
        Me.cmdSaveFile.UseVisualStyleBackColor = True
        '
        'dgResults
        '
        Me.dgResults.AllowUserToAddRows = False
        Me.dgResults.AllowUserToDeleteRows = False
        Me.dgResults.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgResults.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgResults.Location = New System.Drawing.Point(9, 46)
        Me.dgResults.Name = "dgResults"
        Me.dgResults.ReadOnly = True
        Me.dgResults.Size = New System.Drawing.Size(769, 457)
        Me.dgResults.TabIndex = 1
        '
        'cmdExport
        '
        Me.cmdExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdExport.Location = New System.Drawing.Point(673, 17)
        Me.cmdExport.Name = "cmdExport"
        Me.cmdExport.Size = New System.Drawing.Size(105, 23)
        Me.cmdExport.TabIndex = 0
        Me.cmdExport.Text = "Export to CSV"
        Me.cmdExport.UseVisualStyleBackColor = True
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "CSV Files|.csv"
        '
        'XMLViewerSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.grpData)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "XMLViewerSection"
        Me.Size = New System.Drawing.Size(790, 610)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.grpData.ResumeLayout(False)
        Me.grpData.PerformLayout()
        CType(Me.dgResults, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As PS.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents txtXMLFilePath As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cmdSelectFile As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents grpData As System.Windows.Forms.GroupBox
    Friend WithEvents dgResults As System.Windows.Forms.DataGridView
    Friend WithEvents cmdExport As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtSaveFile As System.Windows.Forms.TextBox
    Friend WithEvents cmdSaveFile As System.Windows.Forms.Button
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents cmdGetData As System.Windows.Forms.Button

End Class
