Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.Notification
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()>
Public Class MedicareSurveyType
    Inherits BusinessBase(Of MedicareSurveyType)

#Region "Private Fields"
    Private Const const_HCAHPS_SurveyTypeID As Integer = 2
    Private Const const_HHCAHPS_SurveyTypeID As Integer = 3
    Private Const const_OASCAHPS_SurveyTypeID As Integer = 16

    Private mLastRecalcLoaded As Boolean
    Private mHistoricLoaded As Boolean

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareNumber As String = String.Empty
    Private mName As String = String.Empty
    Private mSurveyTypeID As Integer

    Private mEstAnnualVolume As Integer
    Private mEstResponseRate As Decimal
    Private mSwitchToCalcDate As Date
    Private mAnnualReturnTarget As Integer
    Private mSamplingLocked As Boolean
    Private mProportionChangeThreshold As Decimal
    Private mIsActive As Boolean = True
    Private mNonSubmitting As Boolean = False
    Private mSwitchFromRateOverrideDate As Date
    Private mSamplingRateOverride As Decimal
    Private mAnnualEligibleVolume As Integer 'for historical
    Private mHistoricResponseRate As Decimal 'for historical
    Private mCanUseHistoric As Boolean 'for historical

    Private mCalculationErrors As New List(Of String)
    Private mLastRecalcHistory As MedicareRecalcSurveyTypeHistory
    Private mMedicareGlobalDates As MedicareGlobalCalcDateCollection

    Private mProportionCalcTypeID As MedicareProportionCalcTypes
    Private mMedicareCommon As MedicareCommon

#End Region

#Region "Public Properties"

#Region "MedicareSurveyType Properties"

    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
                'PropertyHasChanged("MedicareNumber")
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
            End If
        End Set
    End Property

    Public Property SurveyTypeID() As Integer
        Get
            Return mSurveyTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyTypeID Then
                mSurveyTypeID = value
                PropertyHasChanged("SurveyTypeID")
            End If
        End Set
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

    Public Property SwitchFromRateOverrideDate() As Date
        Get
            Return mSwitchFromRateOverrideDate
        End Get
        Set(ByVal value As Date)
            If Not value = mSwitchFromRateOverrideDate Then
                mSwitchFromRateOverrideDate = value
                PropertyHasChanged("SwitchFromRateOverrideDate")
            End If
        End Set
    End Property

    Public Property SamplingRateOverride() As Decimal
        Get
            Return mSamplingRateOverride
        End Get
        Set(ByVal value As Decimal)
            If Not value = mSamplingRateOverride Then
                mSamplingRateOverride = value
                PropertyHasChanged("SamplingRateOverride")
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
            End If
        End Set
    End Property

    Public ReadOnly Property MedicareGlobalDates() As MedicareGlobalCalcDateCollection
        Get
            If Me.mMedicareGlobalDates Is Nothing Then
                Me.mMedicareGlobalDates = MedicareGlobalCalcDate.GetAll()
            End If
            Return Me.mMedicareGlobalDates
        End Get
    End Property

#End Region

#Region "MedicareSurveyType Display Properties"

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

    Public Property SamplingRateOverrideDisplay() As Decimal
        Get
            Return SamplingRateOverride * 100
        End Get
        Set(ByVal value As Decimal)
            If Not value = SamplingRateOverride * 100 Then
                SamplingRateOverride = value / 100
                PropertyHasChanged("SamplingRateOverrideDisplay")
            End If
        End Set
    End Property

#End Region

#Region "MedicareRecalcSurveyTypeHistory Properties"
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

