Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

''' <summary>
''' Represents a Period in which various SampleSets are created
''' </summary>
Public Class SamplePeriod
    Inherits BusinessBase(Of SamplePeriod)

#Region "Enums"
    ''' <summary>
    ''' The time frames that a period can belong to
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum TimeFrame
        Past = 0
        Active = 1
        Future = 2
    End Enum

    Public Enum SamplingSchedule
        Daily = 0
        Weekly = 1
        Monthly = 2
        BiMonthly = 3
    End Enum
#End Region

#Region " Private Instance Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mSurveyId As Integer
    Private mCreationDate As Date
    Private mName As String
    Private mExpectedSamples As Integer
    Private mExpectedStartDate As Nullable(Of Date)
    Private mExpectedEndDate As Nullable(Of Date)
    Private mExpectedFirstSampleDate As DateTime
    Private mSamplingMethod As SampleSet.SamplingMethod
    Private mTimeFrame As TimeFrame
    Private mEmployeeId As Integer
    'This value is currently set to a standard value defined by the business unit
    Private mNumberOfDaysPriorToSampleDataFileExpectedToArrive As Integer = AppConfig.Params("NumberOfDaysPriorToSampleDataFileExpectedToArrive").IntegerValue

    Private mSamplePeriodScheduledSamples As SamplePeriodScheduledSampleCollection
    Private mSampleSets As Collection(Of SampleSet)
    Private mHasExpectedDates As Boolean
    Private mSamplingSchedule As SamplingSchedule = SamplingSchedule.Weekly

#End Region

#Region " Public Properties "

    ''' <summary>
    ''' Indicates whether the samples that have not been run have been marked as canceled
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private ReadOnly Property HasRemainingSamplesCanceled() As Boolean
        Get
            For Each scheduledSample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
                If scheduledSample.Canceled Then
                    Return True
                End If
            Next

            Return False
        End Get
    End Property

    Public ReadOnly Property IsDeletable() As Boolean
        Get
            'Check the collection of scheduledsamples.  We do this to make sure that we include 
            'any samples pulled since this object was first populated
            Dim currentState As SamplePeriodScheduledSampleCollection
            currentState = SamplePeriodScheduledSampleProvider.Instance.SelectSamplePeriodScheduledSamples(mId)
            For Each scheduledSample As SamplePeriodScheduledSample In currentState
                If scheduledSample.SampleSetId.HasValue Then Return False
            Next
            Return True
            'Return Not Me.HasSamplesPulled
        End Get
    End Property

    ''' <summary>
    ''' Determines if the period can have all remaining samples canceled
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks> You can't complete a sample period if you haven't started sampling it, it has already been canceled or
    ''' all samples have already been pulled</remarks>
    Public ReadOnly Property IsCancelable() As Boolean
        Get
            Return Not (Me.HasSamplesPulled = False OrElse Me.HasRemainingSamplesCanceled OrElse Me.SampleSets.Count = Me.SamplePeriodScheduledSamples.Count)
        End Get
    End Property


    ''' <summary>
    ''' Determines if the period can have all remaining samples uncanceled
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks> You can't uncomplete a sampleperiod if you have started sampling another period.  This 
    ''' would create a scenario where more than one active period would exist</remarks>
    Public ReadOnly Property IsUnCancelable() As Boolean
        Get
            If Me.HasRemainingSamplesCanceled Then
                'Determine if sampling has started for any other periods
                Dim surveyHasUnfinishedPeriod As Boolean = False
                Dim parentCollection As SamplePeriodCollection
                'Parent property will return the parent collection if this object is in a parent collection
                If Not Me.Parent Is Nothing Then
                    parentCollection = DirectCast(Me.Parent, SamplePeriodCollection)
                    For Each period As SamplePeriod In parentCollection
                        'Find any period that has started sampling and not finished
                        If Not period Is Me AndAlso period.HasSamplesPulled AndAlso period.SampleSets.Count <> period.SamplePeriodScheduledSamples.Count Then
                            surveyHasUnfinishedPeriod = True
                            Exit For
                        End If
                    Next
                End If
                Return (Not surveyHasUnfinishedPeriod)
            Else
                Return False
            End If
        End Get
    End Property

    ''' <summary>
    ''' The unique identifier for the SamplePeriod
    ''' </summary>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property EmployeeId() As Integer
        Get
            Return mEmployeeId
        End Get
        Set(ByVal value As Integer)
            mEmployeeId = value
        End Set
    End Property


    ''' <summary>
    ''' The ID of the Survey to which the SamplePeriod belongs
    ''' </summary>
    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Friend Set(ByVal value As Integer)
            mSurveyId = value
        End Set
    End Property

    ''' <summary>
    ''' The date on which this SamplePeriod was created
    ''' </summary>
    Public Property CreationDate() As Date
        Get
            Return mCreationDate
        End Get
        Friend Set(ByVal value As Date)
            mCreationDate = value
        End Set
    End Property

    ''' <summary>
    ''' The name of the sample period
    ''' </summary>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property SamplingScheduleName() As SamplingSchedule
        Get
            Return mSamplingSchedule
        End Get
        Set(ByVal value As SamplingSchedule)
            mSamplingSchedule = value
        End Set
    End Property

    ''' <summary>
    ''' Returns the 1 letter abbreviation for the sampling schedule type (Daily, Weekly, etc.).  This is what is stored 
    ''' in the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SamplingScheduleCharacter() As String
        Get
            Dim character As String
            Select Case SamplingScheduleName
                Case SamplingSchedule.BiMonthly
                    character = "B"
                Case SamplingSchedule.Daily
                    character = "D"
                Case SamplingSchedule.Monthly
                    character = "M"
                Case SamplingSchedule.Weekly
                    character = "W"
                Case Else
                    Throw New Exception("Invalid sampling schedule name specified")
            End Select
            Return character
        End Get
        Set(ByVal value As String)
            Select Case value
                Case "B"
                    SamplingScheduleName = SamplingSchedule.BiMonthly
                Case "D"
                    SamplingScheduleName = SamplingSchedule.Daily
                Case "M"
                    SamplingScheduleName = SamplingSchedule.Monthly
                Case "W"
                    SamplingScheduleName = SamplingSchedule.Weekly
                Case Else
                    Throw New Exception("Invalid sampling schedule value specified")
            End Select
        End Set

    End Property



    ''' <summary>
    ''' The number of samples that are expected in this period
    ''' </summary>
    <Logable()> _
    Public ReadOnly Property ExpectedSamples() As Integer
        Get
            Return Me.SamplePeriodScheduledSamples.Count
        End Get
    End Property

    ''' <summary>
    ''' The expected start date of the period
    ''' </summary>
    <Logable()> _
    Public Property ExpectedStartDate() As Nullable(Of Date)
        Get
            Return mExpectedStartDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            'If both have a null value, then the value cannot have changed
            If value.HasValue OrElse Me.mExpectedStartDate.HasValue Then
                'If both have a value and the values are different or if only one has a value then we should update the member
                If (value.HasValue AndAlso Me.mExpectedStartDate.HasValue AndAlso value.Value <> Me.mExpectedStartDate.Value) _
                    OrElse (value.HasValue <> Me.ExpectedStartDate.HasValue) Then
                    mExpectedStartDate = value
                    PropertyHasChanged("ExpectedEndDate")
                    PropertyHasChanged("ExpectedStartDate")
                End If
            End If
        End Set
    End Property


    ''' <summary>
    ''' The expected end date of the period
    ''' </summary>
    <Logable()> _
    Public Property ExpectedEndDate() As Nullable(Of Date)
        Get
            Return mExpectedEndDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            'If both have a null value, then the value cannot have changed
            If value.HasValue OrElse Me.mExpectedEndDate.HasValue Then
                'If both have a value and the values are different or if only one has a value then we should update the member
                If (value.HasValue AndAlso Me.mExpectedEndDate.HasValue AndAlso value.Value <> Me.mExpectedEndDate.Value) _
                    OrElse (value.HasValue <> Me.mExpectedEndDate.HasValue) Then
                    mExpectedEndDate = value
                    PropertyHasChanged("ExpectedEndDate")
                    PropertyHasChanged("ExpectedStartDate")
                End If
            End If
        End Set
    End Property

    ''' <summary>
    ''' Returns True if this SamplePeriod is the currently active SamplePeriod
    ''' </summary>
    Public ReadOnly Property IsActive() As Boolean
        Get
            Return PeriodTimeFrame = TimeFrame.Active
        End Get

    End Property

    ''' <summary>
    ''' The SamplingMethod used to determine how many encounters are needed
    ''' </summary>
    Public Property SamplingMethod() As SampleSet.SamplingMethod
        Get
            Return mSamplingMethod
        End Get
        Set(ByVal value As SampleSet.SamplingMethod)
            If mSamplingMethod <> value Then
                mSamplingMethod = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SamplingMethodLabel() As String
        Get
            Return SampleSet.SamplingMethodLabel(mSamplingMethod)
        End Get
        Set(ByVal value As String)
            SamplingMethod = SampleSet.SamplingMethodFromLabel(value)
        End Set
    End Property

    ''' <summary>
    ''' The collection of SampleSets that have been created for this SamplePeriod
    ''' </summary>
    Public ReadOnly Property SampleSets() As Collection(Of SampleSet)
        Get
            mSampleSets = New Collection(Of SampleSet)
            For Each samplePeriodScheduledSample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
                If Not samplePeriodScheduledSample.SampleSet Is Nothing Then mSampleSets.Add(samplePeriodScheduledSample.SampleSet)
            Next

            Return mSampleSets
        End Get
    End Property

    ''' <summary>
    ''' Returns the time frame for the period
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The time frame is either past, active, or future.  This value helps us determine which periods can be selected 
    ''' during sampling.</remarks>
    Public Property PeriodTimeFrame() As TimeFrame
        Get
            Return mTimeFrame
        End Get
        Friend Set(ByVal value As TimeFrame)
            If value <> mTimeFrame Then
                mTimeFrame = value
                PropertyHasChanged("PeriodTimeFrame")
            End If
        End Set
    End Property


    ''' <summary>
    ''' Returns a collection containing all of the scheduled samples
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property SamplePeriodScheduledSamples() As SamplePeriodScheduledSampleCollection
        Get
            'Lazy populate the collection
            If mSamplePeriodScheduledSamples Is Nothing Then
                mSamplePeriodScheduledSamples = SamplePeriodScheduledSampleProvider.Instance.SelectSamplePeriodScheduledSamples(mId)
            End If

            Return mSamplePeriodScheduledSamples
        End Get

    End Property


    ''' <summary>
    ''' How many days before a sample is pulled do we expect to receive a file from the client
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NumberOfDaysPriorToSampleDataFileExpectedToArrive() As Integer
        Get
            Return mNumberOfDaysPriorToSampleDataFileExpectedToArrive
        End Get
        Set(ByVal value As Integer)
            If value <> Me.mNumberOfDaysPriorToSampleDataFileExpectedToArrive Then
                mNumberOfDaysPriorToSampleDataFileExpectedToArrive = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    ''' <summary>
    ''' This is the date of the first expected sample
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property ExpectedFirstSampleDate() As DateTime
        Get
            Return mExpectedFirstSampleDate
        End Get
        Set(ByVal value As DateTime)
            If value <> Me.mExpectedFirstSampleDate Then
                mExpectedFirstSampleDate = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    ''' <summary>
    ''' Indicates whether any samples have been pulled for this sampleperiod
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property HasSamplesPulled() As Boolean
        Get
            If Me.SampleSets Is Nothing OrElse Me.SampleSets.Count = 0 Then
                Return False
            End If
            Return True
        End Get
    End Property

#End Region

#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew = True Then
            Return mInstanceGuid
        Else
            Return Me.Id
        End If
    End Function

    Public Overrides ReadOnly Property IsDirty() As Boolean
        Get
            Return MyBase.IsDirty OrElse Me.SamplePeriodScheduledSamples.IsDirty
        End Get
    End Property

    Public Overrides ReadOnly Property IsValid() As Boolean
        Get
            Return MyBase.IsValid AndAlso Me.SamplePeriodScheduledSamples.IsValid
        End Get
    End Property
#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("Name", 42))
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        Me.ValidationRules.AddRule(AddressOf ValidateExpectedDates, "ExpectedStartDate")
        Me.ValidationRules.AddRule(AddressOf ValidateExpectedDates, "ExpectedEndDate")
        Me.ValidationRules.AddRule(AddressOf ValidateScheduledSamplesExist, "SamplePeriodScheduledSamples")
        'Me.ValidationRules.AddRule(AddressOf ValidateSamplingMethod, "SamplingMethod")
    End Sub

    Private Function ValidateExpectedDates(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If ExpectedStartDate.HasValue <> ExpectedEndDate.HasValue Then
            e.Description = "The expected start date and expected end date must both be null or both have a value"
            Return False
        End If

        If ExpectedStartDate.HasValue AndAlso ExpectedEndDate.HasValue AndAlso ExpectedStartDate.Value > ExpectedEndDate.Value Then
            e.Description = "The expected start date must be earlier or the same as the expected end date"
            Return False
        End If

        Dim survey As Survey = survey.Get(Me.SurveyId)
        If Not survey Is Nothing AndAlso survey.SurveyType = SurveyTypes.Hcahps AndAlso HasSamplesPulled = False AndAlso _
            (ExpectedStartDate.HasValue = False OrElse ExpectedEndDate.HasValue = False) Then
            e.Description = "Periods for HCAHPS surveys cannot have null encounter dates"
            Return False
        End If

        'Only check HCAHPS setup for periods that have not been sampled for yet
        If Not survey Is Nothing AndAlso survey.SurveyType = SurveyTypes.Hcahps AndAlso HasSamplesPulled = False AndAlso _
            (ExpectedStartDate.HasValue = True OrElse ExpectedEndDate.HasValue = True) Then
            If Me.ExpectedStartDate.Value.Day <> 1 OrElse Me.ExpectedEndDate.Value.AddDays(1).Day <> 1 AndAlso _
                Me.ExpectedStartDate.Value.Month = Me.ExpectedEndDate.Value.Month AndAlso _
                Me.ExpectedStartDate.Value.Year = Me.ExpectedEndDate.Value.Year Then
                e.Description = "Periods for HCAHPS surveys must have encounter dates that start on the first day of a month and end on the last day of the same month"
                Return False
            End If
        End If
        Return True
    End Function

    'Private Function ValidateSamplingMethod(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
    '    If Me.SamplingMethod = SampleSet.SamplingMethod.None Then
    '        e.Description = "A sampling method of none is not allowed."
    '        Return False
    '    End If
    '    Return True
    'End Function

    Private Function ValidateScheduledSamplesExist(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.SamplePeriodScheduledSamples.Count = 0 Then
            e.Description = "You must have at least one scheduled sample."
            Return False
        End If
        Return True
    End Function

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region "Private Methods"
    Private Sub UpdateAllSurveyTimeFramesForPeriod()
        Dim samplePeriods As SamplePeriodCollection
        Dim existingPeriod As New SamplePeriod
        Dim activePeriod As SamplePeriod = Nothing
        Dim activePeriodId As Integer = Me.GetActivePeriodIdbySurveyId(Me.SurveyId)

        If Not Me.Parent Is Nothing Then
            samplePeriods = DirectCast(Me.Parent, SamplePeriodCollection)
        Else
            'Throw New Exception("The Parent Collection is not accessible.")
            Exit Sub
        End If

        'Set the values
        For Each existingPeriod In samplePeriods
            If existingPeriod.Id = activePeriodId Then
                existingPeriod.PeriodTimeFrame = TimeFrame.Active
            ElseIf existingPeriod.SampleSets.Count > 0 AndAlso existingPeriod.SampleSets.Count = existingPeriod.SamplePeriodScheduledSamples.Count Then
                existingPeriod.PeriodTimeFrame = TimeFrame.Past
            ElseIf existingPeriod.SampleSets.Count = 0 Then
                existingPeriod.PeriodTimeFrame = TimeFrame.Future
            Else
                existingPeriod.PeriodTimeFrame = TimeFrame.Past
            End If
        Next
    End Sub

#End Region

#Region " Factory Methods "
    ''' <summary>
    ''' Returns a new period
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>This overload should only be called when populating an object from the database.</remarks>
    Public Shared Function NewSamplePeriod() As SamplePeriod
        Return New SamplePeriod
    End Function

    ''' <summary>
    ''' Returns a new period
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>This overload should be called when creating a new object in the UI.</remarks>
    Public Shared Function NewSamplePeriod(ByVal survey As Survey, ByVal employeeId As Integer) As SamplePeriod
        Dim samplePeriod As New SamplePeriod
        samplePeriod.SurveyId = survey.Id
        samplePeriod.EmployeeId = employeeId

        If QualisysParams.CountryCode = CountryCode.Canada Then
            samplePeriod.SamplingMethod = SampleSet.SamplingMethod.SpecifyOutgo
        ElseIf survey.SurveyType = SurveyTypes.ACOcahps Then
            samplePeriod.SamplingMethod = SampleSet.SamplingMethod.Census
        End If

        If survey.SamplePeriods.Count = 0 Then
            samplePeriod.PeriodTimeFrame = TimeFrame.Active
        Else
            samplePeriod.PeriodTimeFrame = TimeFrame.Future
        End If

        'Need to validate since we have special rules for HCAHPS
        samplePeriod.ValidationRules.CheckRules()
        Return samplePeriod
    End Function

    ''' <summary>
    ''' Creates a new SampleSet for this SamplePeriod and performs the sample
    ''' </summary>
    ''' <param name="datasets">The collection of StudyDataset objects to use in the sample</param>
    ''' <param name="startDate">The starting date to use in the sample</param>
    ''' <param name="endDate">The ending date to use in the sample</param>
    ''' <param name="creator">The Employee object of the user creating the sample</param>
    ''' <param name="specificSampleSeedStaticPlus">Pass in a greater or equal than zero sample seed to be used by StaticPlus</param>
    ''' <returns>Returns the newly created SampleSet object</returns>
    Public Function CreateSampleSet(ByVal datasets As Collection(Of StudyDataset), ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal creator As Employee, ByVal hcahpsOverSample As Boolean, ByVal specificSampleSeedStaticPlus As Integer) As SampleSet

        Dim sample As SampleSet = SampleSet.CreateSampleSet(mSurveyId, datasets, startDate, endDate, creator, Me, hcahpsOverSample, specificSampleSeedStaticPlus)

        If Me.mSampleSets IsNot Nothing Then
            mSampleSets.Add(sample)
        End If

        Return sample

    End Function

    ''' <summary>
    ''' Gets all Periods for the specified survey
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetBySurveyId(ByVal surveyId As Integer) As SamplePeriodCollection
        Return SamplePeriodProvider.Instance.SelectBySurveyId(surveyId)
    End Function

    ''' <summary>
    ''' Gets a specific Period
    ''' </summary>
    ''' <param name="samplePeriodId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function [Get](ByVal samplePeriodId As Integer) As SamplePeriod
        Return SamplePeriodProvider.Instance.SelectSamplePeriod(samplePeriodId)
    End Function

    Private Function GetActivePeriodIdbySurveyId(ByVal surveyId As Integer) As Integer
        Return SamplePeriodProvider.Instance.SelectActivePeriodId(surveyId)
    End Function


