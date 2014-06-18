Imports Nrc.Qualisys.Library

Public Class SurveyPropertiesEditor

#Region " Private Fields "

    Private mModule As SurveyPropertiesModule
    Private mEndConfigCallBack As EndConfigCallBackMethod

#End Region

#Region " Constructors "

    Public Sub New(ByVal surveyModule As SurveyPropertiesModule, ByVal endConfigCallBack As EndConfigCallBackMethod)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = surveyModule
        mEndConfigCallBack = endConfigCallBack

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub SurveyPropertiesEditor_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        DisplayData()

    End Sub

    Private Sub SurveyTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyTypeComboBox.SelectedIndexChanged

        Try
            If (SurveyTypeComboBox.SelectedIndex < 0) Then Return
            Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)

            Dim survey As Survey = New Survey()
            survey.SurveyType = surveyType

            LoadSurveySubTypeComboBox(surveyType)
            LoadQuestionaireTypeComboBox(surveyType)

            'lblResurveyMethod.Enabled = False
            ResurveyMethodComboBox.Enabled = False
            SamplingAlgorithmComboBox.SelectedValue = [Enum].Parse(GetType(SamplingAlgorithm), survey.SamplingAlgorithmDefault)
            If survey.SkipEnforcementRequired Then
                EnforceSkipYesOption.Checked = True
                EnforceSkipNoOption.Checked = False
                EnforceSkipYesOption.Enabled = False
                EnforceSkipNoOption.Enabled = False
                lblEnforceSkipPattern.Enabled = False
            Else
                EnforceSkipYesOption.Enabled = True
                EnforceSkipNoOption.Enabled = True
                lblEnforceSkipPattern.Enabled = True
            End If
            RespRateRecalcDaysNumeric.Value = survey.RespRateRecalsDaysNumericDefault
            ResurveyMethodComboBox.SelectedValue = [Enum].Parse(GetType(ResurveyMethod), survey.ResurveyMethodDefault)
            ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault
            ResurveyExcludionDaysNumeric.Enabled = Not survey.IsResurveyExclusionPeriodsNumericDisabled

        Catch ex As System.InvalidCastException
            Return

        End Try

    End Sub

    Private Sub ResurveyMethodComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResurveyMethodComboBox.SelectedIndexChanged

        If (ResurveyMethodComboBox.SelectedIndex < 0) Then Return

        Dim resurveyMethod As ResurveyMethod

        Try
            resurveyMethod = CType(ResurveyMethodComboBox.SelectedValue, Library.ResurveyMethod)

        Catch ex As System.InvalidCastException
            Return

        End Try

        'TODO: SurveyRules.SurveyType = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
        Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
        Dim survey As Survey = New Survey()
        survey.SurveyType = surveyType

        Select Case resurveyMethod
            Case Library.ResurveyMethod.NumberOfDays
                ResurveyExcludionDaysPanel.Enabled = True
                ResurveyExcludionDaysLabel.Text = "Resurvey Exclusion Days:"
                ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault

            Case Library.ResurveyMethod.CalendarMonths
                ResurveyExcludionDaysPanel.Enabled = True
                ResurveyExcludionDaysLabel.Text = "Resurvey Exclusion Months:"
                ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault
        End Select

        ResurveyExcludionDaysPanel.Enabled = (resurveyMethod = Library.ResurveyMethod.NumberOfDays)

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        If (Not CheckInputData()) Then Return

        SaveInputData()

        mEndConfigCallBack(ConfigResultActions.SurveyRefresh, Nothing)
        mEndConfigCallBack = Nothing

    End Sub

    Private Sub cnclButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cnclButton.Click

        mEndConfigCallBack(ConfigResultActions.None, Nothing)
        mEndConfigCallBack = Nothing

    End Sub

#End Region

