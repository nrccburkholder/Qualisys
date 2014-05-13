Public Interface IStudyTable
    Property Id() As Integer
    Property IsView() As Boolean
End Interface
''' <summary>
''' Represents a QualiSys Study Table containing patient data.
''' </summary>
Public Class StudyTable
    Inherits BusinessBase(Of StudyTable)
    Implements IStudyTable

#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object
        Return mId
    End Function

    Public Overrides Function ToString() As String
        Return mName
    End Function
#End Region
#Region " Private Instance Fields "

#Region " Persisted Fields "
    Private mId As Integer
    Private mName As String
    Private mStudyId As Integer
    Private mDescription As String
    Private mIsView As Boolean
#End Region

    Private mColumns As Collection(Of StudyTableColumn)

#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' <summary>
    ''' The QualiSys MetaTable_id for this table
    ''' </summary>
    Public Property Id() As Integer Implements IStudyTable.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The name of the table
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

    ''' <summary>
    ''' The Study ID of the table.
    ''' </summary>
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    ''' <summary>
    ''' The table description
    ''' </summary>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            mDescription = value
        End Set
    End Property

    ''' <summary>
    ''' Returns True if this table is actually a View
    ''' </summary>
    Public Property IsView() As Boolean Implements IStudyTable.IsView
        Get
            Return mIsView
        End Get
        Friend Set(ByVal value As Boolean)
            mIsView = value
        End Set
    End Property
#End Region

    ''' <summary>
    ''' The collection of columns contained in this table.
    ''' </summary>
    Public ReadOnly Property Columns() As Collection(Of StudyTableColumn)
        Get
            If mColumns Is Nothing Then
                mColumns = StudyTableColumn.GetStudyTableColumns(Me.mStudyId, Me.mId)
            End If

            Return mColumns
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>
    ''' Default constructor
    ''' </summary>
    Public Sub New()
    End Sub
#End Region

#Region " DB CRUD Methods "
    ''' <summary>
    ''' Returns a collection of all the tables belonging to a study
    ''' </summary>
    ''' <param name="studyId">The Study ID</param>
    Public Shared Function GetAllStudyTables(ByVal studyId As Integer) As Collection(Of StudyTable)
        Return DataProvider.Instance.SelectByStudyId(studyId)
    End Function

    ''' <summary>
    ''' Returns the selected table
    ''' </summary>
    ''' <param name="tableId">The table ID</param>
    Public Shared Function [Get](ByVal tableId As Integer) As StudyTable
        Return DataProvider.Instance.Select(tableId)
    End Function

#End Region

End Class
