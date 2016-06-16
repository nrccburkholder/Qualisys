Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.Notification
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()> _
Public Class MedicareNumber
    Inherits BusinessBase(Of MedicareNumber)

#Region "Private Fields"

    Private mLastRecalcLoaded As Boolean
    Private mLastRecalcUserCensusForcedLoaded As Boolean
    Private mHistoricLoaded As Boolean

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareNumber As String = String.Empty
    Private mName As String = String.Empty
    Private mProportionCalcTypeID As MedicareProportionCalcTypes
    Private mProportionCalcType As MedicarePropCalcType
    Private mEstAnnualVolume As Integer
    Private mEstResponseRate As Decimal
    Private mEstIneligibleRate As Decimal
    Private mSwitchToCalcDate As Date
    Private mAnnualReturnTarget As Integer
    Private mSamplingLocked As Boolean
    Private mProportionChangeThreshold As Decimal
    Private mCensusForced As Boolean
    Private mCanUseHistoric As Boolean
    Private mAnnualEligibleVolume As Integer
    Private mHistoricResponseRate As Decimal
    Private mPENumber As String = String.Empty
    Private mIsActive As Boolean = True
    Private mUserCensusForced As Integer
    Private mSystematicAnnualReturnTarget As Integer
    Private mSystematicEstRespRate As Decimal
    Private mSystematicSwitchToCalcDate As Date
    Private mNonSubmitting As Boolean = False

    Private mCalculationErrors As New List(Of String)

    Private mLastRecalcHistory As MedicareRecalcHistory
    Private mLastRecalcHistoryUserCensusForced As MedicareRecalcHistory
    Private mMedicareGlobalDates As MedicareGlobalCalcDateCollection

#End Region

#Region "Public Properties"

