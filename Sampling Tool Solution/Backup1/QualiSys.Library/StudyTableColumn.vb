Imports Nrc.QualiSys.Library.DataProvider

Public Class StudyTableColumn

#Region " Private Members "

    Private mId As Integer
    Private mTableId As Integer
    Private mName As String
    Private mDescription As String
    Private mDataType As StudyTableColumnDataTypes
    Private mIsKey As Boolean
    Private mLength As Integer
    Private mIsUserField As Boolean
    Private mIsMatchField As Boolean
    Private mIsPosted As Boolean

#End Region

#Region " Public Properties "

    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property TableId() As Integer
        Get
            Return mTableId
        End Get
        Set(ByVal value As Integer)
            mTableId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            mDescription = value
        End Set
    End Property

    Public Property DataType() As StudyTableColumnDataTypes
        Get
            Return mDataType
        End Get
        Set(ByVal value As StudyTableColumnDataTypes)
            mDataType = value
        End Set
    End Property

    Public Property IsKey() As Boolean
        Get
            Return mIsKey
        End Get
        Set(ByVal value As Boolean)
            mIsKey = value
        End Set
    End Property

    Public Property Length() As Integer
        Get
            Return mLength
        End Get
        Set(ByVal value As Integer)
            mLength = value
        End Set
    End Property

    Public Property IsUserField() As Boolean
        Get
            Return mIsUserField
        End Get
        Set(ByVal value As Boolean)
            mIsUserField = value
        End Set
    End Property

    Public Property IsMatchField() As Boolean
        Get
            Return mIsMatchField
        End Get
        Set(ByVal value As Boolean)
            mIsMatchField = value
        End Set
    End Property

    Public Property IsPosted() As Boolean
        Get
            Return mIsPosted
        End Get
        Set(ByVal value As Boolean)
            mIsPosted = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Function ToString() As String

        Return mName

    End Function

#End Region

#Region " DB CRUD Methods "

    Public Shared Function GetStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)

        Return StudyTableProvider.Instance.SelectStudyTableColumns(studyId, tableId)

    End Function

    Public Shared Function [Get](ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn

        Return StudyTableProvider.Instance.SelectStudyTableColumn(tableId, fieldId)

    End Function

    Public Shared Function GetHouseHoldingColumnsBySurveyId(ByVal surveyId As Integer) As StudyTableColumnCollection

        Return StudyTableProvider.Instance.SelectHouseHoldingFieldsBySurveyId(surveyId)

    End Function

#End Region

End Class
