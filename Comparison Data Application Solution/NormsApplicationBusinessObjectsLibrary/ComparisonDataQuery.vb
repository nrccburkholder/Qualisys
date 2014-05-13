Imports NormsApplicationBusinessObjectsLibrary
'Imports NRC.NRCAuthLib

Public Class ComparisonDataQuery

    Public Enum enuReportType
        DemographicCounts = 1
        QuestionCounts = 2
        QuestionUsers = 3
        Frequencies = 4
        AverageScores = 5
        GroupRanksAndScores = 6
        Percentiles1to100 = 7
    End Enum

    Private mReportType As enuReportType
    Private mLabel As String = ""
    Private mDescription As String = ""
    Private mCriteria As String = ""
    Private mMinDate As Date
    Private mMaxDate As Date
    Private mGroupingType As New Groupings
    Private mIncludeCustomQuestions As Boolean
    Private mUseFacilites As Boolean
    Private mID As Integer
    Private mDimensionList As String = ""
    Private mQuestionList As String = ""
    Private mIsSelectable As Boolean
    Private mMemberID As Integer
    Private mDateCreated As Date
    Private mNeedsSave As Boolean
    'The parentReportID is the most recently saved version of the report.  We need to 
    'keep track of it so we can set the Selectable property to false on it if the user
    'decides to save a report that is derived from it. This is necessary because only 1 
    'report in a chain can be Selectable.
	Private mParentReportID As Integer

    Public Sub New()
    End Sub

    Public Sub New(ByVal reportTypeID As enuReportType)
        mReportType = reportTypeID
    End Sub

#Region "Public Properties"
    Public Property NeedsSave() As Boolean
        Get
            Return mNeedsSave
        End Get
        Set(ByVal Value As Boolean)
            mNeedsSave = Value
        End Set
    End Property

    Public Property ParentReportID() As Integer
        Get
            Return mParentReportID
        End Get
        Set(ByVal Value As Integer)
            mParentReportID = Value
        End Set
    End Property


    Public Property Label() As String
        Get
            Return mLabel
        End Get
        Set(ByVal Value As String)
            If mLabel <> Value Then
                mNeedsSave = True
                mLabel = Value
            End If
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal Value As String)
            If mDescription <> Value Then
                mNeedsSave = True
                mDescription = Value
            End If
        End Set
    End Property

    Public Property MemberID() As Integer
        Get
            Return mMemberID
        End Get
        Set(ByVal Value As Integer)
            If mMemberID <> Value Then
                mNeedsSave = True
                mMemberID = Value
            End If
        End Set
    End Property

    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal Value As Date)
            mDateCreated = Value
        End Set
    End Property

    Public ReadOnly Property ReportType() As enuReportType
        Get
            Return mReportType
        End Get
    End Property

    Public Property Criteria() As String
        Get
            Return mCriteria
        End Get
        Set(ByVal Value As String)
            If mCriteria <> Value Then
                mNeedsSave = True
                mCriteria = Value
            End If
        End Set
    End Property

    Public Property MinDate() As Date
        Get
            Return mMinDate
        End Get
        Set(ByVal Value As Date)
            If mMinDate <> Value Then
                mNeedsSave = True
                mMinDate = Value
            End If
        End Set
    End Property

    Public Property MaxDate() As Date
        Get
            Return mMaxDate
        End Get
        Set(ByVal Value As Date)
            If mMaxDate <> Value Then
                mNeedsSave = True
                mMaxDate = Value
            End If
        End Set
    End Property

    Public Property GroupingType() As Groupings
        Get
            Return mGroupingType
        End Get
        Set(ByVal Value As Groupings)
            If mGroupingType.GroupingID <> Value.GroupingID Then
                mNeedsSave = True
                mGroupingType = Value
            End If
        End Set
    End Property

    Public Property IncludeCustomQuestions() As Boolean
        Get
            Return mIncludeCustomQuestions
        End Get
        Set(ByVal Value As Boolean)
            If mIncludeCustomQuestions <> Value Then
                mNeedsSave = True
                mIncludeCustomQuestions = Value
            End If
        End Set
    End Property

    Public Property UseFacilites() As Boolean
        Get
            Return mUseFacilites
        End Get
        Set(ByVal Value As Boolean)
            If mUseFacilites <> Value Then
                mNeedsSave = True
                mUseFacilites = Value
            End If
        End Set
    End Property

    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property

    Public Property DimensionList() As String
        Get
            Return mDimensionList
        End Get
        Set(ByVal Value As String)
            If mDimensionList <> Value Then
                mNeedsSave = True
                mDimensionList = Value
            End If
        End Set
    End Property

    Public Property QuestionList() As String
        Get
            Return mQuestionList
        End Get
        Set(ByVal Value As String)
            If mQuestionList <> Value Then
                mNeedsSave = True
                mQuestionList = Value
            End If
        End Set
    End Property

    Public Property IsSelectable() As Boolean
        Get
            Return mIsSelectable
        End Get
        Set(ByVal Value As Boolean)
            If mIsSelectable <> Value Then
                mNeedsSave = True
                mIsSelectable = Value
            End If
        End Set
    End Property

