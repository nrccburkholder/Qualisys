Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Survey

#Region " Private Instance Fields "

    Private mId As Integer
    Private mName As String = String.Empty
    Private mContractNumber As String = String.Empty
    Private mDescription As String = String.Empty
    Private mStudyId As Integer
    Private mCutoffResponseCode As CutoffFieldType
    Private mCutoffTableId As Integer
    Private mCutoffFieldId As Integer
    Private mSampleEncounterField As StudyTableColumn
    Private mSamplePlanId As Integer
    Private mResponseRateRecalculationPeriod As Integer
    Private mResurveyPeriod As Integer
    Private mSurveyStartDate As Date
    Private mSurveyEndDate As Date
    Private mSamplingAlgorithm As SamplingAlgorithm
    Private mIsActive As Boolean
    Private mUseUSPSAddrChangeService As Boolean
    Private mContractedLanguages As String = String.Empty
    Private mEnforceSkip As Boolean = True
    Private mClientFacingName As String = String.Empty
    Private mSurveyType As SurveyTypes
    Private mSurveyTypeDefId As Integer
    Private mResurveyMethod As ResurveyMethod
    Private mHouseHoldingType As HouseHoldingType
    Private mHouseHoldingColumns As StudyTableColumnCollection
    Private mSurveySubtypes As SubTypeList
    Private mQuestionnaireType As SubType

    Private mIsDirty As Boolean
    Private mIsValidated As Boolean
    Private mDateValidated As DateTime
    Private mIsFormGenReleased As Boolean
    Private mStudy As Study
    Private mSamplePeriods As SamplePeriodCollection
    Private mCutoffTable As StudyTable
    Private mCutoffField As StudyTableColumn
    Private mBusinessRules As Collection(Of BusinessRule)
    Private mClearFacilityMappings As Boolean

#Region "private variables used as temporary stores of Survey Rules"

    Private mIsCAHPS As Boolean = False
    Private mHasOptionCHART As Boolean = False
    Private mIsMonthlyOnly As Boolean = False
    Private mIsSystematic As Boolean = False
    Private mSamplingToolPriority As Integer = 0
    Private mSamplingMethodDefault As String = String.Empty
    Private mIsSamplingMethodDisabled As Boolean = False
    Private mSamplingAlgorithmDefault As String = String.Empty
    Private mSkipEnforcementRequired As Boolean = False
    Private mRespRateRecalsDaysNumericDefault As Integer = 0
    Private mResurveyMethodDefault As String = String.Empty
    Private mResurveyExclusionPeriodsNumericDefault As Integer = 0
    Private mIsResurveyExclusionPeriodsNumericDisabled As Boolean = False
    Private mHasReportability As Boolean = False
    Private mNotEditableIfSampled As Boolean = False
    Private mIsResurveyMethodDisabled As Boolean = False
    Private mMedicareIdTextMayBeBlank As Boolean = False
    Private mFacilitiesArePracticeSites As Boolean = False
    Private mCompliesWithSwitchToPropSamplingDate As Boolean = False
    Private mAllowOverSample As Boolean = False
    Private mCheckMedicareProportion As Boolean = False
    Private mByPassInitRespRateNumericEnforcement As Boolean = False
    Private mUseUSPSAddrChangeServiceDefault As Boolean = False
    Private mDefaultScheduleDateAdjustmentByMonths As Integer = 0


#End Region

    Private Shared mSurveyTypeList As List(Of ListItem(Of SurveyTypes))
    Private Shared mSamplingAlgorithmList As List(Of ListItem(Of SamplingAlgorithm))
    Private Shared mResurveyMethodList As List(Of ListItem(Of ResurveyMethod))

#End Region

#Region " Public Properties "

