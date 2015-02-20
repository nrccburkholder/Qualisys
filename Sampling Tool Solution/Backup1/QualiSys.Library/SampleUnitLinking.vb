Imports Nrc.QualiSys.Library.DataProvider

Public Class SampleUnitLinking

#Region " Private Instance Fields "
    Private mFromStudyId As Integer
    Private mFromStudyName As String
    Private mFromSurveyId As Integer
    Private mFromSurveyName As String
    Private mFromSampleUnitId As Integer
    Private mFromSampleUnitName As String

    Private mToStudyId As Integer
    Private mToStudyName As String
    Private mToSurveyId As Integer
    Private mToSurveyName As String
    Private mToSampleUnitId As Integer
    Private mToSampleUnitName As String
#End Region

#Region " Public Properties "
    Public Property FromStudyId() As Integer
        Get
            Return mFromStudyId
        End Get
        Set(ByVal value As Integer)
            mFromStudyId = value
        End Set
    End Property
    Public Property FromStudyName() As String
        Get
            Return mFromStudyName
        End Get
        Set(ByVal value As String)
            mFromStudyName = value
        End Set
    End Property
    Public Property FromSurveyId() As Integer
        Get
            Return mFromSurveyId
        End Get
        Set(ByVal value As Integer)
            mFromSurveyId = value
        End Set
    End Property
    Public Property FromSurveyName() As String
        Get
            Return mFromSurveyName
        End Get
        Set(ByVal value As String)
            mFromSurveyName = value
        End Set
    End Property
    Public Property FromSampleUnitId() As Integer
        Get
            Return mFromSampleUnitId
        End Get
        Set(ByVal value As Integer)
            mFromSampleUnitId = value
        End Set
    End Property
    Public Property FromSampleUnitName() As String
        Get
            Return mFromSampleUnitName
        End Get
        Set(ByVal value As String)
            mFromSampleUnitName = value
        End Set
    End Property

    Public Property ToStudyId() As Integer
        Get
            Return mToStudyId
        End Get
        Set(ByVal value As Integer)
            mToStudyId = value
        End Set
    End Property
    Public Property ToStudyName() As String
        Get
            Return mToStudyName
        End Get
        Set(ByVal value As String)
            mToStudyName = value
        End Set
    End Property
    Public Property ToSurveyId() As Integer
        Get
            Return mToSurveyId
        End Get
        Set(ByVal value As Integer)
            mToSurveyId = value
        End Set
    End Property
    Public Property ToSurveyName() As String
        Get
            Return mToSurveyName
        End Get
        Set(ByVal value As String)
            mToSurveyName = value
        End Set
    End Property
    Public Property ToSampleUnitId() As Integer
        Get
            Return mToSampleUnitId
        End Get
        Set(ByVal value As Integer)
            mToSampleUnitId = value
        End Set
    End Property
    Public Property ToSampleUnitName() As String
        Get
            Return mToSampleUnitName
        End Get
        Set(ByVal value As String)
            mToSampleUnitName = value
        End Set
    End Property
#End Region

    ''' <summary>
    ''' Default constructor
    ''' </summary>
    Public Sub New()
    End Sub

#Region " DB CRUD Methods "
    Public Shared Function GetSampleUnitLinkingsByClientId(ByVal clientId As Integer) As SampleUnitLinkingCollection
        Return SampleUnitLinkingProvider.Instance.SelectByClientId(clientId)
    End Function
#End Region
End Class