#End Region

#Region "Public Methods"
    Public Sub UpdateSaving(ByVal newID As Integer)
        mID = newID
        mParentReportID = newID
        mNeedsSave = False
        mIsSelectable = True
    End Sub

    Public Shared Function GetSavedQuery(ByVal id As Integer) As ComparisonDataQuery
        Dim ds As DataSet
        ds = DataAccess.getComparisonDataQuery(id)
        Return getQueryFromRow(ds.Tables(0).Rows(0))
    End Function

    Public Shared Function getQueryFromRow(ByVal dr As DataRow) As ComparisonDataQuery
        Dim NewQuery As New ComparisonDataQuery
        Dim allGroups As GroupingsCollection = DataAccess.GetMeasures()
        With dr
            NewQuery.mID = .Item("NormReport_ID")
            NewQuery.mParentReportID = .Item("NormReport_ID")
            If Not .IsNull("NormReportLabel") Then NewQuery.mLabel = .Item("NormReportLabel")
            If Not .IsNull("Description") Then NewQuery.mDescription = .Item("Description")
            NewQuery.mReportType = .Item("ReportType_ID")
            NewQuery.mIsSelectable = .Item("IsSelectable")
            NewQuery.mMemberID = .Item("CreatorMember_ID")
            NewQuery.mDateCreated = .Item("DateCreated")
            If Not .IsNull("Criteria") Then NewQuery.mCriteria = .Item("Criteria")
            NewQuery.mMinDate = .Item("MinDate")
            NewQuery.mMaxDate = .Item("MaxDate")
            If NewQuery.mReportType <> enuReportType.DemographicCounts Then
                If Not .IsNull("QuestionList") Then NewQuery.mQuestionList = .Item("QuestionList")
                NewQuery.mIncludeCustomQuestions = .Item("bitMinimumClientCheck")
            End If
            Select Case NewQuery.mReportType
                Case enuReportType.Frequencies
                    If Not .IsNull("DimensionList") Then NewQuery.mDimensionList = .Item("DimensionList")
                Case enuReportType.AverageScores, enuReportType.GroupRanksAndScores, enuReportType.Percentiles1to100
                    If Not .IsNull("DimensionList") Then NewQuery.mDimensionList = .Item("DimensionList")
                    Dim groupingID As Integer
                    groupingID = .Item("GroupingType")
                    For Each group As Groupings In allGroups
                        If groupingID = group.GroupingID Then
                            NewQuery.mGroupingType = group
                            Exit For
                        End If
                    Next
            End Select
        End With
        Return NewQuery
    End Function

    Public Shared Function Insert(ByVal reportTypeID As enuReportType, ByVal label As String, ByVal description As String, ByVal IsSelectable As Boolean, ByVal memberID As Integer, ByVal Params As ParametersCollection) As Integer
        Dim newID As Integer
        newID = DataAccess.InsertComparisonDataQuery(reportTypeID, label, description, IsSelectable, memberID, Params)
        Return newID
    End Function

    Public Shared Function Update(ByVal reportTypeID As enuReportType, ByVal label As String, ByVal description As String, ByVal memberID As Integer, ByVal Params As ParametersCollection, ByVal replaceID As Integer) As Integer
        Dim newID As Integer
        SetUnSelectable(replaceID, memberID)
        newID = DataAccess.InsertComparisonDataQuery(reportTypeID, label, description, True, memberID, Params)
        Return newID
    End Function

    Public Shared Sub SetUnSelectable(ByVal id As Integer, ByVal memberID As Integer)
        DataAccess.DeleteComparisonDataQuery(id, memberID)
    End Sub

    Public Shared Sub LogSubmittedReport(ByVal ID As Integer, ByVal MemberID As Integer)
        DataAccess.LogNormReport(ID, MemberID)
    End Sub
#End Region
End Class

Public Structure ComparisonDataQueryLight
    Public ID As Integer
    Public Label As String
    Public Description As String
    Public WhoCreated As String
    Public WhenCreated As Date
End Structure
