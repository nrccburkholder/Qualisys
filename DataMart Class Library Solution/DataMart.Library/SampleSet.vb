Imports Nrc.Framework.data
Imports Nrc.DataMart.Library.DataProvider

''' <summary>
''' Represents a Qualisys SampleSet
''' </summary>
''' <remarks>A SampleSet is a set of i</remarks>
Public Class SampleSet

#Region " Private Instance Fields "
    Private mId As Integer
    Private mDateCreated As Date
    Private mSurveyId As Integer
    Private mSamplePlanId As Integer
    Private mCreatorEmployeeId As Integer
    Private mIsOversample As Boolean
    Private mSampleFromDate As Date
    Private mSampleToDate As Date
    Private mScheduledDate As Nullable(Of Date)
    Private mSamplingAlgorithm As SamplingAlgorithm

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
    ''' The starting date of encounters included in the SampleSet
    ''' </summary>
    Public Property SampleFromDate() As Date
        Get
            Return mSampleFromDate
        End Get
        Set(ByVal value As Date)
            If mSampleFromDate <> value Then
                mSampleFromDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The ending date of encounters included in the SampleSet
    ''' </summary>
    Public Property SampleToDate() As Date
        Get
            Return mSampleToDate
        End Get
        Set(ByVal value As Date)
            If mSampleToDate <> value Then
                mSampleToDate = value
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

#Region " DB CRUD Methods "
    ''' <summary>
    ''' Retrieves a given SampleSet object from the datastore
    ''' </summary>
    ''' <param name="sampleSetId">The unique identifier of the SampleSet to retrieve</param>
    Public Shared Function GetSampleSet(ByVal sampleSetId As Integer) As SampleSet
        Return DataProvider.Instance.SelectSampleSet(sampleSetId)
    End Function

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

End Class
