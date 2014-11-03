''' <summary>
''' This class represents a date range summary for a StudyDataset
''' </summary>
''' <remarks>Study datasets may contain various date fields.  When a dataset is created
''' it is important to summarize the range of date values contained in the dataset
''' so that the information can be accessed without expensive queries against large
''' database tables</remarks>
Public Class StudyDatasetDateRange

#Region " Private Instance Fields "
    Private mTableId As Integer
    Private mFieldId As Integer
    Private mMinimumDate As Date
    Private mMaximumDate As Date
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The unique identifier of the StudyTable to which the field belongs
    ''' </summary>
    Public Property TableId() As Integer
        Get
            Return mTableId
        End Get
        Set(ByVal value As Integer)
            mTableId = value
        End Set
    End Property

    ''' <summary>
    ''' The unique identifier of the StudyDataTableColumn that the date range is for
    ''' </summary>
    Public Property FieldId() As Integer
        Get
            Return mFieldId
        End Get
        Set(ByVal value As Integer)
            mFieldId = value
        End Set
    End Property

    ''' <summary>
    ''' The minimum value found in the StudyDataset for the particular StudyTableColumn
    ''' </summary>
    Public Property MinimumDate() As Date
        Get
            Return mMinimumDate
        End Get
        Set(ByVal value As Date)
            mMinimumDate = value
        End Set
    End Property

    ''' <summary>
    ''' The maximum value found in the StudyDataset for the particular StudyTableColumn
    ''' </summary>
    Public Property MaximumDate() As Date
        Get
            Return mMaximumDate
        End Get
        Set(ByVal value As Date)
            mMaximumDate = value
        End Set
    End Property
#End Region

End Class
