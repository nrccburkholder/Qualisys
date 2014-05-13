Imports NormsApplicationBusinessObjectsLibrary
Public Class Country

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

    Public Shared Function getAllCountries() As CountryCollection
        Dim Countries As New CountryCollection
        Dim ds As DataSet = DataAccess.GetCountries()
        For Each row As DataRow In ds.Tables(0).Rows
            Countries.Add(getCountryfromDataRow(row))
        Next
        Return Countries
    End Function

    Public Shared Function getCountryfromDataRow(ByVal row As DataRow) As Country
        Dim Survey As New Country
        Survey.mName = row("strCountry_nm")
        Survey.mID = row("Country_id")
        Return Survey
    End Function

    Public Shared Function CreateCountry(ByVal Name As String) As Country
        Dim Survey As New Country
        Survey.mName = Name
        Survey.mID = DataAccess.InsertCountry(Name)
        Return Survey
    End Function

    Public Shared Sub UpdateCountry(ByVal CountryID As Integer, ByVal Name As String)
        DataAccess.UpdateCountry(CountryID, Name)
    End Sub

    Public Shared Sub DeleteCountry(ByVal CountryID As Integer)
        DataAccess.DeleteCountry(CountryID)
    End Sub
#End Region

End Class