#Region "MedicareRecalcSurveyTypeHistory Display Properties"

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
                mCanUseHistoric = MedicareCommon.GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate, SurveyTypeID)
                mHistoricLoaded = True
            End If
            Return mCanUseHistoric
        End Get
    End Property

    Public ReadOnly Property AnnualEligibleVolume() As Integer
        Get
            If Not mHistoricLoaded Then
                mCanUseHistoric = MedicareCommon.GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate, SurveyTypeID)
                mHistoricLoaded = True
            End If
            Return mAnnualEligibleVolume
        End Get
    End Property

    Public ReadOnly Property HistoricResponseRate() As Decimal
        Get
            If Not mHistoricLoaded Then
                mCanUseHistoric = MedicareCommon.GetHistoricValues(Date.Now, mAnnualEligibleVolume, mHistoricResponseRate, SurveyTypeID)
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

    Private ReadOnly Property LastRecalcHistory() As MedicareRecalcSurveyTypeHistory
        Get
            If mLastRecalcHistory Is Nothing AndAlso Not mLastRecalcLoaded Then
                mLastRecalcHistory = MedicareRecalcSurveyTypeHistory.GetLatestByMedicareNumber(mMedicareNumber, Date.Now)
                mLastRecalcLoaded = True
            End If
            Return mLastRecalcHistory
        End Get
    End Property

    Private ReadOnly Property MedicareCommon() As MedicareCommon
        Get
            If mMedicareCommon Is Nothing Then
                mMedicareCommon = New MedicareCommon(MedicareNumber, Name)
            End If
            Return mMedicareCommon
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New(ByVal globalDef As MedicareGlobalCalculationDefault)

        Me.CreateNew(globalDef)

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
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("EstAnnualVolume", 1))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("EstResponseRateDisplay", CDec(0.99)))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Date), New Validation.MinValueRuleArgs(Of Date)("SwitchToCalcDate", CDate("1/1/2000")))
        ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("AnnualReturnTarget", 1))
        ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("ProportionChangeThresholdDisplay", CDec(0.99)))
        'ValidationRules.AddRule(AddressOf Validation.MinValue(Of Decimal), New Validation.MinValueRuleArgs(Of Decimal)("SamplingRateOverrideDisplay", CDec(0.99)))
        'ValidationRules.AddRule(AddressOf Validation.MinValue(Of Date), New Validation.MinValueRuleArgs(Of Date)("SwitchFromRateOverrideDate", CDate("1/1/2000")))

    End Sub

    Public Overrides Function ToString() As String

        Return MedicareNumber

    End Function

#End Region

