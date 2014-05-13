Public Class Question

#Region "Private Members"
    Private mQstncore As Integer
    Private mLabel As String
    Private mSurveyType As New SurveyType

#End Region

#Region "public properties"
    Public Property Qstncore() As Integer
        Get
            Return mQstncore
        End Get
        Set(ByVal Value As Integer)
            mQstncore = Value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mLabel
        End Get
        Set(ByVal Value As String)
            mLabel = Value
        End Set
    End Property

    Public Property Survey() As SurveyType
        Get
            Return mSurveyType
        End Get
        Set(ByVal Value As SurveyType)
            mSurveyType = Value
        End Set
    End Property
#End Region

#Region "Public Methods"

    Public Shared Function getQuestion(ByVal qstncore As Integer) As Question
        Dim row As DataRow = DataAccess.GetSingleQuestion(qstncore)
        Return getQuestionfromDataRow(row)
    End Function

    Public Shared Function getQuestionfromDataRow(ByVal row As DataRow) As Question
        Dim Qstn As New Question

        Qstn.mQstncore = row("Qstncore")
        Qstn.mLabel = row("Label")
        If Not row.IsNull("SurveyType_ID") Then
            Qstn.mSurveyType = SurveyType.getSurveyType(CInt(row("SurveyType_ID")))
        End If

        Return Qstn

    End Function

#End Region

End Class