#Region " Persisted Properties "

    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ContractNumber() As String
        Get
            Return mContractNumber
        End Get
        Set(ByVal value As String)
            If mContractNumber <> value Then
                mContractNumber = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If mDescription <> value Then
                mDescription = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If mStudyId <> value Then
                mStudyId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SamplePlanId() As Integer
        Get
            Return mSamplePlanId
        End Get
        Set(ByVal value As Integer)
            If mSamplePlanId <> value Then
                mSamplePlanId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property CutoffResponseCode() As CutoffFieldType
        Get
            Return mCutoffResponseCode
        End Get
        Set(ByVal value As CutoffFieldType)
            If mCutoffResponseCode <> value Then
                mCutoffResponseCode = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property CutoffTableId() As Integer
        Get
            Return mCutoffTableId
        End Get
        Set(ByVal value As Integer)
            If mCutoffTableId <> value Then
                mCutoffTableId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property CutoffFieldId() As Integer
        Get
            Return mCutoffFieldId
        End Get
        Set(ByVal value As Integer)
            If mCutoffFieldId <> value Then
                mCutoffFieldId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SampleEncounterField() As StudyTableColumn
        Get
            Return mSampleEncounterField
        End Get
        Set(ByVal value As StudyTableColumn)
            If (mSampleEncounterField Is Nothing AndAlso _
                value Is Nothing) Then
                Return
            End If

            If (mSampleEncounterField IsNot Nothing AndAlso _
                value IsNot Nothing AndAlso _
                mSampleEncounterField.TableId = value.TableId AndAlso _
                mSampleEncounterField.Id = value.Id) Then
                Return
            End If

            mSampleEncounterField = value
            mIsDirty = True
        End Set
    End Property

    <Logable()> _
    Public Property ResponseRateRecalculationPeriod() As Integer
        Get
            Return mResponseRateRecalculationPeriod
        End Get
        Set(ByVal value As Integer)
            If mResponseRateRecalculationPeriod <> value Then
                mResponseRateRecalculationPeriod = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ResurveyPeriod() As Integer
        Get
            Return mResurveyPeriod
        End Get
        Set(ByVal value As Integer)
            If mResurveyPeriod <> value Then
                mResurveyPeriod = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyStartDate() As Date
        Get
            Return mSurveyStartDate
        End Get
        Set(ByVal value As Date)
            If mSurveyStartDate <> value Then
                mSurveyStartDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyEndDate() As Date
        Get
            Return mSurveyEndDate
        End Get
        Set(ByVal value As Date)
            If mSurveyEndDate <> value Then
                mSurveyEndDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SamplingAlgorithm() As SamplingAlgorithm
        Get
            Return mSamplingAlgorithm
        End Get
        Set(ByVal value As SamplingAlgorithm)
            If mSamplingAlgorithm <> value Then
                mSamplingAlgorithm = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property EnforceSkip() As Boolean
        Get
            Return mEnforceSkip
        End Get
        Set(ByVal value As Boolean)
            If mEnforceSkip <> value Then
                mEnforceSkip = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ClientFacingName() As String
        Get
            Return mClientFacingName
        End Get
        Set(ByVal value As String)
            If mClientFacingName <> value Then
                mClientFacingName = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyType() As SurveyTypes
        Get
            Return mSurveyType
        End Get
        Set(ByVal value As SurveyTypes)
            If mSurveyType <> value Then
                mSurveyType = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyTypeDefId() As Integer
        Get
            Return mSurveyTypeDefId
        End Get
        Set(ByVal value As Integer)
            If mSurveyTypeDefId <> value Then
                mSurveyTypeDefId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ResurveyMethod() As ResurveyMethod
        Get
            Return mResurveyMethod
        End Get
        Set(ByVal value As ResurveyMethod)
            If (mResurveyMethod <> value) Then
                mResurveyMethod = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property HouseHoldingType() As HouseHoldingType
        Get
            Return mHouseHoldingType
        End Get
        Set(ByVal value As HouseHoldingType)
            If mHouseHoldingType <> value Then
                mHouseHoldingType = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsValidated() As Boolean
        Get
            Return mIsValidated
        End Get
        Set(ByVal value As Boolean)
            If mIsValidated <> value Then
                mIsValidated = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsFormGenReleased() As Boolean
        Get
            Return mIsFormGenReleased
        End Get
        Set(ByVal value As Boolean)
            If mIsFormGenReleased <> value Then
                mIsFormGenReleased = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If mIsActive <> value Then
                mIsActive = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property UseUSPSAddrChangeService() As Boolean
        Get
            Return mUseUSPSAddrChangeService
        End Get
        Set(ByVal value As Boolean)
            If mUseUSPSAddrChangeService <> value Then
                mUseUSPSAddrChangeService = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ContractedLanguages() As String
        Get
            Return mContractedLanguages
        End Get
        Set(ByVal value As String)
            If mContractedLanguages <> value Then
                mContractedLanguages = value
                mIsDirty = True
            End If
        End Set
    End Property


    <Logable()> _
    Public Property SurveySubTypes() As SubTypeList
        Get
            Return mSurveySubtypes
        End Get
        Set(ByVal value As SubTypeList)
            mSurveySubtypes = value
            If mSurveySubtypes.IsDirty Then
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuestionnaireType() As SubType
        Get
            Return mQuestionnaireType
        End Get
        Set(ByVal value As SubType)
            If mQuestionnaireType IsNot Nothing And value IsNot Nothing Then
                If mQuestionnaireType.SubTypeId <> value.SubTypeId Then
                    mQuestionnaireType = value
                    mIsDirty = True
                End If
            ElseIf mQuestionnaireType Is Nothing And value IsNot Nothing Then
                mQuestionnaireType = New SubType()
                mQuestionnaireType = value
                mIsDirty = False
            End If
        End Set
    End Property