#Region " Private Methods "

    Private Sub DisplayData()

        'Caption
        If mModule.IsNew Then
            'Me.BackPanel.Caption = "New Survey Editor"
        ElseIf mModule.IsEditable Then
            'Me.BackPanel.Caption = "Survey Properties Editor"
        Else
            'Me.BackPanel.Caption = "Survey Properties Viewer"
        End If

        'Information bar
        InformationBar.Information = mModule.Information

        'Survey Name/ID
        SurveyNameTextBox.Text = mModule.EditingSurvey.Name

        If (mModule.EditingSurvey.Id > 0) Then
            SurveyIdLabel.Text = mModule.EditingSurvey.Id.ToString(Application.CurrentCulture)
        Else
            SurveyIdLabel.Text = "New"
        End If

        'Contract Number
        ContractNumberTextBox.Text = mModule.EditingSurvey.ContractNumber ' SK - 1/31/2009 - Added Contract Number to DisplayData routine.
        ContractNumberTextBox.Focus()

        'Study Name/ID
        StudyNameLabel.Text = mModule.Study.Name
        StudyIdLabel.Text = mModule.Study.Id.ToString

        'Survey type list
        SurveyTypeComboBox.DataSource = Survey.GetSurveyTypes
        SurveyTypeComboBox.SelectedValue = mModule.EditingSurvey.SurveyType
        If (SurveyTypeComboBox.Items.Count > 0 AndAlso SurveyTypeComboBox.SelectedIndex < 0) Then
            SurveyTypeComboBox.SelectedIndex = 0
        End If


        SurveyTypeComboBox.Enabled = mModule.EditingSurvey.IsSurveyTypeEditable

        'Survey SubType list
        Dim surveyTypeID As Integer = CInt(SurveyTypeComboBox.SelectedValue)
        LoadSurveySubTypeComboBox(surveyTypeID)

        'Questionaire Type list
        LoadQuestionaireTypeComboBox(surveyTypeID)

        'Facing name
        FacingNameTextBox.Text = mModule.EditingSurvey.ClientFacingName

        'Survey description
        SurveyDescriptionTextBox.Text = mModule.EditingSurvey.Description

        'Sampling Algorithm
        SamplingAlgorithmComboBox.DataSource = Survey.GetSamplingAlgorithms
        SamplingAlgorithmComboBox.SelectedValue = mModule.EditingSurvey.SamplingAlgorithm
        If (SamplingAlgorithmComboBox.Items.Count > 0 AndAlso SamplingAlgorithmComboBox.SelectedIndex < 0) Then
            SamplingAlgorithmComboBox.SelectedIndex = 0
        End If

        'Enforce skip
        EnforceSkipYesOption.Checked = mModule.EditingSurvey.EnforceSkip
        EnforceSkipNoOption.Checked = Not mModule.EditingSurvey.EnforceSkip

        'Survey start/end date
        SetDateField(SurveyStartDatePicker, mModule.EditingSurvey.SurveyStartDate)
        SetDateField(SurveyEndDatePicker, mModule.EditingSurvey.SurveyEndDate)

        'Sample Encounter field
        SampleEncounterDateComboBox.BeginUpdate()
        SampleEncounterDateComboBox.Items.Clear()
        SampleEncounterDateComboBox.DataSource = mModule.Study.GetSampleEncounterDateFields
        Dim item As ListItem(Of CutoffDateField)
        Dim field As CutoffDateField
        For id As Integer = 0 To SampleEncounterDateComboBox.Items.Count - 1
            item = DirectCast(SampleEncounterDateComboBox.Items(id), ListItem(Of CutoffDateField))
            field = item.Value
            Select Case field.CutoffDateFieldType
                Case CutoffFieldType.NotApplicable
                    If (mModule.EditingSurvey.SampleEncounterField Is Nothing) Then
                        SampleEncounterDateComboBox.SelectedIndex = id
                        Exit For
                    End If

                Case CutoffFieldType.CustomMetafield
                    If (mModule.EditingSurvey.SampleEncounterField IsNot Nothing AndAlso _
                        field.StudyTable.Id = mModule.EditingSurvey.SampleEncounterField.TableId AndAlso _
                        field.StudyTableColumn.Id = mModule.EditingSurvey.SampleEncounterField.Id) Then
                        SampleEncounterDateComboBox.SelectedIndex = id
                        Exit For
                    End If

            End Select
        Next
        If (SampleEncounterDateComboBox.Items.Count > 0 AndAlso SampleEncounterDateComboBox.SelectedIndex < 0) Then
            SampleEncounterDateComboBox.SelectedIndex = 0
        End If
        SampleEncounterDateComboBox.EndUpdate()

        'Cutoff Date field
        CutoffDateComboBox.BeginUpdate()
        CutoffDateComboBox.Items.Clear()
        CutoffDateComboBox.DataSource = mModule.Study.GetCutoffDateFields
        For id As Integer = 0 To CutoffDateComboBox.Items.Count - 1
            item = DirectCast(CutoffDateComboBox.Items(id), ListItem(Of CutoffDateField))
            field = item.Value
            Select Case field.CutoffDateFieldType
                Case CutoffFieldType.SampleCreate, CutoffFieldType.ReturnDate
                    If (field.CutoffDateFieldType = mModule.EditingSurvey.CutoffResponseCode) Then
                        CutoffDateComboBox.SelectedIndex = id
                        Exit For
                    End If

                Case CutoffFieldType.CustomMetafield
                    If (field.CutoffDateFieldType = mModule.EditingSurvey.CutoffResponseCode AndAlso _
                        field.StudyTable.Id = mModule.EditingSurvey.CutoffTableId AndAlso _
                        field.StudyTableColumn.Id = mModule.EditingSurvey.CutoffFieldId) Then
                        CutoffDateComboBox.SelectedIndex = id
                        Exit For
                    End If

            End Select
        Next
        If (CutoffDateComboBox.Items.Count > 0 AndAlso CutoffDateComboBox.SelectedIndex < 0) Then
            CutoffDateComboBox.SelectedIndex = 0
        End If
        CutoffDateComboBox.EndUpdate()

        'Response rate recalculate days
        SetNumericField(RespRateRecalcDaysNumeric, mModule.EditingSurvey.ResponseRateRecalculationPeriod)

        'Resurvey method
        ResurveyMethodComboBox.DataSource = Survey.GetResurveyMethods
        ResurveyMethodComboBox.SelectedValue = mModule.EditingSurvey.ResurveyMethod
        If (ResurveyMethodComboBox.Items.Count > 0 AndAlso ResurveyMethodComboBox.SelectedIndex < 0) Then
            ResurveyMethodComboBox.SelectedIndex = 0
        End If
        'TODO: drive by surveyrules
        If (Not mModule.EditingSurvey.IsResurveyMethodDisabled) Then
            ResurveyMethodComboBox.SelectedValue = Library.ResurveyMethod.NumberOfDays
            ResurveyMethodComboBox.Enabled = False
        End If

        'Resurvey exclusion days
        SetNumericField(ResurveyExcludionDaysNumeric, mModule.EditingSurvey.ResurveyPeriod)

        'Status
        InActivateCheckBox.Checked = Not mModule.EditingSurvey.IsActive

        'Contracted Languages
        If mModule.Study.Client.ClientGroup IsNot Nothing AndAlso mModule.Study.Client.ClientGroup.Name = "OCS" Then
            'Display Contracted Languages
            ContractedLanguagesLabel.Visible = True
            ContractedLanguagesListBox.Visible = True

            'Load the list box
            Dim languages As ContractedLanguageCollection = ContractedLanguage.GetAll()
            For Each language As ContractedLanguage In languages
                ContractedLanguagesListBox.Items.Add(language)
            Next
            ContractedLanguages = mModule.EditingSurvey.ContractedLanguages
        Else
            'Hide the Contracted Languages
            ContractedLanguagesLabel.Visible = False
            ContractedLanguagesListBox.Visible = False
        End If

        'Disable all the fields when viewing properties
        WorkAreaPanel.Enabled = mModule.IsEditable
        OKButton.Enabled = mModule.IsEditable

    End Sub

    Private Property ContractedLanguages() As String
        Get
            Dim langCodes As String = String.Empty

            For Each item As ContractedLanguage In ContractedLanguagesListBox.CheckedItems
                langCodes &= String.Format("{0},", item.LanguageCode)
            Next

            If langCodes.Length > 1 Then
                langCodes = langCodes.Remove(langCodes.Length - 1)
            End If

            Return langCodes
        End Get
        Set(ByVal value As String)
            value = String.Format(",{0},", value)

            'Collect a list of the indexes for all contracted langueages that need to be checked
            Dim checkedItems As New List(Of Integer)
            For Each item As ContractedLanguage In ContractedLanguagesListBox.Items
                If value.IndexOf(String.Format(",{0},", item.LanguageCode)) > -1 Then
                    checkedItems.Add(ContractedLanguagesListBox.Items.IndexOf(item))
                End If
            Next

            'Now lets actually check the appropriate boxes
            For Each checkedItem As Integer In checkedItems
                ContractedLanguagesListBox.SetItemChecked(checkedItem, True)
            Next
        End Set
    End Property

    Private Shared Sub SetDateField(ByVal dateField As DateTimePicker, ByVal dt As Date)

        If (dt < dateField.MinDate) Then
            dateField.Value = dateField.MinDate
        ElseIf (dt > dateField.MaxDate) Then
            dateField.Value = dateField.MaxDate
        Else
            dateField.Value = dt
        End If

    End Sub

    Private Shared Sub SetNumericField(ByVal numField As NumericUpDown, ByVal value As Integer)

        If (value < numField.Minimum) Then
            numField.Value = numField.Minimum
        ElseIf (value > numField.Maximum) Then
            numField.Value = numField.Maximum
        Else
            numField.Value = value
        End If

    End Sub

    Private Function CheckInputData() As Boolean

        Dim title As String = "Survey Property Editor"

        If (ContractNumberTextBox.Text.Trim = "") Then
            ContractNumberTextBox.Focus()
            MessageBox.Show("Contract Number is required!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (SurveyTypeComboBox.SelectedIndex < 0) Then
            SurveyTypeComboBox.Focus()
            MessageBox.Show("You must select a survey type!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (SurveyNameTextBox.Text.Trim = "") Then
            SurveyNameTextBox.Focus()
            MessageBox.Show("Survey name is required!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (SurveyStartDatePicker.Value >= SurveyEndDatePicker.Value) Then
            SurveyEndDatePicker.Focus()
            MessageBox.Show("Your survey end date must be after your start date", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (SampleEncounterDateComboBox.SelectedIndex < 0) Then
            SampleEncounterDateComboBox.Focus()
            MessageBox.Show("You must select a sample encounter field!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (CutoffDateComboBox.SelectedIndex < 0) Then
            CutoffDateComboBox.Focus()
            MessageBox.Show("You must select a cutoff date field!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        If (ResurveyMethodComboBox.SelectedIndex < 0) Then
            ResurveyMethodComboBox.Focus()
            MessageBox.Show("You must select a resurvey method!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        Dim sampleUnits As Collection(Of SampleUnit) = SampleUnit.GetAllSampleUnitsForSurvey(mModule.EditingSurvey)
        For Each unit As SampleUnit In sampleUnits
            If Not SampleUnitCheck(unit) Then
                SurveyTypeComboBox.Focus()
                MessageBox.Show("You have existing sample unit(s) that don't match this survey type! Please correct sample unit(s)!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return False
            End If
        Next

        'Contracted Languages
        If mModule.Study.Client.ClientGroup IsNot Nothing AndAlso mModule.Study.Client.ClientGroup.Name = "OCS" AndAlso ContractedLanguagesListBox.CheckedItems.Count = 0 Then
            ContractedLanguagesListBox.Focus()
            MessageBox.Show("You must select at least one Contracted Language!", title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        Return True

    End Function

    Private Sub SaveInputData()

        With mModule.EditingSurvey
            .SurveyType = CType(SurveyTypeComboBox.SelectedValue, SurveyTypes)
            .Name = SurveyNameTextBox.Text.Trim
            .ContractNumber = ContractNumberTextBox.Text.Trim
            .ClientFacingName = FacingNameTextBox.Text.Trim
            .Description = SurveyDescriptionTextBox.Text.Trim
            .SamplingAlgorithm = CType(SamplingAlgorithmComboBox.SelectedValue, SamplingAlgorithm)
            .EnforceSkip = EnforceSkipYesOption.Checked
            .SurveyStartDate = SurveyStartDatePicker.Value
            .SurveyEndDate = SurveyEndDatePicker.Value
            .SurveySubType = CType(SurveySubTypeComboBox.SelectedItem, SurveySubType)

            Dim dateField As CutoffDateField = DirectCast(SampleEncounterDateComboBox.SelectedValue, CutoffDateField)
            If (dateField.CutoffDateFieldType = CutoffFieldType.NotApplicable) Then
                .SampleEncounterField = Nothing
            Else
                .SampleEncounterField = dateField.StudyTableColumn
            End If

            dateField = DirectCast(CutoffDateComboBox.SelectedValue, CutoffDateField)
            .CutoffResponseCode = dateField.CutoffDateFieldType
            If (dateField.CutoffDateFieldType = CutoffFieldType.CustomMetafield) Then
                .CutoffTableId = dateField.StudyTable.Id
                .CutoffFieldId = dateField.StudyTableColumn.Id
            Else
                .CutoffTableId = -1
                .CutoffFieldId = -1
            End If

            .ResponseRateRecalculationPeriod = CInt(RespRateRecalcDaysNumeric.Value)
            .ResurveyMethod = CType(ResurveyMethodComboBox.SelectedValue, ResurveyMethod)
            .ResurveyPeriod = CInt(ResurveyExcludionDaysNumeric.Value)
            .IsActive = Not InActivateCheckBox.Checked
            .ContractedLanguages = ContractedLanguages
        End With

    End Sub

    Private Sub TextBox_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles SurveyNameTextBox.GotFocus, FacingNameTextBox.GotFocus, ContractNumberTextBox.GotFocus

        Dim ctrl As TextBox = TryCast(sender, TextBox)
        If ctrl IsNot Nothing Then ctrl.SelectAll()

    End Sub

    Private Function SampleUnitCheck(ByVal unit As SampleUnit) As Boolean

        'TODO: SurveyRules.SurveyType = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
        Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
        Dim survey As Survey = New Survey()
        survey.SurveyType = surveyType
        'TODO: SurveyRules.CAHPSTypeOptions
        If survey.SurveyTypeName.Equals("HCAHPS") Then
            If unit.CAHPSType <> CAHPSType.HCAHPS AndAlso unit.CAHPSType <> CAHPSType.CHART AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        ElseIf survey.SurveyTypeName.Equals("ACOCAHPS") Then
            If unit.CAHPSType <> CAHPSType.ACOCAHPS AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        ElseIf survey.SurveyTypeName.Equals("Home Health CAHPS") Then
            If unit.CAHPSType <> CAHPSType.HHCAHPS AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        ElseIf survey.SurveyTypeName.Equals("CGCAHPS") Then
            If unit.CAHPSType <> CAHPSType.MNCM AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        ElseIf survey.SurveyTypeName.Contains("CAHPS") Then 'This is the generic CAHPS intended to work for any CAHPS going forward without code changes
            If unit.CAHPSType <> CAHPSType.CAHPS AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        Else
            If unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        End If

        Return True

    End Function

    Private Sub LoadSurveySubTypeComboBox(ByVal surveytypeid As Integer)
        SurveySubTypeComboBox.DataSource = Survey.GetSurveySubTypes(surveytypeid)
        SurveySubTypeComboBox.DisplayMember = "Description"
        SurveySubTypeComboBox.ValueMember = "Id"
        SurveySubTypeComboBox.SelectedIndex = -1
        If SurveySubTypeComboBox.Items.Count = 0 Then
            SurveySubTypeComboBox.Enabled = False
        Else
            SurveySubTypeComboBox.Enabled = True
        End If
    End Sub

    Private Sub LoadQuestionaireTypeComboBox(ByVal surveytypeid As Integer)
        QuestionaireTypeComboBox.DataSource = Survey.GetQuestionaireTypes(surveytypeid)
        QuestionaireTypeComboBox.DisplayMember = "Description"
        QuestionaireTypeComboBox.ValueMember = "Id"
        QuestionaireTypeComboBox.SelectedIndex = -1
        If QuestionaireTypeComboBox.Items.Count = 0 Then
            QuestionaireTypeComboBox.Enabled = False
        Else
            QuestionaireTypeComboBox.Enabled = True
        End If
    End Sub
#End Region

End Class
