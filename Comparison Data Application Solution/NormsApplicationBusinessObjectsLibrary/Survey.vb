Public Class Survey

#Region "Private Members"
    Private mID As Integer
    Private mName As String
    Private mCountry As Country

#End Region

#Region "Public Properties"
    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            mName = Value
        End Set
    End Property

    Public Property CountryOfOrigin() As Country
        Get
            Return mCountry
        End Get
        Set(ByVal Value As Country)
            mCountry = Value
            DataAccess.updateSurveyCountry(mID, mCountry.ID)
        End Set
    End Property
#End Region

#Region "Public Methods"

    Public Shared Function getClientSurveys(ByVal ClientID As Integer) As SurveysCollection
        Dim ds As DataSet = DataAccess.GetClientSurveys(ClientID)
        Dim SurveysList As New SurveysCollection
        For Each row As DataRow In ds.Tables(0).Rows
            SurveysList.Add(getSurveyfromDataRow(row))
        Next
        Return SurveysList
    End Function

    Public Shared Function getSurveyfromDataRow(ByVal row As DataRow) As Survey
        Dim Survey As New Survey
        Survey.mName = row("strsurvey_nm")
        Survey.mID = row("survey_id")
        Survey.mCountry = Country.getCountryfromDataRow(row)
        Return Survey
    End Function
#End Region

End Class