#End Region

#Region "Public Methods"
    Public Overrides Function ToString() As String
        Return mName
    End Function

    ''' <summary>
    ''' This method will fill in dummy actual sample dates for all scheduled samples that 
    ''' have not been run.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub CancelRemainingSamplesInPeriod()
        If Me.IsCancelable = False Then Throw New Exception("This period cannot be completed")
        For Each scheduledSample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
            If Not scheduledSample.SampleSetId.HasValue Then scheduledSample.Canceled = True
        Next
    End Sub

    ''' <summary>
    ''' This method will remove dummy ActualSampleDates for scheduled samples that 
    ''' are marked as completed.  It will only be allowed if this is the active period, a new period, or no samples
    ''' have been pulled. If it's not the active period and has some samples pulled, 
    ''' then uncompleting it would create 2 active periods.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub UnCancelRemainingSamplesInPeriod()
        If Me.IsUnCancelable = False Then Throw New Exception("This period cannot be uncompleted")
        For Each scheduledSample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
            If scheduledSample.Canceled = True Then scheduledSample.Canceled = False
        Next
    End Sub

    ''' <summary>
    ''' This method will force a check of the validation rules.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ReValidate()
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>
    ''' Called after updating the database.  This will mark the object as clean.
    ''' </summary>
    ''' <remarks>This is only needed when not using the save method of the class.  The save method will
    ''' automatically mark as clean.</remarks>
    Public Sub FinishedUpdating()
        Me.MarkClean()
    End Sub

    ''' <summary>
    ''' Called after inserting a new item in the database.  This will mark the object as old.
    ''' </summary>
    ''' <remarks>This is only needed when not using the save method of the class.  The save method will
    ''' automatically mark as old.</remarks>
    Public Sub FinishedInserting()
        Me.MarkOld()
    End Sub

#End Region

#Region " Data Access "
    ''' <summary>
    ''' Any time we make changes we want to reevaluate the time period information
    ''' </summary>
    ''' <remarks></remarks>
    Public Overrides Sub Save()
        MyBase.Save()
        UpdateAllSurveyTimeFramesForPeriod()
        Me.MarkOld()
    End Sub

    Protected Overrides Sub CreateNew()
        'Set default values here
        Me.SamplingMethod = SampleSet.SamplingMethod.SpecifyTargets
        'Don't check rules because it messes up the SamplePeriodScheduledSamples lazy populate
        'ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        'Todo: Make audits part of transaction once we get system.transactions working
        AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriod)(Nothing, Me, "Id", AuditLogObject.SamplePeriod))
        For Each sample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
            AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriodScheduledSample)(Nothing, sample, "SamplePeriodId", AuditLogObject.SamplePeriodScheduledSample))
        Next
        Id = DataProvider.SamplePeriodProvider.Instance.Insert(Me)
    End Sub

    'Updating SamplePeriodScheduledSamples causes duplicates
    Protected Overrides Sub Update()
        'Todo: Make audits part of transaction once we get system.transactions working
        Dim original As SamplePeriod = SamplePeriod.Get(Me.Id)
        AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriod)(original, Me, "Id", AuditLogObject.SamplePeriod))
        For Each sample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples.DeletedItems
            If Not sample.IsNew Then AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriodScheduledSample)(sample, Nothing, "SamplePeriodId", AuditLogObject.SamplePeriodScheduledSample))
        Next

        For Each sample As SamplePeriodScheduledSample In Me.SamplePeriodScheduledSamples
            Dim originalSample As SamplePeriodScheduledSample = SamplePeriodScheduledSample.Get(sample.SamplePeriodId, sample.SampleNumber)
            AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriodScheduledSample)(originalSample, sample, "SamplePeriodId", AuditLogObject.SamplePeriodScheduledSample))
        Next
        DataProvider.SamplePeriodProvider.Instance.Update(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        'Todo: Make audits part of transaction once we get system.transactions working
        Dim original As SamplePeriod = SamplePeriod.Get(Me.Id)
        AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriod)(original, Nothing, "Id", AuditLogObject.SamplePeriod))
        For Each sample As SamplePeriodScheduledSample In original.SamplePeriodScheduledSamples
            AuditLog.LogChanges(AuditLog.CompareObjects(Of SamplePeriodScheduledSample)(sample, Nothing, "SamplePeriodId", AuditLogObject.SamplePeriodScheduledSample))
        Next
        DataProvider.SamplePeriodProvider.Instance.Delete(mId)
    End Sub

#End Region
End Class

<Serializable()> _
Public Class SamplePeriodCollection
    Inherits BusinessListBase(Of SamplePeriodCollection, SamplePeriod)
End Class
