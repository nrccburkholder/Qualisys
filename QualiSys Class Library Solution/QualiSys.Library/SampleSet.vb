Imports Nrc.Framework.data
Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a Qualisys SampleSet
''' </summary>
''' <remarks>A SampleSet is a set of i</remarks>
Public Class SampleSet

#Region "Enums"

    ''' <summary>
    ''' Enumerates the Qualisys supported methods of determining 
    ''' how many individuals should be sampled
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum SamplingMethod
        'None = 0
        SpecifyTargets = 1
        SpecifyOutgo = 2
        Census = 3
    End Enum

    ''' <summary>
    ''' Enumerates the Removal Rules for sampling
    ''' </summary>
    Public Enum RemovedRule
        None = 0
        Resurvey = 1
        Newborn = 2
        Tocl = 3
        DQRule = 4
        ExcludedEncounter = 5
        HouseHoldingMinor = 6
        HouseHoldingAdult = 7
        SecondarySampleRemoval = 8
    End Enum

    ''' <summary>
    ''' Enumerates the Selection Types for sampling
    ''' </summary>
    Public Enum UnitSelectType
        None = 0
        Indirect = 1
        Direct = 2
    End Enum

#End Region

#Region " Private Instance Fields "

    Private mId As Integer
    Private mSamplePlanId As Integer
    Private mSurveyId As Integer
    Private mCreatorEmployeeId As Integer
    Private mDateCreated As Date
    Private mSampleStartDate As Date
    Private mSampleEndDate As Date
    Private mIsOversample As Boolean
    Private mIsFirstSampleInPeriod As Boolean
    Private mRandomSeed As Integer
    Private mScheduledDate As Nullable(Of Date)
    Private mSamplingAlgorithm As SamplingAlgorithm
    Private mHCAHPSOverSample As Boolean
    Private mDateRangeFrom As Nullable(Of Date)
    Private mDateRangeTo As Nullable(Of Date)

    Private mIsDirty As Boolean

#End Region

#Region " Public Properties "

    ''' <summary>
    ''' The unique identifier of this SampleSet
    ''' </summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The ID of the SamplePlan used to create this SampleSet
    ''' </summary>
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

    ''' <summary>
    ''' The ID of the survey that this SampleSet belongs to
    ''' </summary>
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Friend Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The ID of the user who created this SampleSet
    ''' </summary>
    Public Property CreatorEmployeeId() As Integer
        Get
            Return mCreatorEmployeeId
        End Get
        Set(ByVal value As Integer)
            If mCreatorEmployeeId <> value Then
                mCreatorEmployeeId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The date on which the SampleSet was created
    ''' </summary>
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Friend Set(ByVal value As Date)
            If mDateCreated <> value Then
                mDateCreated = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The starting date of the period's expected encounters
    ''' </summary>
    Public Property SampleStartDate() As Date
        Get
            Return mSampleStartDate
        End Get
        Set(ByVal value As Date)
            If mSampleStartDate <> value Then
                mSampleStartDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The ending date of the period's expected encounters
    ''' </summary>
    Public Property SampleEndDate() As Date
        Get
            Return mSampleEndDate
        End Get
        Set(ByVal value As Date)
            If mSampleEndDate <> value Then
                mSampleEndDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Indicates if this SampleSet is an over-sample
    ''' </summary>
    Public Property IsOversample() As Boolean
        Get
            Return mIsOversample
        End Get
        Set(ByVal value As Boolean)
            If mIsOversample <> value Then
                mIsOversample = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Indicates if this is the first SampleSet in the SamplePeriod
    ''' </summary>
    Public Property IsFirstSampleInPeriod() As Boolean
        Get
            Return mIsFirstSampleInPeriod
        End Get
        Set(ByVal value As Boolean)
            If mIsFirstSampleInPeriod <> value Then
                mIsFirstSampleInPeriod = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The date on which this SampleSet was scheduled for generation
    ''' </summary>
    ''' <remarks>Note: this is not the date that SampleSet generation occurs, rather,
    ''' it is the date on which scheduling was performed</remarks>
    Public Property ScheduledDate() As Nullable(Of Date)
        Get
            Return mScheduledDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            mScheduledDate = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' The SamplingAlgorithm that was used to create this SampleSet
    ''' </summary>
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

    ''' <summary>
    ''' Indicates whether or not we oversampled the HCAHPS unit
    ''' </summary>
    Public Property HCAHPSOverSample() As Boolean
        Get
            Return mHCAHPSOverSample
        End Get
        Set(ByVal value As Boolean)
            If mHCAHPSOverSample <> value Then
                mHCAHPSOverSample = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The start date of the range to be sampled
    ''' </summary>
    ''' <remarks></remarks>
    Public Property DateRangeFrom() As Nullable(Of Date)
        Get
            Return mDateRangeFrom
        End Get
        Set(ByVal value As Nullable(Of Date))
            mDateRangeFrom = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' The end date of the range to be sampled
    ''' </summary>
    ''' <remarks></remarks>
    Public Property DateRangeTo() As Nullable(Of Date)
        Get
            Return mDateRangeTo
        End Get
        Set(ByVal value As Nullable(Of Date))
            mDateRangeTo = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Indicates if the SampleSet has been scheduled for generation
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsScheduledForGeneration() As Boolean
        Get
            Return mScheduledDate.HasValue
        End Get
    End Property

    ''' <summary>
    ''' Boolean value indicating whether changes have been made to the object since it was loaded from the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

#End Region

#Region " Friend Properties "

    ''' <summary>
    ''' The seed value that was used for randomization in the SampleSet
    ''' </summary>
    Friend Property RandomSeed() As Integer
        Get
            Return mRandomSeed
        End Get
        Set(ByVal value As Integer)
            If mRandomSeed <> value Then
                mRandomSeed = value
                mIsDirty = True
            End If
        End Set
    End Property