#Region "Public Methods"

    Protected Overrides Sub CreateNew()

        'Get the global default values
        Dim globalDef As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.GetAll()(0)

        CreateNew(globalDef)
    End Sub

    Protected Overloads Sub CreateNew(ByVal globalDef As MedicareGlobalCalculationDefault)

        'Set default values

        Dim quarterNumber As Integer = (Date.Now().Month() - 1) \ 3 + 1
        Dim firstDayOfQuarterNextYear As New DateTime(Date.Now().Year + 1, (quarterNumber - 1) * 3 + 1, 1)

        SwitchToCalcDate = firstDayOfQuarterNextYear
        EstResponseRate = globalDef.RespRate
        ProportionChangeThreshold = globalDef.ProportionChangeThreshold
        AnnualReturnTarget = globalDef.AnnualReturnTarget

        SwitchFromRateOverrideDate = New Date(1900, 1, 1)

        'Validate the object
        ValidationRules.CheckRules()

    End Sub

    Public Shared Function [Get](ByVal medicareNumber As String, ByVal surveyTypeID As Integer) As MedicareSurveyType

        Return MedicareSurveyTypeProvider.Instance.Select(medicareNumber, surveyTypeID)

    End Function

    Protected Overrides Sub Insert()

        MedicareSurveyTypeProvider.Instance.Insert(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        MedicareSurveyTypeProvider.Instance.Delete(MedicareNumber, SurveyTypeID)

    End Sub

    Public Shared Sub DeleteNow(ByVal medicareNumber As String, ByVal surveyTypeID As Integer)

        MedicareSurveyTypeProvider.Instance.Delete(medicareNumber, surveyTypeID)

    End Sub

    Protected Overrides Sub Update()

        MedicareSurveyTypeProvider.Instance.Update(Me)

    End Sub

    ''' <summary>Ignore business rules and recalculate the proportion.</summary>
    ''' <CreatedBy></CreatedBy>
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
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function RecalculateProportion(ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        'Clear any previous errors
        mCalculationErrors = New List(Of String)

        'Check to see if we really need to recalculate based on the supplied sample date
        If MedicareCommon.NeedToRecalculateProportion(sampleDate, LastRecalcPropSampleCalcDate) Then
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

#End Region

#Region "Private Methods"

    ''' <summary>Determine which type of calculation to use and calculate the proportion.</summary>
    Private Function CalculateProportion(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        Select Case SurveyTypeID
            Case const_HHCAHPS_SurveyTypeID
                If SamplingRateOverride > 0 And SwitchFromRateOverrideDate.Date > Date.Now().Date Then
                    ProportionCalcTypeID = MedicareProportionCalcTypes.RateOverride
                    Return HHCAHPS_CalculateProportionUsingOverride(forced, sampleDate, memberID, sampleLockNotifyFailed)
                Else
                    If SwitchToCalcDate.Date <= Date.Now().Date Then
                        ProportionCalcTypeID = MedicareProportionCalcTypes.Historical
                        Return HHCAHPS_CalculateProportionUsingHistorical(forced, sampleDate, memberID, sampleLockNotifyFailed)
                    Else
                        ProportionCalcTypeID = MedicareProportionCalcTypes.Estimated
                        Return HHCAHPS_CalculateProportionUsingEstimates(forced, sampleDate, memberID, sampleLockNotifyFailed)
                    End If

                End If
            Case Else
                'TODO for OAS
        End Select

    End Function

    Private Function HHCAHPS_CalculateProportionUsingHistorical(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean

        Dim propSampleDate As Date = MedicareCommon.GetPropSampleDate(sampleDate)
        Dim annualEligibleVolume As Integer
        Dim historicResponseRate As Decimal
        Dim errorEncountered As Boolean = False

        Dim canUseHistoric As Boolean = MedicareCommon.GetHistoricValues(sampleDate, annualEligibleVolume, historicResponseRate, SurveyTypeID)

        If canUseHistoric Then
            'Validate the parameters for a divide by zero condition
            If annualEligibleVolume <= 0 Then
                CalculationErrors.Add("Annual Eligible Volume must be greater then 0.")
                errorEncountered = True
            End If
            If historicResponseRate <= 0 Then
                CalculationErrors.Add("Historic Response Rate must be greater than 0.")
                errorEncountered = True
            End If

            'If the parameters are good then proceed
            If Not errorEncountered Then
                'Calculate the proportion.
                Dim annualProportion As Decimal = CDec((AnnualReturnTarget / historicResponseRate) / annualEligibleVolume)

                'Check for proportion over 100%
                If annualProportion > 1 Then annualProportion = 1

                'Lock sampling if new proportion exceeds threshold.
                Dim proportionVariation As Decimal = 0
                proportionVariation = Math.Abs(annualProportion - LastRecalcProportion)
                If proportionVariation > ProportionChangeThreshold Then
                    SamplingLocked = True
                End If

                'Log proportion History.
                Dim objLog As MedicareRecalcSurveyTypeHistory = MedicareRecalcSurveyTypeHistory.NewMedicareRecalcSurveyTypeHistory()
                objLog.MedicarePropCalcTypeID = ProportionCalcTypeID
                objLog.MedicarePropDataTypeID = MedicareProportionDataTypes.Historical
                objLog.MedicareName = Name
                objLog.MedicareNumber = MedicareNumber
                objLog.SurveyTypeID = const_HHCAHPS_SurveyTypeID
                objLog.EstRespRate = EstResponseRate
                objLog.EstAnnualVolume = EstAnnualVolume
                objLog.SwitchToCalcDate = SwitchToCalcDate
                objLog.AnnualReturnTarget = AnnualReturnTarget
                objLog.ProportionCalcPct = annualProportion
                objLog.SamplingLocked = SamplingLocked
                objLog.ProportionChangeThreshold = ProportionChangeThreshold
                objLog.MemberId = memberID
                objLog.DateCalculated = Now
                objLog.HistoricRespRate = historicResponseRate
                objLog.HistoricAnnualVolume = annualEligibleVolume
                objLog.PropSampleCalcDate = propSampleDate
                objLog.ForcedCalculation = forced
                objLog.SamplingRateOverride = SamplingRateOverride
                objLog.SwitchFromRateOverrideDate = SwitchFromRateOverrideDate

                'Send and email notification if sampling is locked
                sampleLockNotifyFailed = False
                If SamplingLocked Then
                    Try
                        MedicareCommon.SendSamplingLockNotification(LastRecalcDateCalculated, LastRecalcProportion, objLog, SurveyTypeID)
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
            'We can't use the historical numbers so we have to calculate using estimates or overrides
            If SamplingRateOverride > 0 And SwitchFromRateOverrideDate.Date > Date.Now().Date Then
                ProportionCalcTypeID = MedicareProportionCalcTypes.RateOverride
                Return HHCAHPS_CalculateProportionUsingOverride(forced, sampleDate, memberID, sampleLockNotifyFailed)
            Else
                ProportionCalcTypeID = MedicareProportionCalcTypes.Estimated
                Return HHCAHPS_CalculateProportionUsingEstimates(forced, sampleDate, memberID, sampleLockNotifyFailed)
            End If
        End If
    End Function

    Private Function HHCAHPS_CalculateProportionUsingEstimates(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean
        Dim errorEncountered As Boolean = False
        Dim propSampleDate As Date = MedicareCommon.GetPropSampleDate(sampleDate)

        'Validate the parameters for a divide by zero condition
        If EstAnnualVolume <= 0 Then
            CalculationErrors.Add("Estimated Annual Volume must be greater than 0.")
            errorEncountered = True
        End If
        If EstResponseRate <= 0 Then
            CalculationErrors.Add("Estimated Response Rate must be greater than 0.")
            errorEncountered = True
        End If

        'If the parameters are good then proceed
        If Not errorEncountered Then
            'Calculate the proportion
            Dim annualProportion As Decimal = CDec((AnnualReturnTarget / EstResponseRate) / EstAnnualVolume)

            'Check for proportion over 100%
            If annualProportion > 1 Then annualProportion = 1

            'Lock sampling if new proportion exceeds threshold.
            Dim proportionVariation As Decimal = 0
            proportionVariation = Math.Abs(annualProportion - LastRecalcProportion)
            If proportionVariation > ProportionChangeThreshold Then
                SamplingLocked = True
            End If

            'Log proportion History.
            Dim objLog As MedicareRecalcSurveyTypeHistory = MedicareRecalcSurveyTypeHistory.NewMedicareRecalcSurveyTypeHistory()
            objLog.MedicarePropCalcTypeID = ProportionCalcTypeID
            objLog.MedicarePropDataTypeID = MedicareProportionDataTypes.Estimated
            objLog.MedicareName = Name
            objLog.MedicareNumber = MedicareNumber
            objLog.SurveyTypeID = const_HHCAHPS_SurveyTypeID
            objLog.EstRespRate = EstResponseRate
            objLog.EstAnnualVolume = EstAnnualVolume
            objLog.SwitchToCalcDate = SwitchToCalcDate
            objLog.AnnualReturnTarget = AnnualReturnTarget
            objLog.ProportionCalcPct = annualProportion
            objLog.SamplingLocked = SamplingLocked
            objLog.ProportionChangeThreshold = ProportionChangeThreshold
            objLog.MemberId = memberID
            objLog.DateCalculated = Now
            objLog.HistoricRespRate = 0
            objLog.HistoricAnnualVolume = 0
            objLog.PropSampleCalcDate = propSampleDate
            objLog.ForcedCalculation = forced
            objLog.SamplingRateOverride = SamplingRateOverride
            objLog.SwitchFromRateOverrideDate = SwitchFromRateOverrideDate

            'Send and email notification if sampling is locked
            sampleLockNotifyFailed = False
            If SamplingLocked Then
                Try
                    MedicareCommon.SendSamplingLockNotification(LastRecalcDateCalculated, LastRecalcProportion, objLog, SurveyTypeID)
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

    Private Function HHCAHPS_CalculateProportionUsingOverride(ByVal forced As Boolean, ByVal sampleDate As Date, ByVal memberID As Integer, ByRef sampleLockNotifyFailed As Boolean) As Boolean
        Dim annualProportion As Decimal
        Dim errorEncountered As Boolean = False
        Dim propSampleDate As Date = MedicareCommon.GetPropSampleDate(sampleDate)

        'Calculate the proportion
        annualProportion = SamplingRateOverride

        'Check for proportion over 100%
        If annualProportion > 1 Then annualProportion = 1

        'Log proportion History.
        Dim objLog As MedicareRecalcSurveyTypeHistory = MedicareRecalcSurveyTypeHistory.NewMedicareRecalcSurveyTypeHistory()
        objLog.MedicarePropCalcTypeID = ProportionCalcTypeID
        objLog.MedicarePropDataTypeID = MedicareProportionDataTypes.RateOverride
        objLog.MedicareName = Name
        objLog.MedicareNumber = MedicareNumber
        objLog.SurveyTypeID = const_HHCAHPS_SurveyTypeID
        objLog.EstRespRate = EstResponseRate
        objLog.EstAnnualVolume = EstAnnualVolume
        objLog.SwitchToCalcDate = SwitchToCalcDate
        objLog.AnnualReturnTarget = AnnualReturnTarget
        objLog.ProportionCalcPct = annualProportion
        objLog.SamplingLocked = SamplingLocked
        objLog.ProportionChangeThreshold = ProportionChangeThreshold
        objLog.MemberId = memberID
        objLog.DateCalculated = Now
        objLog.HistoricRespRate = 0
        objLog.HistoricAnnualVolume = 0
        objLog.PropSampleCalcDate = propSampleDate
        objLog.ForcedCalculation = forced
        objLog.SamplingRateOverride = SamplingRateOverride
        objLog.SwitchFromRateOverrideDate = SwitchFromRateOverrideDate

        'Send and email notification if sampling is locked
        sampleLockNotifyFailed = False
        If SamplingLocked Then
            Try
                MedicareCommon.SendSamplingLockNotification(LastRecalcDateCalculated, LastRecalcProportion, objLog, SurveyTypeID)
            Catch ex As Exception
                sampleLockNotifyFailed = True
            End Try
        End If

        'Save the calculation history
        objLog.Save()

        'All is well
        Return True

    End Function

#End Region

#Region " Factory Methods "

    Public Shared Function NewMedicareSurveyType(globalDef As MedicareGlobalCalculationDefault) As MedicareSurveyType

        Return New MedicareSurveyType(globalDef)

    End Function

#End Region

#Region " Operator Overloading "

    Public Shared Operator =(ByVal left As MedicareSurveyType, ByVal right As MedicareSurveyType) As Boolean

        If left Is Nothing OrElse right Is Nothing Then
            Return False
        Else
            Return (left.mMedicareNumber = right.mMedicareNumber)
        End If

    End Operator

    Public Shared Operator <>(ByVal left As MedicareSurveyType, ByVal right As MedicareSurveyType) As Boolean

        Return Not (left = right)

    End Operator

#End Region

End Class


