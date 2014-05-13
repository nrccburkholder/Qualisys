<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StudySection
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
        Me.components = New System.ComponentModel.Container
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.WorkAreaPanel = New System.Windows.Forms.Panel
        Me.CopyDataStructureGroupBox = New System.Windows.Forms.GroupBox
        Me.CopyDataStructureBrowseButton = New System.Windows.Forms.Button
        Me.CopyDataStructureLabel = New System.Windows.Forms.Label
        Me.CopyDataStructureTextBox = New System.Windows.Forms.TextBox
        Me.AssociateSelectionGroupBox = New System.Windows.Forms.GroupBox
        Me.AssociateSelectionTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.AuthorizedAssociatePanel = New System.Windows.Forms.Panel
        Me.AuthorizedAssociateListBox = New System.Windows.Forms.ListBox
        Me.AuthorizedAssociateLabel = New System.Windows.Forms.Label
        Me.AvailableAssociatePanel = New System.Windows.Forms.Panel
        Me.AvailableAssociateListBox = New System.Windows.Forms.ListBox
        Me.AvailableAssociateLabel = New System.Windows.Forms.Label
        Me.AssociateSelectionButtonPanel = New System.Windows.Forms.Panel
        Me.AddAllButton = New System.Windows.Forms.Button
        Me.AddButton = New System.Windows.Forms.Button
        Me.RemoveAllButton = New System.Windows.Forms.Button
        Me.RemoveButton = New System.Windows.Forms.Button
        Me.StudyOwnerLabel = New System.Windows.Forms.Label
        Me.StudyOwnerComboBox = New System.Windows.Forms.ComboBox
        Me.InActivateCheckBox = New System.Windows.Forms.CheckBox
        Me.UseProperCaseCheckBox = New System.Windows.Forms.CheckBox
        Me.UseAddressCleaningCheckBox = New System.Windows.Forms.CheckBox
        Me.StudyDescriptionTextBox = New System.Windows.Forms.TextBox
        Me.StudyDescriptionLabel = New System.Windows.Forms.Label
        Me.StudyNameLabel = New System.Windows.Forms.Label
        Me.StudyNameTextBox = New System.Windows.Forms.TextBox
        Me.DateCreatedLabel = New System.Windows.Forms.Label
        Me.DateCreatedTextBox = New System.Windows.Forms.TextBox
        Me.StudyEmployeeBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.StudyOwnerBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.NRCEmployeeBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.BottomPanel.SuspendLayout()
        Me.WorkAreaPanel.SuspendLayout()
        Me.CopyDataStructureGroupBox.SuspendLayout()
        Me.AssociateSelectionGroupBox.SuspendLayout()
        Me.AssociateSelectionTableLayoutPanel.SuspendLayout()
        Me.AuthorizedAssociatePanel.SuspendLayout()
        Me.AvailableAssociatePanel.SuspendLayout()
        Me.AssociateSelectionButtonPanel.SuspendLayout()
        CType(Me.StudyEmployeeBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.StudyOwnerBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.NRCEmployeeBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = "Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(721, 20)
        Me.InformationBar.TabIndex = 0
        Me.InformationBar.TabStop = False
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 590)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(721, 35)
        Me.BottomPanel.TabIndex = 2
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(556, 5)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(637, 4)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.Controls.Add(Me.CopyDataStructureGroupBox)
        Me.WorkAreaPanel.Controls.Add(Me.AssociateSelectionGroupBox)
        Me.WorkAreaPanel.Controls.Add(Me.InActivateCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.UseProperCaseCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.UseAddressCleaningCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.StudyDescriptionTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.StudyDescriptionLabel)
        Me.WorkAreaPanel.Controls.Add(Me.StudyNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.StudyNameTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.DateCreatedLabel)
        Me.WorkAreaPanel.Controls.Add(Me.DateCreatedTextBox)
        Me.WorkAreaPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 20)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(721, 570)
        Me.WorkAreaPanel.TabIndex = 1
        '
        'CopyDataStructureGroupBox
        '
        Me.CopyDataStructureGroupBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.CopyDataStructureGroupBox.Controls.Add(Me.CopyDataStructureBrowseButton)
        Me.CopyDataStructureGroupBox.Controls.Add(Me.CopyDataStructureLabel)
        Me.CopyDataStructureGroupBox.Controls.Add(Me.CopyDataStructureTextBox)
        Me.CopyDataStructureGroupBox.Location = New System.Drawing.Point(10, 510)
        Me.CopyDataStructureGroupBox.Name = "CopyDataStructureGroupBox"
        Me.CopyDataStructureGroupBox.Size = New System.Drawing.Size(544, 51)
        Me.CopyDataStructureGroupBox.TabIndex = 10
        Me.CopyDataStructureGroupBox.TabStop = False
        Me.CopyDataStructureGroupBox.Text = "Copy Data Structure"
        '
        'CopyDataStructureBrowseButton
        '
        Me.CopyDataStructureBrowseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CopyDataStructureBrowseButton.Location = New System.Drawing.Point(494, 18)
        Me.CopyDataStructureBrowseButton.Name = "CopyDataStructureBrowseButton"
        Me.CopyDataStructureBrowseButton.Size = New System.Drawing.Size(41, 22)
        Me.CopyDataStructureBrowseButton.TabIndex = 2
        Me.CopyDataStructureBrowseButton.Text = "..."
        Me.CopyDataStructureBrowseButton.UseVisualStyleBackColor = True
        '
        'CopyDataStructureLabel
        '
        Me.CopyDataStructureLabel.AutoSize = True
        Me.CopyDataStructureLabel.Location = New System.Drawing.Point(6, 22)
        Me.CopyDataStructureLabel.Name = "CopyDataStructureLabel"
        Me.CopyDataStructureLabel.Size = New System.Drawing.Size(106, 13)
        Me.CopyDataStructureLabel.TabIndex = 0
        Me.CopyDataStructureLabel.Text = "Copy Structure From:"
        '
        'CopyDataStructureTextBox
        '
        Me.CopyDataStructureTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CopyDataStructureTextBox.Location = New System.Drawing.Point(126, 19)
        Me.CopyDataStructureTextBox.Name = "CopyDataStructureTextBox"
        Me.CopyDataStructureTextBox.ReadOnly = True
        Me.CopyDataStructureTextBox.Size = New System.Drawing.Size(366, 20)
        Me.CopyDataStructureTextBox.TabIndex = 1
        Me.CopyDataStructureTextBox.TabStop = False
        Me.CopyDataStructureTextBox.Text = "<Default Data Structure>"
        '
        'AssociateSelectionGroupBox
        '
        Me.AssociateSelectionGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.AssociateSelectionGroupBox.Controls.Add(Me.AssociateSelectionTableLayoutPanel)
        Me.AssociateSelectionGroupBox.Controls.Add(Me.StudyOwnerLabel)
        Me.AssociateSelectionGroupBox.Controls.Add(Me.StudyOwnerComboBox)
        Me.AssociateSelectionGroupBox.Location = New System.Drawing.Point(10, 192)
        Me.AssociateSelectionGroupBox.Name = "AssociateSelectionGroupBox"
        Me.AssociateSelectionGroupBox.Size = New System.Drawing.Size(544, 304)
        Me.AssociateSelectionGroupBox.TabIndex = 9
        Me.AssociateSelectionGroupBox.TabStop = False
        Me.AssociateSelectionGroupBox.Text = "Associate Selections"
        '
        'AssociateSelectionTableLayoutPanel
        '
        Me.AssociateSelectionTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AssociateSelectionTableLayoutPanel.ColumnCount = 3
        Me.AssociateSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.AssociateSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 50.0!))
        Me.AssociateSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.AssociateSelectionTableLayoutPanel.Controls.Add(Me.AuthorizedAssociatePanel, 2, 0)
        Me.AssociateSelectionTableLayoutPanel.Controls.Add(Me.AvailableAssociatePanel, 0, 0)
        Me.AssociateSelectionTableLayoutPanel.Controls.Add(Me.AssociateSelectionButtonPanel, 1, 1)
        Me.AssociateSelectionTableLayoutPanel.Location = New System.Drawing.Point(9, 46)
        Me.AssociateSelectionTableLayoutPanel.Name = "AssociateSelectionTableLayoutPanel"
        Me.AssociateSelectionTableLayoutPanel.RowCount = 3
        Me.AssociateSelectionTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.AssociateSelectionTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 125.0!))
        Me.AssociateSelectionTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.AssociateSelectionTableLayoutPanel.Size = New System.Drawing.Size(526, 249)
        Me.AssociateSelectionTableLayoutPanel.TabIndex = 2
        '
        'AuthorizedAssociatePanel
        '
        Me.AuthorizedAssociatePanel.Controls.Add(Me.AuthorizedAssociateListBox)
        Me.AuthorizedAssociatePanel.Controls.Add(Me.AuthorizedAssociateLabel)
        Me.AuthorizedAssociatePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AuthorizedAssociatePanel.Location = New System.Drawing.Point(291, 3)
        Me.AuthorizedAssociatePanel.Name = "AuthorizedAssociatePanel"
        Me.AssociateSelectionTableLayoutPanel.SetRowSpan(Me.AuthorizedAssociatePanel, 3)
        Me.AuthorizedAssociatePanel.Size = New System.Drawing.Size(232, 243)
        Me.AuthorizedAssociatePanel.TabIndex = 2
        '
        'AuthorizedAssociateListBox
        '
        Me.AuthorizedAssociateListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AuthorizedAssociateListBox.FormattingEnabled = True
        Me.AuthorizedAssociateListBox.IntegralHeight = False
        Me.AuthorizedAssociateListBox.Location = New System.Drawing.Point(0, 16)
        Me.AuthorizedAssociateListBox.Name = "AuthorizedAssociateListBox"
        Me.AuthorizedAssociateListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.AuthorizedAssociateListBox.Size = New System.Drawing.Size(235, 230)
        Me.AuthorizedAssociateListBox.TabIndex = 1
        '
        'AuthorizedAssociateLabel
        '
        Me.AuthorizedAssociateLabel.AutoSize = True
        Me.AuthorizedAssociateLabel.Location = New System.Drawing.Point(-1, 0)
        Me.AuthorizedAssociateLabel.Name = "AuthorizedAssociateLabel"
        Me.AuthorizedAssociateLabel.Size = New System.Drawing.Size(114, 13)
        Me.AuthorizedAssociateLabel.TabIndex = 0
        Me.AuthorizedAssociateLabel.Text = "Authorized Associates:"
        '
        'AvailableAssociatePanel
        '
        Me.AvailableAssociatePanel.Controls.Add(Me.AvailableAssociateListBox)
        Me.AvailableAssociatePanel.Controls.Add(Me.AvailableAssociateLabel)
        Me.AvailableAssociatePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AvailableAssociatePanel.Location = New System.Drawing.Point(3, 3)
        Me.AvailableAssociatePanel.Name = "AvailableAssociatePanel"
        Me.AssociateSelectionTableLayoutPanel.SetRowSpan(Me.AvailableAssociatePanel, 3)
        Me.AvailableAssociatePanel.Size = New System.Drawing.Size(232, 243)
        Me.AvailableAssociatePanel.TabIndex = 0
        '
        'AvailableAssociateListBox
        '
        Me.AvailableAssociateListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AvailableAssociateListBox.FormattingEnabled = True
        Me.AvailableAssociateListBox.IntegralHeight = False
        Me.AvailableAssociateListBox.Location = New System.Drawing.Point(-3, 16)
        Me.AvailableAssociateListBox.Name = "AvailableAssociateListBox"
        Me.AvailableAssociateListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.AvailableAssociateListBox.Size = New System.Drawing.Size(235, 230)
        Me.AvailableAssociateListBox.TabIndex = 1
        '
        'AvailableAssociateLabel
        '
        Me.AvailableAssociateLabel.AutoSize = True
        Me.AvailableAssociateLabel.Location = New System.Drawing.Point(-3, 0)
        Me.AvailableAssociateLabel.Name = "AvailableAssociateLabel"
        Me.AvailableAssociateLabel.Size = New System.Drawing.Size(107, 13)
        Me.AvailableAssociateLabel.TabIndex = 0
        Me.AvailableAssociateLabel.Text = "Available Associates:"
        '
        'AssociateSelectionButtonPanel
        '
        Me.AssociateSelectionButtonPanel.Controls.Add(Me.AddAllButton)
        Me.AssociateSelectionButtonPanel.Controls.Add(Me.AddButton)
        Me.AssociateSelectionButtonPanel.Controls.Add(Me.RemoveAllButton)
        Me.AssociateSelectionButtonPanel.Controls.Add(Me.RemoveButton)
        Me.AssociateSelectionButtonPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AssociateSelectionButtonPanel.Location = New System.Drawing.Point(241, 65)
        Me.AssociateSelectionButtonPanel.Name = "AssociateSelectionButtonPanel"
        Me.AssociateSelectionButtonPanel.Size = New System.Drawing.Size(44, 119)
        Me.AssociateSelectionButtonPanel.TabIndex = 1
        '
        'AddAllButton
        '
        Me.AddAllButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AddAllButton.Location = New System.Drawing.Point(0, 0)
        Me.AddAllButton.Name = "AddAllButton"
        Me.AddAllButton.Size = New System.Drawing.Size(44, 23)
        Me.AddAllButton.TabIndex = 0
        Me.AddAllButton.Text = ">>"
        Me.AddAllButton.UseVisualStyleBackColor = True
        '
        'AddButton
        '
        Me.AddButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AddButton.Location = New System.Drawing.Point(0, 29)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(44, 23)
        Me.AddButton.TabIndex = 1
        Me.AddButton.Text = ">"
        Me.AddButton.UseVisualStyleBackColor = True
        '
        'RemoveAllButton
        '
        Me.RemoveAllButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RemoveAllButton.Location = New System.Drawing.Point(0, 96)
        Me.RemoveAllButton.Name = "RemoveAllButton"
        Me.RemoveAllButton.Size = New System.Drawing.Size(44, 23)
        Me.RemoveAllButton.TabIndex = 3
        Me.RemoveAllButton.Text = "<<"
        Me.RemoveAllButton.UseVisualStyleBackColor = True
        '
        'RemoveButton
        '
        Me.RemoveButton.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RemoveButton.Location = New System.Drawing.Point(0, 67)
        Me.RemoveButton.Name = "RemoveButton"
        Me.RemoveButton.Size = New System.Drawing.Size(44, 23)
        Me.RemoveButton.TabIndex = 2
        Me.RemoveButton.Text = "<"
        Me.RemoveButton.UseVisualStyleBackColor = True
        '
        'StudyOwnerLabel
        '
        Me.StudyOwnerLabel.AutoSize = True
        Me.StudyOwnerLabel.Location = New System.Drawing.Point(6, 22)
        Me.StudyOwnerLabel.Name = "StudyOwnerLabel"
        Me.StudyOwnerLabel.Size = New System.Drawing.Size(71, 13)
        Me.StudyOwnerLabel.TabIndex = 0
        Me.StudyOwnerLabel.Text = "Study Owner:"
        '
        'StudyOwnerComboBox
        '
        Me.StudyOwnerComboBox.FormattingEnabled = True
        Me.StudyOwnerComboBox.Location = New System.Drawing.Point(126, 19)
        Me.StudyOwnerComboBox.Name = "StudyOwnerComboBox"
        Me.StudyOwnerComboBox.Size = New System.Drawing.Size(202, 21)
        Me.StudyOwnerComboBox.TabIndex = 1
        '
        'InActivateCheckBox
        '
        Me.InActivateCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.InActivateCheckBox.Location = New System.Drawing.Point(10, 160)
        Me.InActivateCheckBox.Name = "InActivateCheckBox"
        Me.InActivateCheckBox.Size = New System.Drawing.Size(146, 17)
        Me.InActivateCheckBox.TabIndex = 8
        Me.InActivateCheckBox.Text = "InActivate Study"
        Me.InActivateCheckBox.UseVisualStyleBackColor = True
        '
        'UseProperCaseCheckBox
        '
        Me.UseProperCaseCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.UseProperCaseCheckBox.Checked = True
        Me.UseProperCaseCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.UseProperCaseCheckBox.Location = New System.Drawing.Point(196, 137)
        Me.UseProperCaseCheckBox.Name = "UseProperCaseCheckBox"
        Me.UseProperCaseCheckBox.Size = New System.Drawing.Size(146, 20)
        Me.UseProperCaseCheckBox.TabIndex = 7
        Me.UseProperCaseCheckBox.Text = "Proper Case for Names:"
        Me.UseProperCaseCheckBox.UseVisualStyleBackColor = True
        '
        'UseAddressCleaningCheckBox
        '
        Me.UseAddressCleaningCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.UseAddressCleaningCheckBox.Checked = True
        Me.UseAddressCleaningCheckBox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.UseAddressCleaningCheckBox.Location = New System.Drawing.Point(10, 137)
        Me.UseAddressCleaningCheckBox.Name = "UseAddressCleaningCheckBox"
        Me.UseAddressCleaningCheckBox.Size = New System.Drawing.Size(146, 17)
        Me.UseAddressCleaningCheckBox.TabIndex = 6
        Me.UseAddressCleaningCheckBox.Text = "Uses Address Cleaning:"
        Me.UseAddressCleaningCheckBox.UseVisualStyleBackColor = True
        '
        'StudyDescriptionTextBox
        '
        Me.StudyDescriptionTextBox.Location = New System.Drawing.Point(140, 64)
        Me.StudyDescriptionTextBox.MaxLength = 255
        Me.StudyDescriptionTextBox.Multiline = True
        Me.StudyDescriptionTextBox.Name = "StudyDescriptionTextBox"
        Me.StudyDescriptionTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.StudyDescriptionTextBox.Size = New System.Drawing.Size(414, 67)
        Me.StudyDescriptionTextBox.TabIndex = 5
        '
        'StudyDescriptionLabel
        '
        Me.StudyDescriptionLabel.AutoSize = True
        Me.StudyDescriptionLabel.Location = New System.Drawing.Point(11, 67)
        Me.StudyDescriptionLabel.Name = "StudyDescriptionLabel"
        Me.StudyDescriptionLabel.Size = New System.Drawing.Size(93, 13)
        Me.StudyDescriptionLabel.TabIndex = 4
        Me.StudyDescriptionLabel.Text = "Study Description:"
        '
        'StudyNameLabel
        '
        Me.StudyNameLabel.AutoSize = True
        Me.StudyNameLabel.Location = New System.Drawing.Point(11, 41)
        Me.StudyNameLabel.Name = "StudyNameLabel"
        Me.StudyNameLabel.Size = New System.Drawing.Size(68, 13)
        Me.StudyNameLabel.TabIndex = 2
        Me.StudyNameLabel.Text = "Study Name:"
        '
        'StudyNameTextBox
        '
        Me.StudyNameTextBox.Location = New System.Drawing.Point(140, 38)
        Me.StudyNameTextBox.MaxLength = 10
        Me.StudyNameTextBox.Name = "StudyNameTextBox"
        Me.StudyNameTextBox.Size = New System.Drawing.Size(202, 20)
        Me.StudyNameTextBox.TabIndex = 3
        '
        'DateCreatedLabel
        '
        Me.DateCreatedLabel.AutoSize = True
        Me.DateCreatedLabel.Location = New System.Drawing.Point(11, 15)
        Me.DateCreatedLabel.Name = "DateCreatedLabel"
        Me.DateCreatedLabel.Size = New System.Drawing.Size(73, 13)
        Me.DateCreatedLabel.TabIndex = 0
        Me.DateCreatedLabel.Text = "Date Created:"
        '
        'DateCreatedTextBox
        '
        Me.DateCreatedTextBox.Location = New System.Drawing.Point(140, 12)
        Me.DateCreatedTextBox.Name = "DateCreatedTextBox"
        Me.DateCreatedTextBox.ReadOnly = True
        Me.DateCreatedTextBox.Size = New System.Drawing.Size(202, 20)
        Me.DateCreatedTextBox.TabIndex = 1
        Me.DateCreatedTextBox.TabStop = False
        '
        'StudyEmployeeBindingSource
        '
        Me.StudyEmployeeBindingSource.AllowNew = True
        Me.StudyEmployeeBindingSource.DataSource = GetType(Nrc.Qualisys.Library.STUDY_EMPLOYEE)
        '
        'StudyOwnerBindingSource
        '
        Me.StudyOwnerBindingSource.AllowNew = True
        Me.StudyOwnerBindingSource.DataSource = Me.StudyEmployeeBindingSource
        '
        'NRCEmployeeBindingSource
        '
        Me.NRCEmployeeBindingSource.DataSource = GetType(Nrc.Qualisys.Library.Employee)
        '
        'StudySection
        '
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Name = "StudySection"
        Me.Size = New System.Drawing.Size(721, 625)
        Me.BottomPanel.ResumeLayout(False)
        Me.WorkAreaPanel.ResumeLayout(False)
        Me.WorkAreaPanel.PerformLayout()
        Me.CopyDataStructureGroupBox.ResumeLayout(False)
        Me.CopyDataStructureGroupBox.PerformLayout()
        Me.AssociateSelectionGroupBox.ResumeLayout(False)
        Me.AssociateSelectionGroupBox.PerformLayout()
        Me.AssociateSelectionTableLayoutPanel.ResumeLayout(False)
        Me.AuthorizedAssociatePanel.ResumeLayout(False)
        Me.AuthorizedAssociatePanel.PerformLayout()
        Me.AvailableAssociatePanel.ResumeLayout(False)
        Me.AvailableAssociatePanel.PerformLayout()
        Me.AssociateSelectionButtonPanel.ResumeLayout(False)
        CType(Me.StudyEmployeeBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.StudyOwnerBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.NRCEmployeeBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents WorkAreaPanel As System.Windows.Forms.Panel
    Friend WithEvents StudyDescriptionLabel As System.Windows.Forms.Label
    Friend WithEvents StudyNameLabel As System.Windows.Forms.Label
    Friend WithEvents StudyNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DateCreatedLabel As System.Windows.Forms.Label
    Friend WithEvents DateCreatedTextBox As System.Windows.Forms.TextBox
    Friend WithEvents StudyDescriptionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents StudyOwnerLabel As System.Windows.Forms.Label
    Friend WithEvents AvailableAssociateLabel As System.Windows.Forms.Label
    Friend WithEvents AuthorizedAssociateLabel As System.Windows.Forms.Label
    Friend WithEvents AvailableAssociateListBox As System.Windows.Forms.ListBox
    Friend WithEvents AuthorizedAssociateListBox As System.Windows.Forms.ListBox
    Friend WithEvents UseProperCaseCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents UseAddressCleaningCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents StudyOwnerComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents AddAllButton As System.Windows.Forms.Button
    Friend WithEvents RemoveAllButton As System.Windows.Forms.Button
    Friend WithEvents RemoveButton As System.Windows.Forms.Button
    Friend WithEvents StudyEmployeeBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents StudyOwnerBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents NRCEmployeeBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents InActivateCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents CopyDataStructureGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents AssociateSelectionGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents AssociateSelectionTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents AuthorizedAssociatePanel As System.Windows.Forms.Panel
    Friend WithEvents AvailableAssociatePanel As System.Windows.Forms.Panel
    Friend WithEvents AssociateSelectionButtonPanel As System.Windows.Forms.Panel
    Friend WithEvents CopyDataStructureBrowseButton As System.Windows.Forms.Button
    Friend WithEvents CopyDataStructureLabel As System.Windows.Forms.Label
    Friend WithEvents CopyDataStructureTextBox As System.Windows.Forms.TextBox

End Class