#End Region

    Public Property DateValidated() As DateTime
        Get
            Return mDateValidated
        End Get
        Set(ByVal value As DateTime)
            If mDateValidated <> value Then
                mDateValidated = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property HouseHoldingFields() As StudyTableColumnCollection
        Get
            If mHouseHoldingColumns Is Nothing Then
                mHouseHoldingColumns = StudyTableColumn.GetHouseHoldingColumnsBySurveyId(Id)
            End If

            Return mHouseHoldingColumns
        End Get
    End Property

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    Public ReadOnly Property Study() As Study
        Get
            If mStudy Is Nothing Then
                mStudy = Nrc.QualiSys.Library.Study.GetStudy(mStudyId)
            End If

            Return mStudy
        End Get
    End Property

    Public ReadOnly Property SamplePeriods() As SamplePeriodCollection
        Get
            If mSamplePeriods Is Nothing Then
                mSamplePeriods = SamplePeriod.GetBySurveyId(mId)
            End If

            Return mSamplePeriods
        End Get
    End Property

    Public ReadOnly Property SampleablePeriods() As Collection(Of SamplePeriod)
        Get
            Dim periods As New Collection(Of SamplePeriod)

            For Each period As SamplePeriod In SamplePeriods
                If period.PeriodTimeFrame <> SamplePeriod.TimeFrame.Future Then periods.Add(period)
            Next

            Return periods
        End Get
    End Property

    Public ReadOnly Property ActiveSamplePeriod() As SamplePeriod
        Get
            For Each period As SamplePeriod In SamplePeriods
                If period.IsActive Then
                    Return period
                End If
            Next

            Return Nothing
        End Get
    End Property

    Public ReadOnly Property CutoffFieldType() As CutoffFieldType
        Get
            If System.Enum.IsDefined(GetType(CutoffFieldType), mCutoffResponseCode) Then
                Return CType(mCutoffResponseCode, CutoffFieldType)
            Else
                Throw New ApplicationException("Unknown cutoff field type " & mCutoffResponseCode)
            End If
        End Get
    End Property

    Public ReadOnly Property CutoffTable() As StudyTable
        Get
            If Not CutoffFieldType = CutoffFieldType.CustomMetafield Then
                Return Nothing
            End If

            If mCutoffTable Is Nothing Then
                Dim tables As Collection(Of StudyTable) = Study.GetStudyTables
                For Each tbl As StudyTable In tables
                    If tbl.Id = mCutoffTableId Then
                        mCutoffTable = tbl
                        Exit For
                    End If
                Next
            End If

            Return mCutoffTable
        End Get
    End Property

    Public ReadOnly Property CutoffField() As StudyTableColumn
        Get
            If Not CutoffFieldType = CutoffFieldType.CustomMetafield Then
                Return Nothing
            End If

            If mCutoffField Is Nothing Then
                For Each field As StudyTableColumn In CutoffTable.Columns
                    If field.Id = mCutoffFieldId Then
                        mCutoffField = field
                        Exit For
                    End If
                Next
            End If

            Return mCutoffField
        End Get
    End Property

    Public ReadOnly Property CutoffFieldLabel() As String
        Get
            Select Case CutoffFieldType
                Case CutoffFieldType.SampleCreate
                    Return "SampleCreate"

                Case CutoffFieldType.ReturnDate
                    Return "ReturnDate"

                Case CutoffFieldType.CustomMetafield
                    Return String.Format("{0}.{1}", CutoffTable.Name, CutoffField.Name)

                Case Else
                    Return "Unknown"

            End Select
        End Get
    End Property

    Public Property IsReportable() As Boolean
        Get
            If (Me.HasReportability) Then
                If (mSurveyTypeDefId = ReportStatus.Reportable) Then
                    Return True
                Else
                    Return False
                End If
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            If (Me.HasReportability) Then
                If value Then
                    SurveyTypeDefId = ReportStatus.Reportable
                Else
                    SurveyTypeDefId = ReportStatus.NotReportable
                End If
            End If
        End Set
    End Property

    Public ReadOnly Property BusinessRules() As Collection(Of BusinessRule)
        Get
            If mBusinessRules Is Nothing Then
                mBusinessRules = BusinessRule.GetBySurvey(Me)
            End If

            Return mBusinessRules
        End Get
    End Property

    Public ReadOnly Property IsSampled() As Boolean
        Get
            Return SurveyProvider.Instance.IsSurveySampled(Id)
        End Get
    End Property

    Public ReadOnly Property IsSurveyTypeEditable() As Boolean
        Get
            If (Me.NotEditableIfSampled AndAlso IsSampled) Then
                Return False
            Else
                Return True
            End If
        End Get
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Public ReadOnly Property HasFacilityMapping() As Boolean
        Get
            Return SurveyProvider.Instance.HasFacilityMapping(Id)
        End Get
    End Property

    Public Property ClearFacilityMappings As Boolean
        Get
            Return mClearFacilityMappings
        End Get
        Set(ByVal value As Boolean)
            mClearFacilityMappings = value
        End Set

    End Property

