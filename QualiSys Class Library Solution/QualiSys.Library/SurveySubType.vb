Public Class SurveySubType

#Region "private fields"
    Private mSurveySubType_Id As Integer
    Private mSurveyType_Id As Integer
    Private mDescription As String = String.Empty
    Private mQuestionaireType_Id As Integer
#End Region

#Region "public properties"

    Public Property Id() As Integer
        Get
            Return mSurveySubType_Id
        End Get
        Private Set(ByVal value As Integer)
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
        Private Set(ByVal value As Integer)
            If Not value = mSurveyType_Id Then
                mSurveyType_Id = value
            End If
        End Set
    End Property

    Public Property QuestionaireId() As Integer
        Get
            Return mQuestionaireType_Id
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mQuestionaireType_Id Then
                mQuestionaireType_Id = value
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()


    End Sub


    Public Sub New(ByVal Id As Integer, ByVal Desc As String, ByVal QuestionaireID As Integer)

        mSurveySubType_Id = Id
        mDescription = Desc
        mQuestionaireType_Id = QuestionaireID

    End Sub

    Public Sub New(ByVal Id As Integer, ByVal SurveyID As Integer, ByVal Desc As String, ByVal QuestionaireID As Integer)

        mSurveySubType_Id = Id
        mDescription = Desc
        mQuestionaireType_Id = QuestionaireID
        mSurveyType_Id = SurveyID

    End Sub

#End Region


End Class
