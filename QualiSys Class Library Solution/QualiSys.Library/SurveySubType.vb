Public Class SurveySubType

#Region "private fields"
    Private mSurveySubType_Id As Integer
    Private mSurveyType_Id As Integer
    Private mDescription As String = String.Empty
    Private mQuestionnaireType_Id As Integer
#End Region

#Region "public properties"

    Public Property Id() As Integer
        Get
            Return mSurveySubType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveySubType_Id Then
                mSurveySubType_Id = value
            End If
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
            End If
        End Set
    End Property

    Public Property SurveyTypeId() As Integer
        Get
            Return mSurveyType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyType_Id Then
                mSurveyType_Id = value
            End If
        End Set
    End Property

    Public Property QuestionnaireId() As Integer
        Get
            Return mQuestionnaireType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuestionnaireType_Id Then
                mQuestionnaireType_Id = value
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()


    End Sub


    Public Sub New(ByVal Id As Integer, ByVal Desc As String, ByVal QuestionnaireID As Integer)

        mSurveySubType_Id = Id
        mDescription = Desc
        mQuestionnaireType_Id = QuestionnaireID

    End Sub

    Public Sub New(ByVal Id As Integer, ByVal SurveyID As Integer, ByVal Desc As String, ByVal QuestionnaireID As Integer)

        mSurveySubType_Id = Id
        mDescription = Desc
        mQuestionnaireType_Id = QuestionnaireID
        mSurveyType_Id = SurveyID

    End Sub

#End Region


End Class