#Region "Survey rules generic getters currently hooked up to AppConfig / QualPro_Params"

    ''' <summary>
    ''' Introduces the ability to override survey type with survey sub type for rule look-ups
    ''' </summary>
    ''' <value></value>
    ''' <returns>the name of any overriding sub type if selected</returns>
    ''' <remarks>will retrieve PCMH for example CJB 8/14/2014</remarks>
    Public ReadOnly Property SurveySubTypeOverrideName() As String
        Get
            Dim override As String = vbNullString
            If SurveySubTypes IsNot Nothing Then
                For Each subtype As SubType In SurveySubTypes
                    If subtype.IsRuleOverride Then
                        override = subtype.SubTypeName
                    End If
                Next
            End If
            Return override
        End Get
    End Property

    Public ReadOnly Property SurveyTypeName() As String
        Get
            If mSurveyTypeList Is Nothing Then
                GetSurveyTypes()
            End If

            For Each st As Nrc.QualiSys.Library.ListItem(Of SurveyTypes) In mSurveyTypeList
                If st.Value.Equals(mSurveyType) Then
                    Return st.ToString()
                End If
            Next
            Return String.Empty
        End Get
    End Property


    Private Function SpecificRuleName(ByVal ruleName As String, Optional ByVal override As String = vbNullString) As String
        Try
            If String.IsNullOrEmpty(override) Then
                Return "SurveyRule: " + ruleName + " - " + SurveyTypeName()
            Else
                Return "SurveyRule: " + ruleName + " - " + override
            End If
        Catch ex As Exception
            Return "SurveyRule: " + ruleName + " - " + SurveyType.ToString()
        End Try
    End Function

    Private Function GenericRuleName(ByVal ruleName As String) As String
        Return "SurveyRule: " + ruleName
    End Function

    Private Sub GetSurveyRule(ByVal ruleName As String, ByRef result As String, Optional ByVal override As String = vbNullString)
        Try
            If SurveyType <> 0 Then
                result = AppConfig.Params(SpecificRuleName(ruleName, override)).StringValue
                Return
            End If
        Catch
        End Try

        Try
            result = AppConfig.Params(GenericRuleName(ruleName)).StringValue
        Catch
            result = String.Empty
        End Try
    End Sub

    Private Sub GetSurveyRule(ByVal ruleName As String, ByRef result As Integer, Optional ByVal override As String = vbNullString)
        Try
            If SurveyType <> 0 Then
                result = AppConfig.Params(SpecificRuleName(ruleName, override)).IntegerValue
                Return
            End If
        Catch
        End Try

        Try
            result = AppConfig.Params(GenericRuleName(ruleName)).IntegerValue
        Catch
            result = 0
        End Try
    End Sub

    Private Sub GetSurveyRule(ByVal ruleName As String, ByRef result As Boolean, Optional ByVal override As String = vbNullString)
        Try
            If SurveyType <> 0 Then
                result = AppConfig.Params(SpecificRuleName(ruleName, override)).StringValue = "1"
                Return
            End If
        Catch
        End Try

        Try
            result = AppConfig.Params(GenericRuleName(ruleName)).StringValue = "1"
        Catch
            result = False
        End Try
    End Sub

