Public Class QuestionGroup
#Region "private members"
    Private mName As String
    Private mDescription As String
    Private mID As Integer
    Private mNormID As Integer
    Private mQuestions As New QuestionsCollection
#End Region

#Region "Public Properties"
    Public Property Name() As String
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

    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property

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

    Public Property NormID() As Integer
        Get
            Return mNormID
        End Get
        Set(ByVal Value As Integer)
            mNormID = Value
        End Set
    End Property

#End Region

#Region "Public Methods"
    Public Shared Function GetAllQuestionGroups() As QuestionGroupCollection
        Dim QGroup As New QuestionGroupCollection
        Dim ds As DataSet = DataAccess.GetAllQuestionGroups

        For Each row As DataRow In ds.Tables(0).Rows
            QGroup.Add(GetQuestionGroup(row("QuestionGroup_ID")))
        Next
        Return QGroup
    End Function

    Public Shared Function GetQuestionGroup(ByVal QuestionGroupID As Integer) As QuestionGroup
        Dim QGroup As New QuestionGroup
        Dim ds As DataSet = DataAccess.GetQuestionGroup(QuestionGroupID)
        Dim dRow As DataRow

        dRow = ds.Tables(0).Rows(0)
        QGroup.mID = dRow("QuestionGroup_ID")
        QGroup.mName = dRow("strGroupName")
        QGroup.mDescription = dRow("Description")
        If Not dRow.IsNull("Norm_ID") Then QGroup.mNormID = dRow("Norm_ID")
        For Each row As DataRow In ds.Tables(1).Rows
            QGroup.mQuestions.Add(Question.getQuestionfromDataRow(row))
        Next
        Return QGroup
    End Function

    Public Shared Function UpdateQuestionGroup(ByVal QuestionGroupID As Integer, ByVal Name As String, ByVal Description As String, ByVal norm_id As Integer, ByVal questions As String()) As QuestionGroup
        Dim newQuestionGroup As QuestionGroup
        DataAccess.UpdateQuestionGroup(QuestionGroupID, Name, Description, norm_id)
        DataAccess.ClearQuestionGroupQuestions(QuestionGroupID)
        For Each qstn As String In questions
            DataAccess.InsertQuestionGroupQuestion(QuestionGroupID, qstn)
        Next
        newQuestionGroup = QuestionGroup.GetQuestionGroup(QuestionGroupID)
        Return newQuestionGroup
    End Function

    Public Shared Function CreateQuestionGroup(ByVal Name As String, ByVal Description As String, ByVal norm_id As Integer, ByVal member_id As Integer, ByVal questions As String()) As QuestionGroup
        Dim QGroupID As Integer
        Dim newQuestionGroup As QuestionGroup
        QGroupID = DataAccess.InsertQuestionGroup(Name, Description, norm_id, member_id)

        For Each qstn As String In questions
            DataAccess.InsertQuestionGroupQuestion(QGroupID, qstn)
        Next
        newQuestionGroup = QuestionGroup.GetQuestionGroup(QGroupID)
        Return newQuestionGroup
    End Function

    Public Shared Sub DeleteQuestionGroup(ByVal QuestionGroupID As Integer)
        DataAccess.DeleteQuestionGroup(QuestionGroupID)
    End Sub

    Public Shared Function CreateQuestionGroup(ByVal Name As String, ByVal Description As String, ByVal norm_id As Integer, ByVal member_id As Integer, ByVal questions As QuestionsCollection) As QuestionGroup
        Dim QGroupID As Integer
        Dim newQuestionGroup As QuestionGroup
        QGroupID = DataAccess.InsertQuestionGroup(Name, Description, norm_id, member_id)

        For Each qstn As Question In questions
            DataAccess.InsertQuestionGroupQuestion(QGroupID, qstn.Qstncore)
        Next
        newQuestionGroup = QuestionGroup.GetQuestionGroup(QGroupID)
        Return newQuestionGroup
    End Function
#End Region

End Class
