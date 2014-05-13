Imports NormsApplicationBusinessObjectsLibrary
Public Class SurveyType

#Region "Private members"
    Private mName As String
    Private mID As Integer
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

    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property
#End Region

#Region "Public Methods"

    Public Shared Function getSurveyType(ByVal surveyTypeID As Integer) As SurveyType
        Dim row As DataRow = DataAccess.GetSingleSurveyType(surveyTypeID)
        Return getSurveyTypefromDataRow(row)
    End Function

    Public Shared Function getSurveyTypefromDataRow(ByVal row As DataRow) As SurveyType
        Dim Survey As New SurveyType
        Survey.mName = row("surveytype_nm")
        Survey.mID = row("surveytype_id")
        Return Survey
    End Function

    Public Shared Function CreateSurveyType(ByVal Name As String) As SurveyType
        Dim Survey As New SurveyType
        Survey.mName = Name
        Survey.mID = DataAccess.InsertSurveyType(Name)
        Return Survey
    End Function

    Public Shared Sub UpdateSurveyType(ByVal SurveyTypeID As Integer, ByVal Name As String)
        DataAccess.UpdateSurveyType(SurveyTypeID, Name)
    End Sub

    Public Shared Sub UpdateSurveyTypeQuestions(ByVal Survey As SurveyType, ByVal questions As String())
        DataAccess.ClearSurveyQuestions(Survey.ID)
        For Each qstn As String In questions
            DataAccess.InsertSurveyQuestion(Survey.ID, qstn)
        Next
    End Sub

    Public Shared Sub DeleteSurveyType(ByVal SurveyTypeID As Integer)
        DataAccess.DeleteSurveyType(SurveyTypeID)
    End Sub
#End Region

End Class