#Region "MedicareLookup Properties"

    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
                PropertyHasChanged("MedicareNumber")
            End If
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property

    Public Property ProportionCalcTypeID() As MedicareProportionCalcTypes
        Get
            Return mProportionCalcTypeID
        End Get
        Set(ByVal value As MedicareProportionCalcTypes)
            If Not value = mProportionCalcTypeID Then
                mProportionCalcTypeID = value
                PropertyHasChanged("ProportionCalcTypeID")
            End If
        End Set
    End Property

    Public ReadOnly Property ProportionCalcType() As MedicarePropCalcType
        Get
            If mProportionCalcType Is Nothing OrElse mProportionCalcType.MedicarePropCalcTypeId <> mProportionCalcTypeID Then
                mProportionCalcType = MedicarePropCalcType.Get(mProportionCalcTypeID)
            End If
            Return mProportionCalcType
        End Get
    End Property

    Public Property EstAnnualVolume() As Integer
        Get
            Return mEstAnnualVolume
        End Get
        Set(ByVal value As Integer)
            If Not value = mEstAnnualVolume Then
                mEstAnnualVolume = value
                PropertyHasChanged("EstAnnualVolume")
            End If
        End Set
    End Property

    Public Property EstResponseRate() As Decimal
        Get
            Return mEstResponseRate
        End Get
        Set(ByVal value As Decimal)
            If Not value = mEstResponseRate Then
                mEstResponseRate = value
                PropertyHasChanged("EstResponseRate")
            End If
        End Set
    End Property

    Public Property EstIneligibleRate() As Decimal
        Get
            Return mEstIneligibleRate
        End Get
        Set(ByVal value As Decimal)
            If Not value = mEstIneligibleRate Then
                mEstIneligibleRate = value
                PropertyHasChanged("EstIneligibleRate")
            End If
        End Set
    End Property

    Public Property SwitchToCalcDate() As Date
        Get
            Return mSwitchToCalcDate
        End Get
        Set(ByVal value As Date)
            If Not value = mSwitchToCalcDate Then
                mSwitchToCalcDate = value
                PropertyHasChanged("SwitchToCalcDate")
            End If
        End Set
    End Property

    Public Property AnnualReturnTarget() As Integer
        Get
            Return mAnnualReturnTarget
        End Get
        Set(ByVal value As Integer)
            If Not value = mAnnualReturnTarget Then
                mAnnualReturnTarget = value
                PropertyHasChanged("AnnualReturnTarget")
            End If
        End Set
    End Property

    Public Property SamplingLocked() As Boolean
        Get
            Return mSamplingLocked
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSamplingLocked Then
                mSamplingLocked = value
                PropertyHasChanged("SamplingLocked")
            End If
        End Set
    End Property

    Public Property ProportionChangeThreshold() As Decimal
        Get
            Return mProportionChangeThreshold
        End Get
        Set(ByVal value As Decimal)
            If Not value = mProportionChangeThreshold Then
                mProportionChangeThreshold = value
                PropertyHasChanged("ProportionChangeThreshold")
            End If
        End Set
    End Property

    Public Property CensusForced() As Boolean
        Get
            Return mCensusForced
        End Get
        Set(ByVal value As Boolean)
            If Not value = mCensusForced Then
                mCensusForced = value
                PropertyHasChanged("CensusForced")
            End If
        End Set
    End Property

    Public Property PENumber() As String
        Get
            Return mPENumber
        End Get
        Set(ByVal value As String)
            If mPENumber <> value Then
                mPENumber = value
                PropertyHasChanged("PENumber")
            End If
        End Set
    End Property

    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsActive Then
                mIsActive = value
                PropertyHasChanged("IsActive")
            End If
        End Set
    End Property

    Public Property NonSubmitting() As Boolean
        Get
            Return mNonSubmitting
        End Get
        Set(ByVal value As Boolean)
            If Not value = mNonSubmitting Then
                mNonSubmitting = value
                PropertyHasChanged("NonSubmitting")
            End If
        End Set
    End Property

    Public Property SystematicAnnualReturnTarget() As Integer
        Get
            Return mSystematicAnnualReturnTarget
        End Get
        Set(ByVal value As Integer)
            If Not value = mSystematicAnnualReturnTarget Then
                mSystematicAnnualReturnTarget = value
                PropertyHasChanged("SystematicAnnualReturnTarget")
            End If
        End Set
    End Property

    Public Property SystematicEstRespRate() As Decimal
        Get
            Return mSystematicEstRespRate
        End Get
        Set(ByVal value As Decimal)
            If Not value = mSystematicEstRespRate Then
                mSystematicEstRespRate = value
                PropertyHasChanged("SystematicEstRespRate")
            End If
        End Set
    End Property

    Public Property SystematicSwitchToCalcDate() As Date
        Get
            Return mSystematicSwitchToCalcDate
        End Get
        Set(ByVal value As Date)
            If Not value = mSystematicSwitchToCalcDate Then
                mSystematicSwitchToCalcDate = value
                PropertyHasChanged("SystematicEstRespRate")
            End If
        End Set
    End Property

    Public Property UserCensusForced() As Integer
        Get
            Return mUserCensusForced
        End Get
        Set(ByVal value As Integer)
            If Not value = mUserCensusForced Then
                mUserCensusForced = value
                PropertyHasChanged("UserCensusForced")
            End If
        End Set
    End Property

    Public ReadOnly Property SystemCensusForced() As Integer
        Get
            Return -1
        End Get
    End Property

#End Region

#Region "MedicareLookup Display Properties"

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mMedicareNumber, mName)
        End Get
    End Property

    Public Property EstResponseRateDisplay() As Decimal
        Get
            Return EstResponseRate * 100
        End Get
        Set(ByVal value As Decimal)
            If Not value = EstResponseRate * 100 Then
                EstResponseRate = value / 100
                PropertyHasChanged("EstResponseRateDisplay")
            End If
        End Set
    End Property

    Public Property EstIneligibleRateDisplay() As Decimal
        Get
            Return EstIneligibleRate * 100
        End Get
        Set(ByVal value As Decimal)
            If Not value = EstIneligibleRate * 100 Then
                EstIneligibleRate = value / 100
                PropertyHasChanged("EstIneligibleRateDisplay")
            End If
        End Set
    End Property

    Public Property ProportionChangeThresholdDisplay() As Decimal
        Get
            Return ProportionChangeThreshold * 100
        End Get
        Set(ByVal value As Decimal)
            If Not value = ProportionChangeThreshold * 100 Then
                ProportionChangeThreshold = value / 100
                PropertyHasChanged("ProportionChangeThresholdDisplay")
            End If
        End Set
    End Property

    Public Property IsInactive() As Boolean
        Get
            Return Not IsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = (Not IsActive) Then
                IsActive = Not value
                PropertyHasChanged("IsInactive")
            End If
        End Set
    End Property

    Public ReadOnly Property SamplingLockedImage() As System.Drawing.Image
        Get
            If mSamplingLocked Then
                Return My.Resources.SamplingLocked16
            Else
                Return My.Resources.SamplingUnlocked16
            End If
        End Get
    End Property

