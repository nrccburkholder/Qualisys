Imports Nrc.QualiSys.Library.DataProvider
Public Interface ISection
    Property SelQstnsId() As Integer
    Property SurveyId() As Integer
    Property Id() As Integer
    Property Label() As String
End Interface

Public Class QuestionSection
    Implements ISection

#Region "Private Members"
    Private mSelQstnsId As Integer
    Private mSurveyId As Integer
    Private mId As Integer
    Private mLabel As String = String.Empty
#End Region

#Region "Public Properties"
    Public Property SelQstnsId() As Integer Implements ISection.SelQstnsId
        Get
            Return mSelQstnsId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mSelQstnsId Then
                mSelQstnsId = value
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer Implements ISection.SurveyId
        Get
            Return mSurveyId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
            End If
        End Set
    End Property

    Public Property Id() As Integer Implements ISection.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
            End If
        End Set
    End Property

    Public Property Label() As String Implements ISection.Label
        Get
            Return mLabel
        End Get
        Private Set(ByVal value As String)
            If Not value = mLabel Then
                mLabel = value
            End If
        End Set
    End Property
#End Region

#Region "DB CRUD Methods"
    Public Shared Function [GetBySurveyId](ByVal surveyId As Integer) As Collection(Of QuestionSection)
        Return QuestionSectionProvider.Instance.SelectSectionsBySurveyId(surveyId)
    End Function
#End Region
End Class