#End Region

#Region "SurveyRules acessing generic Survey Rule API"

    Public ReadOnly Property IsCAHPS(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsCahps", mIsCAHPS, override)
            Return mIsCAHPS
        End Get
    End Property

    Public ReadOnly Property HasOptionCHART(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("HasOptionCHART", mHasOptionCHART, override)
            Return mHasOptionCHART
        End Get
    End Property

    Public ReadOnly Property IsMonthlyOnly(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsMonthlyOnly", mIsMonthlyOnly, override)
            Return mIsMonthlyOnly
        End Get
    End Property

    Public ReadOnly Property SamplingToolPriority(Optional ByVal override As String = vbNullString) As Integer
        Get
            GetSurveyRule("SamplingToolPriority", mSamplingToolPriority, override)
            Return mSamplingToolPriority
        End Get
    End Property

    Public ReadOnly Property SamplingMethodDefault(Optional ByVal override As String = vbNullString) As String
        Get
            GetSurveyRule("SamplingMethodDefault", mSamplingMethodDefault, override)
            Return mSamplingMethodDefault
        End Get
    End Property

    Public ReadOnly Property IsSamplingMethodDisabled(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsSamplingMethodDisabled", mIsSamplingMethodDisabled, override)
            Return mIsSamplingMethodDisabled
        End Get
    End Property

    Public ReadOnly Property SamplingAlgorithmDefault(Optional ByVal override As String = vbNullString) As String
        Get
            GetSurveyRule("SamplingAlgorithmDefault", mSamplingAlgorithmDefault, override)
            Return mSamplingAlgorithmDefault
        End Get
    End Property

    Public ReadOnly Property SkipEnforcementRequired(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("SkipEnforcementRequired", mSkipEnforcementRequired, override)
            Return mSkipEnforcementRequired
        End Get
    End Property

    Public ReadOnly Property RespRateRecalsDaysNumericDefault(Optional ByVal override As String = vbNullString) As Integer
        Get
            GetSurveyRule("RespRateRecalcDaysNumericDefault", mRespRateRecalsDaysNumericDefault, override)
            Return mRespRateRecalsDaysNumericDefault
        End Get
    End Property

    Public ReadOnly Property ResurveyMethodDefault(Optional ByVal override As String = vbNullString) As String
        Get
            GetSurveyRule("ResurveyMethodDefault", mResurveyMethodDefault, override)
            Return mResurveyMethodDefault
        End Get
    End Property

    Public ReadOnly Property ResurveyExclusionPeriodsNumericDefault(Optional ByVal override As String = vbNullString) As Integer
        Get
            GetSurveyRule("ResurveyExclusionPeriodsNumericDefault", mResurveyExclusionPeriodsNumericDefault, override)
            Return mResurveyExclusionPeriodsNumericDefault
        End Get
    End Property

    Public ReadOnly Property IsResurveyExclusionPeriodsNumericDisabled(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsResurveyExclusionPeriodsNumericDisabled", mIsResurveyExclusionPeriodsNumericDisabled, override)
            Return mIsResurveyExclusionPeriodsNumericDisabled
        End Get
    End Property

    Public ReadOnly Property UseUSPSAddrChangeServiceDefault(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("UseUSPSAddrChangeServiceDefault", mUseUSPSAddrChangeServiceDefault, override)
            Return mUseUSPSAddrChangeServiceDefault
        End Get
    End Property

    Public ReadOnly Property HasReportability(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("HasReportability", mHasReportability, override)
            Return mHasReportability
        End Get
    End Property

    Public ReadOnly Property NotEditableIfSampled(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("NotEditableIfSampled", mNotEditableIfSampled, override)
            Return mNotEditableIfSampled
        End Get
    End Property

    Public ReadOnly Property IsResurveyMethodDisabled(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsResurveyMethodDisabled", mIsResurveyMethodDisabled, override)
            Return mIsResurveyMethodDisabled
        End Get
    End Property

    Public ReadOnly Property MedicareIdTextMayBeBlank(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("MedicareIdTextMayBeBlank", mMedicareIdTextMayBeBlank, override)
            Return mMedicareIdTextMayBeBlank
        End Get
    End Property

    Public ReadOnly Property FacilitiesArePracticeSites(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("FacilitiesArePracticeSites", mFacilitiesArePracticeSites, override)
            Return mFacilitiesArePracticeSites
        End Get
    End Property

    Public ReadOnly Property CompliesWithSwitchToPropSamplingDate(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("CompliesWithSwitchToPropSamplingDate", mCompliesWithSwitchToPropSamplingDate, override)
            Return mCompliesWithSwitchToPropSamplingDate
        End Get
    End Property

    Public ReadOnly Property AllowOverSample(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("AllowOverSample", mAllowOverSample, override)
            Return mAllowOverSample
        End Get
    End Property

    Public ReadOnly Property CheckMedicareProportion(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("CheckMedicareProportion", mCheckMedicareProportion, override)
            Return mCheckMedicareProportion
        End Get
    End Property

    Public ReadOnly Property BypassInitRespRateNumericEnforcement(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("BypassInitRespRateNumericEnforcement", mByPassInitRespRateNumericEnforcement, override)
            Return mByPassInitRespRateNumericEnforcement
        End Get
    End Property

    Public ReadOnly Property DefaultScheduleDateAdjustmentByMonths(Optional ByVal override As String = vbNullString) As Integer
        Get
            GetSurveyRule("DefaultScheduleDateAdjustmentByMonths", mDefaultScheduleDateAdjustmentByMonths, override)
            Return mDefaultScheduleDateAdjustmentByMonths
        End Get
    End Property

    Public ReadOnly Property IsSystematic(Optional ByVal override As String = vbNullString) As Boolean
        Get
            GetSurveyRule("IsSystematic", mIsSystematic, override)
            Return mIsSystematic
        End Get
    End Property

#End Region

    Public ReadOnly Property AllowDelete() As Boolean
        Get
            Return SurveyProvider.Instance.AllowDelete(mId)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

    Public Sub New(ByVal parentStudy As Study)

        Me.New()
        mStudy = parentStudy
        If (parentStudy IsNot Nothing) Then mStudyId = parentStudy.Id

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function [Get](ByVal surveyId As Integer) As Survey

        Return SurveyProvider.Instance.[Select](surveyId)

    End Function

    Public Shared Function GetByStudy(ByVal study As Study) As Collection(Of Survey)

        Return SurveyProvider.Instance.SelectByStudy(study)

    End Function

    Public Shared Function GetMailSurveysBySurveyType(ByVal srvyType As SurveyType) As Collection(Of Survey)

        Return SurveyProvider.Instance.SelectBySurveyTypeMailOnly(srvyType)

    End Function

    Public Shared Function GetSurveyTypes() As List(Of ListItem(Of SurveyTypes))

        If (mSurveyTypeList Is Nothing) Then
            mSurveyTypeList = SurveyProvider.Instance.SelectSurveyTypes()
        End If

        Return mSurveyTypeList

    End Function

    Public Shared Function GetSamplingAlgorithms() As List(Of ListItem(Of SamplingAlgorithm))

        If (mSamplingAlgorithmList Is Nothing) Then
            mSamplingAlgorithmList = SurveyProvider.Instance.SelectSamplingAlgorithms
        End If

        Return mSamplingAlgorithmList

    End Function

    Public Shared Function GetResurveyMethods() As List(Of ListItem(Of ResurveyMethod))

        If (mResurveyMethodList Is Nothing) Then
            mResurveyMethodList = SurveyProvider.Instance.SelectResurveyMethod
        End If

        Return mResurveyMethodList

    End Function

    Public Sub Update()

        Dim changes As List(Of AuditLogChange) = GetChanges()
        SurveyProvider.Instance.Update(Me)

        AuditLog.LogChanges(changes)

    End Sub

    Public Shared Function CreateNew(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal responseRateRecalculationPeriod As Integer, _
                                     ByVal resurveyMethodId As ResurveyMethod, ByVal resurveyPeriod As Integer, ByVal surveyStartDate As Date, ByVal surveyEndDate As Date, _
                                     ByVal samplingAlgorithmId As Integer, ByVal enforceSkip As Boolean, ByVal cutoffResponseCode As String, ByVal cutoffTableId As Integer, _
                                     ByVal cutoffFieldId As Integer, ByVal sampleEncounterField As StudyTableColumn, ByVal clientFacingName As String, _
                                     ByVal surveyTypeId As Integer, ByVal surveyTypeDefId As Integer, ByVal houseHoldingType As HouseHoldingType, _
                                     ByVal contractNumber As String, ByVal isActive As Boolean, ByVal contractedLanguages As String, ByVal srvySubTypes As SubTypeList, _
                                     ByVal questionnairesubtype As SubType, ByVal UseUSPSAddrChangeService As Boolean) As Survey

        Return SurveyProvider.Instance.Insert(studyId, name, description, responseRateRecalculationPeriod, resurveyMethodId, resurveyPeriod, surveyStartDate, surveyEndDate, _
                                              samplingAlgorithmId, enforceSkip, cutoffResponseCode, cutoffTableId, cutoffFieldId, sampleEncounterField, clientFacingName, _
                                              surveyTypeId, surveyTypeDefId, houseHoldingType, contractNumber, isActive, contractedLanguages, srvySubTypes, questionnairesubtype, _
                                              UseUSPSAddrChangeService)

    End Function

    Public Shared Sub Delete(ByVal surveyId As Integer)

        SurveyProvider.Instance.Delete(surveyId)

    End Sub


    Public Shared Function GetSubTypes(ByVal surveytypeid As Integer, ByVal categoryid As SubtypeCategories, ByVal surveyid As Integer) As SubTypeList

        Dim mSurveySubTypeList As New SubTypeList

        mSurveySubTypeList = SurveyProvider.Instance.SelectSubTypes(surveytypeid, categoryid, surveyid)

        mSurveySubTypeList.ResetDirtyFlag()

        Return mSurveySubTypeList

    End Function

#End Region

#Region " ChangeLog Helper Functions "

    Friend Function GetChanges() As List(Of AuditLogChange)

        Dim changes As List(Of AuditLogChange)

        'Check to see if this is a new survey
        If Id <> 0 Then
            Dim original As Survey = Survey.Get(Id)
            changes = AuditLog.CompareObjects(Of Survey)(original, Me, "Id", AuditLogObject.Survey)
            If HouseHoldingFields IsNot Nothing Then GetHouseholdingChanges(changes, original)
        Else
            changes = AuditLog.CompareObjects(Of Survey)(Nothing, Me, "Id", AuditLogObject.Survey)

            'Add code to add Householding fields
            For Each hh As StudyTableColumn In HouseHoldingFields
                changes.Add(New AuditLogChange(Me, "Id", "HouseHoldingField", AuditLogChangeType.Add, Nothing, String.Format("table_id={0}, field_id={1}", hh.TableId, hh.Id), AuditLogObject.Survey))
            Next
        End If

        If BusinessRules IsNot Nothing Then
            For Each busRule As BusinessRule In BusinessRules
                changes.AddRange(busRule.GetChanges)
            Next
        End If

        Return changes

    End Function

    Private Sub GetHouseholdingChanges(ByVal changes As List(Of AuditLogChange), ByVal original As Survey)

        Dim hhAdds As New Collection(Of StudyTableColumn)
        Dim hhDeletes As New Collection(Of StudyTableColumn)

        'Check for New fields
        'First add the new field to the hhAdds collection.  If we find that field in the 
        'Original list, we then remove the field from the hhAdds collection.
        For Each hhNew As StudyTableColumn In HouseHoldingFields
            hhAdds.Add(hhNew)
            For Each hhOrig As StudyTableColumn In original.HouseHoldingFields
                If (hhNew.Id = hhOrig.Id AndAlso hhNew.TableId = hhOrig.TableId) Then
                    hhAdds.RemoveAt(hhAdds.Count - 1)
                    Exit For
                End If
            Next
        Next

        'Check for Deleted fields
        'First add the new field to the hhDeletes collection.  If we find that field in the 
        'New list, we then remove the field from the hhDeletes collection.
        For Each hhOrig As StudyTableColumn In original.HouseHoldingFields
            hhDeletes.Add(hhOrig)
            For Each hhnew As StudyTableColumn In HouseHoldingFields
                If (hhnew.Id = hhOrig.Id AndAlso hhnew.TableId = hhOrig.TableId) Then
                    hhDeletes.RemoveAt(hhDeletes.Count - 1)
                    Exit For
                End If
            Next
        Next

        For Each hh As StudyTableColumn In hhAdds
            changes.Add(New AuditLogChange(Me, "Id", "HouseHoldingField", AuditLogChangeType.Add, Nothing, String.Format("table_id={0}, field_id={1}", hh.TableId, hh.Id), AuditLogObject.Survey))
        Next

        For Each hh As StudyTableColumn In hhDeletes
            changes.Add(New AuditLogChange(Me, "Id", "HouseHoldingField", AuditLogChangeType.Delete, String.Format("table_id={0}, field_id={1}", hh.TableId, hh.Id), Nothing, AuditLogObject.Survey))
        Next

    End Sub

#End Region

#Region " Public Methods "

    Public Function GetExistingSampleSetData(ByVal creationStartDate As Date, ByVal creationEndDate As Date, ByVal showOnlyUnscheduled As Boolean) As DataTable

        Return SampleSetProvider.Instance.SelectBySurveyId(mId, creationStartDate, creationEndDate, showOnlyUnscheduled)

    End Function

    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    ''' <summary>
    ''' This method is used the refresh the IsActive flag and the collection of samples for each period
    ''' in a survey.
    ''' </summary>
    ''' <remarks>This method should only be used after a sample is completed.  It does not do a complete
    ''' refresh of each period object.</remarks>
    Public Sub RefreshSamplePeriodsAfterSampling()

        Dim newPeriods As New Dictionary(Of Integer, SamplePeriod)

        For Each period As SamplePeriod In SamplePeriod.GetBySurveyId(Id)
            newPeriods.Add(period.Id, period)
        Next

        For Each currentPeriod As SamplePeriod In SamplePeriods
            Dim newPeriod As SamplePeriod = newPeriods.Item(currentPeriod.Id)

            currentPeriod.PeriodTimeFrame = newPeriod.PeriodTimeFrame
            currentPeriod.SampleSets.Clear()

            For Each ss As SampleSet In newPeriod.SampleSets
                currentPeriod.SampleSets.Add(ss)
            Next
        Next

    End Sub

    ''' <summary>
    ''' Refreshes the survey by retrieving the current instance from the database.
    ''' </summary>
    ''' <remarks>This method is used to get updated values when the survey is updated outside of
    ''' the current application.</remarks>
    Public Sub Refresh()

        Dim current As Survey = Survey.[Get](Id)

        With current
            mCutoffField = Nothing
            mCutoffFieldId = .mCutoffFieldId
            mCutoffResponseCode = .mCutoffResponseCode
            mCutoffTable = Nothing
            mCutoffTableId = .mCutoffTableId
            mSampleEncounterField = .mSampleEncounterField
            mDescription = .mDescription
            mId = .mId
            mIsValidated = .mIsValidated
            mName = .mName
            mSamplePeriods = Nothing
            mResponseRateRecalculationPeriod = .mResponseRateRecalculationPeriod
            mResurveyPeriod = .mResurveyPeriod
            mSurveyStartDate = .mSurveyStartDate
            mSurveyEndDate = .mSurveyEndDate
            mSamplingAlgorithm = .mSamplingAlgorithm
            mEnforceSkip = .mEnforceSkip
            mClientFacingName = .mClientFacingName
            mSurveyType = .mSurveyType
            mSurveyTypeDefId = .mSurveyTypeDefId
            mResurveyMethod = .mResurveyMethod
            mSamplePlanId = .mSamplePlanId
            mHouseHoldingType = .mHouseHoldingType
            mHouseHoldingColumns = Nothing
            mBusinessRules = Nothing
            mIsActive = .mIsActive
            ContractedLanguages = .ContractedLanguages
            mSurveySubtypes = .mSurveySubtypes
            mQuestionnaireType = .mQuestionnaireType
        End With

        mIsDirty = False

    End Sub

    Public Function GetSurveyLanguages() As Collection(Of Language)

        Return Language.GetLanguagesAvailableForSurvey(mId)

    End Function

    Public Function GetCoverLetters() As Collection(Of CoverLetter)

        Return CoverLetter.GetBySurveyId(mId)

    End Function

    Public Function GetCoverLettersByPageType(ByVal PageType As Integer) As Collection(Of CoverLetter)

        Return CoverLetter.GetBySurveyIdAndPageType(mId, PageType)

    End Function

    Public Function GetCoverLettersByPageTypes(ByVal PageTypes As Integer()) As Collection(Of CoverLetter)

        Return CoverLetter.GetBySurveyIdAndPageTypes(mId, PageTypes)

    End Function

    Public Function PerformSurveyValidation() As SurveyValidationResult

        Return SurveyProvider.Instance.PerformSurveyValidation(mId)

    End Function

#End Region

End Class