#End Region

#Region "MedicareRecalcHistory Properties"

    Public ReadOnly Property LastRecalcDateCalculated() As Date
        Get
            If LastRecalcHistory Is Nothing Then
                Return Date.MinValue
            Else
                Return LastRecalcHistory.DateCalculated
            End If
        End Get
    End Property

    Public ReadOnly Property LastRecalcPropCalcType() As MedicarePropCalcType
        Get
            If LastRecalcHistory Is Nothing Then
                Return Nothing
            Else
                Return MedicarePropCalcType.Get(LastRecalcHistory.MedicarePropCalcTypeID)
            End If
        End Get
    End Property

    Public ReadOnly Property LastRecalcCensusForced() As Boolean
        Get
            If LastRecalcHistory Is Nothing Then
                Return False
            Else
                Return LastRecalcHistory.CensusForced
            End If
        End Get
    End Property

    Public ReadOnly Property LastRecalcProportion() As Decimal
        Get
            If LastRecalcHistory Is Nothing Then
                Return 0
            Else
                Return LastRecalcHistory.ProportionCalcPct
            End If
        End Get
    End Property

    Public ReadOnly Property LastRecalcPropSampleCalcDate() As Date
        Get
            If LastRecalcHistory Is Nothing Then
                Return Date.MinValue
            Else
                Return LastRecalcHistory.PropSampleCalcDate
            End If
        End Get
    End Property

#End Region

#Region "MedicareRecalcHistory Display Properties"

    Public ReadOnly Property LastRecalcProportionDisplay() As Decimal
        Get
            Return LastRecalcProportion * 100
        End Get
    End Property

#End Region

#Region "Historic Properties"

    Public ReadOnly Property CanUseHistoric() As Boolean
        Get
            If Not mHistoricLoaded Then
                mCanUseHistoric = GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate)
                mHistoricLoaded = True
            End If
            Return mCanUseHistoric
        End Get
    End Property

    Public ReadOnly Property AnnualEligibleVolume() As Integer
        Get
            If Not mHistoricLoaded Then
                mCanUseHistoric = GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate)
                mHistoricLoaded = True
            End If
            Return mAnnualEligibleVolume
        End Get
    End Property

    Public ReadOnly Property HistoricResponseRate() As Decimal
        Get
            If Not mHistoricLoaded Then
                mCanUseHistoric = GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate)
                mHistoricLoaded = True
            End If
            Return mHistoricResponseRate
        End Get
    End Property

#End Region

#Region "Historic Display Properties"

    Public ReadOnly Property HistoricResponseRateDisplay() As Decimal
        Get
            Return HistoricResponseRate * 100
        End Get
    End Property

#End Region

#End Region

#Region "Calculation Error Properties"

    Public ReadOnly Property CalculationErrors() As List(Of String)
        Get
            Return mCalculationErrors
        End Get
    End Property

#End Region

#Region "Private Properties"

    Private ReadOnly Property MedicareGlobalDates() As MedicareGlobalCalcDateCollection
        Get
            If Me.mMedicareGlobalDates Is Nothing Then
                Me.mMedicareGlobalDates = MedicareGlobalCalcDate.GetAll()
            End If
            Return Me.mMedicareGlobalDates
        End Get
    End Property

    Private ReadOnly Property LastRecalcHistory() As MedicareRecalcHistory
        Get
            If mLastRecalcHistory Is Nothing AndAlso Not mLastRecalcLoaded Then
                mLastRecalcHistory = MedicareRecalcHistory.GetLatestByMedicareNumber(mMedicareNumber, Date.Now, False)
                mLastRecalcLoaded = True
            End If
            Return mLastRecalcHistory
        End Get
    End Property

    Private ReadOnly Property LastRecalcHistoryUserCensusForced() As MedicareRecalcHistory
        Get
            If mLastRecalcHistoryUserCensusForced Is Nothing AndAlso Not mLastRecalcUserCensusForcedLoaded Then
                mLastRecalcHistoryUserCensusForced = MedicareRecalcHistory.GetLatestByMedicareNumber(mMedicareNumber, Date.Now, True)
                mLastRecalcUserCensusForcedLoaded = True
            End If
            Return mLastRecalcHistoryUserCensusForced
        End Get
    End Property


