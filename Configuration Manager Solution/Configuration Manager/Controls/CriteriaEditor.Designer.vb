<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CriteriaEditor
    Inherits System.Windows.Forms.UserControl

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(CriteriaEditor))
        Me.SplitMain = New System.Windows.Forms.SplitContainer
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.ClausesDeleteButton = New System.Windows.Forms.Button
        Me.ClausesAddButton = New System.Windows.Forms.Button
        Me.PhraseNameLabel = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.ClausesDataGrid = New System.Windows.Forms.DataGridView
        Me.FieldColumn = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.OperatorColumn = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.ParameterColumn = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.PhrasesListView = New System.Windows.Forms.ListView
        Me.PhraseColumn = New System.Windows.Forms.ColumnHeader
        Me.PhrasesImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.PhrasesDeleteButton = New System.Windows.Forms.Button
        Me.PhrasesAddButton = New System.Windows.Forms.Button
        Me.RuleNameTextbox = New System.Windows.Forms.TextBox
        Me.RuleNameLabel = New System.Windows.Forms.Label
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.CriteriaStringTextBox = New System.Windows.Forms.TextBox
        Me.ErrorControl = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.SplitMain.Panel1.SuspendLayout()
        Me.SplitMain.Panel2.SuspendLayout()
        Me.SplitMain.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.ClausesDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        CType(Me.ErrorControl, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SplitMain
        '
        Me.SplitMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitMain.Location = New System.Drawing.Point(0, 0)
        Me.SplitMain.Name = "SplitMain"
        Me.SplitMain.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitMain.Panel1
        '
        Me.SplitMain.Panel1.Controls.Add(Me.GroupBox2)
        Me.SplitMain.Panel1.Controls.Add(Me.GroupBox1)
        Me.SplitMain.Panel1MinSize = 144
        '
        'SplitMain.Panel2
        '
        Me.SplitMain.Panel2.Controls.Add(Me.GroupBox3)
        Me.SplitMain.Panel2MinSize = 75
        Me.SplitMain.Size = New System.Drawing.Size(518, 352)
        Me.SplitMain.SplitterDistance = 232
        Me.SplitMain.TabIndex = 0
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.ClausesDeleteButton)
        Me.GroupBox2.Controls.Add(Me.ClausesAddButton)
        Me.GroupBox2.Controls.Add(Me.PhraseNameLabel)
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.Controls.Add(Me.ClausesDataGrid)
        Me.GroupBox2.Location = New System.Drawing.Point(131, 0)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(381, 226)
        Me.GroupBox2.TabIndex = 6
        Me.GroupBox2.TabStop = False
        '
        'ClausesDeleteButton
        '
        Me.ClausesDeleteButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClausesDeleteButton.Location = New System.Drawing.Point(326, 197)
        Me.ClausesDeleteButton.Name = "ClausesDeleteButton"
        Me.ClausesDeleteButton.Size = New System.Drawing.Size(49, 23)
        Me.ClausesDeleteButton.TabIndex = 10
        Me.ClausesDeleteButton.Text = "Delete"
        Me.ClausesDeleteButton.UseVisualStyleBackColor = True
        '
        'ClausesAddButton
        '
        Me.ClausesAddButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClausesAddButton.Location = New System.Drawing.Point(271, 197)
        Me.ClausesAddButton.Name = "ClausesAddButton"
        Me.ClausesAddButton.Size = New System.Drawing.Size(49, 23)
        Me.ClausesAddButton.TabIndex = 9
        Me.ClausesAddButton.Text = "Add"
        Me.ClausesAddButton.UseVisualStyleBackColor = True
        '
        'PhraseNameLabel
        '
        Me.PhraseNameLabel.AutoSize = True
        Me.PhraseNameLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PhraseNameLabel.Location = New System.Drawing.Point(53, 11)
        Me.PhraseNameLabel.Name = "PhraseNameLabel"
        Me.PhraseNameLabel.Size = New System.Drawing.Size(0, 13)
        Me.PhraseNameLabel.TabIndex = 9
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(3, 11)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(44, 13)
        Me.Label2.TabIndex = 7
        Me.Label2.Text = "Phrase:"
        '
        'ClausesDataGrid
        '
        Me.ClausesDataGrid.AllowUserToAddRows = False
        Me.ClausesDataGrid.AllowUserToDeleteRows = False
        Me.ClausesDataGrid.AllowUserToResizeRows = False
        Me.ClausesDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClausesDataGrid.BackgroundColor = System.Drawing.SystemColors.Window
        Me.ClausesDataGrid.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.ClausesDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ClausesDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.FieldColumn, Me.OperatorColumn, Me.ParameterColumn})
        Me.ClausesDataGrid.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter
        Me.ClausesDataGrid.Location = New System.Drawing.Point(6, 27)
        Me.ClausesDataGrid.MultiSelect = False
        Me.ClausesDataGrid.Name = "ClausesDataGrid"
        Me.ClausesDataGrid.RowHeadersWidth = 56
        Me.ClausesDataGrid.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing
        Me.ClausesDataGrid.Size = New System.Drawing.Size(369, 164)
        Me.ClausesDataGrid.TabIndex = 0
        '
        'FieldColumn
        '
        Me.FieldColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.FieldColumn.HeaderText = "Field"
        Me.FieldColumn.MinimumWidth = 136
        Me.FieldColumn.Name = "FieldColumn"
        Me.FieldColumn.Width = 136
        '
        'OperatorColumn
        '
        Me.OperatorColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells
        Me.OperatorColumn.HeaderText = "Operator"
        Me.OperatorColumn.MinimumWidth = 84
        Me.OperatorColumn.Name = "OperatorColumn"
        Me.OperatorColumn.Width = 84
        '
        'ParameterColumn
        '
        Me.ParameterColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill
        Me.ParameterColumn.HeaderText = "Parameter"
        Me.ParameterColumn.MinimumWidth = 110
        Me.ParameterColumn.Name = "ParameterColumn"
        Me.ParameterColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.PhrasesListView)
        Me.GroupBox1.Controls.Add(Me.PhrasesDeleteButton)
        Me.GroupBox1.Controls.Add(Me.PhrasesAddButton)
        Me.GroupBox1.Controls.Add(Me.RuleNameTextbox)
        Me.GroupBox1.Controls.Add(Me.RuleNameLabel)
        Me.GroupBox1.Location = New System.Drawing.Point(6, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(116, 226)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'PhrasesListView
        '
        Me.PhrasesListView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PhrasesListView.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.PhraseColumn})
        Me.PhrasesListView.FullRowSelect = True
        Me.PhrasesListView.GridLines = True
        Me.PhrasesListView.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable
        Me.PhrasesListView.HideSelection = False
        Me.PhrasesListView.Location = New System.Drawing.Point(6, 54)
        Me.PhrasesListView.MultiSelect = False
        Me.PhrasesListView.Name = "PhrasesListView"
        Me.PhrasesListView.ShowItemToolTips = True
        Me.PhrasesListView.Size = New System.Drawing.Size(104, 137)
        Me.PhrasesListView.SmallImageList = Me.PhrasesImageList
        Me.PhrasesListView.TabIndex = 3
        Me.PhrasesListView.UseCompatibleStateImageBehavior = False
        Me.PhrasesListView.View = System.Windows.Forms.View.Details
        '
        'PhraseColumn
        '
        Me.PhraseColumn.Text = "Phrases"
        Me.PhraseColumn.Width = 82
        '
        'PhrasesImageList
        '
        Me.PhrasesImageList.ImageStream = CType(resources.GetObject("PhrasesImageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.PhrasesImageList.TransparentColor = System.Drawing.Color.Black
        Me.PhrasesImageList.Images.SetKeyName(0, "Error")
        '
        'PhrasesDeleteButton
        '
        Me.PhrasesDeleteButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PhrasesDeleteButton.Location = New System.Drawing.Point(61, 197)
        Me.PhrasesDeleteButton.Name = "PhrasesDeleteButton"
        Me.PhrasesDeleteButton.Size = New System.Drawing.Size(49, 23)
        Me.PhrasesDeleteButton.TabIndex = 5
        Me.PhrasesDeleteButton.Text = "Delete"
        Me.PhrasesDeleteButton.UseVisualStyleBackColor = True
        '
        'PhrasesAddButton
        '
        Me.PhrasesAddButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PhrasesAddButton.Location = New System.Drawing.Point(6, 197)
        Me.PhrasesAddButton.Name = "PhrasesAddButton"
        Me.PhrasesAddButton.Size = New System.Drawing.Size(49, 23)
        Me.PhrasesAddButton.TabIndex = 4
        Me.PhrasesAddButton.Text = "Add"
        Me.PhrasesAddButton.UseVisualStyleBackColor = True
        '
        'RuleNameTextbox
        '
        Me.RuleNameTextbox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ErrorControl.SetIconPadding(Me.RuleNameTextbox, -18)
        Me.RuleNameTextbox.Location = New System.Drawing.Point(6, 27)
        Me.RuleNameTextbox.MaxLength = 8
        Me.RuleNameTextbox.Name = "RuleNameTextbox"
        Me.RuleNameTextbox.Size = New System.Drawing.Size(104, 21)
        Me.RuleNameTextbox.TabIndex = 2
        '
        'RuleNameLabel
        '
        Me.RuleNameLabel.AutoSize = True
        Me.RuleNameLabel.Location = New System.Drawing.Point(3, 11)
        Me.RuleNameLabel.Name = "RuleNameLabel"
        Me.RuleNameLabel.Size = New System.Drawing.Size(62, 13)
        Me.RuleNameLabel.TabIndex = 1
        Me.RuleNameLabel.Text = "Rule Name:"
        '
        'GroupBox3
        '
        Me.GroupBox3.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox3.Controls.Add(Me.Label3)
        Me.GroupBox3.Controls.Add(Me.CriteriaStringTextBox)
        Me.GroupBox3.Location = New System.Drawing.Point(6, -6)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(506, 116)
        Me.GroupBox3.TabIndex = 11
        Me.GroupBox3.TabStop = False
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(3, 11)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(77, 13)
        Me.Label3.TabIndex = 12
        Me.Label3.Text = "Criteria String:"
        '
        'CriteriaStringTextBox
        '
        Me.CriteriaStringTextBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CriteriaStringTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.CriteriaStringTextBox.Location = New System.Drawing.Point(6, 27)
        Me.CriteriaStringTextBox.Multiline = True
        Me.CriteriaStringTextBox.Name = "CriteriaStringTextBox"
        Me.CriteriaStringTextBox.ReadOnly = True
        Me.CriteriaStringTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.CriteriaStringTextBox.Size = New System.Drawing.Size(494, 83)
        Me.CriteriaStringTextBox.TabIndex = 13
        '
        'ErrorControl
        '
        Me.ErrorControl.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink
        Me.ErrorControl.ContainerControl = Me
        '
        'CriteriaEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitMain)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "CriteriaEditor"
        Me.Size = New System.Drawing.Size(518, 352)
        Me.SplitMain.Panel1.ResumeLayout(False)
        Me.SplitMain.Panel2.ResumeLayout(False)
        Me.SplitMain.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        CType(Me.ClausesDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        CType(Me.ErrorControl, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SplitMain As System.Windows.Forms.SplitContainer
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents CriteriaStringTextBox As System.Windows.Forms.TextBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents PhrasesDeleteButton As System.Windows.Forms.Button
    Friend WithEvents PhrasesAddButton As System.Windows.Forms.Button
    Friend WithEvents RuleNameTextbox As System.Windows.Forms.TextBox
    Friend WithEvents RuleNameLabel As System.Windows.Forms.Label
    Friend WithEvents PhraseNameLabel As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ClausesDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents ClausesDeleteButton As System.Windows.Forms.Button
    Friend WithEvents ClausesAddButton As System.Windows.Forms.Button
    Friend WithEvents PhrasesListView As System.Windows.Forms.ListView
    Friend WithEvents PhraseColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents PhrasesImageList As System.Windows.Forms.ImageList
    Friend WithEvents FieldColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents OperatorColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents ParameterColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents ErrorControl As System.Windows.Forms.ErrorProvider

End Class
