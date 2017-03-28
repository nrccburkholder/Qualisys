Imports Nrc.Qualisys.Library
Imports System.Linq
Imports System.Text
Imports DevExpress.Utils
Imports DevExpress.XtraEditors
Imports DevExpress.XtraEditors.Controls


Public Class SurveyPropertiesEditor

#Region " Private Fields "

    Private mModule As SurveyPropertiesModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mIsLoading As Boolean = False
    Private mSubTypeList As SubTypeList = New SubTypeList()
    Private previousSurveyTypeIndex As Integer = 0
    Private deleteFacilityMapping As Boolean = False

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
        mIsLoading = True
        DisplayData()
        mIsLoading = False
    End Sub

    Private Sub SurveyTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyTypeComboBox.SelectedIndexChanged

        Try

            Dim cgCahpsSurveyType As SurveyType = GetSurveyTypeByName("CGCAHPS")

            If (SurveyTypeComboBox.SelectedIndex < 0) Then Return
            Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)

            Dim survey As Survey = New Survey()
            survey.SurveyType = surveyType

            LoadSurveySubTypeListBox(surveyType, survey.Id)

            Dim surveytypeid As Integer = 0

            surveytypeid = surveyType

            If Not mIsLoading Then
                If IsCGCahpsSurveyTypeChange(surveytypeid) Then

                    Dim previousSurveyTypeName As String = mModule.EditingSurvey.SurveyTypeName
                    Dim targetSurveyTypeName As String = GetSurveyTypeByID(surveytypeid).Description

                    Dim message As New StringBuilder()

                    message.AppendLine(String.Format("You are changing the Survey Type from {0} to {1}.", previousSurveyTypeName, targetSurveyTypeName))
                    message.AppendLine("")
                    message.AppendLine("This survey has existing facility mappings.")
                    message.AppendLine("Facility mappings will be cleared.")
                    message.AppendLine("")
                    message.AppendLine("Are you sure you want to do that?")

                    If MessageBox.Show(message.ToString(), "Are you sure about this?", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.No Then
                        SurveyTypeComboBox.SelectedIndex = previousSurveyTypeIndex
                        Exit Sub
                    End If

                End If
            End If

            LoadQuestionnaireTypeComboBox(surveytypeid, survey.Id)
            LoadResurveyExclusionTypeComboBox(surveytypeid, survey.Id)

            'lblResurveyMethod.Enabled = False
            ResurveyMethodComboBox.Enabled = False
            SamplingAlgorithmComboBox.SelectedIndex = DirectCast([Enum].Parse(GetType(SamplingAlgorithm), survey.SamplingAlgorithmDefault), Integer) - 1
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
            ResurveyMethodComboBox.SelectedIndex = DirectCast([Enum].Parse(GetType(ResurveyMethod), survey.ResurveyMethodDefault), Integer) - 1

            ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault
            ResurveyExcludionDaysNumeric.Enabled = Not survey.IsResurveyExclusionPeriodsNumericDisabled

            UseUSPSAddrChangeServiceCheckBox.Checked = survey.UseUSPSAddrChangeServiceDefault

            HandoutCheckBox.Visible = survey.HandoutsPermitted
            HandoutLabel.Visible = survey.HandoutsPermitted

            PointInTimeCheckBox.Visible = Not survey.PointInTimeDisallowed
            PointInTimeLabel.Visible = Not survey.PointInTimeDisallowed

            previousSurveyTypeIndex = SurveyTypeComboBox.SelectedIndex

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

    Private Sub SurveySubTypeListBox_ItemCheck(sender As System.Object, e As System.Windows.Forms.ItemCheckEventArgs) Handles SurveySubTypeListBox.ItemCheck

        If Not mIsLoading Then

            Dim idx As Integer = e.Index
            Dim selectedItem As SubType = CType(SurveySubTypeListBox.Items(idx), SubType)

            Dim iRuleOverrideCount As Integer = GetSubtypeBitRuleOverrideCount()

            Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
            Dim survey As Survey = New Survey()
            survey.SurveyType = surveyType

            ' Because this doesn't specifically know if an checkbox item is being checked or unchecked,
            ' we have to figure out what it's going to be.  

            Dim cList As List(Of SubType) = New List(Of SubType)
            For Each item As SubType In SurveySubTypeListBox.CheckedItems
                cList.Add(item)
            Next

            If Not cList.Contains(DirectCast(SurveySubTypeListBox.Items(e.Index), SubType)) Then
                cList.Add(DirectCast(SurveySubTypeListBox.Items(e.Index), SubType))
            ElseIf e.NewValue = CheckState.Unchecked Then
                cList.Remove(DirectCast(SurveySubTypeListBox.Items(e.Index), SubType))
            End If

            Dim stl As SubTypeList = FilterSubtypeCategoryComboBox(cList)

            LoadSubtypeCategoryImageComboBox(QuestionnaireTypeImageComboBox, stl, mModule.EditingSurvey.Id)
            LoadSubtypeCategoryImageComboBox(ResurveyExclusionTypeImageComboBox, stl, mModule.EditingSurvey.Id)

            If selectedItem.IsRuleOverride Then
                If e.NewValue = CheckState.Checked Then
                    iRuleOverrideCount += 1
                    If iRuleOverrideCount = 1 Then
                        ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault(selectedItem.SubTypeName)
                        ResurveyExcludionDaysNumeric.Enabled = Not survey.IsResurveyExclusionPeriodsNumericDisabled(selectedItem.SubTypeName)
                    End If
                Else
                    iRuleOverrideCount -= 1
                    ResurveyExcludionDaysNumeric.Value = survey.ResurveyExclusionPeriodsNumericDefault
                    ResurveyExcludionDaysNumeric.Enabled = Not survey.IsResurveyExclusionPeriodsNumericDisabled
                End If
            End If

            If iRuleOverrideCount > 1 Then
                e.NewValue = e.CurrentValue
                MessageBox.Show("You can't have more than one sub-type with a Rule Override!", "Illegal Sub-Type Selection", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If

            If e.NewValue = CheckState.Checked And Not selectedItem.WasSelected Then
                selectedItem.IsNew = True
                selectedItem.IsDirty = True
            ElseIf e.NewValue = CheckState.Unchecked And selectedItem.WasSelected Then
                selectedItem.NeedsDeleted = True
                selectedItem.IsDirty = True
            Else
                selectedItem.NeedsDeleted = False
                selectedItem.IsNew = False
                selectedItem.IsDirty = False
            End If

        End If

    End Sub

    Private Sub QuestionnaireTypeImageComboBox_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles QuestionnaireTypeImageComboBox.SelectedIndexChanged
        If Not mIsLoading Then

            If QuestionnaireTypeImageComboBox.SelectedItem IsNot Nothing Then

                Dim selectedItem As SubType = CType(CType(QuestionnaireTypeImageComboBox.SelectedItem, ImageComboBoxItem).Value, SubType)

                If selectedItem.IsActive = False Then
                    MessageBox.Show("You can't use that Questionnaire Version.  It's INACTIVE!", "Invalid Questionnaire Version", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                    If mModule.EditingSurvey.QuestionnaireType.IsActive = False Then
                        QuestionnaireTypeImageComboBox.SelectedIndex = 0
                    Else
                        If mModule.EditingSurvey.QuestionnaireType IsNot Nothing Then
                            SelectQuestionnaireSubtype(mModule.EditingSurvey.QuestionnaireType.SubTypeId)
                        End If
                    End If
                    Exit Sub
                End If

                If mModule.EditingSurvey.QuestionnaireType IsNot Nothing Then
                    If selectedItem.SubTypeId <> mModule.EditingSurvey.QuestionnaireType.SubTypeId Then
                        If selectedItem.SubTypeId = 0 Then selectedItem.NeedsDeleted = True
                        selectedItem.IsDirty = True
                    Else
                        selectedItem.IsDirty = False
                    End If
                End If

            Else
                If mModule.EditingSurvey.QuestionnaireType IsNot Nothing Then
                    SelectQuestionnaireSubtype(mModule.EditingSurvey.QuestionnaireType.SubTypeId)
                End If
            End If



        End If
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

        'Must fill these combo boxes prior to SelectedIndexChanged call generated for SurveyType just ahead
        SamplingAlgorithmComboBox.DataSource = Survey.GetSamplingAlgorithms
        ResurveyMethodComboBox.DataSource = Survey.GetResurveyMethods

        'Survey type list
        SurveyTypeComboBox.DataSource = Survey.GetSurveyTypes
        SurveyTypeComboBox.SelectedValue = mModule.EditingSurvey.SurveyType
        If (SurveyTypeComboBox.Items.Count > 0 AndAlso SurveyTypeComboBox.SelectedIndex < 0) Then
            SurveyTypeComboBox.SelectedIndex = 0
        End If

        SurveyTypeComboBox.Enabled = mModule.EditingSurvey.IsSurveyTypeEditable

        'Survey SubType list
        Dim surveyTypeID As Integer = CInt(SurveyTypeComboBox.SelectedValue)
        LoadSurveySubTypeListBox(surveyTypeID, mModule.EditingSurvey.Id)

        'questionnaire Type list
        LoadQuestionnaireTypeComboBox(surveyTypeID, mModule.EditingSurvey.Id)

        'resurvey exclusion Type list
        LoadResurveyExclusionTypeComboBox(surveyTypeID, mModule.EditingSurvey.Id)

        'Set up disabled controls based on survey subtype (not a value saved with the survey, per se)
        Dim override As String = mModule.EditingSurvey.SurveySubTypeOverrideName() 'will retrieve PCMH for example CJB 8/14/2014

        ResurveyExcludionDaysNumeric.Enabled = Not mModule.EditingSurvey.IsResurveyExclusionPeriodsNumericDisabled(override)

        'Facing name
        FacingNameTextBox.Text = mModule.EditingSurvey.ClientFacingName

        'Survey description
        SurveyDescriptionTextBox.Text = mModule.EditingSurvey.Description

        'Sampling Algorithm
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
                    If (mModule.EditingSurvey.SampleEncounterField IsNot Nothing AndAlso
                        field.StudyTable.Id = mModule.EditingSurvey.SampleEncounterField.TableId AndAlso
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
                    If (field.CutoffDateFieldType = mModule.EditingSurvey.CutoffResponseCode AndAlso
                        field.StudyTable.Id = mModule.EditingSurvey.CutoffTableId AndAlso
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
        ResurveyMethodComboBox.SelectedValue = mModule.EditingSurvey.ResurveyMethod
        If (ResurveyMethodComboBox.Items.Count > 0 AndAlso ResurveyMethodComboBox.SelectedIndex < 0) Then
            ResurveyMethodComboBox.SelectedIndex = 0
        End If
        If (mModule.EditingSurvey.IsResurveyMethodDisabled) Then
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

        If mModule.EditingSurvey.Id <> 0 Then
            PointInTimeCheckBox.Visible = Not mModule.EditingSurvey.PointInTimeDisallowed
            HandoutCheckBox.Visible = mModule.EditingSurvey.HandoutsPermitted
            PointInTimeLabel.Visible = Not mModule.EditingSurvey.PointInTimeDisallowed
            HandoutLabel.Visible = mModule.EditingSurvey.HandoutsPermitted
        End If

        UseUSPSAddrChangeServiceCheckBox.Checked = mModule.EditingSurvey.UseUSPSAddrChangeService
        HandoutCheckBox.Checked = mModule.EditingSurvey.IsHandout
        PointInTimeCheckBox.Checked = mModule.EditingSurvey.IsPointInTime

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

        ' For each selected subtype, check to see if a QuestionnaireType is required
        Dim isQuestionnaireRequiredError As Boolean = False
        Dim alertMessage As New StringBuilder
        alertMessage.Append("You must select a Questionnaire Type for the following selected SubType(s):")
        alertMessage.Append(vbCrLf)
        alertMessage.Append(vbCrLf)
        For Each st As SubType In SurveySubTypeListBox.CheckedItems
            If st.IsQuestionnaireRequired Then
                ' If required, then we need to make sure that a QuestionnaireType was selected.
                If CType(CType(QuestionnaireTypeImageComboBox.SelectedItem, ImageComboBoxItem).Value, SubType).SubTypeId = 0 Then
                    alertMessage.Append(st.SubTypeName)
                    alertMessage.Append(vbCrLf)
                    isQuestionnaireRequiredError = True
                End If
            End If
        Next

        ' If there is a missing Questionnaire, display the message to the user.
        If isQuestionnaireRequiredError Then
            QuestionnaireTypeImageComboBox.Focus()
            MessageBox.Show(alertMessage.ToString(), title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return False
        End If

        Return True

    End Function

    Private Sub SaveInputData()

        Dim surveyTypeId As Integer = CType(SurveyTypeComboBox.SelectedValue, SurveyTypes)
        Dim clearFacilityMappings As Boolean = IsCGCahpsSurveyTypeChange(surveyTypeId)

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
            .SurveySubTypes = SetSurveySubTypes()
            .QuestionnaireType = SetQuestionnaireType()
            .ResurveyExclusionType = SetResurveyExclusionType()

            .ClearFacilityMappings = clearFacilityMappings


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
            .UseUSPSAddrChangeService = UseUSPSAddrChangeServiceCheckBox.Checked
            .IsHandout = HandoutCheckBox.Checked
            .IsPointInTime = PointInTimeCheckBox.Checked

        End With

    End Sub

    Private Sub TextBox_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles SurveyNameTextBox.GotFocus, FacingNameTextBox.GotFocus, ContractNumberTextBox.GotFocus

        Dim ctrl As TextBox = TryCast(sender, TextBox)
        If ctrl IsNot Nothing Then ctrl.SelectAll()

    End Sub

    Private Function SampleUnitCheck(ByVal unit As SampleUnit) As Boolean

        Dim surveyType As SurveyTypes = CType(SurveyTypeComboBox.SelectedValue, Library.SurveyTypes)
        Dim survey As Survey = New Survey()
        survey.SurveyType = surveyType

        If survey.IsCAHPS Then 'This is the generic CAHPS intended to work for any CAHPS going forward without code changes
            If unit.CAHPSType <> survey.SurveyType AndAlso unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        Else
            If unit.CAHPSType <> CAHPSType.None Then
                Return False
            End If
        End If

        Return True

    End Function

    Private Sub LoadSurveySubTypeListBox(ByVal surveytypeid As Integer, ByVal surveyid As Integer)

        SurveySubTypeListBox.DataSource = Survey.GetSubTypes(surveytypeid, SubtypeCategories.Subtype, surveyid)
        SurveySubTypeListBox.DisplayMember = "DisplayName"
        SurveySubTypeListBox.ValueMember = "SubTypeId"

        If SurveySubTypeListBox.Items.Count = 0 Then
            SurveySubTypeListBox.Enabled = False
            SurveySubTypeListBox.BackColor = Color.FromKnownColor(KnownColor.Control)
        Else
            SurveySubTypeListBox.Enabled = True
            SurveySubTypeListBox.BackColor = Color.FromKnownColor(KnownColor.Window)
            Dim i As Integer
            For i = 0 To SurveySubTypeListBox.Items.Count - 1
                If CType(SurveySubTypeListBox.Items(i), SubType).WasSelected Then
                    SurveySubTypeListBox.SetItemChecked(i, True)
                End If
            Next
        End If

    End Sub

    Private Sub LoadQuestionnaireTypeComboBox(ByVal surveytypeid As Integer, ByVal surveyid As Integer)

        ' create a list of all questionnairetypes 
        mSubTypeList = Survey.GetSubTypes(surveytypeid, SubtypeCategories.QuestionnaireType, surveyid)

        ' create a list of SubType items that are checked, then filter
        Dim cList As List(Of SubType) = New List(Of SubType)
        For Each item As SubType In SurveySubTypeListBox.CheckedItems
            cList.Add(item)
        Next

        Dim stl As SubTypeList = FilterSubtypeCategoryComboBox(cList)

        Dim questionnaireSubtypeId As Integer

        If Not mModule.EditingSurvey.QuestionnaireType Is Nothing Then
            questionnaireSubtypeId = mModule.EditingSurvey.QuestionnaireType.SubTypeId
        Else
            questionnaireSubtypeId = -1
        End If

        LoadSubtypeCategoryImageComboBox(QuestionnaireTypeImageComboBox, stl, surveyid, questionnaireSubtypeId)

        QuestionnaireTypeImageComboBox.SelectedIndex = 0

        If QuestionnaireTypeImageComboBox.Properties.Items.Count < 2 Then
            QuestionnaireTypeImageComboBox.Enabled = False
        Else
            QuestionnaireTypeImageComboBox.Enabled = True
            If mModule.EditingSurvey.QuestionnaireType IsNot Nothing Then
                If mModule.EditingSurvey.QuestionnaireType.SubTypeId = 0 Then
                    QuestionnaireTypeImageComboBox.SelectedIndex = 0
                Else
                    SelectQuestionnaireSubtype(mModule.EditingSurvey.QuestionnaireType.SubTypeId)
                End If
            End If
        End If

    End Sub

    Private Function FilterSubtypeCategoryComboBox(ByVal _subTypeList As List(Of SubType)) As SubTypeList

        Dim parentSubTypeIDList As List(Of Integer) = New List(Of Integer)
        ' create a list of the parentSubType ids for the checked items
        If _subTypeList.Count > 0 Then

            ' check if any of the selected subtypes is an override
            If _subTypeList.Where(Function(s) (s.IsRuleOverride = True)).Count > 0 Then
                ' add the overrides to the list.
                For Each subtypeItem As SubType In _subTypeList.Where(Function(s) (s.IsRuleOverride = True))
                    parentSubTypeIDList.Add(subtypeItem.ParentSubTypeId)
                Next
            Else
                ' none of the selections is an override, so add them all to the list
                For Each subtypeItem As SubType In _subTypeList
                    parentSubTypeIDList.Add(subtypeItem.ParentSubTypeId)
                Next

            End If
        Else
            parentSubTypeIDList.Add(0)
        End If

        ' make a distinct list of subtype id's 
        parentSubTypeIDList = parentSubTypeIDList.Distinct().ToList

        '  if any of the Non-mapped subtypes are selected, we just return the whole list
        If parentSubTypeIDList.Contains(0) Then
            Return mSubTypeList
        Else
            ' otherwise, we filter on questionnaires that are mapped specifically to subtypes
            Dim tempSubTypeList As New SubTypeList()

            For Each item As SubType In mSubTypeList
                If parentSubTypeIDList.Contains(item.ParentSubTypeId) Or item.SubTypeId = 0 Then ' item.Subtype = 0 represents N/A, so we always include it
                    tempSubTypeList.Add(item)
                End If
            Next

            Return tempSubTypeList

        End If

    End Function

    Private Function SetSurveySubTypes() As SubTypeList

        Dim items As SubTypeList = New SubTypeList
        For Each st As SubType In SurveySubTypeListBox.Items
            items.Add(st)
        Next

        Return items

    End Function

    Private Function SetQuestionnaireType() As SubType

        'If QuestionnaireTypeComboBox.SelectedItem Is Nothing Then
        '    Return Nothing
        'Else
        '    Return CType(QuestionnaireTypeComboBox.SelectedItem, SubType)
        'End If


        If QuestionnaireTypeImageComboBox.SelectedItem Is Nothing Then
            Return Nothing
        Else
            Return CType(CType(QuestionnaireTypeImageComboBox.SelectedItem, ImageComboBoxItem).Value, SubType)
        End If

    End Function

    Private Function SetResurveyExclusionType() As SubType

        'If QuestionnaireTypeComboBox.SelectedItem Is Nothing Then
        '    Return Nothing
        'Else
        '    Return CType(QuestionnaireTypeComboBox.SelectedItem, SubType)
        'End If


        If ResurveyExclusionTypeImageComboBox.SelectedItem Is Nothing Then
            Return Nothing
        Else
            Return CType(CType(ResurveyExclusionTypeImageComboBox.SelectedItem, ImageComboBoxItem).Value, SubType)
        End If

    End Function

    Private Function GetSubtypeBitRuleOverrideCount() As Integer

        Dim iRuleOverrideCount As Integer = 0

        For Each st As SubType In SurveySubTypeListBox.CheckedItems
            If st.IsRuleOverride Then iRuleOverrideCount += 1
        Next

        Return iRuleOverrideCount

    End Function

    Private Sub SelectQuestionnaireSubtype(ByVal subtypeId As Integer)
        For Each item As ImageComboBoxItem In QuestionnaireTypeImageComboBox.Properties.Items
            Dim itemSubType As SubType = CType(item.Value, SubType)
            If itemSubType.SubTypeId = subtypeId Then
                QuestionnaireTypeImageComboBox.SelectedItem = item
                Exit For
            End If
        Next
    End Sub

    Private Sub SelectResurveyExclusionSubtype(ByVal subtypeId As Integer)
        For Each item As ImageComboBoxItem In ResurveyExclusionTypeImageComboBox.Properties.Items
            Dim itemSubType As SubType = CType(item.Value, SubType)
            If itemSubType.SubTypeId = subtypeId Then
                ResurveyExclusionTypeImageComboBox.SelectedItem = item
                Exit For
            End If
        Next
    End Sub

    Private Function GetSurveyTypeByName(ByVal name As String) As SurveyType

        For Each s As SurveyType In Library.SurveyType.GetAll()
            If s.Description.ToUpper().Equals(name.ToUpper()) Then Return s

        Next

        Return Nothing

    End Function

    Private Function GetSurveyTypeByID(ByVal ID As Integer) As SurveyType

        For Each s As SurveyType In Library.SurveyType.GetAll()
            If s.Id = ID Then Return s

        Next

        Return Nothing

    End Function

    Private Function IsCGCahpsSurveyTypeChange(ByVal selectedSurveyTypeId As Integer) As Boolean

        Dim hasFacilityMapping As Boolean = mModule.EditingSurvey.HasFacilityMapping
        Dim previousSurveyTypeId As Integer = mModule.EditingSurvey.SurveyType
        Dim cgCahpsSurveyType As SurveyType = GetSurveyTypeByName("CGCAHPS")

        If previousSurveyTypeId <> selectedSurveyTypeId AndAlso (selectedSurveyTypeId = cgCahpsSurveyType.CAHPSTypeId Or previousSurveyTypeId = cgCahpsSurveyType.CAHPSTypeId) AndAlso hasFacilityMapping Then
            Return True
        End If

    End Function

    Private Sub ResurveyExclusionTypeImageComboBox_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ResurveyExclusionTypeImageComboBox.SelectedIndexChanged
        If Not mIsLoading Then

            If ResurveyExclusionTypeImageComboBox.SelectedItem IsNot Nothing Then

                Dim selectedItem As SubType = CType(CType(ResurveyExclusionTypeImageComboBox.SelectedItem, ImageComboBoxItem).Value, SubType)

                If selectedItem.IsActive = False Then
                    MessageBox.Show("You can't use that Resurvey Exclusion Type.  It's INACTIVE!", "Invalid Questionnaire Version", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                    If mModule.EditingSurvey.ResurveyExclusionType.IsActive = False Then
                        ResurveyExclusionTypeImageComboBox.SelectedIndex = 0
                    Else
                        If mModule.EditingSurvey.ResurveyExclusionType IsNot Nothing Then
                            SelectResurveyExclusionSubtype(mModule.EditingSurvey.ResurveyExclusionType.SubTypeId)
                        End If
                    End If
                    Exit Sub
                End If

                If mModule.EditingSurvey.ResurveyExclusionType IsNot Nothing Then
                    If selectedItem.SubTypeId <> mModule.EditingSurvey.ResurveyExclusionType.SubTypeId Then
                        If selectedItem.SubTypeId = 0 Then selectedItem.NeedsDeleted = True
                        selectedItem.IsDirty = True
                    Else
                        selectedItem.IsDirty = False
                    End If
                End If

            Else
                If mModule.EditingSurvey.ResurveyExclusionType IsNot Nothing Then
                    SelectResurveyExclusionSubtype(mModule.EditingSurvey.ResurveyExclusionType.SubTypeId)
                End If
            End If

        End If

    End Sub

    Private Sub LoadResurveyExclusionTypeComboBox(ByVal surveytypeid As Integer, ByVal surveyid As Integer)

        ' create a list of all resurveyExclusionTypes 
        mSubTypeList = Survey.GetSubTypes(surveytypeid, SubtypeCategories.ResurveyExclusionType, surveyid)

        ' create a list of SubType items that are checked, then filter
        Dim cList As List(Of SubType) = New List(Of SubType)
        For Each item As SubType In SurveySubTypeListBox.CheckedItems
            cList.Add(item)
        Next

        Dim stl As SubTypeList = FilterSubtypeCategoryComboBox(cList)

        Dim resurveyExclusionSubtypeId As Integer

        If Not mModule.EditingSurvey.ResurveyExclusionType Is Nothing Then
            resurveyExclusionSubtypeId = mModule.EditingSurvey.ResurveyExclusionType.SubTypeId
        Else
            resurveyExclusionSubtypeId = -1
        End If

        LoadSubtypeCategoryImageComboBox(ResurveyExclusionTypeImageComboBox, stl, surveyid, resurveyExclusionSubtypeId)

        ResurveyExclusionTypeImageComboBox.SelectedIndex = 0

        If ResurveyExclusionTypeImageComboBox.Properties.Items.Count < 2 Then
            ResurveyExclusionTypeImageComboBox.Enabled = False
        Else
            ResurveyExclusionTypeImageComboBox.Enabled = True
            If mModule.EditingSurvey.ResurveyExclusionType IsNot Nothing Then
                If mModule.EditingSurvey.ResurveyExclusionType.SubTypeId = 0 Then
                    ResurveyExclusionTypeImageComboBox.SelectedIndex = 0
                Else
                    SelectResurveyExclusionSubtype(mModule.EditingSurvey.ResurveyExclusionType.SubTypeId)
                End If
            End If
        End If

    End Sub

    Private Sub LoadSubtypeCategoryImageComboBox(ByRef SubtypeCategoryImageComboBox As ImageComboBoxEdit, ByVal list As SubTypeList, ByVal surveyid As Integer, Optional ByVal selectedSubTypeId As Integer = -1)
        SubtypeCategoryImageComboBox.Properties.Items.Clear()
        For Each item As SubType In list

            Dim display As Boolean = True
            If (surveyid = 0 And item.IsActive = False) Or (item.IsActive = False And item.SubTypeId <> selectedSubTypeId) Then
                display = False
            End If

            If display Then
                Dim imageIndex As Integer

                If item.SubTypeId = 0 Then
                    imageIndex = 2
                Else
                    imageIndex = Convert.ToInt32(item.IsActive)
                End If

                Dim icbi As New ImageComboBoxItem(item, imageIndex)
                icbi.Description = item.DisplayName
                icbi.Value = item
                SubtypeCategoryImageComboBox.Properties.Items.Add(icbi)
            End If

        Next

        SubtypeCategoryImageComboBox.Properties.SmallImages = SubtypeCategoryImageCollection
    End Sub

#End Region

End Class
