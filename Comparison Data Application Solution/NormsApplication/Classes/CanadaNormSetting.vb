Option Explicit On 
Option Strict On

Imports System.Text
Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary
Imports NRC.Data

Public Class CanadaNormSetting

#Region " Private Fields"

    Public Const MIN_UNIT_IN_BENCHMARK_NORM As Integer = 1
    Public Const MAX_UNIT_IN_BENCHMARK_NORM As Integer = 5

    Private mTask As TaskType
    Private mNormID As Integer
    Private mNormLabel As String
    Private mNormDescription As String
	Private mCriteriaStmt As String
    Private mWeightingType As WeightingType = WeightingType.NoWeighting
    Private mReportDateBegin As Date = Date.Today.AddDays(-1)
    Private mReportDateEnd As Date = Date.Today.AddDays(-1)
    Private mReturnDateMax As Date = Date.Today.AddDays(-1)
    Private mSettingChanged As Boolean = False
    Private mClientIDs() As Integer
    Private mClientSelectionChanged As Boolean = False
    Private mSurveyIDs() As Integer
    Private mRollupIDs() As Integer

#End Region

#Region " Public Properties"

    Public Property Task() As TaskType
        Get
            Return Me.mTask
        End Get
        Set(ByVal Value As TaskType)
            mTask = Value
        End Set
    End Property

    Public Property NormID() As Integer
        Get
            Return mNormID
        End Get
        Set(ByVal Value As Integer)
            mNormID = Value
        End Set
    End Property

    Public Property NormLabel() As String
        Get
            Return mNormLabel
        End Get
        Set(ByVal Value As String)
            Value = Value.Trim
            If (mNormLabel <> Value) Then mSettingChanged = True
            mNormLabel = Value
        End Set
    End Property

    Public Property NormDescription() As String
        Get
            Return mNormDescription
        End Get
        Set(ByVal Value As String)
            Value = Value.Trim
            If (mNormDescription <> Value) Then mSettingChanged = True
            mNormDescription = Value
        End Set
    End Property

    Public Property CriteriaStmt() As String
        Get
            Return mCriteriaStmt
        End Get
        Set(ByVal Value As String)
            mCriteriaStmt = Value
        End Set
    End Property

    Public Property WeightingType() As WeightingType
        Get
            Return mWeightingType
        End Get
        Set(ByVal Value As WeightingType)
            If (mWeightingType <> Value) Then mSettingChanged = True
            mWeightingType = Value
        End Set
    End Property

    Public Property Weighted() As Boolean
        Get
            If (mWeightingType = WeightingType.CanadaSurveyWeighting) Then
                Return True
            Else
                Return False
            End If
        End Get
        Set(ByVal Value As Boolean)
            If (Value) Then
                WeightingType = WeightingType.CanadaSurveyWeighting
            Else
                WeightingType = WeightingType.NoWeighting
            End If
        End Set
    End Property

    Public Property ReportDateBegin() As Date
        Get
            Return mReportDateBegin
        End Get
        Set(ByVal Value As Date)
            If (mReportDateBegin <> Value) Then mSettingChanged = True
            mReportDateBegin = Value
        End Set
    End Property

    Public Property ReportDateEnd() As Date
        Get
            Return mReportDateEnd
        End Get
        Set(ByVal Value As Date)
            If (mReportDateEnd <> Value) Then mSettingChanged = True
            mReportDateEnd = Value
        End Set
    End Property

    Public Property ReturnDateMax() As Date
        Get
            Return mReturnDateMax
        End Get
        Set(ByVal Value As Date)
            If (mReturnDateMax <> Value) Then mSettingChanged = True
            mReturnDateMax = Value
        End Set
    End Property

    Public ReadOnly Property SettingChanged() As Boolean
        Get
            Return mSettingChanged
        End Get
    End Property

    Public Property ClientIDs() As Integer()
        Get
            Return mClientIDs
        End Get
        Set(ByVal Value As Integer())
            'Check client selection changed or not
            Array.Sort(Value)
            mClientSelectionChanged = False
            If (mClientIDs Is Nothing OrElse mClientIDs.Length <> Value.Length) Then
                mClientSelectionChanged = True
            Else
                Dim i As Integer
                For i = 0 To mClientIDs.Length - 1
                    If (mClientIDs(i) <> Value(i)) Then
                        mClientSelectionChanged = True
                        Exit For
                    End If
                Next
            End If

            'Save client selection
            mClientIDs = Value
        End Set
    End Property

    Public ReadOnly Property ClientSelectionChanged() As Boolean
        Get
            Return mClientSelectionChanged
        End Get
    End Property

    Public Property SurveyIDs() As Integer()
        Get
            Return mSurveyIDs
        End Get
        Set(ByVal Value As Integer())
            mSurveyIDs = Value
        End Set
    End Property

    Public Property RollupIDs() As Integer()
        Get
            Return mRollupIDs
        End Get
        Set(ByVal Value As Integer())
            mRollupIDs = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Sub Load()
        If (Me.mNormID <= 0) Then Return
        LoadNormGeneralSettings()
        LoadNormSurvey()
        LoadNormRollup()
    End Sub

    Private Sub LoadNormGeneralSettings()
        Dim rdr As New SafeDataReader(DataAccess.LoadNormSettings(mNormID))
        If (rdr.Read) Then
            mNormLabel = rdr.GetString("NormLabel")
            mNormDescription = rdr.GetString("NormDescription")
            mCriteriaStmt = rdr.GetString("CriteriaStmt")
            mWeightingType = CType(rdr("WeightingType"), WeightingType)
            mReportDateBegin = rdr.GetDate("ReportDateBegin")
            mReportDateEnd = rdr.GetDate("ReportDateEnd")
            mReturnDateMax = rdr.GetDate("ReturnDateMax")
        End If
        If (Not rdr Is Nothing) Then rdr.Close()
    End Sub

    Private Sub LoadNormSurvey()
        Dim rdr As SqlDataReader = DataAccess.SelectCanadaNormSurvey(mNormID)
        Dim array As New ArrayList
        Dim surveyID As Integer

        Do While rdr.Read
            surveyID = CInt(rdr("Survey_ID"))
            array.Add(surveyID)
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()
        If (array.Count > 0) Then
            Me.mSurveyIDs = CType(array.ToArray(GetType(Integer)), Integer())
        Else
            Me.mSurveyIDs = Nothing
        End If
    End Sub

    Private Sub LoadNormRollup()
        Dim rdr As SqlDataReader = DataAccess.SelectCanadaNormRollup(mNormID)
        Dim array As New ArrayList
        Dim rollupID As Integer

        Do While rdr.Read
            rollupID = CInt(rdr("Rollup_ID"))
            array.Add(rollupID)
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()
        If (array.Count > 0) Then
            Me.mRollupIDs = CType(array.ToArray(GetType(Integer)), Integer())
        Else
            Me.mRollupIDs = Nothing
        End If
    End Sub

    Public Sub ConcatedSurveyList(ByVal surveyList() As StringBuilder)
        Dim i As Integer
        Dim j As Integer

        'Clear
        For j = 0 To surveyList.Length - 1
            If (surveyList(j) Is Nothing) Then
                surveyList(j) = New StringBuilder
            Else
                surveyList(j).Remove(0, surveyList(j).Length)
            End If
        Next

        'No survey
        If (Me.SurveyIDs.Length = 0) Then Return

        'Concate surveys
        j = 0
        For i = 0 To Me.SurveyIDs.Length - 1
            If (surveyList(j).Length > 7990) Then j += 1
            surveyList(j).Append(SurveyIDs(i))
            surveyList(j).Append(",")
        Next

        'Remove the last ","
        surveyList(j).Remove(surveyList(j).Length - 1, 1)
    End Sub


    Public Sub ConcatedRollupList(ByVal rollupList() As StringBuilder)
        Dim i As Integer
        Dim j As Integer

        'Clear
        For j = 0 To rollupList.Length - 1
            If (rollupList(i) Is Nothing) Then
                rollupList(i) = New StringBuilder
            Else
                rollupList(i).Remove(0, rollupList(i).Length)
            End If
        Next

        'No rollup
        If (Me.RollupIDs Is Nothing) Then Return

        'Concate rollups
        j = 0
        For i = 0 To Me.RollupIDs.Length - 1
            If (rollupList(j).Length > 7990) Then j += 1
            rollupList(j).Append(RollupIDs(i))
            rollupList(j).Append(",")
        Next

        'Remove the last ","
        rollupList(j).Remove(rollupList(j).Length - 1, 1)
    End Sub

    Public Function IsCriteriaCorrect(ByVal criteriaStmt As String, ByRef errMsg As String) As Boolean
        criteriaStmt = criteriaStmt.Trim
        If (criteriaStmt = "") Then Return True

        Dim surveyList(4) As StringBuilder
        ConcatedSurveyList(surveyList)

        Try
            DataAccess.CheckCanadaCriteria(criteriaStmt, surveyList)
            Return True
        Catch ex As Exception
            errMsg = "Criteria statement error:" + vbCrLf + ex.Message
            Return False
        End Try
    End Function

    Public Function SelectTableColumn() As SafeDataReader
        Dim surveyList(4) As StringBuilder
        ConcatedSurveyList(surveyList)

        Return New SafeDataReader(DataAccess.SelectCanadaTableColumn(surveyList))
    End Function

#End Region

End Class
