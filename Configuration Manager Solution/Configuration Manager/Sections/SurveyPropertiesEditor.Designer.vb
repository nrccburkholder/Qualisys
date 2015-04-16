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
        Me.UseUSPSAddrChangeServiceLabel = New System.Windows.Forms.Label()
        Me.UseUSPSAddrChangeServiceCheckBox = New System.Windows.Forms.CheckBox()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.SurveySubTypeListBox = New System.Windows.Forms.CheckedListBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.QuestionnaireTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
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
        Me.OKButton.Location = New System.Drawing.Point(477, 5)
        Me.OKButton.Margin = New System.Windows.Forms.Padding(4)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(100, 28)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'cnclButton
        '
        Me.cnclButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cnclButton.Location = New System.Drawing.Point(585, 5)
        Me.cnclButton.Margin = New System.Windows.Forms.Padding(4)
        Me.cnclButton.Name = "cnclButton"
        Me.cnclButton.Size = New System.Drawing.Size(100, 28)
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
        Me.BottomPanel.Location = New System.Drawing.Point(0, 787)
        Me.BottomPanel.Margin = New System.Windows.Forms.Padding(4)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(696, 43)
        Me.BottomPanel.TabIndex = 2
        '
        'WorkAreaPanel
        '
        Me.WorkAreaPanel.AutoScroll = True
        Me.WorkAreaPanel.Controls.Add(Me.UseUSPSAddrChangeServiceLabel)
        Me.WorkAreaPanel.Controls.Add(Me.UseUSPSAddrChangeServiceCheckBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label12)
        Me.WorkAreaPanel.Controls.Add(Me.SurveySubTypeListBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label6)
        Me.WorkAreaPanel.Controls.Add(Me.QuestionnaireTypeComboBox)
        Me.WorkAreaPanel.Controls.Add(Me.Label2)
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
        Me.WorkAreaPanel.Location = New System.Drawing.Point(0, 25)
        Me.WorkAreaPanel.Margin = New System.Windows.Forms.Padding(4)
        Me.WorkAreaPanel.Name = "WorkAreaPanel"
        Me.WorkAreaPanel.Size = New System.Drawing.Size(696, 762)
        Me.WorkAreaPanel.TabIndex = 1
        '
        'UseUSPSAddrChangeServiceLabel
        '
        Me.UseUSPSAddrChangeServiceLabel.AutoSize = True
        Me.UseUSPSAddrChangeServiceLabel.Location = New System.Drawing.Point(8, 736)
        Me.UseUSPSAddrChangeServiceLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.UseUSPSAddrChangeServiceLabel.Name = "UseUSPSAddrChangeServiceLabel"
        Me.UseUSPSAddrChangeServiceLabel.Size = New System.Drawing.Size(207, 16)
        Me.UseUSPSAddrChangeServiceLabel.TabIndex = 42
        Me.UseUSPSAddrChangeServiceLabel.Text = "Use USPS Addr Change Service:"
        '
        'UseUSPSAddrChangeServiceCheckBox
        '
        Me.UseUSPSAddrChangeServiceCheckBox.AutoSize = True
        Me.UseUSPSAddrChangeServiceCheckBox.Location = New System.Drawing.Point(236, 736)
        Me.UseUSPSAddrChangeServiceCheckBox.Margin = New System.Windows.Forms.Padding(4)
        Me.UseUSPSAddrChangeServiceCheckBox.Name = "UseUSPSAddrChangeServiceCheckBox"
        Me.UseUSPSAddrChangeServiceCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.UseUSPSAddrChangeServiceCheckBox.TabIndex = 41
        Me.UseUSPSAddrChangeServiceCheckBox.UseVisualStyleBackColor = True
        '
        'Label12
        '
        Me.Label12.Location = New System.Drawing.Point(233, 238)
        Me.Label12.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(344, 16)
        Me.Label12.TabIndex = 40
        Me.Label12.Text = "* Survey sub-type rules will override survey type rules."
        Me.Label12.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveySubTypeListBox
        '
        Me.SurveySubTypeListBox.CheckOnClick = True
        Me.SurveySubTypeListBox.ColumnWidth = 150
        Me.SurveySubTypeListBox.FormattingEnabled = True
        Me.SurveySubTypeListBox.IntegralHeight = False
        Me.SurveySubTypeListBox.Items.AddRange(New Object() {"MNCM", "MIPEC", "WCHQ", "ABCDE", "VWXYZ", "ABCD", "EFGH", "IJKLM", "NOPQ", "RSTUV"})
        Me.SurveySubTypeListBox.Location = New System.Drawing.Point(235, 135)
        Me.SurveySubTypeListBox.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.SurveySubTypeListBox.Name = "SurveySubTypeListBox"
        Me.SurveySubTypeListBox.Size = New System.Drawing.Size(407, 98)
        Me.SurveySubTypeListBox.TabIndex = 39
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(8, 282)
        Me.Label6.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(143, 16)
        Me.Label6.TabIndex = 38
        Me.Label6.Text = "Questionnaire Version:"
        Me.Label6.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'QuestionnaireTypeComboBox
        '
        Me.QuestionnaireTypeComboBox.DisplayMember = "Label"
        Me.QuestionnaireTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.QuestionnaireTypeComboBox.FormattingEnabled = True
        Me.QuestionnaireTypeComboBox.Location = New System.Drawing.Point(236, 278)
        Me.QuestionnaireTypeComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.QuestionnaireTypeComboBox.Name = "QuestionnaireTypeComboBox"
        Me.QuestionnaireTypeComboBox.Size = New System.Drawing.Size(407, 24)
        Me.QuestionnaireTypeComboBox.TabIndex = 37
        Me.QuestionnaireTypeComboBox.ValueMember = "Value"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 135)
        Me.Label2.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(116, 16)
        Me.Label2.TabIndex = 36
        Me.Label2.Text = "Survey Sub-Type:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ContractedLanguagesListBox
        '
        Me.ContractedLanguagesListBox.CheckOnClick = True
        Me.ContractedLanguagesListBox.FormattingEnabled = True
        Me.ContractedLanguagesListBox.Location = New System.Drawing.Point(420, 629)
        Me.ContractedLanguagesListBox.Margin = New System.Windows.Forms.Padding(4)
        Me.ContractedLanguagesListBox.Name = "ContractedLanguagesListBox"
        Me.ContractedLanguagesListBox.Size = New System.Drawing.Size(223, 106)
        Me.ContractedLanguagesListBox.TabIndex = 34
        '
        'ContractedLanguagesLabel
        '
        Me.ContractedLanguagesLabel.AutoSize = True
        Me.ContractedLanguagesLabel.Location = New System.Drawing.Point(416, 609)
        Me.ContractedLanguagesLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.ContractedLanguagesLabel.Name = "ContractedLanguagesLabel"
        Me.ContractedLanguagesLabel.Size = New System.Drawing.Size(147, 16)
        Me.ContractedLanguagesLabel.TabIndex = 33
        Me.ContractedLanguagesLabel.Text = "Contracted Languages:"
        Me.ContractedLanguagesLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'InActivateLabel
        '
        Me.InActivateLabel.AutoSize = True
        Me.InActivateLabel.Location = New System.Drawing.Point(8, 709)
        Me.InActivateLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.InActivateLabel.Name = "InActivateLabel"
        Me.InActivateLabel.Size = New System.Drawing.Size(114, 16)
        Me.InActivateLabel.TabIndex = 32
        Me.InActivateLabel.Text = "InActivate Survey:"
        '
        'InActivateCheckBox
        '
        Me.InActivateCheckBox.AutoSize = True
        Me.InActivateCheckBox.Location = New System.Drawing.Point(236, 709)
        Me.InActivateCheckBox.Margin = New System.Windows.Forms.Padding(4)
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
        Me.SampleEncounterDateComboBox.Location = New System.Drawing.Point(236, 543)
        Me.SampleEncounterDateComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.SampleEncounterDateComboBox.Name = "SampleEncounterDateComboBox"
        Me.SampleEncounterDateComboBox.Size = New System.Drawing.Size(407, 24)
        Me.SampleEncounterDateComboBox.TabIndex = 23
        Me.SampleEncounterDateComboBox.ValueMember = "Value"
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(8, 546)
        Me.Label11.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(154, 16)
        Me.Label11.TabIndex = 22
        Me.Label11.Text = "Sample Encounter Field:"
        Me.Label11.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.EnforceSkipNoOption)
        Me.Panel1.Controls.Add(Me.EnforceSkipYesOption)
        Me.Panel1.Controls.Add(Me.lblEnforceSkipPattern)
        Me.Panel1.Location = New System.Drawing.Point(1, 448)
        Me.Panel1.Margin = New System.Windows.Forms.Padding(4)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(644, 26)
        Me.Panel1.TabIndex = 17
        '
        'EnforceSkipNoOption
        '
        Me.EnforceSkipNoOption.AutoSize = True
        Me.EnforceSkipNoOption.Location = New System.Drawing.Point(300, 4)
        Me.EnforceSkipNoOption.Margin = New System.Windows.Forms.Padding(4)
        Me.EnforceSkipNoOption.Name = "EnforceSkipNoOption"
        Me.EnforceSkipNoOption.Size = New System.Drawing.Size(44, 20)
        Me.EnforceSkipNoOption.TabIndex = 2
        Me.EnforceSkipNoOption.Text = "No"
        Me.EnforceSkipNoOption.UseVisualStyleBackColor = True
        '
        'EnforceSkipYesOption
        '
        Me.EnforceSkipYesOption.AutoSize = True
        Me.EnforceSkipYesOption.Checked = True
        Me.EnforceSkipYesOption.Location = New System.Drawing.Point(235, 4)
        Me.EnforceSkipYesOption.Margin = New System.Windows.Forms.Padding(4)
        Me.EnforceSkipYesOption.Name = "EnforceSkipYesOption"
        Me.EnforceSkipYesOption.Size = New System.Drawing.Size(50, 20)
        Me.EnforceSkipYesOption.TabIndex = 1
        Me.EnforceSkipYesOption.TabStop = True
        Me.EnforceSkipYesOption.Text = "Yes"
        Me.EnforceSkipYesOption.UseVisualStyleBackColor = True
        '
        'lblEnforceSkipPattern
        '
        Me.lblEnforceSkipPattern.AutoSize = True
        Me.lblEnforceSkipPattern.Location = New System.Drawing.Point(7, 6)
        Me.lblEnforceSkipPattern.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblEnforceSkipPattern.Name = "lblEnforceSkipPattern"
        Me.lblEnforceSkipPattern.Size = New System.Drawing.Size(139, 16)
        Me.lblEnforceSkipPattern.TabIndex = 0
        Me.lblEnforceSkipPattern.Text = "Enforce Skip Patterns:"
        Me.lblEnforceSkipPattern.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'StudyIdLabel
        '
        Me.StudyIdLabel.BackColor = System.Drawing.SystemColors.Control
        Me.StudyIdLabel.Location = New System.Drawing.Point(563, 68)
        Me.StudyIdLabel.Margin = New System.Windows.Forms.Padding(4)
        Me.StudyIdLabel.Name = "StudyIdLabel"
        Me.StudyIdLabel.ReadOnly = True
        Me.StudyIdLabel.Size = New System.Drawing.Size(80, 22)
        Me.StudyIdLabel.TabIndex = 7
        Me.StudyIdLabel.TabStop = False
        '
        'SurveyIdLabel
        '
        Me.SurveyIdLabel.BackColor = System.Drawing.SystemColors.Control
        Me.SurveyIdLabel.Location = New System.Drawing.Point(563, 37)
        Me.SurveyIdLabel.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyIdLabel.Name = "SurveyIdLabel"
        Me.SurveyIdLabel.ReadOnly = True
        Me.SurveyIdLabel.Size = New System.Drawing.Size(80, 22)
        Me.SurveyIdLabel.TabIndex = 3
        Me.SurveyIdLabel.TabStop = False
        '
        'StudyNameLabel
        '
        Me.StudyNameLabel.BackColor = System.Drawing.SystemColors.Control
        Me.StudyNameLabel.Location = New System.Drawing.Point(235, 68)
        Me.StudyNameLabel.Margin = New System.Windows.Forms.Padding(4)
        Me.StudyNameLabel.Name = "StudyNameLabel"
        Me.StudyNameLabel.ReadOnly = True
        Me.StudyNameLabel.Size = New System.Drawing.Size(205, 22)
        Me.StudyNameLabel.TabIndex = 5
        Me.StudyNameLabel.TabStop = False
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.Location = New System.Drawing.Point(471, 70)
        Me.Label17.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(61, 16)
        Me.Label17.TabIndex = 6
        Me.Label17.Text = "Study ID:"
        Me.Label17.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label18
        '
        Me.Label18.AutoSize = True
        Me.Label18.Location = New System.Drawing.Point(7, 73)
        Me.Label18.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(85, 16)
        Me.Label18.TabIndex = 4
        Me.Label18.Text = "Study Name:"
        Me.Label18.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ResurveyExcludionDaysPanel
        '
        Me.ResurveyExcludionDaysPanel.Controls.Add(Me.ResurveyExcludionDaysNumeric)
        Me.ResurveyExcludionDaysPanel.Controls.Add(Me.ResurveyExcludionDaysLabel)
        Me.ResurveyExcludionDaysPanel.Location = New System.Drawing.Point(1, 671)
        Me.ResurveyExcludionDaysPanel.Margin = New System.Windows.Forms.Padding(4)
        Me.ResurveyExcludionDaysPanel.Name = "ResurveyExcludionDaysPanel"
        Me.ResurveyExcludionDaysPanel.Size = New System.Drawing.Size(379, 31)
        Me.ResurveyExcludionDaysPanel.TabIndex = 30
        '
        'ResurveyExcludionDaysNumeric
        '
        Me.ResurveyExcludionDaysNumeric.Location = New System.Drawing.Point(235, 4)
        Me.ResurveyExcludionDaysNumeric.Margin = New System.Windows.Forms.Padding(4)
        Me.ResurveyExcludionDaysNumeric.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.ResurveyExcludionDaysNumeric.Name = "ResurveyExcludionDaysNumeric"
        Me.ResurveyExcludionDaysNumeric.Size = New System.Drawing.Size(143, 22)
        Me.ResurveyExcludionDaysNumeric.TabIndex = 26
        '
        'ResurveyExcludionDaysLabel
        '
        Me.ResurveyExcludionDaysLabel.AutoSize = True
        Me.ResurveyExcludionDaysLabel.Location = New System.Drawing.Point(7, 6)
        Me.ResurveyExcludionDaysLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.ResurveyExcludionDaysLabel.Name = "ResurveyExcludionDaysLabel"
        Me.ResurveyExcludionDaysLabel.Size = New System.Drawing.Size(164, 16)
        Me.ResurveyExcludionDaysLabel.TabIndex = 25
        Me.ResurveyExcludionDaysLabel.Text = "Resurvey Exclusion Days:"
        Me.ResurveyExcludionDaysLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label16
        '
        Me.Label16.AutoSize = True
        Me.Label16.Location = New System.Drawing.Point(471, 41)
        Me.Label16.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(69, 16)
        Me.Label16.TabIndex = 2
        Me.Label16.Text = "Survey ID:"
        Me.Label16.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'ResurveyMethodComboBox
        '
        Me.ResurveyMethodComboBox.DisplayMember = "Label"
        Me.ResurveyMethodComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ResurveyMethodComboBox.FormattingEnabled = True
        Me.ResurveyMethodComboBox.Location = New System.Drawing.Point(236, 641)
        Me.ResurveyMethodComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.ResurveyMethodComboBox.Name = "ResurveyMethodComboBox"
        Me.ResurveyMethodComboBox.Size = New System.Drawing.Size(141, 24)
        Me.ResurveyMethodComboBox.TabIndex = 29
        Me.ResurveyMethodComboBox.ValueMember = "Value"
        '
        'lblResurveyMethod
        '
        Me.lblResurveyMethod.AutoSize = True
        Me.lblResurveyMethod.Location = New System.Drawing.Point(8, 645)
        Me.lblResurveyMethod.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblResurveyMethod.Name = "lblResurveyMethod"
        Me.lblResurveyMethod.Size = New System.Drawing.Size(117, 16)
        Me.lblResurveyMethod.TabIndex = 28
        Me.lblResurveyMethod.Text = "Resurvey Method:"
        Me.lblResurveyMethod.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SamplingAlgorithmComboBox
        '
        Me.SamplingAlgorithmComboBox.DisplayMember = "Label"
        Me.SamplingAlgorithmComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SamplingAlgorithmComboBox.FormattingEnabled = True
        Me.SamplingAlgorithmComboBox.Location = New System.Drawing.Point(236, 421)
        Me.SamplingAlgorithmComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.SamplingAlgorithmComboBox.Name = "SamplingAlgorithmComboBox"
        Me.SamplingAlgorithmComboBox.Size = New System.Drawing.Size(141, 24)
        Me.SamplingAlgorithmComboBox.TabIndex = 16
        Me.SamplingAlgorithmComboBox.ValueMember = "Value"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 103)
        Me.Label1.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(88, 16)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "Survey Type:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(8, 484)
        Me.Label7.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(115, 16)
        Me.Label7.TabIndex = 18
        Me.Label7.Text = "Survey Start Date:"
        Me.Label7.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(8, 612)
        Me.Label10.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(216, 16)
        Me.Label10.TabIndex = 26
        Me.Label10.Text = "Response Rate Recalculate Days:"
        Me.Label10.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyEndDatePicker
        '
        Me.SurveyEndDatePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.SurveyEndDatePicker.Location = New System.Drawing.Point(236, 511)
        Me.SurveyEndDatePicker.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyEndDatePicker.Name = "SurveyEndDatePicker"
        Me.SurveyEndDatePicker.Size = New System.Drawing.Size(141, 22)
        Me.SurveyEndDatePicker.TabIndex = 21
        '
        'SurveyDescriptionTextBox
        '
        Me.SurveyDescriptionTextBox.Location = New System.Drawing.Point(236, 343)
        Me.SurveyDescriptionTextBox.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyDescriptionTextBox.MaxLength = 40
        Me.SurveyDescriptionTextBox.Multiline = True
        Me.SurveyDescriptionTextBox.Name = "SurveyDescriptionTextBox"
        Me.SurveyDescriptionTextBox.Size = New System.Drawing.Size(407, 68)
        Me.SurveyDescriptionTextBox.TabIndex = 14
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(8, 316)
        Me.Label3.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(173, 16)
        Me.Label3.TabIndex = 11
        Me.Label3.Text = "Client Facing Survey Name:"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(8, 346)
        Me.Label4.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(124, 16)
        Me.Label4.TabIndex = 13
        Me.Label4.Text = "Survey Description:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ContractNumberTextBox
        '
        Me.ContractNumberTextBox.Location = New System.Drawing.Point(235, 7)
        Me.ContractNumberTextBox.Margin = New System.Windows.Forms.Padding(4)
        Me.ContractNumberTextBox.MaxLength = 9
        Me.ContractNumberTextBox.Name = "ContractNumberTextBox"
        Me.ContractNumberTextBox.Size = New System.Drawing.Size(205, 22)
        Me.ContractNumberTextBox.TabIndex = 0
        '
        'SurveyNameTextBox
        '
        Me.SurveyNameTextBox.Location = New System.Drawing.Point(235, 37)
        Me.SurveyNameTextBox.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyNameTextBox.MaxLength = 10
        Me.SurveyNameTextBox.Name = "SurveyNameTextBox"
        Me.SurveyNameTextBox.Size = New System.Drawing.Size(205, 22)
        Me.SurveyNameTextBox.TabIndex = 1
        '
        'RespRateRecalcDaysNumeric
        '
        Me.RespRateRecalcDaysNumeric.Location = New System.Drawing.Point(236, 609)
        Me.RespRateRecalcDaysNumeric.Margin = New System.Windows.Forms.Padding(4)
        Me.RespRateRecalcDaysNumeric.Maximum = New Decimal(New Integer() {9999, 0, 0, 0})
        Me.RespRateRecalcDaysNumeric.Name = "RespRateRecalcDaysNumeric"
        Me.RespRateRecalcDaysNumeric.Size = New System.Drawing.Size(144, 22)
        Me.RespRateRecalcDaysNumeric.TabIndex = 27
        '
        'CutoffDateComboBox
        '
        Me.CutoffDateComboBox.DisplayMember = "Label"
        Me.CutoffDateComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CutoffDateComboBox.FormattingEnabled = True
        Me.CutoffDateComboBox.Location = New System.Drawing.Point(236, 576)
        Me.CutoffDateComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.CutoffDateComboBox.Name = "CutoffDateComboBox"
        Me.CutoffDateComboBox.Size = New System.Drawing.Size(407, 24)
        Me.CutoffDateComboBox.TabIndex = 25
        Me.CutoffDateComboBox.ValueMember = "Value"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(8, 516)
        Me.Label8.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(112, 16)
        Me.Label8.TabIndex = 20
        Me.Label8.Text = "Survey End Date:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyStartDatePicker
        '
        Me.SurveyStartDatePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.SurveyStartDatePicker.Location = New System.Drawing.Point(236, 479)
        Me.SurveyStartDatePicker.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyStartDatePicker.Name = "SurveyStartDatePicker"
        Me.SurveyStartDatePicker.Size = New System.Drawing.Size(141, 22)
        Me.SurveyStartDatePicker.TabIndex = 19
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(8, 580)
        Me.Label9.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(109, 16)
        Me.Label9.TabIndex = 24
        Me.Label9.Text = "Cutoff Date Field:"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyTypeComboBox
        '
        Me.SurveyTypeComboBox.DisplayMember = "Label"
        Me.SurveyTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SurveyTypeComboBox.FormattingEnabled = True
        Me.SurveyTypeComboBox.Location = New System.Drawing.Point(235, 98)
        Me.SurveyTypeComboBox.Margin = New System.Windows.Forms.Padding(4)
        Me.SurveyTypeComboBox.Name = "SurveyTypeComboBox"
        Me.SurveyTypeComboBox.Size = New System.Drawing.Size(407, 24)
        Me.SurveyTypeComboBox.TabIndex = 9
        Me.SurveyTypeComboBox.ValueMember = "Value"
        '
        'ContractNumberLabel
        '
        Me.ContractNumberLabel.AutoSize = True
        Me.ContractNumberLabel.Location = New System.Drawing.Point(7, 12)
        Me.ContractNumberLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.ContractNumberLabel.Name = "ContractNumberLabel"
        Me.ContractNumberLabel.Size = New System.Drawing.Size(111, 16)
        Me.ContractNumberLabel.TabIndex = 0
        Me.ContractNumberLabel.Text = "Contract Number:"
        Me.ContractNumberLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyNameLabel
        '
        Me.SurveyNameLabel.AutoSize = True
        Me.SurveyNameLabel.Location = New System.Drawing.Point(7, 42)
        Me.SurveyNameLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.SurveyNameLabel.Name = "SurveyNameLabel"
        Me.SurveyNameLabel.Size = New System.Drawing.Size(93, 16)
        Me.SurveyNameLabel.TabIndex = 0
        Me.SurveyNameLabel.Text = "Survey Name:"
        Me.SurveyNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'FacingNameTextBox
        '
        Me.FacingNameTextBox.Location = New System.Drawing.Point(236, 311)
        Me.FacingNameTextBox.Margin = New System.Windows.Forms.Padding(4)
        Me.FacingNameTextBox.MaxLength = 42
        Me.FacingNameTextBox.Name = "FacingNameTextBox"
        Me.FacingNameTextBox.Size = New System.Drawing.Size(407, 22)
        Me.FacingNameTextBox.TabIndex = 12
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(8, 426)
        Me.Label5.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(127, 16)
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
        Me.InformationBar.Margin = New System.Windows.Forms.Padding(5)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(696, 25)
        Me.InformationBar.TabIndex = 0
        Me.InformationBar.TabStop = False
        '
        'SurveyPropertiesEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.WorkAreaPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Controls.Add(Me.BottomPanel)
        Me.Margin = New System.Windows.Forms.Padding(4)
        Me.Name = "SurveyPropertiesEditor"
        Me.Size = New System.Drawing.Size(696, 830)
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
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents QuestionnaireTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents SurveySubTypeListBox As System.Windows.Forms.CheckedListBox
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents UseUSPSAddrChangeServiceLabel As System.Windows.Forms.Label
    Friend WithEvents UseUSPSAddrChangeServiceCheckBox As System.Windows.Forms.CheckBox

End Class
