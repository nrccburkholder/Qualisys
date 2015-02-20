''' <summary>
''' Represents a Study Dataset loaded into Qualisys
''' </summary>
''' <remarks>Datasets loaded into Qualisys are Study specific.  This class represents a 
''' summarization of the data contained in the Dataset</remarks>
Public Class StudyDataset

#Region " Private Instance Fields "
    Private mId As Integer
    Private mStudyId As Integer
    Private mDateLoaded As Date
    Private mRecordCount As Integer
    Private mDateRanges As Collection(Of StudyDatasetDateRange)
    Private mHasBeenSampled As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The unique identifier for the Dataset
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
    ''' The ID of the study to which this Dataset belongs
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Friend Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    ''' <summary>
    ''' The date on which the Dataset was loaded
    ''' </summary>
    Public Property DateLoaded() As Date
        Get
            Return mDateLoaded
        End Get
        Friend Set(ByVal value As Date)
            mDateLoaded = value
        End Set
    End Property

    ''' <summary>
    ''' The number of records that were contained in the Dataset
    ''' </summary>
    Public Property RecordCount() As Integer
        Get
            Return mRecordCount
        End Get
        Friend Set(ByVal value As Integer)
            mRecordCount = value
        End Set
    End Property

    ''' <summary>
    ''' A collection of summary date ranges for each of the date fields in the Dataset
    ''' </summary>
    ''' <remarks>For each Dataset loaded we store a summary of the minimum and maximum 
    ''' value contained in any of the date metafields.  This helps eliminate expensive
    ''' queries to access the information later</remarks>
    Public ReadOnly Property DateRanges() As Collection(Of StudyDatasetDateRange)
        Get
            Return mDateRanges
        End Get
    End Property

    ''' <summary>
    ''' Returns True if a sample has been created from this Dataset
    ''' </summary>
    Public Property HasBeenSampled() As Boolean
        Get
            Return mHasBeenSampled
        End Get
        Friend Set(ByVal value As Boolean)
            mHasBeenSampled = value
        End Set
    End Property
#End Region

#Region " Constructors "

    ''' <summary>
    ''' Initializes the StudyDataset object
    ''' </summary>
    Sub New()
        Me.mDateRanges = New Collection(Of StudyDatasetDateRange)
    End Sub
#End Region

    Public Shared Function GetByStudyId(ByVal studyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date)) As Collection(Of StudyDataset)
        Return DataProvider.StudyDatasetProvider.Instance.SelectByStudyId(studyId, creationFilterStartDate, creationFilterEndDate)
    End Function

    Public Shared Sub Delete(ByVal datasetId As Integer)
        Try
            DataProvider.StudyDatasetProvider.Instance.Delete(datasetId)
        Catch ex As Nrc.Framework.Data.SqlCommandException
            If ex.Message = "The dataset cannot be deleted because it has already been sampled" Then
                Throw New DatasetRollbackException("The dataset cannot be deleted because it has already been sampled", ex)
            Else
                Throw
            End If
        End Try
    End Sub

    Public Sub Delete()
        If mHasBeenSampled Then
            Throw New InvalidOperationException("This dataset cannot be deleted because it has already been sampled.")
        End If

        Delete(mId)
    End Sub

End Class
