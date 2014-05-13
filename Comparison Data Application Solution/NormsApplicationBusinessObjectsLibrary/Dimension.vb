Public Class Dimension
#Region "private Members"
    Private mID As Integer
    Private mQuestions As New QuestionsCollection
    Private mName As String
    Private mDescription As String
    Private mSurveyType As New SurveyType

#End Region

#Region "Public Properties"
    Public ReadOnly Property Questions() As QuestionsCollection
        Get
            Return mQuestions
        End Get
    End Property

    Public ReadOnly Property QuestionsList() As String
        Get
            Dim questionList As String = ""
            For Each qstncore As Question In mQuestions
                questionList += "," + qstncore.Qstncore.ToString
            Next
            Return questionList.Substring(1)
        End Get
    End Property

    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return mID.ToString + " - " + mName
        End Get
    End Property

    Public Property ShortName() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            mName = Value
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal Value As String)
            mDescription = Value
        End Set
    End Property

    Public Property SvyType() As SurveyType
        Get
            Return mSurveyType
        End Get
        Set(ByVal Value As SurveyType)
            mSurveyType = Value
        End Set
    End Property

#End Region

#Region "Public Methods"

    Public Shared Function GetDimension(ByVal DimensionID As Integer) As Dimension
        Dim Dimen As New Dimension
        Dim ds As DataSet = DataAccess.GetSingleDimensions(DimensionID)
        Dim dRow As DataRow

        dRow = ds.Tables(0).Rows(0)
        Dimen.mID = dRow("Dimension_ID")
        Dimen.mName = dRow("strDimension_nm")
        Dimen.mDescription = dRow("Description")
        Dimen.mSurveyType = SurveyType.getSurveyType(dRow("SurveyType_ID"))
        For Each row As DataRow In ds.Tables(1).Rows
            Dimen.mQuestions.Add(Question.getQuestionfromDataRow(row))
        Next
        Return Dimen
    End Function

    Public Sub addQuestion(ByVal pQuestion As Question)
        mQuestions.Add(pQuestion)
    End Sub

    Public Sub removeQuestion(ByVal pQuestion As Question)
        mQuestions.Remove(pQuestion)
    End Sub

    Public Shared Function UpdateDimension(ByVal DimensionID As Integer, ByVal Name As String, ByVal Description As String, ByVal surveytype_id As Integer, ByVal questions As String()) As Dimension
        Dim newDimension As Dimension
        DataAccess.UpdateDimension(DimensionID, Name, Description, surveytype_id)
        DataAccess.ClearDimensionQuestions(DimensionID)
        For Each qstn As String In questions
            DataAccess.InsertDimensionQuestion(DimensionID, qstn)
        Next
        newDimension = Dimension.GetDimension(DimensionID)
        Return newDimension
    End Function

    Public Shared Function CreateDimension(ByVal Name As String, ByVal Description As String, ByVal surveytype_id As Integer, ByVal member_id As Integer, ByVal questions As String(), ByVal isStandard As Boolean) As Dimension
        Dim DimID As Integer
        Dim newDimension As Dimension
        DimID = DataAccess.InsertDimension(Name, Description, surveytype_id, member_id, isStandard)

        For Each qstn As String In questions
            DataAccess.InsertDimensionQuestion(DimID, qstn)
        Next
        newDimension = Dimension.GetDimension(DimID)
        Return newDimension
    End Function

    Public Shared Sub DeleteDimension(ByVal DimensionID As Integer)
        DataAccess.DeleteDimension(DimensionID)
    End Sub

    Public Shared Function CreateDimension(ByVal Name As String, ByVal Description As String, ByVal surveytype_id As Integer, ByVal member_id As Integer, ByVal questions As QuestionsCollection, ByVal isStandard As Boolean) As Dimension
        Dim DimID As Integer
        Dim newDimension As Dimension
        DimID = DataAccess.InsertDimension(Name, Description, surveytype_id, member_id, isStandard)

        For Each qstn As Question In questions
            DataAccess.InsertDimensionQuestion(DimID, qstn.Qstncore)
        Next
        newDimension = Dimension.GetDimension(DimID)
        Return newDimension
    End Function

#End Region

End Class