#End Region

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Retrieves a given SampleSet object from the datastore
    ''' </summary>
    ''' <param name="sampleSetId">The unique identifier of the SampleSet to retrieve</param>
    Public Shared Function GetSampleSet(ByVal sampleSetId As Integer) As SampleSet

        Return SampleSetProvider.Instance.[Select](sampleSetId)

    End Function

    ''' <summary>
    ''' Deletes a specific SampleSet object from the datastore
    ''' </summary>
    ''' <param name="SampleSetId">The unique identifier of the SampleSet to delete</param>
    Public Shared Sub DeleteSampleSet(ByVal sampleSetId As Integer)

        SampleSetProvider.Instance.Delete(sampleSetId)

    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Creates a new SampleSet and performs the random sample
    ''' </summary>
    ''' <param name="surveyId">The ID of the survey to sample</param>
    ''' <param name="datasets">A collection of StudyDatasets to sample</param>
    ''' <param name="startDate">The starting date of the sample encounters</param>
    ''' <param name="endDate">The ending date of the sample encounters</param>
    ''' <param name="creator">The Employee object of the creating user</param>
    ''' <param name="period">The SamplePeriod to which the new sample will belong</param>
    ''' <param name="hcahpsOverSample">Specifies whether or not to oversample the HCAHPS unit if this is an oversample</param>
    ''' <param name="specificSampleSeedStaticPlus">Pass in a greater or equal than zero sample seed to be used by StaticPlus</param>
    Public Shared Function CreateSampleSet(ByVal surveyId As Integer, ByVal datasets As Collection(Of StudyDataset), ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal creator As Employee, ByVal period As SamplePeriod, ByVal hcahpsOverSample As Boolean, ByVal specificSampleSeedStaticPlus As Integer) As SampleSet

        'Get the survey object
        Dim srvy As Survey
        srvy = Survey.[Get](surveyId)
        Dim newSampleSetId As Integer
        Dim algorithm As SamplingAlgorithm = srvy.SamplingAlgorithm

        'Determine the sampling algorithm to use and peform the sample
        If algorithm <> SamplingAlgorithm.StaticPlus Then
            newSampleSetId = LegacySampleSet.PerformLegacySample(srvy, datasets, startDate, endDate, creator, period)
        Else
            newSampleSetId = StaticPlusAlgorithm.PerformStaticPlusSample(srvy, period, datasets, startDate, endDate, creator, hcahpsOverSample, specificSampleSeedStaticPlus)
        End If

        'Return the newly created SampleSet object
        Return SampleSet.GetSampleSet(newSampleSetId)

    End Function

    ''' <summary>
    ''' Schedules the SampleSet for survey generation
    ''' </summary>
    ''' <param name="generationDate">The date on which the SampleSet will generate</param>
    Public Sub ScheduleSampleSetGeneration(ByVal generationDate As Date)

        SampleSetProvider.Instance.ScheduleSampleSetGeneration(mId, generationDate)

    End Sub

    ''' <summary>
    ''' Unschedules the SampleSet for survey generation
    ''' </summary>
    ''' <remarks>A SampleSet can only be unscheduled if the surveys have not generated
    ''' If the surveys have generated then an exception will be thrown.</remarks>
    Public Sub UnscheduleSampleSetGeneration()

        SampleSetProvider.Instance.UnscheduleSampleSetGeneration(mId)

    End Sub

    ''' <summary>
    ''' Gets the label for the indicated sampling method value
    ''' </summary>
    ''' <param name="method"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function SamplingMethodLabel(ByVal method As SamplingMethod) As String

        Select Case method
            Case SampleSet.SamplingMethod.SpecifyTargets
                Return "Specify Targets"

            Case SampleSet.SamplingMethod.SpecifyOutgo
                Return "Specify Outgo"

            Case SampleSet.SamplingMethod.Census
                Return "Census"

            Case Else
                Throw New Exception("Method '" & method.ToString & "' is not a valid sampling method.")

        End Select

    End Function

    ''' <summary>
    ''' Gets the enum value for the indicated sampling method label
    ''' </summary>
    ''' <param name="method"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function SamplingMethodFromLabel(ByVal method As String) As SampleSet.SamplingMethod

        Select Case method
            Case "Specify Targets"
                Return SampleSet.SamplingMethod.SpecifyTargets

            Case "Specify Outgo"
                Return SampleSet.SamplingMethod.SpecifyOutgo

            Case "Census"
                Return SamplingMethod.Census

            Case Else
                Throw New Exception("Method '" & method.ToString & "' is not a valid sampling method.")

        End Select

    End Function

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

#End Region

End Class
