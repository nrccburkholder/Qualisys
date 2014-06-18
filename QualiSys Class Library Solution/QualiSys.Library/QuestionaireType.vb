Public Class QuestionaireType

    Private mQuestionaireType_Id As Integer
    Private mDescription As String = String.Empty


#Region "public properties"

    Public Property Id() As Integer
        Get
            Return mQuestionaireType_Id
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mQuestionaireType_Id Then
                mQuestionaireType_Id = value
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

#End Region


#Region " Constructors "

    Public Sub New()


    End Sub


    Public Sub New(ByVal Id As Integer, ByVal Desc As String)

        mQuestionaireType_Id = Id
        mDescription = Desc

    End Sub

#End Region


End Class
