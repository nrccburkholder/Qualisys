<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CreateDefinitionControl
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(CreateDefinitionControl))
        Me.CreateDefinitionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ToolStrip2 = New System.Windows.Forms.ToolStrip
        Me.CreateDefinitionButton = New System.Windows.Forms.ToolStripSplitButton
        Me.CreateDefinitionAndExportIndividual = New System.Windows.Forms.ToolStripMenuItem
        Me.CreateDefinitionAndExportCombined = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator7 = New System.Windows.Forms.ToolStripSeparator
        Me.NewExportCountLabel = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.PredefineButton = New System.Windows.Forms.ToolStripButton
        Me.InputPanel = New System.Windows.Forms.TableLayoutPanel
        Me.NameLabel = New System.Windows.Forms.Label
        Me.YearLabel = New System.Windows.Forms.Label
        Me.NewExportName = New System.Windows.Forms.TextBox
        Me.YearList = New System.Windows.Forms.ComboBox
        Me.StartDateLabel = New System.Windows.Forms.Label
        Me.MonthLabel = New System.Windows.Forms.Label
        Me.NewExportStartDate = New System.Windows.Forms.DateTimePicker
        Me.MonthList = New System.Windows.Forms.ComboBox
        Me.EndDateLabel = New System.Windows.Forms.Label
        Me.NewExportEndDate = New System.Windows.Forms.DateTimePicker
        Me.CreateDefinitionPanel.SuspendLayout()
        Me.ToolStrip2.SuspendLayout()
        Me.InputPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'CreateDefinitionPanel
        '
        Me.CreateDefinitionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.CreateDefinitionPanel.Caption = "Create New Export Definition"
        Me.CreateDefinitionPanel.Controls.Add(Me.ToolStrip2)
        Me.CreateDefinitionPanel.Controls.Add(Me.InputPanel)
        Me.CreateDefinitionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CreateDefinitionPanel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CreateDefinitionPanel.Location = New System.Drawing.Point(0, 0)
        Me.CreateDefinitionPanel.Name = "CreateDefinitionPanel"
        Me.CreateDefinitionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.CreateDefinitionPanel.ShowCaption = True
        Me.CreateDefinitionPanel.Size = New System.Drawing.Size(494, 198)
        Me.CreateDefinitionPanel.TabIndex = 5
        '
        'ToolStrip2
        '
        Me.ToolStrip2.CanOverflow = False
        Me.ToolStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateDefinitionButton, Me.ToolStripSeparator7, Me.NewExportCountLabel, Me.ToolStripSeparator1, Me.PredefineButton})
        Me.ToolStrip2.Location = New System.Drawing.Point(1, 27)
        Me.ToolStrip2.Name = "ToolStrip2"
        Me.ToolStrip2.Size = New System.Drawing.Size(492, 25)
        Me.ToolStrip2.TabIndex = 13
        Me.ToolStrip2.Text = "ToolStrip2"
        '
        'CreateDefinitionButton
        '
        Me.CreateDefinitionButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.CreateDefinitionButton.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CreateDefinitionAndExportIndividual, Me.CreateDefinitionAndExportCombined})
        Me.CreateDefinitionButton.Enabled = False
        Me.CreateDefinitionButton.Image = CType(resources.GetObject("CreateDefinitionButton.Image"), System.Drawing.Image)
        Me.CreateDefinitionButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.CreateDefinitionButton.MergeAction = System.Windows.Forms.MergeAction.MatchOnly
        Me.CreateDefinitionButton.Name = "CreateDefinitionButton"
        Me.CreateDefinitionButton.Size = New System.Drawing.Size(118, 22)
        Me.CreateDefinitionButton.Text = "Create Defiinition..."
        '
        'CreateDefinitionAndExportIndividual
        '
        Me.CreateDefinitionAndExportIndividual.Name = "CreateDefinitionAndExportIndividual"
        Me.CreateDefinitionAndExportIndividual.Size = New System.Drawing.Size(326, 22)
        Me.CreateDefinitionAndExportIndividual.Text = "Create Defiinition and Export to individual file(s)..."
        '
        'CreateDefinitionAndExportCombined
        '
        Me.CreateDefinitionAndExportCombined.Name = "CreateDefinitionAndExportCombined"
        Me.CreateDefinitionAndExportCombined.Size = New System.Drawing.Size(326, 22)
        Me.CreateDefinitionAndExportCombined.Text = "Create Defiinition and Export to combined file..."
        '
        'ToolStripSeparator7
        '
        Me.ToolStripSeparator7.Name = "ToolStripSeparator7"
        Me.ToolStripSeparator7.Size = New System.Drawing.Size(6, 25)
        '
        'NewExportCountLabel
        '
        Me.NewExportCountLabel.Name = "NewExportCountLabel"
        Me.NewExportCountLabel.Size = New System.Drawing.Size(185, 22)
        Me.NewExportCountLabel.Text = "0 Export Definition(s) will be created."
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'PredefineButton
        '
        Me.PredefineButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.PredefineButton.BackColor = System.Drawing.SystemColors.Control
        Me.PredefineButton.Image = CType(resources.GetObject("PredefineButton.Image"), System.Drawing.Image)
        Me.PredefineButton.ImageTransparentColor = System.Drawing.SystemColors.GradientInactiveCaption
        Me.PredefineButton.Name = "PredefineButton"
        Me.PredefineButton.Size = New System.Drawing.Size(125, 22)
        Me.PredefineButton.Text = "Predefine Exports..."
        '
        'InputPanel
        '
        Me.InputPanel.AutoSize = True
        Me.InputPanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.InputPanel.ColumnCount = 2
        Me.InputPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 73.0!))
        Me.InputPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 153.0!))
        Me.InputPanel.Controls.Add(Me.NameLabel, 0, 0)
        Me.InputPanel.Controls.Add(Me.YearLabel, 0, 4)
        Me.InputPanel.Controls.Add(Me.NewExportName, 1, 0)
        Me.InputPanel.Controls.Add(Me.YearList, 1, 4)
        Me.InputPanel.Controls.Add(Me.StartDateLabel, 0, 1)
        Me.InputPanel.Controls.Add(Me.MonthLabel, 0, 3)
        Me.InputPanel.Controls.Add(Me.NewExportStartDate, 1, 1)
        Me.InputPanel.Controls.Add(Me.MonthList, 1, 3)
        Me.InputPanel.Controls.Add(Me.EndDateLabel, 0, 2)
        Me.InputPanel.Controls.Add(Me.NewExportEndDate, 1, 2)
        Me.InputPanel.Location = New System.Drawing.Point(4, 55)
        Me.InputPanel.Name = "InputPanel"
        Me.InputPanel.RowCount = 5
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.RowStyles.Add(New System.Windows.Forms.RowStyle)
        Me.InputPanel.Size = New System.Drawing.Size(226, 135)
        Me.InputPanel.TabIndex = 20
        '
        'NameLabel
        '
        Me.NameLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.NameLabel.AutoSize = True
        Me.NameLabel.Location = New System.Drawing.Point(3, 7)
        Me.NameLabel.Name = "NameLabel"
        Me.NameLabel.Size = New System.Drawing.Size(34, 13)
        Me.NameLabel.TabIndex = 3
        Me.NameLabel.Text = "Name"
        Me.NameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'YearLabel
        '
        Me.YearLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.YearLabel.AutoSize = True
        Me.YearLabel.Location = New System.Drawing.Point(3, 115)
        Me.YearLabel.Name = "YearLabel"
        Me.YearLabel.Size = New System.Drawing.Size(29, 13)
        Me.YearLabel.TabIndex = 19
        Me.YearLabel.Text = "Year"
        Me.YearLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'NewExportName
        '
        Me.NewExportName.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NewExportName.Location = New System.Drawing.Point(76, 3)
        Me.NewExportName.Name = "NewExportName"
        Me.NewExportName.Size = New System.Drawing.Size(147, 21)
        Me.NewExportName.TabIndex = 4
        '
        'YearList
        '
        Me.YearList.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.YearList.DropDownHeight = 158
        Me.YearList.FormattingEnabled = True
        Me.YearList.IntegralHeight = False
        Me.YearList.Location = New System.Drawing.Point(76, 111)
        Me.YearList.Name = "YearList"
        Me.YearList.Size = New System.Drawing.Size(147, 21)
        Me.YearList.TabIndex = 16
        '
        'StartDateLabel
        '
        Me.StartDateLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.StartDateLabel.AutoSize = True
        Me.StartDateLabel.Location = New System.Drawing.Point(3, 34)
        Me.StartDateLabel.Name = "StartDateLabel"
        Me.StartDateLabel.Size = New System.Drawing.Size(57, 13)
        Me.StartDateLabel.TabIndex = 3
        Me.StartDateLabel.Text = "Start Date"
        Me.StartDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MonthLabel
        '
        Me.MonthLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.MonthLabel.AutoSize = True
        Me.MonthLabel.Location = New System.Drawing.Point(3, 88)
        Me.MonthLabel.Name = "MonthLabel"
        Me.MonthLabel.Size = New System.Drawing.Size(37, 13)
        Me.MonthLabel.TabIndex = 18
        Me.MonthLabel.Text = "Month"
        Me.MonthLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'NewExportStartDate
        '
        Me.NewExportStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NewExportStartDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.NewExportStartDate.Location = New System.Drawing.Point(76, 30)
        Me.NewExportStartDate.Name = "NewExportStartDate"
        Me.NewExportStartDate.Size = New System.Drawing.Size(147, 21)
        Me.NewExportStartDate.TabIndex = 5
        '
        'MonthList
        '
        Me.MonthList.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MonthList.DropDownHeight = 158
        Me.MonthList.FormattingEnabled = True
        Me.MonthList.IntegralHeight = False
        Me.MonthList.Location = New System.Drawing.Point(76, 84)
        Me.MonthList.Name = "MonthList"
        Me.MonthList.Size = New System.Drawing.Size(147, 21)
        Me.MonthList.TabIndex = 15
        '
        'EndDateLabel
        '
        Me.EndDateLabel.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.EndDateLabel.AutoSize = True
        Me.EndDateLabel.Location = New System.Drawing.Point(3, 61)
        Me.EndDateLabel.Name = "EndDateLabel"
        Me.EndDateLabel.Size = New System.Drawing.Size(51, 13)
        Me.EndDateLabel.TabIndex = 3
        Me.EndDateLabel.Text = "End Date"
        Me.EndDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'NewExportEndDate
        '
        Me.NewExportEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NewExportEndDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.NewExportEndDate.Location = New System.Drawing.Point(76, 57)
        Me.NewExportEndDate.Name = "NewExportEndDate"
        Me.NewExportEndDate.Size = New System.Drawing.Size(147, 21)
        Me.NewExportEndDate.TabIndex = 6
        '
        'CreateDefinitionControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.CreateDefinitionPanel)
        Me.Name = "CreateDefinitionControl"
        Me.Size = New System.Drawing.Size(494, 198)
        Me.CreateDefinitionPanel.ResumeLayout(False)
        Me.CreateDefinitionPanel.PerformLayout()
        Me.ToolStrip2.ResumeLayout(False)
        Me.ToolStrip2.PerformLayout()
        Me.InputPanel.ResumeLayout(False)
        Me.InputPanel.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CreateDefinitionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ToolStrip2 As System.Windows.Forms.ToolStrip
    Friend WithEvents CreateDefinitionButton As System.Windows.Forms.ToolStripSplitButton
    Friend WithEvents CreateDefinitionAndExportIndividual As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CreateDefinitionAndExportCombined As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator7 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents NewExportCountLabel As System.Windows.Forms.ToolStripLabel
    Friend WithEvents NewExportEndDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents NewExportStartDate As System.Windows.Forms.DateTimePicker
    Friend WithEvents EndDateLabel As System.Windows.Forms.Label
    Friend WithEvents StartDateLabel As System.Windows.Forms.Label
    Friend WithEvents NewExportName As System.Windows.Forms.TextBox
    Friend WithEvents NameLabel As System.Windows.Forms.Label
    Friend WithEvents YearList As System.Windows.Forms.ComboBox
    Friend WithEvents MonthList As System.Windows.Forms.ComboBox
    Friend WithEvents MonthLabel As System.Windows.Forms.Label
    Friend WithEvents YearLabel As System.Windows.Forms.Label
    Friend WithEvents InputPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents PredefineButton As System.Windows.Forms.ToolStripButton

End Class
