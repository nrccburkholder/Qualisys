<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PivotFileSection
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
        Me.LoadSource = New System.Windows.Forms.Button
        Me.TargetDelimiter = New System.Windows.Forms.TextBox
        Me.groupBox1 = New System.Windows.Forms.GroupBox
        Me.label2 = New System.Windows.Forms.Label
        Me.SourceDelimiter = New System.Windows.Forms.TextBox
        Me.SourcePath = New System.Windows.Forms.TextBox
        Me.SourceBrowse = New System.Windows.Forms.Button
        Me.TargetGB = New System.Windows.Forms.GroupBox
        Me.cbQuotes = New System.Windows.Forms.CheckBox
        Me.TargetHeader = New System.Windows.Forms.CheckBox
        Me.Convert = New System.Windows.Forms.Button
        Me.label1 = New System.Windows.Forms.Label
        Me.ColumnGrid = New System.Windows.Forms.DataGridView
        Me.IsPivot = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.Column = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.groupBox1.SuspendLayout()
        Me.TargetGB.SuspendLayout()
        CType(Me.ColumnGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'LoadSource
        '
        Me.LoadSource.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LoadSource.Location = New System.Drawing.Point(366, 46)
        Me.LoadSource.Name = "LoadSource"
        Me.LoadSource.Size = New System.Drawing.Size(75, 23)
        Me.LoadSource.TabIndex = 12
        Me.LoadSource.Text = "Load"
        Me.LoadSource.UseVisualStyleBackColor = True
        '
        'TargetDelimiter
        '
        Me.TargetDelimiter.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.TargetDelimiter.Location = New System.Drawing.Point(113, 17)
        Me.TargetDelimiter.Name = "TargetDelimiter"
        Me.TargetDelimiter.Size = New System.Drawing.Size(29, 20)
        Me.TargetDelimiter.TabIndex = 10
        '
        'groupBox1
        '
        Me.groupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.groupBox1.Controls.Add(Me.LoadSource)
        Me.groupBox1.Controls.Add(Me.label2)
        Me.groupBox1.Controls.Add(Me.SourceDelimiter)
        Me.groupBox1.Controls.Add(Me.SourcePath)
        Me.groupBox1.Controls.Add(Me.SourceBrowse)
        Me.groupBox1.Location = New System.Drawing.Point(22, 7)
        Me.groupBox1.Name = "groupBox1"
        Me.groupBox1.Size = New System.Drawing.Size(447, 81)
        Me.groupBox1.TabIndex = 11
        Me.groupBox1.TabStop = False
        Me.groupBox1.Text = "Source File"
        '
        'label2
        '
        Me.label2.AutoSize = True
        Me.label2.Location = New System.Drawing.Point(41, 51)
        Me.label2.Name = "label2"
        Me.label2.Size = New System.Drawing.Size(47, 13)
        Me.label2.TabIndex = 11
        Me.label2.Text = "Delimiter"
        '
        'SourceDelimiter
        '
        Me.SourceDelimiter.Location = New System.Drawing.Point(6, 48)
        Me.SourceDelimiter.Name = "SourceDelimiter"
        Me.SourceDelimiter.Size = New System.Drawing.Size(29, 20)
        Me.SourceDelimiter.TabIndex = 10
        '
        'SourcePath
        '
        Me.SourcePath.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SourcePath.Location = New System.Drawing.Point(6, 19)
        Me.SourcePath.Name = "SourcePath"
        Me.SourcePath.Size = New System.Drawing.Size(402, 20)
        Me.SourcePath.TabIndex = 6
        '
        'SourceBrowse
        '
        Me.SourceBrowse.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SourceBrowse.Location = New System.Drawing.Point(414, 17)
        Me.SourceBrowse.Name = "SourceBrowse"
        Me.SourceBrowse.Size = New System.Drawing.Size(22, 23)
        Me.SourceBrowse.TabIndex = 5
        Me.SourceBrowse.Text = "..."
        Me.SourceBrowse.UseVisualStyleBackColor = True
        '
        'TargetGB
        '
        Me.TargetGB.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TargetGB.Controls.Add(Me.cbQuotes)
        Me.TargetGB.Controls.Add(Me.TargetHeader)
        Me.TargetGB.Controls.Add(Me.Convert)
        Me.TargetGB.Controls.Add(Me.label1)
        Me.TargetGB.Controls.Add(Me.TargetDelimiter)
        Me.TargetGB.Enabled = False
        Me.TargetGB.Location = New System.Drawing.Point(22, 464)
        Me.TargetGB.Name = "TargetGB"
        Me.TargetGB.Size = New System.Drawing.Size(447, 50)
        Me.TargetGB.TabIndex = 13
        Me.TargetGB.TabStop = False
        Me.TargetGB.Text = "Target File"
        '
        'cbQuotes
        '
        Me.cbQuotes.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.cbQuotes.AutoSize = True
        Me.cbQuotes.Location = New System.Drawing.Point(226, 19)
        Me.cbQuotes.Name = "cbQuotes"
        Me.cbQuotes.Size = New System.Drawing.Size(82, 17)
        Me.cbQuotes.TabIndex = 14
        Me.cbQuotes.Text = "Use Quotes"
        Me.cbQuotes.UseVisualStyleBackColor = True
        '
        'TargetHeader
        '
        Me.TargetHeader.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.TargetHeader.AutoSize = True
        Me.TargetHeader.Location = New System.Drawing.Point(6, 19)
        Me.TargetHeader.Name = "TargetHeader"
        Me.TargetHeader.Size = New System.Drawing.Size(86, 17)
        Me.TargetHeader.TabIndex = 13
        Me.TargetHeader.Text = "Header Row"
        Me.TargetHeader.UseVisualStyleBackColor = True
        '
        'Convert
        '
        Me.Convert.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Convert.Location = New System.Drawing.Point(366, 15)
        Me.Convert.Name = "Convert"
        Me.Convert.Size = New System.Drawing.Size(75, 23)
        Me.Convert.TabIndex = 12
        Me.Convert.Text = "Convert"
        Me.Convert.UseVisualStyleBackColor = True
        '
        'label1
        '
        Me.label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.label1.AutoSize = True
        Me.label1.Location = New System.Drawing.Point(144, 20)
        Me.label1.Name = "label1"
        Me.label1.Size = New System.Drawing.Size(47, 13)
        Me.label1.TabIndex = 11
        Me.label1.Text = "Delimiter"
        '
        'ColumnGrid
        '
        Me.ColumnGrid.AllowUserToAddRows = False
        Me.ColumnGrid.AllowUserToDeleteRows = False
        Me.ColumnGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ColumnGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ColumnGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.IsPivot, Me.Column})
        Me.ColumnGrid.Location = New System.Drawing.Point(22, 94)
        Me.ColumnGrid.MultiSelect = False
        Me.ColumnGrid.Name = "ColumnGrid"
        Me.ColumnGrid.RowHeadersVisible = False
        Me.ColumnGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ColumnGrid.Size = New System.Drawing.Size(447, 364)
        Me.ColumnGrid.TabIndex = 12
        '
        'IsPivot
        '
        Me.IsPivot.DataPropertyName = "IsPivot"
        Me.IsPivot.HeaderText = "Pivot"
        Me.IsPivot.MinimumWidth = 50
        Me.IsPivot.Name = "IsPivot"
        Me.IsPivot.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.IsPivot.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.IsPivot.Width = 50
        '
        'Column
        '
        Me.Column.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.Column.DataPropertyName = "ColumnName"
        Me.Column.HeaderText = "Column Name"
        Me.Column.Name = "Column"
        Me.Column.ReadOnly = True
        '
        'PivotFileSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.groupBox1)
        Me.Controls.Add(Me.TargetGB)
        Me.Controls.Add(Me.ColumnGrid)
        Me.Name = "PivotFileSection"
        Me.Size = New System.Drawing.Size(491, 520)
        Me.groupBox1.ResumeLayout(False)
        Me.groupBox1.PerformLayout()
        Me.TargetGB.ResumeLayout(False)
        Me.TargetGB.PerformLayout()
        CType(Me.ColumnGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Private WithEvents LoadSource As System.Windows.Forms.Button
    Private WithEvents TargetDelimiter As System.Windows.Forms.TextBox
    Private WithEvents groupBox1 As System.Windows.Forms.GroupBox
    Private WithEvents label2 As System.Windows.Forms.Label
    Private WithEvents SourceDelimiter As System.Windows.Forms.TextBox
    Private WithEvents SourcePath As System.Windows.Forms.TextBox
    Private WithEvents SourceBrowse As System.Windows.Forms.Button
    Private WithEvents TargetGB As System.Windows.Forms.GroupBox
    Private WithEvents TargetHeader As System.Windows.Forms.CheckBox
    Private WithEvents Convert As System.Windows.Forms.Button
    Private WithEvents label1 As System.Windows.Forms.Label
    Private WithEvents ColumnGrid As System.Windows.Forms.DataGridView
    Friend WithEvents cbQuotes As System.Windows.Forms.CheckBox
    Friend WithEvents IsPivot As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents Column As System.Windows.Forms.DataGridViewTextBoxColumn

End Class
