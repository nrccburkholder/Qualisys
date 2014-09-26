Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a Cover Letter for a survey
''' </summary>
''' <remarks></remarks>
Public Class CoverLetter

#Region " Private Fields "
    Private mId As Integer
    Private mSurvey_Id As Integer
    Private mName As String
    Private mItems As List(Of CoverLetterItem)
#End Region

#Region " Public Properties "
    ''' <summary>The unique identifier of the Cover Letter</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property Survey_Id As Integer
        Get
            Return mSurvey_Id
        End Get
        Set(value As Integer)
            mSurvey_Id = value
        End Set
    End Property

    ''' <summary>The name of the Cover Letter</summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Friend Set(ByVal value As String)
            mName = value
        End Set
    End Property

    Public Property Items As List(Of CoverLetterItem)
        Get
            Return mItems
        End Get
        Set(value As List(Of CoverLetterItem))
            mItems = value
        End Set
    End Property
#End Region

#Region " Constructors "
    Friend Sub New()
    End Sub

    Public Sub New(ByVal id As Integer, ByVal name As String)

        mId = id
        mName = name

    End Sub

    Public Sub New(ByVal id As Integer, ByVal surveyid As Integer, ByVal name As String, ByVal items As List(Of CoverLetterItem))

        mId = id
        mSurvey_Id = surveyid
        mName = name
        mItems = items

    End Sub
#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "
    Public Shared Function GetBySurveyId(ByVal surveyId As Integer) As Collection(Of CoverLetter)
        Return CoverLetterProvider.Instance.SelectBySurveyId(surveyId)
    End Function

    Public Shared Function GetBySurveyIdAndPageType(ByVal surveyId As Integer, ByVal pagetype As Integer) As Collection(Of CoverLetter)
        Return CoverLetterProvider.Instance.SelectBySurveyIdAndPageType(surveyId, pagetype)
    End Function
#End Region

#End Region

End Class
