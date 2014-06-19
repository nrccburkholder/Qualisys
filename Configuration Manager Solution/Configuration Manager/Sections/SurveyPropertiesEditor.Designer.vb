<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SurveyPropertiesEditor
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
        Me.OKButton = New System.Windows.Forms.Button()
        Me.cnclButton = New System.Windows.Forms.Button()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.WorkAreaPanel = New System.Windows.Forms.Panel()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.QuestionaireTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.SurveySubTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.ContractedLanguagesListBox = New System.Windows.Forms.CheckedListBox()
        Me.ContractedLanguagesLabel = New System.Windows.Forms.Label()
        Me.InActivateLabel = New System.Windows.Forms.Label()
        Me.InActivateCheckBox = New System.Windows.Forms.CheckBox()
        Me.SampleEncounterDateComboBox = New System.Windows.Forms.ComboBox()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.EnforceSkipNoOption = New System.Windows.Forms.RadioButton()
        Me.EnforceSkipYesOption = New System.Windows.Forms.RadioButton()
        Me.lblEnforceSkipPattern = New System.Windows.Forms.Label()
        Me.StudyIdLabel = New System.Windows.Forms.TextBox()
        Me.SurveyIdLabel = New System.Windows.Forms.TextBox()
        Me.StudyNameLabel = New System.Windows.Forms.TextBox()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.Label18 = New System.Windows.Forms.Label()
        Me.ResurveyExcludionDaysPanel = New System.Windows.Forms.Panel()
        Me.ResurveyExcludionDaysNumeric = New System.Windows.Forms.NumericUpDown()
        Me.ResurveyExcludionDaysLabel = New System.Windows.Forms.Label()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.ResurveyMethodComboBox = New System.Windows.Forms.ComboBox()
        Me.lblResurveyMethod = New System.Windows.Forms.Label()
        Me.SamplingAlgorithmComboBox = New System.Windows.Forms.ComboBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.SurveyEndDatePicker = New System.Windows.Forms.DateTimePicker()
        Me.SurveyDescriptionTextBox = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.ContractNumberTextBox = New System.Windows.Forms.TextBox()
        Me.SurveyNameTextBox = New System.Windows.Forms.TextBox()
        Me.RespRateRecalcDaysNumeric = New System.Windows.Forms.NumericUpDown()
        Me.CutoffDateComboBox = New System.Windows.Forms.ComboBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.SurveyStartDatePicker = New System.Windows.Forms.DateTimePicker()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.SurveyTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.ContractNumberLabel = New System.Windows.Forms.Label()
        Me.SurveyNameLabel = New System.Windows.Forms.Label()
        Me.FacingNameTextBox = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar()
        Me.BottomPanel.SuspendLayout()
        Me.WorkAreaPanel.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.ResurveyExcludionDaysPanel.SuspendLayout()
        CType(Me.ResurveyExcludionDaysNumeric, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RespRateRecalcDaysNumeric, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(357, 4)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'cnclButton
        '
        Me.cnclButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cnclButton.Location = New System.Drawing.Point(438, 4)
        Me.cnclButton.Name = "cnclButton"
        Me.cnclButton.Size = New System.Drawing.Size(75, 23)
        Me.cnclButton.TabIndex = 1
        Me.cnclButton.Text = "Cancel"
        Me.cnclButton.UseVisualStyleBackColor = True
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Controls.Add(Me.cnclButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 576)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(522, 35)
        Me.BottomPanel.TabIndex = 2
        '
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.AutoScroll = True
        Me.WorkAreaPanel.Controls.Add(Me.Label6)
        Me.WorkAreaPanel.Controls.Add(Me.QuestionaireTypeComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label2)
        Me.WorkAreaPanel.Controls.Add(Me.SurveySubTypeComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.ContractedLanguagesListBox)
        Me.WorkAreaPanel.Controls.Add(Me.ContractedLanguagesLabel)
        Me.WorkAreaPanel.Controls.Add(Me.InActivateLabel)
        Me.WorkAreaPanel.Controls.Add(Me.InActivateCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.SampleEncounterDateComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label11)
        Me.WorkAreaPanel.Controls.Add(Me.Panel1)
        Me.WorkAreaPanel.Controls.Add(Me.StudyIdLabel)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyIdLabel)
        Me.WorkAreaPanel.Controls.Add(Me.StudyNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.Label17)
        Me.WorkAreaPanel.Controls.Add(Me.Label18)
        Me.WorkAreaPanel.Controls.Add(Me.ResurveyExcludionDaysPanel)
        Me.WorkAreaPanel.Controls.Add(Me.Label16)
        Me.WorkAreaPanel.Controls.Add(Me.ResurveyMethodComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.lblResurveyMethod)
        Me.WorkAreaPanel.Controls.Add(Me.SamplingAlgorithmComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label1)
        Me.WorkAreaPanel.Controls.Add(Me.Label7)
        Me.WorkAreaPanel.Controls.Add(Me.Label10)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyEndDatePicker)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyDescriptionTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label3)
        Me.WorkAreaPanel.Controls.Add(Me.Label4)
        Me.WorkAreaPanel.Controls.Add(Me.ContractNumberTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyNameTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.RespRateRecalcDaysNumeric)
        Me.WorkAreaPanel.Controls.Add(Me.CutoffDateComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label8)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyStartDatePicker)
        Me.WorkAreaPanel.Controls.Add(Me.Label9)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyTypeComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.ContractNumberLabel)
        Me.WorkAreaPanel.Controls.Add(Me.SurveyNameLabel)
        Me.WorkAreaPanel.Controls.Add(Me.FacingNameTextBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label5)
        Me.WorkAreaPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 20)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(522, 556)
        Me.WorkAreaPanel.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(5, 137)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(107, 13)
        Me.Label6.TabIndex = 38
        Me.Label6.Text = "Questionaire Version:"
        Me.Label6.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'QuestionaireTypeComboBox
        '
        Me.QuestionaireTypeComboBox.DisplayMember = "Label"
        Me.QuestionaireTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.QuestionaireTypeComboBox.FormattingEnabled = True
        Me.QuestionaireTypeComboBox.Location = New System.Drawing.Point(176, 134)
        Me.QuestionaireTypeComboBox.Name = "QuestionaireTypeComboBox"
        Me.QuestionaireTypeComboBox.Size = New System.Drawing.Size(306, 21)
        Me.QuestionaireTypeComboBox.TabIndex = 37
        Me.QuestionaireTypeComboBox.ValueMember = "Value"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(5, 110)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(92, 13)
        Me.Label2.TabIndex = 36
        Me.Label2.Text = "Survey Sub-Type:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveySubTypeComboBox
        '
        Me.SurveySubTypeComboBox.DisplayMember = "Label"
        Me.SurveySubTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SurveySubTypeComboBox.FormattingEnabled = True
        Me.SurveySubTypeComboBox.Location = New System.Drawing.Point(176, 107)
        Me.SurveySubTypeComboBox.Name = "SurveySubTypeComboBox"
        Me.SurveySubTypeComboBox.Size = New System.Drawing.Size(306, 21)
        Me.SurveySubTypeComboBox.TabIndex = 35
        Me.SurveySubTypeComboBox.ValueMember = "Value"
        '
        'ContractedLanguagesListBox
        '
        Me.ContractedLanguagesListBox.CheckOnClick = True
        Me.ContractedLanguagesListBox.FormattingEnabled = True
        Me.ContractedLanguagesListBox.Location = New System.Drawing.Point(314, 419)
        Me.ContractedLanguagesListBox.Name = "ContractedLanguagesListBox"
        Me.ContractedLanguagesListBox.Size = New System.Drawing.Size(168, 94)
        Me.ContractedLanguagesListBox.TabIndex = 34
        '
        'ContractedLanguagesLabel
        '
        Me.ContractedLanguagesLabel.AutoSize = True
        Me.ContractedLanguagesLabel.Location = New System.Drawing.Point(311, 403)
        Me.ContractedLanguagesLabel.Name = "ContractedLanguagesLabel"
        Me.ContractedLanguagesLabel.Size = New System.Drawing.Size(118, 13)
        Me.ContractedLanguagesLabel.TabIndex = 33
        Me.ContractedLanguagesLabel.Text = "Contracted Languages:"
        Me.ContractedLanguagesLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'InActivateLabel
        '
        Me.InActivateLabel.AutoSize = True
        Me.InActivateLabel.Location = New System.Drawing.Point(5, 484)
        Me.InActivateLabel.Name = "InActivateLabel"
        Me.InActivateLabel.Size = New System.Drawing.Size(94, 13)
        Me.InActivateLabel.TabIndex = 32
        Me.InActivateLabel.Text = "InActivate Survey:"
        '
        'InActivateCheckBox
        '
        Me.InActivateCheckBox.AutoSize = True
        Me.InActivateCheckBox.Location = New System.Drawing.Point(176, 484)
        Me.InActivateCheckBox.Name = "InActivateCheckBox"
        Me.InActivateCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.InActivateCheckBox.TabIndex = 31
        Me.InActivateCheckBox.UseVisualStyleBackColor = True
        '
        'SampleEncounterDateComboBox
        '
        Me.SampleEncounterDateComboBox.DisplayMember = "Label"
        Me.SampleEncounterDateComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SampleEncounterDateComboBox.FormattingEnabled = True
        Me.SampleEncounterDateComboBox.Location = New System.Drawing.Point(176, 349)
        Me.SampleEncounterDateComboBox.Name = "SampleEncounterDateComboBox"
        Me.SampleEncounterDateComboBox.Size = New System.Drawing.Size(306, 21)
        Me.SampleEncounterDateComboBox.TabIndex = 23
        Me.SampleEncounterDateComboBox.ValueMember = "Value"
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(5, 352)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(122, 13)
        Me.Label11.TabIndex = 22
        Me.Label11.Text = "Sample Encounter Field:"
        Me.Label11.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.EnforceSkipNoOption)
        Me.Panel1.Controls.Add(Me.EnforceSkipYesOption)
        Me.Panel1.Controls.Add(Me.lblEnforceSkipPattern)
        Me.Panel1.Location = New System.Drawing.Point(0, 272)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(483, 21)
        Me.Panel1.TabIndex = 17
        '
        'EnforceSkipNoOption
        '
        Me.EnforceSkipNoOption.AutoSize = True
        Me.EnforceSkipNoOption.Location = New System.Drawing.Point(225, 3)
        Me.EnforceSkipNoOption.Name = "EnforceSkipNoOption"
        Me.EnforceSkipNoOption.Size = New System.Drawing.Size(39, 17)
        Me.EnforceSkipNoOption.TabIndex = 2
        Me.EnforceSkipNoOption.Text = "No"
        Me.EnforceSkipNoOption.UseVisualStyleBackColor = True
        '
        'EnforceSkipYesOption
        '
        Me.EnforceSkipYesOption.AutoSize = True
        Me.EnforceSkipYesOption.Checked = True
        Me.EnforceSkipYesOption.Location = New System.Drawing.Point(176, 3)
        Me.EnforceSkipYesOption.Name = "EnforceSkipYesOption"
        Me.EnforceSkipYesOption.Size = New System.Drawing.Size(43, 17)
        Me.EnforceSkipYesOption.TabIndex = 1
        Me.EnforceSkipYesOption.TabStop = True
        Me.EnforceSkipYesOption.Text = "Yes"
        Me.EnforceSkipYesOption.UseVisualStyleBackColor = True
        '
        'lblEnforceSkipPattern
        '
        Me.lblEnforceSkipPattern.AutoSize = True
        Me.lblEnforceSkipPattern.Location = New System.Drawing.Point(5, 5)
        Me.lblEnforceSkipPattern.Name = "lblEnforceSkipPattern"
        Me.lblEnforceSkipPattern.Size = New System.Drawing.Size(113, 13)
        Me.lblEnforceSkipPattern.TabIndex = 0
        Me.lblEnforceSkipPattern.Text = "Enforce Skip Patterns:"
        Me.lblEnforceSkipPattern.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'StudyIdLabel
        '
        Me.StudyIdLabel.BackColor = System.Drawing.SystemColors.Control
        Me.StudyIdLabel.Location = New System.Drawing.Point(422, 55)
        Me.StudyIdLabel.Name = "StudyIdLabel"
        Me.StudyIdLabel.ReadOnly = True
        Me.StudyIdLabel.Size = New System.Drawing.Size(61, 20)
        Me.StudyIdLabel.TabIndex = 7
        Me.StudyIdLabel.TabStop = False
        '
        'SurveyIdLabel
        '
        Me.SurveyIdLabel.BackColor = System.Drawing.SystemColors.Control
        Me.SurveyIdLabel.Location = New System.Drawing.Point(422, 30)
        Me.SurveyIdLabel.Name = "SurveyIdLabel"
        Me.SurveyIdLabel.ReadOnly = True
        Me.SurveyIdLabel.Size = New System.Drawing.Size(61, 20)
        Me.SurveyIdLabel.TabIndex = 3
        Me.SurveyIdLabel.TabStop = False
        '
        'StudyNameLabel
        '
        Me.StudyNameLabel.BackColor = System.Drawing.SystemColors.Control
        Me.StudyNameLabel.Location = New System.Drawing.Point(176, 55)
        Me.StudyNameLabel.Name = "StudyNameLabel"
        Me.StudyNameLabel.ReadOnly = True
        Me.StudyNameLabel.Size = New System.Drawing.Size(155, 20)
        Me.StudyNameLabel.TabIndex = 5
        Me.StudyNameLabel.TabStop = False
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.Location = New System.Drawing.Point(353, 57)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(51, 13)
        Me.Label17.TabIndex = 6
        Me.Label17.Text = "Study ID:"
        Me.Label17.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label18
        '
        Me.Label18.AutoSize = True
        Me.Label18.Location = New System.Drawing.Point(5, 59)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(68, 13)
        Me.Label18.TabIndex = 4
        Me.Label18.Text = "Study Name:"
        Me.Label18.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ResurveyExcludionDaysPanel
        '
        Me.ResurveyExcludionDaysPanel.Controls.Add(Me.ResurveyExcludionDaysNumeric)
        Me.ResurveyExcludionDaysPanel.Controls.Add(Me.ResurveyExcludionDaysLabel)
        Me.ResurveyExcludionDaysPanel.Location = New System.Drawing.Point(0, 453)
        Me.ResurveyExcludionDaysPanel.Name = "ResurveyExcludionDaysPanel"
        Me.ResurveyExcludionDaysPanel.Size = New System.Drawing.Size(284, 25)
        Me.ResurveyExcludionDaysPanel.TabIndex = 30
        '
        'ResurveyExcludionDaysNumeric
        '
        Me.ResurveyExcludionDaysNumeric.Location = New System.Drawing.Point(176, 3)
        Me.ResurveyExcludionDaysNumeric.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.ResurveyExcludionDaysNumeric.Name = "ResurveyExcludionDaysNumeric"
        Me.ResurveyExcludionDaysNumeric.Size = New System.Drawing.Size(107, 20)
        Me.ResurveyExcludionDaysNumeric.TabIndex = 26
        '
        'ResurveyExcludionDaysLabel
        '
        Me.ResurveyExcludionDaysLabel.AutoSize = True
        Me.ResurveyExcludionDaysLabel.Location = New System.Drawing.Point(5, 5)
        Me.ResurveyExcludionDaysLabel.Name = "ResurveyExcludionDaysLabel"
        Me.ResurveyExcludionDaysLabel.Size = New System.Drawing.Size(130, 13)
        Me.ResurveyExcludionDaysLabel.TabIndex = 25
        Me.ResurveyExcludionDaysLabel.Text = "Resurvey Exclusion Days:"
        Me.ResurveyExcludionDaysLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label16
        '
        Me.Label16.AutoSize = True
        Me.Label16.Location = New System.Drawing.Point(353, 33)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(57, 13)
        Me.Label16.TabIndex = 2
        Me.Label16.Text = "Survey ID:"
        Me.Label16.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'ResurveyMethodComboBox
        '
        Me.ResurveyMethodComboBox.DisplayMember = "Label"
        Me.ResurveyMethodComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ResurveyMethodComboBox.FormattingEnabled = True
        Me.ResurveyMethodComboBox.Location = New System.Drawing.Point(176, 429)
        Me.ResurveyMethodComboBox.Name = "ResurveyMethodComboBox"
        Me.ResurveyMethodComboBox.Size = New System.Drawing.Size(107, 21)
        Me.ResurveyMethodComboBox.TabIndex = 29
        Me.ResurveyMethodComboBox.ValueMember = "Value"
        '
        'lblResurveyMethod
        '
        Me.lblResurveyMethod.AutoSize = True
        Me.lblResurveyMethod.Location = New System.Drawing.Point(5, 432)
        Me.lblResurveyMethod.Name = "lblResurveyMethod"
        Me.lblResurveyMethod.Size = New System.Drawing.Size(94, 13)
        Me.lblResurveyMethod.TabIndex = 28
        Me.lblResurveyMethod.Text = "Resurvey Method:"
        Me.lblResurveyMethod.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SamplingAlgorithmComboBox
        '
        Me.SamplingAlgorithmComboBox.DisplayMember = "Label"
        Me.SamplingAlgorithmComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SamplingAlgorithmComboBox.FormattingEnabled = True
        Me.SamplingAlgorithmComboBox.Items.AddRange(New Object() {"Static", "Dynamic", "Static Plus"})
        Me.SamplingAlgorithmComboBox.Location = New System.Drawing.Point(176, 250)
        Me.SamplingAlgorithmComboBox.Name = "SamplingAlgorithmComboBox"
        Me.SamplingAlgorithmComboBox.Size = New System.Drawing.Size(107, 21)
        Me.SamplingAlgorithmComboBox.TabIndex = 16
        Me.SamplingAlgorithmComboBox.ValueMember = "Value"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(5, 84)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(70, 13)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "Survey Type:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(5, 301)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(94, 13)
        Me.Label7.TabIndex = 18
        Me.Label7.Text = "Survey Start Date:"
        Me.Label7.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(5, 405)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(171, 13)
        Me.Label10.TabIndex = 26
        Me.Label10.Text = "Response Rate Recalculate Days:"
        Me.Label10.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyEndDatePicker
        '
        Me.SurveyEndDatePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.SurveyEndDatePicker.Location = New System.Drawing.Point(176, 323)
        Me.SurveyEndDatePicker.Name = "SurveyEndDatePicker"
        Me.SurveyEndDatePicker.Size = New System.Drawing.Size(107, 20)
        Me.SurveyEndDatePicker.TabIndex = 21
        '
        'SurveyDescriptionTextBox
        '
        Me.SurveyDescriptionTextBox.Location = New System.Drawing.Point(176, 187)
        Me.SurveyDescriptionTextBox.MaxLength = 40
        Me.SurveyDescriptionTextBox.Multiline = True
        Me.SurveyDescriptionTextBox.Name = "SurveyDescriptionTextBox"
        Me.SurveyDescriptionTextBox.Size = New System.Drawing.Size(306, 56)
        Me.SurveyDescriptionTextBox.TabIndex = 14
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(5, 165)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(138, 13)
        Me.Label3.TabIndex = 11
        Me.Label3.Text = "Client Facing Survey Name:"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(5, 189)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(99, 13)
        Me.Label4.TabIndex = 13
        Me.Label4.Text = "Survey Description:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ContractNumberTextBox
        '
        Me.ContractNumberTextBox.Location = New System.Drawing.Point(176, 6)
        Me.ContractNumberTextBox.MaxLength = 9
        Me.ContractNumberTextBox.Name = "ContractNumberTextBox"
        Me.ContractNumberTextBox.Size = New System.Drawing.Size(155, 20)
        Me.ContractNumberTextBox.TabIndex = 0
        '
        'SurveyNameTextBox
        '
        Me.SurveyNameTextBox.Location = New System.Drawing.Point(176, 30)
        Me.SurveyNameTextBox.MaxLength = 10
        Me.SurveyNameTextBox.Name = "SurveyNameTextBox"
        Me.SurveyNameTextBox.Size = New System.Drawing.Size(155, 20)
        Me.SurveyNameTextBox.TabIndex = 1
        '
        'RespRateRecalcDaysNumeric
        '
        Me.RespRateRecalcDaysNumeric.Location = New System.Drawing.Point(176, 403)
        Me.RespRateRecalcDaysNumeric.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.RespRateRecalcDaysNumeric.Name = "RespRateRecalcDaysNumeric"
        Me.RespRateRecalcDaysNumeric.Size = New System.Drawing.Size(108, 20)
        Me.RespRateRecalcDaysNumeric.TabIndex = 27
        '
        'CutoffDateComboBox
        '
        Me.CutoffDateComboBox.DisplayMember = "Label"
        Me.CutoffDateComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CutoffDateComboBox.FormattingEnabled = True
        Me.CutoffDateComboBox.Location = New System.Drawing.Point(176, 376)
        Me.CutoffDateComboBox.Name = "CutoffDateComboBox"
        Me.CutoffDateComboBox.Size = New System.Drawing.Size(306, 21)
        Me.CutoffDateComboBox.TabIndex = 25
        Me.CutoffDateComboBox.ValueMember = "Value"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(5, 327)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(91, 13)
        Me.Label8.TabIndex = 20
        Me.Label8.Text = "Survey End Date:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyStartDatePicker
        '
        Me.SurveyStartDatePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.SurveyStartDatePicker.Location = New System.Drawing.Point(176, 297)
        Me.SurveyStartDatePicker.Name = "SurveyStartDatePicker"
        Me.SurveyStartDatePicker.Size = New System.Drawing.Size(107, 20)
        Me.SurveyStartDatePicker.TabIndex = 19
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(5, 379)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(89, 13)
        Me.Label9.TabIndex = 24
        Me.Label9.Text = "Cutoff Date Field:"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyTypeComboBox
        '
        Me.SurveyTypeComboBox.DisplayMember = "Label"
        Me.SurveyTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SurveyTypeComboBox.FormattingEnabled = True
        Me.SurveyTypeComboBox.Location = New System.Drawing.Point(176, 80)
        Me.SurveyTypeComboBox.Name = "SurveyTypeComboBox"
        Me.SurveyTypeComboBox.Size = New System.Drawing.Size(306, 21)
        Me.SurveyTypeComboBox.TabIndex = 9
        Me.SurveyTypeComboBox.ValueMember = "Value"
        '
        'ContractNumberLabel
        '
        Me.ContractNumberLabel.AutoSize = True
        Me.ContractNumberLabel.Location = New System.Drawing.Point(5, 10)
        Me.ContractNumberLabel.Name = "ContractNumberLabel"
        Me.ContractNumberLabel.Size = New System.Drawing.Size(90, 13)
        Me.ContractNumberLabel.TabIndex = 0
        Me.ContractNumberLabel.Text = "Contract Number:"
        Me.ContractNumberLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyNameLabel
        '
        Me.SurveyNameLabel.AutoSize = True
        Me.SurveyNameLabel.Location = New System.Drawing.Point(5, 34)
        Me.SurveyNameLabel.Name = "SurveyNameLabel"
        Me.SurveyNameLabel.Size = New System.Drawing.Size(74, 13)
        Me.SurveyNameLabel.TabIndex = 0
        Me.SurveyNameLabel.Text = "Survey Name:"
        Me.SurveyNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FacingNameTextBox
        '
        Me.FacingNameTextBox.Location = New System.Drawing.Point(176, 161)
        Me.FacingNameTextBox.MaxLength = 42
        Me.FacingNameTextBox.Name = "FacingNameTextBox"
        Me.FacingNameTextBox.Size = New System.Drawing.Size(306, 20)
        Me.FacingNameTextBox.TabIndex = 12
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(5, 254)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(99, 13)
        Me.Label5.TabIndex = 15
        Me.Label5.Text = "Sampling Algorithm:"
        Me.Label5.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = " Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(522, 20)
        Me.InformationBar.TabIndex = 0
        Me.InformationBar.TabStop = False
        '
        'SurveyPropertiesEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "SurveyPropertiesEditor"
        Me.Size = New System.Drawing.Size(522, 611)
        Me.BottomPanel.ResumeLayout(False)
        Me.WorkAreaPanel.ResumeLayout(False)
        Me.WorkAreaPanel.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.ResurveyExcludionDaysPanel.ResumeLayout(False)
        Me.ResurveyExcludionDaysPanel.PerformLayout()
        CType(Me.ResurveyExcludionDaysNumeric, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RespRateRecalcDaysNumeric, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents cnclButton As System.Windows.Forms.Button
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ResurveyExcludionDaysNumeric As System.Windows.Forms.NumericUpDown
    Friend WithEvents lblEnforceSkipPattern As System.Windows.Forms.Label
    Friend WithEvents SurveyTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents ResurveyExcludionDaysLabel As System.Windows.Forms.Label
    Friend WithEvents RespRateRecalcDaysNumeric As System.Windows.Forms.NumericUpDown
    Friend WithEvents SurveyDescriptionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents CutoffDateComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents SurveyStartDatePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents SurveyNameLabel As System.Windows.Forms.Label
    Friend WithEvents FacingNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents SurveyNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents SurveyEndDatePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents SamplingAlgorithmComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents WorkAreaPanel As System.Windows.Forms.Panel
    Friend WithEvents ResurveyMethodComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents lblResurveyMethod As System.Windows.Forms.Label
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents ResurveyExcludionDaysPanel As System.Windows.Forms.Panel
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents StudyNameLabel As System.Windows.Forms.TextBox
    Friend WithEvents StudyIdLabel As System.Windows.Forms.TextBox
    Friend WithEvents SurveyIdLabel As System.Windows.Forms.TextBox
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents EnforceSkipNoOption As System.Windows.Forms.RadioButton
    Friend WithEvents EnforceSkipYesOption As System.Windows.Forms.RadioButton
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents SampleEncounterDateComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents ContractNumberLabel As System.Windows.Forms.Label
    Friend WithEvents ContractNumberTextBox As System.Windows.Forms.TextBox
    Friend WithEvents InActivateCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents InActivateLabel As System.Windows.Forms.Label
    Friend WithEvents ContractedLanguagesListBox As System.Windows.Forms.CheckedListBox
    Friend WithEvents ContractedLanguagesLabel As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents SurveySubTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents QuestionaireTypeComboBox As System.Windows.Forms.ComboBox

End Class