#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region "Overrides"

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return MedicareNumber
        End If

    End Function

    Protected Overrides Sub AddBusinessRules()

        ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Name", 45))
        ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("MedicareNumber", 20))
        '        ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("PENumber", 50))
        ValidationRules.AddRule(AddressOf ValidateMedicareNumber, "MedicareNumber")
        ValidationRules.AddRule(AddressOf ValidateMedicareNumberIsUnique, "MedicareNumber")
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("EstAnnualVolume", 1))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("EstResponseRateDisplay", CDec(0.99)))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("EstIneligibleRateDisplay", CDec(0.99)))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Date), New Validation.MinValueRuleArgs(Of Date)("SwitchToCalcDate", CDate("1/1/2000")))
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("AnnualReturnTarget", 1))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("ProportionChangeThresholdDisplay", CDec(0.99)))
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("SystematicAnnualReturnTarget", 1))
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("SystematicEstRespRate", 1))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Date), New Validation.MinValueRuleArgs(Of Date)("SystematicSwitchToCalcDate", CDate("1/1/2000")))

    End Sub

    Public Overrides Function ToString() As String

        Return MedicareNumber

    End Function

#End Region

#Region "Validation Methods"

    Private Function ValidateMedicareNumber(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        If String.IsNullOrEmpty(MedicareNumber) Then
            e.Description = "You must provide a Medicare Number!"
            Return False
        Else
            For Each letter As Char In MedicareNumber.ToCharArray
                If Not (Char.IsLetter(letter) OrElse Char.IsNumber(letter)) Then
                    e.Description = "The Medicare Number can only include numbers and letters!"
                    Return False
                End If
            Next
        End If

        Return True

    End Function

    Private Function ValidateMedicareNumberIsUnique(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        Dim medicareList As MedicareNumberList = TryCast(Parent, MedicareNumberList)

        If medicareList IsNot Nothing Then
            For Each medicareNum As MedicareNumber In medicareList
                If GetIdValue.ToString <> medicareNum.GetIdValue.ToString AndAlso MedicareNumber = medicareNum.MedicareNumber Then
                    e.Description = "This Medicare Number already exists!"
                    Return False
                End If
            Next
        End If

        Return True

    End Function

#End Region

#Region "Public Methods"

    Protected Overrides Sub CreateNew()

        'Get the global default values
        Dim globalDef As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.GetAll()(0)

        'Set default values
        ProportionCalcTypeID = MedicareProportionCalcTypes.Historical
        SwitchToCalcDate = Date.Now.AddYears(1)
        EstResponseRate = globalDef.RespRate
        EstIneligibleRate = globalDef.IneligibleRate
        ProportionChangeThreshold = globalDef.ProportionChangeThreshold
        AnnualReturnTarget = globalDef.AnnualReturnTarget

        SystematicSwitchToCalcDate = Date.Now.AddMonths(8)
        SystematicAnnualReturnTarget = AppConfig.Params("SystematicAnnualReturnTarget").IntegerValue
        SystematicEstRespRate = AppConfig.Params("SystematicEstimatedResponseRate").IntegerValue

        'Validate the object
        ValidationRules.CheckRules()

    End Sub

    Public Shared Function [Get](ByVal medicareNumber As String) As MedicareNumber

        Return MedicareProvider.Instance.Select(medicareNumber)

    End Function

    Public Shared Function GetAll() As MedicareNumberList

        Return MedicareProvider.Instance.SelectAll

    End Function

    Public Shared Function GetAllAsDictionary() As Dictionary(Of String, MedicareNumber)

        Return MedicareProvider.Instance.SelectAllAsDictionary

    End Function

    Public Shared Function GetBySurveyID(ByVal surveyID As Integer) As MedicareNumberList

        Return MedicareProvider.Instance.SelectBySurveyID(surveyID)

    End Function

    Public Shared Function GetSamplingLockedBySurveyIDs(ByVal surveyIDs As String) As DataTable

        Return MedicareProvider.Instance.SelectSamplingLockedBySurveyIDs(surveyIDs)

    End Function

    Protected Overrides Sub Insert()

        MedicareProvider.Instance.Insert(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        MedicareProvider.Instance.Delete(MedicareNumber)

    End Sub

    Public Shared Function AllowDelete(ByVal medicareNumber As String) As Boolean

        Return MedicareProvider.Instance.AllowDelete(medicareNumber)

    End Function

    Public Shared Sub DeleteNow(ByVal medicareNumber As String)

        MedicareProvider.Instance.Delete(medicareNumber)

    End Sub

    Protected Overrides Sub Update()

        MedicareProvider.Instance.Update(Me)

    End Sub

    ''' <summary>Ignore business rules and recalculate the proportion.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ForceRecalculate(ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        'Clear any previous errors
        mCalculationErrors = New List(Of String)

        'Calculate the proportion
        Dim retVal As Boolean = CalculateProportion(True, sampleDate, memberID, sampleLockNotifyFailed)

        'Clear all history so it will be loaded again using the new data
        mLastRecalcHistory = Nothing
        mLastRecalcLoaded = False
        mHistoricLoaded = False

        'Return the result
        Return retVal

    End Function

    ''' <summary>Recalculate the proportion if business rules allow it.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function RecalculateProportion(ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        'Clear any previous errors
        mCalculationErrors = New List(Of String)

        'Check to see if we really need to recalculate based on the supplied sample date
        If NeedToRecalculateProportion(sampleDate) Then
            'Calculate the proportion
            Dim retVal As Boolean = CalculateProportion(False, sampleDate, memberID, sampleLockNotifyFailed)

            'Clear all history so it will be loaded again using the new data
            mLastRecalcHistory = Nothing
            mLastRecalcLoaded = False
            mHistoricLoaded = False

            'Return the result
            Return retVal
        Else
            'We did not need to recalculate yet so everything is fine
            Return True
        End If

    End Function

    Public Sub LogUnlockSample(ByVal memberId As Integer)

        MedicareProvider.Instance.LogUnlockSample(MedicareNumber, memberId, Date.Now)

    End Sub

#End Region

#Region "Private Methods"

    Private Function GetPropSampleDate(ByVal sampleDate As Date) As Date

        Dim dateList As List(Of Integer) = GetOrderedRecalcDates()
        Dim dateNow As Date = CDate(String.Format("{0}/1/{1}", sampleDate.Month, sampleDate.Year))

        'Get the most current date that has alread passed.
        Dim setCalcDate As Date = dateNow
        For i As Integer = 0 To dateList.Count - 1
            Dim dateItem As Date = CDate(String.Format("{0}/1/{1}", dateList(i), sampleDate.Year))
            If dateNow >= dateItem Then
                setCalcDate = dateItem
            End If
        Next

        Return setCalcDate

    End Function

    ''' <summary>This method determines if the medicare number is ready and able to calculate a new proportion.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function NeedToRecalculateProportion(ByVal sampleDate As Date) As Boolean

        Dim setCalcDate As Date = GetPropSampleDate(sampleDate)

        ' If the last calc'd date is before the set calc date, then you are OK.
        Return (setCalcDate > LastRecalcPropSampleCalcDate)

    End Function

    ''' <summary>Helper method to order the global recal dates.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetOrderedRecalcDates() As List(Of Integer)

        Dim dateList As New List(Of Integer)

        For Each calcDate As MedicareGlobalCalcDate In MedicareGlobalDates
            dateList.Add(calcDate.ReCalcMonth)
        Next
        dateList.Sort()

        Return dateList

    End Function

    ''' <summary>Determine which type of calculation to use and calculate the proportion.</summary>
    ''' <param name="forced"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function CalculateProportion(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        If SwitchToCalcDate <= Date.Now Then
            ProportionCalcTypeID = MedicareProportionCalcTypes.Historical
        End If

        If ProportionCalcTypeID = MedicareProportionCalcTypes.Historical Then
            Return CalculateProportionUsingHistorical(forced, sampleDate, memberID, sampleLockNotifyFailed)
        Else
            Return CalculateProportionUsingEstimates(forced, sampleDate, memberID, sampleLockNotifyFailed)
        End If

    End Function

    ''' <summary>Calculate the historical proportion using historical values.</summary>
    ''' <param name="forced"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function CalculateProportionUsingHistorical(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        Dim propSampleDate As Date = GetPropSampleDate(sampleDate)
        Dim annualEligibleVolume As Integer
        Dim historicResponseRate As Decimal
        Dim errorEncountered As Boolean = False

        Dim canUseHistoric As Boolean = GetHistoricValues(sampleDate, annualEligibleVolume, historicResponseRate)

        If canUseHistoric Then
            'Validate the parameters for a divide by zero condition
            If annualEligibleVolume <= 0 Then
                mCalculationErrors.Add("Annual Eligible Volume must be greater then 0.")
                errorEncountered = True
            End If
            If historicResponseRate <= 0 Then
                mCalculationErrors.Add("Historic Response Rate must be greater than 0.")
                errorEncountered = True
            End If

            'If the parameters are good then proceed
            If Not errorEncountered Then
                'Calculate the proportion.
                Dim annualProportion As Decimal = CDec((mAnnualReturnTarget / historicResponseRate) / annualEligibleVolume)

                'Check for proportion over 100%
                If annualProportion > 1 Then annualProportion = 1

                'Lock sampling if new proportion exceeds threshold.
                Dim proportionVariation As Decimal = 0
                proportionVariation = Math.Abs(annualProportion - LastRecalcProportion)
                If proportionVariation > mProportionChangeThreshold Then
                    SamplingLocked = True
                End If

                'Determine if the new proportion is greater than the force census limit
                Dim globalDefaults As MedicareGlobalCalculationDefaultCollection = MedicareGlobalCalculationDefault.GetAll
                UserCensusForced = memberID
                If globalDefaults.Count > 0 Then
                    'Global defaults exist so let's check
                    If annualProportion > globalDefaults(0).ForceCensusSamplePercentage Then
                        If CensusForced = False Then
                            CensusForced = True
                            UserCensusForced = SystemCensusForced 'indicates system assigned CensusForced not a user
                        End If
                    Else 'annual Proportion <= globalDefaults(0).ForceCensusSamplePercentage
                        If (CensusForced = True) And (LastRecalcHistoryUserCensusForced Is Nothing) Then
                            CensusForced = False
                            UserCensusForced = SystemCensusForced 'indicates system assigned CensusForced not a user
                        End If
                    End If
                End If

                'Log proportion History.
                Dim objLog As MedicareRecalcHistory = MedicareRecalcHistory.NewMedicareRecalcHistory
                objLog.MedicarePropCalcTypeID = ProportionCalcType.MedicarePropCalcTypeId
                objLog.MedicarePropDataTypeID = MedicareProportionDataTypes.Historical
                objLog.MedicareName = Name
                objLog.MedicareNumber = MedicareNumber
                objLog.EstRespRate = EstResponseRate
                objLog.EstIneligibleRate = EstIneligibleRate
                objLog.EstAnnualVolume = EstAnnualVolume
                objLog.SwitchToCalcDate = SwitchToCalcDate
                objLog.AnnualReturnTarget = AnnualReturnTarget
                objLog.ProportionCalcPct = annualProportion
                objLog.SamplingLocked = SamplingLocked
                objLog.ProportionChangeThreshold = ProportionChangeThreshold
                objLog.CensusForced = CensusForced
                objLog.MemberId = memberID
                objLog.DateCalculated = Now
                objLog.HistoricRespRate = historicResponseRate
                objLog.HistoricAnnualVolume = annualEligibleVolume
                objLog.PropSampleCalcDate = propSampleDate
                objLog.ForcedCalculation = forced
                objLog.UserCensusForced = UserCensusForced

                'Send and email notification if sampling is locked
                sampleLockNotifyFailed = False
                If SamplingLocked Then
                    Try
                        SendSamplingLockNotification(objLog)
                    Catch ex As Exception
                        sampleLockNotifyFailed = True
                    End Try
                End If

                'Save the calculation history
                objLog.Save()

                'All is well
                Return True
            Else
                'This calculation would have caused a divide by zero error
                Return False
            End If
        Else
            'We can't use the historical numbers so we have to calculate using estimates
            Return CalculateProportionUsingEstimates(forced, sampleDate, memberID, sampleLockNotifyFailed)
        End If

    End Function

    ''' <summary>Calculate the proportion using estimated values.</summary>
    ''' <param name="forced"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function CalculateProportionUsingEstimates(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        Dim proportion As Decimal
        Dim annualSample As Decimal
        Dim annualProportion As Decimal
        Dim annualEligibleVolume As Decimal
        Dim errorEncountered As Boolean = False
        Dim propSampleDate As Date = GetPropSampleDate(sampleDate)

        'Validate the parameters for a divide by zero condition
        If mEstAnnualVolume <= 0 Then
            mCalculationErrors.Add("Estimated Annual Volume must be greater than 0.")
            errorEncountered = True
        End If
        If mEstIneligibleRate >= 1 Then
            mCalculationErrors.Add("Estimated Ineligible Rate must be less than 100%.")
            errorEncountered = True
        End If
        If mEstResponseRate <= 0 Then
            mCalculationErrors.Add("Estimated Response Rate must be greater than 0.")
            errorEncountered = True
        End If

        'If the parameters are good then proceed
        If Not errorEncountered Then
            'Calculate the proportion
            annualEligibleVolume = mEstAnnualVolume - (mEstAnnualVolume * mEstIneligibleRate)
            proportion = (1 - mEstIneligibleRate) * mEstResponseRate
            annualSample = (mAnnualReturnTarget / proportion)
            annualProportion = (annualSample / annualEligibleVolume)

            'Check for proportion over 100%
            If annualProportion > 1 Then annualProportion = 1

            'Lock sampling if new proportion exceeds threshold.
            Dim proportionVariation As Decimal = 0
            proportionVariation = Math.Abs(annualProportion - LastRecalcProportion)
            If proportionVariation > mProportionChangeThreshold Then
                SamplingLocked = True
            End If

            'Determine if the new proportion is greater than the force census limit
            Dim globalDefaults As MedicareGlobalCalculationDefaultCollection = MedicareGlobalCalculationDefault.GetAll
            UserCensusForced = memberID
            If globalDefaults.Count > 0 Then
                'Global defaults exist so let's check
                If annualProportion > globalDefaults(0).ForceCensusSamplePercentage Then
                    If CensusForced = False Then
                        CensusForced = True
                        UserCensusForced = SystemCensusForced 'indicates system assigned CensusForced not a user
                    End If
                Else 'annual Proportion <= globalDefaults(0).ForceCensusSamplePercentage
                    If (CensusForced = True) And (LastRecalcHistoryUserCensusForced Is Nothing) Then
                        CensusForced = False
                        UserCensusForced = SystemCensusForced 'indicates system assigned CensusForced not a user
                    End If
                End If
            End If

            'Log proportion History.
            Dim objLog As MedicareRecalcHistory = MedicareRecalcHistory.NewMedicareRecalcHistory
            objLog.MedicarePropCalcTypeID = ProportionCalcType.MedicarePropCalcTypeId
            objLog.MedicarePropDataTypeID = MedicareProportionDataTypes.Estimated
            objLog.MedicareName = Name
            objLog.MedicareNumber = MedicareNumber
            objLog.EstRespRate = EstResponseRate
            objLog.EstIneligibleRate = EstIneligibleRate
            objLog.EstAnnualVolume = EstAnnualVolume
            objLog.SwitchToCalcDate = SwitchToCalcDate
            objLog.AnnualReturnTarget = AnnualReturnTarget
            objLog.ProportionCalcPct = annualProportion
            objLog.SamplingLocked = SamplingLocked
            objLog.ProportionChangeThreshold = ProportionChangeThreshold
            objLog.CensusForced = CensusForced
            objLog.MemberId = memberID
            objLog.DateCalculated = Now
            objLog.HistoricRespRate = 0
            objLog.HistoricAnnualVolume = 0
            objLog.PropSampleCalcDate = propSampleDate
            objLog.ForcedCalculation = forced
            objLog.UserCensusForced = UserCensusForced

            'Send and email notification if sampling is locked
            sampleLockNotifyFailed = False
            If SamplingLocked Then
                Try
                    SendSamplingLockNotification(objLog)
                Catch ex As Exception
                    sampleLockNotifyFailed = True
                End Try
            End If

            'Save the calculation history
            objLog.Save()

            'All is well
            Return True
        Else
            'This calculation would have caused a divide by zero error
            Return False
        End If

    End Function

    Private Function GetHistoricValues(ByVal sampleDate As Date, ByRef annualEligibleVolume As Integer, ByRef historicResponseRate As Decimal) As Boolean

        Dim propSampleDate As Date = GetPropSampleDate(sampleDate)
        Dim canUseHistoric As Boolean = MedicareProvider.Instance.HasHistoricValues(mMedicareNumber, propSampleDate)

        If canUseHistoric Then
            annualEligibleVolume = MedicareProvider.Instance.GetHistoricAnnualVolume(mMedicareNumber, propSampleDate)
            historicResponseRate = MedicareProvider.Instance.GetHistoricRespRate(mMedicareNumber, propSampleDate)
        Else
            annualEligibleVolume = 0
            historicResponseRate = 0
        End If

        Return canUseHistoric

    End Function

    Private Sub SendSamplingLockNotification(ByVal currCalc As MedicareRecalcHistory)

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environment As String = String.Empty

        'Get the listing of sample unit information for the email
        Dim lockDataTable As DataTable = MedicareProvider.Instance.SelectLockedSampleUnitsByMedicareNumber(mMedicareNumber)

        'Determine who the recipients are going to be
        toList.Add("HCAHPSThresholdExceeded@NationalResearch.com")

        'Add the account directors from QualiSys to the CC list
        Dim studies As New List(Of Integer)
        For Each row As DataRow In lockDataTable.Rows
            'Get the study object associated with this row and add the account director email
            Dim studyID As Integer = CInt(row("StudyID"))
            If Not studies.Contains(studyID) Then
                studies.Add(studyID)
                Dim curStudy As Study = Study.GetStudy(studyID)
                If Not ccList.Contains(curStudy.AccountDirector.Email) Then
                    ccList.Add(curStudy.AccountDirector.Email)
                End If
            End If
        Next

        'Determine recipients based on environment
        If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
            'We are not in production
            'Add the real recipients to the note
            recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
            For Each email As String In toList
                recipientNoteText &= email & vbCrLf
            Next
            recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
            For Each email As String In ccList
                recipientNoteText &= email & vbCrLf
            Next
            recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR/>")

            'Clear the lists
            toList.Clear()
            ccList.Clear()

            'Populate the ToList with the Testing group only
            toList.Add("Testing@NationalResearch.com")

            'Set the environment string
            environment = String.Format("({0})", AppConfig.EnvironmentName)
        End If

        'Create the message
        Dim lockMessage As Message = New Message("MedicareProportionChangeThresholdExceeded", "")

        'Set the message properties
        With lockMessage
            'To recipient
            For Each email As String In toList
                .To.Add(email)
            Next

            'CC recipient
            For Each email As String In ccList
                .Cc.Add(email)
            Next

            'Add the replacement values
            With .ReplacementValues
                .Add("MedicareNumber", MedicareNumber)
                .Add("MedicareName", Name)
                .Add("PrevCalcDate", LastRecalcDateCalculated.ToString)
                .Add("PrevCalcProp", LastRecalcProportion.ToString("0.0000%"))
                .Add("CurrCalcDate", currCalc.DateCalculated.ToString)
                .Add("CurrCalcProp", currCalc.ProportionCalcPct.ToString("0.0000%"))
                .Add("RecipientNoteText", recipientNoteText)
                .Add("RecipientNoteHtml", recipientNoteHtml)
                .Add("Environment", environment)
                .Add("RecalcHistoryLink", String.Format("{0}&MedicareNumber={1}", AppConfig.Params("CMRecalcHistoryReport").StringValue, MedicareNumber))
            End With

            'Add the replacement tables
            With .ReplacementTables
                .Add("LockedUnits_Text", lockDataTable)
                .Add("LockedUnits_Html", lockDataTable)
            End With

            'Send the message
            .Send()
        End With

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewMedicareNumber() As MedicareNumber

        Return New MedicareNumber

    End Function

#End Region

#Region " Operator Overloading "

    Public Shared Operator =(ByVal left As MedicareNumber, ByVal right As MedicareNumber) As Boolean

        If left Is Nothing OrElse right Is Nothing Then
            Return False
        Else
            Return (left.mMedicareNumber = right.mMedicareNumber)
        End If

    End Operator

    Public Shared Operator <>(ByVal left As MedicareNumber, ByVal right As MedicareNumber) As Boolean

        Return Not (left = right)

    End Operator

#End Region

End Class

